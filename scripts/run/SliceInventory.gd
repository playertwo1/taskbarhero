extends RefCounted
class_name SliceInventory

## Inventário e equipamento do slice (SLICE-1B). Puro: regras sem UI e sem save.
## O loadout trava durante a expedição (locked); loot novo entra mesmo travado (RUN_META_PROGRESSION).

const RESIDUE := "MAT_C1_LUMEN_RESIDUE"

var items: Array = []
var equipped: Dictionary = {}
var materials: Dictionary = {}
var locked: bool = false

var _rows: Dictionary = {}
var _recycle: Dictionary = {}
var _next_uid: int = 1

static func create(item_rows: Array, recycle: Dictionary) -> SliceInventory:
	var inv := SliceInventory.new()
	for row in item_rows:
		inv._rows[row["id"]] = row
	inv._recycle = recycle
	return inv

func add_item(inst: Dictionary) -> int:
	var stored := inst.duplicate(true)
	stored["uid"] = _next_uid
	_next_uid += 1
	items.append(stored)
	return int(stored["uid"])

func add_materials(m: Dictionary) -> void:
	for id in m:
		materials[id] = int(materials.get(id, 0)) + int(m[id])

func find(uid: int) -> Dictionary:
	for inst in items:
		if int(inst["uid"]) == uid:
			return inst
	return {}

func _owner_of(uid: int) -> String:
	for hero_id in equipped:
		if equipped[hero_id].has(uid):
			return String(hero_id)
	return ""

func _slot(inst: Dictionary) -> String:
	return String(_rows[inst["id"]]["slot"])

func equip(hero_id: String, uid: int) -> String:
	if locked:
		return "locked"
	var inst := find(uid)
	if inst.is_empty() or not _rows.has(inst["id"]):
		return "unknown"
	if not _rows[inst["id"]].get("compatible_heroes", []).has(hero_id):
		return "incompatible"
	var previous := _owner_of(uid)
	if previous != "":
		equipped[previous].erase(uid)
	var slot := _slot(inst)
	var capacity := 2 if slot == "accessory" else 1
	var list: Array = equipped.get(hero_id, [])
	var same_slot: Array = list.filter(func(u): return _slot(find(int(u))) == slot)
	while same_slot.size() >= capacity:
		list.erase(same_slot.pop_front())
	list.append(uid)
	equipped[hero_id] = list
	return ""

func unequip(uid: int) -> String:
	if locked:
		return "locked"
	if find(uid).is_empty():
		return "unknown"
	var owner_id := _owner_of(uid)
	if owner_id != "":
		equipped[owner_id].erase(uid)
	return ""

func recycle(uid: int) -> Dictionary:
	if locked:
		return {"ok": false, "error": "locked", "residue": 0}
	var inst := find(uid)
	if inst.is_empty():
		return {"ok": false, "error": "unknown", "residue": 0}
	if _owner_of(uid) != "":
		return {"ok": false, "error": "equipped", "residue": 0}
	if not _recycle.has(inst["rarity"]):
		return {"ok": false, "error": "not_recyclable", "residue": 0}
	var residue := int(_recycle[inst["rarity"]])
	items.erase(inst)
	add_materials({RESIDUE: residue})
	return {"ok": true, "error": "", "residue": residue}

## Instâncias equipadas no formato de SliceItemStats.equip (id, rarity, item_power, item_level).
func equipment_for_run() -> Dictionary:
	var out := {}
	for hero_id in equipped:
		var list: Array = []
		for uid in equipped[hero_id]:
			var inst := find(int(uid))
			if not inst.is_empty():
				list.append({"id": inst["id"], "rarity": inst["rarity"], "item_power": inst["item_power"], "item_level": inst["item_level"]})
		if not list.is_empty():
			out[hero_id] = list
	return out

static func _score(inst: Dictionary) -> int:
	return LootRoller.rarity_rank(String(inst["rarity"])) * 1000 + int(inst["item_power"])

## Equipa o melhor item por herói e vaga (raridade, depois item_power). Um item nunca vai a dois heróis.
func auto_equip(hero_ids: Array) -> void:
	if locked:
		return
	equipped = {}
	var used := {}
	for hero_id in hero_ids:
		var by_slot := {}
		for inst in items:
			if used.has(int(inst["uid"])) or not _rows.has(inst["id"]) or not _rows[inst["id"]].get("compatible_heroes", []).has(hero_id):
				continue
			var slot := _slot(inst)
			if not by_slot.has(slot):
				by_slot[slot] = []
			by_slot[slot].append(inst)
		var chosen: Array = []
		for slot in by_slot:
			var list: Array = by_slot[slot]
			list.sort_custom(func(a, b): return _score(a) > _score(b))
			var capacity := 2 if slot == "accessory" else 1
			for i in mini(capacity, list.size()):
				chosen.append(int(list[i]["uid"]))
				used[int(list[i]["uid"])] = true
		if not chosen.is_empty():
			equipped[hero_id] = chosen

func to_dict() -> Dictionary:
	return {"items": items.duplicate(true), "equipped": equipped.duplicate(true), "materials": materials.duplicate(true), "next_uid": _next_uid}

static func from_dict(d: Dictionary, item_rows: Array, recycle: Dictionary) -> SliceInventory:
	var inv := create(item_rows, recycle)
	for inst in d.get("items", []):
		var stored: Dictionary = inst.duplicate(true)
		for key in ["uid", "item_power", "item_level"]:
			stored[key] = int(stored[key])
		inv.items.append(stored)
	for hero_id in d.get("equipped", {}):
		var list: Array = []
		for uid in d["equipped"][hero_id]:
			list.append(int(uid))
		inv.equipped[hero_id] = list
	for id in d.get("materials", {}):
		inv.materials[id] = int(d["materials"][id])
	inv._next_uid = int(d.get("next_uid", 1))
	return inv
