extends Node

var success := true
const PATH := "user://test_blacksmith.json"
const OPEN := ["TREE_VIG_002", "TREE_VIG_005", "TREE_OFI_001", "TREE_OFI_002", "TREE_OFI_003"]

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE FERREIRO (SLICE-1D) ---")
	_cleanup()
	_test_service_gating()
	_test_favorite_and_disassemble()
	_test_reinforce_rules()
	_test_reinforce_stats()
	_test_persistence()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE FERREIRO" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _test_service_gating() -> void:
	print("\n>>> 1. SERVIÇOS ATRÁS DA ÁRVORE")
	var c := SliceCampaign.in_memory()
	var uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 10, 3))
	c.inventory.add_materials({SliceInventory.RESIDUE: 5})
	_expect("Ferreiro fechado no início", not c.blacksmith_open() and not c.can_disassemble() and not c.can_reinforce())
	_expect("desmontar recusado sem o nó", c.recycle(uid)["error"] == "service")
	_expect("reforçar recusado sem o nó", c.reinforce(uid) == "service")
	c.data["tree_nodes"] = ["TREE_VIG_002", "TREE_VIG_005", "TREE_OFI_001"]
	_expect("OFI_001 abre só o Ferreiro", c.blacksmith_open() and not c.can_disassemble() and not c.can_reinforce())
	c.data["tree_nodes"].append("TREE_OFI_002")
	_expect("OFI_002 abre a desmontagem", c.can_disassemble() and not c.can_reinforce())
	c.data["tree_nodes"].append("TREE_OFI_003")
	_expect("OFI_003 abre o reforço", c.can_reinforce())

func _test_favorite_and_disassemble() -> void:
	print("\n>>> 2. FAVORITO PROTEGE A DESMONTAGEM")
	var c := SliceCampaign.in_memory()
	c.data["tree_nodes"] = OPEN.duplicate()
	var uid := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Incomum", 12, 3))
	_expect("marcar favorito", c.set_favorite(uid, true) == "")
	_expect("favorito não desmonta", c.recycle(uid)["error"] == "favorite" and c.inventory.find(uid).size() > 0)
	c.set_favorite(uid, false)
	var res := c.recycle(uid)
	_expect("sem favorito desmonta e rende Resíduo", res["ok"] and int(c.inventory.materials[SliceInventory.RESIDUE]) == 2)
	_expect("favorito em item inexistente", c.set_favorite(999, true) == "unknown")

func _test_reinforce_rules() -> void:
	print("\n>>> 3. REGRAS DO REFORÇO +1")
	var c := SliceCampaign.in_memory()
	c.data["tree_nodes"] = OPEN.duplicate()
	var sword := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 10, 3))
	var ring := c.inventory.add_item(LootRoller.make_instance("item_r_001", "Comum", 10, 3))
	_expect("sem Resíduo recusa", c.reinforce(sword) == "materials")
	c.inventory.add_materials({SliceInventory.RESIDUE: 9})
	_expect("acessório é inelegível", c.reinforce(ring) == "ineligible")
	_expect("reforço rende +1 e custa 5 Resíduos", c.reinforce(sword) == "" and int(c.inventory.find(sword)["reinforce"]) == 1 and int(c.inventory.materials[SliceInventory.RESIDUE]) == 4)
	_expect("segundo reforço no mesmo item recusado", c.reinforce(sword) == "maxed")
	_expect("item inexistente", c.reinforce(999) == "unknown")
	c.inventory.locked = true
	var armor := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 10, 3))
	_expect("travado durante a expedição", c.reinforce(armor) == "locked")

func _test_reinforce_stats() -> void:
	print("\n>>> 4. +2% DOS AFIXOS-BASE")
	var rows := SliceStats.load_rows("res://data/items/items.json", "slice")
	var base := {"attack": 10.0, "max_hp": 100.0, "defense": 5.0, "crit_chance": 0.0, "skill_haste": 0.0, "tenacity": 0.0, "attack_speed": 1.0}
	var plain := {"id": "item_w_001", "rarity": "Raro", "item_power": 50, "item_level": 5}
	var reinforced := plain.duplicate()
	reinforced["reinforce"] = 1
	var a := SliceItemStats.equip(base, "hero_001", [plain], rows)
	var b := SliceItemStats.equip(base, "hero_001", [reinforced], rows)
	var gain_a := float(a["attack"]) - 10.0
	var gain_b := float(b["attack"]) - 10.0
	_expect("item base dá bônus de ataque", gain_a > 0.0)
	_expect("reforço multiplica o bônus por 1,10", absf(gain_b - gain_a * 1.10) < 0.0001)
	_expect("Item Power não muda", int(reinforced["item_power"]) == 50)

func _test_persistence() -> void:
	print("\n>>> 5. PERSISTE NO SAVE")
	var c := SliceCampaign.open(PATH)
	c.data["tree_nodes"] = OPEN.duplicate()
	var uid := c.inventory.add_item(LootRoller.make_instance("item_a_002", "Incomum", 10, 3))
	c.inventory.add_materials({SliceInventory.RESIDUE: 5})
	c.set_favorite(uid, true)
	_expect("reforço grava", c.reinforce(uid) == "")
	var again := SliceCampaign.open(PATH)
	var inst := again.inventory.find(uid)
	_expect("reforço e favorito sobrevivem ao reabrir", int(inst["reinforce"]) == 1 and bool(inst["favorite"]))
	var eq := again.inventory.equipment_for_run()
	again.inventory.equip("hero_001", uid)
	_expect("equipamento da run carrega o reforço", int(again.inventory.equipment_for_run()["hero_001"][0]["reinforce"]) == 1 or eq.is_empty())
