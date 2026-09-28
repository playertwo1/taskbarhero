# ROADMAP — Expansão de Conteúdo e Identidade do Pocket Hero

**Status:** planejamento ativo — revisado em 2026-09-28  
**Base:** complementar ao `ROADMAP.md` principal  
**Objetivo:** transformar o Pocket Hero de um MVP funcional em um jogo com identidade, progressão, builds, lore, Hub e conteúdo suficiente para sustentar o Capítulo 1 sem inflar prematuramente o escopo.  
**Mudança desta revisão:** incorporar o padrão canônico dos 8 heróis, o Bastião como Golden Reference de design, a Árvore dos Ecos, equipamentos de 6 slots e os artesãos da cidade.

---

## 0. Princípios desta trilha

Esta roadmap **não substitui** o `ROADMAP.md` principal.

Ela complementa o projeto com a trilha de design e conteúdo.

Regras:

- preservar o MVP já homologado;
- preservar os Golden References aprovados;
- manter o Bosque de Lúmen como Capítulo 1;
- evoluir por pequenos gates;
- não iniciar capítulos futuros antes de validar o loop principal;
- não adicionar backend, multiplayer, contas, cloud save ou monetização nesta etapa;
- números de balanceamento permanecem hipóteses até playtest/simulação;
- conteúdo novo deve reforçar gameplay, progressão ou lore;
- evitar sistemas que existam apenas para aumentar quantidade.

---

# 1. NORTH STAR — Identidade do jogo

## Fantasia central

> Três pequenos heróis entram em regiões que estão lentamente perdendo sua luz, constroem uma build durante a expedição, derrotam criaturas corrompidas, recuperam fragmentos do mundo e retornam a um refúgio que cresce junto com eles.

## Loop macro

### Expedição

`combate → recompensa → escolha → combate → evento → elite → recompensa → chefe → retorno`

Durante a expedição o jogador deve tomar decisões de build:

- adquirir uma nova skill;
- melhorar uma skill;
- escolher ou trocar item;
- adquirir um Eco;
- aceitar eventos de risco/recompensa;
- adaptar a party ao encontro.

### Meta-progressão

`retorno ao Hub → Árvore dos Ecos → artesãos/equipamentos → lore/Ecos → preparar party → nova expedição`

A meta-progressão deve ser percebida fisicamente no **Refúgio da Vigília**. Novos serviços e melhorias aparecem como partes da cidade, evitando transformar o Hub em uma coleção abstrata de menus.

---

# 2. DESIGN-1 — Fundação do jogo

**Objetivo:** congelar a identidade fundamental antes de produzir grandes volumes de conteúdo.

## Entregas

- [x] Criar rascunho `GAME_PILLARS.md` (ainda em `DESIGN`)
- [x] Criar rascunho `CORE_LOOP.md` (ainda em `DESIGN`)
- [x] Criar rascunho `GLOSSARY.md` (nome/caminho canônico registrado no índice de Projeto)
- [x] Definir composição da party: **3 heróis ativos entre 8 disponíveis**
- [x] Definir padrão canônico de herói: ataque básico + 6 skills + 16 passivas + 3 Traits + Mastery 1–10
- [x] Definir Bastião como **Golden Reference de design** para os demais heróis
- [x] Definir conceito e escopo inicial da **Árvore dos Ecos / Árvore Global de Ressonância**: 30 nós em sete ramos, detalhados em `TREE-1`
- [x] Definir conceito de **equipamentos + artesãos da cidade**, substituindo um sistema abstrato tipo Cube
- [x] Importar/converter os contratos canônicos de design para `docs/` e atualizar seus índices (**SYNC-0 concluído**)
- [x] Fechar a fronteira de run versus meta-progressão na matriz autoritativa; parâmetros offline/economia ficam para `ECON-1`
- [x] Registrar regras decididas de oferta/evolução de skills e encaminhar tiers, conjuntos de escolha, gatilhos e efeitos ainda abertos ao [Sistema de skills](docs/03_systems/SKILL_SYSTEM.md)
- [x] Definir regra-base de obtenção, comparação, equipagem e salvamento/desmontagem; o contrato de design foi fechado em `ITEM-1`, e schema runtime/reforja dependem de fases próprias
- [x] Definir função e escopo mínimo de Echo no slice; conteúdo e implementação ficam para `ECHO-1`
- [x] Definir vitória, derrota e retirada voluntária como saídas da expedição
- [x] Definir que a expedição é delimitada pelo objetivo, sem cronômetro de derrota; medir duração-alvo em playtest/pacing

## Contratos já introduzidos

### Herói canônico

Cada herói completo possui:

- 1 ataque básico;
- 6 skills ativas, sendo 1 Signature;
- 16 passivas;
- 3 Traits, com apenas 1 ativo por vez;
- 3 caminhos principais de build;
- 8 tiers de progressão;
- 2 slots de skill em combate;
- level 1–100;
- Mastery 1–10;
- 6 slots de equipamento (5 convencionais + 1 Echo);
- 5 missões pessoais;
- 4 estágios visuais;
- 1 mecânica exclusiva e 1 fraqueza clara.

### Separação obrigatória

- **Run:** decisões temporárias de build, loot, eventos e composição.
- **Herói:** progressão individual permanente e domínio do personagem.
- **Conta/Hub:** Árvore dos Ecos, serviços da cidade e desbloqueios globais.
- **Equipamento:** loot, affixes, crafting, reforja, Ecos e especialização.

## Gate DESIGN-1 PASS

**Estado:** `PASS` em 2026-09-28 para a fundação e separação de sistemas pós-MVP. `CRAFT-1` e `ITEM-1` passaram em design; `ECON-1` ainda define números e valida a economia antes de implementar esses sistemas. Este gate não aprova runtime nem balanceamento.

PASS quando:

- a fantasia central estiver documentada;
- o core loop estiver documentado;
- run, progressão de herói, equipamentos e meta-progressão global estiverem claramente separados;
- os 8 heróis possuírem identidade mecânica distinta;
- a Árvore dos Ecos tiver MVP definido;
- os serviços mínimos dos artesãos tiverem MVP definido;
- não existirem sistemas essenciais sem dono/documento.

---

# 3. LORE-1 — Fundação narrativa

## Entregas

- [x] Criar [`LORE_BIBLE.md`](docs/01_world/LORE_BIBLE.md) como fonte central da cosmologia e das regras do mundo.
- [x] Reconciliar a bíblia com o Capítulo 1 e o Golden Reference do Bastião, sem resolver os mistérios centrais.

Conceitos, grau de certeza e limites de continuidade ficam na [Bíblia de Lore](docs/01_world/LORE_BIBLE.md), fonte autoritativa para essa área.

## Mistérios centrais

Permanecem sem resposta definitiva conforme a [Bíblia de Lore](docs/01_world/LORE_BIBLE.md):

- [ ] O Apagamento é natural?
- [ ] Para onde o Lúmen desaparece?
- [ ] As memórias estão sendo destruídas ou armazenadas?
- [ ] Quem construiu as máquinas antigas de extração de Lúmen?
- [ ] Quem sabia do Apagamento antes dele começar?
- [ ] Quem ou o que é o Observador?

## Golden Reference narrativo — Bastião

A lore pessoal e as cinco missões aprovadas estão na [Golden Reference do Bastião](docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md#lore-pessoal-do-bastiao-decisoes-atuais). Diálogos, encontros finais e implementação continuam pendentes.

## Gate LORE-1 PASS

- [x] regras básicas do universo definidas na Bíblia de Lore;
- [x] nenhum mistério principal respondido cedo demais;
- [x] lore do Bosque de Lúmen consistente com as regras globais, mantendo sua história e desfecho em aberto;
- [x] narrativa compatível com o escopo de gameplay e sem confirmar implementação inexistente.

**Status do gate:** `PASS` em 2026-09-28 para a fundação narrativa. Conteúdo narrativo detalhado do capítulo, diálogos e implementação seguem fases próprias.

---

# 4. HERO-1 — Roster de oito heróis

A party ativa possui **3 heróis entre 8 disponíveis**.

Os oito heróis devem seguir o mesmo contrato estrutural, mantendo identidade mecânica própria.

| ID | Herói | Papel | Mecânica principal | Builds |
|---|---|---|---|---|
| HERO_001 | Bastião | Tank | Guarda / Perfect Block / proteção | Guardião / Retaliação / Controle |
| HERO_002 | Flecha | Ranged DPS | Marca / crítico | Crítico / Marca / Velocidade |
| HERO_003 | Íris | Mage / Control | Lúmen / controle | Arcano / Controle / Lúmen |
| HERO_004 | Brasa | Bruiser | Fúria / HP baixo | Fúria / Queimadura / Sobrevivência |
| HERO_005 | Véu | Assassin | Exposição / execução | Execução / Veneno / Sombra |
| HERO_006 | Orvalho | Healer / Support | Sementes | Cura / Jardim / Simbiose |
| HERO_007 | Forja | Summoner / Engineer | Engenhocas | Torres / Armadilhas / Autômatos |
| HERO_008 | Sino | Buffer / Tempo | Ritmo / memória | Ritmo / Ressonância / Memória |

## Checkpoint HERO-1A — Identidade

Para cada herói:

- [ ] fantasia;
- [ ] papel;
- [ ] mecânica central;
- [ ] recurso ou regra exclusiva, quando aplicável;
- [ ] motivo para participar da jornada;
- [ ] relação inicial com o Apagamento;
- [ ] 3 caminhos de build;
- [ ] fraqueza clara;
- [ ] sinergias naturais com outros heróis.

### Bastião

- [x] identidade;
- [x] papel;
- [x] Guarda / Perfect Block / Desequilíbrio;
- [x] Guardião / Retaliação / Controle;
- [x] fraquezas;
- [x] sinergias preliminares;
- [x] lore pessoal e 5 missões.

## Checkpoint HERO-1B — Ataque básico + 6 Skills

Cada herói possui **1 ataque básico + 6 skills ativas**, sendo a sexta sua **Signature Skill**.

Total do roster:

- **8 ataques básicos**;
- **48 skills ativas**.

### Bastião — DESIGN COMPLETE

- [x] Muralha Viva
- [x] Contra-Golpe
- [x] Desafio
- [x] Fortaleza
- [x] Impacto de Escudo
- [x] Último Bastião — Signature

### Flecha

- [ ] Marca do Caçador
- [ ] Flecha Perfurante
- [ ] Olho Aguçado
- [ ] Rajada
- [ ] Ricochete
- [ ] Chuva de Flechas — Signature

### Íris

- [ ] Pulso Prismático
- [ ] Prisão de Lúmen
- [ ] Refração
- [ ] Véu Astral
- [ ] Eco Prismático
- [ ] Colapso Prismático — Signature

### Brasa

- [ ] Sangue Quente
- [ ] Golpe Incandescente
- [ ] Fúria Crescente
- [ ] Devorar Chamas
- [ ] Investida de Cinzas
- [ ] Última Centelha — Signature

### Véu

- [ ] Passo Entre Mundos
- [ ] Corte Silencioso
- [ ] Veneno Negro
- [ ] Marca da Morte
- [ ] Fenda Sombria
- [ ] Fim Inevitável — Signature

### Orvalho

- [ ] Semente Vital
- [ ] Espinhos Vivos
- [ ] Raízes Protetoras
- [ ] Simbiose
- [ ] Florescer
- [ ] Última Primavera — Signature

### Forja

- [ ] Sentinela
- [ ] Mina de Lúmen
- [ ] Farol
- [ ] Drone Catador
- [ ] Sobrecarga
- [ ] Projeto Impossível — Signature

### Sino

- [ ] Primeira Nota
- [ ] Ressonância
- [ ] Compasso
- [ ] Memória Persistente
- [ ] Crescendo
- [ ] Encore — Signature

## Checkpoint HERO-1C — Passivas e Traits

Por herói:

- **16 passivas**;
- **3 branches de 5 nós**;
- **1 passiva de identidade**;
- **3 Capstones**;
- **3 Traits**, um por identidade de build;
- apenas **1 Trait ativo por vez**.

Total do roster:

- **128 passivas**;
- **24 Traits**.

### Bastião

- [x] 16 passivas completas;
- [x] Guardião completo;
- [x] Retaliação completa;
- [x] Controle completo;
- [x] 3 Capstones;
- [x] Voto do Escudo;
- [x] Ferro Responde;
- [x] Não Passarão.

## Checkpoint HERO-1D — Progressão individual

Por herói:

- level máximo 100;
- 8 tiers estruturais;
- 2 slots de skill em combate;
- Mastery 1–10;
- 4 estágios visuais;
- 5 missões pessoais;
- pelo menos 3 equipamentos/Ecos exclusivos de referência.

### Bastião

- [x] Mastery 1–10;
- [x] modificador M3;
- [x] Forma Ressonante M5;
- [x] Doutrina M7;
- [x] conceito de Echo alternativo M8 para o slot Echo único (sem slot adicional; fora do slice);
- [x] evolução de Inabalável M9;
- [x] Forma Lendária + Signature Modifier M10;
- [x] campanha pessoal de 5 missões;
- [ ] números finais;
- [ ] diálogos completos;
- [ ] encounters implementados;
- [ ] sprites/efeitos finais.

**Estado do ciclo de design do Bastião:** `DESIGN` — referência de profundidade para os demais heróis; números, diálogos, encontros, arte final e implementação continuam pendentes nos gates correspondentes.

## Gate HERO-1 PASS

- 8 heróis documentados no padrão canônico;
- 48 skills documentadas em nível de design;
- 128 passivas documentadas;
- 24 Traits documentados;
- Mastery 1–10 definida para os 8;
- 5 missões pessoais por herói em nível de design;
- nenhum herói substitui completamente outro;
- pelo menos 2 sinergias naturais identificadas por herói;
- nenhum número final congelado antes de teste.

---

# 5. BUILD-1 — Sistema de builds

**Objetivo:** fazer herói, skills, passivas, Traits, equipamentos, Ecos e party interagirem sem criar uma única build correta.

## Fórmula conceitual

`herói + 2 skills equipadas + passivas + Trait + equipamento + Echo + Mastery + composição`

Durante a expedição, escolhas temporárias podem modificar essa base, mas não devem apagar a identidade permanente do herói.

## Regras

Uma build interessante deve alterar comportamento, prioridades ou rota de combate.

Evitar depender apenas de:

`+X ataque / +X defesa`

Cada caminho de build precisa possuir:

- situação ideal;
- fraqueza;
- pelo menos uma interação com skill;
- pelo menos uma interação com equipamento ou Echo;
- possibilidade de híbrido;
- nenhum item obrigatório universal.

## Slots de skill

Cada herói conhece 6 skills, mas leva **até 2 skills ativas para o combate**.

O segundo slot é um **desbloqueio global da conta/Hub**, não um desbloqueio isolado de cada herói.

## Gate BUILD-1 PASS

- pelo menos 3 builds claramente diferentes por herói;
- builds híbridas possíveis;
- Trait altera regra de gameplay, não apenas porcentagem;
- equipamentos e Ecos reforçam escolhas sem torná-las obrigatórias;
- run e meta-progressão não entram em conflito.

---

# 5A. TREE-1 — Árvore dos Ecos / Progressão Global

A antiga referência de “Rune Tree” é adaptada ao universo como uma estrutura física e narrativa do Hub:

# ÁRVORE DOS ECOS

Também pode ser referida nos documentos técnicos como **Árvore Global de Ressonância**.

## Função

Progressão permanente da conta, compartilhada por todos os heróis.

Ela deve desbloquear tanto bônus quanto **sistemas inteiros**.

## Recurso

**Fragmentos de Ressonância** são o recurso dedicado à árvore.

Eles não substituem Lúmen nem materiais de crafting.

## Sete ramos

1. **Vigília** — sobrevivência, recuperação e segurança;
2. **Formação** — party, slots e sinergia entre heróis;
3. **Fortuna** — loot, qualidade e descoberta;
4. **Oficina** — Ferreiro e progressão de equipamento;
5. **Alquimia** — transmutação, essências e catalisadores;
6. **Jornada** — qualidade de vida da expedição e preparação;
7. **Memória** — Ecos, lore, Mastery e sistemas avançados.

## Escopo

- **MVP alvo:** aproximadamente 30 nós;
- **lançamento inicial:** expansão gradual para aproximadamente 84 nós;
- evitar árvore enorme antes de validar economia e pacing.

## Desbloqueios estruturais candidatos

- segundo slot de skill;
- novos espaços/recursos de formação;
- níveis de serviço do Ferreiro;
- níveis de serviço do Alquimista;
- acesso a sistemas de Echo avançado;
- melhorias de loot e identificação;
- qualidade de vida de expedição;
- sistemas de Mastery.

## Gate TREE-1 PASS

- [x] MVP de 30 nós definido;
- [x] faixas relativas de custo e pré-requisitos modelados;
- [x] os sete ramos têm identidade e efeitos distintos, sem progressão de atributos repetida como conteúdo principal;
- [x] vários nós liberam sistemas, serviços ou opções de jogo, além dos bônus de atributo;
- [x] economia simulável antes de custos finais, com Fragmentos de Ressonância e fontes/sinks definidos;
- [x] layout por ramos expansíveis/navegáveis comporta nós futuros sem redesenhar a estrutura-base.

**Status do gate:** `PASS` em 2026-09-28 para catálogo e dependências de design. Não aprova custo final, balanceamento, UI detalhada ou runtime.

---

# 5B. CRAFT-1 — Cidade, equipamentos e substituto do Cube

Pocket Hero não deve usar um “Cube” abstrato como centro do crafting.

As mesmas funções são distribuídas por **personagens e estabelecimentos do Refúgio da Vigília**.

As listas seguintes mostram os papéis gerais de cada artesão. O escopo mínimo, fontes/sinks e ordem de abertura aprovados estão na seção [CRAFT-1 do documento de equipamentos](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md); capacidades mais avançadas não são requisitos do slice.

## Ferreiro

Responsável por:

- desmontagem;
- melhoria de Item Power;
- reforço;
- reforja de affixes;
- fabricação de equipamento;
- serviços ligados a armas e armaduras.

## Alquimista

Responsável por:

- transmutação;
- conversão de materiais;
- Essências;
- Catalisadores;
- receitas ligadas a propriedades especiais.

## Gravadora de Ecos

Responsável por:

- leitura e gravação de Ecos;
- modificadores raros;
- interação entre memória, equipamento e lore;
- serviços avançados desbloqueados gradualmente.

## Ourives

Responsável por:

- anéis, amuletos e acessórios;
- sockets/encaixes, se aprovados no slice;
- especialização fina de equipamento;
- reforja de propriedades de joias.

## Regra do Hub

Nenhum desses serviços precisa estar disponível no começo.

O jogador deve perceber a cidade crescendo:

`retorno → reconstrução → novo artesão/nível → novo serviço → nova decisão de build`

## Gate CRAFT-1 PASS

- [x] serviços mínimos de cada artesão definidos;
- [x] ordem de desbloqueio documentada;
- [x] cada serviço possui fonte e sink econômico identificado; quantidades seguem para `ECON-1`;
- [x] responsabilidades não se duplicam sem motivo;
- [x] crafting melhora escolhas e usa drops/recompensas, sem substituir completamente o loot.

**Status do gate:** `PASS` em 2026-09-28 para arquitetura e escopo de serviço. Receitas, quantidades, custos, UI, balanceamento e runtime ainda dependem dos gates próprios.

---

# 6. ITEM-1 — Equipamentos e catálogo inicial

O contrato aprovado, a relação entre os slots canônicos e o catálogo inicial, as raridades e os limites do primeiro slice ficam na [fonte de equipamento](docs/03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md). O catálogo nominal e visual dos 30 itens fica no [overview do Capítulo 1](docs/04_content/chapters/chapter_01/OVERVIEW.md#equipamentos--catálogo-total-de-30-itens) e no [índice de itens](docs/04_content/items/INDEX.md); este roadmap não replica suas fichas.

**Base aprovada:** seis slots: Arma, Secundário, Armadura, Acessório I, Acessório II e Echo (cinco equipamentos convencionais + um Echo). O catálogo v0.4 inclui 5 Armas, 5 Secundários, 5 Armaduras, 10 Acessórios e 5 Ecos. Os 15 registros runtime anteriores permanecem como legado; veja a [ponte de IDs](docs/04_content/LEGACY_RUNTIME_CATALOG.md).

O cânone de design usa as seis raridades definidas em v0.4. Os quatro tiers carregados pelo runtime são um estado legado, não a escala global do design. O subconjunto de raridades, affixes e Item Power efetivamente usado no slice deve seguir a [fonte canônica](documents/canonical/taskbar_sistema_v0.4/README.md) e ser validado por `ECON-1`/`SLICE-1`.

Equipamentos pessoais do Bastião são referências narrativas/de build na [Golden Reference](docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md); seus nomes não aumentam automaticamente o catálogo dos 30. **A Sentinela que Ficou** permanece no sistema separado de Ecos.

## Gate ITEM-1 — design PASS

- [x] definir os seis slots do herói; integrar os cinco grupos de item do catálogo canônico v0.4;
- [x] aprovar os 30 itens canônicos v0.4; manter os 15 itens antigos somente como registros runtime legados até migração;
- [x] aprovar a escala de seis raridades da base v0.4; documentar as quatro raridades runtime como legado e definir o subset do slice em gate próprio;
- [x] registrar contrato de design sem migração do JSON/runtime;
- [x] definir atributos/efeitos fixos para o slice e adiar affixes aleatórios/reforja;
- [x] definir Item Power como conceito separado de raridade, com fórmula/valores pendentes;
- [x] encaminhar valores, pesos, custos e simulação a `ECON-1`.

**Status do gate:** `PASS` em 2026-09-28 para a arquitetura ITEM-1 então revisada. A aprovação posterior de v0.4 substitui o catálogo/raridades anteriores; migração runtime, UI e balanceamento ainda exigem gates próprios.
# 7. CONTENT-1 — Bosque de Lúmen

O Capítulo 1 permanece composto por **10 subfases**.

## Estrutura narrativa sugerida

1. Trilha Apagada
2. Clareira Luminosa
3. Raízes que Escutam
4. Ninho de Folhas
5. Ponte de Musgo
6. Ruínas de Lúmen
7. Trilha do Javali
8. Jardim de Espinhos
9. Santuário Esquecido
10. Coração do Bosque

## Progressão narrativa

`algo está errado → sinais do Apagamento → descoberta das memórias → ruínas → antigo santuário → Guardião`

---

# 8. ENEMY-1 — Ecologia do Bosque

Meta inicial:

- **10 inimigos base**
- **3 elites**
- **3 mini-bosses**
- **1 boss**

## Inimigos base

- [ ] Geleia de Lúmen
- [ ] Espírito de Raiz
- [ ] Gremlin de Folhas
- [ ] Javali de Musgo
- [ ] Mariposa Luminosa
- [ ] Cogumelo Sonolento
- [ ] Trepa-Cadáver
- [ ] Caracol Cristalino
- [ ] Raposa Oca
- [ ] Sapinho do Lúmen

## Funções desejadas

### Geleia de Lúmen
Inimigo simples/tutorial.

### Espírito de Raiz
Controle / aprisionamento.

### Gremlin de Folhas
Pressão sobre backline.

### Javali de Musgo
Investida / alta vida.

### Mariposa Luminosa
Buff de inimigos.

### Cogumelo Sonolento
Lentidão / zona.

### Trepa-Cadáver
Pode retornar se não for finalizado corretamente.

### Caracol Cristalino
Defesa direcional ou janelas de vulnerabilidade.

### Raposa Oca
Ilusões / duplicatas.

### Sapinho do Lúmen
Mobilidade / interrupção.

---

# 9. ENCOUNTER-1 — Combinações de inimigos

Os encontros devem ser construídos por **sinergia**, não apenas por quantidade.

Exemplos:

- Cogumelo Sonolento + Javali de Musgo
- Mariposa Luminosa + Gremlins
- Espírito de Raiz + Caracol Cristalino
- Raposa Oca + Gremlin
- Sapinho + Mariposa

## Gate ENCOUNTER-1 PASS

- pelo menos 10 composições documentadas;
- cada composição apresenta uma decisão ou ameaça clara;
- evitar encontros resolvidos somente por aumento de HP.

---

# 10. ELITE-1 — Variantes

## Elites iniciais

- [ ] Geleia Anciã
- [ ] Javali Cicatrizado
- [ ] Gremlin Espinhento

## Modificadores candidatos

- Frenético
- Blindado
- Corrompido
- Regenerativo
- Prismático
- Ecoante

Objetivo:

reutilizar criaturas existentes para gerar variedade sem exigir um sprite completamente novo para cada encontro.

---

# 11. MINIBOSS-1

## Rainha das Geleias

Mecânica:

- gera pequenas Geleias;
- ensina gestão de adds.

## Javali da Ponte

Mecânica:

- investidas telegráficas;
- controle de espaço.

## O Espinheiro

Mecânica:

- criatura vegetal imóvel;
- ocupa progressivamente a arena;
- cria pressão de tempo.

---

# 12. BOSS-1 — Guardião-Cervo de Pedra

O boss não deve ser apenas um inimigo com muito HP.

## Fase 1 — O Protetor

- ataques previsíveis;
- investidas;
- área;
- comportamento ainda controlado.

## Fase 2 — O Corrompido

- corrupção visível;
- novos ataques;
- raízes/cristais;
- arena mais perigosa.

## Fase 3 — A Memória

Objetivo:

introduzir a ideia de que derrotar um Guardião pode significar **libertá-lo**, não simplesmente matá-lo.

Possível mecânica:

destruir fragmentos da corrupção enquanto Íris identifica a memória do Guardião.

## Recompensa narrativa

**Fragmento do Coração Verde**

Efeito esperado:

- restaura parcialmente o Bosque;
- modifica visualmente o Hub;
- fortalece a Lanterna-Mãe;
- revela nova região no mapa.

---

# 13. EVENT-1 — Eventos de expedição

Meta inicial:

**10–15 eventos para o Bosque de Lúmen**

Candidatos:

## Árvore Cantante

Opções:

- tocar;
- cortar;
- ignorar.

## Comerciante Gremlin

Comércio de itens incomuns e consequências imprevisíveis.

## Poço de Lúmen

Escolha entre:

- recuperar HP;
- sacrificar recurso/HP em troca de recompensa mais rara.

## Memorial Esquecido

Escolher um herói e revelar uma pequena memória.

## Raiz Oca

Possível passagem secreta.

## Criatura Ferida

Salvar / ignorar / consumir recurso.

## Cristal Partido

Risco de corrupção em troca de poder.

---

# 14. HERO-EVENT-1 — Eventos pessoais

Meta inicial:

**2 eventos exclusivos por herói no Capítulo 1**, quando fizer sentido.

Exemplos:

- Brasa reconhece sinais semelhantes à região perdida;
- Forja consegue abrir tecnologia antiga;
- Orvalho recupera uma planta;
- Véu identifica uma armadilha;
- Sino ouve uma memória residual;
- Íris percebe um Eco;
- Flecha encontra uma rota alternativa;
- Bastião protege um sobrevivente.

Não é obrigatório implementar todos no primeiro vertical slice.

---

# 15. ECHO-1 — Sistema de Ecos

## Funções

Ecos devem servir como:

- coleção;
- pequena alteração de build;
- lore;
- progressão.

## Progressão proposta

### Eco Fraco

efeito básico.

### Eco Desperto

efeito mecânico adicional.

### Eco Verdadeiro

efeito característico e lore completa.

## Exemplo

### Eco da Geleia

**Fraco**
pequeno bônus de cura.

**Desperto**
cura excedente pode virar escudo.

**Verdadeiro**
primeira queda crítica de HP da luta ativa cura emergencial.

---

# 16. HUB-1 — Refúgio da Vigília

O Hub funciona como espaço de meta-progressão, narrativa e representação visual da recuperação do mundo.

Ele deve parecer uma **cidade/refúgio reconstruída**, e não uma tela de seleção de sistemas.

## Núcleo inicial

### Lanterna-Mãe

Funções:

- progresso de capítulos;
- fragmentos recuperados;
- evolução visual do mundo;
- conexão com os Corações de Lúmen.

### Mesa da Expedição

Funções:

- montar party de 3 heróis;
- selecionar destino;
- preparar run;
- consultar modificadores relevantes da expedição.

### Árvore dos Ecos

Funções:

- progressão global;
- desbloqueios estruturais;
- visualização dos sete ramos;
- conexão com Fragmentos de Ressonância.

## Estabelecimentos desbloqueáveis

### Ferraria

Ferreiro; equipamento, desmontagem, upgrade e reforja.

### Laboratório do Alquimista

Transmutação, Essências, Catalisadores e conversões.

### Câmara/Arquivo de Ecos

Gravadora de Ecos; memórias, bestiário, Echoes e modificadores avançados.

### Ourivesaria

Joias, acessórios e especialização fina.

### Jardim

Ligado a Orvalho; função final ainda a validar.

### Memorial

Bosses, feitos, campanha pessoal e história.

### Campo de Treino

Teste de builds, dano, skills e combinações.

## Regra de desbloqueio

Sistemas do Hub aparecem gradualmente.

Fluxo desejado:

`recuperar mundo → Hub muda visualmente → novo serviço aparece → nova possibilidade de build`

Evitar apresentar todos os menus desde o início.

## Gate HUB-1 PASS

- layout funcional do Refúgio definido;
- Lanterna-Mãe, Mesa, Árvore e Ferraria posicionadas;
- ordem de desbloqueio dos demais estabelecimentos definida;
- cada prédio possui função clara e não redundante;
- pelo menos uma melhoria visual do Hub ocorre após o boss do Capítulo 1.

---

# 17. RELATIONSHIP-0 — Relações entre heróis

**Status:** conceito futuro.

Objetivo:

fazer os oito personagens parecerem um grupo.

Possíveis pares narrativos:

- Bastião ↔ Brasa
- Flecha ↔ Véu
- Íris ↔ Sino
- Forja ↔ Orvalho

Inicialmente os vínculos podem desbloquear apenas:

- diálogos;
- pequenas cenas;
- memórias.

Não adicionar bônus numérico antes de validar necessidade.

---

# 18. SECRET-1 — Segredos

Adicionar pequenos segredos para aumentar descoberta sem exigir sistemas gigantes.

Candidatos:

- passagem escondida;
- parede quebrável;
- Eco secreto;
- inimigo raro;
- evento condicionado à party;
- combinação incomum de itens;
- área pós-boss;
- inscrições antigas;
- personagem misterioso.

## O Observador

Entidade rara que aparece ao fundo em determinados pontos.

Características iniciais:

- não ataca;
- não pode ser enfrentada normalmente;
- desaparece quando descoberta;
- pode reaparecer em capítulos futuros.

Não revelar sua identidade nesta etapa.

---

# 19. ECON-1 — Economia mínima

**Status:** `DESIGN` em andamento. O [modelo ECON-1](docs/06_balance/ECONOMY_MODEL.md) registra diagnóstico, cenários de custo, simulação Monte Carlo e limite estrutural da expedição offline. CONTENT-1 já registra uma hipótese de distribuição do bestiário v0.4 pelas dez subfases e uma recompensa opcional e não repetível de Resíduo de Lúmen para experimentar o Ferreiro. A distribuição não define contagens finais nem balanceamento; quantidades, rendimentos e custos precisam ser recalculados. TTK, teto numérico e conversão temporal offline ficam para medição em SLICE-1. Nenhum `/data` ou código homologado foi alterado.

A economia deve continuar simples de entender, mesmo com os novos sistemas.

Separar **recursos principais** de **materiais de crafting/tokens especiais**.

## Recursos principais

### Lúmen

Recurso geral obtido principalmente em expedições e utilizado em serviços básicos do Hub.

### Fragmentos de Ressonância

Recurso de meta-progressão usado na **Árvore dos Ecos**.

### Essências

Família de materiais associada a biomas e crafting/alquimia.

## Token especial

### Sigilos

Recompensas raras de elites/chefes usadas apenas em sinks especiais.

Sigilos não devem funcionar como quarta moeda cotidiana.

## Materiais de crafting

Componentes, ligas, pós, catalisadores e fragmentos podem existir como materiais específicos, desde que não criem dezenas de moedas paralelas.

## Antes de congelar números

Para cada recurso/material documentar:

- fonte;
- quantidade média;
- sink;
- velocidade de aquisição;
- objetivo;
- limite/stack quando relevante;
- risco de inflação;
- método de simulação.

## Gate ECON-1 PASS

- árvore, Ferreiro, Alquimista e loot possuem sinks definidos;
- não existe recurso sem função clara;
- custos principais são simuláveis;
- nenhum sistema exige grind excessivo para funcionar;
- a primeira expedição offline termina no objetivo/derrota sem iniciar outra; teto numérico e conversão de tempo ficam para medição no `SLICE-1`;
- a melhoria do Ferreiro pode ser demonstrada com uma fonte não repetível do material canônico selecionado, sem sacrificar a única peça útil nem ser requisito para vencer;
- números permanecem hipóteses até playtest/ARGOS.

---

# 20. BALANCE-FOUNDATION-1 — Contrato canônico de balanceamento

**Status:** `DESIGN` planejado. A base v0.4 está aprovada; esta fase integra sua estrutura aos heróis/combate do Pocket Hero, reconcilia runtime legado e prepara simulação/baselines para o slice. Não altera o runtime homologado antes do gate de migração.

## Objetivo

Usar Bastião como referência e integrar a estrutura canônica v0.4 para comparar heróis, inimigos, equipamentos, skills/passivas/Traits e efeitos. Manter uma única fonte de verdade, registrar aliases entre IDs e validar os baselines aprovados por simulação/playtest antes de migrá-los ao runtime.

## Subfases

### BALANCE-FND-1A — Auditoria do registro de status

- [ ] mapear nomes/valores runtime atuais para os IDs de design, mantendo IDs runtime intactos;
- [ ] definir unidade, significado, cálculo, fontes permitidas e limites de cada status canônico;
- [ ] separar status-base, recurso de classe, estado temporário e métrica de progressão/loot;
- [ ] registrar como Guard, Perfect Block, Desequilíbrio/Stagger, threat e summons se relacionam com o pipeline compartilhado.

### BALANCE-FND-1B — Modelos de combate e budgets

- [ ] integrar as fórmulas canônicas de dano, crítico, defesa/penetração, cura, escudo e EHP; conferir caps, ordem e exemplos calculados contra o combate atual;
- [ ] fechar o modelo de progressão de atributos e uma entidade de referência para normalizar comparações;
- [ ] construir baseline inicial de heróis começando pelo Bastião e validar a faixa com Flecha e Íris;
- [ ] descrever arquétipo/rank de inimigos e escalonamento de capítulo/dificuldade sem duplicar fichas;
- [ ] integrar os budgets de equipamento por raridade e slot, incluindo o custo de poder de efeitos únicos, e preparar casos de validação;
- [ ] formalizar duração, stacking, dispel, Tenacidade e orçamento de DOT/HOT para buffs e debuffs;
- [ ] mapear tipos de dano, affixes e sistemas v0.4 ao combate do Pocket Hero; documentar incompatibilidades e solicitar decisão somente quando duas regras aprovadas não puderem coexistir.

### BALANCE-FND-1C — Telemetria e gates de validação

- [ ] especificar métricas de dano, cura, escudo, controle, recursos, TTK, EHP, sobrevivência e frequência de uso;
- [ ] montar matriz de comparação de builds, equipamento esperado e abaixo/acima do esperado, ranks e bosses;
- [ ] documentar critérios de aceite e checklist de QA para heróis, inimigos, equipamentos e efeitos;
- [ ] rastrear cada número como `DECIDIDO`, `HIPÓTESE` ou `EM ABERTO`, indicando fonte, método e limitações;
- [ ] registrar discrepâncias com `/data` como trabalho de migração separado, sem mudar o MVP neste gate.

## Gate BALANCE-FOUNDATION-1 PASS

- todo atributo canônico tem identificador estável, definição e unidade;
- heróis, inimigos, equipamento e efeitos usam o mesmo modelo de status/modificadores, sem regra paralela por entidade;
- templates remetem às fontes de identidade/conteúdo existentes e não duplicam fatos canônicos;
- fórmula e limites são calculáveis manualmente e cobertos por exemplos;
- baselines iniciais não excedem budgets sem justificativa documentada;
- indicadores de telemetria e aceite permitem comparar ao menos Bastião, trio inicial, inimigos do Capítulo 1, elite, minichefe, boss e os seis slots de equipamento;
- hipóteses numéricas seguem claramente separadas das regras aprovadas e valores runtime;
- toda migração necessária é apontada e tem escopo explícito; nenhuma mudança silenciosa em `/data`, scripts ou cenas.

O `PASS` desta fase aprova o contrato de design e os baselines para teste, não declara que o jogo está balanceado. Playtest, telemetria real e ajuste iterativo permanecem na fase pós-slice [`BALANCE-1`](#22-balance-1--balanceamento).

---

# 21. SLICE-1 — Vertical Slice do jogo real

Somente após os sistemas anteriores possuírem design suficiente.

## Fluxo mínimo

`Hub → party → preparar build → expedição → combate → escolha → evento → elite → recompensa → mini-boss → boss → retorno → Árvore/Ferreiro → Hub evolui`

## Conteúdo mínimo

- 3 heróis funcionais;
- Bastião implementado como referência estrutural;
- subset de skills/passivas/Traits suficiente para demonstrar builds distintas;
- subset de equipamentos cobrindo os principais tipos de slot;
- subset de inimigos;
- 1 elite;
- 1 evento;
- 1 mini-boss;
- Guardião-Cervo;
- retorno ao Hub;
- Fragmento do Coração Verde;
- Árvore dos Ecos com pequeno ramo funcional;
- Ferreiro com pelo menos **desmontagem + 1 serviço de melhoria**;
- mudança visual perceptível no Hub após conclusão.

**DECISÃO de DESIGN-1:** incluir um Echo funcional opcional no slice. Ele não é necessário para vencer; a função e os limites estão no [Sistema de Ecos](docs/03_systems/ECHO_SYSTEM.md).

## Fora do slice inicial

- árvore completa de ~84 nós;
- todos os 8 heróis implementados;
- todos os artesãos em nível máximo;
- crafting profundo;
- campanha pessoal completa de todos os heróis;
- Mastery 1–10 completa para todos em runtime.

## Gate SLICE-1 PASS

PASS quando:

- o loop completo puder ser jogado do início ao fim;
- decisões durante a run influenciarem a build;
- pelo menos duas builds claramente diferentes forem possíveis;
- progressão do herói e progressão global forem compreensíveis e distintas;
- Hub e expedição formarem um ciclo;
- equipamento ganho puder ser usado ou reciclado com decisão real;
- boss possuir mecânica distinta de inimigo comum;
- retorno da run produzir progressão perceptível sem grind artificial.

---

# 22. BALANCE-1 — Balanceamento

Após o Vertical Slice.

## Medir

- TTK;
- duração da run;
- dano por herói;
- uso de skills;
- taxa de escolha de itens;
- taxa de escolha de skills;
- dano recebido;
- mortes;
- recursos ganhos;
- recursos gastos;
- builds dominantes;
- skills nunca escolhidas;
- itens nunca escolhidos.

## ARGOS

A trilha ARGOS deve apoiar esta etapa.

Prioridades de simulação:

- inflação de recursos;
- TTK;
- distribuição de drops;
- skills dominantes;
- builds quebradas;
- combinações impossíveis de vencer;
- combinações triviais demais.

---

# 23. LOOT-EXPANSION-1 — Economia e loot completos

**Status:** `APPROVED` como base canônica de design por decisão de Rafael em 2026-09-28. A integração, migração dos IDs runtime e validação continuam planejadas para depois do slice. Consulte [TASKBAR Sistema Completo v0.4](documents/canonical/taskbar_sistema_v0.4/README.md).

## Objetivo

Integrar ao Pocket Hero a camada canônica v0.4 de loot/data-driven que conecta inimigo, encontro, item, material, Echo/Memória e economia. Preservar os seis slots do jogo e manter mapeamentos dos IDs atuais até migração compatível.

## Escopo

- [ ] integrar o `ENEMY_CANONICAL_SCHEMA` e os 17 registros aprovados ao modelo Pocket Hero, preservando aliases dos IDs runtime até a migração;
- [ ] substituir como catálogo futuro as 11 propostas anteriores pelos 17 inimigos canônicos (10 normais, 3 elites, 3 minichefes e 1 boss); mapear encontros do Bosque para as dez subfases;
- [ ] adotar o catálogo canônico de 30 itens nas categorias Arma, Secundário, Armadura, Acessório e Echo, compatibilizando os seis slots;
- [ ] integrar os sete materiais e as seis raridades canônicas; definir o subconjunto do primeiro slice sem contradizer a fonte global;
- [ ] integrar o Drop Resolver: ouro, materiais, equipamento, Signature, Echo/Memória e recompensas garantidas com ordem determinística;
- [ ] integrar os mecanismos canônicos de Smart Loot, Duplicate Protection, Slot Pity, Quality Floor, Reward Choice, Boss Fragments e Bestiário; calibrar parâmetros por simulação e registrar qualquer proposta de alteração como decisão separada;
- [ ] definir persistência e idempotência de first clear/pity, seed reproduzível, save migration, overflow de inventário e telemetria local;
- [ ] manter tabelas humanas como vistas derivadas de uma fonte de dados aprovada, evitando duas autoridades para os mesmos drops;
- [ ] simular primeiro clear, repetição, pity e crafting para inflação, farm dominante, equipamento útil e impacto de cada recurso;
- [ ] criar schemas, ferramentas de validação, cenários QA e critérios de aceite antes da implementação de runtime.

## Gate LOOT-EXPANSION-1 PASS

- conteúdo canônico está em fonte única, com migração sem colisão/reutilização de IDs e aliases runtime documentados;
- cada item/material/recompensa possui fonte e sink claros, e as raridades/slots respeitam o padrão canônico;
- algoritmo de recompensa é determinístico por estado e seed e concede first clear no máximo uma vez;
- pity e proteções não forçam itens ilegais para um pool nem elevam o poder acima dos budgets;
- simulações mostram distribuição, progresso, economia, extremos e limitações para primeira conclusão e repetição;
- save, overflow, telemetria e QA têm contrato verificável;
- a fase não reabre nem altera retroativamente o MVP homologado.

O v0.4 já é o cânone de design. `PASS` desta fase comprovará que a integração e a migração respeitam esse cânone; não afirmará equilíbrio sem simulação/playtest nem implementação sem evidência do runtime.

---

# 24. FUTURE-REGIONS — Apenas sementes narrativas

Não produzir conteúdo completo ainda.

## Capítulo 2 — Minas de Cinza

Tema:

extração industrial de Lúmen.

Pergunta narrativa:

> O Apagamento realmente começou naturalmente?

Possíveis inimigos futuros:

- autômatos abandonados;
- morcegos cristalinos;
- mineradores ocos;
- vermes de minério;
- golems;
- máquinas defeituosas.

Boss candidato:

**O Escavador**

Máquina antiga que continua cumprindo a ordem de extrair Lúmen.

---

## Capítulo 3 — Cidade dos Sinos

Tema:

memória.

Pergunta narrativa:

> As memórias estão desaparecendo ou estão sendo armazenadas em algum lugar?

Relacionamento forte com Sino e Íris.

---

# 25. Ordem de execução recomendada

A ordem abaixo substitui a sequência anterior para refletir os sistemas introduzidos em 2026-09-28.

## Fundação concluída e próxima fase

1. [x] **SYNC-0** — importar os novos contratos/documentos para o repositório e atualizar índices;
2. [x] **DESIGN-1** — fechar a fundação e a separação entre run, herói, equipamento e conta;
3. [x] **LORE-1** — consolidar `LORE_BIBLE.md` preservando os mistérios centrais;
4. [x] **HERO-STD** — padrão canônico registrado como `APPROVED` em [`HERO_STANDARD.md`](HERO_STANDARD.md);
5. [x] **HERO-001 BASTIÃO** — registrar Golden Reference completo;
6. [x] **TREE-1 MVP** — definir os 30 nós, pré-requisitos, faixas relativas de custo e dependências da Árvore dos Ecos;
7. [x] **CRAFT-1 MVP** — definir função, fonte/sink, limites do slice e ordem de desbloqueio dos quatro artesãos;
8. [x] **ITEM-1** — reconciliar slots, raridades, contrato de item e catálogo de 30;
9. **ECON-1 — em andamento** — modelo, simulação reproduzível da primeira passagem e cenário offline limitado ao objetivo; usar o mapa provisório do Capítulo 1 e a fonte opcional de Resíduo de Lúmen para recalcular custos/rendimentos conforme v0.4. Teto/conversão temporal dependem de TTK medido em SLICE-1, conforme o [modelo econômico](docs/06_balance/ECONOMY_MODEL.md).

## Depois — conteúdo jogável

10. **CONTENT-1** — Bosque de Lúmen;
11. **ENEMY-1**;
12. **ENCOUNTER-1**;
13. **ELITE-1**;
14. **MINIBOSS-1**;
15. **BOSS-1**;
16. **EVENT-1 / HERO-EVENT-1**;
17. **ECHO-1**;
18. **HUB-1** — layout e progressão visual;
19. **BALANCE-FOUNDATION-1** — estruturar registros e baselines compartilhados;
20. **SLICE-1** — vertical slice completo usando os contratos da fundação;
21. **BALANCE-1 / ARGOS** — telemetria e ajustes iterativos pós-slice;
22. **LOOT-EXPANSION-1** — integrar a base canônica v0.4 ao runtime, migrar IDs com aliases e validar loot/economia após os gates anteriores.

## Paralelo, sem bloquear o slice

- detalhar Flecha como próximo herói após Bastião;
- depois Íris, Brasa, Véu, Orvalho, Forja e Sino;
- relações entre heróis;
- campanhas pessoais dos demais heróis;
- conteúdo completo de capítulos futuros;
- sistemas avançados da cidade;
- expansão da Árvore dos Ecos além do MVP.

## Regra de precedência

Se houver conflito entre um documento antigo e o padrão canônico introduzido nesta revisão:

1. preservar código/MVP homologado até existir tarefa explícita de migração;
2. usar o padrão novo para **design futuro**;
3. registrar a migração necessária em vez de alterar silenciosamente conteúdo já homologado.

---

# 26. Critério de controle de escopo

Antes de adicionar qualquer novo sistema, perguntar:

1. melhora o core loop?
2. cria decisão para o jogador?
3. reforça progressão?
4. reforça lore?
5. interage com sistemas existentes?

Se a resposta for **não para todos**, não priorizar.

---

# 27. Regra de conteúdo

O objetivo não é criar centenas de sistemas independentes.

O objetivo é fazer poucos sistemas conversarem entre si:

`herói ↔ skill ↔ passiva ↔ Trait ↔ item ↔ Echo ↔ party ↔ inimigo ↔ evento ↔ lore ↔ Árvore dos Ecos ↔ artesãos ↔ Hub`

Essa interação deve ser o principal diferencial do Pocket Hero.

---

# 28. Próximo checkpoint

## CHECKPOINT — ECON-1 / CONTENT-1 / HERO-002

### A. Sincronizar documentação

- [x] adicionar o padrão canônico de heróis ao repositório e apontar os índices para a fonte única na raiz;
- [x] adicionar o Golden Reference do Bastião;
- [x] adicionar a Árvore Global de Ressonância / Árvore dos Ecos;
- [x] adicionar Equipamentos e Artesãos da Cidade;
- [x] atualizar `documents/INDEX.md` e `POCKET_HERO_PROJECT_BRIEF.md`;
- [x] reconciliar referências ao catálogo antigo de 5 skills por herói: os 15 conceitos normais existentes são parciais, sem Signature Skills, e não substituem o padrão de 6 skills por herói.

### B. Fechar MVP da progressão global

- [x] selecionar 30 nós da Árvore dos Ecos em sete ramos;
- [x] definir custos apenas em escala relativa; valores absolutos seguem para `ECON-1`;
- [x] definir os nós que liberam o segundo slot de skill, a Ferraria e demais sistemas;
- [x] criar diagrama de dependências entre ramos e nós.

### C. Fechar MVP de equipamento/cidade

- [x] confirmar os seis slots canônicos e documentar os tipos do runtime como legado;
- [x] aprovar as seis raridades da base v0.4; manter apenas anotação histórica sobre quatro raridades no runtime antigo;
- [x] aprovar o catálogo canônico v0.4 de 30 itens; manter catálogo runtime anterior até migração explícita;
- [x] definir desmontagem e primeiro aprimoramento controlado do Ferreiro; valores seguem para `ECON-1`;
- [x] definir o primeiro uso de Essência: destilação alimenta Catalisadores para serviços avançados do Ferreiro, fora do slice;
- [x] decidir em `DESIGN-1` a inclusão de um Echo funcional opcional; a ficha completa e a implementação permanecem para `ECHO-1`.

### D. Próximo herói

Depois de registrar Bastião como referência:

- [ ] iniciar **Flecha** seguindo exatamente o mesmo contrato;
- [ ] 6 skills;
- [ ] 16 passivas;
- [ ] 3 Traits;
- [ ] Mastery 1–10;
- [ ] lore + 5 missões;
- [ ] equipamentos/Echos de referência.

Somente depois ampliar produção massiva do roster ou da Árvore dos Ecos.
