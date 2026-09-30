# Argos — relatório `slice_balance`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `69f2d29739f9ec392514332b89d440ad453da3da5ad1491a5e3a2c1603a7ac2c`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 0%; líderes: guardiao/critico/lumen, guardiao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 14/18 combinações vencedoras fora; mediana 112 s; pior retaliacao_tele/marca/arcano nível 10: 94 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/critico/lumen** — nível 7.0 (meta 9–12), 3.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/marca/lumen** — nível 6.5 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao/critico/lumen** — nível 8.0 (meta 9–12), 4.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao/marca/lumen** — nível 7.5 (meta 9–12), 3.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/critico/lumen** — nível 6.5 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/controle** — nível 8.0 (meta 9–12), 4.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 15; sem lumen: 9; guardiao/critico/controle, guardiao/critico/lumen, guardiao/marca/arcano, guardiao/marca/controle, guardiao/marca/lumen, retaliacao/critico/controle, retaliacao/critico/lumen, retaliacao/marca/controle, retaliacao/marca/lumen, retaliacao_tele/critico/arcano, retaliacao_tele/critico/controle, retaliacao_tele/critico/lumen, retaliacao_tele/marca/arcano, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 74% | 0 |
| guardiao/critico/arcano | 12 | 33% | +0 p.p. | c1_5_2_a | 78% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/critico/controle | 10 | 100% | +67 p.p. |  | 74% | 0 |
| guardiao/critico/controle | 12 | 100% | +0 p.p. |  | 76% | 0 |
| guardiao/critico/lumen | 8 | 100% | +17 p.p. |  | 78% | 1718 |
| guardiao/critico/lumen | 10 | 100% | +0 p.p. |  | 79% | 1625 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 81% | 1601 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 65% | 0 |
| guardiao/marca/arcano | 10 | 50% | +17 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/marca/arcano | 12 | 100% | +0 p.p. |  | 77% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 0 |
| guardiao/marca/controle | 10 | 100% | +17 p.p. |  | 69% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 79% | 0 |
| guardiao/marca/lumen | 8 | 100% | +0 p.p. |  | 78% | 1429 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 76% | 1452 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 81% | 1401 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 56% | 0 |
| retaliacao/critico/arcano | 10 | 17% | +17 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/critico/arcano | 12 | 100% | +67 p.p. |  | 75% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao/critico/controle | 10 | 83% | +0 p.p. | c1_5_2_a | 71% | 0 |
| retaliacao/critico/controle | 12 | 83% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao/critico/lumen | 8 | 83% | -17 p.p. | c1_5_2_a | 76% | 1565 |
| retaliacao/critico/lumen | 10 | 100% | +0 p.p. |  | 79% | 1492 |
| retaliacao/critico/lumen | 12 | 100% | +0 p.p. |  | 79% | 1487 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao/marca/arcano | 10 | 33% | +17 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao/marca/arcano | 12 | 83% | +0 p.p. | c1_5_2_a | 76% | 0 |
| retaliacao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/marca/controle | 10 | 83% | -17 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 12 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao/marca/lumen | 8 | 83% | -17 p.p. | c1_5_2_a | 74% | 1407 |
| retaliacao/marca/lumen | 10 | 100% | +0 p.p. |  | 77% | 1369 |
| retaliacao/marca/lumen | 12 | 100% | +0 p.p. |  | 80% | 1270 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 60% | 0 |
| retaliacao_tele/critico/arcano | 10 | 67% | +50 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/critico/arcano | 12 | 100% | +0 p.p. |  | 75% | 0 |
| retaliacao_tele/critico/controle | 8 | 0% | -33 p.p. | c1_5_2_a | 71% | 0 |
| retaliacao_tele/critico/controle | 10 | 100% | +0 p.p. |  | 73% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao_tele/critico/lumen | 8 | 100% | +0 p.p. |  | 76% | 1429 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 76% | 1504 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 82% | 1487 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao_tele/marca/arcano | 10 | 100% | +17 p.p. |  | 70% | 0 |
| retaliacao_tele/marca/arcano | 12 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao_tele/marca/controle | 8 | 67% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/marca/controle | 10 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao_tele/marca/lumen | 8 | 100% | +0 p.p. |  | 75% | 1429 |
| retaliacao_tele/marca/lumen | 10 | 100% | +0 p.p. |  | 81% | 1349 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 80% | 1262 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 8 | 3 | elite | 100% | 16 s | 74% |
| guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | 5 | rainha | 100% | 42 s | 74% |
| guardiao/critico/arcano | 10 | 3 | elite | 100% | 11 s | 86% |
| guardiao/critico/arcano | 10 | 10 | guardiao | 100% | 133 s | 8% |
| guardiao/critico/arcano | 10 | 5 | rainha | 100% | 37 s | 77% |
| guardiao/critico/arcano | 12 | 3 | elite | 100% | 10 s | 88% |
| guardiao/critico/arcano | 12 | 10 | guardiao | 100% | 121 s | 19% |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 36 s | 79% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/controle | 8 | 10 | guardiao | 83% | 142 s | 15% |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 48 s | 76% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 13 s | 87% |
| guardiao/critico/controle | 10 | 10 | guardiao | 100% | 122 s | 27% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 43 s | 81% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 117 s | 34% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 40 s | 80% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 17 s | 78% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 100% | 138 s | 36% |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 82% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 13 s | 89% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 126 s | 48% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 43 s | 81% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 12 s | 91% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 120 s | 52% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 41 s | 86% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 14 s | 80% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 70% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 88% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 100% | 112 s | 20% |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 34 s | 78% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 92 s | 38% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 32 s | 78% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 16 s | 76% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 123 s | 26% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 78% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 110 s | 38% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 38 s | 79% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 11 s | 91% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 104 s | 45% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 36 s | 81% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 16 s | 81% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 125 s | 38% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 42 s | 82% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 12 s | 91% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 114 s | 50% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 39 s | 82% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 11 s | 91% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 105 s | 56% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 36 s | 82% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 14 s | 76% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 9 s | 89% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 100% | 107 s | 29% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 36 s | 78% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 91% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 100 s | 37% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 33 s | 83% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 15 s | 79% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 67% | 131 s | 20% |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 44 s | 79% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 12 s | 82% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 100% | 116 s | 41% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 40 s | 78% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 11 s | 87% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 111 s | 47% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 131 s | 37% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 45 s | 79% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 85% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 120 s | 44% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 41 s | 83% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 11 s | 91% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 112 s | 58% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 39 s | 84% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 13 s | 79% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 76% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 88% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 100% | 94 s | 36% |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 31 s | 78% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 89 s | 45% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 29 s | 81% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 14 s | 80% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 50% | 132 s | 3% |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 40 s | 79% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 10 s | 84% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 104 s | 37% |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 35 s | 80% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 10 s | 85% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 101 s | 45% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 33 s | 82% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 73% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 122 s | 36% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 78% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 11 s | 87% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 106 s | 56% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 37 s | 83% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 88% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 102 s | 57% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 33 s | 87% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 15 s | 74% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 100% | 128 s | 19% |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 76% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 11 s | 84% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 111 s | 31% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 35 s | 81% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 10 s | 87% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 101 s | 40% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 33 s | 82% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 16 s | 79% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 100% | 127 s | 32% |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 12 s | 85% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 117 s | 44% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 40 s | 80% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 11 s | 85% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 110 s | 50% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 38 s | 83% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 129 s | 50% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 80% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 12 s | 84% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 118 s | 56% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 82% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 11 s | 89% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 111 s | 69% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 38 s | 86% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 13 s | 78% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 100% | 135 s | 18% |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 37 s | 77% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 9 s | 85% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 94 s | 42% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 32 s | 80% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 9 s | 88% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 89 s | 52% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 30 s | 82% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 14 s | 79% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 118 s | 34% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 39 s | 79% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 10 s | 84% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 104 s | 48% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 10 s | 85% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 101 s | 55% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 34 s | 83% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 120 s | 53% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 74% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 11 s | 84% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 105 s | 62% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 10 s | 88% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 102 s | 66% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 34 s | 85% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 6.0 | 11.0 |
| guardiao/critico/controle | 100% | 0% | 5.0 | 10.0 |
| guardiao/critico/lumen | 100% | 0% | 3.5 | 7.0 |
| guardiao/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| guardiao/marca/lumen | 100% | 0% | 3.0 | 6.5 |
| retaliacao/critico/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao/critico/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao/critico/lumen | 100% | 0% | 4.0 | 8.0 |
| retaliacao/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao/marca/lumen | 100% | 0% | 3.5 | 7.5 |
| retaliacao_tele/critico/arcano | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/critico/lumen | 100% | 0% | 3.0 | 6.5 |
| retaliacao_tele/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 8.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 3.0 | 7.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 228 | 13.5 | 4.0 | 10 | 77 |
| guardiao/critico/controle | 234 | 13.0 | 4.0 | 9 | 62 |
| guardiao/critico/lumen | 234 | 11.0 | 4.0 | 9 | 42 |
| guardiao/marca/arcano | 228 | 12.0 | 4.0 | 11 | 72 |
| guardiao/marca/controle | 233 | 13.0 | 4.0 | 10 | 62 |
| guardiao/marca/lumen | 228 | 11.0 | 4.0 | 8 | 36 |
| retaliacao/critico/arcano | 228 | 13.0 | 4.0 | 10 | 80 |
| retaliacao/critico/controle | 233 | 13.0 | 4.0 | 10 | 64 |
| retaliacao/critico/lumen | 232 | 13.0 | 4.0 | 10 | 46 |
| retaliacao/marca/arcano | 230 | 12.5 | 4.0 | 10 | 76 |
| retaliacao/marca/controle | 232 | 13.0 | 4.0 | 10 | 64 |
| retaliacao/marca/lumen | 234 | 13.0 | 4.0 | 8 | 40 |
| retaliacao_tele/critico/arcano | 231 | 12.0 | 4.0 | 10 | 61 |
| retaliacao_tele/critico/controle | 233 | 12.0 | 4.0 | 10 | 60 |
| retaliacao_tele/critico/lumen | 227 | 11.5 | 3.0 | 8 | 36 |
| retaliacao_tele/marca/arcano | 224 | 12.0 | 4.0 | 11 | 63 |
| retaliacao_tele/marca/controle | 241 | 13.0 | 4.0 | 10 | 50 |
| retaliacao_tele/marca/lumen | 227 | 12.0 | 3.0 | 8 | 39 |

Comparação com `20260930-172605_82571ad`.
