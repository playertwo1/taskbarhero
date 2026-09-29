extends Node

var success := true
var catalog: Dictionary

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE EVENT DIRECTOR (SLICE-1B) ---")
	catalog = EventDirector.load_catalog()
	_test_catalog()
	_test_validation_rejects_unknowns()
	_test_eligibility()
	_test_transition_roll()
	_test_choices_and_outcomes()
	print("=======================================================")
	print("[%s] TESTE EVENT DIRECTOR" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _ctx(heroes: Array = ["hero_001", "hero_002", "hero_003"], flags: Dictionary = {}) -> Dictionary:
	return {"alive_heroes": heroes, "party_level": 5, "equipped": [], "previous_no_falls": true, "flags": flags}

func _test_catalog() -> void:
	print("\n>>> 1. CATÁLOGO")
	_expect("catálogo válido", EventDirector.validate(catalog).is_empty())
	_expect("11 linhas: os 10 eventos da spec + a Reserva de Resíduo (fixa, sem escolha)", catalog["events"].size() == 11)
	var kinds := {}
	for e in catalog["events"]:
		kinds[e["kind"]] = int(kinds.get(e["kind"], 0)) + 1
	_expect("2 fixos (Poço e Reserva)", kinds["fixed"] == 2)
	_expect("5 aleatórios, 3 pessoais, 1 secreto", kinds["random"] == 5 and kinds["personal"] == 3 and kinds["secret"] == 1)

func _test_validation_rejects_unknowns() -> void:
	print("\n>>> 2. VALIDAÇÃO")
	var bad_effect := {"random_rules": catalog["random_rules"], "events": [{"id": "x", "kind": "random", "weight": 1, "conditions": [], "choices": [{"id": "a", "label": "a", "effects": [{"type": "executar_codigo"}]}]}]}
	_expect("efeito desconhecido é rejeitado", not EventDirector.validate(bad_effect).is_empty())
	var bad_cond := {"random_rules": catalog["random_rules"], "events": [{"id": "x", "kind": "random", "weight": 1, "conditions": [{"type": "lua_cheia"}], "choices": [{"id": "a", "label": "a", "effects": []}]}]}
	_expect("condição desconhecida é rejeitada", not EventDirector.validate(bad_cond).is_empty())
	var no_choice := {"random_rules": catalog["random_rules"], "events": [{"id": "x", "kind": "random", "weight": 1, "conditions": [], "choices": []}]}
	_expect("evento sem escolha é rejeitado", not EventDirector.validate(no_choice).is_empty())

func _test_eligibility() -> void:
	print("\n>>> 3. ELEGIBILIDADE")
	var d := EventDirector.create(catalog, 1)
	var eco := d.event_by_id("event_c1_eco_percebido")
	_expect("Eco Percebido exige Íris", d.is_eligible(eco, _ctx()) and not d.is_eligible(eco, _ctx(["hero_001", "hero_002"])))
	var obs := d.event_by_id("event_c1_observador")
	_expect("Observador some depois de visto", d.is_eligible(obs, _ctx()) and not d.is_eligible(obs, _ctx(["hero_001"], {"seen_event_c1_observador": true})))
	_expect("event_by_id desconhecido devolve {}", d.event_by_id("nao_existe").is_empty())

func _test_transition_roll() -> void:
	print("\n>>> 4. SORTEIO NAS TRANSIÇÕES")
	var a := EventDirector.create(catalog, 5)
	var b := EventDirector.create(catalog, 5)
	var seq_a := []
	var seq_b := []
	for i in 30:
		var ea := String(a.roll_transition(_ctx()).get("id", ""))
		var eb := String(b.roll_transition(_ctx()).get("id", ""))
		if ea != "":
			a.mark_seen(ea)  # o run marca o evento como visto ao resolvê-lo
		if eb != "":
			b.mark_seen(eb)
		seq_a.append(ea)
		seq_b.append(eb)
	_expect("mesma seed, mesma sequência", seq_a == seq_b)
	var randoms := seq_a.filter(func(id): return id != "" and id != "event_c1_observador")
	_expect("máximo 2 aleatórios por run", randoms.size() <= 2)
	var seen := {}
	var no_repeat := true
	for id in seq_a:
		if id != "":
			no_repeat = no_repeat and not seen.has(id)
			seen[id] = true
	_expect("nenhum evento repete na run", no_repeat)
	var freq := 0
	var trials := 4000
	for i in trials:
		var d := EventDirector.create(catalog, 1000 + i)
		if not d.roll_transition(_ctx()).is_empty():
			freq += 1
	_expect("≈ 25%% de eventos por transição (%.3f)" % (float(freq) / trials), absf(float(freq) / trials - 0.26) < 0.03)
	var no_eco := 0
	for i in 2000:
		var d := EventDirector.create(catalog, 9000 + i)
		if d.roll_transition(_ctx(["hero_001", "hero_002"])).get("id", "") == "event_c1_eco_percebido":
			no_eco += 1
	_expect("sem Íris o Eco nunca aparece", no_eco == 0)

func _test_choices_and_outcomes() -> void:
	print("\n>>> 5. ESCOLHAS E RESULTADOS")
	var d := EventDirector.create(catalog, 3)
	var memorial := d.event_by_id("event_c1_memorial")
	var choices := d.choices_for(memorial, _ctx())
	_expect("Memorial gera uma escolha por herói vivo", choices.size() == 3)
	var fx := d.resolve(choices[1])
	_expect("escopo 'pick' vira o herói escolhido", fx[0]["scope"] == "hero_002" and fx[1]["text_id"] == "LORE_EVT_MEMORIAL_hero_002")
	var raiz := d.event_by_id("event_c1_raiz_oca")
	var open_choice: Dictionary = d.choices_for(raiz, _ctx())[0]
	var counts := {"damage": 0, "item": 0, "nothing": 0}
	for i in 6000:
		var res := EventDirector.create(catalog, i).resolve(open_choice)
		if res.is_empty():
			counts["nothing"] += 1
		elif res[0]["type"] == "damage_fraction":
			counts["damage"] += 1
		else:
			counts["item"] += 1
	_expect("Raiz Oca: ≈20%% espinhos, ≈15%% esconderijo, ≈65%% nada", absf(counts["damage"] / 6000.0 - 0.20) < 0.03 and absf(counts["item"] / 6000.0 - 0.15) < 0.03 and absf(counts["nothing"] / 6000.0 - 0.65) < 0.03)
	var poco := d.event_by_id("event_c1_001")
	_expect("Poço tem duas escolhas", d.choices_for(poco, _ctx()).size() == 2)
