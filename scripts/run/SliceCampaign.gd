extends RefCounted
class_name SliceCampaign

## Orquestra save, inventário e expedição do slice (SLICE-1B). Aplica cada recompensa na hora
## (RUN_META_PROGRESSION: salvar ao receber) e grava. Com save_blocked, joga só em memória.

var save_path: String = ""
var data: Dictionary = {}
var inventory: SliceInventory
var save_blocked: bool = false
var save_error: String = ""
var telemetry: SliceTelemetry = null

var _tables: Dictionary = {}
var _rows: Array = []
var _profiles: Dictionary = {}
var _levels_gained: int = 0
var _items_gained: int = 0
var _residue_gained: int = 0

static func _base(path: String) -> SliceCampaign:
	var c := SliceCampaign.new()
	c.save_path = path
	c._tables = LootRoller.load_tables()
	c._rows = SliceStats.load_rows("res://data/items/items.json", "slice")
	c._profiles = SliceStats.load_profiles()
	return c

static func open(path: String) -> SliceCampaign:
	var c := _base(path)
	var res := SliceSave.read(path)
	if res["ok"]:
		c.data = res["data"]
	else:
		c.data = SliceSave.default_data()
		c.save_blocked = true
		c.save_error = String(res["error"])
	c.inventory = SliceInventory.from_dict(c.data.get("inventory", {}), c._rows, c._tables["recycle"])
	return c

## Campanha sem arquivo (Argos e testes): nunca lê nem grava o disco.
static func in_memory() -> SliceCampaign:
	var c := _base("")
	c.data = SliceSave.default_data()
	c.save_blocked = true
	c.save_error = "memory"
	c.inventory = SliceInventory.create(c._rows, c._tables["recycle"])
	return c

func _save() -> void:
	if save_blocked:
		return
	data["inventory"] = inventory.to_dict()
	SliceSave.write(save_path, data)

func auto_equip(hero_ids: Array) -> void:
	inventory.auto_equip(hero_ids)
	_save()

## Cria a expedição com nível, equipamento e flags do save. A expedição sempre começa com HP cheio
## (o run é recriado do zero) e trava o inventário até finish_expedition.
func start_expedition(build: Dictionary, seed_value: int, extra_options: Dictionary = {}) -> ExpeditionRun:
	inventory.locked = true
	_levels_gained = 0
	_items_gained = 0
	_residue_gained = 0
	var extra := {
		"loot": LootRoller.create(_tables, _rows, seed_value),
		"events": EventDirector.create(EventDirector.load_catalog(), seed_value),
		"flags": data["flags"],
		"first_clear": not bool(data["boss_cleared"]),
		"equipment": inventory.equipment_for_run(),
		"equipped_echo": inventory.equipped_echo,
	}
	extra.merge(extra_options, true)
	var run := SliceSession.create_run(build, int(data["party"]["level"]), seed_value, extra)
	if telemetry != null:
		run.telemetry = telemetry
	return run

func step(run: ExpeditionRun, dt: float) -> Array:
	var events := run.step(dt)
	_apply(events)
	return events

func choose(run: ExpeditionRun, index: int) -> Array:
	var events := run.choose(index)
	_apply(events)
	return events

func _apply(events: Array) -> void:
	var changed := false
	var generated_events: Array = []
	for ev in events:
		match String(ev["type"]):
			"encounter_cleared":
				var echo_id := String(ev.get("first_clear_echo", ""))
				if inventory.grant_echo(echo_id):
					changed = true
					generated_events.append({"type": "echo_obtained", "time": float(ev.get("time", 0.0)), "id": echo_id})
			"loot_dropped":
				inventory.add_item(ev["item"])
				_items_gained += 1
				changed = true
			"material_dropped":
				inventory.add_materials({ev["id"]: ev["quantity"]})
				if ev["id"] == SliceInventory.RESIDUE:
					_residue_gained += int(ev["quantity"])
				changed = true
			"flag_set":
				data["flags"][ev["flag"]] = true
				changed = true
			"event_resolved":
				data["flags"]["seen_%s" % ev["id"]] = true
				changed = true
			"lore_revealed":
				if not data["lore"].has(ev["text_id"]):
					data["lore"].append(ev["text_id"])
				changed = true
			"enemy_defeated":
				_levels_gained += SliceSave.add_xp(data, int(ev.get("xp", 0)), _profiles)
				changed = true
	if changed:
		_save()
	events.append_array(generated_events)

func finish_expedition(run: ExpeditionRun) -> Dictionary:
	inventory.locked = false
	var won := run.state == "won"
	if won:
		data["boss_cleared"] = true
	_save()
	return {"won": won, "levels_gained": _levels_gained, "items": _items_gained, "residue": _residue_gained}

func equip(hero_id: String, uid: int) -> String:
	var err := inventory.equip(hero_id, uid)
	if err == "":
		_save()
	return err

func unequip(uid: int) -> String:
	var err := inventory.unequip(uid)
	if err == "":
		_save()
	return err

func equip_echo(echo_id: String) -> String:
	var err := inventory.equip_echo(echo_id)
	if err == "":
		_save()
	return err

func recycle(uid: int) -> Dictionary:
	var inst := inventory.find(uid)
	var res := inventory.recycle(uid)
	if res["ok"]:
		_save()
		if telemetry != null:
			telemetry.record_recycle(String(inst["rarity"]), int(res["residue"]))
	return res
