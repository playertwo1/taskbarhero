extends RefCounted
class_name BalanceProfiles

## Resolvedor global de balanceamento. Compõe uma única visão runtime na ordem:
## núcleo global → perfil do capítulo → overrides explícitos do chamador.

const MANIFEST_PATH := "res://data/balance/combat_profiles.json"
const DEFAULT_CONTENT_SET := "slice"

static var _manifest_cache: Dictionary = {}
static var _chapter_cache: Dictionary = {}
static var _resolved_cache: Dictionary = {}

static func _load_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("BalanceProfiles: arquivo não encontrado em %s" % path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	push_warning("BalanceProfiles: JSON raiz precisa ser objeto em %s" % path)
	return {}

static func manifest() -> Dictionary:
	if _manifest_cache.is_empty():
		_manifest_cache = _load_dict(MANIFEST_PATH)
	return _manifest_cache

static func default_chapter() -> String:
	return String(manifest().get("default_chapter", ""))

static func chapter_config(chapter_id: String = "") -> Dictionary:
	var resolved_id := chapter_id if chapter_id != "" else default_chapter()
	if not _chapter_cache.has(resolved_id):
		var path := String(manifest().get("chapter_profiles", {}).get(resolved_id, ""))
		_chapter_cache[resolved_id] = _load_dict(path) if path != "" else {}
	return _chapter_cache[resolved_id]

static func _merge(base: Dictionary, overlay: Dictionary) -> Dictionary:
	var out := base.duplicate(true)
	for key in overlay:
		if out.get(key) is Dictionary and overlay[key] is Dictionary:
			out[key] = _merge(out[key], overlay[key])
		else:
			out[key] = overlay[key].duplicate(true) if overlay[key] is Dictionary or overlay[key] is Array else overlay[key]
	return out

## Perfil composto em cache, sem cópia: só leitura. Quem precisar alterar usa `load_profiles`.
static func resolved(chapter_id: String = "") -> Dictionary:
	var resolved_id := chapter_id if chapter_id != "" else default_chapter()
	if not _resolved_cache.has(resolved_id):
		var core := _load_dict(String(manifest().get("global_profile", "")))
		var chapter := chapter_config(resolved_id)
		var composed := _merge(core, chapter)
		composed["resolved_chapter_id"] = resolved_id
		composed["resolved_sources"] = [manifest().get("global_profile", ""), manifest().get("chapter_profiles", {}).get(resolved_id, "")]
		_resolved_cache[resolved_id] = composed
	return _resolved_cache[resolved_id]

static func load_profiles(chapter_id: String = "", overrides: Dictionary = {}) -> Dictionary:
	var base := resolved(chapter_id)
	if overrides.is_empty():
		return base.duplicate(true)
	return _merge(base, overrides)

## Fator global de escala de combate: multiplica HP, ATK e DEF (e as constantes absolutas da
## fórmula de dano). Sem perfil explícito, vale o do perfil padrão.
static func combat_scale(profiles: Dictionary = {}) -> float:
	var p := profiles if not profiles.is_empty() else resolved()
	return float(p.get("combat_scale", 1.0))

## Expoente da curva de nível (`level_curve_p`): 1 = linear. Vale para heróis, herói de referência
## dos inimigos e referências de item.
static func level_curve_p(profiles: Dictionary = {}) -> float:
	var p := profiles if not profiles.is_empty() else resolved()
	return float(p.get("level_curve_p", 1.0))

## Só para testes que conferem números à mão: fixa, no perfil padrão desta execução, o
## `combat_scale` (padrão 1×) e o `level_curve_p` (padrão linear). Cada cena de teste roda em
## um processo próprio; `clear_cache` desfaz.
static func pin_test_units(scale: float = 1.0, curve: float = 1.0) -> void:
	var p := resolved()
	p["combat_scale"] = scale
	p["level_curve_p"] = curve

static func clear_cache() -> void:
	_manifest_cache.clear()
	_chapter_cache.clear()
	_resolved_cache.clear()

static func filter_rows(rows: Array, content_set: String) -> Array:
	var out: Array = []
	for row in rows:
		if row is Dictionary and String(row.get("content_set", DEFAULT_CONTENT_SET)) == content_set:
			out.append(row)
	return out

static func load_rows(path: String, content_set: String) -> Array:
	if not FileAccess.file_exists(path):
		push_warning("BalanceProfiles: arquivo não encontrado em %s" % path)
		return []
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return []
	var parsed = JSON.parse_string(file.get_as_text())
	return filter_rows(parsed, content_set) if parsed is Array else []

static func party_hp_scale(profiles: Dictionary, rank: String) -> float:
	var scale = profiles.get("party_hp_scale", 1.0)
	return float(scale.get(rank, 1.0)) if scale is Dictionary else float(scale)

static func enemy_stats(row: Dictionary, level: int, party_scaled: bool = false, profiles: Dictionary = {}) -> Dictionary:
	var p := profiles if not profiles.is_empty() else resolved()
	var ref: Dictionary = p["reference_hero"]
	var arch: Dictionary = p["archetypes"][row["archetype"]]
	var rank: Dictionary = p["ranks"][row["rank"]]
	var scale := combat_scale(p)
	var curve := level_curve_p(p)
	var max_hp: float = CombatMath.level_value(ref["max_hp"][0], ref["max_hp"][1], level, curve) * float(arch["max_hp"]) * float(rank["max_hp"]) * scale
	if party_scaled and row["rank"] != "NORMAL":
		max_hp *= party_hp_scale(p, row["rank"])
	return {
		"max_hp": max_hp,
		"attack": CombatMath.level_value(ref["attack"][0], ref["attack"][1], level, curve) * float(arch["attack"]) * float(rank["attack"]) * float(p.get("enemy_damage_scale", 1.0)) * scale,
		"defense": CombatMath.level_value(ref["defense"][0], ref["defense"][1], level, curve) * float(arch["defense"]) * float(rank["defense"]) * scale,
		"attack_speed": float(ref["attack_speed"]) * float(arch["attack_speed"]),
		"tenacity": float(rank["tenacity"]),
	}

static func enemy_stat_trace(row: Dictionary, level: int, party_scaled: bool = false, chapter_id: String = "") -> Dictionary:
	var p := load_profiles(chapter_id)
	var stats := enemy_stats(row, level, party_scaled, p)
	return {
		"entity_id": row.get("id", ""), "level": level, "archetype": row.get("archetype", ""),
		"rank": row.get("rank", ""), "party_scaled": party_scaled,
		"enemy_damage_scale": p.get("enemy_damage_scale", 1.0), "combat_scale": combat_scale(p), "level_curve_p": level_curve_p(p),
		"party_hp_scale": party_hp_scale(p, String(row.get("rank", "NORMAL"))) if party_scaled else 1.0,
		"sources": p.get("resolved_sources", []), "result": stats,
	}

static func hero_stats(row: Dictionary, level: int, profiles: Dictionary = {}) -> Dictionary:
	var base: Dictionary = row["base_stats"]
	var scale := combat_scale(profiles)
	var curve := level_curve_p(profiles)
	return {
		"max_hp": CombatMath.level_value(base["max_hp"][0], base["max_hp"][1], level, curve) * scale,
		"attack": CombatMath.level_value(base["attack"][0], base["attack"][1], level, curve) * scale,
		"defense": CombatMath.level_value(base["defense"][0], base["defense"][1], level, curve) * scale,
		"attack_speed": float(row["attack_speed"]), "crit_chance": float(row["crit_chance"]),
		"crit_damage": float(row["crit_damage"]), "skill_haste": float(row["skill_haste"]),
		"tenacity": float(row["tenacity"]),
	}
