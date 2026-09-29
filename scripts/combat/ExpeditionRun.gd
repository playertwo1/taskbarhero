extends RefCounted
class_name ExpeditionRun

## Núcleo de simulação da expedição do slice (SLICE-1A-3a).
## Puro: sem autoload, sem nós e sem tempo real. Determinístico dado rota, dados, seed e opções.
## Usa CombatMath e SliceStats; ainda sem skills, passivas, Traits, Perfect Block, Stagger,
## fases de chefe, invocações (membros "deferred"), loot ou XP.
## Regras decididas em docs/00_project/CORE_LOOP.md e docs/06_balance/SLICE_BALANCE_CONTRACT.md.

const DEFAULT_FORMATION := {"front": "hero_001", "mid": "hero_003", "back": "hero_002"}
const SLOTS := ["front", "mid", "back"]

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
var _rng := RandomNumberGenerator.new()
var _node_started_at: float = 0.0
var _transition_until: float = 0.0
var _pending_start: bool = true

## options: seed (int), crits (bool), party_level (int), formation (Dictionary slot → hero id).
static func create(route: Dictionary, hero_rows: Array, enemy_rows: Array, options: Dictionary = {}) -> ExpeditionRun:
	var run := ExpeditionRun.new()
	run._nodes = route.get("nodes", [])
	run._transition_seconds = float(route.get("transition_seconds", 0.6))
	run._crits = bool(options.get("crits", true))
	run._rng.seed = int(options.get("seed", 1))
	var level := int(options.get("party_level", 1))
	for row in enemy_rows:
		run._enemy_rows[row["id"]] = row
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
		var stats := SliceStats.hero_stats(by_id[hid], level)
		run._heroes[hid] = {
			"id": hid, "stats": stats, "hp": float(stats["max_hp"]), "alive": true, "next_at": 0.0,
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
		var actor := _next_actor(target)
		if actor.is_empty():
			time = target
			break
		time = float(actor["at"])
		if actor["kind"] == "hero":
			_hero_attack(actor["ref"], events)
		else:
			_enemy_attack(actor["ref"], events)
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
			enemies.append({"uid": e["uid"], "hp": e["hp"]})
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
				"hp": float(stats["max_hp"]), "alive": true,
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

func _finish_encounter(events: Array) -> void:
	events.append({
		"type": "encounter_cleared", "time": time, "node_id": _nodes[node_index]["id"],
		"duration": time - _node_started_at, "party_hp": _party_hp(),
	})
	_begin_transition()

## Próximo ataque até `limit`: menor instante; empate resolvido pela ordem fixa (heróis, depois inimigos).
func _next_actor(limit: float) -> Dictionary:
	var best: Dictionary = {}
	var best_at := INF
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if h["alive"] and float(h["next_at"]) < best_at:
			best_at = float(h["next_at"])
			best = {"kind": "hero", "ref": h, "at": best_at}
	for e in _enemies:
		if e["alive"] and float(e["next_at"]) < best_at:
			best_at = float(e["next_at"])
			best = {"kind": "enemy", "ref": e, "at": best_at}
	if best.is_empty() or best_at > limit:
		return {}
	return best

func _first_alive_enemy() -> Dictionary:
	for e in _enemies:
		if e["alive"]:
			return e
	return {}

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
	enemy["hp"] = maxf(0.0, float(enemy["hp"]) - damage)
	hero["next_at"] = float(hero["next_at"]) + CombatMath.attack_interval(float(stats["attack_speed"]))
	events.append({"type": "hero_attack", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": damage, "crit": is_crit})
	if float(enemy["hp"]) <= 0.0:
		enemy["alive"] = false
		events.append({"type": "enemy_defeated", "time": time, "uid": enemy["uid"], "id": enemy["id"]})
		if _first_alive_enemy().is_empty():
			_finish_encounter(events)

func _enemy_target() -> Dictionary:
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			return _heroes[hid]
	return {}

func _enemy_attack(enemy: Dictionary, events: Array) -> void:
	var hero := _enemy_target()
	if hero.is_empty():
		return
	var damage := CombatMath.hit_damage(float(enemy["stats"]["attack"]), float(hero["stats"]["defense"]))
	hero["hp"] = maxf(0.0, float(hero["hp"]) - damage)
	enemy["next_at"] = float(enemy["next_at"]) + CombatMath.attack_interval(float(enemy["stats"]["attack_speed"]))
	events.append({"type": "enemy_attack", "time": time, "source": enemy["uid"], "target": hero["id"], "damage": damage})
	if float(hero["hp"]) <= 0.0:
		hero["alive"] = false
		events.append({"type": "hero_defeated", "time": time, "id": hero["id"]})
		if _enemy_target().is_empty():
			state = "lost"
			events.append({"type": "expedition_lost", "time": time, "node_id": _nodes[node_index]["id"]})
