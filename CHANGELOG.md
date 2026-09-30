# Changelog — Pocket Hero

Registro breve de mudanças estruturais e releases. Detalhes de planejamento continuam no roadmap; histórico de gates concluídos permanece arquivado.

## 2026-09-29 — candidato do ui_kit

- `tools/art/build_ui_kit.py` gera o [candidato v001 do ui_kit](docs/art/candidates/ui_kit/README.md) (botões 9-slice em 3 estados, painel, divisor e 3 ícones) em pixel art TY40, fora de `assets/`. Sem aprovação nem auditoria; problemas conhecidos listados no README.

## 2026-09-29 — BAL-009 decidido e Argos com economia do 1D

- Novo [roteiro de playtest do 1E](docs/08_qa/PLAYTEST_1E.md): 8 perguntas, registro por tentativa e regras de retorno ao balanceamento. Limitações registradas: build de debug usa semente fixa e a telemetria não liga na campanha do aplicativo.
- Rafael decidiu esperar o playtest para o BAL-009: nenhum valor de balanceamento mudou.
- `slice_run_layer` ganhou a variante `com_arvore_e_ferreiro` (compra da Árvore e Reforço +1 entre tentativas). Resultado: sem diferença mensurável contra a base (6,48 contra 6,52 tentativas; 47/48 contra 48/48 vitórias). Achados e ressalvas em [BAL-009](docs/08_qa/BALANCE_FINDINGS.md).

## 2026-09-29 — contratos de tela do slice

- Novo `docs/09_ui/`: [convenções](docs/09_ui/SCREEN_CONVENTIONS.md), [índice](docs/09_ui/INDEX.md) e 11 contratos de UX (`UI_S01` a `UI_S11`), cada um com contrato de arte em `docs/art/contracts/screens/` e um `ui_kit` compartilhado. Todos `DESIGN`, aguardando revisão de Rafael.
- Loadout: build livre por herói (3 × 2 × 3 = 18 combinações) mais 4 presets como atalho, com `TestLoadoutBuilds`.
- Expedição em curso: pausa e velocidades ×1 a ×4 (inicial ×1; ×20 só em debug), com `TestRunSpeedControls`.
- QA no emulador Pixel 9 (1080×2424) achou fundo de painel translúcido deixando a tela de baixo aparecer; os três painéis agora são opacos.
- BAL-009 registra o `slice_balance` do início do 1E (Arcano tardio, dominância de Lúmen, Guardião sem folga).

## 2026-09-29 — 1D: Fragmentos, Árvore, Ferreiro e painéis

- Fragmentos de Ressonância: 32 únicos (4/6/7/7/8) como `fragment_reward` em cinco marcos de `route_c1.json`, pagos uma vez e salvos. `data/progression/resonance_tree_slice.json` e `ResonanceTree` cobrem os 6 nós da Oficina.
- Ferreiro: desmontagem atrás de `TREE_OFI_002` (favoritos protegidos) e Reforço +1 atrás de `TREE_OFI_003` (5 Resíduos, +2% dos afixos-base, uma vez por item). O Ouro do custo proposto ficou fora, porque o slice não tem Ouro.
- Telas provisórias `ResonanceTreePanel` e `BlacksmithPanel` na preparação da campanha; "Reciclar" saiu do inventário.
- Contrato de arte `DESIGN` da camada da Lanterna-Mãe pós-boss (`docs/art/contracts/hub_environment/`).
- Evidência: 27/28 cenas Godot (exceção aceita: seed 101), validador `OK`, Analyst OK, `slice_quick` e `slice_run_layer` sem `BUG`. Pulso Vital sem efeito (EM ABERTO). Validação visual em 432×960 fica para o 1E.

## 2026-09-29 — 1B tela, textos e Argos

- Novo fluxo `TitleScreen → SliceCampaign`: preparação, run jogável com eventos e escolhas, tela de inventário para equipar/reciclar e resultado com save mínimo.
- `EventTexts` lê `data/expedition/event_texts_c1.json` e `SliceLogText` apresenta os eventos na interface. `EVENT_TEXTS.md` é a vista derivada; os textos continuam `DESIGN`, aguardando revisão de Rafael.
- Argos passa a simular campanhas com loot e eventos reais em `slice_run_layer`, além de resumir frequência de eventos, escolha do Poço, raridades e Resíduo por variante.
- Evidência: 25/25 cenas Godot, 10 testes do Analyst, `slice_quick` e `slice_run_layer` sem `BUG`; inspeção visual manual em 432×960 fica pendente para ambiente com janela Godot disponível.

## 2026-09-29 — 1B núcleo: loot, inventário, eventos e save

- Novo `scripts/run/`: `LootRoller` (drops e Reward Choice por seed, `data/loot/drops_c1.json`), `SliceInventory` (equipar, trocar, reciclar em Resíduo, trava durante a run), `EventDirector` (10 eventos + Reserva de Resíduo em `data/expedition/events_c1.json`, condições por party, chance baixa e secreto uma vez por save), `SliceSave` (JSON versionado; versão desconhecida ou arquivo corrompido nunca são sobrescritos) e `SliceCampaign` (aplica e grava cada recompensa ao recebê-la).
- `ExpeditionRun` ganha o estado `choice` (o tempo não avança), `choose(index)`, drops e efeitos de evento; sem `loot`/`events` o run é idêntico ao anterior. `SliceTelemetry` ganha a camada `run_layer`.
- Ferramentas: `tools/godot_import.py` (registra `class_name` novos) e `tools/run_one_scene.py` (roda uma cena de teste). 19/19 cenas PASS naquela etapa. Tela e cenários do Argos foram concluídos no Plano B.

## 2026-09-29 — fundação global de balanceamento

- Separados o núcleo compartilhado (`data/balance/combat_core.json`), o overlay do Capítulo 1 (`data/balance/chapters/chapter_01.json`) e o manifesto de composição (`combat_profiles.json`). `BalanceProfiles.gd` resolve núcleo → capítulo → override; `SliceStats.gd` permanece como adaptador.
- Formação, ameaça, party, rotas, segmentos e ponto anterior ao chefe passaram a vir dos dados. O Argos não contém mais IDs fixos do trio ou do Capítulo 1.
- Adicionados schemas, validação executável e hash SHA-256 das entradas nos relatórios. Regras de caminhos respeitam cobertura de nível; TTK exige nível equivalente entre party e encontro.
- Evidência: validador `OK`, 13/13 cenas Godot, 6/6 testes do Analyst, `slice_quick` com 48 runs e `slice_balance` com 1.404 runs, sem `BUG`. Dominância de Lúmen e pacing do Arcano foram mantidos como achados, sem ajuste silencioso de números.

## 2026-09-29 — 1A-5: telemetria do slice

- `SliceTelemetry` (`scripts/combat/`) agrega os eventos do `ExpeditionRun` conforme a seção 7 do contrato de balanceamento; opcional (`options["telemetry"]`), sem influência no combate, resumo em `snapshot()["telemetry"]`. Novo `tests/unit/test_slice_telemetry.gd`; a suíte passou a 12/12 nessa etapa. Métricas sem dado no run ficam listadas no contrato.

## 2026-09-29 — 1A-CUT: legado do MVP removido

- Removidos o loop contínuo legado e seus autoloads (`GameManager`, `ProgressionManager`, `LootManager`, `SaveManager`, `Telemetry`, `TestHooks`), `Main`, `BattleStrip`, `PartyScreen`, `InventoryScreen`, `data/stages/stages.json`, as linhas legadas de `enemies.json` e `items.json` (agora só `content_set: "slice"`) e os testes R10–R16 e de party/Main. Histórico no git (commit `cd47758`).
- Fluxo principal: `TitleScreen → SliceProbe` (cena inicial `TitleScreen`). Comandos legados do `DebugBridge` (`give_gold`, `set_level`, `spawn_enemy`, `simulate_offline`, `reset_state`) saíram; `get_state` devolve o snapshot do slice.
- `tools/economy/simulate_econ1_first_clear.py` arquivado em `arquivados/pipelines_legados/`; `tools/balance/slice_baseline.py` lê os níveis de `data/expedition/route_c1.json`.
- Perdas assumidas até `1B`/`1D`: save, progresso offline, tracker, XP/ouro contínuos, loot e inventário. Suíte: 11/11 cenas PASS; Argos `slice_quick` sem BUG.
- Roadmap: auditoria de `1A-2` a `1A-5` registrada; a telemetria do `ExpeditionRun` foi concluída na etapa seguinte.

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
