extends RefCounted
class_name SliceLogText

## Converte eventos do ExpeditionRun em linhas de log em português (SLICE-1B Plano B).
## Só apresentação: não lê nem altera o estado do jogo.

const RESIDUE_NAME := "Resíduo de Lúmen"

static func item_label(inst: Dictionary, rows: Dictionary) -> String:
	var row: Dictionary = rows.get(inst["id"], {})
	return "%s (%s, IP %d)" % [row.get("name", inst["id"]), inst["rarity"], int(inst["item_power"])]

static func _hero(id: String, ctx: Dictionary) -> String:
	return String(ctx.get("hero_names", {}).get(id, id))

static func line(ev: Dictionary, ctx: Dictionary) -> String:
	var texts: EventTexts = ctx["texts"]
	match String(ev["type"]):
		"encounter_started":
			return "Encontro: %s" % ctx.get("node_names", {}).get(ev["node_id"], ev["node_id"])
		"encounter_cleared":
			return "Vitória em %.1f s." % float(ev["duration"])
		"hero_defeated":
			return "%s caiu." % _hero(String(ev["id"]), ctx)
		"loot_dropped":
			return "Item: %s" % item_label(ev["item"], ctx["item_rows"])
		"material_dropped":
			var name := RESIDUE_NAME if ev["id"] == "MAT_C1_LUMEN_RESIDUE" else String(ev["id"])
			return "%d× %s" % [int(ev["quantity"]), name]
		"event_offered":
			return texts.intro(String(ev["id"]))
		"event_resolved":
			var parts: Array = [texts.choice_text(String(ev["id"]), String(ev["choice"]))]
			if String(ev.get("outcome", "")) != "":
				parts.append(texts.outcome_text(String(ev["id"]), String(ev["outcome"])))
			return " ".join(parts.filter(func(p): return p != ""))
		"reward_offered":
			return "O Bosque oferece uma recompensa. Escolha uma."
		"reward_chosen":
			return "Escolhido: %s" % item_label(ev["item"], ctx["item_rows"])
		"lore_revealed":
			return texts.lore(String(ev["text_id"]))
		"event_damage":
			return "%s perdeu %.0f HP." % [_hero(String(ev["target"]), ctx), float(ev["amount"])] if float(ev["amount"]) > 0.0 else ""
		"recovery":
			return "%s recuperou %.0f HP." % [_hero(String(ev["target"]), ctx), float(ev["amount"])] if String(ev.get("source", "")) == "event" else ""
		"expedition_won":
			return "A expedição terminou em vitória."
		"expedition_lost":
			return "A party caiu em %s." % ctx.get("node_names", {}).get(ev["node_id"], ev["node_id"])
	return ""
