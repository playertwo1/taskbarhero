# Índice de documentação — Pocket Hero

Abra somente o índice da área necessária. Os índices encaminham para as fontes existentes; áreas sem conteúdo suficiente ainda não têm especificações detalhadas.

| Área | Para que serve | Índice |
| --- | --- | --- |
| Projeto | Visão, decisões, glossário e identidade. | [00 — Projeto](00_project/INDEX.md) |
| Mundo | Lore e regiões. | [01 — Mundo](01_world/INDEX.md) |
| Heróis | Identidade e papéis dos heróis. | [02 — Heróis](02_heroes/INDEX.md) |
| Sistemas | Regras transversais de gameplay. | [03 — Sistemas](03_systems/INDEX.md) |
| Conteúdo | Skills, itens, inimigos, Ecos e capítulos. | [04 — Conteúdo](04_content/INDEX.md) |
| Hub | Espaços e serviços entre expedições. | [05 — Hub](05_hub/INDEX.md) |
| Balanceamento | Estrutura compartilhada, fórmulas, curvas, economia e simulação. | [06 — Balanceamento](06_balance/INDEX.md) |
| Arte | Direção, contratos, conceitos, assets e QA visual. | [07 — Arte](07_art/INDEX.md) |
| QA | Estratégia e evidências de validação. | [08 — QA](08_qa/INDEX.md) |

## Leituras centrais

- [Manual de IA — Fase de Fundação](00_project/MANUAL_IA_FUNDACAO_DO_JOGO.md) — contexto mínimo, fontes de verdade e onde criar cada artefato.
- [Padrão Canônico dos Heróis (HERO_STANDARD.md)](../HERO_STANDARD.md) — fonte única da especificação mandatória de anatomia, progressão, skills, passivas e builds.
- [Estado resumido](../PROJECT_STATE.md) — orientação; fontes citadas mantêm autoridade sobre os detalhes.
- [Roadmap](../ROADMAP.md) — prioridade, fase atual e gates.
- [Registro de conteúdo](CONTENT_REGISTRY.md) — IDs de design e ponteiros para fontes de conteúdo/runtime.
- [Índice de documentos base](../documents/INDEX.md) — guias e originais DOCX.
- [Índice de bases canônicas importadas](../documents/canonical/INDEX.md) — sistemas v0.4 aprovados como autoridade de design.

## Regra de navegação

**Um fato → uma fonte de verdade.** Índices e registry apontam para a fonte; não copiam lore, regras, números de gameplay ou implementação. Consulte [AGENTS.md](../AGENTS.md) para ordem de carregamento e limites entre documentação, runtime e código.

Os templates canônicos de atributos de herói, inimigo, equipamento e efeitos estão no [padrão de balanceamento](06_balance/COMBAT_BALANCE_STANDARD.md); `docs/templates/` continua reservada para modelos documentais reutilizáveis adicionais.
