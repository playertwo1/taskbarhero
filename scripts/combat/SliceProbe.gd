extends Control

## Tela de sondagem local do slice. Tela jogável do slice (promovida a fluxo principal no 1A-CUT); ainda não usa save.
## A expedição vem do SliceSession e fica registrada no DebugBridge; em DevMode o estado é gravado
## em user://argos/slice_state.json a cada mudança de encontro (leitura externa pelo Argos).
const LEVELS := [1, 3, 5, 7, 10, 15, 20]
const BUILDS := SliceSession.BUILD_PRESETS

var run: ExpeditionRun
var selected_level := 5
var selected_build := 0
var selected_gear := 0
var attempt := 0
var speed := 4.0
var hp_label: Label
var encounter_label: Label
var result_label: Label
var log_label: Label
var speed_button: Button

func _data_ok() -> bool:
	var d := SliceSession.data()
	return d["route"] is Dictionary and not d["route"].is_empty() and d["heroes"].size() == 3 and not d["enemies"].is_empty()

func _ready() -> void:
	_build_ui()
	if not _data_ok():
		result_label.text = "Dados do slice indisponíveis"
	else:
		_start_run()

func _build_ui() -> void:
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 24)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	margin.add_child(column)
	var title := Label.new()
	title.text = "Expedição do slice · teste"
	title.add_theme_font_size_override("font_size", 23)
	column.add_child(title)
	var note := Label.new()
	note.text = "Combate automático. HP persiste até a volta ao Hub. Este teste não altera o save."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(note)
	var build_picker := OptionButton.new()
	for b in BUILDS:
		build_picker.add_item(String(b["name"]))
	build_picker.item_selected.connect(func(index: int): selected_build = index)
	column.add_child(build_picker)
	var level_picker := OptionButton.new()
	for level in LEVELS:
		level_picker.add_item("Trio nível %d" % level)
	level_picker.select(2)
	level_picker.item_selected.connect(func(index: int): selected_level = LEVELS[index])
	column.add_child(level_picker)
	var gear_picker := OptionButton.new()
	for label in ["Sem itens", "Itens iniciais", "Itens raros (IP 50)"]:
		gear_picker.add_item(label)
	gear_picker.item_selected.connect(func(index: int): selected_gear = index)
	column.add_child(gear_picker)
	var row := HBoxContainer.new()
	column.add_child(row)
	var retry := Button.new()
	retry.text = "Nova tentativa"
	retry.custom_minimum_size.y = 50
	retry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	retry.pressed.connect(_start_run)
	row.add_child(retry)
	speed_button = Button.new()
	speed_button.text = "Vel. ×4"
	speed_button.custom_minimum_size.y = 50
	speed_button.pressed.connect(_cycle_speed)
	row.add_child(speed_button)
	encounter_label = Label.new()
	encounter_label.add_theme_font_size_override("font_size", 18)
	encounter_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(encounter_label)
	hp_label = Label.new()
	hp_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(hp_label)
	result_label = Label.new()
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(result_label)
	log_label = Label.new()
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(log_label)
	var back := Button.new()
	back.text = "Voltar ao título"
	back.custom_minimum_size.y = 50
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn"))
	column.add_child(back)

func _cycle_speed() -> void:
	speed = 1.0 if speed >= 20.0 else (20.0 if speed >= 4.0 else 4.0)
	speed_button.text = "Vel. ×%d" % int(speed)

func _start_run() -> void:
	if not _data_ok():
		return
	attempt += 1
	var build: Dictionary = BUILDS[selected_build]["heroes"]
	run = SliceSession.create_run(build, selected_level, attempt, {"equipment": _equipment()})
	DebugBridge.register_slice_run(run, {"build": build, "level": selected_level, "seed": attempt, "attempt": attempt, "gear": selected_gear, "source": "slice_probe"})
	StateExporter.write_slice_state(DebugBridge.slice_snapshot())
	result_label.text = "Tentativa %d · %s · nível %d · itens %d" % [attempt, BUILDS[selected_build]["name"], selected_level, selected_gear]
	log_label.text = ""
	_update_status()

func _equipment() -> Dictionary:
	if selected_gear == 0:
		return {}
	var loadout := {
		"hero_001": ["item_w_001", "item_s_001", "item_a_001"],
		"hero_002": ["item_w_002", "item_s_006", "item_a_001"],
		"hero_003": ["item_w_006", "item_s_007", "item_a_001"],
	}
	var out := {}
	for hero_id in loadout:
		var equipped := []
		for item_id in loadout[hero_id]:
			var rarity := "Raro" if selected_gear == 2 else ("Incomum" if item_id == "item_w_002" else "Comum")
			equipped.append({"id": item_id, "rarity": rarity, "item_power": 50 if selected_gear == 2 else 20, "item_level": selected_level})
		out[hero_id] = equipped
	return out

func _process(delta: float) -> void:
	if run == null or run.state == "won" or run.state == "lost":
		return
	var events := run.step(minf(delta * speed, 0.5))
	var lines: Array[String] = []
	for event in events:
		match String(event["type"]):
			"encounter_started": lines.append("Início: %s" % event["node_id"])
			"encounter_cleared": lines.append("Vitória no encontro em %.1f s" % event["duration"])
			"hero_defeated": lines.append("Herói caiu: %s" % event["id"])
			"healing": lines.append("Cura: %.0f HP" % event["amount"])
			"expedition_won": result_label.text += "\nVITÓRIA na expedição"
			"expedition_lost": result_label.text += "\nDERROTA em %s" % event["node_id"]
	if not lines.is_empty():
		log_label.text = "\n".join(lines)
	for event in events:
		if event["type"] in ["encounter_started", "encounter_cleared", "hero_defeated", "expedition_won", "expedition_lost"]:
			StateExporter.write_slice_state(DebugBridge.slice_snapshot())
			break
	_update_status()

func _update_status() -> void:
	if run == null:
		return
	var snap := run.snapshot()
	encounter_label.text = "Encontro: %s · %.1f s" % [snap["node_id"], snap["time"]]
	var hp: Dictionary = snap["party_hp"]
	hp_label.text = "Bastião %.0f HP  ·  Flecha %.0f HP  ·  Íris %.0f HP" % [hp["hero_001"], hp["hero_002"], hp["hero_003"]]
