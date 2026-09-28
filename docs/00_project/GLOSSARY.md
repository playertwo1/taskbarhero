---
status: DESIGN
---

# Glossário do Pocket Hero

**Autoridade:** nomes e definições canônicas dos termos usados entre documentos. A ficha, sistema ou dado indicado continua sendo autoridade sobre detalhes.

| Termo | Definição usada neste projeto | Certeza e fonte |
|---|---|---|
| **Pocket Hero** | Nome do jogo. `taskbarhero` é o nome do repositório. | **DECIDIDO** — [guia de IA](../../documents/AI_PROJECT_GUIDE.md). |
| **MVP** | Primeira entrega Android como aplicativo normal, limitada ao escopo homologado no roadmap. | **DECIDIDO** — [roadmap](../../ROADMAP.md). |
| **Combate automático** | Combate em que as ações ordinárias da party são executadas pelo sistema; o jogador não precisa tocar repetidamente para cada ataque. | **DECIDIDO** como identidade geral; detalhes de controle são **EM ABERTO** — [guia incremental](../design/INCREMENTAL_DESIGN_GUIDE.md). |
| **Party** | Grupo de três heróis escolhidos entre os desbloqueados antes de iniciar uma expedição. | **DECIDIDO** — [pilares de design](GAME_PILLARS.md) e [índice de heróis](../02_heroes/INDEX.md). |
| **Build** | Combinação de escolhas de herói, skills e equipamento que busca uma resposta a objetivo ou desafio. | **DECIDIDO por delegação explícita de Rafael em 2026-09-28** — [Pilares de design](GAME_PILLARS.md); regras de cada build pertencem à ficha/sistema correspondente. |
| **Fase macro** | Uma das cinco grandes etapas de progressão do Bosque que já existem no MVP. | **DECIDIDO** — [overview do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md). |
| **Subfase** | Beat de conteúdo proposto dentro de uma fase macro. As dez registradas são design, não estágios runtime confirmados. | **DESIGN** — [registro de conteúdo](../CONTENT_REGISTRY.md). |
| **Expedição** | Jornada finita iniciada a partir de um objetivo. Termina ao alcançar o objetivo, quando todos os três heróis ativos ficam incapazes de lutar ou ao retornar voluntariamente ao Hub; não há pausa/retomada como estado próprio no primeiro slice. | **DECIDIDO por delegação explícita de Rafael em 2026-09-28** — [loop central](CORE_LOOP.md) e [run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md). |
| **Run** | Fluxo temporário de uma expedição. O fim da run não apaga XP, ouro ou itens obtidos; fases já concluídas permanecem concluídas, e uma fase atual incompleta recomeça do início na próxima expedição. | **DECIDIDO** — regras detalhadas de persistência em [run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md). |
| **Refúgio / Hub** | Espaço entre expedições chamado Refúgio da Vigília; local de preparação, gestão de inventário e progressão global gradual. | **DECIDIDO como direção pós-MVP** — [índice do Hub](../05_hub/INDEX.md); serviços e runtime seguem em design. |
| **Echo / Eco** | Memória preservada/materializada pelo Lúmen. No slice, um Echo opcional ocupa o slot próprio e modifica uma habilidade; não é pet nem moeda. O restante do sistema está fora do escopo mínimo atual. | **DECIDIDO por delegação de Rafael em 2026-09-28** — [Sistema de Ecos](../03_systems/ECHO_SYSTEM.md). |
| **Progressão de run** | Estado e avanço temporário da expedição atual. XP, ouro, itens recebidos e fases concluídas persistem conforme a matriz; a fase incompleta recomeça após uma nova expedição. | **DECIDIDO** — [run/meta](../03_systems/RUN_META_PROGRESSION.md). |
| **Meta-progressão** | Mudanças persistentes que influenciam jornadas futuras; inclui progressão individual dos heróis e sistemas compartilhados da conta/Hub, como a Árvore dos Ecos e serviços desbloqueáveis. | **DECIDIDO como separação de camadas** — [run/meta](../03_systems/RUN_META_PROGRESSION.md); conteúdo e valores ficam nas fontes de sistema. |
| **Progresso offline** | Resolução do avanço enquanto o aplicativo não está aberto. O projeto inclui isso no alvo do MVP; limites e cálculo têm autoridade no design/economia aprovado. | **DECIDIDO** como alvo, valores **EM ABERTO** — [guia de IA](../../documents/AI_PROJECT_GUIDE.md). |
| **Prestige / Ascensão** | Possível reset de longo prazo, fora do MVP e sem sistema aprovado. | **FORA DO MVP; futuro não priorizado** — [guia incremental](../../documents/GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) e roadmap. |
| **Golden** | Referência visual aprovada para orientar a produção de arte; não é regra de gameplay nem aceite automático de toda peça derivada. | Ver [registro Golden](../art/golden/README.md). |

## Convenção

Quando um termo estiver aberto, use a definição provisória acima e aponte para sua fonte. Não criar sinônimos ou redefinir o termo em fichas de conteúdo sem atualizar este glossário e o documento autoritativo da área.
