---
document_type: ai-project-context-and-build-guide
project_id: pocket-hero
repository: playertwo1/taskbarhero
language: pt-BR
reviewed: 2026-09-29
authority: navigation only; defer to repository sources
---

# Pocket Hero — guia curto para agentes

Este arquivo é somente uma porta de entrada. Ele não duplica o estado completo, regras de trabalho, roadmap, lore ou valores do jogo.

## Comece por aqui

1. [`../AGENTS.md`](../AGENTS.md) — instruções, precedência e mapa do repositório.
2. [`../PROJECT_STATE.md`](../PROJECT_STATE.md) — local das fontes observáveis de runtime e estado resumido.
3. [`../ROADMAP.md`](../ROADMAP.md) — roadmap único: prioridade, ordem e gates.
4. [`../docs/INDEX.md`](../docs/INDEX.md) e [`../docs/CONTENT_REGISTRY.md`](../docs/CONTENT_REGISTRY.md) — navegação de design e catálogo de IDs.
5. Para qualquer número do jogo, use o [balanceamento global v1.0](../docs/06_balance/v1/README.md) (constituição primeiro); runtime e medição em [v1 · telemetria e Argos](../docs/06_balance/v1/10_TELEMETRIA_ARGOS.md).
6. Abra apenas o índice e a fonte autoritativa da área afetada.

## Identidade e limites

O produto é **Pocket Hero**; `taskbarhero` é o nome do repositório. É um RPG mobile de combate automático, com identidade visual, personagens, lore, mapas, interface e conteúdo originais. Android como aplicativo normal é a plataforma inicial. O jogo usado como referência serve para observar princípios; não copie seu conteúdo distintivo. Não introduza vantagem de poder paga.

O escopo atual do MVP e os sistemas fora dele estão em [`../AGENTS.md`](../AGENTS.md) e no roadmap. Sobreposição Android, backend/contas, multiplayer, cloud save e monetização não entram no MVP homologado.

## Estado e certeza

O MVP foi homologado em `R19` e substituído pelo vertical slice no `1A-CUT`; consulte o [roadmap concluído arquivado](../arquivados/ROADMAP_CONCLUIDO.md) para o histórico e o [`ROADMAP.md`](../ROADMAP.md) para o trabalho atual. A fundação global de balanceamento está implementada e validada; seus números continuam hipótese até playtest. Confira o roadmap ao iniciar qualquer tarefa porque o estado pode evoluir.

Separe **DECIDIDO**, **RECOMENDADO**, **HIPÓTESE** e **EM ABERTO**. Texto de design não comprova implementação: use JSON em `data/`, cenas/scripts e testes conforme as instruções de [`AGENTS.md`](../AGENTS.md).
