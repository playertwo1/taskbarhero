# Kit completo da Íris — Plano 03

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans. Os passos usam checkbox (`- [ ]`). **Pré-requisito:** Plano 00 (Tarefas 1–5) concluído. **A Tarefa I0 é um portão de decisão de Rafael:** não implemente antes dela.

**Meta:** levar a Íris (`hero_003`) de 4 skills / 5 passivas / 2 Traits / 3 builds (Lúmen sem passivas) para o kit do [HERO_STANDARD](../../docs/02_heroes/HERO_STANDARD.md): 6 skills (com Pulso Restaurador promovido e uma Signature), 16 passivas, 3 Traits e 3 builds completas.

**Arquitetura:** Íris é a herdeira de "Marca + Desequilíbrio" (alvo *preparado*). A Signature (`skill_iri_006`) é um efeito novo `convergence`; as 11 passivas novas e o 3º Trait são `kind`s pequenos sobre ganchos existentes (`_skill_hit`, `_after_skill`, casos `heal`, `shield` e `enemy_debuff` de `_cast`). O design do kit **não existe além do "kit mínimo"**, então a Tarefa I1 escreve o design (status `DESIGN`/`HIPOTESE`) antes do código.

**Tecnologias:** GDScript 4.7.2, JSON, testes headless com `KitTestSupport`.

**Spec:** [hero_003_iris.md](../../docs/02_heroes/hero_003_iris.md), [kit mínimo do slice](../../docs/02_heroes/hero_003_iris_slice_kit.md) (a atualizar na I1), [proposta de combate](../../docs/06_balance/v1/03_SKILLS_PASSIVAS.md).

## Restrições globais

- **Signature no 3º slot (DECIDIDO por Rafael em 2026-09-30).** O herói tem `"signature": "<skill>"` em `heroes.json` e o motor a acrescenta às 2 skills da build. **Ignore qualquer menção a variantes `*_sig` neste plano:** elas não existem; cada herói mantém só as 3 builds (2 skills cada).

Todas as do [Plano 00](2026-09-30-kits-completos-00-fundacao.md#restrições-globais). Adicionais:

- **DECIDIDO** só o que já está em `hero_003_iris_slice_kit.md`. Tudo abaixo (Signature, 5ª skill, passivas A3–C5, 3º Trait, nomes) é **RECOMENDADO**/**HIPÓTESE** até Rafael escolher na Tarefa I0.
- IDs novos seguem o registro: `SKILL_IRI_006` (Signature), `PASS_IRI_006`–`PASS_IRI_016`, `TRAIT_IRI_003`; runtime `skill_iri_006`, `pass_iri_006`…`pass_iri_016`, `trait_iri_003`. `skill_iri_004` (Pulso Restaurador) já existe nos dados como experimento.
- O bônus da identidade Sensível ao Lúmen continua **EM ABERTO** no design; não alterar o +10% de simulação nesta fase.

## Estrutura de arquivos

- Modify `docs/02_heroes/hero_003_iris_slice_kit.md` — vira o kit completo (I1).
- Modify `data/heroes/heroes.json`, `data/skills/skills_slice.json`, `data/skills/passives_slice.json`.
- Modify `scripts/combat/ExpeditionRun.gd`, `scripts/combat/SliceSession.gd`.
- Create `tests/unit/test_kit_iris.gd`, `tests/unit/TestKitIris.tscn`.
- Modify `docs/CONTENT_REGISTRY.md`, `docs/04_content/chapters/chapter_01/SLICE_1_SCOPE.md` (Pulso passa ao recorte).

---

### Tarefa I0: Portão de decisão (Rafael)

- [ ] **Step 1: Perguntar a Rafael** (uma pergunta por decisão, com a recomendação primeiro):

1. **Pulso Restaurador entra no recorte?** Recomendado: **sim**, como 5ª skill normal (`SKILL_IRI_004`) — já existe com números medidos no [v1 · perfil do Capítulo 1](../../docs/06_balance/v1/capitulos/CAPITULO_01.md) e sustenta a build Lúmen. Alternativa: manter fora e a Íris ficar com 4 skills + Signature (kit de 5).
2. **Signature.** Recomendado: **Convergência de Lúmen** (`SKILL_IRI_006`): salva de 2,2×ATK no alvo prioritário e 1,0×ATK nos demais, +50% contra alvos preparados (marcados ou Desequilibrados); CD 30 s. Alternativas: uma Signature de suporte (escudo em massa) ou de controle (atordoamento em área).
3. **3º Trait (build Lúmen).** Recomendado: **Chama Viva** (`TRAIT_IRI_003`): cura e escudos da Íris dão +10% de ATK ao receptor por 4 s. Alternativa: cura que reduz a recarga do Prisma.
4. **Signature no slot.** DECIDIDO por Rafael em 2026-09-30: 3º slot fixo (sem variantes `*_sig`).

- [ ] **Step 2: Registrar** as respostas no topo deste plano (seção "Decisões tomadas") e seguir. Se Rafael escolher alternativas, ajustar apenas as tabelas das Tarefas I2–I6, mantendo a mesma estrutura.

---

### Tarefa I1: Escrever o design do kit completo (documento)

**Files:** Modify `docs/02_heroes/hero_003_iris_slice_kit.md`.

- [ ] **Step 1: Reescrever o documento** mantendo o cabeçalho de status e as seções existentes, e acrescentando:
  - a tabela de skills 1–5 + Signature (IDs `SKILL_IRI_001`–`006`) com intenção, gatilho e recarga (valores das Tarefas I2/I3 como **HIPÓTESE**);
  - as três builds (Arcano, Controle, Lúmen) com as 5 passivas de cada uma (tabelas das Tarefas I4–I6, colunas ID, nome, efeito de design, tradução do slice);
  - o 3º Trait;
  - a seção "Pendências e limites" atualizada: marcar como resolvidos "nós A3–A5, B3–B5, passivas C, Trait Lúmen" e manter **EM ABERTO** Mastery, missões pessoais e o bônus exato da identidade.

- [ ] **Step 2: Verificar** — `grep -c "PASS_IRI_0" docs/02_heroes/hero_003_iris_slice_kit.md` (esperado ≥ 16 entre nós e referências) e `python tools/run_godot_tests.py` (nada de código mudou; suíte continua verde).

- [ ] **Step 3: Checkpoint.**

---

### Tarefa I2: Signature — Convergência de Lúmen (`skill_iri_006`)

Salva de 2,2×ATK no alvo prioritário e 1,0×ATK em cada outro inimigo vivo; alvos preparados (marcados ou Desequilibrados) sofrem +50%. CD 30 s, gatilho `enemies_alive`. R2: +40 de Stagger no alvo prioritário. R3: os aliados ganham +8% de ATK por 4 s.

**Files:** Modify `data/skills/skills_slice.json`, `ExpeditionRun.gd` (`_cast`); Create `tests/unit/test_kit_iris.gd` + `.tscn`.

**Interfaces:**
- Consumes: `_alive_targets` (Plano 00, T5), `_skill_hit`, `_damage_bonus` (já soma `fx["bonus_vs_prepared"]` contra alvo preparado).
- Produces: efeito `"convergence"` com `primary_coefficient, coefficient, prepared_bonus, stagger, ally_atk_bonus?, ally_duration?`.

- [ ] **Step 1: Dados**

```json
  {
    "id": "skill_iri_006",
    "design_id": "SKILL_IRI_006",
    "hero": "hero_003",
    "name": "Convergência de Lúmen",
    "content_set": "slice",
    "status": "HIPOTESE",
    "cooldown": 30.0,
    "trigger": {"type": "enemies_alive"},
    "effects": [
      {"type": "convergence", "primary_coefficient": 2.2, "coefficient": 1.0, "prepared_bonus": 0.5, "stagger": 30.0}
    ],
    "source": "Recomendação da Tarefa I0 do Plano 03 (aprovada por Rafael em <data>); expressão máxima de 'alvo preparado' do trio; números HIPÓTESE",
    "ranks": {
      "2": {"set": {"0.stagger": 70.0}},
      "3": {"set": {"0.ally_atk_bonus": 0.08, "0.ally_duration": 4.0}}
    },
    "ranks_source": "Plano 03 (R2 +40 de Stagger no principal; R3 bônus de equipe). HIPÓTESE"
  },
```

(Trocar `<data>` pela data da decisão de Rafael.)

- [ ] **Step 2: Teste (falha)** — `tests/unit/test_kit_iris.gd`:

```gdscript
extends Node

var success := true

func _expect(label: String, cond: bool) -> void:
	if cond:
		print("[PASS] ", label)
	else:
		print("FALHA: ", label)
		success = false

func _check(label: String, actual: float, expected: float, eps: float = 0.001) -> void:
	_expect("%s = %.4f (esperado %.4f)" % [label, actual, expected], absf(actual - expected) <= eps)

func _ready() -> void:
	print("--- TESTE KIT DA ÍRIS ---")
	KitTestSupport.load_all()
	_test_convergence()
	print("[PASS] TESTE KIT DA ÍRIS CONCLUÍDO" if success else "[FAIL] TESTE KIT DA ÍRIS")
	get_tree().quit(0 if success else 1)

func _cast_now(run: ExpeditionRun, hero_id: String, index: int) -> Array:
	var events: Array = []
	var hero: Dictionary = run._heroes[hero_id]
	run._cast(hero, hero["skills"][index], events)
	return events

func _test_convergence() -> void:
	print("\n>>> I2. CONVERGÊNCIA DE LÚMEN")
	var never := {"skill_iri_006": {"type": "enemy_telegraph"}}
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_006"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	run._enemies[2]["marked_until"] = 99.0
	var hits := KitTestSupport.damages(_cast_now(run, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_006")
	_expect("1 golpe por inimigo vivo", hits.size() == 3)
	_check("principal = 2,2 × outros (mesma DEF)", hits[0] / hits[1], 2.2, 0.0005)
	_check("alvo marcado sofre +50%", hits[2] / hits[1], 1.5, 0.0005)
	var r3 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_006"], []]], [{"enemy_id": "en_c1_001", "count": 1}], {"skill_iri_006": 3}, never)
	KitTestSupport.spawn(r3)
	KitTestSupport.tank(r3)
	var before := r3._stat(r3._heroes["hero_001"], "attack")
	_cast_now(r3, "hero_003", 0)
	_check("R3: aliados +8% de ATK", r3._stat(r3._heroes["hero_001"], "attack") / before, 1.08, 0.0005)
```

`TestKitIris.tscn`: mesmo molde dos outros (`test_kit_iris.gd`, nó `TestKitIris`).

- [ ] **Step 3: Falha esperada** — efeito desconhecido; `hits.size()` = 0.

- [ ] **Step 4: Implementar** — caso em `_cast`:

```gdscript
			"convergence":
				var pool := _alive_targets()
				for i in pool.size():
					var enemy: Dictionary = pool[i]
					var coefficient := float(fx["primary_coefficient"]) if i == 0 else float(fx["coefficient"])
					var hit_fx := {"bonus_vs_prepared": float(fx["prepared_bonus"])}
					if i == 0:
						hit_fx["stagger"] = float(fx["stagger"])
					_skill_hit(hero, enemy, coefficient, def["id"], events, hit_fx)
				if float(fx.get("ally_atk_bonus", 0.0)) > 0.0:
					for hid in _hero_order:
						if hid != hero["id"] and _heroes[hid]["alive"]:
							_heroes[hid]["effects"].append({"source": def["id"], "stat": "attack", "op": "ADD_PERCENT", "value": float(fx["ally_atk_bonus"]),
								"started_at": time, "expires_at": time + float(fx["ally_duration"])})
```

- [ ] **Step 5: Passar; Step 6: `python tools/run_godot_tests.py`; checkpoint.**

---

### Tarefa I3: Pulso Restaurador entra no recorte (`skill_iri_004`)

Sem mudança de números (0,3×ATK, CD 16 s, gatilho aliado ≤ 85%): a skill já existe. Esta tarefa só a **promove**: `status`, `source` e ranks.

**Files:** Modify `data/skills/skills_slice.json` (`skill_iri_004`), `docs/04_content/chapters/chapter_01/SLICE_1_SCOPE.md`.

- [ ] **Step 1: Teste (falha)** — em `test_kit_iris.gd`:

```gdscript
func _test_pulse_ranks() -> void:
	print("\n>>> I3. PULSO RESTAURADOR")
	var row: Dictionary = KitTestSupport.skill_rows.filter(func(r): return r["id"] == "skill_iri_004")[0]
	_expect("Pulso tem ranks 2–5 definidos", row.has("ranks") and row["ranks"].size() == 4)
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {"hero_001": 2000.0})
	var events := KitTestSupport.spawn(run)
	var heals := KitTestSupport.of(events, "healing")
	_expect("cura o aliado abaixo de 85% ao começar", heals.size() == 1 and absf(float(heals[0]["amount"]) - float(run._heroes["hero_003"]["stats"]["attack"]) * 0.3) < 0.01)
```

Ligar em `_ready`.

- [ ] **Step 2: Falha esperada** — `skill_iri_004` não tem `ranks`.

- [ ] **Step 3: Dados** — no objeto `skill_iri_004`, atualizar `source` para citar a decisão de Rafael (I0) e acrescentar:

```json
    "ranks": {
      "2": {"set": {"0.coefficient": 0.33}},
      "3": {"set": {"0.second_fraction": 0.5}},
      "4": {"set": {"0.coefficient": 0.36}},
      "5": {"set": {"0.overheal_shield": 0.5}}
    },
    "ranks_source": "Plano 03 (R2/R4 +10% de cura; R3 cura também o 2º aliado com 50%; R5 excedente vira escudo de 50%). HIPÓTESE"
```

Os campos `second_fraction` e `overheal_shield` são lidos na Tarefa I6.

- [ ] **Step 4: Passar; Step 5: atualizar `SLICE_1_SCOPE.md`** (a Íris passa a ter Pulso no recorte) e checkpoint.

---

### Tarefa I4: Build A (Arcano) — A3, A4, A5

| ID (runtime) | Nome | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- | --- |
| `pass_iri_006` | Eco de Cristal (A3) | a Lança de Lúmen que acerta um alvo preparado reduz em 1 s a própria recarga | `skill_cd_on_prepared` `{"skill":"skill_iri_001","cd_reduce":1.0}` | 4 |
| `pass_iri_007` | Prisma Ressonante (A4) | Prisma de Retorno causa +15% se houver 2+ inimigos vivos | `skill_bonus_multi` `{"skill":"skill_iri_005","value":0.15,"min_enemies":2}` | 7 |
| `pass_iri_008` | Convergência Arcana (A5) | depois de lançar o Prisma, a próxima Lança em até 8 s causa +40% (uma vez) | `prism_then_lance` `{"prism":"skill_iri_005","lance":"skill_iri_001","value":0.4,"window":8.0}` | 10 |

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_after_skill`, `_skill_hit`); Test `test_kit_iris.gd`.

**Interfaces:**
- Produces: `func _skill_passive_multiplier(hero: Dictionary, skill_id: String) -> float` (multiplicador aplicado ao golpe de skill; consome `lance_boost` quando usado).

- [ ] **Step 1: Dados** — 3 linhas, molde:

```json
  {"id": "pass_iri_006", "design_id": "PASS_IRI_006", "hero": "hero_003", "name": "Eco de Cristal", "content_set": "slice", "status": "HIPOTESE", "unlock_level": 4, "kind": "skill_cd_on_prepared", "params": {"skill": "skill_iri_001", "cd_reduce": 1.0}, "source": "Plano 03, Tarefa I4 (A3 da build Arcano; RECOMENDADO por Claude, aprovado por Rafael na I0); números HIPÓTESE"},
```

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_a() -> void:
	print("\n>>> I4. BUILD ARCANO (A3–A5)")
	var never := {"skill_iri_001": {"type": "enemy_telegraph"}, "skill_iri_005": {"type": "enemy_telegraph"}}
	# A3
	var a3 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_001"], ["pass_iri_006"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 4)
	KitTestSupport.spawn(a3)
	KitTestSupport.tank(a3)
	a3._enemies[0]["marked_until"] = 99.0
	_cast_now(a3, "hero_003", 0)
	var cd_prepared := float(a3._heroes["hero_003"]["skills"][0]["ready_at"]) - a3.time
	var a3b := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_001"], ["pass_iri_006"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 4)
	KitTestSupport.spawn(a3b)
	KitTestSupport.tank(a3b)
	_cast_now(a3b, "hero_003", 0)
	var cd_plain := float(a3b._heroes["hero_003"]["skills"][0]["ready_at"]) - a3b.time
	_check("A3: 1 s a menos contra alvo preparado", cd_plain - cd_prepared, 1.0)
	# A4: Prisma +15% com 2+ inimigos, igual com 1.
	var dmg: Array = []
	for count in [1, 2]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_005"], ["pass_iri_007"]]], [{"enemy_id": "en_c1_001", "count": count}], {}, never, {}, 7)
		KitTestSupport.spawn(run)
		KitTestSupport.tank(run)
		dmg.append(KitTestSupport.damages(_cast_now(run, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_005")[0])
	_check("A4: +15% quando há 2 inimigos", dmg[1] / dmg[0], 1.15, 0.0005)
	# A5: Prisma arma +40% na próxima Lança, uma vez.
	var a5 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_001", "skill_iri_005"], ["pass_iri_008"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 10)
	KitTestSupport.spawn(a5)
	KitTestSupport.tank(a5)
	var plain_lance := KitTestSupport.damages(_cast_now(a5, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_001")[0]
	_cast_now(a5, "hero_003", 1)
	var boosted := KitTestSupport.damages(_cast_now(a5, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_001")[0]
	_check("A5: Lança depois do Prisma causa +40%", boosted / plain_lance, 1.4, 0.0005)
	var again := KitTestSupport.damages(_cast_now(a5, "hero_003", 0), "skill_damage", "hero_003", "skill_iri_001")[0]
	_check("A5: só uma vez", again / plain_lance, 1.0, 0.0005)
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar**

```gdscript
## Multiplicador de passivas sobre o golpe de uma skill (Prisma Ressonante e Convergência Arcana).
func _skill_passive_multiplier(hero: Dictionary, skill_id: String) -> float:
	var mult := 1.0
	var multi: Dictionary = hero["passives"].get("skill_bonus_multi", {})
	if not multi.is_empty() and multi["skill"] == skill_id and _alive_targets().size() >= int(multi["min_enemies"]):
		mult += float(multi["value"])
	var chain: Dictionary = hero["passives"].get("prism_then_lance", {})
	if not chain.is_empty() and chain["lance"] == skill_id and float(hero.get("lance_boost_until", -INF)) > time + EPS:
		mult += float(chain["value"])
		hero["lance_boost_until"] = -INF
	return mult
```

Em `_skill_hit`, na linha do `var raw := ...`, multiplicar por `* _skill_passive_multiplier(hero, skill_id)`. Atenção: o golpe secundário da Lança (Dispersão) chama `_skill_hit` com o mesmo `skill_id` e **não** recebe o bônus porque ele foi consumido no primeiro golpe — comportamento aceito e documentado.

Em `_after_skill`:

```gdscript
	var echo: Dictionary = p.get("skill_cd_on_prepared", {})
	if not echo.is_empty() and echo["skill"] == def["id"] and was_prepared:
		_reduce_cooldown(hero, String(echo["skill"]), float(echo["cd_reduce"]))
	var chain: Dictionary = p.get("prism_then_lance", {})
	if not chain.is_empty() and chain["prism"] == def["id"]:
		hero["lance_boost_until"] = time + float(chain["window"])
```

Em `create` (dicionário do herói): `"lance_boost_until": -INF,`.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa I5: Build B (Controle) — B3, B4, B5

| ID | Nome | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- | --- |
| `pass_iri_009` | Micélio Denso (B3) | Véu de Micélio: +25% de escudo em aliado com HP ≤ 40% | `shield_bonus_low` `{"skill":"skill_iri_002","threshold":0.4,"value":0.25}` | 4 |
| `pass_iri_010` | Fratura Profunda (B4) | a Fratura Arcana também reduz o ATK do alvo em 10% pela duração da fratura | `skill_atk_debuff` `{"skill":"skill_iri_003","value":0.10}` | 7 |
| `pass_iri_011` | Teia Total (B5) | a Fratura Arcana também reduz a DEF dos demais inimigos com 50% da força | `debuff_all` `{"skill":"skill_iri_003","fraction":0.5}` | 10 |

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_cast` casos `shield` e `enemy_debuff`); Test `test_kit_iris.gd`.

- [ ] **Step 1: Dados** — 3 linhas com o molde da I4.

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_b() -> void:
	print("\n>>> I5. BUILD CONTROLE (B3–B5)")
	var never := {"skill_iri_003": {"type": "enemy_telegraph"}}
	# B3: aliado a 30% de HP recebe escudo maior.
	var shields: Array = []
	for passives in [[], ["pass_iri_009"]]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_002"], passives]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {"hero_001": 1500.0}, 4)
		var ev := KitTestSupport.spawn(run)
		var granted := KitTestSupport.of(ev, "shield_granted")
		shields.append(float(granted[0]["amount"]) if not granted.is_empty() else -1.0)
	_check("B3: escudo +25% em aliado a 30% de HP", shields[1] / shields[0], 1.25, 0.0005)
	# B4: Fratura reduz o ATK do alvo em 10%.
	var b4 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_003"], ["pass_iri_010"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 7)
	KitTestSupport.spawn(b4)
	KitTestSupport.tank(b4)
	_cast_now(b4, "hero_003", 0)
	_check("B4: ATK do alvo −10%", float(b4._enemies[0]["atk_debuff"]), 0.10)
	_expect("B4: dura o mesmo que a fratura", absf(float(b4._enemies[0]["atk_debuff_until"]) - float(b4._enemies[0]["defense_debuff_until"])) < 0.001)
	# B5: os demais inimigos recebem metade do debuff de DEF.
	var b5 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_003"], ["pass_iri_011"]]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never, {}, 10)
	KitTestSupport.spawn(b5)
	KitTestSupport.tank(b5)
	_cast_now(b5, "hero_003", 0)
	_check("B5: principal −15% de DEF", float(b5._enemies[0]["defense_debuff"]), -0.15)
	_check("B5: demais −7,5% de DEF", float(b5._enemies[1]["defense_debuff"]), -0.075)
	_check("B5: 3º inimigo também", float(b5._enemies[2]["defense_debuff"]), -0.075)
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar** — caso `"enemy_debuff"` de `_cast` (mantendo a extensão de Fissura já existente):

```gdscript
					target["defense_debuff"] = float(fx["value"])
					target["defense_debuff_until"] = time + duration
					var atk_cfg: Dictionary = hero["passives"].get("skill_atk_debuff", {})
					if not atk_cfg.is_empty() and atk_cfg["skill"] == def["id"]:
						target["atk_debuff"] = maxf(float(target.get("atk_debuff", 0.0)), float(atk_cfg["value"]))
						target["atk_debuff_until"] = time + duration
					var all_cfg: Dictionary = hero["passives"].get("debuff_all", {})
					if not all_cfg.is_empty() and all_cfg["skill"] == def["id"]:
						for other in _alive_targets():
							if other["uid"] != target["uid"]:
								other["defense_debuff"] = float(fx["value"]) * float(all_cfg["fraction"])
								other["defense_debuff_until"] = time + duration
```

Caso `"shield"` de `_cast`: depois de escolher `ally`, calcular a fração efetiva:

```gdscript
					var fraction := float(fx["fraction"])
					var low: Dictionary = hero["passives"].get("shield_bonus_low", {})
					if not low.is_empty() and low["skill"] == def["id"] and float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(low["threshold"]) + EPS:
						fraction *= 1.0 + float(low["value"])
```

e passar `fraction` (em vez de `float(fx["fraction"])`) a `_grant_shield`.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa I6: Build C (Lúmen) — C1–C5 e Trait Chama Viva

| ID | Nome | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- | --- |
| `pass_iri_012` | Luz Constante (C1) | Pulso Restaurador cura +10% | `skill_heal_bonus` `{"skill":"skill_iri_004","value":0.10}` | 1 |
| `pass_iri_013` | Pulso Duplo (C2) | o Pulso também cura o 2º aliado mais ferido com 50% do valor | `heal_second` `{"skill":"skill_iri_004","fraction":0.5}` | 1 |
| `pass_iri_014` | Cristal de Cura (C3) | o excedente da cura vira escudo de 50% (máx. 10% do HP máximo do aliado, 6 s) | `overheal_shield` `{"fraction":0.5,"cap":0.10,"duration":6.0}` | 4 |
| `pass_iri_015` | Lúmen Prolongado (C4) | o Véu de Micélio dura +2 s | `skill_duration` `{"skill":"skill_iri_002","extra":2.0}` | 7 |
| `pass_iri_016` | Fonte de Lúmen (C5) | quando um aliado cai abaixo de 25% de HP, o Pulso volta a ficar pronto (1 vez a cada 30 s) | `heal_reset` `{"skill":"skill_iri_004","threshold":0.25,"cooldown":30.0}` | 10 |
| `trait_iri_003` | Chama Viva | cura e escudos da Íris dão +10% de ATK ao receptor por 4 s | `support_atk_bonus` `{"skills":["skill_iri_004","skill_iri_002"],"value":0.10,"duration":4.0}` | 1 |

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_cast` casos `heal` e `shield`, `_enemy_attack`); Test `test_kit_iris.gd`.

- [ ] **Step 1: Dados** — 6 linhas.

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_c() -> void:
	print("\n>>> I6. BUILD LÚMEN (C1–C5 e Chama Viva)")
	var pulse := {"skill_iri_004": {"type": "enemy_telegraph"}}
	# C1 e C2.
	var base := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []], ["hero_003", ["skill_iri_004"], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 1000.0, "hero_002": 2000.0})
	KitTestSupport.spawn(base)
	var plain := KitTestSupport.of(_cast_now(base, "hero_003", 0), "healing")
	var kit := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []], ["hero_003", ["skill_iri_004"], ["pass_iri_012", "pass_iri_013"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 1000.0, "hero_002": 2000.0}, 1)
	KitTestSupport.spawn(kit)
	var boosted := KitTestSupport.of(_cast_now(kit, "hero_003", 0), "healing")
	_check("C1: +10% de cura", float(boosted[0]["amount"]) / float(plain[0]["amount"]), 1.1, 0.0005)
	_expect("C2: 2º aliado também é curado", boosted.size() == 2)
	_check("C2: 50% do valor", float(boosted[1]["amount"]) / float(boosted[0]["amount"]), 0.5, 0.0005)
	# C3: excedente vira escudo.
	var c3 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], ["pass_iri_014"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 3000.0}, 4)
	KitTestSupport.spawn(c3)
	c3._heroes["hero_003"]["stats"]["attack"] = 10000.0
	var ev3 := _cast_now(c3, "hero_003", 0)
	var shield_events := KitTestSupport.of(ev3, "shield_granted")
	_expect("C3: cura o que falta (2000) e o excedente vira escudo", KitTestSupport.of(ev3, "healing").size() == 1 and shield_events.size() == 1)
	_check("C3: escudo = min(50% do excedente = 500, 10% de 5000 = 500)", float(shield_events[0]["amount"]), 500.0, 0.01)
	# C4: Véu dura +2 s.
	var c4 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_002"], ["pass_iri_015"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_iri_002": {"type": "enemy_telegraph"}}, {"hero_001": 1000.0}, 7)
	KitTestSupport.spawn(c4)
	_cast_now(c4, "hero_003", 0)
	var veil: Dictionary = c4._heroes["hero_001"]["effects"].filter(func(e): return e["stat"] == "shield")[0]
	_check("C4: duração 6 + 2 s", float(veil["expires_at"]) - float(veil["started_at"]), 8.0)
	# C5: aliado cai abaixo de 25% → Pulso pronto.
	var c5 := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], ["pass_iri_016"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {}, 10)
	KitTestSupport.spawn(c5)
	_cast_now(c5, "hero_003", 0)
	_expect("C5: Pulso em recarga", float(c5._heroes["hero_003"]["skills"][0]["ready_at"]) > c5.time)
	c5._heroes["hero_001"]["hp"] = 500.0
	c5._check_fountain(c5._heroes["hero_001"], [])
	_check("C5: Pulso volta a ficar pronto", float(c5._heroes["hero_003"]["skills"][0]["ready_at"]), c5.time, 0.001)
	# Trait Chama Viva: a cura dá +10% de ATK ao receptor.
	var trait_run := KitTestSupport.mk([["hero_001", [], []], ["hero_003", ["skill_iri_004"], ["trait_iri_003"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, pulse, {"hero_001": 1000.0}, 1)
	KitTestSupport.spawn(trait_run)
	var atk_before := trait_run._stat(trait_run._heroes["hero_001"], "attack")
	_cast_now(trait_run, "hero_003", 0)
	_check("Trait: receptor com +10% de ATK", trait_run._stat(trait_run._heroes["hero_001"], "attack") / atk_before, 1.1, 0.0005)
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar**

Caso `"heal"` de `_cast` — reescrever o corpo assim:

```gdscript
			"heal":
				var ally := _lowest_hp_ally(float(fx.get("threshold", 1.0)))
				if not ally.is_empty():
					var coefficient := float(fx["coefficient"])
					var bonus: Dictionary = hero["passives"].get("skill_heal_bonus", {})
					if not bonus.is_empty() and bonus["skill"] == def["id"]:
						coefficient *= 1.0 + float(bonus["value"])
					var wanted: float = _stat(hero, "attack") * coefficient
					var amount: float = minf(wanted, float(ally["stats"]["max_hp"]) - float(ally["hp"]))
					ally["hp"] = float(ally["hp"]) + amount
					events.append({"type": "healing", "time": time, "source": hero["id"], "target": ally["id"], "amount": amount})
					for e in _enemies:
						if e["alive"]:
							e["threat"][hero["id"]] = float(e["threat"].get(hero["id"], 0.0)) + amount * ThreatMath.HEAL_THREAT
					var second_cfg: Dictionary = hero["passives"].get("heal_second", {})
					if not second_cfg.is_empty() and second_cfg["skill"] == def["id"]:
						var second := _lowest_hp_ally(1.0, ally["id"])
						if not second.is_empty():
							var extra: float = minf(amount * float(second_cfg["fraction"]), float(second["stats"]["max_hp"]) - float(second["hp"]))
							second["hp"] = float(second["hp"]) + extra
							events.append({"type": "healing", "time": time, "source": hero["id"], "target": second["id"], "amount": extra})
					var over: Dictionary = hero["passives"].get("overheal_shield", {})
					if not over.is_empty() and wanted > amount:
						var shield_amount := minf((wanted - amount) * float(over["fraction"]), float(over["cap"]) * float(ally["stats"]["max_hp"]))
						if shield_amount > 0.0:
							_grant_shield(hero, ally, shield_amount / float(ally["stats"]["max_hp"]), float(over["duration"]), def["id"], events)
					_support_bonus(hero, def["id"], ally)
```

Caso `"shield"` — depois de `_grant_shield(...)`: `_support_bonus(hero, def["id"], ally)`; e o `duration` do escudo passa a somar `skill_duration.extra` quando `skill_duration.skill == def["id"]`.

Funções novas:

```gdscript
## Chama Viva: cura/escudo dão +ATK ao receptor por um tempo.
func _support_bonus(hero: Dictionary, skill_id: String, receiver: Dictionary) -> void:
	var cfg: Dictionary = hero["passives"].get("support_atk_bonus", {})
	if cfg.is_empty() or not cfg["skills"].has(skill_id):
		return
	receiver["effects"].append({"source": "trait_iri_003", "stat": "attack", "op": "ADD_PERCENT", "value": float(cfg["value"]),
		"started_at": time, "expires_at": time + float(cfg["duration"])})

## C5 (Fonte de Lúmen): aliado abaixo do limiar refaz o Pulso (recarga longa entre usos).
func _check_fountain(ally: Dictionary, events: Array) -> void:
	for hid in _hero_order:
		var healer: Dictionary = _heroes[hid]
		var cfg: Dictionary = healer["passives"].get("heal_reset", {})
		if cfg.is_empty() or not healer["alive"] or float(healer.get("fountain_ready_at", -INF)) > time + EPS:
			continue
		if float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(cfg["threshold"]) + EPS:
			healer["fountain_ready_at"] = time + float(cfg["cooldown"])
			_reduce_cooldown(healer, String(cfg["skill"]), 1000.0)
```

Chamar `_check_fountain(hero, events)` em `_enemy_attack`, logo depois de `hero["hp"] = maxf(0.0, ...)` quando `hero["hp"] > 0`.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa I7: Builds, rótulos, registro e verificação do kit

**Files:** Modify `data/heroes/heroes.json`, `scripts/combat/SliceSession.gd`, `docs/CONTENT_REGISTRY.md`; Test `test_kit_iris.gd`.

- [ ] **Step 1: Builds e Signature da Íris** (`hero_003`): `"signature": "skill_iri_006"` e

```json
"builds": {
  "arcano":   {"name": "Arcano",   "skills": ["skill_iri_001", "skill_iri_005"], "passives": ["pass_iri_002", "pass_iri_003", "pass_iri_006", "pass_iri_007", "pass_iri_008", "trait_iri_001"]},
  "controle": {"name": "Controle", "skills": ["skill_iri_003", "skill_iri_002"], "passives": ["pass_iri_004", "pass_iri_005", "pass_iri_009", "pass_iri_010", "pass_iri_011", "trait_iri_002"]},
  "lumen":    {"name": "Lúmen",    "skills": ["skill_iri_004", "skill_iri_002"], "passives": ["pass_iri_012", "pass_iri_013", "pass_iri_014", "pass_iri_015", "pass_iri_016", "trait_iri_003"]}
}
```

- [ ] **Step 2: `SliceSession.gd`** — `BUILD_OPTIONS["hero_003"]` permanece `["arcano", "controle", "lumen"]` (nada a alterar).

- [ ] **Step 3: Teste de integração** (mesmo desenho dos outros heróis)

```gdscript
func _test_full_kit() -> void:
	print("\n>>> I7. KIT COMPLETO")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var iris: Dictionary = heroes.filter(func(r): return r["id"] == "hero_003")[0]
	var skills := {}
	var passives := {}
	for b in iris["builds"].values():
		for s in b["skills"]:
			skills[s] = true
		for p in b["passives"]:
			passives[p] = true
	skills[String(iris["signature"])] = true
	_expect("6 skills distintas (001–006), a Signature no 3º slot", skills.size() == 6)
	_expect("15 passivas de build + Traits (001, 002, 003)", passives.size() >= 18)
	for build in iris["builds"]:
		for level in [1, 5, 10, 12]:
			var run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": "critico", "hero_003": build}, level, 3)
			run.run_to_end(0.25, 900.0)
			_expect("build %s nível %d roda até o fim" % [build, level], run.state == "won" or run.state == "lost")
```

- [ ] **Step 4: Registro** — `CONTENT_REGISTRY.md`: `SKILL_IRI_006`, `PASS_IRI_006`–`016`, `TRAIT_IRI_003` como `IMPLEMENTING`; `SKILL_IRI_004` passa a "no recorte".

- [ ] **Step 5: Rodar tudo** — `python tools/run_godot_tests.py`, `python tools/balance/validate_balance_data.py`, `python tools/argos/run.py --scenario slice_quick` (esperado: PASS, `Balance data: OK`, `0 BUG`). Atenção: a build `lumen` deixa de ser "experimental fora do recorte"; o `rules_slice.json` tem `min_paths_without: {"hero_003": "lumen"}` (caminhos viáveis **sem** a cura) — **não alterar a regra**; o Plano 04 verifica se ela continua satisfeita.

- [ ] **Step 6: Checkpoint.** Entregar ao Plano 04.
