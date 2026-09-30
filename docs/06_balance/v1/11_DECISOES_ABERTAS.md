---
document_type: decision-log
id: BALANCE_V1_11_DECISOES_ABERTAS
version: "1.0"
status: DESIGN
certainty: EM_ABERTO
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO]
---

# 11 — Decisões abertas do balanceamento

Tudo que depende de Rafael. Nenhum agente decide estes itens: apresente as opções e espere. Quando uma decisão for tomada, registre no documento dono (com data) e **apague a linha daqui**. Achados do Argos pendentes (BAL-009 a BAL-015) estão em [BALANCE_FINDINGS](../../08_qa/BALANCE_FINDINGS.md) e na seção NOW-3 do [ROADMAP](../../../ROADMAP.md).

## Estruturais (afetam vários domínios)

D-01, D-04 e D-07 estão agendadas na fatia `NOW-5 · OPUS-ROUND-1` do [ROADMAP](../../../ROADMAP.md), que só o Claude Opus executa.

| ID | Pergunta | Opções | Recomendação | Dono |
| --- | --- | --- | --- | --- |
| D-01 | Como medir o orçamento 30/30/25/15? | (a) ganho dentro de cada capítulo, por ablação; (b) herói L100 completo vs L1 nu (o nível domina com ~16×; não fecha) | (a) | [00 §4](00_CONSTITUICAO.md#4-orçamento-de-poder) |
| D-02 | Quando a Signature fica disponível? | (a) 3º slot fixo desde o início (decisão do slice) e o HERO_STANDARD é atualizado; (b) Tier 6/nível 60 como diz o HERO_STANDARD, e o slice é exceção | (a); a progressão de Tier passa a liberar ranks da Signature | [03 §1](03_SKILLS_PASSIVAS.md#1-loadout) |
| D-03 | Números do foco de crescimento por herói | (a) ±25% do fator de crescimento, compensado no status oposto; (b) proposta antiga (ATK de Íris a 180% da referência); (c) sem foco | (a) | [02 §2](02_HEROIS.md#2-foco-de-crescimento-por-papel) |
| D-04 | Curva de XP para os 100 níveis | (a) XP concedido cresce com o nível do conteúdo à mesma taxa do exigido (níveis por capítulo estáveis); (b) reduzir `growth` e manter XP fixo; (c) tabela manual por capítulo | (a), números medidos pelo Argos contra as horas-alvo | [02 §5](02_HEROIS.md#5-xp-e-ritmo-de-nível) |
| D-05 | `enemy_damage_scale` e HP de party viram regra global? | (a) sim, em `combat_core` (party sempre de 3); (b) continuam locais por capítulo | (a) | [06 §2](06_INIMIGOS_CHEFES.md#2-fórmula-do-inimigo) |
| D-06 | Reforço com mais de um nível nas raridades altas | (a) Reforço por nível cai com a raridade; (b) relaxar "≤ metade do degrau"; (c) manter 1 nível | (a) | [05 §4](05_AFFIXES_CRAFT.md#4-operações-de-craft-e-seus-limites) |
| D-07 | D3 passa do teto de 1 milhão de HP no capítulo 10 | (a) HP de D3 ×1,9 e compensar em ATK/mecânicas; (b) teto de 2 milhões nas dificuldades; (c) reduzir o HP de party do chefe | (a) | [09 §3](09_DIFICULDADE_ENDGAME.md#3-teto-por-camada) |
| D-08 | Fatias de poder por faixa de capítulos | tabela proposta (40/35/20/5 → 30/30/25/15) ou outra | tabela proposta, medida antes de travar | [00 §4](00_CONSTITUICAO.md#4-orçamento-de-poder) |
| D-09 | Teto de sinergia entre aliados | valores propostos (+50% ATK, −50% dano, 50% escudo, 6% HP/s de cura, +25% vulnerabilidade, +50 Haste) ou outros | propostos, medidos no Argos | [00 §5](00_CONSTITUICAO.md#5-poder-da-party-e-teto-de-sinergia) |

## Números HIPÓTESE que precisam de aprovação antes de virar `/data`

| ID | Item | Proposta | Dono |
| --- | --- | --- | --- |
| N-01 | Jogador de referência por capítulo (nível, raridade, IP, ranks, nós, horas) | tabela da constituição | [00 §6](00_CONSTITUICAO.md#6-jogador-de-referência-por-capítulo) |
| N-02 | Faixas de IP por capítulo | `b(c) = 7,5 × (c−1)` | [04 §4](04_ITENS_RARIDADE.md#4-item-power-ip) |
| N-03 | Fator por capítulo dos inimigos | ×1,08 (direção DECIDIDA) | [06 §2](06_INIMIGOS_CHEFES.md#2-fórmula-do-inimigo) |
| N-04 | Catch-up de XP | ×3 até 5 níveis abaixo do topo | [02 §6](02_HEROIS.md#6-heróis-no-banco--catch-up--decidido-rafael-2026-09-30) |
| N-05 | Offline | 50% da taxa online, teto 8 h (12 h pela Árvore) | [07 §9](07_ECONOMIA_LOOT.md#9-progresso-offline) |
| N-06 | Inventário | 60 espaços, até 150 pela Árvore | [07 §8](07_ECONOMIA_LOOT.md#8-inventário-e-excesso) |
| N-07 | Ouro e preços por capítulo | ×1,15 por capítulo | [07 §5](07_ECONOMIA_LOOT.md#5-ouro-e-materiais--base-do-capítulo-1-escala-por-capítulo) |
| N-08 | Orçamento de rank de skill | R1→R5 ≤ +60%; Signature ≤ +40% | [03 §3](03_SKILLS_PASSIVAS.md#3-ranks) |
| N-09 | Orçamento de Mastery | M1–M10 ≤ +10% de poder real | [03 §5](03_SKILLS_PASSIVAS.md#5-mastery-110) |
| N-10 | Respec | 1º por capítulo grátis, depois Ouro | [02 §7](02_HEROIS.md#7-pontos-de-árvore-do-herói-e-respec) |
| N-11 | Anti-farm por diferença de nível | XP ×0,5 com Δ ≥ +5; ×0,1 com Δ ≥ +10 | [00 §9](00_CONSTITUICAO.md#9-relevância-e-diferença-de-nível) |
| N-12 | Janela de relevância | c+1 ≥ 80%; c+2 ≤ 65% | [00 §9](00_CONSTITUICAO.md#9-relevância-e-diferença-de-nível) |
| N-13 | Camadas D1–D3 e raridades liberadas | tabela de 09 | [09 §2](09_DIFICULDADE_ENDGAME.md#2-camadas) |

## Conteúdo e nomes

- Nomes e identidade das raridades 5–9 e como cada uma é obtida.
- Nomes de UI das dificuldades.
- BP e efeito único de Relíquia e Memória (Casca do Guardião, Memória do Guardião).
- Renormalização das tabelas de raridade do slice sem Épico em drops comuns.
- Pressões por capítulo (proposta em [06 §6](06_INIMIGOS_CHEFES.md#6-pressões-por-capítulo)); nomes de capítulos 2–10.

## Herdadas do slice (Capítulo 1)

- Intervalo de recarga do Perfect Block e efeito de passivas sobre ele.
- Conversão do "−20% de resistência a postura" do Desequilíbrio.
- Tenacidade contra a Contenção Arcana da Íris em elite, minichefe e chefe.
- Cláusulas de Guarda que ficaram dormentes no slice.
- Detalhe em [capitulos/CAPITULO_01](capitulos/CAPITULO_01.md#4-regras-locais-do-slice).
