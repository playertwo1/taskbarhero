extends Node

## Telemetry: Coleta de métricas e eventos internos do jogo para o Argos Analyst.

signal metric_recorded(metric_name: String, value: Variant)

var session_start_msec: int = 0
var enemies_killed: int = 0
var total_xp_earned: int = 0
var total_gold_earned: int = 0
var total_hero_deaths: int = 0
var damage_dealt_history: Array = []
var damage_taken_history: Array = []
var kill_times: Array = []

func _ready() -> void:
	session_start_msec = Time.get_ticks_msec()

func record_kill(enemy_id: String, duration_seconds: float, xp: int, gold: int) -> void:
	enemies_killed += 1
	total_xp_earned += xp
	total_gold_earned += gold
	kill_times.append({"enemy": enemy_id, "ttk": duration_seconds})
	metric_recorded.emit("kill", {"enemy": enemy_id, "ttk": duration_seconds, "xp": xp, "gold": gold})

func record_hero_death(enemy_id: String) -> void:
	total_hero_deaths += 1
	metric_recorded.emit("hero_death", {"killed_by": enemy_id})

func get_session_duration_seconds() -> float:
	return float(Time.get_ticks_msec() - session_start_msec) / 1000.0

func get_xp_per_hour() -> float:
	var hours := get_session_duration_seconds() / 3600.0
	return float(total_xp_earned) / hours if hours > 0.0 else 0.0

func get_gold_per_hour() -> float:
	var hours := get_session_duration_seconds() / 3600.0
	return float(total_gold_earned) / hours if hours > 0.0 else 0.0

func get_telemetry_summary() -> Dictionary:
	return {
		"duration_seconds": get_session_duration_seconds(),
		"enemies_killed": enemies_killed,
		"hero_deaths": total_hero_deaths,
		"total_xp": total_xp_earned,
		"total_gold": total_gold_earned,
		"xp_per_hour": get_xp_per_hour(),
		"gold_per_hour": get_gold_per_hour(),
		"kills_recorded": kill_times.size()
	}
