extends Node

## SLICE-1A-4b/1C: Perfect Block, Desequilíbrio, Stagger, golpe telegrafado, fases, ranks e XP.
## Valores esperados calculados à mão com os dados HIPÓTESE de combat_profiles.json.

const ENEMIES_PATH := "res://data/enemies/enemies.json"
const HEROES_PATH := "res://data/heroes/heroes.json"
const SKILLS_PATH := "res://data/skills/skills_slice.json"
const ROUTE_PATH := "res://data/expedition/route_c1.json"
const EPS := 0.001

# Golpe da Geleia (ATK 4,5, nível 1) em Bastião: 4,5 × (1 − 18/118).
const GELEIA_ON_BASTIAO := 3.813559
# Golpe de Bastião (ATK 10) na Geleia (DEF 6,75): 10 × (1 − 6,75/106,75).
const BASTIAO_ON_GELEIA := 9.367681

var success := true
var hero_rows: Array = []
var enemy_rows: Array = []
var skill_rows: Array = []

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE MECÂNICAS DA EXPEDIÇÃO (SLICE-1A-4b/1C) ---")
	print("=======================================================")
	hero_rows = SliceStats.load_rows(HEROES_PATH, "slice")
	enemy_rows = SliceStats.load_rows(ENEMIES_PATH, "slice")
	skill_rows = SliceStats.load_rows(SKILLS_PATH, "slice")

	_test_perfect_block()
	_test_stagger_break()
	_test_telegraph_and_counter()
	_test_phase_spawn()
	_test_skill_ranks()
	_test_prepared_targets()
	_test_heal_threat()
	_test_xp()
	_test_determinism()

	print("\n=======================================================")
	if success:
		print("[PASS] TESTE MECÂNICAS CONCLUÍDO COM SUCESSO")
		get_tree().quit(0)
	else:
		print("[FAIL] TESTE MECÂNICAS FALHOU")
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

func _of(events: Array, type: String) -> Array:
	return events.filter(func(e): return e["type"] == type)

func _at(events: Array, t: float) -> Dictionary:
	for e in events:
		if absf(float(e["time"]) - t) <= EPS:
			return e
	_fail("nenhum evento em t=%.2f" % t)
	return {"damage": -1.0}

## Bastião com HP alto; pb/stagger controlam as mecânicas próprias.
func _bastiao(pb_stagger: float = -1.0, basic_stagger: float = 0.0, skills: Array = []) -> Dictionary:
	for r in hero_rows:
		if r["id"] == "hero_001":
			var copy: Dictionary = r.duplicate(true)
			copy["base_stats"]["max_hp"] = [5000.0, 5000.0]
			copy["basic_stagger"] = basic_stagger
			if pb_stagger < 0.0:
				copy.erase("perfect_block")
			else:
				copy["perfect_block"]["stagger"] = pb_stagger
			copy["builds"] = {"t": {"name": "teste", "skills": skills}}
			return copy
	return {}

func _enemy_variant(base_id: String, new_id: String, mechanics: Dictionary) -> Dictionary:
	for r in enemy_rows:
		if r["id"] == base_id:
			var copy: Dictionary = r.duplicate(true)
			copy["id"] = new_id
			copy["mechanics"] = mechanics
			return copy
	return {}

func _route(members: Array) -> Dictionary:
	return {"transition_seconds": 0.6, "nodes": [{"type": "encounter", "id": "n", "kind": "NORMAL", "stage": 1, "level": 1, "members": members}]}

func _run(heroes: Array, members: Array, enemies: Array = [], options: Dictionary = {}) -> ExpeditionRun:
	var opts := {"seed": 1, "crits": false, "party_level": 1, "skills": skill_rows}
	opts.merge(options, true)
	return ExpeditionRun.create(_route(members), heroes, enemy_rows + enemies, opts)

# Geleia ataca em t = 1, 2, 3...; guarda pronta no início, recarga de 8 s.
func _test_perfect_block() -> void:
	print("\n>>> 1. PERFECT BLOCK E DESEQUILÍBRIO")
	var events := _run([_bastiao(0.0)], [{"enemy_id": "en_c1_001", "count": 1}]).run_to_end(0.25)
	var blocks := _of(events, "perfect_block")
	var hits := _of(events, "enemy_attack")
	_expect("dois Perfect Blocks (t = 1 e t = 9)", blocks.size() == 2 and absf(float(blocks[0]["time"]) - 1.0) < EPS and absf(float(blocks[1]["time"]) - 9.0) < EPS)
	_check("golpe bloqueado: max(1, 3,8136 × 0,2) — dano mínimo 1", float(_at(hits, 1.0)["damage"]), 1.0)
	_check("Desequilíbrio: golpe seguinte × 0,9", float(_at(hits, 2.0)["damage"]), GELEIA_ON_BASTIAO * 0.9)
	_check("depois dos 4 s o golpe é integral", float(_at(hits, 6.0)["damage"]), GELEIA_ON_BASTIAO)

# Stagger 50 por golpe contra postura 100: quebra no 2º golpe (t = 2,5) por 2 s, vulnerável +15%.
func _test_stagger_break() -> void:
	print("\n>>> 2. STAGGER E QUEBRA")
	var events := _run([_bastiao(-1.0, 50.0)], [{"enemy_id": "en_c1_001", "count": 1}]).run_to_end(0.25)
	var breaks := _of(events, "enemy_staggered")
	_expect("quebra no 2º golpe (t = 2,5)", breaks.size() >= 1 and absf(float(breaks[0]["time"]) - 2.5) < EPS)
	_expect("imunidade de 2 s impede quebra em cadeia; 2ª quebra em t = 8,75", breaks.size() == 2 and absf(float(breaks[1]["time"]) - 8.75) < EPS)
	var hits := _of(events, "hero_attack")
	_check("golpe na quebra: 9,3677 × 1,15", float(_at(hits, 3.75)["damage"]), BASTIAO_ON_GELEIA * 1.15)
	_check("fora da quebra o golpe é normal", float(_at(hits, 5.0)["damage"]), BASTIAO_ON_GELEIA)
	var enemy_times: Array = _of(events, "enemy_attack").map(func(e): return snappedf(float(e["time"]), 0.01))
	_expect("a Geleia não ataca durante a quebra (1, 2, 4,5...)", enemy_times.slice(0, 3) == [1.0, 2.0, 4.5])

# Golpe a cada 3 ataques: ataques em 1 e 2, telegraph em 3, golpe ×2,2 em 4,5.
func _test_telegraph_and_counter() -> void:
	print("\n>>> 3. GOLPE TELEGRAFADO E RESPOSTA")
	var mech := {"telegraph": {"id": "t", "every": 3, "windup": 1.5, "coefficient": 2.2, "exposed_duration": 3.0, "exposed_vulnerability": 0.15}}
	var tele := _enemy_variant("en_c1_001", "t_tele", mech)
	var events := _run([_bastiao()], [{"enemy_id": "t_tele", "count": 1}], [tele]).run_to_end(0.25)
	var starts := _of(events, "telegraph_started")
	_expect("telegraph começa em t = 3", not starts.is_empty() and absf(float(starts[0]["time"]) - 3.0) < EPS)
	var heavy := _at(_of(events, "enemy_attack"), 4.5)
	_check("golpe pesado sem resposta: 3,8136 × 2,2", float(heavy["damage"]), GELEIA_ON_BASTIAO * 2.2)
	_expect("ciclo reinicia: ataque comum em 5,5", not _at(_of(events, "enemy_attack"), 5.5).get("heavy", true))

	var countered := _run([_bastiao(-1.0, 0.0, ["skill_bas_007"])], [{"enemy_id": "t_tele", "count": 1}], [tele],
		{"builds": {"hero_001": "t"}, "trigger_overrides": {"skill_bas_007": {"type": "enemy_telegraph"}}}).run_to_end(0.25)
	var casts := _of(countered, "skill_cast")
	_expect("Contra-Golpe só conjura no telegraph (t = 3)", not casts.is_empty() and absf(float(casts[0]["time"]) - 3.0) < EPS)
	_check("golpe pesado na postura: × 0,3", float(_at(_of(countered, "enemy_attack"), 4.5)["damage"]), GELEIA_ON_BASTIAO * 2.2 * 0.3)
	_expect("golpe pesado respondido expõe o inimigo", not _of(countered, "enemy_exposed").is_empty())

func _test_phase_spawn() -> void:
	print("\n>>> 4. FASE COM ADD ADIADO")
	var queen := _enemy_variant("en_c1_004", "t_queen", {"phases": [{"hp_below": 0.5, "spawn_deferred": true}]})
	var events := _run([_bastiao()], [{"enemy_id": "t_queen", "count": 1}, {"enemy_id": "en_c1_001", "count": 2, "deferred": true}], [queen]).run_to_end(0.25)
	var spawned := _of(events, "enemy_spawned")
	var phase := _of(events, "boss_phase")
	_expect("2 adds surgem na fase 2", spawned.size() == 2 and phase.size() == 1)
	_expect("adds surgem no instante da fase", not spawned.is_empty() and absf(float(spawned[0]["time"]) - float(phase[0]["time"])) < EPS)
	var after: Array = _of(events, "hero_attack").filter(func(e): return float(e["time"]) > float(phase[0]["time"]) + EPS)
	_expect("Bastião passa a bater no add", not after.is_empty() and String(after[0]["target"]).begins_with("en_c1_001"))
	_expect("encontro só termina com todos derrotados", _of(events, "enemy_defeated").size() == 3 and _of(events, "expedition_won").size() == 1)

func _skill(id: String) -> Dictionary:
	for s in skill_rows:
		if s["id"] == id:
			return s
	return {}

## Ranks R2–R5 vêm de skills_slice.json (CHAPTER_01_HERO_COMBAT_PROPOSAL.md).
func _test_skill_ranks() -> void:
	print("
>>> 5. RANKS DE SKILL")
	var profiles := SliceStats.load_profiles()
	var arrow := _skill("skill_fle_007")
	var r1 := ExpeditionRun.ranked_skill(arrow, 1, profiles)
	var r2 := ExpeditionRun.ranked_skill(arrow, 2, profiles)
	var r3 := ExpeditionRun.ranked_skill(arrow, 3, profiles)
	var r9 := ExpeditionRun.ranked_skill(arrow, 9, profiles)
	_expect("R1 = dados base, sem terceiro alvo", not r1["effects"][0].has("third_coefficient") and not r1.has("ranks"))
	_check("R2: terceiro alvo 0,40×ATK", float(r2["effects"][0].get("third_coefficient", 0.0)), 0.40)
	_check("R3 acumula R2 e +20% de Stagger no marcado", float(r3["effects"][0].get("stagger_bonus_vs_marked", 0.0)) + float(r3["effects"][0].get("third_coefficient", 0.0)), 0.60)
	_expect("R5 adiciona o segundo disparo contra marcado; rank acima de 5 vira 5", int(r9["rank"]) == 5 and r9["effects"].size() == 2)
	_check("coeficiente principal não muda com rank", float(r9["effects"][0]["coefficient"]), 1.45)
	_expect("dados originais não mudam", not arrow["effects"][0].has("third_coefficient"))
	var counter := ExpeditionRun.ranked_skill(_skill("skill_bas_007"), 5, profiles)
	_check("Contra-Golpe R2+: revide 2,16×ATK", float(counter["effects"][0]["counter_coefficient"]), 2.16)
	_check("Contra-Golpe R4+: atordoamento 0,5 s", float(counter["effects"][0].get("stun", 0.0)), 0.5)

# Marca R3 (+10% da Flecha no marcado) e Prisma disparando por Desequilíbrio.
func _test_prepared_targets() -> void:
	print("
>>> 5b. ALVO PREPARADO")
	var profiles := SliceStats.load_profiles()
	var mark := ExpeditionRun.ranked_skill(_skill("skill_fle_006"), 3, profiles)
	var flecha: Dictionary = {}
	for r in hero_rows:
		if r["id"] == "hero_002":
			flecha = r.duplicate(true)
	flecha["base_stats"]["max_hp"] = [5000.0, 5000.0]
	flecha["crit_chance"] = 0.0
	flecha["builds"] = {"t": {"name": "t", "skills": ["m3"]}}
	mark["id"] = "m3"
	var events := _run([flecha], [{"enemy_id": "en_c1_001", "count": 1}], [], {"builds": {"hero_002": "t"}, "skills": skill_rows + [mark]}).run_to_end(0.25)
	var hits := _of(events, "hero_attack")
	# Flecha ATK 14 × 1,10 contra DEF 6,75: 14 × 1,1 × 0,936768.
	_check("Flecha +10% no alvo que ela marcou", float(hits[0]["damage"]) if not hits.is_empty() else -1.0, 14.0 * 1.1 * 0.936768)
	var bast := _bastiao(0.0, 0.0)
	var iris: Dictionary = {}
	for r in hero_rows:
		if r["id"] == "hero_003":
			iris = r.duplicate(true)
	iris["base_stats"]["attack"] = [0.001, 0.001]
	iris["builds"] = {"t": {"name": "t", "skills": ["skill_iri_005"]}}
	var run := _run([bast, iris], [{"enemy_id": "en_c1_004", "count": 1}], [], {"builds": {"hero_003": "t"}, "formation": {"front": "hero_001", "mid": "hero_003"}})
	var ev := run.run_to_end(0.25)
	var imb := _of(ev, "enemy_imbalanced")
	var prism := _of(ev, "skill_cast")
	_expect("Prisma dispara logo após o Desequilíbrio do Perfect Block", not imb.is_empty() and not prism.is_empty() and absf(float(prism[0]["time"]) - float(imb[0]["time"])) < EPS)

# THREAT_AGGRO_SYSTEM seção 3: cura efetiva gera 0,5 de ameaça em todos os inimigos.
func _test_heal_threat() -> void:
	print("
>>> 5c. AMEAÇA DE CURA")
	var iris: Dictionary = {}
	for r in hero_rows:
		if r["id"] == "hero_003":
			iris = r.duplicate(true)
	iris["base_stats"]["attack"] = [0.001, 0.001]
	iris["builds"] = {"t": {"name": "t", "skills": ["skill_iri_004"]}}
	var bast := _bastiao()
	bast["base_stats"]["max_hp"] = [160.0, 160.0]
	var run := _run([bast, iris], [{"enemy_id": "en_c1_001", "count": 1}], [], {"builds": {"hero_003": "t"}, "formation": {"front": "hero_001", "mid": "hero_003"}})
	var healed := 0.0
	var iris_damage := 0.0
	var threat := -1.0
	while run.state == "fighting" and healed <= 0.0:
		for e in run.step(0.25):
			if e["type"] == "healing":
				healed += float(e["amount"])
			elif e["type"] == "hero_attack" and e["source"] == "hero_003":
				iris_damage += float(e["damage"])
		var enemies: Array = run.snapshot()["enemies"]
		if not enemies.is_empty():
			threat = float(enemies[0]["threat"].get("hero_003", 0.0))
	_expect("houve cura efetiva", healed > 0.0)
	_check("ameaça da Íris = dano + 0,5 × cura", threat, iris_damage + 0.5 * healed)

func _test_xp() -> void:
	print("\n>>> 6. XP")
	var profiles := SliceStats.load_profiles()
	var events := _run([_bastiao()], [{"enemy_id": "en_c1_001", "count": 2}]).run_to_end(0.25)
	var total := 0
	for e in _of(events, "enemy_defeated"):
		total += int(e["xp"])
	_expect("2 Geleias rendem 12 XP", total == 12)
	_expect("curva: nível 1 → 2 custa 30", ExpeditionRun.xp_to_next(1, profiles) == 30)
	_expect("curva: nível 5 → 6 custa 69", ExpeditionRun.xp_to_next(5, profiles) == 69)

func _full_log(seed_value: int, dt: float) -> String:
	var route: Dictionary = JSON.parse_string(FileAccess.open(ROUTE_PATH, FileAccess.READ).get_as_text())
	var run := ExpeditionRun.create(route, hero_rows, enemy_rows, {
		"seed": seed_value, "crits": true, "party_level": 5, "skills": skill_rows,
		"builds": {"hero_001": "retaliacao", "hero_002": "marca", "hero_003": "controle"},
	})
	return JSON.stringify(run.run_to_end(dt))

func _test_determinism() -> void:
	print("\n>>> 7. DETERMINISMO COM AS MECÂNICAS")
	_expect("mesma seed, mesmo log", _full_log(3, 0.25) == _full_log(3, 0.25))
	_expect("log independe do passo", _full_log(3, 0.05) == _full_log(3, 5.0))
