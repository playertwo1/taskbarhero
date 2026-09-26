<!-- Fonte original: [GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx) -->

# **POCKET HERO**

## **Guia de Design Incremental para Criar um Jogo Divertido**

*Progressão · idle · unfolding · automação · paredes · prestige · offline · builds · RNG · feedback · longo prazo*

> PRINCÍPIO CENTRAL
> Um bom incremental não é um jogo em que os números apenas sobem. É um jogo em que o significado desses números muda à medida que o jogador descobre sistemas, automatiza tarefas antigas, quebra paredes, cria sinergias e sente que compreendeu e dominou uma máquina de progressão.

Uso interno: Hermes · Theia · Daedalus · Ergane · Têmis · Research · Claude · ChatGPT · Antigravity

# 1. Como a IA deve usar este guia

Este documento é uma doutrina de design para o Pocket Hero. Ele reúne conceitos recorrentes em bons jogos incrementais, pesquisa acadêmica sobre idle games, textos clássicos de design/matemática do gênero e discussões da comunidade. Ele deve orientar decisões, não ser tratado como checklist mecânico de sistemas obrigatórios.

- Não adicionar uma mecânica apenas porque outros incrementais a usam.

- Sempre justificar um sistema pelo problema de experiência que ele resolve.

- Quando houver conflito entre 'mais conteúdo' e 'melhor ritmo', priorizar ritmo.

- A IA deve distinguir progressão divertida de simples espera.

- A ausência do jogador não deve ser punida; a presença deve permitir decisões melhores.

- Automação deve substituir trabalho repetitivo depois que o jogador demonstrar domínio.

- RNG nunca deve ser a única rota para sair de uma parede.

- Prestige só entra se mudar a experiência ou comprimir conteúdo antigo de forma significativa.

# 2. Incremental, idle, clicker e auto-battler

| Termo | Definição prática | Relação com Pocket Hero |
| --- | --- | --- |
| Incremental | Acumular recursos, reinvestir e acelerar progressão em ciclos. | Estrutura central. |
| Idle | Parte relevante do progresso ocorre com pouca ou nenhuma intervenção. | Modo de funcionamento. |
| Clicker | Ação manual repetida gera recurso/progresso. | Não é nosso foco. |
| Auto-battler | Combate é resolvido automaticamente a partir de decisões de composição/build. | Combate principal. |
| Loot RPG | Equipamentos e combinações alteram poder e estilo da build. | Profundidade e recompensa. |

> Definição do nosso gênero
> Pocket Hero = Incremental RPG + Idle + Auto-battler + Loot RPG. O jogador não deve ficar tocando freneticamente para produzir ouro; ele deve tomar decisões e observar essas decisões produzirem resultados.

# 3. O motor psicológico de um bom incremental

O gênero funciona porque cria ciclos claros de investimento e retorno. O jogador ganha um recurso, compra algo que melhora a produção, a nova produção encurta o tempo até a próxima melhoria e isso abre novos patamares de crescimento.

```
Ganhar recurso
   ↓
Comprar melhoria
   ↓
Produzir mais rápido
   ↓
Comprar algo maior
   ↓
Automatizar parte antiga
   ↓
Encontrar novo gargalo
   ↓
Descobrir nova mecânica
   ↓
Romper gargalo
   ↓
Novo patamar de crescimento
```

O ponto-chave não é apenas crescer; é sentir uma diferença clara entre o 'antes' e o 'depois'. Uma melhoria que reduz vinte minutos para dezoito minutos pode ser matematicamente válida, mas é emocionalmente fraca. Uma melhoria que transforma vinte minutos em trinta segundos cria sensação de domínio e poder.

# 4. Unfolding: o jogo deve se revelar aos poucos

Incrementais muito respeitados usam unfolding: o jogo começa simples e novos sistemas aparecem conforme o jogador aprende os anteriores. Isso reduz sobrecarga cognitiva e transforma cada desbloqueio em descoberta.

| Momento | O jogador vê | Objetivo |
| --- | --- | --- |
| Primeiros minutos | 1 herói + 1 inimigo + HP/XP. | Entender o loop básico. |
| Depois | Equipamento. | Aprender que loot muda eficiência. |
| Depois | Segundo herói / party. | Introduzir composição. |
| Depois | Runas / meta-progressão. | Criar camada de longo prazo. |
| Depois | Forja/crafting. | Dar uso ao loot ruim e reduzir RNG. |
| Depois | Ecos/pets. | Meta-progresso e retorno a áreas antigas. |
| Longo prazo | Eco Corrompido / desafios. | Endgame transformacional. |

> Regra Pocket Hero
> Não mostrar 15 menus no primeiro minuto. O jogo deve crescer junto com o jogador.

# 5. Automação como recompensa por domínio

Uma tarefa pode ser divertida quando é nova e tediosa quando já foi repetida cinquenta vezes. Bons incrementais transformam tarefas antigas em automação e liberam o jogador para decisões mais interessantes.

| Tarefa manual inicial | Quando fica repetitiva | Automação desbloqueada |
| --- | --- | --- |
| Equipar loot | Centenas de drops | Auto-equip por regras. |
| Vender/desmontar | Inventário enche | Auto-salvage + filtro. |
| Avançar fase | Vitórias garantidas | Auto-advance. |
| Comprar upgrades | Compra idêntica em massa | Auto-upgrade. |
| Repetir boss fácil | Sem risco | Auto-retry. |

> Princípio
> Nunca obrigar um jogador experiente a repetir manualmente uma tarefa que ele já demonstrou dominar.

# 6. Alternar decisão e observação

Idle não significa ausência de jogo. A experiência ideal alterna períodos de decisão com períodos de observação e acumulação.

```
DECIDIR
  ↓
observar
  ↓
ACUMULAR
  ↓
retornar
  ↓
ANALISAR
  ↓
otimizar
  ↓
observar novamente
```

O jogador deve sentir que está configurando uma máquina de progressão. O combate continua sozinho, mas a eficiência depende das decisões dele.

# 7. Active play deve acelerar, não ser obrigatório

| Estado | O que acontece | Sensação desejada |
| --- | --- | --- |
| Idle | Party batalha, ganha XP, ouro e loot. | Progresso seguro. |
| Ativo | Trocar build, escolher fase, equipar item, mudar party. | Otimização e aceleração. |
| Ausente | Progresso offline limitado/balanceado. | Não ser punido por fechar o jogo. |

A presença do jogador deve gerar eficiência por inteligência, não por repetição física de toques.

# 8. Offline progress é parte do design

O retorno ao jogo é um momento de recompensa. A tela de retorno precisa transformar tempo ausente em história e valor percebido.

```
Enquanto você esteve fora:

5h 37m

2.481 inimigos derrotados
+1.820.000 XP
+384.500 ouro
71 itens
3 itens épicos
124 Lobos derrotados
```

- Mostrar tempo ausente.

- Mostrar ganhos por categoria.

- Mostrar marcos atingidos.

- Evitar duplicar reward em reaberturas.

- Ter limite inicial (ex.: 8h no MVP) e ajustar com balanceamento.

- Loot offline pode ser reduzido para não explodir inventário.

# 9. O jogador deve sempre enxergar o próximo objetivo

Números sem destino viram ruído. O jogador precisa saber para onde está indo e o que ganhará ao chegar.

| Métrica | Mau feedback | Bom feedback |
| --- | --- | --- |
| Ouro | 8.382.738 | 10M → Forja II · 87% · ~14 min |
| Nível | Lv. 47 | Lv. 50 → Escudo Ricochete |
| Kills | 782 Lobos | 1.000 Lobos → Eco do Lobo |
| Boss | Boss 4 | Derrote para liberar nova região/árvore |

# 10. Upgrades: números e transformação

Upgrades puramente numéricos são necessários, mas não podem carregar o jogo inteiro. Uma parte relevante das melhorias deve mudar comportamento, criar sinergias ou abrir novas decisões.

| Tipo | Exemplo | Efeito |
| --- | --- | --- |
| Numérico | +5% ATK | Acelera o que já existe. |
| Transformacional | Todo terceiro disparo ricocheteia | Muda comportamento. |
| Condicional | +40% dano contra inimigos sangrando | Cria sinergia. |
| Conversão | Fogo vira gelo e aplica slow | Muda build/objetivo. |
| Automação | Auto-salvage de comuns | Comprime tarefa antiga. |

> Diretriz aproximada
> Misturar muitos upgrades numéricos com uma parcela menor, porém marcante, de upgrades transformacionais. Não tratar percentuais como fórmula rígida; o critério é sensação de mudança.

# 11. Sinergias: o coração das builds

```
Sangramento
   +
Crítico
   +
Explodir sangramento ao critar
   =
BUILD
```

Quando o jogador descobre combinações, a progressão deixa de ser somente quantidade e passa a ser conhecimento. Isso aumenta retenção sem exigir conteúdo novo a cada minuto.

- Itens devem poder conversar entre si.

- Skills devem criar condições que outros sistemas exploram.

- Heróis devem formar composições, não apenas somar dano.

- A melhor build deve depender do objetivo.

# 12. Builds dependem do objetivo

| Objetivo | Possível build dominante |
| --- | --- |
| XP/h | Clear speed e mobs densos. |
| Ouro/h | Bônus econômico + alta frequência de kills. |
| Boss | Single-target, sustain, defesa. |
| Loot | Drop chance/raridade + clear. |
| Offline | Consistência e sobrevivência. |
| Eco Corrompido | Resistência + efeitos específicos. |

Isso evita uma 'melhor build universal' e dá valor ao tracker, inventário e experimentação.

# 13. Paredes boas e paredes ruins

| Parede | Exemplo | Qualidade |
| --- | --- | --- |
| Boa | Boss difícil; opções: farmar gear, trocar party, craftar, melhorar runa, caçar Eco. | Gera decisão. |
| Ruim | Boss difícil; única solução: esperar 17 horas. | Só adiciona relógio. |
| Boa | Fase exige resistência/controle específico. | Encoraja adaptação. |
| Ruim | HP inimigo ×100 sem nova mecânica. | Só alonga tempo. |

> Regra
> O problema não é desacelerar. O problema é desacelerar sem oferecer decisões.

# 14. Ritmo: ondas de progresso

Um incremental saudável alterna aceleração, parede, descoberta e explosão. A curva emocional deve ter ondas, não uma linha reta.

```
crescimento
  ↓
parede
  ↓
descoberta
  ↓
explosão
  ↓
crescimento
  ↓
parede maior
  ↓
nova mecânica
  ↓
explosão maior
```

# 15. Prestige/reset: usar somente quando houver motivo

Prestige é poderoso porque permite mostrar crescimento por contraste, mas é uma das mecânicas mais fáceis de usar mal. Não deve existir no Pocket Hero apenas porque o gênero costuma ter reset.

| Prestige ruim | Prestige bom |
| --- | --- |
| Perde tudo e ganha +5% dano. | Comprime conteúdo antigo e libera novas possibilidades. |
| Repete tutorial por horas. | Volta rapidamente ao ponto antigo. |
| Recompensa desconhecida. | Benefício previsível antes de confirmar. |
| Só aumenta números. | Libera automação, novas regras ou árvore própria. |
| Obrigatório para continuar. | Escolha estratégica em momento compreensível. |

## 15.1 Prestige como compressão

```
Primeira run:
Bosque 2h
Distrito 5h
Mar 10h

Depois do prestige:
Bosque 8min
Distrito 35min
Mar 2h
NOVO CONTEÚDO
```

> Decisão atual
> Prestige/Ascensão não entra no MVP. Só será avaliado quando houver conteúdo suficiente para o reset produzir compressão e descoberta.

# 16. Conteúdo antigo não deve virar lixo

Sistemas e regiões antigas podem voltar a ser relevantes por recursos específicos, pets/Ecos, bestiário, bounties, mutações, crafting ou desafios.

| Região antiga | Motivo para voltar |
| --- | --- |
| Bosque de Lúmen | Eco específico, material de forja, bounty, bestiário. |
| Distrito Cinzento | Material de resistência, desafio de ranged. |
| Mar de Vidro | Veneno/cristal, crafting elemental. |
| Qualquer bioma | Versão Eco Corrompido. |

# 17. O jogador precisa ficar melhor, não apenas mais forte

Progressão de conhecimento é tão importante quanto progressão de stats.

| Estágio do jogador | Pensamento |
| --- | --- |
| Iniciante | Maior ATK deve ser melhor. |
| Intermediário | Crit + Attack Speed parece melhor. |
| Avançado | Lifesteal + Crit + Bleed + breakpoint + buff de party + fase ideal. |

> Objetivo
> O jogador deve sentir que domina o sistema melhor do que dominava ontem.

# 18. Feedback visual e sensação de crescimento

A progressão precisa existir também no mundo visível. O herói e o cenário podem comunicar avanço sem depender de números.

- Equipamentos mudam visualmente o herói.

- Auras/partículas aparecem em tiers altos.

- Pets/Ecos acompanham a party.

- Cenários ficam mais densos e vivos.

- Bosses e elites têm silhuetas progressivamente mais impactantes.

- A faixa de batalha mostra a máquina ficando mais eficiente.

# 19. Tema e narrativa leve

O Pocket Hero já tem uma vantagem que muitos incrementais abstratos não têm: é um RPG visual. Podemos usar ambiente, inimigos, mutações e bosses para contar história sem despejar texto.

```
Bosque de Lúmen
  ↓
fungos começam a corromper
  ↓
animais mudam
  ↓
ruínas aparecem
  ↓
Guardião desperta
```

# 20. Camadas de tempo da progressão

| Escala | Exemplos |
| --- | --- |
| Segundos | Ataque → kill → XP/ouro/loot. |
| Minutos | Level, item, skill, upgrade. |
| Horas | Nova fase, herói, sistema, boss. |
| Dias | Ecos, bestiário, crafting, builds, meta-progressão. |
| Longo prazo | Novos biomas, dificuldades, Eco Corrompido, possível Ascensão. |

> Regra
> Quando uma camada desacelera, outra deve continuar oferecendo movimento ou objetivo.

# 21. Conceito de compressão

Cada nova camada deve reduzir o trabalho de uma camada antiga. Isso é a evolução do papel do jogador.

```
operário
   ↓
supervisor
   ↓
gerente
   ↓
arquiteto
```

No início o jogador executa ações. Depois define regras. Mais tarde escolhe estratégias. No fim, projeta uma máquina eficiente.

# 22. Anti-padrões: o que torna um incremental ruim

| Anti-padrão | Por que prejudica |
| --- | --- |
| Número sobe sem mudar o jogo | Novidade desaparece. |
| Prestige com recompensa fraca | Parece apagar progresso. |
| Repetir tutorial após reset | Desrespeita tempo. |
| Clique manual infinito | Vira trabalho físico. |
| Automação tarde demais | Tarefas antigas ficam tediosas. |
| Automação cedo demais | Jogador não aprende o sistema. |
| Esperas sem decisão | Vira cronômetro. |
| RNG sem proteção | Progresso pode travar indefinidamente. |
| Uma build domina tudo | Elimina escolha. |
| Conteúdo antigo inútil | Desperdiça sistemas. |
| Muitas moedas cedo | Sobrecarga cognitiva. |
| Muitos menus no início | Mata unfolding. |
| Offline fraco | Pune quem fecha o jogo. |
| Ativo obrigatório demais | Idle vira trabalho. |
| Upgrades só de +1%/+2% | Falta transformação. |
| Sem próximo marco | Números perdem significado. |
| Paywall | Parede vira cobrança. |

# 23. Doutrina de design incremental do Pocket Hero

**1. PROGRESSO PRECISA SER VISÍVEL.**

**2. O JOGO DEVE SE DESDOBRAR.**

**3. MECÂNICA ANTIGA DEVE PODER VIRAR AUTOMAÇÃO.**

**4. PRESENÇA ACELERA; AUSÊNCIA NÃO PUNE.**

**5. PAREDES DEVEM GERAR DECISÕES.**

**6. RNG NUNCA É A ÚNICA SAÍDA.**

**7. UPGRADES DEVEM CRIAR SINERGIAS.**

**8. BUILDS DEPENDEM DO OBJETIVO.**

**9. CONTEÚDO ANTIGO DEVE PODER VOLTAR A SER ÚTIL.**

**10. PRESTIGE SOMENTE SE MUDAR O JOGO.**

**11. O JOGADOR PRECISA SEMPRE VER O PRÓXIMO MARCO.**

**12. CONHECIMENTO DEVE GERAR EFICIÊNCIA.**

**13. O MUNDO DEVE MUDAR VISUALMENTE COM A PROGRESSÃO.**

**14. NÃO TRANSFORMAR IDLE EM TRABALHO.**

**15. NADA DE PODER PAGO.**

# 24. Aplicação direta no MVP

| Princípio | Implementação MVP |
| --- | --- |
| Unfolding | Começar com combate; liberar equipamento, party, crafting e meta-progressão aos poucos. |
| Automação | Auto-advance e filtros só depois que o jogador domina o básico. |
| Paredes | Boss deve aceitar múltiplas soluções: gear, party, skill, craft, farm. |
| RNG | Loot aleatório + crafting/garantias por milestones. |
| Offline | Até 8h no MVP, com tela de retorno clara. |
| Objetivos | Próximo nível, boss, Eco, unlock e porcentagem sempre visíveis. |
| Builds | XP, ouro, boss, loot e sobrevivência podem exigir builds diferentes. |
| Conteúdo antigo | Ecos, bestiário e materiais mantêm valor de regiões antigas. |
| Prestige | Fora do MVP. |
| Pay | Nenhum poder pago; tudo conquistável jogando. |

# 25. Métricas para saber se está divertido

| Métrica | O que observar |
| --- | --- |
| Tempo até primeiro upgrade | Deve ser rápido o bastante para ensinar o ciclo. |
| Tempo até primeiro unlock | Precisa criar descoberta sem sobrecarregar. |
| Tempo entre decisões relevantes | Evitar longos períodos sem nada para fazer. |
| Tempo até parede | Nem imediato, nem horas sem desafio. |
| Tempo de recuperação após parede | Decisão correta deve gerar salto perceptível. |
| XP/h, ouro/h, kills/h | Acompanhar eficiência. |
| TTK por onda/boss | Detectar progressão parada. |
| Drops úteis/h | Evitar RNG morto. |
| Retorno ao jogo | Offline deve parecer recompensa, não obrigação. |
| Variedade de builds | Se todos usam a mesma, falta escolha. |

# 26. Checklist para qualquer sistema novo

- ☐ Qual problema do jogador este sistema resolve?

- ☐ Ele cria decisão ou só mais números?

- ☐ Ele aparece no momento certo do unfolding?

- ☐ Ele torna uma tarefa antiga desnecessariamente manual?

- ☐ Pode ser automatizado mais tarde?

- ☐ Ele cria uma nova sinergia/build?

- ☐ Ele adiciona uma parede sem solução alternativa?

- ☐ Existe proteção contra RNG extremo?

- ☐ Existe próximo objetivo claramente visível?

- ☐ O sistema melhora o jogo idle e/ou o jogo ativo?

- ☐ Ele mantém conteúdo anterior relevante?

- ☐ Ele pode funcionar sem qualquer compra?

- ☐ Existe métrica clara para balancear?

- ☐ Ele pode ser removido sem destruir o core loop?

# 27. Prompt-base para a IA do projeto

```
Você está trabalhando no Pocket Hero.

Use a doutrina incremental deste documento como regra de design.

Antes de propor qualquer sistema, responda internamente:
1. Qual problema do jogador ele resolve?
2. Qual decisão nova ele cria?
3. Em qual momento do unfolding ele aparece?
4. Que tarefa antiga ele comprime ou automatiza?
5. Como evita RNG extremo?
6. Qual próximo marco ele cria?
7. Que build/sinergia ele permite?
8. Como continua útil no longo prazo?
9. Como é conquistado jogando?
10. Qual métrica valida que ficou divertido?

Regras:
- presença acelera; ausência não pune;
- não transformar idle em trabalho;
- nenhuma vantagem paga;
- prestige só se comprimir conteúdo e abrir novas possibilidades;
- paredes devem oferecer escolhas;
- conteúdo antigo não pode morrer inutilmente;
- o jogador deve perceber que ficou mais eficiente por decisões próprias.
```

> Frase-guia do projeto
> O jogo luta sozinho. Mas ele fica bom porque o jogador ensinou a máquina a lutar melhor.

# 28. Referências de pesquisa

| Fonte | Tema | URL |
| --- | --- | --- |
| Anthony Pecorella / Game Developer | The Math of Idle Games, Part I | https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i |
| Kongregate | The Math of Idle Games, Part III | https://www.kongregate.com/en/pages/the-math-of-idle-games-part-iii |
| Kongregate | Quest for Progress: The Math of Idle Games | https://www.kongregate.com/en/pages/quest-for-progress-the-math-of-idle-games |
| ScienceDirect | Estudo sobre engajamento em Neko Atsume | https://www.sciencedirect.com/science/article/pii/S1071581918305251 |
| Monash University | The pleasure of playing less: Kittens Game | https://research.monash.edu/en/publications/the-pleasure-of-playing-less-a-study-of-incremental-games-through/ |
| Steam | Antimatter Dimensions | https://store.steampowered.com/app/1399720/Antimatter_Dimensions/ |
| Steam | (the) Gnorp Apologue | https://store.steampowered.com/app/1473350/the_Gnorp_Apologue/ |
| Steam | The Perfect Tower II | https://store.steampowered.com/app/1197260/ |
| Steam | Rusty's Retirement | https://store.steampowered.com/app/2666510/Rustys_Retirement/ |
| Reddit r/incremental_games | Definições e discussões do gênero | https://www.reddit.com/r/incremental_games/ |
| Reddit | Discussões sobre prestige ruim e resets | https://www.reddit.com/r/incremental_games/comments/1lcswig |
| Reddit | Discussões sobre active vs idle | https://www.reddit.com/r/incremental_games/comments/1rx0w24 |

# 29. Nota sobre evidência e comunidade

- Textos de Pecorella são referência de design/matemática, não uma especificação universal.

- Estudos acadêmicos ajudam a entender engajamento e experiência, mas não determinam uma fórmula única para sucesso.

- Steam mostra como jogos existentes se posicionam e quais sistemas usam.

- Reddit é evidência qualitativa da comunidade, não estatística representativa de todos os jogadores.

- Toda proposta final para o Pocket Hero deve ser testada no nosso próprio vertical slice e tracker.

# 30. Definition of Done de uma boa camada incremental

- Existe um objetivo claro.

- Existe feedback imediato e feedback de longo prazo.

- O jogador entende por que ficou mais forte.

- A camada introduz decisão real.

- Não exige repetição manual desnecessária.

- Não bloqueia progresso exclusivamente por RNG.

- Possui pelo menos uma rota de otimização.

- Pode ser medida pelo tracker.

- Conversa com outros sistemas.

- Não depende de compra.

- Não sobrecarrega a interface quando aparece.

- Tem um caminho de automação/compressão quando envelhecer.
