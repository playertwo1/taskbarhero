# LOOT_QUALITY_SYSTEM_v0.4.md

> **Versão:** 0.4  
> **Dependência:** `LOOT_ECONOMY_SYSTEM.md`  
> **Objetivo:** tornar o loot útil, previsível o suficiente para não frustrar e ainda emocionante.

---

# 1. Smart Loot moderado

Smart Loot influencia **peso**, não cria item garantido perfeito.

Baseline:

```text
70% relevance budget
30% free budget
```

Na party ativa de 3 heróis:

- 70% do peso favorece slots/affixes úteis para pelo menos um membro;
- 30% permanece completamente aberto.

Smart Loot nunca:

- garante build exata;
- escolhe sempre o maior DPS;
- remove itens para outros heróis;
- altera Relíquias/Memórias exclusivas.

---

# 2. Compatibilidade

Um item é `RELEVANT` se:

```text
pode ser equipado
E
possui pelo menos 1 afinidade útil
```

Afinidades:

```text
TANK
CRIT
MARK
ARCANE
CONTROL
FURY
BURN
EXECUTION
POISON
HEAL
SEED
SUMMON
TRAP
RHYTHM
RESONANCE
GENERIC
```

Itens `GENERIC` são relevantes para todos.

---

# 3. Duplicate Protection

Guardar histórico dos últimos:

```text
6 equipment templates
```

Pesos:

```text
apareceu 1× nos últimos 6 → ×0.70
apareceu 2×              → ×0.40
apareceu 3×              → ×0.15
```

Nunca reduzir a zero.

Relíquia/Memória não usam essa regra quando a fonte é específica.

---

# 4. Slot Pity

Objetivo:

evitar 20 drops sem Arma, Armadura etc.

Slots monitorados:

```text
WEAPON
SECONDARY
ARMOR
ACCESSORY
ECHO
```

`ACCESSORY_I/II` compartilham categoria.

Após:

```text
12 equipment drops sem um slot elegível
```

peso daquele slot:

```text
×1.5
```

Após:

```text
18
```

```text
×2.5
```

Após:

```text
24
```

o próximo equipamento compatível com a fonte prioriza esse slot.

Não se aplica quando o inimigo/pool proíbe o slot.

Contador reseta quando o slot cai.

---

# 5. Quality Floor por raridade

Raridade não pode ser apenas cor.

## Comum

```text
1 affix principal
```

## Incomum

```text
1 principal
1 secundário
```

## Raro

```text
2–3 affixes
>=1 synergy affix
```

## Épico

```text
3–4 affixes
>=1 high-value affix
>=1 synergy affix
```

## Relíquia

```text
efeito único obrigatório
+ stats de suporte
```

## Memória

```text
efeito/lore fixos
sem randomização comum
```

---

# 6. Anti-brick

Após gerar affixes:

```text
validate_affix_conflicts()
validate_budget()
validate_quality_floor()
```

Se falhar:

```text
reroll affixes
```

Máximo:

```text
10 tentativas
```

Se ainda falhar:

```text
fallback deterministic template
```

Nunca entregar item estruturalmente inválido.

---

# 7. Item Power

Raridade define:

```text
complexidade + budget + efeito
```

Item Power define:

```text
escala numérica
```

Formato:

```text
IP 1–100
```

Baseline por conteúdo:

```text
Capítulo 1 Normal:       IP 1–18
Capítulo 1 Elite:        IP 10–24
Capítulo 1 Mini-chefe:   IP 16–28
Capítulo 1 Boss:         IP 22–32
```

O Capítulo 2 começa acima da banda típica do Capítulo 1.

---

# 8. Item Power roll

Dentro da banda:

```text
50% região central
35% região média-alta
10% high roll
 5% near-max
```

Boss first clear:

```text
mínimo = 70% da banda do boss
```

---

# 9. Reutilização de template

Exemplo:

```text
Casco Cristalino
Raro
IP 18
```

mais tarde pode cair como:

```text
Casco Cristalino
Raro
IP 27
```

Não criar:

```text
Casco Cristalino II
Casco Cristalino III
```

só para aumentar números.

---

# 10. Reward Choice

Momentos especiais podem gerar:

```text
3 opções
escolher 1
```

Baseline:

## Elite

```text
não usa por padrão
```

## Mini-chefe

```text
25% chance de Reward Choice
```

## Boss

```text
primeiro clear: Reward Choice garantido
repetição: 35%
```

Reward Choice não substitui drops narrativos garantidos.

---

# 11. Reward Choice generation

As 3 opções devem obedecer:

```text
sem templates duplicados
>=2 slots diferentes quando possível
>=1 opção relevante à party
raridade mínima da fonte
```

---

# 12. Boss Fragments

Boss possui material próprio:

```text
MAT_C1_GUARDIAN_SHARD
Lasca do Guardião-Cervo
```

Repetição:

```text
1–2 garantidas
```

Primeira vitória:

```text
2 garantidas
```

Crafting:

```text
6 Lascas
→ Relíquia aleatória do pool do Guardião

10 Lascas
→ escolher 1 Relíquia do pool do Guardião
```

Ao escolher a receita de 10:

```text
consome 10
```

Não há dupla recompensa.

---

# 13. Eco + Bestiário

Cada espécie pode ter:

```text
bestiary_kills
bestiary_tier
```

Para Eco elegível:

```text
base chance × bestiary multiplier
```

Baseline:

```text
Tier 0 = ×1.00
Tier 1 = ×1.25
Tier 2 = ×1.60
Tier 3 = ×2.00
```

Se Bestiário da espécie chegar ao tier final e o Eco nunca tiver caído:

```text
grant_once = true
```

Isso cria hard pity narrativo.

---

# 14. Bestiário — thresholds iniciais

Inimigo comum:

```text
Tier 1 = 15 kills
Tier 2 = 40 kills
Tier 3 = 80 kills
```

Elite:

```text
Tier 1 = 5
Tier 2 = 12
Tier 3 = 25
```

Mini-chefe/Boss usam registros próprios, não farm massivo.

---

# 15. Drop presentation

Categorias visuais:

```text
EQUIPMENT
MATERIAL
ECHO
RELIC
MEMORY
BOSS_FRAGMENT
```

A apresentação pode variar:

```text
som
partícula
feixe
animação
card
```

mas a lógica de drop permanece independente da UI.

---

# 16. Auto-loot

Recomendado para mobile:

```text
Ouro → automático
Materiais comuns → automático
Equipamento → automático para inventário
Relíquia/Memória → apresentação especial
```

Não obrigar jogador a tocar em dezenas de drops pequenos.

---

# 17. Inventory overflow

Se inventário estiver cheio:

```text
não destruir item raro
```

Política sugerida:

```text
Comum/Incomum → Inbox temporária ou auto-salvage configurável
Raro+ → Reward Inbox garantida
```

A implementação exata pode ser decidida depois.

---

# 18. Telemetria v0.4

Adicionar:

```text
smart_loot_relevance_rate
duplicate_protection_triggers
slot_pity_triggers
quality_floor_rerolls
reward_choice_picks
boss_fragments_earned
boss_fragment_crafts
bestiary_echo_guarantees
item_power_distribution
```

---

# 19. Gate v0.4

PASS quando:

- [ ] smart loot não ultrapassa 70% de viés;
- [ ] itens irrelevantes ainda existem;
- [ ] duplicatas não desaparecem totalmente;
- [ ] slot pity respeita pools;
- [ ] Raro/Épico cumprem Quality Floor;
- [ ] Item Power não altera raridade;
- [ ] boss crafting elimina azar extremo;
- [ ] Eco tem progressão por bestiário;
- [ ] inimigos usam `ENEMY_CANONICAL_SCHEMA.md`.
