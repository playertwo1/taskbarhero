extends RefCounted

## Modo fuzz do Argos (perfis Exploit Hunter e Chaos): sequências de ações aleatórias, inclusive as
## ilegais, sobre a API real do inventário/campanha (SliceCampaign em memória), com oráculos.
## Determinístico por seed. Não altera dados nem código de produção.
##
## Oráculos (nomes dos `violations`):
##   uid_duplicated            dois itens com o mesmo uid
##   equipped_unknown_uid      equipado que não existe no inventário
##   equipped_twice            o mesmo item equipado duas vezes
##   slot_overflow             mais itens no slot do que a capacidade
##   incompatible_equipped     item equipado em herói incompatível
##   negative_material         Resíduo ou Fragmentos negativos
##   echo_not_owned            Echo equipado que o jogador não tem
##   refused_changed_state     ação recusada alterou o estado
##   locked_mutation           mudança de equipamento aceita com o inventário travado
##   equipped_recycled         item equipado foi desmontado
##   favorite_recycled         item favorito foi desmontado
##   recycle_credit_mismatch   Resíduo creditado diferente do devolvido, ou item não removido
##   reinforce_overflow        Reforço acima do máximo
##   reinforce_cost_mismatch   custo do Reforço diferente da regra
##   equip_not_applied         equip aceito mas o item não ficou equipado no herói
##   tree_cost_mismatch        nó da Árvore comprado com custo diferente
##   save_roundtrip_mismatch   inventário muda ao gravar e ler (JSON)

const HEROES := ["hero_001", "hero_002", "hero_003"]
const TREE_OPEN := ["TREE_VIG_002", "TREE_VIG_005", "TREE_OFI_001", "TREE_OFI_002", "TREE_OFI_003"]
const MUTATING := ["equip", "equip_dup", "unequip", "recycle", "recycle_equipped", "recycle_favorite", "reinforce", "reinforce_spam", "equip_echo", "auto_equip"]

var campaign: SliceCampaign
var rng := RandomNumberGenerator.new()
var cfg: Dictionary = {}
var accepted := 0
var refused := 0
var by_action := {}
var detail := {}
var trace: Array = []
var step := 0

static func run(seed_value: int, config: Dictionary) -> Dictionary:
	var fuzz = load("res://tools/argos/simulator/combat/argos_fuzz.gd").new()
	return fuzz._run(seed_value, config)

func _run(seed_value: int, config: Dictionary) -> Dictionary:
	cfg = config
	rng.seed = seed_value
	campaign = SliceCampaign.in_memory()
	_setup()
	var names: Array = []
	var weights: Dictionary = cfg.get("weights", {})
	for name in _all_actions():
		for _i in int(weights.get(name, 1)):
			names.append(name)
	var steps := int(cfg.get("steps", 400))
	for i in steps:
		step = i
		_do(String(names[rng.randi_range(0, names.size() - 1)]))
		_invariants()
		if i % 25 == 24:
			_roundtrip()
	_roundtrip()
	var out := {"seed": seed_value, "steps": steps, "accepted": accepted, "refused": refused, "by_action": by_action,
		"violations": detail.keys(), "violation_detail": detail}
	if not detail.is_empty():
		out["trace_tail"] = trace.slice(maxi(0, trace.size() - 12))
	return out

func _all_actions() -> Array:
	return ["equip", "equip_dup", "unequip", "recycle", "recycle_equipped", "recycle_favorite", "reinforce", "reinforce_spam",
		"favorite", "buy_tree", "equip_echo", "auto_equip", "add_item", "add_materials", "add_fragments", "lock", "unlock"]

# --- Preparação e utilidades ---------------------------------------------------------------

func _setup() -> void:
	for _i in rng.randi_range(int(cfg.get("items_min", 4)), int(cfg.get("items_max", 14))):
		_add_random_item()
	campaign.inventory.add_materials({SliceInventory.RESIDUE: rng.randi_range(0, int(cfg.get("residue_max", 20)))})
	campaign.data["fragments"] = rng.randi_range(0, int(cfg.get("fragments_max", 15)))
	if rng.randf() < float(cfg.get("open_tree_chance", 0.5)):
		campaign.data["tree_nodes"] = TREE_OPEN.duplicate()
	if rng.randf() < 0.3:
		campaign.inventory.grant_echo(SliceInventory.ECHO_SENTINEL)

func _add_random_item() -> void:
	var row: Dictionary = campaign._rows[rng.randi_range(0, campaign._rows.size() - 1)]
	var rarities: Array = row["allowed_rarities"]
	var rarity := String(rarities[rng.randi_range(0, rarities.size() - 1)])
	campaign.inventory.add_item(LootRoller.make_instance(String(row["id"]), rarity, rng.randi_range(1, 100), rng.randi_range(1, 100)))

func _state() -> String:
	var inv := campaign.inventory
	return JSON.stringify([inv.to_dict(), campaign.data.get("fragments", 0), campaign.data.get("tree_nodes", []), inv.locked])

func _uid(prefer: String = "any") -> int:
	var inv := campaign.inventory
	if prefer == "equipped":
		var all: Array = []
		for hid in inv.equipped:
			all.append_array(inv.equipped[hid])
		if not all.is_empty():
			return int(all[rng.randi_range(0, all.size() - 1)])
	if prefer == "eligible":
		var rows := {}
		for row in campaign._rows:
			rows[row["id"]] = row
		var ok: Array = inv.items.filter(func(i): return campaign.blacksmith_rule["slots"].has(String(rows.get(i["id"], {}).get("slot", ""))) and int(i.get("reinforce", 0)) < int(campaign.blacksmith_rule["max_level"]))
		if not ok.is_empty() and rng.randf() < 0.75:
			return int(ok[rng.randi_range(0, ok.size() - 1)]["uid"])
	if prefer == "favorite":
		var fav: Array = inv.items.filter(func(i): return bool(i.get("favorite", false)))
		if not fav.is_empty():
			return int(fav[rng.randi_range(0, fav.size() - 1)]["uid"])
	if inv.items.is_empty() or rng.randf() < 0.1:
		return rng.randi_range(1, 200)  # uid que pode não existir
	return int(inv.items[rng.randi_range(0, inv.items.size() - 1)]["uid"])

func _owner(uid: int) -> String:
	for hid in campaign.inventory.equipped:
		if campaign.inventory.equipped[hid].has(uid):
			return String(hid)
	return ""

func _material() -> int:
	return int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0))

func _violate(name: String, action: String) -> void:
	if not detail.has(name):
		detail[name] = {"count": 0, "first_step": step, "first_action": action}
	detail[name]["count"] = int(detail[name]["count"]) + 1

func _note(action: String, args: String, was_refused: bool) -> void:
	if was_refused:
		refused += 1
	else:
		accepted += 1
	var stats: Dictionary = by_action.get(action, {"accepted": 0, "refused": 0})
	stats["refused" if was_refused else "accepted"] = int(stats["refused" if was_refused else "accepted"]) + 1
	by_action[action] = stats
	trace.append("%d %s %s -> %s" % [step, action, args, "recusado" if was_refused else "aceito"])

# --- Ações ---------------------------------------------------------------------------------

func _do(action: String) -> void:
	var inv := campaign.inventory
	var before := _state()
	var was_locked := inv.locked
	var was_refused := false
	var args := ""
	match action:
		"equip", "equip_dup":
			var hero: String = HEROES[rng.randi_range(0, HEROES.size() - 1)]
			var uid := _uid("equipped" if action == "equip_dup" else "any")
			var err := campaign.equip(hero, uid)
			was_refused = err != ""
			args = "%s #%d (%s)" % [hero, uid, err]
			if not was_refused and not inv.equipped.get(hero, []).has(uid):
				_violate("equip_not_applied", action)
		"unequip":
			var uid := _uid("equipped")
			var err := campaign.unequip(uid)
			was_refused = err != ""
			args = "#%d (%s)" % [uid, err]
		"recycle", "recycle_equipped", "recycle_favorite":
			var uid := _uid("equipped" if action == "recycle_equipped" else ("favorite" if action == "recycle_favorite" else "any"))
			var inst := inv.find(uid)
			var was_equipped := _owner(uid) != ""
			var was_favorite := bool(inst.get("favorite", false))
			var material_before := _material()
			var res := campaign.recycle(uid)
			was_refused = not bool(res["ok"])
			args = "#%d (%s)" % [uid, String(res["error"])]
			if not was_refused:
				if was_equipped:
					_violate("equipped_recycled", action)
				if was_favorite:
					_violate("favorite_recycled", action)
				if _material() - material_before != int(res["residue"]) or not inv.find(uid).is_empty():
					_violate("recycle_credit_mismatch", action)
		"reinforce", "reinforce_spam":
			var uid := _uid("eligible")
			var repeats := 3 if action == "reinforce_spam" else 1
			for _r in repeats:
				var inst := inv.find(uid)
				var level_before := int(inst.get("reinforce", 0))
				var material_before := _material()
				var state_before := _state()
				var err := campaign.reinforce(uid)
				args = "#%d x%d (%s)" % [uid, repeats, err]
				if err == "":
					if int(inv.find(uid).get("reinforce", 0)) != level_before + 1 or int(inv.find(uid).get("reinforce", 0)) > int(campaign.blacksmith_rule["max_level"]):
						_violate("reinforce_overflow", action)
					if material_before - _material() != int(campaign.blacksmith_rule["material_quantity"]):
						_violate("reinforce_cost_mismatch", action)
					if was_locked:
						_violate("locked_mutation", action)
				elif _state() != state_before:
					_violate("refused_changed_state", action)
				was_refused = err != ""
		"favorite":
			var uid := _uid("any")
			var err := campaign.set_favorite(uid, rng.randf() < 0.5)
			was_refused = err != ""
			args = "#%d (%s)" % [uid, err]
		"buy_tree":
			var ids: Array = campaign.tree.node_ids()
			var buyable: Array = ids.filter(func(i): return campaign.tree.can_buy(campaign.data, i) == "")
			var node_id: String = buyable[rng.randi_range(0, buyable.size() - 1)] if (not buyable.is_empty() and rng.randf() < 0.6) else ids[rng.randi_range(0, ids.size() - 1)]
			var fragments_before := int(campaign.data["fragments"])
			var cost := campaign.tree.cost(node_id)
			var err := campaign.buy_tree_node(node_id)
			was_refused = err != ""
			args = "%s (%s)" % [node_id, err]
			if not was_refused and fragments_before - int(campaign.data["fragments"]) != cost:
				_violate("tree_cost_mismatch", action)
		"equip_echo":
			var echo_id: String = [SliceInventory.ECHO_SENTINEL, "", "echo_inexistente"][rng.randi_range(0, 2)]
			var err := campaign.equip_echo(echo_id)
			was_refused = err != ""
			args = "'%s' (%s)" % [echo_id, err]
		"auto_equip":
			campaign.auto_equip(HEROES)
			args = "(locked=%s)" % was_locked
			was_refused = was_locked
		"add_item":
			_add_random_item()
			args = "(loot entra mesmo travado)"
		"add_materials":
			campaign.inventory.add_materials({SliceInventory.RESIDUE: rng.randi_range(0, 30)})
		"add_fragments":
			campaign.data["fragments"] = int(campaign.data["fragments"]) + rng.randi_range(0, 12)
		"lock":
			inv.locked = true
		"unlock":
			inv.locked = false
	if action in ["add_item", "add_materials", "add_fragments", "lock", "unlock", "favorite"]:
		_note(action, args, was_refused)
		return
	_note(action, args, was_refused)
	var after := _state()
	if was_refused and after != before and action not in ["reinforce_spam"]:
		_violate("refused_changed_state", action)
	if was_locked and MUTATING.has(action) and after != before and action != "auto_equip":
		_violate("locked_mutation", action)
	if was_locked and action == "auto_equip" and after != before:
		_violate("locked_mutation", action)

# --- Invariantes ---------------------------------------------------------------------------

func _invariants() -> void:
	var inv := campaign.inventory
	var seen := {}
	for inst in inv.items:
		var uid := int(inst["uid"])
		if seen.has(uid):
			_violate("uid_duplicated", "invariante")
		seen[uid] = true
	var equipped_count := {}
	var rows := {}
	for row in campaign._rows:
		rows[row["id"]] = row
	for hid in inv.equipped:
		var by_slot := {}
		for uid in inv.equipped[hid]:
			var inst := inv.find(int(uid))
			if inst.is_empty():
				_violate("equipped_unknown_uid", "invariante")
				continue
			equipped_count[int(uid)] = int(equipped_count.get(int(uid), 0)) + 1
			var row: Dictionary = rows.get(inst["id"], {})
			if not row.get("compatible_heroes", []).has(hid):
				_violate("incompatible_equipped", "invariante")
			var slot := String(row.get("slot", ""))
			by_slot[slot] = int(by_slot.get(slot, 0)) + 1
		for slot in by_slot:
			if int(by_slot[slot]) > (2 if slot == "accessory" else 1):
				_violate("slot_overflow", "invariante")
	for uid in equipped_count:
		if int(equipped_count[uid]) > 1:
			_violate("equipped_twice", "invariante")
	for id in inv.materials:
		if int(inv.materials[id]) < 0:
			_violate("negative_material", "invariante")
	if int(campaign.data["fragments"]) < 0:
		_violate("negative_material", "invariante")
	if inv.equipped_echo != "" and not inv.echoes.has(inv.equipped_echo):
		_violate("echo_not_owned", "invariante")

## Gravar e ler (JSON, como o save faz) não pode mudar o inventário.
func _roundtrip() -> void:
	var inv := campaign.inventory
	var parsed = JSON.parse_string(JSON.stringify(inv.to_dict()))
	var again := SliceInventory.from_dict(parsed, campaign._rows, campaign._tables["recycle"])
	if JSON.stringify(again.to_dict()) != JSON.stringify(inv.to_dict()):
		_violate("save_roundtrip_mismatch", "roundtrip")
