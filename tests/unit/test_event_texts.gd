extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE EVENT TEXTS (SLICE-1B Plano B) ---")
	var texts := EventTexts.load_texts()
	var catalog := EventDirector.load_catalog()
	var errors := EventTexts.validate(texts, catalog)
	for e in errors:
		print("  erro: %s" % e)
	_expect("textos cobrem todo o catálogo e respeitam os limites", errors.is_empty())

	var t := EventTexts.create(texts)
	_expect("intro do Poço existe", t.intro("event_c1_001") != "")
	_expect("resultado da escolha existe", t.choice_text("event_c1_001", "heal") != "")
	_expect("resultado do Memorial por herói existe", t.choice_text("event_c1_memorial", "honor_hero_002") != "")
	_expect("resultado da Raiz Oca existe", t.outcome_text("event_c1_raiz_oca", "cache") != "")
	_expect("lore do Observador existe", t.lore("LORE_EVT_OBSERVADOR") != "")
	_expect("consulta ausente devolve vazio", t.intro("nao_existe") == "" and t.lore("X") == "")

	var broken := texts.duplicate(true)
	broken["events"].erase("event_c1_raiz_oca")
	_expect("validação acusa evento sem texto", not EventTexts.validate(broken, catalog).is_empty())
	var long := texts.duplicate(true)
	long["events"]["event_c1_001"]["choices"]["heal"] = "Uma. Duas. Três."
	_expect("validação acusa resultado com frases demais", not EventTexts.validate(long, catalog).is_empty())
	var missing_lore := texts.duplicate(true)
	missing_lore["lore"].erase("LORE_EVT_OBSERVADOR")
	_expect("validação acusa lore ausente", not EventTexts.validate(missing_lore, catalog).is_empty())

	print("=======================================================")
	print("[%s] TESTE EVENT TEXTS" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
