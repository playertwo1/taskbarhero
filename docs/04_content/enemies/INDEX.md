# Inimigos — índice

- **Bestário e loot de design canônicos:** [JSON do Capítulo 1](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json). Ele define estrutura, IDs, ranks, arquétipos e dados de loot dos 17 inimigos.
- **Hipótese numérica dos 17:** [atributos derivados e skills por inimigo](CHAPTER_01_COMBAT_PROPOSAL.md); `combat.skills` do JSON canônico continua vazio até migração validada.
- **Schema:** [ENEMY_CANONICAL_SCHEMA](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_CANONICAL_SCHEMA.md).
- **Visão resumida:** [catálogo de inimigos do Capítulo 1](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md); o JSON é a fonte detalhada.
- **Runtime atual:** [inimigos e valores carregados](../../../data/enemies/enemies.json). É implementação legada, não substitui o cânone v0.4.
- **Migração:** [aliases e entidades runtime sem equivalente](../LEGACY_RUNTIME_CATALOG.md).
- **Arte:** [monstros comuns](../../art/conceitos/monstros/README.md), [elites](../../art/conceitos/elites/README.md) e [chefes](../../art/conceitos/chefes/README.md). Confira a ficha visual individual e o contrato Golden antes de gerar sprites.
- **Briefs individuais:** os 12 inimigos sem sprite correspondente têm fichas com descrição visual, perfil de status e resumo de drops nos índices de categoria acima. Descrição visual está em `CONCEPT`; não equivale a aprovação de sprite.
- **Capítulo e encontros:** [overview do Bosque de Lúmen](../chapters/chapter_01/OVERVIEW.md).

Os 17 registros estão `APPROVED` como design canônico. O runtime ainda contém 11 IDs legados; aliases e itens sem mapeamento permanecem explícitos na ponte de migração.
