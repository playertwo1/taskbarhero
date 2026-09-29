extends Node

## ARGOS-SIM (camada de simulação headless do Argos). Sem IA, sem sprites: roda o ExpeditionRun
## do slice para cada cenário, verifica oráculos de invariantes em cada execução e grava uma
## linha JSON por execução. Quem agrega e classifica é tools/argos/analyzer/analyze.py.
## Uso: godot --headless --path . res://tools/argos/simulator/combat/ArgosSim.tscn --
##      scenario=res://tools/argos/simulator/combat/scenarios/slice_balance.json out=<arquivo.jsonl>

const ROUTE_PATH := "res://data/expedition/route_c1.json"
const SEGMENTS := {"elite": "c1_2_2_b", "rainha": "c1_3_2_a", "guardiao": "c1_5_2_a"}
const TELEGRAPH_OVERRIDE := {"skill_bas_007": {"type": "telegraph_on_self"}}

var route: Dictionary
var heroes: Array
var enemies: Array
var skills: Array
var passives: Array
var items: Array
var profiles: Dictionary
var enemy_rank := {}
var out_file: FileAccess
var scenario: Dictionary
## Variante ativa (cenário com "variants"): sobrescritas só nesta execução, nunca gravadas em /data.
var variant_id := ""
var run_options := {}
var base_skills: Array
var base_passives: Array
var base_damage_scale := 0.0

func _json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	return null if file == null else JSON.parse_string(file.get_as_text())

func _args() -> Dictionary:
	var out := {}
	for a in OS.get_cmdline_user_args():
		var kv := String(a).split("=", true, 1)
		if kv.size() == 2:
			out[kv[0]] = kv[1]
	return out

func _ready() -> void:
	var args := _args()
	scenario = _json(String(args.get("scenario", "")))
	if scenario == null:
		push_error("ARGOS: cenário inválido: %s" % args.get("scenario", ""))
		get_tree().quit(2)
		return
	out_file = FileAccess.open(String(args.get("out", "user://argos_runs.jsonl")), FileAccess.WRITE)
	if out_file == null:
		push_error("ARGOS: não foi possível abrir a saída")
		get_tree().quit(2)
		return
	route = _json(ROUTE_PATH)
	heroes = SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	enemies = SliceStats.load_rows("res://data/enemies/enemies.json", "slice")
	skills = SliceStats.load_rows("res://data/skills/skills_slice.json", "slice")
	passives = SliceStats.load_rows("res://data/skills/passives_slice.json", "slice")
	items = SliceStats.load_rows("res://data/items/items.json", "slice")
	profiles = SliceStats.load_profiles()
	for e in enemies:
		enemy_rank[e["id"]] = e["rank"]
	# Cenário pode sobrescrever enemy_damage_scale só nesta execução (nunca grava em /data).
	if scenario.get("overrides", {}).has("enemy_damage_scale"):
		profiles["enemy_damage_scale"] = float(scenario["overrides"]["enemy_damage_scale"])
	base_skills = skills
	base_passives = passives
	base_damage_scale = float(profiles["enemy_damage_scale"])
	_write({"kind": "meta", "scenario": scenario.get("id", ""), "seeds": scenario.get("seeds", 0),
		"enemy_damage_scale": profiles["enemy_damage_scale"], "godot": Engine.get_version_info()["string"],
		"variants": scenario.get("variants", []).map(func(v): return v["id"])})
	var variants: Array = scenario.get("variants", [{"id": ""}])
	for v in variants:
		_apply_variant(v)
		_run_matrix()
	_apply_variant({"id": ""})
	out_file.close()
	get_tree().quit(0)

func _run_matrix() -> void:
	var modes: Array = scenario.get("modes", ["route"])
	for build in _combos():
		for level in scenario.get("levels", [5]):
			for s in range(1, int(scenario.get("seeds", 5)) + 1):
				if modes.has("route"):
					_route_run(build, int(level), s)
				if modes.has("segments"):
					for key in SEGMENTS:
						_segment_run(build, int(level), s, key)
		if modes.has("campaign"):
			for s in range(1, int(scenario.get("seeds", 5)) + 1):
				_campaign(build, s)

## Aplica uma variante: skill_overrides e passive_overrides usam "campo" ou "índice.campo";
## run_options entram no ExpeditionRun (ex.: potions); enemy_damage_scale vale só na variante.
func _apply_variant(v: Dictionary) -> void:
	variant_id = String(v.get("id", ""))
	run_options = v.get("run_options", {})
	profiles["enemy_damage_scale"] = float(v.get("enemy_damage_scale", base_damage_scale))
	skills = _patched(base_skills, v.get("skill_overrides", {}), "effects")
	passives = _patched(base_passives, v.get("passive_overrides", {}), "params")

func _patched(rows: Array, overrides: Dictionary, nested: String) -> Array:
	if overrides.is_empty():
		return rows
	var out: Array = []
	for r in rows:
		var row: Dictionary = r.duplicate(true)
		for key in overrides.get(row["id"], {}):
			var value = overrides[row["id"]][key]
			var parts := String(key).split(".")
			if parts.size() == 1 and nested == "params":
				row["params"][key] = value
			elif parts.size() == 1:
				row[key] = value
			else:
				row[nested][int(parts[0])][parts[1]] = value
		out.append(row)
	return out

func _write(record: Dictionary) -> void:
	if variant_id != "":
		record["variant"] = variant_id
	out_file.store_line(JSON.stringify(record))

func _combos() -> Array:
	var opts: Dictionary = scenario["builds"]
	var out := []
	for b in opts["hero_001"]:
		for f in opts["hero_002"]:
			for i in opts["hero_003"]:
				out.append({"hero_001": b, "hero_002": f, "hero_003": i})
	return out

func _label(build: Dictionary) -> String:
	var label := "%s/%s/%s" % [build["hero_001"], build["hero_002"], build["hero_003"]]
	return label if variant_id == "" else "%s · %s" % [variant_id, label]

func _hero_row(id: String) -> Dictionary:
	for r in heroes:
		if r["id"] == id:
			return r
	return {}

## Ranks por política de marcos (HIPÓTESE da sonda): pontos na 1ª skill até 5, depois na 2ª.
func _ranks(build: Dictionary, level: int) -> Dictionary:
	var milestones: Array = scenario.get("rank_milestones", [])
	var points := 0
	for m in milestones:
		if level >= int(m):
			points += 1
	var cap := int(profiles["skill_rank"]["max"])
	var ranks := {}
	for hid in build:
		var key := String(build[hid]).trim_suffix("_tele")
		var ids: Array = _hero_row(hid)["builds"][key]["skills"]
		ranks[ids[0]] = mini(cap, 1 + points)
		ranks[ids[1]] = mini(cap, 1 + maxi(0, points - (cap - 1)))
	return ranks

func _options(build: Dictionary, level: int, seed_value: int, equipment: Dictionary = {}) -> Dictionary:
	var builds := {}
	var overrides := {}
	for hid in build:
		builds[hid] = String(build[hid]).trim_suffix("_tele")
		if String(build[hid]).ends_with("_tele"):
			overrides.merge(TELEGRAPH_OVERRIDE)
	var opts := {"seed": seed_value, "crits": true, "party_level": level, "skills": skills, "builds": builds,
		"trigger_overrides": overrides, "passives": passives, "skill_ranks": _ranks(build, level), "items": items,
		"equipment": equipment}
	opts.merge(run_options, true)
	return opts

func _single(node_id: String) -> Dictionary:
	for n in route["nodes"]:
		if n["id"] == node_id:
			return {"transition_seconds": route.get("transition_seconds", 0.6), "nodes": [n]}
	return {}

func _max_party_hp(level: int) -> float:
	var total := 0.0
	for r in heroes:
		total += float(SliceStats.hero_stats(r, level)["max_hp"])
	return total

# --- Execuções ------------------------------------------------------------------------------

func _route_run(build: Dictionary, level: int, seed_value: int) -> void:
	var opts := _options(build, level, seed_value)
	var run := ExpeditionRun.create(route, heroes, enemies, opts)
	var events := run.run_to_end(0.25, float(scenario.get("max_time", 3600.0)))
	var rec := _summarize(run, events, level)
	rec.merge({"kind": "route", "build": _label(build), "level": level, "seed": seed_value})
	# Oráculo de determinismo: 1 semente por combinação/nível repete com outro passo.
	if seed_value == 1:
		var again := ExpeditionRun.create(route, heroes, enemies, opts).run_to_end(5.0, float(scenario.get("max_time", 3600.0)))
		if JSON.stringify(again) != JSON.stringify(events):
			rec["violations"].append("nondeterministic_step")
	_write(rec)

func _segment_run(build: Dictionary, level: int, seed_value: int, key: String) -> void:
	var run := ExpeditionRun.create(_single(SEGMENTS[key]), heroes, enemies, _options(build, level, seed_value))
	var events := run.run_to_end(0.25, float(scenario.get("max_time", 3600.0)))
	var rec := _summarize(run, events, level)
	rec.merge({"kind": "segment", "segment": key, "build": _label(build), "level": level, "seed": seed_value})
	_write(rec)

## Tentativas sucessivas: HP cheio a cada tentativa (volta ao Hub), XP acumula mesmo em derrota.
## Com campaign.loot, os drops (modelo canônico simplificado) ficam no inventário e o Hub equipa
## o melhor item por herói e slot antes da tentativa seguinte.
func _campaign(build: Dictionary, seed_value: int) -> void:
	var c: Dictionary = scenario.get("campaign", {})
	var level := int(c.get("start_level", 1))
	var xp := 0
	var attempts := []
	var won := false
	var loot: RefCounted = null
	if bool(c.get("loot", false)):
		loot = load("res://tools/argos/simulator/loot/argos_loot.gd").new(items, seed_value * 7919)
		if not loot.is_ready():
			push_error("ARGOS: fontes canônicas de loot indisponíveis")
			loot = null
	var inventory := []
	var equipment := {}
	var totals := {"gold": 0, "residue": 0, "items": 0}
	var party := ["hero_001", "hero_002", "hero_003"]
	var node_level := {}
	for n in route["nodes"]:
		node_level[n["id"]] = int(n.get("level", 1))
	for attempt in range(1, int(c.get("max_attempts", 10)) + 1):
		var run := ExpeditionRun.create(route, heroes, enemies, _options(build, level, seed_value * 1000 + attempt, equipment))
		var events := run.run_to_end(0.25, float(scenario.get("max_time", 3600.0)))
		var summary := _summarize(run, events, level)
		var gained := {"gold": 0, "residue": 0, "items": 0}
		if loot != null:
			var current := ""
			for e in events:
				if e["type"] == "encounter_started":
					current = e["node_id"]
				elif e["type"] == "enemy_defeated":
					var drop: Dictionary = loot.roll_enemy(e["id"], int(node_level.get(current, 1)), party)
					gained["gold"] += int(drop["gold"])
					gained["residue"] += int(drop["residue"])
					if not drop["item"].is_empty():
						inventory.append(drop["item"])
						gained["items"] += 1
			equipment = loot.best_loadout(inventory, party)
			for k in totals:
				totals[k] += int(gained[k])
		var equipped := 0
		for hid in equipment:
			equipped += equipment[hid].size()
		attempts.append({"level": level, "won": summary["won"], "furthest": summary["furthest_node"], "xp": summary["xp"],
			"violations": summary["violations"], "gold": gained["gold"], "residue": gained["residue"],
			"items_dropped": gained["items"], "equipped_after": equipped})
		xp += int(summary["xp"])
		while level < int(profiles["xp"]["max_level"]) and xp >= ExpeditionRun.xp_to_next(level, profiles):
			xp -= ExpeditionRun.xp_to_next(level, profiles)
			level += 1
		if summary["won"]:
			won = true
			break
	_write({"kind": "campaign", "build": _label(build), "seed": seed_value, "won": won,
		"attempts": attempts.size(), "final_level": level, "history": attempts, "loot": loot != null, "totals": totals})

# --- Métricas e oráculos --------------------------------------------------------------------

func _summarize(run: ExpeditionRun, events: Array, level: int) -> Dictionary:
	var violations: Array = []
	var nodes := {}
	var damage_dealt := {}
	var damage_taken := {}
	var healing := 0.0
	var casts := {}
	var xp := 0
	var expected_xp := 0
	var defeated := {}
	var dead_heroes := {}
	var spawned := {}
	var last_time := -INF
	var last_damage_at := 0.0
	var current_node := ""
	var node_start := 0.0
	var max_hp := _max_party_hp(level)
	for e in events:
		var t := float(e.get("time", 0.0))
		# Oráculo: tempo nunca volta.
		if t < last_time - 0.000001:
			_violate(violations, "time_went_backwards")
		last_time = maxf(last_time, t)
		# Oráculo: combate travado (sem dano por muito tempo dentro de um encontro).
		if current_node != "" and e["type"] != "encounter_started" and t - last_damage_at > float(scenario.get("stuck_seconds", 30.0)):
			_violate(violations, "stuck_no_damage")
		match String(e["type"]):
			"encounter_started":
				current_node = e["node_id"]
				node_start = t
				last_damage_at = t
				spawned = {}
			"encounter_cleared":
				var hp := 0.0
				for v in e["party_hp"].values():
					hp += float(v)
					# Oráculo: HP fora de [0, máximo].
					if float(v) < -0.000001:
						_violate(violations, "negative_hp")
				nodes[e["node_id"]] = {"ttk": float(e["duration"]), "party_hp_pct": 100.0 * hp / max_hp}
			"enemy_spawned":
				spawned[e["uid"]] = true
			"hero_attack", "skill_damage", "counter_attack", "passive_damage":
				damage_dealt[e["source"]] = float(damage_dealt.get(e["source"], 0.0)) + float(e["damage"])
				last_damage_at = t
				# Oráculo: herói derrotado não age.
				if dead_heroes.has(e["source"]):
					_violate(violations, "dead_hero_acted")
				if defeated.has(current_node + ":" + String(e["target"])):
					_violate(violations, "hit_defeated_enemy")
			"skill_cast":
				casts[e["skill"]] = int(casts.get(e["skill"], 0)) + 1
				if dead_heroes.has(e["hero"]):
					_violate(violations, "dead_hero_acted")
			"enemy_attack":
				damage_taken[e["target"]] = float(damage_taken.get(e["target"], 0.0)) + float(e["damage"])
				last_damage_at = t
				if defeated.has(current_node + ":" + String(e["source"])):
					_violate(violations, "defeated_enemy_acted")
				if dead_heroes.has(e["target"]):
					_violate(violations, "dead_hero_targeted")
			"healing":
				healing += float(e["amount"])
				if float(e["amount"]) < -0.000001:
					_violate(violations, "negative_heal")
			"hero_defeated":
				dead_heroes[e["id"]] = true
			"enemy_defeated":
				var key := current_node + ":" + String(e["uid"])
				# Oráculo: inimigo derrotado duas vezes (recompensa duplicada).
				if defeated.has(key):
					_violate(violations, "enemy_defeated_twice")
				defeated[key] = true
				xp += int(e.get("xp", 0))
				expected_xp += int(profiles["xp"]["by_rank"].get(enemy_rank.get(e["id"], ""), 0))
	# Oráculo: XP pago = XP esperado pelos inimigos derrotados.
	if xp != expected_xp:
		_violate(violations, "xp_mismatch")
	var state := run.state
	if state != "won" and state != "lost":
		_violate(violations, "did_not_finish")
	return {
		"won": state == "won", "state": state, "time": run.time, "furthest_node": run.node_index,
		"lost_at": "" if state == "won" else String(run.snapshot()["node_id"]),
		"nodes": nodes, "damage_dealt": damage_dealt, "damage_taken": damage_taken,
		"healing": healing, "casts": casts, "xp": xp, "violations": violations,
	}

func _violate(violations: Array, name: String) -> void:
	if not violations.has(name):
		violations.append(name)
