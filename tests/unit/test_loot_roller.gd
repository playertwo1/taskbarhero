extends Node

var success := true
var tables: Dictionary
var items: Array

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE LOOT ROLLER (SLICE-1B) ---")
	tables = LootRoller.load_tables()
	items = SliceStats.load_rows("res://data/items/items.json", "slice")
	_test_tables_valid()
	_test_determinism()
	_test_normal_drop_rates()
	_test_elite_and_choices()
	_test_boss()
	_test_event_rewards()
	print("=======================================================")
	print("[%s] TESTE LOOT ROLLER" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _row(id: String) -> Dictionary:
	for r in SliceStats.load_rows("res://data/enemies/enemies.json", "slice"):
		if r["id"] == id:
			return r
	return {}

func _test_tables_valid() -> void:
	print("\n>>> 1. TABELAS")
	_expect("tabelas carregadas", not tables.is_empty())
	for key in tables["rarity"]:
		var total := 0.0
		for r in tables["rarity"][key]:
			total += float(tables["rarity"][key][r])
		_expect("tabela %s soma 1" % key, absf(total - 1.0) < 0.0005)

func _test_determinism() -> void:
	print("\n>>> 2. DETERMINISMO")
	var a := LootRoller.create(tables, items, 42)
	var b := LootRoller.create(tables, items, 42)
	var c := LootRoller.create(tables, items, 43)
	var seq_a := []
	var seq_b := []
	var seq_c := []
	for i in 50:
		seq_a.append(a.roll_enemy_drop(_row("en_c1_001"), 3))
		seq_b.append(b.roll_enemy_drop(_row("en_c1_001"), 3))
		seq_c.append(c.roll_enemy_drop(_row("en_c1_001"), 3))
	_expect("mesma seed, mesma sequência", seq_a == seq_b)
	_expect("seed diferente, sequência diferente", seq_a != seq_c)

func _test_normal_drop_rates() -> void:
	print("\n>>> 3. TAXAS DO INIMIGO COMUM")
	var roller := LootRoller.create(tables, items, 7)
	var geleia := _row("en_c1_001")
	var equip := 0
	var residue := 0
	var rarity := {"Comum": 0, "Incomum": 0, "Raro": 0}
	var n := 20000
	var in_range := true
	for i in n:
		var drop := roller.roll_enemy_drop(geleia, 3)
		for inst in drop["items"]:
			equip += 1
			rarity[inst["rarity"]] += 1
			var r: Array = tables["item_power"]["NORMAL"]
			in_range = in_range and inst["item_power"] >= r[0] and inst["item_power"] <= r[1] and inst["item_level"] == 3
		residue += int(drop["materials"].get("MAT_C1_LUMEN_RESIDUE", 0))
	_expect("equipamento ≈ 10%% (%.3f)" % (float(equip) / n), absf(float(equip) / n - 0.10) < 0.01)
	_expect("Resíduo ≈ 65%% (%.3f)" % (float(residue) / n), absf(float(residue) / n - 0.65) < 0.02)
	_expect("Comum é a raridade mais frequente", rarity["Comum"] > rarity["Incomum"] and rarity["Incomum"] > rarity["Raro"])
	_expect("item_power e nível dentro da faixa", in_range)

func _test_elite_and_choices() -> void:
	print("\n>>> 4. ELITE E MINI-BOSS")
	var roller := LootRoller.create(tables, items, 9)
	var drop := roller.roll_enemy_drop(_row("el_c1_001"), 3)
	_expect("elite não rola equipamento comum", drop["items"].is_empty())
	_expect("elite dá 1–2 Resíduos", int(drop["materials"]["MAT_C1_LUMEN_RESIDUE"]) >= 1 and int(drop["materials"]["MAT_C1_LUMEN_RESIDUE"]) <= 2)
	var mb := roller.roll_enemy_drop(_row("mb_c1_001"), 3)
	_expect("mini-boss dá 2–4 Resíduos", int(mb["materials"]["MAT_C1_LUMEN_RESIDUE"]) >= 2 and int(mb["materials"]["MAT_C1_LUMEN_RESIDUE"]) <= 4)
	for kind in ["ELITE", "MINIBOSS"]:
		var options := roller.roll_choice(kind, 3)
		var ids := {}
		for o in options:
			ids[o["id"]] = true
		_expect("%s oferece 3 itens distintos" % kind, options.size() == 3 and ids.size() == 3)
		if kind == "MINIBOSS":
			var all_rare := true
			for o in options:
				all_rare = all_rare and o["rarity"] == "Raro"
			_expect("mini-boss oferece só Raro", all_rare)

func _test_boss() -> void:
	print("\n>>> 5. BOSS")
	var roller := LootRoller.create(tables, items, 11)
	var first := roller.roll_boss(true, 5)
	_expect("primeiro clear: Casca do Guardião", first["items"].size() == 1 and first["items"][0]["id"] == "item_a_005" and first["items"][0]["rarity"] == "Relíquia")
	var epic := true
	for o in first["choice"]:
		epic = epic and o["rarity"] == "Épico"
	_expect("primeiro clear: escolha de 3 Épicos", first["choice"].size() == 3 and epic)
	var repeat := roller.roll_boss(false, 5)
	_expect("repetição: 1 drop e nenhuma escolha", repeat["items"].size() == 1 and repeat["choice"].is_empty())

func _test_event_rewards() -> void:
	print("\n>>> 6. RECOMPENSAS DE EVENTO")
	var roller := LootRoller.create(tables, items, 13)
	var ok := true
	for i in 200:
		var options := roller.roll_event_choice(3, "Raro")
		var has_rare := false
		for o in options:
			has_rare = has_rare or o["rarity"] == "Raro" or o["rarity"] == "Épico"
		ok = ok and options.size() == 3 and has_rare
	_expect("200 escolhas de evento: sempre 3 itens e ao menos 1 Raro", ok)
	var inst := roller.roll_event_item("Incomum", 3)
	_expect("item de evento respeita a raridade pedida", inst["rarity"] == "Incomum")
