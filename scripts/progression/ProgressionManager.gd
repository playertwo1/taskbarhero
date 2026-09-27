extends Node

signal level_up(new_level: int)
signal xp_gained(amount: int, current_xp: int, next_xp: int)
signal gold_changed(new_gold: int, delta: int)
signal stage_changed(stage_index: int, stage_name: String)

var level: int = 1
var xp: int = 0
var xp_next: int = 30
var gold: int = 0
var current_stage: int = 1
var max_stage_reached: int = 1

func _ready() -> void:
	xp_next = get_xp_for_level(level)

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

func advance_stage() -> void:
	current_stage += 1
	if current_stage > max_stage_reached:
		max_stage_reached = current_stage
	stage_changed.emit(current_stage, "Bosque de Lúmen - Fase %d" % current_stage)

func get_state() -> Dictionary:
	return {
		"level": level,
		"xp": xp,
		"xp_next": xp_next,
		"gold": gold,
		"current_stage": current_stage,
		"max_stage_reached": max_stage_reached
	}

func load_state(data: Dictionary) -> void:
	level = data.get("level", 1)
	xp = data.get("xp", 0)
	xp_next = data.get("xp_next", get_xp_for_level(level))
	gold = data.get("gold", 0)
	current_stage = data.get("current_stage", 1)
	max_stage_reached = data.get("max_stage_reached", 1)
