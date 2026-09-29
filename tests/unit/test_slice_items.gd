extends Node

var failed := false

func _check(label: String, condition: bool) -> void:
	if not condition:
		failed = true
		push_error(label)

func _ready() -> void:
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
	_check("BP bruto da espada rara", absf(float(rolled["gross_bp"]) - 3.648) < 0.00001)
	_check("ATK da espada rara", absf(float(rolled["attack"]) - 0.31572) < 0.0001)
	_check("raridade inválida rejeitada", SliceItemStats.roll(by_id["item_r_004"], "Comum", 20, 10).is_empty())
	var bastiao: Dictionary = heroes[0]
	var base := SliceStats.hero_stats(bastiao, 10)
	var valid := [{"id": "item_w_001", "rarity": "Raro", "item_power": 20, "item_level": 10}]
	var equipped := SliceItemStats.equip(base, "hero_001", valid, rows)
	_check("espada aumenta ATK", float(equipped["attack"]) > float(base["attack"]))
	var wrong := [{"id": "item_w_006", "rarity": "Raro", "item_power": 20, "item_level": 10}]
	var rejected := SliceItemStats.equip(base, "hero_001", wrong, rows)
	_check("Bastião não equipa cajado", absf(float(rejected["attack"]) - float(base["attack"])) < 0.00001)
	get_tree().quit(1 if failed else 0)
