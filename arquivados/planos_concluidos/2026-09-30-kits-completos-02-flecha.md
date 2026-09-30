# Kit completo da Flecha — Plano 02

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans. Os passos usam checkbox (`- [ ]`). **Pré-requisito:** Plano 00 (Tarefas 1–4) concluído.

**Meta:** levar a Flecha (`hero_002`) de 4 skills / 5 passivas / 2 Traits / 2 builds para o kit do [HERO_STANDARD](../../docs/02_heroes/HERO_STANDARD.md): 6 skills (com Ricochete e a Signature Chuva de Flechas), 16 passivas, 3 Traits (com Aljava em Movimento) e 3 builds (Crítico, Marca, Velocidade).

**Arquitetura:** Ricochete e Chuva de Flechas são dois efeitos novos de skill (`ricochet`, `arrow_rain`) sobre a lista de alvos vivos. As 11 passivas restantes são `kind`s pequenos ligados a ganchos existentes (`_hero_attack`, `_after_skill`, `_damage_enemy`, `_cast`). A chance de crítico é extraída para `_crit_chance(hero, enemy)` para ser testável sem RNG.

**Tecnologias:** GDScript 4.7.2, JSON, testes headless com `KitTestSupport`.

**Spec:** [FLECHA_SKILLS](../../docs/04_content/skills/FLECHA_SKILLS.md), [passivas](../../docs/02_heroes/hero_002_flecha_passives.md), [Traits](../../docs/02_heroes/hero_002_flecha_traits.md), [ficha](../../docs/02_heroes/hero_002_flecha.md).

## Restrições globais

- **Signature no 3º slot (DECIDIDO por Rafael em 2026-09-30).** O herói tem `"signature": "<skill>"` em `heroes.json` e o motor a acrescenta às 2 skills da build. **Ignore qualquer menção a variantes `*_sig` neste plano:** elas não existem; cada herói mantém só as 3 builds (2 skills cada).

Todas as do [Plano 00](2026-09-30-kits-completos-00-fundacao.md#restrições-globais). Adicionais:

- O design da Flecha **não tem números** (as fichas dizem "não foram atribuídos percentuais"): todos os valores abaixo são **HIPÓTESE de simulação**, com `"status": "HIPOTESE"` e a fonte citando a ficha e a decisão de tradução.
- O slice não tem posição: "linha de visão", "reposicionar" e "alcance" viram efeitos por alvo ou por tempo (registrar a tradução no `source`).
- Não criar atributo novo: precisão = chance de crítico; ritmo = velocidade de ataque; proteção = defesa/penetração pelo pipeline existente (`CombatMath`).
- `_on_crit(hero)` ganha o parâmetro opcional `enemy := {}`; os testes existentes que chamam `_on_crit(archer)` continuam válidos.

## Estrutura de arquivos

- Modify `data/heroes/heroes.json` — builds da Flecha.
- Modify `data/skills/skills_slice.json` — `skill_fle_010`, `skill_fle_011`.
- Modify `data/skills/passives_slice.json` — 10 passivas + 1 Trait.
- Modify `scripts/combat/ExpeditionRun.gd` — `_crit_chance`, `ricochet`, `arrow_rain` e ganchos.
- Modify `scripts/combat/SliceSession.gd` — `BUILD_OPTIONS`/`BUILD_LABELS`.
- Create `tests/unit/test_kit_flecha.gd`, `tests/unit/TestKitFlecha.tscn`.
- Modify `docs/CONTENT_REGISTRY.md`, `docs/04_content/skills/FLECHA_SKILLS.md` (pendências), `docs/02_heroes/hero_002_flecha_passives.md` (estado).

---

### Tarefa F0: Extrair `_crit_chance`

**Files:** Modify `scripts/combat/ExpeditionRun.gd`; Create `tests/unit/test_kit_flecha.gd` + `.tscn`.

**Interfaces:**
- Consumes: `_alive_targets()` (Plano 00, Tarefa 5).
- Produces: `func _crit_chance(hero: Dictionary, enemy: Dictionary) -> float` (não consome estado).

- [ ] **Step 1: Teste (falha)** — `test_kit_flecha.gd`:

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
	print("--- TESTE KIT DA FLECHA ---")
	KitTestSupport.load_all()
	_test_helpers()
	print("[PASS] TESTE KIT DA FLECHA CONCLUÍDO" if success else "[FAIL] TESTE KIT DA FLECHA")
	get_tree().quit(0 if success else 1)

func _test_helpers() -> void:
	print("\n>>> F0. AJUDANTES")
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 3}])
	KitTestSupport.spawn(run)
	var archer: Dictionary = run._heroes["hero_002"]
	archer["stats"]["crit_chance"] = 0.10
	_check("chance de crítico base", run._crit_chance(archer, run._enemies[0]), 0.10)
	run._enemies[0]["marked_until"] = 99.0
	_check("com a Marca do próprio herói e identidade: +0 (identidade só entra com a passiva equipada)", run._crit_chance(archer, run._enemies[0]), 0.10)
	_expect("_alive_targets lista os 3 inimigos", run._alive_targets().size() == 3)
	run._enemies[1]["alive"] = false
	_expect("_alive_targets ignora mortos", run._alive_targets().size() == 2)
```

`TestKitFlecha.tscn`: mesmo molde do `TestKitSupport.tscn` (nó `TestKitFlecha`, script `test_kit_flecha.gd`).

- [ ] **Step 2: Falha esperada** — `Invalid call. Nonexistent function '_crit_chance'`.

- [ ] **Step 3: Implementar** — em `ExpeditionRun.gd`, novas funções:

```gdscript
## Chance de crítico do ataque básico contra `enemy`: base, Instinto de Caçadora, Olho Aguçado R3, Leitura de Abertura e Ajuste Fino.
func _crit_chance(hero: Dictionary, enemy: Dictionary) -> float:
	var chance := _stat(hero, "crit_chance")
	if _marked(enemy):
		chance += float(hero["passives"].get("crit_vs_marked", {}).get("value", 0.0))
		var eye := _effect_with(hero, "skill_fle_008", "crit_vs_marked")
		if not eye.is_empty():
			chance += float(eye["crit_vs_marked"])
	var open: Dictionary = hero["passives"].get("skill_next_crit", {})
	if not open.is_empty() and hero["open_uid"] == enemy["uid"]:
		chance += float(open["crit"])
	var streak: Dictionary = hero["passives"].get("crit_streak", {})
	if not streak.is_empty() and not _effect_with(hero, "skill_fle_008", "value").is_empty():
		chance += float(streak["per_stack"]) * int(hero["crit_streak_n"])
	return chance
```

Em `create` (dicionário do herói) acrescentar `"open_uid": "", "crit_streak_n": 0, "ricochet_boost": 0.0, "last_ricochet": {}, "rhythm_uid": "", "rhythm_n": 0, "step_back_ready_at": -INF,`.

Em `_hero_attack`, trocar todo o bloco que calcula `chance` (de `var chance := _stat(hero, "crit_chance")` até o fim do `if _marked(enemy):`) por:

```gdscript
		var chance := _crit_chance(hero, enemy)
```

e, logo depois de `is_crit = ...`, acrescentar o consumo/atualização de estado:

```gdscript
	if hero["open_uid"] == enemy["uid"]:
		hero["open_uid"] = ""
	if hero["passives"].has("crit_streak") and not _effect_with(hero, "skill_fle_008", "value").is_empty():
		hero["crit_streak_n"] = mini(int(hero["passives"]["crit_streak"]["max_stacks"]), int(hero["crit_streak_n"]) + 1) if is_crit else 0
```

(o teste anterior de Olho R3 continua válido: `_crit_chance` reproduz a mesma soma.)

- [ ] **Step 4: Passar** — `TestKitFlecha.tscn` (4 PASS) e `TestExpeditionMechanics.tscn` (as 5g de Olho R3 seguem PASS).

- [ ] **Step 5: Checkpoint.**

---

### Tarefa F1: Skill 5 — Ricochete (`skill_fle_010`)

Uma flecha salta pela fila: 1,0×ATK no primeiro, e cada salto seguinte causa `falloff` do anterior. R1: 2 saltos (3 alvos), queda ×0,7; R2: 3 saltos; R3: salto que alcança a presa marcada causa +15%; R4: acertar ≥2 alvos distintos dá +10% no próximo Ricochete; R5: se a presa marcada foi atingida, disparo concentrado extra de 0,8×ATK nela.

**Files:** Modify `data/skills/skills_slice.json`, `ExpeditionRun.gd` (`_cast`); Test `test_kit_flecha.gd`.

**Interfaces:**
- Consumes: `_alive_targets`, `_skill_hit`.
- Produces: efeito `"ricochet"` com `coefficient, jumps, falloff, stagger, marked_jump_bonus?, distinct_boost?, finisher_coefficient?`; `hero["last_ricochet"] = {"uids": Array, "marked_hit": bool}` (lido pelas Tarefas F5/F6).

- [ ] **Step 1: Dados**

```json
  {
    "id": "skill_fle_010",
    "design_id": "SKILL_FLE_010",
    "hero": "hero_002",
    "name": "Ricochete",
    "content_set": "slice",
    "status": "HIPOTESE",
    "cooldown": 11.0,
    "trigger": {"type": "enemies_alive"},
    "effects": [
      {"type": "ricochet", "coefficient": 1.0, "jumps": 2, "falloff": 0.7, "stagger": 10.0}
    ],
    "source": "docs/04_content/skills/FLECHA_SKILLS.md, SKILL_FLE_010 (prioridade, limite de alvos e queda por salto EM ABERTO); números de simulação: 1,0×ATK, 2 saltos, ×0,7 por salto, CD 11 s (HIPÓTESE)",
    "ranks": {
      "2": {"set": {"0.jumps": 3}},
      "3": {"set": {"0.marked_jump_bonus": 0.15}},
      "4": {"set": {"0.distinct_boost": 0.1}},
      "5": {"set": {"0.finisher_coefficient": 0.8}}
    },
    "ranks_source": "FLECHA_SKILLS.md (evolução sugerida dos ranks 1–5); valores HIPÓTESE"
  },
```

- [ ] **Step 2: Teste (falha)**

```gdscript
func _cast_now(run: ExpeditionRun, hero_id: String, index: int) -> Array:
	var events: Array = []
	var hero: Dictionary = run._heroes[hero_id]
	run._cast(hero, hero["skills"][index], events)
	return events

func _test_ricochet() -> void:
	print("\n>>> F1. RICOCHETE")
	var never := {"skill_fle_010": {"type": "enemy_telegraph"}}
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 4}], {}, never)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var hits := KitTestSupport.damages(_cast_now(run, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_expect("R1: 3 alvos (1 + 2 saltos)", hits.size() == 3)
	_check("2º alvo = 0,7 do 1º", hits[1] / hits[0], 0.7, 0.0005)
	_check("3º alvo = 0,49 do 1º", hits[2] / hits[0], 0.49, 0.0005)
	# R2: 3 saltos → 4 alvos.
	var r2 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 4}], {"skill_fle_010": 2}, never)
	KitTestSupport.spawn(r2)
	KitTestSupport.tank(r2)
	_expect("R2: 4 alvos", KitTestSupport.damages(_cast_now(r2, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010").size() == 4)
	# R3: o salto que alcança a presa marcada causa +15%.
	var r3 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {"skill_fle_010": 3}, never)
	KitTestSupport.spawn(r3)
	KitTestSupport.tank(r3)
	r3._enemies[1]["marked_until"] = 99.0
	r3._enemies[1]["mark_owner"] = "hero_002"
	var h3 := KitTestSupport.damages(_cast_now(r3, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_check("R3: 2º alvo marcado = 0,7 × 1,15", h3[1] / h3[0], 0.7 * 1.15, 0.0005)
	# R4: 2+ alvos distintos armam +10% no próximo Ricochete.
	var r4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {"skill_fle_010": 4}, never)
	KitTestSupport.spawn(r4)
	KitTestSupport.tank(r4)
	var first := KitTestSupport.damages(_cast_now(r4, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	var second := KitTestSupport.damages(_cast_now(r4, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_check("R4: 2º Ricochete causa +10%", second[0] / first[0], 1.1, 0.0005)
	# R5: presa marcada atingida → disparo concentrado extra de 0,8×ATK nela.
	var r5 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_fle_010": 5}, never)
	KitTestSupport.spawn(r5)
	KitTestSupport.tank(r5)
	r5._enemies[1]["marked_until"] = 99.0
	r5._enemies[1]["mark_owner"] = "hero_002"
	var h5 := KitTestSupport.damages(_cast_now(r5, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_010")
	_expect("R5: 2 acertos + 1 disparo concentrado", h5.size() == 3)
	_check("R5: concentrado = 0,8×ATK (relativo ao 1º = 0,8)", h5[2] / h5[0], 0.8, 0.0005)
```

Ligar `_test_ricochet()` em `_ready`.

- [ ] **Step 3: Falha esperada** — efeito desconhecido; nenhum `skill_damage`.

- [ ] **Step 4: Implementar** — caso em `_cast` (antes de `"enemy_debuff"`):

```gdscript
			"ricochet":
				var pool := _alive_targets()
				if pool.is_empty():
					continue
				var boost := 1.0 + float(hero["ricochet_boost"])
				hero["ricochet_boost"] = 0.0
				var coefficient := float(fx["coefficient"]) * boost
				var uids: Array = []
				var marked_hit := false
				var prey: Dictionary = {}
				for i in mini(pool.size(), int(fx["jumps"]) + 1):
					var enemy: Dictionary = pool[i]
					var jump_bonus := 1.0
					if i > 0 and _marked(enemy) and enemy.get("mark_owner", "") == hero["id"]:
						jump_bonus += float(fx.get("marked_jump_bonus", 0.0))
					if _marked(enemy) and enemy.get("mark_owner", "") == hero["id"]:
						marked_hit = true
						prey = enemy
					_skill_hit(hero, enemy, coefficient * jump_bonus, def["id"], events, fx if i == 0 else {})
					uids.append(enemy["uid"])
					coefficient *= float(fx["falloff"])
				if uids.size() >= 2 and float(fx.get("distinct_boost", 0.0)) > 0.0:
					hero["ricochet_boost"] = float(fx["distinct_boost"])
				if float(fx.get("finisher_coefficient", 0.0)) > 0.0 and not prey.is_empty() and prey["alive"]:
					_skill_hit(hero, prey, float(fx["finisher_coefficient"]) * boost, def["id"], events, {})
				hero["last_ricochet"] = {"uids": uids, "marked_hit": marked_hit}
```

Nota sobre R5: o disparo concentrado usa `coefficient` **base** 0,8 (sem queda), então a razão para o 1º alvo é 0,8 quando `boost == 1`.

- [ ] **Step 5: Passar; Step 6: `python tools/run_godot_tests.py`; checkpoint.**

---

### Tarefa F2: Signature — Chuva de Flechas (`skill_fle_011`)

Uma salva de 3 flechas de 0,5×ATK em **cada** inimigo vivo; a presa marcada recebe ainda um disparo de foco de 1,2×ATK. R2: a Marca da presa é estendida em 2 s. R3: acertos na presa marcada abrem uma janela de 3 s em que ela recebe +10% de dano de todos.

**Files:** Modify `data/skills/skills_slice.json`, `ExpeditionRun.gd` (`_cast`); Test `test_kit_flecha.gd`.

**Interfaces:** Produces efeito `"arrow_rain"` com `coefficient, arrows, focus_coefficient, stagger, mark_extend?, opening_vulnerability?, opening_duration?`.

- [ ] **Step 1: Dados**

```json
  {
    "id": "skill_fle_011",
    "design_id": "SKILL_FLE_011",
    "hero": "hero_002",
    "name": "Chuva de Flechas",
    "content_set": "slice",
    "status": "HIPOTESE",
    "cooldown": 30.0,
    "trigger": {"type": "enemies_alive"},
    "effects": [
      {"type": "arrow_rain", "coefficient": 0.5, "arrows": 3, "focus_coefficient": 1.2, "stagger": 12.0}
    ],
    "source": "docs/04_content/skills/FLECHA_SKILLS.md, Signature SKILL_FLE_011 (salva ampla + foco na presa marcada; números EM ABERTO); 3 flechas de 0,5×ATK por inimigo + foco 1,2×ATK, CD 30 s: HIPÓTESE",
    "ranks": {
      "2": {"set": {"0.mark_extend": 2.0}},
      "3": {"set": {"0.opening_vulnerability": 0.1, "0.opening_duration": 3.0}}
    },
    "ranks_source": "FLECHA_SKILLS.md (R2 propriedade funcional escolhida: extensão da Marca; R3 abertura curta para a party). HIPÓTESE"
  },
```

- [ ] **Step 2: Teste (falha)**

```gdscript
func _test_arrow_rain() -> void:
	print("\n>>> F2. CHUVA DE FLECHAS")
	var never := {"skill_fle_011": {"type": "enemy_telegraph"}}
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_011"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var hits := KitTestSupport.damages(_cast_now(run, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_011")
	_expect("3 inimigos × 3 flechas = 9 acertos (sem presa marcada)", hits.size() == 9)
	var marked := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_011"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_fle_011": 3}, never)
	KitTestSupport.spawn(marked)
	KitTestSupport.tank(marked)
	marked._enemies[0]["marked_until"] = 50.0
	marked._enemies[0]["mark_owner"] = "hero_002"
	var marked_hits := KitTestSupport.damages(_cast_now(marked, "hero_002", 0), "skill_damage", "hero_002", "skill_fle_011")
	_expect("presa marcada recebe o disparo de foco (2×3 + 1)", marked_hits.size() == 7)
	_check("R2: a Marca foi estendida em 2 s", float(marked._enemies[0]["marked_until"]), 52.0)
	_expect("R3: abertura de +10% aberta por 3 s", absf(float(marked._enemies[0]["exposed_vulnerability"]) - 0.1) < 0.0001 and float(marked._enemies[0]["exposed_until"]) > marked.time)
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar**

```gdscript
			"arrow_rain":
				for enemy in _alive_targets():
					for arrow in int(fx["arrows"]):
						if enemy["alive"]:
							_skill_hit(hero, enemy, float(fx["coefficient"]), def["id"], events, fx if arrow == 0 else {})
					if enemy["alive"] and _marked(enemy) and enemy.get("mark_owner", "") == hero["id"]:
						_skill_hit(hero, enemy, float(fx["focus_coefficient"]), def["id"], events, {})
						if float(fx.get("mark_extend", 0.0)) > 0.0:
							enemy["marked_until"] = float(enemy["marked_until"]) + float(fx["mark_extend"])
						if float(fx.get("opening_vulnerability", 0.0)) > 0.0:
							enemy["exposed_until"] = time + float(fx["opening_duration"])
							enemy["exposed_vulnerability"] = float(fx["opening_vulnerability"])
```

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa F3: Build A (Crítico) — A3, A4, A5

| ID | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- |
| `passive_fle_leitura_de_abertura` (A3) | depois de atingir um alvo com Flecha Perfurante, o próximo ataque básico contra ele tem +15 p.p. de crítico (uma vez) | `skill_next_crit` `{"skill":"skill_fle_007","crit":0.15}` | 4 |
| `passive_fle_ajuste_fino` (A4) | durante a janela de Olho Aguçado, cada crítico seguido soma +2 p.p. (máx. 3 acúmulos); um ataque sem crítico zera | `crit_streak` `{"per_stack":0.02,"max_stacks":3}` | 7 |
| `passive_fle_disparo_perfeito` (A5) | durante Olho Aguçado, um crítico contra a presa marcada arma +20% de dano no próximo disparo ofensivo (uma vez) | `perfect_shot` `{"boost":0.2}` | 10 |

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_after_skill`, `_on_crit`, `_hero_attack`); Test `test_kit_flecha.gd`.

- [ ] **Step 1: Dados** — 3 linhas, molde:

```json
  {"id": "passive_fle_leitura_de_abertura", "design_id": null, "hero": "hero_002", "name": "Leitura de Abertura", "content_set": "slice", "status": "HIPOTESE", "unlock_level": 4, "kind": "skill_next_crit", "params": {"skill": "skill_fle_007", "crit": 0.15}, "source": "docs/02_heroes/hero_002_flecha_passives.md, A3 (sem número); precisão = chance de crítico, +15 p.p. no próximo básico contra o mesmo alvo: HIPÓTESE"},
```

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_a() -> void:
	print("\n>>> F3. BUILD CRÍTICO (A3–A5)")
	var never := {"skill_fle_007": {"type": "enemy_telegraph"}, "skill_fle_008": {"type": "enemy_telegraph"}}
	# A3
	var a3 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_007"], ["passive_fle_leitura_de_abertura"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, never, {}, 4)
	KitTestSupport.spawn(a3)
	KitTestSupport.tank(a3)
	var archer: Dictionary = a3._heroes["hero_002"]
	archer["stats"]["crit_chance"] = 0.0
	_cast_now(a3, "hero_002", 0)
	_check("A3: +15 p.p. no alvo atingido", a3._crit_chance(archer, a3._enemies[0]), 0.15)
	_check("A3: nada no outro alvo", a3._crit_chance(archer, a3._enemies[1]), 0.0)
	# A4: só vale com a janela de Olho Aguçado ativa; 3 críticos seguidos = +6 p.p.
	var a4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_008"], ["passive_fle_ajuste_fino"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 7)
	KitTestSupport.spawn(a4)
	KitTestSupport.tank(a4)
	var arch4: Dictionary = a4._heroes["hero_002"]
	arch4["stats"]["crit_chance"] = 0.0
	arch4["crit_streak_n"] = 3
	_check("A4: sem a janela do Olho não soma", a4._crit_chance(arch4, a4._enemies[0]), 0.0)
	_cast_now(a4, "hero_002", 0)
	_check("A4: com a janela: +8 p.p. do Olho + 3×2 p.p.", a4._crit_chance(arch4, a4._enemies[0]), 0.08 + 0.06)
	# A5: crítico contra a presa marcada, com Olho ativo, arma +20%.
	var a5 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_008"], ["passive_fle_disparo_perfeito"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 10)
	KitTestSupport.spawn(a5)
	KitTestSupport.tank(a5)
	var arch5: Dictionary = a5._heroes["hero_002"]
	_cast_now(a5, "hero_002", 0)
	a5._enemies[0]["marked_until"] = 99.0
	a5._enemies[0]["mark_owner"] = "hero_002"
	a5._on_crit(arch5, a5._enemies[0])
	_check("A5: +20% armado", float(arch5["crit_boost_ready"]), 0.2)
	arch5["crit_boost_ready"] = 0.0
	a5._enemies[0]["marked_until"] = 0.0
	a5._on_crit(arch5, a5._enemies[0])
	_check("A5: sem presa marcada não arma", float(arch5["crit_boost_ready"]), 0.0)
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar**

`_after_skill` (junto das outras passivas de skill):

```gdscript
	var open: Dictionary = p.get("skill_next_crit", {})
	if not open.is_empty() and open["skill"] == def["id"] and not primary.is_empty():
		hero["open_uid"] = primary["uid"]
```

`_on_crit` passa a `func _on_crit(hero: Dictionary, enemy: Dictionary = {}) -> void` e ganha, no fim:

```gdscript
	var perfect: Dictionary = hero["passives"].get("perfect_shot", {})
	if not perfect.is_empty() and not enemy.is_empty() and _marked(enemy) and enemy.get("mark_owner", "") == hero["id"] \
			and not _effect_with(hero, "skill_fle_008", "value").is_empty():
		hero["crit_boost_ready"] = maxf(float(hero["crit_boost_ready"]), float(perfect["boost"]))
```

Em `_hero_attack`, a chamada passa a ser `_on_crit(hero, enemy)`.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa F4: Build B (Marca) — B3, B4, B5

| ID | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- |
| `passive_fle_alvo_persistente` (B3) | os ataques básicos preferem a presa marcada por ela, mesmo que outro inimigo esteja na frente (tradução de "linha de visão não cancela a intenção") | `prefer_marked` `{}` | 4 |
| `passive_fle_cacada_compartilhada` (B4) | cada acerto de aliado na presa marcada a prolonga em 0,5 s, com teto de +3 s por Marca | `mark_share_extend` `{"per_hit":0.5,"cap":3.0}` | 7 |
| `passive_fle_presa_da_party` (B5) | até 4 s depois de aplicar a Marca, a primeira skill ofensiva de Flecha na presa dá +10% de ATK aos aliados por 4 s (uma vez por Marca) | `prey_of_party` `{"window":4.0,"atk_bonus":0.1,"duration":4.0}` | 10 |

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_attack_target`, `_damage_enemy`, `_cast` casos `mark` e `attack`); Test `test_kit_flecha.gd`.

- [ ] **Step 1: Dados** — 3 linhas com o molde da Tarefa F3.

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_b() -> void:
	print("\n>>> F4. BUILD MARCA (B3–B5)")
	var never := {"skill_fle_009": {"type": "enemy_telegraph"}}
	# B3: presa marcada atrás do inimigo novo continua sendo o alvo do básico.
	var b3 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], ["passive_fle_alvo_persistente"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, {}, {}, 4)
	KitTestSupport.spawn(b3)
	KitTestSupport.tank(b3)
	var prey: Dictionary = b3._enemies[1]
	prey["marked_until"] = 99.0
	prey["mark_owner"] = "hero_002"
	_expect("B3: escolhe a presa marcada mesmo sendo o 2º da fila", b3._attack_target(b3._heroes["hero_002"])["uid"] == prey["uid"])
	# B4: 8 acertos aliados → +3 s no máximo (teto).
	var b4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_006"], ["passive_fle_cacada_compartilhada"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_fle_006": {"type": "enemy_telegraph"}}, {}, 7)
	KitTestSupport.spawn(b4)
	KitTestSupport.tank(b4)
	_cast_now(b4, "hero_002", 0)
	var mark_target: Dictionary = b4._enemies[0]
	var until := float(mark_target["marked_until"])
	for _i in 8:
		b4._damage_enemy(mark_target, 1.0, b4._heroes["hero_001"], [])
	_check("B4: extensão total limitada a +3 s", float(mark_target["marked_until"]) - until, 3.0)
	# B5: primeira skill ofensiva na presa marcada, dentro da janela, dá +10% de ATK aos aliados.
	var b5 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_006", "skill_fle_009"], ["passive_fle_presa_da_party"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_fle_006": {"type": "enemy_telegraph"}, "skill_fle_009": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(b5)
	KitTestSupport.tank(b5)
	_cast_now(b5, "hero_002", 0)
	var before := b5._stat(b5._heroes["hero_001"], "attack")
	_cast_now(b5, "hero_002", 1)
	_check("B5: aliado com +10% de ATK", b5._stat(b5._heroes["hero_001"], "attack") / before, 1.1, 0.0005)
	var after := b5._stat(b5._heroes["hero_001"], "attack")
	_cast_now(b5, "hero_002", 1)
	_check("B5: só uma vez por Marca", b5._stat(b5._heroes["hero_001"], "attack") / after, 1.0, 0.0005)
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar**

B3 — em `_attack_target`, depois do bloco da trava e antes do `return _first_alive_enemy()`:

```gdscript
	if hero["passives"].has("prefer_marked"):
		for e in _alive_targets():
			if _marked(e) and e.get("mark_owner", "") == hero["id"]:
				return e
```

B4 — em `_damage_enemy`, dentro de `if not owner.is_empty():` (o ramo do aliado que acerta a presa marcada), acrescentar:

```gdscript
			var share: Dictionary = owner["passives"].get("mark_share_extend", {})
			if not share.is_empty():
				var used := float(enemy.get("mark_shared", 0.0))
				var add := minf(float(share["per_hit"]), float(share["cap"]) - used)
				if add > 0.0:
					enemy["marked_until"] = float(enemy["marked_until"]) + add
					enemy["mark_shared"] = used + add
```

B5 — no caso `"mark"` de `_cast`, guardar `target["mark_applied"] = time` e `target["party_used"] = false`; e nova função + chamada no início do caso `"attack"`:

```gdscript
## B5 (Presa da Party): a 1ª skill ofensiva de Flecha na presa, dentro da janela, reforça os aliados.
func _prey_of_party(hero: Dictionary, prey: Dictionary) -> void:
	var cfg: Dictionary = hero["passives"].get("prey_of_party", {})
	if cfg.is_empty() or prey.is_empty() or not _marked(prey) or prey.get("mark_owner", "") != hero["id"] or bool(prey.get("party_used", true)):
		return
	if time - float(prey.get("mark_applied", -INF)) > float(cfg["window"]):
		return
	prey["party_used"] = true
	for hid in _hero_order:
		if hid != hero["id"] and _heroes[hid]["alive"]:
			_heroes[hid]["effects"].append({"source": "passive_fle_presa_da_party", "stat": "attack", "op": "ADD_PERCENT", "value": float(cfg["atk_bonus"]),
				"started_at": time, "expires_at": time + float(cfg["duration"])})
```

No caso `"attack"` (antes do laço `for hit in ...`): `_prey_of_party(hero, _first_alive_enemy())`.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa F5: Build C (Velocidade) — C1–C5 e Trait Aljava em Movimento

| ID | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- |
| `passive_fle_cordas_tensionadas` (C1) | +2% de velocidade de ataque por disparo básico seguido no mesmo alvo (máx. 5 = +10%); zera ao trocar de alvo | `rhythm_stack` `{"per_hit":0.02,"max_stacks":5}` | 1 |
| `passive_fle_saque_rapido` (C2) | depois de usar uma skill, o próximo básico sai em 60% do intervalo normal | `quick_draw` `{"factor":0.6}` | 1 |
| `passive_fle_passo_de_arqueira` (C3) | ao ser atacada, −8% de dano recebido por 3 s (1 vez a cada 8 s); sem esquiva | `step_back` `{"reduction":0.08,"duration":3.0,"cooldown":8.0}` | 4 |
| `passive_fle_aljava_em_ordem` (C4) | Ricochete que atinge ≥2 alvos distintos reduz em 3 s a recarga da Rajada | `ricochet_burst_cd` `{"skill":"skill_fle_009","cd_reduce":3.0,"min_targets":2}` | 7 |
| `passive_fle_ritmo_implacavel` (C5) | ao terminar Rajada ou Ricochete contra a presa marcada, reduz em 3 s a recarga da outra skill equipada (1 vez por uso) | `rhythm_link` `{"skills":["skill_fle_009","skill_fle_010"],"cd_reduce":3.0}` | 10 |
| `trait_fle_aljava_em_movimento` | quando Ricochete atinge >1 inimigo, o próximo básico vai ao 2º alvo atingido (se vivo) | `lock_on_ricochet_second` `{}` | 1 |

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_hero_attack`, `_cast`, `_after_skill`, `_enemy_attack`); Test `test_kit_flecha.gd`.

- [ ] **Step 1: Dados** — 6 linhas.

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_c() -> void:
	print("\n>>> F5. BUILD VELOCIDADE (C1–C5 e Aljava em Movimento)")
	var never := {"skill_fle_009": {"type": "enemy_telegraph"}, "skill_fle_010": {"type": "enemy_telegraph"}}
	# C1: os intervalos entre básicos encurtam com a sequência (1/(1+0,02·n)).
	var times: Array = []
	for passives in [[], ["passive_fle_cordas_tensionadas"]]:
		var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], passives]], [{"enemy_id": "en_c1_001", "count": 1}])
		KitTestSupport.spawn(run)
		KitTestSupport.tank(run)
		var stamps: Array = []
		for e in run.step(15.0):
			if e["type"] == "hero_attack" and e["source"] == "hero_002":
				stamps.append(float(e["time"]))
		times.append(stamps)
	var base_gap: float = times[0][3] - times[0][2]
	var fast_gap: float = times[1][4] - times[1][3]
	_check("C1: o 4º intervalo já é 1/(1+0,02×3) do normal", fast_gap / base_gap, 1.0 / 1.06, 0.002)
	# C2: depois de uma skill, o próximo básico sai em 60% do intervalo.
	var c2 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_009"], ["passive_fle_saque_rapido"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, never, {}, 1)
	KitTestSupport.spawn(c2)
	KitTestSupport.tank(c2)
	var arch: Dictionary = c2._heroes["hero_002"]
	arch["next_at"] = c2.time + 100.0
	_cast_now(c2, "hero_002", 0)
	_check("C2: próximo básico em 0,6 do intervalo", float(arch["next_at"]) - c2.time, CombatMath.attack_interval(c2._stat(arch, "attack_speed")) * 0.6, 0.001)
	# C3: −8% de dano recebido por 3 s, sem repetir dentro de 8 s.
	var c3 := KitTestSupport.mk([["hero_002", [], ["passive_fle_passo_de_arqueira"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 4)
	KitTestSupport.spawn(c3)
	var target: Dictionary = c3._heroes["hero_002"]
	c3._enemies[0]["threat"]["hero_002"] = 1.0e6
	c3._enemy_attack(c3._enemies[0], [])
	_check("C3: dano recebido −8%", 1.0 - c3._damage_taken_multiplier(target), 0.08)
	var count_before: int = target["effects"].size()
	c3._enemy_attack(c3._enemies[0], [])
	_expect("C3: não reaplica dentro de 8 s", target["effects"].size() == count_before)
	# C4: Ricochete com ≥2 alvos tira 3 s da Rajada; C5: presa marcada tira 3 s da outra skill.
	var c4 := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010", "skill_fle_009"], ["passive_fle_aljava_em_ordem", "passive_fle_ritmo_implacavel"]]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never, {}, 10)
	KitTestSupport.spawn(c4)
	KitTestSupport.tank(c4)
	var a4: Dictionary = c4._heroes["hero_002"]
	a4["skills"][1]["ready_at"] = 50.0
	_cast_now(c4, "hero_002", 0)
	_check("C4: Rajada 3 s mais cedo", float(a4["skills"][1]["ready_at"]), 47.0)
	c4._enemies[0]["marked_until"] = 99.0
	c4._enemies[0]["mark_owner"] = "hero_002"
	a4["skills"][1]["ready_at"] = 50.0
	a4["skills"][0]["ready_at"] = 0.0
	_cast_now(c4, "hero_002", 0)
	_check("C4+C5: Rajada 6 s mais cedo (3 do C4 + 3 do C5)", float(a4["skills"][1]["ready_at"]), 44.0)
	# Aljava em Movimento: o próximo básico vai ao 2º alvo atingido.
	var trait_run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", ["skill_fle_010"], ["trait_fle_aljava_em_movimento"]]], [{"enemy_id": "en_c1_001", "count": 3}], {}, never, {}, 1)
	KitTestSupport.spawn(trait_run)
	KitTestSupport.tank(trait_run)
	_cast_now(trait_run, "hero_002", 0)
	_expect("Trait: próximo básico vai ao 2º alvo do Ricochete", trait_run._attack_target(trait_run._heroes["hero_002"])["uid"] == trait_run._enemies[1]["uid"])
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar**

C1 — em `_hero_attack`, trocar `hero["next_at"] = float(hero["next_at"]) + CombatMath.attack_interval(_stat(hero, "attack_speed"))` por:

```gdscript
	var speed := _stat(hero, "attack_speed")
	var rhythm: Dictionary = hero["passives"].get("rhythm_stack", {})
	if not rhythm.is_empty():
		if hero["rhythm_uid"] == enemy["uid"]:
			hero["rhythm_n"] = mini(int(rhythm["max_stacks"]), int(hero["rhythm_n"]) + 1)
		else:
			hero["rhythm_uid"] = enemy["uid"]
			hero["rhythm_n"] = 0
		speed *= 1.0 + float(rhythm["per_hit"]) * int(hero["rhythm_n"])
	hero["next_at"] = float(hero["next_at"]) + CombatMath.attack_interval(speed)
```

C2 — no fim de `_cast` (antes de `_after_skill`):

```gdscript
	var quick: Dictionary = hero["passives"].get("quick_draw", {})
	if not quick.is_empty():
		hero["next_at"] = minf(float(hero["next_at"]), time + CombatMath.attack_interval(_stat(hero, "attack_speed")) * float(quick["factor"]))
```

C3 — em `_enemy_attack`, depois do evento `enemy_attack`:

```gdscript
	var step_back: Dictionary = hero["passives"].get("step_back", {})
	if not step_back.is_empty() and float(hero["step_back_ready_at"]) <= time + EPS:
		hero["step_back_ready_at"] = time + float(step_back["cooldown"])
		hero["effects"].append({"source": "passive_fle_passo_de_arqueira", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(step_back["reduction"]),
			"started_at": time, "expires_at": time + float(step_back["duration"]), "defensive": true})
```

C4, C5 e Trait — em `_after_skill`:

```gdscript
	var last: Dictionary = hero["last_ricochet"]
	if def["id"] == "skill_fle_010" and not last.is_empty():
		var burst: Dictionary = p.get("ricochet_burst_cd", {})
		if not burst.is_empty() and last["uids"].size() >= int(burst["min_targets"]):
			_reduce_cooldown(hero, String(burst["skill"]), float(burst["cd_reduce"]))
		if p.has("lock_on_ricochet_second") and last["uids"].size() > 1:
			hero["target_lock"] = last["uids"][1]
			hero["target_lock_until"] = INF
			hero["lock_once"] = true
	var link: Dictionary = p.get("rhythm_link", {})
	if not link.is_empty() and link["skills"].has(def["id"]) and (not primary.is_empty() and _marked(primary) or bool(last.get("marked_hit", false)) and def["id"] == "skill_fle_010"):
		for other_id in link["skills"]:
			if other_id != def["id"]:
				_reduce_cooldown(hero, String(other_id), float(link["cd_reduce"]))
	if def["id"] != "skill_fle_010":
		hero["last_ricochet"] = {}
```

`_reduce_cooldown(hero, skill_id, seconds)` já existe (Plano 00, Tarefa 5).

(Depois de C4/C5 disparar, `hero["last_ricochet"]` de um Ricochete permanece até outra skill ser lançada; isso é intencional e coberto pelo teste.)

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa F6: Builds, rótulos, registro e verificação do kit

**Files:** Modify `data/heroes/heroes.json`, `scripts/combat/SliceSession.gd`, `docs/CONTENT_REGISTRY.md`, `docs/04_content/skills/FLECHA_SKILLS.md`, `docs/02_heroes/hero_002_flecha_passives.md`; Test `test_kit_flecha.gd`.

- [ ] **Step 1: Builds e Signature** — no `hero_002`: `"signature": "skill_fle_011"` e `builds` com 3 chaves:

```json
"builds": {
  "critico":    {"name": "Crítico",    "skills": ["skill_fle_008", "skill_fle_007"], "passives": ["passive_fle_respiracao_controlada", "passive_fle_ponta_de_penetracao", "passive_fle_leitura_de_abertura", "passive_fle_ajuste_fino", "passive_fle_disparo_perfeito", "passive_fle_ponto_de_mira"]},
  "marca":      {"name": "Marca",      "skills": ["skill_fle_006", "skill_fle_009"], "passives": ["passive_fle_rastro_aberto", "passive_fle_pressao_coordenada", "passive_fle_alvo_persistente", "passive_fle_cacada_compartilhada", "passive_fle_presa_da_party", "passive_fle_cacada_coordenada"]},
  "velocidade": {"name": "Velocidade", "skills": ["skill_fle_009", "skill_fle_010"], "passives": ["passive_fle_cordas_tensionadas", "passive_fle_saque_rapido", "passive_fle_passo_de_arqueira", "passive_fle_aljava_em_ordem", "passive_fle_ritmo_implacavel", "trait_fle_aljava_em_movimento"]}
}
```

- [ ] **Step 2: `SliceSession.gd`**

```gdscript
	"hero_002": ["critico", "marca", "velocidade"],
```
e o rótulo `"velocidade": "Velocidade"` em `BUILD_LABELS`.

- [ ] **Step 3: Teste de integração do kit** (mesmo desenho do Bastião)

```gdscript
func _test_full_kit() -> void:
	print("\n>>> F6. KIT COMPLETO")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var fle: Dictionary = heroes.filter(func(r): return r["id"] == "hero_002")[0]
	var skills := {}
	var passives := {}
	for b in fle["builds"].values():
		for s in b["skills"]:
			skills[s] = true
		for p in b["passives"]:
			passives[p] = true
	skills[String(fle["signature"])] = true
	_expect("6 skills distintas (006–011), a Signature no 3º slot", skills.size() == 6)
	_expect("15 passivas de build + 3 Traits contam (Ponto de Mira, Caçada Coordenada, Aljava)", passives.size() >= 18)
	for build in fle["builds"]:
		for level in [1, 5, 10, 12]:
			var run := SliceSession.create_run({"hero_001": "guardiao", "hero_002": build, "hero_003": "arcano"}, level, 3)
			run.run_to_end(0.25, 900.0)
			_expect("build %s nível %d roda até o fim" % [build, level], run.state == "won" or run.state == "lost")
```

- [ ] **Step 4: Registro** — `CONTENT_REGISTRY.md`: `SKILL_FLE_010`, `SKILL_FLE_011`, 10 passivas + Trait novos com status `IMPLEMENTING`; `FLECHA_SKILLS.md`: nas "Pendências de design", anotar "números de simulação em `skills_slice.json` (2026-09-30)"; `hero_002_flecha_passives.md`: acrescentar seção "Estado no slice" com a tabela das Tarefas F3–F5.

- [ ] **Step 5: Rodar tudo** — `python tools/run_godot_tests.py`, `python tools/balance/validate_balance_data.py`, `python tools/argos/run.py --scenario slice_quick` (esperado: todas as cenas PASS, `Balance data: OK`, `0 BUG`).

- [ ] **Step 6: Checkpoint.** Entregar ao Plano 04.
