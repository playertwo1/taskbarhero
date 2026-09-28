extends Control
class_name HubScreen

signal village_upgraded(new_level: int)
signal blacksmith_opened
signal alchemist_opened
signal jeweler_opened
signal campfire_opened
signal resonance_tree_opened
signal navigate_requested(screen_name: String)

const HUB_BACKGROUNDS: Dictionary = {
	1: "res://assets/sprites/ui/hub/hub_option1_bastion_432x960.png",
	2: "res://assets/sprites/ui/hub/hub_option2_tree_432x960.png",
	3: "res://assets/sprites/ui/hub/hub_option3_street_432x960.png"
}

const VILLAGE_STAGE_NAMES: Dictionary = {
	1: "Acampamento Frágil",
	2: "Povoado de Cinzas",
	3: "Refúgio de Lúmen",
	4: "Santuário Fortificado",
	5: "Bastião Próspero"
}

@export var active_hub_option: int = 2:
	set(val):
		active_hub_option = val
		_update_hub_background()

@export var village_level: int = 1:
	set(val):
		village_level = clamp(val, 1, 5)
		_update_village_status()

var gold_amount: int = 1450
var souls_amount: int = 320

@onready var background_rect: TextureRect = $Background
@onready var village_level_label: Label = $TopBar/Margin/HBox/VillageInfo/LevelLabel
@onready var gold_label: Label = $TopBar/Margin/HBox/Resources/GoldLabel
@onready var souls_label: Label = $TopBar/Margin/HBox/Resources/SoulsLabel
@onready var upgrade_btn: Button = $TopBar/Margin/HBox/UpgradeBtn

# Hotspots
@onready var blacksmith_btn: Button = $Hotspots/BlacksmithBtn
@onready var alchemist_btn: Button = $Hotspots/AlchemistBtn
@onready var jeweler_btn: Button = $Hotspots/JewelerBtn
@onready var campfire_btn: Button = $Hotspots/CampfireBtn
@onready var tree_btn: Button = $Hotspots/TreeBtn

# Bottom Navigation
@onready var nav_village_btn: Button = $BottomNav/HBox/BtnVillage
@onready var nav_heroes_btn: Button = $BottomNav/HBox/BtnHeroes
@onready var nav_explore_btn: Button = $BottomNav/HBox/BtnExplore
@onready var nav_inventory_btn: Button = $BottomNav/HBox/BtnInventory
@onready var nav_menu_btn: Button = $BottomNav/HBox/BtnMenu

func _ready() -> void:
	_update_hub_background()
	_update_village_status()
	_connect_signals()

func _connect_signals() -> void:
	if upgrade_btn:
		upgrade_btn.pressed.connect(_on_upgrade_pressed)
	
	if blacksmith_btn:
		blacksmith_btn.pressed.connect(func(): blacksmith_opened.emit())
	if alchemist_btn:
		alchemist_btn.pressed.connect(func(): alchemist_opened.emit())
	if jeweler_btn:
		jeweler_btn.pressed.connect(func(): jeweler_opened.emit())
	if campfire_btn:
		campfire_btn.pressed.connect(func(): campfire_opened.emit())
	if tree_btn:
		tree_btn.pressed.connect(func(): resonance_tree_opened.emit())
		
	if nav_village_btn:
		nav_village_btn.pressed.connect(func(): navigate_requested.emit("hub"))
	if nav_heroes_btn:
		nav_heroes_btn.pressed.connect(func(): navigate_requested.emit("party"))
	if nav_explore_btn:
		nav_explore_btn.pressed.connect(func(): navigate_requested.emit("stages"))
	if nav_inventory_btn:
		nav_inventory_btn.pressed.connect(func(): navigate_requested.emit("inventory"))
	if nav_menu_btn:
		nav_menu_btn.pressed.connect(func(): navigate_requested.emit("menu"))

func set_hub_option(option_id: int) -> void:
	active_hub_option = option_id

func upgrade_village() -> bool:
	if village_level >= 5:
		return false
	village_level += 1
	village_upgraded.emit(village_level)
	return true

func _on_upgrade_pressed() -> void:
	upgrade_village()

func _update_hub_background() -> void:
	if not background_rect:
		return
	var bg_path = HUB_BACKGROUNDS.get(active_hub_option, HUB_BACKGROUNDS[2])
	if ResourceLoader.exists(bg_path):
		background_rect.texture = load(bg_path)

func _update_village_status() -> void:
	if village_level_label:
		var stage_name = VILLAGE_STAGE_NAMES.get(village_level, "Desconhecido")
		village_level_label.text = "Vila Nv. %d: %s" % [village_level, stage_name]
	if gold_label:
		gold_label.text = "Ouro: %d" % gold_amount
	if souls_label:
		souls_label.text = "Lúmen: %d" % souls_amount
	if upgrade_btn:
		if village_level >= 5:
			upgrade_btn.text = "NÍVEL MÁXIMO"
			upgrade_btn.disabled = true
		else:
			upgrade_btn.text = "MELHORAR [NV. %d]" % (village_level + 1)
			upgrade_btn.disabled = false
