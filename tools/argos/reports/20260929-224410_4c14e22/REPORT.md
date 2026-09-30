# Argos — relatório `slice_balance`

- Commit: `4c14e22` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `76baabc9634f79be1a8665edf7df85cedd43aa32f7cb5c044f42c8e5d422fe2e`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 10** — melhor 100% vs mediana 0%; líderes: guardiao/marca/lumen, retaliacao_tele/critico/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 12** — melhor 100% vs mediana 50%; líderes: guardiao/critico/lumen, guardiao/marca/controle, guardiao/marca/lumen, retaliacao_tele/critico/controle, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 15.5 (meta 9–12), 10.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/marca/arcano** — nível 13.0 (meta 9–12), 7.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/critico/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/critico/controle** — nível 13.0 (meta 9–12), 7.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/marca/arcano** — nível 14.0 (meta 9–12), 8.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/marca/controle** — nível 13.0 (meta 9–12), 7.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao_tele/critico/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 6; sem lumen: 2; guardiao/critico/lumen, guardiao/marca/lumen, retaliacao_tele/critico/controle, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 54% | 0 |
| guardiao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 63% | 0 |
| guardiao/critico/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 60% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 65% | 0 |
| guardiao/critico/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/critico/controle | 12 | 50% | +0 p.p. | c1_5_2_a | 74% | 0 |
| guardiao/critico/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 97 |
| guardiao/critico/lumen | 10 | 50% | +0 p.p. | c1_5_2_a | 77% | 105 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 77% | 98 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| guardiao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/marca/arcano | 12 | 33% | +0 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/marca/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 72% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 74% | 0 |
| guardiao/marca/lumen | 8 | 17% | +0 p.p. | c1_5_2_a | 74% | 94 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 78% | 93 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 80% | 85 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 49% | 0 |
| retaliacao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 54% | 0 |
| retaliacao/critico/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 64% | 0 |
| retaliacao/critico/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao/critico/controle | 12 | 33% | +0 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/critico/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 58% | 77 |
| retaliacao/critico/lumen | 10 | 17% | +0 p.p. | c1_5_2_a | 70% | 93 |
| retaliacao/critico/lumen | 12 | 83% | +0 p.p. | c1_5_2_a | 76% | 92 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 53% | 0 |
| retaliacao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 58% | 0 |
| retaliacao/marca/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 63% | 0 |
| retaliacao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| retaliacao/marca/controle | 12 | 0% | +0 p.p. | c1_5_2_a | 71% | 0 |
| retaliacao/marca/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 80 |
| retaliacao/marca/lumen | 10 | 17% | +0 p.p. | c1_5_2_a | 74% | 87 |
| retaliacao/marca/lumen | 12 | 50% | +0 p.p. | c1_5_2_a | 77% | 85 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 53% | 0 |
| retaliacao_tele/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 57% | 0 |
| retaliacao_tele/critico/arcano | 12 | 17% | +0 p.p. | c1_5_2_a | 61% | 0 |
| retaliacao_tele/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 64% | 0 |
| retaliacao_tele/critico/controle | 10 | 83% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 72% | 0 |
| retaliacao_tele/critico/lumen | 8 | 17% | +0 p.p. | c1_5_2_a | 61% | 88 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 73% | 87 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 75% | 85 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 50% | 0 |
| retaliacao_tele/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| retaliacao_tele/marca/arcano | 12 | 33% | +0 p.p. | c1_5_2_a | 65% | 0 |
| retaliacao_tele/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao_tele/marca/controle | 10 | 50% | +0 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% | +0 p.p. |  | 75% | 0 |
| retaliacao_tele/marca/lumen | 8 | 33% | +0 p.p. | c1_5_2_a | 65% | 91 |
| retaliacao_tele/marca/lumen | 10 | 83% | +0 p.p. | c1_5_2_a | 72% | 81 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 75% | 85 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 8 | 3 | elite | 100% | 17 s | 69% |
| guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | 5 | rainha | 100% | 46 s | 69% |
| guardiao/critico/arcano | 10 | 3 | elite | 100% | 17 s | 71% |
| guardiao/critico/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 10 | 5 | rainha | 100% | 43 s | 73% |
| guardiao/critico/arcano | 12 | 3 | elite | 100% | 14 s | 78% |
| guardiao/critico/arcano | 12 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 41 s | 74% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 19 s | 73% |
| guardiao/critico/controle | 8 | 10 | guardiao | 33% | 164 s | 3% |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 51 s | 73% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/controle | 10 | 10 | guardiao | 67% | 144 s | 11% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 48 s | 76% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 16 s | 83% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 126 s | 32% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 46 s | 78% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 19 s | 76% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 52 s | 82% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 144 s | 24% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 50 s | 79% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 17 s | 82% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 131 s | 36% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 48 s | 82% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 16 s | 74% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 43 s | 72% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 15 s | 78% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 42 s | 73% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 14 s | 79% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 83% | 130 s | 10% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 39 s | 77% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 18 s | 73% |
| guardiao/marca/controle | 8 | 10 | guardiao | 67% | 146 s | 10% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 48 s | 76% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 17 s | 73% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 129 s | 29% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 45 s | 77% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 16 s | 75% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 120 s | 37% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 42 s | 81% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 18 s | 76% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 147 s | 19% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 49 s | 81% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 18 s | 79% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 131 s | 27% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 46 s | 80% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 17 s | 79% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 124 s | 34% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 44 s | 84% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 16 s | 69% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 43 s | 66% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 15 s | 72% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 83% | 122 s | 14% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 41 s | 71% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 14 s | 73% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 117 s | 20% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 17 s | 75% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 47 s | 75% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 16 s | 77% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 17% | 150 s | 12% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 45 s | 78% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 16 s | 79% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 125 s | 28% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 18 s | 70% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 138 s | 24% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 72% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 17 s | 71% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 132 s | 27% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 47 s | 76% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 16 s | 77% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 124 s | 39% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 44 s | 78% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 15 s | 74% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 42 s | 70% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 14 s | 77% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 17% | 136 s | 2% |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 39 s | 74% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 13 s | 79% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 126 s | 17% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 37 s | 80% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 16 s | 75% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 45 s | 78% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 16 s | 76% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 42 s | 79% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 15 s | 78% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 117 s | 29% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 40 s | 82% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 17 s | 70% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 50% | 142 s | 13% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 47 s | 71% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 16 s | 71% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 128 s | 31% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 44 s | 76% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 16 s | 74% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 119 s | 43% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 42 s | 83% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 16 s | 68% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 33% | 128 s | 17% |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 43 s | 68% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 16 s | 70% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 126 s | 20% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 41 s | 71% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 14 s | 73% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 137 s | 18% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 18 s | 77% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 100% | 132 s | 33% |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 47 s | 76% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 16 s | 76% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 126 s | 40% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 43 s | 79% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 16 s | 78% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 120 s | 46% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 18 s | 71% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 136 s | 42% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 49 s | 75% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 17 s | 72% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 130 s | 48% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 47 s | 77% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 16 s | 78% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 123 s | 54% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 44 s | 81% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 15 s | 73% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 33% | 142 s | 5% |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 41 s | 70% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 14 s | 76% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 133 s | 14% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 39 s | 74% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 14 s | 78% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 115 s | 33% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 37 s | 79% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 17 s | 77% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 126 s | 39% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 44 s | 77% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 16 s | 76% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 121 s | 42% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 15 s | 80% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 115 s | 42% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 40 s | 81% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 17 s | 71% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 131 s | 39% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 47 s | 76% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 16 s | 73% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 125 s | 49% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 44 s | 81% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 16 s | 72% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 118 s | 53% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 42 s | 83% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 10.5 | 15.5 |
| guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| guardiao/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/arcano | 100% | 0% | 7.0 | 13.0 |
| guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| guardiao/marca/lumen | 100% | 0% | 4.5 | 9.5 |
| retaliacao/critico/arcano | 100% | 0% | 9.0 | 14.0 |
| retaliacao/critico/controle | 100% | 0% | 7.0 | 13.0 |
| retaliacao/critico/lumen | 100% | 0% | 5.5 | 11.0 |
| retaliacao/marca/arcano | 100% | 0% | 8.5 | 14.0 |
| retaliacao/marca/controle | 100% | 0% | 7.0 | 13.0 |
| retaliacao/marca/lumen | 100% | 0% | 6.0 | 12.0 |
| retaliacao_tele/critico/arcano | 100% | 0% | 9.0 | 14.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 4.5 | 9.5 |
| retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 4.0 | 9.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 232 | 13.0 | 4.0 | 15 | 134 |
| guardiao/critico/controle | 236 | 13.0 | 4.0 | 12 | 80 |
| guardiao/critico/lumen | 237 | 13.0 | 5.0 | 10 | 52 |
| guardiao/marca/arcano | 236 | 13.0 | 4.0 | 12 | 94 |
| guardiao/marca/controle | 232 | 13.0 | 4.0 | 11 | 78 |
| guardiao/marca/lumen | 238 | 13.0 | 4.5 | 10 | 59 |
| retaliacao/critico/arcano | 228 | 13.0 | 4.0 | 12 | 116 |
| retaliacao/critico/controle | 234 | 13.0 | 4.0 | 12 | 87 |
| retaliacao/critico/lumen | 238 | 13.0 | 4.0 | 10 | 70 |
| retaliacao/marca/arcano | 235 | 13.0 | 4.0 | 12 | 109 |
| retaliacao/marca/controle | 233 | 13.0 | 4.0 | 12 | 87 |
| retaliacao/marca/lumen | 238 | 13.0 | 4.0 | 10 | 78 |
| retaliacao_tele/critico/arcano | 228 | 12.0 | 4.0 | 12 | 115 |
| retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 10 | 62 |
| retaliacao_tele/critico/lumen | 237 | 13.0 | 5.0 | 10 | 52 |
| retaliacao_tele/marca/arcano | 233 | 13.0 | 4.0 | 12 | 80 |
| retaliacao_tele/marca/controle | 236 | 13.0 | 5.0 | 10 | 54 |
| retaliacao_tele/marca/lumen | 237 | 13.0 | 4.0 | 10 | 50 |

Comparação com `20260929-210328_7c2d173`.
