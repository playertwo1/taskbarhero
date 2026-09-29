extends Node

## DebugBridge: Ponto central de integracao do jogo com o agente Argos e automacoes externas.
## Encapsula comandos, queries e injecao de cenarios.

@onready var dev_mode = DevMode
@onready var test_hooks = TestHooks
@onready var state_exporter = StateExporter
@onready var telemetry = Telemetry

## Expedição do slice em andamento (registrada pela tela de teste ou por slice_start).
var slice_run: ExpeditionRun = null
var slice_context: Dictionary = {}

func register_slice_run(run: ExpeditionRun, context: Dictionary) -> void:
	slice_run = run
	slice_context = context.duplicate(true)

func slice_snapshot() -> Dictionary:
	return state_exporter.capture_slice_snapshot(slice_run, slice_context)

func execute_command(command_name: String, args: Dictionary = {}) -> Dictionary:
	if not DevMode.is_enabled and not command_name in ["get_state", "get_slice_state"]:
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
		"get_slice_state":
			if slice_run == null:
				return {"status": "error", "message": "nenhuma expedição do slice ativa"}
			return {"status": "ok", "state": slice_snapshot()}
		"slice_start":
			var build: Dictionary = args.get("build", {"hero_001": "retaliacao", "hero_002": "marca", "hero_003": "controle"})
			var level := int(args.get("level", 5))
			var seed_value := int(args.get("seed", 1))
			register_slice_run(SliceSession.create_run(build, level, seed_value), {"build": build, "level": level, "seed": seed_value, "source": "debug_bridge"})
			return {"status": "ok", "state": slice_snapshot()}
		"slice_step":
			if slice_run == null:
				return {"status": "error", "message": "nenhuma expedição do slice ativa"}
			var events := slice_run.step(float(args.get("seconds", 1.0)))
			var path: String = state_exporter.write_slice_state(slice_snapshot())
			return {"status": "ok", "events": events.size(), "state": slice_snapshot(), "file": path}
		"reset_state":
			var ok := test_hooks.reset_player_state()
			return {"status": "ok" if ok else "fail"}
		_:
			return {"status": "error", "message": "Comando desconhecido: %s" % command_name}
