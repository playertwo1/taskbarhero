extends Node

func _ready() -> void:
	print("================================================================================")
	print("--- TESTE R10: PROVA DO LOOP AUTÔNOMO DE COMBATE (5 CICLOS) E PERSISTÊNCIA ---")
	print("================================================================================")
	
	var pass_all: bool = true
	
	# Reset do save para início de teste limpo
	SaveManager.delete_save()
	
	# Forçar reinicialização dos managers
	ProgressionManager.level = 1
	ProgressionManager.xp = 0
	ProgressionManager.xp_next = 50
	ProgressionManager.gold = 0
	ProgressionManager.current_stage = 1
	
	LootManager.equipment = {"weapon": null, "armor": null, "amulet": null}
	LootManager.inventory.clear()
	
	GameManager.hero_current_hp = GameManager.get_total_hero_max_hp()
	GameManager.active_enemy = {}
	GameManager.respawn_cd = 0.0
	GameManager.is_paused = false
	
	# Registrar primeiro spawn
	GameManager.start_combat()
	
	print("[INFO] Combate iniciado. Herói: Bastião (HP: %.0f, ATK: %.1f, DEF: %.1f)" % [
		GameManager.hero_current_hp,
		GameManager.get_total_hero_attack(),
		GameManager.get_total_hero_defense()
	])
	
	var cycle_records: Array = []
	var total_cycles_target: int = 5
	var completed_cycles: int = 0
	
	var cycle_start_time: int = Time.get_ticks_msec()
	var hero_hits: int = 0
	var enemy_hits: int = 0
	
	# Simular ticks de física/processo até completar 5 ciclos
	var max_simulated_seconds: float = 60.0
	var dt: float = 0.05
	var elapsed: float = 0.0
	
	while completed_cycles < total_cycles_target and elapsed < max_simulated_seconds:
		var enemy_before_tick: Dictionary = GameManager.active_enemy.duplicate(true)
		var enemy_hp_before: float = GameManager.active_enemy_hp
		var hero_hp_before: float = GameManager.hero_current_hp
		
		# Avança o loop do GameManager
		GameManager._process(dt)
		elapsed += dt
		
		if not GameManager.active_enemy.is_empty():
			if GameManager.active_enemy_hp < enemy_hp_before:
				hero_hits += 1
			if GameManager.hero_current_hp < hero_hp_before:
				enemy_hits += 1
		else:
			# Inimigo acabou de morrer neste ciclo
			if not enemy_before_tick.is_empty():
				completed_cycles += 1
				var cycle_duration_s: float = float(Time.get_ticks_msec() - cycle_start_time) / 1000.0
				
				var rec: Dictionary = {
					"ciclo": completed_cycles,
					"inimigo": enemy_before_tick.get("name", "Inimigo"),
					"duracao_segundos": cycle_duration_s,
					"golpes_heroi": hero_hits,
					"golpes_inimigo": enemy_hits,
					"xp_total": ProgressionManager.xp,
					"nivel": ProgressionManager.level,
					"ouro_total": ProgressionManager.gold,
					"mochila_itens": LootManager.inventory.size()
				}
				cycle_records.append(rec)
				
				print("[CICLO %d CONCLUÍDO] Derrotou '%s' em %.2fs | Golpes Herói: %d, Golpes Inimigo: %d | XP: %d/Nvl %d | Ouro: %d | Itens: %d" % [
					rec["ciclo"], rec["inimigo"], rec["duracao_segundos"],
					rec["golpes_heroi"], rec["golpes_inimigo"],
					rec["xp_total"], rec["nivel"], rec["ouro_total"], rec["mochila_itens"]
				])
				
				# Tenta auto-equipar melhor item se dropou algo
				var equipped_count: int = LootManager.equip_best_items()
				if equipped_count > 0:
					print("  -> Auto-equipamento: %d item(s) equipados! Novos stats: ATK %.1f, DEF %.1f, MAX_HP %.0f" % [
						equipped_count,
						GameManager.get_total_hero_attack(),
						GameManager.get_total_hero_defense(),
						GameManager.get_total_hero_max_hp()
					])
				
				# Prepara próximo ciclo
				cycle_start_time = Time.get_ticks_msec()
				hero_hits = 0
				enemy_hits = 0
	
	if completed_cycles < total_cycles_target:
		print("ERRO: Apenas %d ciclos completados dentro do limite de tempo." % completed_cycles)
		pass_all = false
	else:
		print("[PASS] Meta de %d ciclos autônomos atingida com sucesso!" % total_cycles_target)
		
	# 2. Validar persistência Save/Load
	print("\n--- TESTANDO PERSISTÊNCIA (SAVE / LOAD) ---")
	GameManager.save_full_state()
	
	if not SaveManager.has_save():
		print("ERRO: Arquivo de save não foi gerado no disco.")
		pass_all = false
	else:
		print("[PASS] Arquivo de save gerado com sucesso em user://")
		
	var saved_level: int = ProgressionManager.level
	var saved_xp: int = ProgressionManager.xp
	var saved_gold: int = ProgressionManager.gold
	var saved_inv_size: int = LootManager.inventory.size()
	
	# Reset em memória
	ProgressionManager.level = 999
	ProgressionManager.xp = 0
	ProgressionManager.gold = 0
	LootManager.inventory.clear()
	
	# Recarregar do arquivo
	GameManager.load_full_state()
	
	if ProgressionManager.level != saved_level or ProgressionManager.xp != saved_xp or ProgressionManager.gold != saved_gold:
		print("ERRO: Dados de progressão recarregados não coincidem com o salvo!")
		pass_all = false
	elif LootManager.inventory.size() != saved_inv_size:
		print("ERRO: Tamanho do inventário recarregado (%d) diverge do salvo (%d)" % [LootManager.inventory.size(), saved_inv_size])
		pass_all = false
	else:
		print("[PASS] Persistência confirmada: Level %d, XP %d, Ouro %d, Itens %d recarregados com perfeição!" % [
			ProgressionManager.level, ProgressionManager.xp, ProgressionManager.gold, LootManager.inventory.size()
		])
	
	# 3. Validar instância da cena de combate integrada com UI e BattleStrip
	print("\n--- TESTANDO INTEGRAÇÃO DA CENA PRINCIPAL COM BATTLESTRIP ---")
	var main_scene: PackedScene = load("res://scenes/main/Main.tscn")
	if not main_scene:
		print("ERRO: Não foi possível carregar Main.tscn")
		pass_all = false
	else:
		var main_node: Node = main_scene.instantiate()
		add_child(main_node)
		
		var bs: Control = main_node.get_node_or_null("Root/Content/BattleStrip") as Control
		if not bs:
			print("ERRO: BattleStrip ausente na cena principal")
			pass_all = false
		else:
			print("[PASS] BattleStrip encontrado e operacional na árvore de nós")
			# Validar visual animado do Herói Bastião
			if bs.hero_visual == null or not bs.hero_visual.visible:
				print("ERRO: Visual animado de Bastião não foi ativado no BattleStrip")
				pass_all = false
			else:
				print("[PASS] Visual animado de Bastião ativado e visível no BattleStrip")

			# Simula forçar a Geleia de Lúmen no strip
			bs.set_enemy({"id": "geleia_de_lumen", "name": "Geleia de Lúmen", "boss": false})
			if bs.enemy_visual == null or not bs.enemy_visual.visible:
				print("ERRO: Visual animado da Geleia de Lúmen não foi ativado no BattleStrip")
				pass_all = false
			else:
				print("[PASS] Visual animado da Geleia de Lúmen ativado e visível no BattleStrip")
				bs.flash_hero_attack()
				bs.flash_enemy_attack()
				bs.play_enemy_death()
				bs.play_hero_death()
				bs.reset_hero()
				print("[PASS] Disparadores de animação (hit, attack, death, reset) para herói e inimigo acionados sem erros")
				
		main_node.free()
	
	print("\n================================================================================")
	if pass_all:
		print("=== GATE R10 HOMOLOGADO COM SUCESSO: LOOP AUTÔNOMO E PERSISTÊNCIA PASS ===")
		print("================================================================================")
		get_tree().quit(0)
	else:
		print("=== GATE R10 FALHOU ===")
		print("================================================================================")
		get_tree().quit(1)
