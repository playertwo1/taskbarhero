# BALANCE_MASTER.md

> **Taskbar Mobile RPG — Balance Pack v0.1**

Este diretório define a primeira régua numérica comum para o jogo.

## Ordem de leitura

1. `STATUS_SYSTEM_BASE.md`
2. `COMBAT_FORMULAS.md`
3. `HERO_STATS_BALANCE.md`
4. `ENEMY_STATS_BALANCE.md`
5. `EQUIPMENT_BALANCE.md`
6. `STAT_BUDGETS.md`
7. `BUFF_DEBUFF_BALANCE.md`
8. `DIFFICULTY_SCALING.md`
9. `BALANCE_QA_CHECKLIST.md`

---

## Contrato principal

```text
STATUS ENGINE
       ↓
HERO BALANCE
       ↓
ENEMY REFERENCE
       ↓
EQUIPMENT / EFFECT BUDGETS
       ↓
DIFFICULTY
       ↓
SIMULATION
       ↓
PLAYTEST
       ↓
BALANCE PATCH
```

---

## O que está congelado

- um registro de status;
- uma pipeline de modificadores;
- mesmos IDs para heróis/inimigos;
- 6 slots de equipamento;
- Stat Budget;
- Defesa com retorno decrescente;
- Skill Haste;
- Tenacidade;
- caps de segurança;
- source_id;
- debug breakdown;
- balanceamento por simulação/playtest.

## O que ainda pode mudar

- HP/ATK/DEF exatos dos heróis;
- coeficientes de skills;
- multiplicadores de inimigos;
- budgets;
- caps de balanceamento;
- dificuldade;
- duração/magnitude de efeitos.

---

## Objetivo do v0.1

Não tentar encontrar os números perfeitos.

O objetivo é garantir que:

```text
TODOS OS NÚMEROS CONVERSEM ENTRE SI
```

e que qualquer ajuste futuro seja mensurável, reproduzível e seguro.
