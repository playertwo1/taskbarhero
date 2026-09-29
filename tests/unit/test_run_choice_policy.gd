extends Node

var success := true
const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}
const LEVEL := 12

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE RUN CHOICE POLICY (SLICE-1B Plano B) ---")
	var tables := LootRoller.load_tables()
	var items := SliceStats.load_rows("res://data/items/items.json", "slice")
	var catalog := EventDirector.load_catalog()

	# 1. Sem chooser: não trava e termina; o padrão escolhe a opção 0.
	var run := SliceSession.create_run(BUILD, LEVEL, 21, {"loot": LootRoller.create(tables, items, 21), "events": EventDirector.create(catalog, 21)})
	var events := run.run_to_end(0.5)
	_expect("run com loot/eventos termina sem chooser", run.state == "won" or run.state == "lost")
	var poco_choice := ""
	for ev in events:
		if ev["type"] == "event_resolved" and ev["id"] == "event_c1_001":
			poco_choice = String(ev["choice"])
	_expect("o padrão escolhe a opção 0 (curar)", poco_choice == "" or poco_choice == "heal")

	# 2. Com chooser: sempre a última opção (sacrificar no Poço).
	var run2 := SliceSession.create_run(BUILD, LEVEL, 21, {"loot": LootRoller.create(tables, items, 21), "events": EventDirector.create(catalog, 21)})
	var events2 := run2.run_to_end(0.5, 3600.0, func(pending): return pending["options"].size() - 1)
	var sacrificed := false
	for ev in events2:
		if ev["type"] == "event_resolved" and ev["id"] == "event_c1_001":
			sacrificed = ev["choice"] == "sacrifice"
	_expect("o chooser é respeitado (Poço: sacrificar)", sacrificed or run2.state == "lost")

	# 3. Outcome: catálogo só com a Raiz Oca e chance 1.0; escolher "Abrir a raiz" (índice 0).
	var raiz: Dictionary = {}
	for e in catalog["events"]:
		if e["id"] == "event_c1_raiz_oca":
			raiz = e
	var forced := {"random_rules": {"transition_chance": 1.0, "secret_chance": 0.0, "max_random_per_run": 4}, "events": [raiz]}
	var seen := {}
	for seed_value in range(1, 40):
		var r := SliceSession.create_run(BUILD, LEVEL, seed_value, {"loot": LootRoller.create(tables, items, seed_value), "events": EventDirector.create(forced, seed_value)})
		for ev in r.run_to_end(0.5):
			if ev["type"] == "event_resolved" and ev["id"] == "event_c1_raiz_oca":
				seen[String(ev["outcome"])] = true
	_expect("event_resolved traz o outcome da Raiz Oca", seen.has("nothing") or seen.has("spines") or seen.has("cache"))
	_expect("os outcomes são só os declarados", seen.keys().all(func(k): return ["spines", "cache", "nothing"].has(k)))
	var plain := SliceSession.create_run(BUILD, LEVEL, 21, {"loot": LootRoller.create(tables, items, 21), "events": EventDirector.create(catalog, 21)})
	var resolved_outcomes := plain.run_to_end(0.5).filter(func(ev): return ev["type"] == "event_resolved" and ev["id"] == "event_c1_001")
	_expect("escolha sem outcomes devolve outcome vazio", resolved_outcomes.all(func(ev): return ev["outcome"] == ""))

	print("=======================================================")
	print("[%s] TESTE RUN CHOICE POLICY" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
