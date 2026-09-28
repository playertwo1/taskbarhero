extends Control

signal item_equipped(item_name: String)

const CATALOG_PATH := "res://data/items/item_visual_catalog.json"

var catalog: Array[Dictionary] = []
var current_filter := "all"
var selected_item: Dictionary = {}
var item_grid: GridContainer
var count_label: Label
var selected_icon: TextureRect
var selected_name: Label
var selected_status: Label
var selected_stats: Label
var equip_button: Button
var category_buttons: Dictionary = {}
var screen_card: PanelContainer

func _ready() -> void:
	_build_screen()
	_adjust_safe_area()
	get_tree().root.size_changed.connect(_adjust_safe_area)
	_load_catalog()
	LootManager.inventory_updated.connect(_refresh_screen)
	LootManager.item_equipped.connect(_on_item_equipped)
	_refresh_screen()

func show_screen() -> void:
	visible = true
	current_filter = "all"
	category_buttons["all"].button_pressed = true
	_refresh_screen()

func hide_screen() -> void:
	visible = false

func _build_screen() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	var backdrop := ColorRect.new()
	backdrop.color = Color(0.025, 0.035, 0.04, 0.9)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	screen_card = PanelContainer.new()
	screen_card.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_card.add_theme_stylebox_override("panel", _panel_style(Color(0.075, 0.095, 0.10), Color(0.22, 0.30, 0.29), 14))
	add_child(screen_card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	screen_card.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	var back_button := _button("‹", Vector2(48, 48))
	back_button.add_theme_font_size_override("font_size", 24)
	back_button.pressed.connect(hide_screen)
	header.add_child(back_button)

	var title := Label.new()
	title.text = "Inventário"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(0.92, 0.90, 0.82))
	title.add_theme_font_size_override("font_size", 20)
	header.add_child(title)

	count_label = Label.new()
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	count_label.add_theme_color_override("font_color", Color(0.65, 0.76, 0.71))
	count_label.add_theme_font_size_override("font_size", 10)
	header.add_child(count_label)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 5)
	content.add_child(tabs)
	var button_group := ButtonGroup.new()
	button_group.allow_unpress = false
	var tab_defs := [
		{"id": "all", "text": "Tudo"},
		{"id": "weapon", "text": "Armas"},
		{"id": "armor", "text": "Armaduras"},
		{"id": "amulet", "text": "Amuletos"},
	]
	for tab in tab_defs:
		var tab_button := _button(tab.text, Vector2(0, 48))
		tab_button.toggle_mode = true
		tab_button.button_group = button_group
		tab_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab_button.add_theme_font_size_override("font_size", 11)
		tab_button.toggled.connect(_on_filter_toggled.bind(tab.id))
		tabs.add_child(tab_button)
		category_buttons[tab.id] = tab_button

	var catalog_note := Label.new()
	catalog_note.text = "15 itens do MVP · 15 candidatos visuais do Capítulo 1"
	catalog_note.add_theme_color_override("font_color", Color(0.61, 0.68, 0.64))
	catalog_note.add_theme_font_size_override("font_size", 10)
	content.add_child(catalog_note)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(scroll)

	item_grid = GridContainer.new()
	item_grid.columns = 4
	item_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_grid.add_theme_constant_override("h_separation", 6)
	item_grid.add_theme_constant_override("v_separation", 6)
	scroll.add_child(item_grid)

	var divider := HSeparator.new()
	content.add_child(divider)

	var details := HBoxContainer.new()
	details.add_theme_constant_override("separation", 9)
	details.custom_minimum_size = Vector2(0, 86)
	content.add_child(details)

	selected_icon = TextureRect.new()
	selected_icon.custom_minimum_size = Vector2(48, 48)
	selected_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	selected_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	selected_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	details.add_child(selected_icon)

	var detail_text := VBoxContainer.new()
	detail_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_text.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	detail_text.add_theme_constant_override("separation", 2)
	details.add_child(detail_text)

	selected_name = Label.new()
	selected_name.text = "Selecione um item"
	selected_name.add_theme_color_override("font_color", Color(0.94, 0.91, 0.82))
	selected_name.add_theme_font_size_override("font_size", 13)
	selected_name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	detail_text.add_child(selected_name)

	selected_status = Label.new()
	selected_status.add_theme_color_override("font_color", Color(0.62, 0.76, 0.68))
	selected_status.add_theme_font_size_override("font_size", 9)
	selected_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_text.add_child(selected_status)

	selected_stats = Label.new()
	selected_stats.add_theme_color_override("font_color", Color(0.82, 0.84, 0.79))
	selected_stats.add_theme_font_size_override("font_size", 10)
	selected_stats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_text.add_child(selected_stats)

	equip_button = _button("Equipar", Vector2(76, 48))
	equip_button.add_theme_font_size_override("font_size", 10)
	equip_button.pressed.connect(_equip_selected)
	details.add_child(equip_button)
	category_buttons["all"].button_pressed = true

func _load_catalog() -> void:
	if not FileAccess.file_exists(CATALOG_PATH):
		push_warning("InventoryScreen: catálogo visual ausente em %s" % CATALOG_PATH)
		return
	var file := FileAccess.open(CATALOG_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Array:
		catalog.clear()
		for item in parsed:
			if item is Dictionary:
				catalog.append(item)

func _refresh_screen() -> void:
	if count_label == null:
		return
	var owned_count := LootManager.inventory.size()
	count_label.text = "%d na mochila\n30 no catálogo" % owned_count
	var filtered := _filtered_items()
	if selected_item.is_empty() or not _contains_id(filtered, str(selected_item.get("id", ""))):
		selected_item = filtered[0] if not filtered.is_empty() else {}
	_refresh_grid(filtered)
	_refresh_detail()

func _refresh_grid(items: Array) -> void:
	for child in item_grid.get_children():
		item_grid.remove_child(child)
		child.queue_free()
	for item in items:
		var tile := Button.new()
		tile.custom_minimum_size = Vector2(62, 72)
		tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tile.focus_mode = Control.FOCUS_NONE
		tile.tooltip_text = str(item.get("name", "Item"))
		var is_selected: bool = (str(item.get("id", "")) == str(selected_item.get("id", "")))
		tile.add_theme_stylebox_override("normal", _tile_style(is_selected))
		tile.add_theme_stylebox_override("hover", _tile_style(is_selected, true))
		tile.add_theme_stylebox_override("pressed", _tile_style(true))
		tile.add_theme_stylebox_override("focus", _tile_style(is_selected))

		var item_box := VBoxContainer.new()
		item_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item_box.alignment = BoxContainer.ALIGNMENT_CENTER
		item_box.add_theme_constant_override("separation", 2)
		item_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		tile.add_child(item_box)

		var icon := TextureRect.new()
		icon.custom_minimum_size = Vector2(32, 32)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var icon_path := str(item.get("icon", ""))
		if ResourceLoader.exists(icon_path):
			icon.texture = load(icon_path)
		item_box.add_child(icon)

		var name_label := Label.new()
		name_label.text = str(item.get("name", "Item"))
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_label.custom_minimum_size = Vector2(0, 26)
		name_label.add_theme_color_override("font_color", Color(0.81, 0.83, 0.78))
		name_label.add_theme_font_size_override("font_size", 8)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item_box.add_child(name_label)
		tile.pressed.connect(_select_item.bind(item))
		item_grid.add_child(tile)

func _refresh_detail() -> void:
	if selected_item.is_empty():
		selected_icon.texture = null
		selected_name.text = "Nenhum item nesta categoria"
		selected_status.text = ""
		selected_stats.text = ""
		equip_button.disabled = true
		equip_button.text = "—"
		return

	selected_name.text = str(selected_item.get("name", "Item"))
	var icon_path := str(selected_item.get("icon", ""))
	selected_icon.texture = load(icon_path) if ResourceLoader.exists(icon_path) else null
	var is_candidate: bool = (str(selected_item.get("status", "")) == "visual_candidate")
	var owned := _owned_count(str(selected_item.get("id", "")))
	var gameplay: Dictionary = selected_item.get("gameplay", {})
	var rarity := str(gameplay.get("rarity", ""))
	if is_candidate:
		selected_status.text = "Candidato visual · gameplay ainda não definido"
		selected_stats.text = ""
	else:
		var ownership_text := "Na mochila ×%d" % owned if owned > 0 else "MVP · ainda não obtido"
		selected_status.text = "%s%s" % [rarity + " · " if not rarity.is_empty() else "", ownership_text]
		selected_stats.text = _format_stats(gameplay)

	var is_equipped := false
	var slot := str(selected_item.get("slot", ""))
	var current = LootManager.equipment.get(slot)
	if current is Dictionary and str(current.get("id", "")) == str(selected_item.get("id", "")):
		is_equipped = true
	equip_button.disabled = is_candidate or owned == 0 or is_equipped
	equip_button.text = "Equipado" if is_equipped else ("Equipar" if owned > 0 and not is_candidate else ("Candidato" if is_candidate else "Não obtido"))

func _format_stats(item: Dictionary) -> String:
	var values: Array[String] = []
	if item.has("attack"):
		values.append("ATQ +%d" % int(item.attack))
	if item.has("defense"):
		values.append("DEF +%d" % int(item.defense))
	if item.has("max_hp"):
		values.append("PV +%d" % int(item.max_hp))
	if item.has("crit"):
		values.append("Crítico +%d%%" % int(round(float(item.crit) * 100.0)))
	if item.has("lifesteal"):
		values.append("Roubo de vida +%d%%" % int(round(float(item.lifesteal) * 100.0)))
	return " · ".join(values)

func _filtered_items() -> Array:
	var result: Array = []
	for item in catalog:
		if current_filter == "all" or str(item.get("slot", "")) == current_filter:
			result.append(item)
	return result

func _contains_id(items: Array, item_id: String) -> bool:
	for item in items:
		if str(item.get("id", "")) == item_id:
			return true
	return false

func _owned_count(item_id: String) -> int:
	var count := 0
	for owned_item in LootManager.inventory:
		if str(owned_item.get("id", "")) == item_id:
			count += 1
	return count

func _select_item(item: Dictionary) -> void:
	selected_item = item
	_refresh_screen()

func _equip_selected() -> void:
	if selected_item.is_empty() or selected_item.get("status", "") != "mvp":
		return
	var item_id := str(selected_item.get("id", ""))
	for owned_item in LootManager.inventory:
		if str(owned_item.get("id", "")) == item_id:
			if LootManager.equip_item(owned_item):
				item_equipped.emit(str(selected_item.get("name", "Item")))
				_refresh_detail()
			return

func _on_filter_toggled(pressed: bool, slot: String) -> void:
	if not pressed:
		return
	current_filter = slot
	_refresh_screen()

func _on_item_equipped(_slot: String, _item: Dictionary) -> void:
	_refresh_detail()

func _adjust_safe_area() -> void:
	if screen_card == null:
		return
	var left_margin := 12
	var top_margin := 16
	var right_margin := 12
	var bottom_margin := 16
	if OS.has_feature("mobile") or OS.has_feature("android"):
		var safe_rect := DisplayServer.get_display_safe_area()
		var screen_size := DisplayServer.screen_get_size()
		var viewport_size := get_viewport_rect().size
		if screen_size.y > 0 and safe_rect.size.y > 0 and viewport_size.y > 0:
			var scale_y := viewport_size.y / float(screen_size.y)
			var scale_x := viewport_size.x / float(screen_size.x)
			left_margin = maxi(left_margin, int(safe_rect.position.x * scale_x) + 8)
			top_margin = maxi(top_margin, int(safe_rect.position.y * scale_y) + 8)
			right_margin = maxi(right_margin, int((screen_size.x - safe_rect.position.x - safe_rect.size.x) * scale_x) + 8)
			bottom_margin = maxi(bottom_margin, int((screen_size.y - safe_rect.position.y - safe_rect.size.y) * scale_y) + 8)
	screen_card.offset_left = left_margin
	screen_card.offset_top = top_margin
	screen_card.offset_right = -right_margin
	screen_card.offset_bottom = -bottom_margin

func _button(label: String, minimum: Vector2) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = minimum
	button.add_theme_color_override("font_color", Color(0.91, 0.91, 0.85))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.97, 0.87))
	button.add_theme_stylebox_override("normal", _panel_style(Color(0.14, 0.20, 0.20), Color(0.24, 0.32, 0.30), 10))
	button.add_theme_stylebox_override("hover", _panel_style(Color(0.18, 0.27, 0.25), Color(0.43, 0.58, 0.51), 10))
	button.add_theme_stylebox_override("pressed", _panel_style(Color(0.20, 0.30, 0.27), Color(0.55, 0.70, 0.58), 10))
	button.add_theme_stylebox_override("disabled", _panel_style(Color(0.11, 0.15, 0.15), Color(0.19, 0.23, 0.22), 10))
	return button

func _tile_style(selected: bool, hovered: bool = false) -> StyleBoxFlat:
	var bg := Color(0.12, 0.16, 0.17)
	var border := Color(0.21, 0.27, 0.28)
	if selected:
		bg = Color(0.18, 0.19, 0.15)
		border = Color(0.75, 0.62, 0.37)
	elif hovered:
		bg = Color(0.16, 0.22, 0.21)
		border = Color(0.38, 0.52, 0.47)
	return _panel_style(bg, border, 9)

func _panel_style(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 8
	style.content_margin_top = 6
	style.content_margin_right = 8
	style.content_margin_bottom = 6
	return style
