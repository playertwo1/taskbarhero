extends Node

func _ready() -> void:
	print("\n=======================================================")
	print("--- TESTE DE SELEÇÃO DE PARTY E NOVOS INIMIGOS ---")
	print("=======================================================")

	var success := true

	# 1. Instanciar BattleStrip
	var battle_strip: Control = load("res://scripts/combat/BattleStrip.gd").new()
	battle_strip.size = Vector2(400, 220)
	add_child(battle_strip)
	await get_tree().process_frame

	# 2. Testar seleção de trio alternativo: Brasa, Orvalho e Sino
	print("\n>>> 1. TESTANDO SELEÇÃO DE PARTY: [brasa, orvalho, sino]")
	GameManager.set_party_selection(["sino", "orvalho", "brasa"])
	await get_tree().process_frame

	if not GameManager.party.has("brasa") or not GameManager.party.has("orvalho") or not GameManager.party.has("sino"):
		print("FALHA: GameManager.party não contém o trio selecionado")
		success = false
	else:
		print("[PASS] GameManager.party atualizado com sucesso: ", GameManager.party.keys())

	# Verificar se BattleStrip instanciou os 3 novos heróis
	var expected_heroes := ["sino", "orvalho", "brasa"]
	for hid in expected_heroes:
		if not battle_strip.party_visuals.has(hid):
			print("FALHA: BattleStrip não possui visual para: ", hid)
			success = false
		else:
			var node: Node2D = battle_strip.party_visuals[hid]
			if not node or not is_instance_valid(node) or not node.visible:
				print("FALHA: Node de visual inválido ou invisível para: ", hid)
				success = false
			else:
				print("  -> Visual de %s instanciado e visível na BattleStrip (OK)" % hid)

	# 3. Testar ataque de Brasa e Orvalho
	battle_strip.play_hero_attack("brasa")
	battle_strip.play_hero_attack("orvalho")
	print("[PASS] Comandos de animação de ataque executados nos novos heróis sem erros")

	# 4. Testar carregamento dos 5 novos inimigos no BattleStrip
	var new_enemies := [
		{"id": "saqueador_da_mata", "name": "Saqueador da Mata"},
		{"id": "xama_de_esporos", "name": "Xamã de Esporos"},
		{"id": "sentinela_de_raizes", "name": "Sentinela de Raízes"},
		{"id": "lobo_de_sombra", "name": "Lobo de Sombra"},
		{"id": "matriarca_do_micelio", "name": "Matriarca do Micélio", "boss": true}
	]

	print("\n>>> 2. TESTANDO EXIBIÇÃO DOS 5 NOVOS INIMIGOS NA BATTLESTRIP:")
	for enemy_data in new_enemies:
		battle_strip.set_enemy(enemy_data)
		await get_tree().process_frame
		if battle_strip.enemy_visual == null or not is_instance_valid(battle_strip.enemy_visual):
			print("FALHA: enemy_visual nulo para: ", enemy_data["id"])
			success = false
		elif not battle_strip.enemy_visual.visible:
			print("FALHA: enemy_visual invisível para: ", enemy_data["id"])
			success = false
		else:
			print("  [PASS] Inimigo '%s' renderizado e ativo no BattleStrip (OK)" % enemy_data["id"])
			battle_strip.flash_enemy_attack()

	# 5. Testar segunda troca de Party: [Forja, Véu, Bastião]
	print("\n>>> 3. TESTANDO SEGUNDA TROCA DE PARTY: [forja, veu, bastiao]")
	GameManager.set_party_selection(["forja", "veu", "bastiao"])
	await get_tree().process_frame

	for hid in ["forja", "veu", "bastiao"]:
		if not battle_strip.party_visuals.has(hid):
			print("FALHA: Visual ausente após segunda troca para: ", hid)
			success = false
		else:
			print("  [PASS] Visual de %s ativo após rotação de party" % hid)

	# Limpeza
	battle_strip.queue_free()

	if success:
		print("\n=======================================================")
		print("=== SELEÇÃO DE PARTY E NOVOS INIMIGOS: 100% PASS ===")
		print("=======================================================")
		get_tree().quit(0)
	else:
		print("\n=== FALHA NO TESTE DE SELEÇÃO DE PARTY ===")
		get_tree().quit(1)
