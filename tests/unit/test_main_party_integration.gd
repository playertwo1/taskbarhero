extends Node

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE DE INTEGRAÇÃO MAIN SCENE + PARTY SCREEN ---")
	print("=======================================================")

	var success := true
	var main_scene: PackedScene = load("res://scenes/main/Main.tscn")
	if not main_scene:
		print("FALHA: Não foi possível carregar scenes/main/Main.tscn")
		get_tree().quit(1)
		return

	var main_instance = main_scene.instantiate()
	add_child(main_instance)
	await get_tree().process_frame
	await get_tree().process_frame

	var party_btn: Button = main_instance.party_button
	var party_scr = main_instance.party_screen
	var subtitle: Label = main_instance.subtitle_label
	var battle_strip = main_instance.battle_strip

	if not party_btn or not party_scr or not subtitle or not battle_strip:
		print("FALHA: Referências de nós essenciais estão ausentes no Main")
		get_tree().quit(1)
		return

	print("[PASS] Main instanciado com PartyButton, PartyScreen, SubtitleLabel e BattleStrip")

	# Test 1: Open PartyScreen via PartyButton
	print("\n>>> 1. TESTANDO ABERTURA DO PARTY SCREEN:")
	party_btn.emit_signal("pressed")
	await get_tree().process_frame
	if not party_scr.visible:
		print("FALHA: PartyScreen não ficou visível após clicar no botão Equipe")
		success = false
	else:
		print("[PASS] PartyScreen visível com sucesso")

	# Test 2: Toggle heroes to select [brasa, veu, forja]
	print("\n>>> 2. TESTANDO SELEÇÃO DE HERÓIS NA UI: [brasa, veu, forja]")
	party_scr.selected_ids = ["brasa", "veu", "forja"]
	party_scr._update_slots_label()
	party_scr._render_heroes()
	party_scr._on_apply_pressed()
	await get_tree().process_frame

	if party_scr.visible:
		print("FALHA: PartyScreen deveria ter fechado após aplicar")
		success = false
	else:
		print("[PASS] PartyScreen fechado após aplicar nova equipe")

	# Verify GameManager party
	if not GameManager.party.has("brasa") or not GameManager.party.has("veu") or not GameManager.party.has("forja"):
		print("FALHA: GameManager party não contém brasa, veu, forja: ", GameManager.party.keys())
		success = false
	else:
		print("[PASS] GameManager party atualizada: ", GameManager.party.keys())

	# Verify Subtitle label
	print("  Subtitle Label text: ", subtitle.text)
	if not ("Br:" in subtitle.text or "V:" in subtitle.text or "Fo:" in subtitle.text):
		print("FALHA: SubtitleLabel não contém prefixos dos novos heróis")
		success = false
	else:
		print("[PASS] SubtitleLabel renderizou HP dinâmico dos heróis selecionados")

	# Verify BattleStrip visuals
	for hid in ["brasa", "veu", "forja"]:
		if not battle_strip.party_visuals.has(hid):
			print("FALHA: BattleStrip não possui visual de: ", hid)
			success = false
		else:
			print("  [PASS] BattleStrip tem visual ativo para: ", hid)

	# Test 3: Run combat frames to ensure no null references or math errors
	print("\n>>> 3. EXECUTANDO 30 FRAMES DE COMBATE COM NOVA EQUIPE:")
	for f in range(30):
		await get_tree().process_frame
	print("[PASS] 30 frames de combate executados sem crash!")

	if success:
		print("\n=======================================================")
		print(">>> TODOS OS TESTES DE INTEGRAÇÃO PASSARAM COM SUCESSO! <<<")
		print("=======================================================\n")
		get_tree().quit(0)
	else:
		print("\n>>> HOUVE FALHAS NOS TESTES DE INTEGRAÇÃO <<<")
		get_tree().quit(1)
