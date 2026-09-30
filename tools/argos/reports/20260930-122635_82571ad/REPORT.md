# Argos — relatório `slice_balance`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `76baabc9634f79be1a8665edf7df85cedd43aa32f7cb5c044f42c8e5d422fe2e`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 67% vs mediana 0%; líderes: retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 10** — melhor 100% vs mediana 17%; líderes: guardiao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 2/16 combinações vencedoras fora; mediana 123 s; pior retaliacao_tele/marca/controle nível 10: 117 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 13.5 (meta 9–12), 8.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/marca/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/critico/arcano** — nível 14.5 (meta 9–12), 9.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/marca/arcano** — nível 13.5 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao_tele/critico/arcano** — nível 13.0 (meta 9–12), 7.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/lumen** — nível 8.5 (meta 9–12), 4.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 5; sem lumen: 1; guardiao/critico/lumen, guardiao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| guardiao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| guardiao/critico/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/critico/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 72% | 0 |
| guardiao/critico/controle | 12 | 67% | +17 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/critico/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 94 |
| guardiao/critico/lumen | 10 | 83% | +33 p.p. | c1_5_2_a | 75% | 99 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 80% | 95 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 61% | 0 |
| guardiao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/marca/arcano | 12 | 0% | -33 p.p. | c1_5_2_a | 68% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 68% | 0 |
| guardiao/marca/controle | 10 | 33% | +33 p.p. | c1_5_2_a | 72% | 0 |
| guardiao/marca/controle | 12 | 83% | -17 p.p. | c1_5_2_a | 75% | 0 |
| guardiao/marca/lumen | 8 | 0% | -17 p.p. | c1_5_2_a | 74% | 94 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 78% | 90 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 82% | 85 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 55% | 0 |
| retaliacao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 58% | 0 |
| retaliacao/critico/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao/critico/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao/critico/controle | 12 | 33% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao/critico/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 80 |
| retaliacao/critico/lumen | 10 | 33% | +17 p.p. | c1_5_2_a | 74% | 90 |
| retaliacao/critico/lumen | 12 | 83% | +0 p.p. | c1_5_2_a | 73% | 85 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 57% | 0 |
| retaliacao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 63% | 0 |
| retaliacao/marca/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/marca/controle | 8 | 17% | +17 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao/marca/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao/marca/controle | 12 | 67% | +67 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 77 |
| retaliacao/marca/lumen | 10 | 33% | +17 p.p. | c1_5_2_a | 71% | 81 |
| retaliacao/marca/lumen | 12 | 67% | +17 p.p. | c1_5_2_a | 72% | 85 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 55% | 0 |
| retaliacao_tele/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 57% | 0 |
| retaliacao_tele/critico/arcano | 12 | 0% | -17 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao_tele/critico/controle | 8 | 17% | +17 p.p. | c1_5_2_a | 65% | 0 |
| retaliacao_tele/critico/controle | 10 | 33% | -50 p.p. | c1_5_2_a | 70% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 75% | 0 |
| retaliacao_tele/critico/lumen | 8 | 67% | +50 p.p. | c1_5_2_a | 63% | 88 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 74% | 81 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 75% | 85 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 50% | 0 |
| retaliacao_tele/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao_tele/marca/arcano | 12 | 50% | +17 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao_tele/marca/controle | 8 | 17% | +17 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao_tele/marca/controle | 10 | 83% | +33 p.p. | c1_5_2_a | 70% | 0 |
| retaliacao_tele/marca/controle | 12 | 83% | -17 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao_tele/marca/lumen | 8 | 67% | +33 p.p. | c1_5_2_a | 67% | 88 |
| retaliacao_tele/marca/lumen | 10 | 100% | +17 p.p. |  | 75% | 81 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 75% | 79 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 8 | 3 | elite | 100% | 17 s | 70% |
| guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | 5 | rainha | 100% | 43 s | 73% |
| guardiao/critico/arcano | 10 | 3 | elite | 100% | 16 s | 75% |
| guardiao/critico/arcano | 10 | 10 | guardiao | 17% | 123 s | 11% |
| guardiao/critico/arcano | 10 | 5 | rainha | 100% | 40 s | 76% |
| guardiao/critico/arcano | 12 | 3 | elite | 100% | 14 s | 81% |
| guardiao/critico/arcano | 12 | 10 | guardiao | 83% | 128 s | 12% |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 38 s | 78% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 18 s | 76% |
| guardiao/critico/controle | 8 | 10 | guardiao | 33% | 153 s | 7% |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 48 s | 74% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/controle | 10 | 10 | guardiao | 100% | 126 s | 25% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 46 s | 77% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 15 s | 85% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 119 s | 37% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 43 s | 78% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 18 s | 78% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 67% | 155 s | 5% |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 50 s | 79% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 18 s | 78% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 130 s | 27% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 48 s | 81% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 16 s | 83% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 123 s | 40% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 45 s | 83% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 15 s | 76% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 42 s | 71% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 14 s | 81% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 40 s | 74% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 14 s | 82% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 121 s | 13% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 37 s | 78% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 18 s | 73% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 136 s | 19% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 46 s | 75% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 16 s | 73% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 122 s | 29% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 43 s | 77% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 15 s | 75% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 116 s | 33% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 42 s | 82% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 18 s | 77% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 67% | 141 s | 22% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 48 s | 77% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 17 s | 79% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 128 s | 32% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 44 s | 81% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 16 s | 80% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 120 s | 39% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 42 s | 85% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 15 s | 71% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 41 s | 70% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 14 s | 75% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 67% | 121 s | 15% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 39 s | 73% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 14 s | 78% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 114 s | 21% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 36 s | 79% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 16 s | 75% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 17% | 132 s | 13% |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 46 s | 77% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 15 s | 81% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 83% | 129 s | 18% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 14 s | 82% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 115 s | 29% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 40 s | 80% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 17 s | 70% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 130 s | 27% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 47 s | 72% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 16 s | 82% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 123 s | 44% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 44 s | 77% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 15 s | 81% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 118 s | 43% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 14 s | 74% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 17% | 127 s | 11% |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 40 s | 71% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 12 s | 79% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 100% | 129 s | 9% |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 38 s | 74% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 12 s | 82% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 115 s | 23% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 34 s | 80% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 16 s | 75% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 33% | 145 s | 5% |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 44 s | 76% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 15 s | 80% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 41 s | 79% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 14 s | 82% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 113 s | 31% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 40 s | 82% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 16 s | 70% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 17% | 151 s | 1% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 45 s | 74% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 15 s | 82% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 122 s | 32% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 43 s | 74% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 15 s | 80% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 115 s | 46% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 41 s | 82% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 16 s | 69% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 67% | 125 s | 15% |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 41 s | 70% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 14 s | 73% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 122 s | 22% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 38 s | 74% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 13 s | 75% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 105 s | 40% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 36 s | 79% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 17 s | 77% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 100% | 125 s | 38% |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 44 s | 77% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 15 s | 81% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 118 s | 42% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 41 s | 78% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 15 s | 82% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 113 s | 48% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 40 s | 79% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 17 s | 72% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 129 s | 38% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 75% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 16 s | 83% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 122 s | 51% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 44 s | 80% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 15 s | 83% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 116 s | 54% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 42 s | 82% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 14 s | 73% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 17% | 148 s | 1% |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 39 s | 71% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 13 s | 77% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 127 s | 25% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 37 s | 75% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 12 s | 81% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 119 s | 29% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 34 s | 80% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 17 s | 77% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 124 s | 37% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 42 s | 77% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 15 s | 81% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 117 s | 42% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 14 s | 81% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 112 s | 42% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 39 s | 80% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 17 s | 71% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 127 s | 45% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 45 s | 78% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 15 s | 82% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 120 s | 49% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 43 s | 80% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 15 s | 81% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 114 s | 54% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 40 s | 80% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 8.5 | 13.5 |
| guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| guardiao/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/arcano | 100% | 0% | 8.0 | 13.0 |
| guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| guardiao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao/critico/arcano | 100% | 0% | 9.5 | 14.5 |
| retaliacao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| retaliacao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| retaliacao/marca/arcano | 100% | 0% | 8.0 | 13.5 |
| retaliacao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| retaliacao/marca/lumen | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/critico/arcano | 100% | 0% | 7.0 | 13.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 11.5 |
| retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 4.0 | 8.5 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 235 | 12.0 | 4.0 | 14 | 106 |
| guardiao/critico/controle | 237 | 13.0 | 4.0 | 11 | 80 |
| guardiao/critico/lumen | 237 | 13.0 | 5.0 | 10 | 52 |
| guardiao/marca/arcano | 228 | 13.0 | 4.0 | 12 | 102 |
| guardiao/marca/controle | 237 | 13.0 | 4.0 | 10 | 66 |
| guardiao/marca/lumen | 238 | 13.0 | 4.0 | 10 | 50 |
| retaliacao/critico/arcano | 232 | 13.0 | 4.0 | 12 | 118 |
| retaliacao/critico/controle | 237 | 13.0 | 4.0 | 12 | 82 |
| retaliacao/critico/lumen | 237 | 13.0 | 4.0 | 10 | 64 |
| retaliacao/marca/arcano | 231 | 13.0 | 4.0 | 12 | 101 |
| retaliacao/marca/controle | 236 | 13.0 | 4.5 | 12 | 80 |
| retaliacao/marca/lumen | 237 | 13.0 | 4.0 | 10 | 60 |
| retaliacao_tele/critico/arcano | 237 | 13.0 | 4.0 | 14 | 95 |
| retaliacao_tele/critico/controle | 238 | 13.0 | 5.0 | 10 | 50 |
| retaliacao_tele/critico/lumen | 235 | 13.0 | 5.0 | 10 | 49 |
| retaliacao_tele/marca/arcano | 234 | 13.0 | 4.0 | 10 | 80 |
| retaliacao_tele/marca/controle | 238 | 13.0 | 4.5 | 10 | 53 |
| retaliacao_tele/marca/lumen | 234 | 13.0 | 4.5 | 8 | 44 |

Comparação com `20260930-113407_17cd40c`.
