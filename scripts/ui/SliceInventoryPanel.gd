extends Control
class_name SliceInventoryPanel

## Inventário do slice (SLICE-1B Plano B): lista, equipar/desequipar e reciclar. Sem regra própria:
## tudo passa por SliceCampaign/SliceInventory. Montada em código, como o SliceProbe.

signal changed
signal closed

var campaign: SliceCampaign
var hero_names: Dictionary = {}
var _item_rows: Dictionary = {}
var _list: VBoxContainer
var _summary: Label
var _echo_status: Label
var _echo_button: Button
var _message: Label

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
	var background := ColorRect.new()
	background.color = Color(0.03, 0.04, 0.05, 0.96)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 18)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)
	var title := Label.new()
	title.text = "Inventário"
	title.add_theme_font_size_override("font_size", 23)
	column.add_child(title)
	_summary = Label.new()
	column.add_child(_summary)
	_echo_status = Label.new()
	column.add_child(_echo_status)
	_echo_button = Button.new()
	_echo_button.custom_minimum_size.y = 50
	_echo_button.pressed.connect(_toggle_echo)
	column.add_child(_echo_button)
	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_message)
	var best := Button.new()
	best.text = "Equipar os melhores"
	best.custom_minimum_size.y = 50
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

func _row(inst: Dictionary, owner_id: String) -> Control:
	var box := VBoxContainer.new()
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = SliceLogText.item_label(inst, _item_rows) + ("  · equipado: %s" % hero_names.get(owner_id, owner_id) if owner_id != "" else "")
	box.add_child(label)
	var actions := HBoxContainer.new()
	var uid := int(inst["uid"])
	if owner_id == "":
		var picker := OptionButton.new()
		var compatible: Array = _item_rows.get(inst["id"], {}).get("compatible_heroes", [])
		for hero_id in compatible:
			picker.add_item(String(hero_names.get(hero_id, hero_id)))
			picker.set_item_metadata(picker.item_count - 1, hero_id)
		picker.custom_minimum_size.y = 50
		actions.add_child(picker)
		var equip := Button.new()
		equip.text = "Equipar"
		equip.custom_minimum_size.y = 50
		equip.pressed.connect(func(): equip_item(uid, String(picker.get_item_metadata(picker.selected))))
		actions.add_child(equip)
	else:
		var unequip := Button.new()
		unequip.text = "Desequipar"
		unequip.custom_minimum_size.y = 50
		unequip.pressed.connect(func(): unequip_item(uid))
		actions.add_child(unequip)
	box.add_child(actions)
	return box

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
