# CHAPTER_01_ENEMY_CATALOG.md

> **Visão humana do Capítulo 1** (movida da origem v0.4 em 2026-09-30). A fonte dos dados é [CHAPTER_01_ENEMIES_CANONICAL.json](CHAPTER_01_ENEMIES_CANONICAL.json); as regras de números são as da [v1.0](../../06_balance/v1/06_INIMIGOS_CHEFES.md). Os valores runtime do slice estão em `data/enemies/enemies.json`.

> **Versão:** 0.4  
> **Fonte canônica machine-readable:** `CHAPTER_01_ENEMIES_CANONICAL.json`

A partir desta versão, esta tabela é apenas uma visão resumida.

A verdade estrutural é cada objeto `enemy.loot`.

| ID | Nome | Rank | Arquétipo | Gear | Materiais | Personal Pool | Signature | Eco |
|---|---|---|---|---:|---|---|---|---|
| `EN_C1_001` | Geleia de Lúmen | NORMAL | STANDARD | 10% | MAT_C1_LUMEN_RESIDUE | ITEM_R_001 | ITEM_R_001 | ITEM_E_001 |
| `EN_C1_002` | Espírito de Raiz | NORMAL | CONTROLLER | 11% | MAT_C1_ANCESTRAL_FIBER | ITEM_S_003, ITEM_R_009 | ITEM_S_003, ITEM_R_009 | — |
| `EN_C1_003` | Gremlin de Folhas | NORMAL | ASSASSIN | 12% | MAT_C1_ANCESTRAL_FIBER | ITEM_W_002, ITEM_A_001 | ITEM_W_002, ITEM_A_001 | — |
| `EN_C1_004` | Javali de Musgo | NORMAL | HEAVY | 12% | MAT_C1_DENSE_MOSS | ITEM_W_003, ITEM_A_002 | ITEM_W_003, ITEM_A_002 | — |
| `EN_C1_005` | Mariposa Luminosa | NORMAL | SUPPORT | 11% | MAT_C1_LUMEN_RESIDUE | ITEM_R_005 | ITEM_R_005 | ITEM_E_002 |
| `EN_C1_006` | Cogumelo Sonolento | NORMAL | CONTROLLER | 10% | MAT_C1_ANCESTRAL_FIBER | ITEM_R_002, ITEM_S_002 | ITEM_R_002, ITEM_S_002 | — |
| `EN_C1_007` | Trepa-Cadáver | NORMAL | HEAVY | 12% | MAT_C1_ANCESTRAL_FIBER | ITEM_R_009, ITEM_R_007 | ITEM_R_009, ITEM_R_007 | — |
| `EN_C1_008` | Caracol Cristalino | NORMAL | HEAVY | 13% | MAT_C1_GREEN_CRYSTAL | ITEM_A_003, ITEM_R_005 | ITEM_A_003, ITEM_R_005 | — |
| `EN_C1_009` | Raposa Oca | NORMAL | ASSASSIN | 14% | MAT_C1_LUMEN_RESIDUE | ITEM_W_004, ITEM_R_006, ITEM_R_004 | ITEM_R_006, ITEM_R_004 | — |
| `EN_C1_010` | Sapinho do Lúmen | NORMAL | STANDARD | 11% | MAT_C1_LUMEN_RESIDUE | ITEM_R_003, ITEM_R_001 | ITEM_R_003, ITEM_R_001 | — |
| `EL_C1_001` | Geleia Anciã | ELITE | STANDARD | 100% | MAT_C1_LUMEN_RESIDUE, MAT_C1_CORRUPTED_ESSENCE | ITEM_R_001, ITEM_E_001 | ITEM_E_001, ITEM_R_001 | ITEM_E_001 |
| `EL_C1_002` | Javali Cicatrizado | ELITE | HEAVY | 100% | MAT_C1_DENSE_MOSS, MAT_C1_CORRUPTED_ESSENCE | ITEM_W_003, ITEM_A_004 | ITEM_W_003, ITEM_A_004 | — |
| `EL_C1_003` | Gremlin Espinhento | ELITE | ASSASSIN | 100% | MAT_C1_ANCESTRAL_FIBER, MAT_C1_CORRUPTED_ESSENCE | ITEM_W_002, ITEM_A_001 | ITEM_W_002, ITEM_A_001 | — |
| `MB_C1_001` | Rainha das Geleias | MINIBOSS | STANDARD | 100% | MAT_C1_LUMEN_RESIDUE, MAT_C1_CORRUPTED_ESSENCE | ITEM_R_001, ITEM_E_001, ITEM_S_004 | ITEM_R_001, ITEM_E_001, ITEM_S_004 | ITEM_E_001 |
| `MB_C1_002` | Javali da Ponte | MINIBOSS | HEAVY | 100% | MAT_C1_DENSE_MOSS, MAT_C1_CORRUPTED_ESSENCE | ITEM_W_003, ITEM_A_004, ITEM_A_003 | ITEM_W_003, ITEM_A_004, ITEM_A_003 | — |
| `MB_C1_003` | O Espinheiro | MINIBOSS | CONTROLLER | 100% | MAT_C1_ANCESTRAL_FIBER, MAT_C1_CORRUPTED_ESSENCE | ITEM_R_009, ITEM_R_008, ITEM_E_003 | ITEM_R_009, ITEM_R_008, ITEM_E_003 | ITEM_E_003 |
| `BOSS_C1_001` | Guardião-Cervo de Pedra | BOSS | HEAVY | 100% | MAT_C1_CORRUPTED_ESSENCE, MAT_C1_GUARDIAN_SHARD | ITEM_A_005 | ITEM_A_005, ITEM_E_005 | — |

---

# Regra

Para detalhes de:

- quantidades;
- chances;
- rarity table;
- Item Power;
- smart loot;
- pity;
- first clear;
- reward choice;

ler:

```text
CHAPTER_01_ENEMIES_CANONICAL.json
```

e:

```text
ENEMY_CANONICAL_SCHEMA.md
```

Não criar uma segunda fonte de verdade manual.
