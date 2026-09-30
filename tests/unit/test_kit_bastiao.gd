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
	print("--- TESTE KIT DO BASTIÃO ---")
	BalanceProfiles.pin_test_units()  # números conferidos à mão em unidades 1× e curva linear
	KitTestSupport.load_all()
	_test_guard()
	_test_triggers()
	_test_shield_bash()
	_test_last_bastion()
	_test_build_a()
	_test_build_b()
	_test_build_c()
	_test_full_kit()
	_test_no_double_defeat()
	print("[PASS] TESTE KIT DO BASTIÃO CONCLUÍDO" if success else "[FAIL] TESTE KIT DO BASTIÃO")
	get_tree().quit(0 if success else 1)

func _test_guard() -> void:
	print("
>>> B1. GUARDA")
	# Geleia ataca em t = 1 e 2: 1º golpe é Perfect Block (+2 +12), 2º é golpe comum (+2).
	var run := KitTestSupport.mk([["hero_001", [], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var events := run.step(2.5)
	_check("Guarda depois de 1 Perfect Block e 1 golpe", float(run._heroes["hero_001"]["guard"]), 16.0)
	_expect("evento guard_gained emitido", not KitTestSupport.of(events, "guard_gained").is_empty())
	var hero: Dictionary = run._heroes["hero_001"]
	run._gain_guard(hero, 500.0, [])
	_check("teto de 100", float(hero["guard"]), 100.0)
	_expect("gastar 30 funciona", run._spend_guard(hero, 30.0, []))
	_check("Guarda depois de gastar", float(hero["guard"]), 70.0)
	_expect("gastar mais que o saldo falha", not run._spend_guard(hero, 80.0, []))
	hero["guard"] = 80.0
	run._apply_guard_carry()
	_check("carry entre encontros: 50%", float(hero["guard"]), 40.0)
	_check("snapshot expõe a Guarda", float(run.snapshot()["party"][0]["guard"]), 40.0)
	var flecha_run := KitTestSupport.mk([["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	_expect("herói sem bloco guard não tem Guarda", flecha_run._heroes["hero_002"]["guard_cfg"].is_empty())

func _test_triggers() -> void:
	print("
>>> B2. GATILHOS")
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	KitTestSupport.spawn(run)
	var hero: Dictionary = run._heroes["hero_001"]
	hero["guard"] = 19.0
	_expect("guard_at_least 20 falha com 19", not run._trigger_ok(hero, {"type": "guard_at_least", "amount": 20.0}))
	hero["guard"] = 20.0
	_expect("guard_at_least 20 passa com 20", run._trigger_ok(hero, {"type": "guard_at_least", "amount": 20.0}))
	hero["guard"] = 100.0
	_expect("guard_and_hp_below falha com todos com HP cheio", not run._trigger_ok(hero, {"type": "guard_and_hp_below", "amount": 100.0, "threshold": 0.5}))
	run._heroes["hero_002"]["hp"] = 100.0
	_expect("guard_and_hp_below passa com aliado a 2% de HP", run._trigger_ok(hero, {"type": "guard_and_hp_below", "amount": 100.0, "threshold": 0.5}))

func _expected_hit(run: ExpeditionRun, enemy: Dictionary, coefficient: float) -> float:
	var atk := float(run._heroes["hero_001"]["stats"]["attack"])
	return CombatMath.hit_damage(atk * coefficient, run._enemy_defense(enemy), 0.0, 1.0)

func _test_shield_bash() -> void:
	print("
>>> B3. IMPACTO DE ESCUDO")
	# Sem Guarda suficiente não lança.
	var low := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	var ev_low := KitTestSupport.spawn(low)
	_expect("sem Guarda 20 não lança", KitTestSupport.of(ev_low, "skill_cast").is_empty())
	# Um inimigo: 1 golpe, sem colisão. Guarda 30 → gasta 20.
	var one := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	one._heroes["hero_001"]["guard"] = 30.0
	var ev_one := KitTestSupport.spawn(one)
	ev_one.append_array(one.step(0.05))
	var spent := KitTestSupport.of(ev_one, "guard_spent")
	_expect("gasta 20 de Guarda", spent.size() == 1 and absf(float(spent[0]["amount"]) - 20.0) < 0.001)
	_expect("1 inimigo: 1 golpe, sem colisão", KitTestSupport.damages(ev_one, "skill_damage", "hero_001", "skill_bas_010").size() == 1)
	# Dois inimigos: golpe principal + colisão nos dois; stun no primeiro.
	var two := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 2}])
	two._heroes["hero_001"]["guard"] = 30.0
	var ev_two := KitTestSupport.spawn(two)
	ev_two.append_array(two.step(0.05))
	var hits_two := KitTestSupport.damages(ev_two, "skill_damage", "hero_001", "skill_bas_010")
	_expect("2 inimigos: golpe + 2 colisões", hits_two.size() == 3)
	_expect("stun no primeiro alvo", not KitTestSupport.of(ev_two, "enemy_stunned").is_empty())
	_check("golpe principal = 1,8×ATK", hits_two[0], _expected_hit(two, two._enemies[0], 1.8))
	_check("colisão = 0,6×ATK", hits_two[1], _expected_hit(two, two._enemies[0], 0.6))
	# R4: colisão aplica Desequilíbrio ao primeiro alvo.
	var r4 := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_bas_010": 4})
	r4._heroes["hero_001"]["guard"] = 30.0
	var ev_r4 := KitTestSupport.spawn(r4)
	ev_r4.append_array(r4.step(0.05))
	_expect("R4 aplica Desequilíbrio", not KitTestSupport.of(ev_r4, "enemy_imbalanced").is_empty())
	# R5: alvo já Desequilibrado + 3 inimigos → principal (1) + colisões (2) + explosão de 0,5×ATK nos outros 2.
	var r5 := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {"skill_bas_010": 5}, {"skill_bas_010": {"type": "enemy_telegraph"}})
	KitTestSupport.spawn(r5)
	KitTestSupport.tank(r5)
	var bast: Dictionary = r5._heroes["hero_001"]
	bast["guard"] = 30.0
	r5._enemies[0]["imbalance_until"] = 99.0
	var ev_r5: Array = []
	r5._cast(bast, bast["skills"][0], ev_r5)
	var hits_r5 := KitTestSupport.damages(ev_r5, "skill_damage", "hero_001", "skill_bas_010")
	_expect("R5: 5 golpes (principal, 2 colisões, 2 explosões)", hits_r5.size() == 5)
	_check("R5: explosão = 0,5×ATK no 3º inimigo", hits_r5[4], _expected_hit(r5, r5._enemies[2], 0.5))

func _test_last_bastion() -> void:
	print("
>>> B4. ÚLTIMO BASTIÃO")
	var run := KitTestSupport.mk([["hero_001", ["skill_bas_011", "skill_bas_007"], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {"hero_001": 2000.0})
	var bast: Dictionary = run._heroes["hero_001"]
	bast["guard"] = 100.0
	bast["skills"][1]["ready_at"] = 100.0
	var events := KitTestSupport.spawn(run)
	_expect("lança com Guarda 100 e HP a 40%", not KitTestSupport.of(events, "skill_cast").is_empty())
	_expect("gasta 100 de Guarda", not KitTestSupport.of(events, "guard_spent").is_empty() and absf(float(KitTestSupport.of(events, "guard_spent")[0]["amount"]) - 100.0) < 0.001)
	_expect("aliado ganha −20% de dano recebido", run._heroes["hero_002"]["effects"].any(func(e): return e["source"] == "skill_bas_011" and absf(float(e["value"]) + 0.2) < 0.0001))
	# Piso de 1 HP mesmo com dano enorme.
	KitTestSupport.tank(run)
	run._enemies[0]["stats"]["attack"] = 1.0e6
	bast["hp"] = 50.0
	run.step(3.0)
	_expect("Bastião sobrevive com 1 HP", bast["alive"] and float(bast["hp"]) >= 1.0 - 0.001)
	# Contra-Golpe acelerado: cada segundo de bastião tira 1 s extra da recarga.
	# ready_at = 100 no lançamento (t ≈ 0) e a janela dura 8 s: durante 8 s a recarga corre 2× (16 s de recarga), então ~92.
	_expect("recarga do Contra-Golpe acelerada (~92)", float(bast["skills"][1]["ready_at"]) < 97.0)
	# Ao fim, onda de choque.
	var end_events := run.step(8.0)
	var wave := KitTestSupport.damages(end_events, "skill_damage", "hero_001", "skill_bas_011")
	_expect("onda de choque no fim da duração", wave.size() == 1 and wave[0] > 0.0)
	_expect("Último Bastião termina", not run._bastion_active(bast))
	# R3: cura os aliados ao fim.
	var r3 := KitTestSupport.mk([["hero_001", ["skill_bas_011"], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {"skill_bas_011": 3}, {}, {"hero_001": 2000.0, "hero_002": 1000.0})
	r3._heroes["hero_001"]["guard"] = 100.0
	var heal_events := KitTestSupport.spawn(r3)
	KitTestSupport.tank(r3)
	heal_events.append_array(r3.step(11.0))
	_expect("R3 cura aliado ao fim (evento healing com causa last_bastion)", heal_events.any(func(e): return e["type"] == "healing" and e.get("cause", "") == "last_bastion"))

func _test_build_a() -> void:
	print("
>>> B5. BUILD GUARDIÃO (A3–A5)")
	# A3: golpe forte telegrafado causa 10% menos no protegido.
	var multipliers: Array = []
	for passives in [[], ["passive_bas_presenca_protetora"]]:
		var run := KitTestSupport.mk([["hero_001", ["skill_bas_006"], passives], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_bas_006": {"type": "enemies_alive"}}, {}, 4)
		KitTestSupport.spawn(run)
		multipliers.append(run._damage_taken_multiplier(run._heroes["hero_002"], 0.0, true))
	_expect("A3: multiplicador de dano forte cai 10 p.p. no protegido", absf(multipliers[0] - multipliers[1] - 0.1) < 0.0001)
	# A4: aliado abaixo de 30% → +10 Guarda no Bastião e −10% no aliado; 1 vez a cada 15 s por aliado.
	var a4 := KitTestSupport.mk([["hero_001", [], ["passive_bas_ninguem_para_tras"]], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 7)
	KitTestSupport.spawn(a4)
	var before: float = a4._heroes["hero_001"]["guard"]
	a4._heroes["hero_002"]["hp"] = 1000.0
	a4._check_ally_low(a4._heroes["hero_002"], [])
	_check("A4: +10 Guarda", float(a4._heroes["hero_001"]["guard"]) - before, 10.0)
	var again: Array = []
	a4._check_ally_low(a4._heroes["hero_002"], again)
	_expect("A4: 1 vez a cada 15 s por aliado", KitTestSupport.of(again, "guard_gained").is_empty())
	# A5: dano fatal em aliado deixa 1 HP; 2ª vez dentro de 120 s não salva.
	var a5 := KitTestSupport.mk([["hero_001", [], ["passive_bas_guarda_eterna"]], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 10)
	KitTestSupport.spawn(a5)
	var frail: Dictionary = a5._heroes["hero_002"]
	frail["hp"] = 5.0
	_expect("A5: salva do golpe fatal", a5._try_save_ally(frail, []) and float(frail["hp"]) == 1.0)
	frail["hp"] = 0.0
	_expect("A5: não salva de novo dentro do cooldown", not a5._try_save_ally(frail, []))

func _test_build_b() -> void:
	print("
>>> B6. BUILD RETALIAÇÃO (B3–B5)")
	# B3: cada carga soma 8% ao Contra-Golpe; consumo total.
	var run := KitTestSupport.mk([["hero_001", ["skill_bas_007"], ["passive_bas_pressao_acumulada"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_bas_007": {"type": "enemy_telegraph"}}, {}, 4)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var hero: Dictionary = run._heroes["hero_001"]
	for _i in 3:
		run._add_stack(hero, "block_charges_counter")
	_check("B3: 3 cargas", float(run._stacks(hero, "block_charges_counter")), 3.0)
	_check("B3: bônus do Contra-Golpe = 3 × 8%", run._counter_charge_bonus(hero), 0.24)
	_check("B3: consumido depois de calcular", float(run._stacks(hero, "block_charges_counter")), 0.0)
	# B4: Elite que ataca leva +10 (Perfect Block: +20).
	var b4 := KitTestSupport.mk([["hero_001", [], ["passive_bas_quebre_se"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 7)
	KitTestSupport.spawn(b4)
	var elite: Dictionary = b4._enemies[0]
	elite["rank"] = "ELITE"
	elite["posture"] = 100.0
	elite["posture_max"] = 100.0
	b4._elite_stagger(b4._heroes["hero_001"], elite, false, [])
	_check("B4: +10 de Stagger num golpe comum", 100.0 - float(elite["posture"]), 10.0)
	elite["posture"] = 100.0
	elite["immune_until"] = -INF
	b4._elite_stagger(b4._heroes["hero_001"], elite, true, [])
	_check("B4: +20 de Stagger num Perfect Block", 100.0 - float(elite["posture"]), 20.0)
	# B5: 3 Perfect Blocks dentro de 12 s armam o Julgamento.
	var b5 := KitTestSupport.mk([["hero_001", ["skill_bas_007"], ["passive_bas_julgamento_de_ferro"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, {"skill_bas_007": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(b5)
	KitTestSupport.tank(b5)
	var h5: Dictionary = b5._heroes["hero_001"]
	for _i in 3:
		b5._count_judgement(h5)
	_expect("B5: Julgamento armado com 3 PBs", bool(h5["judgement_ready"]))
	var wave: Array = []
	b5._fire_judgement(h5, wave)
	_expect("B5: onda atinge os 2 inimigos", KitTestSupport.of(wave, "skill_damage").size() == 2 and not bool(h5["judgement_ready"]))

func _test_build_c() -> void:
	print("\n>>> B7. BUILD CONTROLE (C1–C5 e Não Passarão)")
	var members := [{"enemy_id": "en_c1_001", "count": 3}]
	# C2 e Trait: slow por herói vivo; vale o maior; Desequilibrado usa o valor maior.
	var run := KitTestSupport.mk([["hero_001", [], ["passive_bas_sem_passagem"]]], members)
	KitTestSupport.spawn(run)
	var enemy: Dictionary = run._enemies[0]
	_check("C2: slow padrão 8%", run._zone_slow(enemy), 0.08)
	enemy["imbalance_until"] = 99.0
	_check("C2: slow em Desequilibrado 15%", run._zone_slow(enemy), 0.15)
	var trait_run := KitTestSupport.mk([["hero_001", [], ["passive_bas_sem_passagem", "trait_bas_nao_passarao"]]], members)
	KitTestSupport.spawn(trait_run)
	_check("Trait: vale o maior entre C2 (8%) e a zona (10%)", trait_run._zone_slow(trait_run._enemies[0]), 0.10)
	# Trait: +10% de stagger recebido.
	var target: Dictionary = trait_run._enemies[0]
	target["posture"] = 100.0
	target["posture_max"] = 100.0
	trait_run._apply_stagger(target, 10.0, [])
	_check("Trait: 10 de stagger viram 11", 100.0 - float(target["posture"]), 11.0)
	# C1: Desafio dá +1 Guarda por inimigo vivo e slow de 5%.
	var c1 := KitTestSupport.mk([["hero_001", ["skill_bas_008"], ["passive_bas_voz_de_comando"]]], members, {}, {"skill_bas_008": {"type": "enemies_alive"}})
	var ev_c1 := KitTestSupport.spawn(c1)
	ev_c1.append_array(c1.step(0.05))
	_expect("C1: Guarda ganha 3 (por inimigo) + 3 (provocar)", float(c1._heroes["hero_001"]["guard"]) >= 6.0)
	_expect("C1: inimigos ficam 5% mais lentos", absf(float(c1._enemies[0]["slow"]) - 0.05) < 0.0001)
	# C3: 2 inimigos atrás recebem colisão; C4: Desequilíbrio passa; C5: linha desacelera todos.
	var c := KitTestSupport.mk([["hero_001", ["skill_bas_010"], ["passive_bas_choque_de_linha", "passive_bas_formacao_quebrada", "passive_bas_linha_inquebravel"]]], members, {"skill_bas_010": 4}, {"skill_bas_010": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(c)
	KitTestSupport.tank(c)
	c._heroes["hero_001"]["guard"] = 30.0
	var ev_c: Array = []
	c._cast(c._heroes["hero_001"], c._heroes["hero_001"]["skills"][0], ev_c)
	_expect("C3: golpe + colisão no alvo + 2 inimigos atrás = 4", KitTestSupport.damages(ev_c, "skill_damage", "hero_001", "skill_bas_010").size() == 4)
	_expect("C4: Desequilíbrio passou ao inimigo de trás", float(c._enemies[1]["imbalance_until"]) > c.time)
	_expect("C5: todos os inimigos ficam 20% mais lentos", c._enemies.all(func(e): return absf(float(e["slow"]) - 0.2) < 0.0001))

func _test_full_kit() -> void:
	print("\n>>> B8. KIT COMPLETO")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var bast: Dictionary = heroes.filter(func(r): return r["id"] == "hero_001")[0]
	var skills := {}
	var passives := {}
	for b in bast["builds"].values():
		for s in b["skills"]:
			skills[s] = true
		for p in b["passives"]:
			passives[p] = true
	_expect("Signature fixa no terceiro slot: %s" % bast.get("signature", ""), String(bast.get("signature", "")) == "skill_bas_011")
	skills[String(bast["signature"])] = true
	_expect("6 skills distintas no total (4 antigas + Impacto + Último Bastião)", skills.size() == 6)
	for build in bast["builds"]:
		_expect("build %s não tem variante _sig (a Signature é o 3º slot)" % build, not String(build).ends_with("_sig"))
	var slot_run := SliceSession.create_run({"hero_001": "controle", "hero_002": "critico", "hero_003": "arcano"}, 10, 3)
	_expect("o Bastião entra na run com 3 skills (2 da build + Signature)", slot_run._heroes["hero_001"]["skills"].size() == 3)
	var early_run := SliceSession.create_run({"hero_001": "controle", "hero_002": "critico", "hero_003": "arcano"}, 9, 3)
	_expect("antes do nível 10 a Signature ainda não está liberada (2 skills)", early_run._heroes["hero_001"]["skills"].size() == 2)
	_expect("a Signature libera no nível 10 (campo signature_unlock_level = %s)" % str(bast.get("signature_unlock_level", "?")), int(bast.get("signature_unlock_level", 0)) == 10)
	_expect("18 nós únicos nas builds (15 de build + 3 Traits), além da identidade %s" % bast["identity_passive"], passives.size() == 18)
	var rows := SliceStats.load_rows("res://data/skills/passives_slice.json", "slice")
	var by_id := {}
	for r in rows:
		by_id[r["id"]] = r
	var missing: Array = []
	for pid in passives:
		if not by_id.has(pid) or String(by_id[pid]["kind"]) == "none":
			missing.append(pid)
	_expect("toda passiva das builds existe e tem efeito (faltam: %s)" % str(missing), missing.is_empty())
	# Toda build cria uma run e termina sem erro nos níveis 1, 5, 10 e 12.
	for build in bast["builds"]:
		for level in [1, 5, 10, 12]:
			var run := SliceSession.create_run({"hero_001": build, "hero_002": "critico", "hero_003": "arcano"}, level, 3)
			run.run_to_end(0.25, 900.0)
			_expect("build %s nível %d roda até o fim sem erro" % [build, level], run.state == "won" or run.state == "lost")

# Regressão (Argos, 2026-09-30): o Julgamento de Ferro disparava antes do dano do próprio contra-ataque e podia
# matar o alvo; o contra-ataque o "derrotava" de novo (oráculo enemy_defeated_twice).
func _test_no_double_defeat() -> void:
	print("\n>>> B9. NENHUM INIMIGO É DERROTADO DUAS VEZES")
	# Determinístico: Julgamento armado + contra-ataque que mata o alvo.
	var det := KitTestSupport.mk([["hero_001", ["skill_bas_007"], ["passive_bas_julgamento_de_ferro"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, {"skill_bas_007": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(det)
	var det_hero: Dictionary = det._heroes["hero_001"]
	det._cast(det_hero, det_hero["skills"][0], [])
	det_hero["judgement_ready"] = true
	var striker: Dictionary = det._enemies[0]
	striker["hp"] = 1.0
	striker["threat"]["hero_001"] = 1.0e6
	var det_events: Array = []
	det._enemy_attack(striker, det_events)
	var defeats_of_striker := det_events.filter(func(e): return e["type"] == "enemy_defeated" and e["uid"] == striker["uid"])
	_expect("contra-ataque + Julgamento: o alvo é derrotado uma única vez", defeats_of_striker.size() == 1)
	for case in [[12, 1], [10, 10], [10, 11], [12, 11], [12, 14]]:
		var run := SliceSession.create_run({"hero_001": "retaliacao", "hero_002": "marca", "hero_003": "controle"}, int(case[0]), int(case[1]))
		var events := run.run_to_end(0.25, 3600.0)
		var seen := {}
		var node := ""
		var duplicated := 0
		for e in events:
			if e["type"] == "encounter_started":
				node = String(e["node_id"])
			elif e["type"] == "enemy_defeated":
				var key := node + ":" + String(e["uid"])
				if seen.has(key):
					duplicated += 1
				seen[key] = true
		_expect("nível %d seed %d: nenhum inimigo derrotado duas vezes" % [case[0], case[1]], duplicated == 0)
