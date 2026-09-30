class_name KitTestSupport
extends RefCounted

## Ajudantes dos testes de kit (2026-09-30). Heróis com HP alto para que a luta dure o bastante.

const HEROES_PATH := "res://data/heroes/heroes.json"
const ENEMIES_PATH := "res://data/enemies/enemies.json"
const SKILLS_PATH := "res://data/skills/skills_slice.json"
const PASSIVES_PATH := "res://data/skills/passives_slice.json"

static var hero_rows: Array = []
static var enemy_rows: Array = []
static var skill_rows: Array = []
static var passive_rows: Array = []

static func load_all() -> void:
	hero_rows = SliceStats.load_rows(HEROES_PATH, "slice")
	enemy_rows = SliceStats.load_rows(ENEMIES_PATH, "slice")
	skill_rows = SliceStats.load_rows(SKILLS_PATH, "slice")
	passive_rows = SliceStats.load_rows(PASSIVES_PATH, "slice")

static func of(events: Array, type: String) -> Array:
	return events.filter(func(e): return e["type"] == type)

static func damages(events: Array, type: String, source: String, skill: String = "") -> Array:
	var out: Array = []
	for e in of(events, type):
		if e["source"] == source and (skill == "" or e.get("skill", "") == skill):
			out.append(float(e["damage"]))
	return out

static func _hero(hero_id: String, skills: Array, passives: Array) -> Dictionary:
	for r in hero_rows:
		if r["id"] == hero_id:
			var copy: Dictionary = r.duplicate(true)
			copy["base_stats"]["max_hp"] = [5000.0, 5000.0]
			copy.erase("signature")  # os testes listam as skills explicitamente
			copy["builds"] = {"t": {"name": "t", "skills": skills, "passives": passives}}
			return copy
	return {}

static func mk(specs: Array, members: Array, ranks: Dictionary = {}, overrides: Dictionary = {}, hp: Dictionary = {}, level: int = 1) -> ExpeditionRun:
	var heroes: Array = []
	var builds := {}
	var formation := {}
	var slots := ["front", "mid", "back"]
	for i in specs.size():
		heroes.append(_hero(specs[i][0], specs[i][1], specs[i][2]))
		builds[specs[i][0]] = "t"
		formation[slots[i]] = specs[i][0]
	var route := {"transition_seconds": 0.6, "nodes": [{"type": "encounter", "id": "n", "kind": "NORMAL", "stage": 1, "level": level, "members": members}]}
	var run := ExpeditionRun.create(route, heroes, enemy_rows, {
		"seed": 1, "crits": false, "party_level": level, "skills": skill_rows, "builds": builds,
		"passives": passive_rows, "formation": formation, "trigger_overrides": overrides, "skill_ranks": ranks,
	})
	for hid in hp:
		run._heroes[hid]["hp"] = float(hp[hid])
	return run

static func spawn(run: ExpeditionRun) -> Array:
	var events: Array = []
	for _i in 40:
		if not run._enemies.is_empty():
			break
		events.append_array(run.step(0.05))
	return events

static func tank(run: ExpeditionRun) -> void:
	for e in run._enemies:
		e["hp"] = 1.0e9
		e["stats"]["max_hp"] = 1.0e9

static func new_enemy(run: ExpeditionRun, enemy_id: String = "en_c1_001") -> Dictionary:
	var row: Dictionary = enemy_rows.filter(func(r): return r["id"] == enemy_id)[0]
	return run._new_enemy(row, 1)
