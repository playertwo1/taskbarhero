# Taskbar Hero Mobile / Pocket Hero

Projeto de um RPG idle/hack-and-slash em pixel art inspirado no conceito de jogos que vivem em uma faixa pequena da tela, adaptado para Android.

## Objetivo

Criar um jogo mobile com combate automático, progressão, loot, heróis, inimigos, bosses, pets/companheiros e regiões evolutivas, com identidade visual própria.

## Stack planejada

- Godot 4.7.2
- GDScript
- Hermes Agent como orquestrador
- Claude, ChatGPT e Antigravity
- Daedalus como agente de arte
- pixel-mcp + Aseprite para geração assistida de sprites
- Pixelorama para revisão/acabamento
- Android como plataforma principal

## Roadmap

- `ROADMAP.md` — roteiro detalhado desde a preparação do Windows e instalação das ferramentas até o MVP Android e a fase pós-MVP de overlay.

## Navegação do repositório

- [`AGENTS.md`](AGENTS.md) — índice operacional e ordem de leitura para agentes.
- [`PROJECT_STATE.md`](PROJECT_STATE.md) — resumo observável do estado e localização das fontes runtime.
- [`CHANGELOG.md`](CHANGELOG.md) — mudanças estruturais e releases.
- [`docs/INDEX.md`](docs/INDEX.md) — índice por área da documentação.
- [`docs/CONTENT_REGISTRY.md`](docs/CONTENT_REGISTRY.md) — IDs de design, status e roteamento dos catálogos.

## Design incremental

- `docs/design/INCREMENTAL_DESIGN_GUIDE.md` — resumo operacional da doutrina incremental; o guia temático completo e o DOCX original estão em `documents/`.

## Documentação

- `documents/INDEX.md` — ponto de entrada e rotas de leitura por tarefa para guias completos e DOCX originais.
- `docs/POCKET_HERO_PROJECT_BRIEF.md` — consolidação atual de escopo, MVP, direção de arte, pipeline e próximos gates, derivada dos DOCX arquivados.
- `docs/PIPELINE_IA_SPRITES.md` — arquitetura de agentes e pipeline de criação de sprites por IA.
- `docs/art/SPRITE_STYLE_GUIDE.md` — fonte oficial da arte e precedência das regras; [`PALETTE.md`](docs/art/PALETTE.md) define TY High Fantasy 40, e [`golden/README.md`](docs/art/golden/README.md) registra o ART-0 antes de novos lotes de produção.
- [`REFERENCE_LIBRARY.md`](docs/art/REFERENCE_LIBRARY.md) — referências aprovadas, proveniência e limites de licença; [`WORKFLOW_COMFY.md`](docs/art/WORKFLOW_COMFY.md), [`ANIMATION_STANDARD.md`](docs/art/ANIMATION_STANDARD.md), [`QA_SPRITES.md`](docs/art/QA_SPRITES.md) e [`REJECT_CATALOG.md`](docs/art/REJECT_CATALOG.md) detalham produção e aceite. Contratos, manifestos e lint técnico ficam em `docs/art/contracts/`, `docs/art/manifests/` e `tools/sprite_lint.py`.
- `docs/REFERENCIAS_TBH.md` — referências de gameplay, fases, inimigos, aliados, pets e ideias originais para o projeto.

As versões DOCX completas permanecem arquivadas na pasta Taskbar do Google Drive e também estão versionadas em `docs/archive/`:

- `docs/archive/Pocket_Hero_Pipeline_IA_Sprites_Hermes.docx`
- `docs/archive/TBH_Referencias_e_Banco_de_Ideias_Pocket_Hero.docx`

## Referências externas estudadas

- https://tbhindex.com/pt
- https://mobalytics.gg/gamebase/tbh-task-bar-hero
- https://taskbarhero.org/
- https://www.xmodhub.com/info/blog/tbh-task-bar-hero-tracker-guide/

> As referências servem para estudo de mecânicas e estrutura. O projeto deve manter nomes, arte, sprites, personagens, cenários e identidade próprios.
