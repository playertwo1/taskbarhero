# Sistemas — índice

| Sistema | Regras/intenção | Implementação atual | Evidência relacionada |
| --- | --- | --- | --- |
| Skills | [Sistema de skills](SKILL_SYSTEM.md) | Regras de loadout em design; verificar `data/` e código antes de afirmar implementação | [Catálogo de skills](../04_content/skills/INDEX.md) |
| Run/meta-progressão | [Separação entre run e meta](RUN_META_PROGRESSION.md) | Decisões de design abertas | [Roadmap EXP-DESIGN-1](../../ROADMAP.md) |
| Ecos | [Sistema de Ecos](ECHO_SYSTEM.md) | Um Echo funcional e opcional está incluído no escopo de design do `SLICE-1`; ficha e runtime pendentes | [Índice de conteúdo dos Ecos](../04_content/echoes/INDEX.md) |
| Equipamento/crafting | [Equipamentos e artesãos — CRAFT-1](EQUIPMENT_AND_CRAFTING_SYSTEM.md) | Arquitetura e ordem dos quatro artesãos aprovadas; runtime em [`data/items/items.json`](../../data/items/items.json) não foi alterado. Slots, receitas, custos e balanceamento seguem para `ITEM-1`/`ECON-1`. | [Índice de itens](../04_content/items/INDEX.md) |
| Árvore global de ressonância | [Árvore dos Ecos — catálogo TREE-1](GLOBAL_RESONANCE_TREE.md) | Catálogo de 30 nós e dependências aprovados para design; sem implementação runtime e sem custos balanceados | [Hub](../05_hub/INDEX.md) |
| Combate | [Guia incremental](../design/INCREMENTAL_DESIGN_GUIDE.md) | [`scripts/combat/`](../../scripts/combat/) e [`scenes/`](../../scenes/) | [`tests/test_r10_combat_loop.gd`](../../tests/test_r10_combat_loop.gd) |
| Party/heróis | [Índice de heróis](../02_heroes/INDEX.md) | [`scenes/heroes/`](../../scenes/heroes/) | [`tests/test_r12_party.gd`](../../tests/test_r12_party.gd) |
| Loot/itens | [Índice de itens](../04_content/items/INDEX.md) | [`scripts/loot/`](../../scripts/loot/) + [`data/items/items.json`](../../data/items/items.json) | [`tests/test_r13_loot.gd`](../../tests/test_r13_loot.gd) |
| Fases | [Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) | [`data/stages/stages.json`](../../data/stages/stages.json) | [`tests/test_r14_stages.gd`](../../tests/test_r14_stages.gd) |
| Save/offline | [Guia avançado](../../documents/GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md) | [`scripts/save/`](../../scripts/save/) e [`scripts/progression/`](../../scripts/progression/) | [`tests/test_r15_offline.gd`](../../tests/test_r15_offline.gd) |

Equipamento/crafting e a Árvore dos Ecos ainda não estão implementados. A arquitetura dos artesãos (`CRAFT-1`) e o catálogo da árvore estão aprovados para design; consulte `ITEM-1`/`ECON-1` antes de propor dados runtime. O [índice do Hub](../05_hub/INDEX.md) aponta os artesãos descritos na fonte de equipamento/crafting.
