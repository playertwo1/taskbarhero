extends Node

signal item_dropped(item: Dictionary)
signal item_equipped(slot: String, item: Dictionary)
signal inventory_updated()

const ITEMS_DATA_PATH := "res://data/items/items.json"

var items_database: Array = []
var equipment: Dictionary = {
	"weapon": null,
	"armor": null,
	"amulet": null
}
var inventory: Array = []
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	load_database()

func load_database() -> void:
	if not FileAccess.file_exists(ITEMS_DATA_PATH):
		push_warning("LootManager: Arquivo de itens não encontrado em %s" % ITEMS_DATA_PATH)
		return
	var file := FileAccess.open(ITEMS_DATA_PATH, FileAccess.READ)
	if file != null:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			items_database = parsed

func roll_drop(boss: bool = false) -> Variant:
	if items_database.is_empty():
		return null
	var drop_chance := 0.60 if boss else 0.25
	if rng.randf() > drop_chance:
		return null
	
	var total_weight := 0
	for item in items_database:
		total_weight += int(item.get("weight", 10))
	
	var roll := rng.randi_range(1, total_weight)
	var current := 0
	for item in items_database:
		current += int(item.get("weight", 10))
		if roll <= current:
			var dropped = item.duplicate(true)
			inventory.append(dropped)
			item_dropped.emit(dropped)
			inventory_updated.emit()
			return dropped
	return null

func equip_item(item: Dictionary) -> bool:
	var slot: String = item.get("slot", "")
	if not equipment.has(slot):
		return false
	equipment[slot] = item
	item_equipped.emit(slot, item)
	return true

func equip_best_items() -> int:
	var equipped_count := 0
	for slot in ["weapon", "armor", "amulet"]:
		var best_item = equipment[slot]
		var best_val := _get_item_score(best_item)
		for item in inventory:
			if item.get("slot", "") == slot:
				var score := _get_item_score(item)
				if score > best_val:
					best_val = score
					best_item = item
		if best_item != null and best_item != equipment[slot]:
			equipment[slot] = best_item
			equipped_count += 1
			item_equipped.emit(slot, best_item)
	return equipped_count

func _get_item_score(item: Variant) -> float:
	if item == null or not (item is Dictionary):
		return -1.0
	var score := 0.0
	score += float(item.get("attack", 0)) * 3.0
	score += float(item.get("defense", 0)) * 2.5
	score += float(item.get("max_hp", 0)) * 0.5
	score += float(item.get("crit", 0.0)) * 40.0
	score += float(item.get("lifesteal", 0.0)) * 50.0
	return score

func get_state() -> Dictionary:
	return {
		"equipment": equipment,
		"inventory": inventory
	}

func load_state(data: Dictionary) -> void:
	equipment = data.get("equipment", {"weapon": null, "armor": null, "amulet": null})
	inventory = data.get("inventory", [])
	inventory_updated.emit()
