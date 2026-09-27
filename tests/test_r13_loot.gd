extends Node

func _ready() -> void:
	print("================================================================================")
	print("--- TESTE R13: VALIDAÇÃO DE LOOT, EQUIPAMENTO E EFEITO DE COMBATE (GATE R13) ---")
	print("================================================================================")
	
	var success := true

	# 1. Validar Drop Table (15 itens, 3 slots, 4 raridades)
	LootManager.load_database()
	var db: Array = LootManager.items_database
	print("[INFO] Total de itens carregados no banco: %d" % db.size())
	if db.size() != 15:
		print("ERRO: Banco de itens deve conter exatamente 15 itens! Encontrados: %d" % db.size())
		success = false
	else:
		print("[PASS] Drop table contém exatamente 15 itens temáticos do Bosque de Lúmen")

	var slots_count := {"weapon": 0, "armor": 0, "amulet": 0}
	var rarities_count := {"Comum": 0, "Raro": 0, "Épico": 0, "Lendário": 0}

	for it in db:
		var s: String = it.get("slot", "")
		var r: String = it.get("rarity", "")
		if slots_count.has(s):
			slots_count[s] += 1
		else:
			print("ERRO: Slot desconhecido encontrado: ", s)
			success = false
		if rarities_count.has(r):
			rarities_count[r] += 1
		else:
			print("ERRO: Raridade desconhecida encontrada: ", r)
			success = false

	print("  -> Distribuição por Slot: Armas=%d, Armaduras=%d, Amuletos=%d" % [
		slots_count["weapon"], slots_count["armor"], slots_count["amulet"]
	])
	print("  -> Distribuição por Raridade: Comum=%d, Raro=%d, Épico=%d, Lendário=%d" % [
		rarities_count["Comum"], rarities_count["Raro"], rarities_count["Épico"], rarities_count["Lendário"]
	])

	if slots_count["weapon"] != 5 or slots_count["armor"] != 5 or slots_count["amulet"] != 5:
		print("ERRO: Distribuição esperada de 5 armas, 5 armaduras e 5 amuletos não foi atendida")
		success = false
	else:
		print("[PASS] Os 3 slots estão balanceados uniformemente com 5 itens cada")

	for r_name in rarities_count.keys():
		if rarities_count[r_name] == 0:
			print("ERRO: Raridade '%s' não está representada nos itens" % r_name)
			success = false
	if success:
		print("[PASS] As 4 raridades (Comum, Raro, Épico, Lendário) estão ativas e representadas")

	# 2. Validar Inventário e Comparação de Itens
	LootManager.inventory.clear()
	for it in db:
		LootManager.inventory.append(it.duplicate(true))
	
	if LootManager.inventory.size() != 15:
		print("ERRO: Inventário não pôde receber os 15 itens")
		success = false
	else:
		print("[PASS] Inventário preenchido com os 15 itens da drop table")

	var adaga = LootManager.get_item_by_id("adaga_de_luz")
	var cajado = LootManager.get_item_by_id("cajado_de_lumen")
	if LootManager.compare_items(cajado, adaga) != 1:
		print("ERRO: Comparação falhou! Cajado de Lúmen deveria superar Adaga de Luz")
		success = false
	else:
		print("[PASS] Comparação de itens funcional: Cajado de Lúmen (Lendário) > Adaga de Luz (Comum)")

	# 3. Validar Equipar Manual e Auto-Equipar Melhor
	LootManager.equipment = {"weapon": null, "armor": null, "amulet": null}
	var equipped_single := LootManager.equip_item(adaga)
	if not equipped_single or LootManager.equipment["weapon"]["id"] != "adaga_de_luz":
		print("ERRO: Falha ao equipar item individualmente")
		success = false
	else:
		print("[PASS] Equipar manual funcional (Arma: %s)" % LootManager.equipment["weapon"]["name"])

	# Testar Auto-Equipar o Melhor por Slot
	var best_count := LootManager.equip_best_items()
	var w = LootManager.equipment["weapon"]
	var a = LootManager.equipment["armor"]
	var am = LootManager.equipment["amulet"]

	if w == null or w.get("id") != "cajado_de_lumen":
		print("ERRO: Auto-equipar não escolheu a melhor arma (esperado cajado_de_lumen, obteve %s)" % (w.get("id") if w else "null"))
		success = false
	if a == null or a.get("id") != "armadura_do_guardiao":
		print("ERRO: Auto-equipar não escolheu a melhor armadura (esperado armadura_do_guardiao, obteve %s)" % (a.get("id") if a else "null"))
		success = false
	if am == null or am.get("id") != "coracao_da_floresta":
		print("ERRO: Auto-equipar não escolheu o melhor amuleto (esperado coracao_da_floresta, obteve %s)" % (am.get("id") if am else "null"))
		success = false

	if success:
		print("[PASS] Auto-equipar selecionou com sucesso o melhor item para cada um dos 3 slots:")
		print("  -> Melhor Arma: %s (%s, ATK +%d)" % [w.get("name"), w.get("rarity"), w.get("attack")])
		print("  -> Melhor Armadura: %s (%s, DEF +%d, HP +%d)" % [a.get("name"), a.get("rarity"), a.get("defense"), a.get("max_hp")])
		print("  -> Melhor Amuleto: %s (%s, Crit +%.0f%%, Lifesteal +%.0f%%)" % [am.get("name"), am.get("rarity"), am.get("crit") * 100, am.get("lifesteal") * 100])

	# 4. Cenário de Combate Controlado: Registrar antes/depois e demonstrar efeito coerente
	print("\n--- CENÁRIO CONTROLADO 1: EFEITO DA ARMA NO TTK E DANO DA PARTY ---")
	# Inimigo de teste: Lobo Alfa de Lúmen (HP 120, DEF 6, ATK 12)
	var test_enemy := {
		"id": "lobo_alfa_de_lumen",
		"name": "Lobo Alfa de Lúmen",
		"max_hp": 120,
		"defense": 6,
		"attack": 12,
		"boss": false
	}

	# A) Combate SEM arma equipada
	LootManager.equipment = {"weapon": null, "armor": null, "amulet": null}
	GameManager._init_party_stats()
	GameManager.active_enemy = test_enemy.duplicate(true)
	GameManager.active_enemy_hp = 120.0
	var atk_before := GameManager.get_total_hero_attack()

	var hits_no_weapon := 0
	while GameManager.active_enemy_hp > 0.0 and hits_no_weapon < 50:
		for hid in ["bastiao", "iris", "flecha"]:
			GameManager._hero_attack_from(hid)
			hits_no_weapon += 1
			if GameManager.active_enemy_hp <= 0.0:
				break

	print("  -> Antes (Sem Arma): ATK Total = %.1f | Golpes para derrotar 120 HP = %d golpes" % [atk_before, hits_no_weapon])

	# B) Combate COM Cajado de Lúmen (+18 ATK)
	LootManager.equipment["weapon"] = cajado
	GameManager._init_party_stats()
	GameManager.active_enemy = test_enemy.duplicate(true)
	GameManager.active_enemy_hp = 120.0
	var atk_after := GameManager.get_total_hero_attack()

	var hits_with_weapon := 0
	while GameManager.active_enemy_hp > 0.0 and hits_with_weapon < 50:
		for hid in ["bastiao", "iris", "flecha"]:
			GameManager._hero_attack_from(hid)
			hits_with_weapon += 1
			if GameManager.active_enemy_hp <= 0.0:
				break

	print("  -> Depois (Cajado de Lúmen): ATK Total = %.1f (+%.1f) | Golpes para derrotar 120 HP = %d golpes" % [
		atk_after, atk_after - atk_before, hits_with_weapon
	])

	if hits_with_weapon >= hits_no_weapon:
		print("ERRO: Arma não reduziu a quantidade de golpes necessários para matar o inimigo!")
		success = false
	else:
		var efficiency: float = (1.0 - float(hits_with_weapon) / float(hits_no_weapon)) * 100.0
		print("[PASS] Efeito de combate da arma comprovado: TTK/golpes reduzidos em %.1f%%!" % efficiency)

	print("\n--- CENÁRIO CONTROLADO 2: EFEITO DA ARMADURA NO DANO RECEBIDO E SOBREVIVÊNCIA ---")
	# Inimigo ataca Bastião (Tanque frontline)
	# A) Sem armadura
	LootManager.equipment["armor"] = null
	GameManager._init_party_stats()
	GameManager.active_enemy = test_enemy.duplicate(true)
	var hp_before_hit: float = GameManager.party["bastiao"]["current_hp"]
	var def_before := GameManager.get_hero_defense("bastiao")
	GameManager._enemy_attack()
	var dmg_taken_no_armor: float = hp_before_hit - GameManager.party["bastiao"]["current_hp"]
	print("  -> Antes (Sem Armadura): DEF Bastião = %.1f | Dano sofrido por golpe = %.1f" % [def_before, dmg_taken_no_armor])

	# B) Com Armadura do Guardião (+12 DEF, +90 HP)
	LootManager.equipment["armor"] = a
	GameManager._init_party_stats()
	GameManager.active_enemy = test_enemy.duplicate(true)
	hp_before_hit = GameManager.party["bastiao"]["current_hp"]
	var def_after := GameManager.get_hero_defense("bastiao")
	var max_hp_after := GameManager.get_hero_max_hp("bastiao")
	GameManager._enemy_attack()
	var dmg_taken_with_armor: float = hp_before_hit - GameManager.party["bastiao"]["current_hp"]
	print("  -> Depois (Armadura do Guardião): DEF Bastião = %.1f (+%.1f), Max HP = %.0f | Dano sofrido por golpe = %.1f" % [
		def_after, def_after - def_before, max_hp_after, dmg_taken_with_armor
	])

	if dmg_taken_with_armor >= dmg_taken_no_armor:
		print("ERRO: Armadura não reduziu o dano recebido!")
		success = false
	else:
		var dmg_reduction: float = (1.0 - dmg_taken_with_armor / dmg_taken_no_armor) * 100.0
		print("[PASS] Efeito de combate da armadura comprovado: dano recebido reduzido em %.1f%%!" % dmg_reduction)

	print("\n--- CENÁRIO CONTROLADO 3: EFEITO DO AMULETO (LIFESTEAL) NA REGENERAÇÃO ---")
	LootManager.equipment["amulet"] = am # Coração da Floresta: +6% lifesteal
	GameManager.party["bastiao"]["current_hp"] = 50.0 # Bastião ferido
	var hp_pre_heal: float = GameManager.party["bastiao"]["current_hp"]
	GameManager.active_enemy = test_enemy.duplicate(true)
	GameManager.active_enemy_hp = 100.0
	GameManager._hero_attack_from("bastiao")
	var hp_post_heal: float = GameManager.party["bastiao"]["current_hp"]
	print("  -> Lifesteal ativo: HP pré-ataque = %.1f, HP pós-ataque = %.1f (Cura = +%.2f HP)" % [
		hp_pre_heal, hp_post_heal, hp_post_heal - hp_pre_heal
	])
	if hp_post_heal <= hp_pre_heal:
		print("ERRO: Lifesteal não curou o herói ferido durante o ataque!")
		success = false
	else:
		print("[PASS] Efeito de combate do amuleto comprovado: lifesteal regenerou HP ativamente!")

	# Registrar observação metodológica mandatória:
	print("[NOTA METODOLÓGICA] Atributos e progressão demonstrados com efeito comprovado em combate controlado. Números não declarados balanceados sem telemetria e playtests reais.")

	print("================================================================================")
	if success:
		print("=== GATE R13 HOMOLOGADO COM SUCESSO: LOOT E EQUIPAMENTO PASS ===")
		print("================================================================================")
		get_tree().quit(0)
	else:
		print("=== GATE R13 FALHOU! VERIFIQUE OS ERROS ACIMA ===")
		print("================================================================================")
		get_tree().quit(1)
