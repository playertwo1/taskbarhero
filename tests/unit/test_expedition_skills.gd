extends Node

const ROUTE_PATH := "res://data/expedition/route_c1.json"
const ENEMIES_PATH := "res://data/enemies/enemies.json"
const HEROES_PATH := "res://data/heroes/heroes.json"
const SKILLS_PATH := "res://data/skills/skills_slice.json"
const EPS := 0.001

# Golpes de Geleia (ATK 4,5, nível 1): 4,5 × (1 − DEF/(DEF+100)).
const GELEIA_ON_BASTIAO := 3.813559
const GELEIA_ON_FLECHA := 4.205607
const GELEIA_ON_IRIS := 4.245283

var success := true
var hero_rows: Array = []
var enemy_rows: Array = []
var skill_rows: Array = []

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE SKILLS, AMEAÇA E PROVOCAÇÃO (SLICE-1A-4a) ---")
	print("=======================================================")

	hero_rows = SliceStats.load_rows(HEROES_PATH, "slice")
	enemy_rows = SliceStats.load_rows(ENEMIES_PATH, "slice")
	skill_rows = SliceStats.load_rows(SKILLS_PATH, "slice")

	_test_threat_math()
	_test_skill_data()
	_test_first_target_by_threat()
	_test_threat_multiplier()
	_test_counter_stance()
	_test_fortaleza()
	_test_muralha()
	_test_desafio()
	_test_iris_heal_and_shield()
	_test_stat_buff()
	_test_determinism_with_skills()
	_report_builds()

	print("\n=======================================================")
	if success:
		print("[PASS] TESTE SKILLS CONCLUÍDO COM SUCESSO")
		get_tree().quit(0)
	else:
		print("[FAIL] TESTE SKILLS FALHOU")
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
	return null if f == null else JSON.parse_string(f.get_as_text())

func _hero(id: String, skills: Array = [], attack: float = -1.0) -> Dictionary:
	for r in hero_rows:
		if r["id"] == id:
			var copy: Dictionary = r.duplicate(true)
			# Contas à mão do 1A-3/1A-4a: sem Perfect Block e sem Stagger (testados em test_expedition_mechanics).
			copy.erase("perfect_block")
			copy.erase("basic_stagger")
			if attack > 0.0:
				copy["base_stats"]["attack"] = [attack, attack]
			copy["builds"] = {"t": {"name": "teste", "skills": skills}}
			return copy
	return {}

func _route(members: Array) -> Dictionary:
	return {"transition_seconds": 0.6, "nodes": [{"type": "encounter", "id": "n", "kind": "NORMAL", "stage": 1, "level": 1, "members": members}]}

func _run(heroes: Array, members: Array, builds: Dictionary = {}, extra_skills: Array = [], targeting: String = "threat") -> ExpeditionRun:
	return ExpeditionRun.create(_route(members), heroes, enemy_rows, {
		"seed": 1, "crits": false, "party_level": 1, "builds": builds, "targeting": targeting, "skills": skill_rows + extra_skills,
	})

## Elemento do array ou {} (com falha explícita), para um índice ausente não passar em silêncio.
func _elem(arr: Array, i: int, label: String) -> Dictionary:
	if i < arr.size():
		return arr[i]
	_fail("faltou o elemento %d de %s" % [i, label])
	return {}

func _of(events: Array, type: String) -> Array:
	return events.filter(func(e): return e["type"] == type)

func _test_threat_math() -> void:
	print("\n>>> 1. ESCOLHA DE ALVO POR AMEAÇA")
	var order := ["a", "b", "c"]
	var alive := {"a": true, "b": true, "c": true}
	_expect("sem ameaça e sem alvo: o front", ThreatMath.pick_target({}, "", order, alive) == "a")
	_expect("sem ameaça: mantém o alvo atual vivo", ThreatMath.pick_target({}, "b", order, alive) == "b")
	_expect("114 contra 100 (menos de 15%): mantém", ThreatMath.pick_target({"a": 100.0, "b": 114.0}, "a", order, alive) == "a")
	_expect("116 contra 100 (mais de 15%): troca", ThreatMath.pick_target({"a": 100.0, "b": 116.0}, "a", order, alive) == "b")
	_expect("alvo atual morto: vai para a maior ameaça", ThreatMath.pick_target({"a": 100.0, "b": 50.0}, "a", order, {"a": false, "b": true, "c": true}) == "b")
	_expect("provocação vence a tabela", ThreatMath.pick_target({"a": 100.0}, "a", order, alive, "c") == "c")
	_expect("provocador morto: a tabela decide", ThreatMath.pick_target({"a": 100.0}, "a", order, {"a": true, "b": true, "c": false}, "c") == "a")
	_expect("empate de ameaça: o primeiro da ordem", ThreatMath.pick_target({"a": 5.0, "b": 5.0}, "", order, alive) == "a")
	_expect("todos mortos: sem alvo", ThreatMath.pick_target({"a": 1.0}, "a", order, {"a": false, "b": false, "c": false}) == "")

func _test_skill_data() -> void:
	print("\n>>> 2. DADOS DAS SKILLS DO BASTIÃO")
	var by_id := {}
	for s in skill_rows:
		by_id[s["id"]] = s
	_expect("13 skills do trio, incluindo cura experimental", skill_rows.size() == 13)
	for s in skill_rows:
		if s["status"] != "HIPOTESE" or s["content_set"] != "slice":
			_fail("skill sem status HIPOTESE ou fora do slice: %s" % s["id"])
	_check("Muralha Viva: cooldown", by_id["skill_bas_006"]["cooldown"], 14.0)
	_check("Muralha Viva: duração", by_id["skill_bas_006"]["effects"][0]["duration"], 6.0)
	_check("Muralha Viva: redução (v0.5)", by_id["skill_bas_006"]["effects"][0]["value"], -0.5)
	_check("Contra-Golpe: cooldown", by_id["skill_bas_007"]["cooldown"], 8.0)
	_check("Contra-Golpe: coeficiente", by_id["skill_bas_007"]["effects"][0]["counter_coefficient"], 1.8)
	_check("Desafio: cooldown", by_id["skill_bas_008"]["cooldown"], 15.0)
	_check("Desafio: duração", by_id["skill_bas_008"]["effects"][0]["duration"], 4.0)
	_check("Desafio: dano a aliados", by_id["skill_bas_008"]["effects"][0]["ally_damage_multiplier"], 0.85)
	_check("Fortaleza: cooldown (v0.5)", by_id["skill_bas_009"]["cooldown"], 16.0)
	_check("Fortaleza: duração", by_id["skill_bas_009"]["effects"][0]["duration"], 5.0)
	var bastiao: Dictionary = {}
	for r in hero_rows:
		if r["id"] == "hero_001":
			bastiao = r
	_expect("build Guardião: Muralha Viva e Fortaleza", bastiao["builds"]["guardiao"]["skills"] == ["skill_bas_006", "skill_bas_009"])
	_expect("build Retaliação: Contra-Golpe e Desafio", bastiao["builds"]["retaliacao"]["skills"] == ["skill_bas_007", "skill_bas_008"])
	for build in bastiao["builds"].values():
		for id in build["skills"]:
			if not by_id.has(id):
				_fail("build aponta para skill inexistente: %s" % id)
	for hero in hero_rows:
		for build in hero.get("builds", {}).values():
			_expect("loadout de duas skills: %s" % build["name"], build["skills"].size() == 2)
			for id in build["skills"]:
				_expect("skill existente: %s" % id, by_id.has(id))

func _test_iris_heal_and_shield() -> void:
	var iris := _hero("hero_003", ["skill_iri_004", "skill_iri_002"], 15.0)
	var run := _run([iris], [{"enemy_id": "en_c1_001", "count": 3}], {"hero_003": "t"})
	var events := run.run_to_end(0.25)
	var heals := _of(events, "healing")
	var shields := _of(events, "shield_granted")
	_expect("Íris conjura cura durante o combate", not heals.is_empty())
	_expect("Íris cria escudo temporário", not shields.is_empty())
	for e in heals:
		_expect("cura respeita HP máximo", float(e["amount"]) <= 30.0 + EPS)
	var absorb := _of(events, "shield_absorbed")
	_expect("escudo absorve dano sem curar HP entre encontros", not absorb.is_empty())

# Buff FLAT de ATK entra no golpe básico: (14 + 10) × (1 − 6,75/106,75) = 22,4824.
func _test_stat_buff() -> void:
	print("
>>> BUFF DE STATUS NO ATAQUE")
	var buff := {"id": "t_buff", "hero": "hero_002", "cooldown": 99.0, "trigger": {"type": "enemies_alive"},
		"effects": [{"type": "buff", "stat": "attack", "op": "FLAT", "value": 10.0, "duration": 30.0, "targets": "self"}]}
	var flecha := _hero("hero_002", ["t_buff"], 14.0)
	var run := _run([flecha], [{"enemy_id": "en_c1_001", "count": 1}], {"hero_002": "t"}, [buff])
	var hits := _of(run.run_to_end(0.25), "hero_attack")
	_check("golpe com buff de ATK", float(_elem(hits, 0, "hero_attack").get("damage", 0.0)), 22.4824)

# Flecha bate primeiro (t = 0,8333), e a Geleia ataca em t = 1,0: só a Flecha tem ameaça.
func _test_first_target_by_threat() -> void:
	print("\n>>> 3. PRIMEIRO ALVO")
	var trio := [_hero("hero_001"), _hero("hero_002"), _hero("hero_003")]
	var by_threat := _run(trio, [{"enemy_id": "en_c1_001", "count": 1}]).run_to_end(0.25)
	_expect("por ameaça, o primeiro golpe vai para a Flecha", _elem(_of(by_threat, "enemy_attack"), 0, "enemy_attack").get("target", "") == "hero_002")
	var by_front := _run(trio, [{"enemy_id": "en_c1_001", "count": 1}], {}, [], "front").run_to_end(0.25)
	_expect("com front-first, o primeiro golpe vai para o Bastião", _elem(_of(by_front, "enemy_attack"), 0, "enemy_attack").get("target", "") == "hero_001")

func _test_threat_multiplier() -> void:
	print("\n>>> 4. MULTIPLICADOR DE AMEAÇA DO BASTIÃO")
	var members := [{"enemy_id": "en_c1_001", "count": 1}]
	var plain := _run([_hero("hero_001")], members)
	plain.step(1.3)
	var t_plain: float = plain.snapshot()["enemies"][0]["threat"]["hero_001"]
	_check("sem efeito defensivo: 1,0 × dano (9,3677)", t_plain, 9.36774)
	var shield_skill := {"id": "skill_test", "hero": "hero_001", "cooldown": 100.0, "trigger": {"type": "enemies_alive"},
		"effects": [{"type": "buff", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -0.1, "duration": 100.0, "targets": "self", "defensive": true}]}
	var with_effect := _run([_hero("hero_001", ["skill_test"])], members, {"hero_001": "t"}, [shield_skill])
	with_effect.step(1.3)
	var t_effect: float = with_effect.snapshot()["enemies"][0]["threat"]["hero_001"]
	_check("com efeito defensivo ativo: 1,5 × dano", t_effect, 9.36774 * 1.5)

func _test_counter_stance() -> void:
	print("
>>> 5. CONTRA-GOLPE")
	var run := _run([_hero("hero_001", ["skill_bas_007"])], [{"enemy_id": "en_c1_001", "count": 1}], {"hero_001": "t"})
	var events := run.run_to_end(0.25)
	var casts := _of(events, "skill_cast")
	var attacks := _of(events, "enemy_attack")
	var counters := _of(events, "counter_attack")
	_check("primeira postura em t = 0", _elem(casts, 0, "skill_cast").get("time", -1.0), 0.0)
	_check("segunda postura em t = 8 (cooldown)", _elem(casts, 1, "skill_cast").get("time", -1.0), 8.0)
	_check("golpe recebido na postura: 3,8136 × 0,3", _elem(attacks, 0, "enemy_attack").get("damage", -1.0), GELEIA_ON_BASTIAO * 0.3)
	_check("contra-ataque: 18 contra a defesa da Geleia", _elem(counters, 0, "counter_attack").get("damage", -1.0), 18.0 * (1.0 - 6.75 / 106.75))
	_check("o contra-ataque acontece no mesmo instante do golpe", _elem(counters, 0, "counter_attack").get("time", -1.0), _elem(attacks, 0, "enemy_attack").get("time", -2.0))
	# O revide aplica Desequilíbrio (CHAPTER_01_HERO_COMBAT_PROPOSAL.md): −10% no golpe seguinte.
	_check("sem postura, o golpe seguinte só tem o Desequilíbrio (× 0,9)", _elem(attacks, 1, "enemy_attack").get("damage", -1.0), GELEIA_ON_BASTIAO * 0.9)
	# A segunda postura abre em t = 8,0 e já absorve o golpe desse mesmo instante (a skill vem antes do ataque).
	var at_eight := attacks.filter(func(e): return absf(e["time"] - 8.0) < 0.0001)
	_check("a segunda postura reduz o golpe de t = 8", _elem(at_eight, 0, "enemy_attack em t=8").get("damage", -1.0), GELEIA_ON_BASTIAO * 0.3)
	_expect("um contra-ataque por postura", counters.size() == 2 and absf(float(_elem(counters, 1, "counter_attack").get("time", -1.0)) - 8.0) < 0.0001)
	# Os dois contra-ataques (16,86 cada) + 8 golpes básicos derrubam a Geleia em t = 8,75.
	var defeated := _of(events, "enemy_defeated")
	_check("Geleia derrotada em t = 8,75", _elem(defeated, 0, "enemy_defeated").get("time", -1.0), 8.75)

func _test_fortaleza() -> void:
	print("\n>>> 6. FORTALEZA")
	var run := _run([_hero("hero_001", ["skill_bas_009"])], [{"enemy_id": "en_c1_001", "count": 3}], {"hero_001": "t"})
	var events := run.run_to_end(0.25)
	var hp := 160.0
	var cast_time := -1.0
	var trigger_time := -1.0
	for e in events:
		if e["type"] == "enemy_attack":
			hp -= e["damage"]
			if trigger_time < 0.0 and hp <= 112.0:
				trigger_time = e["time"]
		if e["type"] == "skill_cast" and cast_time < 0.0:
			cast_time = e["time"]
	_expect("Fortaleza dispara quando o HP chega a 70%", cast_time >= 0.0 and absf(cast_time - trigger_time) < 0.0001)
	var seen_reduced := 0
	var seen_full_after := 0
	var after_cast := false
	for e in events:
		if e["type"] == "skill_cast" and absf(e["time"] - cast_time) < 0.0001:
			after_cast = true
			continue
		if after_cast and e["type"] == "enemy_attack":
			if e["time"] < cast_time + 5.0 - 0.0001:
				seen_reduced += 1
				if absf(e["damage"] - GELEIA_ON_BASTIAO * 0.5) > EPS:
					_fail("golpe dentro da janela deveria ser ×0,5: %.4f em t=%.2f" % [e["damage"], e["time"]])
			elif e["time"] < cast_time + 16.0 - 0.0001 and absf(e["damage"] - GELEIA_ON_BASTIAO) <= EPS:
				seen_full_after += 1
	_expect("houve golpes reduzidos durante os 5 s", seen_reduced > 0)
	_expect("depois dos 5 s o dano volta ao normal", seen_full_after > 0)
	var casts := _of(events, "skill_cast")
	_expect("sem nova Fortaleza antes de 16 s", casts.size() == 1 or casts[1]["time"] >= cast_time + 16.0 - 0.0001)

func _behind_setup(skill_ids: Array) -> ExpeditionRun:
	var trio := [_hero("hero_001", skill_ids, 1.0), _hero("hero_002"), _hero("hero_003")]
	return _run(trio, [{"enemy_id": "en_c1_001", "count": 3}], {"hero_001": "t"})

func _test_muralha() -> void:
	print("\n>>> 7. MURALHA VIVA")
	var events := _behind_setup(["skill_bas_006"]).run_to_end(0.25)
	var casts := _of(events, "skill_cast")
	_expect("a Muralha Viva foi usada", casts.size() >= 1)
	if casts.is_empty():
		return
	var cast_time: float = casts[0]["time"]
	var behind_hit := 0
	var checked_front := 0
	var idx_cast := events.find(casts[0])
	for i in range(idx_cast + 1, events.size()):
		var e: Dictionary = events[i]
		if e["type"] != "enemy_attack" or e["time"] >= cast_time + 6.0 - 0.0001:
			continue
		if e["target"] == "hero_002":
			behind_hit += 1
			if absf(e["damage"] - GELEIA_ON_FLECHA * 0.5) > EPS:
				_fail("aliado atrás (Flecha) deveria receber ×0,5: %.4f" % e["damage"])
		elif e["target"] == "hero_003":
			behind_hit += 1
			if absf(e["damage"] - GELEIA_ON_IRIS * 0.5) > EPS:
				_fail("aliado atrás (Íris) deveria receber ×0,5: %.4f" % e["damage"])
		elif e["target"] == "hero_001":
			checked_front += 1
			if absf(e["damage"] - GELEIA_ON_BASTIAO) > EPS:
				_fail("o Bastião não é protegido pela Muralha: %.4f" % e["damage"])
	_expect("aliados atrás foram atingidos dentro da janela", behind_hit > 0)
	var later := events.filter(func(e): return e["type"] == "enemy_attack" and e["time"] >= cast_time + 6.0 and e["target"] == "hero_002")
	if not later.is_empty():
		_check("depois de 6 s a Flecha volta a receber o golpe integral", later[0]["damage"], GELEIA_ON_FLECHA)

func _test_desafio() -> void:
	print("\n>>> 8. DESAFIO")
	var events := _behind_setup(["skill_bas_008"]).run_to_end(0.25)
	var casts := _of(events, "skill_cast")
	_expect("o Desafio foi usado", casts.size() >= 1)
	if casts.is_empty():
		return
	var cast_time: float = casts[0]["time"]
	var idx_cast := events.find(casts[0])
	var forced := 0
	for i in range(idx_cast + 1, events.size()):
		var e: Dictionary = events[i]
		if e["type"] == "enemy_attack" and e["time"] < cast_time + 4.0 - 0.0001:
			forced += 1
			if e["target"] != "hero_001":
				_fail("durante a provocação todos atacam o Bastião: alvo %s em t=%.2f" % [e["target"], e["time"]])
	_expect("houve ataques durante a provocação", forced > 0)
	var recasts := casts.filter(func(e): return e["time"] < cast_time + 15.0 - 0.0001)
	_expect("sem novo Desafio antes de 15 s", recasts.size() == 1)

func _full_log(build: String, seed_value: int) -> String:
	var route: Dictionary = _load_json(ROUTE_PATH)
	var run := ExpeditionRun.create(route, hero_rows, enemy_rows, {
		"seed": seed_value, "crits": true, "party_level": 3, "builds": {"hero_001": build}, "skills": skill_rows,
	})
	return JSON.stringify(run.run_to_end(0.25))

func _test_determinism_with_skills() -> void:
	print("\n>>> 9. DETERMINISMO COM SKILLS")
	_expect("mesma seed, mesmo log (Guardião)", _full_log("guardiao", 4) == _full_log("guardiao", 4))
	_expect("mesma seed, mesmo log (Retaliação)", _full_log("retaliacao", 4) == _full_log("retaliacao", 4))
	var route: Dictionary = _load_json(ROUTE_PATH)
	var opts := {"seed": 9, "crits": true, "party_level": 3, "builds": {"hero_001": "guardiao"}, "skills": skill_rows}
	var a := ExpeditionRun.create(route, hero_rows, enemy_rows, opts).run_to_end(0.05)
	var b := ExpeditionRun.create(route, hero_rows, enemy_rows, opts).run_to_end(5.0)
	_expect("passo pequeno e passo grande geram o mesmo log", JSON.stringify(a) == JSON.stringify(b))

# Informativo: não afirma vitória. Só Bastião tem skills; Flecha e Íris usam o ataque básico.
func _report_builds() -> void:
	print("\n>>> 10. RELATÓRIO POR BUILD (rota inteira, sem crítico, informativo)")
	var route: Dictionary = _load_json(ROUTE_PATH)
	for build in ["", "guardiao", "retaliacao"]:
		for level in [1, 3, 5]:
			var builds := {} if build == "" else {"hero_001": build}
			var run := ExpeditionRun.create(route, hero_rows, enemy_rows, {
				"seed": 1, "crits": false, "party_level": level, "builds": builds, "skills": skill_rows,
			})
			var events := run.run_to_end(0.25)
			var cleared := _of(events, "encounter_cleared")
			var casts := _of(events, "skill_cast")
			var label: String = "sem skills" if build == "" else build
			print("  %-10s nível %d: %s, encontros limpos=%d, tempo=%.1f s, skills usadas=%d" % [label, level, run.state, cleared.size(), run.time, casts.size()])
			_expect("a run (%s, nível %d) termina" % [label, level], run.state == "won" or run.state == "lost")
