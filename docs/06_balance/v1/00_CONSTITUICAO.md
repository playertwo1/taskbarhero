---
document_type: balance-constitution
id: BALANCE_V1_00_CONSTITUICAO
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: []
---

# 00 — Constituição do balanceamento

Regras que **todos** os domínios obedecem. Um domínio pode detalhar, nunca contradizer. Se precisar mudar algo aqui, a mudança é decisão de Rafael e entra no histórico do [README](README.md).

## 1. Precedência

1. Decisão mais recente de Rafael (registrada com data no documento afetado).
2. Esta constituição.
3. O domínio v1 dono do assunto (mapa no [README](README.md)).
4. `/data` para os valores que o jogo carrega; divergência com a v1 vira achado em [BALANCE_FINDINGS](../../08_qa/BALANCE_FINDINGS.md).
5. Perfis de capítulo ([capitulos/](capitulos/)) só definem valores **locais**: nunca mudam fórmula, cap ou orçamento global.
6. Propostas, DOCX e guias são contexto; não aprovam números.

## 2. Unidade e escala — DECIDIDO (Rafael, 2026-09-30)

- `combat_scale = 10`: HP, ATK, DEF de heróis e inimigos, referências de item, `DEFENSE_K` e dano mínimo são multiplicados por 10 ao carregar. Os JSON guardam valores 1×.
- **Não escalam:** percentuais, chances, caps, durações, cooldowns, velocidade de ataque, ratings de Skill Haste e Tenacidade, Guarda, stagger/postura, XP e custos em recursos.
- Percentual interno é decimal (`15% = 0.15`); Haste e Tenacidade são ratings.
- Runtime guarda precisão total; só a UI arredonda ([04 §9](04_ITENS_RARIDADE.md#9-exibição-de-números)).

## 3. Curva-mestra — única para o jogo inteiro

- **Nível de conteúdo** `L` = 1–100. **Capítulo** `c = ⌈L/10⌉`: o capítulo `c` cobre os níveis `10c−9` a `10c` (DECIDIDO, 2026-09-30: 10 capítulos, 10 níveis cada).
- **Curva de nível** (DECIDIDO, `p = 0,8`): `valor(L) = v1 + (v100 − v1) × ((L−1)/99)^p`. Vale para heróis, herói de referência e referências de item.
- **Herói de referência** `REF(L)`: HP 115→470, ATK 12→50, DEF 9→36 (×10 em runtime), AS 1,0, crítico 5%, dano crítico 1,5×. Não é jogável; é a régua de tudo ([06 §1](06_INIMIGOS_CHEFES.md#1-herói-de-referência)).
- **Inimigo** = `REF(L) × arquétipo × rank × 1,08^(c−1) × dificuldade × escalas locais do capítulo`. O fator ×1,08 por capítulo é DECIDIDO como direção e HIPÓTESE como valor.
- Nenhum domínio cria outra curva. Um sistema que precise crescer com o jogo cresce por `REF(L)`, por capítulo `c` ou por Item Power ([04](04_ITENS_RARIDADE.md)).

Referência numérica calculada (10×, `p = 0,8`, chefe HEAVY, HP de party ×2 como no Capítulo 1; HIPÓTESE):

| Capítulo | Nível do chefe | REF HP | REF ATK | Fator do capítulo | HP do chefe (Normal) | Golpe comum do chefe |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 10 | 1 671 | 176 | 1,00 | ~94 mil | ~134 |
| 3 | 30 | 2 479 | 262 | 1,17 | ~162 mil | ~234 |
| 5 | 50 | 3 172 | 336 | 1,36 | ~242 mil | ~350 |
| 7 | 70 | 3 809 | 405 | 1,59 | ~339 mil | ~491 |
| 10 | 100 | 4 700 | 500 | 2,00 | ~526 mil | ~765 |

## 4. Orçamento de poder

**DECIDIDO (Rafael, 2026-09-30):** divisão equilibrada, com nenhuma fonte resolvendo uma parede sozinha: **nível ~30% · equipamento + craft ~30% · kit (ranks, passivas, Traits, Mastery) ~25% · meta de conta (Árvore, Hub) ~15%**.

**Como medir — RECOMENDADO, confirmar ([11 D-01](11_DECISOES_ABERTAS.md)):** a pergunta original foi "herói completo do nível 100 contra herói nu do nível 1". Nessa régua o nível sozinho multiplica o poder por ~16× (ATK ×4 e EHP ×4), enquanto o melhor conjunto de equipamento dá +80%: a divisão 30/30 nunca fecharia. Por isso a v1 mede **o ganho dentro de cada capítulo**, que é o que o jogador sente entre tentativas:

```text
poder efetivo da party  P = DPS sustentado da party × EHP médio da party
ganho do capítulo       G = P(ao vencer o chefe do capítulo) / P(ao entrar no capítulo)
fatia da fonte          s = ln(ganho atribuído à fonte) / ln(G)
```

A atribuição é feita pelo Argos por ablação (desliga a fonte, mede de novo). Fatias-alvo por faixa (HIPÓTESE; o início pesa mais em nível e itens porque kit e meta ainda estão fechados):

| Faixa | Nível | Equipamento + craft | Kit | Meta |
| --- | ---: | ---: | ---: | ---: |
| Capítulos 1–3 | 40% | 35% | 20% | 5% |
| Capítulos 4–6 | 35% | 30% | 25% | 10% |
| Capítulos 7–9 | 30% | 30% | 25% | 15% |
| Capítulo 10 e dificuldades | 30% | 30% | 25% | 15% |

Tolerância: ±10 pontos por fonte. Fora disso é achado `BALANCE`. Nenhum domínio pode, sozinho, ultrapassar sua fatia; se precisar, outro domínio cede e a mudança é registrada.

## 5. Poder da party e teto de sinergia

- O jogo é um trio: além do herói isolado, medir `P` da party. Suportes (Íris hoje; Orvalho e Sino depois) são avaliados pelo que acrescentam aos aliados.
- **Teto de sinergia (HIPÓTESE):** efeitos de aliados somam por categoria antes de multiplicar e param nestes tetos, além dos caps de [01](01_STATUS_E_COMBATE.md#4-caps):

| Categoria vinda de aliados | Teto somado |
| --- | ---: |
| Bônus de ATK / dano | +50% |
| Redução de dano recebido | −50% (o piso de `damage_taken` global é 0,25) |
| Escudos concedidos | 50% do HP máximo do alvo |
| Cura recebida por segundo | 6% do HP máximo do alvo |
| Vulnerabilidade aplicada no inimigo | +25% |
| Aceleração (Haste) concedida | +50 de rating |

- Uma dupla que sozinha vence um capítulo 2 ou mais níveis antes da meta é achado (caso real: BAL-010, Lúmen + Véu).

## 6. Jogador de referência por capítulo

Contrato que todos os domínios consomem: balanceia-se o capítulo 7 sem que ele exista. Valores HIPÓTESE, medidos pelo cenário do Argos "jogador de referência" ([10 §4](10_TELEMETRIA_ARGOS.md#4-jogador-de-referência-no-argos)).

| Capítulo | Nível ao vencer o chefe | Raridade típica equipada (Normal) | IP típico | Ranks médios de skill | Nós da Árvore | Horas online | Horas com offline |
| ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | 10–11 (DECIDIDO) | Incomum/Raro | 15–27 | 2 | 5–6 | 2–3 | 2–3 |
| 2 | 20–21 | Raro | 22–35 | 2–3 | 8–10 | 3–4 | 2,5–3,5 |
| 3 | 30–31 | Raro/Épico | 30–42 | 3 | 11–14 | 4–5 | 3–4 |
| 4 | 40–41 | Épico | 37–50 | 3 | 15–18 | 5–6 | 4–5 |
| 5 | 50–51 | Épico | 45–57 | 3–4 | 19–23 | 6–7 | 4,5–5,5 |
| 6 | 60–61 | Épico | 52–65 | 4 | 24–28 | 7–8 | 5–6 |
| 7 | 70–71 | Épico + Relíquia | 60–72 | 4 | 29–33 | 8–9 | 6–7 |
| 8 | 80–81 | Épico + Relíquia | 67–80 | 4–5 | 34–40 | 9–10 | 6,5–7,5 |
| 9 | 90–91 | Épico + Relíquia | 75–87 | 5 | 41–48 | 10–11 | 7–8 |
| 10 | 100 | Épico + Relíquia + Memória | 82–99 | 5 | 49–56 | 12–14 | 8,5–10 |

- Total Normal: ~66–77 h online. O offline ([07 §9](07_ECONOMIA_LOOT.md#9-progresso-offline)) nunca responde por mais de ~30% do progresso.
- Níveis de raridade 5–9 existem só nas dificuldades ([09](09_DIFICULDADE_ENDGAME.md)).
- Os nós da Árvore assumem o alvo de ~84 nós no jogo final ([08](08_META.md)).

## 7. Alvos globais

| Alvo | Valor | Estado |
| --- | --- | --- |
| Chefe do capítulo vencido no nível | `10c` a `10c+1` | DECIDIDO para o Cap. 1 (10–11); HIPÓTESE para os demais |
| Tentativas até vencer o chefe | 3–8 | HIPÓTESE (tolerância do Argos) |
| Vitória na 1ª tentativa em fase comum | 40–60% | HIPÓTESE (meta humana, medida em playtest) |
| TTK (herói/party no nível do conteúdo, equipamento típico) | comum 3–8 s · elite 15–30 s · minichefe 40–75 s · chefe 120–210 s | herdado; HIPÓTESE |
| Diferença de tempo de vitória entre builds igualmente equipadas | ≤ 15% em conteúdo neutro | herdado |
| Caminhos viáveis por conteúdo | > 1, e > 1 sem cura | DECIDIDO (Rafael, 2026-09-29) |
| HP ao voltar ao Hub | cheio; na expedição só o fôlego | DECIDIDO (Rafael, 2026-09-29) |

## 8. Teto numérico — DECIDIDO (Rafael, 2026-09-30)

- No Normal, nenhum chefe passa de ~1 milhão de HP e nenhum golpe de ~10 mil (a tabela do §3 mostra folga de ~1,9× no capítulo 10).
- As dificuldades usam essa folga e têm teto próprio ([09 §3](09_DIFICULDADE_ENDGAME.md#3-teto-por-camada)). Hoje a camada D3 herdada (HP ×2,1) passaria do teto no capítulo 10 (~1,1 milhão): ver [11 D-07](11_DECISOES_ABERTAS.md).
- Números exibidos: inteiros; abreviação a partir de 10 mil ([04 §9](04_ITENS_RARIDADE.md#9-exibição-de-números)).

## 9. Relevância e diferença de nível

- **Janela de relevância (HIPÓTESE):** um item de mesma raridade do capítulo `c` vale ≥ 80% de um item do capítulo `c+1` e ≤ 65% de um do `c+2`. O jogador troca de equipamento a cada 1–2 capítulos, e o loot antigo não vira lixo no capítulo seguinte. Medido por [04 §7](04_ITENS_RARIDADE.md#7-janela-de-relevância).
- **Diferença de nível** `Δ = nível do herói − nível do conteúdo`: sem penalidade escondida em combate (nada de "errar por estar abaixo"). A diferença aparece só pelos status. Efeitos permitidos, todos visíveis:
  - `Δ ≥ +5`: XP do encontro ×0,5; `Δ ≥ +10`: ×0,1 (anti-farm; HIPÓTESE);
  - IP do loot nunca passa da faixa da fonte ([04 §4](04_ITENS_RARIDADE.md#4-item-power-ip));
  - `Δ ≤ −3`: a UI avisa "acima do seu nível" antes de começar.

## 10. Linhas vermelhas (valem para todos os domínios)

1. A cura nunca é obrigatória nem a melhor opção em todo conteúdo.
2. Todo conteúdo tem mais de um caminho viável.
3. Equipamento não apaga a fraqueza central declarada de um herói ([02 §3](02_HEROIS.md#3-papéis-e-fraquezas-declaradas)).
4. Nenhum herói maximiza as três builds (≈75 pontos recebidos contra ≈108 possíveis).
5. O poder obtido offline nunca passa do teto de horas ([07 §9](07_ECONOMIA_LOOT.md#9-progresso-offline)).
6. Nada pago dá vantagem.
7. Sem dificuldade dinâmica escondida: o jogo não fica mais fácil em segredo depois de derrotas.
8. A velocidade de exibição (×1–×4) não muda o resultado do combate.
9. Nenhum item, craft ou respec destrói permanentemente o investimento do jogador sem confirmação explícita.

## 11. Política de mudanças de números

- Toda mudança em `/data` registra: valor anterior, novo, motivo, cenário do Argos usado e impacto esperado; e sobe `balance_version` do perfil afetado.
- **Nerf:** não reduzir o poder de um item que o jogador já possui sem compensação. Preferir reduzir a fonte futura (drop, receita) ou compensar com material/refund do investimento.
- **Save:** toda mudança de schema ou de significado de um campo salvo vem com migração de save testada. O save guarda fontes e valores-base, nunca status finais calculados.
- O Argos compara antes e depois; a comparação vai no relatório citado pela mudança.

## 12. Sem métrica, não é regra

Cada alvo e linha vermelha acima tem métrica e regra executável no Argos ou na telemetria ([10 §3](10_TELEMETRIA_ARGOS.md#3-regra--métrica)). Regra sem medida fica marcada como "não avaliada" no relatório até ganhar uma.
