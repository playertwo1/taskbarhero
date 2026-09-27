extends Node

signal level_up(new_level: int)
signal xp_gained(amount: int, current_xp: int, next_xp: int)
signal gold_changed(new_gold: int, delta: int)
signal stage_changed(stage_index: int, stage_name: String)
signal stage_progress_updated(current_kills: int, target_kills: int)
signal boss_spawn_ready(boss_id: String)
signal offline_progress_calculated(data: Dictionary)

const STAGES_DATA_PATH := "res://data/stages/stages.json"

var level: int = 1
var xp: int = 0
var xp_next: int = 30
var gold: int = 0
var current_stage: int = 1
var max_stage_reached: int = 1
var stage_kills: int = 0
var stages_database: Array = []
var pending_offline_data: Dictionary = {}

func _ready() -> void:
	xp_next = get_xp_for_level(level)
	load_stages_database()

func load_stages_database() -> void:
	if not FileAccess.file_exists(STAGES_DATA_PATH):
		push_warning("ProgressionManager: Arquivo de estágios não encontrado em %s" % STAGES_DATA_PATH)
		return
	var file := FileAccess.open(STAGES_DATA_PATH, FileAccess.READ)
	if file != null:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			stages_database = parsed

func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	xp += amount
	xp_gained.emit(amount, xp, xp_next)
	while xp >= xp_next:
		xp -= xp_next
		level += 1
		xp_next = get_xp_for_level(level)
		level_up.emit(level)

func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold, amount)

func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold, -amount)
		return true
	return false

func get_xp_for_level(lvl: int) -> int:
	return int(round(25.0 * pow(1.15, lvl - 1) + 5.0 * lvl))

func get_current_stage_data() -> Dictionary:
	for st in stages_database:
		if int(st.get("stage", 1)) == current_stage:
			return st
	if not stages_database.is_empty():
		return stages_database[0]
	return {
		"stage": current_stage,
		"name": "Fase %d" % current_stage,
		"kills_to_advance": 5,
		"spawn_rate": 0.60,
		"enemy_pool": [],
		"boss_id": null
	}

func record_kill(is_boss: bool = false) -> void:
	var st := get_current_stage_data()
	var target_kills: int = int(st.get("kills_to_advance", 5))

	if is_boss:
		# Se derrotou o chefe ou elite da fase
		if current_stage < 5:
			advance_stage()
		else:
			# Chefe supremo Guardião-Cervo de Pedra derrotado!
			stage_kills = 0
			stage_changed.emit(current_stage, "Bosque de Lúmen Conquistado! (Farm Ativo)")
		return

	stage_kills += 1
	stage_progress_updated.emit(stage_kills, target_kills)

	if stage_kills >= target_kills:
		var boss_id = st.get("boss_id")
		if boss_id != null and str(boss_id) != "":
			boss_spawn_ready.emit(str(boss_id))
		else:
			advance_stage()

func advance_stage() -> void:
	stage_kills = 0
	current_stage = mini(5, current_stage + 1)
	if current_stage > max_stage_reached:
		max_stage_reached = current_stage
	var st := get_current_stage_data()
	stage_changed.emit(current_stage, st.get("name", "Fase %d" % current_stage))

func retreat_stage() -> void:
	stage_kills = 0
	current_stage = maxi(1, current_stage - 1)
	var st := get_current_stage_data()
	stage_changed.emit(current_stage, st.get("name", "Fase %d" % current_stage))

func calculate_offline_progress(last_unix: int) -> Dictionary:
	var now_unix := int(Time.get_unix_time_from_system())
	var elapsed := now_unix - last_unix
	if elapsed < 15:
		return {}

	# Limite estrito de 8 horas conforme Roadmap
	var clamped: int = mini(8 * 3600, elapsed)
	
	var h: int = clamped / 3600
	var m: int = (clamped % 3600) / 60
	var time_str := "%dh%02dm" % [h, m] if h > 0 else "%dm" % m

	var kills: int = int(float(clamped) / 4.0)
	var st := get_current_stage_data()
	var stage_lvl: int = int(st.get("stage", 1))

	var xp_per_kill: int = 8 + stage_lvl * 4
	var total_xp: int = kills * xp_per_kill

	var gold_per_kill: int = 2 + stage_lvl * 2
	var total_gold: int = kills * gold_per_kill

	var items: Array = []
	var max_items: int = mini(5, maxi(1, int(kills * 0.05)))
	for i in range(max_items):
		var dropped = LootManager.roll_drop(false)
		if dropped != null:
			items.append(dropped)

	return {
		"elapsed_seconds": clamped,
		"time_formatted": time_str,
		"kills": kills,
		"xp": total_xp,
		"gold": total_gold,
		"items": items
	}

func apply_offline_progress(data: Dictionary) -> void:
	if data.is_empty():
		return
	add_xp(int(data.get("xp", 0)))
	add_gold(int(data.get("gold", 0)))
	pending_offline_data = data
	offline_progress_calculated.emit(data)

func get_state() -> Dictionary:
	return {
		"level": level,
		"xp": xp,
		"xp_next": xp_next,
		"gold": gold,
		"current_stage": current_stage,
		"max_stage_reached": max_stage_reached,
		"stage_kills": stage_kills
	}

func load_state(data: Dictionary) -> void:
	level = data.get("level", 1)
	xp = data.get("xp", 0)
	xp_next = data.get("xp_next", get_xp_for_level(level))
	gold = data.get("gold", 0)
	current_stage = data.get("current_stage", 1)
	max_stage_reached = data.get("max_stage_reached", 1)
	stage_kills = data.get("stage_kills", 0)
