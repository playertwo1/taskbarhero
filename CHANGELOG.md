# Changelog — Pocket Hero

Registro breve de mudanças estruturais e releases. Detalhes de planejamento continuam no roadmap; histórico de gates concluídos permanece arquivado.

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
