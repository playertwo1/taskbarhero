extends RefCounted
class_name EventDirector

## Eventos de expedição do slice (SLICE-1B): validação do catálogo, elegibilidade, sorteio nas
## transições e resolução de escolhas. Puro. RNG derivado da seed e separado do combate.
## Um evento nunca executa código próprio: só efeitos do vocabulário fechado.

const CATALOG_PATH := "res://data/expedition/events_c1.json"
const CONDITIONS := ["party_has", "hero_level_at_least", "item_equipped", "previous_encounter_no_falls", "flag"]
const EFFECTS := ["heal_fraction", "damage_fraction", "grant_material", "grant_reward_choice", "grant_item", "set_flag", "reveal_lore", "modify_next_encounter"]
const KINDS := ["fixed", "random", "personal", "secret"]

var _catalog: Dictionary = {}
var _by_id: Dictionary = {}
var _rng := RandomNumberGenerator.new()
var _seen_run: Array = []
var _random_count: int = 0
## Id do resultado sorteado na última resolve() ("" quando a escolha não tem `outcomes`).
var last_outcome: String = ""

static func load_catalog() -> Dictionary:
	var file := FileAccess.open(CATALOG_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

## Lista de erros; vazia quando o catálogo é válido.
static func validate(catalog: Dictionary) -> Array:
	var errors: Array = []
	if not catalog.has("random_rules") or not catalog.has("events"):
		return ["catálogo sem random_rules ou events"]
	var ids := {}
	for event in catalog["events"]:
		var id := String(event.get("id", ""))
		if id == "" or ids.has(id):
			errors.append("id vazio ou duplicado: %s" % id)
		ids[id] = true
		if not KINDS.has(String(event.get("kind", ""))):
			errors.append("%s: tipo desconhecido" % id)
		for cond in event.get("conditions", []):
			if not CONDITIONS.has(String(cond.get("type", ""))):
				errors.append("%s: condição desconhecida %s" % [id, cond.get("type", "")])
		if event.get("choices", []).is_empty():
			errors.append("%s: sem escolhas" % id)
		for choice in event.get("choices", []):
			var groups: Array = []
			if choice.has("outcomes"):
				for outcome in choice["outcomes"]:
					groups.append(outcome.get("effects", []))
			else:
				groups.append(choice.get("effects", []))
			for effects in groups:
				for fx in effects:
					if not EFFECTS.has(String(fx.get("type", ""))):
						errors.append("%s: efeito desconhecido %s" % [id, fx.get("type", "")])
	return errors

static func create(catalog: Dictionary, seed_value: int) -> EventDirector:
	var director := EventDirector.new()
	director._catalog = catalog
	for event in catalog.get("events", []):
		director._by_id[event["id"]] = event
	director._rng.seed = LootRoller.derive_seed(seed_value, "events")
	return director

func event_by_id(id: String) -> Dictionary:
	return _by_id.get(id, {})

## O run chama ao resolver o evento: entra na lista de vistos da run e conta no limite de aleatórios.
func mark_seen(event_id: String) -> void:
	if not _seen_run.has(event_id):
		_seen_run.append(event_id)
		if String(event_by_id(event_id).get("kind", "")) in ["random", "personal"]:
			_random_count += 1

func _condition_ok(cond: Dictionary, ctx: Dictionary) -> bool:
	match String(cond["type"]):
		"party_has":
			return ctx["alive_heroes"].has(cond["hero"])
		"hero_level_at_least":
			return int(ctx["party_level"]) >= int(cond["value"])
		"item_equipped":
			for inst in ctx["equipped"]:
				if inst["id"] == cond.get("item", inst["id"]) and inst["rarity"] == cond.get("rarity", inst["rarity"]):
					return true
			return false
		"previous_encounter_no_falls":
			return bool(ctx["previous_no_falls"])
		"flag":
			return bool(ctx["flags"].get(cond["name"], false))
	return false

func is_eligible(event: Dictionary, ctx: Dictionary) -> bool:
	if _seen_run.has(event["id"]):
		return false
	if bool(event.get("once_per_save", false)) and bool(ctx["flags"].get("seen_%s" % event["id"], false)):
		return false
	for cond in event.get("conditions", []):
		if not _condition_ok(cond, ctx):
			return false
	return true

## Sorteia no máximo um evento para uma transição entre encontros comuns.
## Ordem: secreto (chance baixa), depois aleatório/pessoal (chance e peso). Limite por run em random_rules.
func roll_transition(ctx: Dictionary) -> Dictionary:
	var rules: Dictionary = _catalog["random_rules"]
	var secrets: Array = []
	var pool: Array = []
	for event in _catalog["events"]:
		if not is_eligible(event, ctx):
			continue
		match String(event["kind"]):
			"secret":
				secrets.append(event)
			"random", "personal":
				pool.append(event)
	if not secrets.is_empty() and _rng.randf() < float(rules["secret_chance"]):
		return secrets[0]
	if pool.is_empty() or _random_count >= int(rules["max_random_per_run"]):
		return {}
	if _rng.randf() >= float(rules["transition_chance"]):
		return {}
	var total := 0.0
	for event in pool:
		total += float(event["weight"])
	var roll := _rng.randf() * total
	var acc := 0.0
	for event in pool:
		acc += float(event["weight"])
		if roll < acc:
			return event
	return pool[pool.size() - 1]

func _substitute(value, hero_id: String):
	if value is String:
		return value.replace("{hero}", hero_id)
	if value is Array:
		return value.map(func(v): return _substitute(v, hero_id))
	if value is Dictionary:
		var out := {}
		for k in value:
			out[k] = _substitute(value[k], hero_id)
		return out
	return value

## Escolhas concretas: uma escolha `per_hero` vira uma por herói vivo, com o escopo "pick" trocado pelo herói.
func choices_for(event: Dictionary, ctx: Dictionary) -> Array:
	var out: Array = []
	for choice in event["choices"]:
		if not bool(choice.get("per_hero", false)):
			out.append(choice.duplicate(true))
			continue
		for hero_id in ctx["alive_heroes"]:
			var expanded: Dictionary = _substitute(choice, hero_id)
			expanded["id"] = "%s_%s" % [choice["id"], hero_id]
			expanded.erase("per_hero")
			for fx in expanded["effects"]:
				if fx.get("scope", "") == "pick":
					fx["scope"] = hero_id
			out.append(expanded)
	return out

## Efeitos concretos de uma escolha: escolhas com `outcomes` sorteiam um resultado por peso.
func resolve(choice: Dictionary) -> Array:
	last_outcome = ""
	if not choice.has("outcomes"):
		return choice.get("effects", []).duplicate(true)
	var total := 0.0
	for outcome in choice["outcomes"]:
		total += float(outcome["weight"])
	var roll := _rng.randf() * total
	var acc := 0.0
	var picked: Dictionary = choice["outcomes"][choice["outcomes"].size() - 1]
	for outcome in choice["outcomes"]:
		acc += float(outcome["weight"])
		if roll < acc:
			picked = outcome
			break
	last_outcome = String(picked.get("id", ""))
	return picked.get("effects", []).duplicate(true)
