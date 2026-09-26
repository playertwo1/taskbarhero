<!-- Fonte original: [GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx) -->

# **POCKET HERO**

## **Guia de Referência do TBH para Criação por IA**

*Mecânicas · fases · heróis · itens · loot · progressão · pets · crafting · comunidade · princípios do nosso jogo*

> DECISÃO DE PRODUTO DO POCKET HERO
> Nosso jogo será gratuito e toda progressão jogável será conquistada dentro do próprio jogo. Não haverá classes pagas, itens pagos, pets pagos, espaços de inventário pagos, boosts de poder pagos, mercado por dinheiro real nem necessidade de compra para avançar. A IA deve tratar essa regra como requisito de produto, não como sugestão.

Versão 1.0 · 26 de setembro de 2026

# 1. Como a IA deve usar este documento

Este documento existe para orientar Hermes, Theia, Daedalus, Ergane, Têmis, Research e qualquer modelo usado no projeto (Claude, ChatGPT ou Antigravity). Ele não é um pedido para clonar TBH: Task Bar Hero. É uma análise estruturada do jogo de referência, combinada com decisões próprias do Pocket Hero.

- Fatos oficiais devem ser preferidos quando Steam/Nugem Studio os publicarem.

- Dados do TBH Index são úteis para escala e estrutura, mas são de um site não oficial que declara usar dados extraídos dos arquivos do jogo.

- TaskBarHero Wiki e Mobalytics devem ser usados como referências de organização, guias e entendimento de sistemas.

- Steam Reviews e Reddit representam experiências individuais e tendências da comunidade; nunca devem ser tratados como especificação oficial.

- Nenhuma sprite, nome distintivo, UI, mapa, texto, tabela de balanceamento ou asset do TBH deve ser copiado.

- A IA deve traduzir princípios, não reproduzir conteúdo.

> Regra de ouro
> Sempre marcar internamente se uma decisão veio de: (A) fonte oficial; (B) dado de comunidade/datamining; (C) feedback de jogadores; ou (D) decisão original do Pocket Hero.

# 2. Hierarquia das fontes

| ID | Fonte | Tipo | Uso permitido |
| --- | --- | --- | --- |
| S1 | Steam — página oficial de TBH | Oficial | Descrição, 3 atos, 4 dificuldades, 500+ itens, 50+ monstros, 10 raridades, free-to-play, DLCs/mercado. |
| S2 | Nugem Studio — site oficial | Oficial | Posicionamento do estúdio, 546.130 pico simultâneo, 500+ itens, 50+ monstros, conceito de aventura mínima. |
| S3 | Steam — página de DLC | Oficial | Priest gratuito; Hunter/Slayer pagos no TBH; packs pagos de pets, stash e Trade Ship. |
| S4 | TBH Index | Não oficial / datamining declarado | 1.576 equipamentos, 143 materiais, 248 runas, 74 monstros, 189 estágios na base v1.2.0; heróis, stats, drops. |
| S5 | TaskBarHero.org Wiki | Comunidade | Campanha 3×10×4, nomes das fases, bosses, níveis, Soul Stones e estrutura de estágios. |
| S6 | Mobalytics | Guias/terceiro | Loop iniciante, party, runas, Cube, pets, offline, progressão e Plaguelands. |
| S7 | Steam Community Reviews/Discussions | Opinião de usuários | Elogios ao conceito/passividade; críticas a grind, loot, QoL e economia/mercado. |
| S8 | Reddit | Opinião de usuários | Relatos de progressão lenta, necessidade de farm e troca de builds. |

# 3. Descrição mais fiel do TBH

TBH: Task Bar Hero é um RPG idle/hack-and-slash em pixel art construído para ocupar uma faixa mínima da tela. Os heróis lutam automaticamente, ganham XP, ouro, baús e equipamentos enquanto o usuário trabalha ou utiliza outros programas. A profundidade está menos no controle direto do combate e mais na construção da party, skills, runas, equipamento, crafting, escolha da fase, gerenciamento de inventário e otimização da eficiência de farm.

A página oficial da Steam descreve o produto como um 'tiny idle RPG' com experiência hack-and-slash completa em uma janela pequena, combinação de classes, itens e skills, Cube System, 3 atos e 4 dificuldades. Também anuncia 500+ itens, 50+ tipos de monstros e 10 raridades de equipamento. [S1]

O site oficial da Nugem Studio reforça a proposta de 'small games, big worlds', informa 546.130 jogadores simultâneos no pico e destaca 500+ itens colecionáveis e 50+ monstros. [S2]

# 4. O princípio central: baixo atrito, alta profundidade

| Camada | O que acontece | Por que funciona |
| --- | --- | --- |
| Combate visível | Heróis avançam e combatem automaticamente em uma faixa lateral. | Dá vida à tela sem exigir atenção constante. |
| Interação curta | Abrir baú, trocar item, mudar build, escolher fase. | Sessões de segundos/minutos. |
| Meta-jogo | Party, skills, runas, Cube, pets e farming. | Mantém profundidade para quem quer otimizar. |
| Progressão passiva | XP/ouro continuam com baixa intervenção. | Combina com trabalho e outras atividades. |
| Otimização | Jogador compara clear speed, sobrevivência, XP/h e loot. | Transforma passividade em decisão estratégica. |

# 5. Loop de jogo de referência

```
Escolher fase
  ↓
Party entra na faixa
  ↓
Combate automático
  ↓
Ondas / mini-encontros / boss
  ↓
XP + ouro + baús + equipamento
  ↓
Comparar e equipar loot
  ↓
Skills / runas / Cube / party
  ↓
Ficar mais forte
  ↓
Avançar ou voltar para farmar
  ↓
Repetir com eficiência maior
```

Mobalytics descreve explicitamente o comportamento de voltar a fases anteriores quando há um muro de dificuldade, farmar gear e níveis e retornar depois mais forte. Também recomenda auto-retry e priorização de slots adicionais de herói. [S6]

# 6. Campanha e fases do TBH — dados de referência

A TaskBarHero Wiki descreve a campanha-base como 3 atos × 10 fases × 4 dificuldades = 120 fases. As dificuldades listadas são Normal, Nightmare, Hell e Torment. Cada ato termina em um boss e usa Soul Stone como chave; segundo a wiki e Mobalytics, a Soul Stone só é consumida quando o boss é derrotado. [S5][S6]

| Ato | Progressão visual das fases (Normal) | Boss |
| --- | --- | --- |
| Ato 1 — Green Fields & Cursed Lands | Pasture → Shadow Meadow → Wasteland → Eerie Canyon → Burning Village Entrance → Rumstreet Square → City Outskirts → Cemetery → Cursed Land → Throne of Darkness | Skeleton King |
| Ato 2 — Desert & Tombs | Oasis Road → Sandstorm Valley → Desert Underground Cave → Bug Nest → Scorching Dunes → Sunset Ruins → Midnight Sands → Sacred Tomb → Pharaoh's Crypt → Pharaoh's Underchannel | Desert Overlord |
| Ato 3 — Frozen Wastes & Hell | Snowbound Outpost → Frozen Battlefield → Glacial Cave Entrance → Frozen Glacier Cavern → Hell Gate → Burning Ravine → Plains of Torment → Citadel of Ruin → Core of the Abyss → Hell Command Chamber | Archon Morkar |

## 6.1 O que aprender com a estrutura de fases

- Cada ato tem uma identidade visual macro, mas muda de subtema dentro do próprio ato.

- A fase 10 funciona como marco/boss, criando um objetivo claro para cada arco.

- A mesma geometria conceitual pode reaparecer em dificuldades maiores, reduzindo custo de arte.

- Mudar composição de inimigos, modificadores e recompensas é mais econômico do que criar mapas totalmente novos.

- Soul Stone mostra um bom padrão de 'chave de tentativa sem punição': só consumir ao vencer reduz frustração.

## 6.2 Tradução para o Pocket Hero

Para o nosso MVP, não copiar 30 fases. Começar pequeno: 1 bioma com 5 fases funcionalmente diferentes (entrada, pressão, farm/ninho, elite e boss). Quando o loop estiver validado, expandir para novos biomas.

# 7. Heróis, classes e party

TBH possui seis heróis/classes: Knight, Ranger, Sorcerer, Priest, Hunter e Slayer. O TBH Index registra árvores de skill em oito tiers e party de até três heróis. [S4]

| Classe TBH | Arquétipo | Função percebida | Lição visual |
| --- | --- | --- | --- |
| Knight | Melee / frontline | Tanque, absorção de dano | Silhueta robusta, frente da party |
| Ranger | Ranged DPS | Velocidade/clear | Arco e distância |
| Sorcerer | Ranged magic/AoE | Dano em área/elemental | Casting e efeitos |
| Priest | Support/Tank | Cura, buffs, sustentação | Suporte e proteção |
| Hunter | Ranged/control | Crossbow, traps, controle | Ferramentas/armadilhas |
| Slayer | Melee/burst | Pressão corpo a corpo | Arma grande/agressividade |

> Diferença obrigatória no Pocket Hero
> No TBH atual, a Steam mostra Priest como DLC gratuito e Hunter/Slayer como DLC pagos, além de outros pacotes pagos. No Pocket Hero, nenhuma classe será paga. Todos os heróis serão liberados exclusivamente por progressão, desafios, história, conquistas ou recursos obtidos jogando. [S3]

# 8. Monstros e famílias

O TBH Index registra 74 monstros e bosses após a atualização v1.2.0, incluindo variantes como goblin, goblin thief, goblin shaman, orc/orc warrior/elite orc, famílias de esqueletos, ratfolk, insetos, kobolds, criaturas de gelo, demônios e versões contaminadas de bosses. [S4]

| Padrão observado | Exemplos TBH | Como usar sem copiar |
| --- | --- | --- |
| Família com base comum | Goblin → Thief → Shaman | Criar sprite-mãe própria e variar arma, postura e função. |
| Escalonamento de força | Orc → Orc Warrior → Elite Orc | Reutilizar linguagem visual com proporção/armadura crescente. |
| Função por equipamento | Skeleton → Archer → Warrior | Mesma anatomia, leitura imediata pelo equipamento. |
| Elemental/bioma | Fire Elemental, Yeti, Lava Being | Monstro deve comunicar o ambiente e ameaça em poucos pixels. |
| Boss contaminado | Contaminated Skeleton King etc. | Criar variantes mutantes próprias no endgame. |

# 9. Loot, equipamentos e raridades

A Steam anuncia 500+ itens únicos. O TBH Index, usando sua base dataminada da v1.2.0, lista 1.576 equipamentos e 143 materiais. A diferença é esperada: a Steam descreve o produto de forma comercial e a base comunitária acompanha conteúdo posterior e variações. [S1][S4]

| Ordem | Raridade TBH | Lição |
| --- | --- | --- |
| 1 | Common | Escada longa de expectativa; sempre existe um degrau acima. |
| 2 | Uncommon | Escada longa de expectativa; sempre existe um degrau acima. |
| 3 | Rare | Escada longa de expectativa; sempre existe um degrau acima. |
| 4 | Legendary | Escada longa de expectativa; sempre existe um degrau acima. |
| 5 | Immortal | Escada longa de expectativa; sempre existe um degrau acima. |
| 6 | Arcana | Escada longa de expectativa; sempre existe um degrau acima. |
| 7 | Beyond | Escada longa de expectativa; sempre existe um degrau acima. |
| 8 | Celestial | Escada longa de expectativa; sempre existe um degrau acima. |
| 9 | Divine | Escada longa de expectativa; sempre existe um degrau acima. |
| 10 | Cosmic | Escada longa de expectativa; sempre existe um degrau acima. |

A IA não deve copiar nomes de itens. O valor está no princípio: loot frequente + raridade legível + chance de um drop excepcional + itens com combinação de stats capaz de mudar a build.

## 9.1 Modelo recomendado para nosso MVP

| Slot | Quantidade inicial | Exemplos de stats próprios |
| --- | --- | --- |
| Arma | 5 | ATK, attack speed, crit, elemento |
| Armadura | 5 | HP, DEF, regen, resistência |
| Amuleto | 5 | crit, life steal, XP, ouro, efeitos especiais |

Raridades do MVP: Comum → Raro → Épico → Lendário. Outras raridades só entram quando houver necessidade real de expansão.

# 10. Cube, crafting e reciclagem do loot

No TBH, o Cube concentra sistemas de crafting e transformação. O TBH Index descreve o crafting como escolha de slot + tier de receita + materiais/ouro, resultando em um item aleatório daquele slot conforme probabilidades de raridade. Mobalytics também descreve síntese, alchemy e outros módulos do Cube. [S4][S6]

| Problema de design | Solução observada | Nossa adaptação |
| --- | --- | --- |
| Loot ruim vira lixo | Cube dá usos alternativos | Desmontar/reciclar em materiais ou XP de forja. |
| Progressão trava | Crafting/synthesis cria outra rota | Receitas conquistadas jogando. |
| Inventário lota | Alchemy/transformação | Auto-salvage desbloqueável por progressão. |
| Build não fecha | Crafting por slot | Permitir foco em categoria sem vender chance por dinheiro. |

> Política do Pocket Hero
> Não vender crafting, re-rolagem, probabilidades, materiais, slots ou tentativas por dinheiro real. Toda melhoria do sistema deve vir de gameplay.

# 11. Runas e meta-progressão

Mobalytics descreve as runas como árvore permanente da conta, cobrindo party size, stats, chest chance, inventário, ouro, XP e automações. O TBH Index registra 248 runas após a atualização v1.2.0. [S4][S6]

Para nosso jogo, o insight não é criar centenas de nós no início. É separar progressão do personagem da progressão da conta. O MVP pode ter uma árvore pequena com slots de party, qualidade de offline, inventário e eficiência.

# 12. Pets/companheiros

Mobalytics descreve pets como bônus persistentes desbloqueados por milestones de kills — 5.000 derrotas do inimigo correspondente em vários casos — com bônus como chance de baú, drop de boss e ouro por kill. [S6]

> Nossa regra
> Pets/Ecos do Pocket Hero serão obtidos por milestones, exploração, bosses, coleção ou conquistas. Nunca vendidos. Se houver um pet visualmente equipado, bônus de conta não precisam obrigar o jogador a usar visual específico.

# 13. Idle e progresso offline

A proposta oficial é permitir que a aventura continue automaticamente e seja confortável ao lado de outros programas. [S1] Mobalytics observa que o TBH fornece XP e ouro offline, mas que chests não caem no offline segundo seu guia de junho de 2026. [S6]

No Pocket Hero, vamos usar o conceito, não a limitação: offline deve dar recompensa útil, mas controlada. O MVP pode limitar a 8 horas e simular XP/ouro com loot reduzido. A regra exata deve ser balanceada com telemetria local.

# 14. Endgame e Plaguelands

Mobalytics descreve Plaguelands como sistema de endgame que usa Corruption como entrada e oferece chance maior de itens muito raros. O TBH Index também registra monsters/bosses contaminados e expansão do banco de estágios na v1.2.0. [S4][S6]

Para o Pocket Hero, isso inspira o 'Eco Corrompido': transformar biomas existentes com mutações, modificadores, paleta e rewards maiores. Não deve existir recurso de entrada comprado com dinheiro.

# 15. O que os jogadores elogiam

Avaliações recentes da Steam elogiam especialmente o conceito criativo de um idle na taskbar, a leveza, a possibilidade de deixar rodando enquanto se faz outra coisa e a diversão de montar builds. Há jogadores com centenas ou mais de mil horas registradas que destacam que o tempo de interação real é muito menor porque o jogo roda passivamente. [S7]

- Conceito 'sempre presente' sem sequestrar a tela.

- Charme visual e leitura rápida.

- Progressão inicial satisfatória.

- Teoria de builds e necessidade de ajustar composição em paredes de dificuldade.

- Longos períodos de farm compatíveis com atividades paralelas.

# 16. O que os jogadores criticam — e como evitar

| Problema observado | Evidência da comunidade | Diretriz Pocket Hero |
| --- | --- | --- |
| Progressão tardia lenta demais | Steam Reviews relatam estagnação depois do cap/late game. | Sempre oferecer pelo menos duas rotas de progresso: gear + meta-progressão + crafting. |
| RNG excessivo | Jogadores citam semanas/centenas de horas sem upgrade. | Pity, crafting direcionado e progresso determinístico parcial. |
| Drop/baús inconsistentes | Discussões relatam sensação de travamento por loot. | Garantir piso de recompensa por tempo/ondas. |
| Mercado/bots/dinheiro real | Parte da comunidade critica economia e monetização. | Não ter mercado real, itens pagos nem vantagem comprável. |
| QoL insuficiente | Reviews citam grind mais tedioso do que necessário. | Auto-loot, filtros, auto-retry e gestão simples desbloqueáveis jogando. |
| Conteúdo endgame pouco recompensador | Plaguelands é elogiado como conceito, mas criticado por custo/retorno por alguns usuários. | Medir XP/h, ouro/h e item/h para calibrar risco/recompensa. |

# 17. Doutrina de produto do Pocket Hero

> REQUISITO FIXO — 100% conquistável no jogo
> O Pocket Hero será gratuito. Tudo que afeta gameplay deve ser obtido jogando. Nenhum herói, classe, arma, armadura, pet, skill, runa, fase, boss, espaço de inventário, boost, material, reroll ou aumento de drop pode depender de pagamento.

| Sistema | TBH pode ter | Pocket Hero deve ter |
| --- | --- | --- |
| Classes | Algumas DLCs pagas | Todas conquistáveis jogando. |
| Pets | Há pets em Supporter Pack | Todos via objetivos/milestones. |
| Stash | Pack pago de páginas extras | Expansão por progressão/quests. |
| Mercado | Steam Market / Trade Ship | Sem mercado por dinheiro real. |
| Trade slots | DLC de slots | Se existir troca, capacidade conquistada jogando. |
| Poder | Pode ser acelerado por compras indiretas/mercado | Zero vantagem comprável. |
| Conteúdo | DLCs/packs | Toda campanha, herói e sistema liberável no jogo. |

Este documento não define monetização alternativa. Se algum modelo sugerir anúncios, cosméticos pagos, battle pass, assinatura ou qualquer forma de receita, isso deve ser tratado como proposta separada e exigir decisão humana explícita. Não incluir no MVP por padrão.

# 18. Instruções para a IA ao criar o nosso jogo

1. Começar sempre pela experiência: 'aventura acontecendo ao lado do usuário', não por quantidade de sistemas.

1. Usar TBH como referência de estrutura, nunca como blueprint literal.

1. Para cada novo sistema, registrar: problema do jogador → solução proposta → métrica de sucesso.

1. Preferir conteúdo original com famílias reutilizáveis de sprites e variações.

1. Produzir primeiro um vertical slice antes de expandir conteúdo.

1. Manter o combate legível em uma faixa pequena de tela mobile.

1. Evitar paredes de progressão sem alternativa. Se gear travar, crafting/meta-progression deve continuar avançando.

1. Criar proteção contra RNG extremo: pity, crafting direcionado, garantias por milestones ou progresso acumulativo.

1. Toda automação/QoL relevante deve ser conquistada por gameplay, não comprada.

1. Nunca introduzir classes, loot, pets, storage ou poder pago.

1. Registrar claramente quando uma ideia é inspirada por TBH, comunidade ou criada originalmente.

1. Têmis deve auditar originalidade visual/naming e coerência com a doutrina free-progression.

# 19. Tradução proposta para o Pocket Hero

Esta tabela é referência de design, não lista de critérios aprovados. Para escopo e aceite do MVP, prevalece o [`ROADMAP.md`](../ROADMAP.md), especialmente R18 (build candidata) e R19 (auditoria). O roadmap já fixa 15 itens, três slots e quatro raridades em R13 e o limite offline inicial de 8h em R15; esses parâmetros devem ser testados, mas não são opcionais neste plano. A distribuição 5/5/5, crafting e meta-progressão são propostas a validar, não gates automáticos do MVP.

| Elemento | Proposta para Pocket Hero (sujeita ao roadmap) |
| --- | --- |
| Formato | Mobile portrait; faixa de batalha visível na parte inferior. |
| Bioma | Bosque de Lúmen. |
| Fases | 5: Entrada, Pressão, Ninho/Farm, Elite, Boss. |
| Heróis | Bastião, Flecha, Íris. |
| Mobs | Geleia de Lúmen, Gremlin de Folha, Javali de Musgo, Espírito de Raiz. |
| Elite | Variante própria do bioma. |
| Boss | Guardião-Cervo de Pedra. |
| Itens | 15 (5 armas, 5 armaduras, 5 amuletos). |
| Raridades | Comum, Raro, Épico, Lendário. |
| Party | Até 3 heróis. |
| Progressão | XP, level, ouro, equipamento; meta-progressão pequena é candidata futura. |
| Crafting | Reciclagem + crafting são propostas; não são gate do MVP. |
| Offline | Até 8h inicialmente, com recompensa balanceada. |
| Tracker | XP/h, ouro/h, kills/h, TTK, drops/h. |
| Monetização | Nenhuma no MVP; 100% do conteúdo conquistável dentro do jogo. |

# 20. Matriz: de onde cada ideia veio

| Ideia | Origem | Uso no Pocket Hero |
| --- | --- | --- |
| Janela/faixa mínima + idle | Steam/Nugem [S1][S2] | Adaptar para mobile e futura sobreposição. |
| 3 atos / 4 dificuldades | Steam [S1] + Wiki [S5] | Usar biomas próprios; começar com 1 bioma/5 fases. |
| Party de até 3 | TBH Index/Mobalytics [S4][S6] | Bastião + Flecha + Íris. |
| Seis arquétipos/classes | TBH Index/Mobalytics [S4][S6] | Criar heróis próprios com funções equivalentes, nomes/sprites originais. |
| 10 raridades | Steam/TBH Index [S1][S4] | MVP com 4 raridades; expansão posterior. |
| Cube/crafting | TBH Index/Mobalytics [S4][S6] | Forja/reciclagem própria; sem dinheiro real. |
| Runas permanentes | TBH Index/Mobalytics [S4][S6] | Meta-progressão original como hipótese futura, não requisito do MVP. |
| Pets por kills | Mobalytics [S6] | Ecos por milestones; todos gratuitos. |
| Soul Stone consumida só no sucesso | Wiki/Mobalytics [S5][S6] | Inspiração para chaves de boss sem punição por tentativa. |
| Plaguelands | Mobalytics/TBH Index [S6][S4] | Eco Corrompido pós-MVP. |
| Tracker/otimização | Comunidade + guias [S6][S7] | Tracker nativo local. |
| Evitar grind excessivo | Steam/Reddit [S7][S8] | Progresso determinístico e múltiplas rotas. |

# 21. Banco inicial de conteúdo original

| Bioma próprio | Leitura visual | Famílias originais | Boss |
| --- | --- | --- | --- |
| Bosque de Lúmen | Musgo, ruínas, cristais verdes, vaga-lumes | Geleias, gremlins de folha, javalis de musgo, espíritos de raiz | Guardião-Cervo de Pedra |
| Distrito Cinzento | Vila queimada, cemitério, torre quebrada | Saqueadores, ossudos, corvos de cinza, espectros | Marechal das Cinzas |
| Mar de Vidro | Deserto vítreo, cavernas, templo | Serpentes, insetos de cristal, nômades | Imperatriz Escorpião |
| Espinha do Inverno | Neve, minas, grutas glaciais | Lobos de gelo, sentinelas, magos de geada | Titã da Geada |
| Fortaleza Rubra | Lava, muralhas, fornalhas | Imps, elementais, cavaleiros, sacerdotes | General da Fornalha |
| Eco Corrompido | Violeta/preto, glitches orgânicos | Variantes mutantes + aberrações | Versão corrompida de bosses próprios |

# 22. Checklist de auditoria para qualquer nova ideia

- ☐ A ideia resolve um problema real do jogador ou só aumenta complexidade?

- ☐ É original em naming, visual e lore?

- ☐ Está inspirada em princípio ou copiando conteúdo?

- ☐ É 100% conquistável jogando?

- ☐ Introduz alguma vantagem paga direta ou indireta? Se sim: FAIL.

- ☐ Cria parede de RNG sem progresso alternativo? Se sim: revisar.

- ☐ Funciona em tela mobile pequena?

- ☐ Pode ser implementada em lote com o pipeline de sprites?

- ☐ Possui métrica de balanceamento/telemetria local?

- ☐ Pode ser retirada sem quebrar o core loop?

# 23. Referências verificadas

| ID | Fonte | URL | Nota |
| --- | --- | --- | --- |
| S1 | Steam — TBH: Task Bar Hero | https://store.steampowered.com/app/3678970/ | Página oficial do jogo; acessada em 26/09/2026. |
| S2 | Nugem Studio — site oficial | https://www.nugemstudio.com/ | Dados do estúdio e métricas públicas; acessada em 26/09/2026. |
| S3 | Steam — DLC de TBH | https://store.steampowered.com/dlc/3678970/TBH_Task_Bar_Hero/ | Classes/packs atuais; acessada em 26/09/2026. |
| S4a | TBH Index — Wiki geral | https://tbhindex.com/wiki | Base não oficial; declara dados dataminados da v1.2.0. |
| S4b | TBH Index — Heroes | https://tbhindex.com/wiki/heroes | Seis heróis, skill tiers, party. |
| S4c | TBH Index — Monsters | https://tbhindex.com/wiki/monsters | 74 monstros/bosses e famílias. |
| S4d | TBH Index — Crafting | https://tbhindex.com/wiki/crafting | Crafting do Cube. |
| S5 | Task Bar Hero Wiki — Stages | https://taskbarhero.org/en/stages/ | 3×10×4, nomes das fases, bosses, levels. |
| S6a | Mobalytics — Beginner Guide | https://mobalytics.gg/gamebase/guides/taskbar-hero-beginner-guide | Party, runas, Cube, progressão, offline. |
| S6b | Mobalytics — Pets Guide | https://mobalytics.gg/gamebase/guides/task-bar-hero-pets | Pets e unlocks por kills. |
| S6c | Mobalytics — Plaguelands | https://mobalytics.gg/gamebase/profile/imortilize/guides/plaguelands-update-task-bar-hero-tbh | Endgame/Corruption. |
| S7a | Steam Community — Reviews | https://steamcommunity.com/app/3678970/reviews/ | Percepção de jogadores, positiva e negativa. |
| S7b | Steam Community — Positive Reviews | https://steamcommunity.com/app/3678970/positivereviews/?browsefilter=toprated | Elogios ao conceito e passividade. |
| S8 | Reddit — discussão de progressão lenta | https://www.reddit.com/r/TaskBarHeroes/comments/1tz4wl5/why_am_i_progressing_so_slowly/ | Relato comunitário; não oficial. |

# 24. Limitações e cuidados de uso das fontes

- Dados de wikis e guias podem ficar desatualizados após patches.

- TBH Index se declara não oficial, embora informe que lê dados dos arquivos do jogo.

- Reviews e Reddit são amostras autoselecionadas e não representam todos os jogadores.

- Existem conflitos entre fontes secundárias sobre DLCs; para estado atual de compra, usar Steam como autoridade.

- Números exatos de balanceamento do TBH não devem ser copiados para o Pocket Hero.

- A estrutura econômica do TBH envolvendo Steam Market e conteúdo pago não deve ser importada para o nosso projeto.

# 25. Prompt-base recomendado para agentes

```
Você está trabalhando no Pocket Hero.

Use este guia somente como referência de design.
Não copie nomes, sprites, mapas, UI, balanceamento ou assets do TBH.

Prioridades:
1. aventura passiva e sempre presente;
2. combate automático legível em faixa mobile;
3. profundidade em party, loot e builds;
4. progressão contínua, com proteção contra RNG extremo;
5. todo conteúdo conquistável dentro do jogo;
6. zero classe, item, pet, storage, boost ou poder pago;
7. identidade visual e lore originais;
8. vertical slice antes de escalar conteúdo.

Para qualquer proposta, declare:
- origem da inspiração;
- o que é original;
- impacto no loop;
- como o jogador conquista;
- critério de balanceamento;
- risco de grind/frustração;
- Definition of Done.
```

> Estado desejado
> O Pocket Hero deve preservar a sensação de 'um pequeno mundo vivo ao lado do usuário', mas remover dependência de compras, mercado e progressão predatória. O jogador deve continuar porque quer melhorar sua equipe, não porque precisa pagar para escapar de uma parede.
