extends Control

@onready var battle_strip: Control = $Root/Content/BattleStrip
@onready var level_label: Label = $Root/Header/Level
@onready var stats_label: Label = $Root/Header/Stats
@onready var gold_label: Label = $Root/Header/Gold
@onready var enemy_label: Label = $Root/Content/EnemyCard/VBox/Enemy
@onready var detail_label: Label = $Root/Content/EnemyCard/VBox/Details
@onready var subtitle_label: Label = $Root/Content/Subtitle
@onready var progress_label: Label = $Root/Content/Progress
@onready var loot_label: Label = $Root/Content/Loot
@onready var inventory_label: Label = $Root/Content/Inventory
@onready var status_label: Label = $Root/Content/Status
@onready var equip_button: Button = $Root/Content/ActionRow/EquipButton
@onready var party_button: Button = $Root/Content/ActionRow/PartyButton
@onready var inventory_button: Button = $Root/Content/ActionRow/InventoryButton
@onready var tracker_button: Button = $Root/Content/ActionRow/TrackerButton
@onready var inventory_screen: Control = $InventoryScreen
@onready var party_screen: Control = $PartyScreen
@onready var offline_modal: Control = $OfflineModal
@onready var offline_time_label: Label = $OfflineModal/Center/Card/VBox/Time
@onready var offline_rewards_label: Label = $OfflineModal/Center/Card/VBox/Rewards
@onready var offline_button: Button = $OfflineModal/Center/Card/VBox/CollectButton

@onready var tracker_modal: Control = $TrackerModal
@onready var tracker_view_header: Label = $TrackerModal/Center/Card/VBox/ViewHeader
@onready var tracker_metrics_label: Label = $TrackerModal/Center/Card/VBox/MetricsContainer/MetricsLabel
@onready var tracker_close_button: Button = $TrackerModal/Center/Card/VBox/CloseButton
@onready var btn_session: Button = $TrackerModal/Center/Card/VBox/Tabs/BtnSession
@onready var btn_2hours: Button = $TrackerModal/Center/Card/VBox/Tabs/Btn2Hours
@onready var btn_best_xp: Button = $TrackerModal/Center/Card/VBox/Tabs/BtnBestXp
@onready var btn_best_gold: Button = $TrackerModal/Center/Card/VBox/Tabs/BtnBestGold

var current_tracker_view: String = "session"

func _ready() -> void:
	_adjust_safe_area()
	get_tree().root.size_changed.connect(_adjust_safe_area)
	
	var offline_data := GameManager.load_full_state()
	
	offline_button.pressed.connect(_on_offline_collect_pressed)
	ProgressionManager.offline_progress_calculated.connect(_on_offline_progress_calculated)
	if not offline_data.is_empty():
		_show_offline_modal(offline_data)
	
	party_button.pressed.connect(_on_party_button_pressed)
	party_screen.party_updated.connect(_on_party_updated)
	tracker_button.pressed.connect(_on_tracker_button_pressed)
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	inventory_screen.connect("item_equipped", _on_inventory_item_equipped)
	tracker_close_button.pressed.connect(_on_tracker_close_pressed)
	btn_session.pressed.connect(func(): _switch_tracker_view("session"))
	btn_2hours.pressed.connect(func(): _switch_tracker_view("last_2_hours"))
	btn_best_xp.pressed.connect(func(): _switch_tracker_view("best_stage_xp"))
	btn_best_gold.pressed.connect(func(): _switch_tracker_view("best_stage_gold"))
	
	GameManager.battle_started.connect(_on_battle_started)
	GameManager.battle_ended.connect(_on_battle_ended)
	GameManager.hero_damaged.connect(_on_hero_damaged)
	GameManager.enemy_damaged.connect(_on_enemy_damaged)
	GameManager.battle_log.connect(_on_battle_log)
	
	GameManager.party_hero_attacked.connect(_on_party_hero_attacked)
	GameManager.party_hero_damaged.connect(_on_party_hero_damaged)
	GameManager.party_hero_died.connect(_on_party_hero_died)
	GameManager.party_hero_revived.connect(_on_party_hero_revived)
	
	ProgressionManager.level_up.connect(_on_level_up)
	ProgressionManager.gold_changed.connect(_on_gold_changed)
	ProgressionManager.stage_changed.connect(_on_stage_changed)
	ProgressionManager.stage_progress_updated.connect(_on_stage_progress_updated)
	
	LootManager.item_dropped.connect(_on_item_dropped)
	LootManager.inventory_updated.connect(_on_inventory_updated)
	
	equip_button.pressed.connect(_on_equip_pressed)
	
	GameManager.start_combat()
	_update_ui()

func _process(_delta: float) -> void:
	_update_battle_strip_ratios()

func _update_battle_strip_ratios() -> void:
	var hero_max := GameManager.get_total_hero_max_hp()
	battle_strip.hero_hp_ratio = GameManager.hero_current_hp / hero_max if hero_max > 0 else 0.0
	
	if not GameManager.active_enemy.is_empty():
		var enemy_max := float(GameManager.active_enemy.get("max_hp", 30))
		battle_strip.enemy_hp_ratio = GameManager.active_enemy_hp / enemy_max if enemy_max > 0 else 0.0
		battle_strip.enemy_is_boss = GameManager.active_enemy.get("boss", false)
	else:
		battle_strip.enemy_hp_ratio = 0.0

func _update_ui() -> void:
	level_label.text = "LV %d" % ProgressionManager.level
	
	var hero_hps: Array[String] = []
	for hid in GameManager.party.keys():
		var h_name: String = str(GameManager.party[hid].get("name", hid))
		var prefix: String = h_name.substr(0, 2) if (hid in ["brasa", "forja"]) else h_name.substr(0, 1)
		var h_hp: float = float(GameManager.party[hid].get("current_hp", 0.0))
		hero_hps.append("%s:%.0f" % [prefix, h_hp])
	var party_hp_str: String = " ".join(hero_hps)
	
	stats_label.text = "⚔ %.0f  🛡 %.1f  ❤ %.0f/%.0f" % [
		GameManager.get_total_hero_attack(),
		GameManager.get_total_hero_defense(),
		GameManager.hero_current_hp,
		GameManager.get_total_hero_max_hp()
	]
	subtitle_label.text = "Bosque de Lúmen • %s" % party_hp_str
	gold_label.text = "Ouro: %d" % ProgressionManager.gold
	
	var st := ProgressionManager.get_current_stage_data()
	var stage_name: String = st.get("name", "Bosque de Lúmen")
	var target_k: int = int(st.get("kills_to_advance", 5))
	progress_label.text = "XP: %d/%d • Fase %d: %s [%d/%d]" % [
		ProgressionManager.xp,
		ProgressionManager.xp_next,
		ProgressionManager.current_stage,
		stage_name,
		ProgressionManager.stage_kills,
		target_k
	]
	
	var eq := LootManager.equipment
	var w_name: String = eq["weapon"].get("name", "Nenhuma") if eq["weapon"] else "Nenhuma"
	var a_name: String = eq["armor"].get("name", "Nenhuma") if eq["armor"] else "Nenhuma"
	var am_name: String = eq["amulet"].get("name", "Nenhum") if eq["amulet"] else "Nenhum"
	loot_label.text = "Equip: %s | %s | %s" % [w_name, a_name, am_name]
	
	inventory_label.text = "Mochila: %d item(s)" % LootManager.inventory.size()
	if tracker_modal != null and tracker_modal.visible:
		_update_tracker_display()

func _on_battle_started(enemy: Dictionary) -> void:
	enemy_label.text = enemy.get("name", "Inimigo") + (" [CHEFE]" if enemy.get("boss", false) else "")
	detail_label.text = "HP: %d  ⚔ %d  🛡 %d" % [
		int(enemy.get("max_hp", 30)),
		int(enemy.get("attack", 4)),
		int(enemy.get("defense", 0))
	]
	battle_strip.reset_hero()
	battle_strip.set_enemy(enemy)
	_update_ui()

func _on_battle_ended(victory: bool, _enemy: Dictionary) -> void:
	if victory:
		battle_strip.play_enemy_death()
	else:
		battle_strip.play_hero_death()
	_update_ui()

func _on_hero_damaged(_dmg: float, _curr: float, _max: float) -> void:
	battle_strip.flash_enemy_attack()
	_update_ui()

func _on_enemy_damaged(_dmg: float, _curr: float, _max: float, _is_crit: bool) -> void:
	_update_ui()

func _on_party_hero_attacked(hero_id: String) -> void:
	battle_strip.play_hero_attack(hero_id)
	_update_ui()

func _on_party_hero_damaged(hero_id: String, _amount: float, _curr: float, _max: float) -> void:
	battle_strip.play_hero_hit(hero_id)
	_update_ui()

func _on_party_hero_died(hero_id: String) -> void:
	battle_strip.play_hero_death_single(hero_id)
	_update_ui()

func _on_party_hero_revived(hero_id: String) -> void:
	battle_strip.reset_hero_single(hero_id)
	_update_ui()

func _on_battle_log(msg: String) -> void:
	status_label.text = msg

func _on_level_up(_new_lvl: int) -> void:
	_update_ui()

func _on_gold_changed(_new_gold: int, _delta: int) -> void:
	_update_ui()

func _on_item_dropped(_item: Dictionary) -> void:
	battle_strip.flash_loot()
	_update_ui()

func _on_inventory_updated() -> void:
	_update_ui()

func _on_equip_pressed() -> void:
	var count := LootManager.equip_best_items()
	if count > 0:
		status_label.text = "Equipados %d item(s) de maior poder!" % count
	else:
		status_label.text = "Nenhum equipamento melhor disponível."
	_update_ui()

func _on_inventory_button_pressed() -> void:
	inventory_screen.call("show_screen")

func _on_inventory_item_equipped(item_name: String) -> void:
	status_label.text = "%s equipado." % item_name
	_update_ui()

func _on_party_button_pressed() -> void:
	party_screen.open()

func _on_party_updated(_party: Array) -> void:
	status_label.text = "Composição da equipe atualizada!"
	_update_ui()

func _on_stage_changed(stage_index: int, stage_name: String) -> void:
	status_label.text = "Avançou para Fase %d: %s!" % [stage_index, stage_name]
	_update_ui()

func _on_stage_progress_updated(_kills: int, _target: int) -> void:
	_update_ui()

func _on_offline_progress_calculated(data: Dictionary) -> void:
	_show_offline_modal(data)

func _show_offline_modal(data: Dictionary) -> void:
	offline_time_label.text = "Você ficou fora %s" % data.get("time_formatted", "0m")
	var items_count: int = data.get("items", []).size()
	offline_rewards_label.text = "+ %d XP\n+ %d Ouro\n+ %d Itens\n+ %d Inimigos derrotados" % [
		int(data.get("xp", 0)),
		int(data.get("gold", 0)),
		items_count,
		int(data.get("kills", 0))
	]
	offline_modal.visible = true

func _on_offline_collect_pressed() -> void:
	offline_modal.visible = false
	_update_ui()

func _on_tracker_button_pressed() -> void:
	_switch_tracker_view("session")
	tracker_modal.visible = true

func _on_tracker_close_pressed() -> void:
	tracker_modal.visible = false

func _switch_tracker_view(view_name: String) -> void:
	current_tracker_view = view_name
	_update_tracker_display()

func _update_tracker_display() -> void:
	if not tracker_modal.visible:
		return
	var data := Telemetry.get_tracker_view(current_tracker_view)
	tracker_view_header.text = data.get("view_label", "Visualização")
	
	var xp_h: float = data.get("xp_per_hour", 0.0)
	var gold_h: float = data.get("gold_per_hour", 0.0)
	var kills_h: float = data.get("kills_per_hour", 0.0)
	var avg_ttk: float = data.get("avg_ttk", 0.0)
	var deaths: int = data.get("deaths", 0)
	var drops_h: float = data.get("drops_per_hour", 0.0)
	var pct_rare: float = data.get("pct_rare_plus", 0.0)
	
	tracker_metrics_label.text = "• XP/h: %.1f (+%d XP)\n• Ouro/h: %.1f (+%d Ouro)\n• Kills/h: %.1f (%d kills)\n• TTK Médio: %.2fs\n• Mortes: %d\n• Drops/h: %.1f (%d drops)\n• %% Raro+: %.1f%% (%d raros+)" % [
		xp_h, int(data.get("total_xp", 0)),
		gold_h, int(data.get("total_gold", 0)),
		kills_h, int(data.get("kills", 0)),
		avg_ttk,
		deaths,
		drops_h, int(data.get("drops", 0)),
		pct_rare, int(data.get("rare_plus_drops", 0))
	]

func _adjust_safe_area() -> void:
	if OS.has_feature("mobile") or OS.has_feature("android"):
		var safe_rect := DisplayServer.get_display_safe_area()
		var screen_size := DisplayServer.screen_get_size()
		var vp_size := get_viewport_rect().size
		if screen_size.y > 0 and safe_rect.size.y > 0 and vp_size.y > 0:
			var scale_y := vp_size.y / float(screen_size.y)
			var scale_x := vp_size.x / float(screen_size.x)
			var top_margin := maxi(18, int(safe_rect.position.y * scale_y) + 4)
			var bottom_margin := maxi(16, int((screen_size.y - (safe_rect.position.y + safe_rect.size.y)) * scale_y) + 4)
			var left_margin := maxi(16, int(safe_rect.position.x * scale_x) + 4)
			var right_margin := maxi(16, int((screen_size.x - (safe_rect.position.x + safe_rect.size.x)) * scale_x) + 4)
			var root_box: VBoxContainer = $Root
			root_box.offset_top = top_margin
			root_box.offset_bottom = -bottom_margin
			root_box.offset_left = left_margin
			root_box.offset_right = -right_margin
