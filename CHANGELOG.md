# Changelog — Pocket Hero

Registro breve de mudanças estruturais e releases. Detalhes de planejamento continuam no roadmap; histórico de gates concluídos permanece arquivado.

## 2026-09-30 — Reorganização do repositório

- Nova autoridade de organização: [ESTRUTURA_DO_REPOSITORIO](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md) (mapa, onde criar cada arquivo, regras de manutenção e recomendações R-1 a R-5 ainda não executadas).
- `AGENTS.md` enxugado de 16 KB para ~5 KB: regras e ponteiros; a tabela e as regras do Argos foram para [`tools/argos/README.md`](tools/argos/README.md). README reescrito com entrada por perfil de leitor.
- Movidos: `HERO_STANDARD.md` → `docs/02_heroes/`; brief e `REFERENCIAS_TBH` → `docs/00_project/`; `PIPELINE_IA_SPRITES` → `docs/art/`; 7 planos executados e as recomendações do 1D → `arquivados/planos_concluidos/`; `referencia/inimigos_futuros` (raiz) → `docs/art/referencia/inimigos_futuros`; scripts Python de `scripts/art` e `scripts/android` → `tools/art` e `tools/android`.
- Unificado: `QA_MOBILE_1E` dentro de [QA_MOBILE_PIXEL9_REPORT](docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md).
- Novo: [`tools/docs/check_links.py`](tools/docs/check_links.py) (links, âncoras e órfãos; `--orphans`).
- Excluídos: `docs/art/references/` (imagens de terceiros), conceito/prévia duplicados em `assets/sprites/ui/ui_kit/`, imagem duplicada em inimigos futuros, `arquivados/pipelines_legados/`, `tests/test_r9_slime_visual.gd` (MVP, não era executado), `scripts/art/audit_docs_links.py`, `tools/balance/scale_compare.py`, `tools/art/build_ui_kit_v003.py`, pastas vazias. Fora do git: ~260 MB (APK de sonda, frames e capturas antigas em `build/`, 61 relatórios do Argos não citados, caches). `build/.gdignore` impede o Godot de importar saídas locais.

## 2026-09-30 — Balanceamento global v1.0

- Novo [`docs/06_balance/v1/`](docs/06_balance/v1/README.md): a constituição (curva-mestra, orçamento de poder 30/30/25/15, jogador de referência por capítulo, alvos, teto, linhas vermelhas, política de mudanças), 11 domínios (status e combate, heróis, skills/passivas, itens/raridade, affixes/craft, inimigos/chefes, economia/loot, meta, dificuldade/endgame, telemetria/Argos, decisões abertas), o perfil do Capítulo 1 e três anexos técnicos (schema de inimigo, Drop Resolver, `LOOT_CONTRACT.json`). Tudo `DESIGN`/HIPÓTESE; nenhum valor de `/data` mudou.
- Decisões de Rafael: poder equilibrado, dificuldades D1–D3 como endgame, farm offline limitado e catch-up de XP para heróis no banco. Pendentes em [11_DECISOES_ABERTAS](docs/06_balance/v1/11_DECISOES_ABERTAS.md) (D-01 a D-09).
- Achados registrados na v1: a curva de XP atual não alcança o nível 100; o HERO_STANDARD e o slice divergem sobre quando a Signature abre; a camada D3 herdada passaria do teto de 1 milhão de HP no capítulo 10; o orçamento 30/30/25/15 só fecha se medido dentro de cada capítulo.
- Excluídos por decisão de Rafael (absorvidos na v1): `documents/canonical/` (base v0.5 e origem v0.4; a pasta v0.5 não estava no git), `documents/references/balance_pack_v0.1/`, `GLOBAL_BALANCE_SYSTEM`, `SLICE_BALANCE_CONTRACT`, `COMBAT_BALANCE_STANDARD`, `BALANCE_V0.5`, `ECONOMY_MODEL`, `CHAPTER_01_HERO_COMBAT_PROPOSAL`, `COMBAT_SCALE_AND_GROWTH_PROPOSAL`, `CHAPTER_01_ITEM_STATS_PROPOSAL` e o CSV de variantes, `docs/04_content/enemies/CHAPTER_01_COMBAT_PROPOSAL.md` e as ferramentas pré-Argos `simulate_chapter1_balance.py`, `slice_baseline.py`, `simulate_route_sustain.py` e `export_chapter1_item_variants.py`.
- Movidos: JSON canônico e catálogo dos inimigos para `docs/04_content/enemies/`; tabelas de drop e materiais para `docs/04_content/chapters/chapter_01/`; catálogo de itens (com a distribuição de status por template) e templates de origem para `docs/04_content/items/`. O `argos_loot.gd` passou a ler os novos caminhos; referências em código, testes e campos `source` de `/data` foram reapontadas. Suíte 36/36 PASS, validador OK.

## 2026-09-30 — Reorganização do roadmap e limpeza de fontes

- `ROADMAP.md` reescrito para leitura por qualquer agente: cabeçalho com metadados, legenda de status, **Estado atual → Concluído → Agora (`NOW-*`) → Próximo (`NEXT-*`) → Futuro**, com IDs estáveis. O texto detalhado dos gates concluídos (fundação, SLICE-1, kits, escala 10×) foi movido para [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).
- Evidência reconferida: 36/36 cenas Godot PASS e validador de balanceamento OK (os documentos ainda citavam 29/30).
- Excluídos por decisão de Rafael, para ninguém consultar a fonte errada (recuperáveis pelo git): `documents/canonical/taskbar_sistema_v0.4/` (cópia idêntica de `taskbar_sistema_v0.5/source/`), candidatos `ui_kit` v001/v002 e `tools/art/build_ui_kit.py`, snapshots de 2026-09-28 (`SPRITE_ENVIRONMENT_PATHS`, `SPRITE_INSTALLATION_AUDIT`, `QA_VISUAL_PRELIMINAR`, `CONCEITOS_PILOTO`). O `export_chapter1_item_variants.py` passou a ler o catálogo da v0.5.
- Links corrigidos: relatório de QA mobile apontava para uma pasta fora do repositório; contrato do `ui_kit` e âncora da proposta de escala estavam quebrados; documentos órfãos (validação dos kits, perfis do Argos arquivados, prompt da UI_S12) passaram a ser indexados.

## 2026-09-30 — SLICE-1 Homologado e QA Mobile no Pixel 9 (1080×2424)

- Homologação oficial do **SLICE-1 (Vertical Slice do Jogo Real)** com gates 1A a 1E concluídos.
- **QA Mobile no Pixel 9:** Sessão tátil completa no display 20:9 (`1080x2424`, 420 dpi, Android 17): TitleScreen → Refúgio UI_S02 → Árvore dos Ecos (6 nós comprados) → Desbloqueio dinâmico do Ferreiro → Loadout & Presets UI_S04 → Arena com 4 camadas de Parallax e velocidades (×1 a ×20) → Reward Choices (ícones 64px) → Tela de Resultado UI_S07 → Inventário UI_S03 → Ferreiro de Lúmen UI_S05 (validação de slot, Reforço +1 consumindo 5 resíduos, favoritar item e proteção de desmonte de favoritos). Relatório formal: [`docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md`](docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md).
- **Telemetria e Simulação Argos (`slice_balance`):** 1404 execuções, **0 BUGs**, com 6 caminhos viáveis no nível 10 (2 sem Lúmen) e taxa de drop consistente (4.0 itens por run).
- **Suíte de Testes Godot:** 29/30 cenas PASS no `python tools/run_godot_tests.py` (zero regressões).

## 2026-09-30 — Padrão de Alta Densidade e Polimento Visual do Loop

- Produção e padronização dos sprites em Alta Densidade: elenco dos 8 heróis em 96×96 (`assets/sprites/heroes/`), bestiário do Cap. 1 de 17 entidades (64px a 224px em `assets/sprites/enemies/highres/`), 30 ícones de itens v0.4 em 64×64 (`assets/sprites/items/icons_64/`), 5 painéis do Hub (256×256+ em `assets/sprites/hub/`), UI Kit 9-slice (`assets/sprites/ui/ui_kit/`) e tema AMOLED (`assets/ui/pocket_hero_theme.tres`).
- Helper `ItemIconResolver.gd` com cache de texturas e paleta de raridades coloridas integrado ao Inventário, Ferreiro e Reward Choices.
- Refúgio Visual completo em `SliceCampaignScreen.gd` com banner dinâmico (`hub_refugio_mobile_completo.png` / `hub_refugio_pos_boss.png`), trio descansando (96×96) e cards de serviços.
- Arena visual de combate no Bosque de Lúmen com 4 camadas de parallax e atores animados reagindo a ataques, dano e vitórias. Loadout tátil (`UI_S04`) com miniaturas dos heróis e descrições dinâmicas de builds. Tela de resultado (`UI_S07`) com badges táteis de recursos e grade de itens conquistados.


- `tools/art/build_ui_kit.py` gera o candidato v001 do ui_kit (excluído em 2026-09-30) (botões 9-slice em 3 estados, painel, divisor e 3 ícones) em pixel art TY40, fora de `assets/`. Sem aprovação nem auditoria; problemas conhecidos listados no README.

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
