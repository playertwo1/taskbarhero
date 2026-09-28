# Capítulo 1 — Bosque de Lúmen

**Status:** proposta de conteúdo v0.2; direção macro aprovada por Rafael em 2026-09-27. Skills e itens novos seguem como candidatos sem balanceamento.
**Escopo:** estrutura de campanha, encontros, inimigos, chefes, skills e equipamentos. Não é especificação de balanceamento, aprovação de arte nem autorização para produção em massa.

## Fontes e nível de certeza

- **DECIDIDO:** o Bosque de Lúmen é a primeira região; a espinha do MVP tem cinco fases — Entrada, Clareira da Pressão, Ninho Silvestre, Covil do Alfa e Santuário do Guardião. A party é Bastião, Flecha e Íris. O elenco existente inclui Geleia de Lúmen, Gremlin de Folha, Javali de Musgo, Espírito de Raiz, Lobo Alfa de Lúmen e Guardião-Cervo de Pedra.
- **DECIDIDO:** o catálogo de design terá 15 skills (cinco por herói) e 30 itens distintos (os 15 existentes do MVP mais 15 novos candidatos).
- **RECOMENDADO:** preservar as cinco fases macro e a estrutura-base de dez subfases e dar a cada uma encontros com função própria e marcos de progressão. Isso amplia o conteúdo sem invalidar os gates históricos do MVP.
- **HIPÓTESE:** os novos nomes, encontros, skills e equipamentos abaixo são propostas originais para discussão. Ainda não estão balanceados nem aprovados como cânone.
- **EM ABERTO:** história final do capítulo, habilidades equipadas/unlocks, efeitos/raridades/recompensas dos itens e alvos de pacing. Não fixar nível, duração, dano, chance de drop ou custo até haver modelo e simulação.

Fontes: [`ROADMAP.md`](../../ROADMAP.md), [`POCKET_HERO_PROJECT_BRIEF.md`](../POCKET_HERO_PROJECT_BRIEF.md), [`REFERENCIAS_TBH.md`](../REFERENCIAS_TBH.md), [guia de design incremental](../../documents/GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) e [guia de economia e pacing](../../documents/GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md). Referências externas deste projeto servem para princípios; nomes, arte, mapas, texto e balanceamento permanecem próprios.

## Promessa do capítulo

**HIPÓTESE narrativa:** a party atravessa o Bosque seguindo rastros de Lúmen que estão ficando fracos, da entrada até as ruínas do santuário. Os inimigos parecem responder a essa mudança, mas sua causa e o papel do Guardião ficam para a história decidir.

**Objetivo de jogo:** ensinar o jogador a ler ameaças, combinar as funções dos três heróis e preparar a party para o Guardião. Cada obstáculo deve introduzir uma razão compreensível para trocar equipamento ou aproveitar uma skill; não deve ser resolvido apenas esperando ou acumulando atributos.

## Estrutura proposta

As cinco fases macro abaixo conservam os nomes já usados. As subfases são novos beats de campanha e ainda não existem no formato atual de dados. A lista de encontros é uma primeira proposta, não uma decisão de quantidade de kills ou de tempo.

| Fase macro | Subfase | Encontro e função de jogo | Ameaças candidatas |
| --- | --- | --- | --- |
| **1. Entrada do Bosque** | 1.1 Trilha dos Marcos Apagados | Ensinar o loop com uma ameaça simples e um inimigo veloz. | Geleia de Lúmen, Gremlin de Folha. |
|  | 1.2 Posto de Vigia Tomado | Introduzir um inimigo que se protege e exige observar sua postura. | Saqueador da Mata (novo candidato), Gremlin. |
| **2. Clareira da Pressão** | 2.1 Clareira Micelial | Introduzir suporte inimigo que fortalece aliados e torna prioridade de alvo uma decisão. | Xamã de Esporos (novo candidato), Geleia. |
|  | 2.2 Ravina do Musgo | Testar sobrevivência contra ataques lentos e anunciados. | Javali de Musgo, Espírito de Raiz. |
| **3. Ninho Silvestre** | 3.1 Galeria de Raízes | Combinar defesa alta e suporte; ensinar a quebrar uma formação inimiga. | Sentinela de Raízes e Xamã de Esporos (novos candidatos). |
|  | 3.2 Câmara do Micélio | Primeiro encontro de chefe secundário, com janelas de ataque legíveis. | Matriarca do Micélio (minichefe proposto), crias de Geleia. |
| **4. Covil do Alfa** | 4.1 Trilha da Matilha | Preparar o encontro de elite com inimigos rápidos e sinais de investida. | Lobo de Sombra (novo candidato), Espírito de Raiz. |
|  | 4.2 Pedra da Matilha | Elite do capítulo; testar defesa, foco e execução de skills. | Lobo Alfa de Lúmen (elite existente). |
| **5. Santuário do Guardião** | 5.1 Pátio das Raízes | Síntese das ameaças já aprendidas, sem introduzir uma família nova. | Sentinela, Javali, Espírito de Raiz. |
|  | 5.2 Coração do Santuário | Chefe final com duas leituras de combate claramente diferentes. | Guardião-Cervo de Pedra (boss existente). |

### Papel do encontro secundário

**HIPÓTESE:** a Matriarca do Micélio pode ocupar o papel de minichefe e ensinar a interromper ou priorizar um inimigo de suporte. Se adicionar esse chefe alongar demais o primeiro capítulo, removê-lo e manter a mesma lição em um encontro normal da Clareira ou do Ninho.

### Fio narrativo candidato

1. Os marcos de luz na trilha começam a falhar.
2. A clareira mostra que algumas criaturas estão reagindo à mudança; o jogador encontra o primeiro suporte inimigo.
3. O ninho revela uma concentração de micélio e oferece o primeiro encontro que combina ameaças.
4. O Alfa bloqueia a rota para o santuário.
5. O Guardião é confrontado no coração das ruínas; o desfecho explica o que acontecia com o Lúmen.

Não definir ainda quem causou a mudança, por que o Guardião combate a party ou o estado final do bosque. São decisões de lore ainda abertas.

## Inimigos e leitura de combate

Manter os quatro inimigos comuns do MVP como base. Acrescentar no máximo quatro famílias no primeiro passe e só se cada uma ensinar uma resposta diferente. Os comportamentos abaixo são propostas qualitativas, não números finais.

| Inimigo | Papel | Sinal legível | Resposta que deve funcionar |
| --- | --- | --- | --- |
| Geleia de Lúmen | Ameaça base. | Preparação curta antes do golpe. | Dano constante; serve de comparação para outras ameaças. |
| Gremlin de Folha | Ameaça rápida e frágil. | Avanço curto e frequente. | Foco de dano e interrupção rápida. |
| Javali de Musgo | Pressão física. | Baixa a cabeça antes da investida. | Mitigação do Bastião e resposta após a investida. |
| Espírito de Raiz | Suporte/controle. | Raízes ou brilho visível antes de fortalecer alguém. | Priorizar o suporte ou romper seu efeito. |
| Saqueador da Mata *(novo)* | Defesa reativa. | Ergue escudo improvisado e fica vulnerável ao baixar a guarda. | Esperar a abertura ou aplicar skill de ruptura. |
| Xamã de Esporos *(novo)* | Sustentação de grupo. | Nuvem visível antes de fortalecer o grupo. | Interromper/priorizar o conjurador; sem dano inevitável ao longo do tempo. |
| Sentinela de Raízes *(novo)* | Tanque de linha. | Raízes se fecham antes de uma postura defensiva. | Ruptura de guarda ou dano persistente fora da defesa. |
| Lobo de Sombra *(novo)* | Predador veloz. | Silhueta/olhos denunciam a investida. | Proteção da retaguarda e contra-ataque depois da corrida. |

Os nomes dos quatro inimigos novos vêm como candidatos do banco de ideias; seus comportamentos e presença em cada fase são propostas novas. Definir controle de alvo, efeitos e telegraphs no contrato de gameplay antes de codificar.

## Encontros de chefe

Todos os chefes precisam ter telegraph, janela de resposta, rota alternativa de progressão e métrica de sucesso. O kit abaixo descreve a leitura pretendida, não a implementação.

### Matriarca do Micélio — minichefe proposto

- **Leitura:** alterna proteção do micélio com ataques diretos; o brilho da coroa de fungos anuncia cada janela.
- **Lição:** suporte inimigo pode ser removido antes de tentar vencer por força bruta.
- **Rotas possíveis:** interromper com a skill de ruptura, manter pressão em alvo único, ou melhorar sobrevivência e vencer após a janela de proteção.
- **Recompensa proposta:** primeira peça ou material temático garantido; não criar moeda nova sem definir source e sink.

### Lobo Alfa de Lúmen — elite existente

- **Leitura:** investida anunciada; depois dela o Alfa fica exposto. Uma chamada de matilha pode ser representada por fortalecimento do próximo inimigo, sem exigir combate simultâneo.
- **Lição:** Bastião sustenta a investida; Flecha/Íris aproveitam a abertura.
- **Recompensa proposta:** item ou progresso garantido na primeira vitória, mais loot normal sujeito a balanceamento.

### Guardião-Cervo de Pedra — boss final existente

- **Fase A, Vigília:** movimentos pesados de galhadas e raízes anunciados; a party precisa sustentar o combate e escolher quando concentrar dano.
- **Fase B, Lúmen Desperto:** muda a sequência e abre uma janela de vulnerabilidade após um ataque amplo. A troca de fase deve ser visual e compreensível.
- **Lição:** composição, defesa e skills podem superar o gate por caminhos diferentes; não resolver com uma checagem opaca de poder.
- **Recompensa proposta:** marco de conclusão e uma recompensa determinística relevante; valores, item exato e replay do boss ficam em aberto.

## Skills dos heróis — cinco conceitos por herói

O catálogo proposto agora contém **15 skills: cinco para cada herói**. São conceitos automáticos e legíveis; não significam que todas serão equipadas ao mesmo tempo. A quantidade de slots de skill, a seleção do jogador, os unlocks, cooldowns, potência, duração e alvos continuam **EM ABERTO** e precisam de teste. Nenhuma skill deve exigir toques repetitivos.

| Herói | Skill | Efeito pretendido | Sinergia/uso |
| --- | --- | --- | --- |
| **Bastião** | **Amparo de Raiz** | Quando um aliado fica em risco, concede proteção temporária a ele. | Ajuda a party a atravessar investidas do Javali, Alfa e Guardião. |
|  | **Contra-golpe de Casca** | Após defender um golpe anunciado, responde e reduz a guarda do inimigo por uma janela curta. | Abre oportunidade para Flecha e Íris; contra a Sentinela e o Alfa. |
|  | **Desafio do Guardião** | Atrai para Bastião um ataque que atingiria um aliado mais frágil. | Protege a retaguarda de investidas do Lobo de Sombra e ataques de chefe. |
|  | **Trama de Escudos** | Uma proteção aplicada a um aliado deixa uma proteção menor nos demais. | Combina sobrevivência da party com a skill Amparo de Raiz; pode ser escolha de defesa em área. |
|  | **Voto da Clareira** | Depois de resistir a uma sequência de golpes, Bastião fortalece a próxima defesa ou contra-ofensiva da party. | Recompensa sobreviver à janela de pressão sem tornar a luta passiva. |
| **Flecha** | **Marca da Caçada** | Marca o alvo prioritário; a party recebe uma oportunidade de dano coordenado. | Cria alvo comum e prepara skills/itens da Íris. |
|  | **Tiro de Ruptura** | Disparo concentrado que aproveita a marca ou uma postura defensiva aberta. | Resposta a Xamã, Sentinela e Matriarca. |
|  | **Rajada da Copa** | Dispara uma sequência curta contra um único alvo, com ataques individuais legíveis. | Pressiona janelas de vulnerabilidade de elite e boss sem exigir vários inimigos simultâneos. |
|  | **Flecha de Execução** | Prioriza um alvo ferido e ganha força quando ele se aproxima da derrota. | Acelera a limpeza de inimigos frágeis; a condição exata não está definida. |
|  | **Passo do Rastro** | Após esquivar de um golpe anunciado, dispara um contra-ataque. | Cria uma opção mais arriscada/ofensiva contra Javali, Lobo de Sombra e chefe. |
| **Íris** | **Lança de Lúmen** | Ataque mágico concentrado com bônus contra o alvo marcado ou exposto. | Converte setup da Flecha/Bastião em dano de chefe. |
|  | **Véu de Micélio** | Aplica uma proteção curta à party, acionada por uma condição visível de perigo. | Sustenta lutas longas e oferece uma rota defensiva. |
|  | **Fratura Arcana** | Enfraquece temporariamente a defesa de um inimigo protegido. | Resposta ao Saqueador, Sentinela e Matriarca; prepara dano dos outros heróis. |
|  | **Pulso Restaurador** | Recupera um aliado em condição crítica. | Opção de recuperação direta, distinta do escudo do Véu de Micélio. |
|  | **Prisma de Retorno** | Um ataque mágico bem-sucedido contra alvo marcado deixa energia para um disparo seguinte mais forte. | Liga setup da Flecha à magia da Íris; cria sequência, sem recurso/moeda manual. |

**Recomendação de implementação:** manter as 15 skills no catálogo de design e testar primeiro uma skill automática por herói. Liberar as demais em marcos posteriores ou como escolhas de build, depois de definir slots, UI e pacing. Não criar árvore extensa, energia ou custo de skill sem demonstrar que acrescentam decisões úteis.

## Equipamentos — catálogo total de 30 itens

O catálogo proposto fica com **30 itens distintos: os 15 existentes do MVP mais 15 novos candidatos para aprofundar o Capítulo 1**. Os três slots e as quatro raridades atuais são mantidos; não se adicionam slots, raridades ou moedas nesta proposta. Os 15 itens novos estão distribuídos em cinco armas, cinco armaduras e cinco amuletos. Todos os nomes e efeitos novos são hipóteses: valores, raridades e taxas de obtenção ficam para o balanceamento.

### Os 15 itens existentes do MVP

| Slot | Itens existentes |
| --- | --- |
| Arma (5) | Adaga de Luz; Espada de Musgo; Lâmina Silvestre; Machado Ancestral; Cajado de Lúmen. |
| Armadura (5) | Túnica de Folhas; Gibão de Casca; Couraça de Javali; Placa Rochosa; Armadura do Guardião. |
| Amuleto (5) | Pedra Polida; Semente Vital; Colar de Espíritos; Amuleto do Cervo; Coração da Floresta. |

### 15 candidatos novos para o Capítulo 1

| Slot | Item candidato | Herói/build que apoia | Efeito de design pretendido |
| --- | --- | --- | --- |
| Arma | **Maça da Raiz-Clara** | Bastião — defesa e resposta | Fortalece o contra-golpe após uma defesa bem-sucedida. |
| Arma | **Arco da Copa Silente** | Flecha — marca e precisão | Melhora a janela de dano contra o alvo marcado. |
| Arma | **Cetro do Veio Âmbar** | Íris — magia e foco | Lança de Lúmen aproveita melhor alvos expostos. |
| Arma | **Lâmina da Trilha Partida** | Build física — sequência | Converte uma defesa inimiga quebrada em oportunidade de ataques rápidos. |
| Arma | **Ramo de Pedra-Runa** | Build de magia — ruptura | Fratura Arcana abre uma janela para dano concentrado da party. |
| Armadura | **Couraça de Casca Musgosa** | Bastião — resistência | Ajuda a suportar uma investida sem anular a necessidade de se defender. |
| Armadura | **Jaqueta do Rastro Longo** | Flecha — sobrevivência | Evita que a retaguarda seja uma fraqueza automática contra predadores rápidos. |
| Armadura | **Manto de Micélio Trançado** | Íris — sustentação | Reforça a proteção do Véu de Micélio. |
| Armadura | **Peitoral do Vigia Caído** | Bastião — defesa reativa | Converte parte da pressão de golpes anunciados em proteção para a party. |
| Armadura | **Capa da Névoa Verde** | Flecha — evasão | Favorece a resposta ofensiva depois de evitar um golpe. |
| Amuleto | **Nó dos Marcos Antigos** | Bastião — proteção da party | Recompensa proteger um aliado em perigo. |
| Amuleto | **Presa da Matilha** | Flecha — foco de alvo | Favorece uma build de precisão contra elite/boss. |
| Amuleto | **Semente do Veio Vivo** | Íris — sustentação | Conecta magia e recuperação sem criar uma quarta moeda ou recurso. |
| Amuleto | **Broche do Eco Claro** | Builds coordenadas | Recompensa a sequência Marca da Caçada → skill aliada. |
| Amuleto | **Dente de Basalto** | Build defensiva | Favorece contra-ataques depois de resistir a um golpe forte. |

Os 15 itens continuam sendo o catálogo candidato do capítulo, não uma ordem de drops obrigatória. Todos devem ser conquistáveis jogando. Um craft futuro pode transformar drops repetidos em progresso previsível, mas precisa de source, sink, fórmula e teste próprios antes de entrar no capítulo.

## Desbloqueios e ritmo

| Marco | O que o jogador aprende/ganha | Estado |
| --- | --- | --- |
| Primeiros encontros | Reconhecer ataques comuns e o próximo objetivo. | Reusar onboarding existente; validar com jogadores. |
| Entrada → Clareira | Receber uma skill automática inicial por herói e aprender a ler seu gatilho. | **Hipótese**; definir gate após medir ritmo. |
| Clareira → Ninho | Primeiro encontro combinado de suporte + ameaça pesada; ensinar prioridade de alvo. | **Hipótese.** |
| Vitória da Matriarca/Elite | Recompensa determinística que abre uma resposta de build. | **Hipótese**; definir item/material após revisar inventário e economia. |
| Vitória no Santuário | Fechar o capítulo e abrir próxima decisão/campanha. | **Em aberto**; próximo destino não está escolhido aqui. |

Não fixar minutos, nível requerido, XP, ouro ou kill count com as propostas de referência do guia. Usar essas métricas como perguntas de playtest, não requisitos finais.

## Economia, balanceamento e critérios de aceite

Este documento não declara os itens ou bosses balanceados. Antes de implementar números:

1. Registrar fórmula e faixa inicial de HP/dano/XP/recompensa para inimigos, subfases e skills.
2. Para cada item/recurso, declarar fonte (*source*) e saída (*sink*); manter inicialmente XP e ouro, sem moeda nova.
3. Simular o início, o meio e o boss do capítulo, incluindo party/gear improvisados e builds propostas.
4. Medir TTK por encontro, tentativas/vitórias do boss, XP/h, ouro/h, drops úteis/h, tempo até upgrade/unlock e participação de build.
5. Rodar playtest humano sem explicar a interface e observar leitura de ameaça, escolha de alvo/gear e clareza do próximo marco.
6. Ajustar e repetir; simulação elimina extremos, mas não substitui a sensação de jogo.

**Gate de design do Capítulo 1 — PASS quando:**

- cinco fases macro e subfases estiverem aprovadas, com função clara e progressão sem repetição vazia;
- cada inimigo e chefe tiver leitura visual, resposta viável, recompensa e lugar na curva;
- catálogo conter 30 itens (15 existentes e 15 novos) e 15 skills propostas (cinco por herói), com rotas de build distintas para atravessar os chefes;
- fórmulas, sources/sinks, hipóteses e métricas estiverem registradas;
- artefatos preservarem identidade original e o conteúdo puder ser aprovado sem depender de arte ainda bloqueada pelo ART-0.

Após esse gate, a próxima fatia será definir schemas/dados e implementar um segmento curto vertical do capítulo; a produção de arte continua sujeita ao gate ART-0 vigente.
