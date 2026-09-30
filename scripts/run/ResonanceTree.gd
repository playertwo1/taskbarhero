extends RefCounted
class_name ResonanceTree

## Árvore dos Ecos do slice (SLICE-1D): 6 nós da Oficina. Puro: opera sobre o dicionário do save
## (`fragments`, `tree_nodes`, `milestones`). Custos por faixa vêm do JSON; números são HIPÓTESE.

const PATH := "res://data/progression/resonance_tree_slice.json"
const ROOT_ID := "TREE_VIG_001"

var _costs: Dictionary = {}
var _nodes: Dictionary = {}
var _order: Array = []

static func load_default() -> ResonanceTree:
	var t := ResonanceTree.new()
	var file := FileAccess.open(PATH, FileAccess.READ)
	if file == null:
		return t
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return t
	t._costs = parsed.get("costs", {})
	for n in parsed.get("nodes", []):
		t._nodes[n["id"]] = n
		t._order.append(n["id"])
	return t

func node_ids() -> Array:
	return _order.duplicate()

func node(id: String) -> Dictionary:
	return _nodes.get(id, {})

func cost(id: String) -> int:
	return int(_costs.get(String(_nodes[id]["tier"]), 0)) if _nodes.has(id) else -1

func is_unlocked(data: Dictionary, id: String) -> bool:
	return id == ROOT_ID or data["tree_nodes"].has(id)

## "" quando dá para comprar; senão o motivo: unknown, owned, prereq, fragments.
func can_buy(data: Dictionary, id: String) -> String:
	if not _nodes.has(id):
		return "unknown"
	if is_unlocked(data, id):
		return "owned"
	for req in _nodes[id]["requires"]:
		if not is_unlocked(data, String(req)):
			return "prereq"
	if int(data["fragments"]) < cost(id):
		return "fragments"
	return ""

## Compra o nó. Devolve o motivo da recusa ou "" em sucesso.
func buy(data: Dictionary, id: String) -> String:
	var err := can_buy(data, id)
	if err != "":
		return err
	data["fragments"] = int(data["fragments"]) - cost(id)
	data["tree_nodes"].append(id)
	return ""

## Efeito de serviço aberto por algum nó comprado (ex.: "blacksmith").
func has_effect(data: Dictionary, effect: String) -> bool:
	for id in _order:
		if String(_nodes[id]["effect"]) == effect and is_unlocked(data, id):
			return true
	return false

## Concede o prêmio único de um marco; devolve os Fragmentos concedidos (0 se já pago).
static func award_milestone(data: Dictionary, node_id: String, amount: int) -> int:
	if amount <= 0 or data["milestones"].has(node_id):
		return 0
	data["milestones"].append(node_id)
	data["fragments"] = int(data["fragments"]) + amount
	return amount
