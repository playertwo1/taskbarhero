# SUMMON_COMPANION_SYSTEM.md

> **Versão:** 0.2

---

# 1. Princípio

Summons usam o mesmo Stat Engine.

Eles não possuem balanceamento independente desconectado do invocador.

---

# 2. Herança

Objeto:

```yaml
summon_scaling:
  max_hp_from_owner:
  attack_from_owner:
  defense_from_owner:
  crit_chance_from_owner:
  crit_damage_from_owner:
  attack_speed_from_owner:
```

---

# 3. Baseline de Forja

Sentinela padrão:

```text
HP       = 35% owner.max_hp
Attack   = 40% owner.attack
Defense  = 50% owner.defense
Crit     = 100% owner.crit_chance
Crit DMG = 100% owner.crit_damage
AS       = definido pelo summon
```

---

# 4. Snapshot

Padrão:

```text
summon stats = SNAPSHOT no momento da invocação
```

Buffs posteriores no dono não recalculam continuamente o summon.

Exceção:

```text
aura compartilhada explicitamente DYNAMIC
```

---

# 5. Limites

Baseline:

```text
max_active_summons = 3
```

Forja pode quebrar isso temporariamente por Signature.

Nunca permitir crescimento sem limite.

---

# 6. Dano total

Regra central:

```text
Hero DPS + Summon DPS = budget total do herói
```

Não:

```text
Hero DPS normal + summons extras grátis
```

Baseline de Forja:

```text
40–60% do DPS total pode vir de constructs
```

dependendo da build.

---

# 7. Summon Death

Ao morrer:

```text
remove modifiers
remove threat
remove collision
remove periodic effects
```

Nunca deixar “ghost effect”.

---

# 8. Threat

Summon gera threat próprio.

Pode possuir:

```text
threat_generation modifier
```

Exemplo:

```text
decoy summon = alto
turret = baixo
```

---

# 9. Stagger

Padrão:

```text
summon_stagger_modifier = 0.50
```

Pode variar por summon.

---

# 10. Crit e procs

Summons não herdam procs do dono por padrão.

Uma passiva precisa declarar:

```text
applies_to_summons: true
```

para evitar multiplicação acidental.

---

# 11. Kill credit

Kill por summon conta como kill do owner para:

- XP;
- loot;
- quest;
- triggers permitidos.

Mas passivas `ON_KILL` devem declarar:

```text
owner_kill_includes_summons: true/false
```

---

# 12. QA

- [ ] scaling correto;
- [ ] snapshot correto;
- [ ] cap de summons;
- [ ] morte limpa tudo;
- [ ] threat separado;
- [ ] kill credit correto;
- [ ] procs não duplicam;
- [ ] performance Android estável com cap máximo.
