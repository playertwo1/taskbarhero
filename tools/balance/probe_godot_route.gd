extends Node

## Read-only, seeded probe of the current Godot slice combat data.
## Does not read or write saves and does not apply documentation proposals.

const ROUTE_PATH := "res://data/expedition/route_c1.json"
const HEROES_PATH := "res://data/heroes/heroes.json"
const ENEMIES_PATH := "res://data/enemies/enemies.json"
const SKILLS_PATH := "res://data/skills/skills_slice.json"

func _load_json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	return null if file == null else JSON.parse_string(file.get_as_text())

func _ready() -> void:
	var route: Dictionary = _load_json(ROUTE_PATH)
	var heroes: Array = SliceStats.load_rows(HEROES_PATH, "slice")
	var enemies: Array = SliceStats.load_rows(ENEMIES_PATH, "slice")
	var skills: Array = SliceStats.load_rows(SKILLS_PATH, "slice")
	if route.is_empty() or heroes.size() != 3 or enemies.is_empty():
		push_error("Dados do slice indisponíveis para a sondagem")
		get_tree().quit(1)
		return
	print("scale,build,level,runs,wins,reach_elite,reach_miniboss,reach_boss,mean_cleared")
	for scale in [0.5, 0.25, 0.15, 0.1]:
		SliceStats.load_profiles()["enemy_damage_scale"] = scale
		for build in ["", "trio_ofensivo", "trio_controle", "trio_misto", "trio_cura"]:
			for level in [5, 7, 10, 15, 20]:
				var wins := 0
				var elite := 0
				var mini := 0
				var boss := 0
				var cleared_total := 0
				for seed_value in range(1, 21):
					var builds := {}
					match build:
						"trio_ofensivo": builds = {"hero_001": "retaliacao", "hero_002": "critico", "hero_003": "arcano"}
						"trio_controle": builds = {"hero_001": "guardiao", "hero_002": "marca", "hero_003": "controle"}
						"trio_misto": builds = {"hero_001": "guardiao", "hero_002": "marca", "hero_003": "arcano"}
						"trio_cura": builds = {"hero_001": "retaliacao", "hero_002": "critico", "hero_003": "lumen"}
					var run := ExpeditionRun.create(route, heroes, enemies, {
						"seed": seed_value, "crits": true, "party_level": level,
						"builds": builds, "skills": skills,
					})
					var events := run.run_to_end(0.25)
					wins += int(run.state == "won")
					for event in events:
						if event["type"] == "encounter_started":
							match event["node_id"]:
								"c1_2_2_b": elite += 1
								"c1_3_2_a": mini += 1
								"c1_5_2_a": boss += 1
						if event["type"] == "encounter_cleared":
							cleared_total += 1
				var label: String = "sem_skills" if build == "" else build
				print("%.2f,%s,%d,20,%d,%d,%d,%d,%.2f" % [scale, label, level, wins, elite, mini, boss, cleared_total / 20.0])
	get_tree().quit(0)
