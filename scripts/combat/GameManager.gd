extends Node

signal battle_started(enemy: Dictionary)
signal battle_ended(victory: bool, enemy: Dictionary)
signal hero_damaged(amount: float, current_hp: float, max_hp: float)
signal enemy_damaged(amount: float, current_hp: float, max_hp: float, is_crit: bool)
signal battle_log(text: String)

const ENEMIES_DATA_PATH := "res://data/enemies/enemies.json"

var enemies_database: Array = []
var active_enemy: Dictionary = {}
var active_enemy_hp: float = 0.0

var hero_base_hp: float = 100.0
var hero_base_attack: float = 10.0
var hero_base_defense: float = 2.0
var hero_current_hp: float = 100.0

var hero_attack_cd: float = 0.0
var enemy_attack_cd: float = 0.0
var respawn_cd: float = 0.0
var autosave_timer: float = 0.0
var enemy_spawn_time_msec: int = 0

var is_paused: bool = false
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	load_enemies_database()

func load_enemies_database() -> void:
	if not FileAccess.file_exists(ENEMIES_DATA_PATH):
		push_warning("GameManager: Inimigos não encontrados em %s" % ENEMIES_DATA_PATH)
		return
	var file := FileAccess.open(ENEMIES_DATA_PATH, FileAccess.READ)
	if file != null:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			enemies_database = parsed

func start_combat() -> void:
	if enemies_database.is_empty():
		return
	spawn_next_enemy()

func _process(delta: float) -> void:
	if is_paused:
		return

	if active_enemy.is_empty():
		respawn_cd -= delta
		if respawn_cd <= 0.0:
			spawn_next_enemy()
		return

	hero_attack_cd -= delta
	enemy_attack_cd -= delta
	autosave_timer -= delta

	if hero_attack_cd <= 0.0:
		hero_attack_cd = 0.75
		_hero_attack()

	if not active_enemy.is_empty() and enemy_attack_cd <= 0.0:
		enemy_attack_cd = 1.10 if not active_enemy.get("boss", false) else 0.85
		_enemy_attack()

	if autosave_timer <= 0.0:
		autosave_timer = 15.0
		save_full_state()

func spawn_next_enemy() -> void:
	if enemies_database.is_empty():
		return
	var total_w := 0
	for e in enemies_database:
		total_w += int(e.get("weight", 10))
	var roll := rng.randi_range(1, total_w)
	var curr := 0
	for e in enemies_database:
		curr += int(e.get("weight", 10))
		if roll <= curr:
			active_enemy = e.duplicate(true)
			active_enemy_hp = float(active_enemy.get("max_hp", 30))
			enemy_spawn_time_msec = Time.get_ticks_msec()
			battle_started.emit(active_enemy)
			battle_log.emit("Um %s apareceu!" % active_enemy.get("name", "Inimigo"))
			break

func _hero_attack() -> void:
	var total_atk := get_total_hero_attack()
	var enemy_def := float(active_enemy.get("defense", 0))
	var base_dmg := maxf(1.0, total_atk - enemy_def)
	var crit_chance := get_total_hero_crit()
	var is_crit := rng.randf() < crit_chance
	var final_dmg := base_dmg * (2.0 if is_crit else 1.0)

	active_enemy_hp -= final_dmg
	enemy_damaged.emit(final_dmg, active_enemy_hp, float(active_enemy.get("max_hp", 30)), is_crit)

	var lifesteal := get_total_hero_lifesteal()
	if lifesteal > 0.0:
		var heal := final_dmg * lifesteal
		hero_current_hp = minf(get_total_hero_max_hp(), hero_current_hp + heal)

	if active_enemy_hp <= 0.0:
		_on_enemy_defeated()

func _enemy_attack() -> void:
	var enemy_atk := float(active_enemy.get("attack", 3))
	var hero_def := get_total_hero_defense()
	var dmg := maxf(1.0, enemy_atk - hero_def)

	hero_current_hp -= dmg
	hero_damaged.emit(dmg, hero_current_hp, get_total_hero_max_hp())

	if hero_current_hp <= 0.0:
		_on_hero_defeated()

func _on_enemy_defeated() -> void:
	var defeated_enemy := active_enemy
	active_enemy = {}
	respawn_cd = 0.60

	var xp_reward := int(defeated_enemy.get("xp", 10))
	ProgressionManager.add_xp(xp_reward)

	var g_min := int(defeated_enemy.get("gold_min", 1))
	var g_max := int(defeated_enemy.get("gold_max", 5))
	var gold_reward := rng.randi_range(g_min, g_max)
	ProgressionManager.add_gold(gold_reward)

	var dropped_item = LootManager.roll_drop(defeated_enemy.get("boss", false))

	var ttk := float(Time.get_ticks_msec() - enemy_spawn_time_msec) / 1000.0
	Telemetry.record_kill(defeated_enemy.get("id", ""), ttk, xp_reward, gold_reward)

	battle_ended.emit(true, defeated_enemy)
	var msg := "%s derrotado! +%d XP, +%d Ouro" % [defeated_enemy.get("name", "Inimigo"), xp_reward, gold_reward]
	if dropped_item != null:
		msg += " | Drop: %s" % dropped_item.get("name", "Item")
	battle_log.emit(msg)

func _on_hero_defeated() -> void:
	var enemy_that_killed := active_enemy
	active_enemy = {}
	respawn_cd = 2.0
	hero_current_hp = get_total_hero_max_hp() * 0.50
	Telemetry.record_hero_death(enemy_that_killed.get("id", ""))
	battle_ended.emit(false, enemy_that_killed)
	battle_log.emit("O grupo recuou para recuperar forças...")

func get_total_hero_attack() -> float:
	var val := hero_base_attack + (ProgressionManager.level - 1) * 2.0
	var weapon = LootManager.equipment.get("weapon")
	if weapon != null:
		val += float(weapon.get("attack", 0))
	return val

func get_total_hero_defense() -> float:
	var val := hero_base_defense + (ProgressionManager.level - 1) * 0.8
	var armor = LootManager.equipment.get("armor")
	if armor != null:
		val += float(armor.get("defense", 0))
	return val

func get_total_hero_max_hp() -> float:
	var val := hero_base_hp + (ProgressionManager.level - 1) * 15.0
	var armor = LootManager.equipment.get("armor")
	if armor != null:
		val += float(armor.get("max_hp", 0))
	return val

func get_total_hero_crit() -> float:
	var val := 0.05
	var amulet = LootManager.equipment.get("amulet")
	if amulet != null:
		val += float(amulet.get("crit", 0.0))
	return val

func get_total_hero_lifesteal() -> float:
	var val := 0.0
	var amulet = LootManager.equipment.get("amulet")
	if amulet != null:
		val += float(amulet.get("lifesteal", 0.0))
	return val

func save_full_state() -> void:
	var full_state := {
		"progression": ProgressionManager.get_state(),
		"loot": LootManager.get_state(),
		"hero_current_hp": hero_current_hp
	}
	SaveManager.save_game(full_state)

func load_full_state() -> void:
	var loaded := SaveManager.load_game()
	if not loaded.is_empty():
		if loaded.has("progression"):
			ProgressionManager.load_state(loaded["progression"])
		if loaded.has("loot"):
			LootManager.load_state(loaded["loot"])
		hero_current_hp = loaded.get("hero_current_hp", get_total_hero_max_hp())
