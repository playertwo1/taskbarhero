extends Node

var success := true
var rows: Array
var recycle := {"Comum": 1, "Incomum": 2, "Raro": 3, "Épico": 5}

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE INVENTORY (SLICE-1B) ---")
	rows = SliceStats.load_rows("res://data/items/items.json", "slice")
	_test_equip_rules()
	_test_slots_and_swap()
	_test_recycle()
	_test_lock_and_roundtrip()
	print("=======================================================")
	print("[%s] TESTE SLICE INVENTORY" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _inst(id: String, rarity: String = "Comum") -> Dictionary:
	return LootRoller.make_instance(id, rarity, 10, 5)

func _test_equip_rules() -> void:
	print("\n>>> 1. EQUIPAR E COMPATIBILIDADE")
	var inv := SliceInventory.create(rows, recycle)
	var bow := inv.add_item(_inst("item_w_002", "Incomum"))
	var sword := inv.add_item(_inst("item_w_001"))
	_expect("uids únicos e crescentes", bow == 1 and sword == 2)
	_expect("arco da Flecha não equipa no Bastião", inv.equip("hero_001", bow) == "incompatible")
	_expect("item desconhecido", inv.equip("hero_001", 99) == "unknown")
	_expect("espada equipa no Bastião", inv.equip("hero_001", sword) == "")
	var run_gear := inv.equipment_for_run()
	_expect("equipment_for_run devolve id/raridade/IP/nível", run_gear["hero_001"][0]["id"] == "item_w_001" and run_gear["hero_001"][0]["item_power"] == 10)
	_expect("unequip devolve ao inventário", inv.unequip(sword) == "" and inv.equipment_for_run().get("hero_001", []).is_empty())

func _test_slots_and_swap() -> void:
	print("\n>>> 2. VAGAS E TROCA")
	var inv := SliceInventory.create(rows, recycle)
	var w1 := inv.add_item(_inst("item_w_001"))
	var w2 := inv.add_item(_inst("item_w_003", "Raro"))
	inv.equip("hero_001", w1)
	inv.equip("hero_001", w2)
	_expect("segunda arma troca a primeira", inv.equipped["hero_001"] == [w2])
	var r1 := inv.add_item(_inst("item_r_001"))
	var r2 := inv.add_item(_inst("item_s_003", "Raro"))
	var r3 := inv.add_item(_inst("item_r_001", "Incomum"))
	inv.equip("hero_001", r1)
	inv.equip("hero_001", r3)
	_expect("acessório tem 2 vagas", inv.equipped["hero_001"].has(r1) and inv.equipped["hero_001"].has(r3))
	var r4 := inv.add_item(_inst("item_r_001", "Raro"))
	inv.equip("hero_001", r4)
	_expect("terceiro acessório troca o mais antigo", not inv.equipped["hero_001"].has(r1) and inv.equipped["hero_001"].has(r4))
	_expect("secundário compartilhado equipa em outro herói", inv.equip("hero_003", r2) == "")

func _test_recycle() -> void:
	print("\n>>> 3. RECICLAGEM")
	var inv := SliceInventory.create(rows, recycle)
	var expected := {"Comum": 1, "Incomum": 2, "Raro": 3, "Épico": 5}
	for rarity in expected:
		var uid := inv.add_item(_inst("item_a_001", rarity))
		var res := inv.recycle(uid)
		_expect("reciclar %s rende %d" % [rarity, expected[rarity]], res["ok"] and res["residue"] == expected[rarity])
	_expect("Resíduo acumulado = 11", int(inv.materials.get("MAT_C1_LUMEN_RESIDUE", 0)) == 11)
	var worn := inv.add_item(_inst("item_a_001"))
	inv.equip("hero_001", worn)
	_expect("equipado não recicla", inv.recycle(worn)["error"] == "equipped")
	var relic := inv.add_item(_inst("item_a_005", "Relíquia"))
	_expect("Relíquia não recicla", inv.recycle(relic)["error"] == "not_recyclable")
	_expect("item reciclado some do inventário", inv.find(1).is_empty())

func _test_lock_and_roundtrip() -> void:
	print("\n>>> 4. TRAVA E PERSISTÊNCIA")
	var inv := SliceInventory.create(rows, recycle)
	var uid := inv.add_item(_inst("item_w_001"))
	inv.equip("hero_001", uid)
	inv.add_materials({"MAT_C1_LUMEN_RESIDUE": 4})
	inv.locked = true
	_expect("travado bloqueia equipar/desequipar/reciclar", inv.equip("hero_001", uid) == "locked" and inv.unequip(uid) == "locked" and inv.recycle(uid)["error"] == "locked")
	_expect("travado ainda aceita loot novo", inv.add_item(_inst("item_a_001")) > uid)
	inv.locked = false
	var copy := SliceInventory.from_dict(JSON.parse_string(JSON.stringify(inv.to_dict())), rows, recycle)
	_expect("ida e volta preserva itens, equipado e materiais", copy.items.size() == inv.items.size() and copy.equipped == inv.equipped and copy.materials == inv.materials)
	_expect("uid continua único depois de carregar", copy.add_item(_inst("item_a_001")) == inv.add_item(_inst("item_a_001")))
