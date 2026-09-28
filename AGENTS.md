# Pocket Hero — instruções para agentes de código

## Antes de trabalhar

1. Siga a [ordem de carregamento de contexto](#ordem-de-carregamento-de-contexto), começando por [`PROJECT_STATE.md`](PROJECT_STATE.md).
2. Confira `git status` e preserve todas as alterações pré-existentes, inclusive arquivos não rastreados. Nunca sobrescreva nem inclua esses arquivos no commit por conveniência.

## AGENTS.md como índice

Este arquivo é o índice operacional do repositório. Use [`docs/INDEX.md`](docs/INDEX.md) para escolher uma área e seu `INDEX.md`; use [`documents/INDEX.md`](documents/INDEX.md) para os guias completos e fontes DOCX. Não copie aqui lore, regras, conteúdo ou valores runtime: mantenha cada fato em uma única fonte.

### Ordem de carregamento de contexto

1. [`PROJECT_STATE.md`](PROJECT_STATE.md) — resumo de estado observado e caminhos autoritativos.
2. [`ROADMAP.md`](ROADMAP.md) — prioridade, trabalho atual e gates.
3. [`docs/INDEX.md`](docs/INDEX.md), [`documents/INDEX.md`](documents/INDEX.md) e, quando a tarefa usar sistemas aprovados, [`documents/canonical/INDEX.md`](documents/canonical/INDEX.md).
4. `INDEX.md` da área afetada, conforme a tabela abaixo.
5. Ficha da entidade/conteúdo e documento do sistema envolvido.
6. Dados runtime necessários em [`data/`](data/); eles são autoridade para valores carregados pelo jogo.
7. Código e testes necessários em `scripts/`, `scenes/` e [`tests/`](tests/).

Carregue somente o contexto necessário. Não abra áreas sem relação com a tarefa.

Para tarefas de visão, arquitetura documental ou fundação do jogo, consulte [`docs/00_project/MANUAL_IA_FUNDACAO_DO_JOGO.md`](docs/00_project/MANUAL_IA_FUNDACAO_DO_JOGO.md) depois do índice da área de Projeto. Ele orienta o processo e não substitui a roadmap nem fontes de conteúdo.

### Mapa do repositório

| Local | Autoridade / função | Índice |
| --- | --- | --- |
| `/docs/` | Por quê e como o jogo deve funcionar; intenção e design. | [`docs/INDEX.md`](docs/INDEX.md) |
| `/documents/canonical/` | Fontes canônicas importadas aprovadas; respeite a precedência registrada no `README.md` de cada pacote. | [`documents/canonical/INDEX.md`](documents/canonical/INDEX.md) |
| Estado/plano/histórico | [`PROJECT_STATE.md`](PROJECT_STATE.md), [`ROADMAP.md`](ROADMAP.md) e [`CHANGELOG.md`](CHANGELOG.md) | Estado observado, plano e mudanças têm papéis distintos. |
| `/data/` | Quais IDs e valores o jogo carrega em runtime. | [`docs/CONTENT_REGISTRY.md`](docs/CONTENT_REGISTRY.md) aponta para os catálogos; os JSON são a fonte dos valores. |
| `/scripts/` e `/scenes/` | Como o projeto Godot implementa comportamento. Não existe `/src/` neste repositório hoje. | [Índice de sistemas](docs/03_systems/INDEX.md) |
| `/assets/` | Imagens, animações e outros assets usados pelo projeto. | [Índice de arte](docs/07_art/INDEX.md) |
| `/tests/` | Verificações executáveis e evidência coberta por elas. | [Índice de QA](docs/08_qa/INDEX.md) |
| `/arquivados/` | Registros históricos úteis, versões substituídas e trabalho concluído. | [`arquivados/INDEX.md`](arquivados/INDEX.md) |

### Índices por área

- Projeto: [`docs/00_project/INDEX.md`](docs/00_project/INDEX.md)
- Mundo/lore: [`docs/01_world/INDEX.md`](docs/01_world/INDEX.md)
- Heróis: [`docs/02_heroes/INDEX.md`](docs/02_heroes/INDEX.md) e padrão canônico em [`HERO_STANDARD.md`](HERO_STANDARD.md)
- Sistemas: [`docs/03_systems/INDEX.md`](docs/03_systems/INDEX.md)
- Conteúdo: [`docs/04_content/INDEX.md`](docs/04_content/INDEX.md), com índices próprios para [skills](docs/04_content/skills/INDEX.md), [itens](docs/04_content/items/INDEX.md), [inimigos](docs/04_content/enemies/INDEX.md), [Ecos](docs/04_content/echoes/INDEX.md) e [capítulos](docs/04_content/chapters/INDEX.md)
- Hub: [`docs/05_hub/INDEX.md`](docs/05_hub/INDEX.md)
- Balanceamento: [`docs/06_balance/INDEX.md`](docs/06_balance/INDEX.md)
- Arte: [`docs/07_art/INDEX.md`](docs/07_art/INDEX.md); para [conceitos e prompts de sprites](docs/art/conceitos/README.md), siga o índice por categoria.
- QA: [`docs/08_qa/INDEX.md`](docs/08_qa/INDEX.md)

Não crie fichas vazias para completar essa árvore. Um índice pode apontar uma área ainda sem especificação e dizer isso explicitamente.

## Fontes e decisões

- A instrução mais recente de Rafael prevalece.
- Código e testes mostram o que existe; `ROADMAP.md` define o plano e os gates.
- O guia de IA e os guias de design são contexto, não prova de implementação nem autorização para expandir escopo.
- Separe **DECIDIDO**, **RECOMENDADO**, **HIPÓTESE** e **EM ABERTO**. Não transforme números ou propostas de teste em requisitos finais sem confirmação/evidência.
- Se uma decisão aberta afetar a tarefa, pare e peça a escolha de Rafael em vez de inventá-la.
- **ONE FACT → ONE AUTHORITY:** cada decisão, regra, número ou fato tem uma fonte autoritativa. Índices, roadmap, registry e brief apontam para ela sem copiar seus detalhes. `/docs` guarda intenção; `/data` guarda valores runtime; código implementa; testes provam somente o que executam.
- **Base canônica de combate/loot:** para balanceamento, schema e conteúdo de inimigos, equipamentos, materiais, drops, raridades e economia, siga [TASKBAR Sistema Completo v0.4](documents/canonical/taskbar_sistema_v0.4/README.md), aprovado por Rafael como base canônica de design. O catálogo e os contratos detalhados permanecem nos arquivos de origem indicados pelo índice; não mantenha cópias divergentes.
- IDs de design seguem os prefixos registrados em [`docs/CONTENT_REGISTRY.md`](docs/CONTENT_REGISTRY.md), incluindo os prefixos da base canônica v0.4. IDs runtime atuais em JSON não devem ser renomeados nem substituídos por IDs de design sem migração explícita; registre aliases até o gate de migração.
- Use somente estes status de ciclo de vida para novos registros: `CONCEPT`, `DESIGN`, `APPROVED`, `IMPLEMENTING`, `IMPLEMENTED`, `QA`, `PASS`, `DEPRECATED`. Não confunda status com certeza: use **HIPÓTESE** ou **EM ABERTO** no texto quando necessário. Normalize registros antigos ao tocá-los, sem reclassificar etapa por inferência.

## Produto e originalidade

- O produto é Pocket Hero; `taskbarhero` é o nome do repositório. TBH/Task Bar Hero é apenas referência.
- Preserve identidade, nomes, arte, lore, UI, mapas, textos e balanceamento originais. Não copie assets ou conteúdo distintivo do jogo de referência.
- O MVP é Android como app normal. Overlay, backend, contas, multiplayer, cloud save, monetização e expansão grande de conteúdo estão fora do MVP.
- Não introduza vantagem paga ou sistema que dependa de compra.

## Arte e criação de sprites

Antes de criar um sprite ou ícone, leia [`docs/art/conceitos/README.md`](docs/art/conceitos/README.md) para seguir o fluxo geral e use o índice da pasta da categoria para localizar a ficha individual do asset:

- **Monstros comuns:** [`docs/art/conceitos/monstros/README.md`](docs/art/conceitos/monstros/README.md) — uma ficha por monstro.
- **Elites:** [`docs/art/conceitos/elites/README.md`](docs/art/conceitos/elites/README.md) — uma ficha por elite.
- **Chefes e minichefes:** [`docs/art/conceitos/chefes/README.md`](docs/art/conceitos/chefes/README.md) — uma ficha por chefe.
- **Itens e ícones de equipamento:** [`docs/art/conceitos/itens/README.md`](docs/art/conceitos/itens/README.md) — uma ficha por item.

Abra o arquivo `.md` do asset exato; ele contém a ideia visual e um prompt específico para gerar o conceito. Antes de produzir, consulte também [`docs/art/ASSET_VISUAL_BLUEPRINT.md`](docs/art/ASSET_VISUAL_BLUEPRINT.md), [`docs/art/SPRITE_STYLE_GUIDE.md`](docs/art/SPRITE_STYLE_GUIDE.md) e [`docs/art/PALETTE.md`](docs/art/PALETTE.md). Para assets com contrato ou Golden, siga-os como fonte prioritária. Conceitos marcados como candidatos ou hipóteses não aprovam conteúdo de gameplay.

Para sprites do MVP, use somente os Golden registrados em [`docs/art/golden/README.md`](docs/art/golden/README.md), os contratos atuais e as folhas/manifests `v002` listados em [`docs/art/MVP_SPRITE_INVENTORY.md`](docs/art/MVP_SPRITE_INVENTORY.md). Fontes editáveis e prévias anteriores à aprovação Golden foram removidas; caminhos antigos citados em auditorias/arquivos históricos são registros, não assets disponíveis nem referências visuais. Não execute os pipelines legados `build_styled_*`, `generate_*` ou `build_comfy_anim.py` para produzir ou sobrescrever sprites do MVP.

## Implementação e aceite

- Trabalhe uma fatia do roadmap por vez. Antes de editar, determine arquivos, comportamento esperado e regressão/aceite.
- Para economia e pacing, registrar hipótese, fórmula, fontes/saídas de recursos e como simular ou medir; não chamar números de balanceados sem playtest/telemetria.
- Para arte, usar contrato, QA técnico e auditoria visual independente antes da integração; não escalar produção antes de passar o gate do primeiro asset.
- Execute as verificações pertinentes do roadmap, revise o diff e registre evidência. Teste parcial não fecha uma etapa inteira.
- Não instale ferramentas, altere segurança, faça commit ou push sem pedido explícito de Rafael. Nunca exponha credenciais.
