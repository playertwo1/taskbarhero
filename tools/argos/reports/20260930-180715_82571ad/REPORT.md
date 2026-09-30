# Argos — relatório `slice_balance`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `a835ba0bdaab8b21c67492b0fb05b303789f83c6b0d94afdf3b1d57027e274ab`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 0%; líderes: retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 10** — melhor 100% vs mediana 33%; líderes: guardiao/critico/lumen, guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/critico/lumen** — nível 8.0 (meta 9–12), 4.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 8; sem lumen: 2; guardiao/critico/lumen, guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/controle, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 80% | 0 |
| guardiao/critico/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 84% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 77% | 0 |
| guardiao/critico/controle | 10 | 17% | +17 p.p. | c1_5_2_a | 81% | 0 |
| guardiao/critico/controle | 12 | 67% | +50 p.p. | c1_5_2_a | 80% | 0 |
| guardiao/critico/lumen | 8 | 83% | +83 p.p. | c1_5_2_a | 87% | 1994 |
| guardiao/critico/lumen | 10 | 100% | +0 p.p. |  | 84% | 2002 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 86% | 1876 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 0 |
| guardiao/marca/arcano | 10 | 17% | +17 p.p. | c1_5_2_a | 80% | 0 |
| guardiao/marca/arcano | 12 | 33% | -17 p.p. | c1_5_2_a | 82% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 79% | 0 |
| guardiao/marca/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 75% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 82% | 0 |
| guardiao/marca/lumen | 8 | 83% | +33 p.p. | c1_5_2_a | 82% | 1784 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 81% | 1840 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 86% | 1788 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao/critico/arcano | 10 | 17% | +17 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao/critico/arcano | 12 | 33% | +33 p.p. | c1_5_2_a | 84% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 76% | 0 |
| retaliacao/critico/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 78% | 0 |
| retaliacao/critico/controle | 12 | 67% | +67 p.p. | c1_5_2_a | 83% | 0 |
| retaliacao/critico/lumen | 8 | 67% | +67 p.p. | c1_5_2_a | 83% | 1889 |
| retaliacao/critico/lumen | 10 | 100% | +0 p.p. |  | 86% | 1891 |
| retaliacao/critico/lumen | 12 | 100% | +0 p.p. |  | 84% | 1759 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 78% | 0 |
| retaliacao/marca/arcano | 12 | 33% | +33 p.p. | c1_5_2_a | 81% | 0 |
| retaliacao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao/marca/controle | 10 | 33% | +33 p.p. | c1_5_2_a | 81% | 0 |
| retaliacao/marca/controle | 12 | 100% | +50 p.p. |  | 80% | 0 |
| retaliacao/marca/lumen | 8 | 67% | +50 p.p. | c1_5_2_a | 78% | 1679 |
| retaliacao/marca/lumen | 10 | 100% | +0 p.p. |  | 83% | 1672 |
| retaliacao/marca/lumen | 12 | 100% | +0 p.p. |  | 83% | 1648 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao_tele/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 78% | 0 |
| retaliacao_tele/critico/arcano | 12 | 100% | +33 p.p. |  | 84% | 0 |
| retaliacao_tele/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 80% | 0 |
| retaliacao_tele/critico/controle | 10 | 83% | +83 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 83% | 0 |
| retaliacao_tele/critico/lumen | 8 | 100% | +0 p.p. |  | 84% | 1784 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 83% | 1823 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 88% | 1759 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao_tele/marca/arcano | 10 | 33% | +33 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao_tele/marca/arcano | 12 | 100% | +33 p.p. |  | 85% | 0 |
| retaliacao_tele/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 76% | 0 |
| retaliacao_tele/marca/controle | 10 | 100% | +33 p.p. |  | 82% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% | +0 p.p. |  | 82% | 0 |
| retaliacao_tele/marca/lumen | 8 | 100% | +0 p.p. |  | 81% | 1784 |
| retaliacao_tele/marca/lumen | 10 | 100% | +0 p.p. |  | 85% | 1641 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 85% | 1659 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 8 | 3 | elite | 100% | 15 s | 80% |
| guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | 5 | rainha | 100% | 41 s | 80% |
| guardiao/critico/arcano | 10 | 3 | elite | 100% | 11 s | 91% |
| guardiao/critico/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 10 | 5 | rainha | 100% | 36 s | 83% |
| guardiao/critico/arcano | 12 | 3 | elite | 100% | 10 s | 92% |
| guardiao/critico/arcano | 12 | 10 | guardiao | 33% | 134 s | 17% |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 34 s | 85% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 17 s | 83% |
| guardiao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 46 s | 83% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 12 s | 94% |
| guardiao/critico/controle | 10 | 10 | guardiao | 83% | 168 s | 17% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 41 s | 84% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 12 s | 95% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 155 s | 20% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 39 s | 86% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 17 s | 86% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 100% | 177 s | 31% |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 47 s | 88% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 13 s | 95% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 161 s | 41% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 42 s | 87% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 12 s | 95% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 153 s | 53% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 40 s | 90% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 14 s | 86% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 77% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 93% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 17% | 143 s | 2% |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 32 s | 82% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 8 s | 94% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 126 s | 21% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 31 s | 84% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 15 s | 83% |
| guardiao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 84% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 11 s | 95% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 140 s | 31% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 37 s | 85% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 10 s | 95% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 133 s | 34% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 35 s | 86% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 86% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 161 s | 32% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 41 s | 87% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 12 s | 95% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 144 s | 53% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 38 s | 89% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 11 s | 96% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 136 s | 57% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 35 s | 88% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 14 s | 82% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 81% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 9 s | 94% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 17% | 136 s | 18% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 34 s | 82% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 95% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 130 s | 21% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 32 s | 86% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 15 s | 84% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 41 s | 86% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 11 s | 91% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 100% | 151 s | 26% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 37 s | 88% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 11 s | 92% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 140 s | 31% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 35 s | 89% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 15 s | 79% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 172 s | 26% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 84% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 90% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 153 s | 46% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 88% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 11 s | 96% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 145 s | 54% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 38 s | 88% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 12 s | 86% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 84% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 8 s | 93% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 83% | 131 s | 20% |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 30 s | 83% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 8 s | 94% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 115 s | 33% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 28 s | 86% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 14 s | 85% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 38 s | 85% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 10 s | 89% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 83% | 136 s | 37% |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 34 s | 88% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 9 s | 90% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 127 s | 39% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 32 s | 86% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 80% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 152 s | 34% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 39 s | 84% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 10 s | 93% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 137 s | 53% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 34 s | 90% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 93% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 131 s | 54% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 31 s | 91% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 14 s | 80% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 38 s | 82% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 11 s | 89% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 138 s | 24% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 34 s | 86% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 10 s | 92% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 129 s | 29% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 31 s | 87% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 15 s | 84% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 33% | 172 s | 16% |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 41 s | 86% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 11 s | 89% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 150 s | 34% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 39 s | 87% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 10 s | 89% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 140 s | 42% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 37 s | 88% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 15 s | 81% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 168 s | 47% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 43 s | 87% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 12 s | 93% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 152 s | 58% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 39 s | 88% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 11 s | 94% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 145 s | 59% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 36 s | 90% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 13 s | 84% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 8 s | 90% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 145 s | 15% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 31 s | 85% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 8 s | 92% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 115 s | 39% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 29 s | 87% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 14 s | 85% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 150 s | 31% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 39 s | 82% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 10 s | 88% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 134 s | 45% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 35 s | 88% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 10 s | 90% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 127 s | 49% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 32 s | 89% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 14 s | 83% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 151 s | 51% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 39 s | 83% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 11 s | 91% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 136 s | 59% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 34 s | 89% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 10 s | 93% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 130 s | 65% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 32 s | 90% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| guardiao/critico/controle | 100% | 0% | 5.5 | 10.5 |
| guardiao/critico/lumen | 100% | 0% | 4.5 | 9.0 |
| guardiao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| guardiao/marca/controle | 100% | 0% | 5.5 | 10.5 |
| guardiao/marca/lumen | 100% | 0% | 4.5 | 9.0 |
| retaliacao/critico/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao/critico/controle | 100% | 0% | 6.0 | 11.5 |
| retaliacao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| retaliacao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao/marca/lumen | 100% | 0% | 4.5 | 9.0 |
| retaliacao_tele/critico/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 8.0 |
| retaliacao_tele/marca/arcano | 100% | 0% | 5.5 | 10.5 |
| retaliacao_tele/marca/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 3.0 | 7.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 230 | 13.0 | 4.0 | 12 | 98 |
| guardiao/critico/controle | 231 | 13.0 | 4.0 | 10 | 68 |
| guardiao/critico/lumen | 233 | 13.0 | 4.0 | 10 | 53 |
| guardiao/marca/arcano | 227 | 12.0 | 4.0 | 12 | 84 |
| guardiao/marca/controle | 234 | 12.0 | 4.0 | 10 | 68 |
| guardiao/marca/lumen | 232 | 11.0 | 4.0 | 9 | 56 |
| retaliacao/critico/arcano | 227 | 13.0 | 4.0 | 12 | 78 |
| retaliacao/critico/controle | 233 | 13.0 | 4.0 | 12 | 80 |
| retaliacao/critico/lumen | 232 | 13.0 | 4.0 | 11 | 62 |
| retaliacao/marca/arcano | 228 | 12.0 | 4.0 | 10 | 84 |
| retaliacao/marca/controle | 228 | 13.0 | 4.0 | 10 | 68 |
| retaliacao/marca/lumen | 234 | 13.0 | 4.0 | 10 | 55 |
| retaliacao_tele/critico/arcano | 227 | 12.0 | 4.0 | 11 | 69 |
| retaliacao_tele/critico/controle | 233 | 12.0 | 4.0 | 11 | 62 |
| retaliacao_tele/critico/lumen | 227 | 11.5 | 3.5 | 8 | 50 |
| retaliacao_tele/marca/arcano | 224 | 12.5 | 4.0 | 11 | 66 |
| retaliacao_tele/marca/controle | 236 | 13.0 | 4.0 | 10 | 61 |
| retaliacao_tele/marca/lumen | 229 | 12.5 | 3.5 | 8 | 39 |

Comparação com `20260930-174431_82571ad`.
