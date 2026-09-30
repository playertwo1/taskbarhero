# Pocket Hero — resumo do projeto

> Documento de orientação. [`AGENTS.md`](../../AGENTS.md), [`PROJECT_STATE.md`](../../PROJECT_STATE.md), [`ROADMAP.md`](../../ROADMAP.md), dados e código mantêm autoridade sobre instruções, plano, estado e comportamento.

## Identidade

**Pocket Hero** é um RPG mobile de combate automático com party, equipamento e progressão. `taskbarhero` é o nome do repositório. Android em um aplicativo normal é a plataforma inicial. A identidade de personagens, mundo, arte, mapas, textos e interface é original; outros jogos servem apenas como referência de estrutura e princípios. Não há vantagem de poder paga no escopo aprovado.

## MVP homologado

O MVP foi concluído no gate **R19**, em 2026-09-27. Evidências e checklist estão em [`arquivados/ROADMAP_CONCLUIDO.md`](../../arquivados/ROADMAP_CONCLUIDO.md); o estado e o plano atual estão em [`ROADMAP.md`](../../ROADMAP.md).

O conteúdo de runtime registra o Bosque de Lúmen, cinco fases macro, trio inicial Bastião/Flecha/Íris, oito inimigos comuns, uma elite, um minichefe e um chefe, além de 15 itens de gameplay. O [registro central](../CONTENT_REGISTRY.md) aponta para os catálogos e os JSON autoritativos. Presença de cena, dado ou item não implica que um conceito futuro esteja aprovado ou completo em design.

O [balanceamento v1.0](../06_balance/v1/README.md) é a autoridade de combate, balanceamento, bestiário, equipamentos, materiais e loot para o jogo inteiro. A base não descreve por si só o runtime atual; consulte a [ponte de compatibilidade](../04_content/LEGACY_RUNTIME_CATALOG.md).

## Expansão pós-MVP

- O [padrão canônico dos heróis](../02_heroes/HERO_STANDARD.md) define seis skills (cinco normais e uma Signature) e seis posições de equipamento (Arma, Secundário, Armadura, dois Acessórios e Echo).
- `TREE-1`, `CRAFT-1` e `ITEM-1` foram aprovados como design. Seus valores econômicos e simulação seguem para `ECON-1`; o runtime ainda não foi migrado para os novos sistemas.
- Prioridade, ordem e gates ficam no roadmap único [`ROADMAP.md`](../../ROADMAP.md).

## Visão futura

Novos biomas, endgame, mais sistemas e expansão de catálogo são possibilidades de longo prazo. Não os trate como requisitos fechados; consulte as fases e gates do roadmap antes de produzir conteúdo.

## Arte e navegação

A direção visual, Golden, contratos, conceitos e QA têm entrada em [`docs/07_art/INDEX.md`](../07_art/INDEX.md). Para os fluxos de sprites, leia [`docs/art/conceitos/README.md`](../art/conceitos/README.md) e a documentação apontada pelos índices. A organização completa do repositório está em [`docs/INDEX.md`](../INDEX.md); as fontes DOCX e guias completos estão em [`documents/INDEX.md`](../../documents/INDEX.md).
