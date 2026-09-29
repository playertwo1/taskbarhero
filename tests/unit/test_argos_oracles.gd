extends Node

## Oráculos do ARGOS-SIM: um log limpo não viola nada; logs com defeitos conhecidos são detectados.

var success := true
var sim: Node

func _ready() -> void:
	print("\n--- TESTE ORÁCULOS DO ARGOS ---")
	sim = load("res://tools/argos/simulator/combat/argos_sim.gd").new()
	sim.scenario = {"stuck_seconds": 30.0}
	sim.heroes = SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	sim.profiles = SliceStats.load_profiles()
	for e in SliceStats.load_rows("res://data/enemies/enemies.json", "slice"):
		sim.enemy_rank[e["id"]] = e["rank"]
	_test_real_run_is_clean()
	_expect_violation("inimigo derrotado duas vezes", [_start(), _defeat(0.0, "en_c1_001#0"), _defeat(1.0, "en_c1_001#0")], "enemy_defeated_twice")
	_expect_violation("XP diferente do esperado", [_start(), {"type": "enemy_defeated", "time": 1.0, "uid": "en_c1_001#0", "id": "en_c1_001", "xp": 99}], "xp_mismatch")
	_expect_violation("herói derrotado age", [_start(), {"type": "hero_defeated", "time": 1.0, "id": "hero_002"},
		{"type": "hero_attack", "time": 2.0, "source": "hero_002", "target": "en_c1_001#0", "damage": 5.0, "crit": false}], "dead_hero_acted")
	_expect_violation("tempo volta", [_start(), {"type": "hero_attack", "time": 5.0, "source": "hero_001", "target": "x", "damage": 1.0},
		{"type": "hero_attack", "time": 4.0, "source": "hero_001", "target": "x", "damage": 1.0}], "time_went_backwards")
	_expect_violation("combate travado", [_start(), {"type": "hero_attack", "time": 45.0, "source": "hero_001", "target": "x", "damage": 1.0}], "stuck_no_damage")
	sim.free()
	print("[PASS] TESTE ORÁCULOS CONCLUÍDO" if success else "[FAIL] TESTE ORÁCULOS FALHOU")
	get_tree().quit(0 if success else 1)

func _start() -> Dictionary:
	return {"type": "encounter_started", "time": 0.0, "node_id": "n", "party_hp": {}}

func _defeat(t: float, uid: String) -> Dictionary:
	return {"type": "enemy_defeated", "time": t, "uid": uid, "id": "en_c1_001", "xp": 6}

func _finished_run() -> ExpeditionRun:
	var run := ExpeditionRun.new()
	run.state = "won"
	return run

func _expect_violation(label: String, events: Array, name: String) -> void:
	var rec: Dictionary = sim._summarize(_finished_run(), events, 1)
	if rec["violations"].has(name):
		print("[PASS] ", label)
	else:
		success = false
		print("FALHA: %s não detectado (%s)" % [label, JSON.stringify(rec["violations"])])

func _test_real_run_is_clean() -> void:
	var route: Dictionary = JSON.parse_string(FileAccess.open("res://data/expedition/route_c1.json", FileAccess.READ).get_as_text())
	var run := ExpeditionRun.create(route, sim.heroes, SliceStats.load_rows("res://data/enemies/enemies.json", "slice"), {
		"seed": 2, "party_level": 5, "skills": SliceStats.load_rows("res://data/skills/skills_slice.json", "slice"),
		"passives": SliceStats.load_rows("res://data/skills/passives_slice.json", "slice"),
		"builds": {"hero_001": "retaliacao", "hero_002": "marca", "hero_003": "lumen"},
	})
	var rec: Dictionary = sim._summarize(run, run.run_to_end(0.25), 5)
	if rec["violations"].is_empty() and int(rec["xp"]) > 0:
		print("[PASS] expedição real sem violações")
	else:
		success = false
		print("FALHA: expedição real violou %s" % JSON.stringify(rec["violations"]))
