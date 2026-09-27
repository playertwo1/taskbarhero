extends Node

## DebugBridge: Ponto central de integracao do jogo com o agente Argos e automacoes externas.
## Encapsula comandos, queries e injecao de cenarios.

@onready var dev_mode = DevMode
@onready var test_hooks = TestHooks
@onready var state_exporter = StateExporter
@onready var telemetry = Telemetry

func execute_command(command_name: String, args: Dictionary = {}) -> Dictionary:
	if not DevMode.is_enabled and command_name != "get_state":
		return {"status": "error", "message": "DevMode esta desativado"}
		
	match command_name:
		"get_state":
			return {"status": "ok", "state": state_exporter.capture_snapshot("runtime", args.get("tag", ""))}
		"set_level":
			var ok := test_hooks.set_level(int(args.get("level", 1)))
			return {"status": "ok" if ok else "fail"}
		"give_gold":
			var ok := test_hooks.give_gold(int(args.get("amount", 100)))
			return {"status": "ok" if ok else "fail"}
		"spawn_enemy":
			var ok := test_hooks.spawn_enemy_by_id(args.get("enemy_id", ""))
			return {"status": "ok" if ok else "fail"}
		"set_time_scale":
			dev_mode.set_custom_time_scale(float(args.get("scale", 1.0)))
			return {"status": "ok", "scale": dev_mode.time_scale}
		"simulate_offline":
			var res := test_hooks.simulate_offline_time(float(args.get("seconds", 3600.0)))
			return {"status": "ok", "result": res}
		"reset_state":
			var ok := test_hooks.reset_player_state()
			return {"status": "ok" if ok else "fail"}
		_:
			return {"status": "error", "message": "Comando desconhecido: %s" % command_name}
