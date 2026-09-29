extends RefCounted

## Modelo de loot e economia do ARGOS-SIM (ferramenta de simulação, não runtime).
## Lê as fontes canônicas v0.4 sem copiar valores: chance de equipamento, ouro e materiais por
## inimigo (CHAPTER_01_ENEMIES_CANONICAL.json) e tabelas de raridade/IP (loot_system_contract_v0.4.json).
## Simplificações registradas: Smart Loot 70% itens da party / 30% qualquer item do recorte;
## sem Duplicate Protection, Slot Pity, Reward Choice, Echo ou drops garantidos de primeiro clear.
## O Drop Resolver real é escopo do LOOT-EXPANSION-1.

const CANON := "res://documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/"
const RARITY_NAME := {"COMMON": "Comum", "UNCOMMON": "Incomum", "RARE": "Raro", "EPIC": "Épico", "RELIC": "Relíquia"}
const RESIDUE := "MAT_C1_LUMEN_RESIDUE"

var loot_by_enemy := {}
var contract := {}
var items: Array = []
var rng := RandomNumberGenerator.new()

static func _json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	return null if file == null else JSON.parse_string(file.get_as_text())

func _init(item_rows: Array, seed_value: int) -> void:
	items = item_rows
	rng.seed = seed_value
	var canon = _json(CANON + "CHAPTER_01_ENEMIES_CANONICAL.json")
	if canon is Dictionary:
		for e in canon["enemies"]:
			loot_by_enemy[String(e["identity"]["id"]).to_lower()] = e["loot"]
	var c = _json(CANON + "loot_system_contract_v0.4.json")
	contract = c if c is Dictionary else {}

func is_ready() -> bool:
	return not loot_by_enemy.is_empty() and not contract.is_empty()

func _weighted(table: Dictionary) -> String:
	var roll := rng.randf()
	var acc := 0.0
	var last := ""
	for key in table:
		acc += float(table[key])
		last = key
		if roll < acc:
			return key
	return last

## Recompensas de um inimigo derrotado: ouro, Resíduo e talvez uma instância de equipamento.
func roll_enemy(enemy_id: String, level: int, party: Array) -> Dictionary:
	var out := {"gold": 0, "residue": 0, "item": {}}
	var loot: Dictionary = loot_by_enemy.get(enemy_id, {})
	if loot.is_empty():
		return out
	var gold: Dictionary = loot.get("gold", {})
	if bool(gold.get("enabled", false)) and rng.randf() < float(gold.get("chance", 1.0)):
		out["gold"] = rng.randi_range(int(gold["min"]), int(gold["max"]))
	for m in loot.get("materials", []):
		if m["material_id"] == RESIDUE and rng.randf() < float(m["chance"]):
			out["residue"] += rng.randi_range(int(m["quantity_min"]), int(m["quantity_max"]))
	var eq: Dictionary = loot.get("equipment", {})
	if bool(eq.get("enabled", false)) and rng.randf() < float(eq.get("chance", 0.0)):
		var rarity: String = RARITY_NAME.get(_weighted(contract["rarity_tables"][eq["rarity_table_id"]]), "Comum")
		var ip: Dictionary = contract["item_power_profiles"][eq["item_power_profile"]]
		var item := _pick_item(rarity, party)
		if not item.is_empty():
			out["item"] = {"id": item["id"], "rarity": rarity, "item_power": rng.randi_range(int(ip["min"]), int(ip["max"])), "item_level": level}
	return out

## Smart Loot simplificado: 70% entre itens compatíveis com a party, 30% entre todos; só raridades permitidas.
func _pick_item(rarity: String, party: Array) -> Dictionary:
	var allowed := items.filter(func(r): return r.get("allowed_rarities", []).has(rarity) and r.has("stat_weights"))
	if allowed.is_empty():
		return {}
	var relevant := allowed.filter(func(r):
		for hid in party:
			if r.get("compatible_heroes", []).has(hid):
				return true
		return false)
	var pool := relevant if not relevant.is_empty() and rng.randf() < float(contract["smart_loot"]["relevant_weight"]) else allowed
	return pool[rng.randi_range(0, pool.size() - 1)]

## Valor de comparação de uma instância: BP bruto do roll (orçamento do item).
func score(instance: Dictionary) -> float:
	for r in items:
		if r["id"] == instance["id"]:
			var rolled := SliceItemStats.roll(r, instance["rarity"], int(instance["item_power"]), int(instance["item_level"]))
			return float(rolled.get("gross_bp", 0.0))
	return 0.0

## Melhor equipamento por herói e slot (acessório tem 2 vagas) a partir do inventário.
func best_loadout(inventory: Array, party: Array) -> Dictionary:
	var by_id := {}
	for r in items:
		by_id[r["id"]] = r
	var sorted := inventory.duplicate()
	sorted.sort_custom(func(a, b): return score(a) > score(b))
	var used := {}
	var out := {}
	for hid in party:
		var slots := {}
		var list := []
		for i in sorted.size():
			var inst: Dictionary = sorted[i]
			var row: Dictionary = by_id.get(inst["id"], {})
			if used.has(i) or row.is_empty() or not row.get("compatible_heroes", []).has(hid):
				continue
			var slot: String = row["slot"]
			var cap := 2 if slot == "accessory" else 1
			if int(slots.get(slot, 0)) >= cap:
				continue
			slots[slot] = int(slots.get(slot, 0)) + 1
			used[i] = true
			list.append(inst)
		out[hid] = list
	return out
