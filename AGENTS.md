# Pocket Hero — instruções para agentes de código

Vale para qualquer agente (Claude, ChatGPT, Antigravity/Gemini). Este arquivo é curto de propósito: ele dá as regras e aponta para as fontes. Não copie aqui lore, regras de jogo, conteúdo ou valores.

## 1. Antes de trabalhar

1. Leia [`PROJECT_STATE.md`](PROJECT_STATE.md) e as seções 1 (estado) e 3 (agora) do [`ROADMAP.md`](ROADMAP.md).
2. Confira `git status` e preserve alterações pré-existentes, inclusive arquivos não rastreados. Outra sessão pode estar trabalhando ao mesmo tempo: não sobrescreva nem inclua trabalho alheio no commit.
3. Confira se a fatia do roadmap tem **executor definido** (ex.: `NOW-5 · OPUS-ROUND-1` é somente para o Claude Opus). Se você não é o executor indicado, não execute: apenas leia e avise Rafael.
4. Abra só o índice da área da tarefa ([`docs/INDEX.md`](docs/INDEX.md)) e depois a ficha exata. Carregue o mínimo de contexto.

**Onde fica cada coisa e onde criar arquivos novos:** [ESTRUTURA_DO_REPOSITORIO](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md).

## 2. Ordem de autoridade

1. A instrução mais recente de Rafael.
2. [`ROADMAP.md`](ROADMAP.md): plano, prioridade e gates.
3. Documento dono do assunto em `docs/` (intenção e design). Para **qualquer número do jogo**: [balanceamento global v1.0](docs/06_balance/v1/README.md), começando pela [constituição](docs/06_balance/v1/00_CONSTITUICAO.md).
4. [`data/`](data/): valores que o jogo carrega. Código e testes mostram o que existe; testes provam só o que executam.
5. Guias em [`documents/`](documents/INDEX.md) e [`arquivados/`](arquivados/INDEX.md) são contexto e histórico, não autoridade.

**Um fato → uma fonte.** Índices, roadmap, registry e brief apontam, não copiam.

## 3. Decisões e certeza

- Marque tudo como **DECIDIDO**, **RECOMENDADO**, **HIPÓTESE** ou **EM ABERTO**. Não transforme proposta ou número de teste em requisito.
- Se uma decisão aberta afeta a tarefa, pare e pergunte a Rafael. As do balanceamento estão em [11_DECISOES_ABERTAS](docs/06_balance/v1/11_DECISOES_ABERTAS.md).
- Status de ciclo de vida: `CONCEPT`, `DESIGN`, `APPROVED`, `IMPLEMENTING`, `IMPLEMENTED`, `QA`, `PASS`, `DEPRECATED`.
- IDs de design seguem o [registro de conteúdo](docs/CONTENT_REGISTRY.md). Não renomeie IDs runtime sem migração explícita; registre aliases.

## 4. Produto e originalidade

- O produto é **Pocket Hero**, app Android normal; `taskbarhero` é só o nome do repositório. TBH/Task Bar Hero é referência, nunca fonte de assets, nomes, textos ou tabelas.
- O MVP antigo foi substituído pelo slice no `1A-CUT`: não recrie o loop legado nem conteúdo sem `content_set: "slice"`.
- Fora do escopo: overlay, backend, contas, multiplayer, cloud save, monetização, vantagem paga.

## 5. Arte

- Siga o fluxo em [`docs/art/conceitos/README.md`](docs/art/conceitos/README.md) e a ficha exata do asset; Golden e contratos têm prioridade ([`docs/art/golden/README.md`](docs/art/golden/README.md), [índice de arte](docs/07_art/INDEX.md)).
- Contrato → conceito → pixel cleanup → QA técnico → auditoria independente → integração → QA mobile. O primeiro asset passa o gate antes da produção em lote.
- Arte final vem do ComfyUI e do Aseprite, não de scripts que desenham a arte. `assets/` guarda só o que o jogo carrega.

## 6. Verificar antes de afirmar

| Pergunta | Comando |
| --- | --- |
| O código continua correto? | `python tools/run_godot_tests.py` |
| Os dados de balanceamento são válidos? | `python tools/balance/validate_balance_data.py` |
| Como está o balanceamento/loot? | `python tools/argos/run.py --scenario slice_quick` · `slice_balance` · `slice_run_layer` |
| A documentação está íntegra? | `python tools/docs/check_links.py --orphans` |

Regras do Argos (achados, cenários, relatórios): [`tools/argos/README.md`](tools/argos/README.md#regras-de-uso-para-qualquer-agente). Simulação não é playtest.

## 7. Implementação e aceite

- Uma fatia do roadmap por vez. Antes de editar: arquivos, comportamento esperado, regressão e aceite.
- Mudou `/data` ou `scripts/combat/`? Rode o Argos e compare o `REPORT.md`; siga a [política de mudanças de números](docs/06_balance/v1/00_CONSTITUICAO.md#11-política-de-mudanças-de-números).
- Moveu ou criou documento? Reaponte links, ligue-o a um `INDEX.md` e rode o verificador de links.
- Concluído vai para `arquivados/`; obsoleto é excluído (com confirmação de Rafael). Não crie fichas vazias só para completar a árvore.
- Tarefas de visão ou fundação do jogo: consulte também o [manual de IA da fundação](docs/00_project/MANUAL_IA_FUNDACAO_DO_JOGO.md).
- Não instale ferramentas, não altere segurança, não faça commit nem push sem pedido explícito de Rafael. Nunca exponha credenciais.
