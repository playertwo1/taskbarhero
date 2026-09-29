---
status: DESIGN
source: "[3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx](../../documents/3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx)"
---

# HERO_001 — Bastião: Traits

**Parte da [Golden Reference do Bastião](BASTIAO_GOLDEN_REFERENCE.md)**, separada em arquivo próprio em 2026-09-29 sem alteração de conteúdo. As regras de precedência da ficha principal valem aqui: valores são propostas em DESIGN/HIPÓTESE.

## Parte IV — Traits do Bastião

Escopo documentado: 3 Traits
Total: 3 Traits
Traits ativos simultaneamente: 1
Desbloqueio: Tier 3 / aproximadamente Lv.30

## 1. Objetivo dos Traits

Traits definem a especialização principal do Bastião. Enquanto as passivas permitem misturar builds, o Trait responde:

Qual versão do Bastião estou jogando nesta run?

Os três caminhos são:

Guardião: proteção de aliados;

Retaliação: Perfect Block e Contra-Golpe;

Controle: posicionamento e Desequilíbrio.

O jogador pode trocar Trait fora de combate no Hub. Nunca durante combate.

## Trait — Voto do Escudo

Branch: Guardião.
Função: proteção ativa.
Dificuldade: baixa/média.

Fantasia:

"Enquanto eu estiver aqui, vocês não caem."

## Efeito principal — Juramento

Sempre que Bastião reduzir ou absorver dano que seria causado a um aliado, recebe JURAMENTO.

Duração: 6 segundos.
Máximo: 5 cargas.

Cada carga concede:

+2% redução de dano;

+2% geração de Guarda proveniente de proteção.

Máximo: +10% redução de dano e +10% geração de Guarda.

Conta como proteção: Muralha Viva, Escudo Compartilhado, Último Bastião, Guarda Eterna e efeitos de equipamento explicitamente marcados como proteção.

Não conta: cura, regeneração, buffs genéricos ou dano evitado pelo próprio aliado.

## Efeito especial — Promessa

Ao alcançar 5 cargas de Juramento, Bastião entra em PROMESSA por 5 segundos.

Durante Promessa:

Muralha Viva aumenta sua área em 25%;

aliados protegidos recebem +10% resistência a dano adicional.

Após Promessa terminar, Juramento retorna para zero. Cooldown interno: 12 segundos.

## Interações

Muralha Viva: principal gerador de Juramento em combates com projéteis.

Escudo Compartilhado: permite gerar Juramento constantemente durante pressão sobre aliados.

Fortaleza: aumenta a capacidade de permanecer na linha de frente enquanto protege.

Guarda Eterna: salvar um aliado concede imediatamente 5 cargas de Juramento.

## Estilo de jogo

aliado sofre pressão
↓
Bastião protege
↓
Juramento
↓
mais defesa
↓
mais proteção
↓
Promessa
↓
janela de defesa extrema do grupo

Fraqueza: perde bastante valor quando Bastião está sozinho, aliados permanecem longe ou inimigos ignoram completamente os outros personagens.

## Trait — Ferro Responde

Branch: Retaliação.
Função: counter tank.
Dificuldade: alta.

Fantasia:

"Todo golpe tem resposta."

## Efeito principal — Resposta

Perfect Blocks concedem RESPOSTA.

Máximo: 3 cargas.
Duração: 6 segundos.

Cada carga reduz o cooldown atual de Contra-Golpe em 0,75 segundo.

## Reação em cadeia — Resposta de Ferro

Ao alcançar 3 cargas, o próximo Contra-Golpe entra no estado RESPOSTA DE FERRO e recebe:

+20% dano;

+30% stagger;

+25% área;

não consome Guarda.

Usar Contra-Golpe remove todas as cargas.

## Perfect Counter

Se o jogador usar Contra-Golpe imediatamente após um Perfect Block, dentro de 1 segundo, realiza PERFECT COUNTER.

Além dos efeitos normais:

gera +10 Guarda;

aplica Desequilíbrio;

prolonga Desequilíbrio existente em 2s;

reduz em 1s o cooldown de Contra-Golpe.

## Sinergia com Julgamento de Ferro

Se Resposta de Ferro e Julgamento de Ferro estiverem ativos simultaneamente, o ataque recebe o estado VEREDITO:

área aumentada;

stagger aumentado;

inimigos comuns próximos são empurrados.

O ganho principal é impacto e controle, não multiplicadores absurdos de dano.

## Estilo de jogo

ataque inimigo
↓
Perfect Block
↓
Resposta
↓
Perfect Block
↓
Resposta
↓
Contra-Golpe
↓
Perfect Counter
↓
novo ciclo

Risco: se o jogador errar o timing, não recebe Resposta. Bloqueios normais não ativam o Trait.

## Trait — Não Passarão

Branch: Controle.
Função: zone control.
Dificuldade: média.

Fantasia:

"Daqui vocês não passam."

## Efeito principal — Zona de Presença

Bastião cria permanentemente uma pequena ZONA DE PRESENÇA com raio de 3 metros.

Inimigos dentro dela:

recebem -10% velocidade;

recebem +10% stagger;

geram +1 Guarda adicional quando são provocados.

Inimigos com Desequilíbrio recebem -20% velocidade em vez de -10%.

## Contenção

Quando Bastião aplica knockback a um inimigo dentro da Zona de Presença, o inimigo recebe CONTENÇÃO por 4 segundos.

Contenção faz o próximo efeito de deslocamento contra aquele inimigo ser 25% mais forte, depois é consumida.

## Barreira Humana

Se um inimigo tentar atravessar diretamente Bastião enquanto estiver dentro da Zona, sofre micro-stagger e 20% Slow por 2s.

Cooldown por inimigo: 5 segundos.

## Interação com Impacto de Escudo

Inimigos com Contenção atingidos por Impacto de Escudo:

viajam mais longe;

causam mais dano ao colidir;

aplicam Desequilíbrio ao alvo atingido.

Desafio
↓
grupo se aproxima
↓
Zona de Presença
↓
Desequilíbrio
↓
Impacto de Escudo
↓
colisão
↓
formação inimiga destruída

## Interação com Linha Inquebrável

Se Bastião possuir o Capstone Linha Inquebrável, a linha deixada por Impacto de Escudo passa a contar como extensão temporária da Zona de Presença, permitindo controlar corredores inteiros.

## Limitação contra chefes

Chefes não podem ser empurrados livremente. Não Passarão os afeta através de stagger, Desequilíbrio, redução leve de movimento e geração de Guarda — nunca por controle total.

## Comparação dos Traits


| Trait | Especialidade | Melhor situação | Fraqueza |
| --- | --- | --- | --- |
| Voto do Escudo | proteger | grupo sob pressão | pouco valor solo |
| Ferro Responde | counters | inimigos agressivos | exige timing |
| Não Passarão | controle | grupos e corredores | menos dano direto |

## Relação com as builds

Os Traits combinam naturalmente com suas branches, mas não existe bloqueio. Exemplos híbridos:

Guardião + Ferro Responde: tank defensivo que ainda recompensa Perfect Blocks.

Retaliação + Não Passarão: counter tank com forte controle de área.

Controle + Voto do Escudo: tank de posicionamento orientado à proteção.

Traits não possuem ranks. O Trait é uma alteração de regra completa. A progressão relacionada acontece através de passivas, equipamentos, Maestria e Echoes.

## Feedback visual e sonoro

Voto do Escudo: cada carga de Juramento adiciona um segmento luminoso ao redor do escudo. Com cinco cargas, o escudo apresenta borda completa de Lúmen. Som grave ao alcançar Promessa.

Ferro Responde: Perfect Blocks geram pequenas rachaduras luminosas na espada. Com três cargas, a arma fica completamente carregada. Som metálico crescente por carga.

Não Passarão: uma linha sutil de Lúmen acompanha o chão ao redor de Bastião e reage quando um inimigo entra. Som curto de impacto quando Barreira Humana interrompe um inimigo.

## Regra de balanceamento

Traits devem alterar decisão e comportamento, nunca virar apenas +15% dano ou +15% defesa.

Se um Trait for claramente superior em todas as situações, ele está mal desenhado. Cada um precisa ter situação ideal, situação ruim, risco e recompensa.
