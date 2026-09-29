# Pocket Hero — base canônica de combate, balanceamento e loot v0.4

**Status:** `APPROVED` como base canônica de design por decisão de Rafael em 2026-09-28.  
**Escopo:** estrutura e regras de combate, atributos, inimigos do Capítulo 1, equipamento, raridades, materiais, economia, loot e resolução de recompensas.

O conteúdo integral e os schemas originais estão preservados nesta pasta. O JSON `source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json` é a fonte machine-readable dos 17 inimigos e seus dados de loot. Catálogos Markdown do pacote são visões de leitura quando declaram aquele JSON como autoridade. Não duplique esses registros em outro catálogo detalhado.

## Fontes canônicas

- [Pacote original recebido](TASKBAR_SISTEMA_COMPLETO_v0.4.zip)
- [README e ordem de leitura](source/TASKBAR_SISTEMA_COMPLETO_v0.4/README_v0.4.md)
- [Master de balanceamento e loot](source/TASKBAR_SISTEMA_COMPLETO_v0.4/BALANCE_MASTER.md)
- [Schema canônico de inimigos](source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_CANONICAL_SCHEMA.md)
- [Inimigos e loot do Capítulo 1 (JSON autoritativo)](source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json)
- [Catálogo de inimigos](source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md)
- [Catálogo canônico dos 30 equipamentos](source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md)
- [Materiais do Capítulo 1](source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_MATERIAL_CATALOG.md)
- [Economia de loot](source/TASKBAR_SISTEMA_COMPLETO_v0.4/LOOT_ECONOMY_SYSTEM.md)
- [Qualidade, smart loot e proteção contra repetição](source/TASKBAR_SISTEMA_COMPLETO_v0.4/LOOT_QUALITY_SYSTEM_v0.4.md)
- [Drop Resolver](source/TASKBAR_SISTEMA_COMPLETO_v0.4/DROP_RESOLVER_SPEC.md)
- [Contratos JSON de sistema e loot](source/TASKBAR_SISTEMA_COMPLETO_v0.4/loot_system_contract_v0.4.json) e [systems contract](source/TASKBAR_SISTEMA_COMPLETO_v0.4/systems_contract_v0.2.json)
- [Índice de todos os documentos e arquivos do pacote](source/TASKBAR_SISTEMA_COMPLETO_v0.4/README.md)

## Precedência

1. Esta versão rege o design canônico futuro dos domínios listados no escopo acima e substitui propostas locais incompatíveis de catálogo, raridade, material, loot e balanceamento.
2. Decisões específicas de Pocket Hero que não conflitam com o pacote continuam válidas, incluindo os seis slots de equipamento definidos em [`HERO_STANDARD.md`](../../../HERO_STANDARD.md) e os artesãos na [especificação de equipamento e crafting](../../../docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md).
3. Os arquivos em [`data/`](../../../data/) continuam sendo autoridade exclusiva para o que o MVP carrega hoje. Aprovar este design não renomeia IDs, substitui JSON runtime nem declara sistemas implementados.
4. A fase [`LOOT-EXPANSION-1`](../../../ROADMAP.md#45-loot-expansion-1--integração-v04-ao-runtime--pós-slice) conduz a adaptação, migração de IDs/valores, integração e QA, preservando mapeamentos legados.

## Limites de validação

O `V0.4_VALIDATION.json` declara `PASS` para a validação estrutural interna do pacote. Isso não comprova integração com Godot, equilíbrio em Pocket Hero, comportamento de save ou QA visual. Valores aprovados como base de design ainda precisam atravessar simulação, implementação e os gates de teste previstos na roadmap antes de serem afirmados como balanceados ou implementados.
