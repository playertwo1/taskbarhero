# Balanceamento — índice

- **Modelo ECON-1:** [economia inicial, custos propostos e diagnóstico estático](ECONOMY_MODEL.md). Valores quantitativos são hipóteses; o documento não altera o runtime.
- **Balanceamento v0.5 (vigente no slice):** [meta incremental do Capítulo 1, escala de cada sistema, mudanças sobre o v0.4 e resultado medido pelo Argos](BALANCE_V0.5.md).
- **Contrato de balanceamento do slice:** [status, regras especiais, fórmulas, baselines, budgets e telemetria do recorte do SLICE-1](SLICE_BALANCE_CONTRACT.md), reproduzível com [`slice_baseline.py`](../../tools/balance/slice_baseline.py). Números são hipóteses.
- **Curvas derivadas do trio e 12 skills candidatas com ranks 1–5:** [base de combate do Capítulo 1](CHAPTER_01_HERO_COMBAT_PROPOSAL.md); não é dado runtime.
- **Estrutura canônica de balanceamento:** [atributos compartilhados e registros de heróis, inimigos, equipamentos e efeitos](COMBAT_BALANCE_STANDARD.md). Estrutura aprovada para design; números e integração permanecem separados.
- **Simulações reproduzíveis:** [baseline do runtime legado](../../tools/economy/simulate_econ1_first_clear.py) e [encontros, materiais, Ferreiro e TTK do Capítulo 1](../../tools/economy/simulate_chapter1_balance.py).
- **Materiais importados:** [Balance Pack v0.1/v0.2 e regras de adaptação](../../documents/references/balance_pack_v0.1/README.md); referência, não fonte canônica de números.
- **Fonte canônica de combate e loot:** [TASKBAR Sistema Completo v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md), aprovado para design; integração e validação/runtime seguem a roadmap.
- **Números runtime:** [`data/items/items.json`](../../data/items/items.json), [`data/enemies/enemies.json`](../../data/enemies/enemies.json) e [`data/stages/stages.json`](../../data/stages/stages.json). Os arquivos de dados prevalecem sobre texto de conceito.
- **Regras/metodologia:** [guia avançado de economia, pacing e balanceamento](../../documents/GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md).
- **Achados registrados:** [balance findings](../08_qa/BALANCE_FINDINGS.md).
- **Próximas simulações/telemetria:** [modelo ECON-1](ECONOMY_MODEL.md), roadmap e [arquitetura ARGOS](../08_qa/ARGOS_ARCHITECTURE.md).

Não há uma fórmula de dano canônica separada ainda. Registrar hipótese, fórmula, fontes, saídas e método de medição antes de congelar novos números.
