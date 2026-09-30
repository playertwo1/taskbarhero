extends RefCounted
class_name SliceTelemetry

## Telemetria mínima do slice (SLICE-1A-5): agrega o fluxo de eventos do ExpeditionRun.
## Contrato: docs/06_balance/v1/10_TELEMETRIA_ARGOS.md §2. Local-first, desligável (o run só
## cria um SliceTelemetry se receber options["telemetry"] = true) e nenhum cálculo do combate lê
## este objeto. Danos são os valores dos eventos (sem descontar overkill).
## Não cobertas (o run não emite o dado): cooldown_uptime, debuff_uptime, stagger_damage (postura),
## tempo com Guarda pronta, dano evitado, shield_expired e economia (sem loot/recursos ainda).

var context: Dictionary = {}
var totals: Dictionary = {}
var by_hero: Dictionary = {}
var by_skill: Dictionary = {}
var damage_by_source: Dictionary = {}
var damage_taken_by_source: Dictionary = {}
var stagger: Dictionary = {"breaks": 0, "damage_during_break": 0.0, "time_to_break": []}
var debuffs: Dictionary = {}
var encounters: Array = []
## Camada da run (SLICE-1B): eventos, ofertas, loot e reciclagem.
var run_layer: Dictionary = {"events_offered": {}, "events_resolved": {}, "rewards_offered": 0, "rewards_chosen": {}, "loot_by_rarity": {}, "materials": {}, "recycled": {}, "residue_from_recycling": 0}

var _current: Dictionary = {}
var _first_hit_at: Dictionary = {}
var _broken_until: Dictionary = {}

func _init(ctx: Dictionary = {}) -> void:
	context = ctx.duplicate(true)
	totals = {
		"damage_dealt_total": 0.0, "critical_damage": 0.0, "damage_taken_total": 0.0, "largest_hit_received": 0.0,
		"healing_done": 0.0, "effective_healing": 0.0, "shield_generated": 0.0, "shield_consumed": 0.0,
		"perfect_blocks": 0, "hero_defeats": 0, "enemies_defeated": 0, "xp_gained": 0,
	}

func _bump(dict: Dictionary, key: String, amount: int = 1) -> void:
	dict[key] = int(dict.get(key, 0)) + amount

## Reciclagem acontece fora do run (tela/campanha), então tem entrada própria.
func record_recycle(rarity: String, residue: int) -> void:
	_bump(run_layer["recycled"], rarity)
	run_layer["residue_from_recycling"] += residue

func ingest(events: Array) -> void:
	for ev in events:
		_apply(ev)

static func enemy_id(uid: String) -> String:
	return uid.split("#")[0]

func _add(dict: Dictionary, key: String, amount: float) -> void:
	dict[key] = float(dict.get(key, 0.0)) + amount

func _hero(hero_id: String) -> Dictionary:
	if not by_hero.has(hero_id):
		by_hero[hero_id] = {"damage_dealt": 0.0, "damage_taken": 0.0, "healing": 0.0, "casts": 0, "deaths": 0}
	return by_hero[hero_id]

func _skill(skill_id: String) -> Dictionary:
	if not by_skill.has(skill_id):
		by_skill[skill_id] = {"casts": 0, "hits": 0, "damage": 0.0}
	return by_skill[skill_id]

## Dano causado a um inimigo: totais, por herói, por fonte e janela de quebra do alvo.
func _dealt(ev: Dictionary, source: String, damage: float, label: String, is_crit: bool = false) -> void:
	totals["damage_dealt_total"] += damage
	if is_crit:
		totals["critical_damage"] += damage
	_hero(source)["damage_dealt"] += damage
	_add(damage_by_source, label, damage)
	var uid := String(ev["target"])
	if not _first_hit_at.has(uid):
		_first_hit_at[uid] = float(ev["time"])
	if float(_broken_until.get(uid, -INF)) > float(ev["time"]):
		stagger["damage_during_break"] += damage
	if not _current.is_empty():
		_current["damage_dealt"] += damage

func _apply(ev: Dictionary) -> void:
	match String(ev["type"]):
		"encounter_started":
			_current = {"node_id": ev["node_id"], "started_at": float(ev["time"]), "damage_dealt": 0.0, "damage_taken": 0.0,
				"healing": 0.0, "shielding": 0.0, "deaths": 0, "victory": false, "duration": 0.0, "ttk": 0.0}
			_current.merge(context.get("encounter_context", {}))
		"encounter_cleared":
			if not _current.is_empty():
				_current["victory"] = true
				_current["duration"] = float(ev["duration"])
				_current["ttk"] = float(ev["duration"])
				encounters.append(_current)
				_current = {}
		"expedition_lost":
			if not _current.is_empty():
				_current["duration"] = float(ev["time"]) - float(_current["started_at"])
				encounters.append(_current)
				_current = {}
		"hero_attack":
			_dealt(ev, String(ev["source"]), float(ev["damage"]), "%s:basic" % ev["source"], bool(ev["crit"]))
		"skill_damage":
			_dealt(ev, String(ev["source"]), float(ev["damage"]), "%s:%s" % [ev["source"], ev["skill"]])
			var sk := _skill(String(ev["skill"]))
			sk["hits"] += 1
			sk["damage"] += float(ev["damage"])
		"counter_attack", "passive_damage":
			_dealt(ev, String(ev["source"]), float(ev["damage"]), "%s:%s" % [ev["source"], ev["type"]])
		"skill_cast":
			_skill(String(ev["skill"]))["casts"] += 1
			_hero(String(ev["hero"]))["casts"] += 1
		"enemy_attack":
			var dmg := float(ev["damage"])
			totals["damage_taken_total"] += dmg
			totals["largest_hit_received"] = maxf(float(totals["largest_hit_received"]), dmg)
			_hero(String(ev["target"]))["damage_taken"] += dmg
			_add(damage_taken_by_source, enemy_id(String(ev["source"])), dmg)
			if not _current.is_empty():
				_current["damage_taken"] += dmg
		"damage_redirected":
			var moved := float(ev["damage"])
			totals["damage_taken_total"] += moved
			_hero(String(ev["to"]))["damage_taken"] += moved
			if not _current.is_empty():
				_current["damage_taken"] += moved
		"healing":
			totals["healing_done"] += float(ev["amount"])
			totals["effective_healing"] += float(ev["amount"])
			_hero(String(ev["source"]))["healing"] += float(ev["amount"])
			if not _current.is_empty():
				_current["healing"] += float(ev["amount"])
		"recovery", "potion_used":
			totals["healing_done"] += float(ev["amount"])
			totals["effective_healing"] += float(ev["amount"])
		"shield_granted":
			totals["shield_generated"] += float(ev["amount"])
			if not _current.is_empty():
				_current["shielding"] += float(ev["amount"])
		"shield_absorbed":
			totals["shield_consumed"] += float(ev["amount"])
		"perfect_block":
			totals["perfect_blocks"] += 1
		"enemy_marked", "enemy_imbalanced", "enemy_stunned", "enemy_exposed":
			debuffs[ev["type"]] = int(debuffs.get(ev["type"], 0)) + 1
		"enemy_staggered":
			stagger["breaks"] += 1
			_broken_until[ev["uid"]] = float(ev["until"])
			if _first_hit_at.has(ev["uid"]):
				stagger["time_to_break"].append(float(ev["time"]) - float(_first_hit_at[ev["uid"]]))
		"event_offered":
			_bump(run_layer["events_offered"], String(ev["id"]))
		"event_resolved":
			_bump(run_layer["events_resolved"], "%s:%s" % [ev["id"], ev["choice"]])
		"reward_offered":
			run_layer["rewards_offered"] += 1
		"reward_chosen":
			_bump(run_layer["rewards_chosen"], String(ev["item"]["rarity"]))
		"loot_dropped":
			_bump(run_layer["loot_by_rarity"], String(ev["item"]["rarity"]))
		"material_dropped":
			_bump(run_layer["materials"], String(ev["id"]), int(ev["quantity"]))
		"enemy_defeated":
			totals["enemies_defeated"] += 1
			totals["xp_gained"] += int(ev.get("xp", 0))
		"hero_defeated":
			totals["hero_defeats"] += 1
			_hero(String(ev["id"]))["deaths"] += 1
			if not _current.is_empty():
				_current["deaths"] += 1

## Resumo serializável (JSON) das métricas agregadas.
func summary() -> Dictionary:
	return {
		"context": context.duplicate(true), "totals": totals.duplicate(true), "by_hero": by_hero.duplicate(true),
		"by_skill": by_skill.duplicate(true), "damage_by_source": damage_by_source.duplicate(true),
		"damage_taken_by_source": damage_taken_by_source.duplicate(true), "stagger": stagger.duplicate(true),
		"debuff_applications": debuffs.duplicate(true), "encounters": encounters.duplicate(true),
		"run_layer": run_layer.duplicate(true),
	}
