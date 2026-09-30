extends Control
class_name SliceCampaignScreen

## Fluxo jogável do slice (SLICE-1B Plano B): Preparação → Expedição → Resultado, com inventário.
## Montada em código (como o SliceProbe). Toda regra vem do núcleo; aqui só há apresentação.
## 1D: a preparação é o Refúgio provisório, com Árvore dos Ecos e Ferreiro (sem arte própria ainda).

const HERO_NAMES := {"hero_001": "Bastião", "hero_002": "Flecha", "hero_003": "Íris"}
const SAVE_PATH := "user://slice_save.json"
const LOG_LIMIT := 40

var save_path: String = SAVE_PATH
var campaign: SliceCampaign
var run: ExpeditionRun
var mode: String = "prep"
var speed: float = 4.0

var _ctx: Dictionary = {}
var _log: Array = []
var _result: String = ""
var _preset: int = 0
var _prep_box: VBoxContainer
var _run_box: VBoxContainer
var _result_box: VBoxContainer
var _status: Label
var _hp: Label
var _log_label: Label
var _choice_box: VBoxContainer
var _prep_info: Label
var _result_label: Label
var _speed_button: Button
var _panel: Control
var _blacksmith_button: Button

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
	var title := Label.new()
	title.text = "Bosque de Lúmen"
	title.add_theme_font_size_override("font_size", 23)
	_prep_box.add_child(title)
	_prep_info = _label()
	_prep_box.add_child(_prep_info)
	var picker := OptionButton.new()
	for preset in SliceSession.BUILD_PRESETS:
		picker.add_item(String(preset["name"]))
	picker.custom_minimum_size.y = 50
	picker.item_selected.connect(func(index: int): _preset = index)
	_prep_box.add_child(picker)
	_prep_box.add_child(_button("Iniciar expedição", func(): start_expedition(_preset)))
	_prep_box.add_child(_button("Inventário", _open_inventory))
	_prep_box.add_child(_button("Árvore dos Ecos", _open_tree))
	_blacksmith_button = _button("Ferreiro", _open_blacksmith)
	_prep_box.add_child(_blacksmith_button)
	if OS.is_debug_build():
		_prep_box.add_child(_button("Sondagem (dev)", func(): get_tree().change_scene_to_file("res://scenes/slice/SliceProbe.tscn")))
		_prep_box.add_child(_button("Voltar ao título", func(): get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")))

func _build_run() -> void:
	_status = _label()
	_status.add_theme_font_size_override("font_size", 18)
	_run_box.add_child(_status)
	_hp = _label()
	_run_box.add_child(_hp)
	_speed_button = _button("Vel. ×4", _cycle_speed)
	_run_box.add_child(_speed_button)
	_choice_box = VBoxContainer.new()
	_choice_box.add_theme_constant_override("separation", 8)
	_run_box.add_child(_choice_box)
	_log_label = _label()
	_run_box.add_child(_log_label)

func _build_result() -> void:
	_result_label = _label()
	_result_box.add_child(_result_label)
	_result_box.add_child(_button("Inventário", _open_inventory))
	_result_box.add_child(_button("Voltar", func(): _show("prep")))

func _show(new_mode: String) -> void:
	mode = new_mode
	_prep_box.visible = mode == "prep"
	_run_box.visible = mode == "run"
	_result_box.visible = mode == "result"
	if mode == "prep":
		var party: Dictionary = campaign.data["party"]
		_prep_info.text = "Nível do trio: %d · XP: %d\n%s" % [int(party["level"]), int(party["xp"]), summary_line()]
		_blacksmith_button.visible = campaign.blacksmith_open()
	if mode == "result":
		_result_label.text = _result

func summary_line() -> String:
	return "Itens: %d · Resíduo de Lúmen: %d · Fragmentos: %d%s" % [campaign.inventory.items.size(), int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0)), int(campaign.data["fragments"]),
		"\nAviso: o save não pôde ser lido (%s); nada será gravado." % campaign.save_error if campaign.save_blocked else ""]

func _cycle_speed() -> void:
	speed = 1.0 if speed >= 20.0 else (20.0 if speed >= 4.0 else 4.0)
	_speed_button.text = "Vel. ×%d" % int(speed)

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

func start_expedition(preset_index: int) -> void:
	var build: Dictionary = SliceSession.BUILD_PRESETS[preset_index]["heroes"]
	_log = []
	_result = ""
	run = campaign.start_expedition(build, int(Time.get_ticks_msec()) if not OS.is_debug_build() else 1 + int(campaign.data["party"]["xp"]))
	_show("run")
	_refresh_run()

func advance(seconds: float) -> void:
	if mode != "run" or run == null or run.state == "choice":
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
	_result = "%s\nNíveis ganhos: %d · Itens: %d · Resíduo: %d · Fragmentos: %d\n%s" % [
		"Vitória! O Guardião-Cervo foi vencido." if summary["won"] else "Derrota. A party volta ao Refúgio para tentar de novo.",
		int(summary["levels_gained"]), int(summary["items"]), int(summary["residue"]), int(summary["fragments"]), summary_line()]
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
		_choice_box.add_child(_button(String(labels[i]), func(): choose(index)))

func _process(delta: float) -> void:
	if mode == "run" and run != null and run.state != "choice":
		advance(minf(delta * speed, 0.5))
