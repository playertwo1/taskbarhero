# SYSTEM_INTEGRATION_ORDER.md

> **Versão:** 0.2

---

# 1. Ordem oficial de implementação

```text
1. STATUS SYSTEM
2. DAMAGE TYPES
3. RESOURCE SYSTEM
4. STAGGER SYSTEM
5. THREAT / AGGRO
6. SUMMONS / COMPANIONS
7. HERO STATS
8. ENEMY STATS
9. EQUIPMENT
10. AFFIXES
11. BUFFS / DEBUFFS
12. SKILLS / PASSIVES
13. BOSS RULES
14. DIFFICULTY
15. TELEMETRY
16. COMBAT SIMULATION
17. PLAYTEST / BALANCE PATCH
```

---

# 2. Dependências

```text
DAMAGE TYPES
└── STATUS SYSTEM

RESOURCE SYSTEM
└── EVENT SYSTEM

STAGGER
├── STATUS
└── COMBAT

THREAT
├── COMBAT
└── AI

SUMMONS
├── STATUS
├── THREAT
├── COMBAT
└── RESOURCE

EQUIPMENT
├── STATUS
├── AFFIX
└── BUDGET

BOSS
├── ENEMY
├── STAGGER
├── THREAT
├── STATUS EFFECTS
└── DAMAGE TYPES

TELEMETRY
└── OBSERVA todos; não altera lógica
```

---

# 3. Regra de arquitetura

Sistema dependente pode:

```text
ler
emitir evento
solicitar operação
```

Sistema dependente não pode:

```text
editar estado interno de outro sistema diretamente
```

Exemplo correto:

```text
Skill
→ ResourceSystem.spend(20)
```

Errado:

```text
skill.owner.resource -= 20
```

---

# 4. Eventos canônicos

Recomendados:

```text
DAMAGE_DEALT
DAMAGE_TAKEN
HEAL_APPLIED
SHIELD_APPLIED
STATUS_APPLIED
STATUS_REMOVED
RESOURCE_CHANGED
STAGGER_DAMAGED
STAGGER_BROKEN
SUMMON_CREATED
SUMMON_REMOVED
TARGET_CHANGED
SKILL_CAST
ENTITY_KILLED
PHASE_CHANGED
```

---

# 5. Versionamento

Cada arquivo possui:

```text
major.minor
```

Mudança de número:

```text
0.2 → 0.3
```

Mudança estrutural incompatível:

```text
0.x → 1.0
```

---

# 6. Definition of Done

Um sistema só está DONE quando possui:

```text
schema
runtime
testes
debug
telemetria mínima
documentação
integração
```

---

# 7. Gate v0.2

Antes de balancear skills individualmente:

- [ ] tipos de dano implementáveis;
- [ ] recurso universal definido;
- [ ] stagger definido;
- [ ] threat definido;
- [ ] summons definidos;
- [ ] boss contract definido;
- [ ] affix conflicts definidos;
- [ ] telemetry schema definido.

Quando tudo passar:

```text
READY_FOR_SKILL_BALANCE = true
```
