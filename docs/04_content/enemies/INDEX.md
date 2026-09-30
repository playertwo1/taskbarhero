# Inimigos — índice

- **Bestário e loot de design canônicos:** [JSON do Capítulo 1](CHAPTER_01_ENEMIES_CANONICAL.json). Ele define estrutura, IDs, ranks, arquétipos e dados de loot dos 17 inimigos.
- **Regras de números:** [v1 · inimigos e chefes](../../06_balance/v1/06_INIMIGOS_CHEFES.md) (referência × arquétipo × rank × capítulo). `combat.skills` do JSON canônico continua vazio até migração validada; os valores do slice estão no runtime.
- **Schema:** [v1 · schema de inimigo](../../06_balance/v1/specs/ENEMY_CANONICAL_SCHEMA.md).
- **Visão resumida:** [catálogo de inimigos do Capítulo 1](CHAPTER_01_ENEMY_CATALOG.md); o JSON é a fonte detalhada.
- **Runtime atual:** [inimigos e valores carregados](../../../data/enemies/enemies.json). Contém só as linhas do slice (`content_set: "slice"`); o legado foi removido no `1A-CUT`. As regras vêm do balanceamento v1.0.
- **Migração:** [aliases e entidades runtime sem equivalente](../LEGACY_RUNTIME_CATALOG.md).
- **Arte:** [monstros comuns](../../art/conceitos/monstros/README.md), [elites](../../art/conceitos/elites/README.md) e [chefes](../../art/conceitos/chefes/README.md). Confira a ficha visual individual e o contrato Golden antes de gerar sprites.
- **Briefs individuais:** os 12 inimigos sem sprite correspondente têm fichas com descrição visual, perfil de status e resumo de drops nos índices de categoria acima. Descrição visual está em `CONCEPT`; não equivale a aprovação de sprite.
- **Capítulo e encontros:** [overview do Bosque de Lúmen](../chapters/chapter_01/OVERVIEW.md).

Os 17 registros estão `APPROVED` como design canônico. O runtime contém 13 registros do slice; os 11 IDs legados foram removidos no `1A-CUT` e seus aliases ficam na ponte de migração.
