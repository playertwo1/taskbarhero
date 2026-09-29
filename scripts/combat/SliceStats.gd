extends RefCounted
class_name SliceStats

## Carregamento por conjunto de conteúdo e derivação de stats do slice (SLICE-1A-2).
## Fonte dos números: data/balance/combat_profiles.json, que espelha o contrato em
## docs/06_balance/SLICE_BALANCE_CONTRACT.md. Todos os valores são HIPÓTESE até o SLICE-1E.

const LEGACY := "legacy"
const SLICE := "slice"
const PROFILES_PATH := "res://data/balance/combat_profiles.json"

static var _profiles_cache: Dictionary = {}

## Linhas sem content_set pertencem ao conjunto legado.
static func filter_rows(rows: Array, content_set: String) -> Array:
	var out: Array = []
	for row in rows:
		if row is Dictionary and String(row.get("content_set", LEGACY)) == content_set:
			out.append(row)
	return out

## Lê um arquivo JSON de lista e devolve só as linhas do conjunto pedido.
static func load_rows(path: String, content_set: String) -> Array:
	if not FileAccess.file_exists(path):
		push_warning("SliceStats: arquivo não encontrado em %s" % path)
		return []
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return []
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Array:
		return filter_rows(parsed, content_set)
	return []

static func load_profiles() -> Dictionary:
	if _profiles_cache.is_empty() and FileAccess.file_exists(PROFILES_PATH):
		var file := FileAccess.open(PROFILES_PATH, FileAccess.READ)
		if file != null:
			var parsed = JSON.parse_string(file.get_as_text())
			if parsed is Dictionary:
				_profiles_cache = parsed
	return _profiles_cache

## Stats de inimigo no nível do conteúdo: HERO_REFERENCE × arquétipo × rank.
## O ataque já inclui enemy_damage_scale. party_scaled aplica a escala de HP da party (party_hp_scale) a elite, mini-boss e boss.
static func enemy_stats(row: Dictionary, level: int, party_scaled: bool = false) -> Dictionary:
	var profiles := load_profiles()
	var ref: Dictionary = profiles["reference_hero"]
	var arch: Dictionary = profiles["archetypes"][row["archetype"]]
	var rank: Dictionary = profiles["ranks"][row["rank"]]
	var max_hp: float = CombatMath.level_value(ref["max_hp"][0], ref["max_hp"][1], level) * float(arch["max_hp"]) * float(rank["max_hp"])
	if party_scaled and row["rank"] != "NORMAL":
		max_hp *= party_hp_scale(profiles, row["rank"])
	var attack: float = CombatMath.level_value(ref["attack"][0], ref["attack"][1], level) * float(arch["attack"]) * float(rank["attack"]) * float(profiles["enemy_damage_scale"])
	var defense: float = CombatMath.level_value(ref["defense"][0], ref["defense"][1], level) * float(arch["defense"]) * float(rank["defense"])
	return {
		"max_hp": max_hp,
		"attack": attack,
		"defense": defense,
		"attack_speed": float(ref["attack_speed"]) * float(arch["attack_speed"]),
		"tenacity": float(rank["tenacity"]),
	}

## Escala de HP pela party: número único (legado do contrato) ou mapa por rank.
static func party_hp_scale(profiles: Dictionary, rank: String) -> float:
	var scale = profiles.get("party_hp_scale", 1.0)
	if scale is Dictionary:
		return float(scale.get(rank, 1.0))
	return float(scale)

## Stats de herói no nível: interpolação linear de HP, ATK e DEF; os demais não crescem por nível.
static func hero_stats(row: Dictionary, level: int) -> Dictionary:
	var base: Dictionary = row["base_stats"]
	return {
		"max_hp": CombatMath.level_value(base["max_hp"][0], base["max_hp"][1], level),
		"attack": CombatMath.level_value(base["attack"][0], base["attack"][1], level),
		"defense": CombatMath.level_value(base["defense"][0], base["defense"][1], level),
		"attack_speed": float(row["attack_speed"]),
		"crit_chance": float(row["crit_chance"]),
		"crit_damage": float(row["crit_damage"]),
		"skill_haste": float(row["skill_haste"]),
		"tenacity": float(row["tenacity"]),
	}
