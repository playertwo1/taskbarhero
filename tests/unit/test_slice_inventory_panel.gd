extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE INVENTORY PANEL (SLICE-1B Plano B) ---")
	var c := SliceCampaign.in_memory()
	var sword := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 10, 3))
	var armor := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Incomum", 12, 3))
	var relic := c.inventory.add_item(LootRoller.make_instance("item_a_005", "Relíquia", 25, 3))
	var panel := SliceInventoryPanel.new()
	add_child(panel)
	panel.setup(c, {"hero_001": "Bastião", "hero_002": "Flecha", "hero_003": "Íris"})
	_expect("uma linha por item", panel.row_count() == 3)
	_expect("resumo mostra itens e Resíduo", panel.summary_text().contains("3") and panel.summary_text().contains("Resíduo"))
	var changed := [0]
	panel.changed.connect(func(): changed[0] += 1)
	_expect("equipar item compatível", panel.equip_item(sword, "hero_001") == "")
	_expect("equipar em herói incompatível falha", panel.equip_item(sword, "hero_002") == "incompatible")
	_expect("reciclar equipado é recusado", panel.recycle_item(sword)["error"] == "equipped")
	_expect("reciclar Relíquia é recusado", panel.recycle_item(relic)["error"] == "not_recyclable")
	var res := panel.recycle_item(armor)
	_expect("reciclar Incomum rende 2 Resíduos", res["ok"] and res["residue"] == 2)
	_expect("a lista se atualiza depois de reciclar", panel.row_count() == 2)
	_expect("o sinal changed foi emitido", changed[0] >= 2)
	_expect("desequipar devolve o item", panel.unequip_item(sword) == "")
	c.inventory.locked = true
	_expect("com expedição em andamento a tela recusa", panel.equip_item(sword, "hero_001") == "locked")
	c.inventory.locked = false
	panel.auto_equip_all()
	_expect("equipar melhores usa o auto_equip", c.inventory.equipped.get("hero_001", []).has(sword))

	print("=======================================================")
	print("[%s] TESTE SLICE INVENTORY PANEL" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
