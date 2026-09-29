extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE LOG TEXT (SLICE-1B Plano B) ---")
	var rows := {}
	for r in SliceStats.load_rows("res://data/items/items.json", "slice"):
		rows[r["id"]] = r
	var ctx := {
		"node_names": {"c1_1_1_a": "Primeira luz"},
		"hero_names": {"hero_001": "Bastião"},
		"item_rows": rows,
		"texts": EventTexts.create(EventTexts.load_texts()),
	}
	var inst := LootRoller.make_instance("item_w_001", "Raro", 17, 3)
	_expect("rótulo de item", SliceLogText.item_label(inst, rows).contains("Raro") and SliceLogText.item_label(inst, rows).contains("IP 17"))
	_expect("encontro iniciado usa o nome", SliceLogText.line({"type": "encounter_started", "node_id": "c1_1_1_a"}, ctx).contains("Primeira luz"))
	_expect("vitória mostra a duração", SliceLogText.line({"type": "encounter_cleared", "duration": 12.34}, ctx).contains("12.3"))
	_expect("herói caído usa o nome", SliceLogText.line({"type": "hero_defeated", "id": "hero_001"}, ctx).contains("Bastião"))
	_expect("loot vira linha de item", SliceLogText.line({"type": "loot_dropped", "item": inst}, ctx).contains("Item"))
	_expect("Resíduo mostra a quantidade", SliceLogText.line({"type": "material_dropped", "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 2}, ctx).contains("2"))
	_expect("evento oferecido mostra a intro do texto", SliceLogText.line({"type": "event_offered", "id": "event_c1_001"}, ctx) == ctx["texts"].intro("event_c1_001"))
	var resolved := SliceLogText.line({"type": "event_resolved", "id": "event_c1_raiz_oca", "choice": "open", "outcome": "cache"}, ctx)
	_expect("evento resolvido junta escolha e resultado", resolved.contains(ctx["texts"].choice_text("event_c1_raiz_oca", "open")) and resolved.contains(ctx["texts"].outcome_text("event_c1_raiz_oca", "cache")))
	_expect("lore revelada mostra o texto", SliceLogText.line({"type": "lore_revealed", "text_id": "LORE_EVT_OBSERVADOR"}, ctx) == ctx["texts"].lore("LORE_EVT_OBSERVADOR"))
	_expect("dano de evento mostra o herói", SliceLogText.line({"type": "event_damage", "target": "hero_001", "amount": 20.0}, ctx).contains("Bastião"))
	_expect("dano zero não gera linha", SliceLogText.line({"type": "event_damage", "target": "hero_001", "amount": 0.0}, ctx) == "")
	_expect("evento sem linha devolve vazio", SliceLogText.line({"type": "skill_cast"}, ctx) == "")
	_expect("vitória e derrota da expedição", SliceLogText.line({"type": "expedition_won"}, ctx) != "" and SliceLogText.line({"type": "expedition_lost", "node_id": "c1_1_1_a"}, ctx).contains("Primeira luz"))

	print("=======================================================")
	print("[%s] TESTE SLICE LOG TEXT" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
