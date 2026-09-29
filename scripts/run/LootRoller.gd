extends RefCounted
class_name LootRoller

## Sorteio de loot do slice (SLICE-1B). Puro: sem autoload, sem nós.
## Tabelas (HIPÓTESE): data/loot/drops_c1.json. RNG derivado da seed e separado do combate.
## Ordem de consumo do RNG é fixa (equipamento, depois materiais) para manter o determinismo.

const TABLES_PATH := "res://data/loot/drops_c1.json"
const RARITY_ORDER := ["Comum", "Incomum", "Raro", "Épico", "Relíquia"]

var _tables: Dictionary = {}
var _items: Array = []
var _rng := RandomNumberGenerator.new()

static func load_tables() -> Dictionary:
	var file := FileAccess.open(TABLES_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

static func derive_seed(base: int, salt: String) -> int:
	return ("%d:%s" % [base, salt]).hash()

static func create(tables: Dictionary, items: Array, seed_value: int) -> LootRoller:
	var roller := LootRoller.new()
	roller._tables = tables
	roller._items = items
	roller._rng.seed = derive_seed(seed_value, "loot")
	return roller

static func make_instance(item_id: String, rarity: String, item_power: int, item_level: int) -> Dictionary:
	return {"id": item_id, "rarity": rarity, "item_power": item_power, "item_level": item_level}

static func rarity_rank(rarity: String) -> int:
	return RARITY_ORDER.find(rarity)

func _weighted(table: Dictionary) -> String:
	var total := 0.0
	for key in table:
		total += float(table[key])
	var roll := _rng.randf() * total
	var acc := 0.0
	var last := ""
	for key in table:
		acc += float(table[key])
		last = String(key)
		if roll < acc:
			return last
	return last

func _pool(rarity: String) -> Array:
	var out: Array = []
	for row in _items:
		if row["allowed_rarities"].has(rarity) and (rarity == "Relíquia" or String(row["base_rarity"]) != "Relíquia"):
			out.append(row)
	return out

func _power(profile: String) -> int:
	var range_: Array = _tables["item_power"][profile]
	return _rng.randi_range(int(range_[0]), int(range_[1]))

func _roll_item(rarity: String, profile: String, level: int, exclude: Array = []) -> Dictionary:
	var pool: Array = _pool(rarity).filter(func(row): return not exclude.has(row["id"]))
	if pool.is_empty():
		pool = _pool(rarity)
	if pool.is_empty():
		return {}
	var row: Dictionary = pool[_rng.randi_range(0, pool.size() - 1)]
	return make_instance(String(row["id"]), rarity, _power(profile), level)

## Drops de um inimigo derrotado: equipamento (chance por posto) e materiais.
func roll_enemy_drop(enemy_row: Dictionary, level: int) -> Dictionary:
	var rank := String(enemy_row["rank"])
	var out := {"items": [], "materials": {}}
	var chance := float(_tables["equipment_chance"].get(rank, 0.0))
	if chance > 0.0 and _rng.randf() < chance:
		var inst := _roll_item(_weighted(_tables["rarity"][rank]), rank, level)
		if not inst.is_empty():
			out["items"].append(inst)
	for entry in _tables["materials"].get(String(enemy_row["id"]), []):
		if _rng.randf() < float(entry["chance"]):
			var qty := _rng.randi_range(int(entry["min"]), int(entry["max"]))
			out["materials"][entry["id"]] = int(out["materials"].get(entry["id"], 0)) + qty
	return out

func _distinct_options(table_key: String, profile: String, level: int, count: int) -> Array:
	var options: Array = []
	var used: Array = []
	for _i in count:
		var inst := _roll_item(_weighted(_tables["rarity"][table_key]), profile, level, used)
		if inst.is_empty():
			continue
		used.append(inst["id"])
		options.append(inst)
	return options

## Reward Choice de elite/mini-boss (kind = "ELITE" | "MINIBOSS").
func roll_choice(kind: String, level: int) -> Array:
	return _distinct_options(kind, kind, level, int(_tables["reward_choice_options"]))

## Escolha de evento: 3 itens e ao menos 1 com raridade >= min_rarity (o primeiro é forçado se preciso).
func roll_event_choice(level: int, min_rarity: String) -> Array:
	var options := _distinct_options("EVENT_REWARD", "EVENT_REWARD", level, int(_tables["reward_choice_options"]))
	var floor_rank := rarity_rank(min_rarity)
	for inst in options:
		if rarity_rank(String(inst["rarity"])) >= floor_rank:
			return options
	if options.is_empty():
		return options
	var used: Array = []
	for inst in options:
		used.append(inst["id"])
	var forced := _roll_item(min_rarity, "EVENT_REWARD", level, used)
	if not forced.is_empty():
		options[0] = forced
	return options

func roll_event_item(rarity: String, level: int) -> Dictionary:
	return _roll_item(rarity, "EVENT_REWARD", level)

## Boss: no primeiro clear, Casca do Guardião + escolha de 3 Épicos; depois, 1 drop pela tabela BOSS.
func roll_boss(first_clear: bool, level: int) -> Dictionary:
	if first_clear:
		var relic := make_instance(String(_tables["relic_item_id"]), "Relíquia", _power("BOSS"), level)
		return {"items": [relic], "choice": _distinct_options("BOSS_FIRST_CLEAR", "BOSS", level, int(_tables["reward_choice_options"]))}
	var inst := _roll_item(_weighted(_tables["rarity"]["BOSS"]), "BOSS", level)
	return {"items": [inst] if not inst.is_empty() else [], "choice": []}
