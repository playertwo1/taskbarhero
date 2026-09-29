extends RefCounted
class_name SliceLogText

## Converte eventos do ExpeditionRun em linhas de log em português (SLICE-1B Plano B).
## Só apresentação: não lê nem altera o estado do jogo.

const RESIDUE_NAME := "Resíduo de Lúmen"
const FALLBACK_ENEMY_NAMES := {
	"boss_c1_001": "Guardião-Cervo de Pedra",
	"mb_c1_001": "Rainha das Geleias",
	"en_c1_001": "Geleia de Lúmen",
	"corruption_fragment": "Fragmento de corrupção",
}
const ATTACK_NAMES := {
	"golpe_de_casco": "golpe de casco",
	"onda_real": "onda real",
}

static func item_label(inst: Dictionary, rows: Dictionary) -> String:
	var row: Dictionary = rows.get(inst["id"], {})
	return "%s (%s, IP %d)" % [row.get("name", inst["id"]), inst["rarity"], int(inst["item_power"])]

static func _hero(id: String, ctx: Dictionary) -> String:
	return String(ctx.get("hero_names", {}).get(id, id))

static func _enemy_name(id_or_uid: String, ctx: Dictionary) -> String:
	var enemy_id := id_or_uid.get_slice("#", 0)
	var names: Dictionary = ctx.get("enemy_names", {})
	return String(names.get(enemy_id, FALLBACK_ENEMY_NAMES.get(enemy_id, enemy_id)))

static func line(ev: Dictionary, ctx: Dictionary) -> String:
	var texts: EventTexts = ctx["texts"]
	match String(ev["type"]):
		"encounter_started":
			return "Encontro: %s" % ctx.get("node_names", {}).get(ev["node_id"], ev["node_id"])
		"encounter_cleared":
			return "Vitória em %.1f s." % float(ev["duration"])
		"hero_defeated":
			return "%s caiu." % _hero(String(ev["id"]), ctx)
		"telegraph_started":
			var skill := String(ev.get("skill", ""))
			var attack_name := String(ATTACK_NAMES.get(skill, skill.replace("_", " ")))
			var windup: float = maxf(0.0, float(ev.get("hits_at", 0.0)) - float(ev.get("time", 0.0)))
			return "%s prepara %s: impacto em %.1f s." % [_enemy_name(String(ev.get("uid", "")), ctx), attack_name, windup]
		"boss_phase":
			var phase := int(ev.get("phase", 0))
			var phase_name := String(ev.get("name", ""))
			if phase_name.is_empty():
				phase_name = "fase %d" % phase
			return "%s muda de fase: %s." % [_enemy_name(String(ev.get("uid", "")), ctx), phase_name]
		"corruption_fragments_started":
			return "%s entra na fase A Memória: %d fragmentos devem ser destruídos em sequência enquanto ele continua atacando." % [
				_enemy_name(String(ev.get("uid", "")), ctx), int(ev.get("count", 0))]
		"corruption_fragment_spawned":
			return "Fragmento de corrupção %d/%d exposto." % [int(ev.get("sequence", 0)), int(ev.get("total", 0))]
		"corruption_fragment_destroyed":
			return "Fragmento de corrupção %d/%d destruído." % [int(ev.get("sequence", 0)), int(ev.get("total", 0))]
		"boss_memory_restored":
			return "O Guardião-Cervo se recorda e baixa as galhadas."
		"enemy_spawned":
			return "%s surgiu como reforço." % _enemy_name(String(ev.get("id", "")), ctx)
		"enemy_exposed":
			var duration: float = maxf(0.0, float(ev.get("until", 0.0)) - float(ev.get("time", 0.0)))
			return "%s ficou exposto por %.1f s." % [_enemy_name(String(ev.get("uid", "")), ctx), duration]
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
