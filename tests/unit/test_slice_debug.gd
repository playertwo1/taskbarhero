extends Node

## DebugBridge/StateExporter apontando para a expedição do slice (Argos v0.0 no slice).

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		success = false
		print("FALHA: ", label)

func _ready() -> void:
	print("--- TESTE PONTE DO SLICE (DebugBridge/StateExporter) ---")
	DevMode.enable()
	_expect("sem expedição, get_slice_state devolve erro", DebugBridge.execute_command("get_slice_state").get("status") == "error" or DebugBridge.slice_run != null)

	var start: Dictionary = DebugBridge.execute_command("slice_start", {"build": {"hero_001": "retaliacao_tele", "hero_002": "marca", "hero_003": "controle"}, "level": 5, "seed": 3})
	_expect("slice_start cria a expedição", start.get("status") == "ok")
	var st: Dictionary = DebugBridge.execute_command("get_slice_state").get("state", {})
	_expect("snapshot tem contexto e 3 heróis com HP máximo", st.get("context", {}).get("seed") == 3 and st.get("run", {}).get("party", []).size() == 3 and float(st["run"]["party"][0]["max_hp"]) > 0.0)

	var step: Dictionary = DebugBridge.execute_command("slice_step", {"seconds": 30.0})
	_expect("slice_step avança o tempo", absf(float(step.get("state", {}).get("run", {}).get("time", 0.0)) - 30.0) < 0.001)
	_expect("slice_step grava o estado para leitura externa", step.get("file", "") == StateExporter.SLICE_STATE_PATH and FileAccess.file_exists(StateExporter.SLICE_STATE_PATH))
	var saved = JSON.parse_string(FileAccess.open(StateExporter.SLICE_STATE_PATH, FileAccess.READ).get_as_text())
	_expect("arquivo gravado é o mesmo snapshot", saved is Dictionary and saved.get("kind") == "slice_expedition")

	# A tela de teste registra a própria expedição no DebugBridge.
	var probe: Node = load("res://scenes/slice/SliceProbe.tscn").instantiate()
	add_child(probe)
	await get_tree().process_frame
	_expect("SliceProbe registra a expedição", DebugBridge.slice_context.get("source") == "slice_probe" and DebugBridge.slice_run == probe.run)
	probe.queue_free()

	DevMode.disable()
	_expect("sem DevMode, comandos de escrita são recusados", DebugBridge.execute_command("slice_step").get("status") == "error")
	_expect("sem DevMode, leitura continua permitida", DebugBridge.execute_command("get_slice_state").get("status") == "ok")
	print("[PASS] TESTE PONTE DO SLICE CONCLUÍDO" if success else "[FAIL] TESTE PONTE DO SLICE FALHOU")
	get_tree().quit(0 if success else 1)
