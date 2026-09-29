# Pocket Hero — estado do projeto

**Última conferência estrutural:** 2026-09-29 (após Plano B do `1B`; o fluxo jogável é `TitleScreen → SliceCampaign`). Este arquivo é um painel de navegação e um resumo observável; não substitui dados, código, testes ou roadmap como fonte de prova.

## Fontes de verdade

- **Plano, prioridade e gates:** [`ROADMAP.md`](ROADMAP.md).
- **Implementação:** cenas em [`scenes/`](scenes/) e scripts em [`scripts/`](scripts/). O repositório Godot não tem uma pasta `src/`.
- **Valores carregados pelo jogo:** arquivos JSON sob [`data/`](data/).
- **Design canônico de combate/loot:** [TASKBAR Sistema Completo v0.4](documents/canonical/taskbar_sistema_v0.4/README.md); não confundir com a implementação observada em `/data`.
- **Arte efetivamente usada pelo projeto:** [`assets/`](assets/), principalmente `assets/sprites/`.
- **Evidência de comportamento:** arquivos sob [`tests/`](tests/) e resultados de execução registrados no roadmap.
- **Histórico concluído:** [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

## Conferir o estado real

Este arquivo não duplica contagens ou checklists. Use os caminhos abaixo para inspecionar estado observável; o [registro central](docs/CONTENT_REGISTRY.md) resume quais catálogos existem e quais são propostas.

- Heróis/runtime: [`scenes/heroes/`](scenes/heroes/) e [`data/heroes/heroes.json`](data/heroes/heroes.json).
- Fluxo jogável: [`scenes/ui/TitleScreen.tscn`](scenes/ui/TitleScreen.tscn) → [`scenes/slice/SliceCampaign.tscn`](scenes/slice/SliceCampaign.tscn); tela em [`scripts/ui/SliceCampaignScreen.gd`](scripts/ui/SliceCampaignScreen.gd), combate em [`scripts/combat/ExpeditionRun.gd`](scripts/combat/ExpeditionRun.gd) e camada de campanha em [`scripts/run/`](scripts/run/).
- Itens/runtime: [`data/items/items.json`](data/items/items.json).
- Inimigos/runtime: [`data/enemies/enemies.json`](data/enemies/enemies.json).
- Rota/runtime: [`data/expedition/route_c1.json`](data/expedition/route_c1.json) (o legado `stages.json` foi removido no `1A-CUT`).
- Balanceamento/runtime: [`data/balance/combat_profiles.json`](data/balance/combat_profiles.json) compõe o [núcleo global](data/balance/combat_core.json) com o [perfil do Capítulo 1](data/balance/chapters/chapter_01.json); arquitetura em [GLOBAL_BALANCE_SYSTEM](docs/06_balance/GLOBAL_BALANCE_SYSTEM.md).
- Skills/design e capítulo: [overview do Capítulo 1](docs/04_content/chapters/chapter_01/OVERVIEW.md); o plano proposto de encontros e boss está em [ENCOUNTERS.md](docs/04_content/chapters/chapter_01/ENCOUNTERS.md), com simulação ligada à [roadmap](ROADMAP.md). Confira código e `/data` antes de afirmar implementação.
- Evidência de validação: [`tests/`](tests/), [relatórios do Argos](tools/argos/reports/) e resultados/gates em [`ROADMAP.md`](ROADMAP.md). Última rodada: 25/25 cenas; 10 testes do Analyst; `slice_quick` e `slice_run_layer` sem `BUG`.

## Estado de produção

Consulte o roadmap para a situação atual do MVP, sprites, QA, conteúdo e trabalho futuro. Não replique aqui checklists que possam divergir. Alterações locais e arquivos não rastreados pertencem ao workspace do usuário: preserve-os e confira `git status` antes de qualquer mudança.

## Navegação

- [Índice geral de documentação](docs/INDEX.md)
- [Registro central de conteúdo e IDs](docs/CONTENT_REGISTRY.md)
- [Índice de documentação de agentes e fontes](documents/INDEX.md)
