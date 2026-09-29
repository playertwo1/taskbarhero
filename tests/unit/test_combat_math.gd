extends Node

const EPS := 0.005

var success := true

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE COMBAT MATH v0.4 (SLICE-1A-1) ---")
	print("=======================================================")

	_test_contract_examples()
	_test_limits()
	_test_stat_pipeline()
	_test_shield()
	_test_level_value()

	print("\n=======================================================")
	if success:
		print("[PASS] TESTE COMBAT MATH CONCLUÍDO COM SUCESSO")
		get_tree().quit(0)
	else:
		print("[FAIL] TESTE COMBAT MATH FALHOU")
		get_tree().quit(1)

func _check(label: String, actual: float, expected: float, eps: float = EPS) -> void:
	if absf(actual - expected) <= eps:
		print("[PASS] %s = %.4f" % [label, actual])
	else:
		print("FALHA: %s esperado %.4f, obtido %.4f" % [label, expected, actual])
		success = false

# Exemplos à mão de docs/06_balance/SLICE_BALANCE_CONTRACT.md, seção 4.
func _test_contract_examples() -> void:
	print("\n>>> 1. EXEMPLOS DO CONTRATO (Bastião nível 1 × Geleia de Lúmen)")
	# Bastião: ATK 10, DEF 18, AS 0,80, crit 3%, crit dmg 1,5. Geleia: DEF 6,75, ATK 4,5, AS 1,0.
	_check("mitigação da Geleia", CombatMath.mitigation(6.75), 0.0632, 0.0001)
	_check("golpe de Bastião", CombatMath.hit_damage(10.0, 6.75), 9.37)
	var avg := CombatMath.expected_hit(CombatMath.hit_damage(10.0, 6.75), 0.03, 1.5)
	_check("golpe médio com crítico", avg, 9.51)
	_check("DPS básico de Bastião", avg * (1.0 / CombatMath.attack_interval(0.80)), 7.61)
	_check("mitigação de Bastião", CombatMath.mitigation(18.0), 0.1525, 0.0001)
	var geleia_hit := CombatMath.hit_damage(4.5, 18.0)
	_check("golpe da Geleia em Bastião", geleia_hit, 3.81)
	_check("tempo da Geleia para matar Bastião", 160.0 / (geleia_hit * 1.0), 42.0, 0.05)
	_check("penetração de 50% reduz a defesa", CombatMath.mitigation(18.0, 0.5), 9.0 / 109.0, 0.0001)
	_check("damage_taken multiplica depois da mitigação", CombatMath.hit_damage(100.0, 100.0, 0.0, 0.8), 40.0)

func _test_limits() -> void:
	print("\n>>> 2. LIMITES")
	_check("dano mínimo 1", CombatMath.hit_damage(0.5, 500.0), 1.0)
	_check("intervalo mínimo com attack_speed 10", CombatMath.attack_interval(10.0), 0.20, 0.0001)
	_check("intervalo normal 1,25", CombatMath.attack_interval(0.8), 1.25, 0.0001)
	_check("cooldown com skill_haste 100", CombatMath.cooldown(10.0, 100.0), 5.0, 0.0001)
	_check("cooldown mínimo", CombatMath.cooldown(1.0, 1000.0), 0.25, 0.0001)
	_check("duração de controle com tenacidade 100", CombatMath.control_duration(4.0, 100.0), 2.0, 0.0001)
	_check("crítico limitado a 100%", CombatMath.expected_hit(10.0, 2.5, 1.5), 15.0)
	_check("crit_chance 0 não altera", CombatMath.expected_hit(10.0, 0.0, 1.5), 10.0)

func _test_stat_pipeline() -> void:
	print("\n>>> 3. PIPELINE DE MODIFICADORES")
	var mods: Array = [
		{"op": "FLAT", "value": 10.0, "source_type": "ITEM", "source_id": "ITEM_W_001"},
		{"op": "ADD_PERCENT", "value": 0.20, "source_type": "PASSIVE", "source_id": "PASS_X"},
		{"op": "ADD_PERCENT", "value": 0.30, "source_type": "TREE", "source_id": "TREE_VIG_002"},
		{"op": "MULTIPLY", "value": 1.10, "source_type": "BUFF", "source_id": "BUFF_X"},
	]
	# (100 + 10) × (1 + 0,20 + 0,30) × 1,10 = 181,5
	_check("FLAT → ADD_PERCENT somado → MULTIPLY", CombatMath.resolve_stat(100.0, mods), 181.5, 0.0001)
	_check("sem modificadores", CombatMath.resolve_stat(100.0, []), 100.0, 0.0001)
	var with_override: Array = mods.duplicate()
	with_override.append({"op": "OVERRIDE", "value": 50.0, "source_type": "EFFECT", "source_id": "E"})
	_check("OVERRIDE substitui o valor", CombatMath.resolve_stat(100.0, with_override), 50.0, 0.0001)
	_check("clamp máximo", CombatMath.resolve_stat(100.0, mods, 0.0, 120.0), 120.0, 0.0001)
	_check("clamp mínimo", CombatMath.resolve_stat(10.0, [{"op": "FLAT", "value": -50.0, "source_type": "DEBUFF", "source_id": "D"}], 0.0), 0.0, 0.0001)
	_check("a ordem do array não muda o resultado", CombatMath.resolve_stat(100.0, mods.duplicate() as Array), CombatMath.resolve_stat(100.0, _reversed(mods)), 0.0001)
	var before := mods.size()
	CombatMath.resolve_stat(100.0, mods)
	if mods.size() != before or not mods[0].has("source_id"):
		print("FALHA: resolve_stat alterou ou descartou a origem dos modificadores")
		success = false
	else:
		print("[PASS] origem dos modificadores preservada")

func _reversed(arr: Array) -> Array:
	var out: Array = arr.duplicate()
	out.reverse()
	return out

func _test_shield() -> void:
	print("\n>>> 4. ESCUDO")
	_check("escudo com shield_power", CombatMath.shield_amount(20.0, 0.5), 30.0, 0.0001)
	var r: Dictionary = CombatMath.absorb(10.0, 4.0)
	_check("dano ao HP após escudo menor", r["hp_damage"], 6.0, 0.0001)
	_check("escudo restante zerado", r["shield_left"], 0.0, 0.0001)
	r = CombatMath.absorb(10.0, 25.0)
	_check("escudo maior absorve tudo", r["hp_damage"], 0.0, 0.0001)
	_check("escudo restante após absorver", r["shield_left"], 15.0, 0.0001)
	r = CombatMath.absorb(10.0, 0.0)
	_check("sem escudo, dano integral", r["hp_damage"], 10.0, 0.0001)

func _test_level_value() -> void:
	print("\n>>> 5. INTERPOLAÇÃO POR NÍVEL")
	# HERO_STATS_BALANCE: Bastião HP 160 → 700.
	_check("nível 1", CombatMath.level_value(160.0, 700.0, 1), 160.0, 0.0001)
	_check("nível 100", CombatMath.level_value(160.0, 700.0, 100), 700.0, 0.0001)
	_check("nível 5", CombatMath.level_value(160.0, 700.0, 5), 160.0 + 540.0 * 4.0 / 99.0, 0.0001)
