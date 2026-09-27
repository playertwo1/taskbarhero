extends Node

## StateExporter: Produz snapshots estruturados em JSON do estado interno do jogo
## para comparacao com a visao de tela do Argos e reproducao deterministica de bugs.

const SNAPSHOTS_DIR := "user://snapshots/"

func capture_snapshot(build_hash: String = "local_dev", tag: String = "") -> Dictionary:
	var snapshot := {
		"build": build_hash,
		"timestamp": Time.get_datetime_string_from_system(true),
		"seed": randi(),
		"stage": ProgressionManager.current_stage,
		"time_seconds": Time.get_ticks_msec() / 1000,
		"level": ProgressionManager.level,
		"xp": ProgressionManager.xp,
		"xp_next": ProgressionManager.xp_next,
		"gold": ProgressionManager.gold,
		"hero": {
			"hp": GameManager.hero_current_hp,
			"max_hp": GameManager.get_total_hero_max_hp(),
			"attack": GameManager.get_total_hero_attack(),
			"defense": GameManager.get_total_hero_defense(),
			"crit": GameManager.get_total_hero_crit(),
			"lifesteal": GameManager.get_total_hero_lifesteal()
		},
		"equipment": LootManager.equipment,
		"inventory_count": LootManager.inventory.size(),
		"active_enemy": GameManager.active_enemy.get("id", "none"),
		"enemy_hp": GameManager.active_enemy_hp,
		"tag": tag
	}
	return snapshot

func save_snapshot_to_file(snapshot: Dictionary, filename_prefix: String = "snapshot") -> String:
	DirAccess.make_dir_absolute(SNAPSHOTS_DIR)
	var timestamp_str := Time.get_datetime_string_from_system().replace(":", "-")
	var path := "%s%s_%s.json" % [SNAPSHOTS_DIR, filename_prefix, timestamp_str]
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(snapshot, "\t"))
		return path
	return ""
