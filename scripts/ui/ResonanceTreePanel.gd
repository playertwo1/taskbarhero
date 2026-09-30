extends Control
class_name ResonanceTreePanel

## Árvore dos Ecos do slice (SLICE-1D): 6 nós da Oficina. Sem regra própria: compra via SliceCampaign.

signal changed
signal closed

const DESCRIPTIONS := {
	"TREE_VIG_001": "Início da árvore. Já ativa.",
	"TREE_VIG_002": "Vida máxima dos heróis (efeito ainda não aplicado no slice).",
	"TREE_VIG_005": "Ressonância Estável: abre os outros ramos.",
	"TREE_OFI_001": "Restaura o Ferreiro no Refúgio.",
	"TREE_OFI_002": "O Ferreiro passa a desmontar equipamento, com confirmação e proteção de favoritos.",
	"TREE_OFI_003": "O Ferreiro passa a oferecer Reforço +1.",
}
const ERRORS := {"owned": "Esse nó já está ativo.", "prereq": "Falta comprar o nó anterior.", "fragments": "Fragmentos insuficientes.", "unknown": "Nó desconhecido."}

var campaign: SliceCampaign
var _list: VBoxContainer
var _summary: Label
var _message: Label

func setup(new_campaign: SliceCampaign) -> void:
	campaign = new_campaign
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
	add_child(scroll)
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 18)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)

	# Cabeçalho com ícone
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	var tree_ico := TextureRect.new()
	tree_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tree_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tree_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tree_ico.custom_minimum_size = Vector2(40, 40)
	if ResourceLoader.exists("res://assets/sprites/hub/hub_arvore_dos_ecos.png"):
		tree_ico.texture = load("res://assets/sprites/hub/hub_arvore_dos_ecos.png")
	header.add_child(tree_ico)

	var title_box := VBoxContainer.new()
	var title := Label.new()
	title.text = "Árvore dos Ecos"
	title.add_theme_font_size_override("font_size", 22)
	title_box.add_child(title)
	_summary = Label.new()
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
	return campaign.tree.node_ids().size()

func summary_text() -> String:
	return "Fragmentos de Ressonância: %d" % int(campaign.data["fragments"])

## "active", "available", "locked" ou "expensive" (pré-requisito ok, mas faltam Fragmentos).
func node_state(id: String) -> String:
	match campaign.tree.can_buy(campaign.data, id):
		"owned":
			return "active"
		"prereq":
			return "locked"
		"fragments":
			return "expensive"
	return "available"

func refresh() -> void:
	_summary.text = summary_text()
	for child in _list.get_children():
		child.queue_free()
	for id in campaign.tree.node_ids():
		_list.add_child(_row(String(id)))

func _row(id: String) -> Control:
	var node := campaign.tree.node(id)
	var state := node_state(id)

	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.11, 0.08, 0.85) if state == "active" else Color(0.06, 0.08, 0.1, 0.85)
	style.border_color = Color(0.28, 0.78, 0.45, 0.6) if state == "active" else Color(0.2, 0.23, 0.26, 0.5)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", style)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var status: String = {"active": "ativo", "available": "disponível", "expensive": "faltam Fragmentos", "locked": "bloqueado"}[state]
	label.text = "%s · %d Fragmentos · %s\n%s" % [node["name"], campaign.tree.cost(id), status, DESCRIPTIONS.get(id, "")]
	if state == "active":
		label.add_theme_color_override("font_color", Color(0.35, 0.85, 0.55))
	elif state == "available":
		label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.8))
	else:
		label.add_theme_color_override("font_color", Color(0.55, 0.58, 0.62))
	box.add_child(label)
	if state == "available" or state == "expensive":
		var buy := Button.new()
		buy.text = "Comprar"
		buy.custom_minimum_size.y = 48
		buy.disabled = state == "expensive"
		buy.pressed.connect(func(): buy_node(id))
		box.add_child(buy)
	panel.add_child(box)
	return panel

func buy_node(id: String) -> String:
	var err := campaign.buy_tree_node(id)
	_message.text = String(ERRORS.get(err, "Nó ativado: %s." % campaign.tree.node(id).get("name", id)))
	refresh()
	if err == "":
		changed.emit()
	return err
