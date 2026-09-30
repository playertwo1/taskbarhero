# ENEMY_CANONICAL_SCHEMA.md

> **Anexo técnico da v1.0** (movido da base v0.5/origem v0.4 em 2026-09-30). Define o formato de dados de inimigo com loot usado em `LOOT-EXPANSION-1`. Regras de números: [06_INIMIGOS_CHEFES](../06_INIMIGOS_CHEFES.md) e [07_ECONOMIA_LOOT](../07_ECONOMIA_LOOT.md), que prevalecem em caso de divergência. Dados do Capítulo 1: [CHAPTER_01_ENEMIES_CANONICAL.json](../../../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json).

> **Versão:** 0.4  
> **Estado:** CONTRATO CANÔNICO  
> **Objetivo:** definir a estrutura que TODO inimigo, elite, mini-chefe e boss deve seguir.

---

# 1. Regra principal

A partir da v0.4, **loot faz parte da definição canônica do inimigo**.

Nenhum inimigo deve existir apenas com:

```text
id
nome
stats
skills
```

e ter seus drops escondidos em uma tabela independente sem vínculo.

A entidade canônica contém:

```text
IDENTIDADE
COMBATE
IA
LOOT
MATERIAIS
EQUIPAMENTOS
SIGNATURE DROPS
ECO/MEMÓRIA
PITY/REGRAS ESPECIAIS
```

Tabelas e documentos de capítulo são VISÕES desses mesmos dados.

---

# 2. Estrutura

```yaml
enemy:
  schema_version: "0.4"

  identity:
    id: EN_C1_001
    display_name: Geleia de Lúmen
    chapter_id: CHAPTER_01
    family_id: LUMEN_SLIME
    rank: NORMAL
    archetype: STANDARD
    tags:
      - LUMEN
      - CREATURE

  combat:
    content_level:
    stats_profile:
    damage_types:
    resistances:
    stagger_profile:
    skills:
    status_immunities: []

  ai:
    behavior_profile:
    target_rules:
    encounter_cost:

  loot:
    gold:
      enabled: true
      min: 3
      max: 6
      chance: 1.0

    materials:
      - material_id: MAT_C1_LUMEN_RESIDUE
        chance: 0.65
        quantity_min: 1
        quantity_max: 1

    equipment:
      enabled: true
      chance: 0.10
      rarity_table_id: RARITY_NORMAL_C1
      item_power_profile: C1_NORMAL
      regional_pool_id: POOL_C1_REGIONAL
      personal_pool:
        - ITEM_R_001
      smart_loot: true

    signature_drops:
      - item_id: ITEM_R_001
        chance: 0.02
        quantity: 1
        independent_roll: true

    echo:
      item_id: ITEM_E_001
      base_chance: 0.0035
      bestiary_progression: true

    memory: null

    guaranteed_drops: []

    reward_choice: null

    pity:
      profile_id: null

  telemetry:
    loot_profile_id: EN_C1_001
```

---

# 3. Campos obrigatórios

## `identity`

Obrigatório para todos.

```text
id
display_name
chapter_id
family_id
rank
archetype
tags
```

---

## `combat`

Não duplicar os status finais no arquivo.

Referenciar:

```text
content_level
stats_profile
```

e aplicar a pipeline definida em `ENEMY_STATS_BALANCE.md`.

---

## `loot.gold`

```yaml
gold:
  enabled:
  min:
  max:
  chance:
```

`chance = 1.0` significa que ouro sempre cai.

---

## `loot.materials`

Lista, porque um inimigo pode fornecer mais de um material.

```yaml
materials:
  - material_id:
    chance:
    quantity_min:
    quantity_max:
```

**Não usar apenas `main_material`.**

---

## `loot.equipment`

```yaml
equipment:
  enabled:
  chance:
  rarity_table_id:
  item_power_profile:
  regional_pool_id:
  personal_pool:
  smart_loot:
```

### `personal_pool`

Templates que combinam diretamente com aquele inimigo.

### `regional_pool_id`

Pool compartilhado da região.

O Drop Resolver combina ambos conforme pesos configurados.

---

## `loot.signature_drops`

Itens com identidade direta daquele inimigo.

Roll independente:

```yaml
signature_drops:
  - item_id:
    chance:
    quantity:
    independent_roll: true
```

Signature Drop não substitui o equipamento normal, salvo regra explícita.

---

## `loot.echo`

```yaml
echo:
  item_id:
  base_chance:
  bestiary_progression:
```

Pode ser `null`.

---

## `loot.memory`

Memória narrativa específica.

Normalmente:

```text
null
```

em inimigos comuns.

Memórias importantes usam:

```text
guaranteed / first_clear / scripted
```

e não RNG genérico.

---

## `loot.guaranteed_drops`

Usado por:

- elites;
- mini-chefes;
- bosses;
- first clear;
- eventos.

---

## `loot.reward_choice`

Pode pedir ao Reward System:

```yaml
reward_choice:
  enabled: true
  options: 3
  picks: 1
  source_pool:
```

Não colocar lógica de UI dentro do inimigo.

O inimigo apenas declara a recompensa.

---

## `loot.pity`

Referência a uma regra, nunca contador salvo no inimigo.

```yaml
pity:
  profile_id: PITY_BOSS_RELIC
```

O progresso do jogador fica no Save/Progression System.

---

# 4. Hierarquia

```text
Enemy Definition
├── identity
├── combat
├── ai
├── loot
│   ├── gold
│   ├── materials[]
│   ├── equipment
│   ├── signature_drops[]
│   ├── echo
│   ├── memory
│   ├── guaranteed_drops[]
│   ├── reward_choice
│   └── pity
└── telemetry
```

---

# 5. O que NÃO pode ficar hardcoded

Proibido:

```text
if enemy == "Geleia":
    drop slime_item
```

Correto:

```text
DropResolver.resolve(enemy.loot, player_context)
```

---

# 6. Separação definição / estado

A definição do inimigo guarda:

```text
base_chance
pool
material
pity_profile_id
```

O Save guarda:

```text
boss_kills_without_relic
slot_pity_counters
duplicate_history
bestiary_kills
first_clear_flags
```

Nunca escrever progresso do jogador dentro do arquivo canônico do inimigo.

---

# 7. IDs

Formato:

```text
EN_C1_001
EL_C1_001
MB_C1_001
BOSS_C1_001
```

Materiais:

```text
MAT_C1_*
```

Pools:

```text
POOL_C1_*
```

Pity:

```text
PITY_*
```

Item Power:

```text
IP_*
```

---

# 8. Extensibilidade

Novos capítulos podem adicionar:

```text
novos inimigos
novos materiais
novos pools
novos signatures
```

sem mudar a estrutura.

Se Capítulo 2 precisar de:

```text
machine_parts
```

eles continuam sendo `materials[]`.

Não criar campo especial:

```text
machine_drop:
```

---

# 9. Gate

Um inimigo só está CANONICAL_READY quando:

- [ ] identidade completa;
- [ ] stats_profile;
- [ ] comportamento;
- [ ] encounter_cost;
- [ ] gold;
- [ ] materials[];
- [ ] equipment config;
- [ ] personal/regional pools;
- [ ] signature drops;
- [ ] Eco/Memória explicitamente definidos ou `null`;
- [ ] pity profile definido ou `null`;
- [ ] telemetria identificável.
