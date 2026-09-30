extends Node

## Árvore de passivas do slice: pontos por nível, tiers em cadeia, 1 Trait por vez, híbridos e capstone no nível 10.

var success := true
var hero_rows: Array = []
var passive_rows: Array = []

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		print("FALHA: ", label)
		success = false

func _hero(id: String) -> Dictionary:
	return hero_rows.filter(func(r): return r["id"] == id)[0]

func _ready() -> void:
	print("--- TESTE ÁRVORE DE PASSIVAS ---")
	KitTestSupport.load_all()
	hero_rows = KitTestSupport.hero_rows
	passive_rows = KitTestSupport.passive_rows
	_test_budget_and_rules()
	_test_auto_allocation()
	_test_run_integration()
	print("[PASS] TESTE ÁRVORE DE PASSIVAS CONCLUÍDO" if success else "[FAIL] TESTE ÁRVORE DE PASSIVAS")
	get_tree().quit(0 if success else 1)

func _test_budget_and_rules() -> void:
	print("\n>>> 1. ORÇAMENTO E REGRAS")
	_expect("1 ponto por nível a partir do 2", PassiveTree.budget(1) == 0 and PassiveTree.budget(2) == 1 and PassiveTree.budget(12) == 11)
	var nodes := PassiveTree.nodes(passive_rows, "hero_001")
	_expect("Bastião tem 18 nós na árvore (3 branches × 6)", nodes.size() == 18)
	var bad := PassiveTree.validate("hero_001", ["passive_bas_escudo_compartilhado"], 12, passive_rows)
	_expect("A2 sozinho é inválido (falta A1)", not bool(bad["ok"]))
	_expect("A1 + A2 é válido", bool(PassiveTree.validate("hero_001", ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado"], 12, passive_rows)["ok"]))
	var hybrid := PassiveTree.validate("hero_001", ["passive_bas_ombro_a_ombro", "passive_bas_peso_do_escudo", "passive_bas_voz_de_comando"], 12, passive_rows)
	_expect("híbrido: o 1º nó de cada branch é válido", bool(hybrid["ok"]))
	var two_traits := PassiveTree.validate("hero_001", ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado", "passive_bas_voto_do_escudo",
		"passive_bas_peso_do_escudo", "passive_bas_momento", "passive_bas_ferro_responde"], 12, passive_rows)
	_expect("2 Traits ao mesmo tempo é inválido", not bool(two_traits["ok"]))
	var over := PassiveTree.validate("hero_001", ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado"], 2, passive_rows)
	_expect("mais pontos que o orçamento é inválido (nível 2 = 1 ponto)", not bool(over["ok"]))
	var capstone_early := PassiveTree.validate("hero_001", ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado", "passive_bas_presenca_protetora", "passive_bas_ninguem_para_tras", "passive_bas_guarda_eterna"], 9, passive_rows)
	_expect("capstone exige nível 10", not bool(capstone_early["ok"]))
	_expect("capstone no nível 10 com a cadeia completa é válido", bool(PassiveTree.validate("hero_001", ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado", "passive_bas_presenca_protetora", "passive_bas_ninguem_para_tras", "passive_bas_guarda_eterna"], 10, passive_rows)["ok"]))

func _test_auto_allocation() -> void:
	print("\n>>> 2. ALOCAÇÃO AUTOMÁTICA")
	var bast := _hero("hero_001")
	_expect("nível 1: nenhuma passiva de build", PassiveTree.auto_allocate(bast, "guardiao", 1, passive_rows).is_empty())
	_expect("nível 2 (1 ponto, deep): só A1 da branch", PassiveTree.auto_allocate(bast, "guardiao", 2, passive_rows) == ["passive_bas_ombro_a_ombro"])
	var l5 := PassiveTree.auto_allocate(bast, "guardiao", 5, passive_rows)
	_expect("nível 5 (4 pontos, deep): A1, A2, A3 e o Trait", l5 == ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado", "passive_bas_presenca_protetora", "passive_bas_voto_do_escudo"])
	var l9 := PassiveTree.auto_allocate(bast, "guardiao", 9, passive_rows)
	_expect("nível 9: sem capstone (exige nível 10)", not l9.has("passive_bas_guarda_eterna"))
	_expect("nível 9 gasta os 8 pontos (o excedente vai para outra branch)", l9.size() == 8)
	var l10 := PassiveTree.auto_allocate(bast, "guardiao", 10, passive_rows)
	_expect("nível 10: o capstone entra", l10.has("passive_bas_guarda_eterna"))
	var l12 := PassiveTree.auto_allocate(bast, "retaliacao", 12, passive_rows)
	_expect("nível 12: 11 pontos, menos que os 17 nós possíveis (não dá para tudo)", l12.size() == 11 and l12.size() < 17)
	_expect("o resultado automático sempre passa na validação", bool(PassiveTree.validate("hero_001", l12, 12, passive_rows)["ok"]))
	var spread := PassiveTree.auto_allocate(bast, "guardiao", 4, passive_rows, "spread")
	_expect("spread no nível 4 (3 pontos): o 1º nó de cada branch", spread.size() == 3 and spread.has("passive_bas_ombro_a_ombro") and spread.has("passive_bas_peso_do_escudo") and spread.has("passive_bas_voz_de_comando"))
	_expect("a build `retaliacao_tele` usa a branch `retaliacao`", PassiveTree.auto_allocate(bast, "retaliacao_tele", 2, passive_rows) == ["passive_bas_peso_do_escudo"])

func _kinds(ids: Array) -> Array:
	var out: Array = []
	for pid in ids:
		out.append(KitTestSupport.passive_rows.filter(func(r): return r["id"] == pid)[0]["kind"])
	return out

func _test_run_integration() -> void:
	print("\n>>> 3. A RUN USA A ÁRVORE")
	var low := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "arcano"}, 3, 1)
	var passives: Dictionary = low._heroes["hero_001"]["passives"]
	_expect("nível 3: o Bastião tem A1 e A2 (Ombro a Ombro e Escudo Compartilhado) e não tem Guarda Eterna", passives.has("ally_aura_dr") and passives.has("redirect") and not passives.has("guard_eternal"))
	var explicit := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "arcano"}, 12, 1,
		{"passive_points": {"hero_001": ["passive_bas_peso_do_escudo", "passive_bas_momento"]}})
	var hybrid_passives: Dictionary = explicit._heroes["hero_001"]["passives"]
	_expect("alocação explícita: só os nós escolhidos (Peso do Escudo e Momento)", hybrid_passives.has("pb_damage") and hybrid_passives.has("counter_bonus_vs_imbalanced") and not hybrid_passives.has("ally_aura_dr"))
	var invalid := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "arcano"}, 5, 1,
		{"passive_points": {"hero_001": ["passive_bas_guarda_eterna"]}})
	_expect("alocação inválida cai na automática (não entra Guarda Eterna sem a cadeia)", not invalid._heroes["hero_001"]["passives"].has("guard_eternal") and invalid._heroes["hero_001"]["passives"].has("ally_aura_dr"))
	var spread := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": "arcano"}, 4, 1, {"passive_policy": "spread"})
	_expect("política spread espalha: A1 das três branches do Bastião", spread._heroes["hero_001"]["passives"].has("ally_aura_dr") and spread._heroes["hero_001"]["passives"].has("pb_damage"))
	for level in [1, 6, 12]:
		var run := SliceSession.create_run({"hero_001": "controle", "hero_002": "velocidade", "hero_003": "lumen"}, level, 3)
		run.run_to_end(0.25, 900.0)
		_expect("nível %d roda até o fim com a árvore" % level, run.state == "won" or run.state == "lost")
