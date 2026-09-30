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
	print("--- TESTE KIT DA ÍRIS ---")
	BalanceProfiles.pin_test_units()  # números conferidos à mão em unidades 1× e curva linear
	KitTestSupport.load_all()
	_test_convergence()
	_test_pulse_ranks()
	_test_build_a()
	_test_build_b()
	_test_build_c()
	_test_full_kit()
	print("[PASS] TESTE KIT DA ÍRIS CONCLUÍDO" if success else "[FAIL] TESTE KIT DA ÍRIS")
	get_tree().quit(0 if success else 1)

func _cast_now(run: ExpeditionRun, hero_id: String, index: int) -> Array:
	var events: Array = []
	var hero: Dictionary = run._heroes[hero_id]
	run._cast(hero, hero["skills"][index], events)
	return events

func _test_convergence() -> void:
	print("\n>>> I2. CONVERGÊNCIA DE LÚMEN")
	var never := {"skill_iri_006": {"type": "enemy_telegraph"}}
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_006"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	run._enemies[2]["marked_until"] = 99.0
	var hits := KitTestSupport.damages(_cast_now(run, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_006")
	_expect("1 golpe por inimigo vivo", hits.size() == 3)
	_check("principal = 2,2 × outros (mesma DEF)", hits[0] / hits[1], 2.2, 0.0005)
	_check("alvo marcado sofre +50% da skill + 10% da identidade Sensível ao Lúmen", hits[2] / hits[1], 1.6, 0.0005)
	var r3 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_006"], []]], [{"enemy_id": "en_c1_001", "count": 1}], {"skill_iri_006": 3}, never)
	KitTestSupport.spawn(r3)
	KitTestSupport.tank(r3)
	var before := r3._stat(r3._heroes["hero_001"], "attack")
	_cast_now(r3, "hero_003", 0)
	_check("R3: aliados +8% de ATK", r3._stat(r3._heroes["hero_001"], "attack") / before, 1.08, 0.0005)

func _test_pulse_ranks() -> void:
	print("\n>>> I3. PULSO RESTAURADOR")
	var row: Dictionary = KitTestSupport.skill_rows.filter(func(r): return r["id"] == "skill_iri_004")[0]
	_expect("Pulso tem ranks 2–5 definidos", row.has("ranks") and row["ranks"].size() == 4)
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {"hero_001": 2000.0})
	var events := KitTestSupport.spawn(run)
	var heals := KitTestSupport.of(events, "healing")
	_expect("cura o aliado abaixo de 85% ao começar (0,3×ATK)", heals.size() == 1 and absf(float(heals[0]["amount"]) - float(run._heroes["hero_003"]["stats"]["attack"]) * 0.3) < 0.01)

func _test_build_a() -> void:
	print("\n>>> I4. BUILD ARCANO (A3–A5)")
	var never := {"skill_iri_001": {"type": "enemy_telegraph"}, "skill_iri_005": {"type": "enemy_telegraph"}}
	# A3: 1 s a menos de recarga contra alvo preparado.
	var cds: Array = []
	for prepared in [true, false]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_001"], ["pass_iri_006"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 4)
		KitTestSupport.spawn(run)
		KitTestSupport.tank(run)
		if prepared:
			run._enemies[0]["marked_until"] = 99.0
		_cast_now(run, "hero_003", 0)
		cds.append(float(run._heroes["hero_003"]["skills"][0]["ready_at"]) - run.time)
	_check("A3: 1 s a menos contra alvo preparado", cds[1] - cds[0], 1.0)
	# A4: Prisma +15% com 2 inimigos, igual com 1.
	var dmg: Array = []
	for count in [1, 2]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_005"], ["pass_iri_007"]]], [{"enemy_id": "en_c1_001", "count": count}], {}, never, {}, 7)
		KitTestSupport.spawn(run)
		KitTestSupport.tank(run)
		dmg.append(KitTestSupport.damages(_cast_now(run, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_005")[0])
	_check("A4: +15% quando há 2 inimigos", dmg[1] / dmg[0], 1.15, 0.0005)
	# A5: Prisma arma +40% na próxima Lança, uma vez.
	var a5 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_001", "skill_iri_005"], ["pass_iri_008"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 10)
	KitTestSupport.spawn(a5)
	KitTestSupport.tank(a5)
	var plain_lance: float = KitTestSupport.damages(_cast_now(a5, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_001")[0]
	_cast_now(a5, "hero_003", 1)
	var boosted: float = KitTestSupport.damages(_cast_now(a5, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_001")[0]
	_check("A5: Lança depois do Prisma causa +40%", boosted / plain_lance, 1.4, 0.0005)
	var again: float = KitTestSupport.damages(_cast_now(a5, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_001")[0]
	_check("A5: só uma vez", again / plain_lance, 1.0, 0.0005)

func _test_build_b() -> void:
	print("\n>>> I5. BUILD CONTROLE (B3–B5)")
	var never := {"skill_iri_003": {"type": "enemy_telegraph"}}
	# B3: aliado a 30% de HP recebe escudo maior.
	var shields: Array = []
	for passives in [[], ["pass_iri_009"]]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_002"], passives]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {"hero_001": 1500.0}, 4)
		var ev := KitTestSupport.spawn(run)
		var granted := KitTestSupport.of(ev, "shield_granted")
		shields.append(float(granted[0]["amount"]) if not granted.is_empty() else -1.0)
	_check("B3: escudo +25% em aliado a 30% de HP", shields[1] / shields[0], 1.25, 0.0005)
	# B4: Fratura reduz o ATK do alvo em 10%.
	var b4 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_003"], ["pass_iri_010"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 7)
	KitTestSupport.spawn(b4)
	KitTestSupport.tank(b4)
	_cast_now(b4, "hero_003", 0)
	_check("B4: ATK do alvo −10%", float(b4._enemies[0]["atk_debuff"]), 0.10)
	_expect("B4: dura o mesmo que a fratura", absf(float(b4._enemies[0]["atk_debuff_until"]) - float(b4._enemies[0]["defense_debuff_until"])) < 0.001)
	# B5: os demais inimigos recebem metade do debuff de DEF.
	var b5 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_003"], ["pass_iri_011"]]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never, {}, 10)
	KitTestSupport.spawn(b5)
	KitTestSupport.tank(b5)
	_cast_now(b5, "hero_003", 0)
	_check("B5: principal −15% de DEF", float(b5._enemies[0]["defense_debuff"]), -0.15)
	_check("B5: demais −7,5% de DEF", float(b5._enemies[1]["defense_debuff"]), -0.075)
	_check("B5: 3º inimigo também", float(b5._enemies[2]["defense_debuff"]), -0.075)

func _test_build_c() -> void:
	print("\n>>> I6. BUILD LÚMEN (C1–C5 e Chama Viva)")
	var pulse := {"skill_iri_004": {"type": "enemy_telegraph"}}
	# C1 e C2.
	var base := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []], ["hero_003", ["skill_iri_004"], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 1000.0, "hero_002": 2000.0})
	KitTestSupport.spawn(base)
	var plain := KitTestSupport.of(_cast_now(base, "hero_003", 0), "healing")
	var kit := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []], ["hero_003", ["skill_iri_004"], ["pass_iri_012", "pass_iri_013"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 1000.0, "hero_002": 2000.0}, 1)
	KitTestSupport.spawn(kit)
	var boosted := KitTestSupport.of(_cast_now(kit, "hero_003", 0), "healing")
	_check("C1: +5% de cura", float(boosted[0]["amount"]) / float(plain[0]["amount"]), 1.05, 0.0005)
	_expect("C2: 2º aliado também é curado", boosted.size() == 2)
	_check("C2: 30% do valor", float(boosted[1]["amount"]) / float(boosted[0]["amount"]), 0.3, 0.0005)
	# C3: excedente vira escudo.
	var c3 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], ["pass_iri_014"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 3000.0}, 4)
	KitTestSupport.spawn(c3)
	c3._heroes["hero_003"]["stats"]["attack"] = 10000.0
	var ev3 := _cast_now(c3, "hero_003", 0)
	var shield_events := KitTestSupport.of(ev3, "shield_granted")
	_expect("C3: cura o que falta (2000) e o excedente vira escudo", KitTestSupport.of(ev3, "healing").size() == 1 and shield_events.size() == 1)
	_check("C3: escudo = min(50% do excedente = 500, 10% de 5000 = 500)", float(shield_events[0]["amount"]), 500.0, 0.01)
	# C4: Véu dura +2 s.
	var c4 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_002"], ["pass_iri_015"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_iri_002": {"type": "enemy_telegraph"}}, {"hero_001": 1000.0}, 7)
	KitTestSupport.spawn(c4)
	_cast_now(c4, "hero_003", 0)
	var veil: Dictionary = c4._heroes["hero_001"]["effects"].filter(func(e): return e["stat"] == "shield")[0]
	_check("C4: duração 6 + 2 s", float(veil["expires_at"]) - float(veil["started_at"]), 8.0)
	# C5: aliado cai abaixo de 25% → Pulso pronto.
	var c5 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], ["pass_iri_016"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {}, 10)
	KitTestSupport.spawn(c5)
	_cast_now(c5, "hero_003", 0)
	_expect("C5: Pulso em recarga", float(c5._heroes["hero_003"]["skills"][0]["ready_at"]) > c5.time)
	c5._heroes["hero_001"]["hp"] = 500.0
	c5._check_fountain(c5._heroes["hero_001"], [])
	_check("C5: Pulso volta a ficar pronto", float(c5._heroes["hero_003"]["skills"][0]["ready_at"]), c5.time, 0.001)
	# Trait Chama Viva: a cura dá +10% de ATK ao receptor.
	var trait_run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], ["trait_iri_003"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 1000.0}, 1)
	KitTestSupport.spawn(trait_run)
	var atk_before := trait_run._stat(trait_run._heroes["hero_001"], "attack")
	_cast_now(trait_run, "hero_003", 0)
	_check("Trait: receptor com +5% de ATK", trait_run._stat(trait_run._heroes["hero_001"], "attack") / atk_before, 1.05, 0.0005)

func _test_full_kit() -> void:
	print("\n>>> I7. KIT COMPLETO")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var iris: Dictionary = heroes.filter(func(r): return r["id"] == "hero_003")[0]
	var skills := {}
	var passives := {}
	for b in iris["builds"].values():
		for s in b["skills"]:
			skills[s] = true
		for p in b["passives"]:
			passives[p] = true
	skills[String(iris["signature"])] = true
	_expect("6 skills distintas (001–006), a Signature no 3º slot", skills.size() == 6 and String(iris["signature"]) == "skill_iri_006")
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
	var slot_run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "lumen"}, 10, 3)
	_expect("a Íris entra na run com 3 skills (2 da build + Signature)", slot_run._heroes["hero_003"]["skills"].size() == 3)
	var early_hero_003 := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "lumen"}, 9, 3)
	_expect("antes do nível 10 a Signature ainda não está liberada (2 skills)", early_hero_003._heroes["hero_003"]["skills"].size() == 2)
	for build in iris["builds"]:
		for level in [1, 5, 10, 12]:
			var run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": build}, level, 3)
			run.run_to_end(0.25, 900.0)
			_expect("build %s nível %d roda até o fim" % [build, level], run.state == "won" or run.state == "lost")
