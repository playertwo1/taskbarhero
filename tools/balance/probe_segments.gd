extends Node

## Sonda por segmento do slice (HIPÓTESE, não é playtest): para cada combinação de builds e
## nível, roda a rota completa e, com HP cheio, a elite, a Rainha e o Guardião isolados.
## Separa atrito da rota (HP só volta no Hub) da dificuldade própria de cada luta.
## Uso: godot --headless --path . res://tools/balance/ProbeSegments.tscn -- [seeds=10] [levels=3,5,8]
##      [hero_001=guardiao,retaliacao] [hero_002=...] [hero_003=...] para filtrar builds.
##      [route_offset=N]: soma N ao nível de todos os encontros (conteúdo escalado 1–100).
##      [damage_scale=X]: cenário com outro enemy_damage_scale, sem alterar /data.

const BUILD_OPTIONS := {
	"hero_001": ["guardiao", "retaliacao", "retaliacao_tele"],
	"hero_002": ["critico", "marca"],
	"hero_003": ["arcano", "controle", "lumen"],
}
const TELEGRAPH_OVERRIDE := {"skill_bas_007": {"type": "telegraph_on_self"}}
const SEGMENTS := {"elite": "c1_2_2_b", "rainha": "c1_3_2_a", "guardiao": "c1_5_2_a"}

var route: Dictionary
var heroes: Array
var enemies: Array
var skills: Array
var passives: Array

func _json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	return null if file == null else JSON.parse_string(file.get_as_text())

func _args() -> Dictionary:
	var out := {"seeds": "10", "levels": "3,5,8"}
	for a in OS.get_cmdline_user_args():
		var kv := String(a).split("=", true, 1)
		if kv.size() == 2:
			out[kv[0]] = kv[1]
	return out

func _single(node_id: String) -> Dictionary:
	for n in route["nodes"]:
		if n["id"] == node_id:
			return {"transition_seconds": 0.6, "nodes": [n]}
	return {}

func _options(build: Dictionary, level: int, seed_value: int) -> Dictionary:
	var builds := {}
	var overrides := {}
	for hid in build:
		builds[hid] = String(build[hid]).trim_suffix("_tele")
		if String(build[hid]).ends_with("_tele"):
			overrides.merge(TELEGRAPH_OVERRIDE)
	return {"seed": seed_value, "crits": true, "party_level": level, "skills": skills, "builds": builds, "trigger_overrides": overrides, "passives": passives}

func _median(values: Array) -> float:
	if values.is_empty():
		return -1.0
	var v := values.duplicate()
	v.sort()
	return float(v[v.size() / 2])

func _ready() -> void:
	route = _json("res://data/expedition/route_c1.json")
	heroes = SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	enemies = SliceStats.load_rows("res://data/enemies/enemies.json", "slice")
	skills = SliceStats.load_rows("res://data/skills/skills_slice.json", "slice")
	passives = SliceStats.load_rows("res://data/skills/passives_slice.json", "slice")
	var args := _args()
	# Cenário de sonda: sobrescreve enemy_damage_scale só nesta execução (não altera /data).
	if args.has("damage_scale"):
		SliceStats.load_profiles()["enemy_damage_scale"] = float(args["damage_scale"])
	var offset := int(args.get("route_offset", "0"))
	for n in route["nodes"]:
		if n.has("level"):
			n["level"] = clampi(int(n["level"]) + offset, 1, 100)
	var seeds := int(args["seeds"])
	print("bastiao,flecha,iris,level,route_win,route_lost_at,boss_entry_hp_pct,elite_win,elite_hp_pct,rainha_win,rainha_ttk,guardiao_win,guardiao_ttk,guardiao_boss_hp_left_pct")
	var opts := {}
	for hid in BUILD_OPTIONS:
		opts[hid] = String(args[hid]).split(",") if args.has(hid) else BUILD_OPTIONS[hid]
	for b in opts["hero_001"]:
		for f in opts["hero_002"]:
			for i in opts["hero_003"]:
				var build := {"hero_001": b, "hero_002": f, "hero_003": i}
				for level_text in String(args["levels"]).split(","):
					var level := int(level_text)
					var route_wins := 0
					var lost_at := {}
					var entry := []
					var seg := {}
					for key in SEGMENTS:
						seg[key] = {"wins": 0, "ttk": [], "left": [], "hp": []}
					for s in range(1, seeds + 1):
						var run := ExpeditionRun.create(route, heroes, enemies, _options(build, level, s))
						for e in run.run_to_end(0.25):
							if e["type"] == "encounter_started" and e["node_id"] == SEGMENTS["guardiao"]:
								var hp := 0.0
								var max_hp := 0.0
								for hid in e["party_hp"]:
									hp += float(e["party_hp"][hid])
									max_hp += float(SliceStats.hero_stats(_row(hid), level)["max_hp"])
								entry.append(100.0 * hp / max_hp)
						if run.state == "won":
							route_wins += 1
						else:
							var nid: String = run.snapshot()["node_id"]
							lost_at[nid] = int(lost_at.get(nid, 0)) + 1
						for key in SEGMENTS:
							var one := ExpeditionRun.create(_single(SEGMENTS[key]), heroes, enemies, _options(build, level, s))
							var events := one.run_to_end(0.25)
							if one.state == "won":
								seg[key]["wins"] += 1
								for e in events:
									if e["type"] == "encounter_cleared":
										seg[key]["ttk"].append(float(e["duration"]))
										var hp2 := 0.0
										var max2 := 0.0
										for hid in e["party_hp"]:
											hp2 += float(e["party_hp"][hid])
											max2 += float(SliceStats.hero_stats(_row(hid), level)["max_hp"])
										seg[key]["hp"].append(100.0 * hp2 / max2)
							else:
								for en in one.snapshot()["enemies"]:
									if String(en["uid"]).begins_with("boss_c1_001"):
										var boss_level := clampi(5 + offset, 1, 100)
										seg[key]["left"].append(100.0 * float(en["hp"]) / SliceStats.enemy_stats(_enemy("boss_c1_001"), boss_level, true)["max_hp"])
					var worst := ""
					var worst_n := 0
					for k in lost_at:
						if int(lost_at[k]) > worst_n:
							worst = k
							worst_n = int(lost_at[k])
					print("%s,%s,%s,%d,%d/%d,%s,%.0f,%d,%.0f,%d,%.0f,%d,%.0f,%.0f" % [b, f, i, level, route_wins, seeds, worst,
						_median(entry), seg["elite"]["wins"], _median(seg["elite"]["hp"]), seg["rainha"]["wins"], _median(seg["rainha"]["ttk"]),
						seg["guardiao"]["wins"], _median(seg["guardiao"]["ttk"]), _median(seg["guardiao"]["left"])])
	get_tree().quit(0)

func _row(hid: String) -> Dictionary:
	for r in heroes:
		if r["id"] == hid:
			return r
	return {}

func _enemy(id: String) -> Dictionary:
	for r in enemies:
		if r["id"] == id:
			return r
	return {}
