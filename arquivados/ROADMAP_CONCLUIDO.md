# Roadmap — fases concluídas

Arquivo histórico das etapas concluídas. O trabalho em andamento e os planos futuros estão em [ROADMAP.md](../ROADMAP.md). Os status e datas abaixo preservam o registro do roadmap de origem.

Ordem deste arquivo: (1) pós-MVP — fundação de design, SLICE-1 (1A–1E), kits completos e migração para escala 10×; (2) marco SETUP-01; (3) fases R0–R19 do MVP legado, removido no `1A-CUT`.

## Pós-MVP — fundação, SLICE-1, kits e escala 10× (arquivado em 2026-09-30)

Texto movido do `ROADMAP.md` na reorganização de 2026-09-30, preservado como estava (links ajustados para esta pasta). O que ainda está pendente dentro destes blocos foi levado para o roadmap vigente; em caso de divergência, o [ROADMAP](../ROADMAP.md) prevalece.

### 3. Fundação concluída (gates de design)

Gates `PASS` em design. Nenhum deles aprova runtime, números finais ou balanceamento.

| Fase | Gate | Escopo aprovado | Fonte |
| --- | --- | --- | --- |
| **ART-0** | PASS 2026-09-27 / Atualizado 2026-09-30 | 4 Golden visuais + Padrão de Alta Densidade (8 heróis 96px, 17 mobs 64–224px, 30 itens 64px, Hub 256px+, UI Kit). | [Relatório Alta Densidade](../docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md) · [Golden](../docs/art/golden/README.md) · [inventário](../docs/art/MVP_SPRITE_INVENTORY.md) |
| **SYNC-0** | PASS | Contratos de design importados e indexados. | [docs/INDEX.md](../docs/INDEX.md) |
| **DESIGN-1** | PASS 2026-09-28 | Party 3 de 8; separação run / herói / equipamento / conta; saídas da expedição; Echo opcional no slice. | [CORE_LOOP](../docs/00_project/CORE_LOOP.md) · [skills](../docs/03_systems/SKILL_SYSTEM.md) |
| **HERO-STD** | APPROVED | Anatomia canônica do herói (1 básico + 6 skills, 16 passivas, 3 Traits, Mastery 1–10, 6 slots, 5 missões, 4 formas). | [HERO_STANDARD.md](../docs/02_heroes/HERO_STANDARD.md) |
| **LORE-1** | PASS 2026-09-28 | Bíblia de Lore com mistérios centrais em aberto. | [LORE_BIBLE](../docs/01_world/LORE_BIBLE.md) |
| **HERO-001 Bastião** | DESIGN completo | Golden Reference de design: kit, passivas, Traits, Mastery, lore e 5 missões. Pendente: números, diálogos, encounters, sprites finais, implementação. | [Golden Reference](../docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md) |
| **TREE-1** | PASS 2026-09-28 | 30 nós em 7 ramos, pré-requisitos e custos relativos. Alvo posterior ~84 nós. | [Árvore dos Ecos](../docs/03_systems/GLOBAL_RESONANCE_TREE.md) |
| **CRAFT-1** | PASS 2026-09-28 | Quatro artesãos (Ferreiro, Alquimista, Gravadora de Ecos, Ourives), serviço mínimo, fonte/sink e ordem de abertura. | [Equipamento e crafting](../docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) |
| **ITEM-1** | PASS 2026-09-28; revisado em 2026-09-30 | 6 slots, quatro raridades no slice, catálogo herdado de 33 templates; armas exclusivas e demais itens compartilháveis. Escala de status em revisão. | [Equipamento](../docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) · [itens](../docs/04_content/items/INDEX.md) · [ponte legada](../docs/04_content/LEGACY_RUNTIME_CATALOG.md) |
| **Base canônica v0.5** | IMPLEMENTING / HIPÓTESE | Composição ativa de combate, itens e loot; regras v0.4 herdadas preservadas dentro da composição. O pacote v0.4 original é somente histórico. | [Base v0.5](../docs/06_balance/v1/README.md) |

---

### 4. Sequência executada do slice

A ordem é esta. Não pular etapas: cada uma entrega o que a seguinte consome.

**DECIDIDO (Rafael, 2026-09-29) — estratégia de runtime do slice:** o SLICE-1 migra para `/data` **somente o subconjunto v0.5 que usa**, com aliases dos IDs runtime atuais registrados no [registro de conteúdo](../docs/CONTENT_REGISTRY.md). Não haverá arquivos de dados paralelos. **Revisado em 2026-09-29 (Rafael):** o conteúdo legado do MVP é **removido** de `/data`, do código e dos testes na etapa `1A-CUT`, quando a rota do slice já funciona; até lá ele coexiste e a suíte segue verde. Depois do corte, o MVP antigo deixa de ser jogável (histórico no git e em `arquivados/`). LOOT-EXPANSION-1 completa a migração depois do slice.

#### 4.0 ECON-1 — Economia mínima · `DESIGN` em andamento

Feito: [modelo econômico](../docs/06_balance/v1/07_ECONOMIA_LOOT.md), [15 encontros / 32 derrotas e proposta do Guardião](../docs/04_content/chapters/chapter_01/ENCOUNTERS.md), [plano estruturado](../docs/04_content/chapters/chapter_01/encounter_plan.json) e simulação reproduzível (excluído em 2026-09-30) de cobertura, budgets, rendimento e TTK teórico.

O que falta depende de jogo real e **fecha no SLICE-1E**: combate, taxa de vitória na primeira tentativa, pacing, teto e conversão offline.

Gate PASS:
- [x] árvore, Ferreiro, Alquimista e loot têm sinks definidos; nenhum recurso sem função;
- [x] custos principais simuláveis;
- [x] primeira expedição offline termina no objetivo/derrota sem iniciar outra;
- [x] melhoria do Ferreiro demonstrável com fonte não repetível de Resíduo de Lúmen, sem ser requisito para vencer;
- [ ] TTK, vitória na primeira tentativa e pacing medidos no SLICE-1E;
- [ ] teto numérico e conversão de tempo offline medidos no SLICE-1E.

#### 4.1 SLICE-0 — Recorte do slice · `PASS`

**Estado:** `PASS` em 2026-09-29. Recorte registrado em [SLICE_1_SCOPE.md](../docs/04_content/chapters/chapter_01/SLICE_1_SCOPE.md); decisões abertas ficam listadas lá, com dono.

Escolher subconjuntos de fontes já aprovadas, sem criar conteúdo novo. O resultado é a lista fechada que o BALANCE-FOUNDATION-1 e o SLICE-1 consomem.

- [x] trio (Bastião, Flecha, Íris): skills, passivas e Traits do slice, garantindo pelo menos duas builds distintas;
- [x] subset de equipamentos cobrindo os principais slots e subset de raridades da proposta v0.5;
- [x] subset de inimigos, 1 elite, 1 mini-boss e as fases do Guardião-Cervo a implementar ([ENCOUNTERS](../docs/04_content/chapters/chapter_01/ENCOUNTERS.md) · [sementes](../docs/04_content/chapters/chapter_01/DESIGN_SEEDS.md));
- [x] 1 evento de expedição com escolha real;
- [x] 1 Echo funcional opcional com recompensa determinística ([Sistema de Ecos](../docs/03_systems/ECHO_SYSTEM.md));
- [x] ramo pequeno da Árvore dos Ecos e o serviço do Ferreiro (desmontagem + 1 melhoria);
- [x] mudança visual do Refúgio após o boss e efeito do Fragmento do Coração Verde ([Hub](../docs/05_hub/HUB_STRUCTURE_SEEDS.md) · [direção visual](../docs/05_hub/HUB_VISUAL_DIRECTION.md));
- [x] lista de IDs da base v0.5 que entram em `/data` e seus aliases com os IDs runtime atuais;
- [x] **inventário de arte do recorte:** para cada entidade, efeito e tela do slice, indicar se já existe folha `v002`/Golden utilizável ou se precisa de contrato novo ([inventário MVP](../docs/art/MVP_SPRITE_INVENTORY.md) · [conceitos](../docs/art/conceitos/README.md)); assets novos seguem contrato → QA técnico → auditoria visual independente, e o primeiro asset novo passa o gate antes dos demais;
- [x] atualizar o [overview do Capítulo 1](../docs/04_content/chapters/chapter_01/OVERVIEW.md) ao padrão de 6 skills por herói.

Gate PASS: recorte registrado com fontes, IDs e aliases; nenhum item do slice sem fonte aprovada; lacunas de arte listadas com contrato ou decisão de reaproveitamento.

#### 4.2 BALANCE-FOUNDATION-1 — Contrato de balanceamento · `PASS`

**Estado:** `PASS` em 2026-09-29. Contrato em [SLICE_BALANCE_CONTRACT.md](../docs/06_balance/v1/capitulos/CAPITULO_01.md); números seguem HIPÓTESE até o SLICE-1E.

**Fundação global — `PASS` em 2026-09-29:** núcleo compartilhado + overlay por capítulo + override de cenário, validação de referências, hashes de entradas e Argos sem IDs fixos do Capítulo 1. Contrato em [GLOBAL_BALANCE_SYSTEM.md](../docs/06_balance/v1/10_TELEMETRIA_ARGOS.md). Este gate aprova a arquitetura e a reprodutibilidade; os números continuam HIPÓTESE.

Integrar ao combate do Pocket Hero **apenas a parte da base v0.5 que o recorte do SLICE-0 usa**, com Bastião como referência. Template base: [COMBAT_BALANCE_STANDARD](../docs/06_balance/v1/01_STATUS_E_COMBATE.md). Regras herdadas da origem v0.4 estão incorporadas à composição v0.5; o restante do contrato fica para BALANCE-1.

- [x] status canônicos usados pelo slice: ID, unidade, significado, cálculo, limites e mapeamento para os nomes/valores runtime atuais;
- [x] como Guarda, Perfect Block, Desequilíbrio/Stagger e Marca entram no pipeline compartilhado;
- [x] fórmulas de dano, crítico, defesa/penetração e cura/escudo, com caps, ordem e exemplos calculados contra o combate atual;
- [x] baseline do trio (Bastião primeiro) e dos inimigos, elite, mini-boss e boss do recorte, dentro dos budgets herdados agora incorporados à v0.5 ou com justificativa;
- [x] budgets dos slots e raridades do recorte;
- [x] métricas mínimas de telemetria para o slice: dano, cura, TTK, mortes, uso de skills e recursos ganhos/gastos;
- [x] cada número rastreado como `DECIDIDO`, `HIPÓTESE` ou `EM ABERTO`, com fonte e método.

Gate PASS: tudo que o slice usa tem definição única e fórmula calculável à mão; heróis e inimigos do recorte usam o mesmo modelo de status/modificadores; baselines prontos para teste. O PASS **não** declara o jogo balanceado.

#### 4.3 SLICE-1 — Vertical slice do jogo real

Fluxo: `Hub → party → build → expedição → combate → escolha → evento → elite → mini-boss → boss → retorno → Árvore/Ferreiro → evolução do Hub`

Cada etapa fecha com teste automatizado novo em `tests/`, a suíte completa passando (`python tools/run_godot_tests.py`) e o jogo rodando com o conteúdo vigente (o legado só existe até o `1A-CUT`).

- **1A — Combate e dados:** migrar o subconjunto v0.4 para `/data` com aliases; combate usa o modelo do BALANCE-FOUNDATION-1; trio com as skills do recorte. Sub-fatias: `1A-1` `CombatMath` (feito), `1A-2` dados e carregadores (feito: `content_set: "slice"`, manifesto + núcleo + overlay de capítulo, `BalanceProfiles`; `SliceStats` é compatibilidade), `1A-3` rota de 10 encontros e combate (feito: `route_c1.json`, `ExpeditionRun`), `1A-4` skills, passivas e Traits (**feito em 2026-09-30**: Pressão Coordenada +10% no próximo golpe de Flecha após aliado acertar a presa marcada, Foco do Cristal +8% no básico contra o alvo da última Lança, Fissura Persistente +1 s de Fratura contra alvo preparado com teto de 7 s e Feixe Tecido com o Prisma atingindo os demais inimigos a 0,35×ATK sem alterar o alvo principal — todos HIPÓTESE aprovada por Rafael, coberta em `TestExpeditionMechanics`; Respiração Controlada +3% por disparo seguido no mesmo alvo (até 5), Rastro Aberto marca a presa como legível no evento e no snapshot, Ponto de Mira e Caçada Coordenada travam o alvo do básico de Flecha; nenhuma passiva do slice fica com `kind: "none"`. Os ranks R3–R5 que eram só nota ganharam números da proposta e código — Muralha, Contra-Golpe, Desafio, Fortaleza, Marca, Olho Aguçado, Rajada, Lança, Prisma e Véu — todos HIPÓTESE de teste, cobertos por `TestExpeditionMechanics`; Flecha Perfurante R4, Fortaleza R5, Fratura R4 e R5 seguem sem efeito próprio por não terem alvo no slice ou já estarem cobertos por passivas), `1A-5` telemetria (**feito em 2026-09-29**: [SliceTelemetry](../scripts/combat/SliceTelemetry.gd) agrega os eventos do `ExpeditionRun`; as métricas sem dado no run, listadas na seção 7 do [contrato](../docs/06_balance/v1/capitulos/CAPITULO_01.md), ficam para o `1E`, por decisão de Rafael em 2026-09-30), `1A-CUT` remoção do legado (**feito em 2026-09-29**: `TitleScreen → SliceProbe`; histórico no git). **Estado `IMPLEMENTED` / gate fechado em 2026-09-30.** Evidência vigente: 30/30 cenas PASS (com as passivas e ranks novos a run de teste da seed 101 deixou de vencer, então a exceção do gate 1C não aparece mais; o comportamento é sensível a esses ajustes e será reavaliado no playtest do `1E`), validador `OK` e Argos `slice_balance` com 0 BUG. Perdas assumidas até `1B`/`1D`: save, offline, tracker, XP/ouro contínuos, loot e inventário.
- **1B — Run:** eventos (framework orientado a dados + 10 eventos, incluindo aleatórios, pessoais e secretos), Reward Choice em elite/mini-boss, loot por seed equipável ou reciclável e save mínimo. Desenho em [SLICE_1B_RUN_SPEC](../docs/03_systems/SLICE_1B_RUN_SPEC.md), Plano A em [2026-09-29-slice-1b-nucleo.md](planos_concluidos/2026-09-29-slice-1b-nucleo.md) e Plano B em [2026-09-29-slice-1b-tela-e-argos.md](planos_concluidos/2026-09-29-slice-1b-tela-e-argos.md). **Estado `IMPLEMENTED` (2026-09-29):** núcleo lógico, textos (`DESIGN`, aguardando revisão), tela de campanha/inventário e camada Argos entregues. Cobertura: baseline 24/25 cenas Godot; a falha fixa da seed 101 está aceita como exceção humana do gate 1C, não como resultado PASS da suíte. Analyst 10 testes OK; `slice_quick` e `slice_run_layer` sem `BUG`. Validação visual manual em 432×960 não foi possível neste ambiente; QA mobile formal permanece em `1E`.
- **1C — Chefes:** mini-boss e Guardião-Cervo com mecânicas distintas de inimigo comum. **Estado `APPROVED` por Rafael em 2026-09-29, com exceção do gate da seed 101:** a Rainha tem ondas de adds nos limiares e telegráfica; o Guardião tem fase final com três fragmentos sequenciais enquanto continua atacando. `TestExpeditionMechanics` cobre os dois. O `slice_balance` confirma vitórias de campanha após progressão nas 18 builds testadas (4–10 tentativas); a build `guardiao/critico/controle` tem 50% de vitórias de primeira tentativa no nível 12. O teste fixo segue falhando e a suíte permanece em 24/25; não foram alterados teste nem dados. A necessidade de balancear o boss será decidida depois do playtest em `1E`.
- **1D — Retorno (`IMPLEMENTED` / `QA PASS`):** Echo opcional implementado: recompensa única na primeira conclusão da Geleia Anciã, inventário/equipamento persistente e adaptação testada de Muralha Viva. **Fragmentos e Árvore (2026-09-29):** Rafael aprovou 32 Fragmentos únicos (4/6/7/7/8) como hipótese de runtime. Estão gravados como `fragment_reward` nos marcos `c1_1_2_b`, `c1_2_2_b`, `c1_3_2_a`, `c1_4_1_a` e `c1_5_2_a` de [route_c1.json](../data/expedition/route_c1.json); a [Árvore de 6 nós](../data/progression/resonance_tree_slice.json) e o [ResonanceTree](../scripts/run/ResonanceTree.gd) pagam cada marco uma vez, com saldo e compras no save (`TestResonanceTree`). **Ferreiro (2026-09-29 / testado no Pixel 9 em 2026-09-30):** desmontagem exige `TREE_OFI_002` e protege favoritos; Reforço +1 exige `TREE_OFI_003`, custa 5 Resíduos, vale uma vez por item (Arma, Secundário, Armadura) e soma +2% aos afixos-base, sem mudar Item Power ([blacksmith_slice.json](../data/progression/blacksmith_slice.json), `TestBlacksmith`). Testado e homologado no emulador Pixel 9 com validação tátil de slots, Reforço +1 e bloqueio de desmontagem de favoritos. **Telas e Refúgio Visual UI_S02 (2026-09-30):** a preparação da campanha foi elevada a Refúgio visual completo (`SliceCampaignScreen.gd`): banner ilustrado dinâmico (`hub_refugio_mobile_completo.png` ou `hub_refugio_pos_boss.png`), trio de heróis descansando no santuário (Bastião, Flecha, Íris em 96×96), TopBar de recursos e cards táteis para serviços com miniaturas de alta resolução (Árvore dos Ecos `hub_arvore_dos_ecos.png`, Ferreiro de Lúmen `hub_ferreiro.png` e Inventário/Echo `echo_c1_001`). Os painéis [ResonanceTreePanel](../scripts/ui/ResonanceTreePanel.gd) e [BlacksmithPanel](../scripts/ui/BlacksmithPanel.gd) continuam cobertos por `TestHubPanels`; o Ferreiro abre condicionado a `TREE_OFI_001`.
- **1E — Validação (`QA PASS` no Pixel 9 e Argos `0 BUG`):** [contratos de tela](../docs/09_ui/INDEX.md) `DESIGN` escritos (Rafael decidiu em 2026-09-29: Expedição em tela própria, Gravadora como seção do Inventário, build livre por herói, pausa e ×1–×4); já implementados a pausa/velocidades ×1–×20 (`TestRunSpeedControls`) e o loadout por herói com 18 combinações e 4 atalhos (`TestLoadoutBuilds`), com painéis opacos. **QA Mobile no Emulador Pixel 9 Concluído (2026-09-30):** Loop completo testado por toques nativos no display 20:9 (`1080x2424`): Title Screen → Refúgio (`UI_S02`) → Árvore dos Ecos (6 nós comprados com 22 fragmentos) → Desbloqueio dinâmico do Ferreiro → Loadout/Presets (`UI_S04`) → Arena de Combate com Parallax e velocidades → Reward Choice → Tela de Resultado (`UI_S07`) → Inventário (`UI_S03`) → Painel do Ferreiro (Reforço +1, proteção de favorito e consumo de 5 resíduos). Evidências e relatório formal em [QA_MOBILE_PIXEL9_REPORT.md](../docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md). **Simulação do Argos `slice_balance` (2026-09-30):** 1404 execuções, **0 BUGs**, relatório consolidado em `tools/argos/reports/20260930-113407_17cd40c/REPORT.md`. **Suíte de Testes:** 29/30 cenas PASS no `python tools/run_godot_tests.py`, zero regressões. **Elevação Visual de Alta Densidade e UI Kit (2026-09-30):** Produzidos e padronizados: 8 heróis 96×96 (`assets/sprites/heroes/<heroi>/hero_<heroi>_96x96.png`), bestiário de 17 entidades 64px a 224px (`assets/sprites/enemies/highres/`), 30 ícones de itens 64×64 (`assets/sprites/items/icons_64/`), UI Kit 9-slice (`assets/sprites/ui/ui_kit/`) e tema AMOLED (`assets/ui/pocket_hero_theme.tres`). A tela de campanha (`SliceCampaignScreen.gd`) enriquecida com TopBar, arena visual com 4 camadas de parallax, atores animados, ícones de itens 64×64 com raridades coloridas via [ItemIconResolver](../scripts/ui/ItemIconResolver.gd) e cards táteis. Relatório formal: [`docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md`](../docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md).

Fora do slice: árvore completa (~84 nós), os 8 heróis, artesãos em nível máximo, crafting profundo, affixes aleatórios/reforja, campanhas pessoais completas, Mastery em runtime.

Gate PASS:
- [x] loop completo jogável do início ao fim (validado no Pixel 9 `1080x2424`);
- [x] decisões da run influenciam a build; pelo menos duas builds claramente diferentes;
- [x] progressão do herói e progressão global compreensíveis e distintas;
- [x] equipamento ganho pode ser usado ou reciclado com decisão real (validado no Ferreiro);
- [x] boss com mecânica distinta de inimigo comum;
- [x] retorno ao Hub produz progressão perceptível sem grind artificial;
- [x] etapas 1A–1E concluídas com evidência registrada.

#### 4.3.1 Balanceamento v0.5 do slice · `IMPLEMENTING`

Meta de Rafael: jogo incremental; Guardião vencido por volta do nível 10–11 com fôlego entre encontros. Estado medido e mudanças em [BALANCE_V0.5](../docs/06_balance/v1/capitulos/CAPITULO_01.md); simulação, não playtest. Fecha com playtest no `SLICE-1E`.

#### 4.4 BALANCE-1 — Ajuste iterativo · pós-slice

**Próxima revisão de balanceamento (DECIDIDO por Rafael):** comparar uma escala de combate **5×** com **10×** para que os atributos de equipamento tenham diferenças legíveis. **DECIDIDO por Rafael em 2026-09-30: escala 10×** (com `DEFENSE_K` escalado junto); a migração de `/data` e do código ainda não foi feita. Decisões já tomadas nesse debate (poder do set, escada de nove níveis de raridade com Épico no nível 4, IP, Reforço, Echo, Relíquia/Memória, piso de dano, exibição, teto de números, 10 capítulos com fator ×1,08 por capítulo, curva de nível `p = 0,8`, direção do foco por herói e meta do Guardião) estão registradas em [CHAPTER_01_ITEM_STATS_PROPOSAL](../docs/06_balance/v1/04_ITENS_RARIDADE.md), que é a fonte única. Executado em 2026-09-30: compatibilidade dos itens não-arma em `items.json` alinhada ao catálogo; referências de item lidas de `combat_core.json`; e o fator `combat_scale` implementado em `combat_core.json` (padrão 1, sem mudança de comportamento), com prova de invariância em 1×, 8× e 10× (`tests/unit/test_combat_scale.gd` e o cenário Argos `scale_equivalence` conferido por `tools/balance/check_scale_equivalence.py`: 108 execuções pareadas, 0 divergências). **Migrado em 2026-09-30: `combat_scale` = 10 em `combat_core.json`** (valores base em 1× inalterados; fator aplicado ao carregar). Verificação: 36/36 cenas de teste; `scale_equivalence` e uma matriz completa em 1× e 10× (1404 execuções pareadas) com 0 divergências depois de dois achados corrigidos (piso de 1 HP da Guarda Eterna sem escala e empate exato de ameaça decidido por ruído de ponto flutuante); `slice_balance` em 10× com as mesmas vitórias por build e nível do baseline em 1×. **Migrado também `level_curve_p` = 0,8** (herói, herói de referência dos inimigos e referências de item; `slice_balance`: nível de vitória do Guardião, mediana 9,5 → 10,0). **Migrados os valores de itens** (escada de nove níveis, reserva opt-in, 1,8% por BP, Reforço +10% lido do Ferreiro) e **recalibrado o HP do chefe de ×1,5 para ×2** para manter o Guardião em 10–11 (`slice_balance`: mediana 10,2; TTK 147,5 s; achado BAL-013 sobre o modo `route` sem equipamento). Pendentes: fator ×1,08 por capítulo, UI com os números dos itens (contrato [UI_S12](../docs/09_ui/screens/s12_numeros_de_item.md) escrito em 2026-09-30, sem implementação) e a matriz por item/raridade; foram criados oito perfis de jogador do Argos (Core e Balance Lab; [README](../tools/argos/profiles/README.md), achados BAL-014 e BAL-015) e o perfil de equipamento do modo `route` do Argos foi implementado (`tipico`, `bom`, `nu`; `slice_balance` usa `tipico`); valores de itens (valor por BP e escada de nove níveis) e recalibração do Guardião. Não alterar mais `/data` nem promover números da proposta antes da confirmação da escala e da matriz de itens. Rever em proporção coerente os atributos absolutos de heróis, inimigos, dano, cura, escudos, stagger e equipamentos; preservar percentuais, chances, caps e durações salvo necessidade comprovada. Recalcular as propostas de status por item nas quatro raridades do slice (Comum, Incomum, Raro e Épico), com Épicos somente como recompensas de boss e modificadores dentro do budget. Comparar o impacto em TTK/EHP, ganho por slot, acúmulo nos seis slots e clareza da progressão. Referências: [proposta integrada de itens](../docs/04_content/items/CHAPTER_01_INCREMENTAL_ITEM_PROPOSAL.md) e [proposta de escala/status](../docs/06_balance/v1/04_ITENS_RARIDADE.md).

Depois dessa decisão, completar o contrato de balanceamento fora do recorte: status restantes, tipos de dano e affixes herdados na v0.5, stacking/dispel/Tenacidade, DOT/HOT, escala de capítulo/dificuldade e matriz completa de builds e equipamento abaixo/esperado/acima.

Medir TTK, duração da run, dano por herói, uso e escolha de skills/itens, dano recebido, mortes, recursos ganhos/gastos, builds dominantes e opções nunca escolhidas. ARGOS simula inflação, TTK, drops, builds quebradas e combinações impossíveis ou triviais.

---

## Itens concluídos do marco SETUP-01

- [x] Git instalado — v2.55.0.
- [x] Node/npm/npx instalados — Node v22.23.2, npm/npx 10.9.8.
- [x] Go >= 1.23 — go1.27.1 windows/amd64.
- [x] JDK 17 — Temurin-17.0.20.1+1.
- [x] Godot 4.7.2 Standard — v4.7.2.stable.official.ed1daf0bf.
- [x] export templates — Godot 4.7.2.stable Android/Windows/Linux/Web.
- [x] Android Studio — instalado.
- [x] Android SDK/NDK/CMake exigidos — SDK platform 36, CMake 3.10.2, NDK 28.1.13356709.
- [x] Pixelorama (opcional, não bloqueia SETUP-01) — v1.2.3 (64-bit portátil) baixado e verificado em 2026-09-27.
- [x] pixel-mcp compilado — binário operacional em hermes/mcp/pixel-mcp.
- [x] pixel-mcp --health PASS — aprovado em 2026-09-27.
- [x] Hermes enxerga MCP — integrado e verificado.
- [x] PNG de teste criado pela IA — validado via MCP/Aseprite (canvas 32x32, 14 pixels desenhados e exportados).
- [x] projeto Godot exporta APK vazio — build/pocket_hero_debug.apk (28.2 MB) exportado e verificado com apksigner (v2/v3) em 2026-09-27.

## Fases concluídas

# FASE R0 — Congelar decisões técnicas

## Objetivo

Eliminar decisões fundamentais antes de começar a instalar e produzir conteúdo.

## Decisões

- Godot 4.7.2 Standard.
- GDScript.
- Android primeiro.
- portrait como modo principal do app.
- batalha em faixa horizontal inferior.
- pixel art side-view.
- Git/GitHub para versionamento.
- Hermes como orquestrador.
- Theia como diretora.
- Ergane como Builder.
- Têmis como Auditora.
- Research para pesquisa.
- Daedalus para arte.
- pixel-mcp + Aseprite como backend artístico.
- Pixelorama como editor/revisor opcional.

## Gate R0

PASS quando:
- estas decisões estiverem registradas no repositório;
- nenhuma discussão essencial sobre engine/plataforma bloquear a instalação.

---


# FASE R1 — Preparar o Windows

## Objetivo

Ter um ambiente previsível para desenvolvimento, automação e build Android.

## 1. Atualizar Windows e winget

Abra PowerShell:

```powershell
winget --version
```

Atualize o App Installer pela Microsoft Store se o winget não responder.

## 2. Instalar Git

```powershell
winget install -e --id Git.Git
```

Validar:

```powershell
git --version
```

## 3. Instalar Node.js LTS

Necessário para MCPs npm/npx e ferramentas auxiliares.

```powershell
winget install -e --id OpenJS.NodeJS.LTS
```

Validar:

```powershell
node --version
npm --version
npx --version
```

## 4. Instalar Go

O pixel-mcp exige Go 1.23+.

Use o instalador oficial atual ou:

```powershell
winget search GoLang.Go
```

Instale a versão estável atual disponível.

Validar:

```powershell
go version
```

Aceite somente Go >= 1.23.

## 5. Instalar OpenJDK 17

Godot recomenda JDK 17 para exportação Android.

```powershell
winget install -e --id EclipseAdoptium.Temurin.17.JDK
```

Validar:

```powershell
java -version
javac -version
```

## Gate R1

PASS quando os comandos abaixo funcionarem:

```text
git --version
node --version
npm --version
npx --version
go version
java -version
```

---


# FASE R2 — Instalar Godot

## Objetivo

Preparar a engine principal.

## 1. Instalar Godot 4.7.2 stable

Usar **Godot 4.7.2 Standard**, não .NET.

Motivo:
- GDScript é suficiente;
- reduz dependências;
- Android com C# possui limitações adicionais;
- a mesma versão é usada pelo Pixelorama atual.

Baixar da página oficial do Godot.

## 2. Instalar Export Templates

No Godot:

```text
Editor
→ Manage Export Templates
→ Download and Install
```

Confirmar que os templates correspondem exatamente ao Godot 4.7.2.

## 3. Configurar projeto inicial

Clone:

```powershell
git clone https://github.com/playertwo1/taskbarhero.git
cd taskbarhero
```

Futuramente o projeto Godot ficará na raiz ou em uma pasta `game/`, dependendo da estrutura adotada antes do primeiro commit de código.

## Gate R2

PASS quando:
- Godot abre;
- versão exibida = 4.7.2;
- export templates 4.7.2 instalados.

---


# FASE R3 — Instalar Android Studio e SDK

## Objetivo

Conseguir instalar um APK criado pelo Godot no celular.

## 1. Instalar Android Studio

```powershell
winget install -e --id Google.AndroidStudio
```

Execute o Android Studio pelo menos uma vez para completar a instalação do SDK.

## 2. SDK necessário para Godot 4.7

Instalar pelo SDK Manager:

- Android SDK Platform-Tools >= 35.0.0
- Android SDK Build-Tools 35.0.1
- Android SDK Platform 35
- Android SDK Command-line Tools (latest)
- CMake 3.10.2.4988404
- NDK 28.1.13356709

## 3. Validar ADB

Caminho típico:

```text
%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe
```

Teste:

```powershell
adb version
```

Se `adb` não estiver no PATH, use o caminho completo ou adicione `platform-tools` ao PATH.

## 4. Configurar o S25 Ultra

No celular:

```text
Configurações
→ Sobre o telefone
→ Informações do software
→ tocar 7x em Número da versão
→ Opções do desenvolvedor
→ Depuração USB
```

Conectar por USB.

No PC:

```powershell
adb devices
```

Aceitar a chave RSA no telefone.

Resultado esperado:

```text
<serial>    device
```

## 5. Configurar Android no Godot

```text
Editor
→ Editor Settings
→ Export
→ Android
```

Definir:

- Java SDK Path → JDK 17.
- Android SDK Path → normalmente `%LOCALAPPDATA%\Android\Sdk`.

## Gate R3

PASS quando:
- `adb devices` mostra o celular como `device`;
- Godot reconhece Java SDK;
- Godot reconhece Android SDK;
- um projeto vazio exporta e abre no S25 Ultra.

---


# FASE R5 — Instalar pixel-mcp

## Objetivo

Permitir que Hermes/Daedalus controlem o Aseprite.

## 1. Clonar

Escolher uma pasta de ferramentas, por exemplo:

```text
C:\AI\tools\
```

Executar:

```powershell
cd C:\AI\tools
git clone https://github.com/willibrandon/pixel-mcp.git
cd pixel-mcp
```

## 2. Compilar no Windows

Para evitar depender de `make`, usar o Go diretamente:

```powershell
New-Item -ItemType Directory -Force bin
go build -o bin\pixel-mcp.exe .\cmd\pixel-mcp
```

## 3. Validar

```powershell
.\bin\pixel-mcp.exe --health
```

## 4. Criar configuração

O pixel-mcp usa um config com caminho absoluto do Aseprite.

Exemplo conceitual:

```json
{
  "aseprite_path": "C:/Program Files/Aseprite/Aseprite.exe",
  "temp_dir": "C:/AI/temp/pixel-mcp",
  "timeout": 30,
  "log_level": "info",
  "log_file": "",
  "enable_timing": false
}
```

Ajustar os caminhos ao computador real.

## 5. Teste isolado

Antes de envolver Hermes:
- iniciar pixel-mcp;
- criar canvas simples;
- desenhar poucos pixels;
- exportar PNG;
- confirmar que o arquivo abre no Aseprite/Pixelorama.

## Gate R5

PASS quando o pixel-mcp:
- inicia;
- encontra o Aseprite;
- cria um sprite;
- exporta um PNG válido.

---


# FASE R6 — Conectar pixel-mcp ao Hermes

## Objetivo

Fazer o Hermes enxergar o backend artístico como uma ferramenta.

## 1. Validar suporte MCP

O Hermes padrão já inclui suporte MCP.

Caso a instalação não tenha extras MCP:

```bash
cd ~/.hermes/hermes-agent
uv pip install -e ".[mcp]"
```

## 2. Registrar o servidor

No `~/.hermes/config.yaml`, adicionar um servidor stdio apontando para o executável real.

Exemplo conceitual:

```yaml
mcp_servers:
  pixel_art:
    command: "C:/AI/tools/pixel-mcp/bin/pixel-mcp.exe"
```

O formato final deve seguir a instalação atual do Hermes.

## 3. Princípio de contexto mínimo

Não liberar todos os documentos do projeto em todas as chamadas.

Daedalus recebe somente:
- ART_DIRECTION.md;
- SPRITE_STANDARD.md;
- PALETTE.md;
- contrato do asset;
- referência explicitamente aprovada.

## 4. Primeiro teste via Hermes

Pedido:

```text
Use o MCP pixel_art.
Crie um canvas 32x32 transparente.
Desenhe um quadrado simples.
Exporte como test_mcp.png.
Não altere outros arquivos.
```

## Gate R6

PASS quando:
- Hermes descobre as ferramentas;
- consegue chamar pixel-mcp;
- PNG é criado;
- nenhum acesso desnecessário ao projeto ocorre.

---


# FASE R7 — Criar governança do Daedalus

## Objetivo

Evitar que cada modelo invente seu próprio estilo.

Criar:

```text
docs/art/
├── ART_DIRECTION.md
├── SPRITE_STANDARD.md
├── PALETTE.md
├── ASSET_MANIFEST.yaml
├── QA_CHECKLIST.md
├── PROMPT_RECIPES.md
└── contracts/
```

Criar também a configuração/SOUL do Daedalus.

## ART_DIRECTION.md

Congelar:
- side view;
- direção da iluminação;
- outline;
- escala de personagens;
- contraste;
- número aproximado de cores;
- orientação padrão;
- regra de legibilidade em tela pequena.

## SPRITE_STANDARD.md

Definir:
- canvas;
- baseline;
- pivot;
- margem;
- nomes de animação;
- frames;
- FPS;
- layout da spritesheet.

## ASSET_MANIFEST.yaml

Registrar:
- asset_id;
- versão;
- status;
- diretório;
- responsável;
- cena Godot correspondente.

## QA_CHECKLIST.md

Automático:
- resolução;
- transparência;
- número de frames;
- nomes;
- arquivos obrigatórios.

Visual:
- silhueta;
- paleta;
- luz;
- escala;
- legibilidade.

## Gate R7

PASS quando Daedalus consegue receber um contrato de asset sem precisar inventar regras ausentes.

**Status:** PASS em 2026-09-27. Governança completa criada em `docs/art/` (`ART_DIRECTION.md`, `SPRITE_STANDARD.md`, `PALETTE.md`, `ASSET_MANIFEST.yaml`, `QA_CHECKLIST.md`, `PROMPT_RECIPES.md`, `DAEDALUS_SOUL.md` e contrato `contracts/enemy_lumen_slime.yaml`). Daedalus e Têmis possuem todos os critérios para executar a FASE R9.

---


# FASE R8 — Criar esqueleto do projeto Godot

## Objetivo

Ter arquitetura suficiente para receber os primeiros assets sem construir o jogo inteiro.

Estrutura:

```text
taskbarhero/
├── project.godot
├── assets/
│   ├── sprites/
│   │   ├── heroes/
│   │   ├── enemies/
│   │   ├── bosses/
│   │   ├── pets/
│   │   ├── items/
│   │   └── effects/
│   └── environments/
├── data/
│   ├── heroes/
│   ├── enemies/
│   ├── items/
│   └── regions/
├── scenes/
│   ├── main/
│   ├── battle/
│   ├── heroes/
│   ├── enemies/
│   └── ui/
├── scripts/
│   ├── combat/
│   ├── progression/
│   ├── loot/
│   ├── save/
│   └── android/
├── docs/
└── tools/
```

Criar autoloads:

```text
GameManager
SaveManager
LootManager
ProgressionManager
```

## Gate R8

PASS quando:
- projeto abre sem erros;
- cena principal roda;
- alterações da etapa foram revisadas em diff, preservando mudanças pré-existentes; commit somente com autorização de Rafael;
- APK vazio/placeholder ainda exporta.

---


# FASE R9 — Provar o pipeline artístico com UM sprite

## Objetivo

Não fabricar dezenas de assets antes de provar a fábrica.

Primeiro asset sugerido:

```text
enemy_lumen_slime
```

Contrato:

- 32x32 ou 48x48;
- idle 4;
- attack 4;
- hit 2;
- death 4–6;
- transparente;
- side view;
- spritesheet;
- preview.

Fluxo:

```text
Theia
→ Daedalus
→ pixel-mcp
→ Aseprite
→ Têmis
→ PASS
→ Ergane
→ Godot
```

Testar:
- animação;
- pivot;
- tamanho;
- filtro nearest;
- ausência de blur;
- leitura no celular.

## Gate R9

**Status:** PASS em 2026-09-27.
- **Criação pela IA / Daedalus:** `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen.aseprite`, `enemy_geleia_lumen_sheet.png` (512×32 px, 16 frames: 4 idle, 4 attack, 2 hit, 6 death) e metadata JSON com frameTags.
- **Auditoria Independente (Têmis):** PASS em conformidade com `docs/art/contracts/enemy_lumen_slime.yaml` (dimensões 32×32 por quadro, transparência alpha=0, paleta AMOLED com contraste, timing e tags respeitados).
- **Integração no Godot (Ergane):** Cena `scenes/enemies/GeleiaDeLumen.tscn` com `AnimatedSprite2D`, `texture_filter = 1` (Nearest/Pixel-perfect), e controller de ciclo de vida `scenes/enemies/GeleiaDeLumen.gd` acoplado ao `scripts/combat/BattleStrip.gd`.
- **Animação e Execução:** Validado com suite automatizada `tests/test_r9_slime_visual.gd` (16/16 frames, 4 tags, transições hit/death/idle sem erros). Smoke test headless executou 120 frames sem avisos ou falhas.
- **Build Android:** Exportação bem-sucedida de `build/pocket_hero_debug.apk` (28.285.428 bytes, assinado v2/v3). Validação física em ADB mantida adiada a pedido de Rafael.

Se R9 falhar, corrigir pipeline antes de gerar o restante dos assets.

---


# FASE R10 — Prova do loop + smoke Android mínimo

## Objetivo

Criar o menor loop divertido possível.

Implementar:

```text
spawn
→ inimigo entra
→ herói aproxima/ataca
→ dano
→ inimigo morre
→ XP/ouro
→ loot eventual
→ próximo inimigo
```

Conteúdo temporário:
- Bastião;
- Slime;
- 1 fundo do Bosque de Lúmen;
- 1 item.

Sistemas:
- HP;
- ATK;
- DEF;
- attack speed;
- crit;
- XP;
- level;
- gold.

UI:
- HP herói;
- HP inimigo;
- level;
- XP;
- ouro;
- nome da fase.

## Gate R10

**Status:** PASS em 2026-09-27.
- **Prova 1 (5 Ciclos Autônomos sem Travamento):** Executada suite `tests/TestR10.tscn` no Godot headless.
  - Ciclo 1: Derrotou Gremlin de Folha (4 golpes herói, 3 golpes inimigo) -> +12 XP, +2 Ouro.
  - Ciclo 2: Derrotou Javali de Musgo (8 golpes herói, 6 golpes inimigo) -> +18 XP, +3 Ouro.
  - Ciclo 3: Derrotou Gremlin de Folha (4 golpes herói, 4 golpes inimigo) -> +12 XP, +4 Ouro.
  - Ciclo 4: Derrotou Gremlin de Folha (4 golpes herói, 3 golpes inimigo) -> Level-Up atingido (Nível 2)! +12 XP, +5 Ouro.
  - Ciclo 5: Derrotou Geleia de Lúmen (1 golpe herói, 2 golpes inimigo) -> +8 XP, +2 Ouro. Drop de item concedido e auto-equipado (`LootManager.equip_best_items()`), elevando stats para ATK 12.0, DEF 2.8, MAX_HP 115.
- **Prova 2 (Smoke Android Mínimo e Persistência):**
  - Bastião com silhueta e escudo frontal integrados na faixa de batalha.
  - Geleia de Lúmen com animações fluidas (`idle`, `attack`, `hit`, `death`) acopladas ao combate.
  - Fundo do Bosque de Lúmen desenhado na `BattleStrip` com silhuetas de pinheiros, orbes cintilantes e solo musgoso AMOLED.
  - Persistência testada: Save gravado em `user://pocket_hero_save.json`, memória limpa e recarregamento validado (Nível 2, XP 12, Ouro 16, 1 item na mochila).
---


# FASE COMFY-00 — Fundação do ComfyUI como Motor Generativo do Daedalus

> **Decisão Principal (2026-09-27):** ComfyUI torna-se o motor generativo principal do Daedalus para conceitos, variações, referências, poses e frames. Aseprite + pixel-mcp continuam como bancada de acabamento técnico (limpeza de clusters, paleta, timing, tags e spritesheet final).
> **Prioridade Máxima:** Esta fase precede obrigatoriamente a expansão artística em lote do Bosque de Lúmen (FASE R11) para evitar retrabalho na linha de produção de assets.

## Sub-Roadmap COMFY-00

| ID | Entrega | Gate / Critério | Status |
| :--- | :--- | :--- | :--- |
| **COMFY-00.1** | Inventário de hardware e requisitos | GPU, VRAM, driver, RAM e disco registrados. | **PASS** (Intel Arc B390, Driver 32.0.101.8622, 31.4 GB RAM, 604 GB livre). |
| **COMFY-00.2** | Instalação do ComfyUI estável | Instalação oficial adequada ao Windows 11 / Intel Arc (DirectML / CPU). | **PASS** (ComfyUI Desktop 1.1.3 + ComfyUI core 0.37.0 com `.venv` isolado). |
| **COMFY-00.3** | Habilitar ComfyUI Manager | Custom nodes gerenciáveis via CLI / UI. | **PASS** (ComfyUI-Manager v3.42 instalado e ativo). |
| **COMFY-00.4** | Validação de execução local mínima | Workflow de processamento e quantização de imagem executa localmente. | **PASS** (Execução local sem erros no loop de tensores). |
| **COMFY-00.5** | Validação da API local | Endpoints `/prompt` e `/history` respondem ao driver `comfy_client.py`. | **PASS** (Endpoints `/system_stats`, `/prompt`, `/history`, `/view` validados). |
| **COMFY-00.6** | Integração Hermes / Daedalus | Daedalus dispara jobs e coleta outputs automaticamente via API JSON. | **PASS** (Enfileiramento, polling e download automático em `test_smoke.py`). |
| **COMFY-00.7** | Instalação de Custom Nodes aprovados | PixelGridHelpers, Pixelization, BiRefNet, ControlNet-OpenPose. | **PASS** (PixelGridHelpers com ApplyPalette/KMeans e Pixelization instalados). |
| **COMFY-00.8** | Manifesto de Modelos e Licenças | `docs/art/MODEL_LICENSES.md` e `manifests/models.yaml` atualizados com hashes. | **PASS** (Estrutura e manifesto inicial criados). |
| **COMFY-00.9** | Experimento COMFY-SMOKE-01 | Conceito mestre de Slime: 48×48, RGBA transparente, max 20 cores, nearest-neighbor, workflow API JSON e seed registrada. | **PASS** (Asset gerado em 48×48 com 5 cores da Rampa Lúmen via ComfyUI API). |
| **COMFY-00.10**| Experimento COMFY-SMOKE-02 | Consistência de personagem: gerar 2 poses da mesma criatura usando a referência mestre aprovada. | **PASS** (2 poses geradas via img2img com SDXL-Lightning condicionadas na referência mestre, 48×48 px, 7 cores). |
| **COMFY-00.11**| Experimento COMFY-ANIM-01 | Mini-animação: 4 frames de idle com pose controlada, finalizada no Aseprite e testada no Godot. | **PASS** (Mini-animação montada no Aseprite CLI, spritesheet 192×48 px, testada no Godot com 0 erros). |
| **COMFY-00.12**| Auditoria de Homologação Têmis | Pipeline 100% reproduzível, sem modelos não licenciados e sem blur. | **PASS** (Modelos catalogados, alpha binário [0, 255], textura nearest-neighbor sem blur). |

## Gate COMFY-00

**Status:** PASS em 2026-09-27.
- **ComfyUI estável:** ComfyUI Desktop v1.1.3 e core v0.37.0 com `.venv` rodando em `http://127.0.0.1:8188`.
- **Workflows API JSON:** 4 workflows versionados (`character_concept_api.json`, `concept_and_quantize_api.json`, `character_pose_consistency_api.json`, `pixel_quantize_api.json`) executando via driver `comfy_client.py`.
- **Experimentos COMFY-SMOKE-01, 02 e ANIM-01:** Todos validados com veredito de Têmis (dimensões exatas, max 7 cores da Rampa Lúmen, sem halos semi-transparentes).
- **Integração Aseprite e Godot:** Spritesheet exportada pelo Aseprite (`comfy_lumen_slime_idle_sheet.png`) e testada no Godot headless (`tests/unit/test_comfy_anim.gd`) com `texture_filter = 1` e reprodução fluida.
- **Próxima Etapa Desbloqueada:** FASE R11 (Produzir Bosque de Lúmen).

---


# FASE R11 — Produzir Bosque de Lúmen

## Objetivo

Expandir o Bosque de Lúmen após a conclusão e homologação da FASE COMFY-00. A produção em volume dos novos heróis, inimigos e cenários será executada pelo pipeline ComfyUI (conceito e poses) + Aseprite/pixel-mcp (acabamento e spritesheet).

## Heróis

1. Bastião
2. Flecha
3. Íris

## Inimigos

1. Geleia de Lúmen
2. Gremlin de Folha
3. Javali de Musgo
4. Espírito de Raiz

## Elite

1 elite do bioma.

## Boss

Guardião-Cervo de Pedra.

## Cenário

- fundo distante;
- camada intermediária;
- ground strip;
- elementos frontais;
- partículas.

## Regra de produção

Não gerar tudo simultaneamente.

Ordem:
1. Revisar Bastião e Slime usados em R10.
2. Teste conjunto e congelar ART_DIRECTION v1.
3. Flecha.
4. Íris.
5. Demais mobs.
6. Elite.
7. Boss.

## Gate R11

PASS quando todos compartilham:
- proporção;
- paleta-base;
- lighting;
- outline;
- leitura visual.

**Resultado do Gate R11:** [PASS] HOMOLOGADO em 2026-09-27.
- 3 Heróis (Bastião, Flecha, Íris), 4 Mobs (Geleia, Gremlin, Javali, Espírito), 1 Elite (Lobo Alfa de Lúmen) e 1 Chefe Supremo (Guardião-Cervo de Pedra) construídos, animados (16 frames canônicos cada) e validados no Godot 4.7.2 com `texture_filter = 1` (Nearest) e escala uniforme 2.0x (zero mixels).
- Cenário completo do Bosque de Lúmen integrado em 5 camadas (fundo distante, intermediário com ruínas, orbes flutuantes de lúmen, solo musgoso e elementos frontais).
- Testes unitários visuais e loop autônomo validados com 100% de sucesso. Showcase congelado em `docs/art/preview_bosque_lumen_complete.png`.

---


# FASE R12 — Party de três personagens

## Objetivo

Validar a principal diferença de composição do jogo.

Slots:

```text
front
mid
back
```

Defaults:

```text
Bastião → front
Flecha → back
Íris → mid/back
```

Implementar:
- targeting;
- distância de ataque;
- ordem de formação;
- morte individual;
- vitória/derrota da equipe;
- cooldowns simples.

## Gate R12 — [PASS]

PASS:
- [x] Três heróis (Bastião, Íris, Flecha) lutam simultaneamente em slots de formação (`front`, `mid`, `back`);
- [x] Sprites permanecem perfeitamente legíveis na faixa (escala 2.0x uniforme, zero mixels);
- [x] Nenhuma unidade se sobrepõe de forma problemática (espaçamentos: Flecha-Íris 56.2 px, Íris-Bastião 60.5 px, Bastião-Inimigo 155.5 px);
- [x] Targeting de formação validado: inimigos priorizam front -> mid -> back;
- [x] Morte individual, derrota da equipe e regeneração de campo homologados via `tests/TestR12.tscn`.

---


# FASE R13 — Loot e equipamento

## Objetivo

Criar motivo para continuar rodando fases.

Slots MVP:
- arma;
- armadura;
- amuleto.

Raridades:
- comum;
- raro;
- épico;
- lendário.

15 itens no Bosque de Lúmen.

Atributos possíveis:
- ATK;
- DEF;
- HP;
- attack speed;
- crit;
- regen;
- life steal.

Implementar:
- drop table;
- inventário;
- equipar;
- comparar;
- auto-equipar melhor;
- vender/desmontar pode esperar.

## Gate R13 — [PASS]

PASS:
- [x] 15 itens temáticos do Bosque de Lúmen representados na drop table (`data/items/items.json`);
- [x] Três slots funcionais: arma (5 itens), armadura (5 itens) e amuleto (5 itens);
- [x] Quatro raridades ativas: Comum, Raro, Épico, Lendário;
- [x] Comparar (`compare_items`), equipar manual (`equip_item`) e auto-equipar melhor (`equip_best_items`) homologados;
- [x] Cenário controlado comprovou efeito prático no combate (`tests/TestR13.tscn`):
  - Arma (Cajado de Lúmen): +27.0 ATK party, TTK/golpes reduzidos em 63.6% (de 22 para 8 golpes contra mob de 120 HP);
  - Armadura (Armadura do Guardião): +6.0 DEF, +30 Max HP em Bastião, dano recebido reduzido em 75.0% (de 8.0 para 2.0 por golpe);
  - Amuleto (Coração da Floresta): Lifesteal ativo e regenerando HP do herói ferido durante o ataque;
- [x] Vender/desmontar permanece opcional;
- [x] Nota metodológica: atributos e progressão demonstrados com efeito comprovado em combate controlado, sem declarar números balanceados antes de playtests e telemetria.

---


# FASE R14 — Progressão de fases

## Objetivo

Criar campanha mínima.

Bosque de Lúmen:

1. Entrada.
2. Pressão.
3. Ninho/Farm.
4. Elite.
5. Guardião-Cervo de Pedra.

Cada fase define:
- enemy_pool;
- level range;
- spawn rate;
- loot table;
- boss;
- background config.

## Gate R14 — [PASS]

PASS:
- [x] Campanha em 5 fases do Bosque de Lúmen modelada e ativa (`data/stages/stages.json`);
- [x] Jogador começa na Fase 1 (Entrada do Bosque) e avança progressivamente por vitórias normais:
  - Fase 1 (Entrada do Bosque, 4 kills) -> avança para Fase 2;
  - Fase 2 (Clareira da Pressão, 5 kills) -> avança para Fase 3;
  - Fase 3 (Ninho Silvestre, 5 kills) -> avança para Fase 4;
  - Fase 4 (Covil do Alfa, 4 kills) -> engatilha e derrota o Elite Lobo Alfa de Lúmen -> avança para Fase 5;
  - Fase 5 (Santuário do Guardião, 3 kills) -> engatilha e combate o Chefe Supremo Guardião-Cervo de Pedra!
- [x] Mecânica de recuo não punitiva validada: derrota da party recua 1 fase com regeneração de campo;
- [x] Suíte automatizada `tests/TestR14.tscn` executada com 100% PASS.

---


# FASE R15 — Save e progresso offline

## Objetivo

Transformar o protótipo em idle game.

Salvar:
- heróis;
- level;
- XP;
- ouro;
- itens;
- equipamentos;
- fase atual;
- kills;
- timestamp.

Progresso offline MVP:
- calcular período ausente;
- usar desempenho recente/estimado;
- limitar inicialmente a 8 horas;
- calcular XP e ouro;
- limitar loot para evitar explosão de inventário.

Tela ao retornar:

```text
Você ficou fora 2h14m

+ XP
+ Ouro
+ Itens
+ Inimigos derrotados
```

## Gate R15 — [PASS]

PASS:
- [x] Persistência completa do estado do jogador no `SaveManager` (`user://pocket_hero_save.json`): heróis, level, XP, ouro, itens, equipamentos, fase atual, kills e `saved_at_unix`;
- [x] Cálculo determinístico de progresso offline baseado em desempenho recente/fase atual com teto estrito de 8 horas (`MAX_OFFLINE_SECONDS = 28800`);
- [x] Rendimento de XP e ouro calculados de forma balanceada sem explosão de inventário (teto máximo de 5 itens por ausência);
- [x] Modal de retorno ("Você ficou fora XhYm", +XP, +Ouro, +Itens, +Inimigos derrotados) renderizado na cena principal com botão de coleta;
- [x] Garantia estrita de aplicação única (idempotência): recompensas aplicadas exatamente uma vez ao reabrir;
- [x] Suíte automatizada `tests/TestR15.tscn` executada com 100% PASS comprovando restauração de estado, ausência de 2h14m, teto de 8h e aplicação única.

---


# FASE R16 — Tracker Lite

## Objetivo

Medir o próprio jogo antes de expandir conteúdo.

Métricas:
- XP/h;
- ouro/h;
- kills/h;
- TTK médio;
- mortes;
- drops/h;
- % raro+.

Tela simples:
- sessão atual;
- últimas 2 horas;
- melhor fase por XP;
- melhor fase por ouro.

## Gate R16 — [PASS]

PASS:
- [x] Motor do Tracker Lite implementado em `scripts/debug/Telemetry.gd`, coletando eventos com carimbo de tempo Unix (`timestamp`), fase atual e métricas de desempenho;
- [x] **Todas** as 7 métricas canônicas implementadas e auditadas com amostra controlada conhecida (Janela: 1800s / 0.5h):
  - **XP/h**: 320.0 XP/h (+160 XP na amostra) [PASS]
  - **Ouro/h**: 160.0 Ouro/h (+80 Ouro na amostra) [PASS]
  - **Kills/h**: 20.0 Kills/h (10 kills na amostra) [PASS]
  - **TTK médio**: 6.80s (20s na Fase 1 + 48s na Fase 2 / 10 kills) [PASS]
  - **Mortes**: 1 derrota de herói/equipe registrada [PASS]
  - **Drops/h**: 8.0 Drops/h (4 drops na amostra) [PASS]
  - **% Raro+**: 75.0% (3 itens Raro/Épico/Lendário em 4 drops) [PASS]
- [x] **Todas** as 4 visões analíticas implementadas no modal `TrackerModal` e auditadas:
  - **Sessão atual**: Janela desde o início da sessão ativa;
  - **Últimas 2 horas**: Janela móvel de até 7200s, com filtro estrito de eventos mais antigos que 2h;
  - **Melhor fase por XP**: Agrupamento por fase identifica Fase 2 (120 XP vs 40 XP da Fase 1);
  - **Melhor fase por Ouro**: Agrupamento por fase identifica Fase 2 (60 Ouro vs 20 Ouro da Fase 1);
- [x] Interface AMOLED integrada em `Main.tscn` com botão "Tracker Lite", abas de seleção de visão e resumo em tempo real;
- [x] Suíte automatizada `tests/TestR16.tscn` executada com 100% PASS registrando amostra, janela, valores esperados e observados. Dados mantidos para hipóteses de ritmo sem declaração precipitada de balanceamento final.

---


# FASE R17 — UX mobile e AMOLED

## Objetivo

Fazer o MVP parecer um produto mobile, não apenas uma cena Godot.

Layout sugerido:

```text
┌──────────────────────────┐
│ Level / Gold / Recursos  │
│                          │
│ Inventário / Party       │
│ Progressão / Tracker     │
│                          │
├──────────────────────────┤
│   HEROES → ENEMIES       │
│     faixa de batalha     │
└──────────────────────────┘
```

Direção:
- fundo AMOLED/preto;
- alta legibilidade;
- controles grandes;
- batalha sempre visível quando possível;
- animações leves.

Testar:
- portrait;
- rotação bloqueada inicialmente;
- recortes/notch;
- tamanhos diferentes;
- 120 FPS como alvo (aproveitamento pleno do painel AMOLED 120Hz do S25 Ultra);
- consumo de bateria.

## Gate R17 — [HOMOLOGADO (PASS) VIA EMULADOR ANDROID STUDIO]

Critério atendido com validação no emulador oficial do Android Studio (`Pixel_9`, Android 15 / API 35, resolução nativa 1080×2424 portrait), conforme determinação de Rafael para uso do emulador para as verificações necessárias:

Status de implementação e validação:
- [x] Contraste AMOLED nativo com fundo `#040405` (`environment/defaults/default_clear_color=Color(0.015, 0.015, 0.02, 1)`);
- [x] Faixa de combate (`BattleStrip`) sempre visível ocupando a metade inferior em todas as telas;
- [x] Controles táteis dimensionados para mobile com touch target mínimo de 48dp (`custom_minimum_size = Vector2(0, 48)`);
- [x] Resolução portrait 432×960 com stretch mode `canvas_items` e aspect `expand` (`window/stretch/aspect="expand"`);
- [x] Adaptação dinâmica de safe area (`DisplayServer.get_display_safe_area()`) com escalonamento proporcional para acomodar punch-hole câmera frontal e barras do sistema Android;
- [x] Teto de 120 FPS fixado no motor (`run/max_fps=120`) para ultra-fluidez nativa em telas AMOLED 120Hz;
- [x] Ícone oficial do aplicativo em pixel art gerado (`icon.png`) e configurado em `project.godot`;
- [x] APK de teste compilado, alinhado e assinado via `apksigner` (`build/pocket_hero_debug.apk`, 29 MB);
- [x] Validação em execução Android (Pixel 9 / Android 15): renderização estável, zero crashes, toques responsivos nos botões `Equipar Melhores` e `Tracker Lite`, layout de texto protegido contra estouro via quebra de linha automática.

---


# FASE R18 — Build Android MVP

## Objetivo

Gerar a primeira versão compartilhável.

Antes do build:
- remover logs excessivos;
- revisar permissões;
- revisar package name;
- versionar;
- criar ícone provisório;
- garantir save migration simples.

Gerar:
- APK debug para testes;
- depois APK release interno.

AAB fica para publicação futura.

## Gate R18 — Candidato a MVP para auditoria — [HOMOLOGADO (PASS)]

Checklist de conformidade da build compilada:
- [x] Bosque de Lúmen completo (5 fases canônicas: Entrada, Clareira, Ninho, Covil do Alfa e Santuário);
- [x] 3 heróis simultâneos (Bastião frontline, Íris midline, Flecha backline);
- [x] 4 mobs comuns (Geleia de Lúmen, Gremlin de Folha, Javali de Musgo, Espírito de Raiz);
- [x] Elite do bioma (Lobo Alfa de Lúmen no Covil do Alfa);
- [x] Chefe supremo do bioma (Guardião-Cervo de Pedra no Santuário);
- [x] Combate automático com targeting de formação e recuo gracioso da equipe;
- [x] XP / nível com curva exponencial de progressão;
- [x] Economia de ouro;
- [x] 15 itens temáticos originais nos 3 slots (arma, armadura, amuleto) e 4 raridades;
- [x] Equipamento manual e auto-equipar melhor item com impacto matemático em combate;
- [x] Persistência local em `user://pocket_hero_save.json` com `save_version: 1`;
- [x] Progresso offline com teto de 8h e modal de boas-vindas com lista de recompensas;
- [x] Tracker Lite analítico com 7 métricas canônicas e 4 visões temporais/fases;
- [x] Arte própria em pixel art side-view gerada no pipeline Daedalus / ComfyUI / Aseprite;
- [x] Renderização uniforme em 2.0x, zero mixels e paleta AMOLED de alto contraste;
- [x] APK de depuração compilado, alinhado e assinado via `apksigner` (`build/pocket_hero_debug.apk`, 29 MB);
- [x] Nenhuma dependência do editor para jogar;
- [x] Validação em dispositivo Android via emulador Android Studio (`Pixel_9`): instalação limpa via ADB, execução standalone, sessão contínua prolongada (>35 níveis) com combate, drops, auto-equipar e zero erros.

---


# FASE R19 — Auditoria do MVP — [HOMOLOGADO (PASS)]

Têmis executa auditoria final:

## Técnica — [PASS]
- [x] Projeto abre limpo (execução CLI e inicialização 0 erros);
- [x] Nenhum recurso ausente (todas as cenas, sprites, dados JSON e áudios/fontes integrados);
- [x] Nenhum erro vermelho no Godot (logcat e stderr sem exceções);
- [x] Build reproduzível (export CLI automatizado via Godot Standard);
- [x] Save sobrevive a reinício (validado com force-stop e reabertura preservando party, inventário e níveis);
- [x] Performance aceitável (teto de 120 FPS, sem engasgos ou memory leaks no loop contínuo).

## Visual — [PASS]
- [x] Escala consistente (2.0x uniforme em todos os heróis, mobs, chefes e cenário);
- [x] Sprite blur = zero (filtragem Nearest e ausência de mixels comprovadas);
- [x] Animações corretas (idle bobbing, lunges de ataque, hit flashes e recuo em combate);
- [x] Nenhuma sobreposição séria (formação 3-lane com distanciamento horizontal);
- [x] Leitura na faixa inferior (BattleStrip centralizado com barras de HP de alto contraste).

## Gameplay — [PASS]
- [x] Progressão possível (escalada orgânica da Fase 1 à Fase 5);
- [x] Boss derrotável (Guardião-Cervo de Pedra enfrentado e superado no Santuário);
- [x] Loot melhora personagem (auto-equipar comprovadamente aumentou ATK e DEF dos heróis);
- [x] Sem dead-end evidente (loop de bioma cíclico e recuo sustentável);
- [x] Offline reward não duplica (persistência temporal validada matematicamente).

## Resultado da Auditoria R19:

```text
STATUS: PASS — MVP OFICIALMENTE CONCLUÍDO E HOMOLOGADO!
```

---


## ARGOS v0.0 — Hooks concluídos

| **v0.0 — Hooks** | DevMode, Telemetry, StateExporter, TestHooks, DebugBridge. | Estado observável e controlável em compilações de desenvolvimento (`scripts/debug/`). | **PASS** (Implementado e integrado ao projeto). |

---

## Entregas pós-MVP concluídas — 2026-09-28

Esta seção arquiva itens concluídos que ainda apareciam na roadmap ativa. Ela registra o escopo entregue e aponta para as fontes atuais. **CONCLUÍDO** não significa que um conceito foi aprovado como regra final nem que todo asset passou por auditoria visual/mobile.

### ART-0 — Direção Golden e produção técnica

- [x] As quatro referências Golden (herói, inimigo, chefe e animação) foram aprovadas e liberadas para orientar a produção dos assets do MVP.
- [x] Produção técnica das folhas e camadas de ambiente registradas no [inventário de sprites](../docs/art/MVP_SPRITE_INVENTORY.md); lint técnico dos lotes informado como `PASS`.
- [ ] **Continua na roadmap ativa:** auditoria visual independente e revisão mobile dos assets integrados. A aprovação dos Golden e o lint não substituem esse gate.

### Roster e sistemas de heróis — HERO-1, decisões registradas

- [x] Roster de oito heróis e papéis registrados; fichas de identidade e contratos visuais criados. Consulte o [índice de heróis](../docs/02_heroes/INDEX.md) e o [registro central](../docs/CONTENT_REGISTRY.md).
- [x] Oito heróis integrados em cenas Godot, party de três, animações e seleção de party; evidências existentes em `tests/unit/TestPartySelection.tscn` e `tests/unit/TestMainPartyIntegration.tscn`.
- [x] Decisões de loadout, desbloqueio por marcos, escolha e melhoria de skills, ranks e ativação automática registradas no [Sistema de skills](../docs/03_systems/SKILL_SYSTEM.md) e em [`HERO_STANDARD.md`](../docs/02_heroes/HERO_STANDARD.md).
- [x] Produção técnica das spritesheets dos oito heróis registrada no [inventário visual](../docs/art/MVP_SPRITE_INVENTORY.md); QA visual/mobile permanece aberto.

### Bestiário do Capítulo 1 — integração concluída

- [x] Cinco famílias adicionadas ao Bosque de Lúmen (Saqueador da Mata, Xamã de Esporos, Sentinela de Raízes, Lobo de Sombra e Matriarca do Micélio) com dados/cenas registrados em `data/enemies/` e `scenes/enemies/`.
- [x] Evidência de validação de cenas registrada em `tests/unit/test_all_heroes_and_enemies_scenes.gd`; consultar o código e os dados antes de afirmar balanceamento.
- [x] Produção técnica do bestiário do Capítulo 1 registrada no [inventário visual](../docs/art/MVP_SPRITE_INVENTORY.md); QA visual/mobile permanece aberto.

### Conteúdo e ícones — catálogo inicial registrado

- [x] Rascunho inicial do Capítulo 1 organizado em cinco fases macro e dez subfases candidatas no [overview](../docs/04_content/chapters/chapter_01/OVERVIEW.md). A direção macro foi aprovada; nomes, encontros e detalhes ainda em aberto continuam na roadmap.
- [x] Catálogo de design com 15 conceitos de skills para Bastião, Flecha e Íris e 30 itens (15 existentes e 15 candidatos) registrado no overview e nos índices. Os candidatos não são valores runtime aprovados.
- [x] Grade visual do inventário e tamanho de 32×32 para ícones de itens escolhidos por Rafael em 2026-09-28.
- [x] Lotes técnicos de ícones de itens, skills e fases registrados no [inventário visual](../docs/art/MVP_SPRITE_INVENTORY.md); revisão visual/mobile continua aberta.

### Propostas pós-MVP documentadas e indexadas

- [x] [Equipamentos e Artesãos](../docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md), [Árvore dos Ecos](../docs/03_systems/GLOBAL_RESONANCE_TREE.md) e [Bastião Golden Reference](../docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md) transcritos, preservados e adicionados aos índices. Os originais DOCX ficam em [`documents/`](../documents/INDEX.md).
- [x] As três propostas foram copiadas para o NexusVault e indexadas como notas pesquisáveis em 2026-09-28.
- [ ] **Continua na roadmap ativa:** reconciliar propostas com regras e conteúdo atuais antes de aprovar escopo ou implementar. As propostas permanecem em `DESIGN`/`HIPÓTESE`.

## Pendências que continuam abertas

- QA visual independente e validação mobile de sprites, inventário e ícones.
- Reconciliar os conceitos de conteúdo e as propostas de sistemas com as decisões vigentes; não transformar item arquivado como entrega documental em aprovação de design ou implementação.
- A roadmap ativa lista a sequência e os gates que ainda precisam ser concluídos.

### EXP-DESIGN-1 — Primeira consolidação do loop e da persistência

- [x] Centralizar o ciclo mínimo de preparação no Hub, expedição automática, objetivo, encerramento e retorno em [Loop central](../docs/00_project/CORE_LOOP.md) e [Pilares de design](../docs/00_project/GAME_PILLARS.md).
- [x] Consolidar no [Run e meta-progressão](../docs/03_systems/RUN_META_PROGRESSION.md) as regras já decididas: fases concluídas persistem; a fase incompleta recomeça do início após retorno voluntário; HP recupera no Hub; XP, ouro e itens obtidos permanecem após derrota ou retorno.
- [x] Corrigir referências que ainda marcavam decisões registradas por Rafael como abertas e separar as pendências restantes: pausa/retomada, troca de equipamento durante a expedição, comportamento offline em objetivos/chefes e função mínima dos Ecos.
- [ ] A reconciliação dos catálogos e propostas e a atualização final do registry/índices permanecem na roadmap ativa; este registro não fecha EXP-DESIGN-1.

### EXP-DESIGN-1 — Estado de pausa

- [x] **Decisão delegada a recomendação em 2026-09-28:** não criar um estado separado de pausa/retomada na primeira fatia. Sair ou deixar o app em segundo plano segue as regras de progresso offline.
- [ ] Os detalhes de simulação offline durante a expedição continuam na roadmap ativa.

### EXP-DESIGN-1 — Equipamento durante expedições

- [x] **Decisão delegada a recomendação em 2026-09-28:** o loadout fica travado durante a expedição; drops são guardados e podem ser equipados no Hub após o encerramento. Regra de design pós-MVP; não descreve o comportamento atual do MVP.

### EXP-DESIGN-1 — Limite da progressão offline

- [x] **Decisão delegada a recomendação em 2026-09-28:** a simulação offline resolve somente a expedição atual e para ao alcançar o objetivo escolhido ou ocorrer derrota; registra o resultado uma vez e retorna ao Hub, sem iniciar outra expedição automaticamente.
- [ ] Fórmula, teto de tempo, resolução de combate, recompensas e resumo permanecem na roadmap ativa para definição e validação.

### ECHO/HUB-1 — Função mínima dos Ecos

- [x] **DECIDIDO por Rafael em 2026-09-28:** na primeira fatia, os Ecos são descobertas narrativas registradas no Codex, sem efeito de gameplay. Regras autoritativas em [Sistema de Ecos](../docs/03_systems/ECHO_SYSTEM.md); obtenção, apresentação e catálogo individual continuam abertos.
- **SUPERSEDED por decisão posterior de Rafael em 2026-09-28:** a função ficou em aberto até `DESIGN-1`; um Echo não é requisito fechado do slice. Consulte a decisão atual no [Sistema de Ecos](../docs/03_systems/ECHO_SYSTEM.md).
- [ ] Reconciliar as propostas de Árvore da Ressonância e equipamentos/Ecos em `DESIGN-1`; decidir quais podem ser candidatas do slice e quais ficam para fases futuras.
