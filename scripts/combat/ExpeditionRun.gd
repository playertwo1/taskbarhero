extends RefCounted
class_name ExpeditionRun

const Profiles := preload("res://scripts/combat/BalanceProfiles.gd")

## Núcleo de simulação da expedição do slice (SLICE-1A-3a e 1A-4a).
## Puro: sem autoload, sem nós e sem tempo real. Determinístico dado rota, dados, seed e opções.
## Usa CombatMath, BalanceProfiles e ThreatMath. Inclui skills com gatilho e cooldown, buffs de
## damage_taken, postura de contra-ataque, provocação e alvo por ameaça.
## SLICE-1A-4b/1C (HIPÓTESE): Stagger e quebra, Perfect Block e Desequilíbrio, golpe telegrafado,
## fases de chefe com adds adiados e objetivos sequenciais, ranks de skill, XP por inimigo derrotado e as
## passivas/Traits do recorte com efeito em combate (data/skills/passives_slice.json). Sem loot.
## Regras: docs/00_project/CORE_LOOP.md e docs/06_balance/v1/capitulos/CAPITULO_01.md.

const SLOTS := ["front", "mid", "back"]
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
var _scale: float = 1.0  # combat_scale do perfil: escala HP/ATK/DEF e as constantes absolutas do dano
var _targeting: String = "threat"  # threat | front
var _rng := RandomNumberGenerator.new()
var _node_started_at: float = 0.0
var _transition_until: float = 0.0
var _pending_start: bool = true
var _taunt: Dictionary = {}
var _profiles: Dictionary = {}
var _deferred: Array = []
var _uid_counter: int = 0
## Recuperação na expedição: fôlego entre encontros vem do perfil do capítulo (DECIDIDO por Rafael);
## poções e cura em evento ficam desligadas por padrão e só existem em cenários do Argos.
var _potions: Dictionary = {}
var _recovery: Dictionary = {}
var _event_heal: Dictionary = {}
var _fell_this_encounter: bool = false
## Telemetria opcional (SLICE-1A-5): só agrega os eventos; o combate nunca a lê.
var telemetry: SliceTelemetry = null
## SLICE-1B: loot, eventos e escolhas pendentes. Sem loot/events o run é idêntico ao anterior.
var loot: LootRoller = null
var director: EventDirector = null
var pending: Dictionary = {}
var rewards: Dictionary = {"items": [], "materials": {}, "flags": {}, "lore": []}
var _offers: Array = []
var _flags: Dictionary = {}
var _first_clear: bool = false
var _party_level: int = 1
var _equipped_list: Array = []
var _equipped_echo: String = ""
var _event_mods: Array = []
var _mod_uid: int = 0

## options: seed (int), crits (bool), party_level (int), formation (slot → hero id),
## targeting ("threat" ou "front"), skills (linhas de skills_slice.json) e
## builds (hero id → chave de build em row["builds"]), items (linhas do catálogo)
## e equipment (hero id → lista de instâncias com id, rarity, item_power, item_level),
## skill_ranks (skill id → rank 1–5), trigger_overrides (skill id → gatilho escolhido no Hub)
## e passives (linhas de passives_slice.json; sem elas, heróis lutam sem passivas/Traits).
## Recuperação: recovery_between_encounters {fraction, only_if_no_fall} (padrão: perfil do capítulo;
## {} desliga), potions {count, heal_fraction, threshold} e event_heal {id do evento → fração}.
static func create(route: Dictionary, hero_rows: Array, enemy_rows: Array, options: Dictionary = {}) -> ExpeditionRun:
	var run := ExpeditionRun.new()
	run._nodes = route.get("nodes", [])
	run._transition_seconds = float(route.get("transition_seconds", 0.6))
	run._crits = bool(options.get("crits", true))
	run._potions = options.get("potions", {}).duplicate()
	run._event_heal = options.get("event_heal", {})
	run._targeting = String(options.get("targeting", "threat"))
	run._rng.seed = int(options.get("seed", 1))
	if bool(options.get("telemetry", false)):
		run.telemetry = SliceTelemetry.new(options.get("telemetry_context", {}))
	run.loot = options.get("loot", null)
	run.director = options.get("events", null)
	run._flags = options.get("flags", {}).duplicate()
	run._first_clear = bool(options.get("first_clear", false))
	run._party_level = int(options.get("party_level", 1))
	run._equipped_echo = String(options.get("equipped_echo", ""))
	for hero_gear in options.get("equipment", {}).values():
		run._equipped_list.append_array(hero_gear)
	var chapter_id := String(route.get("chapter_id", ""))
	run._profiles = options.get("balance_profiles", Profiles.load_profiles(chapter_id))
	run._scale = Profiles.combat_scale(run._profiles)
	run._recovery = options.get("recovery_between_encounters", run._profiles.get("recovery_between_encounters", {}))
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
	var formation: Dictionary = options.get("formation", _default_formation(hero_rows))
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
		var stats := Profiles.hero_stats(row, level, run._profiles)
		stats = SliceItemStats.equip(stats, hid, equipment.get(hid, []), item_rows, -1.0, run._profiles)
		var skills: Array = []
		var passive_ids: Array = [row.get("identity_passive", "")]
		var tree_mode := bool(options.get("passive_tree", false))
		if builds.has(hid) and row.has("builds") and row["builds"].has(builds[hid]):
			if tree_mode:
				passive_ids.append_array(PassiveTree.resolve(row, String(builds[hid]), level, options.get("passives", []), options))
			else:
				passive_ids.append_array(row["builds"][builds[hid]].get("passives", []))
			for sid in row["builds"][builds[hid]]["skills"]:
				var def: Dictionary = ranked_skill(skills_by_id[sid], int(ranks.get(sid, 1)), run._profiles)
				if overrides.has(sid):
					def["trigger"] = overrides[sid]
				skills.append({"def": def, "ready_at": 0.0, "ready_seen": false})
			# Terceiro slot: a Signature do herói (fixa, além das 2 skills da build).
			var signature := String(row.get("signature", ""))
			var signature_unlock := int(row.get("signature_unlock_level", 10))
			if signature != "" and level >= signature_unlock and skills_by_id.has(signature) and not skills.any(func(k): return k["def"]["id"] == signature):
				var sig_def: Dictionary = ranked_skill(skills_by_id[signature], int(ranks.get(signature, 1)), run._profiles)
				if overrides.has(signature):
					sig_def["trigger"] = overrides[signature]
				skills.append({"def": sig_def, "ready_at": 0.0, "ready_seen": false})
		run._heroes[hid] = {
			"id": hid, "stats": stats, "hp": float(stats["max_hp"]), "alive": true, "next_at": 0.0,
			"threat_profile": String(row.get("threat_profile", "DEFAULT")),
			"skills": skills, "effects": [], "stance": {}, "guard_ready_at": 0.0,
			"basic_stagger": float(row.get("basic_stagger", 0.0)), "perfect_block": row.get("perfect_block", {}),
			"passives": {}, "stacks": {}, "guard": 0.0, "guard_cfg": row.get("guard", {}), "lance_boost_until": -INF, "open_uid": "", "crit_streak_n": 0, "ricochet_boost": 0.0, "last_ricochet": {}, "rhythm_uid": "", "rhythm_n": 0, "step_back_ready_at": -INF, "last_bastion": {}, "judgement_count": 0, "judgement_last": -INF, "judgement_ready": false, "pressure_ready": false, "focus_uid": "", "target_lock": "", "target_lock_until": -INF, "lock_once": false,
			"aim_uid": "", "aim_n": 0, "crit_boost_ready": 0.0,
		}
		for pid in passive_ids:
			if passive_rows.has(pid) and String(passive_rows[pid]["kind"]) != "none" and (tree_mode or int(passive_rows[pid].get("unlock_level", 1)) <= level):
				run._heroes[hid]["passives"][passive_rows[pid]["kind"]] = passive_rows[pid]["params"]
	run._hero_order = order
	return run

static func _default_formation(hero_rows: Array) -> Dictionary:
	var formation := {}
	for row in hero_rows:
		var slot := String(row.get("formation_slot", ""))
		if SLOTS.has(slot) and not formation.has(slot):
			formation[slot] = String(row.get("id", ""))
	return formation

## Cópia da skill no rank pedido. Cada rank R2–R5 em def["ranks"] aplica, em ordem, "set"
## ("campo" no topo ou "índice.campo" num efeito) e "add" (efeitos novos). Rank 1 = dados base.
## Fonte dos ranks: docs/06_balance/v1/03_SKILLS_PASSIVAS.md §3 (HIPÓTESE; proposta original de ranks no git).
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

## XP necessário para passar do nível ao seguinte (HIPÓTESE em combat_core.xp.curve).
static func xp_to_next(level: int, profiles: Dictionary) -> int:
	var c: Dictionary = profiles["xp"]["curve"]
	return int(round(float(c["base"]) * pow(float(c["growth"]), level - 1) + float(c["per_level"]) * level))

## Avança a simulação em dt segundos e devolve os eventos ocorridos no intervalo.
func step(dt: float) -> Array:
	var events: Array = []
	if state == "won" or state == "lost" or state == "choice":
		return events
	var target := time + dt
	if _pending_start:
		_pending_start = false
		_advance_node(events)
	while state != "won" and state != "lost":
		if state == "choice":
			break
		if state == "transition":
			if _transition_until <= target:
				time = _transition_until
				_advance_node(events)
				continue
			time = target
			break
		var ev := _next_event(target)
		if ev.is_empty():
			_advance_clock(target, events)
			break
		_advance_clock(float(ev["at"]), events)
		if state != "fighting":
			continue
		match String(ev["kind"]):
			"bastion_end":
				_end_last_bastion(ev["ref"], events)
				if state == "fighting":
					_evaluate_skills(events)
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
	if telemetry != null:
		telemetry.ingest(events)
	return events

## Avança o relógio do combate: aplica regeneração de postura e a cura de escudos que expiram no intervalo.
func _advance_clock(to: float, events: Array) -> void:
	var from := time
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["alive"]:
			continue
		for e in h["effects"]:
			if e.has("regen_fraction"):
				var overlap := minf(to, float(e["expires_at"])) - maxf(from, float(e["started_at"]))
				if overlap > 0.0:
					_heal_hero(h, h, float(h["stats"]["max_hp"]) * float(e["regen_fraction"]) * overlap, "regen", events, to)
			if e["stat"] == "shield" and e.has("expire_heal") and not bool(e.get("expire_done", false)) and float(e["expires_at"]) <= to + EPS:
				e["expire_done"] = true
				var amount := minf(float(e["value"]) * float(e["expire_heal"]), float(h["stats"]["max_hp"]) * float(e["expire_heal_cap"]))
				_heal_hero(h, _heroes.get(e.get("caster", h["id"]), h), amount, "shield_expired", events, float(e["expires_at"]))
	time = to

## Contra-Golpe acelerado durante o Último Bastião: a recarga restante corre `1/scale` vezes mais rápido até o fim
## da janela. Calculado no lançamento (independe do tamanho do passo da simulação).
func _bastion_accelerate(hero: Dictionary, sk: Dictionary) -> void:
	if not _bastion_active(hero) or sk["def"]["id"] != "skill_bas_007":
		return
	var scale := float(hero["last_bastion"]["cfg"]["counter_cooldown_scale"])
	var remaining := float(sk["ready_at"]) - time
	var window := float(hero["last_bastion"]["until"]) - time
	if remaining <= 0.0 or window <= 0.0 or scale <= 0.0:
		return
	var fast_needed := remaining * scale
	sk["ready_at"] = time + (fast_needed if fast_needed <= window else window + (remaining - window / scale))
	sk["ready_seen"] = false

func _bastion_active(hero: Dictionary) -> bool:
	return not hero["last_bastion"].is_empty() and float(hero["last_bastion"]["until"]) > time + EPS

## Fim do Último Bastião: onda de choque proporcional ao absorvido e, no R3, cura dos aliados.
func _end_last_bastion(hero: Dictionary, events: Array) -> void:
	var st: Dictionary = hero["last_bastion"]
	var cfg: Dictionary = st["cfg"]
	var absorbed := float(st["absorbed"])
	hero["last_bastion"] = {}
	var wave := minf(absorbed * float(cfg["wave_coefficient"]), float(cfg["wave_cap"]) * _stat(hero, "attack"))
	for enemy in _alive_targets():
		var dmg := CombatMath.hit_damage(wave, _enemy_defense(enemy), 0.0, _enemy_damage_taken(enemy), _scale)
		events.append({"type": "skill_damage", "time": time, "source": hero["id"], "skill": "skill_bas_011", "target": enemy["uid"], "damage": dmg})
		_damage_enemy(enemy, dmg, hero, events)
	if float(cfg.get("heal_fraction", 0.0)) > 0.0:
		for hid in _hero_order:
			var ally: Dictionary = _heroes[hid]
			if hid != hero["id"] and ally["alive"]:
				_heal_hero(ally, hero, minf(absorbed * float(cfg["heal_fraction"]), float(cfg["heal_cap"]) * float(ally["stats"]["max_hp"])), "last_bastion", events, time)

func _heal_hero(target: Dictionary, source: Dictionary, amount: float, cause: String, events: Array, at: float) -> void:
	var healed := minf(amount, float(target["stats"]["max_hp"]) - float(target["hp"]))
	if healed <= 0.0:
		return
	target["hp"] = float(target["hp"]) + healed
	events.append({"type": "healing", "time": at, "source": source["id"], "target": target["id"], "amount": healed, "cause": cause})

## Roda até o fim (vitória ou derrota) ou até max_time e devolve todos os eventos.
## Em `choice`, usa chooser.call(pending) -> int (ou a opção 0 sem chooser); sem isso o laço nunca avançaria.
func run_to_end(dt: float = 0.25, max_time: float = 3600.0, chooser: Callable = Callable()) -> Array:
	var all: Array = []
	while state != "won" and state != "lost" and time < max_time:
		if state == "choice":
			var index := int(chooser.call(pending)) if chooser.is_valid() else 0
			all.append_array(choose(index))
		else:
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
				"marked": _marked(e), "mark_readable": _marked(e) and bool(e.get("mark_readable", false)),
			})
	var party: Array = []
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		party.append({"id": hid, "hp": float(h["hp"]), "max_hp": float(h["stats"]["max_hp"]), "alive": bool(h["alive"]), "guard": float(h["guard"])})
	var snap := {
		"state": state, "time": time, "node_index": node_index,
		"node_id": _nodes[node_index]["id"] if node_index >= 0 and node_index < _nodes.size() else "",
		"party_hp": _party_hp(), "party": party, "enemies": enemies,
	}
	if telemetry != null:
		snap["telemetry"] = telemetry.summary()
	return snap

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
		if director != null and not director.event_by_id(String(node["id"])).is_empty():
			_queue_event(director.event_by_id(String(node["id"])))
			_next_offer(events)
			return
		if _event_heal.has(node["id"]):
			_recover_party(float(_event_heal[node["id"]]), "event", events)
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
	_fell_this_encounter = false
	_purge_expired()
	if node_index > 0:
		_apply_guard_carry()
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
	_apply_event_mods(events)
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
	var stats := Profiles.enemy_stats(row, level, true, _profiles)
	var stagger: Dictionary = _profiles.get("stagger", {}).get("ranks", {}).get(row["rank"], {})
	var mechanics: Dictionary = row.get("mechanics", {})
	var enemy := {
		"uid": "%s#%d" % [row["id"], _uid_counter], "id": row["id"], "rank": row["rank"], "stats": stats,
		"hp": float(stats["max_hp"]), "alive": true, "targetable": true, "objective": false, "threat": {}, "target": "",
		"next_at": time + CombatMath.attack_interval(float(stats["attack_speed"])),
		"marked_until": 0.0, "defense_debuff_until": 0.0, "defense_debuff": 0.0,
		"posture_max": float(stagger.get("posture", 0.0)), "posture": float(stagger.get("posture", 0.0)),
		"posture_at": time, "last_stagger_at": -INF, "broken_until": -INF, "immune_until": -INF,
		"imbalance_until": -INF, "exposed_until": -INF, "exposed_vulnerability": 0.0,
		"mechanics": mechanics, "phase_index": 0, "attacks_done": 0, "telegraph_until": -INF, "telegraph_target": "",
		"mark_owner": "", "mark_bonus": 0.0,
		"telegraph_every": int(mechanics.get("telegraph", {}).get("every", 0)),
		"corruption_fragments_remaining": 0, "corruption_fragments_total": 0, "corruption_fragment_hp": 0.0,
	}
	_uid_counter += 1
	return enemy

func _new_corruption_fragment(parent: Dictionary) -> Dictionary:
	var hp := float(parent["corruption_fragment_hp"])
	var sequence := int(parent["corruption_fragments_total"]) - int(parent["corruption_fragments_remaining"]) + 1
	var stats: Dictionary = parent["stats"].duplicate(true)
	stats["max_hp"] = hp
	var fragment := {
		"uid": "corruption_fragment#%d" % _uid_counter, "id": "corruption_fragment", "rank": "NORMAL", "stats": stats,
		"hp": hp, "alive": true, "targetable": true, "objective": true, "threat": {}, "target": "",
		"next_at": INF, "marked_until": 0.0, "defense_debuff_until": 0.0, "defense_debuff": 0.0,
		"posture_max": 0.0, "posture": 0.0, "posture_at": time, "last_stagger_at": -INF,
		"broken_until": -INF, "immune_until": -INF, "imbalance_until": -INF, "exposed_until": -INF,
		"exposed_vulnerability": 0.0, "mechanics": {}, "phase_index": 0, "attacks_done": 0,
		"telegraph_until": -INF, "telegraph_target": "", "mark_owner": "", "mark_bonus": 0.0,
		"telegraph_every": 0, "objective_parent_uid": parent["uid"], "objective_sequence": sequence,
		"objective_total": int(parent["corruption_fragments_total"]),
	}
	_uid_counter += 1
	return fragment

func _spawn_corruption_fragment(parent: Dictionary, events: Array) -> void:
	var fragment := _new_corruption_fragment(parent)
	_enemies.insert(0, fragment)
	events.append({
		"type": "corruption_fragment_spawned", "time": time, "uid": fragment["uid"],
		"sequence": fragment["objective_sequence"], "total": fragment["objective_total"],
	})

func _purge_expired() -> void:
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		h["effects"] = h["effects"].filter(func(e): return float(e["expires_at"]) > time)
		if not h["last_bastion"].is_empty() and float(h["last_bastion"]["until"]) <= time:
			h["last_bastion"] = {}
		if not h["stance"].is_empty() and float(h["stance"]["expires_at"]) <= time:
			h["stance"] = {}
	if not _taunt.is_empty() and float(_taunt["until"]) <= time:
		_taunt = {}

func _finish_encounter(events: Array) -> void:
	events.append({
		"type": "encounter_cleared", "time": time, "node_id": _nodes[node_index]["id"],
		"duration": time - _node_started_at, "party_hp": _party_hp(),
		"first_clear_echo": String(_nodes[node_index].get("first_clear_echo", "")),
		"fragment_reward": int(_nodes[node_index].get("fragment_reward", 0)),
	})
	var last_node := node_index >= _nodes.size() - 1
	if not last_node and not _recovery.is_empty() and not (bool(_recovery.get("only_if_no_fall", false)) and _fell_this_encounter):
		_recover_party(float(_recovery["fraction"]), "between_encounters", events)
	_expire_event_mods()
	_queue_offers_after_encounter(events)
	_next_offer(events)

## Recupera uma fração do HP máximo dos heróis vivos (derrotados continuam fora até o Hub).
func _recover_party(fraction: float, source: String, events: Array) -> void:
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if h["alive"]:
			var amount: float = minf(float(h["stats"]["max_hp"]) * fraction, float(h["stats"]["max_hp"]) - float(h["hp"]))
			if amount > 0.0:
				h["hp"] = float(h["hp"]) + amount
				events.append({"type": "recovery", "time": time, "source": source, "target": hid, "amount": amount})

## Próximo instante com ação até `limit`. Empate: skill pronta, heróis (na ordem), inimigos (na ordem).
func _next_event(limit: float) -> Dictionary:
	var best: Dictionary = {}
	var best_at := INF
	var best_prio := 99
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if h["alive"] and not h["last_bastion"].is_empty():
			var end_at := maxf(float(h["last_bastion"]["until"]), time)
			if end_at < best_at - EPS or (absf(end_at - best_at) <= EPS and 0 < best_prio):
				best_at = end_at
				best_prio = 0
				best = {"kind": "bastion_end", "at": end_at, "ref": h}
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
		if e["alive"] and not bool(e.get("objective", false)):
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
		if e["alive"] and bool(e.get("targetable", true)):
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
	var profile: Dictionary = _profiles.get("threat_profiles", {}).get(hero.get("threat_profile", "DEFAULT"), {})
	if _has_defensive_effect(hero):
		return float(profile.get("defensive_active_multiplier", profile.get("base_multiplier", 1.0)))
	return float(profile.get("base_multiplier", 1.0))

func _damage_taken_multiplier(hero: Dictionary, extra_reduction: float = 0.0, heavy: bool = false) -> float:
	var mods: Array = []
	for e in _active_effects(hero):
		if e["stat"] == "damage_taken" and (heavy or not bool(e.get("only_heavy", false))):
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
	var floor := float(_profiles.get("stat_caps", {}).get("damage_taken_multiplier_min", 0.25))
	return CombatMath.resolve_stat(1.0, mods, floor)

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
	if hero["passives"].has("block_charges_counter"):
		_add_stack(hero, "block_charges_counter")
	_count_judgement(hero)
	# Muralha Viva R5 estende os efeitos ativos (+1 s, máx. +2 s por uso); Contra-Golpe R5 cria uma onda.
	for hid in _hero_order:
		for e in _active_effects(_heroes[hid]):
			if float(e.get("pb_extend", 0.0)) > 0.0 and hero["skills"].any(func(sk): return sk["def"]["id"] == e["source"]):
				var add := minf(float(e["pb_extend"]), float(e["pb_extend_max"]) - float(e["extended"]))
				if add > 0.0:
					e["expires_at"] = float(e["expires_at"]) + add
					e["extended"] = float(e["extended"]) + add
	for sk in hero["skills"]:
		var wave := float(sk["def"]["effects"][0].get("pb_wave", 0.0)) if sk["def"]["id"] == "skill_bas_007" else 0.0
		if wave > 0.0:
			for index in [1, 2]:
				var extra := _nth_alive_enemy(index)
				if not extra.is_empty():
					_skill_hit(hero, extra, wave, "skill_bas_007", events, {})
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
		var dmg := CombatMath.hit_damage(raw, _enemy_defense(enemy), 0.0, _enemy_damage_taken(enemy), _scale)
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
	if p.has("skill_area") and p["skill_area"]["skill"] == def["id"]:
		var index := 1
		while true:
			var other := _nth_alive_enemy(index)
			if other.is_empty():
				break
			_skill_hit(hero, other, float(p["skill_area"]["coefficient"]), def["id"], events, {})
			index += 1
	if p.has("focus_basic_bonus") and p["focus_basic_bonus"]["skill"] == def["id"] and not primary.is_empty():
		hero["focus_uid"] = primary["uid"]
	var echo_cfg: Dictionary = p.get("skill_cd_on_prepared", {})
	if not echo_cfg.is_empty() and echo_cfg["skill"] == def["id"] and was_prepared:
		_reduce_cooldown(hero, String(echo_cfg["skill"]), float(echo_cfg["cd_reduce"]))
	var chain_cfg: Dictionary = p.get("prism_then_lance", {})
	if not chain_cfg.is_empty() and chain_cfg["prism"] == def["id"]:
		hero["lance_boost_until"] = time + float(chain_cfg["window"])
	var rico: Dictionary = hero["last_ricochet"]
	if def["id"] == "skill_fle_010" and not rico.is_empty():
		var burst: Dictionary = p.get("ricochet_burst_cd", {})
		if not burst.is_empty() and rico["uids"].size() >= int(burst["min_targets"]):
			_reduce_cooldown(hero, String(burst["skill"]), float(burst["cd_reduce"]))
		if p.has("lock_on_ricochet_second") and rico["uids"].size() > 1:
			hero["target_lock"] = rico["uids"][1]
			hero["target_lock_until"] = INF
			hero["lock_once"] = true
	var link: Dictionary = p.get("rhythm_link", {})
	if not link.is_empty() and link["skills"].has(def["id"]):
		var link_ok: bool = (not primary.is_empty() and _marked(primary)) or (def["id"] == "skill_fle_010" and bool(rico.get("marked_hit", false)))
		if link_ok:
			for other_id in link["skills"]:
				if other_id != def["id"]:
					_reduce_cooldown(hero, String(other_id), float(link["cd_reduce"]))
	if def["id"] != "skill_fle_010":
		hero["last_ricochet"] = {}
	var open_cfg: Dictionary = p.get("skill_next_crit", {})
	if not open_cfg.is_empty() and open_cfg["skill"] == def["id"] and not primary.is_empty():
		hero["open_uid"] = primary["uid"]
	# Ponto de Mira: Olho Aguçado fixa a mira no alvo escolhido durante a janela da skill.
	if p.has("lock_on_skill_cast") and p["lock_on_skill_cast"]["skill"] == def["id"] and not primary.is_empty():
		hero["target_lock"] = primary["uid"]
		hero["target_lock_until"] = time + float(def["effects"][0].get("duration", 0.0))
		hero["lock_once"] = false
	var fx0: Dictionary = def["effects"][0] if not def["effects"].is_empty() else {}
	if float(fx0.get("atk_debuff_value", 0.0)) > 0.0:
		var debuff_target := primary
		if p.has("skill_area") and p["skill_area"]["skill"] == def["id"]:
			debuff_target = _nth_alive_enemy(1)
		if not debuff_target.is_empty() and debuff_target["alive"]:
			debuff_target["atk_debuff"] = float(fx0["atk_debuff_value"])
			debuff_target["atk_debuff_until"] = time + float(fx0["atk_debuff_duration"])
	if float(fx0.get("survive_ally_boost", 0.0)) > 0.0 and not primary.is_empty() and primary["alive"]:
		primary["prism_boost"] = float(fx0["survive_ally_boost"])
		primary["prism_owner"] = hero["id"]
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
		"guard_at_least":
			return not _first_alive_enemy().is_empty() and float(hero["guard"]) + EPS >= float(trigger["amount"])
		"guard_and_hp_below":
			if _first_alive_enemy().is_empty() or float(hero["guard"]) + EPS < float(trigger["amount"]):
				return false
			for hid in _hero_order:
				var h: Dictionary = _heroes[hid]
				if h["alive"] and float(h["hp"]) <= float(h["stats"]["max_hp"]) * float(trigger["threshold"]) + EPS:
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

## Menor porcentagem de HP entre heróis vivos; empate mantém o primeiro da formação.
func _lowest_hp_hero_id() -> String:
	var result := ""
	var lowest_ratio: float = INF
	for hid in _hero_order:
		var hero: Dictionary = _heroes[hid]
		if not hero["alive"]:
			continue
		var ratio := float(hero["hp"]) / float(hero["stats"]["max_hp"])
		if ratio < lowest_ratio - EPS:
			lowest_ratio = ratio
			result = String(hid)
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
	_bastion_accelerate(hero, sk)
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
					target["mark_extend"] = float(fx.get("ally_hit_extend", 0.0))
					target["mark_transfer"] = bool(fx.get("transfer_on_kill", false))
					target["mark_readable"] = hero["passives"].has("mark_readable")
					target["mark_applied"] = time
					target["party_used"] = false
					target["mark_shared"] = 0.0
					events.append({"type": "enemy_marked", "time": time, "target": target["uid"], "readable": bool(target["mark_readable"])})
			"attack":
				if bool(fx.get("only_if_marked", false)) and not _marked(_first_alive_enemy()):
					continue
				_prey_of_party(hero, _first_alive_enemy())
				var hit_count := int(fx.get("hits", 1))
				for hit in hit_count:
					var target := _first_alive_enemy()
					if target.is_empty():
						break
					var hit_fx: Dictionary = fx
					if hit == hit_count - 1 and (fx.has("last_hit_bonus") or fx.has("last_crit_vs_marked") or fx.has("last_extend_mark")):
						hit_fx = fx.duplicate()
						hit_fx["_last"] = true
					_skill_hit(hero, target, float(fx["coefficient"]), def["id"], events, hit_fx)
				var extra := {"second_coefficient": 1, "third_coefficient": 2}
				for key in extra:
					if fx.has(key):
						var other := _nth_alive_enemy(int(extra[key]))
						if not other.is_empty():
							_skill_hit(hero, other, float(fx[key]), def["id"], events, {})
							if key == "second_coefficient" and float(fx.get("second_hit_cd_reduce", 0.0)) > 0.0:
								for prism in hero["skills"]:
									if prism["def"]["id"] == "skill_iri_005" and float(prism["ready_at"]) > time + EPS:
										prism["ready_at"] = maxf(time, float(prism["ready_at"]) - float(fx["second_hit_cd_reduce"]))
										prism["ready_seen"] = false
			"last_bastion":
				if not _spend_guard(hero, float(fx["guard_cost"]), events):
					continue
				hero["last_bastion"] = {"since": time, "until": time + float(fx["duration"]), "absorbed": 0.0, "cfg": fx}
				for hid in _hero_order:
					if hid != hero["id"] and _heroes[hid]["alive"]:
						_heroes[hid]["effects"].append({
							"source": def["id"], "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(fx["ally_damage_reduction"]),
							"started_at": time, "expires_at": time + float(fx["duration"]), "defensive": true,
						})
				events.append({"type": "last_bastion_started", "time": time, "hero": hero["id"], "until": hero["last_bastion"]["until"]})
				for accel_sk in hero["skills"]:
					_bastion_accelerate(hero, accel_sk)
			"shield_bash":
				if not _spend_guard(hero, float(fx["guard_cost"]), events):
					continue
				var bash_target := _first_alive_enemy()
				if bash_target.is_empty():
					continue
				var was_imbalanced := float(bash_target["imbalance_until"]) > time + EPS
				var bash_fx: Dictionary = fx
				var spread: Dictionary = hero["passives"].get("bash_imbalance_spread", {})
				var spread_on: bool = not spread.is_empty() and spread["skill"] == def["id"]
				if spread_on and was_imbalanced:
					bash_fx = fx.duplicate()
					bash_fx["stagger"] = float(fx["stagger"]) * (1.0 + float(spread["stagger_bonus"]))
				_skill_hit(hero, bash_target, float(fx["coefficient"]), def["id"], events, bash_fx)
				var extra_cfg: Dictionary = hero["passives"].get("bash_extra", {})
				var collision_count := 1 + (int(extra_cfg["extra_targets"]) if not extra_cfg.is_empty() and extra_cfg["skill"] == def["id"] else 0)
				var behind_list: Array = []
				for behind_index in range(1, collision_count + 1):
					var behind_enemy := _nth_alive_enemy(behind_index)
					if not behind_enemy.is_empty():
						behind_list.append(behind_enemy)
				if bash_target["alive"] and not behind_list.is_empty():
					_skill_hit(hero, bash_target, float(fx["collision_coefficient"]), def["id"], events, {})
					for behind_enemy in behind_list:
						_skill_hit(hero, behind_enemy, float(fx["collision_coefficient"]), def["id"], events, {})
					if bash_target["alive"]:
						_stun(bash_target, float(fx["collision_stun"]), events)
						if bool(fx.get("collision_imbalance", false)):
							_imbalance(bash_target, events)
					if spread_on and behind_list[0]["alive"]:
						_imbalance(behind_list[0], events)
				if was_imbalanced and float(fx.get("explosion_coefficient", 0.0)) > 0.0:
					var blast_index := 1
					while true:
						var blast_target := _nth_alive_enemy(blast_index)
						if blast_target.is_empty():
							break
						_skill_hit(hero, blast_target, float(fx["explosion_coefficient"]), def["id"], events, {})
						blast_index += 1
				var line: Dictionary = hero["passives"].get("bash_line", {})
				if not line.is_empty() and line["skill"] == def["id"]:
					for line_enemy in _alive_targets():
						line_enemy["slow"] = float(line["slow"])
						line_enemy["slow_until"] = time + float(line["duration"])
					if bash_target["alive"]:
						_imbalance(bash_target, events)
			"ricochet":
				var pool := _alive_targets()
				if pool.is_empty():
					continue
				var boost := 1.0 + float(hero["ricochet_boost"])
				hero["ricochet_boost"] = 0.0
				var coefficient := float(fx["coefficient"]) * boost
				var uids: Array = []
				var marked_hit := false
				var prey: Dictionary = {}
				for i in mini(pool.size(), int(fx["jumps"]) + 1):
					var bounce_target: Dictionary = pool[i]
					var jump_bonus := 1.0
					var own_mark: bool = _marked(bounce_target) and bounce_target.get("mark_owner", "") == hero["id"]
					if i > 0 and own_mark:
						jump_bonus += float(fx.get("marked_jump_bonus", 0.0))
					if own_mark:
						marked_hit = true
						prey = bounce_target
					_skill_hit(hero, bounce_target, coefficient * jump_bonus, def["id"], events, fx if i == 0 else {})
					uids.append(bounce_target["uid"])
					coefficient *= float(fx["falloff"])
				if uids.size() >= 2 and float(fx.get("distinct_boost", 0.0)) > 0.0:
					hero["ricochet_boost"] = float(fx["distinct_boost"])
				if float(fx.get("finisher_coefficient", 0.0)) > 0.0 and not prey.is_empty() and prey["alive"]:
					_skill_hit(hero, prey, float(fx["finisher_coefficient"]) * boost, def["id"], events, {})
				hero["last_ricochet"] = {"uids": uids, "marked_hit": marked_hit}
			"arrow_rain":
				for rain_target in _alive_targets():
					for arrow in int(fx["arrows"]):
						if rain_target["alive"]:
							_skill_hit(hero, rain_target, float(fx["coefficient"]), def["id"], events, fx if arrow == 0 else {})
					if rain_target["alive"] and _marked(rain_target) and rain_target.get("mark_owner", "") == hero["id"]:
						_skill_hit(hero, rain_target, float(fx["focus_coefficient"]), def["id"], events, {})
						if float(fx.get("mark_extend", 0.0)) > 0.0:
							rain_target["marked_until"] = float(rain_target["marked_until"]) + float(fx["mark_extend"])
						if float(fx.get("opening_vulnerability", 0.0)) > 0.0:
							rain_target["exposed_until"] = time + float(fx["opening_duration"])
							rain_target["exposed_vulnerability"] = float(fx["opening_vulnerability"])
			"convergence":
				var conv_pool := _alive_targets()
				for conv_i in conv_pool.size():
					var conv_enemy: Dictionary = conv_pool[conv_i]
					var conv_coeff := float(fx["primary_coefficient"]) if conv_i == 0 else float(fx["coefficient"])
					var conv_fx := {"bonus_vs_prepared": float(fx["prepared_bonus"])}
					if conv_i == 0:
						conv_fx["stagger"] = float(fx["stagger"])
					_skill_hit(hero, conv_enemy, conv_coeff, def["id"], events, conv_fx)
				if float(fx.get("ally_atk_bonus", 0.0)) > 0.0:
					for hid in _hero_order:
						if hid != hero["id"] and _heroes[hid]["alive"]:
							_heroes[hid]["effects"].append({"source": def["id"], "stat": "attack", "op": "ADD_PERCENT", "value": float(fx["ally_atk_bonus"]),
								"started_at": time, "expires_at": time + float(fx["ally_duration"])})
			"enemy_debuff":
				var target := _first_alive_enemy()
				if not target.is_empty():
					var duration := float(fx["duration"])
					var extend: Dictionary = hero["passives"].get("debuff_extend_vs_prepared", {})
					if not extend.is_empty() and extend["skill"] == def["id"] and was_prepared:
						duration = minf(duration + float(extend["extra"]), maxf(duration, float(extend["cap"])))
					target["defense_debuff"] = float(fx["value"])
					target["defense_debuff_until"] = time + duration
					var atk_cfg: Dictionary = hero["passives"].get("skill_atk_debuff", {})
					if not atk_cfg.is_empty() and atk_cfg["skill"] == def["id"]:
						target["atk_debuff"] = maxf(float(target.get("atk_debuff", 0.0)), float(atk_cfg["value"]))
						target["atk_debuff_until"] = time + duration
					var all_cfg: Dictionary = hero["passives"].get("debuff_all", {})
					if not all_cfg.is_empty() and all_cfg["skill"] == def["id"]:
						for debuffed in _alive_targets():
							if debuffed["uid"] != target["uid"]:
								debuffed["defense_debuff"] = float(fx["value"]) * float(all_cfg["fraction"])
								debuffed["defense_debuff_until"] = time + duration
			"shield":
				var ally := _lowest_hp_ally(float(fx.get("threshold", 0.7)))
				if not ally.is_empty():
					var fraction := float(fx["fraction"])
					var low: Dictionary = hero["passives"].get("shield_bonus_low", {})
					if not low.is_empty() and low["skill"] == def["id"] and float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(low["threshold"]) + EPS:
						fraction *= 1.0 + float(low["value"])
					var shield_duration := float(fx["duration"])
					var dur_cfg: Dictionary = hero["passives"].get("skill_duration", {})
					if not dur_cfg.is_empty() and dur_cfg["skill"] == def["id"]:
						shield_duration += float(dur_cfg["extra"])
					_grant_shield(hero, ally, fraction, shield_duration, def["id"], events, fx)
					_support_bonus(hero, def["id"], ally)
					if fx.has("second_fraction"):
						var second := _lowest_hp_ally(1.0, ally["id"])
						if not second.is_empty():
							_grant_shield(hero, second, float(fx["second_fraction"]), float(fx["duration"]), def["id"], events, fx)
			"heal":
				var heal_ally := _lowest_hp_ally(float(fx.get("threshold", 1.0)))
				if not heal_ally.is_empty():
					var heal_coeff := float(fx["coefficient"])
					var heal_bonus: Dictionary = hero["passives"].get("skill_heal_bonus", {})
					if not heal_bonus.is_empty() and heal_bonus["skill"] == def["id"]:
						heal_coeff *= 1.0 + float(heal_bonus["value"])
					var wanted: float = _stat(hero, "attack") * heal_coeff
					var amount: float = minf(wanted, float(heal_ally["stats"]["max_hp"]) - float(heal_ally["hp"]))
					heal_ally["hp"] = float(heal_ally["hp"]) + amount
					events.append({"type": "healing", "time": time, "source": hero["id"], "target": heal_ally["id"], "amount": amount})
					for e in _enemies:
						if e["alive"]:
							e["threat"][hero["id"]] = float(e["threat"].get(hero["id"], 0.0)) + amount * ThreatMath.HEAL_THREAT
					var second_cfg: Dictionary = hero["passives"].get("heal_second", {})
					if not second_cfg.is_empty() and second_cfg["skill"] == def["id"]:
						var heal_second := _lowest_hp_ally(1.0, heal_ally["id"])
						if not heal_second.is_empty():
							var extra_heal: float = minf(amount * float(second_cfg["fraction"]), float(heal_second["stats"]["max_hp"]) - float(heal_second["hp"]))
							heal_second["hp"] = float(heal_second["hp"]) + extra_heal
							events.append({"type": "healing", "time": time, "source": hero["id"], "target": heal_second["id"], "amount": extra_heal})
					var overheal: Dictionary = hero["passives"].get("overheal_shield", {})
					if not overheal.is_empty() and wanted > amount:
						var shield_amount := minf((wanted - amount) * float(overheal["fraction"]), float(overheal["cap"]) * float(heal_ally["stats"]["max_hp"]))
						if shield_amount > 0.0:
							_grant_shield(hero, heal_ally, shield_amount / float(heal_ally["stats"]["max_hp"]), float(overheal["duration"]), def["id"], events)
					_support_bonus(hero, def["id"], heal_ally)
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
					t["effects"].append(_buff_effect(def, fx))
				var heavy_guard: Dictionary = hero["passives"].get("skill_heavy_guard", {})
				if not heavy_guard.is_empty() and heavy_guard["skill"] == def["id"]:
					for t in targets:
						t["effects"].append({"source": def["id"], "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(heavy_guard["value"]),
							"started_at": time, "expires_at": time + float(fx["duration"]), "defensive": true, "only_heavy": true})
				if _equipped_echo == "echo_c1_001" and String(def["id"]) == "skill_bas_006" and _lowest_hp_hero_id() == String(hero["id"]):
					hero["effects"].append(_buff_effect(def, fx))
			"counter_stance":
				hero["stance"] = {
					"expires_at": time + float(fx["duration"]), "reduction": float(fx["damage_reduction"]),
					"coefficient": float(fx["counter_coefficient"]), "stagger": float(fx.get("counter_stagger", 0.0)),
					"imbalance": bool(fx.get("imbalance", false)), "stun": float(fx.get("stun", 0.0)),
				}
			"taunt":
				_taunt = {"hero": hero["id"], "until": time + float(fx["duration"]), "ally_multiplier": float(fx["ally_damage_multiplier"]), "cd_on_kill": float(fx.get("cd_on_kill", 0.0)), "skill": def["id"]}
				if bool(fx.get("imbalance", false)):
					for e in _enemies:
						if e["alive"]:
							_imbalance(e, events)
				_gain_guard(hero, float(hero["guard_cfg"].get("on_taunt", 0.0)), events)
				var taunt_extra: Dictionary = hero["passives"].get("taunt_extra", {})
				var zone_cfg: Dictionary = hero["passives"].get("presence_zone", {})
				for taunted in _alive_targets():
					_gain_guard(hero, float(taunt_extra.get("guard_per_enemy", 0.0)) + float(zone_cfg.get("taunt_guard", 0.0)), events)
					if not taunt_extra.is_empty():
						taunted["slow"] = float(taunt_extra["slow"])
						taunted["slow_until"] = float(_taunt["until"])
	var quick: Dictionary = hero["passives"].get("quick_draw", {})
	if not quick.is_empty():
		hero["next_at"] = minf(float(hero["next_at"]), time + CombatMath.attack_interval(_stat(hero, "attack_speed")) * float(quick["factor"]))
	_after_skill(hero, def, primary, was_prepared, events)

## Efeito de buff com os campos opcionais dos ranks altos (extensões, regeneração e bônus condicionais).
func _buff_effect(def: Dictionary, fx: Dictionary) -> Dictionary:
	var effect := {
		"source": def["id"], "stat": fx["stat"], "op": fx["op"], "value": float(fx["value"]), "started_at": time,
		"expires_at": time + float(fx["duration"]), "defensive": bool(fx.get("defensive", false)),
	}
	for key in ["regen_fraction", "pb_extend", "pb_extend_max", "crit_vs_marked", "first_crit_extend", "crit_boost"]:
		if fx.has(key):
			effect[key] = float(fx[key])
	effect["extended"] = 0.0
	return effect

## Primeiro efeito ativo do herói com a origem `source` e o campo `key` positivo; {} se não houver.
func _effect_with(hero: Dictionary, source: String, key: String) -> Dictionary:
	for e in _active_effects(hero):
		if e["source"] == source and e.has(key) and float(e[key]) > 0.0:
			return e
	return {}

## Inimigos vivos e alvejáveis, na ordem da fila (o primeiro é o alvo prioritário).
func _alive_targets() -> Array:
	return _enemies.filter(func(e): return e["alive"] and bool(e.get("targetable", true)))

## Encurta a recarga restante de uma skill do herói (nunca abaixo de agora).
func _reduce_cooldown(hero: Dictionary, skill_id: String, seconds: float) -> void:
	for sk in hero["skills"]:
		if sk["def"]["id"] == skill_id and float(sk["ready_at"]) > time + EPS:
			sk["ready_at"] = maxf(time, float(sk["ready_at"]) - seconds)
			sk["ready_seen"] = false

## n-ésimo inimigo vivo (0 = o primeiro) ou {}.
func _nth_alive_enemy(n: int) -> Dictionary:
	var seen := 0
	for e in _enemies:
		if not e["alive"] or not bool(e.get("targetable", true)):
			continue
		if seen == n:
			return e
		seen += 1
	return {}

# --- Guarda (Bastião) --------------------------------------------------------------------------

## B5 da Flecha (Presa da Party): a 1ª skill ofensiva na presa, dentro da janela, reforça os aliados.
func _prey_of_party(hero: Dictionary, prey: Dictionary) -> void:
	var cfg: Dictionary = hero["passives"].get("prey_of_party", {})
	if cfg.is_empty() or prey.is_empty() or not _marked(prey) or prey.get("mark_owner", "") != hero["id"] or bool(prey.get("party_used", true)):
		return
	if time - float(prey.get("mark_applied", -INF)) > float(cfg["window"]):
		return
	prey["party_used"] = true
	for hid in _hero_order:
		if hid != hero["id"] and _heroes[hid]["alive"]:
			_heroes[hid]["effects"].append({"source": "passive_fle_presa_da_party", "stat": "attack", "op": "ADD_PERCENT", "value": float(cfg["atk_bonus"]),
				"started_at": time, "expires_at": time + float(cfg["duration"])})

## Chama Viva: cura/escudo dão +ATK ao receptor por um tempo.
func _support_bonus(hero: Dictionary, skill_id: String, receiver: Dictionary) -> void:
	var cfg: Dictionary = hero["passives"].get("support_atk_bonus", {})
	if cfg.is_empty() or not cfg["skills"].has(skill_id):
		return
	receiver["effects"].append({"source": "trait_iri_003", "stat": "attack", "op": "ADD_PERCENT", "value": float(cfg["value"]),
		"started_at": time, "expires_at": time + float(cfg["duration"])})

## C5 da Íris (Fonte de Lúmen): aliado abaixo do limiar refaz o Pulso (recarga longa entre usos).
func _check_fountain(ally: Dictionary, _events: Array) -> void:
	for hid in _hero_order:
		var healer: Dictionary = _heroes[hid]
		var cfg: Dictionary = healer["passives"].get("heal_reset", {})
		if cfg.is_empty() or not healer["alive"] or float(healer.get("fountain_ready_at", -INF)) > time + EPS:
			continue
		if float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(cfg["threshold"]) + EPS:
			healer["fountain_ready_at"] = time + float(cfg["cooldown"])
			_reduce_cooldown(healer, String(cfg["skill"]), 1000.0)

## A4 (Ninguém Fica Para Trás): ao cair abaixo do limiar, Bastião ganha Guarda e o aliado recebe redução curta.
func _check_ally_low(ally: Dictionary, events: Array) -> void:
	if not ally["alive"]:
		return
	for hid in _hero_order:
		var guard_hero: Dictionary = _heroes[hid]
		var cfg: Dictionary = guard_hero["passives"].get("ally_low_guard", {})
		if cfg.is_empty() or hid == ally["id"] or not guard_hero["alive"]:
			continue
		var below := float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(cfg["threshold"]) + EPS
		var ready_at: Dictionary = guard_hero.get("ally_low_ready", {})
		if below and float(ready_at.get(ally["id"], -INF)) <= time + EPS:
			ready_at[ally["id"]] = time + float(cfg["cooldown"])
			guard_hero["ally_low_ready"] = ready_at
			_gain_guard(guard_hero, float(cfg["guard"]), events)
			ally["effects"].append({"source": "passive_bas_ninguem_para_tras", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(cfg["reduction"]),
				"started_at": time, "expires_at": time + float(cfg["duration"]), "defensive": true})

## A5 (Guarda Eterna): salva um aliado do golpe fatal (1 HP + redução curta), com recarga longa.
func _try_save_ally(ally: Dictionary, events: Array) -> bool:
	for hid in _hero_order:
		var guardian: Dictionary = _heroes[hid]
		var cfg: Dictionary = guardian["passives"].get("guard_eternal", {})
		if cfg.is_empty() or hid == ally["id"] or not guardian["alive"] or float(guardian.get("eternal_ready_at", -INF)) > time + EPS:
			continue
		guardian["eternal_ready_at"] = time + float(cfg["cooldown"])
		ally["hp"] = _scale
		ally["effects"].append({"source": "passive_bas_guarda_eterna", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(cfg["reduction"]),
			"started_at": time, "expires_at": time + float(cfg["duration"]), "defensive": true})
		events.append({"type": "ally_saved", "time": time, "hero": ally["id"], "by": guardian["id"]})
		return true
	return false

## Maior redução de velocidade de ataque imposta pelas passivas de zona (Sem Passagem e Não Passarão).
func _zone_slow(enemy: Dictionary) -> float:
	var best := 0.0
	var imbalanced := float(enemy["imbalance_until"]) > time + EPS
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["alive"]:
			continue
		var c2: Dictionary = h["passives"].get("zone_slow", {})
		if not c2.is_empty():
			best = maxf(best, float(c2["value_imbalanced"]) if imbalanced else float(c2["value"]))
		var zone: Dictionary = h["passives"].get("presence_zone", {})
		if not zone.is_empty():
			best = maxf(best, float(zone["slow_imbalanced"]) if imbalanced else float(zone["slow"]))
	return best

## B3: bônus somado ao coeficiente do Contra-Golpe pelas cargas; consome todas.
func _counter_charge_bonus(hero: Dictionary) -> float:
	var cfg: Dictionary = hero["passives"].get("block_charges_counter", {})
	if cfg.is_empty():
		return 0.0
	var n := _stacks(hero, "block_charges_counter")
	hero["stacks"].erase("block_charges_counter")
	return float(cfg["per_charge"]) * n

## B4: Elite/Miniboss/Boss que atinge o herói perde postura (dobra no Perfect Block).
func _elite_stagger(hero: Dictionary, enemy: Dictionary, perfect: bool, events: Array) -> void:
	var cfg: Dictionary = hero["passives"].get("anti_elite_stagger", {})
	if cfg.is_empty() or enemy["rank"] == "NORMAL":
		return
	_apply_stagger(enemy, float(cfg["stagger"]) * (float(cfg["perfect_multiplier"]) if perfect else 1.0), events)

## B5: conta Perfect Blocks dentro da janela; ao chegar em `required` arma o Julgamento.
func _count_judgement(hero: Dictionary) -> void:
	var cfg: Dictionary = hero["passives"].get("judgement_iron", {})
	if cfg.is_empty():
		return
	hero["judgement_count"] = (int(hero["judgement_count"]) + 1) if time - float(hero["judgement_last"]) <= float(cfg["window"]) else 1
	hero["judgement_last"] = time
	if int(hero["judgement_count"]) >= int(cfg["required"]):
		hero["judgement_ready"] = true
		hero["judgement_count"] = 0

func _fire_judgement(hero: Dictionary, events: Array) -> void:
	hero["judgement_ready"] = false
	for enemy in _alive_targets():
		_skill_hit(hero, enemy, float(hero["passives"]["judgement_iron"]["coefficient"]), "skill_bas_007", events, {})

func _gain_guard(hero: Dictionary, amount: float, events: Array) -> void:
	var cfg: Dictionary = hero["guard_cfg"]
	if cfg.is_empty() or amount <= 0.0 or not hero["alive"]:
		return
	var before := float(hero["guard"])
	hero["guard"] = minf(float(cfg["max"]), before + amount)
	if float(hero["guard"]) > before:
		events.append({"type": "guard_gained", "time": time, "hero": hero["id"], "amount": float(hero["guard"]) - before, "total": hero["guard"]})

func _spend_guard(hero: Dictionary, amount: float, events: Array) -> bool:
	if hero["guard_cfg"].is_empty() or float(hero["guard"]) + EPS < amount:
		return false
	hero["guard"] = float(hero["guard"]) - amount
	events.append({"type": "guard_spent", "time": time, "hero": hero["id"], "amount": amount, "total": hero["guard"]})
	return true

## Entre encontros a Guarda decai: fica com `carry_fraction` do valor.
func _apply_guard_carry() -> void:
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["guard_cfg"].is_empty():
			h["guard"] = float(h["guard"]) * float(h["guard_cfg"]["carry_fraction"])

func _grant_shield(caster: Dictionary, ally: Dictionary, fraction: float, duration: float, source: String, events: Array, fx: Dictionary = {}) -> void:
	var amount: float = float(ally["stats"]["max_hp"]) * fraction
	var effect := {"source": source, "caster": caster["id"], "stat": "shield", "value": amount, "started_at": time, "expires_at": time + duration}
	if fx.has("expire_heal"):
		effect["expire_heal"] = float(fx["expire_heal"])
		effect["expire_heal_cap"] = float(fx["expire_heal_cap"])
	ally["effects"].append(effect)
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
	if float(hero["crit_boost_ready"]) > 0.0:
		bonus += float(hero["crit_boost_ready"])
		hero["crit_boost_ready"] = 0.0
	if float(enemy.get("prism_boost", 0.0)) > 0.0 and enemy.get("prism_owner", "") != hero["id"]:
		bonus += float(enemy["prism_boost"])
		enemy["prism_boost"] = 0.0
	# Pressão Coordenada: um aliado acertou a presa marcada; o próximo golpe do dono da Marca é reforçado (não acumula).
	if hero["pressure_ready"] and _marked(enemy) and enemy.get("mark_owner", "") == hero["id"]:
		hero["pressure_ready"] = false
		bonus += float(hero["passives"]["mark_ally_hit_boost"]["value"])
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
	var last := bool(fx.get("_last", false))
	var raw := _stat(hero, "attack") * coefficient * (_damage_bonus(hero, enemy, fx) + (float(fx.get("last_hit_bonus", 0.0)) if last else 0.0)) * _skill_passive_multiplier(hero, skill_id)
	# Rajada R3: o último disparo contra a presa marcada rola crítico com +5 p.p.
	if last and _crits and fx.has("last_crit_vs_marked") and _marked(enemy):
		var crit_chance := clampf(_stat(hero, "crit_chance") + float(fx["last_crit_vs_marked"]), 0.0, CombatMath.CRIT_CHANCE_CAP)
		if _rng.randf() < crit_chance:
			raw = CombatMath.apply_crit(raw, true, _stat(hero, "crit_damage"))
	if last and float(fx.get("last_extend_mark", 0.0)) > 0.0 and _marked(enemy):
		enemy["marked_until"] = float(enemy["marked_until"]) + float(fx["last_extend_mark"])
	var damage := CombatMath.hit_damage(raw, _enemy_defense(enemy), _armor_pen(hero), _enemy_damage_taken(enemy), _scale)
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
	for zone_id in _hero_order:
		var zone: Dictionary = _heroes[zone_id]["passives"].get("presence_zone", {})
		if not zone.is_empty() and _heroes[zone_id]["alive"]:
			amount *= 1.0 + float(zone["stagger_bonus"])
			break
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
		events.append({
			"type": "boss_phase", "time": time, "uid": enemy["uid"],
			"phase": int(enemy["phase_index"]) + 1, "name": String(phase.get("name", "")),
		})
		if phase.has("telegraph_every"):
			enemy["telegraph_every"] = int(phase["telegraph_every"])
		var fragment_count := int(phase.get("corruption_fragments", 0))
		if bool(phase.get("phase_gate", false)) and fragment_count > 0:
			var gate_hp := maxf(0.0, float(enemy["hp"]))
			enemy["targetable"] = false
			enemy["corruption_fragments_total"] = fragment_count
			enemy["corruption_fragments_remaining"] = fragment_count
			enemy["corruption_fragment_hp"] = gate_hp / float(fragment_count)
			events.append({"type": "corruption_fragments_started", "time": time, "uid": enemy["uid"], "count": fragment_count})
			_spawn_corruption_fragment(enemy, events)
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
	if not bool(enemy.get("targetable", true)):
		return false
	if _marked(enemy) and enemy.get("mark_owner", "") != hero["id"]:
		var owner: Dictionary = _heroes.get(enemy.get("mark_owner", ""), {})
		if not owner.is_empty():
			if owner["passives"].has("mark_ally_hit_boost"):
				owner["pressure_ready"] = true
			if owner["passives"].has("lock_on_marked_ally_hit") and owner["alive"]:
				owner["target_lock"] = enemy["uid"]
				owner["target_lock_until"] = INF
				owner["lock_once"] = true
			var share: Dictionary = owner["passives"].get("mark_share_extend", {})
			if not share.is_empty():
				var used := float(enemy.get("mark_shared", 0.0))
				var add := minf(float(share["per_hit"]), float(share["cap"]) - used)
				if add > 0.0:
					enemy["marked_until"] = float(enemy["marked_until"]) + add
					enemy["mark_shared"] = used + add
		if float(enemy.get("mark_extend", 0.0)) > 0.0:
			enemy["marked_until"] = float(enemy["marked_until"]) + float(enemy["mark_extend"])
			enemy["mark_extend"] = 0.0
	var effective := minf(damage, float(enemy["hp"]))
	enemy["hp"] = maxf(0.0, float(enemy["hp"]) - damage)
	var gained: float = effective * _threat_multiplier(hero)
	enemy["threat"][hero["id"]] = float(enemy["threat"].get(hero["id"], 0.0)) + gained
	_check_phases(enemy, events)
	if not bool(enemy.get("targetable", true)) or float(enemy["hp"]) > 0.0:
		return false
	if bool(enemy.get("objective", false)):
		enemy["alive"] = false
		events.append({
			"type": "corruption_fragment_destroyed", "time": time, "uid": enemy["uid"],
			"sequence": enemy["objective_sequence"], "total": enemy["objective_total"],
		})
		var parent: Dictionary = {}
		for candidate in _enemies:
			if candidate["uid"] == enemy["objective_parent_uid"]:
				parent = candidate
				break
		if not parent.is_empty():
			parent["corruption_fragments_remaining"] = int(parent["corruption_fragments_remaining"]) - 1
			if int(parent["corruption_fragments_remaining"]) > 0:
				_spawn_corruption_fragment(parent, events)
			else:
				events.append({"type": "boss_memory_restored", "time": time, "uid": parent["uid"]})
				parent["hp"] = 0.0
				_defeat_enemy(parent, events)
		return true
	_defeat_enemy(enemy, events)
	return true

func _defeat_enemy(enemy: Dictionary, events: Array) -> void:
	var was_marked := _marked(enemy)
	enemy["alive"] = false
	enemy["telegraph_until"] = -INF
	_on_enemy_killed(enemy, was_marked, events)
	var xp := int(_profiles.get("xp", {}).get("by_rank", {}).get(enemy["rank"], 0))
	events.append({"type": "enemy_defeated", "time": time, "uid": enemy["uid"], "id": enemy["id"], "xp": xp})
	if loot != null and _enemy_rows.has(enemy["id"]):
		_collect_drop(enemy, events)
	if _first_alive_enemy().is_empty():
		_finish_encounter(events)

## Olho Aguçado R4/R5: o primeiro crítico estende a janela (1 vez) e reforça o próximo disparo (1 vez).
func _on_crit(hero: Dictionary, enemy: Dictionary = {}) -> void:
	var eye := _effect_with(hero, "skill_fle_008", "first_crit_extend")
	if not eye.is_empty() and float(eye.get("extended", 0.0)) <= 0.0:
		eye["expires_at"] = float(eye["expires_at"]) + float(eye["first_crit_extend"])
		eye["extended"] = float(eye["first_crit_extend"])
	var boost := _effect_with(hero, "skill_fle_008", "crit_boost")
	if not boost.is_empty():
		hero["crit_boost_ready"] = float(boost["crit_boost"])
	var perfect: Dictionary = hero["passives"].get("perfect_shot", {})
	if not perfect.is_empty() and not enemy.is_empty() and _marked(enemy) and enemy.get("mark_owner", "") == hero["id"] \
			and not _effect_with(hero, "skill_fle_008", "value").is_empty():
		hero["crit_boost_ready"] = maxf(float(hero["crit_boost_ready"]), float(perfect["boost"]))

## Multiplicador de passivas sobre o golpe de uma skill (Prisma Ressonante e Convergência Arcana).
func _skill_passive_multiplier(hero: Dictionary, skill_id: String) -> float:
	var mult := 1.0
	var multi: Dictionary = hero["passives"].get("skill_bonus_multi", {})
	if not multi.is_empty() and multi["skill"] == skill_id and _alive_targets().size() >= int(multi["min_enemies"]):
		mult += float(multi["value"])
	var chain: Dictionary = hero["passives"].get("prism_then_lance", {})
	if not chain.is_empty() and chain["lance"] == skill_id and float(hero.get("lance_boost_until", -INF)) > time + EPS:
		mult += float(chain["value"])
		hero["lance_boost_until"] = -INF
	return mult

## Efeitos de abate: transferência da Marca (Marca R5) e redução de recarga do Desafio (Desafio R5).
func _on_enemy_killed(enemy: Dictionary, was_marked: bool, events: Array) -> void:
	if was_marked and bool(enemy.get("mark_transfer", false)):
		var next := _first_alive_enemy()
		if not next.is_empty():
			next["marked_until"] = float(enemy["marked_until"])
			next["mark_owner"] = enemy["mark_owner"]
			next["mark_bonus"] = enemy["mark_bonus"]
			next["mark_readable"] = enemy.get("mark_readable", false)
			next["mark_extend"] = 0.0
			next["mark_transfer"] = false
			enemy["mark_transfer"] = false
			events.append({"type": "enemy_marked", "time": time, "target": next["uid"], "readable": bool(next["mark_readable"]), "transferred": true})
	if _taunt_active() and float(_taunt.get("cd_on_kill", 0.0)) > 0.0:
		var caster: Dictionary = _heroes[_taunt["hero"]]
		for sk in caster["skills"]:
			if sk["def"]["id"] == _taunt["skill"] and float(sk["ready_at"]) > time + EPS:
				sk["ready_at"] = maxf(time, float(sk["ready_at"]) - float(_taunt["cd_on_kill"]))
				sk["ready_seen"] = false
		_taunt["cd_on_kill"] = 0.0

## Alvo do ataque básico: trava de mira (Ponto de Mira, Caçada Coordenada) ou o primeiro inimigo vivo.
func _attack_target(hero: Dictionary) -> Dictionary:
	if String(hero["target_lock"]) != "" and float(hero["target_lock_until"]) > time + EPS:
		for e in _enemies:
			if e["uid"] == hero["target_lock"] and e["alive"] and bool(e.get("targetable", true)):
				return e
	if hero["passives"].has("prefer_marked"):
		for e in _alive_targets():
			if _marked(e) and e.get("mark_owner", "") == hero["id"]:
				return e
	return _first_alive_enemy()

## Chance de crítico do ataque básico contra `enemy`: base, Instinto de Caçadora, Olho Aguçado R3, Leitura de Abertura e Ajuste Fino.
func _crit_chance(hero: Dictionary, enemy: Dictionary) -> float:
	var chance := _stat(hero, "crit_chance")
	if _marked(enemy):
		chance += float(hero["passives"].get("crit_vs_marked", {}).get("value", 0.0))
		var eye := _effect_with(hero, "skill_fle_008", "crit_vs_marked")
		if not eye.is_empty():
			chance += float(eye["crit_vs_marked"])
	var open: Dictionary = hero["passives"].get("skill_next_crit", {})
	if not open.is_empty() and hero["open_uid"] == enemy["uid"]:
		chance += float(open["crit"])
	var streak: Dictionary = hero["passives"].get("crit_streak", {})
	if not streak.is_empty() and not _effect_with(hero, "skill_fle_008", "value").is_empty():
		chance += float(streak["per_stack"]) * int(hero["crit_streak_n"])
	return chance

func _hero_attack(hero: Dictionary, events: Array) -> void:
	var enemy := _attack_target(hero)
	if enemy.is_empty():
		return
	if bool(hero["lock_once"]):
		hero["lock_once"] = false
		hero["target_lock"] = ""
	# Respiração Controlada: cada disparo seguido no mesmo alvo estabiliza o próximo; trocar de alvo zera.
	var aim: Dictionary = hero["passives"].get("steady_aim", {})
	var aim_bonus := 0.0
	if not aim.is_empty():
		if hero["aim_uid"] == enemy["uid"]:
			hero["aim_n"] = mini(int(aim["max_stacks"]), int(hero["aim_n"]) + 1)
			aim_bonus = float(aim["per_attack"]) * int(hero["aim_n"])
		else:
			hero["aim_uid"] = enemy["uid"]
			hero["aim_n"] = 0
	var is_crit := false
	if _crits:
		is_crit = _rng.randf() < clampf(_crit_chance(hero, enemy), 0.0, CombatMath.CRIT_CHANCE_CAP)
	if hero["open_uid"] == enemy["uid"]:
		hero["open_uid"] = ""
	if hero["passives"].has("crit_streak") and not _effect_with(hero, "skill_fle_008", "value").is_empty():
		hero["crit_streak_n"] = mini(int(hero["passives"]["crit_streak"]["max_stacks"]), int(hero["crit_streak_n"]) + 1) if is_crit else 0
	var focus: Dictionary = hero["passives"].get("focus_basic_bonus", {})
	var focus_bonus := float(focus["value"]) if not focus.is_empty() and hero["focus_uid"] == enemy["uid"] else 0.0
	var raw := CombatMath.apply_crit(_stat(hero, "attack") * (_damage_bonus(hero, enemy, {}) + focus_bonus + aim_bonus), is_crit, _stat(hero, "crit_damage"))
	var damage := CombatMath.hit_damage(raw, _enemy_defense(enemy), _armor_pen(hero), _enemy_damage_taken(enemy), _scale)
	if is_crit and hero["passives"].has("crit_armor_pen"):
		_add_stack(hero, "crit_armor_pen")
	if is_crit:
		_on_crit(hero, enemy)
	var speed := _stat(hero, "attack_speed")
	var rhythm: Dictionary = hero["passives"].get("rhythm_stack", {})
	if not rhythm.is_empty():
		if hero["rhythm_uid"] == enemy["uid"]:
			hero["rhythm_n"] = mini(int(rhythm["max_stacks"]), int(hero["rhythm_n"]) + 1)
		else:
			hero["rhythm_uid"] = enemy["uid"]
			hero["rhythm_n"] = 0
		speed *= 1.0 + float(rhythm["per_hit"]) * int(hero["rhythm_n"])
	hero["next_at"] = float(hero["next_at"]) + CombatMath.attack_interval(speed)
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
	var slow := _zone_slow(enemy)
	if float(enemy.get("slow_until", -INF)) > time + EPS:
		slow = maxf(slow, float(enemy["slow"]))
	speed *= 1.0 - slow
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
	if float(enemy.get("atk_debuff_until", -INF)) > time + EPS:
		raw *= 1.0 - float(enemy["atk_debuff"])
	var stance_hit := _stance_active(hero)
	var reduction := float(hero["stance"]["reduction"]) if stance_hit else 0.0
	var pb: Dictionary = hero["perfect_block"]
	var bastion := _bastion_active(hero)
	var blocked: bool = bastion or (not pb.is_empty() and float(hero["guard_ready_at"]) <= time + EPS)
	var damage := CombatMath.hit_damage(raw, _stat(hero, "defense"), 0.0, _damage_taken_multiplier(hero, reduction, not telegraph.is_empty()), _scale)
	# Escudo Compartilhado: parte do golpe vai para o protetor, com a defesa dele e sem matá-lo.
	var guardian := _protector(hero, "redirect")
	if not guardian.is_empty():
		var moved: float = damage * float(guardian["passives"]["redirect"]["fraction"])
		var taken: float = minf(moved * (1.0 - CombatMath.mitigation(_stat(guardian, "defense"), 0.0, _scale)) * _damage_taken_multiplier(guardian), float(guardian["hp"]) - _scale)
		if taken > 0.0:
			damage -= moved
			guardian["hp"] = float(guardian["hp"]) - taken
			events.append({"type": "damage_redirected", "time": time, "from": target_id, "to": guardian["id"], "damage": taken})
	# Último Bastião: parte do golpe em aliados vai para quem sustenta a Signature (não o mata).
	for keeper_id in _hero_order:
		var keeper: Dictionary = _heroes[keeper_id]
		if keeper_id != target_id and keeper["alive"] and _bastion_active(keeper):
			var share: float = damage * float(keeper["last_bastion"]["cfg"]["redirect_fraction"])
			var kept: float = minf(share * (1.0 - CombatMath.mitigation(_stat(keeper, "defense"), 0.0, _scale)) * _damage_taken_multiplier(keeper), float(keeper["hp"]) - _scale)
			if kept > 0.0:
				damage -= share
				keeper["hp"] = float(keeper["hp"]) - kept
				keeper["last_bastion"]["absorbed"] = float(keeper["last_bastion"]["absorbed"]) + share
				events.append({"type": "damage_redirected", "time": time, "from": target_id, "to": keeper["id"], "damage": kept})
			break
	# Voto do Escudo: proteger um aliado (aura ou redirecionamento) gera Juramento.
	for protector in [_protector(hero, "ally_aura_dr"), guardian]:
		if not protector.is_empty() and protector["passives"].has("oath"):
			_add_stack(protector, "oath")
			break
	if blocked:
		damage = maxf(CombatMath.MIN_DAMAGE * _scale, damage * float(pb["damage_multiplier"]))
		if not bastion:
			hero["guard_ready_at"] = time + float(pb["recharge"])
		_imbalance(enemy, events)
		events.append({"type": "perfect_block", "time": time, "hero": target_id, "source": enemy["uid"], "heavy": not telegraph.is_empty()})
	if not telegraph.is_empty() and (blocked or stance_hit) and bool(enemy.get("targetable", true)):
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
	if bastion:
		hero["last_bastion"]["absorbed"] = float(hero["last_bastion"]["absorbed"]) + remaining
		hero["hp"] = maxf(_scale, float(hero["hp"]))
	events.append({"type": "enemy_attack", "time": time, "source": enemy["uid"], "target": target_id, "damage": remaining, "heavy": not telegraph.is_empty()})
	var step_back: Dictionary = hero["passives"].get("step_back", {})
	if not step_back.is_empty() and float(hero["step_back_ready_at"]) <= time + EPS:
		hero["step_back_ready_at"] = time + float(step_back["cooldown"])
		hero["effects"].append({"source": "passive_fle_passo_de_arqueira", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(step_back["reduction"]),
			"started_at": time, "expires_at": time + float(step_back["duration"]), "defensive": true})
	if not hero["guard_cfg"].is_empty():
		var guard_cfg: Dictionary = hero["guard_cfg"]
		_gain_guard(hero, float(guard_cfg["on_hit_taken"]), events)
		if blocked:
			_gain_guard(hero, float(guard_cfg["on_perfect_block"]), events)
		elif stance_hit:
			_gain_guard(hero, float(guard_cfg["on_block"]), events)
	if stance_hit and not blocked and hero["passives"].has("block_charges_counter"):
		_add_stack(hero, "block_charges_counter")
	_elite_stagger(hero, enemy, blocked, events)
	for guard_id in _hero_order:
		var guard_hero: Dictionary = _heroes[guard_id]
		if guard_id != target_id and not guard_hero["guard_cfg"].is_empty():
			_gain_guard(guard_hero, float(guard_hero["guard_cfg"]["on_ally_hit"]), events)
	if blocked:
		_apply_stagger(enemy, float(pb.get("stagger", 0.0)), events)
		_on_perfect_block(hero, enemy, events)
	var potions := int(_potions.get("count", 0))
	if potions > 0 and float(hero["hp"]) > 0.0 and float(hero["hp"]) <= float(hero["stats"]["max_hp"]) * float(_potions["threshold"]):
		var healed: float = minf(float(hero["stats"]["max_hp"]) * float(_potions["heal_fraction"]), float(hero["stats"]["max_hp"]) - float(hero["hp"]))
		hero["hp"] = float(hero["hp"]) + healed
		_potions["count"] = potions - 1
		events.append({"type": "potion_used", "time": time, "target": target_id, "amount": healed, "left": potions - 1})
	if float(hero["hp"]) > 0.0:
		_check_ally_low(hero, events)
		_check_fountain(hero, events)
	if float(hero["hp"]) <= 0.0 and not _try_save_ally(hero, events):
		_fell_this_encounter = true
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
		mult += _counter_charge_bonus(hero)
		if float(enemy["imbalance_until"]) > time + EPS:
			mult += float(hero["passives"].get("counter_bonus_vs_imbalanced", {}).get("value", 0.0))
		var iron: Dictionary = hero["passives"].get("pb_charges_counter", {})
		if not iron.is_empty() and _stacks(hero, "pb_charges_counter") >= int(iron["max_charges"]):
			mult += float(iron["damage_bonus"])
			stagger *= 1.0 + float(iron["stagger_bonus"])
			hero["stacks"].erase("pb_charges_counter")
			events.append({"type": "iron_response", "time": time, "hero": hero["id"]})
		var raw_counter := float(hero["stance"]["coefficient"]) * _stat(hero, "attack") * mult * _damage_bonus(hero, enemy, {})
		var counter := CombatMath.hit_damage(raw_counter, _enemy_defense(enemy), 0.0, _enemy_damage_taken(enemy), _scale)
		events.append({"type": "counter_attack", "time": time, "source": hero["id"], "target": enemy["uid"], "damage": counter})
		_gain_guard(hero, float(hero["guard_cfg"].get("on_counter_hit", 0.0)), events)
		if not _damage_enemy(enemy, counter, hero, events):
			if bool(hero["stance"].get("imbalance", false)):
				_imbalance(enemy, events)
			_apply_stagger(enemy, stagger, events)
			if float(hero["stance"].get("stun", 0.0)) > 0.0:
				_stun(enemy, float(hero["stance"]["stun"]), events)
		# Julgamento de Ferro depois do dano do contra-ataque: dispará-lo antes podia matar o alvo e derrotá-lo duas vezes.
		if bool(hero["judgement_ready"]):
			_fire_judgement(hero, events)
		# A postura é consumida pelo contra-ataque; a ameaça acima ainda usou o ×1,5 da postura ativa.
		hero["stance"] = {}

func _no_hero_alive() -> bool:
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			return false
	return true

# --- SLICE-1B: ofertas, escolhas, loot e efeitos de evento ------------------------------------

## Nível do encontro atual ou, num nó de evento (sem nível), do último encontro já passado.
func _current_level() -> int:
	var i := mini(node_index, _nodes.size() - 1)
	while i >= 0:
		if _nodes[i].has("level"):
			return int(_nodes[i]["level"])
		i -= 1
	return _party_level

func _event_context() -> Dictionary:
	var alive: Array = []
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			alive.append(hid)
	return {"alive_heroes": alive, "party_level": _party_level, "equipped": _equipped_list,
		"previous_no_falls": not _fell_this_encounter, "flags": _flags}

func _queue_event(event: Dictionary) -> void:
	_offers.append({"kind": "event", "id": event["id"], "event": event, "options": director.choices_for(event, _event_context())})

func _queue_offers_after_encounter(events: Array) -> void:
	var node: Dictionary = _nodes[node_index]
	var kind := String(node.get("kind", "NORMAL"))
	if loot != null:
		if kind == "ELITE" or kind == "MINIBOSS":
			_offers.append({"kind": "reward", "id": "reward_%s" % node["id"], "options": loot.roll_choice(kind, _current_level())})
		elif kind == "BOSS":
			var boss := loot.roll_boss(_first_clear, _current_level())
			for inst in boss["items"]:
				_grant_item(inst, events)
			if not boss["choice"].is_empty():
				_offers.append({"kind": "reward", "id": "reward_%s" % node["id"], "options": boss["choice"]})
	if director != null and kind == "NORMAL" and node_index + 1 < _nodes.size():
		var next_node: Dictionary = _nodes[node_index + 1]
		if next_node["type"] == "encounter" and String(next_node.get("kind", "NORMAL")) == "NORMAL":
			var event := director.roll_transition(_event_context())
			if not event.is_empty():
				_queue_event(event)

func _option_labels(offer: Dictionary) -> Array:
	var labels: Array = []
	for option in offer["options"]:
		labels.append(String(option.get("label", option.get("id", ""))))
	return labels

## Abre a próxima oferta (pausa em `choice`) ou, sem ofertas, inicia a transição.
func _next_offer(events: Array) -> void:
	while not _offers.is_empty():
		var offer: Dictionary = _offers.pop_front()
		if offer["options"].is_empty():
			continue
		var is_event := String(offer["kind"]) == "event"
		if is_event and bool(offer["event"].get("auto", false)):
			events.append({"type": "event_offered", "time": time, "id": offer["id"], "auto": true})
			_resolve_event_choice(offer, offer["options"][0], events)
			continue
		pending = offer
		state = "choice"
		events.append({"type": "event_offered" if is_event else "reward_offered", "time": time, "id": offer["id"], "options": _option_labels(offer)})
		return
	pending = {}
	_begin_transition()

## Resolve a escolha pendente. Devolve os eventos gerados ([] se não há escolha ou o índice é inválido).
func choose(index: int) -> Array:
	var events: Array = []
	if state != "choice" or index < 0 or index >= pending["options"].size():
		return events
	var offer := pending
	var option: Dictionary = offer["options"][index]
	pending = {}
	if String(offer["kind"]) == "event":
		_resolve_event_choice(offer, option, events)
	else:
		events.append({"type": "reward_chosen", "time": time, "id": offer["id"], "item": option})
		_grant_item(option, events)
	_next_offer(events)
	if telemetry != null:
		telemetry.ingest(events)
	return events

func _resolve_event_choice(offer: Dictionary, choice: Dictionary, events: Array) -> void:
	director.mark_seen(String(offer["id"]))
	_flags["seen_%s" % offer["id"]] = true
	rewards["flags"]["seen_%s" % offer["id"]] = true
	var effects := director.resolve(choice)
	events.append({"type": "event_resolved", "time": time, "id": offer["id"], "choice": choice["id"], "effects": effects.size(), "outcome": director.last_outcome})
	for fx in effects:
		_apply_effect(fx, events)

func _grant_item(inst: Dictionary, events: Array) -> void:
	rewards["items"].append(inst)
	events.append({"type": "loot_dropped", "time": time, "item": inst})

func _grant_material(id: String, quantity: int, events: Array) -> void:
	rewards["materials"][id] = int(rewards["materials"].get(id, 0)) + quantity
	events.append({"type": "material_dropped", "time": time, "id": id, "quantity": quantity})

func _collect_drop(enemy: Dictionary, events: Array) -> void:
	var drop := loot.roll_enemy_drop(_enemy_rows[enemy["id"]], _current_level())
	for inst in drop["items"]:
		_grant_item(inst, events)
	for id in drop["materials"]:
		_grant_material(String(id), int(drop["materials"][id]), events)

func _scope_heroes(scope: String) -> Array:
	var out: Array = []
	for hid in _hero_order:
		if _heroes[hid]["alive"] and (scope == "all" or scope == hid):
			out.append(_heroes[hid])
	return out

func _apply_effect(fx: Dictionary, events: Array) -> void:
	match String(fx["type"]):
		"heal_fraction":
			for h in _scope_heroes(String(fx.get("scope", "all"))):
				var amount: float = minf(float(h["stats"]["max_hp"]) * float(fx["value"]), float(h["stats"]["max_hp"]) - float(h["hp"]))
				if amount > 0.0:
					h["hp"] = float(h["hp"]) + amount
					events.append({"type": "recovery", "time": time, "source": "event", "target": h["id"], "amount": amount})
		"damage_fraction":
			for h in _scope_heroes(String(fx.get("scope", "all"))):
				var lost: float = minf(float(h["stats"]["max_hp"]) * float(fx["value"]), float(h["hp"]) - _scale)
				if lost > 0.0:
					h["hp"] = float(h["hp"]) - lost
				events.append({"type": "event_damage", "time": time, "target": h["id"], "amount": maxf(lost, 0.0), "remaining": float(h["hp"])})
		"grant_material":
			_grant_material(String(fx["id"]), int(fx["quantity"]), events)
		"grant_item":
			if loot != null:
				var inst := loot.roll_event_item(String(fx["rarity"]), _current_level())
				if not inst.is_empty():
					_grant_item(inst, events)
		"grant_reward_choice":
			if loot != null:
				_offers.push_front({"kind": "reward", "id": "reward_event", "options": loot.roll_event_choice(_current_level(), String(fx["min_rarity"]))})
		"set_flag":
			_flags[fx["flag"]] = true
			rewards["flags"][fx["flag"]] = true
			events.append({"type": "flag_set", "time": time, "flag": fx["flag"]})
		"reveal_lore":
			rewards["lore"].append(fx["text_id"])
			events.append({"type": "lore_revealed", "time": time, "text_id": fx["text_id"]})
		"modify_next_encounter":
			var mod: Dictionary = fx.duplicate(true)
			mod["left"] = int(fx.get("encounters", 1))
			mod["mid"] = _mod_uid
			_mod_uid += 1
			_event_mods.append(mod)
			events.append({"type": "next_encounter_modified", "time": time, "mark": bool(fx.get("mark_first_enemy", false)), "stat": String(fx.get("stat", ""))})

## Aplica os modificadores pendentes ao encontro que começa: bônus de status da party (durante N encontros) e Marca no primeiro inimigo (uma vez).
func _apply_event_mods(_events: Array) -> void:
	for mod in _event_mods:
		if bool(mod.get("mark_first_enemy", false)):
			if not _enemies.is_empty() and int(mod["left"]) > 0:
				_enemies[0]["marked_until"] = time + 30.0
			mod["left"] = 0
			continue
		if int(mod["left"]) > 0 and not bool(mod.get("applied", false)):
			for hid in _hero_order:
				if _heroes[hid]["alive"]:
					_heroes[hid]["effects"].append({"source": "event", "mid": mod["mid"], "stat": mod["stat"], "op": mod["op"], "value": float(mod["value"]), "expires_at": INF, "defensive": false})
			mod["applied"] = true

## Ao fim do encontro, gasta um encontro de cada modificador aplicado e remove os bônus esgotados.
func _expire_event_mods() -> void:
	for mod in _event_mods:
		if bool(mod.get("applied", false)):
			mod["left"] = int(mod["left"]) - 1
	var spent: Array = []
	for mod in _event_mods:
		if int(mod["left"]) <= 0:
			spent.append(mod["mid"])
	for hid in _hero_order:
		_heroes[hid]["effects"] = _heroes[hid]["effects"].filter(func(e): return not spent.has(e.get("mid", -1)))
	_event_mods = _event_mods.filter(func(mod): return int(mod["left"]) > 0)
