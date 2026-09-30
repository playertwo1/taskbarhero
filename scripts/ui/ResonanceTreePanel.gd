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
	title.text = "Árvore dos Ecos"
	title.add_theme_font_size_override("font_size", 23)
	column.add_child(title)
	_summary = Label.new()
	column.add_child(_summary)
	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_message)
	_list = VBoxContainer.new()
	_list.add_theme_constant_override("separation", 8)
	column.add_child(_list)
	var back := Button.new()
	back.text = "Voltar"
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
	var box := VBoxContainer.new()
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var status: String = {"active": "ativo", "available": "disponível", "expensive": "faltam Fragmentos", "locked": "bloqueado"}[state]
	label.text = "%s · %d Fragmentos · %s\n%s" % [node["name"], campaign.tree.cost(id), status, DESCRIPTIONS.get(id, "")]
	box.add_child(label)
	if state == "available" or state == "expensive":
		var buy := Button.new()
		buy.text = "Comprar"
		buy.custom_minimum_size.y = 50
		buy.disabled = state == "expensive"
		buy.pressed.connect(func(): buy_node(id))
		box.add_child(buy)
	return box

func buy_node(id: String) -> String:
	var err := campaign.buy_tree_node(id)
	_message.text = String(ERRORS.get(err, "Nó ativado: %s." % campaign.tree.node(id).get("name", id)))
	refresh()
	if err == "":
		changed.emit()
	return err
