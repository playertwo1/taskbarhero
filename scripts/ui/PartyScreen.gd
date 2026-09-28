extends PanelContainer

signal party_updated(hero_ids: Array)

@onready var hero_list: VBoxContainer = $Center/Card/VBox/Scroll/HeroList
@onready var close_button: Button = $Center/Card/VBox/Header/CloseButton
@onready var apply_button: Button = $Center/Card/VBox/ApplyButton
@onready var slots_label: Label = $Center/Card/VBox/SlotsLabel

var selected_ids: Array = []

func _ready() -> void:
	visible = false
	if close_button:
		close_button.pressed.connect(close)
	if apply_button:
		apply_button.pressed.connect(_on_apply_pressed)
	_sync_from_game_manager()

func open() -> void:
	_sync_from_game_manager()
	_render_heroes()
	visible = true

func close() -> void:
	visible = false

func _sync_from_game_manager() -> void:
	selected_ids.clear()
	for hid in GameManager.party.keys():
		selected_ids.append(str(hid))
	_update_slots_label()

func _update_slots_label() -> void:
	if not slots_label:
		return
	var names: Array = []
	for hid in selected_ids:
		if GameManager.HERO_DATABASE.has(hid):
			names.append(GameManager.HERO_DATABASE[hid]["name"])
	var names_str := ", ".join(names) if names.size() > 0 else "Nenhum"
	slots_label.text = "Party Selecionada (%d/3): %s" % [selected_ids.size(), names_str]
	if apply_button:
		apply_button.disabled = (selected_ids.size() != 3)

func _on_hero_toggled(hero_id: String) -> void:
	if selected_ids.has(hero_id):
		selected_ids.erase(hero_id)
	else:
		if selected_ids.size() < 3:
			selected_ids.append(hero_id)
		else:
			selected_ids.remove_at(0)
			selected_ids.append(hero_id)
	_update_slots_label()
	_render_heroes()

func _on_apply_pressed() -> void:
	if selected_ids.size() == 3:
		GameManager.set_party_selection(selected_ids)
		party_updated.emit(selected_ids)
		close()

func _render_heroes() -> void:
	if not hero_list:
		return
	for c in hero_list.get_children():
		c.queue_free()

	for hid in GameManager.HERO_DATABASE.keys():
		var data: Dictionary = GameManager.HERO_DATABASE[hid]
		var is_selected: bool = selected_ids.has(hid)
		var slot_idx: int = selected_ids.find(hid)
		var slot_name := ""
		if slot_idx == 0:
			slot_name = "Back"
		elif slot_idx == 1:
			slot_name = "Mid"
		elif slot_idx == 2:
			slot_name = "Front"

		var row := PanelContainer.new()
		var sb := StyleBoxFlat.new()
		sb.set_corner_radius_all(8)
		sb.content_margin_left = 10
		sb.content_margin_right = 10
		sb.content_margin_top = 8
		sb.content_margin_bottom = 8

		if is_selected:
			sb.bg_color = Color(0.12, 0.22, 0.28, 1.0)
			sb.border_width_left = 2
			sb.border_width_right = 2
			sb.border_width_top = 2
			sb.border_width_bottom = 2
			sb.border_color = Color(0.45, 0.75, 0.95, 1.0)
		else:
			sb.bg_color = Color(0.08, 0.09, 0.11, 1.0)
			sb.border_width_left = 1
			sb.border_width_right = 1
			sb.border_width_top = 1
			sb.border_width_bottom = 1
			sb.border_color = Color(0.18, 0.20, 0.24, 1.0)
		row.add_theme_stylebox_override("panel", sb)

		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 8)
		row.add_child(hbox)

		# Informações do herói
		var info_box := VBoxContainer.new()
		info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(info_box)

		var title_lbl := Label.new()
		var role_trans := str(data.get("role", "")).to_upper()
		title_lbl.text = "%s [%s]" % [data.get("name", hid), role_trans]
		title_lbl.add_theme_font_size_override("font_size", 14)
		if is_selected:
			title_lbl.add_theme_color_override("font_color", Color(0.96, 0.8, 0.28, 1.0))
		else:
			title_lbl.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96, 1.0))
		info_box.add_child(title_lbl)

		var stats_lbl := Label.new()
		stats_lbl.text = "HP: %.0f | ATK: %.0f | DEF: %.0f | CD: %.2fs | Crit: %.0f%%" % [
			float(data.get("base_hp", 0)),
			float(data.get("base_attack", 0)),
			float(data.get("base_defense", 0)),
			float(data.get("cd_interval", 1.0)),
			float(data.get("crit_rate", 0)) * 100.0
		]
		stats_lbl.add_theme_font_size_override("font_size", 11)
		stats_lbl.add_theme_color_override("font_color", Color(0.65, 0.70, 0.78, 1.0))
		info_box.add_child(stats_lbl)

		# Botão de Toggle
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(80, 36)
		if is_selected:
			btn.text = "✓ %s" % slot_name
			btn.add_theme_color_override("font_color", Color(0.45, 0.95, 0.65, 1.0))
		else:
			btn.text = "Escolher"
		btn.pressed.connect(_on_hero_toggled.bind(hid))
		hbox.add_child(btn)

		hero_list.add_child(row)
