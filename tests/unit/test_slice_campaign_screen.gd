extends Node

var success := true
const PATH := "user://test_slice_screen.json"
const LEVEL := 12

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
	print("--- TESTE SLICE CAMPAIGN SCREEN (SLICE-1B Plano B) ---")
	_cleanup()
	var screen: SliceCampaignScreen = load("res://scenes/slice/SliceCampaign.tscn").instantiate()
	screen.save_path = PATH
	add_child(screen)
	_expect("a tela abre em preparação", screen.mode == "prep")
	screen.campaign.data["party"]["level"] = LEVEL
	screen.start_expedition(2)
	_expect("iniciar leva ao modo run e trava o inventário", screen.mode == "run" and screen.campaign.inventory.locked)

	var saw_choice := false
	var choices_made := 0
	var guard := 0
	var saw_encounter_line := false
	while screen.mode == "run" and guard < 20000:
		guard += 1
		# O log da tela guarda só as últimas linhas; uma luta longa de chefe empurra as de "Encontro" para fora.
		saw_encounter_line = saw_encounter_line or screen.log_lines().any(func(l): return String(l).begins_with("Encontro"))
		var labels := screen.pending_labels()
		if not labels.is_empty():
			saw_choice = true
			_expect("a escolha pendente tem opções e o log já mostra o texto", labels.size() >= 1 and screen.log_lines().size() >= 1)
			screen.choose(labels.size() - 1 if choices_made % 2 == 0 else 0)
			choices_made += 1
		else:
			screen.advance(0.5)
	_expect("a expedição terminou no modo result", screen.mode == "result")
	_expect("houve ao menos uma escolha (Reward Choice ou evento)", saw_choice)
	_expect("o resultado descreve vitória ou derrota", screen.result_text().contains("vitória") or screen.result_text().contains("Derrota") or screen.result_text().contains("Vitória") or screen.result_text().contains("derrota"))
	_expect("o inventário destravou", not screen.campaign.inventory.locked)
	_expect("o save foi gravado em disco", FileAccess.file_exists(PATH))
	_expect("o log teve linhas de encontro", saw_encounter_line)
	var reloaded := SliceCampaign.open(PATH)
	_expect("reabrir o save preserva os itens", reloaded.inventory.items.size() == screen.campaign.inventory.items.size())
	screen.campaign.inventory.grant_echo(SliceInventory.ECHO_SENTINEL)
	screen._open_inventory()
	var echo_button: Button = screen._panel.find_child("Button", true, false)
	for node in screen._panel.find_children("*", "Button", true, false):
		if String(node.text).contains("Sentinela"):
			echo_button = node
	_expect("inventário mostra opção de equipar o Echo obtido", echo_button != null and echo_button.text.contains("Equipar"))
	if echo_button != null:
		echo_button.pressed.emit()
	_expect("botão do inventário equipa A Sentinela que Ficou", screen.campaign.inventory.equipped_echo == SliceInventory.ECHO_SENTINEL)
	screen.queue_free()
	_cleanup()

	print("=======================================================")
	print("[%s] TESTE SLICE CAMPAIGN SCREEN" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
