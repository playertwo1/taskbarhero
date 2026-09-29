extends Node

## Sonda de campanha do slice (HIPÓTESE, não é playtest).
## Cada tentativa é uma expedição completa com HP cheio (volta ao Hub); o XP de todos os
## inimigos derrotados, inclusive em derrotas, fica com a party. A cada marco de nível a party
## ganha 1 ponto de rank por herói, investido na 1ª skill da build até o rank 5 e depois na 2ª.
## Uso: godot --headless --path . res://tools/balance/ProbeCampaign.tscn -- [seeds=10] [attempts=12]
##      [policy=all|none|every_level|every_2] [gear=none|starter] [out=user://campaign.csv]
##      [damage_scale=X]: cenário com outro enemy_damage_scale, sem alterar /data.

const BUILD_OPTIONS := {
	"hero_001": ["guardiao", "retaliacao", "retaliacao_tele"],
	"hero_002": ["critico", "marca"],
	"hero_003": ["arcano", "controle", "lumen"],
}
## Variante de Hub: Contra-Golpe guardado para o golpe telegrafado (gatilho ajustável, SKILL_SYSTEM).
const TELEGRAPH_OVERRIDE := {"skill_bas_007": {"type": "telegraph_on_self"}}
const POLICIES := {
	"none": [],
	"every_2": [3, 5, 7, 9, 11, 13, 15, 17, 19],
	"every_level": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
}
const LOADOUT := {
	"hero_001": ["item_w_001", "item_s_001", "item_a_001"],
	"hero_002": ["item_w_002", "item_s_006", "item_a_001"],
	"hero_003": ["item_w_006", "item_s_007", "item_a_001"],
}

var route: Dictionary
var heroes: Array
var enemies: Array
var skills: Array
var passives: Array
var items: Array
var profiles: Dictionary

func _json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	return null if file == null else JSON.parse_string(file.get_as_text())

func _args() -> Dictionary:
	var out := {"seeds": "10", "attempts": "12", "policy": "all", "gear": "none", "out": ""}
	for a in OS.get_cmdline_user_args():
		var kv := String(a).split("=", true, 1)
		if kv.size() == 2:
			out[kv[0]] = kv[1]
	return out

func _equipment(gear: String, level: int) -> Dictionary:
	var out := {}
	if gear == "none":
		return out
	for hero_id in LOADOUT:
		var list := []
		for item_id in LOADOUT[hero_id]:
			list.append({"id": item_id, "rarity": "Incomum" if item_id == "item_w_002" else "Comum", "item_power": 20, "item_level": level})
		out[hero_id] = list
	return out

func _hero_row(id: String) -> Dictionary:
	for r in heroes:
		if r["id"] == id:
			return r
	return {}

## Ranks por skill para o nível, conforme a política de marcos.
func _ranks(build: Dictionary, level: int, milestones: Array) -> Dictionary:
	var ranks := {}
	var points := 0
	for m in milestones:
		if level >= int(m):
			points += 1
	var cap := int(profiles["skill_rank"]["max"])
	for hid in build:
		var key := String(build[hid]).trim_suffix("_tele")
		var ids: Array = _hero_row(hid)["builds"][key]["skills"]
		var first := mini(cap, 1 + points)
		var second := mini(cap, 1 + maxi(0, points - (cap - 1)))
		ranks[ids[0]] = first
		ranks[ids[1]] = second
	return ranks

func _attempt(build: Dictionary, level: int, milestones: Array, gear: String, seed_value: int) -> Dictionary:
	var builds := {}
	var overrides := {}
	for hid in build:
		builds[hid] = String(build[hid]).trim_suffix("_tele")
		if String(build[hid]).ends_with("_tele"):
			overrides.merge(TELEGRAPH_OVERRIDE)
	var run := ExpeditionRun.create(route, heroes, enemies, {
		"seed": seed_value, "crits": true, "party_level": level, "skills": skills, "builds": builds,
		"trigger_overrides": overrides, "skill_ranks": _ranks(build, level, milestones), "passives": passives,
		"items": items, "equipment": _equipment(gear, level),
	})
	var events := run.run_to_end(0.25)
	var xp := 0
	var boss_reached := false
	for e in events:
		match String(e["type"]):
			"enemy_defeated": xp += int(e["xp"])
			"encounter_started": boss_reached = boss_reached or e["node_id"] == "c1_5_2_a"
	return {"won": run.state == "won", "xp": xp, "node": run.node_index, "boss": boss_reached, "time": run.time}

func _campaign(build: Dictionary, milestones: Array, gear: String, seed_value: int, max_attempts: int) -> Dictionary:
	var level := 1
	var xp := 0
	var furthest := []
	for attempt in range(1, max_attempts + 1):
		var r := _attempt(build, level, milestones, gear, seed_value * 1000 + attempt)
		furthest.append(int(r["node"]))
		xp += int(r["xp"])
		while level < int(profiles["xp"]["max_level"]) and xp >= ExpeditionRun.xp_to_next(level, profiles):
			xp -= ExpeditionRun.xp_to_next(level, profiles)
			level += 1
		if r["won"]:
			return {"won": true, "attempts": attempt, "level": level, "furthest": furthest}
	return {"won": false, "attempts": max_attempts, "level": level, "furthest": furthest}

func _combos() -> Array:
	var out := []
	for b in BUILD_OPTIONS["hero_001"]:
		for f in BUILD_OPTIONS["hero_002"]:
			for i in BUILD_OPTIONS["hero_003"]:
				out.append({"hero_001": b, "hero_002": f, "hero_003": i})
	return out

func _median(values: Array) -> float:
	if values.is_empty():
		return -1.0
	var v := values.duplicate()
	v.sort()
	return float(v[v.size() / 2]) if v.size() % 2 == 1 else (float(v[v.size() / 2 - 1]) + float(v[v.size() / 2])) / 2.0

func _ready() -> void:
	route = _json("res://data/expedition/route_c1.json")
	heroes = SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	enemies = SliceStats.load_rows("res://data/enemies/enemies.json", "slice")
	skills = SliceStats.load_rows("res://data/skills/skills_slice.json", "slice")
	passives = SliceStats.load_rows("res://data/skills/passives_slice.json", "slice")
	items = SliceStats.load_rows("res://data/items/items.json", "slice")
	profiles = SliceStats.load_profiles()
	var args := _args()
	# Cenário de sonda: sobrescreve enemy_damage_scale só nesta execução (não altera /data).
	if args.has("damage_scale"):
		SliceStats.load_profiles()["enemy_damage_scale"] = float(args["damage_scale"])
	var seeds := int(args["seeds"])
	var max_attempts := int(args["attempts"])
	var policies: Array = POLICIES.keys() if args["policy"] == "all" else [args["policy"]]
	var lines: Array[String] = ["policy,gear,bastiao,flecha,iris,campaigns,won,first_try,median_attempts,median_win_level,max_attempts"]
	for policy in policies:
		for build in _combos():
			var won := 0
			var first := 0
			var attempts := []
			var levels := []
			for s in range(1, seeds + 1):
				var c := _campaign(build, POLICIES[policy], args["gear"], s, max_attempts)
				if c["won"]:
					won += 1
					attempts.append(c["attempts"])
					levels.append(c["level"])
					if int(c["attempts"]) == 1:
						first += 1
			var line := "%s,%s,%s,%s,%s,%d,%d,%d,%.1f,%.1f,%d" % [policy, args["gear"], build["hero_001"], build["hero_002"], build["hero_003"], seeds, won, first, _median(attempts), _median(levels), max_attempts]
			lines.append(line)
			print(line)
	if String(args["out"]) != "":
		var f := FileAccess.open(String(args["out"]), FileAccess.WRITE)
		if f != null:
			f.store_string("\n".join(lines) + "\n")
	get_tree().quit(0)
