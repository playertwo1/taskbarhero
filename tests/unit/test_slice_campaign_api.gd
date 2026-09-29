extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE CAMPAIGN API (SLICE-1B Plano B) ---")
	_test_presets()
	_test_in_memory()
	_test_auto_equip()
	_test_extra_options()
	print("=======================================================")
	print("[%s] TESTE SLICE CAMPAIGN API" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _test_presets() -> void:
	print("\n>>> 1. PRESETS")
	_expect("4 presets com nome e trio", SliceSession.BUILD_PRESETS.size() == 4 and SliceSession.BUILD_PRESETS.all(func(p): return p.has("name") and p["heroes"].size() == 3))

func _test_in_memory() -> void:
	print("\n>>> 2. EM MEMÓRIA")
	var c := SliceCampaign.in_memory()
	_expect("não grava em disco", c.save_blocked and c.save_error == "memory")
	var uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 5, 1))
	_expect("equipar funciona sem arquivo", c.equip("hero_001", uid) == "")

func _test_auto_equip() -> void:
	print("\n>>> 3. AUTO EQUIPAR")
	var c := SliceCampaign.in_memory()
	var weak := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 30, 5))
	var strong := c.inventory.add_item(LootRoller.make_instance("item_w_003", "Raro", 5, 5))
	var armor_a := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 10, 5))
	var armor_b := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 20, 5))
	var shared_lo := c.inventory.add_item(LootRoller.make_instance("item_s_003", "Raro", 8, 5))
	c.auto_equip(["hero_001", "hero_002", "hero_003"])
	var b1: Array = c.inventory.equipped["hero_001"]
	_expect("maior raridade vence o IP maior (Raro em vez de Comum)", b1.has(strong) and not b1.has(weak))
	_expect("mesma raridade: maior IP", b1.has(armor_b) and not b1.has(armor_a))
	_expect("secundário compartilhado vai para um herói só", [c.inventory.equipped.get("hero_001", []), c.inventory.equipped.get("hero_002", []), c.inventory.equipped.get("hero_003", [])].filter(func(l): return l.has(shared_lo)).size() == 1)
	c.inventory.locked = true
	var before := c.inventory.equipped.duplicate(true)
	c.auto_equip(["hero_001"])
	_expect("travado não muda nada", c.inventory.equipped == before)

func _test_extra_options() -> void:
	print("\n>>> 4. OPÇÕES EXTRAS")
	var c := SliceCampaign.in_memory()
	c.data["party"]["level"] = 12
	var build: Dictionary = SliceSession.BUILD_PRESETS[2]["heroes"]
	var run := c.start_expedition(build, 5, {"crits": false})
	_expect("expedição criada e inventário travado", run != null and c.inventory.locked)
	var default_run := SliceCampaign.in_memory().start_expedition(build, 5)
	_expect("sem extras continua funcionando", default_run != null)
