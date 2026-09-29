extends Node

const BUILDS := {
	"ofensivo": {"hero_001": "retaliacao", "hero_002": "critico", "hero_003": "arcano"},
	"controle": {"hero_001": "guardiao", "hero_002": "marca", "hero_003": "controle"},
	"cura": {"hero_001": "retaliacao", "hero_002": "critico", "hero_003": "lumen"},
}
const LOADOUT := {
	"hero_001": ["item_w_001", "item_s_001", "item_a_001"],
	"hero_002": ["item_w_002", "item_s_006", "item_a_001"],
	"hero_003": ["item_w_006", "item_s_007", "item_a_001"],
}

func _json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	return null if file == null else JSON.parse_string(file.get_as_text())

func _equipment(mode: String, level: int) -> Dictionary:
	var out := {}
	if mode == "none":
		return out
	for hero_id in LOADOUT:
		var instances := []
		for item_id in LOADOUT[hero_id]:
			var rarity := "Raro" if mode == "rare" else ("Incomum" if item_id == "item_w_002" else "Comum")
			instances.append({"id": item_id, "rarity": rarity, "item_power": 50 if mode == "rare" else 20, "item_level": level})
		out[hero_id] = instances
	return out

func _ready() -> void:
	var route: Dictionary = _json("res://data/expedition/route_c1.json")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var enemies := SliceStats.load_rows("res://data/enemies/enemies.json", "slice")
	var skills := SliceStats.load_rows("res://data/skills/skills_slice.json", "slice")
	var items := SliceStats.load_rows("res://data/items/items.json", "slice")
	print("build,gear,level,runs,wins,elite,mini,boss,mean_cleared,mean_healed,mean_boss_entry_hp")
	for build in BUILDS:
		for gear in ["none", "starter", "rare"]:
			for level in [3, 5, 7, 10]:
				var wins := 0
				var elite := 0
				var mini := 0
				var boss := 0
				var cleared := 0
				var healed := 0.0
				var boss_hp := 0.0
				for seed_value in range(1, 21):
					var run := ExpeditionRun.create(route, heroes, enemies, {
						"seed": seed_value, "crits": true, "party_level": level,
						"skills": skills, "builds": BUILDS[build], "items": items,
						"equipment": _equipment(gear, level),
					})
					var events := run.run_to_end(0.25)
					wins += int(run.state == "won")
					for event in events:
						match String(event["type"]):
							"encounter_cleared": cleared += 1
							"healing": healed += float(event["amount"])
							"encounter_started":
								match String(event["node_id"]):
									"c1_2_2_b": elite += 1
									"c1_3_2_a": mini += 1
									"c1_5_2_a":
										boss += 1
										for hp in event["party_hp"].values():
											boss_hp += float(hp)
				print("%s,%s,%d,20,%d,%d,%d,%d,%.2f,%.1f,%.1f" % [build, gear, level, wins, elite, mini, boss, cleared / 20.0, healed / 20.0, boss_hp / 20.0])
	get_tree().quit(0)
