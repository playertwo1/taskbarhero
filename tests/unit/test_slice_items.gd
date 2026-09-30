extends Node

var failed := false

func _check(label: String, condition: bool) -> void:
	if not condition:
		failed = true
		push_error(label)

func _ready() -> void:
	BalanceProfiles.pin_test_units()  # números conferidos à mão em unidades 1× e curva linear
	var rows := SliceStats.load_rows("res://data/items/items.json", "slice")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	_check("18 itens do recorte", rows.size() == 18)
	var by_id := {}
	for row in rows:
		by_id[row["id"]] = row
		var total := 0.0
		for weight in row["stat_weights"].values():
			total += float(weight)
		_check("frações somam 100%%: %s" % row["id"], absf(total - 1.0) < 0.00001)
	var sword: Dictionary = by_id["item_w_001"]
	var rolled := SliceItemStats.roll(sword, "Raro", 20, 10)
	_check("BP bruto da espada rara (nível 3 da escada, 5,25 × 1,2 × 0,76)", absf(float(rolled["gross_bp"]) - 4.788) < 0.00001)
	_check("sem modificador não há reserva de efeito", absf(float(rolled["reserved_bp"])) < 0.00001)
	_check("ATK da espada rara (4,788 × 0,7 × 1,8% × 15,4545)", absf(float(rolled["attack"]) - 0.93235) < 0.0001)
	_check("raridade inválida rejeitada", SliceItemStats.roll(by_id["item_r_004"], "Comum", 20, 10).is_empty())
	var ladder := {"Comum": 2.0, "Incomum": 3.625, "Raro": 5.25, "Épico": 6.875}
	for rarity in ladder:
		var r := SliceItemStats.roll(sword, rarity, 20, 10)
		_check("escada de BP: %s" % rarity, absf(float(r["gross_bp"]) - float(ladder[rarity]) * 1.2 * 0.76) < 0.00001)
	var with_effect := sword.duplicate(true)
	with_effect["modifiers"] = [{"stat": "attack", "op": "FLAT", "value": 1.0}]
	var reserved := SliceItemStats.roll(with_effect, "Raro", 20, 10)
	_check("reserva de efeito (20%) só com modificador", absf(float(reserved["reserved_bp"]) - 0.2 * float(reserved["gross_bp"])) < 0.00001)
	_check("o modificador reduz o status na mesma proporção", absf(float(reserved["attack"]) - 0.8 * float(rolled["attack"])) < 0.0001)
	var relic := SliceItemStats.roll(by_id["item_a_005"], "Relíquia", 20, 10)
	_check("Relíquia fica fora da escada (BP especial 6)", absf(float(relic["gross_bp"]) - 6.0 * 1.2 * 0.76) < 0.00001)
	_check("crítico usa o valor por BP (0,63 pp)", absf(float(SliceItemStats.roll(by_id["item_w_002"], "Raro", 20, 10)["crit_chance"]) - 5.25 * 1.2 * 0.76 * 0.35 * 0.0063) < 0.000001)
	_check("Reforço vem do Ferreiro (+10%)", absf(SliceItemStats.reinforce_bonus() - 0.10) < 0.000001)
	var bastiao: Dictionary = heroes[0]
	var base := SliceStats.hero_stats(bastiao, 10)
	var valid := [{"id": "item_w_001", "rarity": "Raro", "item_power": 20, "item_level": 10}]
	var equipped := SliceItemStats.equip(base, "hero_001", valid, rows)
	_check("espada aumenta ATK", float(equipped["attack"]) > float(base["attack"]))
	var wrong := [{"id": "item_w_006", "rarity": "Raro", "item_power": 20, "item_level": 10}]
	var rejected := SliceItemStats.equip(base, "hero_001", wrong, rows)
	_check("Bastião não equipa cajado", absf(float(rejected["attack"]) - float(base["attack"])) < 0.00001)
	get_tree().quit(1 if failed else 0)
