extends RefCounted
class_name SliceItemStats

## Rolagem determinística dos afixos-base do equipamento do slice.
## O orçamento (BP por nível de raridade, multiplicador de slot, valor por BP) vem de
## `combat_core.json → item_budget`; decisões em
## docs/06_balance/v1/04_ITENS_RARIDADE.md §2 (decisões de 2026-09-30).
## Efeitos funcionais (modificadores) ainda não são aplicados; a reserva de BP para efeito
## só é descontada de um item que tem modificador, então hoje todo o BP vira status.

## Reforço do Ferreiro: a autoridade é `data/progression/blacksmith_slice.json`.
const BLACKSMITH_PATH := "res://data/progression/blacksmith_slice.json"

static var _reinforce_cache: float = -1.0

static func reinforce_bonus() -> float:
	if _reinforce_cache < 0.0:
		var file := FileAccess.open(BLACKSMITH_PATH, FileAccess.READ)
		var parsed = JSON.parse_string(file.get_as_text()) if file != null else null
		_reinforce_cache = float(parsed["reinforce"]["stat_bonus"]) if parsed is Dictionary else 0.0
	return _reinforce_cache

## BP base da raridade: nível da escada (`bp_by_level`) ou BP especial (Relíquia, Memória).
## Devolve -1 para uma raridade desconhecida.
static func base_bp(budget: Dictionary, rarity: String) -> float:
	var level := int(budget["rarity_level"].get(rarity, 0))
	if level >= 1 and level <= budget["bp_by_level"].size():
		return float(budget["bp_by_level"][level - 1])
	return float(budget["special_bp"].get(rarity, -1.0))

## `profiles` define a referência de herói, o `combat_scale`, a curva de nível e o orçamento;
## vazio usa o perfil padrão.
static func roll(row: Dictionary, rarity: String, item_power: int, item_level: int, profiles: Dictionary = {}) -> Dictionary:
	if not row.get("allowed_rarities", []).has(rarity):
		return {}
	if item_power < 1 or item_power > 100 or item_level < 1 or item_level > 100:
		return {}
	var p := profiles if not profiles.is_empty() else BalanceProfiles.resolved()
	var budget: Dictionary = p["item_budget"]
	var bp := base_bp(budget, rarity)
	if bp < 0.0:
		return {}
	var factor := 0.60 + 0.80 * float(item_power) / 100.0
	var gross: float = bp * float(budget["slot_multiplier"][row["slot"]]) * factor
	var reserve := float(budget["effect_reserve"].get(rarity, 0.0)) if not row.get("modifiers", []).is_empty() else 0.0
	var available: float = gross * (1.0 - reserve)
	var weights: Dictionary = row.get("stat_weights", {})
	var value: Dictionary = budget["value_per_bp"]
	var hero_ref: Dictionary = p["reference_hero"]
	var scale := BalanceProfiles.combat_scale(p)
	var curve := BalanceProfiles.level_curve_p(p)
	var refs := {"attack": CombatMath.level_value(hero_ref["attack"][0], hero_ref["attack"][1], item_level, curve) * scale,
		"max_hp": CombatMath.level_value(hero_ref["max_hp"][0], hero_ref["max_hp"][1], item_level, curve) * scale,
		"defense": CombatMath.level_value(hero_ref["defense"][0], hero_ref["defense"][1], item_level, curve) * scale}
	return {
		"attack": available * float(weights.get("attack", 0.0)) * float(value["attack"]) * refs["attack"],
		"max_hp": available * float(weights.get("max_hp", 0.0)) * float(value["max_hp"]) * refs["max_hp"],
		"defense": available * float(weights.get("defense", 0.0)) * float(value["defense"]) * refs["defense"],
		"attack_speed": available * float(weights.get("attack_speed", 0.0)) * float(value["attack_speed"]),
		"crit_chance": available * float(weights.get("crit_chance", 0.0)) * float(value["crit_chance"]),
		"skill_haste": available * float(weights.get("skill_haste", 0.0)) * float(value["skill_haste"]),
		"tenacity": available * float(weights.get("tenacity", 0.0)) * float(value["tenacity"]),
		"gross_bp": gross,
		"reserved_bp": gross - available,
	}

## Reforço (Ferreiro): cada nível soma `reinforce_bonus` (fração) aos afixos-base do item.
## Sem `reinforce_bonus` explícito, vale o de `blacksmith_slice.json`.
static func equip(base: Dictionary, hero_id: String, instances: Array, rows: Array, reinforce_bonus_override: float = -1.0, profiles: Dictionary = {}) -> Dictionary:
	var reinforce_per_level := reinforce_bonus_override if reinforce_bonus_override >= 0.0 else reinforce_bonus()
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
		var bonus := roll(row, String(instance.get("rarity", "")), int(instance.get("item_power", 0)), int(instance.get("item_level", 0)), profiles)
		if bonus.is_empty():
			continue
		slots[slot] = int(slots.get(slot, 0)) + 1
		var scale := 1.0 + reinforce_per_level * int(instance.get("reinforce", 0))
		for stat in ["attack", "max_hp", "defense", "crit_chance", "skill_haste", "tenacity"]:
			stats[stat] = float(stats[stat]) + float(bonus[stat]) * scale
		stats["attack_speed"] = float(stats["attack_speed"]) * (1.0 + float(bonus["attack_speed"]) * scale)
	return stats
