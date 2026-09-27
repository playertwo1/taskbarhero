extends Node

## Telemetry: Coleta de métricas e eventos internos do jogo para o Argos Analyst e Tracker Lite (FASE R16).

signal metric_recorded(metric_name: String, value: Variant)
signal tracker_updated(view_data: Dictionary)

var session_start_msec: int = 0
var session_start_unix: int = 0

# Contadores acumulados
var enemies_killed: int = 0
var total_xp_earned: int = 0
var total_gold_earned: int = 0
var total_hero_deaths: int = 0
var total_drops_count: int = 0

# Histórico detalhado de eventos para Tracker Lite
var kills_history: Array = []
var deaths_history: Array = []
var drops_history: Array = []

# Histórico legados preservados
var damage_dealt_history: Array = []
var damage_taken_history: Array = []
var kill_times: Array = []

func _ready() -> void:
	reset_session()

func reset_session(custom_unix: int = -1) -> void:
	session_start_msec = Time.get_ticks_msec()
	session_start_unix = custom_unix if custom_unix > 0 else int(Time.get_unix_time_from_system())
	enemies_killed = 0
	total_xp_earned = 0
	total_gold_earned = 0
	total_hero_deaths = 0
	total_drops_count = 0
	kills_history.clear()
	deaths_history.clear()
	drops_history.clear()
	damage_dealt_history.clear()
	damage_taken_history.clear()
	kill_times.clear()

func record_kill(enemy_id: String, duration_seconds: float, xp: int, gold: int, stage_idx: int = -1, timestamp_unix: int = -1) -> void:
	var now_unix: int = timestamp_unix if timestamp_unix > 0 else int(Time.get_unix_time_from_system())
	var stage: int = stage_idx if stage_idx > 0 else (ProgressionManager.current_stage if ProgressionManager != null else 1)
	
	enemies_killed += 1
	total_xp_earned += xp
	total_gold_earned += gold
	
	var kill_entry := {
		"timestamp": now_unix,
		"enemy": enemy_id,
		"ttk": duration_seconds,
		"xp": xp,
		"gold": gold,
		"stage": stage
	}
	kills_history.append(kill_entry)
	kill_times.append({"enemy": enemy_id, "ttk": duration_seconds})
	metric_recorded.emit("kill", kill_entry)

func record_hero_death(enemy_id: String, stage_idx: int = -1, timestamp_unix: int = -1) -> void:
	var now_unix: int = timestamp_unix if timestamp_unix > 0 else int(Time.get_unix_time_from_system())
	var stage: int = stage_idx if stage_idx > 0 else (ProgressionManager.current_stage if ProgressionManager != null else 1)
	
	total_hero_deaths += 1
	var death_entry := {
		"timestamp": now_unix,
		"killed_by": enemy_id,
		"stage": stage
	}
	deaths_history.append(death_entry)
	metric_recorded.emit("hero_death", death_entry)

func record_drop(item: Dictionary, stage_idx: int = -1, timestamp_unix: int = -1) -> void:
	var now_unix: int = timestamp_unix if timestamp_unix > 0 else int(Time.get_unix_time_from_system())
	var stage: int = stage_idx if stage_idx > 0 else (ProgressionManager.current_stage if ProgressionManager != null else 1)
	
	total_drops_count += 1
	var drop_entry := {
		"timestamp": now_unix,
		"item_id": item.get("id", ""),
		"item_name": item.get("name", "Item"),
		"rarity": item.get("rarity", "Comum"),
		"stage": stage
	}
	drops_history.append(drop_entry)
	metric_recorded.emit("drop", drop_entry)

func get_session_duration_seconds() -> float:
	return float(Time.get_ticks_msec() - session_start_msec) / 1000.0

func calculate_metrics_for_window(start_unix: int, end_unix: int, stage_filter: int = -1, forced_window_seconds: float = -1.0) -> Dictionary:
	var filtered_kills: Array = []
	var filtered_deaths: Array = []
	var filtered_drops: Array = []
	
	for k in kills_history:
		var ts: int = int(k.get("timestamp", 0))
		var st: int = int(k.get("stage", 1))
		if ts >= start_unix and ts <= end_unix:
			if stage_filter <= 0 or st == stage_filter:
				filtered_kills.append(k)
				
	for d in deaths_history:
		var ts: int = int(d.get("timestamp", 0))
		var st: int = int(d.get("stage", 1))
		if ts >= start_unix and ts <= end_unix:
			if stage_filter <= 0 or st == stage_filter:
				filtered_deaths.append(d)
				
	for dr in drops_history:
		var ts: int = int(dr.get("timestamp", 0))
		var st: int = int(dr.get("stage", 1))
		if ts >= start_unix and ts <= end_unix:
			if stage_filter <= 0 or st == stage_filter:
				filtered_drops.append(dr)
	
	var duration_seconds: float = forced_window_seconds if forced_window_seconds > 0.0 else maxf(1.0, float(end_unix - start_unix))
	var duration_hours: float = duration_seconds / 3600.0
	
	var xp_sum: int = 0
	var gold_sum: int = 0
	var ttk_sum: float = 0.0
	
	for k in filtered_kills:
		xp_sum += int(k.get("xp", 0))
		gold_sum += int(k.get("gold", 0))
		ttk_sum += float(k.get("ttk", 0.0))
		
	var kills_cnt: int = filtered_kills.size()
	var deaths_cnt: int = filtered_deaths.size()
	var drops_cnt: int = filtered_drops.size()
	
	var avg_ttk: float = (ttk_sum / float(kills_cnt)) if kills_cnt > 0 else 0.0
	
	var rare_plus_cnt: int = 0
	for dr in filtered_drops:
		var rarity: String = dr.get("rarity", "")
		if rarity in ["Raro", "Épico", "Lendário"]:
			rare_plus_cnt += 1
			
	var pct_rare_plus: float = (float(rare_plus_cnt) / float(drops_cnt) * 100.0) if drops_cnt > 0 else 0.0
	
	var xp_per_hour: float = (float(xp_sum) / duration_hours) if duration_hours > 0.0 else 0.0
	var gold_per_hour: float = (float(gold_sum) / duration_hours) if duration_hours > 0.0 else 0.0
	var kills_per_hour: float = (float(kills_cnt) / duration_hours) if duration_hours > 0.0 else 0.0
	var drops_per_hour: float = (float(drops_cnt) / duration_hours) if duration_hours > 0.0 else 0.0
	
	return {
		"duration_seconds": duration_seconds,
		"duration_hours": duration_hours,
		"total_xp": xp_sum,
		"total_gold": gold_sum,
		"kills": kills_cnt,
		"deaths": deaths_cnt,
		"drops": drops_cnt,
		"rare_plus_drops": rare_plus_cnt,
		"xp_per_hour": xp_per_hour,
		"gold_per_hour": gold_per_hour,
		"kills_per_hour": kills_per_hour,
		"avg_ttk": avg_ttk,
		"drops_per_hour": drops_per_hour,
		"pct_rare_plus": pct_rare_plus
	}

func get_tracker_view(view_name: String, current_unix: int = -1) -> Dictionary:
	var now_unix: int = current_unix if current_unix > 0 else int(Time.get_unix_time_from_system())
	
	match view_name:
		"session":
			var start_unix := session_start_unix
			var res := calculate_metrics_for_window(start_unix, now_unix)
			res["view"] = "session"
			res["view_label"] = "Sessão Atual"
			return res
			
		"last_2_hours":
			var start_unix := now_unix - 7200
			var effective_duration: float = minf(7200.0, maxf(1.0, float(now_unix - session_start_unix)))
			var res := calculate_metrics_for_window(start_unix, now_unix, -1, effective_duration)
			res["view"] = "last_2_hours"
			res["view_label"] = "Últimas 2 Horas"
			return res
			
		"best_stage_xp":
			var stages_active: Dictionary = {}
			for k in kills_history:
				var st: int = int(k.get("stage", 1))
				stages_active[st] = true
				
			var best_stage: int = 1
			var best_xp: int = -1
			var best_metrics: Dictionary = {}
			
			if stages_active.is_empty():
				best_metrics = calculate_metrics_for_window(session_start_unix, now_unix, 1)
			else:
				for st in stages_active.keys():
					var m := calculate_metrics_for_window(session_start_unix, now_unix, int(st))
					if int(m["total_xp"]) > best_xp:
						best_xp = int(m["total_xp"])
						best_stage = int(st)
						best_metrics = m
						
			best_metrics["view"] = "best_stage_xp"
			best_metrics["best_stage"] = best_stage
			best_metrics["best_stage_name"] = _get_stage_name(best_stage)
			best_metrics["view_label"] = "Melhor Fase por XP: Fase %d (%s)" % [best_stage, best_metrics["best_stage_name"]]
			return best_metrics
			
		"best_stage_gold":
			var stages_active: Dictionary = {}
			for k in kills_history:
				var st: int = int(k.get("stage", 1))
				stages_active[st] = true
				
			var best_stage: int = 1
			var best_gold: int = -1
			var best_metrics: Dictionary = {}
			
			if stages_active.is_empty():
				best_metrics = calculate_metrics_for_window(session_start_unix, now_unix, 1)
			else:
				for st in stages_active.keys():
					var m := calculate_metrics_for_window(session_start_unix, now_unix, int(st))
					if int(m["total_gold"]) > best_gold:
						best_gold = int(m["total_gold"])
						best_stage = int(st)
						best_metrics = m
						
			best_metrics["view"] = "best_stage_gold"
			best_metrics["best_stage"] = best_stage
			best_metrics["best_stage_name"] = _get_stage_name(best_stage)
			best_metrics["view_label"] = "Melhor Fase por Ouro: Fase %d (%s)" % [best_stage, best_metrics["best_stage_name"]]
			return best_metrics
			
		_:
			return get_tracker_view("session", current_unix)

func _get_stage_name(stage_idx: int) -> String:
	if ProgressionManager != null and not ProgressionManager.stages_database.is_empty():
		for s in ProgressionManager.stages_database:
			if int(s.get("stage", 0)) == stage_idx:
				return s.get("name", "Fase %d" % stage_idx)
	match stage_idx:
		1: return "Entrada do Bosque"
		2: return "Clareira da Pressão"
		3: return "Ninho Silvestre"
		4: return "Covil do Alfa"
		5: return "Santuário do Guardião"
		_: return "Fase %d" % stage_idx

func get_xp_per_hour() -> float:
	return get_tracker_view("session")["xp_per_hour"]

func get_gold_per_hour() -> float:
	return get_tracker_view("session")["gold_per_hour"]

func get_telemetry_summary() -> Dictionary:
	var session_metrics := get_tracker_view("session")
	return {
		"duration_seconds": session_metrics["duration_seconds"],
		"enemies_killed": session_metrics["kills"],
		"hero_deaths": session_metrics["deaths"],
		"total_xp": session_metrics["total_xp"],
		"total_gold": session_metrics["total_gold"],
		"xp_per_hour": session_metrics["xp_per_hour"],
		"gold_per_hour": session_metrics["gold_per_hour"],
		"kills_recorded": kill_times.size(),
		"avg_ttk": session_metrics["avg_ttk"],
		"drops_per_hour": session_metrics["drops_per_hour"],
		"pct_rare_plus": session_metrics["pct_rare_plus"]
	}
