extends Node

func _ready() -> void:
	print("\n--- TESTE DE TELA INICIAL (TITLE SCREEN) ---")
	
	var title_scene = load("res://scenes/ui/TitleScreen.tscn")
	if not title_scene:
		push_error("[FAIL] Falha ao carregar TitleScreen.tscn")
		get_tree().quit(1)
		return
	
	var title_instance = title_scene.instantiate()
	add_child(title_instance)
	
	var bg = title_instance.get_node("Background") as TextureRect
	if not bg or not bg.texture:
		push_error("[FAIL] Background texture nao encontrada")
		get_tree().quit(1)
		return
	print("[PASS] Background de arte carregado: ", bg.texture.get_path(), " (Tamanho: ", bg.texture.get_size(), ")")
	
	var prompt = title_instance.get_node("VBoxContainer/PromptLabel") as Label
	if not prompt:
		push_error("[FAIL] PromptLabel nao encontrado")
		get_tree().quit(1)
		return
	print("[PASS] PromptLabel presente: '", prompt.text, "'")
	
	# Testar sinal de inicio de jogo
	var state = {"emitted": false}
	title_instance.start_game_requested.connect(func():
		state["emitted"] = true
	)
	
	title_instance._start_game()
	if state["emitted"]:
		print("[PASS] Sinal start_game_requested emitido com sucesso ao tocar na tela")
	else:
		push_error("[FAIL] Sinal start_game_requested nao foi emitido")
		get_tree().quit(1)
		return
		
	print("=== TITLE SCREEN TEST PASS ===\n")
	get_tree().quit(0)
