# ROADMAP — Expansão de Conteúdo e Identidade do Pocket Hero

**Status:** planejamento ativo — revisado em 2026-09-28  
**Base:** complementar ao `ROADMAP.md` principal  
**Objetivo:** transformar o Pocket Hero de um MVP funcional em um jogo com identidade, progressão, builds, lore, Hub e conteúdo suficiente para sustentar o Capítulo 1 sem inflar prematuramente o escopo.  
**Mudança desta revisão:** incorporar o padrão canônico dos 8 heróis, o Bastião como Golden Reference de design, a Árvore dos Ecos, equipamentos de 10 slots e os artesãos da cidade.

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

- [ ] Criar `GAME_PILLARS.md`
- [ ] Criar `CORE_LOOP.md`
- [ ] Criar `LORE_BIBLE.md`
- [ ] Criar `GAME_GLOSSARY.md`
- [x] Definir composição da party: **3 heróis ativos entre 8 disponíveis**
- [x] Definir padrão canônico de herói: ataque básico + 6 skills + 16 passivas + 3 Traits + Mastery 1–10
- [x] Definir Bastião como **Golden Reference de design** para os demais heróis
- [x] Definir conceito da **Árvore dos Ecos / Árvore Global de Ressonância**
- [x] Definir conceito de **equipamentos + artesãos da cidade**, substituindo um sistema abstrato tipo Cube
- [ ] Importar/converter os documentos canônicos para a estrutura `docs/` do repositório
- [ ] Definir regras finais de run versus meta-progressão
- [ ] Definir como skills são oferecidas/evoluem durante a run sem conflitar com a árvore permanente do herói
- [ ] Definir como itens são obtidos, comparados, equipados, desmontados e reforjados
- [ ] Definir como Ecos são adquiridos e como se relacionam com equipamentos e lore
- [ ] Definir condições de vitória e derrota
- [ ] Definir duração-alvo inicial de uma run

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
- 10 slots de equipamento;
- 5 missões pessoais;
- 4 estágios visuais;
- 1 mecânica exclusiva e 1 fraqueza clara.

### Separação obrigatória

- **Run:** decisões temporárias de build, loot, eventos e composição.
- **Herói:** progressão individual permanente e domínio do personagem.
- **Conta/Hub:** Árvore dos Ecos, serviços da cidade e desbloqueios globais.
- **Equipamento:** loot, affixes, crafting, reforja, Ecos e especialização.

## Gate DESIGN-1 PASS

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

## Conceitos centrais

### Lúmen

Energia ligada a vida, memória e identidade.

### O Apagamento

Fenômeno responsável pela perda gradual do Lúmen.

Uma criatura afetada pode perder:

- memórias;
- instintos;
- identidade;
- capacidade de reconhecer aliados.

### Corações de Lúmen

Grandes núcleos ligados às regiões do mundo.

Cada capítulo pode revelar um Coração e um Guardião.

### Guardiões

Não são necessariamente vilões.

São criaturas ou entidades responsáveis por proteger regiões e que podem ter sido corrompidas pelo Apagamento.

### Ecos

Fragmentos de memória preservados pelo Lúmen.

Servem simultaneamente como:

- sistema de gameplay;
- coleção;
- progressão;
- bestiário;
- veículo de lore.

## Mistérios centrais

Manter inicialmente sem resposta definitiva:

- [ ] O Apagamento é natural?
- [ ] Para onde o Lúmen desaparece?
- [ ] As memórias estão sendo destruídas ou armazenadas?
- [ ] Quem construiu as máquinas antigas de extração de Lúmen?
- [ ] Quem sabia do Apagamento antes dele começar?
- [ ] Quem ou o que é o Observador?

## Golden Reference narrativo — Bastião

A lore pessoal do Bastião está definida em conceito e deve servir como referência de integração entre narrativa e mecânica.

Pontos canônicos:

- antigo membro da **Guarda da Primeira Muralha**;
- o nome verdadeiro foi perdido pelo Apagamento;
- **Bastião** é o nome adquirido pela função que passou a representar;
- **Primeiro Juramento:** “Enquanto houver alguém atrás de mim, eu permaneço.”;
- **Porta da Vigília** é o centro de sua memória perdida;
- seu arco trabalha dever, memória, culpa e a diferença entre resistir e viver;
- o nome verdadeiro não deve ser revelado nesta etapa.

### Campanha pessoal — 5 missões

1. **A Porta** — retorno às ruínas da Primeira Muralha;
2. **Nomes no Ferro** — origem do escudo e dos companheiros perdidos;
3. **O Último a Sair** — descoberta de que permaneceu mesmo após a evacuação;
4. **O Nome Esquecido** — recusa recuperar sua identidade ao custo das memórias alheias;
5. **Eu Fico** — repetição da antiga batalha, agora com aliados permanecendo ao seu lado.

**Status:** `LORE_DESIGN_COMPLETE` para Bastião; diálogos completos, encounters finais e implementação continuam pendentes.

## Gate LORE-1 PASS

- regras básicas do universo definidas;
- nenhum mistério principal respondido cedo demais;
- lore do Bosque de Lúmen consistente com o universo;
- narrativa compatível com gameplay.

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
- [x] Echo de Maestria M8;
- [x] evolução de Inabalável M9;
- [x] Forma Lendária + Signature Modifier M10;
- [x] campanha pessoal de 5 missões;
- [ ] números finais;
- [ ] diálogos completos;
- [ ] encounters implementados;
- [ ] sprites/efeitos finais.

**Estado do Bastião:** `HERO_DESIGN_CONTENT_COMPLETE` — Golden Reference para produção dos demais heróis.

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

- MVP de ~30 nós definido;
- custo e pré-requisitos modelados;
- nenhum ramo possui upgrades puramente redundantes;
- pelo menos parte dos nós libera sistemas, não só atributos;
- economia simulável antes de valores finais;
- UI comporta expansão futura sem redesenho total.

---

# 5B. CRAFT-1 — Cidade, equipamentos e substituto do Cube

Pocket Hero não deve usar um “Cube” abstrato como centro do crafting.

As mesmas funções são distribuídas por **personagens e estabelecimentos do Refúgio da Vigília**.

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

- serviços mínimos de cada artesão definidos;
- ordem de desbloqueio documentada;
- cada serviço possui fonte e sink econômico;
- nenhum serviço duplica outro sem motivo;
- crafting melhora escolhas, não substitui completamente o loot.

---

# 6. ITEM-1 — Equipamentos e catálogo inicial

O sistema de equipamento passa a utilizar **10 slots por herói**.

## Slots canônicos

1. Weapon
2. Secondary
3. Head
4. Chest
5. Gloves
6. Boots
7. Amulet
8. Ring
9. Relic
10. Echo

O slot **Echo** conecta diretamente loot, build e lore.

## Estrutura de item

Um item pode possuir, conforme raridade e categoria:

- Item Power;
- atributo-base;
- affixes;
- modificador mecânico;
- raridade;
- tags de herói/build;
- interação com Echo;
- origem/lore quando relevante.

## Catálogo inicial

Preservar os itens existentes e evoluir o catálogo total inicialmente para **30 itens**, priorizando variedade funcional antes de quantidade.

Itens candidatos já definidos:

- [ ] Casca do Guardião
- [ ] Olho de Vidro Verde
- [ ] Raiz Faminta
- [ ] Cinza Eterna
- [ ] Sino Partido
- [ ] Engrenagem Impossível
- [ ] Agulha da Viúva
- [ ] Coração de Pedra
- [ ] Fragmento Prismático
- [ ] Pétala do Primeiro Jardim

## Equipamentos exclusivos de referência — Bastião

- [x] **Muralha do Primeiro Juramento** — escudo ligado à sua campanha pessoal;
- [x] **Vigília** — espada feita com fragmentos da Porta da Vigília;
- [x] **A Sentinela que Ficou** — Echo ligado à memória da evacuação.

## Exemplos de efeitos desejados

### Casca do Guardião
Receber escudo gera uma pequena onda de dano.

### Olho de Vidro Verde
Críticos aplicam Marca.

### Raiz Faminta
Cura excedente pode virar escudo.

### Cinza Eterna
Inimigos queimados explodem ao morrer.

### Sino Partido
Toda terceira skill pode repetir parcialmente.

### Engrenagem Impossível
Engenhocas duram mais em troca de poder pessoal de Forja.

### Agulha da Viúva
Veneno pode causar crítico.

### Coração de Pedra
Menos HP = maior resistência.

### Fragmento Prismático
Atingir múltiplos inimigos com magia reduz cooldown.

### Pétala do Primeiro Jardim
Cura pode gerar Semente.

## Raridade e progressão

Raridade deve controlar quantidade/qualidade de propriedades e acesso a efeitos especiais, mas **Item Power e efeito mecânico devem ser avaliados separadamente** para evitar que raridade sozinha determine o melhor item.

Os nomes e quantidades finais de tiers de raridade permanecem sujeitos ao documento canônico de equipamentos e aos testes de pacing.

## Gate ITEM-1 PASS

- 10 slots definidos e representados na UI;
- 30 itens documentados;
- raridades e regras de Item Power definidas;
- affixes e limites de reforja definidos;
- pelo menos 10 itens alteram comportamento;
- pelo menos 8 itens suportam builds diferentes;
- pelo menos 1 Echo funcional no slice;
- nenhum item obrigatório para todos os personagens;
- desmontagem/crafting não torna drops irrelevantes.

---

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
- números permanecem hipóteses até playtest/ARGOS.

---

# 20. SLICE-1 — Vertical Slice do jogo real

Somente após os sistemas anteriores possuírem design suficiente.

## Fluxo mínimo

`Hub → party → preparar build → expedição → combate → escolha → evento → elite → recompensa → mini-boss → boss → retorno → Árvore/Ferreiro → Hub evolui`

## Conteúdo mínimo

- 3 heróis funcionais;
- Bastião implementado como referência estrutural;
- subset de skills/passivas/Traits suficiente para demonstrar builds distintas;
- subset de equipamentos cobrindo os principais tipos de slot;
- 1 Echo funcional;
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

# 21. BALANCE-1 — Balanceamento

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

# 22. FUTURE-REGIONS — Apenas sementes narrativas

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

# 23. Ordem de execução recomendada

A ordem abaixo substitui a sequência anterior para refletir os sistemas introduzidos em 2026-09-28.

## Agora — sincronização de design

1. **SYNC-0** — importar os novos contratos/documentos para o repositório e atualizar índices;
2. **DESIGN-1** — fechar run vs herói vs conta vs equipamento;
3. **LORE-1** — iniciar `LORE_BIBLE.md` preservando os mistérios centrais;
4. **HERO-STD** — congelar o padrão canônico de herói;
5. **HERO-001 BASTIÃO** — registrar Golden Reference completo;
6. **TREE-1 MVP** — desenhar os ~30 nós iniciais da Árvore dos Ecos;
7. **CRAFT-1 MVP** — definir Ferraria/Alquimia/Ecos/Ourives e ordem de desbloqueio;
8. **ITEM-1** — reconciliar 10 slots, raridades, Item Power, affixes e 30 itens;
9. **ECON-1** — fontes/sinks e primeira simulação.

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
19. **SLICE-1** — vertical slice completo;
20. **BALANCE-1 / ARGOS**.

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

# 24. Critério de controle de escopo

Antes de adicionar qualquer novo sistema, perguntar:

1. melhora o core loop?
2. cria decisão para o jogador?
3. reforça progressão?
4. reforça lore?
5. interage com sistemas existentes?

Se a resposta for **não para todos**, não priorizar.

---

# 25. Regra de conteúdo

O objetivo não é criar centenas de sistemas independentes.

O objetivo é fazer poucos sistemas conversarem entre si:

`herói ↔ skill ↔ passiva ↔ Trait ↔ item ↔ Echo ↔ party ↔ inimigo ↔ evento ↔ lore ↔ Árvore dos Ecos ↔ artesãos ↔ Hub`

Essa interação deve ser o principal diferencial do Pocket Hero.

---

# 26. Próximo checkpoint

## NEXT — SYNC-0 / TREE-1 / HERO-002

### A. Sincronizar documentação

- [ ] adicionar o padrão canônico de heróis ao repositório;
- [ ] adicionar o Golden Reference do Bastião;
- [ ] adicionar a Árvore Global de Ressonância / Árvore dos Ecos;
- [ ] adicionar Equipamentos e Artesãos da Cidade;
- [ ] atualizar `documents/INDEX.md` e `POCKET_HERO_PROJECT_BRIEF.md`;
- [ ] marcar documentos antigos de 5 skills como **superseded** onde houver conflito.

### B. Fechar MVP da progressão global

- [ ] selecionar aproximadamente 30 nós da Árvore dos Ecos;
- [ ] definir custos apenas em escala relativa inicialmente;
- [ ] definir quais nós liberam segundo slot, Ferraria e demais sistemas;
- [ ] criar diagrama de dependências.

### C. Fechar MVP de equipamento/cidade

- [ ] confirmar os 10 slots;
- [ ] congelar esquema inicial de raridade/Item Power/affixes;
- [ ] definir desmontagem e primeiro upgrade do Ferreiro;
- [ ] definir primeiro uso de Essências no Alquimista;
- [ ] selecionar 1 Echo para o vertical slice.

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
