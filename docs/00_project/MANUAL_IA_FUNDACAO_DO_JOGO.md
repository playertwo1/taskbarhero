# Manual de IA — Fase de Fundação do Pocket Hero

**Revisado em:** 2026-09-28  
**Escopo:** orientar agentes que planejam ou documentam a fundação do jogo após o MVP.  
**Autoridade:** manual de navegação e processo. As decisões de Rafael, `AGENTS.md`, `ROADMAP.md`, código/dados e evidências aplicáveis prevalecem.

## Para que serve

Use este manual para entender **qual contexto carregar, onde criar cada tipo de artefato e como transformar uma ideia em uma entrega verificável**. Ele adapta a proposta de organização discutida [nesta conversa compartilhada](https://chatgpt.com/share/6ab9edf8-745c-83e9-95ce-ae66050ea88e?ogimg=plain) à estrutura que existe de fato no repositório.

Este manual não aprova conteúdo de jogo, substitui a roadmap, nem declara fases concluídas. O [ROADMAP](../../ROADMAP.md) determina a prioridade e os gates atuais; os documentos de cada área continuam sendo a fonte dos detalhes.

## Contexto mínimo para começar

1. Leia [`AGENTS.md`](../../AGENTS.md) e siga a ordem de contexto e as regras de preservação do workspace.
2. Leia [`PROJECT_STATE.md`](../../PROJECT_STATE.md) como mapa do estado observável; confirme detalhes nas fontes apontadas.
3. Leia [`ROADMAP.md`](../../ROADMAP.md) para localizar a tarefa, seu estado e o gate vigente.
4. Leia [`docs/INDEX.md`](../INDEX.md), este manual e o `INDEX.md` da área afetada.
5. Abra somente os documentos da entidade/sistema envolvidos; consulte `/data`, código e testes apenas quando a tarefa exigir.

**Contexto mínimo suficiente:** pare de carregar material quando já souber o objetivo, a fonte de autoridade, o local de edição, as dependências, o aceite e o que continua em aberto. Não leia o projeto inteiro para alterar uma única skill, item ou asset.

## Mapa real de fontes de verdade

| Pergunta | Fonte a consultar |
| --- | --- |
| O que fazer agora e quais gates cumprir? | [`ROADMAP.md`](../../ROADMAP.md) |
| Onde está o estado resumido e quais fontes verificar? | [`PROJECT_STATE.md`](../../PROJECT_STATE.md); é um mapa, não prova por si só. |
| Quais IDs, nomes de catálogo e status de conteúdo estão registrados? | [`docs/CONTENT_REGISTRY.md`](../CONTENT_REGISTRY.md) e o índice da categoria. |
| Quais regras ou efeitos de design foram escritos? | Documento da área/entidade apontado por seu `INDEX.md`; não presuma que uma proposta já foi aprovada. |
| Quais valores o jogo carrega? | JSON e demais dados em [`data/`](../../data/). |
| Como o jogo se comporta hoje? | Cenas em [`scenes/`](../../scenes/) e scripts em [`scripts/`](../../scripts/). |
| Como a arte aparece no jogo? | [`assets/`](../../assets/), contratos, manifests e Golden da área de arte. |
| Que comportamento foi verificado? | Testes em [`tests/`](../../tests/) e resultado observado de sua execução. Um teste cobre apenas o que executa. |
| O que já foi concluído e arquivado? | [`arquivados/`](../../arquivados/). Histórico não é plano ativo. |

**Não existe pasta `/src/` neste repositório Godot.** Para código, procure em `/scripts/` e `/scenes/`. Use `/docs/` para intenção e regras de design, `/data/` para valores runtime, `/assets/` para arte/áudio e `/tests/` para evidência.

## Onde criar cada coisa

Consulte primeiro o índice da área. Crie o documento de detalhe na pasta correspondente apenas quando houver conteúdo suficiente para mantê-lo; não crie arquivos vazios para imitar uma árvore idealizada.

| Tipo de trabalho | Local correspondente | Orientação |
| --- | --- | --- |
| Pilares, visão, decisões e fundamentos do projeto | [`docs/00_project/`](./INDEX.md) | Intenção de alto nível. Este manual é uma orientação de processo, não os pilares do jogo. |
| Lore, regras do mundo, cronologia e regiões | [`docs/01_world/`](../01_world/INDEX.md) | Separe fatos definidos de mistérios e hipóteses. |
| Identidade, papel e história de um herói | [`docs/02_heroes/`](../02_heroes/INDEX.md) | Não misture ficha narrativa com números runtime ou lista detalhada de skills. |
| Regras compartilhadas de combate, party, skills, itens, Ecos ou chefes | [`docs/03_systems/`](../03_systems/INDEX.md) | Descreva o funcionamento geral; o conteúdo individual fica em sua categoria. |
| Skills, itens, inimigos, Ecos e capítulos | [`docs/04_content/`](../04_content/INDEX.md) | Use índices e documentos existentes; confira o registry antes de criar ID ou duplicar catálogo. |
| Refúgio e serviços entre expedições | [`docs/05_hub/`](../05_hub/INDEX.md) | Há um protótipo isolado de UI; o Hub não está integrado ao fluxo principal e não tem especificação global aprovada. Siga a prioridade e as decisões do roadmap. |
| Fórmulas, drops, economia e hipóteses de balanceamento | [`docs/06_balance/`](../06_balance/INDEX.md) | Registrar hipóteses, fontes/saídas e método de medição; não chamar valores de balanceados sem evidência. |
| Direção, contratos, conceitos, sprites e QA visual | [`docs/07_art/`](../07_art/INDEX.md) e [`AGENTS.md`](../../AGENTS.md) | Para sprites, Golden e contrato têm precedência sobre conceitos. |
| Plano de teste, playtest, auditoria e aceite | [`docs/08_qa/`](../08_qa/INDEX.md) | Declare o que cada verificação prova e o que ainda não cobre. |
| IDs e valores usados no jogo | [`data/`](../../data/) | Alterar somente quando o escopo for implementação e o design estiver aprovado. |
| Implementação Godot | [`scripts/`](../../scripts/) e [`scenes/`](../../scenes/) | Confirmar o comportamento existente antes de alterar. |
| Imagens e áudio efetivamente usados | [`assets/`](../../assets/) | Seguir contratos e gates de arte. |
| Evidência automatizada | [`tests/`](../../tests/) | Não tratar teste parcial como aceite de fase completa. |

## Como iniciar uma tarefa da fase de fundação

1. **Localize a fase no roadmap.** Registre o objetivo e o gate; não invente prioridade a partir deste manual.
2. **Escreva o resultado esperado.** Diga qual decisão, regra ou comportamento ficará claro para o jogador/equipe.
3. **Escolha uma autoridade.** Determine qual arquivo será a fonte do novo fato. Outros arquivos devem apontar para ele, não copiar seu conteúdo.
4. **Separe certeza de andamento.** Marque decisões, recomendações, hipóteses e escolhas em aberto conforme abaixo.
5. **Confira o catálogo antes de criar.** Reuse IDs e nomes existentes; peça nova decisão quando houver conflito com material vigente.
6. **Faça a menor fatia coerente.** Escreva apenas o que desbloqueia o próximo gate; não expanda todos os capítulos, heróis ou sistemas de uma vez.
7. **Aponte a navegação.** Atualize o `INDEX.md` pertinente e o registro central quando criar ou mudar uma entidade catalogada.
8. **Mantenha as camadas separadas.** Design em `/docs`; valores finais usados pelo jogo em `/data`; implementação em `/scripts`/`/scenes`; arte em `/assets`; prova em `/tests`.
9. **Feche com evidência e pendências.** Atualize a roadmap somente se o estado/gate realmente mudou. Atualize `PROJECT_STATE.md` somente se mudar o estado observado, sem duplicar checklists.

Antes de editar, identifique os arquivos afetados, o comportamento ou entendimento esperado, as regressões relevantes e o critério de aceite, conforme [`AGENTS.md`](../../AGENTS.md). Preserve todas as mudanças e arquivos não rastreados que já existiam no workspace.

## Decisão, hipótese e status não são a mesma coisa

Use os rótulos de certeza definidos em [`documents/INDEX.md`](../../documents/INDEX.md):

- **DECIDIDO:** instrução ou decisão explícita de Rafael, ou regra já aceita na fonte vigente.
- **RECOMENDADO:** princípio útil, mas sujeito a decisões posteriores.
- **HIPÓTESE:** proposta para validar por protótipo, simulação ou playtest.
- **EM ABERTO:** depende de escolha/validação de Rafael; não preencha por conta própria.

Para registros novos de conteúdo, use os status do [`CONTENT_REGISTRY`](../CONTENT_REGISTRY.md): `CONCEPT`, `DESIGN`, `APPROVED`, `IMPLEMENTING`, `IMPLEMENTED`, `QA`, `PASS` ou `DEPRECATED`. Status descreve o estágio do trabalho, não o grau de certeza. Não transforme **HIPÓTESE** em `APPROVED` por escrever uma ficha.

## IDs, índices e a regra “um fato → uma fonte”

- Consulte [`docs/CONTENT_REGISTRY.md`](../CONTENT_REGISTRY.md) antes de atribuir ID. IDs de design são estáveis e não substituem IDs runtime já usados nos dados.
- Registre IDs novos antes de implementar. Nunca renumere ou reutilize um ID; migração runtime exige decisão explícita.
- Cada área usa seu próprio `INDEX.md` para revelar o que existe e encaminhar para detalhes. Atualize o índice ao criar, mover ou retirar um documento.
- Registre cada regra, número ou identidade em uma única fonte autoritativa. Roadmap, registry e índices podem apontar para ela, sem replicar toda a ficha.
- Use os status de ciclo de vida padronizados; não invente sinônimos como “quase pronto” ou “fazendo”.

## Como usar a conversa compartilhada

A conversa propõe práticas organizacionais que este manual adota: separar design/dados/código/arte/testes, navegar por índices, usar IDs persistentes, padronizar status, minimizar contexto e manter a roadmap focada em entregas e gates.

As listas de habilidades, itens, inimigos, subfases, elites e raridades do chat são **propostas**, não conteúdo aprovado. Algumas diferem do [overview atual do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) e do [`CONTENT_REGISTRY`](../CONTENT_REGISTRY.md). Antes de incorporar uma ideia:

1. compare-a com o conteúdo e os IDs existentes;
2. registre a divergência e a intenção de jogo;
3. peça decisão de Rafael se houver conflito de escopo ou conteúdo;
4. só depois atualize a fonte canônica e seus índices.

O exemplo `/src/` na conversa não descreve este repositório. A implementação Pocket Hero está hoje em `/scripts/` e `/scenes/`.

## Primeira sequência de trabalho

Use a ordem e o estado mais recentes de [`ROADMAP.md`](../../ROADMAP.md). Como referência, a trilha de fundação/expansão vem antes da expansão grande de conteúdo e do vertical slice: concluir validações em andamento; definir pilares, loop, run/meta-progressão e fundação narrativa; reconciliar roster/builds/catálogos existentes; fechar o escopo do Capítulo 1; especificar o Hub mínimo; então planejar uma fatia jogável e seu balanceamento.

Não trate esta frase como um checklist paralelo. Os itens, dependências e critérios de aceite atuais ficam apenas na roadmap. Se a roadmap mudar, siga a versão nova.

## Critério de conclusão de uma tarefa documental

Uma entrega está pronta para revisão quando:

- responde a uma necessidade da fase indicada no roadmap;
- foi escrita no local certo e tem uma única fonte de verdade;
- aponta suas dependências e incertezas sem inventar decisões;
- IDs, nomes e status não entram em conflito com o registry;
- índices e referências foram atualizados;
- critérios de aceite e trabalho restante estão claros.

Documentação pronta não significa sistema implementado, asset aprovado, fase `PASS` ou jogo validado. Use os gates e as evidências exigidas pela roadmap para cada um desses estados.
