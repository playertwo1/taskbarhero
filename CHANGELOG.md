# Changelog — Pocket Hero

Registro breve de mudanças estruturais e releases. Detalhes de planejamento continuam no roadmap; histórico de gates concluídos permanece arquivado.

## 2026-09-29 — balanceamento v0.5 e Argos

- `docs/06_balance/BALANCE_V0.5.md`: meta incremental (Guardião do Capítulo 1 por volta do nível 10–11), fôlego entre encontros, fases 1/3/5/7/10, chefe ×1,5, golpes telegrafados, ranks R2–R5, passivas e Traits; o v0.4 canônico não foi alterado.
- ARGOS-SIM (`tools/argos/`): simulador headless com oráculos, Analyst, cenários e variantes; relatórios medidos em `tools/argos/reports/`.

## 2026-09-29 — roadmap único

- `ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md` incorporado ao `ROADMAP.md` e removido. Gates e checklists ativos foram para o roadmap; ideias de design sem ficha foram preservadas em `docs/04_content/chapters/chapter_01/DESIGN_SEEDS.md`, `docs/05_hub/HUB_STRUCTURE_SEEDS.md` e `docs/01_world/FUTURE_SEEDS.md`.
- Sequência: `SLICE-0` (recorte, com inventário de arte) → `BALANCE-FOUNDATION-1` limitado ao recorte → `SLICE-1` em etapas 1A–1E, cada uma com teste. Decisão de Rafael: o slice migra para `/data` só o subconjunto v0.4 que usa, com aliases. Trilhas de heróis, conteúdo completo e Hub completo pausadas até o slice.
- A taxonomia antiga de recursos (Lúmen como moeda, Sigilos) não foi transportada: `ECONOMY_MODEL.md` e a base v0.4 são a fonte vigente.

## 2026-09-29 — limpeza e consolidação

- Adicionada a proposta de Mastery 1–10 da Flecha; roadmap reordenado para BALANCE-FOUNDATION-1 → SLICE-1 antes de retomar fichas de heróis.
- Removidas 11 cópias idênticas do Balance Pack v0.1; a base canônica v0.4 fica como fonte única.
- `docs/qa/` → `docs/08_qa/`, guia incremental → `docs/00_project/`, DOCX legados → `arquivados/docx_legados/`; pastas vazias removidas.
- `SPRITE_STANDARD` e `QA_CHECKLIST` (R7) incorporados a `ANIMATION_STANDARD` e `QA_SPRITES` e arquivados.
- Pipelines de sprite pré-Golden movidos para `arquivados/pipelines_legados/`; `work/` deixa de ser versionado (mantido localmente, ignorado pelo Godot).
- Removidos mockups de Hub superados (v001/v002, comparativo) e 11 PNGs sem referência; recuperáveis no histórico git (`10e67b6`).
- Registro de auditoria do MVP arquivado; Golden Reference do Bastião dividida em ficha + passivas + Traits + Mastery.
- Novo `tools/run_godot_tests.py` executa todas as cenas de teste em headless (11/11 PASS).

## 2026-09-28 — arquitetura documental

- Criados índices por área, estado resumido e registro de conteúdo/IDs para navegação.
- Movido o overview do Capítulo 1 para `docs/04_content/chapters/chapter_01/OVERVIEW.md`; os links internos foram atualizados.
- Código, catálogos runtime e caminhos dos assets Godot não foram reorganizados nesta fatia.
