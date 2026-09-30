extends Control
class_name BlacksmithPanel

## Ferreiro do slice (SLICE-1D / UI_S12): desmontagem com confirmação, Reforço +1, favoritos,
## chips de status (C1), linhas de item (C2), gaveta de detalhes (C3) e prévia do reforço (C5).
## Sem regra própria: tudo passa por SliceCampaign e ItemStatView. Só abre com `TREE_OFI_001`.

signal changed
signal closed

const ItemIconResolver = preload("res://scripts/ui/ItemIconResolver.gd")
const ItemStatView = preload("res://scripts/ui/ItemStatView.gd")

const ERRORS := {
	"service": "Esse serviço ainda não foi restaurado na Árvore dos Ecos.",
	"locked": "O Ferreiro fecha durante uma expedição.",
	"unknown": "Item não encontrado.",
	"equipped": "Desequipe o item antes de desmontar.",
	"favorite": "Item favorito não pode ser desmontado. Tire o favorito primeiro.",
	"not_recyclable": "Esse item não pode ser desmontado.",
	"ineligible": "Só Arma, Secundário e Armadura recebem Reforço.",
	"maxed": "Esse item já tem Reforço +1.",
	"materials": "Resíduo de Lúmen insuficiente.",
}

var campaign: SliceCampaign
var hero_names: Dictionary = {}
## uid do item aguardando a confirmação de desmontagem (0 = nenhum).
var pending_uid: int = 0
var _item_rows: Dictionary = {}
var _list: VBoxContainer
var _summary: Label
var _message: Label
var _drawer_overlay: Control = null

func setup(new_campaign: SliceCampaign, names: Dictionary) -> void:
	campaign = new_campaign
	hero_names = names
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

	# Cabeçalho com ícone
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	var forge_ico := TextureRect.new()
	forge_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	forge_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forge_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	forge_ico.custom_minimum_size = Vector2(40, 40)
	if ResourceLoader.exists("res://assets/sprites/hub/hub_ferreiro.png"):
		forge_ico.texture = load("res://assets/sprites/hub/hub_ferreiro.png")
	header.add_child(forge_ico)

	var title_box := VBoxContainer.new()
	var title := Label.new()
	title.text = "Ferreiro de Lúmen"
	title.add_theme_font_size_override("font_size", 22)
	title_box.add_child(title)
	_summary = Label.new()
	_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary.add_theme_font_size_override("font_size", 14)
	_summary.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	title_box.add_child(_summary)
	header.add_child(title_box)
	column.add_child(header)

	# Divisor UI Kit
	var div := TextureRect.new()
	div.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	div.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	div.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	div.custom_minimum_size = Vector2(0, 8)
	if ResourceLoader.exists("res://assets/sprites/ui/ui_kit/ui_kit_divider.png"):
		div.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_divider.png")
	column.add_child(div)

	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_message)

	_list = VBoxContainer.new()
	_list.add_theme_constant_override("separation", 8)
	column.add_child(_list)

	var back := Button.new()
	back.text = "Voltar ao Refúgio"
	back.custom_minimum_size.y = 50
	back.pressed.connect(func(): closed.emit())
	column.add_child(back)

func row_count() -> int:
	return campaign.inventory.items.size()

func summary_text() -> String:
	var rule := campaign.blacksmith_rule
	var parts: Array = ["Resíduo de Lúmen: %d" % int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0))]
	parts.append("Desmontagem: %s" % ("aberta" if campaign.can_disassemble() else "fechada"))
	parts.append("Reforço +1 (%d Resíduos): %s" % [int(rule.get("material_quantity", 0)), "aberto" if campaign.can_reinforce() else "fechado"])
	return " · ".join(parts)

func refresh() -> void:
	_summary.text = summary_text()
	for child in _list.get_children():
		child.queue_free()
	var worn := {}
	for hero_id in campaign.inventory.equipped:
		for uid in campaign.inventory.equipped[hero_id]:
			worn[int(uid)] = String(hero_id)
	for inst in campaign.inventory.items:
		_list.add_child(_row(inst, String(worn.get(int(inst["uid"]), ""))))

## C2 — Linha de item do Ferreiro (UI_S12):
## Ícone, moldura de raridade, chips de bônus, prévia do reforço (C5) e ações.
func _row(inst: Dictionary, owner_id: String) -> Control:
	var uid := int(inst["uid"])
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
	var tags: Array = []
	if int(inst.get("reinforce", 0)) > 0:
		tags.append("Reforço +%d" % int(inst["reinforce"]))
	if bool(inst.get("favorite", false)):
		tags.append("favorito ★")
	if owner_id != "":
		tags.append("equipado: %s" % hero_names.get(owner_id, owner_id))
	label.text = SliceLogText.item_label(inst, _item_rows) + ("  · " + ", ".join(tags) if not tags.is_empty() else "")
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

	# Chips de Bônus (C1)
	var chips_row := HBoxContainer.new()
	chips_row.add_theme_constant_override("separation", 6)
	var bonus_lines := ItemStatView.lines(inst, _item_rows)
	for i in mini(3, bonus_lines.size()):
		var bline: Dictionary = bonus_lines[i]
		chips_row.add_child(ItemStatView.create_stat_chip(ItemStatView.format_bonus_number(bline["value"], bline["kind"]), bline["glyph"], "neutral"))
	box.add_child(chips_row)

	# C5 — Prévia do Reforço (Ferreiro) se serviço aberto e elegível
	var rule := campaign.blacksmith_rule
	var is_eligible: bool = rule.get("slots", []).has(row_data.get("slot", ""))
	if campaign.can_reinforce() and is_eligible and int(inst.get("reinforce", 0)) < int(rule.get("max_level", 1)):
		var prev_box := ItemStatView.create_reinforce_preview_box(inst, _item_rows)
		box.add_child(prev_box)

	# Ações
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 6)

	var details_btn := Button.new()
	details_btn.text = "Detalhes"
	details_btn.custom_minimum_size.y = 44
	details_btn.pressed.connect(func(): _open_drawer(inst))
	actions.add_child(details_btn)

	var fav := Button.new()
	fav.text = "Tirar favorito" if bool(inst.get("favorite", false)) else "Favoritar"
	fav.custom_minimum_size.y = 44
	fav.pressed.connect(func(): toggle_favorite(uid))
	actions.add_child(fav)

	if campaign.can_reinforce():
		var up := Button.new()
		up.text = "Reforçar"
		up.custom_minimum_size.y = 44
		up.pressed.connect(func(): reinforce_item(uid))
		actions.add_child(up)

	if campaign.can_disassemble():
		var dis := Button.new()
		dis.text = "Confirmar desmontagem" if pending_uid == uid else "Desmontar"
		dis.custom_minimum_size.y = 44
		dis.pressed.connect(func(): press_disassemble(uid))
		actions.add_child(dis)

	box.add_child(actions)
	panel.add_child(box)
	return panel

## C3 — Gaveta de Detalhes no Ferreiro
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

	# 2. Bônus do item
	var bonus_title := Label.new()
	bonus_title.text = "Bônus do Item:"
	bonus_title.add_theme_font_size_override("font_size", 15)
	bonus_title.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	vbox.add_child(bonus_title)

	var b_lines := ItemStatView.lines(inst, _item_rows)
	for bline in b_lines:
		var row_h := HBoxContainer.new()
		row_h.add_theme_constant_override("separation", 10)
		var name_lbl := Label.new()
		name_lbl.text = "%s %s" % [bline["glyph"], bline["name"]]
		name_lbl.custom_minimum_size.x = 140
		name_lbl.add_theme_font_size_override("font_size", 14)
		row_h.add_child(name_lbl)

		var val_lbl := Label.new()
		val_lbl.text = ItemStatView.format_bonus_number(bline["value"], bline["kind"])
		val_lbl.add_theme_font_size_override("font_size", 14)
		val_lbl.add_theme_color_override("font_color", Color(0.9, 0.92, 0.95))
		row_h.add_child(val_lbl)
		vbox.add_child(row_h)

	# 3. Prévia do Reforço (C5) na Gaveta
	var rule := campaign.blacksmith_rule
	var is_eligible: bool = rule.get("slots", []).has(row_data.get("slot", ""))
	if is_eligible and int(inst.get("reinforce", 0)) < int(rule.get("max_level", 1)):
		vbox.add_child(ItemStatView.create_reinforce_preview_box(inst, _item_rows))

	# 4. Descrição
	var desc_text: String = String(row_data.get("flavor_text", row_data.get("description", "")))
	if desc_text != "":
		var desc_lbl := Label.new()
		desc_lbl.text = desc_text
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.add_theme_font_size_override("font_size", 12)
		desc_lbl.add_theme_color_override("font_color", Color(0.6, 0.63, 0.68))
		vbox.add_child(desc_lbl)

	# 5. Ações
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

	var fav_btn := Button.new()
	fav_btn.text = "Tirar favorito" if bool(inst.get("favorite", false)) else "Favoritar"
	fav_btn.custom_minimum_size.y = 48
	fav_btn.pressed.connect(func():
		toggle_favorite(uid)
		if _drawer_overlay:
			_drawer_overlay.queue_free()
			_drawer_overlay = null)
	drawer_actions.add_child(fav_btn)

	vbox.add_child(drawer_actions)
	add_child(_drawer_overlay)

func _fail(err: String) -> void:
	_message.text = String(ERRORS.get(err, ""))

func toggle_favorite(uid: int) -> String:
	var inst := campaign.inventory.find(uid)
	var err := campaign.set_favorite(uid, not bool(inst.get("favorite", false)))
	_fail(err)
	if pending_uid == uid:
		pending_uid = 0
	refresh()
	if err == "":
		changed.emit()
	return err

func reinforce_item(uid: int) -> String:
	var err := campaign.reinforce(uid)
	_fail(err)
	if err == "":
		_message.text = "Reforço +1 aplicado."
	refresh()
	if err == "":
		changed.emit()
	return err

## Primeiro toque pede confirmação (error "confirm"); o segundo no mesmo item desmonta.
func press_disassemble(uid: int) -> Dictionary:
	if pending_uid != uid:
		var inst := campaign.inventory.find(uid)
		if inst.is_empty():
			_fail("unknown")
			return {"ok": false, "error": "unknown", "residue": 0}
		if bool(inst.get("favorite", false)):
			_fail("favorite")
			return {"ok": false, "error": "favorite", "residue": 0}
		pending_uid = uid
		_message.text = "Desmontar destrói o item e rende Resíduo de Lúmen. Toque de novo para confirmar."
		refresh()
		return {"ok": false, "error": "confirm", "residue": 0}
	pending_uid = 0
	var res := campaign.recycle(uid)
	if res["ok"]:
		_message.text = "Desmontado: +%d Resíduo de Lúmen." % int(res["residue"])
	else:
		_fail(String(res["error"]))
	refresh()
	if res["ok"]:
		changed.emit()
	return res
