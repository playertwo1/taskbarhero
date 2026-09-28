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
- **6 skills por herói**, sendo 1 Signature;
- **16 passivas por herói**;
- **3 Traits por herói**;
- **3 caminhos principais de build**;
- **2 slots de skill em combate**;
- level **1–100**;
- **Mastery 1–10**;
- **10 slots de equipamento**;
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
- [x] 6 skills;
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

**Estado:** `HERO_DESIGN_CONTENT_COMPLETE`.

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
- [ ] selecionar ~30 nós para o MVP;
- [ ] definir pré-requisitos;
- [ ] definir custos relativos;
- [ ] definir diagrama/UI;
- [ ] expandir apenas depois do slice validado.

Alvo posterior: aproximadamente **84 nós**, sem obrigar essa quantidade no primeiro vertical slice.

---

## 6. EQUIP-1 — Equipamentos e artesãos da cidade

O sistema não utilizará um Cube abstrato como centro do crafting.

As funções são distribuídas pelo Refúgio da Vigília:

- **Ferreiro** — desmontagem, melhoria, reforja e fabricação;
- **Alquimista** — transmutação, Essências e Catalisadores;
- **Gravadora de Ecos** — Echoes, memórias e modificadores raros;
- **Ourives** — joias, acessórios e especialização fina.

### Equipamento

- [x] 10 slots canônicos definidos em design;
- [x] conceito de Item Power, affixes e progressão documentado;
- [ ] reconciliar raridades finais;
- [ ] fechar schema de item;
- [ ] atualizar catálogo inicial de 30 itens;
- [ ] selecionar subset para o vertical slice;
- [ ] implementar primeiro serviço do Ferreiro.

Os serviços da cidade devem aparecer gradualmente conforme o Hub é reconstruído.

---

## 7. LORE-1 — Fundação narrativa

Conceitos mantidos:

- Lúmen;
- Apagamento;
- Corações de Lúmen;
- Guardiões;
- Ecos;
- Observador como mistério não resolvido.

### Bastião

A lore pessoal do Bastião agora funciona como Golden Reference narrativo e conecta diretamente gameplay, equipamentos e campanha pessoal.

- [x] Primeiro Juramento;
- [x] Guarda da Primeira Muralha;
- [x] Porta da Vigília;
- [x] origem de Muralha do Primeiro Juramento e Vigília;
- [x] 5 missões pessoais;
- [x] arco “Eu fico”;
- [ ] diálogos finais e implementação.

- [ ] criar `LORE_BIBLE.md` consolidando as regras globais sem resolver cedo os mistérios principais.

---

## 8. CONTENT-1 — Capítulo 1: Bosque de Lúmen

O Capítulo 1 continua sendo o **Bosque de Lúmen**, preservando a direção já aprovada de dez subfases, ecologia própria, elites, mini-bosses e Guardião-Cervo.

O documento antigo do capítulo possui conteúdo útil, mas qualquer referência a **15 skills / 5 skills por herói** deve ser considerada desatualizada para design futuro.

### Próximas correções

- [ ] atualizar o Capítulo 1 para o novo padrão de heróis;
- [ ] decidir qual subset de skills/passivas/Traits aparece no slice;
- [ ] reconciliar os 30 itens com o novo sistema de 10 slots;
- [ ] detalhar encontros de chefes;
- [ ] integrar Echoes e eventos ao novo loop;
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
- [ ] 1 Echo funcional;
- [ ] 1 elite;
- [ ] 1 evento;
- [ ] 1 mini-boss;
- [ ] Guardião-Cervo;
- [ ] pequeno ramo funcional da Árvore dos Ecos;
- [ ] Ferreiro com desmontagem + 1 melhoria;
- [ ] retorno ao Hub com progressão perceptível;
- [ ] mudança visual do Refúgio após o boss.

---

## 10. Próxima ordem de execução

1. **SYNC-0** — colocar no repositório os novos contratos de design e atualizar índices;
2. fechar separação entre **run / herói / equipamento / conta**;
3. criar `LORE_BIBLE.md`;
4. registrar Bastião como Golden Reference de design;
5. definir os ~30 nós do MVP da Árvore dos Ecos;
6. fechar MVP do Ferreiro/Alquimista/Ecos/Ourives;
7. reconciliar economia e 30 itens;
8. atualizar o documento do Bosque de Lúmen;
9. iniciar **Flecha** como segundo herói completo seguindo o padrão do Bastião;
10. preparar `SLICE-1`;
11. depois usar ARGOS para balanceamento e regressão.

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
