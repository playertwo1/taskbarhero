# STATE — ponto de retomada

Qualquer agente deve conseguir retomar só com este arquivo + a seção ativa do `ROADMAP.md` (seções 1 e 3), sem a conversa anterior. Curto: o que não for estado atual sai daqui. Este arquivo era o `PROJECT_STATE.md`; o painel de fontes abaixo foi preservado.

**Atualizado:** 2026-10-17 (última conferência estrutural: 2026-09-30) · **Marco ativo:** `NOW-2 · BALANCE-1` — aplicar o balanceamento v1.0 · **Estado:** IN_PROGRESS (`IMPLEMENTING`)

## O que funciona hoje (confirmado no código)
- Vertical slice do Capítulo 1 jogável (`TitleScreen → SliceCampaign`), QA mobile `PASS` no emulador Pixel 9 (`docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md`).
- Kits do trio (Bastião, Flecha, Íris) em runtime como HIPÓTESE; escala 10× migrada; tela `UI_S12` (`ItemStatView.gd`) integrada.
- Versão do export Android: `0.1.0` (`export_presets.cfg`); tag `v0.1.0` no commit `6038ac6`.

## Última atividade
- ID / commit: `6038ac6` (2026-09-30) — `UI_S12` números de item e integração completa.
- Resultado real: segundo o `ROADMAP.md` §1, suíte Godot 37/37 PASS e validador de balanceamento OK em 2026-09-30.
- Testes executados: NOT_RUN nesta sessão de padronização (2026-10-17, só documentação; sem Godot aqui).
- Evidência: `ROADMAP.md` §1; relatórios do Argos em `tools/argos/reports/`.

## Próxima ação
- `NOW-2 · BALANCE-1`: Rafael decide D-01 a D-09 (`docs/06_balance/v1/11_DECISOES_ABERTAS.md`); sem isso, não gravar números novos em `/data`. Em paralelo, o que não depende de decisão: cenário "jogador de referência" no Argos.

## Bloqueios e aprovações humanas
- `NOW-1 · SLICE-1E`: playtest humano ainda não executado (roteiro em `docs/08_qa/PLAYTEST_1E.md`).
- `NOW-3`: decisões BAL-009 a BAL-015 e D-01 a D-09 aguardam Rafael.
- `NOW-5 · OPUS-ROUND-1`: executor exclusivo Claude Opus, junto com Rafael.
- Commit e push só com pedido explícito de Rafael (`AGENTS.md`).

## Divergências entre roadmap e implementação
- O `CHANGELOG.md` não tinha versões; os números `0.0.x`/`0.1.0` foram atribuídos na padronização pelas datas (a tag `v0.1.0` é a única existente).
- Ainda não há playtest humano; simulação do Argos não substitui playtest.

---

## Painel de fontes (antigo PROJECT_STATE.md)

**Última conferência estrutural:** 2026-09-30 (balanceamento global v1.0 em `docs/06_balance/v1/`; implementação de `UI_S12` com `ItemStatView.gd`; suíte 37/37 PASS; exclusão das fontes duplicadas/obsoletas listadas no [CHANGELOG](CHANGELOG.md)). Este arquivo é um painel de navegação e um resumo observável; não substitui dados, código, testes ou roadmap como fonte de prova.

## Fontes de verdade

- **Plano, prioridade e gates:** [`ROADMAP.md`](ROADMAP.md) — comece pelas seções 1 (estado) e 3 (agora).
- **Implementação:** cenas em [`scenes/`](scenes/) e scripts em [`scripts/`](scripts/). O repositório Godot não tem uma pasta `src/`.
- **Valores carregados pelo jogo:** arquivos JSON sob [`data/`](data/).
- **Balanceamento (design do jogo inteiro):** [balanceamento global v1.0](docs/06_balance/v1/README.md). Não confundir design com os valores que o jogo carrega em `/data`.
- **Arte efetivamente usada pelo projeto:** [`assets/sprites/`](assets/sprites/) (heróis 96px, bestiário 64–224px, itens 64px, hub 256px+, ui_kit e tema em `assets/ui/pocket_hero_theme.tres`). Fontes e pipelines em [`work/art_pipeline/`](work/art_pipeline/) e especificações em [`docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md`](docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md).
- **Evidência de comportamento:** arquivos sob [`tests/`](tests/) e resultados de execução registrados no roadmap.
- **Histórico concluído:** [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

## Conferir o estado real

Este arquivo não duplica contagens ou checklists. Use os caminhos abaixo para inspecionar estado observável; o [registro central](docs/CONTENT_REGISTRY.md) resume quais catálogos existem e quais são propostas.

- Heróis/runtime: [`scenes/heroes/`](scenes/heroes/) e [`data/heroes/heroes.json`](data/heroes/heroes.json); sprites 96×96 em [`assets/sprites/heroes/`](assets/sprites/heroes/). Fichas canônicas completas no padrão [`HERO_STANDARD.md`](docs/02_heroes/HERO_STANDARD.md) (lore de fundação, 5 missões pessoais, equipamentos/Ecos e evolução visual): Bastião (`HERO_001`), Flecha (`HERO_002`) e Íris (`HERO_003`) em [`docs/02_heroes/`](docs/02_heroes/).
- Fluxo jogável: [`scenes/ui/TitleScreen.tscn`](scenes/ui/TitleScreen.tscn) → [`scenes/slice/SliceCampaign.tscn`](scenes/slice/SliceCampaign.tscn); tela em [`scripts/ui/SliceCampaignScreen.gd`](scripts/ui/SliceCampaignScreen.gd) (com arena visual do Bosque de Lúmen, Refúgio visual UI_S02 com banner dinâmico e trio descansando, TopBar de recursos e tema integrado), combate em [`scripts/combat/ExpeditionRun.gd`](scripts/combat/ExpeditionRun.gd) e camada de campanha em [`scripts/run/`](scripts/run/).
- Progressão do Refúgio (1D): [`data/progression/`](data/progression/) (Árvore de 6 nós e regras do Ferreiro), [`scripts/run/ResonanceTree.gd`](scripts/run/ResonanceTree.gd) e painéis em [`scripts/ui/`](scripts/ui/) (`ResonanceTreePanel`, `BlacksmithPanel`). Marcos de Fragmentos ficam em `route_c1.json`.
- Telas do slice: contratos de UX e de arte em [`docs/09_ui/`](docs/09_ui/INDEX.md); implementação em `scripts/ui/` (campanha com Refúgio visual, loadout tátil dos heróis com miniaturas e descrições dinâmicas de builds, tela de resultado enriquecida com badges de recursos e grade de itens, inventário e ferreiro com ícones 64×64 e raridade colorida via `ItemIconResolver.gd`, números de itens, comparação e gaveta de detalhes via `ItemStatView.gd` (UI_S12), painéis estilizados com tema AMOLED nativo e UI Kit 9-slice, Árvore, pausa/velocidades).
- Itens/runtime: [`data/items/items.json`](data/items/items.json); ícones 64×64 em [`assets/sprites/items/icons_64/`](assets/sprites/items/icons_64/) integrados dinamicamente via `scripts/ui/ItemIconResolver.gd`.
- Inimigos/runtime: [`data/enemies/enemies.json`](data/enemies/enemies.json); bestiário de alta densidade em [`assets/sprites/enemies/highres/`](assets/sprites/enemies/highres/).
- Rota/runtime: [`data/expedition/route_c1.json`](data/expedition/route_c1.json) (o legado `stages.json` foi removido no `1A-CUT`).
- Balanceamento/runtime: [`data/balance/combat_profiles.json`](data/balance/combat_profiles.json) compõe o [núcleo global](data/balance/combat_core.json) com o [perfil do Capítulo 1](data/balance/chapters/chapter_01.json); arquitetura em [v1 · telemetria e Argos](docs/06_balance/v1/10_TELEMETRIA_ARGOS.md).
- Skills/design e capítulo: [overview do Capítulo 1](docs/04_content/chapters/chapter_01/OVERVIEW.md); o plano proposto de encontros e boss está em [ENCOUNTERS.md](docs/04_content/chapters/chapter_01/ENCOUNTERS.md), com simulação ligada à [roadmap](ROADMAP.md). Confira código e `/data` antes de afirmar implementação.
- Evidência de validação: [`tests/`](tests/), [relatórios do Argos](tools/argos/reports/), relatório de QA Mobile no Pixel 9 e resultados/gates em [`ROADMAP.md`](ROADMAP.md). O número atual de cenas e o último relatório do Argos ficam na seção 1 do [roadmap](ROADMAP.md); o QA mobile no Pixel 9 está em [`docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md`](docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md). Playtest humano ainda não foi feito.

## Estado de produção

Consulte o roadmap para a situação atual do MVP, sprites, QA, conteúdo e trabalho futuro. Não replique aqui checklists que possam divergir. Alterações locais e arquivos não rastreados pertencem ao workspace do usuário: preserve-os e confira `git status` antes de qualquer mudança.

## Navegação

- [README do repositório](README.md)
- [Estrutura do repositório](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md) — onde cada coisa mora e onde criar arquivos novos
- [Índice geral de documentação](docs/INDEX.md)
- [Registro central de conteúdo e IDs](docs/CONTENT_REGISTRY.md)
- [Índice de documentação de agentes e fontes](documents/INDEX.md)
