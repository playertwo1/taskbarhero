# AFFIX_FAMILIES_AND_CONFLICTS.md

> **Versão:** 0.2

---

# 1. Objetivo

Stat Budget define “quanto”.

Affix Family define:

```text
o que pode existir junto
```

---

# 2. Famílias

```text
OFFENSE
CRITICAL
SPEED
DEFENSE
SUSTAIN
SKILL
CONTROL
SUMMON
RESOURCE
ELEMENTAL
UTILITY
ECONOMY
UNIQUE
```

---

# 3. Regras por slot

## Weapon

Permitidas:

```text
OFFENSE
CRITICAL
SPEED
SKILL
ELEMENTAL
RESOURCE
UNIQUE
```

Restritas:

```text
DEFENSE
SUSTAIN
```

---

## Secondary

Permitidas:

```text
todas exceto ECONOMY em tiers altos de combate
```

---

## Armor

Permitidas:

```text
DEFENSE
SUSTAIN
CONTROL
RESOURCE
UTILITY
UNIQUE
```

Restritas:

```text
OFFENSE
CRITICAL
```

---

## Accessories

Permitidas:

```text
CRITICAL
SPEED
SKILL
CONTROL
RESOURCE
ELEMENTAL
SUMMON
UTILITY
```

---

## Echo

Permitidas:

```text
todas
```

Mas:

```text
>=50% budget em efeito/build
```

---

# 4. Conflitos fortes

Por padrão, impedir no mesmo item:

```text
Life Steal + Healing Received alto
Crit Chance alto + Crit Damage alto + Attack Speed alto
Summon Damage alto + Hero Damage alto
Move Speed alto + Attack Speed alto em valores máximos
Economy + máximo poder de combate
```

Podem coexistir em valores menores se o budget permitir.

---

# 5. Affix uniqueness

Flags:

```yaml
exclusive_group:
max_per_item:
max_per_loadout:
```

Exemplo:

```yaml
exclusive_group: ON_HIT_EXPLOSION
max_per_item: 1
max_per_loadout: 2
```

---

# 6. Procs

Todo proc precisa de:

```yaml
trigger:
chance:
internal_cooldown:
effect:
```

Baseline:

```text
ICD >= 0.5 s
```

para procs ofensivos comuns.

Sem ICD só quando a matemática foi explicitamente balanceada.

---

# 7. Proc budget

Procs on-hit precisam considerar Attack Speed.

Exemplo:

```text
10% chance
2 ataques/s
≈0.2 proc/s
```

Se AS dobra, proc esperado dobra.

Logo:

```text
proc chance isolada NÃO é orçamento suficiente
```

---

# 8. Roll ranges

Faixa curta:

```text
80–110%
```

do valor nominal por tier.

Não criar item perfeito 5× melhor que item ruim da mesma raridade.

---

# 9. Anti-BiS

Se item/affix for universal:

```text
investigar
```

Gatilhos:

```text
>70% das builds usam o mesmo affix
>60% usam o mesmo item no mesmo slot
```

---

# 10. QA

- [ ] família permitida;
- [ ] conflito validado;
- [ ] budget validado;
- [ ] proc possui ICD;
- [ ] slot correto;
- [ ] max_per_item;
- [ ] max_per_loadout;
- [ ] sem combo exponencial.
