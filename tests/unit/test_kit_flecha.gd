extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		print("FALHA: ", label)
		success = false

func _check(label: String, actual: float, expected: float, eps: float = 0.001) -> void:
	_expect("%s = %.4f (esperado %.4f)" % [label, actual, expected], absf(actual - expected) <= eps)

func _ready() -> void:
	print("--- TESTE KIT DA FLECHA ---")
	KitTestSupport.load_all()
	_test_helpers()
	_test_ricochet()
	_test_arrow_rain()
	_test_build_a()
	_test_build_b()
	_test_build_c()
	_test_full_kit()
	print("[PASS] TESTE KIT DA FLECHA CONCLUÍDO" if success else "[FAIL] TESTE KIT DA FLECHA")
	get_tree().quit(0 if success else 1)

func _cast_now(run: ExpeditionRun, hero_id: String, index: int) -> Array:
	var events: Array = []
	var hero: Dictionary = run._heroes[hero_id]
	run._cast(hero, hero["skills"][index], events)
	return events

func _test_helpers() -> void:
	print("\n>>> F0. AJUDANTES")
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 3}])
	KitTestSupport.spawn(run)
	var archer: Dictionary = run._heroes["hero_002"]
	archer["stats"]["crit_chance"] = 0.10
	_check("chance de crítico base", run._crit_chance(archer, run._enemies[0]), 0.10)
	run._enemies[0]["marked_until"] = 99.0
	_check("presa marcada: +10 p.p. da identidade Instinto de Caçadora (sempre equipada)", run._crit_chance(archer, run._enemies[0]), 0.20)
	_expect("_alive_targets lista os 3 inimigos", run._alive_targets().size() == 3)

func _test_ricochet() -> void:
	print("\n>>> F1. RICOCHETE")
	var never := {"skill_fle_010": {"type": "enemy_telegraph"}}
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 4}], {}, never)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var hits := KitTestSupport.damages(_cast_now(run, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_expect("R1: 3 alvos (1 + 2 saltos)", hits.size() == 3)
	_check("2º alvo = 0,7 do 1º", hits[1] / hits[0], 0.7, 0.0005)
	_check("3º alvo = 0,49 do 1º", hits[2] / hits[0], 0.49, 0.0005)
	# R2: 3 saltos → 4 alvos.
	var r2 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 4}], {"skill_fle_010": 2}, never)
	KitTestSupport.spawn(r2)
	KitTestSupport.tank(r2)
	_expect("R2: 4 alvos", KitTestSupport.damages(_cast_now(r2, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010").size() == 4)
	# R3: o salto que alcança a presa marcada causa +15%.
	var r3 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {"skill_fle_010": 3}, never)
	KitTestSupport.spawn(r3)
	KitTestSupport.tank(r3)
	r3._enemies[1]["marked_until"] = 99.0
	r3._enemies[1]["mark_owner"] = "hero_002"
	var h3 := KitTestSupport.damages(_cast_now(r3, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_check("R3: 2º alvo marcado = 0,7 × 1,15", h3[1] / h3[0], 0.7 * 1.15, 0.0005)
	# R4: 2+ alvos distintos armam +10% no próximo Ricochete.
	var r4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {"skill_fle_010": 4}, never)
	KitTestSupport.spawn(r4)
	KitTestSupport.tank(r4)
	var first := KitTestSupport.damages(_cast_now(r4, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	var second := KitTestSupport.damages(_cast_now(r4, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_check("R4: 2º Ricochete causa +10%", second[0] / first[0], 1.1, 0.0005)
	# R5: presa marcada atingida → disparo concentrado extra de 0,8×ATK nela.
	var r5 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_fle_010": 5}, never)
	KitTestSupport.spawn(r5)
	KitTestSupport.tank(r5)
	r5._enemies[1]["marked_until"] = 99.0
	r5._enemies[1]["mark_owner"] = "hero_002"
	var h5 := KitTestSupport.damages(_cast_now(r5, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_expect("R5: 2 acertos + 1 disparo concentrado", h5.size() == 3)
	_check("R5: concentrado = 0,8×ATK (relativo ao 1º = 0,8)", h5[2] / h5[0], 0.8, 0.0005)

func _test_arrow_rain() -> void:
	print("\n>>> F2. CHUVA DE FLECHAS")
	var never := {"skill_fle_011": {"type": "enemy_telegraph"}}
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_011"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var hits := KitTestSupport.damages(_cast_now(run, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_011")
	_expect("3 inimigos × 3 flechas = 9 acertos (sem presa marcada)", hits.size() == 9)
	var marked := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_011"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_fle_011": 3}, never)
	KitTestSupport.spawn(marked)
	KitTestSupport.tank(marked)
	marked._enemies[0]["marked_until"] = 50.0
	marked._enemies[0]["mark_owner"] = "hero_002"
	var marked_hits := KitTestSupport.damages(_cast_now(marked, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_011")
	_expect("presa marcada recebe o disparo de foco (2×3 + 1)", marked_hits.size() == 7)
	_check("R2: a Marca foi estendida em 2 s", float(marked._enemies[0]["marked_until"]), 52.0)
	_expect("R3: abertura de +10% aberta por 3 s", absf(float(marked._enemies[0]["exposed_vulnerability"]) - 0.1) < 0.0001 and float(marked._enemies[0]["exposed_until"]) > marked.time)

func _test_build_a() -> void:
	print("\n>>> F3. BUILD CRÍTICO (A3–A5)")
	var never := {"skill_fle_007": {"type": "enemy_telegraph"}, "skill_fle_008": {"type": "enemy_telegraph"}}
	# A3
	var a3 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_007"], ["passive_fle_leitura_de_abertura"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, never, {}, 4)
	KitTestSupport.spawn(a3)
	KitTestSupport.tank(a3)
	var archer: Dictionary = a3._heroes["hero_002"]
	archer["stats"]["crit_chance"] = 0.0
	_cast_now(a3, "hero_002", 0)
	_check("A3: +15 p.p. no alvo atingido", a3._crit_chance(archer, a3._enemies[0]), 0.15)
	_check("A3: nada no outro alvo", a3._crit_chance(archer, a3._enemies[1]), 0.0)
	# A4: só vale com a janela de Olho Aguçado ativa; 3 críticos seguidos = +6 p.p.
	var a4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_008"], ["passive_fle_ajuste_fino"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 7)
	KitTestSupport.spawn(a4)
	KitTestSupport.tank(a4)
	var arch4: Dictionary = a4._heroes["hero_002"]
	arch4["stats"]["crit_chance"] = 0.0
	arch4["crit_streak_n"] = 3
	_check("A4: sem a janela do Olho não soma", a4._crit_chance(arch4, a4._enemies[0]), 0.0)
	_cast_now(a4, "hero_002", 0)
	_check("A4: com a janela: +8 p.p. do Olho + 3×2 p.p.", a4._crit_chance(arch4, a4._enemies[0]), 0.08 + 0.06)
	# A5: crítico contra a presa marcada, com Olho ativo, arma +20%.
	var a5 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_008"], ["passive_fle_disparo_perfeito"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 10)
	KitTestSupport.spawn(a5)
	KitTestSupport.tank(a5)
	var arch5: Dictionary = a5._heroes["hero_002"]
	_cast_now(a5, "hero_002", 0)
	a5._enemies[0]["marked_until"] = 99.0
	a5._enemies[0]["mark_owner"] = "hero_002"
	a5._on_crit(arch5, a5._enemies[0])
	_check("A5: +20% armado", float(arch5["crit_boost_ready"]), 0.2)
	arch5["crit_boost_ready"] = 0.0
	a5._enemies[0]["marked_until"] = 0.0
	a5._on_crit(arch5, a5._enemies[0])
	_check("A5: sem presa marcada não arma", float(arch5["crit_boost_ready"]), 0.0)

func _test_build_b() -> void:
	print("\n>>> F4. BUILD MARCA (B3–B5)")
	# B3: presa marcada atrás do inimigo novo continua sendo o alvo do básico.
	var b3 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], ["passive_fle_alvo_persistente"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, {}, {}, 4)
	KitTestSupport.spawn(b3)
	KitTestSupport.tank(b3)
	var prey: Dictionary = b3._enemies[1]
	prey["marked_until"] = 99.0
	prey["mark_owner"] = "hero_002"
	_expect("B3: escolhe a presa marcada mesmo sendo o 2º da fila", b3._attack_target(b3._heroes["hero_002"])["uid"] == prey["uid"])
	# B4: 8 acertos aliados → +3 s no máximo (teto).
	var b4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_006"], ["passive_fle_cacada_compartilhada"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_fle_006": {"type": "enemy_telegraph"}}, {}, 7)
	KitTestSupport.spawn(b4)
	KitTestSupport.tank(b4)
	_cast_now(b4, "hero_002", 0)
	var mark_target: Dictionary = b4._enemies[0]
	var until := float(mark_target["marked_until"])
	for _i in 8:
		b4._damage_enemy(mark_target, 1.0, b4._heroes["hero_001"], [])
	_check("B4: extensão total limitada a +3 s", float(mark_target["marked_until"]) - until, 3.0)
	# B5: primeira skill ofensiva na presa marcada, dentro da janela, dá +10% de ATK aos aliados.
	var b5 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_006", "skill_fle_009"], ["passive_fle_presa_da_party"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_fle_006": {"type": "enemy_telegraph"}, "skill_fle_009": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(b5)
	KitTestSupport.tank(b5)
	_cast_now(b5, "hero_002", 0)
	var before := b5._stat(b5._heroes["hero_001"], "attack")
	_cast_now(b5, "hero_002", 1)
	_check("B5: aliado com +10% de ATK", b5._stat(b5._heroes["hero_001"], "attack") / before, 1.1, 0.0005)
	var after := b5._stat(b5._heroes["hero_001"], "attack")
	_cast_now(b5, "hero_002", 1)
	_check("B5: só uma vez por Marca", b5._stat(b5._heroes["hero_001"], "attack") / after, 1.0, 0.0005)

func _test_build_c() -> void:
	print("\n>>> F5. BUILD VELOCIDADE (C1–C5 e Aljava em Movimento)")
	var never := {"skill_fle_009": {"type": "enemy_telegraph"}, "skill_fle_010": {"type": "enemy_telegraph"}}
	# C1: os intervalos entre básicos encurtam com a sequência (1/(1+0,02·n)).
	var times: Array = []
	for passives in [[], ["passive_fle_cordas_tensionadas"]]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], passives]], [{"enemy_id": "en_c1_001", "count": 1}])
		KitTestSupport.spawn(run)
		KitTestSupport.tank(run)
		var stamps: Array = []
		for e in run.step(15.0):
			if e["type"] == "hero_attack" and e["source"] == "hero_002":
				stamps.append(float(e["time"]))
		times.append(stamps)
	var base_gap: float = times[0][3] - times[0][2]
	var fast_gap: float = times[1][4] - times[1][3]
	_check("C1: o 4º intervalo já é 1/(1+0,02×3) do normal", fast_gap / base_gap, 1.0 / 1.06, 0.002)
	# C2: depois de uma skill, o próximo básico sai em 60% do intervalo.
	var c2 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_009"], ["passive_fle_saque_rapido"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 1)
	KitTestSupport.spawn(c2)
	KitTestSupport.tank(c2)
	var arch: Dictionary = c2._heroes["hero_002"]
	arch["next_at"] = c2.time + 100.0
	_cast_now(c2, "hero_002", 0)
	_check("C2: próximo básico em 0,6 do intervalo", float(arch["next_at"]) - c2.time, CombatMath.attack_interval(c2._stat(arch, "attack_speed")) * 0.6, 0.001)
	# C3: −8% de dano recebido por 3 s, sem repetir dentro de 8 s.
	var c3 := KitTestSupport.mk([["hero_002", [], ["passive_fle_passo_de_arqueira"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 4)
	KitTestSupport.spawn(c3)
	var target: Dictionary = c3._heroes["hero_002"]
	c3._enemies[0]["threat"]["hero_002"] = 1.0e6
	c3._enemy_attack(c3._enemies[0], [])
	_check("C3: dano recebido −8%", 1.0 - c3._damage_taken_multiplier(target), 0.08)
	var count_before: int = target["effects"].size()
	c3._enemy_attack(c3._enemies[0], [])
	_expect("C3: não reaplica dentro de 8 s", target["effects"].size() == count_before)
	# C4: Ricochete com ≥2 alvos tira 3 s da Rajada; C5: presa marcada tira 3 s da outra skill.
	var c4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010", "skill_fle_009"], ["passive_fle_aljava_em_ordem", "passive_fle_ritmo_implacavel"]]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never, {}, 10)
	KitTestSupport.spawn(c4)
	KitTestSupport.tank(c4)
	var a4: Dictionary = c4._heroes["hero_002"]
	a4["skills"][1]["ready_at"] = 50.0
	_cast_now(c4, "hero_002", 0)
	_check("C4: Rajada 3 s mais cedo", float(a4["skills"][1]["ready_at"]), 47.0)
	c4._enemies[0]["marked_until"] = 99.0
	c4._enemies[0]["mark_owner"] = "hero_002"
	a4["skills"][1]["ready_at"] = 50.0
	a4["skills"][0]["ready_at"] = 0.0
	_cast_now(c4, "hero_002", 0)
	_check("C4+C5: Rajada 6 s mais cedo (3 do C4 + 3 do C5)", float(a4["skills"][1]["ready_at"]), 44.0)
	# Aljava em Movimento: o próximo básico vai ao 2º alvo atingido.
	var trait_run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], ["trait_fle_aljava_em_movimento"]]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never, {}, 1)
	KitTestSupport.spawn(trait_run)
	KitTestSupport.tank(trait_run)
	_cast_now(trait_run, "hero_002", 0)
	_expect("Trait: próximo básico vai ao 2º alvo do Ricochete", trait_run._attack_target(trait_run._heroes["hero_002"])["uid"] == trait_run._enemies[1]["uid"])

func _test_full_kit() -> void:
	print("\n>>> F6. KIT COMPLETO")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var fle: Dictionary = heroes.filter(func(r): return r["id"] == "hero_002")[0]
	var skills := {}
	var passives := {}
	for b in fle["builds"].values():
		for s in b["skills"]:
			skills[s] = true
		for p in b["passives"]:
			passives[p] = true
	skills[String(fle["signature"])] = true
	_expect("6 skills distintas (006–011), a Signature no 3º slot", skills.size() == 6 and String(fle["signature"]) == "skill_fle_011")
	_expect("18 nós únicos nas builds (15 de build + 3 Traits), além da identidade", passives.size() == 18)
	var rows := SliceStats.load_rows("res://data/skills/passives_slice.json", "slice")
	var by_id := {}
	for r in rows:
		by_id[r["id"]] = r
	var missing: Array = []
	for pid in passives:
		if not by_id.has(pid) or String(by_id[pid]["kind"]) == "none":
			missing.append(pid)
	_expect("toda passiva das builds existe e tem efeito (faltam: %s)" % str(missing), missing.is_empty())
	var slot_run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "velocidade", "hero_003": "arcano"}, 10, 3)
	_expect("a Flecha entra na run com 3 skills (2 da build + Signature)", slot_run._heroes["hero_002"]["skills"].size() == 3)
	var early_hero_002 := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "velocidade", "hero_003": "arcano"}, 9, 3)
	_expect("antes do nível 10 a Signature ainda não está liberada (2 skills)", early_hero_002._heroes["hero_002"]["skills"].size() == 2)
	for build in fle["builds"]:
		for level in [1, 5, 10, 12]:
			var run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": build, "hero_003": "arcano"}, level, 3)
			run.run_to_end(0.25, 900.0)
			_expect("build %s nível %d roda até o fim" % [build, level], run.state == "won" or run.state == "lost")
