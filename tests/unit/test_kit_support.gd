extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		print("FALHA: ", label)
		success = false

func _ready() -> void:
	print("--- TESTE SUPORTE DOS KITS ---")
	KitTestSupport.load_all()
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 2}])
	KitTestSupport.spawn(run)
	_expect("spawn cria 2 inimigos", run._enemies.size() == 2)
	KitTestSupport.tank(run)
	_expect("tank deixa HP alto", float(run._enemies[0]["hp"]) >= 1.0e9)
	var extra := KitTestSupport.new_enemy(run)
	_expect("new_enemy devolve inimigo vivo", bool(extra["alive"]))
	var events := run.step(3.0)
	_expect("Flecha ataca", not KitTestSupport.damages(events, "hero_attack", "hero_002").is_empty())
	# unlock_level: uma passiva de teste só entra no nível pedido.
	var gated: Dictionary = KitTestSupport.passive_rows.filter(func(r): return r["id"] == "passive_fle_pressao_coordenada")[0].duplicate(true)
	gated["id"] = "passive_teste_gated"
	gated["unlock_level"] = 5
	KitTestSupport.passive_rows.append(gated)
	var low := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], ["passive_teste_gated"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 4)
	var high := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], ["passive_teste_gated"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 5)
	_expect("unlock_level 5 fica de fora no nível 4", not low._heroes["hero_002"]["passives"].has("mark_ally_hit_boost"))
	_expect("unlock_level 5 entra no nível 5", high._heroes["hero_002"]["passives"].has("mark_ally_hit_boost"))
	KitTestSupport.passive_rows.erase(gated)
	# Ajudantes compartilhados (Plano 00, Tarefa 5).
	var helpers := KitTestSupport.mk([["hero_001", ["skill_bas_007"], []]], [{"enemy_id": "en_c1_001", "count": 3}])
	KitTestSupport.spawn(helpers)
	_expect("_alive_targets lista 3 inimigos", helpers._alive_targets().size() == 3)
	helpers._enemies[0]["alive"] = false
	_expect("_alive_targets ignora mortos", helpers._alive_targets().size() == 2)
	var bast: Dictionary = helpers._heroes["hero_001"]
	bast["skills"][0]["ready_at"] = helpers.time + 10.0
	helpers._reduce_cooldown(bast, "skill_bas_007", 3.0)
	_expect("_reduce_cooldown tira 3 s", absf(float(bast["skills"][0]["ready_at"]) - (helpers.time + 7.0)) < 0.001)
	helpers._reduce_cooldown(bast, "skill_bas_007", 100.0)
	_expect("_reduce_cooldown nunca passa de agora", absf(float(bast["skills"][0]["ready_at"]) - helpers.time) < 0.001)
	print("[PASS] TESTE SUPORTE DOS KITS CONCLUÍDO" if success else "[FAIL] TESTE SUPORTE DOS KITS")
	get_tree().quit(0 if success else 1)
