extends Node

func _ready() -> void:
	print("================================================================================")
	print("--- TESTE R15: VALIDAÇÃO DE SAVE E PROGRESSO OFFLINE (GATE R15) ---")
	print("================================================================================")

	var success := true

	# 1. Preparar estado limpo de teste
	SaveManager.delete_save()
	ProgressionManager.level = 2
	ProgressionManager.xp = 15
	ProgressionManager.gold = 50
	ProgressionManager.current_stage = 2
	ProgressionManager.stage_kills = 3
	LootManager.equipment = {
		"weapon": {"id": "adaga_de_luz", "name": "Adaga de Luz", "slot": "weapon", "attack": 2},
		"armor": null,
		"amulet": null
	}
	LootManager.inventory.clear()
	GameManager._init_party_stats()

	# Salva o estado completo
	GameManager.save_full_state()
	if not SaveManager.has_save():
		print("ERRO: SaveManager não encontrou o arquivo de save gravado")
		success = false
	else:
		print("[PASS] Estado inicial salvo com sucesso em user://")

	# 2. Simular encerramento e ausência de 2h 14m (8040 segundos)
	var raw_save: Dictionary = SaveManager.load_game()
	var simulated_offline_seconds: int = 8040 # 2 horas e 14 minutos
	var past_timestamp: int = int(Time.get_unix_time_from_system()) - simulated_offline_seconds
	raw_save["saved_at_unix"] = past_timestamp
	SaveManager.save_game(raw_save)
	print("[INFO] Simulação de ausência: 2h 14m (8040 segundos no passado)")

	# Resetar memória dos managers para provar que o reload restaura do disco
	ProgressionManager.level = 1
	ProgressionManager.xp = 0
	ProgressionManager.gold = 0
	ProgressionManager.current_stage = 1
	ProgressionManager.stage_kills = 0
	LootManager.equipment = {"weapon": null, "armor": null, "amulet": null}

	# 3. Reabrir e recarregar (Primeira Carga pós-offline)
	var xp_before_offline := 15
	var gold_before_offline := 50

	var offline_data := GameManager.load_full_state()

	# Validar restauração do estado base e ganho de nível decorrente da XP offline
	if ProgressionManager.level < 2:
		print("ERRO: Nível não restaurado corretamente (esperado pelo menos 2, obtido %d)" % ProgressionManager.level)
		success = false
	if ProgressionManager.current_stage != 2:
		print("ERRO: Fase não restaurada corretamente (esperada 2, obtida %d)" % ProgressionManager.current_stage)
		success = false
	if LootManager.equipment["weapon"] == null or LootManager.equipment["weapon"]["id"] != "adaga_de_luz":
		print("ERRO: Equipamento não restaurado corretamente")
		success = false
	else:
		print("[PASS] Estado anterior restaurado com fidelidade (Fase 2, Adaga equipada, Nível avançado de 2 para %d via XP offline)" % ProgressionManager.level)

	# Validar dados do progresso offline
	if offline_data.is_empty():
		print("ERRO: Progresso offline não foi calculado durante a carga!")
		success = false
	else:
		print("[PASS] Progresso offline detectado e calculado:")
		print("  -> Tempo formatado: %s" % offline_data.get("time_formatted"))
		print("  -> Inimigos derrotados estimados: %d" % offline_data.get("kills"))
		print("  -> XP acumulado: +%d" % offline_data.get("xp"))
		print("  -> Ouro acumulado: +%d" % offline_data.get("gold"))
		print("  -> Itens obtidos (sem explosão de inventário): %d" % offline_data.get("items", []).size())

		if offline_data.get("time_formatted") != "2h14m":
			print("ERRO: Formatação de tempo incorreta! Esperado '2h14m', obtido '%s'" % offline_data.get("time_formatted"))
			success = false
		else:
			print("[PASS] Formatação de tempo '2h14m' idêntica à especificação do Roadmap")

		if ProgressionManager.gold <= gold_before_offline:
			print("ERRO: Ouro offline não foi somado ao jogador")
			success = false
		else:
			print("[PASS] Ouro offline aplicado: de %d para %d" % [gold_before_offline, ProgressionManager.gold])

		if offline_data.get("items", []).size() > 5:
			print("ERRO: Limite de itens offline violado (mais de 5 itens)")
			success = false
		else:
			print("[PASS] Limite de segurança de itens respeitado (%d itens)" % offline_data.get("items", []).size())

	# 4. Provar que o progresso offline é aplicado UMA ÚNICA VEZ
	print("\n--- TESTANDO APLICAÇÃO ÚNICA (SEM DUPLICIDADE) ---")
	var gold_after_first_claim := ProgressionManager.gold
	var xp_after_first_claim := ProgressionManager.xp
	var level_after_first_claim := ProgressionManager.level

	# Salva o estado atual (com timestamp de agora)
	GameManager.save_full_state()

	# Recarrega imediatamente (simulando reabertura rápida sem tempo decorrido)
	var second_offline := GameManager.load_full_state()

	if not second_offline.is_empty():
		print("ERRO: Progresso offline foi aplicado novamente em reabertura imediata!")
		success = false
	else:
		print("[PASS] Nenhuma recompensa offline duplicada em reabertura imediata (retornou vazio)")

	if ProgressionManager.gold != gold_after_first_claim or ProgressionManager.xp != xp_after_first_claim or ProgressionManager.level != level_after_first_claim:
		print("ERRO: Atributos foram inflacionados na segunda leitura!")
		success = false
	else:
		print("[PASS] Validação estrita: Recompensas aplicadas UMA ÚNICA VEZ com perfeição")

	# 5. Validar teto máximo de 8 horas (28800s)
	print("\n--- TESTANDO TETO MÁXIMO DE 8 HORAS ---")
	var ancient_timestamp: int = int(Time.get_unix_time_from_system()) - (24 * 3600) # 24 horas ausente
	var max_cap_test := ProgressionManager.calculate_offline_progress(ancient_timestamp)
	if max_cap_test.get("elapsed_seconds") != 28800:
		print("ERRO: Teto de 8h (28800s) violado! Obtido: %d segundos" % max_cap_test.get("elapsed_seconds"))
		success = false
	else:
		print("[PASS] Teto estrito de 8 horas (28800s) validado com sucesso (%s)" % max_cap_test.get("time_formatted"))

	print("================================================================================")
	if success:
		print("=== GATE R15 HOMOLOGADO COM SUCESSO: SAVE E PROGRESSO OFFLINE PASS ===")
		print("================================================================================")
		get_tree().quit(0)
	else:
		print("=== GATE R15 FALHOU! VERIFIQUE OS ERROS ACIMA ===")
		print("================================================================================")
		get_tree().quit(1)
