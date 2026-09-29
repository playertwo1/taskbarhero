extends RefCounted
class_name SliceItemStats

## Rolagem determinística dos afixos-base do equipamento do slice.
## Hipótese numérica em docs/04_content/items/CHAPTER_01_ITEM_STATS_PROPOSAL.md.
## Efeitos funcionais de raridade alta ainda não são aplicados.
const BP := {"Comum": 2.0, "Incomum": 3.0, "Raro": 4.0, "Épico": 5.0, "Relíquia": 6.0, "Memória": 6.0}
const SLOT_MULTIPLIER := {"weapon": 1.2, "secondary": 1.0, "armor": 1.2, "accessory": 0.9, "echo": 1.0}
const EFFECT_RESERVE := {"Comum": 0.0, "Incomum": 0.10, "Raro": 0.20, "Épico": 0.35, "Relíquia": 0.50, "Memória": 0.60}

static func roll(row: Dictionary, rarity: String, item_power: int, item_level: int) -> Dictionary:
	if not row.get("allowed_rarities", []).has(rarity):
		return {}
	if item_power < 1 or item_power > 100 or item_level < 1 or item_level > 100:
		return {}
	var factor := 0.60 + 0.80 * float(item_power) / 100.0
	var gross: float = BP[rarity] * SLOT_MULTIPLIER[row["slot"]] * factor
	var available: float = gross * (1.0 - EFFECT_RESERVE[rarity])
	var weights: Dictionary = row.get("stat_weights", {})
	var refs := {"attack": CombatMath.level_value(12.0, 50.0, item_level),
		"max_hp": CombatMath.level_value(115.0, 470.0, item_level),
		"defense": CombatMath.level_value(9.0, 36.0, item_level)}
	return {
		"attack": available * float(weights.get("attack", 0.0)) * 0.01 * refs["attack"],
		"max_hp": available * float(weights.get("max_hp", 0.0)) * 0.01 * refs["max_hp"],
		"defense": available * float(weights.get("defense", 0.0)) * 0.01 * refs["defense"],
		"attack_speed": available * float(weights.get("attack_speed", 0.0)) * 0.006,
		"crit_chance": available * float(weights.get("crit_chance", 0.0)) * 0.0035,
		"skill_haste": available * float(weights.get("skill_haste", 0.0)) * 1.2,
		"tenacity": available * float(weights.get("tenacity", 0.0)) * 1.5,
		"gross_bp": gross,
		"reserved_bp": gross - available,
	}

static func equip(base: Dictionary, hero_id: String, instances: Array, rows: Array) -> Dictionary:
	var stats := base.duplicate(true)
	var by_id := {}
	for row in rows:
		by_id[row["id"]] = row
	var slots := {}
	for instance in instances:
		if not by_id.has(instance.get("id", "")):
			continue
		var row: Dictionary = by_id[instance["id"]]
		if not row.get("compatible_heroes", []).has(hero_id):
			continue
		var slot: String = String(row["slot"])
		var capacity := 2 if slot == "accessory" else 1
		if int(slots.get(slot, 0)) >= capacity:
			continue
		var bonus := roll(row, String(instance.get("rarity", "")), int(instance.get("item_power", 0)), int(instance.get("item_level", 0)))
		if bonus.is_empty():
			continue
		slots[slot] = int(slots.get(slot, 0)) + 1
		for stat in ["attack", "max_hp", "defense", "crit_chance", "skill_haste", "tenacity"]:
			stats[stat] = float(stats[stat]) + float(bonus[stat])
		stats["attack_speed"] = float(stats["attack_speed"]) * (1.0 + float(bonus["attack_speed"]))
	return stats
