extends RefCounted
class_name PassiveTree

## Árvore de passivas do slice (decisão de Rafael, 2026-09-30): as passivas não abrem todas de uma vez. Cada branch
## (a chave de build do herói) é uma cadeia de tiers em que uma passiva menor libera a maior; o jogador recebe
## pontos por nível e escolhe onde gastar (builds específicas e híbridas). Escala do slice do padrão canônico
## (HERO_STANDARD seção 7/8): 1 ponto por nível a partir do 2; 1 ponto por passiva (só o rank 1 existe no slice);
## 1 Trait por vez. Números HIPÓTESE.
##
## Cada linha de passiva da árvore tem "tree": {"branch", "tier", "requires", "min_level", "trait"}. Um nó entra quando
## há pontos, o nível alcança min_level e já existem `requires` nós de tier menor na mesma branch.

const MAX_TRAITS := 1

static func budget(level: int) -> int:
	return maxi(0, level - 1)

## Linhas da árvore do herói, ordenadas por tier (o Trait depois da passiva do mesmo tier).
static func nodes(passive_rows: Array, hero_id: String) -> Array:
	var out: Array = passive_rows.filter(func(r): return r.get("hero", "") == hero_id and r.has("tree"))
	out.sort_custom(func(a, b): return _order(a) < _order(b))
	return out

static func _order(row: Dictionary) -> int:
	return int(row["tree"]["tier"]) * 10 + (1 if bool(row["tree"].get("trait", false)) else 0)

static func branches(hero_row: Dictionary) -> Array:
	return hero_row.get("builds", {}).keys()

static func can_add(row: Dictionary, chosen: Array, level: int) -> bool:
	var tree: Dictionary = row["tree"]
	if chosen.any(func(c): return c["id"] == row["id"]):
		return false
	if level < int(tree.get("min_level", 1)):
		return false
	var lower := 0
	var traits := 0
	for c in chosen:
		if c["tree"]["branch"] == tree["branch"] and int(c["tree"]["tier"]) < int(tree["tier"]):
			lower += 1
		if bool(c["tree"].get("trait", false)):
			traits += 1
	if lower < int(tree.get("requires", 0)):
		return false
	return not (bool(tree.get("trait", false)) and traits >= MAX_TRAITS)

## Valida uma alocação explícita (lista de ids de passivas). Devolve {ok, errors, spent, budget}.
static func validate(hero_id: String, chosen_ids: Array, level: int, passive_rows: Array) -> Dictionary:
	var errors: Array = []
	var by_id := {}
	for r in nodes(passive_rows, hero_id):
		by_id[r["id"]] = r
	var rows: Array = []
	for pid in chosen_ids:
		if not by_id.has(pid):
			errors.append("%s não é um nó da árvore de %s" % [pid, hero_id])
		else:
			rows.append(by_id[pid])
	if chosen_ids.size() > budget(level):
		errors.append("%d pontos gastos; orçamento do nível %d é %d" % [chosen_ids.size(), level, budget(level)])
	rows.sort_custom(func(a, b): return _order(a) < _order(b))
	var accepted: Array = []
	for r in rows:
		if can_add(r, accepted, level):
			accepted.append(r)
		else:
			errors.append("%s não pode ser escolhido (pré-requisito, nível, repetição ou 2º Trait)" % r["id"])
	return {"ok": errors.is_empty(), "errors": errors, "spent": chosen_ids.size(), "budget": budget(level)}

## Alocação automática (Argos/Hub sem escolha): "deep" aprofunda a branch da build e sobra para as outras em ordem;
## "spread" toma o próximo nó de cada branch em rodízio (começando pela da build).
static func auto_allocate(hero_row: Dictionary, build_key: String, level: int, passive_rows: Array, policy: String = "deep") -> Array:
	var all_nodes := nodes(passive_rows, String(hero_row["id"]))
	var order: Array = [build_key.trim_suffix("_tele")]
	for b in branches(hero_row):
		if not order.has(b):
			order.append(b)
	var per_branch := {}
	for b in order:
		per_branch[b] = all_nodes.filter(func(r): return r["tree"]["branch"] == b)
	var chosen: Array = []
	var points := budget(level)
	if policy == "spread":
		var progress := true
		while progress and chosen.size() < points:
			progress = false
			for b in order:
				if chosen.size() >= points:
					break
				for r in per_branch[b]:
					if can_add(r, chosen, level):
						chosen.append(r)
						progress = true
						break
	else:
		for b in order:
			for r in per_branch[b]:
				if chosen.size() < points and can_add(r, chosen, level):
					chosen.append(r)
	return chosen.map(func(r): return r["id"])

## Ids de passivas que o herói usa na run: alocação explícita (options.passive_points[hero]) se válida; senão automática.
static func resolve(hero_row: Dictionary, build_key: String, level: int, passive_rows: Array, options: Dictionary) -> Array:
	var hero_id := String(hero_row["id"])
	var explicit: Dictionary = options.get("passive_points", {})
	if explicit.has(hero_id):
		var check := validate(hero_id, explicit[hero_id], level, passive_rows)
		if bool(check["ok"]):
			return explicit[hero_id]
		push_warning("alocação de passivas inválida para %s: %s" % [hero_id, str(check["errors"])])
	return auto_allocate(hero_row, build_key, level, passive_rows, String(options.get("passive_policy", "deep")))
