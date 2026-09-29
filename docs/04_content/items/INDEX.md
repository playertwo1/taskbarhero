# Itens — índice

- **Catálogo canônico adaptado de 33 itens:** [CHAPTER_01_ITEM_CATALOG](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md). Ele define IDs, nomes, categorias, identidade e compatibilidade inicial: 6 Armas, 7 Secundários, 5 Armaduras, 10 Acessórios e 5 Ecos.
- **Hipóteses quantitativas para tentativas incrementais e versões de itens:** [proposta do Capítulo 1](CHAPTER_01_INCREMENTAL_ITEM_PROPOSAL.md); não é valor runtime nem substitui o catálogo de IDs.
- **Status numéricos candidatos dos 33 templates:** [orçamento por template e fórmula por raridade/IP](CHAPTER_01_ITEM_STATS_PROPOSAL.md); os efeitos funcionais ainda precisam ser precificados contra a reserva de BP.
- **70 variantes calculadas dos 33 templates:** [CSV de comparação em IP 20/nível 10](CHAPTER_01_ITEM_VARIANTS_IP20_L10.csv), gerado por [`export_chapter1_item_variants.py`](../../../tools/balance/export_chapter1_item_variants.py); não é tabela de loot runtime.
- **Raridades, budgets, affixes e Item Power:** [base canônica v0.4](../../../documents/canonical/taskbar_sistema_v0.4/README.md).
- **Materiais e fontes:** [catálogo de materiais do Capítulo 1](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_MATERIAL_CATALOG.md).
- **Loot e algoritmo de recompensa:** [Drop Resolver](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/DROP_RESOLVER_SPEC.md) e [tabelas de drop](../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_DROP_TABLES.md).
- **Runtime atual:** [catálogo e valores carregados](../../../data/items/items.json). Contém só os 18 templates do slice; os 15 itens legados foram removidos no `1A-CUT`. O resto do catálogo segue para `LOOT-EXPANSION-1`.
- **Compatibilidade:** [IDs runtime antigos e mapeamento](../LEGACY_RUNTIME_CATALOG.md).
- **Slots e artesãos:** [HERO_STANDARD](../../../HERO_STANDARD.md) e [equipamentos/crafting](../../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md).
- **Arte:** [fichas dos ícones](../../art/conceitos/itens/README.md) e [assets já integrados](../../../assets/sprites/items/README.md).

Os 30 itens importados são a base `APPROVED` de design; os três templates adicionados na adaptação estão `DESIGN` até integração e QA. O runtime só carrega seus registros atuais.
