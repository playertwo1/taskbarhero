# SLICE-1B Núcleo (loot, inventário, eventos, save) — Plano de implementação

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans para executar tarefa por tarefa. Os passos usam checkbox (`- [ ]`).

**Meta:** entregar a lógica pura do `1B` (loot por seed, inventário com reciclagem, catálogo de 10 eventos, pausa de escolha no `ExpeditionRun`, save mínimo e orquestração), toda testada em headless.

**Arquitetura:** unidades puras (`RefCounted`, sem autoload, sem nós) em `scripts/run/`, ligadas ao `ExpeditionRun` existente por opções (`loot`, `events`, `flags`, `first_clear`). O `ExpeditionRun` ganha o estado `choice` e o método `choose(index)`. Loot e eventos usam RNG **derivado da seed e separado do RNG de combate**. Sem as opções novas o run se comporta exatamente como hoje.

**Tecnologias:** Godot 4.7.2 (GDScript), JSON em `/data`, testes em cenas headless (`tests/unit/Test*.tscn`) rodados por `python tools/run_godot_tests.py`.

**Spec:** [`docs/03_systems/SLICE_1B_RUN_SPEC.md`](../../03_systems/SLICE_1B_RUN_SPEC.md). Este plano é o **Plano A (núcleo)**. O **Plano B (tela de inventário/equipar/reciclar, fluxo no `SliceProbe`, cenários do Argos)** é escrito depois que o núcleo passar.

## Restrições globais

- **Sem commit nem push** (AGENTS.md: só sob pedido de Rafael). Cada tarefa termina num checkpoint com testes verdes; relate e pare.
- Preserve alterações e arquivos não rastreados pré-existentes (`git status` antes de começar). Nunca apague nada em `tools/argos/reports/`.
- GDScript com **tabs**; comentários e textos em português; nomes de código como o resto do repositório (`snake_case`, `class_name` PascalCase).
- Um fato, uma fonte: números do slice vivem em `/data`; o código não os copia. Todo número novo é **HIPÓTESE** e leva `"status": "HIPOTESE"` e `"source"` no JSON.
- Ninguém morre por evento: custo de HP nunca deixa um herói abaixo de 1 HP.
- Nenhum evento é necessário para vencer o boss; itens de evento não somam Resíduo além do orçamento do ECON-1.
- Depois de criar um `class_name` novo, rode `python tools/godot_import.py` (Tarefa 1) antes dos testes, senão o Godot headless não conhece a classe.
- Sem as opções novas (`loot`, `events`), a saída do `ExpeditionRun` deve ser idêntica à atual (teste na Tarefa 4).

## Mapa de arquivos

| Arquivo | Ação | Responsabilidade |
| --- | --- | --- |
| `tools/godot_import.py` | criar | Reimporta o projeto para registrar `class_name` novos |
| `data/loot/drops_c1.json` | criar | Tabelas de drop, raridade, Reward Choice, materiais e reciclagem (HIPÓTESE) |
| `scripts/run/LootRoller.gd` | criar | Sorteio puro de drops e ofertas |
| `scripts/run/SliceInventory.gd` | criar | Equipar, trocar, reciclar, travamento |
| `data/expedition/events_c1.json` | criar | Catálogo dos 10 eventos + regras de sorteio |
| `scripts/run/EventDirector.gd` | criar | Validação, elegibilidade, sorteio e resolução de escolhas |
| `scripts/combat/ExpeditionRun.gd` | modificar | Estado `choice`, `choose`, drops, efeitos de evento |
| `scripts/run/SliceSave.gd` | criar | JSON versionado, leitura segura, XP/nível |
| `scripts/run/SliceCampaign.gd` | criar | Orquestra save + inventário + expedição |
| `scripts/combat/SliceTelemetry.gd` | modificar | Contadores de eventos, ofertas, loot, reciclagem |
| `tests/unit/Test*.tscn` + `test_*.gd` | criar | Um teste por unidade |
| docs (spec, roadmap, índices, changelog) | modificar | Sincronizar (Tarefa 8) |

## Modelo de teste (usado em todas as tarefas)

Cada teste é um `test_<nome>.gd` (`extends Node`, imprime `[PASS]`/`FALHA`, sai com `get_tree().quit(0|1)`) mais uma cena `Test<Nome>.tscn` de três linhas. Cena modelo (troque o caminho e o nome):

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/unit/test_NOME.gd" id="1_test"]

[node name="TestNOME" type="Node"]
script = ExtResource("1_test")
```

Esqueleto do `.gd` (as tarefas mostram só os casos):

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _finish(name: String) -> void:
	print("=======================================================")
	print("[%s] %s" % ["PASS" if success else "FAIL", name])
	get_tree().quit(0 if success else 1)
```

Para rodar **uma** cena: `GODOT=$(python -c "import sys;sys.path.insert(0,'tools');import run_godot_tests as r;print(r.DEFAULT_GODOT)"); "$GODOT" --headless --path . res://tests/unit/TestNOME.tscn`. Para a suíte: `python tools/run_godot_tests.py`.

---

## Tarefa 1: Tabelas de drop e `LootRoller`

**Arquivos:**
- Criar: `tools/godot_import.py`, `data/loot/drops_c1.json`, `scripts/run/LootRoller.gd`
- Teste: `tests/unit/test_loot_roller.gd`, `tests/unit/TestLootRoller.tscn`

**Interfaces:**
- Consome: `data/items/items.json` (linhas do slice: `id`, `slot`, `base_rarity`, `allowed_rarities`).
- Produz (usado pelas Tarefas 2, 4, 6):
  - `LootRoller.load_tables() -> Dictionary`
  - `LootRoller.derive_seed(base: int, salt: String) -> int`
  - `LootRoller.create(tables: Dictionary, items: Array, seed_value: int) -> LootRoller`
  - `LootRoller.make_instance(item_id: String, rarity: String, item_power: int, item_level: int) -> Dictionary` (chaves `id`, `rarity`, `item_power`, `item_level`, o mesmo formato de `SliceItemStats.equip`)
  - `roll_enemy_drop(enemy_row: Dictionary, level: int) -> Dictionary` → `{"items": Array, "materials": Dictionary}`
  - `roll_choice(kind: String, level: int) -> Array` (3 instâncias distintas; `kind` ∈ `ELITE`, `MINIBOSS`)
  - `roll_event_choice(level: int, min_rarity: String) -> Array` (3 instâncias, ao menos 1 com raridade ≥ `min_rarity`)
  - `roll_event_item(rarity: String, level: int) -> Dictionary`
  - `roll_boss(first_clear: bool, level: int) -> Dictionary` → `{"items": Array, "choice": Array}`

- [ ] **Passo 1: criar `tools/godot_import.py`**

```python
"""Reimporta o projeto Godot em headless para registrar class_name novos.

Uso: python tools/godot_import.py [--godot CAMINHO]
"""
import argparse
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import run_godot_tests as runner  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default=os.environ.get("GODOT", runner.DEFAULT_GODOT))
    args = parser.parse_args()
    if not os.path.isfile(args.godot):
        sys.exit(f"Godot não encontrado em {args.godot}; use --godot ou a variável GODOT.")
    result = subprocess.run([args.godot, "--headless", "--path", runner.ROOT, "--import", "--quit"], timeout=300)
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
```

- [ ] **Passo 2: criar `data/loot/drops_c1.json`**

Fontes: chances de equipamento e materiais vêm de `CHAPTER_01_ENEMIES_CANONICAL.json`; tabelas de raridade de `loot_system_contract_v0.4.json`, **renormalizadas** para o recorte (sem Épico/Relíquia em drops normais; SLICE_1_SCOPE seção 3). Elite e mini-boss não rolam equipamento comum: entregam Reward Choice (spec seção 4).

```json
{
  "schema_version": "1.0",
  "status": "HIPOTESE",
  "source": "docs/03_systems/SLICE_1B_RUN_SPEC.md seção 4; chances de CHAPTER_01_ENEMIES_CANONICAL.json; raridades de loot_system_contract_v0.4.json renormalizadas para o recorte",
  "item_power": {"NORMAL": [1, 18], "ELITE": [10, 24], "MINIBOSS": [16, 28], "BOSS": [22, 32], "EVENT_REWARD": [10, 24]},
  "equipment_chance": {"NORMAL": 0.10, "ELITE": 0.0, "MINIBOSS": 0.0, "BOSS": 0.0},
  "rarity": {
    "NORMAL": {"Comum": 0.633, "Incomum": 0.276, "Raro": 0.091},
    "ELITE": {"Incomum": 0.4375, "Raro": 0.5625},
    "MINIBOSS": {"Raro": 1.0},
    "BOSS": {"Épico": 0.85, "Relíquia": 0.15},
    "BOSS_FIRST_CLEAR": {"Épico": 1.0},
    "EVENT_REWARD": {"Incomum": 0.5, "Raro": 0.5}
  },
  "reward_choice_options": 3,
  "relic_item_id": "item_a_005",
  "materials": {
    "en_c1_001": [{"id": "MAT_C1_LUMEN_RESIDUE", "chance": 0.65, "min": 1, "max": 1}],
    "el_c1_001": [{"id": "MAT_C1_LUMEN_RESIDUE", "chance": 1.0, "min": 1, "max": 2}],
    "mb_c1_001": [{"id": "MAT_C1_LUMEN_RESIDUE", "chance": 1.0, "min": 2, "max": 4}]
  },
  "recycle": {"Comum": 1, "Incomum": 2, "Raro": 3, "Épico": 5}
}
```

- [ ] **Passo 3: escrever o teste que falha** (`tests/unit/test_loot_roller.gd`)

```gdscript
extends Node

var success := true
var tables: Dictionary
var items: Array

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE LOOT ROLLER (SLICE-1B) ---")
	tables = LootRoller.load_tables()
	items = SliceStats.load_rows("res://data/items/items.json", "slice")
	_test_tables_valid()
	_test_determinism()
	_test_normal_drop_rates()
	_test_elite_and_choices()
	_test_boss()
	_test_event_rewards()
	print("=======================================================")
	print("[%s] TESTE LOOT ROLLER" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _row(id: String) -> Dictionary:
	for r in SliceStats.load_rows("res://data/enemies/enemies.json", "slice"):
		if r["id"] == id:
			return r
	return {}

func _test_tables_valid() -> void:
	print("\n>>> 1. TABELAS")
	_expect("tabelas carregadas", not tables.is_empty())
	for key in tables["rarity"]:
		var total := 0.0
		for r in tables["rarity"][key]:
			total += float(tables["rarity"][key][r])
		_expect("tabela %s soma 1" % key, absf(total - 1.0) < 0.0005)

func _test_determinism() -> void:
	print("\n>>> 2. DETERMINISMO")
	var a := LootRoller.create(tables, items, 42)
	var b := LootRoller.create(tables, items, 42)
	var c := LootRoller.create(tables, items, 43)
	var seq_a := []
	var seq_b := []
	var seq_c := []
	for i in 50:
		seq_a.append(a.roll_enemy_drop(_row("en_c1_001"), 3))
		seq_b.append(b.roll_enemy_drop(_row("en_c1_001"), 3))
		seq_c.append(c.roll_enemy_drop(_row("en_c1_001"), 3))
	_expect("mesma seed, mesma sequência", seq_a == seq_b)
	_expect("seed diferente, sequência diferente", seq_a != seq_c)

func _test_normal_drop_rates() -> void:
	print("\n>>> 3. TAXAS DO INIMIGO COMUM")
	var roller := LootRoller.create(tables, items, 7)
	var geleia := _row("en_c1_001")
	var equip := 0
	var residue := 0
	var rarity := {"Comum": 0, "Incomum": 0, "Raro": 0}
	var n := 20000
	for i in n:
		var drop := roller.roll_enemy_drop(geleia, 3)
		for inst in drop["items"]:
			equip += 1
			rarity[inst["rarity"]] += 1
			_expect_range(inst)
		residue += int(drop["materials"].get("MAT_C1_LUMEN_RESIDUE", 0))
	_expect("equipamento ≈ 10%% (%.3f)" % (float(equip) / n), absf(float(equip) / n - 0.10) < 0.01)
	_expect("Resíduo ≈ 65%% (%.3f)" % (float(residue) / n), absf(float(residue) / n - 0.65) < 0.02)
	_expect("Comum é a raridade mais frequente", rarity["Comum"] > rarity["Incomum"] and rarity["Incomum"] > rarity["Raro"])

func _expect_range(inst: Dictionary) -> void:
	var r: Array = tables["item_power"]["NORMAL"]
	if inst["item_power"] < r[0] or inst["item_power"] > r[1] or inst["item_level"] != 3:
		_expect("item_power/nível dentro da faixa", false)

func _test_elite_and_choices() -> void:
	print("\n>>> 4. ELITE E MINI-BOSS")
	var roller := LootRoller.create(tables, items, 9)
	var drop := roller.roll_enemy_drop(_row("el_c1_001"), 3)
	_expect("elite não rola equipamento comum", drop["items"].is_empty())
	_expect("elite dá 1–2 Resíduos", int(drop["materials"]["MAT_C1_LUMEN_RESIDUE"]) >= 1 and int(drop["materials"]["MAT_C1_LUMEN_RESIDUE"]) <= 2)
	var mb := roller.roll_enemy_drop(_row("mb_c1_001"), 3)
	_expect("mini-boss dá 2–4 Resíduos", int(mb["materials"]["MAT_C1_LUMEN_RESIDUE"]) >= 2 and int(mb["materials"]["MAT_C1_LUMEN_RESIDUE"]) <= 4)
	for kind in ["ELITE", "MINIBOSS"]:
		var options := roller.roll_choice(kind, 3)
		var ids := {}
		for o in options:
			ids[o["id"]] = true
		_expect("%s oferece 3 itens distintos" % kind, options.size() == 3 and ids.size() == 3)
		if kind == "MINIBOSS":
			var all_rare := true
			for o in options:
				all_rare = all_rare and o["rarity"] == "Raro"
			_expect("mini-boss oferece só Raro", all_rare)

func _test_boss() -> void:
	print("\n>>> 5. BOSS")
	var roller := LootRoller.create(tables, items, 11)
	var first := roller.roll_boss(true, 5)
	_expect("primeiro clear: Casca do Guardião", first["items"].size() == 1 and first["items"][0]["id"] == "item_a_005" and first["items"][0]["rarity"] == "Relíquia")
	var epic := true
	for o in first["choice"]:
		epic = epic and o["rarity"] == "Épico"
	_expect("primeiro clear: escolha de 3 Épicos", first["choice"].size() == 3 and epic)
	var repeat := roller.roll_boss(false, 5)
	_expect("repetição: 1 drop e nenhuma escolha", repeat["items"].size() == 1 and repeat["choice"].is_empty())

func _test_event_rewards() -> void:
	print("\n>>> 6. RECOMPENSAS DE EVENTO")
	var roller := LootRoller.create(tables, items, 13)
	for i in 200:
		var options := roller.roll_event_choice(3, "Raro")
		var has_rare := false
		for o in options:
			has_rare = has_rare or o["rarity"] == "Raro" or o["rarity"] == "Épico"
		if options.size() != 3 or not has_rare:
			_expect("escolha de evento com 3 itens e ao menos 1 Raro", false)
			return
	_expect("200 escolhas de evento: sempre 3 itens e ao menos 1 Raro", true)
	var inst := roller.roll_event_item("Incomum", 3)
	_expect("item de evento respeita a raridade pedida", inst["rarity"] == "Incomum")
```

- [ ] **Passo 4: criar `tests/unit/TestLootRoller.tscn`** (modelo acima com `NOME` = `loot_roller` no script e `LootRoller` no nó) e rodar para ver falhar

Run: `python tools/godot_import.py` e depois a cena (comando no modelo de teste).
Esperado: FALHA de compilação ("Could not find type LootRoller").

- [ ] **Passo 5: implementar `scripts/run/LootRoller.gd`**

```gdscript
extends RefCounted
class_name LootRoller

## Sorteio de loot do slice (SLICE-1B). Puro: sem autoload, sem nós.
## Tabelas (HIPÓTESE): data/loot/drops_c1.json. RNG derivado da seed e separado do combate.
## Ordem de consumo do RNG é fixa (equipamento, depois materiais) para manter o determinismo.

const TABLES_PATH := "res://data/loot/drops_c1.json"
const RARITY_ORDER := ["Comum", "Incomum", "Raro", "Épico", "Relíquia"]

var _tables: Dictionary = {}
var _items: Array = []
var _rng := RandomNumberGenerator.new()

static func load_tables() -> Dictionary:
	var file := FileAccess.open(TABLES_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

static func derive_seed(base: int, salt: String) -> int:
	return ("%d:%s" % [base, salt]).hash()

static func create(tables: Dictionary, items: Array, seed_value: int) -> LootRoller:
	var roller := LootRoller.new()
	roller._tables = tables
	roller._items = items
	roller._rng.seed = derive_seed(seed_value, "loot")
	return roller

static func make_instance(item_id: String, rarity: String, item_power: int, item_level: int) -> Dictionary:
	return {"id": item_id, "rarity": rarity, "item_power": item_power, "item_level": item_level}

static func rarity_rank(rarity: String) -> int:
	return RARITY_ORDER.find(rarity)

func _weighted(table: Dictionary) -> String:
	var total := 0.0
	for key in table:
		total += float(table[key])
	var roll := _rng.randf() * total
	var acc := 0.0
	var last := ""
	for key in table:
		acc += float(table[key])
		last = String(key)
		if roll < acc:
			return last
	return last

func _pool(rarity: String) -> Array:
	var out: Array = []
	for row in _items:
		if row["allowed_rarities"].has(rarity) and (rarity == "Relíquia" or String(row["base_rarity"]) != "Relíquia"):
			out.append(row)
	return out

func _power(profile: String) -> int:
	var range_: Array = _tables["item_power"][profile]
	return _rng.randi_range(int(range_[0]), int(range_[1]))

func _roll_item(rarity: String, profile: String, level: int, exclude: Array = []) -> Dictionary:
	var pool: Array = _pool(rarity).filter(func(row): return not exclude.has(row["id"]))
	if pool.is_empty():
		pool = _pool(rarity)
	if pool.is_empty():
		return {}
	var row: Dictionary = pool[_rng.randi_range(0, pool.size() - 1)]
	return make_instance(String(row["id"]), rarity, _power(profile), level)

## Drops de um inimigo derrotado: equipamento (chance por posto) e materiais.
func roll_enemy_drop(enemy_row: Dictionary, level: int) -> Dictionary:
	var rank := String(enemy_row["rank"])
	var out := {"items": [], "materials": {}}
	var chance := float(_tables["equipment_chance"].get(rank, 0.0))
	if chance > 0.0 and _rng.randf() < chance:
		var inst := _roll_item(_weighted(_tables["rarity"][rank]), rank, level)
		if not inst.is_empty():
			out["items"].append(inst)
	for entry in _tables["materials"].get(String(enemy_row["id"]), []):
		if _rng.randf() < float(entry["chance"]):
			var qty := _rng.randi_range(int(entry["min"]), int(entry["max"]))
			out["materials"][entry["id"]] = int(out["materials"].get(entry["id"], 0)) + qty
	return out

func _distinct_options(table_key: String, profile: String, level: int, count: int) -> Array:
	var options: Array = []
	var used: Array = []
	for _i in count:
		var inst := _roll_item(_weighted(_tables["rarity"][table_key]), profile, level, used)
		if inst.is_empty():
			continue
		used.append(inst["id"])
		options.append(inst)
	return options

## Reward Choice de elite/mini-boss (kind = "ELITE" | "MINIBOSS").
func roll_choice(kind: String, level: int) -> Array:
	return _distinct_options(kind, kind, level, int(_tables["reward_choice_options"]))

## Escolha de evento: 3 itens e ao menos 1 com raridade >= min_rarity (o primeiro é forçado se preciso).
func roll_event_choice(level: int, min_rarity: String) -> Array:
	var options := _distinct_options("EVENT_REWARD", "EVENT_REWARD", level, int(_tables["reward_choice_options"]))
	var floor_rank := rarity_rank(min_rarity)
	for inst in options:
		if rarity_rank(String(inst["rarity"])) >= floor_rank:
			return options
	if options.is_empty():
		return options
	var used: Array = []
	for inst in options:
		used.append(inst["id"])
	var forced := _roll_item(min_rarity, "EVENT_REWARD", level, used)
	if not forced.is_empty():
		options[0] = forced
	return options

func roll_event_item(rarity: String, level: int) -> Dictionary:
	return _roll_item(rarity, "EVENT_REWARD", level)

## Boss: no primeiro clear, Casca do Guardião + escolha de 3 Épicos; depois, 1 drop pela tabela BOSS.
func roll_boss(first_clear: bool, level: int) -> Dictionary:
	if first_clear:
		var relic := make_instance(String(_tables["relic_item_id"]), "Relíquia", _power("BOSS"), level)
		return {"items": [relic], "choice": _distinct_options("BOSS_FIRST_CLEAR", "BOSS", level, int(_tables["reward_choice_options"]))}
	var inst := _roll_item(_weighted(_tables["rarity"]["BOSS"]), "BOSS", level)
	return {"items": [inst] if not inst.is_empty() else [], "choice": []}
```

- [ ] **Passo 6: importar e rodar até passar**

Run: `python tools/godot_import.py` e a cena `TestLootRoller`.
Esperado: todas as linhas `[PASS]`, saída `PASS`. Se "Comum é a raridade mais frequente" falhar por amostra, confirme `n = 20000` (a chance de equipamento é 10%, dá ~2000 itens).

- [ ] **Passo 7: suíte completa**

Run: `python tools/run_godot_tests.py`
Esperado: todas as cenas PASS (13/13).

---

## Tarefa 2: `SliceInventory`

**Arquivos:**
- Criar: `scripts/run/SliceInventory.gd`
- Teste: `tests/unit/test_slice_inventory.gd`, `tests/unit/TestSliceInventory.tscn`

**Interfaces:**
- Consome: linhas de `data/items/items.json` (`id`, `slot`, `compatible_heroes`), tabela `recycle` de `drops_c1.json`, instâncias da Tarefa 1.
- Produz (Tarefas 5 e 6):
  - `SliceInventory.create(item_rows: Array, recycle: Dictionary) -> SliceInventory`
  - propriedades: `items: Array` (cada instância ganha `uid: int`), `equipped: Dictionary` (herói → `Array` de `uid`), `materials: Dictionary`, `locked: bool`
  - `add_item(inst: Dictionary) -> int` (devolve `uid`), `add_materials(m: Dictionary) -> void`
  - `equip(hero_id: String, uid: int) -> String` (`""` = ok; erros `locked`, `unknown`, `incompatible`)
  - `unequip(uid: int) -> String` (`""`, `locked`, `unknown`)
  - `recycle(uid: int) -> Dictionary` → `{"ok": bool, "error": String, "residue": int}` (erros `locked`, `unknown`, `equipped`, `not_recyclable`)
  - `equipment_for_run() -> Dictionary` (herói → `Array` de instâncias, formato de `SliceItemStats.equip`)
  - `find(uid: int) -> Dictionary` (`{}` se não existe)
  - `to_dict() -> Dictionary`, `static from_dict(d: Dictionary, item_rows: Array, recycle: Dictionary) -> SliceInventory`

Regras: acessório tem 2 vagas; os demais slots, 1. Equipar num slot cheio **troca** (o item mais antigo do slot volta ao inventário). `locked` (expedição em andamento) bloqueia equipar, desequipar e reciclar. Relíquia e itens sem valor em `recycle` não são recicláveis (`not_recyclable`).

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true
var rows: Array
var recycle := {"Comum": 1, "Incomum": 2, "Raro": 3, "Épico": 5}

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE INVENTORY (SLICE-1B) ---")
	rows = SliceStats.load_rows("res://data/items/items.json", "slice")
	_test_equip_rules()
	_test_slots_and_swap()
	_test_recycle()
	_test_lock_and_roundtrip()
	print("=======================================================")
	print("[%s] TESTE SLICE INVENTORY" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _inst(id: String, rarity: String = "Comum") -> Dictionary:
	return LootRoller.make_instance(id, rarity, 10, 5)

func _test_equip_rules() -> void:
	print("\n>>> 1. EQUIPAR E COMPATIBILIDADE")
	var inv := SliceInventory.create(rows, recycle)
	var bow := inv.add_item(_inst("item_w_002", "Incomum"))
	var sword := inv.add_item(_inst("item_w_001"))
	_expect("uids únicos e crescentes", bow == 1 and sword == 2)
	_expect("arco da Flecha não equipa no Bastião", inv.equip("hero_001", bow) == "incompatible")
	_expect("item desconhecido", inv.equip("hero_001", 99) == "unknown")
	_expect("espada equipa no Bastião", inv.equip("hero_001", sword) == "")
	var run_gear := inv.equipment_for_run()
	_expect("equipment_for_run devolve id/raridade/IP/nível", run_gear["hero_001"][0]["id"] == "item_w_001" and run_gear["hero_001"][0]["item_power"] == 10)
	_expect("unequip devolve ao inventário", inv.unequip(sword) == "" and inv.equipment_for_run().get("hero_001", []).is_empty())

func _test_slots_and_swap() -> void:
	print("\n>>> 2. VAGAS E TROCA")
	var inv := SliceInventory.create(rows, recycle)
	var w1 := inv.add_item(_inst("item_w_001"))
	var w2 := inv.add_item(_inst("item_w_003", "Raro"))
	inv.equip("hero_001", w1)
	inv.equip("hero_001", w2)
	_expect("segunda arma troca a primeira", inv.equipped["hero_001"] == [w2])
	var r1 := inv.add_item(_inst("item_r_001"))
	var r2 := inv.add_item(_inst("item_s_003", "Raro"))
	var r3 := inv.add_item(_inst("item_r_001", "Incomum"))
	inv.equip("hero_001", r1)
	inv.equip("hero_001", r3)
	_expect("acessório tem 2 vagas", inv.equipped["hero_001"].has(r1) and inv.equipped["hero_001"].has(r3))
	var r4 := inv.add_item(_inst("item_r_001", "Raro"))
	inv.equip("hero_001", r4)
	_expect("terceiro acessório troca o mais antigo", not inv.equipped["hero_001"].has(r1) and inv.equipped["hero_001"].has(r4))
	_expect("secundário compartilhado equipa em outro herói", inv.equip("hero_003", r2) == "")

func _test_recycle() -> void:
	print("\n>>> 3. RECICLAGEM")
	var inv := SliceInventory.create(rows, recycle)
	var expected := {"Comum": 1, "Incomum": 2, "Raro": 3, "Épico": 5}
	for rarity in expected:
		var uid := inv.add_item(_inst("item_a_001", rarity))
		var res := inv.recycle(uid)
		_expect("reciclar %s rende %d" % [rarity, expected[rarity]], res["ok"] and res["residue"] == expected[rarity])
	_expect("Resíduo acumulado = 11", int(inv.materials.get("MAT_C1_LUMEN_RESIDUE", 0)) == 11)
	var worn := inv.add_item(_inst("item_a_001"))
	inv.equip("hero_001", worn)
	_expect("equipado não recicla", inv.recycle(worn)["error"] == "equipped")
	var relic := inv.add_item(_inst("item_a_005", "Relíquia"))
	_expect("Relíquia não recicla", inv.recycle(relic)["error"] == "not_recyclable")
	_expect("item reciclado some do inventário", inv.find(1).is_empty())

func _test_lock_and_roundtrip() -> void:
	print("\n>>> 4. TRAVA E PERSISTÊNCIA")
	var inv := SliceInventory.create(rows, recycle)
	var uid := inv.add_item(_inst("item_w_001"))
	inv.equip("hero_001", uid)
	inv.add_materials({"MAT_C1_LUMEN_RESIDUE": 4})
	inv.locked = true
	_expect("travado bloqueia equipar/desequipar/reciclar", inv.equip("hero_001", uid) == "locked" and inv.unequip(uid) == "locked" and inv.recycle(uid)["error"] == "locked")
	_expect("travado ainda aceita loot novo", inv.add_item(_inst("item_a_001")) > uid)
	inv.locked = false
	var copy := SliceInventory.from_dict(JSON.parse_string(JSON.stringify(inv.to_dict())), rows, recycle)
	_expect("ida e volta preserva itens, equipado e materiais", copy.items.size() == inv.items.size() and copy.equipped == inv.equipped and copy.materials == inv.materials)
	_expect("uid continua único depois de carregar", copy.add_item(_inst("item_a_001")) == inv.add_item(_inst("item_a_001")))
```

Nota: o JSON converte inteiros em `float`. `from_dict` deve reconverter `uid`, `item_power`, `item_level` para `int` e os valores de `equipped`/`materials` também.

- [ ] **Passo 2: criar a cena `TestSliceInventory.tscn`, rodar e ver falhar** (compilação: tipo `SliceInventory` desconhecido).

- [ ] **Passo 3: implementar `scripts/run/SliceInventory.gd`**

```gdscript
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
```

- [ ] **Passo 4: importar, rodar a cena e a suíte**

Run: `python tools/godot_import.py`; cena `TestSliceInventory`; `python tools/run_godot_tests.py`
Esperado: todas PASS. Se "terceiro acessório troca o mais antigo" falhar, revise a ordem em `equip` (o `pop_front` remove o mais antigo, e `list` mantém a ordem de inserção).

---

## Tarefa 3: Catálogo de 10 eventos e `EventDirector`

**Arquivos:**
- Criar: `data/expedition/events_c1.json`, `scripts/run/EventDirector.gd`
- Teste: `tests/unit/test_event_director.gd`, `tests/unit/TestEventDirector.tscn`

**Interfaces:**
- Produz (Tarefa 4):
  - `EventDirector.load_catalog() -> Dictionary`
  - `EventDirector.validate(catalog: Dictionary) -> Array` (lista de mensagens de erro; vazia = válido)
  - `EventDirector.create(catalog: Dictionary, seed_value: int) -> EventDirector`
  - `event_by_id(id: String) -> Dictionary` (`{}` se não existe)
  - `roll_transition(ctx: Dictionary) -> Dictionary` (evento sorteado ou `{}`)
  - `choices_for(event: Dictionary, ctx: Dictionary) -> Array` (escolhas concretas; `per_hero` vira uma por herói vivo)
  - `resolve(choice: Dictionary) -> Array` (efeitos concretos; `outcomes` resolvidos por peso)
  - `mark_seen(event_id: String) -> void`
- `ctx` (montado pelo run): `alive_heroes: Array[String]`, `party_level: int`, `equipped: Array` (instâncias), `previous_no_falls: bool`, `flags: Dictionary`.

Vocabulário fechado (validado): condições `party_has{hero}`, `hero_level_at_least{value}`, `item_equipped{item|rarity}`, `previous_encounter_no_falls`, `flag{name}`; efeitos `heal_fraction`, `damage_fraction`, `grant_material`, `grant_reward_choice`, `grant_item`, `set_flag`, `reveal_lore`, `modify_next_encounter`.

- [ ] **Passo 1: criar `data/expedition/events_c1.json`**

Fonte dos valores: spec seção 3 (HIPÓTESE). `weight: 0` = não entra no sorteio de transição. `"auto": true` = sem pausa (resolve a única escolha na hora). `scope`: `"all"`, um ID de herói, ou `"pick"` (substituído pelo herói escolhido em `per_hero`).

```json
{
  "schema_version": "1.0",
  "status": "HIPOTESE",
  "source": "docs/03_systems/SLICE_1B_RUN_SPEC.md seção 3; nomes dos candidatos de docs/04_content/chapters/chapter_01/DESIGN_SEEDS.md",
  "random_rules": {"transition_chance": 0.25, "secret_chance": 0.01, "max_random_per_run": 2},
  "events": [
    {"id": "event_c1_001", "design_id": "EVENT_C1_001", "kind": "fixed", "name": "Poço de Lúmen", "weight": 0, "once_per_save": false, "conditions": [],
     "choices": [
       {"id": "heal", "label": "Curar a party", "effects": [{"type": "heal_fraction", "scope": "all", "value": 0.35}]},
       {"id": "sacrifice", "label": "Sacrificar vida por uma recompensa rara", "effects": [
         {"type": "damage_fraction", "scope": "all", "value": 0.25},
         {"type": "grant_reward_choice", "min_rarity": "Raro"}]}
     ]},
    {"id": "event_c1_reserva_residuo", "design_id": null, "kind": "fixed", "name": "Reserva de Resíduo", "weight": 0, "once_per_save": false, "auto": true, "conditions": [],
     "choices": [{"id": "collect", "label": "Recolher", "effects": [{"type": "grant_material", "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 2}]}]},
    {"id": "event_c1_criatura_ferida", "design_id": null, "kind": "random", "name": "Criatura Ferida", "weight": 60, "once_per_save": false, "conditions": [],
     "choices": [
       {"id": "save", "label": "Salvar", "effects": [
         {"type": "damage_fraction", "scope": "all", "value": 0.10},
         {"type": "grant_item", "rarity": "Comum"},
         {"type": "set_flag", "flag": "criatura_salva"},
         {"type": "reveal_lore", "text_id": "LORE_EVT_CRIATURA_FERIDA"}]},
       {"id": "ignore", "label": "Ignorar", "effects": []}
     ]},
    {"id": "event_c1_raiz_oca", "design_id": null, "kind": "random", "name": "Raiz Oca", "weight": 40, "once_per_save": false, "conditions": [],
     "choices": [
       {"id": "open", "label": "Abrir a raiz", "outcomes": [
         {"weight": 20, "effects": [{"type": "damage_fraction", "scope": "all", "value": 0.10}]},
         {"weight": 15, "effects": [{"type": "grant_item", "rarity": "Incomum"}, {"type": "reveal_lore", "text_id": "LORE_EVT_RAIZ_OCA"}]},
         {"weight": 65, "effects": []}]},
       {"id": "ignore", "label": "Ignorar", "effects": []}
     ]},
    {"id": "event_c1_arvore_cantante", "design_id": null, "kind": "random", "name": "Árvore Cantante", "weight": 50, "once_per_save": false, "conditions": [],
     "choices": [
       {"id": "touch", "label": "Tocar", "effects": [{"type": "modify_next_encounter", "stat": "attack_speed", "op": "ADD_PERCENT", "value": 0.08, "encounters": 1}]},
       {"id": "cut", "label": "Cortar", "effects": [{"type": "damage_fraction", "scope": "all", "value": 0.05}, {"type": "grant_item", "rarity": "Comum"}]},
       {"id": "ignore", "label": "Ignorar", "effects": []}
     ]},
    {"id": "event_c1_cristal_partido", "design_id": null, "kind": "random", "name": "Cristal Partido", "weight": 30, "once_per_save": false, "conditions": [],
     "choices": [
       {"id": "absorb", "label": "Absorver o poder", "effects": [
         {"type": "damage_fraction", "scope": "all", "value": 0.15},
         {"type": "modify_next_encounter", "stat": "attack", "op": "ADD_PERCENT", "value": 0.12, "encounters": 2}]},
       {"id": "leave", "label": "Deixar", "effects": []}
     ]},
    {"id": "event_c1_memorial", "design_id": null, "kind": "random", "name": "Memorial Esquecido", "weight": 30, "once_per_save": false, "conditions": [],
     "choices": [
       {"id": "honor", "label": "Honrar {hero}", "per_hero": true, "effects": [
         {"type": "heal_fraction", "scope": "pick", "value": 0.15},
         {"type": "reveal_lore", "text_id": "LORE_EVT_MEMORIAL_{hero}"}]}
     ]},
    {"id": "event_c1_eco_percebido", "design_id": null, "kind": "personal", "name": "Eco Percebido", "weight": 30, "once_per_save": false,
     "conditions": [{"type": "party_has", "hero": "hero_003"}],
     "choices": [
       {"id": "react", "label": "Reagir ao Eco", "effects": [
         {"type": "reveal_lore", "text_id": "LORE_EVT_ECO_PERCEBIDO"},
         {"type": "modify_next_encounter", "stat": "attack", "op": "ADD_PERCENT", "value": 0.05, "encounters": 1}]}
     ]},
    {"id": "event_c1_rastro_cacada", "design_id": null, "kind": "personal", "name": "Rastro da Caçada", "weight": 30, "once_per_save": false,
     "conditions": [{"type": "party_has", "hero": "hero_002"}],
     "choices": [
       {"id": "follow", "label": "Seguir o rastro", "effects": [
         {"type": "damage_fraction", "scope": "all", "value": 0.08},
         {"type": "modify_next_encounter", "mark_first_enemy": true, "encounters": 1}]},
       {"id": "ignore", "label": "Ignorar", "effects": []}
     ]},
    {"id": "event_c1_sobrevivente", "design_id": null, "kind": "personal", "name": "O Sobrevivente", "weight": 30, "once_per_save": false,
     "conditions": [{"type": "party_has", "hero": "hero_001"}],
     "choices": [
       {"id": "protect", "label": "Proteger", "effects": [
         {"type": "damage_fraction", "scope": "hero_001", "value": 0.15},
         {"type": "grant_item", "rarity": "Incomum"},
         {"type": "reveal_lore", "text_id": "LORE_EVT_SOBREVIVENTE"}]},
       {"id": "pass", "label": "Passar", "effects": []}
     ]},
    {"id": "event_c1_observador", "design_id": null, "kind": "secret", "name": "O Observador", "weight": 0, "once_per_save": true, "auto": true, "conditions": [],
     "choices": [{"id": "witness", "label": "Testemunhar", "effects": [
       {"type": "set_flag", "flag": "observador_visto"},
       {"type": "reveal_lore", "text_id": "LORE_EVT_OBSERVADOR"}]}]}
  ]
}
```

- [ ] **Passo 2: escrever o teste que falha** (`tests/unit/test_event_director.gd`)

```gdscript
extends Node

var success := true
var catalog: Dictionary

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE EVENT DIRECTOR (SLICE-1B) ---")
	catalog = EventDirector.load_catalog()
	_test_catalog()
	_test_validation_rejects_unknowns()
	_test_eligibility()
	_test_transition_roll()
	_test_choices_and_outcomes()
	print("=======================================================")
	print("[%s] TESTE EVENT DIRECTOR" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _ctx(heroes: Array = ["hero_001", "hero_002", "hero_003"], flags: Dictionary = {}) -> Dictionary:
	return {"alive_heroes": heroes, "party_level": 5, "equipped": [], "previous_no_falls": true, "flags": flags}

func _test_catalog() -> void:
	print("\n>>> 1. CATÁLOGO")
	_expect("catálogo válido", EventDirector.validate(catalog).is_empty())
	_expect("10 eventos", catalog["events"].size() == 10)
	var kinds := {}
	for e in catalog["events"]:
		kinds[e["kind"]] = int(kinds.get(e["kind"], 0)) + 1
	_expect("1 fixo de escolha + 1 fixo automático", kinds["fixed"] == 2)
	_expect("5 aleatórios, 3 pessoais, 1 secreto", kinds["random"] == 5 and kinds["personal"] == 3 and kinds["secret"] == 1)

func _test_validation_rejects_unknowns() -> void:
	print("\n>>> 2. VALIDAÇÃO")
	var bad_effect := {"random_rules": catalog["random_rules"], "events": [{"id": "x", "kind": "random", "weight": 1, "conditions": [], "choices": [{"id": "a", "label": "a", "effects": [{"type": "executar_codigo"}]}]}]}
	_expect("efeito desconhecido é rejeitado", not EventDirector.validate(bad_effect).is_empty())
	var bad_cond := {"random_rules": catalog["random_rules"], "events": [{"id": "x", "kind": "random", "weight": 1, "conditions": [{"type": "lua_cheia"}], "choices": [{"id": "a", "label": "a", "effects": []}]}]}
	_expect("condição desconhecida é rejeitada", not EventDirector.validate(bad_cond).is_empty())
	var no_choice := {"random_rules": catalog["random_rules"], "events": [{"id": "x", "kind": "random", "weight": 1, "conditions": [], "choices": []}]}
	_expect("evento sem escolha é rejeitado", not EventDirector.validate(no_choice).is_empty())

func _test_eligibility() -> void:
	print("\n>>> 3. ELEGIBILIDADE")
	var d := EventDirector.create(catalog, 1)
	var eco := d.event_by_id("event_c1_eco_percebido")
	_expect("Eco Percebido exige Íris", d.is_eligible(eco, _ctx()) and not d.is_eligible(eco, _ctx(["hero_001", "hero_002"])))
	var obs := d.event_by_id("event_c1_observador")
	_expect("Observador some depois de visto", d.is_eligible(obs, _ctx()) and not d.is_eligible(obs, _ctx(["hero_001"], {"seen_event_c1_observador": true})))
	_expect("event_by_id desconhecido devolve {}", d.event_by_id("nao_existe").is_empty())

func _test_transition_roll() -> void:
	print("\n>>> 4. SORTEIO NAS TRANSIÇÕES")
	var a := EventDirector.create(catalog, 5)
	var b := EventDirector.create(catalog, 5)
	var seq_a := []
	var seq_b := []
	for i in 30:
		var ea := String(a.roll_transition(_ctx()).get("id", ""))
		var eb := String(b.roll_transition(_ctx()).get("id", ""))
		if ea != "":
			a.mark_seen(ea)  # o run marca o evento como visto ao resolvê-lo
		if eb != "":
			b.mark_seen(eb)
		seq_a.append(ea)
		seq_b.append(eb)
	_expect("mesma seed, mesma sequência", seq_a == seq_b)
	_expect("máximo 2 aleatórios por run", seq_a.filter(func(id): return id != "" and id != "event_c1_observador").size() <= 2)
	var seen := {}
	for id in seq_a:
		if id != "":
			_expect("evento %s não repete na run" % id, not seen.has(id))
			seen[id] = true
	var freq := 0
	var trials := 4000
	for i in trials:
		var d := EventDirector.create(catalog, 1000 + i)
		if not d.roll_transition(_ctx()).is_empty():
			freq += 1
	_expect("≈ 25%% de eventos por transição (%.3f)" % (float(freq) / trials), absf(float(freq) / trials - 0.26) < 0.03)
	var no_eco := 0
	for i in 2000:
		var d := EventDirector.create(catalog, 9000 + i)
		if d.roll_transition(_ctx(["hero_001", "hero_002"])).get("id", "") == "event_c1_eco_percebido":
			no_eco += 1
	_expect("sem Íris o Eco nunca aparece", no_eco == 0)

func _test_choices_and_outcomes() -> void:
	print("\n>>> 5. ESCOLHAS E RESULTADOS")
	var d := EventDirector.create(catalog, 3)
	var memorial := d.event_by_id("event_c1_memorial")
	var choices := d.choices_for(memorial, _ctx())
	_expect("Memorial gera uma escolha por herói vivo", choices.size() == 3)
	var fx := d.resolve(choices[1])
	_expect("escopo 'pick' vira o herói escolhido", fx[0]["scope"] == "hero_002" and fx[1]["text_id"] == "LORE_EVT_MEMORIAL_hero_002")
	var raiz := d.event_by_id("event_c1_raiz_oca")
	var open_choice: Dictionary = d.choices_for(raiz, _ctx())[0]
	var counts := {"damage": 0, "item": 0, "nothing": 0}
	for i in 6000:
		var res := EventDirector.create(catalog, i).resolve(open_choice)
		if res.is_empty():
			counts["nothing"] += 1
		elif res[0]["type"] == "damage_fraction":
			counts["damage"] += 1
		else:
			counts["item"] += 1
	_expect("Raiz Oca: ≈20%% espinhos, ≈15%% esconderijo, ≈65%% nada", absf(counts["damage"] / 6000.0 - 0.20) < 0.03 and absf(counts["item"] / 6000.0 - 0.15) < 0.03 and absf(counts["nothing"] / 6000.0 - 0.65) < 0.03)
	var poco := d.event_by_id("event_c1_001")
	_expect("Poço tem duas escolhas", d.choices_for(poco, _ctx()).size() == 2)
```

- [ ] **Passo 3: criar `TestEventDirector.tscn`, importar, rodar e ver falhar** (tipo `EventDirector` desconhecido).

- [ ] **Passo 4: implementar `scripts/run/EventDirector.gd`**

```gdscript
extends RefCounted
class_name EventDirector

## Eventos de expedição do slice (SLICE-1B): validação do catálogo, elegibilidade, sorteio nas
## transições e resolução de escolhas. Puro. RNG derivado da seed e separado do combate.
## Um evento nunca executa código próprio: só efeitos do vocabulário fechado.

const CATALOG_PATH := "res://data/expedition/events_c1.json"
const CONDITIONS := ["party_has", "hero_level_at_least", "item_equipped", "previous_encounter_no_falls", "flag"]
const EFFECTS := ["heal_fraction", "damage_fraction", "grant_material", "grant_reward_choice", "grant_item", "set_flag", "reveal_lore", "modify_next_encounter"]
const KINDS := ["fixed", "random", "personal", "secret"]

var _catalog: Dictionary = {}
var _by_id: Dictionary = {}
var _rng := RandomNumberGenerator.new()
var _seen_run: Array = []
var _random_count: int = 0

static func load_catalog() -> Dictionary:
	var file := FileAccess.open(CATALOG_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

## Lista de erros; vazia quando o catálogo é válido.
static func validate(catalog: Dictionary) -> Array:
	var errors: Array = []
	if not catalog.has("random_rules") or not catalog.has("events"):
		return ["catálogo sem random_rules ou events"]
	var ids := {}
	for event in catalog["events"]:
		var id := String(event.get("id", ""))
		if id == "" or ids.has(id):
			errors.append("id vazio ou duplicado: %s" % id)
		ids[id] = true
		if not KINDS.has(String(event.get("kind", ""))):
			errors.append("%s: tipo desconhecido" % id)
		for cond in event.get("conditions", []):
			if not CONDITIONS.has(String(cond.get("type", ""))):
				errors.append("%s: condição desconhecida %s" % [id, cond.get("type", "")])
		if event.get("choices", []).is_empty():
			errors.append("%s: sem escolhas" % id)
		for choice in event.get("choices", []):
			var groups: Array = []
			if choice.has("outcomes"):
				for outcome in choice["outcomes"]:
					groups.append(outcome.get("effects", []))
			else:
				groups.append(choice.get("effects", []))
			for effects in groups:
				for fx in effects:
					if not EFFECTS.has(String(fx.get("type", ""))):
						errors.append("%s: efeito desconhecido %s" % [id, fx.get("type", "")])
	return errors

static func create(catalog: Dictionary, seed_value: int) -> EventDirector:
	var director := EventDirector.new()
	director._catalog = catalog
	for event in catalog.get("events", []):
		director._by_id[event["id"]] = event
	director._rng.seed = LootRoller.derive_seed(seed_value, "events")
	return director

func event_by_id(id: String) -> Dictionary:
	return _by_id.get(id, {})

func mark_seen(event_id: String) -> void:
	if not _seen_run.has(event_id):
		_seen_run.append(event_id)
		if String(event_by_id(event_id).get("kind", "")) in ["random", "personal"]:
			_random_count += 1

func _condition_ok(cond: Dictionary, ctx: Dictionary) -> bool:
	match String(cond["type"]):
		"party_has":
			return ctx["alive_heroes"].has(cond["hero"])
		"hero_level_at_least":
			return int(ctx["party_level"]) >= int(cond["value"])
		"item_equipped":
			for inst in ctx["equipped"]:
				if inst["id"] == cond.get("item", inst["id"]) and inst["rarity"] == cond.get("rarity", inst["rarity"]):
					return true
			return false
		"previous_encounter_no_falls":
			return bool(ctx["previous_no_falls"])
		"flag":
			return bool(ctx["flags"].get(cond["name"], false))
	return false

func is_eligible(event: Dictionary, ctx: Dictionary) -> bool:
	if _seen_run.has(event["id"]):
		return false
	if bool(event.get("once_per_save", false)) and bool(ctx["flags"].get("seen_%s" % event["id"], false)):
		return false
	for cond in event.get("conditions", []):
		if not _condition_ok(cond, ctx):
			return false
	return true

## Sorteia no máximo um evento para uma transição entre encontros comuns.
## Ordem: secreto (chance baixa), depois aleatório/pessoal (chance e peso). Limite por run em random_rules.
func roll_transition(ctx: Dictionary) -> Dictionary:
	var rules: Dictionary = _catalog["random_rules"]
	var secrets: Array = []
	var pool: Array = []
	for event in _catalog["events"]:
		if not is_eligible(event, ctx):
			continue
		match String(event["kind"]):
			"secret":
				secrets.append(event)
			"random", "personal":
				pool.append(event)
	if not secrets.is_empty() and _rng.randf() < float(rules["secret_chance"]):
		return secrets[0]
	if pool.is_empty() or _random_count >= int(rules["max_random_per_run"]):
		return {}
	if _rng.randf() >= float(rules["transition_chance"]):
		return {}
	var total := 0.0
	for event in pool:
		total += float(event["weight"])
	var roll := _rng.randf() * total
	var acc := 0.0
	for event in pool:
		acc += float(event["weight"])
		if roll < acc:
			return event
	return pool[pool.size() - 1]

func _substitute(value, hero_id: String):
	if value is String:
		return value.replace("{hero}", hero_id)
	if value is Array:
		return value.map(func(v): return _substitute(v, hero_id))
	if value is Dictionary:
		var out := {}
		for k in value:
			out[k] = _substitute(value[k], hero_id)
		return out
	return value

## Escolhas concretas: uma escolha `per_hero` vira uma por herói vivo, com o escopo "pick" trocado pelo herói.
func choices_for(event: Dictionary, ctx: Dictionary) -> Array:
	var out: Array = []
	for choice in event["choices"]:
		if not bool(choice.get("per_hero", false)):
			out.append(choice.duplicate(true))
			continue
		for hero_id in ctx["alive_heroes"]:
			var expanded: Dictionary = _substitute(choice, hero_id)
			expanded["id"] = "%s_%s" % [choice["id"], hero_id]
			expanded.erase("per_hero")
			for fx in expanded["effects"]:
				if fx.get("scope", "") == "pick":
					fx["scope"] = hero_id
			out.append(expanded)
	return out

## Efeitos concretos de uma escolha: escolhas com `outcomes` sorteiam um resultado por peso.
func resolve(choice: Dictionary) -> Array:
	if not choice.has("outcomes"):
		return choice.get("effects", []).duplicate(true)
	var total := 0.0
	for outcome in choice["outcomes"]:
		total += float(outcome["weight"])
	var roll := _rng.randf() * total
	var acc := 0.0
	for outcome in choice["outcomes"]:
		acc += float(outcome["weight"])
		if roll < acc:
			return outcome.get("effects", []).duplicate(true)
	return choice["outcomes"][choice["outcomes"].size() - 1].get("effects", []).duplicate(true)
```

- [ ] **Passo 5: importar, rodar a cena e a suíte**

Esperado: PASS. Se a frequência de evento ficar fora de ~0,26, lembre que `max_random_per_run` só limita dentro de um mesmo diretor; o teste usa um diretor novo por tentativa, então cada tentativa é a primeira transição. A chance efetiva é `transition_chance` (0,25) mais a fração de secretos (~1%).

---

## Tarefa 4: Integrar loot e eventos ao `ExpeditionRun` (estado `choice`)

**Arquivos:**
- Modificar: `scripts/combat/ExpeditionRun.gd` (blocos abaixo, todos ancorados por trechos existentes)
- Teste: `tests/unit/test_expedition_choices.gd`, `tests/unit/TestExpeditionChoices.tscn`

**Interfaces:**
- Consome: `LootRoller` (Tarefa 1), `EventDirector` (Tarefa 3).
- Novas opções de `ExpeditionRun.create`: `loot: LootRoller`, `events: EventDirector`, `flags: Dictionary` (flags do save), `first_clear: bool` (padrão `false`).
- Produz (Tarefas 6 e 7):
  - estado `"choice"`; `pending: Dictionary` = `{"kind": "reward"|"event", "id": String, "options": Array}` (opções: instâncias de item para `reward`; escolhas de evento para `event`)
  - `choose(index: int) -> Array` (eventos gerados; devolve `[]` se não há escolha pendente ou o índice é inválido)
  - `rewards: Dictionary` = `{"items": Array, "materials": Dictionary, "flags": Dictionary, "lore": Array}` (livro-razão da run)
  - eventos novos: `loot_dropped {item}`, `material_dropped {id, quantity}`, `reward_offered {id, options}`, `reward_chosen {id, item}`, `event_offered {id, auto?, options?}`, `event_resolved {id, choice, effects}`, `event_damage {target, amount}`, `flag_set {flag}`, `lore_revealed {text_id}`, `next_encounter_modified {…}`

Comportamento: com `loot`/`events` nulos o run é idêntico ao atual. Em `choice` o tempo **não avança**: `step` devolve `[]`. Após `choose`, a fila de ofertas continua até esvaziar e só então começa a transição.

- [ ] **Passo 1: escrever o teste que falha** (`tests/unit/test_expedition_choices.gd`)

```gdscript
extends Node

var success := true
var tables: Dictionary
var items: Array
var catalog: Dictionary

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}

func _ready() -> void:
	print("--- TESTE EXPEDITION CHOICES (SLICE-1B) ---")
	tables = LootRoller.load_tables()
	items = SliceStats.load_rows("res://data/items/items.json", "slice")
	catalog = EventDirector.load_catalog()
	_test_neutral_without_options()
	_test_reward_choice_pauses()
	_test_poco_choices()
	_test_effects()
	_test_determinism_and_separation()
	_test_boss_first_clear()
	print("=======================================================")
	print("[%s] TESTE EXPEDITION CHOICES" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _run(seed_value: int, extra: Dictionary = {}) -> ExpeditionRun:
	var opts := {"loot": LootRoller.create(tables, items, seed_value), "events": EventDirector.create(catalog, seed_value)}
	opts.merge(extra, true)
	return SliceSession.create_run(BUILD, 12, seed_value, opts)

## Roda até o fim escolhendo sempre a opção `pick`; devolve todos os eventos.
func _play(run: ExpeditionRun, pick: int = 0) -> Array:
	var all: Array = []
	var guard := 0
	while run.state != "won" and run.state != "lost" and guard < 20000:
		guard += 1
		if run.state == "choice":
			all.append_array(run.choose(mini(pick, run.pending["options"].size() - 1)))
		else:
			all.append_array(run.step(0.5))
	return all

func _test_neutral_without_options() -> void:
	print("\n>>> 1. NEUTRALIDADE SEM OPÇÕES")
	var plain := SliceSession.create_run(BUILD, 12, 4)
	plain.run_to_end()
	var no_events := SliceSession.create_run(BUILD, 12, 4, {"loot": LootRoller.create(tables, items, 4)})
	no_events.run_to_end()
	_expect("loot ligado (sem eventos) não altera o combate", plain.state == no_events.state and is_equal_approx(plain.time, no_events.time) and plain.snapshot()["party_hp"] == no_events.snapshot()["party_hp"])

func _test_reward_choice_pauses() -> void:
	print("\n>>> 2. REWARD CHOICE PAUSA A RUN")
	var run := _run(21)
	var guard := 0
	while run.state != "choice" and run.state != "won" and run.state != "lost" and guard < 5000:
		guard += 1
		run.step(0.5)
	_expect("a run pausa em uma escolha", run.state == "choice")
	var t_before := run.time
	run.step(30.0)
	_expect("em `choice` o tempo não avança", is_equal_approx(run.time, t_before))
	_expect("escolha inválida é ignorada", run.choose(99).is_empty() and run.state == "choice")
	var pending := run.pending
	var kind := String(pending["kind"])
	var count_before := run.rewards["items"].size()
	var events := run.choose(0)
	_expect("escolher gera eventos e resolve a oferta", not events.is_empty() and run.pending != pending)
	if kind == "reward":
		_expect("a escolha entra no livro-razão como item", run.rewards["items"].size() == count_before + 1)

func _test_poco_choices() -> void:
	print("\n>>> 3. POÇO DE LÚMEN")
	for pick in [0, 1]:
		var run := _run(33)
		var hp_before := {}
		var reached := false
		var guard := 0
		while run.state != "won" and run.state != "lost" and guard < 20000:
			guard += 1
			if run.state == "choice":
				if run.pending["id"] == "event_c1_001":
					hp_before = run.snapshot()["party_hp"].duplicate()
					var ev := run.choose(pick)
					reached = true
					var hp_after: Dictionary = run.snapshot()["party_hp"]
					if pick == 0:
						var healed := false
						for hid in hp_after:
							healed = healed or hp_after[hid] > hp_before[hid]
						_expect("curar aumenta o HP de quem estava ferido (ou já estava cheio)", healed or _all_full(hp_before, run))
					else:
						var hurt := true
						for hid in hp_after:
							hurt = hurt and hp_after[hid] >= 1.0 and hp_after[hid] <= hp_before[hid]
						_expect("sacrificar reduz HP sem matar (mínimo 1)", hurt)
						_expect("sacrificar abre uma escolha de recompensa", run.state == "choice" and run.pending["kind"] == "reward")
					break
				else:
					run.choose(0)
			else:
				run.step(0.5)
		_expect("o Poço apareceu (escolha %d)" % pick, reached)

func _all_full(hp: Dictionary, run: ExpeditionRun) -> bool:
	for p in run.snapshot()["party"]:
		if not is_equal_approx(hp[p["id"]], p["max_hp"]):
			return false
	return true

func _test_effects() -> void:
	print("\n>>> 4. EFEITOS DE EVENTO")
	var forced := {"random_rules": {"transition_chance": 1.0, "secret_chance": 0.0, "max_random_per_run": 4},
		"events": [{"id": "ev_buff", "kind": "random", "weight": 1, "once_per_save": false, "conditions": [],
			"choices": [{"id": "go", "label": "go", "effects": [
				{"type": "modify_next_encounter", "stat": "attack", "op": "ADD_PERCENT", "value": 0.5, "encounters": 1},
				{"type": "modify_next_encounter", "mark_first_enemy": true, "encounters": 1},
				{"type": "set_flag", "flag": "f1"}, {"type": "reveal_lore", "text_id": "L1"},
				{"type": "grant_material", "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 3},
				{"type": "damage_fraction", "scope": "all", "value": 5.0}]}]}]}
	_expect("catálogo de teste válido", EventDirector.validate(forced).is_empty())
	var run := _run(5, {"events": EventDirector.create(forced, 5)})
	var events := _play(run)
	var types := {}
	for ev in events:
		types[ev["type"]] = int(types.get(ev["type"], 0)) + 1
	_expect("evento oferecido e resolvido", types.get("event_offered", 0) >= 1 and types.get("event_resolved", 0) >= 1)
	_expect("flag, lore e material chegam ao livro-razão", run.rewards["flags"].has("f1") and run.rewards["lore"].has("L1") and int(run.rewards["materials"].get("MAT_C1_LUMEN_RESIDUE", 0)) >= 3)
	var min_hp := INF
	for ev in events:
		if ev["type"] == "event_damage":
			min_hp = minf(min_hp, float(ev["remaining"]))
	_expect("dano de evento nunca deixa ninguém abaixo de 1 HP", min_hp >= 1.0 - 0.0001)
	_expect("modificador do próximo encontro foi aplicado", types.get("next_encounter_modified", 0) >= 2)

func _test_determinism_and_separation() -> void:
	print("\n>>> 5. DETERMINISMO E RNG SEPARADO")
	var a := _play(_run(77))
	var b := _play(_run(77))
	_expect("mesma seed e escolhas: mesmos eventos", a == b)
	var no_chance := {"random_rules": {"transition_chance": 0.0, "secret_chance": 0.0, "max_random_per_run": 0}, "events": EventDirector.load_catalog()["events"]}
	var quiet := _run(9, {"events": EventDirector.create(no_chance, 9)})
	_play(quiet, 0)
	var loot_only := SliceSession.create_run(BUILD, 12, 9, {"loot": LootRoller.create(tables, items, 9)})
	var events_loot := _play(loot_only, 0)
	_expect("eventos sem chance de sortear não mudam o combate", quiet.state == loot_only.state)

func _test_boss_first_clear() -> void:
	print("\n>>> 6. BOSS")
	var run := _run(101, {"first_clear": true})
	var events := _play(run, 0)
	if run.state != "won":
		print("(aviso) a run de teste não venceu; o teste do boss é pulado com seed 101")
		return
	var relic := false
	for ev in events:
		if ev["type"] == "loot_dropped" and ev["item"]["id"] == "item_a_005":
			relic = true
	_expect("primeiro clear entrega a Casca do Guardião", relic)
```

Nota para quem executa: se o nível 12 do trio não vencer a rota com as builds de teste, use o nível mais alto em que `tools/argos` mostra vitória (o Argos `slice_quick` documenta as builds vencedoras) e ajuste `SliceSession.create_run(BUILD, 12, ...)`; não altere `/data`.

- [ ] **Passo 2: criar `TestExpeditionChoices.tscn`, importar, rodar e ver falhar** (propriedades `pending`, `rewards`, método `choose` inexistentes).

- [ ] **Passo 3: aplicar as alterações no `ExpeditionRun.gd`**

3a. Depois de `var telemetry: SliceTelemetry = null`, adicione:

```gdscript
## SLICE-1B: loot, eventos e escolhas pendentes. Sem loot/events o run é idêntico ao anterior.
var loot: LootRoller = null
var director: EventDirector = null
var pending: Dictionary = {}
var rewards: Dictionary = {"items": [], "materials": {}, "flags": {}, "lore": []}
var _offers: Array = []
var _flags: Dictionary = {}
var _first_clear: bool = false
var _party_level: int = 1
var _equipped_list: Array = []
var _event_mods: Array = []
var _mod_uid: int = 0
```

3b. Em `create`, logo depois do bloco `if bool(options.get("telemetry", false)): ...`, adicione:

```gdscript
	run.loot = options.get("loot", null)
	run.director = options.get("events", null)
	run._flags = options.get("flags", {}).duplicate()
	run._first_clear = bool(options.get("first_clear", false))
	run._party_level = int(options.get("party_level", 1))
	for hero_gear in options.get("equipment", {}).values():
		run._equipped_list.append_array(hero_gear)
```

3c. Em `step`: troque a guarda inicial e a condição do laço.

```gdscript
	if state == "won" or state == "lost" or state == "choice":
		return events
```
e, como **primeira linha dentro** de `while state != "won" and state != "lost":`:

```gdscript
		if state == "choice":
			break
```

3d. Em `_advance_node`, dentro de `if node["type"] == "event":`, logo depois de `events.append({"type": "event_reached", ...})`, insira:

```gdscript
		if director != null and not director.event_by_id(String(node["id"])).is_empty():
			_queue_event(director.event_by_id(String(node["id"])))
			_next_offer(events)
			return
```

3e. Em `_finish_encounter`, substitua a última linha `_begin_transition()` por:

```gdscript
	_expire_event_mods()
	_queue_offers_after_encounter(events)
	_next_offer(events)
```

3f. Em `_start_encounter`, imediatamente **antes** de `events.append({"type": "encounter_started", ...})`, adicione:

```gdscript
	_apply_event_mods(events)
```

3g. Em `_damage_enemy`, logo depois de `events.append({"type": "enemy_defeated", ...})`, adicione:

```gdscript
	if loot != null:
		_collect_drop(enemy, events)
```

3h. Adicione ao final do arquivo o bloco novo:

```gdscript
# --- SLICE-1B: ofertas, escolhas, loot e efeitos de evento ------------------------------------

func _current_level() -> int:
	return int(_nodes[node_index]["level"]) if node_index >= 0 and node_index < _nodes.size() else _party_level

func _event_context() -> Dictionary:
	var alive: Array = []
	for hid in _hero_order:
		if _heroes[hid]["alive"]:
			alive.append(hid)
	return {"alive_heroes": alive, "party_level": _party_level, "equipped": _equipped_list,
		"previous_no_falls": not _fell_this_encounter, "flags": _flags}

func _queue_event(event: Dictionary) -> void:
	_offers.append({"kind": "event", "id": event["id"], "event": event, "options": director.choices_for(event, _event_context())})

func _queue_offers_after_encounter(events: Array) -> void:
	var node: Dictionary = _nodes[node_index]
	var kind := String(node.get("kind", "NORMAL"))
	if loot != null:
		if kind == "ELITE" or kind == "MINIBOSS":
			_offers.append({"kind": "reward", "id": "reward_%s" % node["id"], "options": loot.roll_choice(kind, _current_level())})
		elif kind == "BOSS":
			var boss := loot.roll_boss(_first_clear, _current_level())
			for inst in boss["items"]:
				_grant_item(inst, events)
			if not boss["choice"].is_empty():
				_offers.append({"kind": "reward", "id": "reward_%s" % node["id"], "options": boss["choice"]})
	if director != null and kind == "NORMAL" and node_index + 1 < _nodes.size():
		var next_node: Dictionary = _nodes[node_index + 1]
		if next_node["type"] == "encounter" and String(next_node.get("kind", "NORMAL")) == "NORMAL":
			var event := director.roll_transition(_event_context())
			if not event.is_empty():
				_queue_event(event)

func _option_labels(offer: Dictionary) -> Array:
	var labels: Array = []
	for option in offer["options"]:
		labels.append(String(option.get("label", option.get("id", ""))))
	return labels

## Abre a próxima oferta (pausa em `choice`) ou, sem ofertas, inicia a transição.
func _next_offer(events: Array) -> void:
	while not _offers.is_empty():
		var offer: Dictionary = _offers.pop_front()
		if offer["options"].is_empty():
			continue
		var is_event := String(offer["kind"]) == "event"
		if is_event and bool(offer["event"].get("auto", false)):
			events.append({"type": "event_offered", "time": time, "id": offer["id"], "auto": true})
			_resolve_event_choice(offer, offer["options"][0], events)
			continue
		pending = offer
		state = "choice"
		events.append({"type": "event_offered" if is_event else "reward_offered", "time": time, "id": offer["id"], "options": _option_labels(offer)})
		return
	pending = {}
	_begin_transition()

## Resolve a escolha pendente. Devolve os eventos gerados ([] se não há escolha ou o índice é inválido).
func choose(index: int) -> Array:
	var events: Array = []
	if state != "choice" or index < 0 or index >= pending["options"].size():
		return events
	var offer := pending
	var option: Dictionary = offer["options"][index]
	pending = {}
	if String(offer["kind"]) == "event":
		_resolve_event_choice(offer, option, events)
	else:
		events.append({"type": "reward_chosen", "time": time, "id": offer["id"], "item": option})
		_grant_item(option, events)
	_next_offer(events)
	if telemetry != null:
		telemetry.ingest(events)
	return events

func _resolve_event_choice(offer: Dictionary, choice: Dictionary, events: Array) -> void:
	director.mark_seen(String(offer["id"]))
	_flags["seen_%s" % offer["id"]] = true
	rewards["flags"]["seen_%s" % offer["id"]] = true
	var effects := director.resolve(choice)
	events.append({"type": "event_resolved", "time": time, "id": offer["id"], "choice": choice["id"], "effects": effects.size()})
	for fx in effects:
		_apply_effect(fx, events)

func _grant_item(inst: Dictionary, events: Array) -> void:
	rewards["items"].append(inst)
	events.append({"type": "loot_dropped", "time": time, "item": inst})

func _grant_material(id: String, quantity: int, events: Array) -> void:
	rewards["materials"][id] = int(rewards["materials"].get(id, 0)) + quantity
	events.append({"type": "material_dropped", "time": time, "id": id, "quantity": quantity})

func _collect_drop(enemy: Dictionary, events: Array) -> void:
	var drop := loot.roll_enemy_drop(_enemy_rows[enemy["id"]], _current_level())
	for inst in drop["items"]:
		_grant_item(inst, events)
	for id in drop["materials"]:
		_grant_material(String(id), int(drop["materials"][id]), events)

func _scope_heroes(scope: String) -> Array:
	var out: Array = []
	for hid in _hero_order:
		if _heroes[hid]["alive"] and (scope == "all" or scope == hid):
			out.append(_heroes[hid])
	return out

func _apply_effect(fx: Dictionary, events: Array) -> void:
	match String(fx["type"]):
		"heal_fraction":
			for h in _scope_heroes(String(fx.get("scope", "all"))):
				var amount: float = minf(float(h["stats"]["max_hp"]) * float(fx["value"]), float(h["stats"]["max_hp"]) - float(h["hp"]))
				if amount > 0.0:
					h["hp"] = float(h["hp"]) + amount
					events.append({"type": "recovery", "time": time, "source": "event", "target": h["id"], "amount": amount})
		"damage_fraction":
			for h in _scope_heroes(String(fx.get("scope", "all"))):
				var lost: float = minf(float(h["stats"]["max_hp"]) * float(fx["value"]), float(h["hp"]) - 1.0)
				if lost > 0.0:
					h["hp"] = float(h["hp"]) - lost
				events.append({"type": "event_damage", "time": time, "target": h["id"], "amount": maxf(lost, 0.0), "remaining": float(h["hp"])})
		"grant_material":
			_grant_material(String(fx["id"]), int(fx["quantity"]), events)
		"grant_item":
			if loot != null:
				var inst := loot.roll_event_item(String(fx["rarity"]), _current_level())
				if not inst.is_empty():
					_grant_item(inst, events)
		"grant_reward_choice":
			if loot != null:
				_offers.push_front({"kind": "reward", "id": "reward_event", "options": loot.roll_event_choice(_current_level(), String(fx["min_rarity"]))})
		"set_flag":
			_flags[fx["flag"]] = true
			rewards["flags"][fx["flag"]] = true
			events.append({"type": "flag_set", "time": time, "flag": fx["flag"]})
		"reveal_lore":
			rewards["lore"].append(fx["text_id"])
			events.append({"type": "lore_revealed", "time": time, "text_id": fx["text_id"]})
		"modify_next_encounter":
			_event_mods.append(fx.duplicate(true))
			_event_mods[_event_mods.size() - 1]["left"] = int(fx.get("encounters", 1))
			_event_mods[_event_mods.size() - 1]["mid"] = _mod_uid
			_mod_uid += 1
			events.append({"type": "next_encounter_modified", "time": time, "mark": bool(fx.get("mark_first_enemy", false)), "stat": String(fx.get("stat", ""))})

## Aplica os modificadores pendentes ao encontro que começa: bônus de status da party (durante N encontros) e Marca no primeiro inimigo (uma vez).
func _apply_event_mods(_events: Array) -> void:
	for mod in _event_mods:
		if bool(mod.get("mark_first_enemy", false)):
			if not _enemies.is_empty() and int(mod["left"]) > 0:
				_enemies[0]["marked_until"] = time + 30.0
			mod["left"] = 0
			continue
		if int(mod["left"]) > 0 and not bool(mod.get("applied", false)):
			for hid in _hero_order:
				if _heroes[hid]["alive"]:
					_heroes[hid]["effects"].append({"source": "event", "mid": mod["mid"], "stat": mod["stat"], "op": mod["op"], "value": float(mod["value"]), "expires_at": INF, "defensive": false})
			mod["applied"] = true

## Ao fim do encontro, gasta um encontro de cada modificador e remove os bônus esgotados.
func _expire_event_mods() -> void:
	for mod in _event_mods:
		if bool(mod.get("applied", false)):
			mod["left"] = int(mod["left"]) - 1
	var spent: Array = []
	for mod in _event_mods:
		if int(mod["left"]) <= 0:
			spent.append(mod["mid"])
	for hid in _hero_order:
		_heroes[hid]["effects"] = _heroes[hid]["effects"].filter(func(e): return not spent.has(e.get("mid", -1)))
	_event_mods = _event_mods.filter(func(mod): return int(mod["left"]) > 0)
```

- [ ] **Passo 4: importar e rodar `TestExpeditionChoices`, depois a suíte completa**

Esperado: `TestExpeditionChoices` PASS e todas as cenas anteriores PASS. Em especial `TestExpeditionRun`, `TestExpeditionMechanics`, `TestExpeditionSkills`, `TestArgosOracles` e `TestSliceTelemetry` não podem mudar de resultado: a Tarefa 4 é neutra quando `loot`/`events` são nulos.

- [ ] **Passo 5: rodar o Argos rápido para confirmar neutralidade**

Run: `python tools/argos/run.py --scenario slice_quick`
Esperado: `0 BUG`, mesmo número de execuções. Apague **só** o relatório novo que você gerou (`tools/argos/reports/<data-hora>_<commit>` criado agora); nunca apague relatórios anteriores.

---

## Tarefa 5: `SliceSave`

**Arquivos:**
- Criar: `scripts/run/SliceSave.gd`
- Teste: `tests/unit/test_slice_save.gd`, `tests/unit/TestSliceSave.tscn`

**Interfaces:**
- Consome: `SliceInventory.to_dict()` (Tarefa 2), `ExpeditionRun.xp_to_next(level, profiles)` e `SliceStats.load_profiles()`.
- Produz (Tarefa 6):
  - `SliceSave.VERSION := 1`
  - `SliceSave.default_data() -> Dictionary` (`version`, `inventory: {}`, `party: {level, xp}`, `boss_cleared`, `flags`, `lore`)
  - `SliceSave.read(path: String) -> Dictionary` → `{"ok": bool, "error": "" | "missing" | "corrupt" | "version", "data": Dictionary}`; `missing` devolve `ok: true` com `default_data()`
  - `SliceSave.write(path: String, data: Dictionary) -> bool` (escreve em arquivo temporário e renomeia)
  - `SliceSave.add_xp(data: Dictionary, amount: int, profiles: Dictionary) -> int` (devolve quantos níveis subiu)

Regra de segurança: `read` **nunca** apaga nem sobrescreve o arquivo; `corrupt` e `version` devolvem `ok: false` e a `SliceCampaign` (Tarefa 6) bloqueia a gravação.

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true
const PATH := "user://test_slice_save.json"

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE SAVE (SLICE-1B) ---")
	_cleanup()
	_test_missing_and_roundtrip()
	_test_unknown_version_preserved()
	_test_corrupt_preserved()
	_test_xp()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE SLICE SAVE" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _test_missing_and_roundtrip() -> void:
	print("\n>>> 1. AUSENTE E IDA E VOLTA")
	var res := SliceSave.read(PATH)
	_expect("arquivo ausente vira save novo", res["ok"] and res["data"]["version"] == SliceSave.VERSION and res["data"]["party"]["level"] == 1)
	var data := SliceSave.default_data()
	data["boss_cleared"] = true
	data["flags"] = {"observador_visto": true}
	data["party"] = {"level": 7, "xp": 42}
	_expect("write devolve true", SliceSave.write(PATH, data))
	var back := SliceSave.read(PATH)
	_expect("ida e volta preserva os campos", back["ok"] and back["data"]["boss_cleared"] and back["data"]["flags"]["observador_visto"] and int(back["data"]["party"]["level"]) == 7 and int(back["data"]["party"]["xp"]) == 42)
	_expect("não sobra arquivo temporário", not FileAccess.file_exists(PATH + ".tmp"))

func _test_unknown_version_preserved() -> void:
	print("\n>>> 2. VERSÃO DESCONHECIDA")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string('{"version": 999, "party": {"level": 50, "xp": 1}}')
	file.close()
	var res := SliceSave.read(PATH)
	_expect("versão desconhecida é rejeitada", not res["ok"] and res["error"] == "version")
	var check := FileAccess.open(PATH, FileAccess.READ)
	_expect("o arquivo original continua intacto", check.get_as_text().contains("999"))

func _test_corrupt_preserved() -> void:
	print("\n>>> 3. JSON CORROMPIDO")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string("{isto não é json")
	file.close()
	var res := SliceSave.read(PATH)
	_expect("corrompido é rejeitado", not res["ok"] and res["error"] == "corrupt")
	var check := FileAccess.open(PATH, FileAccess.READ)
	_expect("o arquivo corrompido continua intacto", check.get_as_text() == "{isto não é json")

func _test_xp() -> void:
	print("\n>>> 4. XP E NÍVEL")
	var profiles := SliceStats.load_profiles()
	var data := SliceSave.default_data()
	var need := ExpeditionRun.xp_to_next(1, profiles)
	_expect("XP abaixo do necessário não sobe de nível", SliceSave.add_xp(data, need - 1, profiles) == 0 and data["party"]["level"] == 1)
	_expect("cruzar o limite sobe 1 nível e guarda o resto", SliceSave.add_xp(data, 1, profiles) == 1 and data["party"]["level"] == 2 and data["party"]["xp"] == 0)
	var big := SliceSave.default_data()
	SliceSave.add_xp(big, 1000000, profiles)
	_expect("nível respeita o teto do perfil", big["party"]["level"] == int(profiles["xp"]["max_level"]))
```

- [ ] **Passo 2: criar a cena, importar, rodar e ver falhar** (tipo `SliceSave` desconhecido).

- [ ] **Passo 3: implementar `scripts/run/SliceSave.gd`**

```gdscript
extends RefCounted
class_name SliceSave

## Save mínimo do slice (SLICE-1B): JSON versionado. Leitura nunca apaga nem sobrescreve.
## Versão desconhecida ou JSON corrompido devolvem ok=false; quem chama bloqueia a gravação.

const VERSION := 1

static func default_data() -> Dictionary:
	return {"version": VERSION, "inventory": {}, "party": {"level": 1, "xp": 0}, "boss_cleared": false, "flags": {}, "lore": []}

static func read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": true, "error": "missing", "data": default_data()}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "error": "corrupt", "data": {}}
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return {"ok": false, "error": "corrupt", "data": {}}
	if int(parsed.get("version", -1)) != VERSION:
		return {"ok": false, "error": "version", "data": {}}
	var data := default_data()
	data.merge(parsed, true)
	data["party"] = {"level": int(data["party"]["level"]), "xp": int(data["party"]["xp"])}
	return {"ok": true, "error": "", "data": data}

## Escreve em arquivo temporário e renomeia, para não deixar o save pela metade.
static func write(path: String, data: Dictionary) -> bool:
	var tmp := path + ".tmp"
	var file := FileAccess.open(tmp, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	return DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp), ProjectSettings.globalize_path(path)) == OK

## Soma XP à party e devolve quantos níveis subiu (teto em profiles["xp"]["max_level"]).
static func add_xp(data: Dictionary, amount: int, profiles: Dictionary) -> int:
	var party: Dictionary = data["party"]
	var max_level := int(profiles["xp"]["max_level"])
	var gained := 0
	party["xp"] = int(party["xp"]) + amount
	while int(party["level"]) < max_level:
		var need := ExpeditionRun.xp_to_next(int(party["level"]), profiles)
		if int(party["xp"]) < need:
			break
		party["xp"] = int(party["xp"]) - need
		party["level"] = int(party["level"]) + 1
		gained += 1
	if int(party["level"]) >= max_level:
		party["xp"] = 0
	return gained
```

- [ ] **Passo 4: importar, rodar a cena e a suíte.** Esperado: PASS.

---

## Tarefa 6: `SliceCampaign` (orquestração)

**Arquivos:**
- Criar: `scripts/run/SliceCampaign.gd`
- Teste: `tests/unit/test_slice_campaign.gd`, `tests/unit/TestSliceCampaign.tscn`

**Interfaces:**
- Consome: `SliceSave`, `SliceInventory`, `LootRoller`, `EventDirector`, `SliceSession.create_run(build, level, seed, extra)`, `ExpeditionRun.step/choose/rewards`.
- Produz (Plano B, tela):
  - `SliceCampaign.open(save_path: String) -> SliceCampaign`
  - propriedades: `data: Dictionary`, `inventory: SliceInventory`, `save_blocked: bool`, `save_error: String`, `telemetry: SliceTelemetry` (opcional)
  - `start_expedition(build: Dictionary, seed_value: int) -> ExpeditionRun` (trava o inventário, usa nível/equipamento/flags do save e `first_clear = not data.boss_cleared`)
  - `step(run: ExpeditionRun, dt: float) -> Array` e `choose(run: ExpeditionRun, index: int) -> Array` (chamam o run e **aplicam cada evento de recompensa ao inventário e ao save na hora**)
  - `finish_expedition(run: ExpeditionRun) -> Dictionary` (destrava; se `won`, marca `boss_cleared`; devolve `{"won": bool, "levels_gained": int, "items": int, "residue": int}`)
  - `recycle(uid: int) -> Dictionary` e `equip(hero_id: String, uid: int) -> String` (chamam o inventário, gravam e registram telemetria)

Regras: cada `loot_dropped`, `material_dropped`, `flag_set`, `lore_revealed` e `enemy_defeated` (XP) é aplicado imediatamente e grava o save (RUN_META: "salvar ao receber"). Com `save_blocked` nada é gravado, mas o jogo continua em memória. HP volta cheio: uma expedição nova sempre recria o run do zero.

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true
const PATH := "user://test_slice_campaign.json"
const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE CAMPAIGN (SLICE-1B) ---")
	_cleanup()
	_test_loot_saved_on_receipt()
	_test_lock_and_equipment()
	_test_blocked_save()
	_cleanup()
	print("=======================================================")
	print("[%s] TESTE SLICE CAMPAIGN" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _play(c: SliceCampaign, run: ExpeditionRun, stop_after_items: int = -1) -> void:
	var guard := 0
	while run.state != "won" and run.state != "lost" and guard < 20000:
		guard += 1
		if stop_after_items >= 0 and c.inventory.items.size() >= stop_after_items:
			return
		if run.state == "choice":
			c.choose(run, 0)
		else:
			c.step(run, 0.5)

func _test_loot_saved_on_receipt() -> void:
	print("\n>>> 1. SALVA AO RECEBER")
	var c := SliceCampaign.open(PATH)
	_expect("save novo abre sem bloqueio", not c.save_blocked and c.data["party"]["level"] == 1)
	c.data["party"]["level"] = 12  # nível em que a rota é vencível (Argos), para haver loot no meio da run
	var run := c.start_expedition(BUILD, 21)
	_play(c, run, 1)
	_expect("um item chegou ao inventário no meio da run", c.inventory.items.size() >= 1 and run.state != "won" and run.state != "lost")
	var on_disk := SliceSave.read(PATH)
	_expect("o item já está no arquivo antes da run acabar", on_disk["ok"] and on_disk["data"]["inventory"]["items"].size() >= 1)
	_play(c, run)
	var summary := c.finish_expedition(run)
	var again := SliceCampaign.open(PATH)
	_expect("reabrir preserva inventário e materiais", again.inventory.items.size() == c.inventory.items.size() and again.inventory.materials == c.inventory.materials)
	_expect("XP foi somado ao save", again.data["party"]["xp"] > 0 or again.data["party"]["level"] > 1)
	_expect("resultado marca vitória apenas se venceu", summary["won"] == (run.state == "won") and again.data["boss_cleared"] == summary["won"])

func _test_lock_and_equipment() -> void:
	print("\n>>> 2. TRAVA E EQUIPAMENTO NA RUN")
	var c := SliceCampaign.open(PATH)
	var uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Raro", 20, 5))
	_expect("equipar fora da run funciona", c.equip("hero_001", uid) == "")
	var run := c.start_expedition(BUILD, 5)
	_expect("expedição trava o inventário", c.inventory.locked and c.equip("hero_001", uid) == "locked")
	_expect("o run usa o equipamento do save", run != null)
	c.finish_expedition(run)
	_expect("terminar destrava", not c.inventory.locked)
	var fresh := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 5, 1))
	var res := c.recycle(fresh)
	_expect("reciclar via campanha rende Resíduo e grava", res["ok"] and SliceSave.read(PATH)["data"]["inventory"]["materials"]["MAT_C1_LUMEN_RESIDUE"] >= 1)

func _test_blocked_save() -> void:
	print("\n>>> 3. SAVE BLOQUEADO")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string('{"version": 999}')
	file.close()
	var c := SliceCampaign.open(PATH)
	_expect("versão desconhecida bloqueia a gravação", c.save_blocked and c.save_error == "version")
	c.data["party"]["level"] = 12
	var run := c.start_expedition(BUILD, 3)
	_play(c, run, 1)
	var check := FileAccess.open(PATH, FileAccess.READ)
	_expect("o arquivo desconhecido não é sobrescrito", check.get_as_text() == '{"version": 999}')
	_expect("o jogo segue em memória", c.inventory.items.size() >= 1)
```

- [ ] **Passo 2: criar a cena, importar, rodar e ver falhar.**

- [ ] **Passo 3: implementar `scripts/run/SliceCampaign.gd`**

```gdscript
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

static func open(path: String) -> SliceCampaign:
	var c := SliceCampaign.new()
	c.save_path = path
	c._tables = LootRoller.load_tables()
	c._rows = SliceStats.load_rows("res://data/items/items.json", "slice")
	c._profiles = SliceStats.load_profiles()
	var res := SliceSave.read(path)
	if res["ok"]:
		c.data = res["data"]
	else:
		c.data = SliceSave.default_data()
		c.save_blocked = true
		c.save_error = String(res["error"])
	c.inventory = SliceInventory.from_dict(c.data.get("inventory", {}), c._rows, c._tables["recycle"])
	return c

func _save() -> void:
	if save_blocked:
		return
	data["inventory"] = inventory.to_dict()
	SliceSave.write(save_path, data)

func start_expedition(build: Dictionary, seed_value: int) -> ExpeditionRun:
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
		"telemetry": telemetry != null,
	}
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
	for ev in events:
		match String(ev["type"]):
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

func recycle(uid: int) -> Dictionary:
	var inst := inventory.find(uid)
	var res := inventory.recycle(uid)
	if res["ok"]:
		_save()
		if telemetry != null:
			telemetry.record_recycle(String(inst["rarity"]), int(res["residue"]))
	return res
```

Nota: `record_recycle` é criado na Tarefa 7. Para a Tarefa 6 passar antes dela, o teste não liga `telemetry`, então a chamada nunca executa; ainda assim o código só compila com o método existente **no momento da chamada** (GDScript resolve em runtime para `SliceTelemetry` tipado como propriedade `SliceTelemetry`). Se o parser reclamar, faça a Tarefa 7 primeiro.

- [ ] **Passo 4: importar, rodar a cena e a suíte.** Esperado: PASS.

---

## Tarefa 7: Telemetria de eventos, ofertas, loot e reciclagem

**Arquivos:**
- Modificar: `scripts/combat/SliceTelemetry.gd`
- Modificar: `tests/unit/test_slice_telemetry.gd` (casos novos)

**Interfaces:**
- Consome: eventos da Tarefa 4 (`event_offered`, `event_resolved`, `reward_offered`, `reward_chosen`, `loot_dropped`, `material_dropped`).
- Produz: no `summary()`, novo campo `run_layer` = `{"events_offered": {id: n}, "events_resolved": {"id:choice": n}, "rewards_offered": n, "rewards_chosen": {rarity: n}, "loot_by_rarity": {rarity: n}, "materials": {id: n}, "recycled": {rarity: n}, "residue_from_recycling": n}` e o método `record_recycle(rarity: String, residue: int) -> void`.

- [ ] **Passo 1: acrescentar ao teste** (no fim de `_ready`, antes do `print("====...")`, chame `_test_run_layer()`; adicione a função)

```gdscript
func _test_run_layer() -> void:
	print("\n>>> 4. CAMADA DA RUN (1B)")
	var t := SliceTelemetry.new()
	t.ingest([
		{"type": "event_offered", "time": 1.0, "id": "event_c1_001", "options": ["Curar", "Sacrificar"]},
		{"type": "event_resolved", "time": 1.0, "id": "event_c1_001", "choice": "heal", "effects": 1},
		{"type": "reward_offered", "time": 2.0, "id": "reward_x", "options": []},
		{"type": "reward_chosen", "time": 2.0, "id": "reward_x", "item": {"id": "item_w_001", "rarity": "Raro"}},
		{"type": "loot_dropped", "time": 2.0, "item": {"id": "item_w_001", "rarity": "Raro"}},
		{"type": "loot_dropped", "time": 3.0, "item": {"id": "item_a_001", "rarity": "Comum"}},
		{"type": "material_dropped", "time": 3.0, "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 2},
	])
	t.record_recycle("Comum", 1)
	var layer: Dictionary = t.summary()["run_layer"]
	_expect("evento oferecido e resolvido contados", layer["events_offered"]["event_c1_001"] == 1 and layer["events_resolved"]["event_c1_001:heal"] == 1)
	_expect("ofertas e escolhas de recompensa", layer["rewards_offered"] == 1 and layer["rewards_chosen"]["Raro"] == 1)
	_expect("loot por raridade e materiais", layer["loot_by_rarity"]["Raro"] == 1 and layer["loot_by_rarity"]["Comum"] == 1 and layer["materials"]["MAT_C1_LUMEN_RESIDUE"] == 2)
	_expect("reciclagem registrada", layer["recycled"]["Comum"] == 1 and layer["residue_from_recycling"] == 1)
```

- [ ] **Passo 2: rodar o teste e ver falhar** (`run_layer` inexistente).

- [ ] **Passo 3: implementar** — em `SliceTelemetry.gd`:

Junto das outras variáveis de estado:

```gdscript
var run_layer: Dictionary = {"events_offered": {}, "events_resolved": {}, "rewards_offered": 0, "rewards_chosen": {}, "loot_by_rarity": {}, "materials": {}, "recycled": {}, "residue_from_recycling": 0}

func _bump(dict: Dictionary, key: String, amount: int = 1) -> void:
	dict[key] = int(dict.get(key, 0)) + amount

func record_recycle(rarity: String, residue: int) -> void:
	_bump(run_layer["recycled"], rarity)
	run_layer["residue_from_recycling"] += residue
```

Novos casos no `match` de `_apply` (antes do fim do `match`):

```gdscript
		"event_offered":
			_bump(run_layer["events_offered"], String(ev["id"]))
		"event_resolved":
			_bump(run_layer["events_resolved"], "%s:%s" % [ev["id"], ev["choice"]])
		"reward_offered":
			run_layer["rewards_offered"] += 1
		"reward_chosen":
			_bump(run_layer["rewards_chosen"], String(ev["item"]["rarity"]))
		"loot_dropped":
			_bump(run_layer["loot_by_rarity"], String(ev["item"]["rarity"]))
		"material_dropped":
			_bump(run_layer["materials"], String(ev["id"]), int(ev["quantity"]))
```

E no `summary()` acrescente `"run_layer": run_layer.duplicate(true),`.

- [ ] **Passo 4: rodar `TestSliceTelemetry`, `TestSliceCampaign` e a suíte.** Esperado: PASS.

---

## Tarefa 8: Sincronizar documentação e fechar o checkpoint

**Arquivos:**
- Modificar: `docs/03_systems/SLICE_1B_RUN_SPEC.md`, `ROADMAP.md`, `CHANGELOG.md`, `docs/03_systems/INDEX.md`, `docs/CONTENT_REGISTRY.md`, `docs/08_qa/INDEX.md` (se listar testes), `AGENTS.md` (apenas se o mapa de `/scripts/` precisar citar `scripts/run/`)

- [ ] **Passo 1: corrigir a contagem de transições na spec.** Na seção 3, o texto diz "cerca de 5 por run". Na rota real há **4** transições entre encontros comuns (1→2, 2→3, 3→4, 4→5). Ajuste "~5 por run" para "~4 por run" e recalcule: secreto ~1% × 4 ≈ 4% por run; evento 25% × 4 ≈ 1,0 por run. Em `spec` e nesta tabela mantenha "HIPÓTESE".

- [ ] **Passo 2: registrar o estado no ROADMAP.** Na linha `1B — Run`, troque o estado para `IMPLEMENTING` e liste: núcleo entregue (loot, inventário, eventos, escolha no run, save, campanha, telemetria); pendentes: tela de inventário e fluxo (`Plano B`), cenários do Argos, texto de lore dos eventos. Atualize a contagem de cenas PASS da seção 1.

- [ ] **Passo 3: CHANGELOG.** Nova entrada `2026-09-29 — 1B núcleo` com os arquivos novos e o resultado da suíte.

- [ ] **Passo 4: índices.** `docs/03_systems/INDEX.md` (linha do `1B` passa a citar os testes novos), `docs/CONTENT_REGISTRY.md` (`data/expedition/events_c1.json` e `data/loot/drops_c1.json` como catálogos runtime; IDs `event_c1_*` em minúsculas com `design_id: null` exceto `EVENT_C1_001`), e o `AGENTS.md` só se o mapa citar `/scripts/` (acrescente "`scripts/run/`: loot, inventário, eventos, save do slice").

- [ ] **Passo 5: verificação final**

Run:
```bash
python tools/godot_import.py
python tools/run_godot_tests.py
python tools/argos/run.py --scenario slice_quick
python scripts/art/audit_docs_links.py
```
Esperado: 18/18 cenas PASS (as 12 atuais, incluindo `TestSliceTelemetry` com os casos novos, mais `TestLootRoller`, `TestSliceInventory`, `TestEventDirector`, `TestExpeditionChoices`, `TestSliceSave` e `TestSliceCampaign`), Argos com 0 BUG e 0 links quebrados. Apague só o relatório do Argos gerado por você agora.

- [ ] **Passo 6: checkpoint.** Não faça commit. Relate a Rafael: arquivos criados/alterados, resultado da suíte e do Argos, e as hipóteses que ficaram só no JSON. Proponha o Plano B (tela de inventário/equipar/reciclar, fluxo no `SliceProbe`, cenários do Argos para loot e eventos).

---

## Autorrevisão (feita ao escrever)

**Cobertura da spec:** seção 2 (unidades) → Tarefas 1–6; seção 3 (framework, vocabulário, 10 eventos, sorteio, valores) → Tarefa 3 e 4; seção 4 (drop comum, Reward Choice, boss, sem Echo) → Tarefas 1 e 4; seção 5 (equipar/trocar/reciclar, sem venda) → Tarefa 2; seção 6 (save) → Tarefa 5; seção 7 (testes 1–6) → testes de cada tarefa; item 7 da spec (Argos com loot/eventos) e a tela de inventário → **Plano B**, declarado no início. Telemetria de eventos/ofertas/reciclagem → Tarefa 7.

**Lacunas conhecidas e assumidas:** texto de lore dos eventos (só `text_id`; EM ABERTO na spec); a tela; cenários do Argos; "Memória do Guardião" e Echo continuam fora.

**Consistência de nomes:** `LootRoller.make_instance/roll_enemy_drop/roll_choice/roll_event_choice/roll_event_item/roll_boss`, `SliceInventory.add_item/equip/unequip/recycle/equipment_for_run/to_dict/from_dict`, `EventDirector.create/roll_transition/choices_for/resolve/mark_seen/event_by_id/is_eligible/validate`, `ExpeditionRun.pending/rewards/choose`, `SliceSave.read/write/add_xp/default_data`, `SliceCampaign.open/start_expedition/step/choose/finish_expedition/equip/unequip/recycle` e `SliceTelemetry.record_recycle/run_layer` foram usados com a mesma assinatura em todas as tarefas.
