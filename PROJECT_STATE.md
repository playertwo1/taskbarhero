# Pocket Hero — estado do projeto

**Última conferência estrutural:** 2026-09-30 (elevação ao Padrão de Alta Densidade aprovado por Rafael; integração de tema AMOLED, arena visual de combate, Refúgio visual UI_S02 e ícones de 64×64 com raridades nas telas do loop em `SliceCampaignScreen`). Este arquivo é um painel de navegação e um resumo observável; não substitui dados, código, testes ou roadmap como fonte de prova.

## Fontes de verdade

- **Plano, prioridade e gates:** [`ROADMAP.md`](ROADMAP.md).
- **Implementação:** cenas em [`scenes/`](scenes/) e scripts em [`scripts/`](scripts/). O repositório Godot não tem uma pasta `src/`.
- **Valores carregados pelo jogo:** arquivos JSON sob [`data/`](data/).
- **Design canônico de combate/loot:** [TASKBAR Sistema Completo v0.4](documents/canonical/taskbar_sistema_v0.4/README.md); não confundir com a implementação observada em `/data`.
- **Arte efetivamente usada pelo projeto:** [`assets/sprites/`](assets/sprites/) (heróis 96px, bestiário 64–224px, itens 64px, hub 256px+, ui_kit e tema em `assets/ui/pocket_hero_theme.tres`). Fontes e pipelines em [`work/art_pipeline/`](work/art_pipeline/) e especificações em [`docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md`](docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md).
- **Evidência de comportamento:** arquivos sob [`tests/`](tests/) e resultados de execução registrados no roadmap.
- **Histórico concluído:** [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

## Conferir o estado real

Este arquivo não duplica contagens ou checklists. Use os caminhos abaixo para inspecionar estado observável; o [registro central](docs/CONTENT_REGISTRY.md) resume quais catálogos existem e quais são propostas.

- Heróis/runtime: [`scenes/heroes/`](scenes/heroes/) e [`data/heroes/heroes.json`](data/heroes/heroes.json); sprites 96×96 em [`assets/sprites/heroes/`](assets/sprites/heroes/).
- Fluxo jogável: [`scenes/ui/TitleScreen.tscn`](scenes/ui/TitleScreen.tscn) → [`scenes/slice/SliceCampaign.tscn`](scenes/slice/SliceCampaign.tscn); tela em [`scripts/ui/SliceCampaignScreen.gd`](scripts/ui/SliceCampaignScreen.gd) (com arena visual do Bosque de Lúmen, Refúgio visual UI_S02 com banner dinâmico e trio descansando, TopBar de recursos e tema integrado), combate em [`scripts/combat/ExpeditionRun.gd`](scripts/combat/ExpeditionRun.gd) e camada de campanha em [`scripts/run/`](scripts/run/).
- Progressão do Refúgio (1D): [`data/progression/`](data/progression/) (Árvore de 6 nós e regras do Ferreiro), [`scripts/run/ResonanceTree.gd`](scripts/run/ResonanceTree.gd) e painéis em [`scripts/ui/`](scripts/ui/) (`ResonanceTreePanel`, `BlacksmithPanel`). Marcos de Fragmentos ficam em `route_c1.json`.
- Telas do slice: contratos de UX e de arte em [`docs/09_ui/`](docs/09_ui/INDEX.md) (`DESIGN`); implementação em `scripts/ui/` (campanha com Refúgio visual, loadout tátil dos heróis com miniaturas e descrições dinâmicas de builds, tela de resultado enriquecida com badges de recursos e grade de itens, inventário e ferreiro com ícones 64×64 e raridade colorida via `ItemIconResolver.gd`, painéis estilizados com tema AMOLED nativo e UI Kit 9-slice, Árvore, pausa/velocidades).
- Itens/runtime: [`data/items/items.json`](data/items/items.json); ícones 64×64 em [`assets/sprites/items/icons_64/`](assets/sprites/items/icons_64/) integrados dinamicamente via `scripts/ui/ItemIconResolver.gd`.
- Inimigos/runtime: [`data/enemies/enemies.json`](data/enemies/enemies.json); bestiário de alta densidade em [`assets/sprites/enemies/highres/`](assets/sprites/enemies/highres/).
- Rota/runtime: [`data/expedition/route_c1.json`](data/expedition/route_c1.json) (o legado `stages.json` foi removido no `1A-CUT`).
- Balanceamento/runtime: [`data/balance/combat_profiles.json`](data/balance/combat_profiles.json) compõe o [núcleo global](data/balance/combat_core.json) com o [perfil do Capítulo 1](data/balance/chapters/chapter_01.json); arquitetura em [GLOBAL_BALANCE_SYSTEM](docs/06_balance/GLOBAL_BALANCE_SYSTEM.md).
- Skills/design e capítulo: [overview do Capítulo 1](docs/04_content/chapters/chapter_01/OVERVIEW.md); o plano proposto de encontros e boss está em [ENCOUNTERS.md](docs/04_content/chapters/chapter_01/ENCOUNTERS.md), com simulação ligada à [roadmap](ROADMAP.md). Confira código e `/data` antes de afirmar implementação.
- Evidência de validação: [`tests/`](tests/), [relatórios do Argos](tools/argos/reports/), relatório de QA Mobile no Pixel 9 e resultados/gates em [`ROADMAP.md`](ROADMAP.md). Baseline de testes em 2026-09-30: 29/30 cenas PASS (`TestExpeditionChoices` perde no nível 12, seed 101, aceita como exceção humana do gate 1C). Zero regressões. Simulação Argos `slice_balance`: 1404 execuções com 0 BUGs. Validação mobile tátil no Pixel 9 (`1080x2424`) homologada com 100% de fluidez em todas as telas do loop (TitleScreen a Ferreiro).

## Estado de produção

Consulte o roadmap para a situação atual do MVP, sprites, QA, conteúdo e trabalho futuro. Não replique aqui checklists que possam divergir. Alterações locais e arquivos não rastreados pertencem ao workspace do usuário: preserve-os e confira `git status` antes de qualquer mudança.

## Navegação

- [Índice geral de documentação](docs/INDEX.md)
- [Registro central de conteúdo e IDs](docs/CONTENT_REGISTRY.md)
- [Índice de documentação de agentes e fontes](documents/INDEX.md)
