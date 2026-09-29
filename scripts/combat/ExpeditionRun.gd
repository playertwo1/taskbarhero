extends RefCounted
class_name ExpeditionRun

## Núcleo de simulação da expedição do slice (SLICE-1A-3a e 1A-4a).
## Puro: sem autoload, sem nós e sem tempo real. Determinístico dado rota, dados, seed e opções.
## Usa CombatMath, SliceStats e ThreatMath. Inclui skills com gatilho e cooldown, buffs de
## damage_taken, postura de contra-ataque, provocação e alvo por ameaça.
## SLICE-1A-4b/1C (HIPÓTESE): Stagger e quebra, Perfect Block e Desequilíbrio, golpe telegrafado,
## fases de chefe com adds adiados ("deferred"), ranks de skill, XP por inimigo derrotado e as
## passivas/Traits do recorte com efeito em combate (data/skills/passives_slice.json). Sem loot.
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
var _profiles: Dictionary = {}
var _deferred: Array = []
var _uid_counter: int = 0

## options: seed (int), crits (bool), party_level (int), formation (slot → hero id),
## targeting ("threat" ou "front"), skills (linhas de skills_slice.json) e
## builds (hero id → chave de build em row["builds"]), items (linhas do catálogo)
## e equipment (hero id → lista de instâncias com id, rarity, item_power, item_level),
## skill_ranks (skill id → rank 1–5), trigger_overrides (skill id → gatilho escolhido no Hub)
## e passives (linhas de passives_slice.json; sem elas, heróis lutam sem passivas/Traits).
static func create(route: Dictionary, hero_rows: Array, enemy_rows: Array, options: Dictionary = {}) -> ExpeditionRun:
	var run := ExpeditionRun.new()
	run._nodes = route.get("nodes", [])
	run._transition_seconds = float(route.get("transition_seconds", 0.6))
	run._crits = bool(options.get("crits", true))
	run._targeting = String(options.get("targeting", "threat"))
	run._rng.seed = int(options.get("seed", 1))
	run._profiles = SliceStats.load_profiles()
	var ranks: Dictionary = options.get("skill_ranks", {})
	var overrides: Dictionary = options.get("trigger_overrides", {})
	var passive_rows := {}
	for prow in options.get("passives", []):
		passive_rows[prow["id"]] = prow
	var level := int(options.get("party_level", 1))
	for row in enemy_rows:
		run._enemy_rows[row["id"]] = row
	var skills_by_id := {}
	for s in options.get("skills", []):
		skills_by_id[s["id"]] = s
	var builds: Dictionary = options.get("builds", {})
	var equipment: Dictionary = options.get("equipment", {})
	var item_rows: Array = options.get("items", [])
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
		stats = SliceItemStats.equip(stats, hid, equipment.get(hid, []), item_rows)
		var skills: Array = []
		var passive_ids: Array = [row.get("identity_passive", "")]
		if builds.has(hid) and row.has("builds") and row["builds"].has(builds[hid]):
			passive_ids.append_array(row["builds"][builds[hid]].get("passives", []))
			for sid in row["builds"][builds[hid]]["skills"]:
				var def: Dictionary = ranked_skill(skills_by_id[sid], int(ranks.get(sid, 1)), run._profiles)
				if overrides.has(sid):
					def["trigger"] = overrides[sid]
				skills.append({"def": def, "ready_at": 0.0, "ready_seen": false})
		run._heroes[hid] = {
			"id": hid, "stats": stats, "hp": float(stats["max_hp"]), "alive": true, "next_at": 0.0,
			"skills": skills, "effects": [], "stance": {}, "guard_ready_at": 0.0,
			"basic_stagger": float(row.get("basic_stagger", 0.0)), "perfect_block": row.get("perfect_block", {}),
			"passives": {}, "stacks": {},
		}
		for pid in passive_ids:
			if passive_rows.has(pid) and String(passive_rows[pid]["kind"]) != "none":
				run._heroes[hid]["passives"][passive_rows[pid]["kind"]] = passive_rows[pid]["params"]
	run._hero_order = order
	return run

## Cópia da skill no rank pedido. Cada rank R2–R5 em def["ranks"] aplica, em ordem, "set"
## ("campo" no topo ou "índice.campo" num efeito) e "add" (efeitos novos). Rank 1 = dados base.
## Fonte dos ranks: docs/06_balance/CHAPTER_01_HERO_COMBAT_PROPOSAL.md (HIPÓTESE).
static func ranked_skill(def: Dictionary, rank: int, profiles: Dictionary) -> Dictionary:
	var out: Dictionary = def.duplicate(true)
	var r := clampi(rank, 1, int(profiles.get("skill_rank", {}).get("max", 5)))
	out["rank"] = r
	var table: Dictionary = def.get("ranks", {})
	for step in range(2, r + 1):
		var patch: Dictionary = table.get(str(step), {})
		var sets: Dictionary = patch.get("set", {})
		for key in sets:
			var parts := String(key).split(".")
			if parts.size() == 1:
				out[key] = sets[key]
			else:
				out["effects"][int(parts[0])][parts[1]] = sets[key]
		for fx in patch.get("add", []):
			out["effects"].append(fx.duplicate(true))
	out.erase("ranks")
	return out

## XP necessário para passar do nível ao seguinte (HIPÓTESE em combat_profiles.xp.curve).
static func xp_to_next(level: int, profiles: Dictionary) -> int:
	var c: Dictionary = profiles["xp"]["curve"]
	return int(round(float(c["base"]) * pow(float(c["growth"]), level - 1) + float(c["per_level"]) * level))

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
				_mark_ready_seen()
				_evaluate_skills(events)
			"hero":
				_hero_attack(ev["ref"], events)
				if state == "fighting":
					_evaluate_skills(events)
			"enemy":
				_enemy_act(ev["ref"], events)
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
			enemies.append({
				"uid": e["uid"], "id": e["id"], "hp": e["hp"], "max_hp": float(e["stats"]["max_hp"]),
				"threat": e["threat"].duplicate(), "target": e["target"],
				"telegraph": float(e["telegraph_until"]) > time, "broken": float(e["broken_until"]) > time,
			})
	var party: Array = []
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		party.append({"id": hid, "hp": float(h["hp"]), "max_hp": float(h["stats"]["max_hp"]), "alive": bool(h["alive"])})
	return {
		"state": state, "time": time, "node_index": node_index,
		"node_id": _nodes[node_index]["id"] if node_index >= 0 and node_index < _nodes.size() else "",
		"party_hp": _party_hp(), "party": party, "enemies": enemies,
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
	_deferred = []
	_uid_counter = 0
	_purge_expired()
	var level := int(node["level"])
	for member in node["members"]:
		var row: Dictionary = _enemy_rows[member["enemy_id"]]
		for _i in int(member["count"]):
			if bool(member.get("deferred", false)):
				_deferred.append({"row": row, "level": level})
			else:
				_enemies.append(_new_enemy(row, level))
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if h["alive"]:
			h["next_at"] = time + CombatMath.attack_interval(float(h["stats"]["attack_speed"]))
			h["guard_ready_at"] = time
	events.append({"type": "encounter_started", "time": time, "node_id": node["id"], "party_hp": _party_hp()})
	_mark_ready_seen()
	if _enemies.is_empty():
		_finish_encounter(events)
	else:
		_evaluate_skills(events)

## Recargas concluídas até agora já foram avaliadas; não geram evento "ready" no passado.
func _mark_ready_seen() -> void:
	for hid in _hero_order:
		for sk in _heroes[hid]["skills"]:
			if float(sk["ready_at"]) <= time + EPS:
				sk["ready_seen"] = true

func _new_enemy(row: Dictionary, level: int) -> Dictionary:
	var stats := SliceStats.enemy_stats(row, level, true)
	var stagger: Dictionary = _profiles.get("stagger", {}).get("ranks", {}).get(row["rank"], {})
	var mechanics: Dictionary = row.get("mechanics", {})
	var enemy := {
		"uid": "%s#%d" % [row["id"], _uid_counter], "id": row["id"], "rank": row["rank"], "stats": stats,
		"hp": float(stats["max_hp"]), "alive": true, "threat": {}, "target": "",
		"next_at": time + CombatMath.attack_interval(float(stats["attack_speed"])),
		"marked_until": 0.0, "defense_debuff_until": 0.0, "defense_debuff": 0.0,
		"posture_max": float(stagger.get("posture", 0.0)), "posture": float(stagger.get("posture", 0.0)),
		"posture_at": time, "last_stagger_at": -INF, "broken_until": -INF, "immune_until": -INF,
		"imbalance_until": -INF, "exposed_until": -INF, "exposed_vulnerability": 0.0,
		"mechanics": mechanics, "phase_index": 0, "attacks_done": 0, "telegraph_until": -INF, "telegraph_target": "",
		"mark_owner": "", "mark_bonus": 0.0,
		"telegraph_every": int(mechanics.get("telegraph", {}).get("every", 0)),
	}
	_uid_counter += 1
	return enemy

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
			if bool(sk["ready_seen"]):
				continue
			# Um evento por recarga, no instante exato, mesmo que o passo tenha terminado a < EPS dele.
			var at := float(sk["ready_at"])
			if at < best_at - EPS or (absf(at - best_at) <= EPS and 1 < best_prio):
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
	for kind in ["pb_stacks_dr", "oath"]:
		var stacks := _stacks(hero, kind)
		if stacks > 0:
			mods.append({"op": "ADD_PERCENT", "value": -float(hero["passives"][kind]["per_stack"]) * stacks, "source_type": "PASSIVE", "source_id": kind})
	var protector := _protector(hero, "ally_aura_dr")
	if not protector.is_empty():
		mods.append({"op": "ADD_PERCENT", "value": -float(protector["passives"]["ally_aura_dr"]["value"]), "source_type": "PASSIVE", "source_id": "ally_aura_dr"})
	return CombatMath.resolve_stat(1.0, mods, DAMAGE_TAKEN_FLOOR)

# --- Passivas ------------------------------------------------------------------------------------

## Outro herói vivo com a passiva `kind` (aura ou redirecionamento para aliados); {} se não houver.
func _protector(hero: Dictionary, kind: String) -> Dictionary:
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if hid != hero["id"] and h["alive"] and h["passives"].has(kind):
			return h
	return {}

func _stacks(hero: Dictionary, kind: String) -> int:
	var st: Dictionary = hero["stacks"].get(kind, {})
	if st.is_empty() or float(st["until"]) <= time + EPS:
		return 0
	return int(st["n"])

func _add_stack(hero: Dictionary, kind: String) -> int:
	var params: Dictionary = hero["passives"][kind]
	var n := mini(int(params.get("max_stacks", params.get("max_charges", 1))), _stacks(hero, kind) + 1)
	hero["stacks"][kind] = {"n": n, "until": time + float(params["duration"])}
	return n

## Perfect Block: Inabalável, Ferro Responde (recarga do Contra-Golpe) e Peso do Escudo.
func _on_perfect_block(hero: Dictionary, enemy: Dictionary, events: Array) -> void:
	if hero["passives"].has("pb_stacks_dr"):
		_add_stack(hero, "pb_stacks_dr")
	if hero["passives"].has("pb_charges_counter"):
		var params: Dictionary = hero["passives"]["pb_charges_counter"]
		_add_stack(hero, "pb_charges_counter")
		for sk in hero["skills"]:
			if sk["def"]["id"] == params["skill"] and float(sk["ready_at"]) > time + EPS:
				sk["ready_at"] = maxf(time, float(sk["ready_at"]) - float(params["cd_per_charge"]))
				sk["ready_seen"] = false
	if hero["passives"].has("pb_damage") and enemy["alive"]:
		var raw := _stat(hero, "attack") * float(hero["passives"]["pb_damage"]["coefficient"])
		var dmg := CombatMath.hit_damage(raw, _enemy_defense(enemy), 0.0, _enemy_damage_taken(enemy))
		events.append({"type": "passive_damage", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": dmg})
		_damage_enemy(enemy, dmg, hero, events)

## Atordoa um inimigo; se ele estiver preparando um golpe telegrafado, o golpe é interrompido.
func _stun(enemy: Dictionary, base_seconds: float, events: Array) -> void:
	var seconds := CombatMath.control_duration(base_seconds, float(enemy["stats"]["tenacity"]))
	if float(enemy["telegraph_until"]) > time + EPS:
		enemy["telegraph_until"] = -INF
		enemy["attacks_done"] = 0
		enemy["next_at"] = time + seconds
		events.append({"type": "telegraph_interrupted", "time": time, "uid": enemy["uid"]})
	else:
		enemy["next_at"] = maxf(float(enemy["next_at"]), time) + seconds
	events.append({"type": "enemy_stunned", "time": time, "uid": enemy["uid"], "seconds": seconds})

## Passivas que modificam uma skill específica (Dispersão de Choque, Rede de Micélio, Contenção Arcana).
func _after_skill(hero: Dictionary, def: Dictionary, primary: Dictionary, was_prepared: bool, events: Array) -> void:
	var p: Dictionary = hero["passives"]
	if p.has("skill_splash") and p["skill_splash"]["skill"] == def["id"] and not def["effects"][0].has("second_coefficient"):
		var other := _nth_alive_enemy(1)
		if not other.is_empty():
			_skill_hit(hero, other, float(p["skill_splash"]["coefficient"]), def["id"], events, {})
	if primary.is_empty() or not primary["alive"]:
		return
	if p.has("skill_slow") and p["skill_slow"]["skill"] == def["id"]:
		primary["slow"] = float(p["skill_slow"]["value"])
		primary["slow_until"] = time + float(p["skill_slow"]["duration"])
	if p.has("skill_stun_vs_prepared") and p["skill_stun_vs_prepared"]["skill"] == def["id"] and was_prepared:
		if float(primary.get("stun_lock_until", -INF)) <= time + EPS:
			primary["stun_lock_until"] = time + float(p["skill_stun_vs_prepared"]["per_target_lock"])
			_stun(primary, float(p["skill_stun_vs_prepared"]["duration"]), events)

## Status final do herói com buffs ativos (pipeline do contrato). damage_taken e shield têm regras próprias.
func _stat(hero: Dictionary, stat: String) -> float:
	var mods: Array = []
	for e in _active_effects(hero):
		if e["stat"] == stat and e.has("op"):
			mods.append({"op": e["op"], "value": e["value"], "source_type": "SKILL", "source_id": e["source"]})
	var base := float(hero["stats"][stat])
	return base if mods.is_empty() else CombatMath.resolve_stat(base, mods, 0.0)

# --- Skills ----------------------------------------------------------------------------------

func _trigger_ok(hero: Dictionary, trigger: Dictionary) -> bool:
	match String(trigger.get("type", "")):
		"enemies_alive":
			return not _first_alive_enemy().is_empty()
		"enemy_unmarked":
			return float(_first_alive_enemy().get("marked_until", 0.0)) <= time + EPS
		"enemy_marked":
			return float(_first_alive_enemy().get("marked_until", 0.0)) > time + EPS
		"enemy_marked_or_imbalanced":
			var first := _first_alive_enemy()
			return not first.is_empty() and _prepared(first)
		"ally_hp_below":
			return not _lowest_hp_ally(float(trigger["threshold"])).is_empty()
		"self_hp_below":
			return float(hero["hp"]) <= float(hero["stats"]["max_hp"]) * float(trigger["threshold"]) + EPS
		"ally_behind_hp_below":
			var index: int = _hero_order.find(hero["id"])
			for i in range(index + 1, _hero_order.size()):
				var ally: Dictionary = _heroes[_hero_order[i]]
				if ally["alive"] and float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(trigger["threshold"]) + EPS:
					return true
			return false
		"enemy_telegraph":
			for e in _enemies:
				if e["alive"] and float(e["telegraph_until"]) > time + EPS:
					return true
			return false
		"telegraph_on_self":
			for e in _enemies:
				if e["alive"] and float(e["telegraph_until"]) > time + EPS and e["telegraph_target"] == hero["id"]:
					return true
			return false
		"enemy_targets_ally":
			for e in _enemies:
				if e["alive"] and e["target"] != "" and e["target"] != hero["id"] and _heroes[e["target"]]["alive"]:
					return true
			return false
	return false

func _lowest_hp_ally(threshold: float, exclude: String = "") -> Dictionary:
	var result: Dictionary = {}
	var lowest := threshold
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["alive"] or hid == exclude:
			continue
		var ratio: float = float(h["hp"]) / float(h["stats"]["max_hp"])
		if ratio <= lowest:
			lowest = ratio
			result = h
	return result

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
	sk["ready_seen"] = false
	events.append({"type": "skill_cast", "time": time, "hero": hero["id"], "skill": def["id"]})
	var primary := _first_alive_enemy()
	var was_prepared := not primary.is_empty() and _prepared(primary)
	for fx in def["effects"]:
		match String(fx["type"]):
			"mark":
				var target := _first_alive_enemy()
				if not target.is_empty():
					target["marked_until"] = time + float(fx["duration"])
					target["mark_owner"] = hero["id"]
					target["mark_bonus"] = float(fx.get("owner_bonus", 0.0))
					events.append({"type": "enemy_marked", "time": time, "target": target["uid"]})
			"attack":
				if bool(fx.get("only_if_marked", false)) and not _marked(_first_alive_enemy()):
					continue
				for hit in int(fx.get("hits", 1)):
					var target := _first_alive_enemy()
					if target.is_empty():
						break
					_skill_hit(hero, target, float(fx["coefficient"]), def["id"], events, fx)
				var extra := {"second_coefficient": 1, "third_coefficient": 2}
				for key in extra:
					if fx.has(key):
						var other := _nth_alive_enemy(int(extra[key]))
						if not other.is_empty():
							_skill_hit(hero, other, float(fx[key]), def["id"], events, {})
			"enemy_debuff":
				var target := _first_alive_enemy()
				if not target.is_empty():
					target["defense_debuff"] = float(fx["value"])
					target["defense_debuff_until"] = time + float(fx["duration"])
			"shield":
				var ally := _lowest_hp_ally(float(fx.get("threshold", 0.7)))
				if not ally.is_empty():
					_grant_shield(hero, ally, float(fx["fraction"]), float(fx["duration"]), def["id"], events)
					if fx.has("second_fraction"):
						var second := _lowest_hp_ally(1.0, ally["id"])
						if not second.is_empty():
							_grant_shield(hero, second, float(fx["second_fraction"]), float(fx["duration"]), def["id"], events)
			"heal":
				var ally := _lowest_hp_ally(float(fx.get("threshold", 1.0)))
				if not ally.is_empty():
					var amount: float = minf(_stat(hero, "attack") * float(fx["coefficient"]), float(ally["stats"]["max_hp"]) - float(ally["hp"]))
					ally["hp"] = float(ally["hp"]) + amount
					events.append({"type": "healing", "time": time, "source": hero["id"], "target": ally["id"], "amount": amount})
					for e in _enemies:
						if e["alive"]:
							e["threat"][hero["id"]] = float(e["threat"].get(hero["id"], 0.0)) + amount * ThreatMath.HEAL_THREAT
			"buff":
				var targets: Array = []
				if fx["targets"] == "self":
					targets = [hero]
				elif fx["targets"] == "allies_behind":
					var index: int = _hero_order.find(hero["id"])
					for i in range(index + 1, _hero_order.size()):
						if _heroes[_hero_order[i]]["alive"]:
							targets.append(_heroes[_hero_order[i]])
				elif fx["targets"] == "allies":
					for hid in _hero_order:
						if hid != hero["id"] and _heroes[hid]["alive"]:
							targets.append(_heroes[hid])
				for t in targets:
					t["effects"].append({
						"source": def["id"], "stat": fx["stat"], "op": fx["op"], "value": float(fx["value"]),
						"expires_at": time + float(fx["duration"]), "defensive": bool(fx.get("defensive", false)),
					})
			"counter_stance":
				hero["stance"] = {
					"expires_at": time + float(fx["duration"]), "reduction": float(fx["damage_reduction"]),
					"coefficient": float(fx["counter_coefficient"]), "stagger": float(fx.get("counter_stagger", 0.0)),
					"imbalance": bool(fx.get("imbalance", false)), "stun": float(fx.get("stun", 0.0)),
				}
			"taunt":
				_taunt = {"hero": hero["id"], "until": time + float(fx["duration"]), "ally_multiplier": float(fx["ally_damage_multiplier"])}
				if bool(fx.get("imbalance", false)):
					for e in _enemies:
						if e["alive"]:
							_imbalance(e, events)
	_after_skill(hero, def, primary, was_prepared, events)

## n-ésimo inimigo vivo (0 = o primeiro) ou {}.
func _nth_alive_enemy(n: int) -> Dictionary:
	var seen := 0
	for e in _enemies:
		if not e["alive"]:
			continue
		if seen == n:
			return e
		seen += 1
	return {}

func _grant_shield(caster: Dictionary, ally: Dictionary, fraction: float, duration: float, source: String, events: Array) -> void:
	var amount: float = float(ally["stats"]["max_hp"]) * fraction
	ally["effects"].append({"source": source, "caster": caster["id"], "stat": "shield", "value": amount, "expires_at": time + duration})
	events.append({"type": "shield_granted", "time": time, "hero": ally["id"], "amount": amount})

func _marked(enemy: Dictionary) -> bool:
	return not enemy.is_empty() and float(enemy["marked_until"]) > time + EPS

## Alvo "preparado" da proposta: marcado ou com Desequilíbrio.
func _prepared(enemy: Dictionary) -> bool:
	return _marked(enemy) or float(enemy["imbalance_until"]) > time + EPS

func _imbalance(enemy: Dictionary, events: Array) -> void:
	enemy["imbalance_until"] = time + float(_profiles["imbalance"]["duration"])
	events.append({"type": "enemy_imbalanced", "time": time, "uid": enemy["uid"]})

## Bônus de dano condicional (damage_bonus): Marca do próprio herói e efeitos contra alvo preparado.
func _damage_bonus(hero: Dictionary, enemy: Dictionary, fx: Dictionary) -> float:
	var bonus := 1.0
	if _marked(enemy) and enemy.get("mark_owner", "") == hero["id"]:
		bonus += float(enemy.get("mark_bonus", 0.0))
	if _prepared(enemy):
		bonus += float(fx.get("bonus_vs_prepared", 0.0))
		bonus += float(hero["passives"].get("bonus_vs_prepared", {}).get("value", 0.0))
	return bonus

## Penetração ativa de Ponta de Penetração (após crítico).
func _armor_pen(hero: Dictionary) -> float:
	return float(hero["passives"]["crit_armor_pen"]["value"]) if _stacks(hero, "crit_armor_pen") > 0 else 0.0

func _enemy_defense(enemy: Dictionary) -> float:
	var defense: float = float(enemy["stats"]["defense"])
	if float(enemy["defense_debuff_until"]) > time + EPS:
		defense *= 1.0 + float(enemy["defense_debuff"])
	return defense

## fx: efeito de ataque da skill (stagger e bônus condicionais); {} para alvos secundários.
func _skill_hit(hero: Dictionary, enemy: Dictionary, coefficient: float, skill_id: String, events: Array, fx: Dictionary) -> void:
	var raw := _stat(hero, "attack") * coefficient * _damage_bonus(hero, enemy, fx)
	var damage := CombatMath.hit_damage(raw, _enemy_defense(enemy), _armor_pen(hero), _enemy_damage_taken(enemy))
	var stagger := float(fx.get("stagger", 0.0))
	if _marked(enemy):
		stagger *= 1.0 + float(fx.get("stagger_bonus_vs_marked", 0.0))
	if _prepared(enemy):
		stagger *= 1.0 + float(fx.get("stagger_bonus_vs_prepared", 0.0))
	events.append({"type": "skill_damage", "time": time, "source": hero["id"], "skill": skill_id, "target": enemy["uid"], "damage": damage})
	if not _damage_enemy(enemy, damage, hero, events):
		_apply_stagger(enemy, stagger, events)

# --- Stagger, Desequilíbrio e mecânicas de chefe -----------------------------------------------

func _broken(enemy: Dictionary) -> bool:
	return float(enemy["broken_until"]) > time + EPS

## Multiplicador de dano recebido pelo inimigo: quebra e janela exposta após golpe telegrafado errado.
func _enemy_damage_taken(enemy: Dictionary) -> float:
	var mult := 1.0
	if _broken(enemy):
		mult += float(_profiles["stagger"]["ranks"][enemy["rank"]]["vulnerability"])
	if float(enemy["exposed_until"]) > time + EPS:
		mult += float(enemy["exposed_vulnerability"])
	return mult

func _refresh_posture(enemy: Dictionary) -> void:
	var rules: Dictionary = _profiles["stagger"]
	var start := maxf(float(enemy["posture_at"]), float(enemy["last_stagger_at"]) + float(rules["recovery_delay"]))
	if time > start:
		var regen: float = (time - start) * float(rules["recovery_per_second"]) * float(enemy["posture_max"])
		enemy["posture"] = minf(float(enemy["posture_max"]), float(enemy["posture"]) + regen)
	enemy["posture_at"] = time

func _apply_stagger(enemy: Dictionary, amount: float, events: Array) -> void:
	if amount <= 0.0 or not enemy["alive"] or float(enemy["posture_max"]) <= 0.0:
		return
	if _broken(enemy) or float(enemy["immune_until"]) > time + EPS:
		return
	_refresh_posture(enemy)
	if float(enemy["imbalance_until"]) > time + EPS:
		amount *= 1.0 + float(_profiles["imbalance"]["stagger_taken_bonus"])
	enemy["posture"] = float(enemy["posture"]) - amount
	enemy["last_stagger_at"] = time
	if float(enemy["posture"]) > EPS:
		return
	var rank_rules: Dictionary = _profiles["stagger"]["ranks"][enemy["rank"]]
	enemy["broken_until"] = time + float(rank_rules["break_duration"])
	enemy["immune_until"] = float(enemy["broken_until"]) + float(rank_rules["immunity"])
	enemy["posture"] = float(enemy["posture_max"])
	enemy["posture_at"] = enemy["immune_until"]
	var interrupted := float(enemy["telegraph_until"]) > time + EPS
	enemy["telegraph_until"] = -INF
	if interrupted:
		enemy["attacks_done"] = 0
	enemy["next_at"] = maxf(float(enemy["next_at"]), float(enemy["broken_until"]))
	events.append({"type": "enemy_staggered", "time": time, "uid": enemy["uid"], "until": enemy["broken_until"], "interrupted": interrupted})

func _check_phases(enemy: Dictionary, events: Array) -> void:
	var phases: Array = enemy["mechanics"].get("phases", [])
	while int(enemy["phase_index"]) < phases.size():
		var phase: Dictionary = phases[int(enemy["phase_index"])]
		if float(enemy["hp"]) > float(enemy["stats"]["max_hp"]) * float(phase["hp_below"]) + EPS:
			return
		enemy["phase_index"] = int(enemy["phase_index"]) + 1
		events.append({"type": "boss_phase", "time": time, "uid": enemy["uid"], "phase": int(enemy["phase_index"]) + 1})
		if phase.has("telegraph_every"):
			enemy["telegraph_every"] = int(phase["telegraph_every"])
		if bool(phase.get("spawn_deferred", false)):
			var count := int(phase.get("spawn_count", _deferred.size()))
			for _i in mini(count, _deferred.size()):
				var d: Dictionary = _deferred.pop_front()
				var add := _new_enemy(d["row"], int(d["level"]))
				_enemies.insert(0, add)
				events.append({"type": "enemy_spawned", "time": time, "uid": add["uid"], "id": add["id"]})

# --- Ataques ---------------------------------------------------------------------------------

## Aplica dano a um inimigo, gera ameaça para o herói e trata a derrota. Devolve true se morreu.
func _damage_enemy(enemy: Dictionary, damage: float, hero: Dictionary, events: Array) -> bool:
	var effective := minf(damage, float(enemy["hp"]))
	enemy["hp"] = maxf(0.0, float(enemy["hp"]) - damage)
	var gained: float = effective * _threat_multiplier(hero)
	enemy["threat"][hero["id"]] = float(enemy["threat"].get(hero["id"], 0.0)) + gained
	if float(enemy["hp"]) > 0.0:
		_check_phases(enemy, events)
		return false
	enemy["alive"] = false
	enemy["telegraph_until"] = -INF
	var xp := int(_profiles.get("xp", {}).get("by_rank", {}).get(enemy["rank"], 0))
	events.append({"type": "enemy_defeated", "time": time, "uid": enemy["uid"], "id": enemy["id"], "xp": xp})
	if _first_alive_enemy().is_empty():
		_finish_encounter(events)
	return true

func _hero_attack(hero: Dictionary, events: Array) -> void:
	var enemy := _first_alive_enemy()
	if enemy.is_empty():
		return
	var is_crit := false
	if _crits:
		var chance := _stat(hero, "crit_chance")
		if _marked(enemy):
			chance += float(hero["passives"].get("crit_vs_marked", {}).get("value", 0.0))
		is_crit = _rng.randf() < clampf(chance, 0.0, CombatMath.CRIT_CHANCE_CAP)
	var raw := CombatMath.apply_crit(_stat(hero, "attack") * _damage_bonus(hero, enemy, {}), is_crit, _stat(hero, "crit_damage"))
	var damage := CombatMath.hit_damage(raw, _enemy_defense(enemy), _armor_pen(hero), _enemy_damage_taken(enemy))
	if is_crit and hero["passives"].has("crit_armor_pen"):
		_add_stack(hero, "crit_armor_pen")
	hero["next_at"] = float(hero["next_at"]) + CombatMath.attack_interval(_stat(hero, "attack_speed"))
	events.append({"type": "hero_attack", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": damage, "crit": is_crit})
	if not _damage_enemy(enemy, damage, hero, events):
		_apply_stagger(enemy, float(hero["basic_stagger"]), events)

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

## Ação do inimigo no seu turno: golpe telegrafado (início ou resolução) ou ataque comum.
func _enemy_act(enemy: Dictionary, events: Array) -> void:
	var telegraph: Dictionary = enemy["mechanics"].get("telegraph", {})
	var speed := float(enemy["stats"]["attack_speed"])
	if float(enemy.get("slow_until", -INF)) > time + EPS:
		speed *= 1.0 - float(enemy["slow"])
	var interval := CombatMath.attack_interval(speed)
	if float(enemy["telegraph_until"]) > -INF and float(enemy["telegraph_until"]) <= time + EPS:
		enemy["telegraph_until"] = -INF
		enemy["attacks_done"] = 0
		enemy["next_at"] = time + interval
		_enemy_attack(enemy, events, float(telegraph["coefficient"]), telegraph)
		return
	var every := int(enemy["telegraph_every"])
	if every > 0 and int(enemy["attacks_done"]) >= every - 1:
		enemy["telegraph_until"] = time + float(telegraph["windup"])
		enemy["telegraph_target"] = _front_hero() if String(telegraph.get("target", "")) == "front" else _choose_target(enemy)
		enemy["next_at"] = enemy["telegraph_until"]
		events.append({"type": "telegraph_started", "time": time, "uid": enemy["uid"], "skill": telegraph["id"], "hits_at": enemy["telegraph_until"]})
		_evaluate_skills(events)
		return
	enemy["attacks_done"] = int(enemy["attacks_done"]) + 1
	enemy["next_at"] = float(enemy["next_at"]) + interval
	_enemy_attack(enemy, events, float(enemy["mechanics"].get("basic_coefficient", 1.0)))

## Primeiro herói vivo da formação (linha de frente).
func _front_hero() -> String:
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			return hid
	return ""

func _enemy_attack(enemy: Dictionary, events: Array, coefficient: float = 1.0, telegraph: Dictionary = {}) -> void:
	var target_id := _front_hero() if String(telegraph.get("target", "")) == "front" else _choose_target(enemy)
	if target_id == "":
		return
	var hero: Dictionary = _heroes[target_id]
	var raw := float(enemy["stats"]["attack"]) * coefficient
	if float(enemy["imbalance_until"]) > time + EPS:
		raw *= 1.0 + float(_profiles["imbalance"]["damage_bonus"])
	if _taunt_active() and _taunt["hero"] != target_id:
		raw *= float(_taunt["ally_multiplier"])
	var stance_hit := _stance_active(hero)
	var reduction := float(hero["stance"]["reduction"]) if stance_hit else 0.0
	var pb: Dictionary = hero["perfect_block"]
	var blocked: bool = not pb.is_empty() and float(hero["guard_ready_at"]) <= time + EPS
	var damage := CombatMath.hit_damage(raw, _stat(hero, "defense"), 0.0, _damage_taken_multiplier(hero, reduction))
	# Escudo Compartilhado: parte do golpe vai para o protetor, com a defesa dele e sem matá-lo.
	var guardian := _protector(hero, "redirect")
	if not guardian.is_empty():
		var moved: float = damage * float(guardian["passives"]["redirect"]["fraction"])
		var taken: float = minf(moved * (1.0 - CombatMath.mitigation(_stat(guardian, "defense"))) * _damage_taken_multiplier(guardian), float(guardian["hp"]) - 1.0)
		if taken > 0.0:
			damage -= moved
			guardian["hp"] = float(guardian["hp"]) - taken
			events.append({"type": "damage_redirected", "time": time, "from": target_id, "to": guardian["id"], "damage": taken})
	# Voto do Escudo: proteger um aliado (aura ou redirecionamento) gera Juramento.
	for protector in [_protector(hero, "ally_aura_dr"), guardian]:
		if not protector.is_empty() and protector["passives"].has("oath"):
			_add_stack(protector, "oath")
			break
	if blocked:
		damage = maxf(CombatMath.MIN_DAMAGE, damage * float(pb["damage_multiplier"]))
		hero["guard_ready_at"] = time + float(pb["recharge"])
		_imbalance(enemy, events)
		events.append({"type": "perfect_block", "time": time, "hero": target_id, "source": enemy["uid"], "heavy": not telegraph.is_empty()})
	if not telegraph.is_empty() and (blocked or stance_hit):
		enemy["exposed_until"] = time + float(telegraph["exposed_duration"])
		enemy["exposed_vulnerability"] = float(telegraph["exposed_vulnerability"])
		events.append({"type": "enemy_exposed", "time": time, "uid": enemy["uid"], "until": enemy["exposed_until"]})
	var remaining := damage
	for effect in _active_effects(hero):
		if effect["stat"] == "shield" and remaining > 0.0:
			var absorbed: float = minf(remaining, float(effect["value"]))
			effect["value"] = float(effect["value"]) - absorbed
			remaining -= absorbed
			var caster: String = String(effect.get("caster", target_id))
			enemy["threat"][caster] = float(enemy["threat"].get(caster, 0.0)) + absorbed * ThreatMath.SHIELD_THREAT
			events.append({"type": "shield_absorbed", "time": time, "hero": target_id, "amount": absorbed})
	hero["hp"] = maxf(0.0, float(hero["hp"]) - remaining)
	events.append({"type": "enemy_attack", "time": time, "source": enemy["uid"], "target": target_id, "damage": remaining, "heavy": not telegraph.is_empty()})
	if blocked:
		_apply_stagger(enemy, float(pb.get("stagger", 0.0)), events)
		_on_perfect_block(hero, enemy, events)
	if float(hero["hp"]) <= 0.0:
		hero["alive"] = false
		hero["stance"] = {}
		events.append({"type": "hero_defeated", "time": time, "id": target_id})
		if _no_hero_alive():
			state = "lost"
			events.append({"type": "expedition_lost", "time": time, "node_id": _nodes[node_index]["id"]})
			return
	elif stance_hit and enemy["alive"]:
		var mult := 1.0
		var stagger := float(hero["stance"].get("stagger", 0.0))
		if float(enemy["imbalance_until"]) > time + EPS:
			mult += float(hero["passives"].get("counter_bonus_vs_imbalanced", {}).get("value", 0.0))
		var iron: Dictionary = hero["passives"].get("pb_charges_counter", {})
		if not iron.is_empty() and _stacks(hero, "pb_charges_counter") >= int(iron["max_charges"]):
			mult += float(iron["damage_bonus"])
			stagger *= 1.0 + float(iron["stagger_bonus"])
			hero["stacks"].erase("pb_charges_counter")
			events.append({"type": "iron_response", "time": time, "hero": hero["id"]})
		var raw_counter := float(hero["stance"]["coefficient"]) * _stat(hero, "attack") * mult * _damage_bonus(hero, enemy, {})
		var counter := CombatMath.hit_damage(raw_counter, _enemy_defense(enemy), 0.0, _enemy_damage_taken(enemy))
		events.append({"type": "counter_attack", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": counter})
		if not _damage_enemy(enemy, counter, hero, events):
			if bool(hero["stance"].get("imbalance", false)):
				_imbalance(enemy, events)
			_apply_stagger(enemy, stagger, events)
			if float(hero["stance"].get("stun", 0.0)) > 0.0:
				_stun(enemy, float(hero["stance"]["stun"]), events)
		# A postura é consumida pelo contra-ataque; a ameaça acima ainda usou o ×1,5 da postura ativa.
		hero["stance"] = {}

func _no_hero_alive() -> bool:
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			return false
	return true
