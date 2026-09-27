extends Node

## TestHooks: Hooks internos controlados para o Argos e testes automatizados.
## Somente operam quando DevMode estiver ativo.

func set_level(target_level: int) -> bool:
	if not DevMode.is_enabled:
		return false
	ProgressionManager.level = maxi(1, target_level)
	ProgressionManager.xp = 0
	ProgressionManager.xp_next = 50 * ProgressionManager.level
	return true

func give_gold(amount: int) -> bool:
	if not DevMode.is_enabled:
		return false
	ProgressionManager.add_gold(amount)
	return true

func spawn_enemy_by_id(enemy_id: String) -> bool:
	if not DevMode.is_enabled:
		return false
	for enemy in GameManager.enemies_database:
		if enemy.get("id", "") == enemy_id:
			GameManager.active_enemy = enemy.duplicate(true)
			GameManager.active_enemy_hp = float(enemy.get("max_hp", 30))
			GameManager.battle_started.emit(GameManager.active_enemy)
			return true
	return false

func simulate_offline_time(seconds: float) -> Dictionary:
	if not DevMode.is_enabled:
		return {}
	# Simulação rápida determinística de progresso offline
	var xp_rate := 15.0 # XP por segundo base
	var gold_rate := 4.0 # Ouro por segundo base
	var earned_xp := int(seconds * xp_rate)
	var earned_gold := int(seconds * gold_rate)
	ProgressionManager.add_xp(earned_xp)
	ProgressionManager.add_gold(earned_gold)
	return {"simulated_seconds": seconds, "earned_xp": earned_xp, "earned_gold": earned_gold}

func reset_player_state() -> bool:
	if not DevMode.is_enabled:
		return false
	ProgressionManager.level = 1
	ProgressionManager.xp = 0
	ProgressionManager.xp_next = 50
	ProgressionManager.gold = 0
	ProgressionManager.current_stage = 1
	LootManager.equipment = {"weapon": null, "armor": null, "amulet": null}
	LootManager.inventory.clear()
	GameManager.hero_current_hp = GameManager.get_total_hero_max_hp()
	return true
