extends Node

func _ready() -> void:
	print("\n--- TESTE DO HUB SCREEN (O REFÚGIO) ---")
	
	var hub_scene = load("res://scenes/ui/HubScreen.tscn")
	if not hub_scene:
		push_error("[FAIL] Falha ao carregar HubScreen.tscn")
		get_tree().quit(1)
		return
	
	var hub_instance = hub_scene.instantiate()
	add_child(hub_instance)
	print("[PASS] HubScreen instanciado com sucesso")
	
	# 1. Background e opções
	var bg = hub_instance.get_node("Background") as TextureRect
	if not bg or not bg.texture:
		push_error("[FAIL] TextureRect de background nao encontrada")
		get_tree().quit(1)
		return
	print("[PASS] Background padrao carregado: ", bg.texture.get_path())
	
	hub_instance.set_hub_option(1)
	print("[PASS] Opcao 1 configurada: ", bg.texture.get_path())
	hub_instance.set_hub_option(3)
	print("[PASS] Opcao 3 configurada: ", bg.texture.get_path())
	hub_instance.set_hub_option(2)
	print("[PASS] Opcao 2 configurada: ", bg.texture.get_path())
	
	# 2. Testar hotspots de artesãos e locais
	var signals_tested: Dictionary = {
		"blacksmith": false,
		"alchemist": false,
		"jeweler": false,
		"campfire": false,
		"tree": false
	}
	
	hub_instance.blacksmith_opened.connect(func(): signals_tested["blacksmith"] = true)
	hub_instance.alchemist_opened.connect(func(): signals_tested["alchemist"] = true)
	hub_instance.jeweler_opened.connect(func(): signals_tested["jeweler"] = true)
	hub_instance.campfire_opened.connect(func(): signals_tested["campfire"] = true)
	hub_instance.resonance_tree_opened.connect(func(): signals_tested["tree"] = true)
	
	hub_instance.blacksmith_btn.pressed.emit()
	hub_instance.alchemist_btn.pressed.emit()
	hub_instance.jeweler_btn.pressed.emit()
	hub_instance.campfire_btn.pressed.emit()
	hub_instance.tree_btn.pressed.emit()
	
	for key in signals_tested:
		if not signals_tested[key]:
			push_error("[FAIL] Sinal do hotspot nao disparou: " + key)
			get_tree().quit(1)
			return
	print("[PASS] Todos os 5 hotspots de artesãos, fogueira e árvore emitiram seus sinais")
	
	# 3. Testar evolução da vila (Progresso Nv. 1 -> Nv. 5)
	var upgraded_levels: Array[int] = []
	hub_instance.village_upgraded.connect(func(lvl): upgraded_levels.append(lvl))
	
	print("[INFO] Nivel inicial: ", hub_instance.village_level, " (", hub_instance.village_level_label.text, ")")
	for i in range(4):
		var upgraded = hub_instance.upgrade_village()
		if not upgraded:
			push_error("[FAIL] Falha ao evoluir a vila no passo " + str(i))
			get_tree().quit(1)
			return
	
	if hub_instance.village_level != 5:
		push_error("[FAIL] Nivel final esperado 5, obtido: " + str(hub_instance.village_level))
		get_tree().quit(1)
		return
	print("[PASS] Progressao da vila testada com sucesso ate o Nivel 5: ", upgraded_levels)
	print("[PASS] Label de status final: '", hub_instance.village_level_label.text, "'")
	
	# 4. Testar navegacao inferior
	var nav_destinations: Array[String] = []
	hub_instance.navigate_requested.connect(func(dest): nav_destinations.append(dest))
	
	hub_instance.nav_village_btn.pressed.emit()
	hub_instance.nav_heroes_btn.pressed.emit()
	hub_instance.nav_explore_btn.pressed.emit()
	hub_instance.nav_inventory_btn.pressed.emit()
	hub_instance.nav_menu_btn.pressed.emit()
	
	var expected_dests = ["hub", "party", "stages", "inventory", "menu"]
	if nav_destinations != expected_dests:
		push_error("[FAIL] Destinos de navegacao incorretos: " + str(nav_destinations))
		get_tree().quit(1)
		return
	print("[PASS] Barra de navegacao inferior testada com sucesso: ", nav_destinations)
	
	print("=== HUB SCREEN TEST 100% PASS ===\n")
	get_tree().quit(0)
