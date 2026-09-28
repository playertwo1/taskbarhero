# BALANCE_TELEMETRY.md

> **Versão:** 0.2

---

# 1. Objetivo

Balancear por evidência.

Não depender apenas de sensação.

---

# 2. Evento base

```yaml
combat_event:
  timestamp:
  run_id:
  encounter_id:
  source_id:
  target_id:
  event_type:
  value:
  skill_id:
  effect_id:
  damage_type:
```

---

# 3. Métricas obrigatórias

## Dano

```text
damage_dealt_total
damage_by_source
damage_by_skill
damage_by_type
damage_by_summon
critical_damage
dot_damage
```

## Recebido

```text
damage_taken_total
damage_taken_by_source
largest_hit_received
```

## Cura

```text
healing_done
effective_healing
overheal
```

## Escudo

```text
shield_generated
shield_consumed
shield_expired
```

## Skills

```text
casts
hits
missed_opportunities
cooldown_uptime
```

## Buffs

```text
buff_uptime
buff_applications
buff_refreshes
```

## Debuffs

```text
debuff_uptime
debuff_applications
resisted_duration
```

## Recursos

```text
generated
spent
overflowed
time_at_zero
time_at_max
```

## Stagger

```text
stagger_damage
breaks
time_to_break
damage_during_break
```

## Summons

```text
summon_uptime
summon_damage
summon_deaths
summon_kills
```

---

# 4. Resultados do encontro

```yaml
encounter_result:
  duration:
  victory:
  deaths:
  damage_dealt:
  damage_taken:
  healing:
  shielding:
  ttk:
  survival_time:
  build_id:
  equipment_score:
```

---

# 5. Privacy / local-first

Para desenvolvimento:

```text
telemetria local
```

é suficiente.

Salvar logs em:

```text
debug/balance/
```

Upload remoto só se decidirmos implementar analytics futuramente.

---

# 6. Percentis

Não olhar apenas média.

Registrar:

```text
P10
P25
P50
P75
P90
```

Exemplo:

```text
TTK médio = 30 s
```

pode esconder:

```text
P10 = 8 s
P90 = 65 s
```

---

# 7. Balance Dashboard

Painel futuro deve comparar:

```text
herói
build
skill
passiva
item
affix
inimigo
boss
dificuldade
```

Métricas principais:

```text
DPS
TTK
survival
pick rate
equip rate
death rate
buff uptime
resource efficiency
```

---

# 8. Alertas

Sinalizar automaticamente:

```text
skill equip rate >80%
item equip rate >60%
affix presence >70%
build clear speed >20% baseline
boss death rate extremo
resource overflow >30%
resource starvation >50% do combate
```

---

# 9. Determinismo

Logs precisam guardar:

```text
seed
```

quando RNG influencia resultado.

Assim bugs podem ser reproduzidos.

---

# 10. QA

- [ ] eventos têm IDs;
- [ ] nenhum cálculo depende da telemetria;
- [ ] logs podem ser desligados;
- [ ] impacto de performance mínimo;
- [ ] seed é salvo em debug;
- [ ] resultados agregam corretamente.
