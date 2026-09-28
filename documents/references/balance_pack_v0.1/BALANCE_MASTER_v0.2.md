# BALANCE_MASTER.md

> **Taskbar Mobile RPG — Balance Pack v0.2**

A v0.2 amplia a base numérica com os sistemas que faltavam para começar a balancear skills e passivas sem criar dependências improvisadas.

---

# Ordem oficial de leitura

## Fundação

1. `STATUS_SYSTEM_BASE.md`
2. `DAMAGE_TYPES_SYSTEM.md`
3. `COMBAT_FORMULAS.md`
4. `RESOURCE_SYSTEM_BASE.md`
5. `STAGGER_SYSTEM.md`
6. `THREAT_AGGRO_SYSTEM.md`
7. `SUMMON_COMPANION_SYSTEM.md`

## Conteúdo

8. `HERO_STATS_BALANCE.md`
9. `ENEMY_STATS_BALANCE.md`
10. `EQUIPMENT_BALANCE.md`
11. `STAT_BUDGETS.md`
12. `AFFIX_FAMILIES_AND_CONFLICTS.md`
13. `BUFF_DEBUFF_BALANCE.md`
14. `BOSS_RULES.md`
15. `DIFFICULTY_SCALING.md`

## Validação

16. `BALANCE_TELEMETRY.md`
17. `BALANCE_QA_CHECKLIST.md`
18. `SYSTEM_INTEGRATION_ORDER.md`

---

# Novos contratos v0.2

## Tipos de dano

```text
PHYSICAL
ARCANE
FIRE
TOXIC
TRUE
```

Poucos tipos, claros e úteis.

---

## Recursos

Todos os recursos especiais dos 8 heróis passam pelo mesmo Resource System.

---

## Stagger

HP e postura são sistemas diferentes.

Chefes continuam vulneráveis a builds de Stagger sem permitir stun-lock infinito.

---

## Threat

Dano, cura, shield e taunt usam regras previsíveis.

---

## Summons

Summons herdam parte dos stats do owner e fazem parte do orçamento total do herói.

---

## Bosses

Boss precisa de comportamento, fases e counterplay.

Nunca ser apenas:

```text
NormalEnemy × 20 HP
```

---

## Affixes

Stat Budget controla quantidade.

Affix Families controla combinações.

---

## Telemetria

Balanceamento precisa ser mensurável.

Registrar:

```text
DPS
TTK
survival
buff uptime
debuff uptime
resources
stagger
summons
equipment/build usage
```

---

# Estado

```text
STATUS FOUNDATION       READY
DAMAGE TYPES            READY
RESOURCE CONTRACT       READY
STAGGER CONTRACT        READY
THREAT CONTRACT         READY
SUMMON CONTRACT         READY
HERO BASELINE           READY
ENEMY BASELINE          READY
EQUIPMENT BASELINE      READY
BUFF/DEBUFF BASELINE    READY
BOSS CONTRACT           READY
DIFFICULTY BASELINE     READY
TELEMETRY CONTRACT      READY

NEXT:
SKILLS + PASSIVES BALANCE
```

---

# Próxima etapa recomendada

Usar Bastião como Golden Reference e criar:

```text
BASTIAO_SKILL_BALANCE.md
BASTIAO_PASSIVE_BALANCE.md
```

Depois repetir a mesma metodologia para os outros 7 heróis.
