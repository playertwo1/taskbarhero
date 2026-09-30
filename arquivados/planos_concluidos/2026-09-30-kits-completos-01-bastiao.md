# Kit completo do Bastião — Plano 01

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans. Os passos usam checkbox (`- [ ]`). **Pré-requisito:** Plano 00 (Tarefas 1–4) concluído.

**Meta:** levar o Bastião (`hero_001`) de 4 skills / 7 passivas / 2 Traits / 2 builds para o kit do [HERO_STANDARD](../../docs/02_heroes/HERO_STANDARD.md): 6 skills (Impacto de Escudo e a Signature Último Bastião no 3º slot), 16 passivas, 3 Traits e 3 builds, com a mecânica exclusiva **Guarda** ativa.

**Arquitetura:** a Guarda vira um recurso `hero["guard"]` (0–100) alimentado por eventos de combate; skills gastam Guarda por um gatilho novo (`guard_at_least`). Passivas novas entram como `kind`s tratados por ganchos curtos no `ExpeditionRun`. Tudo o que depende de posição (knockback, "movimento") é **traduzido** para efeitos por alvo (stagger, stun, Desequilíbrio, slow de ataque).

**Tecnologias:** GDScript 4.7.2, JSON, testes headless com `KitTestSupport`.

**Spec:** [Golden Reference](../../docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md) (seções 3, 8, 9, 10), [passivas](../../docs/02_heroes/hero_001_bastiao_passives.md), [Traits](../../docs/02_heroes/hero_001_bastiao_traits.md).

## Restrições globais

Todas as do [Plano 00](2026-09-30-kits-completos-00-fundacao.md#restrições-globais). Adicionais:

- Números de design da Guarda vêm do Golden Reference (tabela da seção 3); `carry_fraction` e todos os números de skills novas são **HIPÓTESE**.
- `guard_ready_at` (prontidão do Perfect Block, já existente) **não é** a Guarda; a nova é `hero["guard"]`. Não misturar.
- Rank 1 é o valor do slice para passivas (como as existentes); ranks maiores das passivas ficam fora do slice.
- Quem tem `guard` é quem tem `"guard"` em `heroes.json`; outros heróis nunca ganham Guarda.

## Estrutura de arquivos

- Modify `data/heroes/heroes.json` — bloco `guard` e builds do Bastião.
- Modify `data/skills/skills_slice.json` — `skill_bas_010`, `skill_bas_011`.
- Modify `data/skills/passives_slice.json` — 9 passivas novas + 1 Trait.
- Modify `scripts/combat/ExpeditionRun.gd` — Guarda, gatilhos, `shield_bash`, `last_bastion` e ganchos das passivas.
- Modify `scripts/combat/SliceSession.gd` — `BUILD_OPTIONS`/`BUILD_LABELS`.
- Create `tests/unit/test_kit_bastiao.gd`, `tests/unit/TestKitBastiao.tscn`.
- Modify `docs/CONTENT_REGISTRY.md`, `docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md` (estado).

---

### Tarefa B1: Recurso Guarda

**Files:**
- Modify: `data/heroes/heroes.json` (herói `hero_001`)
- Modify: `scripts/combat/ExpeditionRun.gd` (`create`, `_start_encounter`, `_enemy_attack`, `_cast` caso `"taunt"`, `snapshot`)
- Test: `tests/unit/test_kit_bastiao.gd` (novo)

**Interfaces:**
- Produces:
  - `func _gain_guard(hero: Dictionary, amount: float, events: Array) -> void` — emite `{"type":"guard_gained","time","hero","amount","total"}` só se subiu.
  - `func _spend_guard(hero: Dictionary, amount: float, events: Array) -> bool` — emite `{"type":"guard_spent","time","hero","amount","total"}`.
  - `hero["guard"]: float`, `hero["guard_cfg"]: Dictionary`.
  - `snapshot()["party"][i]["guard"]: float`.

- [ ] **Step 1: Criar o teste (falha)**

`tests/unit/test_kit_bastiao.gd`:

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
	print("--- TESTE KIT DO BASTIÃO ---")
	KitTestSupport.load_all()
	_test_guard()
	print("[PASS] TESTE KIT DO BASTIÃO CONCLUÍDO" if success else "[FAIL] TESTE KIT DO BASTIÃO")
	get_tree().quit(0 if success else 1)

func _test_guard() -> void:
	print("\n>>> B1. GUARDA")
	# Geleia ataca em t = 1 e 2: 1º golpe é Perfect Block (+2 +12), 2º é golpe comum (+2).
	var run := KitTestSupport.mk([["hero_001", [], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var events := run.step(2.5)
	_check("Guarda depois de 1 Perfect Block e 1 golpe", float(run._heroes["hero_001"]["guard"]), 16.0)
	_expect("evento guard_gained emitido", not KitTestSupport.of(events, "guard_gained").is_empty())
	var hero: Dictionary = run._heroes["hero_001"]
	run._gain_guard(hero, 500.0, [])
	_check("teto de 100", float(hero["guard"]), 100.0)
	_expect("gastar 30 funciona", run._spend_guard(hero, 30.0, []))
	_check("Guarda depois de gastar", float(hero["guard"]), 70.0)
	_expect("gastar mais que o saldo falha", not run._spend_guard(hero, 80.0, []))
	hero["guard"] = 80.0
	run._apply_guard_carry()
	_check("carry entre encontros: 50%", float(hero["guard"]), 40.0)
	_check("snapshot expõe a Guarda", float(run.snapshot()["party"][0]["guard"]), 40.0)
	var flecha_run := KitTestSupport.mk([["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	_expect("herói sem bloco guard não tem Guarda", flecha_run._heroes["hero_002"]["guard_cfg"].is_empty())
```

`tests/unit/TestKitBastiao.tscn` (mesmo molde de `TestKitSupport.tscn`, apontando para `test_kit_bastiao.gd`, nó `TestKitBastiao`).

- [ ] **Step 2: Rodar e ver falhar** — `TestKitBastiao.tscn`; Expected: erro de parse/`Invalid access to property 'guard'`.

- [ ] **Step 3: Dados** — em `heroes.json`, no objeto `hero_001`, acrescentar após `perfect_block`:

```json
"guard": {"status": "DECIDIDO", "max": 100.0, "on_hit_taken": 2.0, "on_block": 5.0, "on_perfect_block": 12.0, "on_ally_hit": 4.0, "on_taunt": 3.0, "on_counter_hit": 5.0, "carry_fraction": 0.5, "source": "BASTIAO_GOLDEN_REFERENCE.md seção 3 (tabela de ganhos e máximo 100); carry_fraction 0,5 é HIPÓTESE do slice: a Guarda 'decai lentamente' fora do combate, o slice aplica metade entre encontros"},
```

- [ ] **Step 4: Implementar** — em `ExpeditionRun.gd`:

Em `create`, no dicionário do herói acrescentar `"guard": 0.0, "guard_cfg": row.get("guard", {}),` (na mesma linha onde estão `"pressure_ready": false, ...`).

Funções novas (perto de `_grant_shield`):

```gdscript
# --- Guarda (Bastião) --------------------------------------------------------------------------

func _gain_guard(hero: Dictionary, amount: float, events: Array) -> void:
	var cfg: Dictionary = hero["guard_cfg"]
	if cfg.is_empty() or amount <= 0.0 or not hero["alive"]:
		return
	var before := float(hero["guard"])
	hero["guard"] = minf(float(cfg["max"]), before + amount)
	if float(hero["guard"]) > before:
		events.append({"type": "guard_gained", "time": time, "hero": hero["id"], "amount": float(hero["guard"]) - before, "total": hero["guard"]})

func _spend_guard(hero: Dictionary, amount: float, events: Array) -> bool:
	if hero["guard_cfg"].is_empty() or float(hero["guard"]) + EPS < amount:
		return false
	hero["guard"] = float(hero["guard"]) - amount
	events.append({"type": "guard_spent", "time": time, "hero": hero["id"], "amount": amount, "total": hero["guard"]})
	return true

## Entre encontros a Guarda decai: fica com `carry_fraction` do valor.
func _apply_guard_carry() -> void:
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["guard_cfg"].is_empty():
			h["guard"] = float(h["guard"]) * float(h["guard_cfg"]["carry_fraction"])
```

Em `_start_encounter`, logo depois de `_purge_expired()`, chamar `if node_index > 0: _apply_guard_carry()` (o primeiro encontro da run começa com a Guarda que o herói tiver; os testes dependem disso ao preencher `hero["guard"]` antes do `spawn`).

Em `_enemy_attack`, imediatamente depois da linha `events.append({"type": "enemy_attack", ...})` (antes de `if blocked:`):

```gdscript
	if not hero["guard_cfg"].is_empty():
		var cfg: Dictionary = hero["guard_cfg"]
		_gain_guard(hero, float(cfg["on_hit_taken"]), events)
		if blocked:
			_gain_guard(hero, float(cfg["on_perfect_block"]), events)
		elif stance_hit:
			_gain_guard(hero, float(cfg["on_block"]), events)
	for hid in _hero_order:
		var guard_hero: Dictionary = _heroes[hid]
		if hid != target_id and not guard_hero["guard_cfg"].is_empty():
			_gain_guard(guard_hero, float(guard_hero["guard_cfg"]["on_ally_hit"]), events)
```

No caso `"taunt"` de `_cast`, ao final do caso: `_gain_guard(hero, float(hero["guard_cfg"].get("on_taunt", 0.0)), events)`.

No bloco do contra-ataque (onde emite `counter_attack`), depois do evento: `_gain_guard(hero, float(hero["guard_cfg"].get("on_counter_hit", 0.0)), events)`.

Em `snapshot`, no dicionário de `party.append`, acrescentar `"guard": float(h["guard"])`.

- [ ] **Step 5: Rodar e ver passar** — `TestKitBastiao.tscn` (8 PASS) e `python tools/run_godot_tests.py` (sem regressões: heróis sem `guard` ficam iguais).

- [ ] **Step 6: Checkpoint.**

---

### Tarefa B2: Gatilhos por Guarda

**Files:** Modify `scripts/combat/ExpeditionRun.gd` (`_trigger_ok`); Test: `test_kit_bastiao.gd`.

**Interfaces:** Produces gatilhos `{"type":"guard_at_least","amount":N}` e `{"type":"guard_and_hp_below","amount":N,"threshold":T}` (Guarda ≥ N **e** algum herói vivo, inclusive o próprio, com HP ≤ T do máximo).

- [ ] **Step 1: Teste (falha)** — em `_test_guard` não; nova função `_test_triggers()` chamada em `_ready`:

```gdscript
func _test_triggers() -> void:
	print("\n>>> B2. GATILHOS")
	var run := KitTestSupport.mk([["hero_001", [], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	KitTestSupport.spawn(run)
	var hero: Dictionary = run._heroes["hero_001"]
	hero["guard"] = 19.0
	_expect("guard_at_least 20 falha com 19", not run._trigger_ok(hero, {"type": "guard_at_least", "amount": 20.0}))
	hero["guard"] = 20.0
	_expect("guard_at_least 20 passa com 20", run._trigger_ok(hero, {"type": "guard_at_least", "amount": 20.0}))
	hero["guard"] = 100.0
	_expect("guard_and_hp_below falha com todos com HP cheio", not run._trigger_ok(hero, {"type": "guard_and_hp_below", "amount": 100.0, "threshold": 0.5}))
	run._heroes["hero_002"]["hp"] = 100.0
	_expect("guard_and_hp_below passa com aliado a 2% de HP", run._trigger_ok(hero, {"type": "guard_and_hp_below", "amount": 100.0, "threshold": 0.5}))
```

- [ ] **Step 2: Falha esperada** — `_trigger_ok` devolve `false` para tipo desconhecido: a asserção de "passa" falha.

- [ ] **Step 3: Implementar** — no `match` de `_trigger_ok`, antes do `return false` final:

```gdscript
		"guard_at_least":
			return not _first_alive_enemy().is_empty() and float(hero["guard"]) + EPS >= float(trigger["amount"])
		"guard_and_hp_below":
			if _first_alive_enemy().is_empty() or float(hero["guard"]) + EPS < float(trigger["amount"]):
				return false
			for hid in _hero_order:
				var h: Dictionary = _heroes[hid]
				if h["alive"] and float(h["hp"]) <= float(h["stats"]["max_hp"]) * float(trigger["threshold"]) + EPS:
					return true
			return false
```

- [ ] **Step 4: Passar; Step 5: checkpoint.**

---

### Tarefa B3: Skill 5 — Impacto de Escudo (`skill_bas_010`)

Tradução para o slice (sem posição): a "colisão" acontece quando há um segundo inimigo vivo; o primeiro alvo leva dano extra e stun, e o de trás leva o mesmo dano extra.

**Files:** Modify `data/skills/skills_slice.json`, `scripts/combat/ExpeditionRun.gd` (`_cast`); Test `test_kit_bastiao.gd`.

**Interfaces:**
- Consumes: `_gain_guard/_spend_guard`, gatilho `guard_at_least` (B1/B2), `_skill_hit`, `_stun`, `_imbalance`, `_nth_alive_enemy`.
- Produces: efeito `"shield_bash"` com campos `coefficient, stagger, guard_cost, collision_coefficient, collision_stun, collision_imbalance?, explosion_coefficient?`.

- [ ] **Step 1: Dados** — acrescentar ao array de `skills_slice.json` (antes de `skill_fle_006`):

```json
  {
    "id": "skill_bas_010",
    "design_id": "SKILL_BAS_010",
    "hero": "hero_001",
    "name": "Impacto de Escudo",
    "content_set": "slice",
    "status": "HIPOTESE",
    "cooldown": 10.0,
    "trigger": {"type": "guard_at_least", "amount": 20.0},
    "effects": [
      {"type": "shield_bash", "coefficient": 1.4, "stagger": 35.0, "guard_cost": 20.0, "collision_coefficient": 0.4, "collision_stun": 0.6}
    ],
    "source": "BASTIAO_GOLDEN_REFERENCE.md, Skill 5 (140% Weapon Damage, 20 Guarda, CD 10 s); slice sem posição: colisão = existe um segundo inimigo vivo; dano extra 0,4×ATK nos dois e stun de 0,6 s no primeiro (HIPÓTESE)",
    "ranks": {
      "2": {"set": {"0.coefficient": 1.54}},
      "3": {"set": {"0.collision_coefficient": 0.6}},
      "4": {"set": {"0.collision_imbalance": true}},
      "5": {"set": {"0.explosion_coefficient": 0.5}}
    },
    "ranks_source": "Golden Reference (R2 maior distância → +10% de coeficiente no slice; R3 maior knockback → colisão 0,6; R4 colisões aplicam Desequilíbrio; R5 explosão de impacto 0,5×ATK nos demais se o alvo estava Desequilibrado). HIPÓTESE"
  },
```

- [ ] **Step 2: Teste (falha)**

```gdscript
func _expected_hit(run: ExpeditionRun, enemy: Dictionary, coefficient: float) -> float:
	var atk := float(run._heroes["hero_001"]["stats"]["attack"])
	return CombatMath.hit_damage(atk * coefficient, run._enemy_defense(enemy), 0.0, 1.0)

func _test_shield_bash() -> void:
	print("\n>>> B3. IMPACTO DE ESCUDO")
	var always := {"type": "guard_at_least", "amount": 20.0}
	# Sem Guarda suficiente não lança.
	var low := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	var ev_low := KitTestSupport.spawn(low)
	_expect("sem Guarda 20 não lança", KitTestSupport.of(ev_low, "skill_cast").is_empty())
	# Um inimigo: 1 golpe, sem colisão. Guarda 30 → gasta 20.
	var one := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 1}])
	one._heroes["hero_001"]["guard"] = 30.0
	var ev_one := KitTestSupport.spawn(one)
	ev_one.append_array(one.step(0.05))
	var spent := KitTestSupport.of(ev_one, "guard_spent")
	_expect("gasta 20 de Guarda", spent.size() == 1 and absf(float(spent[0]["amount"]) - 20.0) < 0.001)
	var hits_one := KitTestSupport.damages(ev_one, "skill_damage", "hero_001", "skill_bas_010")
	_expect("1 inimigo: 1 golpe, sem colisão", hits_one.size() == 1)
	# Dois inimigos: golpe principal + colisão nos dois; stun no primeiro.
	var two := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 2}])
	two._heroes["hero_001"]["guard"] = 30.0
	var ev_two := KitTestSupport.spawn(two)
	ev_two.append_array(two.step(0.05))
	var hits_two := KitTestSupport.damages(ev_two, "skill_damage", "hero_001", "skill_bas_010")
	_expect("2 inimigos: golpe + 2 colisões", hits_two.size() == 3)
	_expect("stun no primeiro alvo", not KitTestSupport.of(ev_two, "enemy_stunned").is_empty())
	_check("golpe principal = 1,4×ATK", hits_two[0], _expected_hit(two, two._enemies[0], 1.4))
	_check("colisão = 0,4×ATK", hits_two[1], _expected_hit(two, two._enemies[0], 0.4))
	# R4: colisão aplica Desequilíbrio ao primeiro alvo.
	var r4 := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 2}], {"skill_bas_010": 4})
	r4._heroes["hero_001"]["guard"] = 30.0
	var ev_r4 := KitTestSupport.spawn(r4)
	ev_r4.append_array(r4.step(0.05))
	_expect("R4 aplica Desequilíbrio", not KitTestSupport.of(ev_r4, "enemy_imbalanced").is_empty())
	# R5: alvo já Desequilibrado + 3 inimigos → principal (1) + colisões (2) + explosão de 0,5×ATK nos outros 2.
	var r5 := KitTestSupport.mk([["hero_001", ["skill_bas_010"], []]], [{"enemy_id": "en_c1_001", "count": 3}], {"skill_bas_010": 5}, {"skill_bas_010": {"type": "enemy_telegraph"}})
	KitTestSupport.spawn(r5)
	KitTestSupport.tank(r5)
	var bast: Dictionary = r5._heroes["hero_001"]
	bast["guard"] = 30.0
	r5._enemies[0]["imbalance_until"] = 99.0
	var ev_r5: Array = []
	r5._cast(bast, bast["skills"][0], ev_r5)
	var hits_r5 := KitTestSupport.damages(ev_r5, "skill_damage", "hero_001", "skill_bas_010")
	_expect("R5: 5 golpes (principal, 2 colisões, 2 explosões)", hits_r5.size() == 5)
	_check("R5: explosão = 0,5×ATK no 3º inimigo", hits_r5[4], _expected_hit(r5, r5._enemies[2], 0.5))

- [ ] **Step 3: Falha esperada** — o efeito `shield_bash` não existe: nenhum `skill_damage`.

- [ ] **Step 4: Implementar** — no `match` de `_cast`, antes de `"enemy_debuff"`:

```gdscript
			"shield_bash":
				if not _spend_guard(hero, float(fx["guard_cost"]), events):
					continue
				var bash_target := _first_alive_enemy()
				if bash_target.is_empty():
					continue
				var was_imbalanced := float(bash_target["imbalance_until"]) > time + EPS
				_skill_hit(hero, bash_target, float(fx["coefficient"]), def["id"], events, fx)
				var behind := _nth_alive_enemy(1)
				if bash_target["alive"] and not behind.is_empty():
					_skill_hit(hero, bash_target, float(fx["collision_coefficient"]), def["id"], events, {})
					_skill_hit(hero, behind, float(fx["collision_coefficient"]), def["id"], events, {})
					if bash_target["alive"]:
						_stun(bash_target, float(fx["collision_stun"]), events)
						if bool(fx.get("collision_imbalance", false)):
							_imbalance(bash_target, events)
				if was_imbalanced and float(fx.get("explosion_coefficient", 0.0)) > 0.0:
					var index := 1
					while true:
						var other := _nth_alive_enemy(index)
						if other.is_empty():
							break
						_skill_hit(hero, other, float(fx["explosion_coefficient"]), def["id"], events, {})
						index += 1
```

- [ ] **Step 5: Passar; Step 6: `python tools/run_godot_tests.py`; checkpoint.**

---

### Tarefa B4: Signature — Último Bastião (`skill_bas_011`)

Duração 8 s. Durante o efeito: Bastião não cai abaixo de 1 HP; aliados −20% de dano recebido; 30% do dano dos aliados é redirecionado para ele; todo golpe contra ele conta como Perfect Block; Contra-Golpe recarrega 2× mais rápido. Ao fim: onda de choque de `0,75 × absorvido` (teto 3,0×ATK) em cada inimigo. R2: 10 s. R3: cura aliados com 25% do absorvido (teto 10% do HP máximo de cada).

**Files:** Modify `data/skills/skills_slice.json`, `scripts/combat/ExpeditionRun.gd` (`create`, `_cast`, `_enemy_attack`, `_advance_clock`); Test `test_kit_bastiao.gd`.

**Interfaces:**
- Consumes: `_spend_guard`, gatilho `guard_and_hp_below`, `_advance_clock`, `_heal_hero`, `_skill_hit`-like dano.
- Produces: efeito `"last_bastion"`; estado `hero["last_bastion"]: Dictionary` = `{"until": float, "absorbed": float, "cfg": Dictionary}` (vazio quando inativo); função `_bastion_active(hero) -> bool`.

- [ ] **Step 1: Dados**

```json
  {
    "id": "skill_bas_011",
    "design_id": "SKILL_BAS_011",
    "hero": "hero_001",
    "name": "Último Bastião",
    "content_set": "slice",
    "status": "HIPOTESE",
    "cooldown": 45.0,
    "trigger": {"type": "guard_and_hp_below", "amount": 100.0, "threshold": 0.5},
    "effects": [
      {"type": "last_bastion", "guard_cost": 100.0, "duration": 8.0, "ally_damage_reduction": 0.2, "redirect_fraction": 0.3, "counter_cooldown_scale": 0.5, "wave_coefficient": 0.75, "wave_cap": 3.0}
    ],
    "source": "BASTIAO_GOLDEN_REFERENCE.md, Signature (100 Guarda, 8 s; sem cair de 1 HP, redução para aliados, redirecionamento, todo bloqueio é Perfect Block, Contra-Golpe acelerado, onda proporcional ao absorvido); gatilho de emergência (HP ≤ 50% de alguém) e todos os números além dos citados: HIPÓTESE",
    "ranks": {
      "2": {"set": {"0.duration": 10.0}},
      "3": {"set": {"0.heal_fraction": 0.25, "0.heal_cap": 0.1}}
    },
    "ranks_source": "Golden Reference (R2 duração 8 → 10 s; R3 restaura vida dos aliados proporcional ao absorvido). HIPÓTESE"
  },
```

- [ ] **Step 2: Teste (falha)**

```gdscript
func _test_last_bastion() -> void:
	print("\n>>> B4. ÚLTIMO BASTIÃO")
	var run := KitTestSupport.mk([["hero_001", ["skill_bas_011", "skill_bas_007"], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {"hero_001": 2000.0})
	var bast: Dictionary = run._heroes["hero_001"]
	bast["guard"] = 100.0
	bast["skills"][1]["ready_at"] = 100.0
	var events := KitTestSupport.spawn(run)
	_expect("lança com Guarda 100 e HP a 40%", not KitTestSupport.of(events, "skill_cast").is_empty())
	_check("gasta 100 de Guarda (mais ganhos dos golpes)", float(KitTestSupport.of(events, "guard_spent")[0]["amount"]), 100.0)
	_expect("aliado ganha −20% de dano recebido", not run._effect_with(run._heroes["hero_002"], "skill_bas_011", "value").is_empty() or run._heroes["hero_002"]["effects"].any(func(e): return e["source"] == "skill_bas_011" and absf(float(e["value"]) + 0.2) < 0.0001))
	# Piso de 1 HP mesmo com dano enorme.
	KitTestSupport.tank(run)
	run._enemies[0]["stats"]["attack"] = 1.0e6
	bast["hp"] = 50.0
	run.step(3.0)
	_expect("Bastião sobrevive com 1 HP", bast["alive"] and float(bast["hp"]) >= 1.0 - 0.001)
	# Contra-Golpe acelerado: 2 s de bastião reduzem a recarga em ~2 s extras.
	var ready_now := float(bast["skills"][1]["ready_at"])
	_expect("recarga do Contra-Golpe acelerada", ready_now < 100.0 - 1.5)
	# Ao fim, onda de choque.
	var end_events := run.step(8.0)
	var wave := KitTestSupport.damages(end_events, "skill_damage", "hero_001", "skill_bas_011")
	_expect("onda de choque no fim da duração", wave.size() == 1 and wave[0] > 0.0)
	_expect("Último Bastião termina", not run._bastion_active(bast))
	# R3: cura os aliados ao fim.
	var r3 := KitTestSupport.mk([["hero_001", ["skill_bas_011"], []], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {"skill_bas_011": 3}, {}, {"hero_001": 2000.0, "hero_002": 1000.0})
	r3._heroes["hero_001"]["guard"] = 100.0
	KitTestSupport.spawn(r3)
	KitTestSupport.tank(r3)
	var heal_events := r3.step(11.0)
	_expect("R3 cura aliado ao fim (evento healing com causa last_bastion)", heal_events.any(func(e): return e["type"] == "healing" and e.get("cause", "") == "last_bastion"))
```

- [ ] **Step 3: Falha esperada** — tipo de efeito desconhecido; sem `_bastion_active`.

- [ ] **Step 4: Implementar**

Em `create`, no dicionário do herói: `"last_bastion": {},`.

Função nova:

```gdscript
func _bastion_active(hero: Dictionary) -> bool:
	return not hero["last_bastion"].is_empty() and float(hero["last_bastion"]["until"]) > time + EPS
```

Caso em `_cast`:

```gdscript
			"last_bastion":
				if not _spend_guard(hero, float(fx["guard_cost"]), events):
					continue
				hero["last_bastion"] = {"until": time + float(fx["duration"]), "absorbed": 0.0, "cfg": fx}
				for hid in _hero_order:
					if hid != hero["id"] and _heroes[hid]["alive"]:
						_heroes[hid]["effects"].append({
							"source": def["id"], "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(fx["ally_damage_reduction"]),
							"started_at": time, "expires_at": time + float(fx["duration"]), "defensive": true,
						})
				events.append({"type": "last_bastion_started", "time": time, "hero": hero["id"], "until": hero["last_bastion"]["until"]})
```

Em `_enemy_attack`:
1. Trocar `var blocked: bool = not pb.is_empty() and float(hero["guard_ready_at"]) <= time + EPS` por
```gdscript
	var bastion := _bastion_active(hero)
	var blocked: bool = bastion or (not pb.is_empty() and float(hero["guard_ready_at"]) <= time + EPS)
```
2. No bloco `if blocked:`, envolver o recarregamento: `if not bastion: hero["guard_ready_at"] = time + float(pb["recharge"])`; e onde usa `pb["damage_multiplier"]`/`pb["stagger"]` com `pb` vazio (Bastião sempre tem `perfect_block`, então funciona).
3. Redirecionamento do Último Bastião: logo depois do bloco do `guardian := _protector(hero, "redirect")`, acrescentar:
```gdscript
	for hid in _hero_order:
		var keeper: Dictionary = _heroes[hid]
		if hid != target_id and keeper["alive"] and _bastion_active(keeper):
			var share: float = damage * float(keeper["last_bastion"]["cfg"]["redirect_fraction"])
			var kept: float = minf(share * (1.0 - CombatMath.mitigation(_stat(keeper, "defense"))) * _damage_taken_multiplier(keeper), float(keeper["hp"]) - 1.0)
			if kept > 0.0:
				damage -= share
				keeper["hp"] = float(keeper["hp"]) - kept
				keeper["last_bastion"]["absorbed"] = float(keeper["last_bastion"]["absorbed"]) + share
				events.append({"type": "damage_redirected", "time": time, "from": target_id, "to": keeper["id"], "damage": kept})
			break
```
4. Depois do `hero["hp"] = maxf(0.0, float(hero["hp"]) - remaining)`, para o piso e o absorvido:
```gdscript
	if bastion:
		hero["last_bastion"]["absorbed"] = float(hero["last_bastion"]["absorbed"]) + remaining
		hero["hp"] = maxf(1.0, float(hero["hp"]))
```
(o teste de morte logo abaixo continua a valer para os demais.)

Em `_advance_clock(to, events)`, dentro do laço de heróis vivos, antes do `time = to` da função:

```gdscript
		if not h["last_bastion"].is_empty():
			var st: Dictionary = h["last_bastion"]
			var active_until := minf(to, float(st["until"]))
			var scale := float(st["cfg"]["counter_cooldown_scale"])
			var window := active_until - maxf(from, float(st.get("since", from)))
			if window > 0.0 and scale > 0.0:
				for sk in h["skills"]:
					if sk["def"]["id"] == "skill_bas_007" and float(sk["ready_at"]) > time:
						sk["ready_at"] = maxf(time, float(sk["ready_at"]) - window * (1.0 / scale - 1.0))
						sk["ready_seen"] = false
			if float(st["until"]) <= to + EPS:
				_end_last_bastion(h, events)
```

Função de encerramento:

```gdscript
func _end_last_bastion(hero: Dictionary, events: Array) -> void:
	var st: Dictionary = hero["last_bastion"]
	var cfg: Dictionary = st["cfg"]
	var absorbed := float(st["absorbed"])
	hero["last_bastion"] = {}
	var wave := minf(absorbed * float(cfg["wave_coefficient"]), float(cfg["wave_cap"]) * _stat(hero, "attack"))
	for enemy in _enemies.duplicate():
		if enemy["alive"] and bool(enemy.get("targetable", true)):
			var dmg := CombatMath.hit_damage(wave, _enemy_defense(enemy), 0.0, _enemy_damage_taken(enemy))
			events.append({"type": "skill_damage", "time": time, "source": hero["id"], "skill": "skill_bas_011", "target": enemy["uid"], "damage": dmg})
			_damage_enemy(enemy, dmg, hero, events)
	if float(cfg.get("heal_fraction", 0.0)) > 0.0:
		for hid in _hero_order:
			var ally: Dictionary = _heroes[hid]
			if hid != hero["id"] and ally["alive"]:
				_heal_hero(ally, hero, minf(absorbed * float(cfg["heal_fraction"]), float(cfg["heal_cap"]) * float(ally["stats"]["max_hp"])), "last_bastion", events, time)
```

Nota: `_advance_clock` usa `time` (ainda o valor antigo) para os eventos; passe `to` como tempo do evento onde for relevante (`_heal_hero(..., to)`) e ajuste `_end_last_bastion` para receber `at: float`. Guarde `"since"` = `time` no início do bastião (`hero["last_bastion"]["since"] = time` no caso `_cast`).

- [ ] **Step 5: Passar; Step 6: suíte completa; checkpoint.**

---

### Tarefa B5: Build A (Guardião) — A3, A4, A5

Tradução para o slice e números (HIPÓTESE, `unlock_level` 4/7/10):

| ID | Efeito no slice | `kind` e `params` |
| --- | --- | --- |
| `passive_bas_presenca_protetora` (A3) | aliados protegidos por Muralha Viva recebem −10% de dano de **golpes fortes telegrafados** (o único efeito "de controle" que os inimigos têm sobre heróis) | `skill_heavy_guard` `{"skill":"skill_bas_006","value":0.10}` |
| `passive_bas_ninguem_para_tras` (A4) | quando um aliado cai abaixo de 30% de HP (1 vez por aliado a cada 15 s): Bastião ganha +10 Guarda e o aliado −10% de dano por 3 s | `ally_low_guard` `{"threshold":0.3,"guard":10.0,"reduction":0.1,"duration":3.0,"cooldown":15.0}` |
| `passive_bas_guarda_eterna` (A5) | dano fatal em aliado deixa-o com 1 HP e −20% de dano por 2 s; 1 vez a cada 120 s | `guard_eternal` `{"cooldown":120.0,"reduction":0.2,"duration":2.0}` |

**Files:** Modify `data/skills/passives_slice.json`, `ExpeditionRun.gd` (`_cast` caso `buff`, `_damage_taken_multiplier`, `_enemy_attack`); Test `test_kit_bastiao.gd`.

**Interfaces:** Consumes `_damage_taken_multiplier(hero, extra_reduction := 0.0)` → passa a `(hero, extra_reduction := 0.0, heavy := false)`. Produces efeitos com `"only_heavy": true`.

- [ ] **Step 1: Dados** — três linhas em `passives_slice.json`, todas com `"hero":"hero_001","content_set":"slice","status":"HIPOTESE","design_id":null` e `"source"` citando `hero_001_bastiao_passives.md` (A3, A4, A5) e a tradução acima; mais `"unlock_level": 4`, `7`, `10`.

Exemplo completo (A3); as outras seguem o mesmo molde com os `params` da tabela:

```json
  {"id": "passive_bas_presenca_protetora", "design_id": null, "hero": "hero_001", "name": "Presença Protetora", "content_set": "slice", "status": "HIPOTESE", "unlock_level": 4, "kind": "skill_heavy_guard", "params": {"skill": "skill_bas_006", "value": 0.1}, "source": "docs/02_heroes/hero_001_bastiao_passives.md, A3 (resistência a controle); tradução do slice: −10% de dano de golpes fortes telegrafados nos protegidos, pois heróis não sofrem outro controle; valor HIPÓTESE"},
```

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_a() -> void:
	print("\n>>> B5. BUILD GUARDIÃO (A3–A5)")
	# A3: golpe forte telegrafado causa 10% menos no protegido.
	var heavy_mech := {"telegraph": {"id": "t", "every": 3, "windup": 1.5, "coefficient": 2.2, "target": "back", "exposed_duration": 3.0, "exposed_vulnerability": 0.15}}
	var damages: Array = []
	for passives in [[], ["passive_bas_presenca_protetora"]]:
		var run := KitTestSupport.mk([["hero_001", ["skill_bas_006"], passives], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_bas_006": {"type": "enemies_alive"}}, {}, 4)
		KitTestSupport.spawn(run)
		var ally: Dictionary = run._heroes["hero_002"]
		var enemy: Dictionary = run._enemies[0]
		damages.append(run._damage_taken_multiplier(ally, 0.0, true))
	_expect("A3: multiplicador de dano forte cai 10 p.p. no protegido", absf(damages[0] - damages[1] - 0.1) < 0.0001)
	# A4: aliado abaixo de 30% → +10 Guarda no Bastião e −10% no aliado.
	var a4 := KitTestSupport.mk([["hero_001", [], ["passive_bas_ninguem_para_tras"]], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 7)
	KitTestSupport.spawn(a4)
	var before: float = a4._heroes["hero_001"]["guard"]
	a4._heroes["hero_002"]["hp"] = 1000.0
	var ev_a4: Array = []
	a4._check_ally_low(a4._heroes["hero_002"], ev_a4)
	_check("A4: +10 Guarda", float(a4._heroes["hero_001"]["guard"]) - before, 10.0)
	var again: Array = []
	a4._check_ally_low(a4._heroes["hero_002"], again)
	_expect("A4: 1 vez a cada 15 s por aliado", KitTestSupport.of(again, "guard_gained").is_empty())
	# A5: dano fatal em aliado deixa 1 HP; 2ª vez dentro de 120 s não salva.
	var a5 := KitTestSupport.mk([["hero_001", [], ["passive_bas_guarda_eterna"]], ["hero_002", [], []]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 10)
	KitTestSupport.spawn(a5)
	var frail: Dictionary = a5._heroes["hero_002"]
	frail["hp"] = 5.0
	_expect("A5: salva do golpe fatal", a5._try_save_ally(frail, []) and float(frail["hp"]) == 1.0)
	frail["hp"] = 0.0
	_expect("A5: não salva de novo dentro do cooldown", not a5._try_save_ally(frail, []))
```

- [ ] **Step 3: Falha esperada** (funções inexistentes; assinatura de 3 argumentos).

- [ ] **Step 4: Implementar**

(a) `_damage_taken_multiplier`: nova assinatura e filtro:

```gdscript
func _damage_taken_multiplier(hero: Dictionary, extra_reduction: float = 0.0, heavy: bool = false) -> float:
	var mods: Array = []
	for e in _active_effects(hero):
		if e["stat"] == "damage_taken" and (heavy or not bool(e.get("only_heavy", false))):
```
Em `_enemy_attack`, a chamada `CombatMath.hit_damage(raw, _stat(hero, "defense"), 0.0, _damage_taken_multiplier(hero, reduction))` passa `not telegraph.is_empty()` como 3º argumento.

(b) A3 no caso `"buff"` de `_cast`, depois do laço `for t in targets`:

```gdscript
				var heavy_guard: Dictionary = hero["passives"].get("skill_heavy_guard", {})
				if not heavy_guard.is_empty() and heavy_guard["skill"] == def["id"]:
					for t in targets:
						t["effects"].append({"source": def["id"], "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(heavy_guard["value"]),
							"started_at": time, "expires_at": time + float(fx["duration"]), "defensive": true, "only_heavy": true})
```

(c) A4:

```gdscript
## A4 (Ninguém Fica Para Trás): ao cair abaixo do limiar, Bastião ganha Guarda e o aliado recebe redução curta.
func _check_ally_low(ally: Dictionary, events: Array) -> void:
	if not ally["alive"]:
		return
	for hid in _hero_order:
		var guard_hero: Dictionary = _heroes[hid]
		var cfg: Dictionary = guard_hero["passives"].get("ally_low_guard", {})
		if cfg.is_empty() or hid == ally["id"] or not guard_hero["alive"]:
			continue
		var below := float(ally["hp"]) <= float(ally["stats"]["max_hp"]) * float(cfg["threshold"]) + EPS
		var ready := float(guard_hero.get("ally_low_ready", {}).get(ally["id"], -INF)) <= time + EPS
		if below and ready:
			if not guard_hero.has("ally_low_ready"):
				guard_hero["ally_low_ready"] = {}
			guard_hero["ally_low_ready"][ally["id"]] = time + float(cfg["cooldown"])
			_gain_guard(guard_hero, float(cfg["guard"]), events)
			ally["effects"].append({"source": "passive_bas_ninguem_para_tras", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(cfg["reduction"]),
				"started_at": time, "expires_at": time + float(cfg["duration"]), "defensive": true})
```
Chamar `_check_ally_low(hero, events)` em `_enemy_attack` logo depois de `hero["hp"] = maxf(...)` quando `hero["hp"] > 0`.

(d) A5:

```gdscript
## A5 (Guarda Eterna): salva um aliado do golpe fatal (1 HP + redução curta), com recarga longa.
func _try_save_ally(ally: Dictionary, events: Array) -> bool:
	for hid in _hero_order:
		var guardian: Dictionary = _heroes[hid]
		var cfg: Dictionary = guardian["passives"].get("guard_eternal", {})
		if cfg.is_empty() or hid == ally["id"] or not guardian["alive"] or float(guardian.get("eternal_ready_at", -INF)) > time + EPS:
			continue
		guardian["eternal_ready_at"] = time + float(cfg["cooldown"])
		ally["hp"] = 1.0
		ally["effects"].append({"source": "passive_bas_guarda_eterna", "stat": "damage_taken", "op": "ADD_PERCENT", "value": -float(cfg["reduction"]),
			"started_at": time, "expires_at": time + float(cfg["duration"]), "defensive": true})
		events.append({"type": "ally_saved", "time": time, "hero": ally["id"], "by": guardian["id"]})
		return true
	return false
```
Em `_enemy_attack`, no ponto `if float(hero["hp"]) <= 0.0:`, trocar por `if float(hero["hp"]) <= 0.0 and not _try_save_ally(hero, events):`. Atenção: o teste chama `_try_save_ally` com HP 5 → o `ally["hp"]` já é 5, então a função deixa 1; o segundo caso (HP 0) cai no cooldown.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa B6: Build B (Retaliação) — B3, B4, B5

| ID | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- |
| `passive_bas_pressao_acumulada` (B3) | cada bloqueio (Perfect Block ou postura) gera 1 carga (máx. 5, 8 s); cada carga soma +8% ao coeficiente do próximo Contra-Golpe; o Contra-Golpe consome todas | `block_charges_counter` `{"per_charge":0.08,"max_stacks":5,"duration":8.0}` | 4 |
| `passive_bas_quebre_se` (B4) | Elite/Miniboss/Boss que atinge Bastião leva +10 de Stagger; Perfect Block dobra (+20) | `anti_elite_stagger` `{"stagger":10.0,"perfect_multiplier":2.0}` | 7 |
| `passive_bas_julgamento_de_ferro` (B5) | 3 Perfect Blocks com no máximo 12 s entre eles armam o Julgamento: o próximo Contra-Golpe que acertar também dá 1,8×ATK em todos os inimigos | `judgement_iron` `{"required":3,"window":12.0,"coefficient":1.8}` | 10 |

O Golden Reference pede 4 Perfect Blocks no rank 1; usamos 3 (o valor do rank 3) porque com recarga de 8 s do Perfect Block 4 seguidos quase nunca ocorrem — **HIPÓTESE a confirmar no Argos** (registrar em `BALANCE_FINDINGS.md` se o Julgamento nunca disparar).

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_on_perfect_block`, `_enemy_attack`); Test `test_kit_bastiao.gd`.

- [ ] **Step 1: Dados** — 3 linhas com o molde da Tarefa B5.

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_b() -> void:
	print("\n>>> B6. BUILD RETALIAÇÃO (B3–B5)")
	# B3: cada carga soma 8% ao Contra-Golpe; consumo total.
	var run := KitTestSupport.mk([["hero_001", ["skill_bas_007"], ["passive_bas_pressao_acumulada"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {"skill_bas_007": {"type": "enemy_telegraph"}}, {}, 4)
	KitTestSupport.spawn(run)
	KitTestSupport.tank(run)
	var hero: Dictionary = run._heroes["hero_001"]
	for _i in 3:
		run._add_stack(hero, "block_charges_counter")
	_check("B3: 3 cargas", float(run._stacks(hero, "block_charges_counter")), 3.0)
	_check("B3: bônus do Contra-Golpe = 3 × 8%", run._counter_charge_bonus(hero), 0.24)
	_check("B3: consumido depois de calcular", float(run._stacks(hero, "block_charges_counter")), 0.0)
	# B4: Elite que ataca leva +10 (Perfect Block: +20).
	var b4 := KitTestSupport.mk([["hero_001", [], ["passive_bas_quebre_se"]]], [{"enemy_id": "en_c1_001", "count": 1}], {}, {}, {}, 7)
	KitTestSupport.spawn(b4)
	var elite: Dictionary = b4._enemies[0]
	elite["rank"] = "ELITE"
	elite["posture"] = 100.0
	elite["posture_max"] = 100.0
	b4._elite_stagger(b4._heroes["hero_001"], elite, false, [])
	_check("B4: +10 de Stagger num golpe comum", 100.0 - float(elite["posture"]), 10.0)
	elite["posture"] = 100.0
	elite["immune_until"] = -INF
	b4._elite_stagger(b4._heroes["hero_001"], elite, true, [])
	_check("B4: +20 de Stagger num Perfect Block", 100.0 - float(elite["posture"]), 20.0)
	# B5: 3 Perfect Blocks dentro de 12 s armam o Julgamento; janela vencida zera.
	var b5 := KitTestSupport.mk([["hero_001", ["skill_bas_007"], ["passive_bas_julgamento_de_ferro"]]], [{"enemy_id": "en_c1_001", "count": 2}], {}, {"skill_bas_007": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(b5)
	var h5: Dictionary = b5._heroes["hero_001"]
	for _i in 3:
		b5._count_judgement(h5)
	_expect("B5: Julgamento armado com 3 PBs", bool(h5["judgement_ready"]))
	var wave: Array = []
	b5._fire_judgement(h5, wave)
	_expect("B5: onda atinge os 2 inimigos", KitTestSupport.of(wave, "skill_damage").size() == 2 and not bool(h5["judgement_ready"]))
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar** — em `create` (dicionário do herói): `"judgement_count": 0, "judgement_last": -INF, "judgement_ready": false,`. Funções e ganchos:

```gdscript
## B3: bônus somado ao coeficiente do Contra-Golpe pelas cargas; consome todas.
func _counter_charge_bonus(hero: Dictionary) -> float:
	var cfg: Dictionary = hero["passives"].get("block_charges_counter", {})
	if cfg.is_empty():
		return 0.0
	var n := _stacks(hero, "block_charges_counter")
	hero["stacks"].erase("block_charges_counter")
	return float(cfg["per_charge"]) * n

## B4: Elite/Miniboss/Boss que atinge o herói perde postura (dobra no Perfect Block).
func _elite_stagger(hero: Dictionary, enemy: Dictionary, perfect: bool, events: Array) -> void:
	var cfg: Dictionary = hero["passives"].get("anti_elite_stagger", {})
	if cfg.is_empty() or enemy["rank"] == "NORMAL":
		return
	_apply_stagger(enemy, float(cfg["stagger"]) * (float(cfg["perfect_multiplier"]) if perfect else 1.0), events)

## B5: conta Perfect Blocks dentro da janela; ao chegar em `required` arma o Julgamento.
func _count_judgement(hero: Dictionary) -> void:
	var cfg: Dictionary = hero["passives"].get("judgement_iron", {})
	if cfg.is_empty():
		return
	hero["judgement_count"] = (int(hero["judgement_count"]) + 1) if time - float(hero["judgement_last"]) <= float(cfg["window"]) else 1
	hero["judgement_last"] = time
	if int(hero["judgement_count"]) >= int(cfg["required"]):
		hero["judgement_ready"] = true
		hero["judgement_count"] = 0

func _fire_judgement(hero: Dictionary, events: Array) -> void:
	hero["judgement_ready"] = false
	var index := 0
	while true:
		var enemy := _nth_alive_enemy(index)
		if enemy.is_empty():
			break
		_skill_hit(hero, enemy, float(hero["passives"]["judgement_iron"]["coefficient"]), "skill_bas_007", events, {})
		index += 1
```

Ganchos: em `_on_perfect_block` (início): `_add_stack(hero, "block_charges_counter")` se a passiva existir, e `_count_judgement(hero)`; em `_enemy_attack` no ramo `elif stance_hit` também `_add_stack` (B3) — mas só se a passiva existir (`hero["passives"].has(...)`) —, e depois do evento `enemy_attack`: `_elite_stagger(hero, enemy, blocked, events)`. No contra-ataque (`raw_counter = ...`): somar `_counter_charge_bonus(hero)` a `mult` antes de calcular; depois do `counter_attack`, `if hero["judgement_ready"]: _fire_judgement(hero, events)`.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa B7: Build C (Controle) — C1–C5 e Trait Não Passarão

Tradução (sem posição/movimento) e números HIPÓTESE:

| ID | Efeito no slice | `kind` e `params` | `unlock_level` |
| --- | --- | --- | --- |
| `passive_bas_voz_de_comando` (C1) | inimigos provocados: −5% de velocidade de ataque; +1 Guarda por inimigo vivo ao lançar Desafio | `taunt_extra` `{"slow":0.05,"guard_per_enemy":1.0}` | 1 |
| `passive_bas_sem_passagem` (C2) | todos os inimigos: −8% de velocidade de ataque; Desequilibrados −15% | `zone_slow` `{"value":0.08,"value_imbalanced":0.15}` | 1 |
| `passive_bas_choque_de_linha` (C3) | Impacto de Escudo colide com até 2 inimigos atrás (em vez de 1) | `bash_extra` `{"skill":"skill_bas_010","extra_targets":1}` | 4 |
| `passive_bas_formacao_quebrada` (C4) | Impacto de Escudo: stagger +10% em alvo Desequilibrado e o Desequilíbrio passa ao inimigo de trás | `bash_imbalance_spread` `{"skill":"skill_bas_010","stagger_bonus":0.10}` | 7 |
| `passive_bas_linha_inquebravel` (C5) | após Impacto de Escudo, todos os inimigos ficam 20% mais lentos por 3 s e o primeiro é Desequilibrado | `bash_line` `{"skill":"skill_bas_010","duration":3.0,"slow":0.2}` | 10 |
| `trait_bas_nao_passarao` | zona de presença: inimigos −10% de velocidade (Desequilibrados −20%), +10% de stagger recebido de qualquer fonte, +1 Guarda por inimigo provocado | `presence_zone` `{"slow":0.10,"slow_imbalanced":0.20,"stagger_bonus":0.10,"taunt_guard":1.0}` | 1 |

Contenção e Barreira Humana do Trait exigem posição: **fora do slice**, registrado no `source`.

**Files:** Modify `passives_slice.json`, `ExpeditionRun.gd` (`_enemy_act`, `_apply_stagger`, `_cast` casos `taunt` e `shield_bash`); Test `test_kit_bastiao.gd`.

- [ ] **Step 1: Dados** — 6 linhas.

- [ ] **Step 2: Testes (falham)**

```gdscript
func _test_build_c() -> void:
	print("\n>>> B7. BUILD CONTROLE (C1–C5 e Não Passarão)")
	var members := [{"enemy_id": "en_c1_001", "count": 3}]
	# C2 e Trait: slow por herói vivo; vale o maior; Desequilibrado usa o valor maior.
	var run := KitTestSupport.mk([["hero_001", [], ["passive_bas_sem_passagem"]]], members)
	KitTestSupport.spawn(run)
	var enemy: Dictionary = run._enemies[0]
	_check("C2: slow padrão 8%", run._zone_slow(enemy), 0.08)
	enemy["imbalance_until"] = 99.0
	_check("C2: slow em Desequilibrado 15%", run._zone_slow(enemy), 0.15)
	var trait_run := KitTestSupport.mk([["hero_001", [], ["passive_bas_sem_passagem", "trait_bas_nao_passarao"]]], members)
	KitTestSupport.spawn(trait_run)
	_check("Trait: vale o maior entre C2 (8%) e a zona (10%)", trait_run._zone_slow(trait_run._enemies[0]), 0.10)
	# Trait: +10% de stagger recebido.
	var target: Dictionary = trait_run._enemies[0]
	target["posture"] = 100.0
	target["posture_max"] = 100.0
	trait_run._apply_stagger(target, 10.0, [])
	_check("Trait: 10 de stagger viram 11", 100.0 - float(target["posture"]), 11.0)
	# C1: Desafio dá +1 Guarda por inimigo vivo e slow de 5%.
	var c1 := KitTestSupport.mk([["hero_001", ["skill_bas_008"], ["passive_bas_voz_de_comando"]]], members, {}, {"skill_bas_008": {"type": "enemies_alive"}})
	var ev_c1 := KitTestSupport.spawn(c1)
	ev_c1.append_array(c1.step(0.05))
	_expect("C1: Guarda ganha 3 (por inimigo) + 3 (provocar)", float(c1._heroes["hero_001"]["guard"]) >= 6.0)
	_expect("C1: inimigos ficam 5% mais lentos", absf(float(c1._enemies[0]["slow"]) - 0.05) < 0.0001)
	# C3: 2 inimigos atrás recebem colisão; C4: Desequilíbrio passa; C5: linha desacelera todos.
	var c := KitTestSupport.mk([["hero_001", ["skill_bas_010"], ["passive_bas_choque_de_linha", "passive_bas_formacao_quebrada", "passive_bas_linha_inquebravel"]]], members, {"skill_bas_010": 4}, {"skill_bas_010": {"type": "enemy_telegraph"}}, {}, 10)
	KitTestSupport.spawn(c)
	KitTestSupport.tank(c)
	c._heroes["hero_001"]["guard"] = 30.0
	var ev_c: Array = []
	c._cast(c._heroes["hero_001"], c._heroes["hero_001"]["skills"][0], ev_c)
	_expect("C3: golpe + 2×2 colisões", KitTestSupport.damages(ev_c, "skill_damage", "hero_001", "skill_bas_010").size() == 5)
	_expect("C4: Desequilíbrio passou ao inimigo de trás", float(c._enemies[1]["imbalance_until"]) > c.time)
	_expect("C5: todos os inimigos ficam 20% mais lentos", c._enemies.all(func(e): return absf(float(e["slow"]) - 0.2) < 0.0001))
```

- [ ] **Step 3: Falha esperada.**

- [ ] **Step 4: Implementar** — Funções:

```gdscript
## Menor velocidade de ataque imposta ao inimigo pelas passivas de zona (C2 e Não Passarão); vale o maior slow.
func _zone_slow(enemy: Dictionary) -> float:
	var best := 0.0
	var imbalanced := float(enemy["imbalance_until"]) > time + EPS
	for hid in _hero_order:
		var h: Dictionary = _heroes[hid]
		if not h["alive"]:
			continue
		for kind in ["zone_slow", "presence_zone"]:
			var cfg: Dictionary = h["passives"].get(kind, {})
			if not cfg.is_empty():
				best = maxf(best, float(cfg["value_imbalanced" if kind == "zone_slow" else "slow_imbalanced"]) if imbalanced else float(cfg["value" if kind == "zone_slow" else "slow"]))
	return best
```

Em `_enemy_act`, trocar o bloco do slow por:

```gdscript
	var slow := _zone_slow(enemy)
	if float(enemy.get("slow_until", -INF)) > time + EPS:
		slow = maxf(slow, float(enemy["slow"]))
	speed *= 1.0 - slow
```

Em `_apply_stagger`, no início (depois dos `return` de guarda) : 

```gdscript
	for hid in _hero_order:
		var zone: Dictionary = _heroes[hid]["passives"].get("presence_zone", {})
		if not zone.is_empty() and _heroes[hid]["alive"]:
			amount *= 1.0 + float(zone["stagger_bonus"])
			break
```

`taunt` (C1 e Trait): depois do caso `"taunt"`, para cada inimigo vivo: `_gain_guard(hero, guard_per_enemy + taunt_guard, events)`, e se `taunt_extra` existir, `e["slow"] = slow; e["slow_until"] = _taunt["until"]`.

`shield_bash`: (C3) `var collision_count := 1 + int(hero["passives"].get("bash_extra", {}).get("extra_targets", 0))` e trocar o par de golpes de colisão por um laço `for i in range(1, collision_count + 1)` (o primeiro alvo leva 1 golpe de colisão; cada inimigo atrás leva 1); (C4) se a passiva existir e o alvo estava Desequilibrado, multiplicar o stagger do golpe principal por `1 + stagger_bonus` (`fx2 = fx.duplicate(); fx2["stagger"] *= ...`) e depois de aplicar, `_imbalance(behind, events)`; (C5) ao final: para cada inimigo vivo `e["slow"] = cfg.slow; e["slow_until"] = time + cfg.duration` e `_imbalance(bash_target, events)` se o alvo vive.

- [ ] **Step 5: Passar; Step 6: suíte; checkpoint.**

---

### Tarefa B8: Builds, rótulos, registro e verificação do kit

**Files:**
- Modify: `data/heroes/heroes.json` (builds do Bastião)
- Modify: `scripts/combat/SliceSession.gd` (`BUILD_OPTIONS`, `BUILD_LABELS`)
- Modify: `docs/CONTENT_REGISTRY.md`, `docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md` (Parte VI: Estado)
- Test: `tests/unit/test_kit_bastiao.gd`

- [ ] **Step 1: Builds e Signature em `heroes.json`** — no `hero_001` acrescentar `"signature": "skill_bas_011"` (3º slot fixo, decisão de Rafael em 2026-09-30) e substituir `builds` por três builds de 2 skills (sem variantes `_sig`):

```json
"builds": {
  "guardiao":   {"name": "Guardião",   "skills": ["skill_bas_006", "skill_bas_009"], "passives": ["passive_bas_ombro_a_ombro", "passive_bas_escudo_compartilhado", "passive_bas_presenca_protetora", "passive_bas_ninguem_para_tras", "passive_bas_guarda_eterna", "passive_bas_voto_do_escudo"]},
  "retaliacao": {"name": "Retaliação", "skills": ["skill_bas_007", "skill_bas_008"], "passives": ["passive_bas_peso_do_escudo", "passive_bas_momento", "passive_bas_pressao_acumulada", "passive_bas_quebre_se", "passive_bas_julgamento_de_ferro", "passive_bas_ferro_responde"]},
  "controle":   {"name": "Controle",   "skills": ["skill_bas_010", "skill_bas_008"], "passives": ["passive_bas_voz_de_comando", "passive_bas_sem_passagem", "passive_bas_choque_de_linha", "passive_bas_formacao_quebrada", "passive_bas_linha_inquebravel", "trait_bas_nao_passarao"]}
}
```

Motor (`ExpeditionRun.create`): depois do laço das skills da build, acrescentar a Signature do herói se ela existir em `skills` e ainda não estiver na lista (ranks e `trigger_overrides` valem para ela).

Manter `retaliacao_tele` (é `retaliacao` + override de gatilho). O Último Bastião acelera o Contra-Golpe **no lançamento** e termina por um evento do relógio (`bastion_end`), para o log não depender do tamanho do passo.

- [ ] **Step 2: `SliceSession.gd`**

```gdscript
	"hero_001": ["guardiao", "retaliacao", "retaliacao_tele", "controle"],
```
`BUILD_LABELS` já tem o rótulo `controle` ("Controle"), compartilhado com a Íris.

- [ ] **Step 3: Teste de integração do kit**

```gdscript
func _test_full_kit() -> void:
	print("\n>>> B8. KIT COMPLETO")
	var heroes := SliceStats.load_rows("res://data/heroes/heroes.json", "slice")
	var bast: Dictionary = heroes.filter(func(r): return r["id"] == "hero_001")[0]
	var skills := {}
	var passives := {}
	for b in bast["builds"].values():
		for s in b["skills"]:
			skills[s] = true
		for p in b["passives"]:
			passives[p] = true
	_expect("Signature no 3º slot", String(bast.get("signature", "")) == "skill_bas_011")
	skills[String(bast["signature"])] = true
	_expect("6 skills distintas no total (4 antigas + Impacto + Último Bastião)", skills.size() == 6)
	_expect("16 passivas incluindo identidade e Trait, sem 'none' (identidade: %s)" % bast["identity_passive"], passives.size() + 1 >= 16)
	# Toda combinação cria uma run e termina sem erro em níveis 1, 5, 10 e 12.
	for build in bast["builds"]:
		for level in [1, 5, 10, 12]:
			var run := SliceSession.create_run({"hero_001": build, "hero_002": "critico", "hero_003": "arcano"}, level, 3)
			run.run_to_end(0.25, 900.0)
			_expect("build %s nível %d roda até o fim sem erro" % [build, level], run.state == "won" or run.state == "lost")
```

Contagem de passivas: identidade (1) + A1–A5 (5) + B1–B5 (5) + C1–C5 (5) = 16 (os 2 Traits + Não Passarão são os 3 Traits, contados à parte); o teste usa `>= 16` porque os Traits (`voto_do_escudo`, `ferro_responde`, `nao_passarao`) também aparecem no conjunto: 15 + 3 = 18 nós únicos + identidade.

- [ ] **Step 4: Registro** — `docs/CONTENT_REGISTRY.md`: acrescentar `SKILL_BAS_010`, `SKILL_BAS_011`, as 10 passivas/Trait novas com status `IMPLEMENTING` e "runtime: sim"; `BASTIAO_GOLDEN_REFERENCE.md` Parte VI: substituir a linha de estado do kit por "6 skills, 16 passivas, 3 Traits, 3 builds em runtime (HIPÓTESE, 2026-09-30); Contenção e Barreira Humana do Não Passarão fora do slice (exigem posição)".

- [ ] **Step 5: Rodar tudo**

Run: `python tools/run_godot_tests.py` — Expected: todas as cenas PASS.
Run: `python tools/balance/validate_balance_data.py` — Expected: `Balance data: OK`.
Run: `python tools/argos/run.py --scenario slice_quick` — Expected: `0 BUG` (tempo ~2 s por cenário). Se aparecer BUG, corrigir antes de seguir.

- [ ] **Step 6: Checkpoint.** Entregar ao Plano 04 (Argos). **Não** mexer em números de balanceamento aqui: o ajuste acontece no Plano 04, com evidência.
