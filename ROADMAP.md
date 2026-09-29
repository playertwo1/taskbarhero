# ROADMAP — Pocket Hero

**Status atualizado em 2026-09-29** · **Engine:** Godot 4.7.2 Standard · **Plataforma inicial:** Android

Roadmap único do projeto: define prioridade, ordem e gates. Detalhes de design ficam nas fontes linkadas em cada fase (um fato → uma fonte). O histórico do MVP está em [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

---

## 1. Onde estamos

- **MVP:** concluído e homologado no gate **R19** em 2026-09-27. Não reabrir; o conteúdo legado será substituído pelo slice no `1A-CUT` (seção 4, decisão de 2026-09-29).
- **Fase atual:** expansão de conteúdo, identidade e meta-progressão.
- **Diagnóstico de 2026-09-29:** a fundação de design está ampla (sistemas, Bastião, Flecha, Árvore, artesãos, itens, economia), mas nenhum número foi validado em jogo. O gargalo agora é **provar os contratos no SLICE-1**, não escrever mais fichas.
- **Próximo passo:** [SLICE-1](#43-slice-1--vertical-slice-do-jogo-real), começando por 1A (migração do subconjunto para `/data` e combate). SLICE-0 e BALANCE-FOUNDATION-1 estão `PASS` (2026-09-29).
- **Evidência técnica atual:** `python tools/run_godot_tests.py` — 11/11 cenas PASS em 2026-09-29.

---

## 2. Princípios e controle de escopo

- Preservar os Golden References aprovados. O MVP homologado é substituído pelo conteúdo do slice no `1A-CUT` (decisão de Rafael, 2026-09-29); antes disso, mudanças canônicas novas não alteram código homologado sem tarefa explícita de migração.
- Bosque de Lúmen continua sendo o Capítulo 1; não iniciar capítulos futuros antes de validar o loop.
- Sem backend, contas, multiplayer, cloud save ou monetização.
- Números de balanceamento são **HIPÓTESE** até simulação e playtest.
- Evoluir por gates pequenos; cada fase fecha com evidência, não com documento.

Antes de adicionar um sistema, perguntar: melhora o core loop? cria decisão? reforça progressão? reforça lore? interage com sistemas existentes? Se todas forem "não", não priorizar. O objetivo é poucos sistemas conversando entre si:

`herói ↔ skill ↔ passiva ↔ Trait ↔ item ↔ Echo ↔ party ↔ inimigo ↔ evento ↔ lore ↔ Árvore dos Ecos ↔ artesãos ↔ Hub`

Fantasia, core loop e pilares: [`GAME_PILLARS.md`](docs/00_project/GAME_PILLARS.md) e [`CORE_LOOP.md`](docs/00_project/CORE_LOOP.md).

---

## 3. Fundação concluída

Gates `PASS` em design. Nenhum deles aprova runtime, números finais ou balanceamento.

| Fase | Gate | Escopo aprovado | Fonte |
| --- | --- | --- | --- |
| **ART-0** | PASS 2026-09-27 | 4 Golden visuais (Bastião v002, Geleia, Guardião-Cervo v002, idle da Geleia). Pendente: QA visual independente e revisão mobile para release. | [Golden](docs/art/golden/README.md) · [inventário](docs/art/MVP_SPRITE_INVENTORY.md) |
| **SYNC-0** | PASS | Contratos de design importados e indexados. | [docs/INDEX.md](docs/INDEX.md) |
| **DESIGN-1** | PASS 2026-09-28 | Party 3 de 8; separação run / herói / equipamento / conta; saídas da expedição; Echo opcional no slice. | [CORE_LOOP](docs/00_project/CORE_LOOP.md) · [skills](docs/03_systems/SKILL_SYSTEM.md) |
| **HERO-STD** | APPROVED | Anatomia canônica do herói (1 básico + 6 skills, 16 passivas, 3 Traits, Mastery 1–10, 6 slots, 5 missões, 4 formas). | [HERO_STANDARD.md](HERO_STANDARD.md) |
| **LORE-1** | PASS 2026-09-28 | Bíblia de Lore com mistérios centrais em aberto. | [LORE_BIBLE](docs/01_world/LORE_BIBLE.md) |
| **HERO-001 Bastião** | DESIGN completo | Golden Reference de design: kit, passivas, Traits, Mastery, lore e 5 missões. Pendente: números, diálogos, encounters, sprites finais, implementação. | [Golden Reference](docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md) |
| **TREE-1** | PASS 2026-09-28 | 30 nós em 7 ramos, pré-requisitos e custos relativos. Alvo posterior ~84 nós. | [Árvore dos Ecos](docs/03_systems/GLOBAL_RESONANCE_TREE.md) |
| **CRAFT-1** | PASS 2026-09-28 | Quatro artesãos (Ferreiro, Alquimista, Gravadora de Ecos, Ourives), serviço mínimo, fonte/sink e ordem de abertura. | [Equipamento e crafting](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) |
| **ITEM-1** | PASS 2026-09-28 | 6 slots, 6 raridades v0.4, catálogo de 30 itens; 15 itens runtime como legado. | [Equipamento](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) · [itens](docs/04_content/items/INDEX.md) · [ponte legada](docs/04_content/LEGACY_RUNTIME_CATALOG.md) |
| **LOOT v0.4** | APPROVED como cânone | Base de combate, loot, inimigos, materiais e economia. Integração ao runtime em LOOT-EXPANSION-1. | [TASKBAR v0.4](documents/canonical/taskbar_sistema_v0.4/README.md) |

---

## 4. Sequência ativa

A ordem é esta. Não pular etapas: cada uma entrega o que a seguinte consome.

**DECIDIDO (Rafael, 2026-09-29) — estratégia de runtime do slice:** o SLICE-1 migra para `/data` **somente o subconjunto v0.4 que usa**, com aliases dos IDs runtime atuais registrados no [registro de conteúdo](docs/CONTENT_REGISTRY.md). Não haverá arquivos de dados paralelos. **Revisado em 2026-09-29 (Rafael):** o conteúdo legado do MVP é **removido** de `/data`, do código e dos testes na etapa `1A-CUT`, quando a rota do slice já funciona; até lá ele coexiste e a suíte segue verde. Depois do corte, o MVP antigo deixa de ser jogável (histórico no git e em `arquivados/`). LOOT-EXPANSION-1 completa a migração depois do slice.

### 4.0 ECON-1 — Economia mínima · `DESIGN` em andamento

Feito: [modelo econômico](docs/06_balance/ECONOMY_MODEL.md), [15 encontros / 32 derrotas e proposta do Guardião](docs/04_content/chapters/chapter_01/ENCOUNTERS.md), [plano estruturado](docs/04_content/chapters/chapter_01/encounter_plan.json) e [simulação reproduzível](tools/economy/simulate_chapter1_balance.py) de cobertura, budgets, rendimento e TTK teórico.

O que falta depende de jogo real e **fecha no SLICE-1E**: combate, taxa de vitória na primeira tentativa, pacing, teto e conversão offline.

Gate PASS:
- [x] árvore, Ferreiro, Alquimista e loot têm sinks definidos; nenhum recurso sem função;
- [x] custos principais simuláveis;
- [x] primeira expedição offline termina no objetivo/derrota sem iniciar outra;
- [x] melhoria do Ferreiro demonstrável com fonte não repetível de Resíduo de Lúmen, sem ser requisito para vencer;
- [ ] TTK, vitória na primeira tentativa e pacing medidos no SLICE-1E;
- [ ] teto numérico e conversão de tempo offline medidos no SLICE-1E.

### 4.1 SLICE-0 — Recorte do slice · `PASS`

**Estado:** `PASS` em 2026-09-29. Recorte registrado em [SLICE_1_SCOPE.md](docs/04_content/chapters/chapter_01/SLICE_1_SCOPE.md); decisões abertas ficam listadas lá, com dono.

Escolher subconjuntos de fontes já aprovadas, sem criar conteúdo novo. O resultado é a lista fechada que o BALANCE-FOUNDATION-1 e o SLICE-1 consomem.

- [x] trio (Bastião, Flecha, Íris): skills, passivas e Traits do slice, garantindo pelo menos duas builds distintas;
- [x] subset de equipamentos cobrindo os principais slots e subset de raridades v0.4;
- [x] subset de inimigos, 1 elite, 1 mini-boss e as fases do Guardião-Cervo a implementar ([ENCOUNTERS](docs/04_content/chapters/chapter_01/ENCOUNTERS.md) · [sementes](docs/04_content/chapters/chapter_01/DESIGN_SEEDS.md));
- [x] 1 evento de expedição com escolha real;
- [x] 1 Echo funcional opcional com recompensa determinística ([Sistema de Ecos](docs/03_systems/ECHO_SYSTEM.md));
- [x] ramo pequeno da Árvore dos Ecos e o serviço do Ferreiro (desmontagem + 1 melhoria);
- [x] mudança visual do Refúgio após o boss e efeito do Fragmento do Coração Verde ([Hub](docs/05_hub/HUB_STRUCTURE_SEEDS.md) · [direção visual](docs/05_hub/HUB_VISUAL_DIRECTION.md));
- [x] lista de IDs v0.4 que entram em `/data` e seus aliases com os IDs runtime atuais;
- [x] **inventário de arte do recorte:** para cada entidade, efeito e tela do slice, indicar se já existe folha `v002`/Golden utilizável ou se precisa de contrato novo ([inventário MVP](docs/art/MVP_SPRITE_INVENTORY.md) · [conceitos](docs/art/conceitos/README.md)); assets novos seguem contrato → QA técnico → auditoria visual independente, e o primeiro asset novo passa o gate antes dos demais;
- [x] atualizar o [overview do Capítulo 1](docs/04_content/chapters/chapter_01/OVERVIEW.md) ao padrão de 6 skills por herói.

Gate PASS: recorte registrado com fontes, IDs e aliases; nenhum item do slice sem fonte aprovada; lacunas de arte listadas com contrato ou decisão de reaproveitamento.

### 4.2 BALANCE-FOUNDATION-1 — Contrato de balanceamento · `PASS`

**Estado:** `PASS` em 2026-09-29. Contrato em [SLICE_BALANCE_CONTRACT.md](docs/06_balance/SLICE_BALANCE_CONTRACT.md); números seguem HIPÓTESE até o SLICE-1E.

Integrar ao combate do Pocket Hero **apenas a parte da v0.4 que o recorte do SLICE-0 usa**, com Bastião como referência. Template base: [COMBAT_BALANCE_STANDARD](docs/06_balance/COMBAT_BALANCE_STANDARD.md). O restante do contrato fica para BALANCE-1.

- [x] status canônicos usados pelo slice: ID, unidade, significado, cálculo, limites e mapeamento para os nomes/valores runtime atuais;
- [x] como Guarda, Perfect Block, Desequilíbrio/Stagger e Marca entram no pipeline compartilhado;
- [x] fórmulas de dano, crítico, defesa/penetração e cura/escudo, com caps, ordem e exemplos calculados contra o combate atual;
- [x] baseline do trio (Bastião primeiro) e dos inimigos, elite, mini-boss e boss do recorte, dentro dos budgets v0.4 ou com justificativa;
- [x] budgets dos slots e raridades do recorte;
- [x] métricas mínimas de telemetria para o slice: dano, cura, TTK, mortes, uso de skills e recursos ganhos/gastos;
- [x] cada número rastreado como `DECIDIDO`, `HIPÓTESE` ou `EM ABERTO`, com fonte e método.

Gate PASS: tudo que o slice usa tem definição única e fórmula calculável à mão; heróis e inimigos do recorte usam o mesmo modelo de status/modificadores; baselines prontos para teste. O PASS **não** declara o jogo balanceado.

### 4.3 SLICE-1 — Vertical slice do jogo real

Fluxo: `Hub → party → build → expedição → combate → escolha → evento → elite → mini-boss → boss → retorno → Árvore/Ferreiro → evolução do Hub`

Cada etapa fecha com teste automatizado novo em `tests/`, a suíte completa passando (`python tools/run_godot_tests.py`) e o jogo rodando com o conteúdo vigente (o legado só existe até o `1A-CUT`).

- **1A — Combate e dados:** migrar o subconjunto v0.4 para `/data` com aliases; combate usa o modelo do BALANCE-FOUNDATION-1; trio com as skills do recorte. Sub-fatias: `1A-1` `CombatMath` (feito), `1A-2` dados e carregadores do slice, `1A-3` rota de 10 encontros e combate, `1A-CUT` remoção do legado com testes reescritos, `1A-4` skills, passivas e Traits, `1A-5` telemetria.
- **1B — Run:** expedição com escolhas de build, evento e elite; loot do recorte equipável ou reciclável.
- **1C — Chefes:** mini-boss e Guardião-Cervo com mecânicas distintas de inimigo comum.
- **1D — Retorno:** Hub, ramo da Árvore, Ferreiro (desmontagem + 1 melhoria), Echo opcional e mudança visual do Refúgio após o boss.
- **1E — Validação:** QA mobile no emulador, QA visual dos assets novos e medições pendentes do ECON-1 (TTK, vitória na primeira tentativa, pacing, offline).

Fora do slice: árvore completa (~84 nós), os 8 heróis, artesãos em nível máximo, crafting profundo, affixes aleatórios/reforja, campanhas pessoais completas, Mastery em runtime.

Gate PASS:
- [ ] loop completo jogável do início ao fim;
- [ ] decisões da run influenciam a build; pelo menos duas builds claramente diferentes;
- [ ] progressão do herói e progressão global compreensíveis e distintas;
- [ ] equipamento ganho pode ser usado ou reciclado com decisão real;
- [ ] boss com mecânica distinta de inimigo comum;
- [ ] retorno ao Hub produz progressão perceptível sem grind artificial;
- [ ] etapas 1A–1E concluídas com evidência registrada.

### 4.4 BALANCE-1 — Ajuste iterativo · pós-slice

Completar o contrato de balanceamento fora do recorte: status restantes, tipos de dano e affixes v0.4, stacking/dispel/Tenacidade, DOT/HOT, escala de capítulo/dificuldade e matriz completa de builds e equipamento abaixo/esperado/acima.

Medir TTK, duração da run, dano por herói, uso e escolha de skills/itens, dano recebido, mortes, recursos ganhos/gastos, builds dominantes e opções nunca escolhidas. ARGOS simula inflação, TTK, drops, builds quebradas e combinações impossíveis ou triviais.

### 4.5 LOOT-EXPANSION-1 — Integração v0.4 ao runtime · pós-slice

Completa a migração iniciada no SLICE-1A.

- [ ] integrar `ENEMY_CANONICAL_SCHEMA` e os 17 inimigos canônicos, com aliases dos IDs runtime;
- [ ] adotar os 30 itens, 7 materiais e 6 raridades, compatíveis com os 6 slots;
- [ ] integrar o Drop Resolver e os mecanismos canônicos (Smart Loot, Duplicate Protection, Slot Pity, Quality Floor, Reward Choice, Boss Fragments, Bestiário), calibrados por simulação;
- [ ] persistência e idempotência de first clear/pity, seed reproduzível, save migration, overflow e telemetria local;
- [ ] tabelas humanas como vistas derivadas de uma única fonte de dados;
- [ ] schemas, validação, cenários de QA e critérios de aceite antes do runtime.

Gate PASS: fonte única sem colisão de IDs; fonte e sink para cada recompensa; resolver determinístico por estado e seed; pity dentro dos budgets; simulações de primeira conclusão e repetição; save/overflow/telemetria verificáveis; MVP não alterado retroativamente.

---

## 5. Trilhas pausadas até o slice

Retomar depois do SLICE-1, usando os contratos validados.

- **HERO-002 Flecha:** identidade, 6 skills, 3 builds, 16 passivas, 3 Traits e Mastery 1–10 em [ficha](docs/02_heroes/hero_002_flecha.md) · [skills](docs/04_content/skills/FLECHA_SKILLS.md) · [passivas](docs/02_heroes/hero_002_flecha_passives.md) · [Traits](docs/02_heroes/hero_002_flecha_traits.md) · [Mastery](docs/02_heroes/hero_002_flecha_mastery.md). Faltam lore + 5 missões e equipamentos/Ecos de referência.
- **HERO-1 roster:** Íris, Brasa, Véu, Orvalho, Forja e Sino no padrão canônico. Os nomes de skills propostos estão no [HERO_STANDARD](HERO_STANDARD.md). Gate: 8 heróis documentados, 48 skills, 128 passivas, 24 Traits, Mastery e 5 missões por herói, 2+ sinergias por herói, nenhum herói substituindo outro.
- **Conteúdo do Capítulo 1 completo:** 10 subfases, 10–15 eventos, eventos pessoais, 3 elites com modificadores, 3 mini-bosses e segredos ([sementes](docs/04_content/chapters/chapter_01/DESIGN_SEEDS.md)).
- **HUB-1 completo:** layout do Refúgio, ordem de abertura de todos os estabelecimentos e UI detalhada da Árvore ([estrutura proposta](docs/05_hub/HUB_STRUCTURE_SEEDS.md)).
- **Expansão da Árvore dos Ecos** além dos 30 nós.
- **Relações entre heróis e regiões futuras:** apenas sementes ([FUTURE_SEEDS](docs/01_world/FUTURE_SEEDS.md)).

---

## 6. Pendências de setup

Anotadas no marco SETUP-01; não reabrem o MVP.

- [ ] **ADB / S25 Ultra:** conexão física adiada em 2026-09-27; emulador Android Studio usado em R17–R19.
- [ ] **Aseprite 1.3.10+:** 1.3.7 operacional; alvo ainda não atingido.

---

## 7. Trabalho futuro

### ARGOS — Autonomous Playtester

Hooks da v0.0 concluídos. **Ordem revisada (Rafael, 2026-09-29):** simulador + Analyst antes do Maestro, porque o gargalo atual é balanceamento; RSN Game QA fica como referência de oráculos, não dependência.

| Versão | Escopo | Entrega / gate | Estado |
| --- | --- | --- | --- |
| **v0.1 — Foundation** | GdUnit4, Maestro MCP, perfis Beginner/Chaos. | APK testado por jornadas Android; 10+ regressões críticas. | PENDENTE |
| **v0.2 — Visual** | Fallback CLI Android, screenshots, regressão visual. | Detectar botões inacessíveis e HUD quebrado. | PENDENTE |
| **v0.3 — Scale** | Simulador headless (10k–100k execuções) e Argos Analyst. | Relatórios de inflação, drops, TTK e economia. | `IMPLEMENTING` — ARGOS-SIM de combate/campanha do slice em uso ([README](tools/argos/README.md), [achados](docs/08_qa/BALANCE_FINDINGS.md)); economia e loot pendentes |
| **v0.4 — Learning** | Godot RL Agents. | Experimento de estratégias emergentes/exploits. | EXPERIMENTAL |
| **v1.0 — Autonomous QA** | build → test → report → fix → retest. | Ciclo validado em CI. | PENDENTE |

### Overlay Android

Pós-MVP e fora da arquitetura central até priorização explícita: Android Build Template + Gradle, plugin Kotlin e service, permissão `TYPE_APPLICATION_OVERLAY`, touch passthrough, bateria e restrições de background.

---

## 8. Referências

- [Documentos do projeto](documents/INDEX.md) · [índice de docs](docs/INDEX.md) · [registro de conteúdo](docs/CONTENT_REGISTRY.md)
- [Resumo consolidado](docs/POCKET_HERO_PROJECT_BRIEF.md) · [estado do projeto](PROJECT_STATE.md)
- [Histórico das fases concluídas](arquivados/ROADMAP_CONCLUIDO.md) · [CHANGELOG](CHANGELOG.md)
