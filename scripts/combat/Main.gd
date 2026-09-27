extends Control

@onready var battle_strip: Control = $Root/Content/BattleStrip
@onready var level_label: Label = $Root/Header/Level
@onready var stats_label: Label = $Root/Header/Stats
@onready var gold_label: Label = $Root/Header/Gold
@onready var enemy_label: Label = $Root/Content/EnemyCard/VBox/Enemy
@onready var detail_label: Label = $Root/Content/EnemyCard/VBox/Details
@onready var progress_label: Label = $Root/Content/Progress
@onready var loot_label: Label = $Root/Content/Loot
@onready var inventory_label: Label = $Root/Content/Inventory
@onready var status_label: Label = $Root/Content/Status
@onready var equip_button: Button = $Root/Content/EquipButton

func _ready() -> void:
	GameManager.load_full_state()
	
	GameManager.battle_started.connect(_on_battle_started)
	GameManager.battle_ended.connect(_on_battle_ended)
	GameManager.hero_damaged.connect(_on_hero_damaged)
	GameManager.enemy_damaged.connect(_on_enemy_damaged)
	GameManager.battle_log.connect(_on_battle_log)
	
	ProgressionManager.level_up.connect(_on_level_up)
	ProgressionManager.gold_changed.connect(_on_gold_changed)
	
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
	stats_label.text = "⚔ %.0f  🛡 %.1f  ❤ %.0f/%.0f" % [
		GameManager.get_total_hero_attack(),
		GameManager.get_total_hero_defense(),
		GameManager.hero_current_hp,
		GameManager.get_total_hero_max_hp()
	]
	gold_label.text = "Ouro: %d" % ProgressionManager.gold
	progress_label.text = "XP: %d/%d  •  Fase %d (Bosque de Lúmen)" % [
		ProgressionManager.xp,
		ProgressionManager.xp_next,
		ProgressionManager.current_stage
	]
	
	var eq := LootManager.equipment
	var w_name: String = eq["weapon"].get("name", "Nenhuma") if eq["weapon"] else "Nenhuma"
	var a_name: String = eq["armor"].get("name", "Nenhuma") if eq["armor"] else "Nenhuma"
	var am_name: String = eq["amulet"].get("name", "Nenhum") if eq["amulet"] else "Nenhum"
	loot_label.text = "Equip: [Arma: %s] [Armadura: %s] [Amuleto: %s]" % [w_name, a_name, am_name]
	
	inventory_label.text = "Mochila: %d item(s)" % LootManager.inventory.size()

func _on_battle_started(enemy: Dictionary) -> void:
	enemy_label.text = enemy.get("name", "Inimigo") + (" [CHEFE]" if enemy.get("boss", false) else "")
	detail_label.text = "HP: %d  ⚔ %d  🛡 %d" % [
		int(enemy.get("max_hp", 30)),
		int(enemy.get("attack", 4)),
		int(enemy.get("defense", 0))
	]
	_update_ui()

func _on_battle_ended(_victory: bool, _enemy: Dictionary) -> void:
	_update_ui()

func _on_hero_damaged(_dmg: float, _curr: float, _max: float) -> void:
	battle_strip.flash_enemy_attack()
	_update_ui()

func _on_enemy_damaged(_dmg: float, _curr: float, _max: float, _is_crit: bool) -> void:
	battle_strip.flash_hero_attack()
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
