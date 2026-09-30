# Kits completos dos 3 heróis — Plano 00: fundação compartilhada e ordem de execução

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans para executar tarefa por tarefa. Os passos usam checkbox (`- [ ]`).

**Meta:** deixar Bastião, Flecha e Íris com o kit do [HERO_STANDARD](../../docs/02_heroes/HERO_STANDARD.md) pronto para simulação (6 skills com Signature, 16 passivas, 3 Traits, 3 builds), e validar tudo em ~3000 runs do Argos, ajustando números onde o relatório apontar.

**Arquitetura:** o `ExpeditionRun` continua sendo o único núcleo de combate. Cada skill/passiva nova é (1) uma linha em `data/skills/*.json` com `"status": "HIPOTESE"` e `"source"`, (2) no máximo um novo `kind`/`type` tratado por um gancho pequeno em `scripts/combat/ExpeditionRun.gd`, (3) um teste determinístico. Passivas de capstone e de tier alto entram por **nível de desbloqueio** (`unlock_level`), para não mudar o balanceamento dos níveis baixos já medidos.

**Tecnologias:** Godot 4.7.2 (GDScript), JSON em `/data`, testes headless (`tests/unit/Test*.tscn`, `python tools/run_godot_tests.py`), Argos (`python tools/argos/run.py --scenario <id>`).

**Spec:** [HERO_STANDARD.md](../../docs/02_heroes/HERO_STANDARD.md) seções 2, 3, 5, 6 e 18; [BASTIAO_GOLDEN_REFERENCE](../../docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md); [passivas do Bastião](../../docs/02_heroes/hero_001_bastiao_passives.md) e [Traits](../../docs/02_heroes/hero_001_bastiao_traits.md); [FLECHA_SKILLS](../../docs/04_content/skills/FLECHA_SKILLS.md), [passivas](../../docs/02_heroes/hero_002_flecha_passives.md) e [Traits](../../docs/02_heroes/hero_002_flecha_traits.md); [kit da Íris](../../docs/02_heroes/hero_003_iris_slice_kit.md); metas em [rules_slice.json](../../tools/argos/analyzer/rules_slice.json) e [v1 · perfil do Capítulo 1](../../docs/06_balance/v1/capitulos/CAPITULO_01.md).

## Ordem dos planos

| # | Plano | Depende de | Entrega |
| --- | --- | --- | --- |
| 00 | este arquivo | — | suporte de teste, `unlock_level`, baseline do Argos, loadout sem contagem fixa, ajudantes compartilhados |
| 01 | [Bastião](2026-09-30-kits-completos-01-bastiao.md) | 00 | Guarda, Impacto de Escudo, Último Bastião, A3–A5, B3–B5, C1–C5, Não Passarão |
| 02 | [Flecha](2026-09-30-kits-completos-02-flecha.md) | 00 | Ricochete, Chuva de Flechas, A3–A5, B3–B5, C1–C5, Aljava em Movimento |
| 03 | [Íris](2026-09-30-kits-completos-03-iris.md) | 00 e decisão de Rafael (Tarefa I0) | Signature, Pulso promovido, A3–A5, B3–B5, build C, 3º Trait |
| 04 | [Argos 3000 runs](2026-09-30-kits-completos-04-argos.md) | 01–03 (ou parcial) | 3 cenários de foco, telemetria, laço de ajuste |

Os planos 01, 02 e 03 são independentes entre si depois do 00 e podem rodar em paralelo em worktrees separados; todos editam `ExpeditionRun.gd`, `heroes.json`, `skills_slice.json` e `passives_slice.json`, então **integre um por vez** e rode a suíte completa a cada integração.

## Restrições globais

- **Sem commit nem push** (AGENTS.md: só sob pedido de Rafael). Cada tarefa termina num checkpoint com testes verdes; relate e pare. Antes de começar: `git status` e preserve o que já existe (`tools/daedalus/comfyui/...`, `documents/*.docx`, relatórios do Argos).
- GDScript com **tabs**; comentários e textos em português; `snake_case` no código. `ExpeditionRun.gd` usa fim de linha CRLF: use a ferramenta Edit (que preserva) ou, em Python, `open(..., newline='')` e troque `\n` por `\r\n` ao gravar.
- Um fato, uma fonte: números vivem em `/data`; o código não os copia. Todo número novo é **HIPÓTESE** com `"status": "HIPOTESE"` e `"source"` explicando de onde veio. Não renomear IDs runtime existentes.
- Números de design são propostas de teste. Nada aqui declara o jogo balanceado nem prova diversão (AGENTS.md, seção do Argos).
- Não afrouxar `tools/argos/analyzer/rules_slice.json` para passar relatório. Mudança de meta é decisão de Rafael.
- `GDScript`: `trait` é palavra reservada (use `with_trait`); `for sk in ...` dentro de `_cast` colide com o parâmetro `sk` (use outro nome); inferir tipo de `Dictionary` vindo de `Array.filter` exige anotação explícita (`var x: Dictionary = ...`).
- O slice não tem posição nem movimento: efeitos de deslocamento (knockback, slow por travessia, "movimento") são **traduzidos** para efeitos de combate por alvo (stagger, stun, Desequilíbrio, slow de ataque) e a tradução é registrada no `"source"` de cada linha.

## Estrutura de arquivos (comum aos planos)

- `tests/unit/kit_test_support.gd` — **novo** (Tarefa 1): helpers `KitTestSupport.mk/spawn/tank/damages/new_enemy`, usados pelos testes dos 3 heróis.
- `tests/unit/test_kit_bastiao.gd`, `test_kit_flecha.gd`, `test_kit_iris.gd` (+ `.tscn`) — um por herói.
- `data/skills/skills_slice.json`, `data/skills/passives_slice.json`, `data/heroes/heroes.json` — dados.
- `scripts/combat/ExpeditionRun.gd` — ganchos de combate.
- `tools/argos/simulator/combat/scenarios/kits_focus_*.json` — cenários (Plano 04).
- `docs/CONTENT_REGISTRY.md` e as fichas em `docs/02_heroes/` — IDs e status.

---

### Tarefa 1: Suporte de teste compartilhado

**Files:**
- Create: `tests/unit/kit_test_support.gd`
- Create: `tests/unit/test_kit_support.gd`, `tests/unit/TestKitSupport.tscn`

**Interfaces:**
- Produces:
  - `KitTestSupport.load_all() -> void` (carrega linhas de heróis, inimigos, skills, passivas do conjunto `slice`)
  - `KitTestSupport.mk(specs: Array, members: Array, ranks := {}, overrides := {}, hp := {}, level := 1) -> ExpeditionRun` onde `specs` é `[[hero_id, skills, passives], ...]` (o primeiro é a linha de frente; aceita até 3 heróis)
  - `KitTestSupport.spawn(run) -> Array` (avança até haver inimigos; devolve eventos)
  - `KitTestSupport.tank(run) -> void` (deixa os inimigos com 1e9 de HP)
  - `KitTestSupport.new_enemy(run, enemy_id := "en_c1_001") -> Dictionary`
  - `KitTestSupport.damages(events, type, source, skill := "") -> Array` (valores `damage`)
  - `KitTestSupport.of(events, type) -> Array`

- [ ] **Step 1: Escrever `kit_test_support.gd`**

```gdscript
class_name KitTestSupport
extends RefCounted

## Ajudantes dos testes de kit (2026-09-30). Heróis com HP alto para que a luta dure o bastante.

const HEROES_PATH := "res://data/heroes/heroes.json"
const ENEMIES_PATH := "res://data/enemies/enemies.json"
const SKILLS_PATH := "res://data/skills/skills_slice.json"
const PASSIVES_PATH := "res://data/skills/passives_slice.json"

static var hero_rows: Array = []
static var enemy_rows: Array = []
static var skill_rows: Array = []
static var passive_rows: Array = []

static func load_all() -> void:
	hero_rows = SliceStats.load_rows(HEROES_PATH, "slice")
	enemy_rows = SliceStats.load_rows(ENEMIES_PATH, "slice")
	skill_rows = SliceStats.load_rows(SKILLS_PATH, "slice")
	passive_rows = SliceStats.load_rows(PASSIVES_PATH, "slice")

static func of(events: Array, type: String) -> Array:
	return events.filter(func(e): return e["type"] == type)

static func damages(events: Array, type: String, source: String, skill: String = "") -> Array:
	var out: Array = []
	for e in of(events, type):
		if e["source"] == source and (skill == "" or e.get("skill", "") == skill):
			out.append(float(e["damage"]))
	return out

static func _hero(hero_id: String, skills: Array, passives: Array) -> Dictionary:
	for r in hero_rows:
		if r["id"] == hero_id:
			var copy: Dictionary = r.duplicate(true)
			copy["base_stats"]["max_hp"] = [5000.0, 5000.0]
			copy["builds"] = {"t": {"name": "t", "skills": skills, "passives": passives}}
			return copy
	return {}

static func mk(specs: Array, members: Array, ranks: Dictionary = {}, overrides: Dictionary = {}, hp: Dictionary = {}, level: int = 1) -> ExpeditionRun:
	var heroes: Array = []
	var builds := {}
	var formation := {}
	var slots := ["front", "mid", "back"]
	for i in specs.size():
		heroes.append(_hero(specs[i][0], specs[i][1], specs[i][2]))
		builds[specs[i][0]] = "t"
		formation[slots[i]] = specs[i][0]
	var route := {"transition_seconds": 0.6, "nodes": [{"type": "encounter", "id": "n", "kind": "NORMAL", "stage": 1, "level": level, "members": members}]}
	var run := ExpeditionRun.create(route, heroes, enemy_rows, {
		"seed": 1, "crits": false, "party_level": level, "skills": skill_rows, "builds": builds,
		"passives": passive_rows, "formation": formation, "trigger_overrides": overrides, "skill_ranks": ranks,
	})
	for hid in hp:
		run._heroes[hid]["hp"] = float(hp[hid])
	return run

static func spawn(run: ExpeditionRun) -> Array:
	var events: Array = []
	for _i in 40:
		if not run._enemies.is_empty():
			break
		events.append_array(run.step(0.05))
	return events

static func tank(run: ExpeditionRun) -> void:
	for e in run._enemies:
		e["hp"] = 1.0e9
		e["stats"]["max_hp"] = 1.0e9

static func new_enemy(run: ExpeditionRun, enemy_id: String = "en_c1_001") -> Dictionary:
	var row: Dictionary = enemy_rows.filter(func(r): return r["id"] == enemy_id)[0]
	return run._new_enemy(row, 1)
```

- [ ] **Step 2: Escrever o teste do próprio suporte**

`tests/unit/test_kit_support.gd`:

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		print("FALHA: ", label)
		success = false

func _ready() -> void:
	print("--- TESTE SUPORTE DOS KITS ---")
	KitTestSupport.load_all()
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 2}])
	KitTestSupport.spawn(run)
	_expect("spawn cria 2 inimigos", run._enemies.size() == 2)
	KitTestSupport.tank(run)
	_expect("tank deixa HP alto", float(run._enemies[0]["hp"]) >= 1.0e9)
	var extra := KitTestSupport.new_enemy(run)
	_expect("new_enemy devolve inimigo vivo", bool(extra["alive"]))
	var events := run.step(3.0)
	_expect("Flecha ataca", not KitTestSupport.damages(events, "hero_attack", "hero_002").is_empty())
	print("[PASS] TESTE SUPORTE DOS KITS CONCLUÍDO" if success else "[FAIL] TESTE SUPORTE DOS KITS")
	get_tree().quit(0 if success else 1)
```

`tests/unit/TestKitSupport.tscn` (mesmo formato dos demais):

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/unit/test_kit_support.gd" id="1_test"]

[node name="TestKitSupport" type="Node"]
script = ExtResource("1_test")
```

- [ ] **Step 3: Rodar**

Run: `"Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe" --headless --path . res://tests/unit/TestKitSupport.tscn`
Expected: 4 linhas `[PASS]` e `CONCLUÍDO`, código de saída 0.

- [ ] **Step 4: Checkpoint** — `python tools/run_godot_tests.py` (esperado: todas as cenas PASS; o número sobe em 1). Relate e pare.

---

### Tarefa 2: Portão `unlock_level` das passivas

Passivas de tier alto só valem quando o nível da party alcança `unlock_level`. Sem o campo, vale 1 (comportamento atual).

**Files:**
- Modify: `scripts/combat/ExpeditionRun.gd` (laço `for pid in passive_ids:` dentro de `create`, ~linha 136)
- Test: `tests/unit/test_kit_support.gd` (acrescentar caso)

**Interfaces:**
- Consumes: `passive_rows[pid]` (linha do JSON) e `level` (`options.party_level`).
- Produces: linhas de passiva aceitam `"unlock_level": int` (HIPÓTESE). Escala padrão dos planos: tier 1 = 1, tier 2 (A3/B3/C3) = 4, tier 3 (A4/B4/C4) = 7, capstones = 10.

- [ ] **Step 1: Teste que falha** — em `test_kit_support.gd`, antes do `print` final:

```gdscript
	# unlock_level: uma passiva de teste só entra no nível pedido.
	var gated: Dictionary = KitTestSupport.passive_rows.filter(func(r): return r["id"] == "passive_fle_pressao_coordenada")[0].duplicate(true)
	gated["id"] = "passive_teste_gated"
	gated["unlock_level"] = 5
	KitTestSupport.passive_rows.append(gated)
	var low := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], ["passive_teste_gated"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 4)
	var high := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], ["passive_teste_gated"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 5)
	_expect("unlock_level 5 fica de fora no nível 4", not low._heroes["hero_002"]["passives"].has("mark_ally_hit_boost"))
	_expect("unlock_level 5 entra no nível 5", high._heroes["hero_002"]["passives"].has("mark_ally_hit_boost"))
	KitTestSupport.passive_rows.erase(gated)
```

- [ ] **Step 2: Rodar e ver falhar** — `TestKitSupport.tscn`; Expected: `FALHA: unlock_level 5 fica de fora no nível 4`.

- [ ] **Step 3: Implementar** — em `create`, trocar

```gdscript
			if passive_rows.has(pid) and String(passive_rows[pid]["kind"]) != "none":
				run._heroes[hid]["passives"][passive_rows[pid]["kind"]] = passive_rows[pid]["params"]
```

por

```gdscript
			if passive_rows.has(pid) and String(passive_rows[pid]["kind"]) != "none" and int(passive_rows[pid].get("unlock_level", 1)) <= level:
				run._heroes[hid]["passives"][passive_rows[pid]["kind"]] = passive_rows[pid]["params"]
```

- [ ] **Step 4: Rodar e ver passar** — `TestKitSupport.tscn` (6 PASS) e `python tools/run_godot_tests.py` (nenhuma regressão; nada usa `unlock_level` ainda).

- [ ] **Step 5: Checkpoint.**

---

### Tarefa 3: Baseline do Argos antes de qualquer mudança de kit

O ajuste só faz sentido se houver referência. Rode **antes** dos planos 01–03.

**Files:** nenhum (só relatórios em `tools/argos/reports/`).

- [ ] **Step 1: Rodar o cenário atual**

Run: `python tools/argos/run.py --scenario slice_balance`
Expected: `Argos: 1404 execuções, ... (0 BUG)`. Anote o caminho do relatório (`tools/argos/reports/<data>_<commit>/REPORT.md`).

- [ ] **Step 2: Registrar a referência** — copie para um arquivo novo `docs/08_qa/KITS_BASELINE_2026-09-30.md` as linhas: taxa de vitória por build, "Referência de primeira tentativa no nível 10", mediana de tentativas da campanha e nível de vitória. Um parágrafo, com o caminho do relatório e o commit.

- [ ] **Step 3: Checkpoint.** Não apague relatórios existentes.

---

### Tarefa 4: `TestLoadoutBuilds` deixa de fixar "18 combinações"

Cada herói ganha builds (`controle`, `velocidade`, variantes `*_sig`), então o número de combinações muda a cada plano. O teste passa a comparar com o produto calculado de `SliceSession.BUILD_OPTIONS`.

**Files:**
- Modify: `tests/unit/test_loadout_builds.gd` (linha 43 e o bloco `_test_every_combination_builds_a_run`, linhas ~50–59)

- [ ] **Step 1: Trocar as duas constantes 18**

Em `test_loadout_builds.gd`, substituir

```gdscript
	_expect("18 combinações (3 × 2 × 3)", total == 18)
```

por

```gdscript
	var expected_total := 1
	for hero_id in SliceSession.BUILD_OPTIONS:
		expected_total *= SliceSession.BUILD_OPTIONS[hero_id].size()
	_expect("o total de combinações é o produto das opções por herói (%d)" % expected_total, total == expected_total and total >= 18)
```

e, no fim de `_test_every_combination_builds_a_run`, substituir

```gdscript
	_expect("as 18 combinações criam uma run válida", made == 18)
```

por

```gdscript
	var expected_runs := SliceSession.BUILD_OPTIONS["hero_001"].size() * SliceSession.BUILD_OPTIONS["hero_002"].size() * SliceSession.BUILD_OPTIONS["hero_003"].size()
	_expect("todas as %d combinações criam uma run válida" % expected_runs, made == expected_runs)
```

- [ ] **Step 2: Rodar** — `TestLoadoutBuilds.tscn`; Expected: PASS com 18 (nada mudou ainda).

- [ ] **Step 3: Checkpoint.**

Regra para os planos 01–03: **todo build novo** entra em `SliceSession.BUILD_OPTIONS` e `BUILD_LABELS` (`scripts/combat/SliceSession.gd`), com rótulo em português, e a tela de loadout (UI_S04) precisa continuar cabendo em 432×960 (rodar `TestSliceCampaignScreen` e `TestHubScreen`).

---

### Tarefa 5: Ajudantes de combate compartilhados (`_alive_targets`, `_reduce_cooldown`)

Os planos 02 e 03 usam os dois; definidos aqui uma única vez.

**Files:**
- Modify: `scripts/combat/ExpeditionRun.gd`
- Test: `tests/unit/test_kit_support.gd`

**Interfaces:**
- Produces:
  - `func _alive_targets() -> Array` — inimigos vivos e alvejáveis, na ordem da fila (o primeiro é o alvo prioritário).
  - `func _reduce_cooldown(hero: Dictionary, skill_id: String, seconds: float) -> void` — encurta a recarga restante (nunca abaixo de `time`) e rearma o aviso `ready_seen`.

- [ ] **Step 1: Teste (falha)** — em `test_kit_support.gd`, antes do `print` final:

```gdscript
	var helpers := KitTestSupport.mk([["hero_001", ["skill_bas_007"], []]], [{"enemy_id": "en_c1_001", "count": 3}])
	KitTestSupport.spawn(helpers)
	_expect("_alive_targets lista 3 inimigos", helpers._alive_targets().size() == 3)
	helpers._enemies[0]["alive"] = false
	_expect("_alive_targets ignora mortos", helpers._alive_targets().size() == 2)
	var bast: Dictionary = helpers._heroes["hero_001"]
	bast["skills"][0]["ready_at"] = helpers.time + 10.0
	helpers._reduce_cooldown(bast, "skill_bas_007", 3.0)
	_expect("_reduce_cooldown tira 3 s", absf(float(bast["skills"][0]["ready_at"]) - (helpers.time + 7.0)) < 0.001)
	helpers._reduce_cooldown(bast, "skill_bas_007", 100.0)
	_expect("_reduce_cooldown nunca passa de agora", absf(float(bast["skills"][0]["ready_at"]) - helpers.time) < 0.001)
```

- [ ] **Step 2: Falha esperada** — `Nonexistent function '_alive_targets'`.

- [ ] **Step 3: Implementar** — em `ExpeditionRun.gd`, perto de `_nth_alive_enemy`:

```gdscript
## Inimigos vivos e alvejáveis, na ordem da fila (o primeiro é o alvo prioritário).
func _alive_targets() -> Array:
	return _enemies.filter(func(e): return e["alive"] and bool(e.get("targetable", true)))

## Encurta a recarga restante de uma skill do herói (nunca abaixo de agora).
func _reduce_cooldown(hero: Dictionary, skill_id: String, seconds: float) -> void:
	for sk in hero["skills"]:
		if sk["def"]["id"] == skill_id and float(sk["ready_at"]) > time + EPS:
			sk["ready_at"] = maxf(time, float(sk["ready_at"]) - seconds)
			sk["ready_seen"] = false
```

- [ ] **Step 4: Passar** — `TestKitSupport.tscn` e `python tools/run_godot_tests.py`.

- [ ] **Step 5: Checkpoint.**

---

## Decisões que dependem de Rafael (parar e perguntar quando chegar nelas)

1. **Signature no slot (DECIDIDO por Rafael em 2026-09-30):** a Signature ocupa um **terceiro slot fixo** por herói (`"signature"` em `heroes.json`; o motor a acrescenta às 2 skills da build). **Não existem variantes `_sig`.** Cada build continua com 2 skills; a Signature é do herói.
2. **Íris**: a 5ª skill e a Signature não existem no design. O Plano 03 propõe nomes e números como **RECOMENDADO**; a Tarefa I0 pede a escolha.
3. **Guarda do Bastião** entra em runtime (Plano 01, Tarefa B1). Isso reativa cláusulas hoje "dormentes" (Contra-Golpe R3). Recomendação: entrar.
