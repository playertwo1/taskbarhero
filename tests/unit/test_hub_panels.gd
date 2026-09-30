extends Node

var success := true
const PATH := "user://test_hub_panels.json"
const NAMES := {"hero_001": "Bastião", "hero_002": "Flecha", "hero_003": "Íris"}

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _ready() -> void:
	print("--- TESTE PAINÉIS DO REFÚGIO (SLICE-1D) ---")
	_cleanup()
	_test_tree_panel()
	_test_blacksmith_panel()
	await _test_screen_wiring()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE PAINÉIS DO REFÚGIO" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _test_tree_panel() -> void:
	print("\n>>> 1. PAINEL DA ÁRVORE")
	var c := SliceCampaign.in_memory()
	var panel := ResonanceTreePanel.new()
	add_child(panel)
	panel.setup(c)
	_expect("uma linha por nó (6)", panel.row_count() == 6)
	_expect("raiz ativa, Pulso Vital sem Fragmentos", panel.node_state("TREE_VIG_001") == "active" and panel.node_state("TREE_VIG_002") == "expensive")
	_expect("nó com pré-requisito pendente está bloqueado", panel.node_state("TREE_OFI_001") == "locked")
	_expect("resumo mostra Fragmentos", panel.summary_text().contains("0"))
	var changed := [0]
	panel.changed.connect(func(): changed[0] += 1)
	c.data["fragments"] = 2
	_expect("comprar sem Fragmentos suficientes falha", panel.buy_node("TREE_VIG_005") == "prereq")
	_expect("comprar Pulso Vital funciona e emite changed", panel.buy_node("TREE_VIG_002") == "" and changed[0] == 1)
	_expect("nó comprado fica ativo e o saldo baixa", panel.node_state("TREE_VIG_002") == "active" and int(c.data["fragments"]) == 0)
	_expect("recompra é recusada", panel.buy_node("TREE_VIG_002") == "owned" and changed[0] == 1)
	panel.queue_free()

func _test_blacksmith_panel() -> void:
	print("\n>>> 2. PAINEL DO FERREIRO")
	var c := SliceCampaign.in_memory()
	var sword := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 10, 3))
	var armor := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Incomum", 12, 3))
	c.inventory.add_materials({SliceInventory.RESIDUE: 5})
	var panel := BlacksmithPanel.new()
	add_child(panel)
	panel.setup(c, NAMES)
	_expect("uma linha por item", panel.row_count() == 2)
	_expect("serviços fechados no início", panel.summary_text().contains("fechada") and panel.summary_text().contains("fechado"))
	_expect("desmontar sem o nó é recusado", panel.press_disassemble(armor)["error"] == "confirm" and panel.press_disassemble(armor)["error"] == "service")
	c.data["tree_nodes"] = ["TREE_VIG_002", "TREE_VIG_005", "TREE_OFI_001", "TREE_OFI_002", "TREE_OFI_003"]
	panel.refresh()
	_expect("serviços abertos com a Árvore", panel.summary_text().contains("aberta") and panel.summary_text().contains("aberto"))
	_expect("primeiro toque só pede confirmação", panel.press_disassemble(armor)["error"] == "confirm" and panel.pending_uid == armor and c.inventory.find(armor).size() > 0)
	_expect("segundo toque desmonta e rende Resíduo", panel.press_disassemble(armor)["ok"] and c.inventory.find(armor).is_empty() and int(c.inventory.materials[SliceInventory.RESIDUE]) == 7)
	c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 5, 1))
	panel.toggle_favorite(sword)
	_expect("favorito não entra em confirmação", panel.press_disassemble(sword)["error"] == "favorite" and panel.pending_uid == 0)
	var other := int(c.inventory.items[1]["uid"])
	_expect("pede confirmação para outro item", panel.press_disassemble(other)["error"] == "confirm" and panel.pending_uid == other)
	panel.toggle_favorite(other)
	_expect("favoritar cancela a confirmação pendente", panel.pending_uid == 0 and panel.press_disassemble(other)["error"] == "favorite")
	_expect("reforçar gasta Resíduo e marca o item", panel.reinforce_item(sword) == "" and int(c.inventory.find(sword)["reinforce"]) == 1 and int(c.inventory.materials[SliceInventory.RESIDUE]) == 2)
	_expect("reforço repetido é recusado", panel.reinforce_item(sword) == "maxed")
	panel.queue_free()

func _test_screen_wiring() -> void:
	print("\n>>> 3. TELA DA CAMPANHA")
	var screen: SliceCampaignScreen = load("res://scenes/slice/SliceCampaign.tscn").instantiate()
	screen.save_path = PATH
	add_child(screen)
	await get_tree().process_frame
	_expect("Ferreiro escondido sem OFI_001", not screen._blacksmith_button.visible)
	screen.campaign.data["fragments"] = 3
	_expect("resumo da preparação mostra Fragmentos", screen.summary_line().contains("Fragmentos: 3"))
	screen.campaign.data["tree_nodes"] = ["TREE_VIG_002", "TREE_VIG_005", "TREE_OFI_001"]
	screen._show("prep")
	_expect("Ferreiro aparece depois de OFI_001", screen._blacksmith_button.visible)
	screen._open_tree()
	_expect("abrir a Árvore cria o painel", screen._panel is ResonanceTreePanel)
	screen._panel.closed.emit()
	await get_tree().process_frame
	screen._open_blacksmith()
	_expect("abrir o Ferreiro cria o painel", screen._panel is BlacksmithPanel)
	screen._panel.closed.emit()
	screen.queue_free()
