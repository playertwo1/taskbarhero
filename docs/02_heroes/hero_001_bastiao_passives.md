---
status: DESIGN
source: "[3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx](../../documents/3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx)"
---

# HERO_001 — Bastião: Passivas

**Parte da [Golden Reference do Bastião](BASTIAO_GOLDEN_REFERENCE.md)**, separada em arquivo próprio em 2026-09-29 sem alteração de conteúdo. As regras de precedência da ficha principal valem aqui: valores são propostas em DESIGN/HIPÓTESE.

## Parte III — Passivas do Bastião

Escopo documentado: 16 passivas
Total: 16 passivas
Branches: Guardião / Retaliação / Controle
Ranks por passiva: 5
Capstones: 3

## 1. Estrutura

INABALÁVEL
                             │
              ┌──────────────┼──────────────┐
              │              │              │
          GUARDIÃO       RETALIAÇÃO      CONTROLE
              │              │              │
             A1             B1             C1
              ↓              ↓              ↓
             A2             B2             C2
              ↓              ↓              ↓
             A3             B3             C3
              ↓              ↓              ↓
             A4             B4             C4
              ↓              ↓              ↓
         A5 CAPSTONE    B5 CAPSTONE    C5 CAPSTONE

Total: 1 Passiva de Identidade + 5 Guardião + 5 Retaliação + 5 Controle = 16.

## 2. Passiva de Identidade — Inabalável

Tipo: Core Passive.
Ranks: 5.
Disponível: início.

Perfect Blocks fortalecem temporariamente Bastião. Cada Perfect Block concede uma carga de Inabalável.

Duração base: 4 segundos.
Máximo: 3 cargas.
Cada nova carga renova a duração.


| Rank | Efeito por carga |
| --- | --- |
| 1 | +2% redução de dano |
| 2 | +3% redução de dano |
| 3 | +3% redução + 2 Guarda adicional |
| 4 | +4% redução + 2 Guarda |
| 5 | +5% redução + 3 Guarda |

Com três cargas no Rank 5: +15% redução de dano enquanto o jogador continuar executando Perfect Blocks.

Objetivo: criar a base da identidade mecânica do personagem — jogar melhor = defender melhor.

## Build A — Guardião

Objetivo: transformar Bastião na principal proteção do grupo.

## A1 — Ombro a Ombro

Tipo: Aura defensiva.
Ranks: 5.

Aliados próximos recebem redução de dano. Raio inicial: 4 metros.


| Rank | Redução de dano |
| --- | --- |
| 1 | 2% |
| 2 | 3% |
| 3 | 4% |
| 4 | 5% |
| 5 | 6% |

No Rank 5, aliados dentro da área também recebem +10% resistência a knockback.

## A2 — Escudo Compartilhado

Tipo: Proteção.
Ranks: 5.

Parte do dano recebido por aliados próximos é redirecionado para Bastião. O dano transferido sofre mitigação normal da defesa de Bastião.


| Rank | Dano redirecionado |
| --- | --- |
| 1 | 4% |
| 2 | 6% |
| 3 | 8% |
| 4 | 10% |
| 5 | 12% |

Limite: não pode transferir dano suficiente para matar Bastião diretamente.

No Rank 5, cada instância de dano redirecionado gera +1 Guarda, com cooldown interno de 1 segundo.

Sinergia: Muralha Viva, Fortaleza e Último Bastião.

## A3 — Presença Protetora

Tipo: Modificador de Muralha Viva.
Ranks: 5.

Aliados protegidos por Muralha Viva recebem resistência adicional a controle.


| Rank | Resistência a controle |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Rank 3: reduz também duração de Slow.
Rank 5: ao entrar em Muralha Viva, o aliado remove imediatamente um efeito leve de Slow.

Não remove Stun, Freeze, efeitos de chefe ou mecânicas especiais.

## A4 — Ninguém Fica Para Trás

Tipo: Resposta de emergência.
Ranks: 5.

Quando um aliado fica abaixo de 30% HP, Bastião recebe bônus de movimento ao se deslocar em direção a ele.


| Rank | Movimento |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Duração: 5 segundos.
Cooldown por aliado: 15 segundos.

Rank 3: chegar próximo do aliado gera +10 Guarda.
Rank 5: ao alcançar o aliado, ambos recebem 10% redução de dano por 3s.

## A5 — Capstone: Guarda Eterna

Tipo: Capstone — Guardião.
Ranks: 5.

Quando um aliado próximo sofreria dano fatal, Bastião pode impedir sua morte. O aliado permanece com 1 HP e recebe proteção temporária.

Rank 1: ativa uma vez a cada 120 segundos; proteção 20% redução de dano por 2s.

Rank 2: cooldown 105 segundos.

Rank 3: proteção 30% por 3s.

Rank 4: cooldown 90 segundos.

Rank 5: ao salvar o aliado, Bastião recebe +30 Guarda e o aliado recebe 40% redução de dano por 3s.

Não funciona contra mecânicas de morte obrigatória, quedas, execução de encounter ou efeitos explicitamente marcados como inevitáveis.

## Build B — Retaliação

Objetivo: transformar ataques inimigos em dano. É a árvore com maior recompensa mecânica para Perfect Block.

## B1 — Peso do Escudo

Tipo: Retaliação.
Ranks: 5.

Perfect Blocks causam dano físico ao atacante.


| Rank | Weapon Damage |
| --- | --- |
| 1 | 20% |
| 2 | 30% |
| 3 | 40% |
| 4 | 50% |
| 5 | 60% |

Rank 5: o ataque também causa pequeno stagger. Não ativa efeitos de ataque básico.

## B2 — Momento

Tipo: Amplificador.
Ranks: 5.

Contra-Golpe causa dano adicional contra inimigos com Desequilíbrio.


| Rank | Dano adicional |
| --- | --- |
| 1 | +8% |
| 2 | +12% |
| 3 | +16% |
| 4 | +20% |
| 5 | +25% |

Rank 3: Contra-Golpe prolonga Desequilíbrio em 1 segundo.
Rank 5: se o inimigo estiver Desequilibrado, Contra-Golpe gera +5 Guarda.

## B3 — Pressão Acumulada

Tipo: Acúmulo ofensivo.
Ranks: 5.

Bloquear ataques gera Pressão. Máximo: 5 cargas. Cada carga aumenta o próximo Contra-Golpe.


| Rank | Dano por carga |
| --- | --- |
| 1 | +3% |
| 2 | +4% |
| 3 | +5% |
| 4 | +6% |
| 5 | +8% |

Rank 5: cinco cargas completas também aumentam o raio do Contra-Golpe. Usar Contra-Golpe consome todas as cargas. Duração: 8 segundos.

## B4 — Quebre-se Contra Mim

Tipo: Anti-Elite / Anti-Boss.
Ranks: 5.

Quando elites ou chefes atingem o escudo de Bastião, recebem aumento de dano de stagger.


| Rank | Stagger recebido |
| --- | --- |
| 1 | +5% |
| 2 | +8% |
| 3 | +11% |
| 4 | +14% |
| 5 | +18% |

Perfect Block dobra o bônus daquele ataque. Rank 5: Perfect Block contra Elite/Boss também gera +5 Guarda.

## B5 — Capstone: Julgamento de Ferro

Tipo: Capstone — Retaliação.
Ranks: 5.

Perfect Blocks consecutivos geram cargas de Julgamento. Após acumular a quantidade necessária, o próximo Contra-Golpe se transforma em Julgamento de Ferro, criando uma onda de choque frontal.

Rank 1: requer 4 Perfect Blocks; dano da onda 180% Weapon Damage.

Rank 2: requer 4; dano 210%.

Rank 3: requer 3 Perfect Blocks; dano 230%.

Rank 4: dano 260%; aplica Desequilíbrio.

Rank 5: dano 300% Weapon Damage; inimigos já Desequilibrados também sofrem Heavy Stagger.

As cargas permanecem por 10 segundos entre Perfect Blocks.

## Build C — Controle

Objetivo: manipular posicionamento e fluxo da batalha.

## C1 — Voz de Comando

Tipo: Modificador de Desafio.
Ranks: 5.

Aumenta o alcance de Desafio.


| Rank | Área |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Rank 3: inimigos provocados recebem -5% velocidade.
Rank 5: Desafio gera +1 Guarda adicional por inimigo atingido.

## C2 — Sem Passagem

Tipo: Controle de proximidade.
Ranks: 5.

Inimigos próximos de Bastião recebem redução de movimento quando tentam atravessar sua posição.


| Rank | Slow |
| --- | --- |
| 1 | 5% |
| 2 | 8% |
| 3 | 11% |
| 4 | 14% |
| 5 | 18% |

Área: 3 metros. Rank 5: inimigos Desequilibrados recebem 25% Slow em vez de 18%.

## C3 — Choque de Linha

Tipo: Modificador de Impacto de Escudo.
Ranks: 5.

Rank 1: pode empurrar 2 inimigos.

Rank 2: dano de colisão +10%.

Rank 3: pode empurrar 3 inimigos.

Rank 4: colisão entre dois inimigos causa +25% dano.

Rank 5: pode empurrar até 4 inimigos e colisões geram pequeno dano em área.

## C4 — Formação Quebrada

Tipo: Manipulação de Desequilíbrio.
Ranks: 5.

Inimigos Desequilibrados sofrem mais efeitos de deslocamento.


| Rank | Knockback adicional |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Rank 3: stagger contra esses inimigos +10%.
Rank 5: quando um inimigo Desequilibrado colide contra outro, o segundo inimigo também recebe Desequilíbrio.

## C5 — Capstone: Linha Inquebrável

Tipo: Capstone — Controle.
Ranks: 5.

Usar Impacto de Escudo deixa atrás de Bastião uma linha temporária de Lúmen. Inimigos que atravessarem a linha são afetados.

Rank 1: duração 3 segundos; 20% Slow.

Rank 2: duração 4 segundos.

Rank 3: primeiro inimigo que atravessa recebe Desequilíbrio.

Rank 4: duração 5 segundos; Slow 30%.

Rank 5: o primeiro cruzamento de cada inimigo também causa interrupção e aplica Desequilíbrio.

Chefes não são interrompidos. Recebem apenas Slow reduzido, Desequilíbrio e aumento de stagger.

## 3. Custos

Cada rank custa 1 Skill Point. Cada passiva possui 5 ranks.

16 × 5 = 80 pontos possíveis

Isso é somente passivas. Skills ativas também consomem pontos. O jogador não terá pontos suficientes para maximizar tudo.

## 4. Requisitos de árvore

### Core

Inabalável disponível desde o início.

### Tier 1 — nível 10

Ombro a Ombro; Peso do Escudo; Voz de Comando.

### Tier 2 — nível 20

Escudo Compartilhado; Momento; Sem Passagem. Requer 3 pontos na branch.

### Tier 3 — nível 30

Presença Protetora; Pressão Acumulada; Choque de Linha. Requer 7 pontos na branch.

### Tier 4 — nível 50

Ninguém Fica Para Trás; Quebre-se Contra Mim; Formação Quebrada. Requer 12 pontos na branch.

### Capstone — nível 70

Guarda Eterna; Julgamento de Ferro; Linha Inquebrável. Requer 18 pontos na branch.

## 5. Filosofia de builds híbridas

O jogador não precisa permanecer em apenas uma branch.

### Protector Counter

Guardião forte + Retaliação média + Controle leve. Combina proteção de aliados com Perfect Blocks.

### Crowd Commander

Controle forte + Guardião leve + Retaliação leve. Focado em Desafio, Desequilíbrio, knockback e posicionamento.

### Iron Wall

Guardião extremo + Retaliação moderada + Controle leve. Build defensiva extrema.

## 6. Interações importantes

Desafio
↓
Voz de Comando
↓
mais inimigos provocados
↓
mais Guarda
↓
Impacto de Escudo
↓
Choque de Linha
↓
Formação Quebrada
↓
Linha Inquebrável

Perfect Block
↓
Inabalável
↓
Pressão Acumulada
↓
Julgamento
↓
Contra-Golpe
↓
Julgamento de Ferro

Aliado sofre dano
↓
Escudo Compartilhado
↓
Bastião recebe dano
↓
gera Guarda
↓
Muralha Viva
↓
Guarda Eterna

## 7. Anti-sinergias intencionais

Nem tudo deve funcionar perfeitamente junto. Fortaleza incentiva ficar parado, enquanto Ninguém Fica Para Trás incentiva movimentação. Retaliação quer que inimigos ataquem Bastião, enquanto Controle frequentemente quer empurrá-los para longe.

Essa tensão é desejável.

## 8. Regra para números

Todos os números deste documento são BALANCE_PLACEHOLDER e podem mudar durante testes. A identidade das passivas, entretanto, deve permanecer.

Nunca balancear removendo a característica principal de uma passiva. Se Julgamento de Ferro estiver forte, prefira aumentar o número de Perfect Blocks necessários, reduzir dano, colocar cooldown interno ou reduzir raio — mas mantenha Perfect Blocks → grande Contra-Golpe.
