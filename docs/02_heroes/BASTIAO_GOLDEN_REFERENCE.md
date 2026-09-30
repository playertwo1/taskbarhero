---
status: DESIGN
source: "[3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx](../../documents/3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx)"
---

# Bastião Golden Reference

> **Fonte e escopo:** Esta ficha é o modelo de profundidade e organização para os próximos heróis; reutilize a estrutura, não copie a mecânica ou os números exclusivos do Bastião. “Golden Reference” aqui significa referência de design, não aprovação de sprite Golden. O padrão HERO_STANDARD e as decisões recentes de Rafael prevalecem. Valores e sistemas adicionais permanecem em DESIGN/HIPÓTESE até revisão, balanceamento e aceite.
> **Documento original:** [3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx](../../documents/3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx). Esta versão Markdown foi curada para manter apenas o conteúdo de referência e as decisões atuais; o DOCX original preserva o documento integral e seus elementos visuais.

## Regras de precedência no Pocket Hero

- [`HERO_STANDARD.md`](HERO_STANDARD.md) continua sendo a fonte única para a anatomia e os requisitos compartilhados dos oito heróis. Regras compartilhadas do herói devem ser consultadas no padrão canônico, sem duplicação nesta ficha.
- A ficha de Bastião serve como exemplo de profundidade, não como autorização para copiar kit, passivas, Traits, Maestria, lore ou valores para os demais heróis.
- As decisões atuais do [Sistema de skills](../03_systems/SKILL_SYSTEM.md) prevalecem. A fonte descreve observação/timing de Perfect Block; como o combate do Pocket Hero é automático, qualquer uso precisa ser adaptado a regras automáticas e não pode exigir comando durante a luta.
- O DOCX original inclui propostas genéricas para outros heróis; elas não foram reproduzidas nesta ficha curada. O [catálogo do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) e as fichas individuais mantêm autoridade para esses heróis.
- Números de Guarda, dano, cooldown, duração, ranks, custos, Maestria e progressão visual são propostas. Não copiar para `/data/` nem tratar seções rotuladas `DESIGN_COMPLETE` no DOCX como aceite do Pocket Hero.
- O diretório `game/heroes/` sugerido pela fonte não existe neste repositório Godot. Para implementação, siga [`AGENTS.md`](../../AGENTS.md), cenas em `scenes/` e scripts em `scripts/`.

## BASTIÃO — GOLDEN REFERENCE

Projeto: Pocket Hero
Versão: 0.1
Status do registro de design: `DESIGN`; o status atual e as pendências estão no [roadmap](../../ROADMAP.md) (`HERO-001` na seção 2; pendências em `NEXT-2`).
Documento-base: padrão canônico + kit de combate + passivas + traits + maestria

Documento de design do Bastião e referência de profundidade para as demais fichas. A implementação é comprovada pelo código, dados e testes do repositório.

## Regras compartilhadas e lore pessoal

As regras compartilhadas de anatomia, skills, equipamentos, progressão e critério de conclusão têm fonte única em [`HERO_STANDARD.md`](HERO_STANDARD.md). A fonte DOCX v0.1 continha uma cópia extensa dessas regras e de propostas genéricas de roster; essa cópia foi retirada desta versão curada para não divergir do padrão vigente. O DOCX original continua preservado em `documents/`.

<a id="lore-pessoal-do-bastiao-decisoes-atuais"></a>
## Lore pessoal do Bastião — decisões atuais

**Status:** `DESIGN`; fatos abaixo são canônicos para a concepção narrativa atual. Diálogos, encontros finais e implementação continuam pendentes.

- Bastião foi membro da **Guarda da Primeira Muralha**.
- Seu nome verdadeiro foi perdido pelo Apagamento. **Não revelá-lo nesta etapa.**
- “Bastião” é o nome que assumiu a partir da função que passou a representar.
- Seu **Primeiro Juramento** é: “Enquanto houver alguém atrás de mim, eu permaneço.”
- A **Porta da Vigília** concentra sua memória perdida.
- Seu arco explora dever, memória, culpa e a diferença entre resistir e viver.

As cinco missões pessoais são:

1. **A Porta** — retorno às ruínas da Primeira Muralha.
2. **Nomes no Ferro** — origem do escudo e dos companheiros perdidos.
3. **O Último a Sair** — descoberta de que permaneceu mesmo após a evacuação.
4. **O Nome Esquecido** — recusa recuperar sua identidade ao custo das memórias alheias.
5. **Eu Fico** — repetição da antiga batalha, agora com aliados permanecendo ao seu lado.

## Parte II — Bastião: Kit Base

## 1. Identidade

Nome: Bastião
Arquétipo: Tank defensivo focado em absorver pressão, proteger aliados, controlar inimigos, bloquear ataques importantes, converter defesa em dano e sobreviver quando todos os outros cairiam.

Fantasia:

"Eu fico."

Bastião não luta porque acredita que é invencível. Ele luta porque alguém precisa permanecer de pé.

## 2. Filosofia de gameplay

Bastião não deve ser um personagem com 300% mais HP que simplesmente apanha. Ele deve recompensar decisões.

O jogador precisa observar: quem está sendo atacado → de onde vem o perigo → quando bloquear → quando gastar Guarda.

INIMIGO ATACA
      ↓
BASTIÃO BLOQUEIA
      ↓
GERA GUARDA
      ↓
PROTEGE ALIADOS
      ↓
ACUMULA PRESSÃO
      ↓
CONVERTE DEFESA EM ATAQUE
      ↓
CONTROLA O CAMPO
      ↓
VOLTA A DEFENDER

## 3. Mecânica exclusiva — Guarda

Valor inicial: 0 / 100.

Guarda representa sua capacidade de manter posição sob pressão.


| Evento | Guarda |
| --- | --- |
| receber ataque | +2 |
| bloquear ataque | +5 |
| Perfect Block | +12 |
| aliado protegido receber ataque | +4 |
| provocar inimigo | +3 |
| Contra-Golpe acertar | +5 |

Máximo: 100 Guarda.

Guarda não desaparece imediatamente fora de combate. Após alguns segundos sem combate começa a decair lentamente.

## 4. Perfect Block

Existe uma pequena janela ao levantar a defesa. Se um ataque atingir Bastião durante essa janela ocorre um PERFECT BLOCK.

Efeito básico:

dano recebido drasticamente reduzido;

gera Guarda adicional;

aplica Desequilíbrio ao atacante;

ativa interações de skills e passivas.

Isso cria diferença entre Bastião iniciante e Bastião dominado.

## 5. Status exclusivo — Desequilíbrio

Inimigos Desequilibrados sofrem:


| Efeito | Valor inicial |
| --- | --- |
| dano causado | -10% |
| resistência a stagger | -20% |
| duração | 4s |

Algumas builds poderão explorar esse estado agressivamente.

## 6. Ataque básico — Marcha de Ferro

Combo de espada e escudo:

Golpe 1 — Espada horizontal
↓
Golpe 2 — Golpe de escudo
↓
Golpe 3 — Corte pesado

O terceiro golpe gera +4 Guarda. Se atingir inimigo Desequilibrado: +6 Guarda.

## 7. Defesa básica

Segurar defesa: Erguer Escudo.

Redução inicial de dano frontal: 70%.
Movimento: -35% velocidade.

Bastião pode continuar avançando lentamente enquanto bloqueia. O escudo possui um pequeno arco frontal de proteção.

## 8. Skills


| Slot | Skill | Função |
| --- | --- | --- |
| S1 | Muralha Viva | proteção |
| S2 | Contra-Golpe | retaliação |
| S3 | Desafio | controle |
| S4 | Fortaleza | defesa |
| S5 | Impacto de Escudo | controle/dano |
| Signature | Último Bastião | emergência |

### Skill 1 — Muralha Viva

Bastião cria uma zona de proteção atrás de si. Aliados posicionados atrás do escudo recebem -40% dano à distância. Parte do dano mitigado gera Guarda.

Duração inicial: 6 segundos.
Cooldown: 14 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | proteção básica |
| 2 | +1s duração |
| 3 | aliados recebem +10% resistência |
| 4 | área maior |
| 5 | Perfect Blocks prolongam a duração |

Identidade: essa skill define Bastião como protetor. O posicionamento do personagem importa.

### Skill 2 — Contra-Golpe

Bastião assume postura defensiva. Se for atingido dentro da janela:

BLOCK
↓
ESCUDO
↓
CONTRA-ATAQUE

Dano: 180% Weapon Damage.
Aplica: Desequilíbrio.
Perfect Block: 250% Weapon Damage.
Cooldown: 8 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | counter básico |
| 2 | +20% dano |
| 3 | gera +10 Guarda |
| 4 | pequeno stun |
| 5 | Perfect Block cria onda de choque |

### Skill 3 — Desafio

Bastião bate sua arma contra o escudo. Inimigos próximos são Provocados por 4 segundos. Enquanto estiverem provocados causam -15% dano a aliados e priorizam Bastião.

Cada inimigo provocado gera +3 Guarda.
Cooldown: 15 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | taunt |
| 2 | área maior |
| 3 | duração +1s |
| 4 | inimigos provocados recebem Desequilíbrio |
| 5 | matar inimigo provocado reduz cooldown |

### Skill 4 — Fortaleza

Bastião ancora o escudo no chão. Durante 5 segundos recebe:


| Status | Bônus |
| --- | --- |
| redução de dano | +40% |
| resistência a knockback | +100% |
| geração de Guarda | +50% |

Bastião perde mobilidade significativa.
Cooldown: 20 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | defesa básica |
| 2 | +1s duração |
| 3 | regeneração leve |
| 4 | aliados próximos recebem resistência |
| 5 | não pode ser interrompido |

### Skill 5 — Impacto de Escudo

Bastião avança violentamente.

BASTIÃO
██████►

Inimigos atingidos são empurrados. O primeiro inimigo que colidir contra parede, objeto ou outro inimigo recebe dano adicional e stun.

Dano inicial: 140% Weapon Damage.
Custo: 20 Guarda.
Cooldown: 10 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | investida |
| 2 | maior distância |
| 3 | maior knockback |
| 4 | colisões aplicam Desequilíbrio |
| 5 | inimigos Desequilibrados causam explosão de impacto |

### Signature — Último Bastião

Custo: 100 Guarda.
Duração: 8 segundos.

Durante o efeito:

não pode cair abaixo de 1 HP;

aliados próximos recebem redução de dano;

ataques contra aliados parcialmente redirecionam dano para Bastião;

todos os bloqueios contam como Perfect Blocks;

Contra-Golpe recebe cooldown acelerado;

Bastião não pode ser empurrado.

Ao terminar, uma onda de choque causa dano proporcional ao dano absorvido.

Conceito visual: o chão ao redor do personagem apresenta linhas luminosas de Lúmen formando uma muralha circular. Bastião permanece no centro.


| Rank | Efeito |
| --- | --- |
| 1 | efeito padrão |
| 2 | duração 8 → 10 segundos |
| 3 | ao terminar, restaura parte da vida dos aliados proporcional ao dano absorvido |

## 9. Passiva de identidade — Inabalável

Sempre que Bastião realiza um Perfect Block:

+Guarda
+
Desequilíbrio
+
redução temporária de dano

Perfect Blocks consecutivos aumentam brevemente sua eficiência defensiva. Esse bônus possui limite.

## 10. Builds principais

### Guardião

Objetivo: proteger o grupo.

### Retaliação

Objetivo: transformar defesa em dano.

### Controle

Objetivo: controlar posicionamento inimigo.

## 11. Fraquezas


| Fraqueza | Consequência |
| --- | --- |
| mobilidade baixa | dificuldade contra inimigos móveis |
| ataques traseiros | escudo pouco eficiente |
| dano contínuo | difícil realizar Perfect Block |
| inimigos espalhados | controle menos eficiente |
| pouca Guarda | capacidades ofensivas reduzidas |
| isolamento | parte das passivas perde valor |

Isso impede que Bastião seja sempre a melhor escolha.

## 12. Sinergias preliminares

Orvalho: Bastião mantém inimigos ocupados e Orvalho cria zonas persistentes. Excelente em batalhas longas.

Flecha: Desafio mantém inimigos agrupados e Flecha ataca com segurança.

Íris: Bastião agrupa; Íris controla áreas.

Brasa: Bastião absorve pressão enquanto Brasa permanece em HP baixo.

Véu: Bastião força inimigos a olhar para ele; Véu ataca pontos vulneráveis.

Forja: Bastião mantém inimigos dentro das áreas das engenhocas.

Sino: buffs defensivos e manipulação de ritmo tornam Bastião extremamente estável.

## 13. Equipamentos exclusivos iniciais

### Escudo — Muralha do Primeiro Juramento

Raridade: Legendary.
Efeito: Perfect Blocks geram Guarda adicional.

### Espada — Vigília

Raridade: Legendary.
Efeito: Contra-Golpe causa dano aumentado contra inimigos Desequilibrados.

### Echo — A Sentinela que Ficou

Raridade: Unique Echo.
Efeito: Muralha Viva protege também o aliado com menor HP mesmo que ele esteja ligeiramente fora da área.

Lore:

Todos fugiram.
Um ficou.

## 14. Curva de aprendizado

Iniciante: bloquear + provocar.

Intermediário: Guarda + posição + proteção.

Avançado: Perfect Block + controle.

Master: transformar ataques inimigos em recursos e controlar o ritmo inteiro da batalha.

## 15. Regra fundamental do personagem

Quando o jogador domina Bastião, deve sentir:

"Quanto mais pressão colocam em mim, mais perigoso eu fico."

Mas nunca:

"Posso simplesmente ficar parado e ser invencível."

Esse equilíbrio define o personagem.

## Partes III–V — arquivos próprios

- [Parte III — Passivas](hero_001_bastiao_passives.md)
- [Parte IV — Traits](hero_001_bastiao_traits.md)
- [Parte V — Maestria 1–10](hero_001_bastiao_mastery.md)

## Parte VI — Estado Atual do Bastião


| Sistema | Estado |
| --- | --- |
| identidade | concluído |
| mecânica central | concluído |
| fraqueza | concluído |
| ataque básico | concluído |
| 6 skills | concluído |
| Signature | concluído |
| 16 passivas | concluído |
| 3 Traits | concluído |
| 3 builds | concluído |
| runtime (slice) | 6 skills, 16 passivas, 3 Traits e 3 builds em runtime como HIPÓTESE (2026-09-30), com a Guarda ativa; Contenção e Barreira Humana do Não Passarão ficam fora do slice (exigem posição) |
| sinergias | preliminar |
| equipamentos exclusivos | 3 iniciais |
| Mastery 1–10 | concluído |
| Lore pessoal e 5 missões | conceitos registrados; diálogos e encontros pendentes |
| evolução visual | definida em conceito; arte pendente |
| números finais | pendente |
| balanceamento | pendente |

Status do ciclo de design: `DESIGN`. Para o estado atual e as pendências, consulte o [roadmap](../../ROADMAP.md) (`HERO-001` na seção 2; pendências em `NEXT-2`).

## Próximos itens recomendados

Diálogos e encontros das cinco missões pessoais do Bastião.

Itens exclusivos adicionais e Echoes.

Sinergias formais com os outros 7 heróis.

Design visual das quatro formas.

Valores de balanceamento e protótipo jogável.

Sprites, VFX, SFX e feedback de UI.

Regra de ouro do Bastião:

Quanto mais pressão colocam em mim, mais perigoso eu fico — mas nunca por simplesmente ficar parado.
