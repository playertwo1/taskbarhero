extends Node

func _ready() -> void:
	print("--- TESTE UNITÁRIO: DEBUGBRIDGE DO SLICE ---")
	var success := true

	DevMode.enable()
	if not DevMode.is_enabled:
		print("AVISO: DevMode nao habilitado (pode ser build sem debug).")

	var none_res: Dictionary = DebugBridge.execute_command("get_state")
	if none_res.get("status") != "error":
		print("ERRO: get_state sem expedição ativa deveria falhar.")
		success = false
	else:
		print("[PASS] get_state sem expedição devolve erro")

	var start_res: Dictionary = DebugBridge.execute_command("slice_start", {"level": 5, "seed": 3})
	if start_res.get("status") != "ok" or not start_res.has("state"):
		print("ERRO: slice_start falhou.")
		success = false
	else:
		print("[PASS] slice_start registrou a expedição")

	var state_res: Dictionary = DebugBridge.execute_command("get_state")
	if state_res.get("status") != "ok" or state_res["state"].get("kind") != "slice_expedition":
		print("ERRO: get_state não devolveu o snapshot do slice.")
		success = false
	else:
		print("[PASS] get_state devolve o snapshot do slice")

	var step_res: Dictionary = DebugBridge.execute_command("slice_step", {"seconds": 2.0})
	if step_res.get("status") != "ok":
		print("ERRO: slice_step falhou.")
		success = false
	else:
		print("[PASS] slice_step avançou a expedição")

	var bad: Dictionary = DebugBridge.execute_command("give_gold")
	if bad.get("status") != "error":
		print("ERRO: comando legado give_gold deveria ser desconhecido.")
		success = false
	else:
		print("[PASS] comandos legados removidos")

	print("================================================================================")
	if success:
		print("=== TESTE DEBUGBRIDGE: PASS ===")
		get_tree().quit(0)
	else:
		print("=== TESTE DEBUGBRIDGE: FALHOU ===")
		get_tree().quit(1)
