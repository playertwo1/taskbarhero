extends Node

const ENEMIES_PATH := "res://data/enemies/enemies.json"
const ITEMS_PATH := "res://data/items/items.json"
const HEROES_PATH := "res://data/heroes/heroes.json"
const EPS := 0.005

var success := true

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE DADOS DO SLICE v0.4 (SLICE-1A-2) ---")
	print("=======================================================")

	_test_enemy_rows()
	_test_item_rows()
	_test_hero_rows()
	_test_legacy_unchanged()
	_test_enemy_derivation()
	_test_hero_derivation()

	print("\n=======================================================")
	if success:
		print("[PASS] TESTE DADOS DO SLICE CONCLUÍDO COM SUCESSO")
		get_tree().quit(0)
	else:
		print("[FAIL] TESTE DADOS DO SLICE FALHOU")
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

func _row(rows: Array, id: String) -> Dictionary:
	for r in rows:
		if r.get("id", "") == id:
			return r
	return {}

func _test_enemy_rows() -> void:
	print("\n>>> 1. INIMIGOS DO SLICE")
	var rows: Array = SliceStats.load_rows(ENEMIES_PATH, "slice")
	_expect("13 inimigos do slice", rows.size() == 13)
	var ranks := {"NORMAL": 0, "ELITE": 0, "MINIBOSS": 0, "BOSS": 0}
	var ids := {}
	for r in rows:
		ids[r["id"]] = true
		ranks[r["rank"]] = int(ranks.get(r["rank"], 0)) + 1
		for f in ["id", "design_id", "legacy_alias", "name", "content_set", "rank", "archetype", "encounter_cost", "damage_types", "stagger_profile"]:
			if not r.has(f):
				_fail("inimigo %s sem o campo %s" % [r.get("id", "?"), f])
		if r["id"] != String(r["design_id"]).to_lower():
			_fail("id do slice deve ser o design_id em minúsculas: %s" % r["id"])
	_expect("10 comuns, 1 elite, 1 mini-boss, 1 boss", ranks["NORMAL"] == 10 and ranks["ELITE"] == 1 and ranks["MINIBOSS"] == 1 and ranks["BOSS"] == 1)
	_expect("IDs únicos", ids.size() == rows.size())

	var aliases := {
		"en_c1_001": "geleia_de_lumen", "en_c1_002": "espirito_de_raiz", "en_c1_003": "gremlin_de_folha",
		"en_c1_004": "javali_de_musgo", "boss_c1_001": "guardiao_cervo_de_pedra",
	}
	var alias_count := 0
	for r in rows:
		var alias = r["legacy_alias"]
		if alias != null:
			alias_count += 1
			if aliases.get(r["id"], "") != alias:
				_fail("alias inesperado em %s: %s" % [r["id"], alias])
	_expect("exatamente 5 aliases, conforme a ponte legada", alias_count == 5)
	for id in aliases.keys():
		if _row(rows, id).is_empty():
			_fail("faltou o inimigo aliado %s" % id)
		elif _row(rows, id)["legacy_alias"] != aliases[id]:
			_fail("alias errado em %s" % id)

func _test_item_rows() -> void:
	print("\n>>> 2. ITENS DO SLICE")
	var rows: Array = SliceStats.load_rows(ITEMS_PATH, "slice")
	_expect("18 itens do slice", rows.size() == 18)
	var slots := {}
	var ids := {}
	for r in rows:
		ids[r["id"]] = true
		slots[r["slot"]] = int(slots.get(r["slot"], 0)) + 1
		for f in ["id", "design_id", "name", "content_set", "slot", "base_rarity", "allowed_rarities", "identity", "modifiers"]:
			if not r.has(f):
				_fail("item %s sem o campo %s" % [r.get("id", "?"), f])
		if r.has("modifiers") and not (r["modifiers"] is Array and r["modifiers"].is_empty()):
			_fail("modifiers deve ficar vazio até a 1B: %s" % r["id"])
		if r.has("allowed_rarities") and not (r["base_rarity"] in r["allowed_rarities"]):
			_fail("raridade base fora das permitidas: %s" % r["id"])
		if r["id"] != String(r["design_id"]).to_lower():
			_fail("id do slice deve ser o design_id em minúsculas: %s" % r["id"])
	_expect("IDs únicos", ids.size() == rows.size())
	_expect("slots: 4 armas, 6 secundários, 5 armaduras, 3 acessórios", slots.get("weapon", 0) == 4 and slots.get("secondary", 0) == 6 and slots.get("armor", 0) == 5 and slots.get("accessory", 0) == 3)
	_expect("Casca do Guardião é Relíquia", _row(rows, "item_a_005").get("base_rarity", "") == "Relíquia")
	_expect("Arco de Folha Tensa é arma Incomum", _row(rows, "item_w_002").get("slot", "") == "weapon" and _row(rows, "item_w_002").get("base_rarity", "") == "Incomum")
	for excluded in ["item_e_001", "item_e_005"]:
		_expect("%s fora do slice" % excluded, _row(rows, excluded).is_empty())

func _test_hero_rows() -> void:
	print("\n>>> 3. TRIO DO SLICE")
	var rows: Array = SliceStats.load_rows(HEROES_PATH, "slice")
	_expect("3 heróis do slice", rows.size() == 3)
	var expected := {"hero_001": "bastiao", "hero_002": "flecha", "hero_003": "iris"}
	for id in expected.keys():
		var r := _row(rows, id)
		if r.is_empty():
			_fail("faltou %s" % id)
		elif r.get("legacy_alias", "") != expected[id]:
			_fail("alias errado em %s" % id)
		else:
			print("[PASS] %s -> %s" % [id, expected[id]])

func _test_legacy_unchanged() -> void:
	print("\n>>> 4. LEGADO INALTERADO E SEM VAZAMENTO")
	GameManager.load_enemies_database()
	_expect("carregamento padrão de inimigos: 11 legados", GameManager.enemies_database.size() == 11)
	for e in GameManager.enemies_database:
		if e.get("content_set", "legacy") != "legacy":
			_fail("linha do slice vazou para o carregador legado: %s" % e.get("id", "?"))
	LootManager.load_database()
	_expect("carregamento padrão de itens: 15 legados", LootManager.items_database.size() == 15)
	for it in LootManager.items_database:
		if it.get("content_set", "legacy") != "legacy":
			_fail("linha do slice vazou para o carregador legado: %s" % it.get("id", "?"))
	_expect("load_rows legacy devolve 11 inimigos", SliceStats.load_rows(ENEMIES_PATH, "legacy").size() == 11)
	_expect("load_rows legacy devolve 15 itens", SliceStats.load_rows(ITEMS_PATH, "legacy").size() == 15)

# Valores esperados calculados por tools/balance/slice_baseline.py (fórmulas do contrato).
func _test_enemy_derivation() -> void:
	print("\n>>> 5. STATS DERIVADOS DOS INIMIGOS")
	var rows: Array = SliceStats.load_rows(ENEMIES_PATH, "slice")
	var geleia := SliceStats.enemy_stats(_row(rows, "en_c1_001"), 1)
	_check("Geleia nível 1: HP", geleia["max_hp"], 97.75)
	_check("Geleia nível 1: ATK (com enemy_damage_scale)", geleia["attack"], 4.5)
	_check("Geleia nível 1: DEF", geleia["defense"], 6.75)
	_check("Geleia nível 1: attack_speed", geleia["attack_speed"], 1.0)
	_check("Geleia nível 1: tenacidade", geleia["tenacity"], 0.0)
	var anci := SliceStats.enemy_stats(_row(rows, "el_c1_001"), 2)
	_check("Geleia Anciã nível 2: HP", anci["max_hp"], 231.8354)
	_check("Geleia Anciã nível 2: tenacidade de elite", anci["tenacity"], 25.0)
	var rainha := SliceStats.enemy_stats(_row(rows, "mb_c1_001"), 3)
	_check("Rainha nível 3: HP", rainha["max_hp"], 726.9217)
	_check("Rainha nível 3: ATK", rainha["attack"], 7.4212)
	var boss := SliceStats.enemy_stats(_row(rows, "boss_c1_001"), 5)
	_check("Guardião nível 5: HP sem escala de party", boss["max_hp"], 3621.6162)
	_check("Guardião nível 5: DEF", boss["defense"], 18.9205)
	_check("Guardião nível 5: attack_speed (Heavy)", boss["attack_speed"], 0.7)
	_check("Guardião nível 5: tenacidade de boss", boss["tenacity"], 100.0)
	var boss_party := SliceStats.enemy_stats(_row(rows, "boss_c1_001"), 5, true)
	_check("Guardião nível 5: HP com escala de party ×1,5 (BOSS, v0.5)", boss_party["max_hp"], 3621.6162 * 1.5)
	var rainha_party := SliceStats.enemy_stats(_row(rows, "mb_c1_001"), 3, true)
	_check("Rainha nível 3: HP com escala de party ×3", rainha_party["max_hp"], 726.9217 * 3.0)
	var geleia_party := SliceStats.enemy_stats(_row(rows, "en_c1_001"), 1, true)
	_check("comum não recebe escala de party", geleia_party["max_hp"], 97.75)
	var javali := SliceStats.enemy_stats(_row(rows, "en_c1_004"), 2)
	_check("Javali de Musgo nível 2 (Heavy): HP", javali["max_hp"], 166.0202)
	_check("Javali de Musgo nível 2: attack_speed", javali["attack_speed"], 0.7)

func _test_hero_derivation() -> void:
	print("\n>>> 6. STATS DERIVADOS DO TRIO")
	var rows: Array = SliceStats.load_rows(HEROES_PATH, "slice")
	var b1 := SliceStats.hero_stats(_row(rows, "hero_001"), 1)
	_check("Bastião nível 1: HP", b1["max_hp"], 160.0)
	_check("Bastião nível 1: ATK", b1["attack"], 10.0)
	_check("Bastião nível 1: DEF", b1["defense"], 18.0)
	_check("Bastião: attack_speed", b1["attack_speed"], 0.8)
	_check("Bastião: tenacidade", b1["tenacity"], 20.0)
	var b5 := SliceStats.hero_stats(_row(rows, "hero_001"), 5)
	_check("Bastião nível 5: HP", b5["max_hp"], 181.8182)
	_check("Bastião nível 5: ATK", b5["attack"], 11.2929)
	_check("Bastião nível 5: DEF", b5["defense"], 20.5051)
	var f1 := SliceStats.hero_stats(_row(rows, "hero_002"), 1)
	_check("Flecha nível 1: ATK", f1["attack"], 14.0)
	_check("Flecha: crit_chance", f1["crit_chance"], 0.10)
	_check("Flecha: crit_damage", f1["crit_damage"], 1.6)
	var i5 := SliceStats.hero_stats(_row(rows, "hero_003"), 5)
	_check("Íris nível 5: HP", i5["max_hp"], 105.7071)
	_check("Íris nível 5: ATK", i5["attack"], 16.9394)
	_check("Íris: skill_haste", i5["skill_haste"], 15.0)
