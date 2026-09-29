extends Node

var success := true
var tables: Dictionary
var items: Array
var catalog: Dictionary

const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}
const LEVEL := 12

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE EXPEDITION CHOICES (SLICE-1B) ---")
	tables = LootRoller.load_tables()
	items = SliceStats.load_rows("res://data/items/items.json", "slice")
	catalog = EventDirector.load_catalog()
	_test_neutral_without_options()
	_test_reward_choice_pauses()
	_test_poco_choices()
	_test_effects()
	_test_determinism_and_separation()
	_test_boss_first_clear()
	print("=======================================================")
	print("[%s] TESTE EXPEDITION CHOICES" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _run(seed_value: int, extra: Dictionary = {}) -> ExpeditionRun:
	var opts := {"loot": LootRoller.create(tables, items, seed_value), "events": EventDirector.create(catalog, seed_value)}
	opts.merge(extra, true)
	return SliceSession.create_run(BUILD, LEVEL, seed_value, opts)

## Roda até o fim escolhendo sempre a opção `pick`; devolve todos os eventos.
func _play(run: ExpeditionRun, pick: int = 0) -> Array:
	var all: Array = []
	var guard := 0
	while run.state != "won" and run.state != "lost" and guard < 20000:
		guard += 1
		if run.state == "choice":
			all.append_array(run.choose(mini(pick, run.pending["options"].size() - 1)))
		else:
			all.append_array(run.step(0.5))
	return all

func _test_neutral_without_options() -> void:
	print("\n>>> 1. NEUTRALIDADE SEM OPÇÕES")
	var plain := SliceSession.create_run(BUILD, LEVEL, 4)
	plain.run_to_end()
	var loot_only := SliceSession.create_run(BUILD, LEVEL, 4, {"loot": LootRoller.create(tables, items, 4)})
	var guard := 0
	while loot_only.state != "won" and loot_only.state != "lost" and guard < 20000:
		guard += 1
		if loot_only.state == "choice":
			loot_only.choose(0)
		else:
			loot_only.step(0.25)
	_expect("loot ligado (sem eventos) não altera o resultado do combate", plain.state == loot_only.state)
	_expect("mesmo HP final da party", plain.snapshot()["party_hp"] == loot_only.snapshot()["party_hp"])

func _test_reward_choice_pauses() -> void:
	print("\n>>> 2. REWARD CHOICE PAUSA A RUN")
	var run := _run(21)
	var guard := 0
	while run.state != "choice" and run.state != "won" and run.state != "lost" and guard < 5000:
		guard += 1
		run.step(0.5)
	_expect("a run pausa em uma escolha", run.state == "choice")
	var t_before := run.time
	run.step(30.0)
	_expect("em `choice` o tempo não avança", is_equal_approx(run.time, t_before))
	_expect("escolha inválida é ignorada", run.choose(99).is_empty() and run.state == "choice")
	var kind := String(run.pending["kind"])
	var count_before: int = run.rewards["items"].size()
	var events := run.choose(0)
	_expect("escolher gera eventos", not events.is_empty())
	if kind == "reward":
		_expect("a escolha entra no livro-razão como item", run.rewards["items"].size() == count_before + 1)

func _all_full(run: ExpeditionRun) -> bool:
	for p in run.snapshot()["party"]:
		if not is_equal_approx(float(p["hp"]), float(p["max_hp"])):
			return false
	return true

func _test_poco_choices() -> void:
	print("\n>>> 3. POÇO DE LÚMEN")
	for pick in [0, 1]:
		var run := _run(33)
		var reached := false
		var guard := 0
		while run.state != "won" and run.state != "lost" and guard < 20000:
			guard += 1
			if run.state != "choice":
				run.step(0.5)
				continue
			if run.pending["id"] != "event_c1_001":
				run.choose(0)
				continue
			var hp_before: Dictionary = run.snapshot()["party_hp"].duplicate()
			var was_full := _all_full(run)
			run.choose(pick)
			reached = true
			var hp_after: Dictionary = run.snapshot()["party_hp"]
			if pick == 0:
				var not_lower := true
				var healed := false
				for hid in hp_after:
					not_lower = not_lower and hp_after[hid] >= hp_before[hid]
					healed = healed or hp_after[hid] > hp_before[hid]
				_expect("curar nunca reduz HP e cura quem estava ferido", not_lower and (healed or was_full))
			else:
				var hurt := true
				for hid in hp_after:
					hurt = hurt and hp_after[hid] >= 1.0 and hp_after[hid] <= hp_before[hid]
				_expect("sacrificar reduz HP sem matar (mínimo 1)", hurt)
				_expect("sacrificar abre uma escolha de recompensa", run.state == "choice" and run.pending["kind"] == "reward")
			break
		_expect("o Poço apareceu (escolha %d)" % pick, reached)

func _test_effects() -> void:
	print("\n>>> 4. EFEITOS DE EVENTO")
	var forced := {"random_rules": {"transition_chance": 1.0, "secret_chance": 0.0, "max_random_per_run": 4},
		"events": [{"id": "ev_buff", "kind": "random", "weight": 1, "once_per_save": false, "conditions": [],
			"choices": [{"id": "go", "label": "go", "effects": [
				{"type": "modify_next_encounter", "stat": "attack", "op": "ADD_PERCENT", "value": 0.5, "encounters": 1},
				{"type": "modify_next_encounter", "mark_first_enemy": true, "encounters": 1},
				{"type": "set_flag", "flag": "f1"}, {"type": "reveal_lore", "text_id": "L1"},
				{"type": "grant_material", "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 3},
				{"type": "damage_fraction", "scope": "all", "value": 5.0}]}]}]}
	_expect("catálogo de teste válido", EventDirector.validate(forced).is_empty())
	var run := _run(5, {"events": EventDirector.create(forced, 5)})
	var events := _play(run)
	var types := {}
	for ev in events:
		types[ev["type"]] = int(types.get(ev["type"], 0)) + 1
	_expect("evento oferecido e resolvido", types.get("event_offered", 0) >= 1 and types.get("event_resolved", 0) >= 1)
	_expect("flag, lore e material chegam ao livro-razão", run.rewards["flags"].has("f1") and run.rewards["lore"].has("L1") and int(run.rewards["materials"].get("MAT_C1_LUMEN_RESIDUE", 0)) >= 3)
	var min_hp := INF
	for ev in events:
		if ev["type"] == "event_damage":
			min_hp = minf(min_hp, float(ev["remaining"]))
	_expect("dano de evento nunca deixa ninguém abaixo de 1 HP", min_hp >= 1.0 - 0.0001)
	_expect("modificadores do próximo encontro registrados", types.get("next_encounter_modified", 0) >= 2)

func _test_determinism_and_separation() -> void:
	print("\n>>> 5. DETERMINISMO E RNG SEPARADO")
	var a := _play(_run(77))
	var b := _play(_run(77))
	_expect("mesma seed e escolhas: mesmos eventos", a == b)
	var no_chance := {"random_rules": {"transition_chance": 0.0, "secret_chance": 0.0, "max_random_per_run": 0}, "events": EventDirector.load_catalog()["events"]}
	# O Poço e a Reserva são fixos e continuam valendo; sem chance de sorteio, só o loot muda o mundo.
	var quiet := _run(9, {"events": EventDirector.create(no_chance, 9)})
	var events_quiet := _play(quiet, 0)
	var random_offered := 0
	for ev in events_quiet:
		if ev["type"] == "event_offered" and not ["event_c1_001", "event_c1_reserva_residuo"].has(ev["id"]):
			random_offered += 1
	_expect("sem chance de sorteio nenhum evento aleatório aparece", random_offered == 0)

func _test_boss_first_clear() -> void:
	print("\n>>> 6. BOSS")
	var run := _run(101, {"first_clear": true})
	var events := _play(run, 0)
	if run.state != "won":
		_expect("a run de teste (nível %d, seed 101) venceu; ajuste LEVEL se o balanceamento mudou" % LEVEL, false)
		return
	var relic := false
	for ev in events:
		if ev["type"] == "loot_dropped" and ev["item"]["id"] == "item_a_005":
			relic = true
	_expect("primeiro clear entrega a Casca do Guardião", relic)
