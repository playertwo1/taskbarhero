---
document_type: project-document-index
project_id: pocket-hero
repository: playertwo1/taskbarhero
language: pt-BR
last_reviewed: 2026-09-28
---

# Pocket Hero — índice de documentos

## Comece aqui

1. Leia [`AI_PROJECT_GUIDE.md`](./AI_PROJECT_GUIDE.md) para identidade, escopo do MVP, princípios, estado registrado, decisões em aberto e regras para agentes.
2. Leia [`../ROADMAP.md`](../ROADMAP.md) antes de executar trabalho: ele define fases, ordem, checklists e critérios de aceite.
3. Abra somente o guia temático necessário para a tarefa. O `AI_PROJECT_GUIDE.md` não substitui o código, o roadmap nem uma decisão de Rafael.

## Hierarquia das fontes

A ordem de autoridade e de carregamento é definida somente em [`../AGENTS.md`](../AGENTS.md) (seções *Ordem de carregamento de contexto* e *Fontes e decisões*). Em resumo: a decisão mais recente de Rafael prevalece; código e testes provam o que existe; o roadmap define plano e gates; guias e referências deste diretório são contexto, não prova nem autorização. Registre qualquer divergência encontrada.

Rótulos usados no guia: **DECIDIDO** = direção registrada como requisito; **RECOMENDADO** = princípio a aplicar salvo conflito; **HIPÓTESE** = valor/ideia a testar; **EM ABERTO** = requer escolha ou confirmação de Rafael; **STATUS REGISTRADO** = evidência datada, que precisa ser atualizada antes de agir se puder ter mudado.

## Guias de base — DOCX original e Markdown

Os DOCX são preservados como fontes originais. As versões Markdown facilitam busca, diff e leitura por agentes; não são uma reprodução visual do Word.

| Assunto | Markdown para leitura | DOCX original |
| --- | --- | --- |
| UX, onboarding, acessibilidade, playtest, ferramentas e QA | [`GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.md`](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.md) | [`GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx`](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx) |
| TBH como referência, tradução original e limites de uso | [`GUIA_IA_REFERENCIA_TBH_POCKET_HERO.md`](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.md) | [`GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx`](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx) |
| Design incremental, unfolding, automação, paredes e progressão | [`GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md`](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) | [`GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx`](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx) |
| Economia, pacing, telemetria, balanceamento e offline | [`GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md`](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md) | [`GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx`](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx) |
| Padrão canônico compartilhado para o roster de heróis | [`../HERO_STANDARD.md`](../HERO_STANDARD.md) | — (fonte Markdown canônica) |
| Equipamentos, crafting e artesãos da cidade (proposta v0.1) | [`../docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md`](../docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) | [`1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx`](./1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx) |
| Árvore global de ressonância / Árvore dos Ecos (proposta v0.1) | [`../docs/03_systems/GLOBAL_RESONANCE_TREE.md`](../docs/03_systems/GLOBAL_RESONANCE_TREE.md) | [`2-Taskbar_Arvore_Global_de_Ressonancia_v0.1.docx`](./2-Taskbar_Arvore_Global_de_Ressonancia_v0.1.docx) |
| Bastião como modelo de design para os heróis (referência v0.1) | [`../docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md`](../docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md) | [`3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx`](./3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx) |
| Referências importadas de balanceamento (Balance Pack v0.1/v0.2) | [`references/balance_pack_v0.1/README.md`](./references/balance_pack_v0.1/README.md) | [`references/balance_pack_v0.1/TASKBAR_BALANCE_PACK_v0.1.zip`](./references/balance_pack_v0.1/TASKBAR_BALANCE_PACK_v0.1.zip) |
| Base canônica de combate, balanceamento e loot v0.4 | [`canonical/taskbar_sistema_v0.4/README.md`](./canonical/taskbar_sistema_v0.4/README.md) | [`canonical/taskbar_sistema_v0.4/TASKBAR_SISTEMA_COMPLETO_v0.4.zip`](./canonical/taskbar_sistema_v0.4/TASKBAR_SISTEMA_COMPLETO_v0.4.zip) |

## Rotas de leitura por tarefa

- **Arquitetura da documentação e catálogos do jogo:** [`../docs/INDEX.md`](../docs/INDEX.md) e [`../docs/CONTENT_REGISTRY.md`](../docs/CONTENT_REGISTRY.md).
- **Escopo, fase atual ou próximo trabalho:** [`../ROADMAP.md`](../ROADMAP.md) + [`../docs/POCKET_HERO_PROJECT_BRIEF.md`](../docs/POCKET_HERO_PROJECT_BRIEF.md).
- **Loop, progressão ou nova mecânica:** [`../docs/00_project/INCREMENTAL_DESIGN_GUIDE.md`](../docs/00_project/INCREMENTAL_DESIGN_GUIDE.md) + guia de design incremental.
- **Usar referências de Task Bar Hero/TBH:** guia de referência, especialmente sua hierarquia de fontes e regras de originalidade.
- **Criar moeda, curva, item, drop, boss, offline ou meta-progressão:** guia avançado de economia e balanceamento.
- **Atributos e estrutura balanceável de entidade:** [padrão canônico de combate](../docs/06_balance/COMBAT_BALANCE_STANDARD.md); use as referências importadas somente como material de estudo.
- **Combate, balanceamento e loot:** siga a [base canônica v0.4](./canonical/taskbar_sistema_v0.4/README.md) para design e o [sistema global](../docs/06_balance/GLOBAL_BALANCE_SYSTEM.md) para runtime, validação e simulação. O slice já usa núcleo + perfil de capítulo; conteúdo fora do recorte continua em `LOOT-EXPANSION-1`.
- **Design pós-MVP de equipamentos, artesãos, Árvore dos Ecos ou Bastião:** consulte as propostas v0.1 na tabela acima e a fase correspondente da [`../ROADMAP.md`](../ROADMAP.md); elas não provam implementação nem aprovação de números.
- **Onboarding, UI, acessibilidade, haptics, bateria, Dev Mode, playtest ou aceite:** guia de UX e playtest.
- **Sprites, contratos de arte e integração:** [`../docs/PIPELINE_IA_SPRITES.md`](../docs/PIPELINE_IA_SPRITES.md) + fase correspondente do roadmap.
- **Direção visual e inventário de ícones/sprites do Capítulo 1:** [`../docs/art/ASSET_VISUAL_BLUEPRINT.md`](../docs/art/ASSET_VISUAL_BLUEPRINT.md).
- **Ideias e prompts por monstro, elite, chefe e item:** [`../docs/art/conceitos/README.md`](../docs/art/conceitos/README.md).
- **Referências e banco de ideias antigo:** [`../docs/REFERENCIAS_TBH.md`](../docs/REFERENCIAS_TBH.md), sempre subordinado aos documentos mais recentes e à política de originalidade.

## Regra de uso por agentes

Use o contexto mínimo suficiente. Antes de propor ou implementar algo, identifique: objetivo do jogador, fase do roadmap, decisão versus hipótese, arquivos afetados, critério de aceite e fonte. Se o pedido envolver uma escolha marcada **EM ABERTO**, não a invente: apresente a alternativa a Rafael. Conteúdo sobre TBH orienta princípios; não autoriza copiar nomes, sprites, mapas, interface, textos, tabelas de balanceamento ou assets.
