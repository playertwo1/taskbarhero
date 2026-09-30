---
document_type: roadmap
project: Pocket Hero
repository: taskbarhero
language: pt-BR
last_reviewed: 2026-09-30
engine: Godot 4.7.2 Standard
platform: Android (app normal)
current_focus: [SLICE-1E playtest humano, BALANCE-1 aplicar o balanceamento v1.0, OPUS-ROUND-1 (só Claude Opus)]
---

# ROADMAP — Pocket Hero

Roadmap único do projeto: prioridade, ordem e gates. Ele **aponta** para as fontes; não copia regras, lore nem números (um fato → uma fonte).

## Como ler este arquivo (qualquer agente: Claude, ChatGPT, Antigravity)

1. Leia a seção **1 (Estado atual)** e a **3 (Agora)**. Só abra a **4 (Próximo)** e a **5 (Futuro)** se a tarefa pedir.
2. Cada fase tem um **ID estável** (ex.: `BALANCE-1`). Use-o ao citar a fase em commits, relatórios e documentos.
3. **Status de ciclo de vida:** `CONCEPT` → `DESIGN` → `APPROVED` → `IMPLEMENTING` → `IMPLEMENTED` → `QA` → `PASS` · `DEPRECATED`.
4. **Certeza:** **DECIDIDO** (Rafael decidiu) · **HIPÓTESE** (valor a testar) · **EM ABERTO** (decisão de Rafael pendente). Não invente decisões em aberto: pergunte.
5. Checklist `[x]` = feito com evidência; `[ ]` = pendente.
6. O que foi concluído está em [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md), com o texto original de cada gate. Material arquivado é histórico: não use como fonte de regra ou número.
7. Regras de trabalho, ordem de carregamento e comandos: [`AGENTS.md`](AGENTS.md). Painel de caminhos: [`PROJECT_STATE.md`](PROJECT_STATE.md).

---

## 1. Estado atual (conferido em 2026-09-30)

**Fluxo jogável:** `TitleScreen → SliceCampaign` (Refúgio → loadout → expedição de 10 encontros → Rainha das Geleias → Guardião-Cervo → retorno → Árvore dos Ecos / Ferreiro). O MVP antigo foi removido no `1A-CUT` e só existe no git (commit `cd47758`).

| Área | Estado | Evidência |
| --- | --- | --- |
| Suíte Godot | **37/37 cenas PASS** | `python tools/run_godot_tests.py` em 2026-09-30 (inclui `TestItemStatView`). |
| Dados de balanceamento | Validador **OK** | `python tools/balance/validate_balance_data.py` em 2026-09-30. |
| Argos (simulação) | 0 `BUG`; achados `BALANCE`/`PACING` abertos | Último `slice_balance`: `tools/argos/reports/20260930-180715_82571ad/REPORT.md`; perfis de jogador: `20260930-183035_82571ad`; achados em [BALANCE_FINDINGS](docs/08_qa/BALANCE_FINDINGS.md). |
| SLICE-1 (vertical slice) | `IMPLEMENTED` / QA mobile `PASS` | Loop completo no emulador Pixel 9 (`1080x2424`): [relatório](docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md). |
| Playtest humano do slice | **pendente** | Roteiro pronto em [PLAYTEST_1E](docs/08_qa/PLAYTEST_1E.md), ainda não executado. |
| Kits do trio | `IMPLEMENTED` / HIPÓTESE | Bastião, Flecha e Íris com 6 skills (Signature no 3º slot fixo), 16 passivas, 3 Traits e 3 builds. [Validação](docs/08_qa/KITS_VALIDATION_2026-09-30.md) · [log de ajuste](docs/08_qa/KITS_TUNING_LOG.md). |
| Balanceamento | **v1.0** global escrito (`DESIGN`); escala **10×** migrada (DECIDIDO) | `combat_scale` = 10 e `level_curve_p` = 0,8 em [`combat_core.json`](data/balance/combat_core.json); regras do jogo inteiro em [balanceamento v1.0](docs/06_balance/v1/README.md). |
| Arte | Padrão de Alta Densidade integrado | [Relatório](docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md) · [índice de arte](docs/07_art/INDEX.md). |

---

## 2. Concluído (resumo)

Detalhes, evidências e texto original de cada gate: [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

| ID | Resultado | Data | Fonte vigente |
| --- | --- | --- | --- |
| MVP (R0–R19) | Homologado no R19 e substituído pelo slice no `1A-CUT` | 2026-09-27 / 2026-09-29 | Só histórico |
| ART-0 | 4 Golden + Padrão de Alta Densidade | 2026-09-27 / 2026-09-30 | [Golden](docs/art/golden/README.md) · [inventário](docs/art/MVP_SPRITE_INVENTORY.md) |
| SYNC-0 | Contratos de design importados e indexados | — | [docs/INDEX.md](docs/INDEX.md) |
| DESIGN-1 | Party 3 de 8; separação run / herói / equipamento / conta | 2026-09-28 | [CORE_LOOP](docs/00_project/CORE_LOOP.md) · [skills](docs/03_systems/SKILL_SYSTEM.md) |
| HERO-STD | Anatomia canônica do herói (`APPROVED`) | 2026-09-28 | [HERO_STANDARD](docs/02_heroes/HERO_STANDARD.md) |
| LORE-1 | Bíblia de Lore | 2026-09-28 | [LORE_BIBLE](docs/01_world/LORE_BIBLE.md) |
| HERO-001 | Bastião: Golden Reference de design | 2026-09-28 | [Golden Reference](docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md) |
| TREE-1 | Árvore dos Ecos: 30 nós em 7 ramos | 2026-09-28 | [GLOBAL_RESONANCE_TREE](docs/03_systems/GLOBAL_RESONANCE_TREE.md) |
| CRAFT-1 | Quatro artesãos e serviço mínimo | 2026-09-28 | [EQUIPMENT_AND_CRAFTING_SYSTEM](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) |
| ITEM-1 | 6 slots, quatro raridades no slice | 2026-09-28 | [itens](docs/04_content/items/INDEX.md) |
| SLICE-0 | Recorte do slice | 2026-09-29 | [SLICE_1_SCOPE](docs/04_content/chapters/chapter_01/SLICE_1_SCOPE.md) |
| BALANCE-FOUNDATION-1 | Contrato de balanceamento + arquitetura global | 2026-09-29 | [v1 · perfil do Capítulo 1](docs/06_balance/v1/capitulos/CAPITULO_01.md) · [v1 · telemetria e Argos](docs/06_balance/v1/10_TELEMETRIA_ARGOS.md) |
| SLICE-1A | Combate, dados, rota, skills/passivas, telemetria, corte do legado | 2026-09-30 | [SliceTelemetry](scripts/combat/SliceTelemetry.gd) · [route_c1.json](data/expedition/route_c1.json) |
| SLICE-1B | Eventos, Reward Choice, loot, inventário, save | 2026-09-29 | [SLICE_1B_RUN_SPEC](docs/03_systems/SLICE_1B_RUN_SPEC.md) |
| SLICE-1C | Rainha das Geleias e Guardião-Cervo com mecânicas próprias (`APPROVED`) | 2026-09-29 | [ENCOUNTERS](docs/04_content/chapters/chapter_01/ENCOUNTERS.md) |
| SLICE-1D | Echo, Fragmentos, Árvore de 6 nós, Ferreiro, Refúgio visual | 2026-09-30 | [ECHO_SYSTEM](docs/03_systems/ECHO_SYSTEM.md) · [blacksmith_slice.json](data/progression/blacksmith_slice.json) |
| SLICE-1E (técnico) | Contratos de tela, pausa/velocidades, loadout livre, QA mobile Pixel 9 | 2026-09-30 | [UI](docs/09_ui/INDEX.md) · [QA mobile](docs/08_qa/QA_MOBILE_PIXEL9_REPORT.md) |
| KITS-1 | Kits completos do trio em runtime (HIPÓTESE) | 2026-09-30 | [planos 00–04](arquivados/planos_concluidos/2026-09-30-kits-completos-00-fundacao.md) · [validação](docs/08_qa/KITS_VALIDATION_2026-09-30.md) |
| SCALE-10X | `combat_scale` 10, curva `p = 0,8`, valores de itens, HP de chefe ×2, perfis de equipamento na rota do Argos | 2026-09-30 | [v1 · perfil do Capítulo 1](docs/06_balance/v1/capitulos/CAPITULO_01.md) · [BAL-013](docs/08_qa/BALANCE_FINDINGS.md) |
| BALANCE-V1-DOC | Balanceamento global v1.0: constituição + 11 domínios + perfil do Capítulo 1; absorveu a base v0.5, a origem v0.4 e os contratos antigos (excluídos) | 2026-09-30 | [balanceamento v1.0](docs/06_balance/v1/README.md) |
| REPO-ORG | Repositório reorganizado: referências visuais numa pasta só, ferramentas Python fora de `scripts/`, planos concluídos arquivados, AGENTS enxuto, verificador de links oficial, ~260 MB de lixo local removidos | 2026-09-30 | [estrutura do repositório](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md) |
| ARGOS-PROFILES | Oito perfis de jogador executáveis (Core e Balance Lab) com fuzz de inventário | 2026-09-30 | [profiles/README](tools/argos/profiles/README.md) |

---

## 3. Agora — trabalho em andamento

Ordem de prioridade. Trabalhe uma fatia por vez.

### NOW-1 · SLICE-1E — Playtest humano · `QA` pendente

- **Objetivo:** medir com pessoas o que o Argos não mede: diversão, clareza, TTK sentido, vitória na primeira tentativa e pacing.
- **Fonte:** [PLAYTEST_1E](docs/08_qa/PLAYTEST_1E.md) (perguntas, registro por tentativa e retorno ao balanceamento).
- **Fecha também:** os dois últimos itens do gate `ECON-1` ([v1 · economia e loot](docs/06_balance/v1/07_ECONOMIA_LOOT.md)).
- [ ] executar o playtest e registrar as respostas;
- [ ] TTK, vitória na primeira tentativa e pacing medidos (gate `ECON-1`);
- [ ] teto numérico e conversão de tempo offline medidos (gate `ECON-1`);
- [ ] levar os resultados às decisões `BAL-009` a `BAL-015` (seção NOW-3).

### NOW-2 · BALANCE-1 — Aplicar o balanceamento v1.0 · `IMPLEMENTING`

- **Objetivo:** levar as regras do [balanceamento v1.0](docs/06_balance/v1/README.md) do documento para `/data` e para o Argos, com medição antes de cada número.
- **Fontes:** [constituição](docs/06_balance/v1/00_CONSTITUICAO.md) · [decisões abertas](docs/06_balance/v1/11_DECISOES_ABERTAS.md) · [perfil do Capítulo 1](docs/06_balance/v1/capitulos/CAPITULO_01.md) · [proposta integrada de itens](docs/04_content/items/CHAPTER_01_INCREMENTAL_ITEM_PROPOSAL.md).
- **Já feito:** ver `SCALE-10X`, `BALANCE-V1-DOC` e `ARGOS-PROFILES` na seção 2.
- [ ] Rafael decide D-01 a D-09 (NOW-3); sem isso, não gravar números novos;
- [ ] cenário "jogador de referência" no Argos, com inimigos sintéticos por capítulo ([10 §4](docs/06_balance/v1/10_TELEMETRIA_ARGOS.md));
- [ ] ablação por fonte para medir as fatias de poder ([00 §4](docs/06_balance/v1/00_CONSTITUICAO.md));
- [ ] regras novas do Analyst: teto de sinergia, fraqueza declarada, relevância, passiva mensurável, variância;
- [ ] curva de XP que alcance o nível 100 ([02 §5](docs/06_balance/v1/02_HEROIS.md), D-04);
- [ ] matriz de status por item/raridade (Comum, Incomum, Raro, Épico; Épico só em chefe) — **EM ABERTO**, não inferir valores;
- [ ] fator ×1,08 por capítulo em `/data`;
- [x] implementar a tela [UI_S12 — números de item](docs/09_ui/screens/s12_numeros_de_item.md) (camada de apresentação `ItemStatView.gd` integrada no Inventário, Ferreiro, Loadout e Resultado; 37/37 cenas PASS);
- **Restrição:** nada de `/data` muda sem decisão e sem relatório do Argos antes/depois ([00 §11](docs/06_balance/v1/00_CONSTITUICAO.md)).
- **Gate PASS:** decisões D-01 a D-09 registradas; jogador de referência e fatias medidos; matriz de itens aprovada; Capítulo 1 dentro das metas no Argos; confronto com o playtest.

### NOW-3 · Decisões aguardando Rafael · `EM ABERTO`

| ID | Pergunta | Fonte |
| --- | --- | --- |
| BAL-009 | Arcano/Controle tardios e Guardião sem folga — decidir depois do playtest | [BALANCE_FINDINGS](docs/08_qa/BALANCE_FINDINGS.md) |
| BAL-010 | `lumen` e `retaliacao_tele` vencem cedo: reduzir Pulso Restaurador, reduzir Contra-Golpe telegrafado ou aceitar | idem |
| BAL-011 | Íris `arcano` fraca; 36 passivas novas sem efeito medido | idem |
| BAL-012 | TTK do Guardião abaixo de 120–210 s (parcialmente tratado pelo HP ×2; confirmar) | idem |
| BAL-013 | Aprovar o perfil de equipamento `tipico` no modo `route` do Argos | idem |
| BAL-014 | Perfil Grinder: Resíduo de Lúmen e inventário crescem sem limite | idem |
| BAL-015 | Perfil Beginner: 44% de abandono, concentrado nas builds com Íris Arcano | idem |
| D-01 a D-09 | Decisões estruturais do balanceamento v1.0 (medição do orçamento, Signature, foco por herói, curva de XP, escalas globais, Reforço, teto de D3, fatias, sinergia) | [11_DECISOES_ABERTAS](docs/06_balance/v1/11_DECISOES_ABERTAS.md) |
| UI | Revisar os contratos de tela `UI_S01`–`UI_S12` (`DESIGN`) | [docs/09_ui](docs/09_ui/INDEX.md) |
| Textos | Revisar os textos de eventos do 1B (`DESIGN`) | [SLICE_1B_RUN_SPEC](docs/03_systems/SLICE_1B_RUN_SPEC.md) |

### NOW-4 · Arte do ui_kit v003 · `CONCEPT` aprovado

- **Objetivo:** levar o conceito aprovado a asset final.
- **Fonte:** [README do ui_kit](assets/sprites/ui/ui_kit/README.md) · [contrato](docs/art/contracts/screens/ui_kit.yaml) · [conceito](docs/art/candidates/ui_kit_v003/README.md).
- [ ] pixelização no Aseprite a partir do conceito (não gerar a arte final por script);
- [ ] QA técnico (`tools/sprite_lint.py`) e auditoria visual independente;
- [ ] QA mobile das telas que usam o kit.

### NOW-5 · OPUS-ROUND-1 — Próxima rodada técnica · `DESIGN` · **executor: somente Claude Opus**

**Regra de execução (Rafael, 2026-09-30):** esta fatia é feita **apenas com o Claude Opus**, junto com Rafael. Outros agentes (ChatGPT, Antigravity/Gemini, Sonnet, Haiku ou subagentes de outro modelo) **não executam** estes itens: podem só ler e citar. Se você não é o Claude Opus, pare e avise Rafael.

**Parte A — decisões e correções do balanceamento v1.0** (cada uma pede a escolha de Rafael antes de mudar `/data`):

- [ ] **Curva de XP (D-04):** a curva atual não alcança o nível 100. Subir do 99 ao 100 exige ~22 milhões de XP, e o chefe dá 80. Proposta: o XP concedido cresce com o nível do conteúdo na mesma taxa do XP exigido, medida pelo Argos contra as horas-alvo ([02 §5](docs/06_balance/v1/02_HEROIS.md#5-xp-e-ritmo-de-nível)).
- [ ] **Medição do orçamento 30/30/25/15 (D-01):** medido do nível 1 ao 100, como aprovado, nunca fecha (só o nível multiplica o poder ~16×; o melhor equipamento dá +80%). A v1 mede o ganho **dentro de cada capítulo**; confirmar ou escolher outra régua ([00 §4](docs/06_balance/v1/00_CONSTITUICAO.md#4-orçamento-de-poder)).
- [ ] **Teto da dificuldade D3 (D-07):** o chefe do capítulo 10 em D3 teria ~1,1 milhão de HP, acima do teto de 1 milhão. Opções: HP de D3 ×1,9, teto próprio de 2 milhões ou reduzir o HP de party do chefe ([09 §3](docs/06_balance/v1/09_DIFICULDADE_ENDGAME.md#3-teto-por-camada)).

**Parte B — manutenção do repositório** (detalhe e cuidados em [ESTRUTURA_DO_REPOSITORIO §5](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md#5-recomendações-ainda-não-executadas)):

- [ ] R-1 unir `docs/art/` e `docs/07_art/` (~700 arquivos com `.import`);
- [ ] R-2 `.gdignore` em `docs/` e parar de versionar `.import` de imagens de documentação (testar a leitura do Argos em `docs/`);
- [ ] R-3 remover cenas de inimigos do MVP que o slice não usa (mudança de código; rodar testes);
- [ ] R-4 renomear `documents/` (junto com R-1);
- [ ] R-5 versionar só os relatórios do Argos citados como evidência.

**Gate PASS:** D-01, D-04 e D-07 decididos e registrados na v1 (e em `/data` com Argos antes/depois, quando couber); R-1 a R-5 feitos ou descartados por Rafael; `python tools/docs/check_links.py --orphans`, testes Godot, validador e Argos sem falhas.

---

## 4. Próximo — depois do slice (em ordem)

Não iniciar antes de fechar `NOW-1` e `NOW-2`, salvo pedido de Rafael.

### NEXT-1 · LOOT-EXPANSION-1 — Integração do loot canônico ao runtime (regras v1.0)

Completa a migração iniciada no SLICE-1A. Regras: [v1 · economia e loot](docs/06_balance/v1/07_ECONOMIA_LOOT.md), [schema de inimigo](docs/06_balance/v1/specs/ENEMY_CANONICAL_SCHEMA.md), [Drop Resolver](docs/06_balance/v1/specs/DROP_RESOLVER_SPEC.md). Dados do Capítulo 1: [JSON canônico dos inimigos](docs/04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json).

- [ ] integrar `ENEMY_CANONICAL_SCHEMA` e os 17 inimigos canônicos, com aliases dos IDs runtime ([registro](docs/CONTENT_REGISTRY.md));
- [ ] adotar o catálogo do Capítulo 1 reconciliado, 7 materiais e as quatro raridades do slice nos 6 slots; confirmar expansão e IDs antes da migração;
- [ ] integrar o Drop Resolver e os mecanismos canônicos (Smart Loot, Duplicate Protection, Slot Pity, Quality Floor, Reward Choice, Boss Fragments, Bestiário), calibrados por simulação;
- [ ] persistência e idempotência de first clear/pity, seed reproduzível, migração de save, overflow e telemetria local;
- [ ] tabelas humanas como vistas derivadas de uma única fonte de dados;
- [ ] schemas, validação, cenários de QA e critérios de aceite antes do runtime.

**Gate PASS:** fonte única sem colisão de IDs; fonte e sink para cada recompensa; resolver determinístico por estado e seed; pity dentro dos budgets; simulações de primeira conclusão e repetição; save/overflow/telemetria verificáveis.

### NEXT-2 · HERO-SYSTEMS-1 + HERO-1 — Arquitetura e roster dos oito heróis

Proposta: [HERO_SYSTEMS_Roadmap_Canonica.docx](documents/HERO_SYSTEMS_Roadmap_Canonica.docx) (não substitui o [HERO_STANDARD](docs/02_heroes/HERO_STANDARD.md) nem aprova números).

- [ ] reconciliar ações, skills, Ultimate/Signature, árvores, Mastery e Ascension com o `HERO_STANDARD`, as fichas e o runtime;
- [ ] completar a matriz funcional e as identidades dos oito heróis; escolher um `HERO_REFERENCE` antes de produzir kits;
- [ ] schemas compartilhados para herói, skills, passivas, árvore, Mastery, Ascension, campanha pessoal e sinergias;
- [ ] Flecha (HERO-002): lore, 5 missões e equipamentos/Ecos de referência ([ficha](docs/02_heroes/hero_002_flecha.md));
- [ ] roster restante (Brasa, Véu, Orvalho, Forja, Sino) no padrão canônico, em ondas.

**Gate PASS:** arquitetura validada por um herói de referência; builds distintas alteram gameplay; schemas congelados; 8 heróis, 48 skills, 128 passivas, 24 Traits, Mastery e 5 missões por herói, com 2+ sinergias e sem redundância.

### NEXT-3 · CHAPTER-1-FULL — Conteúdo completo do Capítulo 1

- [ ] 10 subfases, 10–15 eventos, eventos pessoais, 3 elites com modificadores, 3 mini-bosses e segredos ([sementes](docs/04_content/chapters/chapter_01/DESIGN_SEEDS.md) · [overview](docs/04_content/chapters/chapter_01/OVERVIEW.md)).

### NEXT-4 · HUB-1 — Refúgio completo e Árvore expandida

- [ ] layout do Refúgio, ordem de abertura dos estabelecimentos e UI detalhada da Árvore ([estrutura](docs/05_hub/HUB_STRUCTURE_SEEDS.md) · [direção visual](docs/05_hub/HUB_VISUAL_DIRECTION.md));
- [ ] expandir a Árvore dos Ecos além dos 30 nós (alvo ~84; [fonte](docs/03_systems/GLOBAL_RESONANCE_TREE.md)).

### NEXT-5 · CRAFT-AFFIXES-1 — Crafting profundo e affixes

Depende de SLICE-1, `LOOT-EXPANSION-1` e das fontes/sinks do `ECON-1`. Proposta: [TASKBAR_Artesaos_Crafting_Affixes_v2.docx](documents/TASKBAR_Artesaos_Crafting_Affixes_v2.docx) (não muda automaticamente [CRAFT-1](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md), `ITEM-1` nem a v0.5).

- [ ] reconciliar domínios e nomes dos artesãos com CRAFT-1/ITEM-1 e o Hub;
- [ ] aprovar por etapas anatomia de item, famílias/tags, incompatibilidades, budgets e fontes antes de schemas;
- [ ] decompor `CRAFT-01` a `CRAFT-19` em fatias pequenas, começando por schema, compatibilidade e um fluxo demonstrável;
- [ ] validar reforja, refinamento, aspectos, runas, transmutação, relíquias, salvage e proteção contra azar;
- [ ] integrar affixes às identidades dos heróis sem apagar fraquezas centrais.

**Gate PASS:** artesãos sem sobreposição; cada operação com fonte/sink e limites aprovados; nenhum item perdido permanentemente; crafting profundo opcional; integração com builds validada.

---

## 5. Futuro — sem data

### ARGOS — playtester automático

Estrutura e comandos: [tools/argos/README.md](tools/argos/README.md). Ordem decidida por Rafael (2026-09-29): simulador + Analyst antes do Maestro.

| Versão | Escopo | Estado |
| --- | --- | --- |
| v0.1 — Foundation | GdUnit4, Maestro MCP, jornadas Android | PENDENTE |
| v0.2 — Visual | Screenshots e regressão visual | PENDENTE |
| v0.3 — Scale | Simulador headless + Analyst | `IMPLEMENTING` — combate/campanha, loot da run e oito perfis de jogador em uso; economia completa pendente |
| v0.4 — Learning | Godot RL Agents | EXPERIMENTAL |
| v1.0 — Autonomous QA | build → test → report → fix → retest em CI | PENDENTE |

### Outras trilhas

- **Relações entre heróis e regiões futuras:** apenas sementes ([FUTURE_SEEDS](docs/01_world/FUTURE_SEEDS.md)).
- **Capítulos 2+:** não iniciar antes de validar o loop do Capítulo 1.
- **Overlay Android:** fora do MVP até priorização explícita (Build Template + Gradle, plugin Kotlin, `TYPE_APPLICATION_OVERLAY`, touch passthrough, bateria).

---

## 6. Pendências de setup

- [ ] **ADB / S25 Ultra:** conexão física adiada em 2026-09-27; usa-se o emulador Pixel 9.
- [ ] **Aseprite 1.3.10+:** 1.3.7 operacional; alvo ainda não atingido.

---

## 7. Princípios de escopo

- Sem backend, contas, multiplayer, cloud save, monetização ou vantagem paga.
- Números de balanceamento são **HIPÓTESE** até simulação e playtest; simulação do Argos não é playtest.
- Cada fase fecha com evidência (teste, relatório, QA), não com documento.
- Antes de adicionar um sistema: ele melhora o core loop, cria decisão, reforça progressão ou lore, ou interage com sistemas existentes? Se não, não priorizar. Pilares: [GAME_PILLARS](docs/00_project/GAME_PILLARS.md) · [CORE_LOOP](docs/00_project/CORE_LOOP.md).

---

## 8. Referências

- [AGENTS.md](AGENTS.md) · [PROJECT_STATE.md](PROJECT_STATE.md) · [CHANGELOG.md](CHANGELOG.md) · [estrutura do repositório](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md)
- [Índice de docs](docs/INDEX.md) · [documentos base](documents/INDEX.md) · [balanceamento v1.0](docs/06_balance/v1/README.md) · [registro de conteúdo](docs/CONTENT_REGISTRY.md)
- [Resumo do projeto](docs/00_project/POCKET_HERO_PROJECT_BRIEF.md) · [histórico concluído](arquivados/ROADMAP_CONCLUIDO.md) · [arquivados](arquivados/INDEX.md)
