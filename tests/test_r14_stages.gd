extends Node

func _ready() -> void:
	print("================================================================================")
	print("--- TESTE R14: VALIDAÇÃO DA PROGRESSÃO DE FASES DO BOSQUE DE LÚMEN (GATE R14) ---")
	print("================================================================================")

	var success := true

	# 1. Validar carregamento do banco de fases (stages.json)
	ProgressionManager.load_stages_database()
	var stages: Array = ProgressionManager.stages_database
	print("[INFO] Total de fases configuradas: %d" % stages.size())
	if stages.size() != 5:
		print("ERRO: Esperado 5 fases no Bosque de Lúmen, encontrados: %d" % stages.size())
		success = false
	else:
		print("[PASS] 5 fases canônicas carregadas com sucesso")

	var expected_stages := {
		1: {"name": "Entrada do Bosque", "boss": ""},
		2: {"name": "Clareira da Pressão", "boss": ""},
		3: {"name": "Ninho Silvestre", "boss": ""},
		4: {"name": "Covil do Alfa", "boss": "lobo_alfa_de_lumen"},
		5: {"name": "Santuário do Guardião", "boss": "guardiao_cervo_de_pedra"}
	}

	for st in stages:
		var idx: int = int(st.get("stage", 0))
		if not expected_stages.has(idx):
			print("ERRO: Estágio inesperado com índice: %d" % idx)
			success = false
			continue
		var exp_data: Dictionary = expected_stages[idx]
		print("  -> Fase %d: %s | Kills para avançar: %d | Boss: %s" % [
			idx, st.get("name"), int(st.get("kills_to_advance")), str(st.get("boss_id"))
		])

	# 2. Reset para início da campanha na Fase 1
	ProgressionManager.current_stage = 1
	ProgressionManager.stage_kills = 0
	ProgressionManager.max_stage_reached = 1
	ProgressionManager.level = 1
	GameManager._init_party_stats()
	GameManager.active_enemy = {}
	GameManager.queued_boss_id = ""

	print("\n[INÍCIO DA PROGRESSÃO] Iniciando na Fase 1: %s" % ProgressionManager.get_current_stage_data().get("name"))
	if ProgressionManager.current_stage != 1:
		print("ERRO: Jogador não iniciou na fase 1")
		success = false
	else:
		print("[PASS] Jogador devidamente inicializado na Fase 1")

	# 3. Simular combate progressivo fase a fase até o Boss final
	var stages_reached: Array = [1]
	var bosses_spawned: Array = []

	var max_simulated_kills := 30
	var kill_counter := 0

	while kill_counter < max_simulated_kills and ProgressionManager.current_stage <= 5:
		# Spawna inimigo de acordo com a fase atual
		GameManager.spawn_next_enemy()
		var enemy: Dictionary = GameManager.active_enemy
		if enemy.is_empty():
			print("ERRO: Falha ao spawnar inimigo durante o teste de progressão")
			success = false
			break

		var enemy_id: String = enemy.get("id", "")
		var is_boss: bool = enemy.get("boss", false) or enemy.get("elite", false)

		if is_boss and not bosses_spawned.has(enemy_id):
			bosses_spawned.append(enemy_id)
			print("  [EVENTO] BOSS/ELITE ENGATILHADO NA FASE %d: %s (HP %d, ATK %d)" % [
				ProgressionManager.current_stage, enemy.get("name"), int(enemy.get("max_hp")), int(enemy.get("attack"))
			])

		# Simula combate vitorioso dos 3 heróis contra o inimigo
		while GameManager.active_enemy_hp > 0.0:
			for hid in ["bastiao", "iris", "flecha"]:
				GameManager._hero_attack_from(hid)
				if GameManager.active_enemy_hp <= 0.0:
					break

		kill_counter += 1

		# Registra avanço de fase
		var stage_now: int = ProgressionManager.current_stage
		if not stages_reached.has(stage_now):
			stages_reached.append(stage_now)
			var s_data := ProgressionManager.get_current_stage_data()
			print("[AVANÇO] Chegou à Fase %d: '%s' (Kills totais: %d)" % [
				stage_now, s_data.get("name"), kill_counter
			])

		# Se chegamos na Fase 5 e o boss final Guardião-Cervo de Pedra foi derrotado:
		if is_boss and enemy_id == "guardiao_cervo_de_pedra":
			print("  [VITÓRIA SUPREMA] O Chefe do Bosque de Lúmen (Guardião-Cervo de Pedra) foi derrotado!")
			break

	print("\n--- RESUMO DA PROGRESSÃO ---")
	print("Fases alcançadas em sequência normal: ", stages_reached)
	print("Chefes enfrentados: ", bosses_spawned)

	# 4. Validar Critérios do Gate R14
	if not stages_reached.has(5):
		print("ERRO: O jogador não conseguiu alcançar a Fase 5 (Santuário do Guardião)!")
		success = false
	else:
		print("[PASS] Jogador progrediu da Fase 1 até a Fase 5 de forma normal e autônoma")

	if not bosses_spawned.has("guardiao_cervo_de_pedra"):
		print("ERRO: O Guardião-Cervo de Pedra não foi invocado/alcançado!")
		success = false
	else:
		print("[PASS] Guardião-Cervo de Pedra (Boss Supremo) invocado e combatido no Santuário")

	if not bosses_spawned.has("lobo_alfa_de_lumen"):
		print("ERRO: O Lobo Alfa de Lúmen não foi invocado na Fase 4!")
		success = false
	else:
		print("[PASS] Lobo Alfa de Lúmen (Elite) devidamente combatido no Covil do Alfa (Fase 4)")

	# 5. Validar Mecânica de Recuo ao sofrer derrota na Party
	print("\n--- TESTANDO RECUO AO SER DERROTADO ---")
	ProgressionManager.current_stage = 3
	ProgressionManager.stage_kills = 3
	GameManager.active_enemy = {"id": "javali_de_musgo", "name": "Javali", "attack": 999}
	GameManager.party["bastiao"]["current_hp"] = 0.0
	GameManager.party["bastiao"]["is_alive"] = false
	GameManager.party["iris"]["current_hp"] = 0.0
	GameManager.party["iris"]["is_alive"] = false
	GameManager.party["flecha"]["current_hp"] = 0.0
	GameManager.party["flecha"]["is_alive"] = false

	GameManager._on_hero_defeated()

	if ProgressionManager.current_stage != 2:
		print("ERRO: Ao ser derrotada na Fase 3, a party deveria recuar para a Fase 2, mas está na Fase %d" % ProgressionManager.current_stage)
		success = false
	else:
		print("[PASS] Recuo gracioso validado: Derrota na Fase 3 recuou a equipe para a Fase 2 com regeneração")

	print("================================================================================")
	if success:
		print("=== GATE R14 HOMOLOGADO COM SUCESSO: PROGRESSÃO DE FASES PASS ===")
		print("================================================================================")
		get_tree().quit(0)
	else:
		print("=== GATE R14 FALHOU! VERIFIQUE OS ERROS ACIMA ===")
		print("================================================================================")
		get_tree().quit(1)
