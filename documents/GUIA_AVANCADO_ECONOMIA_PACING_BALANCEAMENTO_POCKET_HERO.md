<!-- Fonte original: [GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx) -->

# **POCKET HERO**

## **Guia Avançado de Economia, Pacing, Telemetria e Balanceamento**

*Como transformar um incremental em uma máquina divertida, compreensível e sustentável*

> OBJETIVO
> Complementar o Guia de Design Incremental com regras práticas para economia, ritmo, desbloqueios, paredes, balanceamento, telemetria, offline, save e proteção contra sistemas frustrantes. Este documento deve orientar a IA antes que ela invente números, moedas, upgrades ou novas camadas de progressão.

# 1. Como usar este documento

Este guia é uma camada operacional. O primeiro guia explica por que bons incrementais funcionam; este define como transformar esses princípios em regras concretas de projeto. A IA deve consultá-lo antes de criar economia, tabelas de progressão, desbloqueios, sistemas offline, prestige, novas moedas, upgrades ou telemetria.

- Não criar números sem uma curva e um objetivo de pacing.

- Não criar moeda sem source, sink e motivo claro de existir.

- Não criar parede sem pelo menos duas soluções plausíveis.

- Não criar sistema de longo prazo sem métrica para validar seu efeito.

- Não criar unlock só para aumentar o número de menus.

- Toda automação deve aparecer depois do aprendizado, não antes.

- Nada que afete poder deve depender de pagamento.

# 2. Flow em ondas: domínio antes do próximo desafio

O jogador não deve ficar em tensão permanente. Após quebrar uma parede ou conquistar um upgrade importante, o jogo deve conceder um período de domínio em que inimigos antes difíceis são destruídos com facilidade. Só depois o desafio sobe novamente.

```
Parede
  ↓
Upgrade forte
  ↓
POWER FANTASY
  ↓
Fases antigas desmancham
  ↓
Novo inimigo / nova regra
  ↓
Nova parede
```

> Regra de pacing
> Nunca aumentar a dificuldade imediatamente para neutralizar um grande upgrade. O jogador precisa sentir o ganho antes de o jogo exigir mais.

# 3. Autonomia + competência

O jogador deve sentir duas coisas: 'eu escolhi esse caminho' e 'ele funciona porque eu entendi o sistema'. Builds, party, equipamentos e crafting devem oferecer margem para escolhas diferentes sem transformar qualquer opção subótima em punição extrema.

| Qualidade da build | Eficiência aproximada | Experiência |
| --- | --- | --- |
| Ótima | 100% | Recompensa estudo e otimização. |
| Boa | 85–95% | Progride confortavelmente. |
| Improvisada | 65–85% | Progride e ensina o que falta. |
| Muito ruim | Abaixo disso | O jogo deve dar pistas, não só castigar. |

# 4. Evitar 'guide-slop' e wiki obrigatória

Um sistema deixa de ser saudável quando existe uma sequência única de decisões corretas e qualquer variação trava o jogador por horas. Guias externos podem existir, mas não podem ser requisito para jogar.

> Regra das 3 rotas
> Quando o jogador encontra uma parede importante, tentar oferecer 2–3 caminhos razoáveis: melhorar gear, mudar build/party ou avançar meta-progressão/crafting.

```
Boss difícil

Caminho A → farmar equipamento
Caminho B → mudar party/build
Caminho C → crafting / runas / Eco
```

# 5. Ajuda interna inteligente

Quando o jogador falha repetidamente, o jogo pode diagnosticar o tipo de problema sem entregar uma build pronta.

```
Guardião-Cervo
5 derrotas consecutivas

Análise:
Dano: adequado
Sobrevivência: baixa

Sugestões:
• aumentar DEF
• usar frontline mais resistente
• buscar resistência Nature
• farmar a fase anterior
```

- Ensinar a pensar, não dar a resposta.

- Usar tracker para gerar diagnósticos simples.

- Nunca obrigar o jogador a abrir wiki/Discord.

- Permitir ignorar dicas.

# 6. Economia: sources e sinks

Cada recurso precisa de entrada (source) e saída (sink). Se entra muito mais do que sai, a moeda perde valor. Se sai muito mais do que entra, o jogador sente escassez permanente.

| Recurso | Sources | Sinks | Risco |
| --- | --- | --- | --- |
| Ouro | kills, boss, offline | upgrade, craft, reroll | Inflação. |
| XP | combate, offline | progressão de level | Level perder significado. |
| Material | desmontar, elite, boss | crafting | Excesso de inventário. |
| Fragmento de Eco | milestones/endgame | upgrade de Eco | Criar moeda rara sem propósito. |

> Vantagem do nosso modelo
> Como o Pocket Hero não precisa vender moedas, energia ou atalhos, a economia pode ser desenhada exclusivamente para diversão e clareza.

# 7. Evitar currency soup

Moedas demais criam carga mental e fazem o jogador esquecer o valor de cada uma. O MVP deve começar com o mínimo necessário.

```
MVP recomendado

Ouro
XP
1 material de crafting principal
```

Novas moedas só entram se resolverem um problema que ouro/XP/material não conseguem resolver sem confusão.

# 8. Curvas de custo e poder

Uma forma simples de produzir crescimento é usar curvas exponenciais leves. A IA deve registrar as constantes em arquivo de balanceamento, não espalhá-las pelo código.

```
Custo(n) = CustoBase × r^n

Poder(n) = PoderBase × g^n
```

Se r cresce um pouco mais rápido que g, o jogador naturalmente encontra paredes. Milestones, skills, gear e sinergias entram como multiplicadores que quebram essas paredes e criam novas explosões de progresso.

| Elemento | Exemplo inicial | Observação |
| --- | --- | --- |
| Custo base | 100 ouro | Fácil de entender. |
| Razão de custo | 1,15–1,25 | Testar; não congelar sem dados. |
| Milestone | Lv. 20 | Grande salto perceptível. |
| Multiplicador | ×1,5 ou efeito transformacional | Preferir salto visível. |

# 9. Milestones explosivos

```
Lv 18 → +5% HP
Lv 19 → +5% HP

Lv 20 → MILESTONE
Escudo Vivo:
ao bloquear, cura 2% do HP
```

O jogador precisa saber que existem pontos especiais à frente. Isso transforma level em uma distância até algo significativo.

# 10. Números: legibilidade antes de grandiosidade

O Pocket Hero não precisa começar com números científicos. RPG funciona melhor quando o jogador ainda consegue comparar visualmente valores.

| Faixa | Exibição recomendada |
| --- | --- |
| 0–999 | valor inteiro |
| 1.000–999.999 | 1.2K / 18K / 850K |
| 1M+ | 1.2M / 40M etc. |
| Números extremos futuros | Configuração de notação científica/engenharia, se necessário. |

> Decisão técnica
> Não implementar BigNumber no MVP. Só adicionar quando os limites de int/float do Godot realmente se tornarem problema de design.

# 11. Offline: calcular, não simular

Nunca simular frame a frame horas de ausência. Salvar timestamp e métricas de eficiência recentes.

```
elapsed = agora - last_save

offline_kills = kills_per_hour × elapsed
offline_xp    = xp_per_hour × elapsed
offline_gold  = gold_per_hour × elapsed
```

- Usar média de desempenho recente ou modelo simplificado.

- Limitar período offline no MVP (ex.: 8h).

- Aplicar recompensa uma única vez.

- Reduzir loot offline se necessário para proteger inventário.

- Mostrar claramente como a recompensa foi calculada.

# 12. Não superinvestir em anti-cheat de relógio

O Pocket Hero é single-player, sem mercado por dinheiro real, sem ranking competitivo e sem vantagem comprada. Por isso, alterações locais de relógio não justificam always-online, DRM agressivo ou infraestrutura cara.

> Princípio
> Proteja a experiência, não o ego do sistema. Se o jogador quiser alterar o próprio save offline, isso não deve degradar a experiência dos demais.

# 13. Save versionado e resiliente

```
{
  "save_version": 1,
  "player": {},
  "heroes": {},
  "inventory": {},
  "progression": {}
}
```

Toda mudança estrutural no save deve ter migração explícita. Incrementais são jogos de longo prazo; perder progresso destrói confiança.

```
escrever save.tmp
  ↓
validar
  ↓
substituir save principal
  ↓
guardar anterior como backup
```

- save principal

- backup anterior

- temp de escrita

- save_version

- migrations versionadas

- checksum/validação simples se necessário

# 14. Telemetria local desde a primeira build

Não precisamos de servidor para aprender com o jogo. Eventos locais já permitem diagnosticar pacing, economia e dificuldade.

| Evento | Dados úteis |
| --- | --- |
| session_start | versão, estágio atual |
| enemy_killed | enemy_id, stage, duração |
| boss_attempt | boss_id, build, duração |
| boss_win/fail | resultado, HP restante, tempo |
| item_drop | raridade, slot, origem |
| item_equipped | item substituído, delta de stats |
| level_up | tempo desde último nível |
| stage_enter/complete | tempo, deaths, recompensas |
| offline_claim | tempo ausente, XP, ouro, loot |

> Uso para IA
> Hermes deve poder analisar logs agregados e apontar anomalias: fase longa demais, boss com win rate baixo, ouro inflado, drops úteis raros demais ou build dominante.

# 15. Métricas-chave de balanceamento

| Métrica | Pergunta |
| --- | --- |
| TTK | Quanto tempo uma onda/inimigo leva? |
| Boss win rate | O gate está justo? |
| XP/h | Qual fase realmente progride level? |
| Gold/h | A economia está inflacionando? |
| Spend/earn ratio | Jogador consegue gastar o que ganha? |
| Useful drops/h | RNG está dando progresso real? |
| Time-to-upgrade | Quanto demora para sentir mudança? |
| Time-to-unlock | Unfolding está lento/rápido? |
| Build share | Existe uma build universal? |

# 16. FTUE como funil

O First Time User Experience deve ser tratado como uma sequência mensurável, não apenas tutorial.

```
Instala
 ↓
vê Bastião lutando
 ↓
mata primeiro Slime
 ↓
ganha primeiro item
 ↓
equipa
 ↓
level up
 ↓
libera fase 2
 ↓
libera Flecha
```

Se algum passo tiver abandono ou confusão, corrigir o fluxo antes de adicionar novos sistemas.

# 17. Achievements como unlocks

Achievements podem ser parte do unfolding, não apenas troféus decorativos.

| Achievement | Desbloqueio |
| --- | --- |
| Mate 1.000 Geléias | Eco Lumi + research de Slime. |
| Complete Bosque sem morrer | Auto-retry / desafio. |
| Derrote 50 elites | Forja II. |
| Equipe 3 Lendários | Nova regra de loot/filter. |

# 18. Anti-dark-patterns

O projeto deve evitar técnicas que usam medo, pressão temporal ou fricção proposital para forçar retorno ou compra.

| Evitar | Motivo |
| --- | --- |
| FOMO diário irreversível | Retorno vira obrigação. |
| Streak que zera tudo | Pune ausência. |
| Countdown falso | Manipulação. |
| Energia comprável | Cria problema para vender solução. |
| Loot box paga | Mistura poder/RNG e dinheiro. |
| Escassez artificial | Não serve ao gameplay. |
| Boost pago | Quebra nossa doutrina 100% conquistável. |

> Princípio de retenção
> Queremos que o jogador volte porque está curioso sobre sua máquina e suas builds, não porque tem medo de perder uma recompensa.

# 19. Arquitetura de diversão

```
AUTO-COMBATE
    ↓
LOOT + LEVEL
    ↓
BUILD
    ↓
PARTY + SKILLS
    ↓
EFICIÊNCIA
    ↓
NOVA PAREDE
    ↓
GEAR / PARTY / META
    ↓
PAREDE QUEBRADA
    ↓
POWER FANTASY
    ↓
NOVO SISTEMA
    ↓
UNFOLD
```

# 20. Ciclo de automação

```
coisa manual
    ↓
jogador aprende
    ↓
repete
    ↓
domina
    ↓
AUTOMAÇÃO
    ↓
atenção migra
para algo mais interessante
```

# 21. Especificação modular recomendada

Além deste documento mestre, o repositório deve futuramente manter arquivos menores para Minimum Sufficient Context:

| Arquivo | Responsabilidade |
| --- | --- |
| ECONOMY_RULES.md | Moedas, sources, sinks, inflação, custos e crafting. |
| PACING_AND_UNLOCKS.md | Quando cada sistema aparece e quais milestones o liberam. |
| TELEMETRY_SPEC.md | Eventos, métricas, schemas e relatórios. |
| BALANCE_MODEL.md | Fórmulas de HP, ATK, XP, custos, drop e milestones. |

# 22. Regras para a IA ao criar números

- Nunca inventar valor isolado: declarar fórmula, objetivo e faixa esperada.

- Todo stat deve ter limite ou comportamento conhecido.

- Toda curva deve ser testada em pelo menos início, meio e fim do conteúdo atual.

- Toda moeda precisa de source/sink.

- Todo boss deve ter target TTK e win rate desejado.

- Todo unlock deve ter objetivo de pacing.

- Toda mudança grande deve ser comparada com telemetria anterior.

- Nunca usar dificuldade artificial para justificar compra.

# 23. Proposta inicial de metas de pacing do MVP

Estes valores são hipóteses de teste, não especificações finais. Servem para a IA construir a primeira versão e depois ajustar com telemetria.

| Evento | Hipótese inicial |
| --- | --- |
| Primeiro kill | 5–15 s |
| Primeiro level up | 30–90 s |
| Primeiro item | 1–3 min |
| Primeiro upgrade perceptível | 2–5 min |
| Primeiro unlock de sistema | 5–10 min |
| Flecha liberada | 10–25 min |
| Primeira parede real | 20–40 min |
| Primeiro boss | 30–60 min de progresso total |
| Sessão curta útil | 2–5 min |
| Retorno offline recompensador | a partir de ~15–30 min |

> Importante
> Esses tempos não são regras. Devem ser validados em testes reais. Se o jogador estiver se divertindo mais rápido ou mais devagar, a telemetria e o playtest vencem a tabela.

# 24. Definition of Done de uma economia saudável

- O jogador entende para que serve cada moeda.

- Nenhuma moeda principal está permanentemente inútil.

- Sources e sinks estão documentados.

- Existe motivo para gastar sem sensação de confisco.

- Não há explosão de moedas no onboarding.

- Crafting oferece progresso sem eliminar o valor do loot.

- Ouro não cresce muito mais rápido que seus sinks.

- Materiais não entopem inventário sem uso.

- Nenhum recurso é vendido por dinheiro real.

# 25. Definition of Done de uma parede saudável

- O jogador percebe por que está falhando.

- Existem ao menos duas respostas razoáveis.

- Uma decisão correta gera melhoria perceptível.

- A parede não exige apenas esperar.

- RNG não é a única solução.

- O jogo pode oferecer pistas se houver repetidas falhas.

- Depois da ruptura existe um período de power fantasy.

# 26. Prompt-base para Theia/Ergane ao criar sistemas

```
Antes de implementar um sistema incremental no Pocket Hero:

1. Defina o problema que ele resolve.
2. Defina em qual momento ele aparece.
3. Defina qual decisão nova ele cria.
4. Defina source/sink se houver recurso.
5. Defina fórmula e variáveis de balanceamento.
6. Defina ao menos duas rotas para romper paredes relevantes.
7. Defina como o sistema pode ser automatizado depois do domínio.
8. Defina métricas para saber se está divertido.
9. Defina como o sistema se mantém útil no longo prazo.
10. Confirme que é 100% conquistável dentro do jogo.

Se qualquer ponto estiver indefinido, não escale o sistema. Faça um protótipo menor.
```

> Regra final
> Mais sistemas não significam mais diversão. A IA deve provar que cada camada melhora o loop antes de expandi-la.

# 27. Fontes e referências usadas

| Fonte | Tema | URL |
| --- | --- | --- |
| Game Developer | Flow channel em game design | https://www.gamedeveloper.com/design/understanding-the-flow-channel-in-game-design |
| Self-Determination Theory / PENS | Autonomia, competência e motivação | https://selfdeterminationtheory.org/player-experience-of-needs-satisfaction-pens/ |
| Game Developer | Economia de jogos: sources/sinks | https://www.gamedeveloper.com/design/book-excerpt-game-economy-design-metagame-monetization-and-live-operations |
| Anthony Pecorella | Math of Idle Games | https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i |
| GameAnalytics | Analytics IQ / progression metrics | https://docs.gameanalytics.com/products-and-features/analytics-iq/overview/ |
| GameAnalytics | Funnels | https://docs.gameanalytics.com/products-and-features/analytics-iq/funnels/ |
| Godot Forum | Offline progress discussion | https://forum.godotengine.org/t/i-am-making-an-idle-clicker-game-and-i-wanted-to-make-a-offline-progress-but-i-dont-know-how-make-it/2519 |
| Reddit r/incremental_games | Guide-slop / dependência de guias | https://www.reddit.com/r/incremental_games/comments/1w8la69/ |
| Reddit r/incremental_games | Feature desejável / dicas internas | https://www.reddit.com/r/incremental_games/comments/1rmoznx/ |
| Reddit r/incremental_games | Timeskip em incrementais | https://www.reddit.com/r/incremental_games/comments/1sz28bv/ |
| Reddit r/incremental_games | Preferências e anti-padrões | https://www.reddit.com/r/incremental_games/ |
| ScienceDirect | Revisão 2026 sobre dark patterns em jogos | https://www.sciencedirect.com/science/article/pii/S1875952126000443 |

# 28. Nota sobre evidência

- Artigos de design são referências, não leis universais.

- PENS ajuda a estruturar motivação, mas não substitui playtest.

- Reddit fornece sinais qualitativos de comunidade, não amostra representativa.

- Fórmulas apresentadas são modelos iniciais; o balanceamento final deve vir de telemetria e testes.

- Dark-pattern research deve ser usado como limite ético e de UX, não como manual para manipulação.

# 29. Resultado esperado

O Pocket Hero deve ser um jogo em que o jogador sente que sua pequena party está sempre avançando, mas onde avanço não significa apenas números maiores. Ele descobre novas camadas, aprende a construir sinergias, automatiza tarefas antigas, quebra paredes por decisões e volta ao jogo curioso para ver o que sua máquina produziu.

> Frase-guia
> O jogador não deve pensar 'esperei o suficiente'. Ele deve pensar 'agora entendi como ficar mais eficiente'.
