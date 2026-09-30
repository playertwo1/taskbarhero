extends Node

var success := true
const PATH := "user://test_resonance_tree.json"
const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE RESONANCE TREE (SLICE-1D) ---")
	_cleanup()
	_test_route_rewards()
	_test_tree_rules()
	_test_milestones_idempotent()
	_test_campaign_awards_and_persists()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE RESONANCE TREE" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _route_rewards() -> Dictionary:
	var file := FileAccess.open("res://data/expedition/route_c1.json", FileAccess.READ)
	var route: Dictionary = JSON.parse_string(file.get_as_text())
	var out := {}
	for n in route["nodes"]:
		if int(n.get("fragment_reward", 0)) > 0:
			out[String(n["id"])] = int(n["fragment_reward"])
	return out

func _test_route_rewards() -> void:
	print("\n>>> 1. MARCOS NA ROTA (32 = 4/6/7/7/8)")
	var rewards := _route_rewards()
	var total := 0
	var before_boss := 0
	for id in rewards:
		total += int(rewards[id])
		if id != "c1_5_2_a":
			before_boss += int(rewards[id])
	_expect("cinco marcos", rewards.size() == 5)
	_expect("total de 32 Fragmentos", total == 32)
	_expect("24 antes do Guardião", before_boss == 24)

func _test_tree_rules() -> void:
	print("\n>>> 2. REGRAS DA ÁRVORE")
	var t := ResonanceTree.load_default()
	var d := SliceSave.default_data()
	_expect("raiz começa ativa", t.is_unlocked(d, "TREE_VIG_001"))
	_expect("nó desconhecido recusado", t.buy(d, "TREE_X") == "unknown")
	_expect("sem Fragmentos recusa", t.buy(d, "TREE_VIG_002") == "fragments")
	d["fragments"] = 24
	_expect("pré-requisito antes do custo", t.buy(d, "TREE_OFI_001") == "prereq")
	for id in ["TREE_VIG_002", "TREE_VIG_005", "TREE_OFI_001", "TREE_OFI_002", "TREE_OFI_003"]:
		_expect("compra %s" % id, t.buy(d, id) == "")
	_expect("rota do Ferreiro custa exatamente 24", int(d["fragments"]) == 0)
	_expect("compra repetida recusada", t.buy(d, "TREE_OFI_003") == "owned")
	_expect("efeitos de serviço abertos", t.has_effect(d, "blacksmith") and t.has_effect(d, "disassemble") and t.has_effect(d, "upgrade"))
	var fresh := SliceSave.default_data()
	_expect("sem compras não há Ferreiro", not t.has_effect(fresh, "blacksmith"))

func _test_milestones_idempotent() -> void:
	print("\n>>> 3. MARCO É PAGO UMA VEZ")
	var d := SliceSave.default_data()
	_expect("primeiro pagamento", ResonanceTree.award_milestone(d, "c1_1_2_b", 4) == 4)
	_expect("repetição paga zero", ResonanceTree.award_milestone(d, "c1_1_2_b", 4) == 0 and int(d["fragments"]) == 4)
	_expect("recompensa zero não registra marco", ResonanceTree.award_milestone(d, "c1_1_1_a", 0) == 0 and not d["milestones"].has("c1_1_1_a"))

func _play(c: SliceCampaign, run: ExpeditionRun) -> void:
	var guard := 0
	while run.state != "won" and run.state != "lost" and guard < 20000:
		guard += 1
		if run.state == "choice":
			c.choose(run, 0)
		else:
			c.step(run, 0.5)

func _test_campaign_awards_and_persists() -> void:
	print("\n>>> 4. CAMPANHA CONCEDE, SALVA E NÃO REPAGA")
	var c := SliceCampaign.open(PATH)
	c.data["party"]["level"] = 12
	var run := c.start_expedition(BUILD, 21)
	_play(c, run)
	var summary := c.finish_expedition(run)
	var gained := int(summary["fragments"])
	_expect("a run concedeu Fragmentos", gained >= 4)
	_expect("saldo do save confere", int(c.data["fragments"]) == gained)
	var again := SliceCampaign.open(PATH)
	_expect("reabrir preserva saldo e marcos", int(again.data["fragments"]) == gained and again.data["milestones"].size() >= 1)
	var run2 := again.start_expedition(BUILD, 22)
	_play(again, run2)
	var second := again.finish_expedition(run2)
	_expect("segunda run não repaga marcos", int(second["fragments"]) == 0 or run.state != run2.state)
	_expect("comprar pela campanha grava", again.buy_tree_node("TREE_VIG_002") == "" and SliceCampaign.open(PATH).data["tree_nodes"].has("TREE_VIG_002"))
