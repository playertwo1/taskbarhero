extends RefCounted

## Modelo de jogador do Argos: traduz a `policy` de um perfil (tools/argos/profiles/*.json) em
## decisões sobre a API real do jogo. É ferramenta de teste, não comportamento de produção:
## nenhuma regra do jogo vive aqui, só a escolha de qual botão um jogador artificial aperta.
##
## Políticas (todas opcionais; o padrão reproduz o Argos anterior aos perfis):
##   reward   best | first | lowest | random | by_ip     escolha entre os itens oferecidos
##   events   first | random   (ou o mapa id-do-evento → id-da-opção, como antes)
##   equip    best | none | by_ip | focus_attack | focus_defense | random
##   equip_from_attempt  N     só começa a equipar na tentativa N (novato que ainda não descobriu)
##   spend    none | full | random     gasto na Árvore e no Ferreiro entre as tentativas
##   build    fixed | random_per_attempt
##   quit_after_losses N       abandona depois de N derrotas seguidas (0 = nunca)
##   continue_after_win N      tentativas extras depois da primeira vitória (farm)
##   max_attempts N

var policy: Dictionary = {}
var rng := RandomNumberGenerator.new()

static func create(p: Dictionary, seed_value: int) -> RefCounted:
	var player = load("res://tools/argos/simulator/combat/argos_player.gd").new()
	player.policy = p
	player.rng.seed = seed_value
	return player

func _score(item: Dictionary) -> int:
	return LootRoller.rarity_rank(String(item["rarity"])) * 1000 + int(item["item_power"])

func reward_index(options: Array) -> int:
	if options.is_empty():
		return 0
	match String(policy.get("reward", "best")):
		"first":
			return 0
		"random":
			return rng.randi_range(0, options.size() - 1)
		"lowest":
			var low := 0
			for i in options.size():
				if _score(options[i]) < _score(options[low]):
					low = i
			return low
		"by_ip":
			var top := 0
			for i in options.size():
				if int(options[i]["item_power"]) > int(options[top]["item_power"]):
					top = i
			return top
		_:
			var best := 0
			for i in options.size():
				if _score(options[i]) > _score(options[best]):
					best = i
			return best

func event_index(pending: Dictionary) -> int:
	var options: Array = pending["options"]
	if String(policy.get("events", "first")) == "random" and not options.is_empty():
		return rng.randi_range(0, options.size() - 1)
	var want := String(policy.get(String(pending["id"]), ""))
	for i in options.size():
		if String(options[i]["id"]) == want:
			return i
	return 0

func pick(pending: Dictionary) -> int:
	return reward_index(pending["options"]) if String(pending["kind"]) == "reward" else event_index(pending)

func should_spend() -> bool:
	match String(policy.get("spend", "none")):
		"full":
			return true
		"random":
			return rng.randf() < 0.5
		_:
			return false

func builds_for_attempt(base_build: Dictionary, options: Dictionary) -> Dictionary:
	if String(policy.get("build", "fixed")) != "random_per_attempt":
		return base_build
	var out := {}
	for hid in base_build:
		var choices: Array = options.get(hid, [base_build[hid]])
		out[hid] = choices[rng.randi_range(0, choices.size() - 1)]
	return out

## Pontuação de item para o equipar do perfil; maior é melhor.
func _equip_score(row: Dictionary, item: Dictionary) -> float:
	var weights: Dictionary = row.get("stat_weights", {})
	match String(policy.get("equip", "best")):
		"by_ip":
			return float(item["item_power"])
		"focus_attack":
			var off := float(weights.get("attack", 0.0)) + float(weights.get("crit_chance", 0.0)) + float(weights.get("attack_speed", 0.0))
			return off * 100000.0 + _score(item)
		"focus_defense":
			var def := float(weights.get("max_hp", 0.0)) + float(weights.get("defense", 0.0)) + float(weights.get("tenacity", 0.0))
			return def * 100000.0 + _score(item)
		"random":
			return rng.randf()
		_:
			return float(_score(item))

## Equipa conforme a política, sempre pela API do inventário (as regras de compatibilidade e de
## capacidade continuam as do jogo). `best` usa o auto_equip real do Hub.
func apply_equip(campaign: SliceCampaign, party_ids: Array, attempt: int) -> void:
	var mode := String(policy.get("equip", "best"))
	if mode == "none" or attempt < int(policy.get("equip_from_attempt", 1)):
		return
	if mode == "best":
		campaign.auto_equip(party_ids)
		return
	var rows := {}
	for row in campaign._rows:
		rows[row["id"]] = row
	campaign.inventory.equipped = {}
	var used := {}
	for hero_id in party_ids:
		var by_slot := {}
		for item in campaign.inventory.items:
			var row: Dictionary = rows.get(item["id"], {})
			if used.has(int(item["uid"])) or row.is_empty() or not row.get("compatible_heroes", []).has(hero_id):
				continue
			var slot := String(row["slot"])
			if not by_slot.has(slot):
				by_slot[slot] = []
			by_slot[slot].append([_equip_score(row, item), int(item["uid"])])
		for slot in by_slot:
			var list: Array = by_slot[slot]
			list.sort_custom(func(a, b): return a[0] > b[0])
			for i in mini(2 if slot == "accessory" else 1, list.size()):
				if campaign.inventory.equip(hero_id, int(list[i][1])) == "":
					used[int(list[i][1])] = true
