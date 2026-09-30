extends Node

## `combat_scale`: multiplicar HP, ATK, DEF, as referências de item, DEFENSE_K e o dano mínimo
## não pode mudar o combate. Provas: (1) cada função escala do jeito certo, (2) a mesma
## rota com a mesma seed termina igual em 1×, 8× e 10×, depois de dividir os valores absolutos.

const ROUTE_PATH := "res://data/expedition/route_c1.json"
const Profiles := preload("res://scripts/combat/BalanceProfiles.gd")
const ABSOLUTE_KEYS := ["damage", "amount", "remaining", "hp", "max_hp", "shield", "lost", "absorbed"]

var success := true
var hero_rows: Array = []
var enemy_rows: Array = []
var item_rows: Array = []

func _ready() -> void:
	print("\n--- TESTE COMBAT SCALE ---")
	hero_rows = SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	enemy_rows = SliceStats.load_rows("res://data/enemies/enemies.json", "slice")
	item_rows = SliceStats.load_rows("res://data/items/items.json", "slice")
	_test_default_is_ten()
	_test_combat_math()
	_test_hero_and_enemy_stats()
	_test_item_stats()
	_test_level_curve()
	for k in [8.0, 10.0]:
		_test_run_invariance(k)
	get_tree().quit(0 if success else 1)

func _expect(label: String, condition: bool) -> void:
	if condition:
		print("[PASS] ", label)
	else:
		push_error("[FAIL] " + label)
		success = false

func _near(a: float, b: float, rel: float = 1e-9) -> bool:
	return absf(a - b) <= rel * maxf(1.0, maxf(absf(a), absf(b)))

func _profiles(k: float) -> Dictionary:
	return Profiles.load_profiles("CHAPTER_01", {"combat_scale": k})

func _hero(id: String) -> Dictionary:
	for row in hero_rows:
		if row["id"] == id:
			return row
	return {}

func _test_default_is_ten() -> void:
	_expect("o padrão do núcleo é combat_scale 10 (decidido em 2026-09-30)", _near(Profiles.combat_scale(), 10.0))
	_expect("override não altera o cache", _near(Profiles.combat_scale(_profiles(1.0)), 1.0) and _near(Profiles.combat_scale(), 10.0))
	Profiles.pin_test_units()
	_expect("pin_test_units fixa escala 1 e curva linear para os testes à mão", _near(Profiles.combat_scale(), 1.0))
	Profiles.clear_cache()
	_expect("clear_cache devolve o valor do núcleo", _near(Profiles.combat_scale(), 10.0))

func _test_combat_math() -> void:
	for k in [5.0, 10.0]:
		_expect("mitigação com K escalado é igual (×%d)" % int(k), _near(CombatMath.mitigation(23.6 * k, 0.0, k), CombatMath.mitigation(23.6)))
		_expect("mitigação com K fixo mudaria o jogo (×%d)" % int(k), CombatMath.mitigation(23.6 * k) > CombatMath.mitigation(23.6) + 0.2)
		_expect("golpe escala linearmente (×%d)" % int(k), _near(CombatMath.hit_damage(12.9 * k, 21.5 * k, 0.0, 0.9, k), k * CombatMath.hit_damage(12.9, 21.5, 0.0, 0.9)))
		_expect("dano mínimo escala (×%d)" % int(k), _near(CombatMath.hit_damage(0.5, 500.0 * k, 0.0, 1.0, k), k))
	_expect("sem fator o comportamento é o de sempre", _near(CombatMath.hit_damage(0.5, 500.0), 1.0))

func _test_hero_and_enemy_stats() -> void:
	var row := _hero("hero_001")
	var base := Profiles.hero_stats(row, 10, _profiles(1.0))
	var scaled := Profiles.hero_stats(row, 10, _profiles(10.0))
	for stat in ["max_hp", "attack", "defense"]:
		_expect("herói: %s ×10" % stat, _near(float(scaled[stat]), 10.0 * float(base[stat])))
	for stat in ["attack_speed", "crit_chance", "crit_damage", "skill_haste", "tenacity"]:
		_expect("herói: %s não escala" % stat, _near(float(scaled[stat]), float(base[stat])))
	for enemy in enemy_rows:
		var e1 := Profiles.enemy_stats(enemy, 10, true, _profiles(1.0))
		var e10 := Profiles.enemy_stats(enemy, 10, true, _profiles(10.0))
		var ok: bool = _near(float(e10["max_hp"]), 10.0 * float(e1["max_hp"])) and _near(float(e10["attack"]), 10.0 * float(e1["attack"])) and _near(float(e10["defense"]), 10.0 * float(e1["defense"]))
		ok = ok and _near(float(e10["attack_speed"]), float(e1["attack_speed"])) and _near(float(e10["tenacity"]), float(e1["tenacity"]))
		_expect("inimigo %s: HP/ATK/DEF ×10; velocidade e tenacidade não" % enemy["id"], ok)

func _test_item_stats() -> void:
	for row in item_rows:
		var rarity := String(row["allowed_rarities"][0])
		var r1 := SliceItemStats.roll(row, rarity, 27, 10, _profiles(1.0))
		var r10 := SliceItemStats.roll(row, rarity, 27, 10, _profiles(10.0))
		if r1.is_empty():
			continue
		var ok := true
		for stat in ["attack", "max_hp", "defense"]:
			ok = ok and _near(float(r10[stat]), 10.0 * float(r1[stat]))
		for stat in ["attack_speed", "crit_chance", "skill_haste", "tenacity", "gross_bp"]:
			ok = ok and _near(float(r10[stat]), float(r1[stat]))
		_expect("item %s: ATK/HP/DEF ×10; razões e ratings não" % row["id"], ok)

func _curve_profiles(k: float, p: float) -> Dictionary:
	return Profiles.load_profiles("CHAPTER_01", {"combat_scale": k, "level_curve_p": p})

## `level_curve_p` vale para herói, herói de referência dos inimigos e referência de item,
## e não mexe nos níveis 1 e 100.
func _test_level_curve() -> void:
	var row := _hero("hero_001")
	var lin := _curve_profiles(1.0, 1.0)
	var curved := _curve_profiles(1.0, 0.8)
	for stat in ["max_hp", "attack", "defense"]:
		_expect("p = 0,8 mantém o nível 1 do herói (%s)" % stat, _near(float(Profiles.hero_stats(row, 1, curved)[stat]), float(Profiles.hero_stats(row, 1, lin)[stat])))
		_expect("p = 0,8 mantém o nível 100 do herói (%s)" % stat, _near(float(Profiles.hero_stats(row, 100, curved)[stat]), float(Profiles.hero_stats(row, 100, lin)[stat])))
		var b: Array = row["base_stats"][stat]
		var expected: float = float(b[0]) + (float(b[1]) - float(b[0])) * pow(9.0 / 99.0, 0.8)
		_expect("p = 0,8 no nível 10 segue a fórmula (%s)" % stat, _near(float(Profiles.hero_stats(row, 10, curved)[stat]), expected))
	var boss: Dictionary = {}
	for enemy in enemy_rows:
		if enemy["rank"] == "BOSS":
			boss = enemy
	var e_lin := Profiles.enemy_stats(boss, 10, true, lin)
	var e_cur := Profiles.enemy_stats(boss, 10, true, curved)
	var ref_ratio := (115.0 + 355.0 * pow(9.0 / 99.0, 0.8)) / (115.0 + 355.0 * 9.0 / 99.0)
	_expect("inimigo: o HP do nível 10 usa o mesmo p do herói", _near(float(e_cur["max_hp"]) / float(e_lin["max_hp"]), ref_ratio))
	var sword: Dictionary = {}
	for item in item_rows:
		if item["id"] == "item_w_001":
			sword = item
	var i_lin := SliceItemStats.roll(sword, "Raro", 27, 10, lin)
	var i_cur := SliceItemStats.roll(sword, "Raro", 27, 10, curved)
	var atk_ratio := (12.0 + 38.0 * pow(9.0 / 99.0, 0.8)) / (12.0 + 38.0 * 9.0 / 99.0)
	_expect("item: a referência de ATK no nível do item usa o mesmo p", _near(float(i_cur["attack"]) / float(i_lin["attack"]), atk_ratio))
	_expect("item: razões e ratings não dependem de p", _near(float(i_cur["crit_chance"]), float(i_lin["crit_chance"])) and _near(float(i_cur["gross_bp"]), float(i_lin["gross_bp"])))
	var both := _curve_profiles(10.0, 0.8)
	_expect("escala e curva se compõem (herói)", _near(float(Profiles.hero_stats(row, 10, both)["attack"]), 10.0 * float(Profiles.hero_stats(row, 10, curved)["attack"])))

func _normalize(events: Array, k: float) -> Array:
	var out: Array = []
	for e in events:
		var line := "%s@%.3f" % [e.get("type", ""), float(e.get("time", 0.0))]
		var divisor := 1.0 if String(e.get("type", "")).begins_with("guard") else k  # a Guarda é recurso: não escala
		for key in ABSOLUTE_KEYS:
			if e.has(key) and (e[key] is float or e[key] is int):
				line += " %s=%.3f" % [key, float(e[key]) / divisor]
		for key in ["crit", "source", "target", "hero", "uid"]:
			if e.has(key):
				line += " %s=%s" % [key, str(e[key])]
		out.append(line)
	return out

func _run(k: float) -> Dictionary:
	var route: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ROUTE_PATH))
	var equipment := {
		"hero_001": [{"id": "item_w_001", "rarity": "Raro", "item_power": 27, "item_level": 5}, {"id": "item_a_001", "rarity": "Raro", "item_power": 27, "item_level": 5, "reinforce": 1}],
		"hero_002": [{"id": "item_w_002", "rarity": "Incomum", "item_power": 27, "item_level": 5}],
		"hero_003": [{"id": "item_a_002", "rarity": "Incomum", "item_power": 27, "item_level": 5}],
	}
	var opts := {"seed": 7, "crits": true, "party_level": 5, "balance_profiles": _profiles(k), "items": item_rows, "equipment": equipment}
	# Uma rota inteira com a escada e o Reforço novos: o log tem de ser idêntico em qualquer escala.
	var run := ExpeditionRun.create(route, hero_rows, enemy_rows, opts)
	var events := run.run_to_end(0.25, 3600.0)
	var hp := 0.0
	for hid in run._heroes:
		hp += float(run._heroes[hid]["hp"])
	return {"events": _normalize(events, k), "state": run.state, "hp": hp / k, "time": run.time}

func _test_run_invariance(k: float) -> void:
	var a := _run(1.0)
	var b := _run(k)
	var n := int(k)
	_expect("rota ×%d: mesmo desfecho (%s)" % [n, a["state"]], a["state"] == b["state"])
	_expect("rota ×%d: mesma duração" % n, _near(float(a["time"]), float(b["time"]), 1e-6))
	_expect("rota ×%d: mesmo HP final da party (÷ fator)" % n, _near(float(a["hp"]), float(b["hp"]), 1e-6))
	_expect("rota ×%d: mesmo log de eventos (%d eventos)" % [n, a["events"].size()], a["events"] == b["events"])
	if a["events"] != b["events"]:
		for i in range(mini(a["events"].size(), b["events"].size())):
			if a["events"][i] != b["events"][i]:
				print("  primeira divergência no evento %d:\n    1×: %s\n    ×%d: %s" % [i, a["events"][i], n, b["events"][i]])
				break
		print("  eventos: 1× = %d, ×%d = %d" % [a["events"].size(), n, b["events"].size()])
