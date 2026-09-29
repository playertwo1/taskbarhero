# Sistemas — índice

| Sistema | Regras/intenção | Implementação atual | Evidência relacionada |
| --- | --- | --- | --- |
| Skills | [Sistema de skills](SKILL_SYSTEM.md) | Regras de loadout em design; verificar `data/` e código antes de afirmar implementação | [Catálogo de skills](../04_content/skills/INDEX.md) |
| Run/meta-progressão | [Separação entre run e meta](RUN_META_PROGRESSION.md) | Decisões de design abertas | [Roadmap EXP-DESIGN-1](../../ROADMAP.md) |
| Ecos | [Sistema de Ecos](ECHO_SYSTEM.md) | Um Echo funcional e opcional está incluído no escopo de design do `SLICE-1`; ficha e runtime pendentes | [Índice de conteúdo dos Ecos](../04_content/echoes/INDEX.md) |
| Equipamento/crafting | [Equipamentos e artesãos — CRAFT-1 / ITEM-1](EQUIPMENT_AND_CRAFTING_SYSTEM.md) e [cânone v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md) | Seis posições e 30 itens canônicos; runtime em [`data/items/items.json`](../../data/items/items.json) preserva os registros legados até migração. | [Índice de itens](../04_content/items/INDEX.md) |
| Árvore global de ressonância | [Árvore dos Ecos — catálogo TREE-1](GLOBAL_RESONANCE_TREE.md) | Catálogo de 30 nós e dependências aprovados para design; sem implementação runtime. Conversão de custo em hipótese está no [modelo ECON-1](../06_balance/ECONOMY_MODEL.md). | [Hub](../05_hub/INDEX.md) |
| Combate | [Guia incremental](../00_project/INCREMENTAL_DESIGN_GUIDE.md) | [`scripts/combat/`](../../scripts/combat/) e [`scenes/`](../../scenes/) | [`tests/test_r10_combat_loop.gd`](../../tests/test_r10_combat_loop.gd) |
| Party/heróis | [Índice de heróis](../02_heroes/INDEX.md) | [`scenes/heroes/`](../../scenes/heroes/) | [`tests/test_r12_party.gd`](../../tests/test_r12_party.gd) |
| Loot/itens | [Cânone v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md) e [índice de itens](../04_content/items/INDEX.md) | [`scripts/loot/`](../../scripts/loot/) + [`data/items/items.json`](../../data/items/items.json), sistema antigo até migração | [`tests/test_r13_loot.gd`](../../tests/test_r13_loot.gd) |
| Fases | [Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) | [`data/stages/stages.json`](../../data/stages/stages.json) | [`tests/test_r14_stages.gd`](../../tests/test_r14_stages.gd) |
| Save/offline | [Guia avançado](../../documents/GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md) | [`scripts/save/`](../../scripts/save/) e [`scripts/progression/`](../../scripts/progression/) | [`tests/test_r15_offline.gd`](../../tests/test_r15_offline.gd) |
| Registro de atributos/modificadores | [Padrão compartilhado de balanceamento](../06_balance/COMBAT_BALANCE_STANDARD.md) | Sem migração para runtime neste contrato | [índice de balanceamento](../06_balance/INDEX.md) |

Equipamento/crafting e a Árvore dos Ecos ainda não estão implementados. A arquitetura dos artesãos (`CRAFT-1`), o contrato e catálogo de design dos itens (`ITEM-1`) e o catálogo da árvore estão aprovados. O modelo econômico está em `DESIGN` e ainda precisa passar pela simulação e pelos gates descritos em `ECON-1`. O [índice do Hub](../05_hub/INDEX.md) aponta os artesãos descritos na fonte de equipamento/crafting.
