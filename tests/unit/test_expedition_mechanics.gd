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
	BalanceProfiles.pin_test_units()  # números conferidos à mão em unidades 1× e curva linear
	print("\n=======================================================")
	print("--- TESTE MECÂNICAS DA EXPEDIÇÃO (SLICE-1A-4b/1C) ---")
	print("=======================================================")
	hero_rows = SliceStats.load_rows(HEROES_PATH, "slice")
	# Estes testes medem mecânicas isoladas: sem a Signature (3º slot) que os kits completos acrescentam.
	for hero_row in hero_rows:
		hero_row.erase("signature")
	enemy_rows = SliceStats.load_rows(ENEMIES_PATH, "slice")
	skill_rows = SliceStats.load_rows(SKILLS_PATH, "slice")

	_test_perfect_block()
	_test_stagger_break()
	_test_telegraph_and_counter()
	_test_phase_spawn()
	_test_queen_add_waves()
	_test_guardian_memory_fragments()
	_test_skill_ranks()
	_test_prepared_targets()
	_test_heal_threat()
	_test_passives()
	_test_slice_passives_1a4()
	_test_flecha_passives_v2()
	_test_skill_ranks_v2()
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

func _test_queen_add_waves() -> void:
	print("\n>>> 4a. DUAS ONDAS DA RAINHA DAS GELEIAS")
	var queen: Dictionary = {}
	for row in enemy_rows:
		if String(row["id"]) == "mb_c1_001":
			queen = row.duplicate(true)
			queen["id"] = "t_queen"
			break
	var events := _run([_bastiao()], [
		{"enemy_id": "t_queen", "count": 1},
		{"enemy_id": "en_c1_001", "count": 2, "deferred": true},
	], [queen]).run_to_end(0.25)
	var phases := _of(events, "boss_phase")
	var spawns := _of(events, "enemy_spawned")
	var first_add_defeated_at := INF
	for event in _of(events, "enemy_defeated"):
		if String(event["id"]) == "en_c1_001":
			first_add_defeated_at = minf(first_add_defeated_at, float(event["time"]))
	_expect("a Rainha atravessa suas duas fases", phases.size() == 2)
	_expect("um add surge em cada limiar", spawns.size() == 2 and phases.size() == 2 and absf(float(spawns[0]["time"]) - float(phases[0]["time"])) < EPS and absf(float(spawns[1]["time"]) - float(phases[1]["time"])) < EPS)
	_expect("a primeira onda termina antes da segunda", first_add_defeated_at < float(phases[1]["time"]))
	_expect("Rainha e os dois adds são derrotados", _of(events, "enemy_defeated").size() == 3 and _of(events, "expedition_won").size() == 1)
	_expect("onda real mantém o ataque telegrafado", not _of(events, "telegraph_started").is_empty())

func _test_guardian_memory_fragments() -> void:
	print("\n>>> 4b. FASE DA MEMÓRIA DO GUARDIÃO")
	var guardian := _enemy_variant("boss_c1_001", "t_guardian", {
		"basic_coefficient": 0.6,
		"telegraph": {
			"id": "golpe_de_casco", "every": 2, "windup": 1.5, "coefficient": 2.4,
			"target": "front", "exposed_duration": 3.0, "exposed_vulnerability": 0.15,
		},
		"phases": [{
			"hp_below": 0.35, "name": "A Memória", "phase_gate": true,
			"corruption_fragments": 3, "telegraph_every": 2,
		}],
	})
	var profiles := SliceStats.load_profiles()
	profiles["ranks"]["BOSS"]["max_hp"] = 0.01
	var events := _run([_bastiao()], [{"enemy_id": "t_guardian", "count": 1}], [guardian], {
		"balance_profiles": profiles,
	}).run_to_end(0.25)
	var started := _of(events, "corruption_fragments_started")
	var spawned := _of(events, "corruption_fragment_spawned")
	var destroyed := _of(events, "corruption_fragment_destroyed")
	_expect("fase final anuncia três fragmentos", started.size() == 1 and int(started[0]["count"]) == 3)
	_expect("três fragmentos são expostos", spawned.size() == 3 and destroyed.size() == 3)
	var sequence_is_valid := true
	var last_spawned := 0
	var last_destroyed := 0
	for event in events:
		if String(event["type"]) == "corruption_fragment_spawned":
			var sequence := int(event["sequence"])
			if sequence != last_spawned + 1 or (last_spawned > 0 and last_destroyed != last_spawned):
				sequence_is_valid = false
			last_spawned = sequence
		elif String(event["type"]) == "corruption_fragment_destroyed":
			var sequence := int(event["sequence"])
			if sequence != last_spawned:
				sequence_is_valid = false
			last_destroyed = sequence
	_expect("cada fragmento surge após o anterior ser destruído", sequence_is_valid and last_destroyed == 3)
	var guardian_attack_during_sequence := false
	var phase_started_at := float(started[0]["time"]) if not started.is_empty() else INF
	var guardian_uid := String(started[0]["uid"]) if not started.is_empty() else ""
	for event in _of(events, "enemy_attack"):
		if String(event["source"]) == guardian_uid and float(event["time"]) > phase_started_at:
			guardian_attack_during_sequence = true
			break
	_expect("Guardião continua atacando durante a sequência", guardian_attack_during_sequence)
	_expect("último fragmento restaura a memória e encerra o encontro", _of(events, "boss_memory_restored").size() == 1 and _of(events, "expedition_won").size() == 1)

func _skill(id: String) -> Dictionary:
	for s in skill_rows:
		if s["id"] == id:
			return s
	return {}

## Ranks R2–R5 vêm de skills_slice.json (orçamento em docs/06_balance/v1/03_SKILLS_PASSIVAS.md §3).
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

func _passive_rows() -> Array:
	return SliceStats.load_rows("res://data/skills/passives_slice.json", "slice")

# Peso do Escudo (0,20×ATK no Perfect Block) e Contenção Arcana (atordoa alvo preparado e
# interrompe o golpe telegrafado).
func _test_passives() -> void:
	print("
>>> 5d. PASSIVAS")
	var bast := _bastiao(0.0)
	bast["builds"] = {"r": {"name": "r", "skills": [], "passives": ["passive_bas_peso_do_escudo"]}}
	var events := _run([bast], [{"enemy_id": "en_c1_001", "count": 1}], [], {"builds": {"hero_001": "r"}, "passives": _passive_rows()}).run_to_end(0.25)
	var pd := _of(events, "passive_damage")
	# 10 × 0,20 × (1 − 6,75/106,75)
	_check("Peso do Escudo no Perfect Block de t = 1", float(pd[0]["damage"]) if not pd.is_empty() and absf(float(pd[0]["time"]) - 1.0) < EPS else -1.0, 2.0 * 0.936768)

	var mech := {"telegraph": {"id": "t", "every": 3, "windup": 1.5, "coefficient": 2.2, "target": "front", "exposed_duration": 3.0, "exposed_vulnerability": 0.15}}
	var tele := _enemy_variant("en_c1_001", "t_tele2", mech)
	var guard := _bastiao(0.0)
	guard["builds"] = {"g": {"name": "g", "skills": []}}
	var iris: Dictionary = {}
	for r in hero_rows:
		if r["id"] == "hero_003":
			iris = r.duplicate(true)
	iris["base_stats"]["attack"] = [0.001, 0.001]
	iris["builds"] = {"c": {"name": "c", "skills": ["skill_iri_003"], "passives": ["trait_iri_002"]}}
	var run := _run([guard, iris], [{"enemy_id": "t_tele2", "count": 1}], [tele], {
		"builds": {"hero_001": "g", "hero_003": "c"}, "passives": _passive_rows(),
		"formation": {"front": "hero_001", "mid": "hero_003"},
		"trigger_overrides": {"skill_iri_003": {"type": "enemy_telegraph"}},
	})
	var ev := run.run_to_end(0.25)
	var cut := _of(ev, "telegraph_interrupted")
	_expect("Contenção Arcana interrompe o 1º golpe telegrafado (t = 3)", not cut.is_empty() and absf(float(cut[0]["time"]) - 3.0) < EPS)
	var heavy: Array = _of(ev, "enemy_attack").filter(func(e): return e["heavy"] and float(e["time"]) < 6.0)
	_expect("o golpe pesado interrompido não acontece", heavy.is_empty())

## Cópia do herói com uma build de teste ("t"); ATK padrão salvo se `attack` > 0.
func _hero_build(hero_id: String, skills: Array, passives: Array) -> Dictionary:
	for r in hero_rows:
		if r["id"] == hero_id:
			var copy: Dictionary = r.duplicate(true)
			copy["base_stats"]["max_hp"] = [5000.0, 5000.0]
			copy["builds"] = {"t": {"name": "t", "skills": skills, "passives": passives}}
			return copy
	return {}

func _party_run(heroes: Array, formation: Dictionary, members: Array, builds: Dictionary, overrides: Dictionary) -> ExpeditionRun:
	return _run(heroes, members, [], {"builds": builds, "passives": _passive_rows(), "formation": formation, "trigger_overrides": overrides})

func _damages(events: Array, type: String, source: String, skill: String = "") -> Array:
	var out: Array = []
	for e in _of(events, type):
		if e["source"] == source and (skill == "" or e.get("skill", "") == skill):
			out.append(float(e["damage"]))
	return out

# Passivas do 1A-4 com número HIPÓTESE aprovado por Rafael em 2026-09-30: Feixe Tecido, Foco do Cristal,
# Fissura Persistente e Pressão Coordenada; Respiração Controlada, Rastro Aberto, Ponto de Mira e Caçada Coordenada
# ganharam efeito de teste em 2026-09-30 (nenhuma passiva do slice fica com kind "none").
func _test_slice_passives_1a4() -> void:
	print("
>>> 5e. PASSIVAS 1A-4 (Pressão, Foco, Fissura, Feixe)")
	var none_ids: Array = []
	for row in _passive_rows():
		if String(row["kind"]) == "none":
			none_ids.append(row["id"])
	none_ids.sort()
	_expect("nenhuma passiva do slice segue com kind none", none_ids.is_empty())

	# Feixe Tecido: o Prisma atinge os 3 inimigos; o dano no alvo principal não muda.
	var members := [{"enemy_id": "en_c1_001", "count": 3}]
	var front := {"front": "hero_001", "mid": "hero_003"}
	var override := {"skill_iri_005": {"type": "enemies_alive"}}
	var plain := _party_run([_bastiao(), _hero_build("hero_003", ["skill_iri_005"], [])], front, members, {"hero_001": "t", "hero_003": "t"}, override)
	var beam := _party_run([_bastiao(), _hero_build("hero_003", ["skill_iri_005"], ["trait_iri_001"])], front, members, {"hero_001": "t", "hero_003": "t"}, override)
	var plain_hits := _damages(plain.step(0.01), "skill_damage", "hero_003", "skill_iri_005")
	var beam_hits := _damages(beam.step(0.01), "skill_damage", "hero_003", "skill_iri_005")
	_expect("sem o Trait o Prisma atinge 1 alvo", plain_hits.size() == 1)
	_expect("Feixe Tecido atinge os 3 inimigos", beam_hits.size() == 3)
	_check("Feixe Tecido não altera o dano no alvo principal", beam_hits[0] if not beam_hits.is_empty() else -1.0, plain_hits[0] if not plain_hits.is_empty() else -2.0)
	_check("demais alvos: 0,35 / 1,40 do dano principal", beam_hits[1] / beam_hits[0] if beam_hits.size() > 1 else -1.0, 0.35 / 1.4)

	# Fissura Persistente: +1 s de Fratura contra alvo preparado (teto 7 s); sem preparo, 5 s.
	var fissure_ends: Array = []
	for prepared in [false, true]:
		for passives in [[], ["pass_iri_005"]]:
			var run := _party_run([_bastiao(), _hero_build("hero_003", ["skill_iri_003"], passives)], front, [{"enemy_id": "en_c1_001", "count": 1}], {"hero_001": "t", "hero_003": "t"}, {"skill_iri_003": {"type": "enemy_marked"}} if prepared else {})
			var first: Array = []
			for _i in 40:
				if not run._enemies.is_empty():
					break
				first += run.step(0.05)
			if prepared and not run._enemies.is_empty():
				run._enemies[0]["marked_until"] = 99.0
			var cast := _of(first + run.step(3.0), "skill_cast")
			fissure_ends.append(float(run._enemies[0]["defense_debuff_until"]) - float(cast[0]["time"]) if not cast.is_empty() and not run._enemies.is_empty() else -1.0)
	_check("Fratura sem preparo dura 5 s", fissure_ends[0], 5.0, 0.05)
	_check("Fissura sem preparo não muda a duração", fissure_ends[1], 5.0, 0.05)
	_check("alvo preparado sem a passiva: 5 s", fissure_ends[2], 5.0, 0.05)
	_check("Fissura Persistente contra alvo preparado: 6 s", fissure_ends[3], 6.0, 0.05)

	# Foco do Cristal: ataques básicos no alvo da última Lança de Lúmen causam +8%.
	var focus_events: Array = []
	for passives in [[], ["pass_iri_002"]]:
		var run := _party_run([_bastiao(), _hero_build("hero_003", ["skill_iri_001"], passives)], front, [{"enemy_id": "en_c1_001", "count": 2}], {"hero_001": "t", "hero_003": "t"}, {})
		focus_events.append(_damages(run.run_to_end(0.25), "hero_attack", "hero_003"))
	_expect("Foco do Cristal aumenta o 1º ataque básico após a Lança em 8%",
		not focus_events[0].is_empty() and not focus_events[1].is_empty() and absf(focus_events[1][0] / focus_events[0][0] - 1.08) < 0.001)

	# Pressão Coordenada: depois que um aliado acerta a presa marcada, o próximo golpe de Flecha sobe 10% (sem acumular).
	var pressure: Array = []
	for passives in [[], ["passive_fle_pressao_coordenada"]]:
		var run := _party_run([_bastiao(), _hero_build("hero_002", ["skill_fle_006"], passives)], {"front": "hero_001", "mid": "hero_002"}, [{"enemy_id": "en_c1_001", "count": 3}], {"hero_001": "t", "hero_002": "t"}, {})
		pressure.append(_damages(run.run_to_end(0.25), "hero_attack", "hero_002"))
	var ratios: Array = []
	for i in mini(pressure[0].size(), pressure[1].size()):
		ratios.append(snappedf(pressure[1][i] / pressure[0][i], 0.001))
	_expect("Pressão Coordenada reforça golpes em 10% e nunca mais que isso", ratios.has(1.1) and ratios.all(func(r): return r <= 1.1001))

# --- Passivas de Flecha (Respiração, Rastro, Ponto de Mira, Caçada) e ranks altos das skills (2026-09-30) ---

## Cria a run com os heróis pedidos: [[hero_id, skills, passives], ...]; o primeiro é a linha de frente.
func _mk(specs: Array, members: Array, ranks: Dictionary = {}, overrides: Dictionary = {}, hp: Dictionary = {}) -> ExpeditionRun:
	var heroes: Array = []
	var builds := {}
	var formation := {}
	var slots := ["front", "mid", "back"]
	for i in specs.size():
		var hero := _bastiao() if specs[i][0] == "hero_001" else _hero_build(specs[i][0], [], [])
		hero["builds"] = {"t": {"name": "t", "skills": specs[i][1], "passives": specs[i][2]}}
		heroes.append(hero)
		builds[specs[i][0]] = "t"
		formation[slots[i]] = specs[i][0]
	var run := _run(heroes, members, [], {"builds": builds, "passives": _passive_rows(), "formation": formation, "trigger_overrides": overrides, "skill_ranks": ranks})
	for hid in hp:
		run._heroes[hid]["hp"] = float(hp[hid])
	return run

## Avança até existirem inimigos e devolve os eventos do caminho.
func _spawn(run: ExpeditionRun) -> Array:
	var events: Array = []
	for _i in 40:
		if not run._enemies.is_empty():
			break
		events.append_array(run.step(0.05))
	return events

func _tank(run: ExpeditionRun) -> void:
	for e in run._enemies:
		e["hp"] = 1.0e9
		e["stats"]["max_hp"] = 1.0e9

func _new_geleia(run: ExpeditionRun) -> Dictionary:
	return run._new_enemy(enemy_rows.filter(func(r): return r["id"] == "en_c1_001")[0], 1)

func _test_flecha_passives_v2() -> void:
	print("\n>>> 5f. PASSIVAS DE FLECHA (Respiração, Rastro, Ponto de Mira, Caçada)")
	var members := [{"enemy_id": "en_c1_001", "count": 1}]
	# Respiração Controlada: +3% por disparo seguido no mesmo alvo (o 1º não ganha nada).
	var base := _mk([["hero_001", [], []], ["hero_002", [], []]], members)
	var aim := _mk([["hero_001", [], []], ["hero_002", [], ["passive_fle_respiracao_controlada"]]], members)
	_spawn(base)
	_spawn(aim)
	_tank(base)
	_tank(aim)
	var base_hits := _damages(base.step(12.0), "hero_attack", "hero_002")
	var aim_hits := _damages(aim.step(12.0), "hero_attack", "hero_002")
	_expect("Respiração: Flecha atacou várias vezes", base_hits.size() >= 6 and aim_hits.size() >= 6)
	_check("Respiração: 1º disparo sem bônus", aim_hits[0] / base_hits[0], 1.0, 0.0005)
	_check("Respiração: 2º disparo +3%", aim_hits[1] / base_hits[1], 1.03, 0.0005)
	_check("Respiração: 5º disparo +12%", aim_hits[4] / base_hits[4], 1.12, 0.0005)
	_check("Respiração: teto de 5 acúmulos (+15%)", aim_hits[5] / base_hits[5], 1.15, 0.0005)
	var swap := _mk([["hero_001", [], []], ["hero_002", [], ["passive_fle_respiracao_controlada"]]], members)
	_spawn(swap)
	_tank(swap)
	swap.step(6.0)
	var flecha: Dictionary = swap._heroes["hero_002"]
	_expect("Respiração acumulou no mesmo alvo", int(flecha["aim_n"]) >= 2)
	var newcomer := _new_geleia(swap)
	newcomer["hp"] = 1.0e9
	swap._enemies.insert(0, newcomer)
	swap.step(1.5)
	_expect("Respiração zera ao trocar de alvo", int(flecha["aim_n"]) <= 1)

	# Rastro Aberto: a presa marcada fica legível (evento e snapshot); sem a passiva não.
	var readable: Array = []
	for passives in [[], ["passive_fle_rastro_aberto"]]:
		var run := _mk([["hero_001", [], []], ["hero_002", ["skill_fle_006"], passives]], members)
		var ev := _spawn(run) + run.step(0.1)
		var mark := _of(ev, "enemy_marked")
		readable.append([bool(mark[0]["readable"]) if not mark.is_empty() else false, bool(run.snapshot()["enemies"][0]["mark_readable"])])
	_expect("Rastro Aberto: sem a passiva a Marca não é legível", readable[0] == [false, false])
	_expect("Rastro Aberto: com a passiva a Marca é legível no evento e no snapshot", readable[1] == [true, true])

	# Ponto de Mira: Olho Aguçado fixa o alvo; um inimigo novo na frente não desvia os ataques básicos.
	var focus_targets: Array = []
	for passives in [[], ["passive_fle_ponto_de_mira"]]:
		var run := _mk([["hero_001", [], []], ["hero_002", ["skill_fle_008"], passives]], [{"enemy_id": "en_c1_001", "count": 2}])
		_spawn(run)
		_tank(run)
		var locked: String = run._enemies[0]["uid"]
		var front := _new_geleia(run)
		front["hp"] = 1.0e9
		run._enemies.insert(0, front)
		var shots := _of(run.step(3.0), "hero_attack").filter(func(e): return e["source"] == "hero_002")
		focus_targets.append([locked, shots[0]["target"] if not shots.is_empty() else ""])
	_expect("Ponto de Mira: sem o Trait Flecha vai ao inimigo da frente", focus_targets[0][1] != focus_targets[0][0])
	_expect("Ponto de Mira: com o Trait Flecha mantém o alvo fixado", focus_targets[1][1] == focus_targets[1][0])

	# Caçada Coordenada: aliado acerta a presa marcada; o próximo básico de Flecha a prioriza (uma vez).
	var hunt_targets: Array = []
	for passives in [[], ["passive_fle_cacada_coordenada"]]:
		var run := _mk([["hero_001", [], []], ["hero_002", ["skill_fle_006"], passives]], [{"enemy_id": "en_c1_001", "count": 2}])
		_spawn(run)
		_tank(run)
		var prey: Dictionary = run._enemies[0]
		run._damage_enemy(prey, 1.0, run._heroes["hero_001"], [])
		var front := _new_geleia(run)
		front["hp"] = 1.0e9
		run._enemies.insert(0, front)
		var shots := _of(run.step(2.0), "hero_attack").filter(func(e): return e["source"] == "hero_002")
		hunt_targets.append([prey["uid"], shots[0]["target"] if not shots.is_empty() else "", bool(run._heroes["hero_002"]["lock_once"])])
	_expect("Caçada: sem o Trait Flecha ignora a presa marcada", hunt_targets[0][1] != hunt_targets[0][0])
	_expect("Caçada: com o Trait Flecha o próximo básico vai à presa marcada", hunt_targets[1][1] == hunt_targets[1][0])
	_expect("Caçada: a prioridade é consumida (não acumula)", hunt_targets[1][2] == false)

func _skill_def(id: String, rank: int) -> Dictionary:
	return ExpeditionRun.ranked_skill(skill_rows.filter(func(r): return r["id"] == id)[0], rank, SliceStats.load_profiles())

func _test_skill_ranks_v2() -> void:
	print("\n>>> 5g. RANKS ALTOS DAS SKILLS (números de teste da proposta)")
	var one := [{"enemy_id": "en_c1_001", "count": 1}]
	var three := [{"enemy_id": "en_c1_001", "count": 3}]
	var always := {"type": "enemies_alive"}

	# Muralha Viva R5: Perfect Block prolonga +1 s por bloqueio, no máximo +2 s.
	var wall := _mk([["hero_001", ["skill_bas_006"], []], ["hero_002", [], []]], one, {"skill_bas_006": 5}, {"skill_bas_006": always})
	_spawn(wall)
	var eff: Dictionary = wall._effect_with(wall._heroes["hero_002"], "skill_bas_006", "pb_extend")
	var before := float(eff["expires_at"]) if not eff.is_empty() else -1.0
	for _i in 3:
		wall._on_perfect_block(wall._heroes["hero_001"], wall._enemies[0], [])
	_check("Muralha R5: +2 s no máximo depois de 3 Perfect Blocks", float(eff["expires_at"]) - before, 2.0)

	# Contra-Golpe R5: Perfect Block cria onda de 0,60×ATK em até 2 inimigos adicionais.
	var counter := _mk([["hero_001", ["skill_bas_007"], []]], three, {"skill_bas_007": 5}, {"skill_bas_007": {"type": "enemy_telegraph"}})
	_spawn(counter)
	var wave_events: Array = []
	counter._on_perfect_block(counter._heroes["hero_001"], counter._enemies[0], wave_events)
	var wave := _of(wave_events, "skill_damage")
	_expect("Contra-Golpe R5: onda atinge 2 inimigos adicionais", wave.size() == 2 and wave[0]["target"] != wave[1]["target"])
	var rank4 := _mk([["hero_001", ["skill_bas_007"], []]], three, {"skill_bas_007": 4}, {"skill_bas_007": {"type": "enemy_telegraph"}})
	_spawn(rank4)
	var no_wave: Array = []
	rank4._on_perfect_block(rank4._heroes["hero_001"], rank4._enemies[0], no_wave)
	_expect("Contra-Golpe R4: sem onda", _of(no_wave, "skill_damage").is_empty())

	# Desafio R5: abater um provocado reduz a recarga em 3 s, uma vez por uso.
	var taunt := _mk([["hero_001", ["skill_bas_008"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_bas_008": 5}, {"skill_bas_008": always})
	_spawn(taunt)
	var cd_skill: Dictionary = taunt._heroes["hero_001"]["skills"][0]
	var ready_before := float(cd_skill["ready_at"])
	taunt._damage_enemy(taunt._enemies[0], 1.0e9, taunt._heroes["hero_001"], [])
	_check("Desafio R5: 1º abate reduz a recarga em 3 s", ready_before - float(cd_skill["ready_at"]), 3.0)
	ready_before = float(cd_skill["ready_at"])
	taunt._damage_enemy(taunt._enemies[1], 1.0e9, taunt._heroes["hero_001"], [])
	_check("Desafio R5: só uma vez por uso", ready_before - float(cd_skill["ready_at"]), 0.0)

	# Fortaleza R3: regenera 1,5% do HP máximo por segundo durante a postura (6 s a partir do R2).
	var fort := _mk([["hero_001", ["skill_bas_009"], []]], one, {"skill_bas_009": 3}, {}, {"hero_001": 1000.0})
	var fort_events := _spawn(fort)
	_tank(fort)
	fort_events.append_array(fort.step(10.0))
	var regen := 0.0
	for e in _of(fort_events, "healing"):
		if e.get("cause", "") == "regen":
			regen += float(e["amount"])
	_check("Fortaleza R3: 1,5%/s × 6 s de HP máximo", regen, 0.015 * 5000.0 * 6.0, 1.0)

	# Marca R4 (aliado prolonga 1 s, uma vez) e R5 (transfere ao abater, uma vez).
	var mark := _mk([["hero_001", [], []], ["hero_002", ["skill_fle_006"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_fle_006": 5})
	_spawn(mark)
	_tank(mark)
	var prey: Dictionary = mark._enemies[0]
	var until := float(prey["marked_until"])
	mark._damage_enemy(prey, 1.0, mark._heroes["hero_001"], [])
	_check("Marca R4: 1º acerto aliado prolonga 1 s", float(prey["marked_until"]) - until, 1.0)
	until = float(prey["marked_until"])
	mark._damage_enemy(prey, 1.0, mark._heroes["hero_001"], [])
	_check("Marca R4: só uma vez por Marca", float(prey["marked_until"]) - until, 0.0)
	var heir: Dictionary = mark._enemies[1]
	prey["hp"] = 0.5
	var kill_events: Array = []
	mark._damage_enemy(prey, 5.0, mark._heroes["hero_001"], kill_events)
	_expect("Marca R5: a duração restante passa ao próximo alvo", mark._marked(heir) and absf(float(heir["marked_until"]) - until) < 0.01 and not _of(kill_events, "enemy_marked").is_empty())

	# Olho Aguçado R3 (+4 p.p. de crítico contra marcado), R4 (1º crítico estende 1 s) e R5 (+15% no próximo disparo).
	var eye := _mk([["hero_001", [], []], ["hero_002", [], []]], one, {}, {})
	_spawn(eye)
	_tank(eye)
	var archer: Dictionary = eye._heroes["hero_002"]
	archer["stats"]["crit_chance"] = 0.0
	eye._crits = true
	eye._enemies[0]["marked_until"] = 1.0e9
	var crit_counts: Array = []
	for rank in [2, 3]:
		var def := _skill_def("skill_fle_008", rank)
		archer["effects"] = [eye._buff_effect(def, def["effects"][0])]
		archer["effects"][0]["expires_at"] = 1.0e9
		var crits := 0
		for _i in 2000:
			var shot: Array = []
			eye._hero_attack(archer, shot)
			for e in _of(shot, "hero_attack"):
				if bool(e["crit"]):
					crits += 1
		crit_counts.append(crits)
	_expect("Olho R2: +8 p.p. da skill e +10 p.p. da identidade contra marcado: ~360 críticos em 2000 disparos", crit_counts[0] > 300 and crit_counts[0] < 430)
	_expect("Olho R3: +4 p.p. extras contra marcado (~+80 críticos)", crit_counts[1] - crit_counts[0] > 20)
	var def5 := _skill_def("skill_fle_008", 5)
	archer["effects"] = [eye._buff_effect(def5, def5["effects"][0])]
	var window := float(archer["effects"][0]["expires_at"])
	eye._on_crit(archer)
	_check("Olho R4: 1º crítico estende a janela em 1 s", float(archer["effects"][0]["expires_at"]) - window, 1.0)
	eye._on_crit(archer)
	_check("Olho R4: só uma vez", float(archer["effects"][0]["expires_at"]) - window, 1.0)
	_check("Olho R5: crítico arma +15% no próximo disparo", float(archer["crit_boost_ready"]), 0.15)
	var boosted: float = eye._damage_bonus(archer, eye._enemies[0], {})
	_check("Olho R5: o bônus é consumido no disparo seguinte", boosted - eye._damage_bonus(archer, eye._enemies[0], {}), 0.15)

	# Rajada R4 (+10% no último disparo) e R5 (último acerto na marcada estende a Marca em 1 s).
	var last_hits: Array = []
	for rank in [3, 4]:
		var burst := _mk([["hero_001", [], []], ["hero_002", ["skill_fle_009"], []]], one, {"skill_fle_009": rank}, {"skill_fle_009": {"type": "enemy_marked"}})
		_spawn(burst)
		_tank(burst)
		burst._enemies[0]["marked_until"] = 1.0e9
		last_hits.append(_damages(burst.step(3.0), "skill_damage", "hero_002", "skill_fle_009"))
	_expect("Rajada R4: 4 disparos; só o último sobe 10%", last_hits[1].size() == 4 and absf(last_hits[1][3] / last_hits[0][3] - 1.1) < 0.001 and absf(last_hits[1][0] / last_hits[0][0] - 1.0) < 0.001)
	var burst5 := _mk([["hero_001", [], []], ["hero_002", ["skill_fle_009"], []]], one, {"skill_fle_009": 5}, {"skill_fle_009": {"type": "enemy_marked"}})
	_spawn(burst5)
	_tank(burst5)
	burst5._enemies[0]["marked_until"] = 100.0
	burst5.step(3.0)
	_check("Rajada R5: último acerto na marcada estende a Marca em 1 s", float(burst5._enemies[0]["marked_until"]), 101.0)

	# Lança de Lúmen R5: acerto no segundo alvo reduz a recarga do Prisma em 1 s.
	var lance := _mk([["hero_001", [], []], ["hero_003", ["skill_iri_001", "skill_iri_005"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_iri_001": 5})
	lance._heroes["hero_003"]["skills"][1]["ready_at"] = 10.0
	_spawn(lance)
	_check("Lança R5: Prisma volta 1 s (10 → 9)", float(lance._heroes["hero_003"]["skills"][1]["ready_at"]), 9.0)

	# Prisma R3 (+5% no próximo ataque aliado) e R5 (−10% ATK por 3 s; com Feixe Tecido, no 2º alvo).
	for with_trait in [false, true]:
		var prism := _mk([["hero_001", [], []], ["hero_003", ["skill_iri_005"], ["trait_iri_001"] if with_trait else []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_iri_005": 5}, {"skill_iri_005": always})
		_spawn(prism)
		var first: Dictionary = prism._enemies[0]
		var second: Dictionary = prism._enemies[1]
		_check("Prisma R3: alvo que sobrevive recebe +5% do próximo ataque aliado", float(first.get("prism_boost", 0.0)), 0.05)
		var debuffed_first := float(first.get("atk_debuff", 0.0))
		var debuffed_second := float(second.get("atk_debuff", 0.0))
		if with_trait:
			_expect("Prisma R5 + Feixe Tecido: −10% ATK no 2º alvo, não no principal", absf(debuffed_second - 0.1) < 0.0001 and debuffed_first == 0.0)
		else:
			_expect("Prisma R5 sem Trait: −10% ATK no alvo principal", absf(debuffed_first - 0.1) < 0.0001 and debuffed_second == 0.0)
	var prism_run := _mk([["hero_001", [], []], ["hero_003", ["skill_iri_005"], []]], one, {"skill_iri_005": 5}, {"skill_iri_005": always})
	_spawn(prism_run)
	_tank(prism_run)
	var ally_bonus: float = prism_run._damage_bonus(prism_run._heroes["hero_001"], prism_run._enemies[0], {})
	_check("Prisma R3: aliado ganha +5% uma vez", ally_bonus - prism_run._damage_bonus(prism_run._heroes["hero_001"], prism_run._enemies[0], {}), 0.05)

	# Véu de Micélio R5: ao expirar, 25% do escudo restante cura o portador (máx. 5% do HP máximo).
	var veil := _mk([["hero_001", [], []], ["hero_003", ["skill_iri_002"], []]], one, {"skill_iri_002": 5}, {}, {"hero_001": 1500.0})
	var veil_events := _spawn(veil)
	_tank(veil)
	veil_events.append_array(veil.step(12.0))
	var shield_heal := 0.0
	for e in _of(veil_events, "healing"):
		if e.get("cause", "") == "shield_expired":
			shield_heal += float(e["amount"])
	_expect("Véu R5: a expiração cura o portador, no máximo 5% do HP (250)", shield_heal > 0.0 and shield_heal <= 250.001)

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
