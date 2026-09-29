extends RefCounted
class_name ExpeditionRun

## Núcleo de simulação da expedição do slice (SLICE-1A-3a e 1A-4a).
## Puro: sem autoload, sem nós e sem tempo real. Determinístico dado rota, dados, seed e opções.
## Usa CombatMath, SliceStats e ThreatMath. Inclui skills com gatilho e cooldown, buffs de
## damage_taken, postura de contra-ataque, provocação e alvo por ameaça.
## Ainda sem passivas, Traits, Perfect Block, Desequilíbrio, Stagger, fases de chefe, invocações
## (membros "deferred"), loot ou XP.
## Regras: docs/00_project/CORE_LOOP.md e docs/06_balance/SLICE_BALANCE_CONTRACT.md.

const DEFAULT_FORMATION := {"front": "hero_001", "mid": "hero_003", "back": "hero_002"}
const SLOTS := ["front", "mid", "back"]
## HIPÓTESE local do SLICE-1A-4a: o v0.4 não define teto para damage_taken.
const DAMAGE_TAKEN_FLOOR := 0.25
## v0.4 (THREAT_AGGRO_SYSTEM.md): Bastião gera ×1,5 de ameaça com efeitos defensivos ativos.
const DEFENSIVE_THREAT_MULTIPLIER := 1.5
const EPS := 0.000001

var state: String = "fighting"  # fighting | transition | won | lost
var time: float = 0.0
var node_index: int = -1

var _nodes: Array = []
var _transition_seconds: float = 0.6
var _heroes: Dictionary = {}
var _hero_order: Array = []
var _enemies: Array = []
var _enemy_rows: Dictionary = {}
var _crits: bool = true
var _targeting: String = "threat"  # threat | front
var _rng := RandomNumberGenerator.new()
var _node_started_at: float = 0.0
var _transition_until: float = 0.0
var _pending_start: bool = true
var _taunt: Dictionary = {}

## options: seed (int), crits (bool), party_level (int), formation (slot → hero id),
## targeting ("threat" ou "front"), skills (linhas de skills_slice.json) e
## builds (hero id → chave de build em row["builds"]).
static func create(route: Dictionary, hero_rows: Array, enemy_rows: Array, options: Dictionary = {}) -> ExpeditionRun:
	var run := ExpeditionRun.new()
	run._nodes = route.get("nodes", [])
	run._transition_seconds = float(route.get("transition_seconds", 0.6))
	run._crits = bool(options.get("crits", true))
	run._targeting = String(options.get("targeting", "threat"))
	run._rng.seed = int(options.get("seed", 1))
	var level := int(options.get("party_level", 1))
	for row in enemy_rows:
		run._enemy_rows[row["id"]] = row
	var skills_by_id := {}
	for s in options.get("skills", []):
		skills_by_id[s["id"]] = s
	var builds: Dictionary = options.get("builds", {})
	var by_id := {}
	for row in hero_rows:
		by_id[row["id"]] = row
	var formation: Dictionary = options.get("formation", DEFAULT_FORMATION)
	var order: Array = []
	for slot in SLOTS:
		var hid: String = String(formation.get(slot, ""))
		if by_id.has(hid) and not order.has(hid):
			order.append(hid)
	for row in hero_rows:
		if not order.has(row["id"]):
			order.append(row["id"])
	for hid in order:
		var row: Dictionary = by_id[hid]
		var stats := SliceStats.hero_stats(row, level)
		var skills: Array = []
		if builds.has(hid) and row.has("builds") and row["builds"].has(builds[hid]):
			for sid in row["builds"][builds[hid]]["skills"]:
				skills.append({"def": skills_by_id[sid], "ready_at": 0.0})
		run._heroes[hid] = {
			"id": hid, "stats": stats, "hp": float(stats["max_hp"]), "alive": true, "next_at": 0.0,
			"skills": skills, "effects": [], "stance": {},
		}
	run._hero_order = order
	return run

## Avança a simulação em dt segundos e devolve os eventos ocorridos no intervalo.
func step(dt: float) -> Array:
	var events: Array = []
	if state == "won" or state == "lost":
		return events
	var target := time + dt
	if _pending_start:
		_pending_start = false
		_advance_node(events)
	while state != "won" and state != "lost":
		if state == "transition":
			if _transition_until <= target:
				time = _transition_until
				_advance_node(events)
				continue
			time = target
			break
		var ev := _next_event(target)
		if ev.is_empty():
			time = target
			break
		time = float(ev["at"])
		match String(ev["kind"]):
			"ready":
				_evaluate_skills(events)
			"hero":
				_hero_attack(ev["ref"], events)
				if state == "fighting":
					_evaluate_skills(events)
			"enemy":
				_enemy_attack(ev["ref"], events)
				if state == "fighting":
					_evaluate_skills(events)
	return events

## Roda até o fim (vitória ou derrota) ou até max_time e devolve todos os eventos.
func run_to_end(dt: float = 0.25, max_time: float = 3600.0) -> Array:
	var all: Array = []
	while state != "won" and state != "lost" and time < max_time:
		all.append_array(step(dt))
	return all

func snapshot() -> Dictionary:
	var enemies: Array = []
	for e in _enemies:
		if e["alive"]:
			enemies.append({"uid": e["uid"], "hp": e["hp"], "threat": e["threat"].duplicate(), "target": e["target"]})
	return {
		"state": state, "time": time, "node_index": node_index,
		"node_id": _nodes[node_index]["id"] if node_index >= 0 and node_index < _nodes.size() else "",
		"party_hp": _party_hp(), "enemies": enemies,
	}

func _party_hp() -> Dictionary:
	var hp := {}
	for hid in _hero_order:
		hp[hid] = float(_heroes[hid]["hp"])
	return hp

func _advance_node(events: Array) -> void:
	node_index += 1
	if node_index >= _nodes.size():
		state = "won"
		events.append({"type": "expedition_won", "time": time})
		return
	var node: Dictionary = _nodes[node_index]
	if node["type"] == "event":
		events.append({"type": "event_reached", "time": time, "node_id": node["id"]})
		_begin_transition()
		return
	_start_encounter(node, events)

func _begin_transition() -> void:
	state = "transition"
	_transition_until = time + _transition_seconds

func _start_encounter(node: Dictionary, events: Array) -> void:
	state = "fighting"
	_node_started_at = time
	_enemies = []
	_purge_expired()
	var level := int(node["level"])
	var index := 0
	for member in node["members"]:
		if bool(member.get("deferred", false)):
			continue
		var row: Dictionary = _enemy_rows[member["enemy_id"]]
		for _i in int(member["count"]):
			var stats := SliceStats.enemy_stats(row, level, true)
			_enemies.append({
				"uid": "%s#%d" % [row["id"], index], "id": row["id"], "stats": stats,
				"hp": float(stats["max_hp"]), "alive": true, "threat": {}, "target": "",
				"next_at": time + CombatMath.attack_interval(float(stats["attack_speed"])),
			})
			index += 1
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if h["alive"]:
			h["next_at"] = time + CombatMath.attack_interval(float(h["stats"]["attack_speed"]))
	events.append({"type": "encounter_started", "time": time, "node_id": node["id"], "party_hp": _party_hp()})
	if _enemies.is_empty():
		_finish_encounter(events)
	else:
		_evaluate_skills(events)

func _purge_expired() -> void:
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		h["effects"] = h["effects"].filter(func(e): return float(e["expires_at"]) > time)
		if not h["stance"].is_empty() and float(h["stance"]["expires_at"]) <= time:
			h["stance"] = {}
	if not _taunt.is_empty() and float(_taunt["until"]) <= time:
		_taunt = {}

func _finish_encounter(events: Array) -> void:
	events.append({
		"type": "encounter_cleared", "time": time, "node_id": _nodes[node_index]["id"],
		"duration": time - _node_started_at, "party_hp": _party_hp(),
	})
	_begin_transition()

## Próximo instante com ação até `limit`. Empate: skill pronta, heróis (na ordem), inimigos (na ordem).
func _next_event(limit: float) -> Dictionary:
	var best: Dictionary = {}
	var best_at := INF
	var best_prio := 99
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["alive"]:
			continue
		for sk in h["skills"]:
			var at := float(sk["ready_at"])
			if at > time + EPS and (at < best_at - EPS or (absf(at - best_at) <= EPS and 1 < best_prio)):
				best_at = at
				best_prio = 1
				best = {"kind": "ready", "at": at}
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if h["alive"]:
			var at := float(h["next_at"])
			if at < best_at - EPS or (absf(at - best_at) <= EPS and 2 < best_prio):
				best_at = at
				best_prio = 2
				best = {"kind": "hero", "at": at, "ref": h}
	for e in _enemies:
		if e["alive"]:
			var at := float(e["next_at"])
			if at < best_at - EPS or (absf(at - best_at) <= EPS and 3 < best_prio):
				best_at = at
				best_prio = 3
				best = {"kind": "enemy", "at": at, "ref": e}
	if best.is_empty() or best_at > limit:
		return {}
	return best

func _first_alive_enemy() -> Dictionary:
	for e in _enemies:
		if e["alive"]:
			return e
	return {}

func _alive_map() -> Dictionary:
	var alive := {}
	for hid in _hero_order:
		alive[hid] = bool(_heroes[hid]["alive"])
	return alive

# --- Efeitos ---------------------------------------------------------------------------------

func _active_effects(hero: Dictionary) -> Array:
	return hero["effects"].filter(func(e): return float(e["expires_at"]) > time + EPS)

func _stance_active(hero: Dictionary) -> bool:
	return not hero["stance"].is_empty() and float(hero["stance"]["expires_at"]) > time + EPS

func _taunt_active() -> bool:
	return not _taunt.is_empty() and float(_taunt["until"]) > time + EPS

func _has_defensive_effect(hero: Dictionary) -> bool:
	for e in _active_effects(hero):
		if bool(e.get("defensive", false)):
			return true
	if _stance_active(hero):
		return true
	return _taunt_active() and _taunt["hero"] == hero["id"]

func _threat_multiplier(hero: Dictionary) -> float:
	return DEFENSIVE_THREAT_MULTIPLIER if hero["id"] == "hero_001" and _has_defensive_effect(hero) else 1.0

func _damage_taken_multiplier(hero: Dictionary, extra_reduction: float = 0.0) -> float:
	var mods: Array = []
	for e in _active_effects(hero):
		if e["stat"] == "damage_taken":
			mods.append({"op": e["op"], "value": e["value"], "source_type": "SKILL", "source_id": e["source"]})
	if extra_reduction > 0.0:
		mods.append({"op": "ADD_PERCENT", "value": -extra_reduction, "source_type": "SKILL", "source_id": "stance"})
	return CombatMath.resolve_stat(1.0, mods, DAMAGE_TAKEN_FLOOR)

# --- Skills ----------------------------------------------------------------------------------

func _trigger_ok(hero: Dictionary, trigger: Dictionary) -> bool:
	match String(trigger.get("type", "")):
		"enemies_alive":
			return not _first_alive_enemy().is_empty()
		"self_hp_below":
			return float(hero["hp"]) <= float(hero["stats"]["max_hp"]) * float(trigger["threshold"]) + EPS
		"ally_behind_hp_below":
			var index: int = _hero_order.find(hero["id"])
			for i in range(index + 1, _hero_order.size()):
				var ally: Dictionary = _heroes[_hero_order[i]]
				if ally["alive"] and float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(trigger["threshold"]) + EPS:
					return true
			return false
		"enemy_targets_ally":
			for e in _enemies:
				if e["alive"] and e["target"] != "" and e["target"] != hero["id"] and _heroes[e["target"]]["alive"]:
					return true
			return false
	return false

func _evaluate_skills(events: Array) -> void:
	if _first_alive_enemy().is_empty():
		return
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["alive"]:
			continue
		for sk in h["skills"]:
			if float(sk["ready_at"]) <= time + EPS and _trigger_ok(h, sk["def"]["trigger"]):
				_cast(h, sk, events)

func _cast(hero: Dictionary, sk: Dictionary, events: Array) -> void:
	var def: Dictionary = sk["def"]
	sk["ready_at"] = time + CombatMath.cooldown(float(def["cooldown"]), float(hero["stats"]["skill_haste"]))
	events.append({"type": "skill_cast", "time": time, "hero": hero["id"], "skill": def["id"]})
	for fx in def["effects"]:
		match String(fx["type"]):
			"buff":
				var targets: Array = []
				if fx["targets"] == "self":
					targets = [hero]
				elif fx["targets"] == "allies_behind":
					var index: int = _hero_order.find(hero["id"])
					for i in range(index + 1, _hero_order.size()):
						if _heroes[_hero_order[i]]["alive"]:
							targets.append(_heroes[_hero_order[i]])
				for t in targets:
					t["effects"].append({
						"source": def["id"], "stat": fx["stat"], "op": fx["op"], "value": float(fx["value"]),
						"expires_at": time + float(fx["duration"]), "defensive": bool(fx.get("defensive", false)),
					})
			"counter_stance":
				hero["stance"] = {
					"expires_at": time + float(fx["duration"]), "reduction": float(fx["damage_reduction"]),
					"coefficient": float(fx["counter_coefficient"]),
				}
			"taunt":
				_taunt = {"hero": hero["id"], "until": time + float(fx["duration"]), "ally_multiplier": float(fx["ally_damage_multiplier"])}

# --- Ataques ---------------------------------------------------------------------------------

## Aplica dano a um inimigo, gera ameaça para o herói e trata a derrota. Devolve true se morreu.
func _damage_enemy(enemy: Dictionary, damage: float, hero: Dictionary, events: Array) -> bool:
	var effective := minf(damage, float(enemy["hp"]))
	enemy["hp"] = maxf(0.0, float(enemy["hp"]) - damage)
	var gained: float = effective * _threat_multiplier(hero)
	enemy["threat"][hero["id"]] = float(enemy["threat"].get(hero["id"], 0.0)) + gained
	if float(enemy["hp"]) > 0.0:
		return false
	enemy["alive"] = false
	events.append({"type": "enemy_defeated", "time": time, "uid": enemy["uid"], "id": enemy["id"]})
	if _first_alive_enemy().is_empty():
		_finish_encounter(events)
	return true

func _hero_attack(hero: Dictionary, events: Array) -> void:
	var enemy := _first_alive_enemy()
	if enemy.is_empty():
		return
	var stats: Dictionary = hero["stats"]
	var is_crit := false
	if _crits:
		is_crit = _rng.randf() < clampf(float(stats["crit_chance"]), 0.0, CombatMath.CRIT_CHANCE_CAP)
	var raw := CombatMath.apply_crit(float(stats["attack"]), is_crit, float(stats["crit_damage"]))
	var damage := CombatMath.hit_damage(raw, float(enemy["stats"]["defense"]))
	hero["next_at"] = float(hero["next_at"]) + CombatMath.attack_interval(float(stats["attack_speed"]))
	events.append({"type": "hero_attack", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": damage, "crit": is_crit})
	_damage_enemy(enemy, damage, hero, events)

func _choose_target(enemy: Dictionary) -> String:
	var alive := _alive_map()
	if _targeting == "front":
		for hid in _hero_order:
			if alive[hid]:
				return hid
		return ""
	var forced: String = _taunt["hero"] if _taunt_active() else ""
	enemy["target"] = ThreatMath.pick_target(enemy["threat"], enemy["target"], _hero_order, alive, forced)
	return enemy["target"]

func _enemy_attack(enemy: Dictionary, events: Array) -> void:
	var target_id := _choose_target(enemy)
	if target_id == "":
		return
	var hero: Dictionary = _heroes[target_id]
	var raw := float(enemy["stats"]["attack"])
	if _taunt_active() and _taunt["hero"] != target_id:
		raw *= float(_taunt["ally_multiplier"])
	var stance_hit := _stance_active(hero)
	var reduction := float(hero["stance"]["reduction"]) if stance_hit else 0.0
	var damage := CombatMath.hit_damage(raw, float(hero["stats"]["defense"]), 0.0, _damage_taken_multiplier(hero, reduction))
	hero["hp"] = maxf(0.0, float(hero["hp"]) - damage)
	enemy["next_at"] = float(enemy["next_at"]) + CombatMath.attack_interval(float(enemy["stats"]["attack_speed"]))
	events.append({"type": "enemy_attack", "time": time, "source": enemy["uid"], "target": target_id, "damage": damage})
	if float(hero["hp"]) <= 0.0:
		hero["alive"] = false
		hero["stance"] = {}
		events.append({"type": "hero_defeated", "time": time, "id": target_id})
		if _no_hero_alive():
			state = "lost"
			events.append({"type": "expedition_lost", "time": time, "node_id": _nodes[node_index]["id"]})
			return
	elif stance_hit:
		var counter := CombatMath.hit_damage(float(hero["stance"]["coefficient"]) * float(hero["stats"]["attack"]), float(enemy["stats"]["defense"]))
		events.append({"type": "counter_attack", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": counter})
		_damage_enemy(enemy, counter, hero, events)
		# A postura é consumida pelo contra-ataque; a ameaça acima ainda usou o ×1,5 da postura ativa.
		hero["stance"] = {}

func _no_hero_alive() -> bool:
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			return false
	return true
