extends Control
class_name SliceInventoryPanel

## Inventário do slice (SLICE-1B / UI_S12): lista, equipar/desequipar, ficha do herói (C4),
## chips de status (C1), linhas de item com comparação (C2) e gaveta de detalhes (C3).
## Sem regra própria: cálculo de status via ItemStatView e campanhas via SliceCampaign.

signal changed
signal closed

const ItemIconResolver = preload("res://scripts/ui/ItemIconResolver.gd")
const ItemStatView = preload("res://scripts/ui/ItemStatView.gd")

var campaign: SliceCampaign
var hero_names: Dictionary = {}
var selected_hero_id: String = "hero_001"
var _item_rows: Dictionary = {}
var _list: VBoxContainer
var _summary: Label
var _echo_status: Label
var _echo_button: Button
var _message: Label
var _hero_sheet_container: VBoxContainer
var _drawer_overlay: Control = null

func setup(new_campaign: SliceCampaign, names: Dictionary) -> void:
	campaign = new_campaign
	hero_names = names
	if not hero_names.is_empty() and not hero_names.has(selected_hero_id):
		selected_hero_id = String(hero_names.keys()[0])
	_item_rows = {}
	for row in SliceStats.load_rows("res://data/items/items.json", "slice"):
		_item_rows[row["id"]] = row
	_build()
	refresh()

func _build() -> void:
	for child in get_children():
		child.queue_free()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if ResourceLoader.exists("res://assets/ui/pocket_hero_theme.tres"):
		theme = load("res://assets/ui/pocket_hero_theme.tres")
	var background := ColorRect.new()
	background.color = Color(0.03, 0.04, 0.05, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 16)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)

	var title := Label.new()
	title.text = "Inventário & Equipamento"
	title.add_theme_font_size_override("font_size", 22)
	column.add_child(title)

	_summary = Label.new()
	_summary.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	column.add_child(_summary)

	# Divisor UI Kit
	var div := TextureRect.new()
	div.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	div.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	div.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	div.custom_minimum_size = Vector2(0, 8)
	if ResourceLoader.exists("res://assets/sprites/ui/ui_kit/ui_kit_divider.png"):
		div.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_divider.png")
	column.add_child(div)

	# Seletor de Herói e Ficha de Status (C4)
	var hero_header := HBoxContainer.new()
	hero_header.add_theme_constant_override("separation", 8)
	var hero_lbl := Label.new()
	hero_lbl.text = "Comparar com:"
	hero_lbl.add_theme_font_size_override("font_size", 14)
	hero_lbl.add_theme_color_override("font_color", Color(0.75, 0.77, 0.8))
	hero_header.add_child(hero_lbl)

	for hid in hero_names:
		var hbtn := Button.new()
		hbtn.text = String(hero_names[hid])
		hbtn.custom_minimum_size.y = 36
		var target_hid: String = hid
		hbtn.pressed.connect(func():
			selected_hero_id = target_hid
			refresh())
		hero_header.add_child(hbtn)
	column.add_child(hero_header)

	_hero_sheet_container = VBoxContainer.new()
	column.add_child(_hero_sheet_container)

	_echo_status = Label.new()
	column.add_child(_echo_status)
	_echo_button = Button.new()
	_echo_button.custom_minimum_size.y = 48
	_echo_button.pressed.connect(_toggle_echo)
	column.add_child(_echo_button)

	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_message)

	var best := Button.new()
	best.text = "Equipar os melhores"
	best.custom_minimum_size.y = 48
	best.pressed.connect(auto_equip_all)
	column.add_child(best)

	_list = VBoxContainer.new()
	_list.add_theme_constant_override("separation", 8)
	column.add_child(_list)

	var back := Button.new()
	back.text = "Voltar"
	back.custom_minimum_size.y = 50
	back.pressed.connect(func(): closed.emit())
	column.add_child(back)

func row_count() -> int:
	return campaign.inventory.items.size()

func summary_text() -> String:
	return "Itens: %d · Resíduo de Lúmen: %d" % [campaign.inventory.items.size(), int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0))]

func refresh() -> void:
	_summary.text = summary_text()
	var owns_echo := campaign.inventory.echoes.has(SliceInventory.ECHO_SENTINEL)
	_echo_status.text = "Echo: A Sentinela que Ficou%s" % (" · equipado" if campaign.inventory.equipped_echo == SliceInventory.ECHO_SENTINEL else "") if owns_echo else "Nenhum Echo recuperado."
	_echo_button.visible = owns_echo
	_echo_button.disabled = campaign.inventory.locked
	_echo_button.text = "Desequipar Echo" if campaign.inventory.equipped_echo == SliceInventory.ECHO_SENTINEL else "Equipar A Sentinela que Ficou"

	# Atualiza a Ficha de Status do Herói (C4)
	for child in _hero_sheet_container.get_children():
		child.queue_free()
	if not selected_hero_id.is_empty():
		_hero_sheet_container.add_child(ItemStatView.create_hero_sheet_control(selected_hero_id, campaign))

	for child in _list.get_children():
		child.queue_free()
	var owner_of := {}
	for hero_id in campaign.inventory.equipped:
		for uid in campaign.inventory.equipped[hero_id]:
			owner_of[int(uid)] = String(hero_id)
	for inst in campaign.inventory.items:
		_list.add_child(_row(inst, String(owner_of.get(int(inst["uid"]), ""))))

func _toggle_echo() -> void:
	var next_echo := "" if campaign.inventory.equipped_echo == SliceInventory.ECHO_SENTINEL else SliceInventory.ECHO_SENTINEL
	var err := campaign.equip_echo(next_echo)
	_report(err)
	refresh()
	if err == "":
		changed.emit()

## C2 — Linha de item (Inventário / UI_S12):
## Ícone, moldura de raridade, subtítulo de IP, até 3 chips de bônus, chip de diferença e ações.
func _row(inst: Dictionary, owner_id: String) -> Control:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.1, 0.85)
	style.border_color = Color(0.2, 0.23, 0.26, 0.5)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", style)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)

	var row_header := HBoxContainer.new()
	row_header.add_theme_constant_override("separation", 10)
	var icon := ItemIconResolver.create_icon_rect(String(inst.get("id", "")), Vector2(44, 44))
	row_header.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 2)

	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var name_txt := SliceLogText.item_label(inst, _item_rows)
	if bool(inst.get("favorite", false)):
		name_txt += " ★"
	if owner_id != "":
		name_txt += "  · equipado: %s" % hero_names.get(owner_id, owner_id)
	label.text = name_txt
	var rarity: String = String(inst.get("rarity", "Comum"))
	label.add_theme_color_override("font_color", ItemIconResolver.rarity_color(rarity))
	text_box.add_child(label)

	var sub_lbl := Label.new()
	var row_data: Dictionary = _item_rows.get(inst.get("id", ""), {})
	var slot_name: String = String(row_data.get("slot", "item")).capitalize()
	sub_lbl.text = "[%s] %s · IP %d · Nv. %d" % [slot_name, rarity, int(inst.get("item_power", 0)), int(inst.get("item_level", 0))]
	sub_lbl.add_theme_font_size_override("font_size", 12)
	sub_lbl.add_theme_color_override("font_color", Color(0.65, 0.68, 0.72))
	text_box.add_child(sub_lbl)
	row_header.add_child(text_box)
	box.add_child(row_header)

	# Linha de Chips (C1 / C2): até 3 bônus + chip de comparação
	var chips_row := HBoxContainer.new()
	chips_row.add_theme_constant_override("separation", 6)

	var bonus_lines := ItemStatView.lines(inst, _item_rows)
	for i in mini(3, bonus_lines.size()):
		var bline: Dictionary = bonus_lines[i]
		chips_row.add_child(ItemStatView.create_stat_chip(ItemStatView.format_bonus_number(bline["value"], bline["kind"]), bline["glyph"], "neutral"))

	# Chip de comparação com o herói selecionado
	if not selected_hero_id.is_empty():
		var comp := ItemStatView.compare(inst, selected_hero_id, campaign, _item_rows)
		if comp["compatible"] and comp["primary_chip_text"] != "":
			var diff_variant: String = String(comp["primary_diff"]["diff_info"]["variant"])
			chips_row.add_child(ItemStatView.create_stat_chip(comp["primary_chip_text"], "", diff_variant))

	box.add_child(chips_row)

	# Ações
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 6)
	var uid := int(inst["uid"])

	var details_btn := Button.new()
	details_btn.text = "Detalhes"
	details_btn.custom_minimum_size.y = 44
	details_btn.pressed.connect(func(): _open_drawer(inst))
	actions.add_child(details_btn)

	if owner_id == "":
		var picker := OptionButton.new()
		var compatible: Array = _item_rows.get(inst["id"], {}).get("compatible_heroes", [])
		for hero_id in compatible:
			picker.add_item(String(hero_names.get(hero_id, hero_id)))
			picker.set_item_metadata(picker.item_count - 1, hero_id)
		picker.custom_minimum_size.y = 44
		actions.add_child(picker)
		var equip := Button.new()
		equip.text = "Equipar"
		equip.custom_minimum_size.y = 44
		equip.pressed.connect(func(): equip_item(uid, String(picker.get_item_metadata(picker.selected))))
		actions.add_child(equip)
	else:
		var unequip := Button.new()
		unequip.text = "Desequipar"
		unequip.custom_minimum_size.y = 44
		unequip.pressed.connect(func(): unequip_item(uid))
		actions.add_child(unequip)

	box.add_child(actions)
	panel.add_child(box)
	return panel

## C3 — Gaveta de Detalhes do Item (Inventário / Ferreiro)
func _open_drawer(inst: Dictionary) -> void:
	if _drawer_overlay != null:
		_drawer_overlay.queue_free()

	_drawer_overlay = PanelContainer.new()
	_drawer_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.04, 0.05, 0.07, 0.96)
	bg.border_color = Color(0.24, 0.28, 0.32, 0.8)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(8)
	bg.content_margin_left = 16
	bg.content_margin_right = 16
	bg.content_margin_top = 16
	bg.content_margin_bottom = 16
	_drawer_overlay.add_theme_stylebox_override("panel", bg)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_drawer_overlay.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10)
	scroll.add_child(vbox)

	# 1. Cabeçalho
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	var icon := ItemIconResolver.create_icon_rect(String(inst.get("id", "")), Vector2(64, 64))
	header.add_child(icon)

	var head_info := VBoxContainer.new()
	head_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var row_data: Dictionary = _item_rows.get(inst.get("id", ""), {})
	var title_lbl := Label.new()
	title_lbl.text = String(row_data.get("name", inst.get("id", "")))
	title_lbl.add_theme_font_size_override("font_size", 18)
	title_lbl.add_theme_color_override("font_color", ItemIconResolver.rarity_color(String(inst.get("rarity", "Comum"))))
	head_info.add_child(title_lbl)

	var sub_head := Label.new()
	var slot_name: String = String(row_data.get("slot", "item")).capitalize()
	var pips := "●" if int(inst.get("reinforce", 0)) > 0 else "○"
	sub_head.text = "%s · %s · IP %d · Nv. %d · Reforço: %s" % [slot_name, String(inst.get("rarity", "Comum")), int(inst.get("item_power", 0)), int(inst.get("item_level", 0)), pips]
	sub_head.add_theme_font_size_override("font_size", 13)
	sub_head.add_theme_color_override("font_color", Color(0.7, 0.72, 0.76))
	head_info.add_child(sub_head)
	header.add_child(head_info)
	vbox.add_child(header)

	# 2. Tabela de Bônus e Comparação
	var bonus_title := Label.new()
	bonus_title.text = "Bônus do Item & Comparação:"
	bonus_title.add_theme_font_size_override("font_size", 15)
	bonus_title.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	vbox.add_child(bonus_title)

	var comp := ItemStatView.compare(inst, selected_hero_id, campaign, _item_rows)
	var diff_by_stat := {}
	for d in comp.get("diffs", []):
		diff_by_stat[d["stat"]] = d

	var b_lines := ItemStatView.lines(inst, _item_rows)
	for bline in b_lines:
		var stat: String = bline["stat"]
		var diff_info: Dictionary = diff_by_stat.get(stat, {})
		var row_h := HBoxContainer.new()
		row_h.add_theme_constant_override("separation", 10)

		var name_lbl := Label.new()
		name_lbl.text = "%s %s" % [bline["glyph"], bline["name"]]
		name_lbl.custom_minimum_size.x = 120
		name_lbl.add_theme_font_size_override("font_size", 14)
		row_h.add_child(name_lbl)

		var val_lbl := Label.new()
		val_lbl.text = ItemStatView.format_bonus_number(bline["value"], bline["kind"])
		val_lbl.custom_minimum_size.x = 70
		val_lbl.add_theme_font_size_override("font_size", 14)
		val_lbl.add_theme_color_override("font_color", Color(0.9, 0.92, 0.95))
		row_h.add_child(val_lbl)

		if not diff_info.is_empty():
			var d_info: Dictionary = diff_info["diff_info"]
			var d_chip := ItemStatView.create_stat_chip(d_info["text"], "", d_info["variant"])
			row_h.add_child(d_chip)

		vbox.add_child(row_h)

	# 3. Totais do Herói
	if comp["compatible"]:
		var tot_title := Label.new()
		tot_title.text = "Impacto no Herói (%s):" % String(hero_names.get(selected_hero_id, selected_hero_id))
		tot_title.add_theme_font_size_override("font_size", 14)
		tot_title.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
		vbox.add_child(tot_title)

		for d in comp.get("diffs", []):
			if ["attack", "max_hp", "defense"].has(d["stat"]) or absf(d["diff"]) > 0.0001:
				var h_tot_row := HBoxContainer.new()
				h_tot_row.add_theme_constant_override("separation", 8)
				var lbl := Label.new()
				var dinfo: Dictionary = d["diff_info"]
				var curr_str := ItemStatView.format_number(d["curr_val"], d["kind"])
				var next_str := ItemStatView.format_number(d["next_val"], d["kind"])
				lbl.text = "%s %s: %s → %s (%s)" % [d["glyph"], d["name"], curr_str, next_str, dinfo["text"]]
				lbl.add_theme_font_size_override("font_size", 13)
				h_tot_row.add_child(lbl)
				vbox.add_child(h_tot_row)

	# 4. Descrição de Identidade
	var desc_text: String = String(row_data.get("flavor_text", row_data.get("description", "")))
	if desc_text != "":
		var desc_lbl := Label.new()
		desc_lbl.text = desc_text
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.add_theme_font_size_override("font_size", 12)
		desc_lbl.add_theme_color_override("font_color", Color(0.6, 0.63, 0.68))
		vbox.add_child(desc_lbl)

	# 5. Botões de Ação da Gaveta
	var drawer_actions := HBoxContainer.new()
	drawer_actions.add_theme_constant_override("separation", 10)
	var uid := int(inst["uid"])

	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.custom_minimum_size = Vector2(100, 48)
	close_btn.pressed.connect(func():
		_drawer_overlay.queue_free()
		_drawer_overlay = null)
	drawer_actions.add_child(close_btn)

	var equip_btn := Button.new()
	equip_btn.text = "Equipar em %s" % String(hero_names.get(selected_hero_id, selected_hero_id))
	equip_btn.custom_minimum_size.y = 48
	equip_btn.disabled = campaign.inventory.locked
	equip_btn.pressed.connect(func():
		equip_item(uid, selected_hero_id)
		if _drawer_overlay:
			_drawer_overlay.queue_free()
			_drawer_overlay = null)
	drawer_actions.add_child(equip_btn)

	vbox.add_child(drawer_actions)
	add_child(_drawer_overlay)

func _report(error: String) -> void:
	var texts := {"locked": "Não é possível mudar o equipamento durante uma expedição.", "incompatible": "Esse item não serve para esse herói.",
		"unknown": "Item não encontrado.", "equipped": "Desequipe o item antes de reciclar.", "not_recyclable": "Esse item não pode ser reciclado.",
		"service": "A desmontagem fica no Ferreiro, depois de restaurá-lo na Árvore dos Ecos.", "favorite": "Item favorito não pode ser desmontado."}
	_message.text = String(texts.get(error, ""))

func equip_item(uid: int, hero_id: String) -> String:
	var err := campaign.equip(hero_id, uid)
	_report(err)
	refresh()
	if err == "":
		changed.emit()
	return err

func unequip_item(uid: int) -> String:
	var err := campaign.unequip(uid)
	_report(err)
	refresh()
	if err == "":
		changed.emit()
	return err

func recycle_item(uid: int) -> Dictionary:
	var res := campaign.recycle(uid)
	_report(String(res["error"]))
	if res["ok"]:
		_message.text = "Reciclado: +%d Resíduo de Lúmen." % int(res["residue"])
	refresh()
	if res["ok"]:
		changed.emit()
	return res

func auto_equip_all() -> void:
	campaign.auto_equip(hero_names.keys())
	_message.text = ""
	refresh()
	changed.emit()
