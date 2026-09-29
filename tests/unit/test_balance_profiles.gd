extends Node

const Profiles := preload("res://scripts/combat/BalanceProfiles.gd")

var success := true

func _ready() -> void:
	var manifest := Profiles.manifest()
	_expect("capítulo padrão registrado", Profiles.default_chapter() == "CHAPTER_01")
	_expect("manifesto aponta núcleo", String(manifest.get("global_profile", "")).ends_with("combat_core.json"))

	var profiles := Profiles.load_profiles("CHAPTER_01")
	_expect("núcleo foi composto", profiles.has("reference_hero") and profiles.has("threat_profiles"))
	_expect("overlay foi composto", is_equal_approx(float(profiles.get("enemy_damage_scale", 0.0)), 0.5))
	_expect("fonte rastreável", profiles.get("resolved_sources", []).size() == 2)

	var overridden := Profiles.load_profiles("CHAPTER_01", {"enemy_damage_scale": 0.25})
	_expect("override local aplicado", is_equal_approx(float(overridden["enemy_damage_scale"]), 0.25))
	_expect("override não altera cache", is_equal_approx(float(Profiles.load_profiles("CHAPTER_01")["enemy_damage_scale"]), 0.5))

	var enemies := Profiles.load_rows("res://data/enemies/enemies.json", "slice")
	var trace := Profiles.enemy_stat_trace(enemies[0], 1, true, "CHAPTER_01")
	_expect("trace identifica entidade", trace["entity_id"] == enemies[0]["id"])
	_expect("trace contém resultado e fontes", trace.has("result") and trace["sources"].size() == 2)

	get_tree().quit(0 if success else 1)

func _expect(label: String, condition: bool) -> void:
	if condition:
		print("[PASS] ", label)
	else:
		push_error("[FAIL] " + label)
		success = false
