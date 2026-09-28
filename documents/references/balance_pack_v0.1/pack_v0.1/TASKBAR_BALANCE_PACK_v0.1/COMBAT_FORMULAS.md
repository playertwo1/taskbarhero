# COMBAT_FORMULAS.md

> **Versão:** 0.1  
> **Objetivo:** fonte de verdade das fórmulas de combate.

---

# 1. Ordem geral

```text
Base Stats
→ Level
→ Equipment
→ Passive / Tree
→ Buff / Debuff
→ Final Stats
→ Skill Formula
→ Defense/Penetration
→ Damage Taken modifiers
→ Shield
→ HP
```

---

# 2. Ataque básico

```text
raw = attack
```

Com crítico:

```text
raw = attack × crit_damage
```

Dano médio teórico:

```text
avg_hit =
attack × (1 + crit_chance × (crit_damage - 1))
```

Basic DPS:

```text
basic_dps =
avg_hit × attack_speed
```

---

# 3. Skill

```text
skill_raw_damage =
attack × coefficient
+ optional_flat_component
```

Preferir coefficient.

Flat puro envelhece mal com progressão.

---

# 4. Defesa

```text
effective_defense =
MAX(
    0,
    defense × (1 - armor_pen_pct) - armor_pen_flat
)

mitigation =
effective_defense
/
(effective_defense + 100)

damage =
raw_damage × (1 - mitigation)
```

Depois:

```text
damage *= damage_taken
```

Por fim:

```text
damage = MAX(1, damage)
```

---

# 5. Effective HP

Com `DEFENSE_K = 100`:

```text
EHP =
max_hp / (1 - mitigation)
```

equivalente a:

```text
EHP =
max_hp × (1 + defense / 100)
```

quando não há outras formas de mitigação.

Usar EHP para balanceamento interno.

---

# 6. Crítico

```text
base crit chance = 5%
base crit damage = 1.50×
crit chance cap  = 100%
```

DOT não critica por padrão.

Uma skill/passiva pode habilitar:

```text
can_crit: true
```

---

# 7. Attack Speed

```text
attack_interval = 1 / attack_speed
```

Hard safety:

```text
MIN_ATTACK_INTERVAL = 0.20 s
```

---

# 8. Skill Haste

```text
cooldown =
base_cooldown
/
(1 + skill_haste / 100)
```

Safety:

```text
MIN_SKILL_COOLDOWN = 0.25 s
```

---

# 9. Tenacidade

```text
control_duration =
base_duration
/
(1 + tenacity / 100)
```

---

# 10. Healing

```text
heal =
base_heal
× (1 + healing_power)
× (1 + healing_received)
```

Healing crit não existe por padrão.

Se futuramente existir, deve ser mecânica explicitamente habilitada.

---

# 11. Shield

```text
shield =
base_shield
× (1 + shield_power)
```

Dano consome:

```text
current_shield
```

antes do HP, salvo dano explicitamente marcado para ignorar shield.

---

# 12. DOT/HOT

```text
total_effect =
scaling_stat × total_coefficient
```

```text
tick_value =
total_effect / number_of_ticks
```

Padrão:

```text
DOT/HOT = SNAPSHOT
Aura = DYNAMIC
```

---

# 13. Ordem de modificadores do status

```text
(base + ΣFLAT)
× (1 + ΣADD_PERCENT)
× ΠMULTIPLY
→ OVERRIDE
→ CLAMP
```

---

# 14. Ordem de redução de dano

Baseline:

```text
Raw Damage
→ Defense/Penetration
→ generic damage_taken
→ special mitigation
→ Shield
→ HP
```

Multiplicadores defensivos especiais devem ser raros.

---

# 15. Arredondamento

Runtime mantém precisão.

UI arredonda.

Nunca:

```text
arredondar
→ usar arredondado no cálculo seguinte
```

---

# 16. RNG

Sempre que possível:

```text
seed disponível em debug/test
```

Isso permite reproduzir:

- crítico;
- procs;
- loot;
- affixes;
- comportamento.

---

# 17. Combat Simulation

Criar simulador interno que aceite:

```yaml
hero:
loadout:
enemy:
duration:
seed:
```

e retorne:

```text
DPS
burst_5s
damage_taken
healing
shielding
TTK
survival_time
skill_usage
buff_uptime
debuff_uptime
```

Esse simulador será o principal instrumento de balanceamento.
