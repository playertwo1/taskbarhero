extends RefCounted
class_name CombatMath

## Fórmulas de combate v0.4 usadas pelo conteúdo do slice (SLICE-1A-1).
## Fonte: docs/06_balance/SLICE_BALANCE_CONTRACT.md e COMBAT_FORMULAS.md do v0.4.
## Funções puras: sem estado, sem RNG e sem arredondamento. O runtime mantém precisão.
## Não é usado pelo combate do MVP legado, que continua com a matemática atual.

const DEFENSE_K := 100.0
const MIN_DAMAGE := 1.0
const MIN_ATTACK_INTERVAL := 0.20
const MIN_SKILL_COOLDOWN := 0.25
const CRIT_CHANCE_CAP := 1.0

## Fração do dano bloqueada pela defesa: def_efetiva / (def_efetiva + K).
static func mitigation(defense: float, armor_pen_pct: float = 0.0) -> float:
	var effective := maxf(0.0, defense * (1.0 - armor_pen_pct))
	return effective / (effective + DEFENSE_K)

## Dano depois de defesa/penetração e damage_taken, com mínimo de 1.
static func hit_damage(raw: float, defense: float, armor_pen_pct: float = 0.0, damage_taken: float = 1.0) -> float:
	var damage := raw * (1.0 - mitigation(defense, armor_pen_pct))
	damage *= damage_taken
	return maxf(MIN_DAMAGE, damage)

## Dano médio por golpe: hit × (1 + chance × (crit_damage − 1)), chance limitada a 100%.
static func expected_hit(hit: float, crit_chance: float, crit_damage: float) -> float:
	var chance := clampf(crit_chance, 0.0, CRIT_CHANCE_CAP)
	return hit * (1.0 + chance * (crit_damage - 1.0))

## Golpe concreto: o crítico é decidido por quem chama, mantendo a função determinística.
static func apply_crit(hit: float, is_crit: bool, crit_damage: float) -> float:
	return hit * crit_damage if is_crit else hit

## Segundos entre ataques: 1 / attack_speed, com mínimo de 0,20 s.
static func attack_interval(attack_speed: float) -> float:
	if attack_speed <= 0.0:
		return INF
	return maxf(MIN_ATTACK_INTERVAL, 1.0 / attack_speed)

## Cooldown final: base / (1 + skill_haste / 100), com mínimo de 0,25 s.
static func cooldown(base_cooldown: float, skill_haste: float) -> float:
	return maxf(MIN_SKILL_COOLDOWN, base_cooldown / (1.0 + skill_haste / 100.0))

## Duração final de controle: base / (1 + tenacity / 100).
static func control_duration(base_duration: float, tenacity: float) -> float:
	return base_duration / (1.0 + tenacity / 100.0)

## Escudo gerado: base × (1 + shield_power).
static func shield_amount(base_shield: float, shield_power: float) -> float:
	return base_shield * (1.0 + shield_power)

## O escudo é consumido antes do HP. Devolve o dano que chega ao HP e o escudo restante.
static func absorb(damage: float, shield: float) -> Dictionary:
	var absorbed := minf(damage, maxf(0.0, shield))
	return {"hp_damage": damage - absorbed, "shield_left": maxf(0.0, shield) - absorbed}

## Interpolação linear entre o nível 1 e o nível 100.
static func level_value(level_1: float, level_100: float, level: int) -> float:
	return level_1 + (level_100 - level_1) * float(level - 1) / 99.0

## Pipeline de status: (base + ΣFLAT) × (1 + ΣADD_PERCENT) × ΠMULTIPLY → OVERRIDE → clamp.
## Cada modificador é {op, value, source_type, source_id}; a origem não altera a matemática
## e fica preservada no array recebido, que não é modificado. Com vários OVERRIDE vale o último.
static func resolve_stat(base: float, modifiers: Array, min_value: float = -INF, max_value: float = INF) -> float:
	var flat := 0.0
	var add_percent := 0.0
	var multiply := 1.0
	var has_override := false
	var override_value := 0.0
	for mod in modifiers:
		var value: float = float(mod.get("value", 0.0))
		match String(mod.get("op", "")):
			"FLAT":
				flat += value
			"ADD_PERCENT":
				add_percent += value
			"MULTIPLY":
				multiply *= value
			"OVERRIDE":
				has_override = true
				override_value = value
	var result := (base + flat) * (1.0 + add_percent) * multiply
	if has_override:
		result = override_value
	return clampf(result, min_value, max_value)
