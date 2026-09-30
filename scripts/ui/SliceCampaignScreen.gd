extends Control
class_name SliceCampaignScreen

## Fluxo jogável do slice (SLICE-1B Plano B): Preparação → Expedição → Resultado, com inventário.
## Montada em código (como o SliceProbe). Toda regra vem do núcleo; aqui só há apresentação.
## 1D: a preparação é o Refúgio provisório, com Árvore dos Ecos e Ferreiro (sem arte própria ainda).

const HERO_NAMES := {"hero_001": "Bastião", "hero_002": "Flecha", "hero_003": "Íris"}
const HERO_SPRITES := {
	"hero_001": "res://assets/sprites/heroes/bastiao/hero_bastiao_96x96.png",
	"hero_002": "res://assets/sprites/heroes/flecha/hero_flecha_96x96.png",
	"hero_003": "res://assets/sprites/heroes/iris/hero_iris_96x96.png",
}
const HERO_ROLES := {
	"hero_001": "Guardião · Linha de Frente",
	"hero_002": "Sentinela · Fundo de Campo",
	"hero_003": "Maga · Linha Média",
}
const BUILD_DESCRIPTIONS := {
	"guardiao": "Defesa elevada, Bloqueio contínuo e geração sustentada de Guarda.",
	"retaliacao": "Contra-ataque massivo de impacto disparado logo após bloquear.",
	"retaliacao_tele": "Contra-ataque reservado para anular e punir golpes telegrafados.",
	"critico": "Foco em alta taxa e multiplicador crítico com disparos velozes.",
	"marca": "Aplica Marca nos alvos, expondo suas fraquezas e aumentando dano do trio.",
	"arcano": "Dano massivo em área e rajadas contínuas de energia de Lúmen.",
	"controle": "Desaceleração de ações inimigas e atordoamento de alvos prioritários.",
	"lumen": "Restauração contínua de Vida e barreiras protetoras para manter a party viva.",
}
const SAVE_PATH := "user://slice_save.json"
const LOG_LIMIT := 40
const ItemIconResolver = preload("res://scripts/ui/ItemIconResolver.gd")

var save_path: String = SAVE_PATH
var campaign: SliceCampaign
var run: ExpeditionRun
var mode: String = "prep"
## Velocidades oferecidas ao jogador (UI_S05); ×20 só em build de debug.
const SPEEDS := [1.0, 2.0, 3.0, 4.0]
const DEBUG_SPEED := 20.0

var speed: float = 1.0
var paused: bool = false

var _ctx: Dictionary = {}
var _log: Array = []
var _result: String = ""
## Build escolhida por herói (UI_S04); começa no primeiro preset.
var selected_build: Dictionary = {}
var _build_pickers: Dictionary = {}
var _prep_box: VBoxContainer
var _run_box: VBoxContainer
var _result_box: VBoxContainer
var _status: Label
var _hp: Label
var _log_label: Label
var _choice_box: VBoxContainer
var _prep_info: Label
var _result_label: Label
var _pause_button: Button
var _speed_buttons: Dictionary = {}
var _panel: Control
var _blacksmith_button: Button
var _arena_box: Control
var _hero_actor: Node2D
var _enemy_actor: Node2D
var _res_badges: HBoxContainer
var _frag_label: Label
var _res_label: Label
var _xp_label: Label
var _refugio_banner: TextureRect
var _refugio_title: Label
var _refugio_subtitle: Label
var _blacksmith_card: Control
var _build_desc_labels: Dictionary = {}
var _result_title: Label
var _result_subtitle: Label
var _result_badges: HBoxContainer
var _result_items_box: HBoxContainer
var _result_xp_val: Label
var _result_res_val: Label
var _result_frag_val: Label

func _ready() -> void:
	campaign = SliceCampaign.open(save_path)
	var route: Dictionary = SliceSession.data()["route"]
	var node_names := {}
	for node in route.get("nodes", []):
		node_names[node["id"]] = node.get("name", node["id"])
	var item_rows := {}
	for row in SliceSession.data()["items"]:
		item_rows[row["id"]] = row
	var enemy_names := {}
	for row in SliceSession.data()["enemies"]:
		enemy_names[row["id"]] = row.get("name", row["id"])
	_ctx = {"node_names": node_names, "hero_names": HERO_NAMES, "enemy_names": enemy_names, "item_rows": item_rows, "texts": EventTexts.create(EventTexts.load_texts())}
	_build_ui()
	_show("prep")

func _build_ui() -> void:
	var def_theme: Theme = load("res://assets/ui/pocket_hero_theme.tres")
	if def_theme:
		theme = def_theme
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 24)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)
	_prep_box = VBoxContainer.new()
	_prep_box.add_theme_constant_override("separation", 12)
	root.add_child(_prep_box)
	_run_box = VBoxContainer.new()
	_run_box.add_theme_constant_override("separation", 12)
	root.add_child(_run_box)
	_result_box = VBoxContainer.new()
	_result_box.add_theme_constant_override("separation", 12)
	root.add_child(_result_box)
	_build_prep()
	_build_run()
	_build_result()

func _button(text: String, on_press: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size.y = 50
	b.pressed.connect(on_press)
	return b

func _label(autowrap: bool = true) -> Label:
	var l := Label.new()
	if autowrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

func _build_prep() -> void:
	_refugio_title = Label.new()
	_refugio_title.text = "Refúgio de Lúmen"
	_refugio_title.add_theme_font_size_override("font_size", 24)
	_prep_box.add_child(_refugio_title)
	_refugio_subtitle = _label()
	_refugio_subtitle.text = "Santuário sob a névoa do Bosque · A Lanterna protege a party"
	_refugio_subtitle.add_theme_color_override("font_color", Color(0.7, 0.75, 0.8))
	_prep_box.add_child(_refugio_subtitle)

	# Barra de Recursos (TopBar)
	_res_badges = HBoxContainer.new()
	_res_badges.add_theme_constant_override("separation", 16)
	var frag_box := HBoxContainer.new()
	var frag_ico := TextureRect.new()
	frag_ico.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_icon_fragment_24.png")
	frag_ico.custom_minimum_size = Vector2(24, 24)
	frag_box.add_child(frag_ico)
	_frag_label = Label.new()
	frag_box.add_child(_frag_label)
	_res_badges.add_child(frag_box)
	var res_box := HBoxContainer.new()
	var res_ico := TextureRect.new()
	res_ico.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_icon_residue_24.png")
	res_ico.custom_minimum_size = Vector2(24, 24)
	res_box.add_child(res_ico)
	_res_label = Label.new()
	res_box.add_child(_res_label)
	_res_badges.add_child(res_box)
	var xp_box := HBoxContainer.new()
	var xp_ico := TextureRect.new()
	xp_ico.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_icon_xp_24.png")
	xp_ico.custom_minimum_size = Vector2(24, 24)
	xp_box.add_child(xp_ico)
	_xp_label = Label.new()
	xp_box.add_child(_xp_label)
	_res_badges.add_child(xp_box)
	_prep_box.add_child(_res_badges)

	# Banner Visual do Refúgio (Diorama Hub)
	var banner_frame := PanelContainer.new()
	banner_frame.custom_minimum_size = Vector2(0, 190)
	var banner_box := Control.new()
	banner_box.custom_minimum_size = Vector2(0, 190)
	banner_box.clip_contents = true
	banner_frame.add_child(banner_box)

	_refugio_banner = TextureRect.new()
	_refugio_banner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_refugio_banner.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_refugio_banner.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_refugio_banner.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_refugio_banner.texture = load("res://assets/sprites/hub/hub_refugio_mobile_completo.png")
	banner_box.add_child(_refugio_banner)

	# Heróis descansando no refúgio
	var party_layer := HBoxContainer.new()
	party_layer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	party_layer.offset_bottom = -8
	party_layer.alignment = BoxContainer.ALIGNMENT_CENTER
	party_layer.add_theme_constant_override("separation", 20)

	var bastiao_ico := TextureRect.new()
	bastiao_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	bastiao_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bastiao_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bastiao_ico.custom_minimum_size = Vector2(56, 56)
	bastiao_ico.texture = load("res://assets/sprites/heroes/bastiao/hero_bastiao_96x96.png")
	party_layer.add_child(bastiao_ico)

	var flecha_ico := TextureRect.new()
	flecha_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	flecha_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	flecha_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	flecha_ico.custom_minimum_size = Vector2(56, 56)
	flecha_ico.texture = load("res://assets/sprites/heroes/flecha/hero_flecha_96x96.png")
	party_layer.add_child(flecha_ico)

	var iris_ico := TextureRect.new()
	iris_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	iris_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	iris_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	iris_ico.custom_minimum_size = Vector2(56, 56)
	iris_ico.texture = load("res://assets/sprites/heroes/iris/hero_iris_96x96.png")
	party_layer.add_child(iris_ico)

	banner_box.add_child(party_layer)
	_prep_box.add_child(banner_frame)

	_prep_info = _label()
	_prep_box.add_child(_prep_info)

	# Serviços do Refúgio (Cards com miniaturas)
	var services_title := Label.new()
	services_title.text = "Serviços do Refúgio"
	services_title.add_theme_font_size_override("font_size", 18)
	_prep_box.add_child(services_title)

	# Card Árvore dos Ecos
	var tree_card := HBoxContainer.new()
	tree_card.add_theme_constant_override("separation", 12)
	var tree_thumb := TextureRect.new()
	tree_thumb.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tree_thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tree_thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tree_thumb.custom_minimum_size = Vector2(48, 48)
	tree_thumb.texture = load("res://assets/sprites/hub/hub_arvore_dos_ecos.png")
	tree_card.add_child(tree_thumb)
	var tree_btn := _button("Árvore dos Ecos", _open_tree)
	tree_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tree_card.add_child(tree_btn)
	_prep_box.add_child(tree_card)

	# Card Ferreiro de Lúmen
	_blacksmith_card = HBoxContainer.new()
	_blacksmith_card.add_theme_constant_override("separation", 12)
	var forge_thumb := TextureRect.new()
	forge_thumb.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	forge_thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forge_thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	forge_thumb.custom_minimum_size = Vector2(48, 48)
	forge_thumb.texture = load("res://assets/sprites/hub/hub_ferreiro.png")
	_blacksmith_card.add_child(forge_thumb)
	_blacksmith_button = _button("Ferreiro", _open_blacksmith)
	_blacksmith_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_blacksmith_card.add_child(_blacksmith_button)
	_prep_box.add_child(_blacksmith_card)

	# Card Inventário
	var inv_card := HBoxContainer.new()
	inv_card.add_theme_constant_override("separation", 12)
	var inv_thumb := TextureRect.new()
	inv_thumb.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	inv_thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	inv_thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	inv_thumb.custom_minimum_size = Vector2(48, 48)
	inv_thumb.texture = ItemIconResolver.get_texture("echo_c1_001")
	inv_card.add_child(inv_thumb)
	var inv_btn := _button("Inventário", _open_inventory)
	inv_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inv_card.add_child(inv_btn)
	_prep_box.add_child(inv_card)

	# Seção de Preparação da Expedição
	var exp_title := Label.new()
	exp_title.text = "Preparar Expedição (Bosque de Lúmen)"
	exp_title.add_theme_font_size_override("font_size", 18)
	_prep_box.add_child(exp_title)

	selected_build = SliceSession.BUILD_PRESETS[0]["heroes"].duplicate()
	var presets := OptionButton.new()
	presets.add_item("Atalho: escolher um preset")
	for preset in SliceSession.BUILD_PRESETS:
		presets.add_item("Preset: %s" % preset["name"])
	presets.custom_minimum_size.y = 50
	presets.item_selected.connect(func(index: int):
		if index > 0:
			apply_preset(index - 1)
			presets.select(0))
	_prep_box.add_child(presets)

	for hero_id in SliceSession.BUILD_OPTIONS:
		var hero_card := PanelContainer.new()
		var card_style := StyleBoxFlat.new()
		card_style.bg_color = Color(0.06, 0.08, 0.1, 0.9)
		card_style.set_corner_radius_all(6)
		card_style.content_margin_left = 10
		card_style.content_margin_right = 10
		card_style.content_margin_top = 8
		card_style.content_margin_bottom = 8
		hero_card.add_theme_stylebox_override("panel", card_style)

		var card_vbox := VBoxContainer.new()
		card_vbox.add_theme_constant_override("separation", 6)

		var top_row := HBoxContainer.new()
		top_row.add_theme_constant_override("separation", 10)

		var portrait := TextureRect.new()
		portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size = Vector2(48, 48)
		if ResourceLoader.exists(HERO_SPRITES.get(hero_id, "")):
			portrait.texture = load(HERO_SPRITES[hero_id])
		top_row.add_child(portrait)

		var info_box := VBoxContainer.new()
		info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_box.add_theme_constant_override("separation", 2)
		var name_label := Label.new()
		name_label.text = "%s  ·  %s" % [String(HERO_NAMES.get(hero_id, hero_id)), String(HERO_ROLES.get(hero_id, ""))]
		name_label.add_theme_font_size_override("font_size", 14)
		info_box.add_child(name_label)

		var picker := OptionButton.new()
		picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		picker.custom_minimum_size.y = 44
		for key in SliceSession.BUILD_OPTIONS[hero_id]:
			picker.add_item(String(SliceSession.BUILD_LABELS[key]))
		var owner_id: String = hero_id
		picker.item_selected.connect(func(index: int): set_build(owner_id, String(SliceSession.BUILD_OPTIONS[owner_id][index])))
		info_box.add_child(picker)
		_build_pickers[hero_id] = picker
		top_row.add_child(info_box)
		card_vbox.add_child(top_row)

		var desc := Label.new()
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc.add_theme_font_size_override("font_size", 12)
		desc.add_theme_color_override("font_color", Color(0.72, 0.76, 0.8))
		card_vbox.add_child(desc)
		_build_desc_labels[hero_id] = desc

		hero_card.add_child(card_vbox)
		_prep_box.add_child(hero_card)
	_sync_build_pickers()

	_prep_box.add_child(_button("Iniciar expedição", start_selected))
	if OS.is_debug_build():
		_prep_box.add_child(_button("Sondagem (dev)", func(): get_tree().change_scene_to_file("res://scenes/slice/SliceProbe.tscn")))
		_prep_box.add_child(_button("Voltar ao título", func(): get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")))

func _build_arena() -> void:
	_arena_box = Control.new()
	_arena_box.custom_minimum_size = Vector2(0, 190)
	_arena_box.clip_contents = true
	var stage := Node2D.new()
	stage.scale = Vector2(2, 2)
	_arena_box.add_child(stage)
	var bg_distant := Sprite2D.new()
	bg_distant.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	bg_distant.texture = load("res://assets/sprites/environment/bosque_lumen/bg_distant.png")
	bg_distant.centered = false
	stage.add_child(bg_distant)
	var mid_trees := Sprite2D.new()
	mid_trees.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	mid_trees.texture = load("res://assets/sprites/environment/bosque_lumen/mid_trees.png")
	mid_trees.centered = false
	stage.add_child(mid_trees)
	var ground := Sprite2D.new()
	ground.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	ground.position = Vector2(0, 68)
	ground.texture = load("res://assets/sprites/environment/bosque_lumen/ground_strip.png")
	ground.centered = false
	stage.add_child(ground)
	var bastiao_scn: PackedScene = load("res://scenes/heroes/Bastiao.tscn")
	if bastiao_scn:
		_hero_actor = bastiao_scn.instantiate()
		_hero_actor.position = Vector2(40, 96)
		stage.add_child(_hero_actor)
	var enemy_scn: PackedScene = load("res://scenes/enemies/JavaliDeMusgo.tscn")
	if enemy_scn:
		_enemy_actor = enemy_scn.instantiate()
		_enemy_actor.position = Vector2(170, 96)
		stage.add_child(_enemy_actor)

func _build_run() -> void:
	_build_arena()
	_run_box.add_child(_arena_box)
	_status = _label()
	_status.add_theme_font_size_override("font_size", 18)
	_run_box.add_child(_status)
	_hp = _label()
	_run_box.add_child(_hp)
	var controls := HBoxContainer.new()
	controls.add_theme_constant_override("separation", 6)
	_pause_button = _button("Pausar", toggle_pause)
	_pause_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	controls.add_child(_pause_button)
	var offered: Array = SPEEDS.duplicate()
	if OS.is_debug_build():
		offered.append(DEBUG_SPEED)
	for value in offered:
		var chosen: float = value
		var b := _button("×%d" % int(chosen), func(): set_speed(chosen))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		controls.add_child(b)
		_speed_buttons[chosen] = b
	_run_box.add_child(controls)
	_refresh_controls()
	_choice_box = VBoxContainer.new()
	_choice_box.add_theme_constant_override("separation", 8)
	_run_box.add_child(_choice_box)
	_log_label = _label()
	_run_box.add_child(_log_label)

func _build_result() -> void:
	var res_card := PanelContainer.new()
	var res_card_style := StyleBoxFlat.new()
	res_card_style.bg_color = Color(0.04, 0.05, 0.07, 0.95)
	res_card_style.set_corner_radius_all(8)
	res_card_style.content_margin_left = 14
	res_card_style.content_margin_right = 14
	res_card_style.content_margin_top = 14
	res_card_style.content_margin_bottom = 14
	res_card.add_theme_stylebox_override("panel", res_card_style)

	var res_vbox := VBoxContainer.new()
	res_vbox.add_theme_constant_override("separation", 10)

	_result_title = Label.new()
	_result_title.add_theme_font_size_override("font_size", 22)
	_result_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	res_vbox.add_child(_result_title)

	_result_subtitle = Label.new()
	_result_subtitle.add_theme_font_size_override("font_size", 14)
	_result_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_subtitle.add_theme_color_override("font_color", Color(0.75, 0.78, 0.8))
	res_vbox.add_child(_result_subtitle)

	# Divisor visual do UI Kit
	var div := TextureRect.new()
	div.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	div.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	div.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	div.custom_minimum_size = Vector2(0, 8)
	if ResourceLoader.exists("res://assets/sprites/ui/ui_kit/ui_kit_divider.png"):
		div.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_divider.png")
	res_vbox.add_child(div)

	# Badges com ícones de recompensas
	_result_badges = HBoxContainer.new()
	_result_badges.alignment = BoxContainer.ALIGNMENT_CENTER
	_result_badges.add_theme_constant_override("separation", 16)

	# Badge XP
	var xp_badge := HBoxContainer.new()
	xp_badge.add_theme_constant_override("separation", 6)
	var xp_ico := TextureRect.new()
	xp_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	xp_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	xp_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	xp_ico.custom_minimum_size = Vector2(24, 24)
	xp_ico.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_icon_xp_24.png")
	xp_badge.add_child(xp_ico)
	_result_xp_val = Label.new()
	_result_xp_val.add_theme_font_size_override("font_size", 15)
	xp_badge.add_child(_result_xp_val)
	_result_badges.add_child(xp_badge)

	# Badge Resíduo
	var res_badge := HBoxContainer.new()
	res_badge.add_theme_constant_override("separation", 6)
	var res_ico := TextureRect.new()
	res_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	res_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	res_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	res_ico.custom_minimum_size = Vector2(24, 24)
	res_ico.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_icon_residue_24.png")
	res_badge.add_child(res_ico)
	_result_res_val = Label.new()
	_result_res_val.add_theme_font_size_override("font_size", 15)
	res_badge.add_child(_result_res_val)
	_result_badges.add_child(res_badge)

	# Badge Fragmentos
	var frag_badge := HBoxContainer.new()
	frag_badge.add_theme_constant_override("separation", 6)
	var frag_ico := TextureRect.new()
	frag_ico.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	frag_ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frag_ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frag_ico.custom_minimum_size = Vector2(24, 24)
	frag_ico.texture = load("res://assets/sprites/ui/ui_kit/ui_kit_icon_fragment_24.png")
	frag_badge.add_child(frag_ico)
	_result_frag_val = Label.new()
	_result_frag_val.add_theme_font_size_override("font_size", 15)
	frag_badge.add_child(_result_frag_val)
	_result_badges.add_child(frag_badge)

	res_vbox.add_child(_result_badges)

	# Box para itens conquistados
	_result_items_box = HBoxContainer.new()
	_result_items_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_result_items_box.add_theme_constant_override("separation", 8)
	res_vbox.add_child(_result_items_box)

	# Rótulo canônico mantido para cobertura dos testes
	_result_label = _label()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	res_vbox.add_child(_result_label)

	res_card.add_child(res_vbox)
	_result_box.add_child(res_card)

	_result_box.add_child(_button("Inventário", _open_inventory))
	_result_box.add_child(_button("Voltar ao Refúgio", func(): _show("prep")))

func _show(new_mode: String) -> void:
	mode = new_mode
	_prep_box.visible = mode == "prep"
	_run_box.visible = mode == "run"
	_result_box.visible = mode == "result"
	if mode == "prep":
		var party: Dictionary = campaign.data["party"]
		_prep_info.text = "Nível do trio: %d · XP: %d\n%s" % [int(party["level"]), int(party["xp"]), summary_line()]
		var is_open: bool = campaign.blacksmith_open()
		_blacksmith_button.visible = is_open
		if _blacksmith_card:
			_blacksmith_card.visible = is_open
		if _frag_label:
			_frag_label.text = str(int(campaign.data["fragments"]))
		if _res_label:
			_res_label.text = str(int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0)))
		if _xp_label:
			_xp_label.text = "Lv. %d" % int(party["level"])
		var is_boss_cleared: bool = bool(campaign.data.get("boss_cleared", false))
		if _refugio_banner:
			if is_boss_cleared:
				_refugio_title.text = "Refúgio Restaurado"
				_refugio_subtitle.text = "A Chama da Lanterna-Mãe brilha límpida · O Guardião foi libertado"
				_refugio_banner.texture = load("res://assets/sprites/hub/hub_refugio_pos_boss.png")
			else:
				_refugio_title.text = "Refúgio de Lúmen"
				_refugio_subtitle.text = "Santuário sob a névoa do Bosque · A Lanterna protege a party"
				_refugio_banner.texture = load("res://assets/sprites/hub/hub_refugio_mobile_completo.png")
	if mode == "run":
		if _hero_actor and _hero_actor.has_method("reset"):
			_hero_actor.reset()
		if _enemy_actor and _enemy_actor.has_method("reset"):
			_enemy_actor.reset()
	if mode == "result":
		_result_label.text = _result

func summary_line() -> String:
	return "Itens: %d · Resíduo de Lúmen: %d · Fragmentos: %d%s" % [campaign.inventory.items.size(), int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0)), int(campaign.data["fragments"]),
		"\nAviso: o save não pôde ser lido (%s); nada será gravado." % campaign.save_error if campaign.save_blocked else ""]

## Define a velocidade (×1 a ×4; ×20 só em debug). Valor fora da lista é ignorado.
func set_speed(value: float) -> bool:
	if not (SPEEDS.has(value) or (OS.is_debug_build() and value == DEBUG_SPEED)):
		return false
	speed = value
	_refresh_controls()
	return true

## Pausa não altera a simulação: só deixa de avançar o tempo.
func toggle_pause() -> void:
	paused = not paused
	_refresh_controls()

func _refresh_controls() -> void:
	if _pause_button == null:
		return
	_pause_button.text = "Retomar" if paused else "Pausar"
	for value in _speed_buttons:
		_speed_buttons[value].disabled = is_equal_approx(float(value), speed)

func _open_inventory() -> void:
	_panel = SliceInventoryPanel.new()
	add_child(_panel)
	_panel.setup(campaign, HERO_NAMES)
	_panel.closed.connect(func():
		_panel.queue_free()
		_show(mode))

func _open_tree() -> void:
	var panel := ResonanceTreePanel.new()
	_open_overlay(panel)
	panel.setup(campaign)

func _open_blacksmith() -> void:
	var panel := BlacksmithPanel.new()
	_open_overlay(panel)
	panel.setup(campaign, HERO_NAMES)

func _open_overlay(panel: Control) -> void:
	_panel = panel
	add_child(panel)
	panel.closed.connect(func():
		panel.queue_free()
		_show(mode))

## Escolhe a build de um herói. Recusa herói ou build fora da lista.
func set_build(hero_id: String, key: String) -> bool:
	if not SliceSession.BUILD_OPTIONS.has(hero_id) or not SliceSession.BUILD_OPTIONS[hero_id].has(key):
		return false
	selected_build[hero_id] = key
	_sync_build_pickers()
	return true

func apply_preset(preset_index: int) -> void:
	selected_build = SliceSession.BUILD_PRESETS[preset_index]["heroes"].duplicate()
	_sync_build_pickers()

func _sync_build_pickers() -> void:
	for hero_id in _build_pickers:
		var opt_idx: int = SliceSession.BUILD_OPTIONS[hero_id].find(selected_build[hero_id])
		_build_pickers[hero_id].select(opt_idx)
		if _build_desc_labels.has(hero_id):
			_build_desc_labels[hero_id].text = BUILD_DESCRIPTIONS.get(selected_build[hero_id], "")

## Atalho usado por testes: aplica o preset e inicia.
func start_expedition(preset_index: int) -> void:
	apply_preset(preset_index)
	start_selected()

func start_selected() -> void:
	var build: Dictionary = selected_build.duplicate()
	_log = []
	_result = ""
	run = campaign.start_expedition(build, int(Time.get_ticks_msec()) if not OS.is_debug_build() else 1 + int(campaign.data["party"]["xp"]))
	paused = false
	_refresh_controls()
	_show("run")
	_refresh_run()

func advance(seconds: float) -> void:
	if mode != "run" or run == null or run.state == "choice" or paused:
		return
	_consume(campaign.step(run, seconds))

func choose(index: int) -> void:
	if mode != "run" or run == null or run.state != "choice":
		return
	_consume(campaign.choose(run, index))

func _consume(events: Array) -> void:
	for ev in events:
		var line := SliceLogText.line(ev, _ctx)
		if line != "":
			_log.append(line)
		var k: String = String(ev.get("kind", ""))
		if k == "attack" or k == "cast":
			if ev.get("source", "") == "hero" and _hero_actor and _hero_actor.has_method("play_attack"):
				_hero_actor.play_attack()
				if _enemy_actor and _enemy_actor.has_method("play_hit"):
					_enemy_actor.play_hit()
			elif ev.get("source", "") == "enemy" and _enemy_actor and _enemy_actor.has_method("play_attack"):
				_enemy_actor.play_attack()
				if _hero_actor and _hero_actor.has_method("play_hit"):
					_hero_actor.play_hit()
		elif k == "defeat" or k == "kill":
			if _enemy_actor and _enemy_actor.has_method("play_death"):
				_enemy_actor.play_death()
	while _log.size() > LOG_LIMIT:
		_log.pop_front()
	if run.state == "won" or run.state == "lost":
		_finish()
	else:
		_refresh_run()

func pending_labels() -> Array:
	if run == null or run.state != "choice":
		return []
	var out: Array = []
	if String(run.pending["kind"]) == "reward":
		for inst in run.pending["options"]:
			out.append(SliceLogText.item_label(inst, _ctx["item_rows"]))
	else:
		for option in run.pending["options"]:
			out.append(String(option["label"]))
	return out

func log_lines() -> Array:
	return _log

func result_text() -> String:
	return _result

func _finish() -> void:
	var summary := campaign.finish_expedition(run)
	var won: bool = bool(summary.get("won", false))
	_result = "%s\nNíveis ganhos: %d · Itens: %d · Resíduo: %d · Fragmentos: %d\n%s" % [
		"Vitória! O Guardião-Cervo foi vencido." if won else "Derrota. A party volta ao Refúgio para tentar de novo.",
		int(summary["levels_gained"]), int(summary["items"]), int(summary["residue"]), int(summary["fragments"]), summary_line()]
	if _result_title:
		if won:
			_result_title.text = "VITÓRIA NA EXPEDIÇÃO"
			_result_title.add_theme_color_override("font_color", Color(0.96, 0.82, 0.38))
			_result_subtitle.text = "O Guardião-Cervo foi libertado da corrupção e a luz retornou ao Bosque."
		else:
			_result_title.text = "EXPEDIÇÃO INTERROMPIDA"
			_result_title.add_theme_color_override("font_color", Color(0.92, 0.42, 0.42))
			_result_subtitle.text = "A party recuou com segurança para descansar e forjar novos equipamentos."
	if _result_xp_val:
		_result_xp_val.text = "+%d Nível" % int(summary["levels_gained"]) if int(summary["levels_gained"]) > 0 else "XP Salvo"
	if _result_res_val:
		_result_res_val.text = "+%d Resíduo" % int(summary["residue"])
	if _result_frag_val:
		_result_frag_val.text = "+%d Frag." % int(summary["fragments"])
	if _result_items_box:
		for child in _result_items_box.get_children():
			child.queue_free()
		var all_items: Array = campaign.inventory.items
		var count: int = int(summary["items"])
		if count > 0 and all_items.size() >= count:
			var recent := all_items.slice(all_items.size() - count)
			for it in recent:
				var ico := ItemIconResolver.create_icon_rect(String(it.get("id", "")), Vector2(44, 44))
				_result_items_box.add_child(ico)
	_show("result")

func _refresh_run() -> void:
	if run == null:
		return
	var snap := run.snapshot()
	_status.text = "Encontro: %s" % _ctx["node_names"].get(snap["node_id"], snap["node_id"])
	var parts: Array = []
	for p in snap["party"]:
		parts.append("%s %.0f/%.0f" % [HERO_NAMES.get(p["id"], p["id"]), float(p["hp"]), float(p["max_hp"])])
	_hp.text = "  ·  ".join(parts)
	_log_label.text = "\n".join(_log.slice(maxi(0, _log.size() - 8)))
	for child in _choice_box.get_children():
		child.queue_free()
	var labels := pending_labels()
	for i in labels.size():
		var index := i
		var btn: Button
		if run != null and run.pending.get("kind", "") == "reward" and i < run.pending.get("options", []).size():
			var inst: Dictionary = run.pending["options"][i]
			btn = _button(String(labels[i]), func(): choose(index))
			var tex: Texture2D = ItemIconResolver.get_texture(String(inst.get("id", "")))
			if tex:
				btn.icon = tex
				btn.expand_icon = true
			var rarity: String = String(inst.get("rarity", "Comum"))
			btn.add_theme_color_override("font_color", ItemIconResolver.rarity_color(rarity))
		else:
			btn = _button(String(labels[i]), func(): choose(index))
		_choice_box.add_child(btn)

func _process(delta: float) -> void:
	if mode == "run" and run != null and run.state != "choice":
		advance(minf(delta * speed, 0.5))
