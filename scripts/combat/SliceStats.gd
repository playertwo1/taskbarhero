extends RefCounted
class_name SliceStats

const Profiles := preload("res://scripts/combat/BalanceProfiles.gd")

## Adaptador temporário para os chamadores do vertical slice.
## A autoridade e a resolução de perfis agora pertencem a BalanceProfiles.

static func filter_rows(rows: Array, content_set: String) -> Array:
	return Profiles.filter_rows(rows, content_set)

static func load_rows(path: String, content_set: String) -> Array:
	return Profiles.load_rows(path, content_set)

static func load_profiles(chapter_id: String = "", overrides: Dictionary = {}) -> Dictionary:
	return Profiles.load_profiles(chapter_id, overrides)

static func party_hp_scale(profiles: Dictionary, rank: String) -> float:
	return Profiles.party_hp_scale(profiles, rank)

static func enemy_stats(row: Dictionary, level: int, party_scaled: bool = false, profiles: Dictionary = {}) -> Dictionary:
	return Profiles.enemy_stats(row, level, party_scaled, profiles)

static func hero_stats(row: Dictionary, level: int, profiles: Dictionary = {}) -> Dictionary:
	return Profiles.hero_stats(row, level, profiles)
