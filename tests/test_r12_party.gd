extends Node

func _ready() -> void:
	print("================================================================================")
	print("--- TESTE R12: VALIDAÇÃO DO SISTEMA DE PARTY DE TRÊS PERSONAGENS ---")
	print("================================================================================")
	
	var success := true
	
	# 1. Validar composição e slots da Party
	var party: Dictionary = GameManager.party
	if party.size() != 3:
		print("ERRO: Party não possui 3 integrantes! Tamanho atual: %d" % party.size())
		success = false
	else:
		print("[PASS] Party de 3 integrantes configurada no GameManager")

	var required_slots := {
		"front": "bastiao",
		"mid": "iris",
		"back": "flecha"
	}

	for slot in required_slots.keys():
		var expected_hid: String = required_slots[slot]
		var actual_hid: String = GameManager.formation_slots.get(slot, "")
		if actual_hid != expected_hid:
			print("ERRO: Slot '%s' esperado '%s', mas está '%s'" % [slot, expected_hid, actual_hid])
			success = false
		else:
			print("  -> Slot '%s': %s (OK)" % [slot, actual_hid.capitalize()])

	# 2. Validar Atributos de Função e Alcance (Tank, Mage, Archer)
	var bastiao: Dictionary = party.get("bastiao", {})
	var iris: Dictionary = party.get("iris", {})
	var flecha: Dictionary = party.get("flecha", {})

	if bastiao.get("role") != "tank" or bastiao.get("attack_range", 0.0) < 150.0:
		print("ERRO: Bastião com função ou alcance incorreto: ", bastiao)
		success = false
	else:
		print("[PASS] Bastião: Tanque Frontline (Alcance: %.0f, CD: %.2fs)" % [bastiao.get("attack_range"), bastiao.get("cd_interval")])

	if iris.get("role") != "mage" or iris.get("attack_range", 0.0) < 250.0:
		print("ERRO: Íris com função ou alcance incorreto: ", iris)
		success = false
	else:
		print("[PASS] Íris: Maga Midline (Alcance: %.0f, CD: %.2fs)" % [iris.get("attack_range"), iris.get("cd_interval")])

	if flecha.get("role") != "archer" or flecha.get("attack_range", 0.0) < 350.0:
		print("ERRO: Flecha com função ou alcance incorreto: ", flecha)
		success = false
	else:
		print("[PASS] Flecha: Arqueiro Backline (Alcance: %.0f, CD: %.2fs)" % [flecha.get("attack_range"), flecha.get("cd_interval")])

	# 3. Validar Regra de Targeting de Formação
	# Inimigos devem focar o FRONT primeiro. Ao morrer, MID. Ao morrer, BACK.
	GameManager._init_party_stats()
	var target_1: String = GameManager._get_enemy_target()
	if target_1 != "bastiao":
		print("ERRO: Primeiro alvo deveria ser 'bastiao', mas foi '%s'" % target_1)
		success = false
	else:
		print("[PASS] Targeting 1: Inimigo mira no frontline (Bastião)")

	# Matar Bastião
	bastiao["is_alive"] = false
	bastiao["current_hp"] = 0.0
	var target_2: String = GameManager._get_enemy_target()
	if target_2 != "iris":
		print("ERRO: Segundo alvo com Bastião morto deveria ser 'iris', mas foi '%s'" % target_2)
		success = false
	else:
		print("[PASS] Targeting 2: Com Bastião caído, inimigo avança para midline (Íris)")

	# Matar Íris
	iris["is_alive"] = false
	iris["current_hp"] = 0.0
	var target_3: String = GameManager._get_enemy_target()
	if target_3 != "flecha":
		print("ERRO: Terceiro alvo com Bastião e Íris mortos deveria ser 'flecha', mas foi '%s'" % target_3)
		success = false
	else:
		print("[PASS] Targeting 3: Com Bastião e Íris caídos, inimigo ataca backline (Flecha)")

	# Matar Flecha -> Party Defeated
	flecha["is_alive"] = false
	flecha["current_hp"] = 0.0
	if GameManager.is_party_alive():
		print("ERRO: is_party_alive() deveria ser falso com todos caídos")
		success = false
	else:
		print("[PASS] Derrota da Party: Todos os heróis caídos detectados corretamente")

	# 4. Validar Regeneração / Revive pós combate
	GameManager._on_enemy_defeated()
	if not GameManager.is_party_alive():
		print("ERRO: Heróis deveriam reviver com campo regenerativo após vitória")
		success = false
	else:
		print("[PASS] Campo Regenerativo: Heróis caídos reanimados após desfecho")

	# 5. Validar BattleStrip visual e posicionamento sem sobreposição (Zero Mixels)
	var bs_script = load("res://scripts/combat/BattleStrip.gd")
	if not bs_script:
		print("ERRO: BattleStrip.gd falhou ao carregar")
		success = false
	else:
		var bs_node: Control = Control.new()
		bs_node.set_script(bs_script)
		bs_node.size = Vector2(432, 220)
		add_child(bs_node)
		bs_node._ready()
		bs_node._process(0.016)

		var flecha_vis = bs_node.party_visuals.get("flecha")
		var iris_vis = bs_node.party_visuals.get("iris")
		var bastiao_vis = bs_node.party_visuals.get("bastiao")

		if flecha_vis == null or iris_vis == null or bastiao_vis == null:
			print("ERRO: Visual de algum integrante da party não foi instanciado no BattleStrip")
			success = false
		else:
			print("[PASS] Os 3 heróis da party instanciados com sucesso no BattleStrip")

			# Verificar ordenação e espaçamento das posições X
			var pos_flecha: float = flecha_vis.position.x
			var pos_iris: float = iris_vis.position.x
			var pos_bastiao: float = bastiao_vis.position.x

			print("  -> Posições X: Flecha=%.1f | Íris=%.1f | Bastião=%.1f" % [pos_flecha, pos_iris, pos_bastiao])
			if not (pos_flecha < pos_iris and pos_iris < pos_bastiao):
				print("ERRO: Posições não respeitam a ordem de formação (back < mid < front)")
				success = false
			else:
				print("[PASS] Ordem de formação espacial respeitada na faixa")

			var dist_1: float = pos_iris - pos_flecha
			var dist_2: float = pos_bastiao - pos_iris
			print("  -> Espaçamentos: Flecha-Íris=%.1f px, Íris-Bastião=%.1f px" % [dist_1, dist_2])
			if dist_1 < 45.0 or dist_2 < 45.0:
				print("ERRO: Espaçamento insuficiente entre heróis (possível sobreposição)")
				success = false
			else:
				print("[PASS] Espaçamento seguro entre heróis (sem sobreposição problemática)")

			# Verificar escala uniforme 2.0x (Zero mixels)
			if flecha_vis.scale != Vector2(2.0, 2.0) or iris_vis.scale != Vector2(2.0, 2.0) or bastiao_vis.scale != Vector2(2.0, 2.0):
				print("ERRO: Escala dos heróis não é 2.0x uniforme!")
				success = false
			else:
				print("[PASS] Escala 2.0x uniforme verificada em todos os heróis (Zero Mixels)")

		bs_node.queue_free()

	print("================================================================================")
	if success:
		print("=== GATE R12 HOMOLOGADO COM SUCESSO: PARTY COMBAT SYSTEM PASS ===")
		print("================================================================================")
		get_tree().quit(0)
	else:
		print("=== GATE R12 FALHOU! VERIFIQUE OS ERROS ACIMA ===")
		print("================================================================================")
		get_tree().quit(1)
