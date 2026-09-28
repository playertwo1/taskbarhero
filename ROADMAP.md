# ROADMAP — Pocket Hero

**Status atualizado em 2026-09-28**  
**Engine:** Godot 4.7.2 Standard  
**Plataforma inicial:** Android

## 1. Estado atual

O MVP do Pocket Hero foi concluído e homologado no gate **R19 em 2026-09-27**. O histórico das fases concluídas, incluindo evidências e checklists, permanece em [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

O projeto entrou na fase de **expansão de conteúdo, identidade e meta-progressão**, sem reabrir a homologação do MVP.

A trilha detalhada de design fica em:

[`ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md`](ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md)

---

## 2. ART-0 — Golden References visuais

Os quatro Golden foram aprovados por Rafael em 2026-09-27. **ART-0 está PASS para produção.**

- [x] **GOLDEN HERO VISUAL** — Bastião v002 aprovado; hash fixado; folha completa/QA pendente.
- [x] **GOLDEN ENEMY** — Geleia 64×64 aprovada; hash fixado; folha completa/QA pendente.
- [x] **GOLDEN BOSS** — Guardião-Cervo v002 aprovado; hash fixado; folha completa/QA pendente.
- [x] **GOLDEN ANIMATION** — idle da Geleia, 4 quadros a 160 ms, aprovado; release/QA pendente.

As nove folhas animadas e quatro camadas de ambiente já foram substituídas nos caminhos usados pelo projeto e o lint técnico passou. QA visual independente e revisão mobile continuam como aceite de release pendente.

**Importante:** o Golden visual do Bastião e o Golden de **design de herói** são contratos diferentes. Um controla direção artística; o outro controla anatomia, skills, passivas, Traits, Mastery e lore.

---

## 3. DESIGN-EXPANSION — Nova base canônica

A expansão deixa de trabalhar com o rascunho antigo de **5 skills por herói**.

O padrão futuro passa a ser:

- **8 heróis jogáveis**;
- party de **3 heróis ativos**;
- **1 ataque básico por herói**;
- **6 skills por herói no total**, sendo 5 normais e 1 Signature;
- **16 passivas por herói**;
- **3 Traits por herói**;
- **3 caminhos principais de build**;
- **2 slots de skill em combate**;
- level **1–100**;
- **Mastery 1–10**;
- **6 slots de equipamento: 5 convencionais + 1 Echo**;
- **5 missões pessoais por herói**;
- **4 estágios visuais**.

Totais de design para o roster completo:

- 8 ataques básicos;
- 48 skills ativas;
- 128 passivas;
- 24 Traits.

Os números de balanceamento continuam como hipóteses até playtest/simulação.

---

## 4. HERO-001 — Bastião Golden Reference de design

Bastião passa a ser a referência estrutural para os sete heróis seguintes.

### Concluído em design

- [x] identidade Tank / Protector;
- [x] Guarda, Perfect Block e Desequilíbrio;
- [x] ataque básico;
- [x] 6 skills no total, incluindo a Signature;
- [x] 16 passivas;
- [x] 3 branches e 3 Capstones;
- [x] 3 Traits;
- [x] builds Guardião / Retaliação / Controle;
- [x] Mastery 1–10;
- [x] progressão visual;
- [x] equipamentos/Echos iniciais;
- [x] lore central;
- [x] campanha pessoal com 5 missões.

### Ainda pendente

- [ ] números finais;
- [ ] diálogos completos;
- [ ] encounters das missões;
- [ ] efeitos/sprites finais;
- [ ] implementação;
- [ ] balanceamento e QA.

**Status do ciclo:** `DESIGN` — consulte esta seção e a ficha Golden para o escopo documentado e suas pendências.

---

## 5. META-1 — Árvore dos Ecos

A referência de Rune Tree global é adaptada ao universo como **Árvore dos Ecos / Árvore Global de Ressonância** no Refúgio da Vigília.

### Estrutura

Sete ramos:

1. Vigília;
2. Formação;
3. Fortuna;
4. Oficina;
5. Alquimia;
6. Jornada;
7. Memória.

### Escopo

- [x] conceito geral definido;
- [x] integração com Hub/lore definida;
- [x] selecionar 30 nós e registrar pré-requisitos;
- [x] definir faixas relativas de custo;
- [x] criar diagrama de dependências e princípio de expansão da UI;
- [ ] desenhar/prototipar a UI detalhada em `HUB-1`/`SLICE-1`;
- [ ] expandir apenas depois do slice validado.

Alvo posterior: aproximadamente **84 nós**, sem obrigar essa quantidade no primeiro vertical slice.

---

## 6. EQUIP-1 — Equipamentos e artesãos da cidade

O sistema não utilizará um Cube abstrato como centro do crafting.

As funções são distribuídas pelo Refúgio da Vigília:

- **Ferreiro** — Arma, Secundário e Armadura; desmontagem e melhoria conforme os gates aprovados;
- **Alquimista** — materiais, catalisadores, transmutação e consumíveis;
- **Gravadora de Ecos** — slot e catálogo independente de Echo;
- **Ourives** — Acessório I e II, com especialização de build.

A ordem, o mínimo de serviço por artesão e o que fica fora do slice estão aprovados em [CRAFT-1](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md). Reforja, fabricação livre, sockets e outros serviços listados acima são possibilidades futuras, não requisitos do primeiro slice.

### Equipamento

- [x] seis slots canônicos definidos em design (cinco convencionais + Echo), com escopo do primeiro catálogo registrado;
- [x] raridades canônicas de design seguem v0.4; subset do slice e migração das quatro raridades runtime legadas seguem os gates de `SLICE-1`;
- [x] contrato de design de item e fronteira sem migração runtime documentados;
- [x] catálogo canônico v0.4 de 30 itens definido; os 15 registros runtime anteriores estão mapeados como legados;
- [x] Item Power separado conceitualmente de raridade; números e fórmula seguem para `ECON-1`;
- [x] affixes aleatórios e reforja adiados para depois do slice;
- [ ] selecionar subset para o vertical slice;
- [ ] implementar primeiro serviço do Ferreiro.

Os serviços da cidade devem aparecer gradualmente conforme o Hub é reconstruído.

---

## 7. LORE-1 — Fundação narrativa

**Concluído:** a [Bíblia de Lore](docs/01_world/LORE_BIBLE.md) consolida as regras globais e mantém as causas e mistérios principais em aberto. A lore individual do Bastião está na seção [decisões atuais](docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md#lore-pessoal-do-bastiao-decisoes-atuais); diálogos e implementação permanecem trabalho futuro.

---

## 8. CONTENT-1 — Capítulo 1: Bosque de Lúmen

O Capítulo 1 continua sendo o **Bosque de Lúmen**, com dez subfases. Bestiário, itens, materiais e loot seguem a base canônica v0.4. Uma proposta de quinze encontros mistos, quantidades, custos locais e padrões do boss final está em [ENCOUNTERS.md](docs/04_content/chapters/chapter_01/ENCOUNTERS.md), com formações em [encounter_plan.json](docs/04_content/chapters/chapter_01/encounter_plan.json). É design para validação, não dado runtime.

O overview atual do capítulo lista 15 conceitos de skills normais — cinco para cada herói inicial — e não inclui as Signature Skills. É um catálogo parcial, não uma alternativa à meta canônica de seis skills por herói.

### Próximas correções

- [ ] atualizar o Capítulo 1 para o novo padrão de heróis;
- [ ] decidir qual subset de skills/passivas/Traits aparece no slice;
- [x] reconciliar o catálogo de 30 itens com o sistema canônico de slots; a seleção do slice segue para `SLICE-1`;
- [x] detalhar encontros e padrões propostos de chefes; validar taxa de vitória inicial e combate implementado em `SLICE-1`;
- [ ] introduzir no conteúdo um Echo funcional opcional, com recompensa determinística e função registrada no [Sistema de Ecos](docs/03_systems/ECHO_SYSTEM.md);
- [ ] definir como o Fragmento do Coração Verde altera visualmente o Hub.

---

## 9. SLICE-1 — Próximo vertical slice

Fluxo-alvo:

`Hub → party → build → expedição → combate → escolha → evento → elite → mini-boss → boss → retorno → Árvore/Ferreiro → evolução do Hub`

### Conteúdo mínimo

- [ ] 3 heróis funcionais;
- [ ] Bastião como referência estrutural;
- [ ] pelo menos duas builds claramente distintas;
- [ ] subset de equipamentos;
- [ ] 1 Echo funcional opcional para completar o slice, sem ser necessário para vencer;
- [ ] 1 elite;
- [ ] 1 evento;
- [ ] 1 mini-boss;
- [ ] Guardião-Cervo;
- [ ] pequeno ramo funcional da Árvore dos Ecos;
- [ ] Ferreiro com desmontagem + 1 melhoria;
- [ ] retorno ao Hub com progressão perceptível;
- [ ] mudança visual do Refúgio após o boss.

**DECISÃO de DESIGN-1:** incluir um Echo funcional opcional, como recompensa determinística que conecta loot, build e lore. Não será obrigatório para vencer; escopo restrito e exemplo aprovado estão no [Sistema de Ecos](docs/03_systems/ECHO_SYSTEM.md).

---

## 10. Próxima ordem de execução

1. [x] **SYNC-0** — colocar no repositório os novos contratos de design e atualizar índices;
2. [x] **DESIGN-1** — fechar a fundação e a separação entre **run / herói / equipamento / conta**;
3. [x] **LORE-1** — criar a Bíblia de Lore, reconciliada com o Capítulo 1 e a lore canônica do Bastião;
4. [x] registrar Bastião como Golden Reference de design;
5. [x] **TREE-1** — definir os ~30 nós do MVP da Árvore dos Ecos;
6. [x] **CRAFT-1** — definir função, fonte/sink e ordem de desbloqueio dos quatro artesãos;
7. [x] **ITEM-1** — reconciliar slots, raridades, contrato de item e catálogo de 30;
8. **ECON-1 — em andamento:** [modelo econômico](docs/06_balance/ECONOMY_MODEL.md), [15 encontros mistos/32 derrotas e proposta do Guardião](docs/04_content/chapters/chapter_01/ENCOUNTERS.md), [plano estruturado](docs/04_content/chapters/chapter_01/encounter_plan.json) e [simulação reproduzível](tools/economy/simulate_chapter1_balance.py). A simulação verifica cobertura do bestiário, encounter budgets, rendimento de materiais/Ouro e TTK teórico. Falta validar combate, taxa de vitória na primeira tentativa e pacing em `SLICE-1`, além do teto/conversão offline, antes do gate `PASS`;
9. validar e consolidar no Bosque de Lúmen os marcos econômicos após o gate `ECON-1`;
10. iniciar **Flecha** como segundo herói completo seguindo o padrão do Bastião;
11. executar **[BALANCE-FOUNDATION-1](ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md#20-balance-foundation-1--contrato-canonico-de-balanceamento)** para consolidar o contrato comum de atributos e registros de heróis, inimigos, equipamentos e efeitos;
12. preparar `SLICE-1` com as regras e métricas aprovadas;
13. depois do primeiro slice, usar ARGOS e telemetria em **BALANCE-1** para ajuste iterativo.

Não iniciar produção massiva dos 7 heróis restantes ou da árvore completa antes de os contratos acima passarem pelo slice.

---

## 11. Pendências registradas de setup

Estas pendências permanecem anotadas no marco SETUP-01 e não reabrem a homologação do MVP:

- [ ] **ADB / S25 Ultra** — conexão física adiada em 2026-09-27; emulador Android Studio usado em R17–R19.
- [ ] **Aseprite 1.3.10+** — Aseprite 1.3.7 operacional; alvo do setup ainda não atingido.

---

## 12. Trabalho futuro

### ARGOS — Autonomous Playtester

Os hooks da v0.0 foram concluídos e permanecem planejadas:

| Versão | Escopo | Entrega / gate | Estado |
| --- | --- | --- | --- |
| **v0.1 — Foundation** | GdUnit4, Maestro MCP e perfis Beginner/Chaos. | APK testado por jornadas Android; pelo menos 10 regressões críticas. | PENDENTE |
| **v0.2 — Visual** | Fallback CLI Android, screenshots e regressão visual. | Detectar botões inacessíveis e HUD quebrado. | PENDENTE |
| **v0.3 — Scale** | Simulador headless (10k–100k execuções) e Argos Analyst. | Relatórios de inflação, drops, TTK e economia da Árvore/artesãos. | PENDENTE |
| **v0.4 — Learning** | Godot RL Agents. | Experimento de estratégias emergentes/exploits. | EXPERIMENTAL |
| **v1.0 — Autonomous QA** | Pipeline build → test → report → fix → retest. | Ciclo validado em CI. | PENDENTE |

### Base canônica de combate e loot v0.4

Rafael aprovou [TASKBAR Sistema Completo v0.4](documents/canonical/taskbar_sistema_v0.4/README.md) como fonte canônica de design para combate, balanceamento, inimigos, equipamentos, materiais, raridades, loot e economia. `BALANCE-FOUNDATION-1` e [LOOT-EXPANSION-1](ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md#23-loot-expansion-1--economia-e-loot-completos) cuidam da adaptação ao runtime e validação; os dados atuais do MVP permanecem como implementação observada até a migração.

### Overlay Android

Continua pós-MVP e fora da arquitetura central até priorização explícita.

Escopo previsto:

- Android Build Template + Gradle;
- plugin Kotlin e lifecycle/service;
- permissão `TYPE_APPLICATION_OVERLAY`;
- interação/touch passthrough;
- consumo de bateria e restrições de background.

---

## 13. Limites de escopo

- preservar o MVP homologado;
- preservar Golden References aprovados;
- não adicionar backend, contas, multiplayer, cloud save ou monetização sem necessidade concreta;
- não congelar números de economia/balanceamento antes de simulação e playtest;
- sistemas novos precisam conversar com gameplay, progressão ou lore;
- evitar quantidade sem função;
- mudanças canônicas novas orientam **design futuro** e não alteram silenciosamente código homologado.

---

## 14. Referências

- [`ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md`](ROADMAP_EXPANSAO_CONTEUDO_POCKET_HERO.md)
- [Documentos do projeto](documents/INDEX.md)
- [Resumo consolidado](docs/POCKET_HERO_PROJECT_BRIEF.md)
- [Golden References e ART-0](docs/art/golden/README.md)
- [Inventário de sprites do MVP](docs/art/MVP_SPRITE_INVENTORY.md)
- [Histórico das fases concluídas](arquivados/ROADMAP_CONCLUIDO.md)
