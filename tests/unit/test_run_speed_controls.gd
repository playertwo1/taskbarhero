extends Node

var success := true
const PATH := "user://test_run_speed_controls.json"

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
	print("--- TESTE PAUSA E VELOCIDADE (UI_S05) ---")
	_cleanup()
	var screen: SliceCampaignScreen = load("res://scenes/slice/SliceCampaign.tscn").instantiate()
	screen.save_path = PATH
	add_child(screen)
	await get_tree().process_frame
	_expect("velocidade inicial é ×1 e não começa pausado", screen.speed == 1.0 and not screen.paused)
	for v in [1.0, 2.0, 3.0, 4.0]:
		_expect("aceita ×%d" % int(v), screen.set_speed(v) and screen.speed == v)
	var before: float = screen.speed
	_expect("recusa velocidade fora da lista", not screen.set_speed(7.0) and screen.speed == before)
	screen.start_expedition(0)
	_expect("expedição começa sem pausa", screen.mode == "run" and not screen.paused)
	screen.advance(1.0)
	var t_running: float = screen.run.time
	_expect("sem pausa o tempo avança", t_running > 0.0)
	screen.toggle_pause()
	screen.advance(5.0)
	_expect("pausado, o tempo não avança", screen.paused and screen.run.time == t_running)
	screen.set_speed(3.0)
	_expect("trocar a velocidade em pausa é permitido e continua pausado", screen.paused and screen.speed == 3.0)
	screen.toggle_pause()
	screen.advance(1.0)
	_expect("retomar avança de novo", not screen.paused and screen.run.time > t_running)
	screen.toggle_pause()
	screen.start_expedition(0)
	_expect("nova expedição não herda a pausa", not screen.paused)
	screen.queue_free()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE PAUSA E VELOCIDADE" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
