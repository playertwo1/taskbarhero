# Argos — relatório `slice_balance`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `76baabc9634f79be1a8665edf7df85cedd43aa32f7cb5c044f42c8e5d422fe2e`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 17%; líderes: guardiao/critico/lumen, guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 15/18 combinações vencedoras fora; mediana 113 s; pior retaliacao_tele/marca/arcano nível 10: 99 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 12.5 (meta 9–12), 6.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/critico/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao/critico/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/critico/controle** — nível 8.0 (meta 9–12), 3.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/critico/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/controle** — nível 8.0 (meta 9–12), 3.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/lumen** — nível 6.0 (meta 9–12), 2.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 12; sem lumen: 6; guardiao/critico/lumen, guardiao/marca/controle, guardiao/marca/lumen, retaliacao/critico/controle, retaliacao/critico/lumen, retaliacao/marca/controle, retaliacao/marca/lumen, retaliacao_tele/critico/controle, retaliacao_tele/critico/lumen, retaliacao_tele/marca/arcano, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 5.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| guardiao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| guardiao/critico/arcano | 12 | 67% | +0 p.p. | c1_5_2_a | 71% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/critico/controle | 10 | 33% | +0 p.p. | c1_5_2_a | 76% | 0 |
| guardiao/critico/controle | 12 | 100% | +0 p.p. |  | 71% | 0 |
| guardiao/critico/lumen | 8 | 100% | +0 p.p. |  | 75% | 136 |
| guardiao/critico/lumen | 10 | 100% | +0 p.p. |  | 79% | 143 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 79% | 136 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/marca/arcano | 10 | 17% | +0 p.p. | c1_5_2_a | 69% | 0 |
| guardiao/marca/arcano | 12 | 100% | +0 p.p. |  | 75% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 64% | 0 |
| guardiao/marca/controle | 10 | 50% | +0 p.p. | c1_5_2_a | 67% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 71% | 0 |
| guardiao/marca/lumen | 8 | 100% | +0 p.p. |  | 74% | 136 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 78% | 143 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 77% | 131 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 55% | 0 |
| retaliacao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao/critico/arcano | 12 | 33% | +0 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao/critico/controle | 10 | 83% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao/critico/controle | 12 | 67% | +0 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao/critico/lumen | 8 | 100% | +0 p.p. |  | 76% | 131 |
| retaliacao/critico/lumen | 10 | 100% | +0 p.p. |  | 76% | 131 |
| retaliacao/critico/lumen | 12 | 100% | +0 p.p. |  | 80% | 129 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao/marca/arcano | 12 | 33% | +0 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao/marca/controle | 8 | 33% | +0 p.p. | c1_5_2_a | 70% | 0 |
| retaliacao/marca/controle | 10 | 67% | +0 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 12 | 100% | +0 p.p. |  | 76% | 0 |
| retaliacao/marca/lumen | 8 | 83% | +0 p.p. | c1_5_2_a | 68% | 127 |
| retaliacao/marca/lumen | 10 | 100% | +0 p.p. |  | 78% | 127 |
| retaliacao/marca/lumen | 12 | 100% | +0 p.p. |  | 81% | 123 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 56% | 0 |
| retaliacao_tele/critico/arcano | 10 | 33% | +0 p.p. | c1_5_2_a | 63% | 0 |
| retaliacao_tele/critico/arcano | 12 | 100% | +0 p.p. |  | 70% | 0 |
| retaliacao_tele/critico/controle | 8 | 67% | +0 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao_tele/critico/controle | 10 | 100% | +0 p.p. |  | 71% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 72% | 0 |
| retaliacao_tele/critico/lumen | 8 | 100% | +0 p.p. |  | 77% | 127 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 76% | 124 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 77% | 128 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| retaliacao_tele/marca/arcano | 10 | 67% | +0 p.p. | c1_5_2_a | 65% | 0 |
| retaliacao_tele/marca/arcano | 12 | 100% | +0 p.p. |  | 72% | 0 |
| retaliacao_tele/marca/controle | 8 | 83% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao_tele/marca/controle | 10 | 100% | +0 p.p. |  | 67% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% | +0 p.p. |  | 75% | 0 |
| retaliacao_tele/marca/lumen | 8 | 100% | +0 p.p. |  | 68% | 127 |
| retaliacao_tele/marca/lumen | 10 | 100% | +0 p.p. |  | 73% | 125 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 74% | 120 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 8 | 3 | elite | 100% | 12 s | 81% |
| guardiao/critico/arcano | 8 | 10 | guardiao | 17% | 120 s | 4% |
| guardiao/critico/arcano | 8 | 5 | rainha | 100% | 42 s | 75% |
| guardiao/critico/arcano | 10 | 3 | elite | 100% | 12 s | 84% |
| guardiao/critico/arcano | 10 | 10 | guardiao | 83% | 132 s | 2% |
| guardiao/critico/arcano | 10 | 5 | rainha | 100% | 39 s | 74% |
| guardiao/critico/arcano | 12 | 3 | elite | 100% | 11 s | 86% |
| guardiao/critico/arcano | 12 | 10 | guardiao | 100% | 118 s | 21% |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 36 s | 79% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 14 s | 81% |
| guardiao/critico/controle | 8 | 10 | guardiao | 67% | 133 s | 13% |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 48 s | 77% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 13 s | 85% |
| guardiao/critico/controle | 10 | 10 | guardiao | 100% | 120 s | 28% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 44 s | 78% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 13 s | 87% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 116 s | 33% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 42 s | 83% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 15 s | 83% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 100% | 131 s | 41% |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 79% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 14 s | 86% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 123 s | 49% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 45 s | 82% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 13 s | 90% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 119 s | 56% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 42 s | 81% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 12 s | 83% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 40 s | 72% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 10 s | 87% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 100% | 104 s | 25% |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 36 s | 77% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 10 s | 88% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 101 s | 34% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 34 s | 78% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 14 s | 83% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 121 s | 27% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 43 s | 76% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 13 s | 86% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 115 s | 35% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 41 s | 79% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 107 s | 44% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 39 s | 80% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 14 s | 84% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 124 s | 38% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 44 s | 80% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 13 s | 88% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 119 s | 47% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 42 s | 79% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 12 s | 91% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 112 s | 52% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 40 s | 81% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 13 s | 76% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 100% | 126 s | 11% |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 41 s | 68% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 12 s | 79% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 100% | 109 s | 23% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 38 s | 72% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 102 s | 33% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 35 s | 79% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 13 s | 80% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 100% | 121 s | 34% |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 43 s | 74% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 12 s | 80% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 100% | 114 s | 41% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 41 s | 78% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 12 s | 81% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 109 s | 44% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 39 s | 81% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 13 s | 84% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 125 s | 47% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 81% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 84% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 116 s | 56% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 41 s | 83% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 12 s | 85% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 110 s | 61% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 40 s | 81% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 11 s | 79% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 17% | 127 s | 6% |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 39 s | 68% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 10 s | 82% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 100% | 101 s | 29% |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 32 s | 77% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 87% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 91 s | 41% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 31 s | 78% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 13 s | 76% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 100% | 120 s | 26% |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 40 s | 77% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 12 s | 80% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 108 s | 31% |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 38 s | 78% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 11 s | 82% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 104 s | 36% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 35 s | 80% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 14 s | 81% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 120 s | 50% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 12 s | 84% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 111 s | 62% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 39 s | 79% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 11 s | 85% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 104 s | 55% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 37 s | 83% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 13 s | 73% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 100% | 113 s | 25% |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 12 s | 82% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 108 s | 32% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 36 s | 79% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 11 s | 83% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 104 s | 36% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 34 s | 81% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 13 s | 78% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 100% | 120 s | 41% |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 44 s | 76% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 12 s | 82% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 115 s | 41% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 40 s | 81% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 12 s | 85% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 110 s | 50% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 39 s | 82% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 14 s | 80% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 123 s | 61% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 43 s | 84% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 13 s | 83% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 114 s | 63% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 83% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 12 s | 84% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 109 s | 68% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 39 s | 83% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 11 s | 78% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 100% | 122 s | 18% |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 75% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 10 s | 81% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 99 s | 36% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 34 s | 79% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 9 s | 85% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 91 s | 44% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 32 s | 80% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 13 s | 79% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 117 s | 35% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 41 s | 77% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 12 s | 83% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 108 s | 43% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 39 s | 79% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 11 s | 85% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 104 s | 49% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 37 s | 84% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 14 s | 80% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 120 s | 53% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 12 s | 81% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 108 s | 64% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 38 s | 81% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 12 s | 83% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 104 s | 65% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 36 s | 84% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 6.5 | 12.5 |
| guardiao/critico/controle | 100% | 0% | 5.0 | 10.0 |
| guardiao/critico/lumen | 100% | 0% | 3.0 | 7.0 |
| guardiao/marca/arcano | 100% | 0% | 5.5 | 11.0 |
| guardiao/marca/controle | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/lumen | 100% | 0% | 3.0 | 7.0 |
| retaliacao/critico/arcano | 100% | 0% | 6.0 | 12.0 |
| retaliacao/critico/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao/critico/lumen | 100% | 0% | 3.0 | 7.0 |
| retaliacao/marca/arcano | 100% | 0% | 6.0 | 11.5 |
| retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| retaliacao/marca/lumen | 100% | 0% | 3.0 | 7.0 |
| retaliacao_tele/critico/arcano | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 3.5 | 8.0 |
| retaliacao_tele/critico/lumen | 100% | 0% | 3.0 | 7.0 |
| retaliacao_tele/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| retaliacao_tele/marca/controle | 100% | 0% | 3.5 | 8.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 2.5 | 6.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 235 | 13.0 | 4.0 | 12 | 86 |
| guardiao/critico/controle | 239 | 13.0 | 4.0 | 12 | 65 |
| guardiao/critico/lumen | 238 | 13.0 | 5.0 | 10 | 41 |
| guardiao/marca/arcano | 235 | 13.0 | 5.0 | 10 | 72 |
| guardiao/marca/controle | 236 | 13.0 | 5.0 | 11 | 52 |
| guardiao/marca/lumen | 238 | 13.0 | 5.0 | 10 | 41 |
| retaliacao/critico/arcano | 237 | 13.0 | 4.0 | 11 | 80 |
| retaliacao/critico/controle | 236 | 13.0 | 5.0 | 10 | 62 |
| retaliacao/critico/lumen | 238 | 13.0 | 5.0 | 9 | 38 |
| retaliacao/marca/arcano | 235 | 13.0 | 4.0 | 11 | 74 |
| retaliacao/marca/controle | 237 | 13.0 | 5.0 | 10 | 62 |
| retaliacao/marca/lumen | 238 | 13.0 | 5.0 | 10 | 41 |
| retaliacao_tele/critico/arcano | 237 | 13.0 | 4.0 | 11 | 66 |
| retaliacao_tele/critico/controle | 237 | 13.0 | 5.0 | 10 | 47 |
| retaliacao_tele/critico/lumen | 237 | 13.0 | 5.0 | 9 | 40 |
| retaliacao_tele/marca/arcano | 238 | 13.0 | 4.0 | 10 | 62 |
| retaliacao_tele/marca/controle | 238 | 13.0 | 5.0 | 10 | 47 |
| retaliacao_tele/marca/lumen | 238 | 13.0 | 5.0 | 8 | 34 |

Comparação com `20260930-150448_82571ad`.
