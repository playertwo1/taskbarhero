extends RefCounted
class_name EventTexts

## Textos dos eventos do slice (SLICE-1B). Fonte: data/expedition/event_texts_c1.json.
## Só consulta e validação; nada de regra de jogo aqui.

const TEXTS_PATH := "res://data/expedition/event_texts_c1.json"
const MAX_SENTENCES := {"intro": 4, "lore": 4, "choice": 2, "outcome": 2}

var _texts: Dictionary = {}

static func load_texts() -> Dictionary:
	var file := FileAccess.open(TEXTS_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

static func create(texts: Dictionary) -> EventTexts:
	var t := EventTexts.new()
	t._texts = texts
	return t

func intro(event_id: String) -> String:
	return String(_texts.get("events", {}).get(event_id, {}).get("intro", ""))

func choice_text(event_id: String, choice_id: String) -> String:
	return String(_texts.get("events", {}).get(event_id, {}).get("choices", {}).get(choice_id, ""))

func outcome_text(event_id: String, outcome_id: String) -> String:
	return String(_texts.get("events", {}).get(event_id, {}).get("outcomes", {}).get(outcome_id, ""))

func lore(text_id: String) -> String:
	return String(_texts.get("lore", {}).get(text_id, ""))

static func _sentences(text: String) -> int:
	var n := 0
	for c in text:
		if c == "." or c == "!" or c == "?":
			n += 1
	return n

static func _check(errors: Array, label: String, text: String, kind: String) -> void:
	if text.strip_edges() == "":
		errors.append("%s: texto vazio" % label)
	elif _sentences(text) > int(MAX_SENTENCES[kind]):
		errors.append("%s: mais de %d frases" % [label, MAX_SENTENCES[kind]])

## Lista de erros; vazia quando os textos cobrem o catálogo e respeitam os limites.
static func validate(texts: Dictionary, catalog: Dictionary, hero_ids: Array = ["hero_001", "hero_002", "hero_003"]) -> Array:
	var errors: Array = []
	var events: Dictionary = texts.get("events", {})
	var lore_texts: Dictionary = texts.get("lore", {})
	for event in catalog.get("events", []):
		var id := String(event["id"])
		if not events.has(id):
			errors.append("%s: sem textos" % id)
			continue
		_check(errors, "%s.intro" % id, String(events[id].get("intro", "")), "intro")
		for choice in event["choices"]:
			var choice_ids: Array = []
			if bool(choice.get("per_hero", false)):
				for hero_id in hero_ids:
					choice_ids.append("%s_%s" % [choice["id"], hero_id])
			else:
				choice_ids.append(String(choice["id"]))
			for cid in choice_ids:
				_check(errors, "%s.choices.%s" % [id, cid], String(events[id].get("choices", {}).get(cid, "")), "choice")
			for outcome in choice.get("outcomes", []):
				_check(errors, "%s.outcomes.%s" % [id, outcome["id"]], String(events[id].get("outcomes", {}).get(outcome["id"], "")), "outcome")
			var groups: Array = []
			if choice.has("outcomes"):
				for outcome in choice["outcomes"]:
					groups.append(outcome.get("effects", []))
			else:
				groups.append(choice.get("effects", []))
			for effects in groups:
				for fx in effects:
					if String(fx["type"]) != "reveal_lore":
						continue
					var text_ids: Array = []
					if String(fx["text_id"]).contains("{hero}"):
						for hero_id in hero_ids:
							text_ids.append(String(fx["text_id"]).replace("{hero}", hero_id))
					else:
						text_ids.append(String(fx["text_id"]))
					for tid in text_ids:
						if not lore_texts.has(tid):
							errors.append("%s: lore ausente %s" % [id, tid])
	for tid in lore_texts:
		_check(errors, "lore.%s" % tid, String(lore_texts[tid]), "lore")
	return errors
