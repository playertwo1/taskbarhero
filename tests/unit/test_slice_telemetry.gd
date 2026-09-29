extends Node

var success := true

func _ready() -> void:
	print("--- TESTE SLICE TELEMETRY (SLICE-1A-5) ---")
	_test_hand_calculated()
	_test_run_consistency()
	_test_disabled_by_default()
	_test_run_layer()
	print("=======================================================")
	if success:
		print("[PASS] TESTE SLICE TELEMETRY CONCLUÍDO COM SUCESSO")
		get_tree().quit(0)
	else:
		print("[FAIL] TESTE SLICE TELEMETRY FALHOU")
		get_tree().quit(1)

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _test_hand_calculated() -> void:
	print("\n>>> 1. AGREGAÇÃO CALCULADA À MÃO")
	var t := SliceTelemetry.new()
	t.ingest([
		{"type": "encounter_started", "time": 0.0, "node_id": "n1", "party_hp": {}},
		{"type": "skill_cast", "time": 0.5, "hero": "hero_001", "skill": "skill_a"},
		{"type": "hero_attack", "time": 1.0, "source": "hero_001", "target": "x#0", "damage": 10.0, "crit": true},
		{"type": "skill_damage", "time": 1.5, "source": "hero_001", "skill": "skill_a", "target": "x#0", "damage": 20.0},
		{"type": "enemy_staggered", "time": 2.0, "uid": "x#0", "until": 4.0, "interrupted": false},
		{"type": "counter_attack", "time": 3.0, "source": "hero_001", "target": "x#0", "damage": 5.0},
		{"type": "counter_attack", "time": 5.0, "source": "hero_001", "target": "x#0", "damage": 7.0},
		{"type": "enemy_attack", "time": 3.5, "source": "x#0", "target": "hero_002", "damage": 8.0, "heavy": false},
		{"type": "enemy_attack", "time": 3.6, "source": "x#0", "target": "hero_002", "damage": 12.0, "heavy": true},
		{"type": "shield_granted", "time": 3.7, "hero": "hero_002", "amount": 30.0},
		{"type": "shield_absorbed", "time": 3.8, "hero": "hero_002", "amount": 6.0},
		{"type": "healing", "time": 3.9, "source": "hero_003", "target": "hero_002", "amount": 9.0},
		{"type": "perfect_block", "time": 3.95, "hero": "hero_001", "source": "x#0", "heavy": false},
		{"type": "enemy_defeated", "time": 6.0, "uid": "x#0", "id": "x", "xp": 4},
		{"type": "encounter_cleared", "time": 6.0, "node_id": "n1", "duration": 6.0, "party_hp": {}},
	])
	var tot: Dictionary = t.totals
	_expect("dano total 42", is_equal_approx(tot["damage_dealt_total"], 42.0))
	_expect("dano crítico 10", is_equal_approx(tot["critical_damage"], 10.0))
	_expect("dano recebido 20 e maior golpe 12", is_equal_approx(tot["damage_taken_total"], 20.0) and is_equal_approx(tot["largest_hit_received"], 12.0))
	_expect("escudo gerado 30 e consumido 6", is_equal_approx(tot["shield_generated"], 30.0) and is_equal_approx(tot["shield_consumed"], 6.0))
	_expect("cura 9", is_equal_approx(tot["healing_done"], 9.0))
	_expect("1 Perfect Block, 1 abate, 4 XP", tot["perfect_blocks"] == 1 and tot["enemies_defeated"] == 1 and tot["xp_gained"] == 4)
	_expect("skill_a: 1 cast, 1 hit, 20 de dano", t.by_skill["skill_a"]["casts"] == 1 and t.by_skill["skill_a"]["hits"] == 1)
	_expect("dano por fonte separa básico e skill", is_equal_approx(t.damage_by_source["hero_001:basic"], 10.0) and is_equal_approx(t.damage_by_source["hero_001:skill_a"], 20.0))
	_expect("dano recebido por fonte usa o ID do inimigo", is_equal_approx(t.damage_taken_by_source["x"], 20.0))
	_expect("quebra: 1, tempo até quebrar 1.0 s", t.stagger["breaks"] == 1 and is_equal_approx(t.stagger["time_to_break"][0], 1.0))
	_expect("dano durante a quebra 5 (o de t=5 fica fora)", is_equal_approx(t.stagger["damage_during_break"], 5.0))
	var enc: Dictionary = t.encounters[0]
	_expect("encontro: vitória, 6 s, dano 42, recebido 20", enc["victory"] and is_equal_approx(enc["duration"], 6.0) and is_equal_approx(enc["damage_dealt"], 42.0) and is_equal_approx(enc["damage_taken"], 20.0))

func _test_run_consistency() -> void:
	print("\n>>> 2. RUN COMPLETO: CONSISTÊNCIA E NEUTRALIDADE")
	var build := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}
	var with_t := SliceSession.create_run(build, 10, 7, {"telemetry": true, "telemetry_context": {"build": "guardiao"}})
	var plain := SliceSession.create_run(build, 10, 7)
	var events := with_t.run_to_end()
	plain.run_to_end()
	_expect("telemetria não altera o resultado do combate", with_t.state == plain.state and is_equal_approx(with_t.time, plain.time) and with_t.snapshot()["party_hp"] == plain.snapshot()["party_hp"])
	var dealt := 0.0
	var casts := 0
	var cleared := 0
	var defeats := 0
	for ev in events:
		match String(ev["type"]):
			"hero_attack", "skill_damage", "counter_attack", "passive_damage": dealt += float(ev["damage"])
			"skill_cast": casts += 1
			"encounter_cleared": cleared += 1
			"hero_defeated": defeats += 1
	var t := with_t.telemetry
	_expect("dano total bate com a soma dos eventos", is_equal_approx(t.totals["damage_dealt_total"], dealt))
	var by_source := 0.0
	for k in t.damage_by_source:
		by_source += float(t.damage_by_source[k])
	_expect("soma de damage_by_source = total", is_equal_approx(by_source, dealt))
	var cast_sum := 0
	for k in t.by_skill:
		cast_sum += int(t.by_skill[k]["casts"])
	_expect("casts por skill somam os skill_cast", cast_sum == casts and casts > 0)
	var victories := 0
	for enc in t.encounters:
		if enc["victory"]:
			victories += 1
	_expect("encontros vencidos = encounter_cleared", victories == cleared)
	_expect("mortes = hero_defeated", t.totals["hero_defeats"] == defeats)
	_expect("contexto preservado no resumo", with_t.snapshot()["telemetry"]["context"].get("build", "") == "guardiao")

func _test_disabled_by_default() -> void:
	print("\n>>> 3. DESLIGADA POR PADRÃO")
	var run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}, 5, 1)
	run.step(2.0)
	_expect("sem opção não há telemetria nem chave no snapshot", run.telemetry == null and not run.snapshot().has("telemetry"))

func _test_run_layer() -> void:
	print("
>>> 4. CAMADA DA RUN (1B)")
	var t := SliceTelemetry.new()
	t.ingest([
		{"type": "event_offered", "time": 1.0, "id": "event_c1_001", "options": ["Curar", "Sacrificar"]},
		{"type": "event_resolved", "time": 1.0, "id": "event_c1_001", "choice": "heal", "effects": 1},
		{"type": "reward_offered", "time": 2.0, "id": "reward_x", "options": []},
		{"type": "reward_chosen", "time": 2.0, "id": "reward_x", "item": {"id": "item_w_001", "rarity": "Raro"}},
		{"type": "loot_dropped", "time": 2.0, "item": {"id": "item_w_001", "rarity": "Raro"}},
		{"type": "loot_dropped", "time": 3.0, "item": {"id": "item_a_001", "rarity": "Comum"}},
		{"type": "material_dropped", "time": 3.0, "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 2},
	])
	t.record_recycle("Comum", 1)
	var layer: Dictionary = t.summary()["run_layer"]
	_expect("evento oferecido e resolvido contados", layer["events_offered"]["event_c1_001"] == 1 and layer["events_resolved"]["event_c1_001:heal"] == 1)
	_expect("ofertas e escolhas de recompensa", layer["rewards_offered"] == 1 and layer["rewards_chosen"]["Raro"] == 1)
	_expect("loot por raridade e materiais", layer["loot_by_rarity"]["Raro"] == 1 and layer["loot_by_rarity"]["Comum"] == 1 and layer["materials"]["MAT_C1_LUMEN_RESIDUE"] == 2)
	_expect("reciclagem registrada", layer["recycled"]["Comum"] == 1 and layer["residue_from_recycling"] == 1)
