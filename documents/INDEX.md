---
document_type: project-document-index
project_id: pocket-hero
repository: playertwo1/taskbarhero
language: pt-BR
last_reviewed: 2026-09-26
---

# Pocket Hero — índice de documentos

## Comece aqui

1. Leia [`AI_PROJECT_GUIDE.md`](./AI_PROJECT_GUIDE.md) para identidade, escopo do MVP, princípios, estado registrado, decisões em aberto e regras para agentes.
2. Leia [`../ROADMAP.md`](../ROADMAP.md) antes de executar trabalho: ele define fases, ordem, checklists e critérios de aceite.
3. Abra somente o guia temático necessário para a tarefa. O `AI_PROJECT_GUIDE.md` não substitui o código, o roadmap nem uma decisão de Rafael.

## Hierarquia das fontes

Em caso de conflito, use esta ordem e registre a divergência:

1. Instrução ou decisão explícita mais recente de Rafael.
2. [`../AGENTS.md`](../AGENTS.md) para instruções de trabalho dos agentes.
3. Código e testes atuais para afirmar o que está implementado e verificado.
4. [`../ROADMAP.md`](../ROADMAP.md) para sequência do trabalho e critérios previstos.
5. [`../docs/POCKET_HERO_PROJECT_BRIEF.md`](../docs/POCKET_HERO_PROJECT_BRIEF.md) para o resumo consolidado do projeto e seu estado registrado.
6. [`AI_PROJECT_GUIDE.md`](./AI_PROJECT_GUIDE.md) como contexto curto para agentes.
7. Guias temáticos abaixo: fundamentos e recomendações de design; não converta automaticamente uma hipótese em decisão.
8. Documentos antigos e referências externas: consulte como evidência contextual, respeitando data, tipo de fonte e originalidade do projeto.

Rótulos usados no guia: **DECIDIDO** = direção registrada como requisito; **RECOMENDADO** = princípio a aplicar salvo conflito; **HIPÓTESE** = valor/ideia a testar; **EM ABERTO** = requer escolha ou confirmação de Rafael; **STATUS REGISTRADO** = evidência datada, que precisa ser atualizada antes de agir se puder ter mudado.

## Guias de base — DOCX original e Markdown

Os DOCX são preservados como fontes originais. As versões Markdown facilitam busca, diff e leitura por agentes; não são uma reprodução visual do Word.

| Assunto | Markdown para leitura | DOCX original |
| --- | --- | --- |
| UX, onboarding, acessibilidade, playtest, ferramentas e QA | [`GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.md`](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.md) | [`GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx`](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx) |
| TBH como referência, tradução original e limites de uso | [`GUIA_IA_REFERENCIA_TBH_POCKET_HERO.md`](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.md) | [`GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx`](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx) |
| Design incremental, unfolding, automação, paredes e progressão | [`GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md`](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) | [`GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx`](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx) |
| Economia, pacing, telemetria, balanceamento e offline | [`GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md`](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md) | [`GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx`](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx) |

## Rotas de leitura por tarefa

- **Escopo, fase atual ou próximo trabalho:** [`../ROADMAP.md`](../ROADMAP.md) + [`../docs/POCKET_HERO_PROJECT_BRIEF.md`](../docs/POCKET_HERO_PROJECT_BRIEF.md).
- **Loop, progressão ou nova mecânica:** [`../docs/design/INCREMENTAL_DESIGN_GUIDE.md`](../docs/design/INCREMENTAL_DESIGN_GUIDE.md) + guia de design incremental.
- **Usar referências de Task Bar Hero/TBH:** guia de referência, especialmente sua hierarquia de fontes e regras de originalidade.
- **Criar moeda, curva, item, drop, boss, offline ou meta-progressão:** guia avançado de economia e balanceamento.
- **Onboarding, UI, acessibilidade, haptics, bateria, Dev Mode, playtest ou aceite:** guia de UX e playtest.
- **Sprites, contratos de arte e integração:** [`../docs/PIPELINE_IA_SPRITES.md`](../docs/PIPELINE_IA_SPRITES.md) + fase correspondente do roadmap.
- **Referências e banco de ideias antigo:** [`../docs/REFERENCIAS_TBH.md`](../docs/REFERENCIAS_TBH.md), sempre subordinado aos documentos mais recentes e à política de originalidade.

## Regra de uso por agentes

Use o contexto mínimo suficiente. Antes de propor ou implementar algo, identifique: objetivo do jogador, fase do roadmap, decisão versus hipótese, arquivos afetados, critério de aceite e fonte. Se o pedido envolver uma escolha marcada **EM ABERTO**, não a invente: apresente a alternativa a Rafael. Conteúdo sobre TBH orienta princípios; não autoriza copiar nomes, sprites, mapas, interface, textos, tabelas de balanceamento ou assets.