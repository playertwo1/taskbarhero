extends Node

const ROUTE_PATH := "res://data/expedition/route_c1.json"
const PLAN_PATH := "res://docs/04_content/chapters/chapter_01/encounter_plan.json"
const ENEMIES_PATH := "res://data/enemies/enemies.json"
const HEROES_PATH := "res://data/heroes/heroes.json"
const EPS := 0.001

var success := true
var hero_rows: Array = []
var enemy_rows: Array = []

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE EXPEDITION RUN (SLICE-1A-3a) ---")
	print("=======================================================")

	hero_rows = SliceStats.load_rows(HEROES_PATH, "slice")
	enemy_rows = SliceStats.load_rows(ENEMIES_PATH, "slice")

	_test_route_integrity()
	_test_hand_calculated_kill()
	_test_targeting()
	_test_hp_persists_and_end_states()
	_test_determinism()
	_test_step_size_independence()
	_report_full_route()

	print("\n=======================================================")
	if success:
		print("[PASS] TESTE EXPEDITION RUN CONCLUÍDO COM SUCESSO")
		get_tree().quit(0)
	else:
		print("[FAIL] TESTE EXPEDITION RUN FALHOU")
		get_tree().quit(1)

func _fail(msg: String) -> void:
	print("FALHA: ", msg)
	success = false

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		_fail(label)

func _check(label: String, actual: float, expected: float, eps: float = EPS) -> void:
	if absf(actual - expected) <= eps:
		print("[PASS] %s = %.4f" % [label, actual])
	else:
		_fail("%s esperado %.4f, obtido %.4f" % [label, expected, actual])

func _load_json(path: String) -> Variant:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return null
	return JSON.parse_string(f.get_as_text())

func _hero(id: String, hp: float = -1.0, attack: float = -1.0) -> Dictionary:
	for r in hero_rows:
		if r["id"] == id:
			var copy: Dictionary = r.duplicate(true)
			# Contas à mão do 1A-3/1A-4a: sem Perfect Block e sem Stagger (testados em test_expedition_mechanics).
			copy.erase("perfect_block")
			copy.erase("basic_stagger")
			if hp > 0.0:
				copy["base_stats"]["max_hp"] = [hp, hp]
			if attack > 0.0:
				copy["base_stats"]["attack"] = [attack, attack]
			return copy
	return {}

func _route(nodes: Array) -> Dictionary:
	return {"transition_seconds": 0.6, "nodes": nodes}

func _enc(id: String, level: int, members: Array, kind: String = "NORMAL") -> Dictionary:
	return {"type": "encounter", "id": id, "kind": kind, "stage": 1, "level": level, "members": members}

func _count(events: Array, type: String) -> int:
	var n := 0
	for e in events:
		if e["type"] == type:
			n += 1
	return n

func _test_route_integrity() -> void:
	print("\n>>> 1. INTEGRIDADE DA ROTA")
	var route: Dictionary = _load_json(ROUTE_PATH)
	var plan: Dictionary = _load_json(PLAN_PATH)
	var plan_by_id := {}
	for e in plan["encounters"]:
		plan_by_id[e["id"]] = e
	var nodes: Array = route["nodes"]
	var encounters := nodes.filter(func(n): return n["type"] == "encounter")
	var events := nodes.filter(func(n): return n["type"] == "event")
	_expect("12 nós: 10 encontros e 2 eventos", nodes.size() == 12 and encounters.size() == 10 and events.size() == 2)

	var levels: Array = []
	var kills := 0
	var enemy_ids := {}
	for r in enemy_rows:
		enemy_ids[r["id"]] = r
	var limits := {"NORMAL": 3.25, "ELITE": 5.0, "MINIBOSS": 11.5, "BOSS": 21.5}
	for n in encounters:
		levels.append(int(n["level"]))
		var cost := 0.0
		for m in n["members"]:
			kills += int(m["count"])
			if not enemy_ids.has(m["enemy_id"]):
				_fail("inimigo inexistente no slice: %s" % m["enemy_id"])
				continue
			cost += float(enemy_ids[m["enemy_id"]]["encounter_cost"]) * float(m["count"])
		if cost > limits[n["kind"]] + 0.0001:
			_fail("custo acima do limite local em %s: %.2f" % [n["id"], cost])
		var p: Dictionary = plan_by_id.get(n["plan_id"], {})
		if p.is_empty() or p["kind"] != n["kind"]:
			_fail("nó fora do plano ou com tipo diferente: %s" % n["id"])
	_expect("23 derrotas contando as invocações adiadas", kills == 23)
	_expect("níveis 1,1,1,2,2,2,3,4,3,5", levels == [1, 1, 1, 2, 2, 2, 3, 4, 3, 5])
	_expect("ordem: elite antes da Rainha, boss por último", encounters[5]["kind"] == "ELITE" and encounters[8]["kind"] == "MINIBOSS" and encounters[9]["kind"] == "BOSS")
	_expect("Poço de Lúmen entre o encontro 7 e o 8", nodes[7]["id"] == "event_c1_001")
	_expect("Reserva de Resíduo depois da Rainha e antes do boss", nodes[10]["id"] == "event_c1_reserva_residuo" and nodes[9]["id"] == "c1_3_2_a")
	var deferred := 0
	for n in encounters:
		for m in n["members"]:
			if m.get("deferred", false):
				deferred += int(m["count"])
	_expect("3 Geleias adiadas (2 da Rainha, 1 do Guardião)", deferred == 3)

# Bastião nível 1 (ATK 10, AS 0,80) contra 1 Geleia (HP 97,75, DEF 6,75), sem crítico:
# golpe de 9,3677 → 11 golpes → 11 × 1,25 s = 13,75 s.
func _test_hand_calculated_kill() -> void:
	print("\n>>> 2. TEMPO CALCULADO À MÃO")
	var route := _route([_enc("solo", 1, [{"enemy_id": "en_c1_001", "count": 1}])])
	var run := ExpeditionRun.create(route, [_hero("hero_001")], enemy_rows, {"seed": 1, "crits": false, "party_level": 1})
	var events := run.run_to_end(0.5)
	var cleared: Dictionary = {}
	for e in events:
		if e["type"] == "encounter_cleared":
			cleared = e
	_expect("encontro concluído", not cleared.is_empty())
	_check("duração do encontro", cleared.get("duration", 0.0), 13.75)
	_expect("11 golpes do herói", _count(events, "hero_attack") == 11)
	_expect("vitória da expedição", run.state == "won")
	# A Geleia ataca a cada 1,0 s até 13,0 s: 13 golpes de 3,8136.
	_expect("13 golpes do inimigo", _count(events, "enemy_attack") == 13)
	_check("HP restante de Bastião", cleared["party_hp"]["hero_001"], 160.0 - 13.0 * 3.8136, 0.01)

func _test_targeting() -> void:
	print("\n>>> 3. ALVOS E FOCO")
	var route := _route([_enc("duo", 1, [{"enemy_id": "en_c1_001", "count": 2}])])
	var run := ExpeditionRun.create(route, [_hero("hero_001"), _hero("hero_002"), _hero("hero_003")], enemy_rows, {"seed": 3, "crits": false, "party_level": 1, "targeting": "front"})
	var events := run.run_to_end(0.25)
	var first_target_change := -1
	var last_on_first := -1
	var first_on_second := 1000000
	for i in events.size():
		var e: Dictionary = events[i]
		if e["type"] == "hero_attack":
			if e["target"].ends_with("#0"):
				last_on_first = i
			elif e["target"].ends_with("#1") and i < first_on_second:
				first_on_second = i
	_expect("heróis focam o primeiro inimigo até derrubá-lo", last_on_first < first_on_second)
	var enemy_targets := {}
	for e in events:
		if e["type"] == "enemy_attack":
			enemy_targets[e["target"]] = true
	_expect("inimigos só atacam o front enquanto ele vive", enemy_targets.size() == 1 and enemy_targets.has("hero_001"))

	# Front frágil: cai e o alvo passa para o mid (Íris, hero_003).
	var frail := ExpeditionRun.create(route, [_hero("hero_001", 5.0, 1.0), _hero("hero_002"), _hero("hero_003")], enemy_rows, {"seed": 3, "crits": false, "party_level": 1, "targeting": "front"})
	var ev2 := frail.run_to_end(0.25)
	var saw_mid := false
	var front_dead_at := -1.0
	for e in ev2:
		if e["type"] == "hero_defeated" and e["id"] == "hero_001":
			front_dead_at = e["time"]
		if e["type"] == "enemy_attack" and e["target"] == "hero_003":
			saw_mid = true
			_expect("o mid só é atacado depois da queda do front", front_dead_at >= 0.0 and e["time"] >= front_dead_at)
			break
	_expect("alvo passa do front para o mid", saw_mid)

func _test_hp_persists_and_end_states() -> void:
	print("\n>>> 4. HP PERSISTENTE, VITÓRIA E DERROTA")
	var route := _route([
		_enc("a", 1, [{"enemy_id": "en_c1_001", "count": 1}]),
		_enc("b", 1, [{"enemy_id": "en_c1_001", "count": 1}]),
	])
	var run := ExpeditionRun.create(route, [_hero("hero_001")], enemy_rows, {"seed": 1, "crits": false, "party_level": 1})
	var events := run.run_to_end(0.5)
	var cleared_a: Dictionary = {}
	var started_b: Dictionary = {}
	for e in events:
		if e["type"] == "encounter_cleared" and e["node_id"] == "a":
			cleared_a = e
		if e["type"] == "encounter_started" and e["node_id"] == "b":
			started_b = e
	_expect("HP do fim do encontro A é o HP do início do B", cleared_a["party_hp"]["hero_001"] == started_b["party_hp"]["hero_001"])
	_expect("sem cura entre encontros", started_b["party_hp"]["hero_001"] < 160.0)
	var starts := events.filter(func(e): return e["type"] == "encounter_started")
	_check("transição entre encontros", starts[1]["time"] - cleared_a["time"], 0.6)

	# Derrota: três heróis de 1 HP.
	var doomed := ExpeditionRun.create(route, [_hero("hero_001", 1.0, 1.0), _hero("hero_002", 1.0, 1.0), _hero("hero_003", 1.0, 1.0)], enemy_rows, {"seed": 1, "crits": false, "party_level": 1})
	var ev := doomed.run_to_end(0.5)
	_expect("derrota quando os três caem", doomed.state == "lost" and _count(ev, "expedition_lost") == 1 and _count(ev, "hero_defeated") == 3)
	_expect("sem reviver depois de cair", _count(ev, "encounter_started") == 1)
	_expect("run encerrada não gera mais eventos", doomed.step(10.0).is_empty())

	# Vitória.
	var strong := ExpeditionRun.create(route, [_hero("hero_001", 1000.0, 1000.0)], enemy_rows, {"seed": 1, "crits": false, "party_level": 1})
	var ev3 := strong.run_to_end(0.5)
	_expect("vitória ao limpar o último nó", strong.state == "won" and _count(ev3, "expedition_won") == 1 and _count(ev3, "encounter_cleared") == 2)

	# Evento na rota: emite event_reached e segue.
	var with_event := _route([
		_enc("a", 1, [{"enemy_id": "en_c1_001", "count": 1}]),
		{"type": "event", "id": "poco", "name": "Poço", "stage": 1},
		_enc("b", 1, [{"enemy_id": "en_c1_001", "count": 1}]),
	])
	var ev4 := ExpeditionRun.create(with_event, [_hero("hero_001", 1000.0, 1000.0)], enemy_rows, {"seed": 1, "crits": false, "party_level": 1}).run_to_end(0.5)
	_expect("evento emitido entre os encontros", _count(ev4, "event_reached") == 1 and _count(ev4, "encounter_cleared") == 2)

	# Membros adiados não lutam.
	var deferred := _route([_enc("d", 1, [{"enemy_id": "en_c1_001", "count": 1}, {"enemy_id": "en_c1_001", "count": 2, "deferred": true}])])
	var ev5 := ExpeditionRun.create(deferred, [_hero("hero_001", 1000.0, 1000.0)], enemy_rows, {"seed": 1, "crits": false, "party_level": 1}).run_to_end(0.5)
	_expect("membros adiados não lutam", _count(ev5, "enemy_defeated") == 1)

func _run_log(seed_value: int, crits: bool) -> String:
	var route: Dictionary = _load_json(ROUTE_PATH)
	var run := ExpeditionRun.create(route, hero_rows, enemy_rows, {"seed": seed_value, "crits": crits, "party_level": 3})
	return JSON.stringify(run.run_to_end(0.25))

func _test_determinism() -> void:
	print("\n>>> 5. DETERMINISMO")
	_expect("mesma seed, mesmo log de eventos", _run_log(7, true) == _run_log(7, true))
	_expect("sem crítico, a seed não altera o log", _run_log(1, false) == _run_log(2, false))
	var route: Dictionary = _load_json(ROUTE_PATH)
	var events := ExpeditionRun.create(route, hero_rows, enemy_rows, {"seed": 5, "crits": false, "party_level": 3}).run_to_end(0.25)
	var crits := events.filter(func(e): return e.get("crit", false))
	_expect("crits:false não produz críticos", crits.is_empty())
	var with_crits := ExpeditionRun.create(route, hero_rows, enemy_rows, {"seed": 5, "crits": true, "party_level": 3}).run_to_end(0.25)
	_expect("crits:true produz ao menos um crítico", not with_crits.filter(func(e): return e.get("crit", false)).is_empty())

func _test_step_size_independence() -> void:
	print("\n>>> 6. TAMANHO DO PASSO")
	var route: Dictionary = _load_json(ROUTE_PATH)
	var a := ExpeditionRun.create(route, hero_rows, enemy_rows, {"seed": 9, "crits": true, "party_level": 3}).run_to_end(0.05)
	var b := ExpeditionRun.create(route, hero_rows, enemy_rows, {"seed": 9, "crits": true, "party_level": 3}).run_to_end(5.0)
	_expect("passo pequeno e passo grande geram o mesmo log", JSON.stringify(a) == JSON.stringify(b))

# Relatório informativo: não afirma vitória no boss (o contrato prevê sobrevivência insuficiente sem skills).
func _report_full_route() -> void:
	print("\n>>> 7. RELATÓRIO DA ROTA (trio nu, sem skills, sem crítico, informativo)")
	var route: Dictionary = _load_json(ROUTE_PATH)
	for level in [1, 3, 5]:
		var run := ExpeditionRun.create(route, hero_rows, enemy_rows, {"seed": 1, "crits": false, "party_level": level})
		var events := run.run_to_end(0.25)
		var cleared := events.filter(func(e): return e["type"] == "encounter_cleared")
		var last: Dictionary = cleared[cleared.size() - 1] if not cleared.is_empty() else {}
		print("  nível %d: estado=%s, encontros limpos=%d, tempo=%.1f s" % [level, run.state, cleared.size(), run.time])
		for c in cleared:
			print("    %s duração %.1f s, HP restante %s" % [c["node_id"], c["duration"], _hp_text(c["party_hp"])])
		_expect("a run do nível %d termina" % level, run.state == "won" or run.state == "lost")
		if not last.is_empty() and run.state == "lost":
			print("    derrota depois de %d encontros" % cleared.size())

func _hp_text(hp: Dictionary) -> String:
	var parts: Array = []
	for k in hp.keys():
		parts.append("%s=%.0f" % [k, hp[k]])
	return ", ".join(parts)

