# DROP_RESOLVER_SPEC.md

> **Anexo técnico da v1.0** (movido da base v0.5/origem v0.4 em 2026-09-30). Algoritmo do resolvedor de drops. Tabelas, pity e proteções: [07_ECONOMIA_LOOT](../07_ECONOMIA_LOOT.md), que prevalece em caso de divergência. Parâmetros em JSON: [LOOT_CONTRACT.json](LOOT_CONTRACT.json) (lido pelo Argos).

> **Versão:** 0.4  
> **Objetivo:** ordem canônica do algoritmo de recompensa.

---

# 1. Entrada

```yaml
enemy_definition:
player_context:
run_context:
save_progress:
rng_seed:
```

---

# 2. Ordem

```text
01 validate(enemy.loot)
02 resolve_gold()
03 resolve_materials()
04 resolve_guaranteed_drops()
05 resolve_equipment_drop_count()
06 for each equipment:
       resolve_rarity()
       resolve_item_power()
       build_candidate_pool()
       apply_source_weights()
       apply_smart_loot()
       apply_duplicate_protection()
       apply_slot_pity()
       select_template()
       roll_affixes()
       validate_quality_floor()
07 resolve_signature_drops()
08 resolve_echo_or_memory()
09 resolve_reward_choice()
10 update_pity()
11 update_bestiary()
12 emit_telemetry()
```

---

# 3. Precedência

Proteções não devem brigar entre si.

Ordem do peso:

```text
POOL LEGALITY
→ SOURCE WEIGHT
→ SMART LOOT
→ DUPLICATE PROTECTION
→ SLOT PITY
```

`POOL LEGALITY` sempre vence.

Slot pity não pode forçar:

```text
Arma
```

em uma fonte cuja pool só tenha:

```text
Eco
```

---

# 4. Guaranteed Drop

Guaranteed acontece antes do RNG comum.

First Clear:

```text
é idempotente
```

Se o jogo crashar após salvar a recompensa:

```text
não conceder novamente
```

---

# 5. Seed

Debug precisa permitir:

```text
mesmo seed
+
mesmo estado
=
mesmo resultado
```

---

# 6. Reward Choice

Gerar todas as opções antes de mostrar a UI.

Salvar:

```text
choice_offer_id
options
```

antes do jogador escolher, evitando reroll por fechar/reabrir tela.

---

# 7. Pity transactional

Pity só atualiza quando o resultado é confirmado.

Exemplo:

```text
Relíquia caiu
→ resetar boss relic pity
```

Se reward falhar:

```text
não resetar
```

---

# 8. Telemetria

Toda recompensa deve registrar:

```text
enemy_id
source_rank
roll_type
raw_probability
modifiers_applied
final_weight
result
item_power
pity_state_before
pity_state_after
```

Somente em debug/telemetria; não precisa aparecer ao jogador.
