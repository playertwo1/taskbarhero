# SLICE-1B Tela, textos e Argos — Plano de implementação (Plano B)

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans para executar tarefa por tarefa. Os passos usam checkbox (`- [ ]`).

**Meta:** tornar o núcleo do `1B` jogável e medível: textos de lore dos eventos no jogo, log legível, tela de inventário/equipar/reciclar, fluxo `Título → Campanha → Expedição → Resultado`, e cenários do Argos que usam o loot e os eventos reais.

**Arquitetura:** lógica de apresentação **pura** (`EventTexts`, `SliceLogText`) testada sem cena; telas finas (`SliceInventoryPanel`, `SliceCampaignScreen`) montadas em código (como o `SliceProbe`) que só chamam o núcleo (`SliceCampaign`, `ExpeditionRun.choose`); o Argos passa a rodar a campanha pelo mesmo `SliceCampaign` (em memória), em vez do modelo simplificado de loot.

**Tecnologias:** Godot 4.7.2 (GDScript), JSON em `/data`, Python 3 (Argos Analyst), cenas de teste headless em `tests/unit/`.

**Spec:** [`docs/03_systems/SLICE_1B_RUN_SPEC.md`](../../03_systems/SLICE_1B_RUN_SPEC.md). **Pré-requisito:** Plano A executado ([núcleo](2026-09-29-slice-1b-nucleo.md); 19/19 cenas PASS). **Textos:** [`data/expedition/event_texts_c1.json`](../../../data/expedition/event_texts_c1.json) (já escritos a partir da [lore canônica](../../01_world/loreparte1.md) e da [Bíblia de Lore](../../01_world/LORE_BIBLE.md); vista legível em [EVENT_TEXTS.md](../../04_content/chapters/chapter_01/EVENT_TEXTS.md)).

## Restrições globais

- **Sem commit nem push** (AGENTS.md). Cada tarefa termina num checkpoint com testes verdes; relate e pare.
- Preserve arquivos não rastreados e alterações que não são suas; nunca apague nada em `tools/argos/reports/` além do relatório que você mesmo gerou.
- GDScript com **tabs**; comentários e textos em português. Depois de criar `class_name` novo: `python tools/godot_import.py`. Para uma cena de teste: `python tools/run_one_scene.py tests/unit/TestNome.tscn`.
- Textos de lore: **fonte única é `event_texts_c1.json`**. `EVENT_TEXTS.md` é derivado por `python tools/content/export_event_texts.py`; nunca edite o `.md` à mão e regenere-o após qualquer mudança nos textos.
- Não responder mistérios da Bíblia de Lore (Observador, causa do Apagamento, destino do Lúmen); não revelar o nome do Bastião nem quem ele protegia. Qualquer mudança de texto passa por Rafael.
- `ExpeditionRun` sem `loot`/`events` continua idêntico ao comportamento anterior.
- Mobile portrait 432×960: telas com margens de 18 px, botões com altura mínima 50 px, sem depender de mouse.
- O Hub visual, o Ferreiro, a Árvore e o Echo **não** entram (`1D`).

## Mapa de arquivos

| Arquivo | Ação | Responsabilidade |
| --- | --- | --- |
| `scripts/combat/ExpeditionRun.gd` | modificar | `run_to_end` com política de escolha; `outcome` em `event_resolved` |
| `scripts/run/EventDirector.gd` | modificar | `last_outcome` |
| `data/expedition/events_c1.json` | (já tem `id` nos resultados da Raiz Oca) | — |
| `scripts/run/EventTexts.gd` | criar | Carrega e valida textos; consulta por evento/escolha/resultado/lore |
| `scripts/run/SliceLogText.gd` | criar | Eventos do run → linhas em português |
| `scripts/run/SliceInventory.gd` | modificar | `auto_equip` |
| `scripts/run/SliceCampaign.gd` | modificar | `in_memory()`, `start_expedition(..., extra_options)`, `auto_equip` |
| `scripts/combat/SliceSession.gd` | modificar | `BUILD_PRESETS` compartilhado |
| `scripts/combat/SliceProbe.gd` | modificar | usa `SliceSession.BUILD_PRESETS` |
| `scripts/ui/SliceInventoryPanel.gd` | criar | Lista, equipar/desequipar, reciclar |
| `scripts/ui/SliceCampaignScreen.gd` + `scenes/slice/SliceCampaign.tscn` | criar | Fluxo Preparação → Expedição → Resultado |
| `scripts/ui/TitleScreen.gd` | modificar | Título abre a campanha |
| `tools/argos/simulator/combat/argos_sim.gd` | modificar | Campanha com `run_layer` (loot e eventos reais, políticas) |
| `tools/argos/simulator/combat/scenarios/slice_run_layer.json` | criar | Cenário com variantes do Poço e eventos frequentes |
| `tools/argos/analyzer/analyze.py` + `test_analyze.py` | modificar | Tabela de eventos e loot da run |
| docs (spec, roadmap, changelog, índices, AGENTS/README) | modificar | Sincronizar |

## Modelo de teste

Igual ao Plano A: `tests/unit/test_<nome>.gd` (`extends Node`, `_expect`, `get_tree().quit(0|1)`) + cena `Test<Nome>.tscn`:

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/unit/test_NOME.gd" id="1_test"]

[node name="TestNOME" type="Node"]
script = ExtResource("1_test")
```

Esqueleto do `.gd`:

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false
```

---

## Tarefa 1: `run_to_end` com política de escolha e `outcome` nos eventos

**Por quê:** hoje `ExpeditionRun.run_to_end` entra em laço infinito se o run tiver `loot`/`events` e parar em `choice` (o tempo não avança). O Argos precisa de uma política de escolha, e a tela precisa saber *qual* resultado da Raiz Oca aconteceu para mostrar o texto certo.

**Arquivos:**
- Modificar: `scripts/combat/ExpeditionRun.gd` (`run_to_end`, `_resolve_event_choice`), `scripts/run/EventDirector.gd` (`resolve`)
- Teste: `tests/unit/test_run_choice_policy.gd`, `tests/unit/TestRunChoicePolicy.tscn`

**Interfaces:**
- Produz:
  - `ExpeditionRun.run_to_end(dt: float = 0.25, max_time: float = 3600.0, chooser: Callable = Callable()) -> Array` (com `chooser` válido, chama `chooser.call(pending) -> int` a cada `choice`; sem `chooser`, escolhe o índice 0)
  - `EventDirector.last_outcome: String` (id do resultado sorteado na última `resolve`; `""` se a escolha não tem `outcomes`)
  - evento `event_resolved` ganha o campo `outcome: String`

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true
const BUILD := {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}
const LEVEL := 12

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE RUN CHOICE POLICY (SLICE-1B Plano B) ---")
	var tables := LootRoller.load_tables()
	var items := SliceStats.load_rows("res://data/items/items.json", "slice")
	var catalog := EventDirector.load_catalog()

	# 1. Sem chooser: não trava e termina; o padrão escolhe a opção 0.
	var run := SliceSession.create_run(BUILD, LEVEL, 21, {"loot": LootRoller.create(tables, items, 21), "events": EventDirector.create(catalog, 21)})
	var events := run.run_to_end(0.5)
	_expect("run com loot/eventos termina sem chooser", run.state == "won" or run.state == "lost")
	var poco_choice := ""
	for ev in events:
		if ev["type"] == "event_resolved" and ev["id"] == "event_c1_001":
			poco_choice = String(ev["choice"])
	_expect("o padrão escolhe a opção 0 (curar)", poco_choice == "" or poco_choice == "heal")

	# 2. Com chooser: sempre a última opção (sacrificar no Poço).
	var run2 := SliceSession.create_run(BUILD, LEVEL, 21, {"loot": LootRoller.create(tables, items, 21), "events": EventDirector.create(catalog, 21)})
	var events2 := run2.run_to_end(0.5, 3600.0, func(pending): return pending["options"].size() - 1)
	var sacrificed := false
	for ev in events2:
		if ev["type"] == "event_resolved" and ev["id"] == "event_c1_001":
			sacrificed = ev["choice"] == "sacrifice"
	_expect("o chooser é respeitado (Poço: sacrificar)", sacrificed or run2.state == "lost")

	# 3. outcome: catálogo só com a Raiz Oca e chance 1.0; escolher "Abrir a raiz" (índice 0).
	var raiz: Dictionary = {}
	for e in catalog["events"]:
		if e["id"] == "event_c1_raiz_oca":
			raiz = e
	var forced := {"random_rules": {"transition_chance": 1.0, "secret_chance": 0.0, "max_random_per_run": 4}, "events": [raiz]}
	var seen := {}
	for seed_value in range(1, 40):
		var r := SliceSession.create_run(BUILD, LEVEL, seed_value, {"loot": LootRoller.create(tables, items, seed_value), "events": EventDirector.create(forced, seed_value)})
		for ev in r.run_to_end(0.5):
			if ev["type"] == "event_resolved" and ev["id"] == "event_c1_raiz_oca":
				seen[String(ev["outcome"])] = true
	_expect("event_resolved traz o outcome da Raiz Oca", seen.has("nothing") or seen.has("spines") or seen.has("cache"))
	_expect("os outcomes são só os declarados", seen.keys().all(func(k): return ["spines", "cache", "nothing"].has(k)))
	var plain := SliceSession.create_run(BUILD, LEVEL, 21, {"loot": LootRoller.create(tables, items, 21), "events": EventDirector.create(catalog, 21)})
	var resolved_outcomes := plain.run_to_end(0.5).filter(func(ev): return ev["type"] == "event_resolved" and ev["id"] == "event_c1_001")
	_expect("escolha sem outcomes devolve outcome vazio", resolved_outcomes.all(func(ev): return ev["outcome"] == ""))

	print("=======================================================")
	print("[%s] TESTE RUN CHOICE POLICY" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
```

- [ ] **Passo 2: criar a cena `TestRunChoicePolicy.tscn`, rodar e ver falhar** (`python tools/run_one_scene.py tests/unit/TestRunChoicePolicy.tscn`). Esperado: TIMEOUT (laço infinito em `choice`) ou erro de chave `outcome`.

- [ ] **Passo 3: implementar**

Em `EventDirector.gd`, junto de `var _random_count`:

```gdscript
## Id do resultado sorteado na última resolve() ("" quando a escolha não tem `outcomes`).
var last_outcome: String = ""
```

Substitua o corpo de `resolve` por:

```gdscript
func resolve(choice: Dictionary) -> Array:
	last_outcome = ""
	if not choice.has("outcomes"):
		return choice.get("effects", []).duplicate(true)
	var total := 0.0
	for outcome in choice["outcomes"]:
		total += float(outcome["weight"])
	var roll := _rng.randf() * total
	var acc := 0.0
	var picked: Dictionary = choice["outcomes"][choice["outcomes"].size() - 1]
	for outcome in choice["outcomes"]:
		acc += float(outcome["weight"])
		if roll < acc:
			picked = outcome
			break
	last_outcome = String(picked.get("id", ""))
	return picked.get("effects", []).duplicate(true)
```

Em `ExpeditionRun.gd`, substitua `run_to_end`:

```gdscript
## Roda até o fim (vitória ou derrota) ou até max_time e devolve todos os eventos.
## Em `choice`, usa chooser.call(pending) -> int (ou a opção 0 sem chooser); sem isso o laço nunca avançaria.
func run_to_end(dt: float = 0.25, max_time: float = 3600.0, chooser: Callable = Callable()) -> Array:
	var all: Array = []
	while state != "won" and state != "lost" and time < max_time:
		if state == "choice":
			var index := int(chooser.call(pending)) if chooser.is_valid() else 0
			all.append_array(choose(index))
		else:
			all.append_array(step(dt))
	return all
```

E em `_resolve_event_choice`, troque a linha do `event_resolved` por:

```gdscript
	events.append({"type": "event_resolved", "time": time, "id": offer["id"], "choice": choice["id"], "effects": effects.size(), "outcome": director.last_outcome})
```

(`director.resolve` já foi chamado na linha anterior; `last_outcome` está atualizado.)

- [ ] **Passo 4: importar e rodar** `TestRunChoicePolicy`, `TestExpeditionChoices` e a suíte (`python tools/run_godot_tests.py`). Esperado: PASS; nenhuma cena anterior muda.

---

## Tarefa 2: `EventTexts` (carregar, consultar e validar os textos)

**Arquivos:**
- Criar: `scripts/run/EventTexts.gd`
- Teste: `tests/unit/test_event_texts.gd`, `tests/unit/TestEventTexts.tscn`

**Interfaces:**
- Consome: `data/expedition/event_texts_c1.json`, `data/expedition/events_c1.json`.
- Produz (Tarefas 3, 6):
  - `EventTexts.load_texts() -> Dictionary`
  - `EventTexts.validate(texts: Dictionary, catalog: Dictionary, hero_ids: Array = ["hero_001", "hero_002", "hero_003"]) -> Array` (erros; vazia = válido)
  - `EventTexts.create(texts: Dictionary) -> EventTexts`
  - `intro(event_id: String) -> String`, `choice_text(event_id: String, choice_id: String) -> String`, `outcome_text(event_id: String, outcome_id: String) -> String`, `lore(text_id: String) -> String` (todos devolvem `""` se ausente)

Validação: todo evento do catálogo tem `intro`; toda escolha (com `per_hero` expandida para `hero_ids`) tem texto; todo `outcome` tem texto; todo `reveal_lore` (com `{hero}` expandido) existe em `lore`; limites de frases (intro e lore ≤ 4, escolha e resultado ≤ 2, contando `.`, `!` e `?`); nenhum texto vazio.

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE EVENT TEXTS (SLICE-1B Plano B) ---")
	var texts := EventTexts.load_texts()
	var catalog := EventDirector.load_catalog()
	var errors := EventTexts.validate(texts, catalog)
	for e in errors:
		print("  erro: %s" % e)
	_expect("textos cobrem todo o catálogo e respeitam os limites", errors.is_empty())

	var t := EventTexts.create(texts)
	_expect("intro do Poço existe", t.intro("event_c1_001") != "")
	_expect("resultado da escolha existe", t.choice_text("event_c1_001", "heal") != "")
	_expect("resultado do Memorial por herói existe", t.choice_text("event_c1_memorial", "honor_hero_002") != "")
	_expect("resultado da Raiz Oca existe", t.outcome_text("event_c1_raiz_oca", "cache") != "")
	_expect("lore do Observador existe", t.lore("LORE_EVT_OBSERVADOR") != "")
	_expect("consulta ausente devolve vazio", t.intro("nao_existe") == "" and t.lore("X") == "")

	var broken := texts.duplicate(true)
	broken["events"].erase("event_c1_raiz_oca")
	_expect("validação acusa evento sem texto", not EventTexts.validate(broken, catalog).is_empty())
	var long := texts.duplicate(true)
	long["events"]["event_c1_001"]["choices"]["heal"] = "Uma. Duas. Três."
	_expect("validação acusa resultado com frases demais", not EventTexts.validate(long, catalog).is_empty())
	var missing_lore := texts.duplicate(true)
	missing_lore["lore"].erase("LORE_EVT_OBSERVADOR")
	_expect("validação acusa lore ausente", not EventTexts.validate(missing_lore, catalog).is_empty())

	print("=======================================================")
	print("[%s] TESTE EVENT TEXTS" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
```

- [ ] **Passo 2: criar a cena, importar, rodar e ver falhar** (tipo `EventTexts` desconhecido).

- [ ] **Passo 3: implementar `scripts/run/EventTexts.gd`**

```gdscript
extends RefCounted
class_name EventTexts

## Textos dos eventos do slice (SLICE-1B). Fonte: data/expedition/event_texts_c1.json.
## Só consulta e validação; nada de regra de jogo aqui.

const TEXTS_PATH := "res://data/expedition/event_texts_c1.json"
const MAX_SENTENCES := {"intro": 4, "lore": 4, "choice": 2, "outcome": 2}

var _texts: Dictionary = {}

static func load_texts() -> Dictionary:
	var file := FileAccess.open(TEXTS_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

static func create(texts: Dictionary) -> EventTexts:
	var t := EventTexts.new()
	t._texts = texts
	return t

func intro(event_id: String) -> String:
	return String(_texts.get("events", {}).get(event_id, {}).get("intro", ""))

func choice_text(event_id: String, choice_id: String) -> String:
	return String(_texts.get("events", {}).get(event_id, {}).get("choices", {}).get(choice_id, ""))

func outcome_text(event_id: String, outcome_id: String) -> String:
	return String(_texts.get("events", {}).get(event_id, {}).get("outcomes", {}).get(outcome_id, ""))

func lore(text_id: String) -> String:
	return String(_texts.get("lore", {}).get(text_id, ""))

static func _sentences(text: String) -> int:
	var n := 0
	for c in text:
		if c == "." or c == "!" or c == "?":
			n += 1
	return n

static func _check(errors: Array, label: String, text: String, kind: String) -> void:
	if text.strip_edges() == "":
		errors.append("%s: texto vazio" % label)
	elif _sentences(text) > int(MAX_SENTENCES[kind]):
		errors.append("%s: mais de %d frases" % [label, MAX_SENTENCES[kind]])

## Lista de erros; vazia quando os textos cobrem o catálogo e respeitam os limites.
static func validate(texts: Dictionary, catalog: Dictionary, hero_ids: Array = ["hero_001", "hero_002", "hero_003"]) -> Array:
	var errors: Array = []
	var events: Dictionary = texts.get("events", {})
	var lore_texts: Dictionary = texts.get("lore", {})
	for event in catalog.get("events", []):
		var id := String(event["id"])
		if not events.has(id):
			errors.append("%s: sem textos" % id)
			continue
		_check(errors, "%s.intro" % id, String(events[id].get("intro", "")), "intro")
		for choice in event["choices"]:
			var choice_ids: Array = []
			if bool(choice.get("per_hero", false)):
				for hero_id in hero_ids:
					choice_ids.append("%s_%s" % [choice["id"], hero_id])
			else:
				choice_ids.append(String(choice["id"]))
			for cid in choice_ids:
				_check(errors, "%s.choices.%s" % [id, cid], String(events[id].get("choices", {}).get(cid, "")), "choice")
			for outcome in choice.get("outcomes", []):
				_check(errors, "%s.outcomes.%s" % [id, outcome["id"]], String(events[id].get("outcomes", {}).get(outcome["id"], "")), "outcome")
			var groups: Array = []
			if choice.has("outcomes"):
				for outcome in choice["outcomes"]:
					groups.append(outcome.get("effects", []))
			else:
				groups.append(choice.get("effects", []))
			for effects in groups:
				for fx in effects:
					if String(fx["type"]) != "reveal_lore":
						continue
					var text_ids: Array = []
					if String(fx["text_id"]).contains("{hero}"):
						for hero_id in hero_ids:
							text_ids.append(String(fx["text_id"]).replace("{hero}", hero_id))
					else:
						text_ids.append(String(fx["text_id"]))
					for tid in text_ids:
						if not lore_texts.has(tid):
							errors.append("%s: lore ausente %s" % [id, tid])
	for tid in lore_texts:
		_check(errors, "lore.%s" % tid, String(lore_texts[tid]), "lore")
	return errors
```

- [ ] **Passo 4: importar e rodar** `TestEventTexts`. Se acusar erros nos textos de Rafael (frases demais), **não afrouxe o limite**: relate qual texto excedeu e proponha a edição no `event_texts_c1.json`.

---

## Tarefa 3: `SliceLogText` (eventos do run → linhas em português)

**Arquivos:**
- Criar: `scripts/run/SliceLogText.gd`
- Teste: `tests/unit/test_slice_log_text.gd`, `tests/unit/TestSliceLogText.tscn`

**Interfaces:**
- Consome: `EventTexts` (Tarefa 2), eventos do `ExpeditionRun` (Plano A e Tarefa 1).
- Produz (Tarefa 6):
  - `SliceLogText.item_label(inst: Dictionary, rows: Dictionary) -> String` (`"Nome (Raridade, IP n)"`; `rows` é `id → linha`)
  - `SliceLogText.line(ev: Dictionary, ctx: Dictionary) -> String` (`""` para eventos sem linha). `ctx`: `node_names: Dictionary`, `hero_names: Dictionary`, `item_rows: Dictionary`, `texts: EventTexts`.

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE LOG TEXT (SLICE-1B Plano B) ---")
	var rows := {}
	for r in SliceStats.load_rows("res://data/items/items.json", "slice"):
		rows[r["id"]] = r
	var ctx := {
		"node_names": {"c1_1_1_a": "Primeira luz"},
		"hero_names": {"hero_001": "Bastião"},
		"item_rows": rows,
		"texts": EventTexts.create(EventTexts.load_texts()),
	}
	var inst := LootRoller.make_instance("item_w_001", "Raro", 17, 3)
	_expect("rótulo de item", SliceLogText.item_label(inst, rows).contains("Raro") and SliceLogText.item_label(inst, rows).contains("IP 17"))
	_expect("encontro iniciado usa o nome", SliceLogText.line({"type": "encounter_started", "node_id": "c1_1_1_a"}, ctx).contains("Primeira luz"))
	_expect("vitória mostra a duração", SliceLogText.line({"type": "encounter_cleared", "duration": 12.34}, ctx).contains("12.3"))
	_expect("herói caído usa o nome", SliceLogText.line({"type": "hero_defeated", "id": "hero_001"}, ctx).contains("Bastião"))
	_expect("loot vira linha de item", SliceLogText.line({"type": "loot_dropped", "item": inst}, ctx).contains("Item"))
	_expect("Resíduo mostra a quantidade", SliceLogText.line({"type": "material_dropped", "id": "MAT_C1_LUMEN_RESIDUE", "quantity": 2}, ctx).contains("2"))
	_expect("evento oferecido mostra a intro do texto", SliceLogText.line({"type": "event_offered", "id": "event_c1_001"}, ctx) == ctx["texts"].intro("event_c1_001"))
	var resolved := SliceLogText.line({"type": "event_resolved", "id": "event_c1_raiz_oca", "choice": "open", "outcome": "cache"}, ctx)
	_expect("evento resolvido junta escolha e resultado", resolved.contains(ctx["texts"].choice_text("event_c1_raiz_oca", "open")) and resolved.contains(ctx["texts"].outcome_text("event_c1_raiz_oca", "cache")))
	_expect("lore revelada mostra o texto", SliceLogText.line({"type": "lore_revealed", "text_id": "LORE_EVT_OBSERVADOR"}, ctx) == ctx["texts"].lore("LORE_EVT_OBSERVADOR"))
	_expect("dano de evento mostra o herói", SliceLogText.line({"type": "event_damage", "target": "hero_001", "amount": 20.0}, ctx).contains("Bastião"))
	_expect("dano zero não gera linha", SliceLogText.line({"type": "event_damage", "target": "hero_001", "amount": 0.0}, ctx) == "")
	_expect("evento sem linha devolve vazio", SliceLogText.line({"type": "skill_cast"}, ctx) == "")
	_expect("vitória e derrota da expedição", SliceLogText.line({"type": "expedition_won"}, ctx) != "" and SliceLogText.line({"type": "expedition_lost", "node_id": "c1_1_1_a"}, ctx).contains("Primeira luz"))

	print("=======================================================")
	print("[%s] TESTE SLICE LOG TEXT" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
```

- [ ] **Passo 2: cena, importar, rodar e ver falhar.**

- [ ] **Passo 3: implementar `scripts/run/SliceLogText.gd`**

```gdscript
extends RefCounted
class_name SliceLogText

## Converte eventos do ExpeditionRun em linhas de log em português (SLICE-1B Plano B).
## Só apresentação: não lê nem altera o estado do jogo.

const RESIDUE_NAME := "Resíduo de Lúmen"

static func item_label(inst: Dictionary, rows: Dictionary) -> String:
	var row: Dictionary = rows.get(inst["id"], {})
	return "%s (%s, IP %d)" % [row.get("name", inst["id"]), inst["rarity"], int(inst["item_power"])]

static func _hero(id: String, ctx: Dictionary) -> String:
	return String(ctx.get("hero_names", {}).get(id, id))

static func line(ev: Dictionary, ctx: Dictionary) -> String:
	var texts: EventTexts = ctx["texts"]
	match String(ev["type"]):
		"encounter_started":
			return "Encontro: %s" % ctx.get("node_names", {}).get(ev["node_id"], ev["node_id"])
		"encounter_cleared":
			return "Vitória em %.1f s." % float(ev["duration"])
		"hero_defeated":
			return "%s caiu." % _hero(String(ev["id"]), ctx)
		"loot_dropped":
			return "Item: %s" % item_label(ev["item"], ctx["item_rows"])
		"material_dropped":
			var name := RESIDUE_NAME if ev["id"] == "MAT_C1_LUMEN_RESIDUE" else String(ev["id"])
			return "%d× %s" % [int(ev["quantity"]), name]
		"event_offered":
			return texts.intro(String(ev["id"]))
		"event_resolved":
			var parts: Array = [texts.choice_text(String(ev["id"]), String(ev["choice"]))]
			if String(ev.get("outcome", "")) != "":
				parts.append(texts.outcome_text(String(ev["id"]), String(ev["outcome"])))
			return " ".join(parts.filter(func(p): return p != ""))
		"reward_offered":
			return "O Bosque oferece uma recompensa. Escolha uma."
		"reward_chosen":
			return "Escolhido: %s" % item_label(ev["item"], ctx["item_rows"])
		"lore_revealed":
			return texts.lore(String(ev["text_id"]))
		"event_damage":
			return "%s perdeu %.0f HP." % [_hero(String(ev["target"]), ctx), float(ev["amount"])] if float(ev["amount"]) > 0.0 else ""
		"recovery":
			return "%s recuperou %.0f HP." % [_hero(String(ev["target"]), ctx), float(ev["amount"])] if String(ev.get("source", "")) == "event" else ""
		"expedition_won":
			return "A expedição terminou em vitória."
		"expedition_lost":
			return "A party caiu em %s." % ctx.get("node_names", {}).get(ev["node_id"], ev["node_id"])
	return ""
```

- [ ] **Passo 4: importar, rodar `TestSliceLogText` e a suíte.** Esperado: PASS.

---

## Tarefa 4: API da campanha para a tela e o Argos (`auto_equip`, `in_memory`, opções extras)

**Arquivos:**
- Modificar: `scripts/run/SliceInventory.gd` (`auto_equip`), `scripts/run/SliceCampaign.gd` (`in_memory`, `start_expedition(..., extra_options)`, `auto_equip`)
- Modificar: `scripts/combat/SliceSession.gd` (`BUILD_PRESETS`), `scripts/combat/SliceProbe.gd` (usa o preset compartilhado)
- Teste: `tests/unit/test_slice_campaign_api.gd`, `tests/unit/TestSliceCampaignApi.tscn`

**Interfaces:**
- Produz (Tarefas 5, 6, 7):
  - `SliceInventory.auto_equip(hero_ids: Array) -> void` (maior raridade e depois maior `item_power` por herói e vaga; um item nunca vai para dois heróis; não faz nada se `locked`)
  - `SliceCampaign.in_memory() -> SliceCampaign` (`save_blocked = true`, `save_error = "memory"`, nunca toca o disco)
  - `SliceCampaign.start_expedition(build: Dictionary, seed_value: int, extra_options: Dictionary = {}) -> ExpeditionRun` (`extra_options` sobrescreve as opções padrão, exceto se omitido)
  - `SliceCampaign.auto_equip(hero_ids: Array) -> void` (chama o inventário e grava)
  - `SliceSession.BUILD_PRESETS: Array` (`[{name, heroes}]`, os 4 do `SliceProbe`)

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE CAMPAIGN API (SLICE-1B Plano B) ---")
	_test_presets()
	_test_in_memory()
	_test_auto_equip()
	_test_extra_options()
	print("=======================================================")
	print("[%s] TESTE SLICE CAMPAIGN API" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)

func _test_presets() -> void:
	print("\n>>> 1. PRESETS")
	_expect("4 presets com nome e trio", SliceSession.BUILD_PRESETS.size() == 4 and SliceSession.BUILD_PRESETS.all(func(p): return p.has("name") and p["heroes"].size() == 3))

func _test_in_memory() -> void:
	print("\n>>> 2. EM MEMÓRIA")
	var c := SliceCampaign.in_memory()
	_expect("não grava em disco", c.save_blocked and c.save_error == "memory")
	var uid := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 5, 1))
	_expect("equipar funciona sem arquivo", c.equip("hero_001", uid) == "")

func _test_auto_equip() -> void:
	print("\n>>> 3. AUTO EQUIPAR")
	var c := SliceCampaign.in_memory()
	var weak := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 30, 5))
	var strong := c.inventory.add_item(LootRoller.make_instance("item_w_003", "Raro", 5, 5))
	var armor_a := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 10, 5))
	var armor_b := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Comum", 20, 5))
	var shared_lo := c.inventory.add_item(LootRoller.make_instance("item_s_003", "Raro", 8, 5))
	c.auto_equip(["hero_001", "hero_002", "hero_003"])
	var b1: Array = c.inventory.equipped["hero_001"]
	_expect("maior raridade vence o IP maior (Raro em vez de Comum)", b1.has(strong) and not b1.has(weak))
	_expect("mesma raridade: maior IP", b1.has(armor_b) and not b1.has(armor_a))
	_expect("secundário compartilhado vai para um herói só", [c.inventory.equipped.get("hero_001", []), c.inventory.equipped.get("hero_002", []), c.inventory.equipped.get("hero_003", [])].filter(func(l): return l.has(shared_lo)).size() == 1)
	c.inventory.locked = true
	var before := c.inventory.equipped.duplicate(true)
	c.auto_equip(["hero_001"])
	_expect("travado não muda nada", c.inventory.equipped == before)

func _test_extra_options() -> void:
	print("\n>>> 4. OPÇÕES EXTRAS")
	var c := SliceCampaign.in_memory()
	c.data["party"]["level"] = 12
	var build: Dictionary = SliceSession.BUILD_PRESETS[2]["heroes"]
	var run := c.start_expedition(build, 5, {"crits": false})
	_expect("expedição criada e inventário travado", run != null and c.inventory.locked)
	var default_run := SliceCampaign.in_memory().start_expedition(build, 5)
	_expect("sem extras continua funcionando", default_run != null)
```

- [ ] **Passo 2: cena, rodar e ver falhar** (`BUILD_PRESETS` e `in_memory` inexistentes).

- [ ] **Passo 3: implementar**

`SliceSession.gd` (logo depois de `const TELEGRAPH_OVERRIDE`):

```gdscript
## Builds prontas para a tela e o teste (herói → chave de build; "_tele" liga o gatilho do golpe telegrafado).
const BUILD_PRESETS := [
	{"name": "Ofensivo", "heroes": {"hero_001": "retaliacao", "hero_002": "marca", "hero_003": "arcano"}},
	{"name": "Controle", "heroes": {"hero_001": "retaliacao_tele", "hero_002": "marca", "hero_003": "controle"}},
	{"name": "Guardião", "heroes": {"hero_001": "guardiao", "hero_002": "critico", "hero_003": "controle"}},
	{"name": "Cura", "heroes": {"hero_001": "retaliacao", "hero_002": "critico", "hero_003": "lumen"}},
]
```

`SliceProbe.gd`: troque a constante `BUILDS := [...]` por `const BUILDS := SliceSession.BUILD_PRESETS` (mesmo conteúdo, uma fonte).

`SliceInventory.gd`, novo método:

```gdscript
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
```

`SliceCampaign.gd`: substitua `open` e adicione `in_memory`/`auto_equip`, e `start_expedition` com opções extras:

```gdscript
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

func auto_equip(hero_ids: Array) -> void:
	inventory.auto_equip(hero_ids)
	_save()
```

e em `start_expedition` mude a assinatura e o final:

```gdscript
func start_expedition(build: Dictionary, seed_value: int, extra_options: Dictionary = {}) -> ExpeditionRun:
```
```gdscript
	extra.merge(extra_options, true)
	var run := SliceSession.create_run(build, int(data["party"]["level"]), seed_value, extra)
```
(a linha do `merge` vai imediatamente antes da criação do run; o resto da função fica como está).

- [ ] **Passo 4: importar e rodar** `TestSliceCampaignApi`, `TestSliceCampaign`, `TestSliceInventory` e a suíte. Esperado: PASS.

---

## Tarefa 5: `SliceInventoryPanel` (lista, equipar/desequipar, reciclar)

**Arquivos:**
- Criar: `scripts/ui/SliceInventoryPanel.gd`
- Teste: `tests/unit/test_slice_inventory_panel.gd`, `tests/unit/TestSliceInventoryPanel.tscn`

**Interfaces:**
- Consome: `SliceCampaign` (`inventory`, `equip`, `unequip`, `recycle`, `auto_equip`), `SliceLogText.item_label`.
- Produz (Tarefa 6):
  - `SliceInventoryPanel` (`extends Control`, `class_name SliceInventoryPanel`), sinal `changed`, sinal `closed`
  - `setup(campaign: SliceCampaign, hero_names: Dictionary) -> void`
  - `refresh() -> void`
  - `equip_item(uid: int, hero_id: String) -> String` (retorna o código de erro do inventário; `""` = ok), `unequip_item(uid: int) -> String`, `recycle_item(uid: int) -> Dictionary`, `auto_equip_all() -> void`
  - `row_count() -> int`, `summary_text() -> String` (Resíduo e nº de itens)

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _ready() -> void:
	print("--- TESTE SLICE INVENTORY PANEL (SLICE-1B Plano B) ---")
	var c := SliceCampaign.in_memory()
	var sword := c.inventory.add_item(LootRoller.make_instance("item_w_001", "Comum", 10, 3))
	var armor := c.inventory.add_item(LootRoller.make_instance("item_a_001", "Incomum", 12, 3))
	var relic := c.inventory.add_item(LootRoller.make_instance("item_a_005", "Relíquia", 25, 3))
	var panel := SliceInventoryPanel.new()
	add_child(panel)
	panel.setup(c, {"hero_001": "Bastião", "hero_002": "Flecha", "hero_003": "Íris"})
	_expect("uma linha por item", panel.row_count() == 3)
	_expect("resumo mostra itens e Resíduo", panel.summary_text().contains("3") and panel.summary_text().contains("Resíduo"))
	var changed := [0]
	panel.changed.connect(func(): changed[0] += 1)
	_expect("equipar item compatível", panel.equip_item(sword, "hero_001") == "")
	_expect("equipar em herói incompatível falha", panel.equip_item(sword, "hero_002") == "incompatible")
	_expect("reciclar equipado é recusado", panel.recycle_item(sword)["error"] == "equipped")
	_expect("reciclar Relíquia é recusado", panel.recycle_item(relic)["error"] == "not_recyclable")
	var res := panel.recycle_item(armor)
	_expect("reciclar Incomum rende 2 Resíduos", res["ok"] and res["residue"] == 2)
	_expect("a lista se atualiza depois de reciclar", panel.row_count() == 2)
	_expect("o sinal changed foi emitido", changed[0] >= 2)
	_expect("desequipar devolve o item", panel.unequip_item(sword) == "")
	c.inventory.locked = true
	_expect("com expedição em andamento a tela recusa", panel.equip_item(sword, "hero_001") == "locked")
	c.inventory.locked = false
	panel.auto_equip_all()
	_expect("equipar melhores usa o auto_equip", c.inventory.equipped.get("hero_001", []).has(sword))

	print("=======================================================")
	print("[%s] TESTE SLICE INVENTORY PANEL" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
```

- [ ] **Passo 2: cena, importar, rodar e ver falhar.**

- [ ] **Passo 3: implementar `scripts/ui/SliceInventoryPanel.gd`**

```gdscript
extends Control
class_name SliceInventoryPanel

## Inventário do slice (SLICE-1B Plano B): lista, equipar/desequipar e reciclar. Sem regra própria:
## tudo passa por SliceCampaign/SliceInventory. Montada em código, como o SliceProbe.

signal changed
signal closed

var campaign: SliceCampaign
var hero_names: Dictionary = {}
var _item_rows: Dictionary = {}
var _list: VBoxContainer
var _summary: Label
var _message: Label

func setup(new_campaign: SliceCampaign, names: Dictionary) -> void:
	campaign = new_campaign
	hero_names = names
	_item_rows = {}
	for row in SliceStats.load_rows("res://data/items/items.json", "slice"):
		_item_rows[row["id"]] = row
	_build()
	refresh()

func _build() -> void:
	for child in get_children():
		child.queue_free()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var background := ColorRect.new()
	background.color = Color(0.03, 0.04, 0.05, 0.96)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 18)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)
	var title := Label.new()
	title.text = "Inventário"
	title.add_theme_font_size_override("font_size", 23)
	column.add_child(title)
	_summary = Label.new()
	column.add_child(_summary)
	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_message)
	var best := Button.new()
	best.text = "Equipar os melhores"
	best.custom_minimum_size.y = 50
	best.pressed.connect(auto_equip_all)
	column.add_child(best)
	_list = VBoxContainer.new()
	_list.add_theme_constant_override("separation", 8)
	column.add_child(_list)
	var back := Button.new()
	back.text = "Voltar"
	back.custom_minimum_size.y = 50
	back.pressed.connect(func(): closed.emit())
	column.add_child(back)

func row_count() -> int:
	return campaign.inventory.items.size()

func summary_text() -> String:
	return "Itens: %d · Resíduo de Lúmen: %d" % [campaign.inventory.items.size(), int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0))]

func refresh() -> void:
	_summary.text = summary_text()
	for child in _list.get_children():
		child.queue_free()
	var owner_of := {}
	for hero_id in campaign.inventory.equipped:
		for uid in campaign.inventory.equipped[hero_id]:
			owner_of[int(uid)] = String(hero_id)
	for inst in campaign.inventory.items:
		_list.add_child(_row(inst, String(owner_of.get(int(inst["uid"]), ""))))

func _row(inst: Dictionary, owner_id: String) -> Control:
	var box := VBoxContainer.new()
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = SliceLogText.item_label(inst, _item_rows) + ("  · equipado: %s" % hero_names.get(owner_id, owner_id) if owner_id != "" else "")
	box.add_child(label)
	var actions := HBoxContainer.new()
	var uid := int(inst["uid"])
	if owner_id == "":
		var picker := OptionButton.new()
		var compatible: Array = _item_rows.get(inst["id"], {}).get("compatible_heroes", [])
		for hero_id in compatible:
			picker.add_item(String(hero_names.get(hero_id, hero_id)))
			picker.set_item_metadata(picker.item_count - 1, hero_id)
		picker.custom_minimum_size.y = 50
		actions.add_child(picker)
		var equip := Button.new()
		equip.text = "Equipar"
		equip.custom_minimum_size.y = 50
		equip.pressed.connect(func(): equip_item(uid, String(picker.get_item_metadata(picker.selected))))
		actions.add_child(equip)
	else:
		var unequip := Button.new()
		unequip.text = "Desequipar"
		unequip.custom_minimum_size.y = 50
		unequip.pressed.connect(func(): unequip_item(uid))
		actions.add_child(unequip)
	var recycle := Button.new()
	recycle.text = "Reciclar"
	recycle.custom_minimum_size.y = 50
	recycle.disabled = owner_id != "" or campaign.inventory.locked
	recycle.pressed.connect(func(): recycle_item(uid))
	actions.add_child(recycle)
	box.add_child(actions)
	return box

func _report(error: String) -> void:
	var texts := {"locked": "Não é possível mudar o equipamento durante uma expedição.", "incompatible": "Esse item não serve para esse herói.",
		"unknown": "Item não encontrado.", "equipped": "Desequipe o item antes de reciclar.", "not_recyclable": "Esse item não pode ser reciclado."}
	_message.text = String(texts.get(error, ""))

func equip_item(uid: int, hero_id: String) -> String:
	var err := campaign.equip(hero_id, uid)
	_report(err)
	refresh()
	if err == "":
		changed.emit()
	return err

func unequip_item(uid: int) -> String:
	var err := campaign.unequip(uid)
	_report(err)
	refresh()
	if err == "":
		changed.emit()
	return err

func recycle_item(uid: int) -> Dictionary:
	var res := campaign.recycle(uid)
	_report(String(res["error"]))
	if res["ok"]:
		_message.text = "Reciclado: +%d Resíduo de Lúmen." % int(res["residue"])
	refresh()
	if res["ok"]:
		changed.emit()
	return res

func auto_equip_all() -> void:
	campaign.auto_equip(hero_names.keys())
	_message.text = ""
	refresh()
	changed.emit()
```

- [ ] **Passo 4: importar e rodar** `TestSliceInventoryPanel`. Nota: `refresh()` usa `queue_free`, então a contagem de **itens** vem do inventário (`row_count`), não dos filhos da lista. Esperado: PASS.

---

## Tarefa 6: `SliceCampaignScreen`, cena e fluxo do Título

**Arquivos:**
- Criar: `scripts/ui/SliceCampaignScreen.gd`, `scenes/slice/SliceCampaign.tscn`
- Modificar: `scripts/ui/TitleScreen.gd` (destino), `tests/unit/test_title_screen.gd` só se ele testar o destino
- Teste: `tests/unit/test_slice_campaign_screen.gd`, `tests/unit/TestSliceCampaignScreen.tscn`

**Interfaces:**
- Consome: `SliceCampaign`, `SliceSession.BUILD_PRESETS`, `EventTexts`, `SliceLogText`, `SliceInventoryPanel`, `ExpeditionRun` (`step`, `choose`, `pending`, `state`).
- Produz: `SliceCampaignScreen` (`extends Control`) com `save_path: String` (defina **antes** de `add_child`), `mode: String` (`"prep"`, `"run"`, `"result"`), `campaign`, `run`, e a API pública abaixo (a UI e o teste chamam os mesmos métodos):
  - `start_expedition(preset_index: int) -> void`
  - `advance(seconds: float) -> void` (avança a simulação até `seconds`, para em `choice`, vitória ou derrota)
  - `pending_labels() -> Array` (rótulos da escolha pendente; `[]` se não há)
  - `choose(index: int) -> void`
  - `log_lines() -> Array`
  - `result_text() -> String`

Regras da tela: em `choice` a simulação para e mostra a intro do evento (ou "recompensa") com um botão por opção; itens de recompensa aparecem com `SliceLogText.item_label`. No resultado mostra vitória/derrota, níveis ganhos, itens e Resíduo do `finish_expedition`, com botões *Voltar* e *Inventário*. Botão *Sondagem (dev)* só em `OS.is_debug_build()`.

- [ ] **Passo 1: escrever o teste que falha**

```gdscript
extends Node

var success := true
const PATH := "user://test_slice_screen.json"
const LEVEL := 12

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] %s" % label)
	else:
		print("FALHA: %s" % label)
		success = false

func _cleanup() -> void:
	for p in [PATH, PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))

func _ready() -> void:
	print("--- TESTE SLICE CAMPAIGN SCREEN (SLICE-1B Plano B) ---")
	_cleanup()
	var screen: SliceCampaignScreen = load("res://scenes/slice/SliceCampaign.tscn").instantiate()
	screen.save_path = PATH
	add_child(screen)
	_expect("a tela abre em preparação", screen.mode == "prep")
	screen.campaign.data["party"]["level"] = LEVEL
	screen.start_expedition(2)
	_expect("iniciar leva ao modo run e trava o inventário", screen.mode == "run" and screen.campaign.inventory.locked)

	var saw_choice := false
	var choices_made := 0
	var guard := 0
	while screen.mode == "run" and guard < 20000:
		guard += 1
		var labels := screen.pending_labels()
		if not labels.is_empty():
			saw_choice = true
			_expect("a escolha pendente tem opções e o log já mostra o texto", labels.size() >= 1 and screen.log_lines().size() >= 1)
			screen.choose(labels.size() - 1 if choices_made % 2 == 0 else 0)
			choices_made += 1
		else:
			screen.advance(0.5)
	_expect("a expedição terminou no modo result", screen.mode == "result")
	_expect("houve ao menos uma escolha (Reward Choice ou evento)", saw_choice)
	_expect("o resultado descreve vitória ou derrota", screen.result_text().contains("vitória") or screen.result_text().contains("Derrota") or screen.result_text().contains("Vitória") or screen.result_text().contains("derrota"))
	_expect("o inventário destravou", not screen.campaign.inventory.locked)
	_expect("o save foi gravado em disco", FileAccess.file_exists(PATH))
	_expect("o log tem linhas de encontro", screen.log_lines().any(func(l): return String(l).begins_with("Encontro")))
	var reloaded := SliceCampaign.open(PATH)
	_expect("reabrir o save preserva os itens", reloaded.inventory.items.size() == screen.campaign.inventory.items.size())
	screen.queue_free()
	_cleanup()

	print("=======================================================")
	print("[%s] TESTE SLICE CAMPAIGN SCREEN" % ("PASS" if success else "FAIL"))
	get_tree().quit(0 if success else 1)
```

- [ ] **Passo 2: cena de teste, importar, rodar e ver falhar** (falta a cena `SliceCampaign.tscn` e a classe).

- [ ] **Passo 3: implementar `scripts/ui/SliceCampaignScreen.gd`**

```gdscript
extends Control
class_name SliceCampaignScreen

## Fluxo jogável do slice (SLICE-1B Plano B): Preparação → Expedição → Resultado, com inventário.
## Montada em código (como o SliceProbe). Toda regra vem do núcleo; aqui só há apresentação.
## O Hub visual, o Ferreiro e a Árvore são do 1D e não entram.

const HERO_NAMES := {"hero_001": "Bastião", "hero_002": "Flecha", "hero_003": "Íris"}
const SAVE_PATH := "user://slice_save.json"
const LOG_LIMIT := 40

var save_path: String = SAVE_PATH
var campaign: SliceCampaign
var run: ExpeditionRun
var mode: String = "prep"
var speed: float = 4.0

var _ctx: Dictionary = {}
var _log: Array = []
var _result: String = ""
var _preset: int = 0
var _prep_box: VBoxContainer
var _run_box: VBoxContainer
var _result_box: VBoxContainer
var _status: Label
var _hp: Label
var _log_label: Label
var _choice_box: VBoxContainer
var _prep_info: Label
var _result_label: Label
var _speed_button: Button
var _panel: SliceInventoryPanel

func _ready() -> void:
	campaign = SliceCampaign.open(save_path)
	var route: Dictionary = SliceSession.data()["route"]
	var node_names := {}
	for node in route.get("nodes", []):
		node_names[node["id"]] = node.get("name", node["id"])
	var item_rows := {}
	for row in SliceSession.data()["items"]:
		item_rows[row["id"]] = row
	_ctx = {"node_names": node_names, "hero_names": HERO_NAMES, "item_rows": item_rows, "texts": EventTexts.create(EventTexts.load_texts())}
	_build_ui()
	_show("prep")

func _build_ui() -> void:
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 24)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)
	_prep_box = VBoxContainer.new()
	_prep_box.add_theme_constant_override("separation", 12)
	root.add_child(_prep_box)
	_run_box = VBoxContainer.new()
	_run_box.add_theme_constant_override("separation", 12)
	root.add_child(_run_box)
	_result_box = VBoxContainer.new()
	_result_box.add_theme_constant_override("separation", 12)
	root.add_child(_result_box)
	_build_prep()
	_build_run()
	_build_result()

func _button(text: String, on_press: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size.y = 50
	b.pressed.connect(on_press)
	return b

func _label(autowrap: bool = true) -> Label:
	var l := Label.new()
	if autowrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

func _build_prep() -> void:
	var title := Label.new()
	title.text = "Bosque de Lúmen"
	title.add_theme_font_size_override("font_size", 23)
	_prep_box.add_child(title)
	_prep_info = _label()
	_prep_box.add_child(_prep_info)
	var picker := OptionButton.new()
	for preset in SliceSession.BUILD_PRESETS:
		picker.add_item(String(preset["name"]))
	picker.custom_minimum_size.y = 50
	picker.item_selected.connect(func(index: int): _preset = index)
	_prep_box.add_child(picker)
	_prep_box.add_child(_button("Iniciar expedição", func(): start_expedition(_preset)))
	_prep_box.add_child(_button("Inventário", _open_inventory))
	if OS.is_debug_build():
		_prep_box.add_child(_button("Sondagem (dev)", func(): get_tree().change_scene_to_file("res://scenes/slice/SliceProbe.tscn")))
	_prep_box.add_child(_button("Voltar ao título", func(): get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")))

func _build_run() -> void:
	_status = _label()
	_status.add_theme_font_size_override("font_size", 18)
	_run_box.add_child(_status)
	_hp = _label()
	_run_box.add_child(_hp)
	_speed_button = _button("Vel. ×4", _cycle_speed)
	_run_box.add_child(_speed_button)
	_choice_box = VBoxContainer.new()
	_choice_box.add_theme_constant_override("separation", 8)
	_run_box.add_child(_choice_box)
	_log_label = _label()
	_run_box.add_child(_log_label)

func _build_result() -> void:
	_result_label = _label()
	_result_box.add_child(_result_label)
	_result_box.add_child(_button("Inventário", _open_inventory))
	_result_box.add_child(_button("Voltar", func(): _show("prep")))

func _show(new_mode: String) -> void:
	mode = new_mode
	_prep_box.visible = mode == "prep"
	_run_box.visible = mode == "run"
	_result_box.visible = mode == "result"
	if mode == "prep":
		var party: Dictionary = campaign.data["party"]
		_prep_info.text = "Nível do trio: %d · XP: %d\n%s" % [int(party["level"]), int(party["xp"]), summary_line()]
	if mode == "result":
		_result_label.text = _result

func summary_line() -> String:
	return "Itens: %d · Resíduo de Lúmen: %d%s" % [campaign.inventory.items.size(), int(campaign.inventory.materials.get(SliceInventory.RESIDUE, 0)),
		"\nAviso: o save não pôde ser lido (%s); nada será gravado." % campaign.save_error if campaign.save_blocked else ""]

func _cycle_speed() -> void:
	speed = 1.0 if speed >= 20.0 else (20.0 if speed >= 4.0 else 4.0)
	_speed_button.text = "Vel. ×%d" % int(speed)

func _open_inventory() -> void:
	_panel = SliceInventoryPanel.new()
	add_child(_panel)
	_panel.setup(campaign, HERO_NAMES)
	_panel.closed.connect(func():
		_panel.queue_free()
		_show(mode))

func start_expedition(preset_index: int) -> void:
	var build: Dictionary = SliceSession.BUILD_PRESETS[preset_index]["heroes"]
	_log = []
	_result = ""
	run = campaign.start_expedition(build, int(Time.get_ticks_msec()) if not OS.is_debug_build() else 1 + int(campaign.data["party"]["xp"]))
	_show("run")
	_refresh_run()

func advance(seconds: float) -> void:
	if mode != "run" or run == null or run.state == "choice":
		return
	_consume(campaign.step(run, seconds))

func choose(index: int) -> void:
	if mode != "run" or run == null or run.state != "choice":
		return
	_consume(campaign.choose(run, index))

func _consume(events: Array) -> void:
	for ev in events:
		var line := SliceLogText.line(ev, _ctx)
		if line != "":
			_log.append(line)
	while _log.size() > LOG_LIMIT:
		_log.pop_front()
	if run.state == "won" or run.state == "lost":
		_finish()
	else:
		_refresh_run()

func pending_labels() -> Array:
	if run == null or run.state != "choice":
		return []
	var out: Array = []
	if String(run.pending["kind"]) == "reward":
		for inst in run.pending["options"]:
			out.append(SliceLogText.item_label(inst, _ctx["item_rows"]))
	else:
		for option in run.pending["options"]:
			out.append(String(option["label"]))
	return out

func log_lines() -> Array:
	return _log

func result_text() -> String:
	return _result

func _finish() -> void:
	var summary := campaign.finish_expedition(run)
	_result = "%s\nNíveis ganhos: %d · Itens: %d · Resíduo: %d\n%s" % [
		"Vitória! O Guardião-Cervo foi vencido." if summary["won"] else "Derrota. A party volta ao Refúgio para tentar de novo.",
		int(summary["levels_gained"]), int(summary["items"]), int(summary["residue"]), summary_line()]
	_show("result")

func _refresh_run() -> void:
	if run == null:
		return
	var snap := run.snapshot()
	_status.text = "Encontro: %s" % _ctx["node_names"].get(snap["node_id"], snap["node_id"])
	var parts: Array = []
	for p in snap["party"]:
		parts.append("%s %.0f/%.0f" % [HERO_NAMES.get(p["id"], p["id"]), float(p["hp"]), float(p["max_hp"])])
	_hp.text = "  ·  ".join(parts)
	_log_label.text = "\n".join(_log.slice(maxi(0, _log.size() - 8)))
	for child in _choice_box.get_children():
		child.queue_free()
	var labels := pending_labels()
	for i in labels.size():
		var index := i
		_choice_box.add_child(_button(String(labels[i]), func(): choose(index)))

func _process(delta: float) -> void:
	if mode == "run" and run != null and run.state != "choice":
		advance(minf(delta * speed, 0.5))
```

Detalhe: o intro do evento entra no log em `event_offered` (via `SliceLogText`), então o texto de lore aparece acima dos botões. O parâmetro de seed de `start_expedition` usa uma seed determinística em debug (facilita reproduzir) e o relógio em release.

- [ ] **Passo 4: criar `scenes/slice/SliceCampaign.tscn`**

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/ui/SliceCampaignScreen.gd" id="1"]

[node name="SliceCampaign" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")
```

- [ ] **Passo 5: apontar o Título para a nova tela.** Em `scripts/ui/TitleScreen.gd`, troque `res://scenes/slice/SliceProbe.tscn` por `res://scenes/slice/SliceCampaign.tscn` (e o comentário para "Transição para a campanha do slice"). Se `tests/unit/test_title_screen.gd` citar o destino, atualize-o.

- [ ] **Passo 6: importar, rodar** `TestSliceCampaignScreen` e a suíte. Esperado: PASS. Se "houve ao menos uma escolha" falhar, confirme `LEVEL = 12` (a rota precisa chegar ao elite, onde há Reward Choice); não force o teste.

- [ ] **Passo 7: verificação manual no editor/emulador (registrar, não automatizável).** Abra o projeto, rode o Título e passe por Preparação → Iniciar → uma escolha → Resultado → Inventário. Anote no relatório qualquer texto cortado ou botão pequeno em 432×960 (o QA mobile formal é do `1E`).

---

## Tarefa 7: Argos com loot e eventos reais

**Arquivos:**
- Modificar: `tools/argos/simulator/combat/argos_sim.gd`
- Criar: `tools/argos/simulator/combat/scenarios/slice_run_layer.json`
- Modificar: `tools/argos/analyzer/analyze.py`, `tools/argos/analyzer/test_analyze.py`, `tools/argos/README.md`

**Interfaces:**
- Consome: `SliceCampaign.in_memory()`, `start_expedition(build, seed, extra_options)`, `step`, `choose`, `finish_expedition`, `auto_equip` (Tarefa 4); `ExpeditionRun.pending`; `EventDirector`.
- Produz:
  - modo de campanha `campaign.run_layer: true` no cenário; registro `kind: "campaign"` com o mesmo formato atual (`history[]` com `gold`, `residue`, `items_dropped`, `equipped_after`, …) **mais** `history[].events` = `{"offered": {id: n}, "resolved": {"id:choice": n}, "loot_by_rarity": {rarity: n}}` e `run_layer: true`
  - variantes com `campaign_policy` (`{event_id: choice_id}`, mais `reward: "best"|"first"`) e `event_rules` (sobrescreve `random_rules` do catálogo)
  - relatório: seção **Eventos e loot da run** (por evento: vezes oferecido, por 100 tentativas, divisão de escolhas)

- [ ] **Passo 1: escrever o teste do Analyst que falha** (`test_analyze.py`, novo caso; reutilize os helpers do arquivo)

```python
def campaign_with_events(build, offered, resolved, loot=None):
    hist = [{"level": 10, "won": True, "furthest": 11, "xp": 100, "violations": [], "gold": 0, "residue": 6,
             "items_dropped": 2, "equipped_after": 3,
             "events": {"offered": offered, "resolved": resolved, "loot_by_rarity": loot or {"Comum": 2}}}]
    return {"kind": "campaign", "build": build, "seed": 1, "won": True, "attempts": 1, "final_level": 10, "history": hist,
            "loot": True, "run_layer": True, "build_map": {}, "totals": {"gold": 0, "residue": 6, "items": 2}}


class RunLayerTest(unittest.TestCase):
    def test_event_rows_count_offers_and_choices(self):
        runs = [
            campaign_with_events("a/b/c", {"event_c1_001": 1}, {"event_c1_001:heal": 1}),
            campaign_with_events("a/b/c", {"event_c1_001": 1, "event_c1_raiz_oca": 1}, {"event_c1_001:sacrifice": 1, "event_c1_raiz_oca:open": 1}),
        ]
        rows = {r["event"]: r for r in analyze.summarize(runs)["run_layer"]["events"]}
        self.assertEqual(rows["event_c1_001"]["offered"], 2)
        self.assertEqual(rows["event_c1_001"]["choices"], {"heal": 1, "sacrifice": 1})
        self.assertEqual(rows["event_c1_raiz_oca"]["offered"], 1)
        self.assertAlmostEqual(rows["event_c1_001"]["per_100_attempts"], 200.0)

    def test_loot_by_rarity_is_summed(self):
        runs = [campaign_with_events("a/b/c", {}, {}, {"Comum": 2, "Raro": 1}), campaign_with_events("a/b/c", {}, {}, {"Comum": 1})]
        loot = analyze.summarize(runs)["run_layer"]["loot_by_rarity"]
        self.assertEqual(loot, {"Comum": 3, "Raro": 1})

    def test_no_run_layer_data_is_empty(self):
        self.assertEqual(analyze.summarize([route("a/b/c", 5, True)])["run_layer"], {"events": [], "loot_by_rarity": {}})
```

Rode: `python -m unittest tools/argos/analyzer/test_analyze.py`. Esperado: FALHA (`KeyError: 'run_layer'`).

- [ ] **Passo 2: implementar no Analyst.** Em `summarize`, antes do `return`, acrescente e inclua `"run_layer": run_layer` no dicionário devolvido:

```python
    events = defaultdict(lambda: {"offered": 0, "choices": defaultdict(int)})
    loot_by_rarity = defaultdict(int)
    attempts_total = 0
    for cs in campaign.values():
        for c in cs:
            for h in c.get("history", []):
                layer = h.get("events")
                if layer is None:
                    continue
                attempts_total += 1
                for event_id, n in layer.get("offered", {}).items():
                    events[event_id]["offered"] += n
                for key, n in layer.get("resolved", {}).items():
                    event_id, choice = key.split(":", 1)
                    events[event_id]["choices"][choice] += n
                for rarity, n in layer.get("loot_by_rarity", {}).items():
                    loot_by_rarity[rarity] += n
    run_layer = {
        "events": [{"event": e, "offered": v["offered"], "choices": dict(v["choices"]),
                    "per_100_attempts": 100.0 * v["offered"] / attempts_total if attempts_total else 0.0}
                   for e, v in sorted(events.items())],
        "loot_by_rarity": dict(loot_by_rarity),
    }
```

Em `write_report`, antes do bloco `if prev:`, acrescente:

```python
    layer = summary.get("run_layer", {"events": [], "loot_by_rarity": {}})
    if layer["events"]:
        lines += ["", "## Eventos e loot da run (SLICE-1B, campanha com o núcleo real)", "",
                  "| Evento | Oferecido | Por 100 tentativas | Escolhas |", "| --- | ---: | ---: | --- |"]
        for r in layer["events"]:
            split = ", ".join(f"{k}: {v}" for k, v in sorted(r["choices"].items())) or "—"
            lines.append(f"| {r['event']} | {r['offered']} | {r['per_100_attempts']:.0f} | {split} |")
        if layer["loot_by_rarity"]:
            lines.append("")
            lines.append("Itens recebidos por raridade: " + ", ".join(f"{k} {v}" for k, v in sorted(layer["loot_by_rarity"].items())) + ".")
```

Rode `python -m unittest tools/argos/analyzer/test_analyze.py`. Esperado: OK (todos os testes antigos e os 3 novos).

- [ ] **Passo 3: cenário `slice_run_layer.json`**

```json
{
  "id": "slice_run_layer",
  "chapter_id": "CHAPTER_01",
  "party": ["hero_001", "hero_002", "hero_003"],
  "description": "Campanha com o núcleo real do 1B (LootRoller, EventDirector, SliceInventory). Variantes fixam a escolha do Poço e aumentam a frequência de eventos para medir o pior e o melhor caso sem depender de sorte.",
  "seeds": 6,
  "levels": [5],
  "builds": {
    "hero_001": ["guardiao", "retaliacao"],
    "hero_002": ["critico", "marca"],
    "hero_003": ["arcano", "controle"]
  },
  "modes": ["campaign"],
  "campaign": {"start_level": 1, "max_attempts": 10, "run_layer": true, "policy": {"reward": "best"}},
  "variants": [
    {"id": "base", "note": "Política padrão: Poço cura (opção 0), recompensa melhor item."},
    {"id": "poco_curar", "note": "Poço sempre cura.", "campaign_policy": {"event_c1_001": "heal"}},
    {"id": "poco_sacrificar", "note": "Poço sempre sacrifica (recompensa rara).", "campaign_policy": {"event_c1_001": "sacrifice"}},
    {"id": "eventos_frequentes", "note": "50% de chance de evento por transição, até 4 por run.", "event_rules": {"transition_chance": 0.5, "max_random_per_run": 4}}
  ],
  "rank_milestones": [3, 5, 7, 9, 11, 13, 15, 17, 19],
  "max_time": 3600,
  "stuck_seconds": 30
}
```

- [ ] **Passo 4: implementar no `argos_sim.gd`.**

Junto das outras variáveis: `var variant_policy := {}` e `var variant_event_rules := {}`. Em `_apply_variant`, depois de `run_options = ...`:

```gdscript
	variant_policy = v.get("campaign_policy", {})
	variant_event_rules = v.get("event_rules", {})
```

No início de `_campaign`:

```gdscript
	if bool(scenario.get("campaign", {}).get("run_layer", false)):
		_campaign_run_layer(build, seed_value)
		return
```

Funções novas (no fim da seção de execuções):

```gdscript
## Escolha automática do Argos (não é comportamento de jogador): recompensa = melhor raridade/IP; evento = política ou opção 0.
func _pick(pending: Dictionary, policy: Dictionary) -> int:
	var options: Array = pending["options"]
	if String(pending["kind"]) == "reward":
		if String(policy.get("reward", "best")) != "best":
			return 0
		var best := 0
		for i in options.size():
			var a: Dictionary = options[i]
			var b: Dictionary = options[best]
			if LootRoller.rarity_rank(a["rarity"]) * 1000 + int(a["item_power"]) > LootRoller.rarity_rank(b["rarity"]) * 1000 + int(b["item_power"]):
				best = i
		return best
	var want := String(policy.get(String(pending["id"]), ""))
	for i in options.size():
		if String(options[i]["id"]) == want:
			return i
	return 0

func _events_director(seed_value: int) -> EventDirector:
	var catalog := EventDirector.load_catalog()
	for key in variant_event_rules:
		catalog["random_rules"][key] = variant_event_rules[key]
	return EventDirector.create(catalog, seed_value)

## Campanha com o núcleo real do 1B: SliceCampaign em memória, loot/eventos/inventário verdadeiros.
## Mesmo formato de registro da campanha antiga, mais history[].events para o Analyst.
func _campaign_run_layer(build: Dictionary, seed_value: int) -> void:
	var c: Dictionary = scenario.get("campaign", {})
	var policy: Dictionary = c.get("policy", {}).duplicate()
	policy.merge(variant_policy, true)
	var campaign := SliceCampaign.in_memory()
	campaign.data["party"]["level"] = int(c.get("start_level", 1))
	var attempts := []
	var totals := {"gold": 0, "residue": 0, "items": 0}
	var won := false
	for attempt in range(1, int(c.get("max_attempts", 10)) + 1):
		var level := int(campaign.data["party"]["level"])
		var attempt_seed := seed_value * 1000 + attempt
		var options := _options(build, level, attempt_seed, campaign.inventory.equipment_for_run())
		if not variant_event_rules.is_empty():
			options["events"] = _events_director(attempt_seed)
		var run := campaign.start_expedition(build, attempt_seed, options)
		var events: Array = []
		var guard := 0
		while run.state != "won" and run.state != "lost" and run.time < float(scenario.get("max_time", 3600.0)) and guard < 100000:
			guard += 1
			if run.state == "choice":
				events.append_array(campaign.choose(run, _pick(run.pending, policy)))
			else:
				events.append_array(campaign.step(run, 0.25))
		var summary := _summarize(run, events, level)
		var layer := {"offered": {}, "resolved": {}, "loot_by_rarity": {}}
		var residue := 0
		var items_dropped := 0
		for e in events:
			match String(e["type"]):
				"event_offered":
					layer["offered"][e["id"]] = int(layer["offered"].get(e["id"], 0)) + 1
				"event_resolved":
					var key := "%s:%s" % [e["id"], e["choice"]]
					layer["resolved"][key] = int(layer["resolved"].get(key, 0)) + 1
				"loot_dropped":
					layer["loot_by_rarity"][e["item"]["rarity"]] = int(layer["loot_by_rarity"].get(e["item"]["rarity"], 0)) + 1
					items_dropped += 1
				"material_dropped":
					residue += int(e["quantity"])
		campaign.finish_expedition(run)
		campaign.auto_equip(party_ids)
		var equipped := 0
		for hid in campaign.inventory.equipped:
			equipped += campaign.inventory.equipped[hid].size()
		totals["residue"] += residue
		totals["items"] += items_dropped
		attempts.append({"level": level, "won": summary["won"], "furthest": summary["furthest_node"], "xp": summary["xp"],
			"violations": summary["violations"], "gold": 0, "residue": residue, "items_dropped": items_dropped,
			"equipped_after": equipped, "events": layer})
		if summary["won"]:
			won = true
			break
	_write({"kind": "campaign", "build": _label(build), "build_map": build.duplicate(), "seed": seed_value, "won": won,
		"attempts": attempts.size(), "final_level": int(campaign.data["party"]["level"]), "history": attempts,
		"loot": true, "run_layer": true, "totals": totals})
```

Atenção: o oráculo `_summarize` compara o XP pago com o esperado por inimigo derrotado; ele continua válido porque os eventos de XP são os mesmos. `campaign.step` devolve os mesmos eventos do run. O nível vem do XP acumulado no `SliceSave.add_xp` (o `SliceCampaign` aplica), então **não** recalcule nível no simulador.

- [ ] **Passo 5: rodar o cenário.** `python tools/argos/run.py --scenario slice_run_layer`. Esperado: termina sem `BUG`; o `REPORT.md` traz a seção *Eventos e loot da run* com o Poço aparecendo em cerca de 1 de cada tentativa que chega ao nó dele, e as variantes `poco_curar`/`poco_sacrificar` com divisões de escolha de 100% em um lado. Leia **só** o `REPORT.md` (AGENTS.md). Achados `BALANCE`/`PACING` vão para `docs/08_qa/BALANCE_FINDINGS.md` com hipótese; **não** mude `/data` nem `rules_slice.json` para "passar".

- [ ] **Passo 6: regressão.** `python tools/argos/run.py --scenario slice_quick` (0 BUG, mesmo número de execuções) e `python -m unittest tools/argos/analyzer/test_analyze.py`. Apague apenas os relatórios que você gerou agora.

- [ ] **Passo 7: documentar.** Em `tools/argos/README.md`, uma linha na tabela de cenários para `slice_run_layer` (o que mede e como ler a seção nova).

---

## Tarefa 8: Sincronizar documentação e fechar o checkpoint

**Arquivos:**
- Modificar: `docs/03_systems/SLICE_1B_RUN_SPEC.md`, `ROADMAP.md`, `CHANGELOG.md`, `PROJECT_STATE.md`, `README.md`, `AGENTS.md`, `docs/03_systems/INDEX.md`, `docs/01_world/INDEX.md`, `docs/04_content/chapters/INDEX.md`, `docs/CONTENT_REGISTRY.md`, `docs/08_qa/INDEX.md` (se listar testes)

- [ ] **Passo 1: spec.** Na seção 3 da `SLICE_1B_RUN_SPEC.md`, troque "**EM ABERTO:** texto de lore de cada evento" por: textos escritos em `event_texts_c1.json` (`DESIGN`, aguardando revisão de Rafael); a forma exata de `modify_next_encounter` já está no `EventDirector`/`ExpeditionRun`. Atualize a seção 8 (o que ainda está fora).

- [ ] **Passo 2: índices e registro.** Em `docs/01_world/INDEX.md`: linha *Textos de eventos do Capítulo 1* apontando para `EVENT_TEXTS.md` (derivado) e para o JSON (fonte). Em `docs/04_content/chapters/INDEX.md`: link para `EVENT_TEXTS.md`. Em `docs/CONTENT_REGISTRY.md`: linha *Textos de eventos do slice* (`data/expedition/event_texts_c1.json`, `DESIGN`).

- [ ] **Passo 3: estado.** `ROADMAP.md`: `1B` passa a **feito, aguardando `1E`** (núcleo, textos, tela e Argos entregues); mova o que sobrar (QA mobile formal, Hub visual) para `1D`/`1E`. `PROJECT_STATE.md`: fluxo jogável agora é `TitleScreen → SliceCampaign`. `README.md` (linha do fluxo e a evidência de testes). `AGENTS.md`: o mapa de `/scripts/` cita `scripts/run/` e `scripts/ui/SliceCampaignScreen.gd`; a tabela de Argos ganha `slice_run_layer`. `CHANGELOG.md`: entrada `1B tela, textos e Argos`.

- [ ] **Passo 4: vista derivada em dia.** `python tools/content/export_event_texts.py` e confirme que `git diff --stat docs/04_content/chapters/chapter_01/EVENT_TEXTS.md` não mostra mudança inesperada.

- [ ] **Passo 5: verificação final**

```bash
python tools/godot_import.py
python tools/run_godot_tests.py
python -m unittest tools/argos/analyzer/test_analyze.py
python tools/argos/run.py --scenario slice_quick
python tools/argos/run.py --scenario slice_run_layer
python tools/balance/validate_balance_data.py
python scripts/art/audit_docs_links.py
```

Esperado: todas as cenas PASS (Plano A deixou 19; este plano soma `TestRunChoicePolicy`, `TestEventTexts`, `TestSliceLogText`, `TestSliceCampaignApi`, `TestSliceInventoryPanel` e `TestSliceCampaignScreen`: **25/25**), Analyst OK, Argos sem `BUG`, validador `OK`, 0 links quebrados. Apague só os relatórios do Argos que você gerou.

- [ ] **Passo 6: checkpoint.** Sem commit. Relate a Rafael: arquivos, resultados, achados do `slice_run_layer` (frequência dos eventos, sacrificar × curar, Resíduo por tentativa contra a meta de 5) e as observações do teste manual em 432×960. Peça a revisão dos textos de lore (`EVENT_TEXTS.md`), que continuam `DESIGN` até a aprovação dele.

---

## Autorrevisão (feita ao escrever)

**Cobertura:** textos de lore no jogo (Tarefas 2, 3, 6); tela de inventário/equipar/reciclar (5); fluxo no jogo (6); cenários do Argos para loot e eventos (7); ajustes de núcleo que os dois exigem (1, 4); documentação (8). Ficam fora, por decisão da spec: Hub visual, Ferreiro, Árvore, Echo, offline, QA mobile formal.

**Riscos tratados:** laço infinito de `run_to_end` em `choice` (Tarefa 1); erro do `queue_free` na contagem de linhas do painel (Tarefa 5); nível da party no teste da tela (`LEVEL = 12`, com instrução de não forçar); Argos sem recalcular nível (o `SliceCampaign` já aplica o XP); relatórios de terceiros preservados.

**Consistência de nomes:** `EventTexts.intro/choice_text/outcome_text/lore/validate/create/load_texts`, `SliceLogText.line/item_label`, `SliceCampaign.in_memory/start_expedition(build, seed, extra_options)/auto_equip`, `SliceInventory.auto_equip`, `SliceSession.BUILD_PRESETS`, `SliceInventoryPanel.setup/equip_item/unequip_item/recycle_item/auto_equip_all/row_count/summary_text`, `SliceCampaignScreen.start_expedition/advance/choose/pending_labels/log_lines/result_text`, `EventDirector.last_outcome` e o campo `outcome` de `event_resolved` foram usados com a mesma assinatura em todas as tarefas.
