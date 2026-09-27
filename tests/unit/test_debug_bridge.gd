extends Node

func _ready() -> void:
	print("--- TESTE UNITÁRIO: VALIDAÇÃO DO DEBUGBRIDGE & TELEMETRIA ARGOS ---")
	var success: bool = true

	# 1. Ativar DevMode
	DevMode.enable()
	if not DevMode.is_enabled:
		print("AVISO: DevMode nao habilitado (pode ser build sem debug).")

	# 2. Testar get_state
	var state_res: Dictionary = DebugBridge.execute_command("get_state", {"tag": "unit_test"})
	if state_res.get("status") != "ok" or not state_res.has("state"):
		print("ERRO: Falha ao capturar estado via DebugBridge.")
		success = false
	else:
		var st: Dictionary = state_res["state"]
		print("[PASS] Snapshot capturado com sucesso: Stage %s, Level %d, Hero HP %.0f" % [
			st.get("stage"), st.get("level"), st.get("hero", {}).get("hp", 0)
		])

	# 3. Testar give_gold
	var gold_before: int = ProgressionManager.gold
	var gold_res: Dictionary = DebugBridge.execute_command("give_gold", {"amount": 250})
	if gold_res.get("status") != "ok" or ProgressionManager.gold != gold_before + 250:
		print("ERRO: give_gold nao creditou o ouro corretamente.")
		success = false
	else:
		print("[PASS] give_gold validado: saldo anterior %d -> novo saldo %d" % [gold_before, ProgressionManager.gold])

	# 4. Testar set_level
	var lvl_res: Dictionary = DebugBridge.execute_command("set_level", {"level": 7})
	if lvl_res.get("status") != "ok" or ProgressionManager.level != 7:
		print("ERRO: set_level nao atualizou o nivel para 7.")
		success = false
	else:
		print("[PASS] set_level validado: Hero Level alterado para %d" % ProgressionManager.level)

	# 5. Testar Telemetria
	Telemetry.record_kill("geleia_de_lumen", 2.5, 10, 5)
	var summary: Dictionary = Telemetry.get_telemetry_summary()
	if summary.get("enemies_killed", 0) < 1:
		print("ERRO: Telemetria nao registrou o kill.")
		success = false
	else:
		print("[PASS] Telemetria validada: Kills %d, Total XP %d, Total Ouro %d" % [
			summary.get("enemies_killed"), summary.get("total_xp"), summary.get("total_gold")
		])

	# 6. Resetar estado
	DebugBridge.execute_command("reset_state")
	print("[PASS] Reset de estado de teste concluido.")

	print("================================================================================")
	if success:
		print("=== TESTE DEBUGBRIDGE & TELEMETRIA ARGOS: PASS ===")
		get_tree().quit(0)
	else:
		print("=== TESTE DEBUGBRIDGE & TELEMETRIA ARGOS: FALHOU ===")
		get_tree().quit(1)
