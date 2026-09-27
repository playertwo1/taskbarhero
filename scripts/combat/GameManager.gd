extends Node

signal battle_started(enemy: Dictionary)
signal battle_ended(victory: bool, enemy: Dictionary)
signal hero_damaged(amount: float, current_hp: float, max_hp: float)
signal enemy_damaged(amount: float, current_hp: float, max_hp: float, is_crit: bool)
signal battle_log(text: String)

signal party_hero_attacked(hero_id: String)
signal party_hero_damaged(hero_id: String, amount: float, current_hp: float, max_hp: float)
signal party_hero_died(hero_id: String)
signal party_hero_revived(hero_id: String)

const ENEMIES_DATA_PATH := "res://data/enemies/enemies.json"

var enemies_database: Array = []
var active_enemy: Dictionary = {}
var active_enemy_hp: float = 0.0

# Party de 3 heróis: Bastião (Front), Íris (Mid), Flecha (Back)
var party: Dictionary = {
	"bastiao": {
		"id": "bastiao",
		"name": "Bastião",
		"role": "tank",
		"slot": "front",
		"base_hp": 130.0,
		"current_hp": 130.0,
		"base_attack": 8.0,
		"base_defense": 4.0,
		"attack_cd": 0.0,
		"cd_interval": 0.90,
		"attack_range": 200.0,
		"crit_rate": 0.05,
		"is_alive": true
	},
	"iris": {
		"id": "iris",
		"name": "Íris",
		"role": "mage",
		"slot": "mid",
		"base_hp": 75.0,
		"current_hp": 75.0,
		"base_attack": 14.0,
		"base_defense": 1.0,
		"attack_cd": 0.35,
		"cd_interval": 1.15,
		"attack_range": 300.0,
		"crit_rate": 0.08,
		"is_alive": true
	},
	"flecha": {
		"id": "flecha",
		"name": "Flecha",
		"role": "archer",
		"slot": "back",
		"base_hp": 85.0,
		"current_hp": 85.0,
		"base_attack": 11.0,
		"base_defense": 2.0,
		"attack_cd": 0.65,
		"cd_interval": 0.75,
		"attack_range": 400.0,
		"crit_rate": 0.15,
		"is_alive": true
	}
}

var formation_slots: Dictionary = {
	"front": "bastiao",
	"mid": "iris",
	"back": "flecha"
}

var hero_base_hp: float = 100.0
var hero_base_attack: float = 10.0
var hero_base_defense: float = 2.0

var hero_current_hp: float:
	get:
		var total := 0.0
		for h in party.values():
			total += h["current_hp"]
		return total
	set(val):
		# Compatibilidade retroativa para scripts/testes que alteram HP diretamente
		var total_max := get_total_hero_max_hp()
		if total_max > 0.0:
			var ratio := clampf(val / total_max, 0.0, 1.0)
			for hid in party.keys():
				party[hid]["current_hp"] = get_hero_max_hp(hid) * ratio
				party[hid]["is_alive"] = (party[hid]["current_hp"] > 0.0)
		elif party.has("bastiao"):
			party["bastiao"]["current_hp"] = val
			party["bastiao"]["is_alive"] = (val > 0.0)

var hero_attack_cd: float = 0.0
var enemy_attack_cd: float = 0.0
var respawn_cd: float = 0.0
var autosave_timer: float = 0.0
var enemy_spawn_time_msec: int = 0

var is_paused: bool = false
var rng := RandomNumberGenerator.new()
var queued_boss_id: String = ""

func _ready() -> void:
	rng.randomize()
	load_enemies_database()
	_init_party_stats()
	ProgressionManager.boss_spawn_ready.connect(_on_boss_spawn_ready)

func _on_boss_spawn_ready(boss_id: String) -> void:
	queued_boss_id = boss_id
	battle_log.emit("O líder do território se aproxima!")

func _init_party_stats() -> void:
	for hid in party.keys():
		party[hid]["current_hp"] = get_hero_max_hp(hid)
		party[hid]["is_alive"] = true

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

	# Cooldowns individuais simples de ataque para cada herói vivo da party
	for hero_id in ["bastiao", "iris", "flecha"]:
		var h: Dictionary = party[hero_id]
		if not h["is_alive"]:
			continue
		h["attack_cd"] -= delta
		if h["attack_cd"] <= 0.0:
			h["attack_cd"] = h["cd_interval"]
			_hero_attack_from(hero_id)
			if active_enemy.is_empty():
				break

	# Cooldown de ataque do inimigo
	enemy_attack_cd -= delta
	autosave_timer -= delta

	if not active_enemy.is_empty() and enemy_attack_cd <= 0.0:
		enemy_attack_cd = 1.10 if not active_enemy.get("boss", false) else 0.85
		_enemy_attack()

	if autosave_timer <= 0.0:
		autosave_timer = 15.0
		save_full_state()

func spawn_next_enemy() -> void:
	if enemies_database.is_empty():
		return

	var chosen_enemy: Dictionary = {}

	if queued_boss_id != "":
		for e in enemies_database:
			if e.get("id", "") == queued_boss_id:
				chosen_enemy = e.duplicate(true)
				break
		queued_boss_id = ""

	if chosen_enemy.is_empty():
		var st := ProgressionManager.get_current_stage_data()
		var pool: Array = st.get("enemy_pool", [])
		if not pool.is_empty():
			var total_pool_w := 0
			for entry in pool:
				total_pool_w += int(entry.get("weight", 10))
			var roll := rng.randi_range(1, total_pool_w)
			var cur := 0
			var target_id := ""
			for entry in pool:
				cur += int(entry.get("weight", 10))
				if roll <= cur:
					target_id = entry.get("id", "")
					break
			for e in enemies_database:
				if e.get("id", "") == target_id:
					chosen_enemy = e.duplicate(true)
					break

	# Fallback para roll global caso nada tenha sido selecionado
	if chosen_enemy.is_empty():
		var total_w := 0
		for e in enemies_database:
			total_w += int(e.get("weight", 10))
		var roll := rng.randi_range(1, total_w)
		var curr := 0
		for e in enemies_database:
			curr += int(e.get("weight", 10))
			if roll <= curr:
				chosen_enemy = e.duplicate(true)
				break

	if not chosen_enemy.is_empty():
		active_enemy = chosen_enemy
		active_enemy_hp = float(active_enemy.get("max_hp", 30))
		enemy_spawn_time_msec = Time.get_ticks_msec()
		battle_started.emit(active_enemy)
		battle_log.emit("Um %s apareceu!" % active_enemy.get("name", "Inimigo"))

func _hero_attack_from(hero_id: String) -> void:
	if active_enemy.is_empty():
		return
	var h: Dictionary = party[hero_id]
	var total_atk := get_hero_attack(hero_id)
	var enemy_def := float(active_enemy.get("defense", 0))
	var base_dmg := maxf(1.0, total_atk - enemy_def)
	var crit_chance := get_hero_crit(hero_id)
	var is_crit := rng.randf() < crit_chance
	var final_dmg := base_dmg * (2.0 if is_crit else 1.0)

	active_enemy_hp -= final_dmg
	party_hero_attacked.emit(hero_id)
	enemy_damaged.emit(final_dmg, active_enemy_hp, float(active_enemy.get("max_hp", 30)), is_crit)

	var lifesteal := get_total_hero_lifesteal()
	if lifesteal > 0.0:
		var heal := final_dmg * lifesteal
		h["current_hp"] = minf(get_hero_max_hp(hero_id), h["current_hp"] + heal)

	if active_enemy_hp <= 0.0:
		_on_enemy_defeated()

func _hero_attack() -> void:
	# Wrapper para manter compatibilidade com chamadas legado
	_hero_attack_from("bastiao")

func _get_enemy_target() -> String:
	# Targeting baseado na ordem de formação: front (Bastião) -> mid (Íris) -> back (Flecha)
	var front_id: String = formation_slots.get("front", "bastiao")
	if party.has(front_id) and party[front_id]["is_alive"]:
		return front_id

	var mid_id: String = formation_slots.get("mid", "iris")
	if party.has(mid_id) and party[mid_id]["is_alive"]:
		return mid_id

	var back_id: String = formation_slots.get("back", "flecha")
	if party.has(back_id) and party[back_id]["is_alive"]:
		return back_id

	return ""

func _enemy_attack() -> void:
	var target_id := _get_enemy_target()
	if target_id == "":
		_on_hero_defeated()
		return

	var enemy_atk := float(active_enemy.get("attack", 3))
	var target_def := get_hero_defense(target_id)
	var dmg := maxf(1.0, enemy_atk - target_def)

	var th: Dictionary = party[target_id]
	th["current_hp"] -= dmg
	var th_max := get_hero_max_hp(target_id)

	party_hero_damaged.emit(target_id, dmg, th["current_hp"], th_max)
	hero_damaged.emit(dmg, hero_current_hp, get_total_hero_max_hp())

	if th["current_hp"] <= 0.0:
		th["current_hp"] = 0.0
		th["is_alive"] = false
		party_hero_died.emit(target_id)
		battle_log.emit("%s caiu em combate!" % th["name"])

	if not is_party_alive():
		_on_hero_defeated()

func is_party_alive() -> bool:
	for h in party.values():
		if h["is_alive"]:
			return true
	return false

func _on_enemy_defeated() -> void:
	var defeated_enemy := active_enemy
	active_enemy = {}
	respawn_cd = 0.60

	# Revive heróis caídos com regeneração de campo
	for hid in party.keys():
		if not party[hid]["is_alive"]:
			party[hid]["is_alive"] = true
			party[hid]["current_hp"] = get_hero_max_hp(hid) * 0.40
			party_hero_revived.emit(hid)

	var xp_reward := int(defeated_enemy.get("xp", 10))
	ProgressionManager.add_xp(xp_reward)

	var g_min := int(defeated_enemy.get("gold_min", 1))
	var g_max := int(defeated_enemy.get("gold_max", 5))
	var gold_reward := rng.randi_range(g_min, g_max)
	ProgressionManager.add_gold(gold_reward)

	var dropped_item = LootManager.roll_drop(defeated_enemy.get("boss", false))

	var ttk := float(Time.get_ticks_msec() - enemy_spawn_time_msec) / 1000.0
	Telemetry.record_kill(defeated_enemy.get("id", ""), ttk, xp_reward, gold_reward)

	var is_boss: bool = defeated_enemy.get("boss", false) or defeated_enemy.get("elite", false)
	ProgressionManager.record_kill(is_boss)

	battle_ended.emit(true, defeated_enemy)
	var msg := "%s derrotado! +%d XP, +%d Ouro" % [defeated_enemy.get("name", "Inimigo"), xp_reward, gold_reward]
	if dropped_item != null:
		msg += " | Drop: %s" % dropped_item.get("name", "Item")
	battle_log.emit(msg)

func _on_hero_defeated() -> void:
	var enemy_that_killed := active_enemy
	active_enemy = {}
	respawn_cd = 2.0
	queued_boss_id = ""
	ProgressionManager.retreat_stage()

	# Restaura a party a 50% de HP para recuo
	for hid in party.keys():
		party[hid]["is_alive"] = true
		party[hid]["current_hp"] = get_hero_max_hp(hid) * 0.50
		party_hero_revived.emit(hid)

	Telemetry.record_hero_death(enemy_that_killed.get("id", ""))
	battle_ended.emit(false, enemy_that_killed)
	battle_log.emit("A equipe recuou para recuperar forças...")

func get_hero_attack(hero_id: String) -> float:
	var h: Dictionary = party.get(hero_id, {})
	if h.is_empty():
		return 10.0
	var val: float = h["base_attack"] + (ProgressionManager.level - 1) * 1.5
	var weapon = LootManager.equipment.get("weapon")
	if weapon != null:
		val += float(weapon.get("attack", 0)) * 0.50
	return val

func get_hero_defense(hero_id: String) -> float:
	var h: Dictionary = party.get(hero_id, {})
	if h.is_empty():
		return 2.0
	var val: float = h["base_defense"] + (ProgressionManager.level - 1) * 0.5
	var armor = LootManager.equipment.get("armor")
	if armor != null:
		val += float(armor.get("defense", 0)) * 0.50
	return val

func get_hero_max_hp(hero_id: String) -> float:
	var h: Dictionary = party.get(hero_id, {})
	if h.is_empty():
		return 100.0
	var val: float = h["base_hp"] + (ProgressionManager.level - 1) * 10.0
	var armor = LootManager.equipment.get("armor")
	if armor != null:
		val += float(armor.get("max_hp", 0)) * 0.33
	return val

func get_hero_crit(hero_id: String) -> float:
	var h: Dictionary = party.get(hero_id, {})
	var val: float = h.get("crit_rate", 0.05) if not h.is_empty() else 0.05
	var amulet = LootManager.equipment.get("amulet")
	if amulet != null:
		val += float(amulet.get("crit", 0.0))
	return val

func get_total_hero_attack() -> float:
	var total := 0.0
	for hid in party.keys():
		if party[hid]["is_alive"]:
			total += get_hero_attack(hid)
	return total

func get_total_hero_defense() -> float:
	var target_id := _get_enemy_target()
	if target_id != "":
		return get_hero_defense(target_id)
	return get_hero_defense("bastiao")

func get_total_hero_max_hp() -> float:
	var total := 0.0
	for hid in party.keys():
		total += get_hero_max_hp(hid)
	return total

func get_total_hero_crit() -> float:
	return get_hero_crit("flecha")

func get_total_hero_lifesteal() -> float:
	var val := 0.0
	var amulet = LootManager.equipment.get("amulet")
	if amulet != null:
		val += float(amulet.get("lifesteal", 0.0))
	return val

func save_full_state() -> void:
	var party_hps := {}
	for hid in party.keys():
		party_hps[hid] = party[hid]["current_hp"]

	var full_state := {
		"progression": ProgressionManager.get_state(),
		"loot": LootManager.get_state(),
		"hero_current_hp": hero_current_hp,
		"party_hps": party_hps,
		"formation_slots": formation_slots,
		"saved_at_unix": int(Time.get_unix_time_from_system())
	}
	SaveManager.save_game(full_state)

func load_full_state() -> Dictionary:
	var loaded := SaveManager.load_game()
	var offline_data := {}
	if not loaded.is_empty():
		if loaded.has("progression"):
			ProgressionManager.load_state(loaded["progression"])
		if loaded.has("loot"):
			LootManager.load_state(loaded["loot"])
		if loaded.has("formation_slots"):
			formation_slots = loaded["formation_slots"]
		if loaded.has("party_hps"):
			var hps: Dictionary = loaded["party_hps"]
			for hid in hps.keys():
				if party.has(hid):
					party[hid]["current_hp"] = float(hps[hid])
					party[hid]["is_alive"] = (party[hid]["current_hp"] > 0.0)
		elif loaded.has("hero_current_hp"):
			self.hero_current_hp = loaded["hero_current_hp"]

		if loaded.has("saved_at_unix"):
			var last_unix: int = int(loaded["saved_at_unix"])
			offline_data = ProgressionManager.calculate_offline_progress(last_unix)
			if not offline_data.is_empty():
				ProgressionManager.apply_offline_progress(offline_data)
	return offline_data
