---
document_type: balance-domain
id: BALANCE_V1_09_DIFICULDADE_ENDGAME
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 04_ITENS_RARIDADE, 06_INIMIGOS_CHEFES]
---

# 09 — Dificuldades e endgame

**DECIDIDO (Rafael, 2026-09-30):** o loop de longo prazo são capítulos rejogáveis em camadas de dificuldade, com loot das raridades 5–9 e Relíquias. Sem reset de progresso (prestígio fica fora da v1).

## 1. Princípio

Dificuldade não é só HP inflado: cada camada combina modificadores de status, composição, affixes e mecânicas. Se uma camada aumenta o TTK sem criar decisão nova, é `FAIL`. A partir de D2: novos padrões, affixes obrigatórios, composição mais inteligente, telegraphs mais rápidos, janelas menores, mecânicas opcionais de risco e recompensa. D0 nunca exige build específica; D3 pode exigir otimização.

## 2. Camadas

Nomes de UI EM ABERTO. D0 = Normal. Cada camada abre depois de vencer o capítulo 10 na camada anterior (RECOMENDADO), e então todos os capítulos ficam disponíveis nela.

| Camada | HP | ATK | DEF | Orçamento de encontro | Recompensa | Raridades liberadas | Affixes de elite |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| D0 Normal | ×1,00 | ×1,00 | ×1,00 | ×1,00 | ×1,00 | 1–4 | 0–1 |
| D1 | ×1,25 | ×1,12 | ×1,05 | ×1,10 | ×1,10 | até 5–6 | 1 |
| D2 | ×1,60 | ×1,25 | ×1,10 | ×1,20 | ×1,25 | até 7–8 | 1–2 |
| D3 | ×2,10 | ×1,40 | ×1,15 | ×1,30 | ×1,50 | até 9 | 2 |

Multiplicadores herdados (HIPÓTESE). "Recompensa" é orçamento de recompensa, não necessariamente chance literal. A camada entra na ordem: referência → arquétipo → rank → nível → **dificuldade** → affix → efeitos temporários.

## 3. Teto por camada

- Teto global no Normal: chefe ≤ ~1 milhão de HP, golpe ≤ ~10 mil ([00 §8](00_CONSTITUICAO.md#8-teto-numérico--decidido-rafael-2026-09-30)).
- Com a curva-mestra, o chefe do capítulo 10 no Normal tem ~526 mil de HP; em D3 (×2,10) teria ~1,1 milhão, acima do teto. **EM ABERTO ([11 D-07](11_DECISOES_ABERTAS.md)):** (a) limitar o HP de D3 a ×1,9 e compensar em ATK/mecânicas (RECOMENDADO); (b) teto próprio de 2 milhões para as dificuldades; (c) reduzir o HP de party do chefe.
- Golpe comum do chefe do capítulo 10 em D3: ~1,1 mil; golpe telegrafado forte (×3–4): ~4 mil. Dentro do teto.

## 4. Progressão no endgame

- Nível máximo 100; o crescimento continua por raridades 5–9 (poder do set de +42% a +80%), Relíquias, Reforço, Mastery 1–10 e nós tardios da Árvore.
- A fatia de poder no endgame segue a faixa "Capítulo 10 e dificuldades" da [constituição §4](00_CONSTITUICAO.md#4-orçamento-de-poder).
- XP de Mastery vem das camadas D1–D3.
- IP continua na faixa do capítulo (máximo 100); a camada libera raridade, não IP.

## 5. Testes por camada

Herói de referência; builds ofensiva, defensiva e de controle; equipamento abaixo, esperado e acima; chefe; elite; encontro com vários arquétipos.
