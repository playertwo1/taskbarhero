# Argos — relatório `slice_balance`

- Commit: `ed61189` · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 83% vs mediana 0%; líderes: retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 10** — melhor 100% vs mediana 33%; líderes: retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de elite fora de 15–30 s** — 13/72 combinações vencedoras fora; mediana 16 s; pior retaliacao/marca/arcano nível 12: 13 s _(regra: docs/06_balance/SLICE_BALANCE_CONTRACT.md, seção 5 (faixa v0.4))_
- **[BALANCE/MEDIUM] TTK de rainha fora de 40–75 s** — 19/72 combinações vencedoras fora; mediana 42 s; pior retaliacao/marca/arcano nível 12: 35 s _(regra: docs/06_balance/SLICE_BALANCE_CONTRACT.md, seção 5 (faixa v0.4))_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 3/54 combinações vencedoras fora; mediana 138 s; pior retaliacao/marca/arcano nível 12: 113 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/controle** — nível 12.5 (meta 9–12), 6.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/marca/arcano** — nível 14.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/critico/arcano** — nível 12.5 (meta 9–12), 6.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/critico/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis até o nível 11 (rota ≥ 50%): 6; sem lumen: 1; guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 43% | 0 |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 60% | 0 |
| guardiao/critico/arcano | 10 | 0% |  | c1_5_2_a | 65% | 0 |
| guardiao/critico/arcano | 12 | 0% |  | c1_5_2_a | 65% | 0 |
| guardiao/critico/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 56% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| guardiao/critico/controle | 10 | 0% |  | c1_5_2_a | 74% | 0 |
| guardiao/critico/controle | 12 | 33% |  | c1_5_2_a | 75% | 0 |
| guardiao/critico/lumen | 5 | 0% | -100 p.p. | c1_5_2_a | 64% | 91 |
| guardiao/critico/lumen | 8 | 0% | -100 p.p. | c1_5_2_a | 74% | 102 |
| guardiao/critico/lumen | 10 | 17% |  | c1_5_2_a | 78% | 105 |
| guardiao/critico/lumen | 12 | 100% |  |  | 77% | 104 |
| guardiao/marca/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 53% | 0 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 60% | 0 |
| guardiao/marca/arcano | 10 | 0% |  | c1_5_2_a | 67% | 0 |
| guardiao/marca/arcano | 12 | 0% |  | c1_5_2_a | 73% | 0 |
| guardiao/marca/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 60% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 72% | 0 |
| guardiao/marca/controle | 10 | 0% |  | c1_5_2_a | 73% | 0 |
| guardiao/marca/controle | 12 | 83% |  | c1_5_2_a | 77% | 0 |
| guardiao/marca/lumen | 5 | 0% | -83 p.p. | c1_5_2_a | 65% | 81 |
| guardiao/marca/lumen | 8 | 0% | -100 p.p. | c1_5_2_a | 75% | 94 |
| guardiao/marca/lumen | 10 | 67% |  | c1_5_2_a | 77% | 96 |
| guardiao/marca/lumen | 12 | 100% |  |  | 79% | 92 |
| retaliacao/critico/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 50% | 0 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| retaliacao/critico/arcano | 10 | 0% |  | c1_5_2_a | 61% | 0 |
| retaliacao/critico/arcano | 12 | 17% |  | c1_5_2_a | 70% | 0 |
| retaliacao/critico/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 55% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao/critico/controle | 10 | 33% |  | c1_5_2_a | 70% | 0 |
| retaliacao/critico/controle | 12 | 67% |  | c1_5_2_a | 75% | 0 |
| retaliacao/critico/lumen | 5 | 0% | -67 p.p. | c1_5_2_a | 56% | 71 |
| retaliacao/critico/lumen | 8 | 0% | -100 p.p. | c1_5_2_a | 68% | 88 |
| retaliacao/critico/lumen | 10 | 83% |  | c1_5_2_a | 75% | 90 |
| retaliacao/critico/lumen | 12 | 83% |  | c1_5_2_a | 77% | 92 |
| retaliacao/marca/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 51% | 0 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 58% | 0 |
| retaliacao/marca/arcano | 10 | 0% |  | c1_5_2_a | 61% | 0 |
| retaliacao/marca/arcano | 12 | 17% |  | c1_5_2_a | 72% | 0 |
| retaliacao/marca/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 58% | 0 |
| retaliacao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 10 | 33% |  | c1_5_2_a | 70% | 0 |
| retaliacao/marca/controle | 12 | 100% |  |  | 77% | 0 |
| retaliacao/marca/lumen | 5 | 0% | -100 p.p. | c1_5_2_a | 62% | 71 |
| retaliacao/marca/lumen | 8 | 33% | -67 p.p. | c1_5_2_a | 72% | 83 |
| retaliacao/marca/lumen | 10 | 100% |  |  | 78% | 87 |
| retaliacao/marca/lumen | 12 | 100% |  |  | 77% | 85 |
| retaliacao_tele/critico/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 43% | 0 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 58% | 0 |
| retaliacao_tele/critico/arcano | 10 | 0% |  | c1_5_2_a | 62% | 0 |
| retaliacao_tele/critico/arcano | 12 | 67% |  | c1_5_2_a | 70% | 0 |
| retaliacao_tele/critico/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 52% | 0 |
| retaliacao_tele/critico/controle | 8 | 33% | +33 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao_tele/critico/controle | 10 | 33% |  | c1_5_2_a | 73% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% |  |  | 77% | 0 |
| retaliacao_tele/critico/lumen | 5 | 0% | -100 p.p. | c1_5_2_a | 61% | 86 |
| retaliacao_tele/critico/lumen | 8 | 83% | -17 p.p. | c1_5_2_a | 71% | 88 |
| retaliacao_tele/critico/lumen | 10 | 100% |  |  | 72% | 87 |
| retaliacao_tele/critico/lumen | 12 | 100% |  |  | 80% | 92 |
| retaliacao_tele/marca/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 50% | 0 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 57% | 0 |
| retaliacao_tele/marca/arcano | 10 | 33% |  | c1_5_2_a | 64% | 0 |
| retaliacao_tele/marca/arcano | 12 | 50% |  | c1_5_2_a | 69% | 0 |
| retaliacao_tele/marca/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao_tele/marca/controle | 8 | 33% | +33 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/marca/controle | 10 | 83% |  | c1_5_2_a | 76% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% |  |  | 77% | 0 |
| retaliacao_tele/marca/lumen | 5 | 0% | -100 p.p. | c1_5_2_a | 57% | 81 |
| retaliacao_tele/marca/lumen | 8 | 83% | -17 p.p. | c1_5_2_a | 71% | 83 |
| retaliacao_tele/marca/lumen | 10 | 100% |  |  | 78% | 84 |
| retaliacao_tele/marca/lumen | 12 | 100% |  |  | 78% | 79 |

## Encontros isolados com HP cheio

| Build | Nível | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 5 | elite | 100% | 18 s | 65% |
| guardiao/critico/arcano | 5 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 5 | rainha | 100% | 48 s | 67% |
| guardiao/critico/arcano | 8 | elite | 100% | 17 s | 69% |
| guardiao/critico/arcano | 8 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | rainha | 100% | 43 s | 73% |
| guardiao/critico/arcano | 10 | elite | 100% | 16 s | 72% |
| guardiao/critico/arcano | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 10 | rainha | 100% | 41 s | 76% |
| guardiao/critico/arcano | 12 | elite | 100% | 14 s | 77% |
| guardiao/critico/arcano | 12 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 12 | rainha | 100% | 38 s | 77% |
| guardiao/critico/controle | 5 | elite | 100% | 20 s | 70% |
| guardiao/critico/controle | 5 | guardiao | 0% | — | — |
| guardiao/critico/controle | 5 | rainha | 100% | 52 s | 69% |
| guardiao/critico/controle | 8 | elite | 100% | 18 s | 74% |
| guardiao/critico/controle | 8 | guardiao | 17% | 163 s | 12% |
| guardiao/critico/controle | 8 | rainha | 100% | 48 s | 75% |
| guardiao/critico/controle | 10 | elite | 100% | 18 s | 77% |
| guardiao/critico/controle | 10 | guardiao | 100% | 156 s | 22% |
| guardiao/critico/controle | 10 | rainha | 100% | 45 s | 77% |
| guardiao/critico/controle | 12 | elite | 100% | 16 s | 83% |
| guardiao/critico/controle | 12 | guardiao | 100% | 141 s | 29% |
| guardiao/critico/controle | 12 | rainha | 100% | 43 s | 78% |
| guardiao/critico/lumen | 5 | elite | 100% | 20 s | 70% |
| guardiao/critico/lumen | 5 | guardiao | 0% | — | — |
| guardiao/critico/lumen | 5 | rainha | 100% | 53 s | 77% |
| guardiao/critico/lumen | 8 | elite | 100% | 18 s | 75% |
| guardiao/critico/lumen | 8 | guardiao | 33% | 165 s | 4% |
| guardiao/critico/lumen | 8 | rainha | 100% | 50 s | 81% |
| guardiao/critico/lumen | 10 | elite | 100% | 18 s | 77% |
| guardiao/critico/lumen | 10 | guardiao | 100% | 156 s | 17% |
| guardiao/critico/lumen | 10 | rainha | 100% | 48 s | 82% |
| guardiao/critico/lumen | 12 | elite | 100% | 16 s | 82% |
| guardiao/critico/lumen | 12 | guardiao | 100% | 145 s | 35% |
| guardiao/critico/lumen | 12 | rainha | 100% | 44 s | 82% |
| guardiao/marca/arcano | 5 | elite | 100% | 17 s | 71% |
| guardiao/marca/arcano | 5 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 5 | rainha | 100% | 44 s | 68% |
| guardiao/marca/arcano | 8 | elite | 100% | 15 s | 76% |
| guardiao/marca/arcano | 8 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | rainha | 100% | 41 s | 75% |
| guardiao/marca/arcano | 10 | elite | 100% | 14 s | 78% |
| guardiao/marca/arcano | 10 | guardiao | 17% | 128 s | 18% |
| guardiao/marca/arcano | 10 | rainha | 100% | 39 s | 77% |
| guardiao/marca/arcano | 12 | elite | 100% | 14 s | 80% |
| guardiao/marca/arcano | 12 | guardiao | 67% | 126 s | 22% |
| guardiao/marca/arcano | 12 | rainha | 100% | 37 s | 79% |
| guardiao/marca/controle | 5 | elite | 100% | 19 s | 69% |
| guardiao/marca/controle | 5 | guardiao | 0% | — | — |
| guardiao/marca/controle | 5 | rainha | 100% | 49 s | 72% |
| guardiao/marca/controle | 8 | elite | 100% | 18 s | 71% |
| guardiao/marca/controle | 8 | guardiao | 33% | 157 s | 17% |
| guardiao/marca/controle | 8 | rainha | 100% | 45 s | 76% |
| guardiao/marca/controle | 10 | elite | 100% | 17 s | 73% |
| guardiao/marca/controle | 10 | guardiao | 100% | 144 s | 6% |
| guardiao/marca/controle | 10 | rainha | 100% | 42 s | 79% |
| guardiao/marca/controle | 12 | elite | 100% | 15 s | 76% |
| guardiao/marca/controle | 12 | guardiao | 100% | 132 s | 31% |
| guardiao/marca/controle | 12 | rainha | 100% | 40 s | 82% |
| guardiao/marca/lumen | 5 | elite | 100% | 20 s | 72% |
| guardiao/marca/lumen | 5 | guardiao | 0% | — | — |
| guardiao/marca/lumen | 5 | rainha | 100% | 50 s | 76% |
| guardiao/marca/lumen | 8 | elite | 100% | 18 s | 77% |
| guardiao/marca/lumen | 8 | guardiao | 83% | 156 s | 20% |
| guardiao/marca/lumen | 8 | rainha | 100% | 46 s | 80% |
| guardiao/marca/lumen | 10 | elite | 100% | 17 s | 79% |
| guardiao/marca/lumen | 10 | guardiao | 100% | 145 s | 28% |
| guardiao/marca/lumen | 10 | rainha | 100% | 44 s | 82% |
| guardiao/marca/lumen | 12 | elite | 100% | 16 s | 81% |
| guardiao/marca/lumen | 12 | guardiao | 100% | 137 s | 42% |
| guardiao/marca/lumen | 12 | rainha | 100% | 42 s | 84% |
| retaliacao/critico/arcano | 5 | elite | 100% | 17 s | 65% |
| retaliacao/critico/arcano | 5 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 5 | rainha | 100% | 44 s | 64% |
| retaliacao/critico/arcano | 8 | elite | 100% | 16 s | 71% |
| retaliacao/critico/arcano | 8 | guardiao | 50% | 134 s | 8% |
| retaliacao/critico/arcano | 8 | rainha | 100% | 41 s | 71% |
| retaliacao/critico/arcano | 10 | elite | 100% | 15 s | 74% |
| retaliacao/critico/arcano | 10 | guardiao | 100% | 124 s | 22% |
| retaliacao/critico/arcano | 10 | rainha | 100% | 39 s | 75% |
| retaliacao/critico/arcano | 12 | elite | 100% | 14 s | 76% |
| retaliacao/critico/arcano | 12 | guardiao | 100% | 119 s | 29% |
| retaliacao/critico/arcano | 12 | rainha | 100% | 36 s | 80% |
| retaliacao/critico/controle | 5 | elite | 100% | 18 s | 72% |
| retaliacao/critico/controle | 5 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 5 | rainha | 100% | 48 s | 73% |
| retaliacao/critico/controle | 8 | elite | 100% | 16 s | 75% |
| retaliacao/critico/controle | 8 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 8 | rainha | 100% | 44 s | 78% |
| retaliacao/critico/controle | 10 | elite | 100% | 16 s | 77% |
| retaliacao/critico/controle | 10 | guardiao | 67% | 142 s | 16% |
| retaliacao/critico/controle | 10 | rainha | 100% | 41 s | 81% |
| retaliacao/critico/controle | 12 | elite | 100% | 15 s | 79% |
| retaliacao/critico/controle | 12 | guardiao | 100% | 132 s | 28% |
| retaliacao/critico/controle | 12 | rainha | 100% | 40 s | 81% |
| retaliacao/critico/lumen | 5 | elite | 100% | 19 s | 69% |
| retaliacao/critico/lumen | 5 | guardiao | 0% | — | — |
| retaliacao/critico/lumen | 5 | rainha | 100% | 49 s | 68% |
| retaliacao/critico/lumen | 8 | elite | 100% | 17 s | 71% |
| retaliacao/critico/lumen | 8 | guardiao | 100% | 147 s | 30% |
| retaliacao/critico/lumen | 8 | rainha | 100% | 46 s | 75% |
| retaliacao/critico/lumen | 10 | elite | 100% | 17 s | 72% |
| retaliacao/critico/lumen | 10 | guardiao | 100% | 140 s | 38% |
| retaliacao/critico/lumen | 10 | rainha | 100% | 44 s | 78% |
| retaliacao/critico/lumen | 12 | elite | 100% | 15 s | 78% |
| retaliacao/critico/lumen | 12 | guardiao | 100% | 133 s | 45% |
| retaliacao/critico/lumen | 12 | rainha | 100% | 41 s | 82% |
| retaliacao/marca/arcano | 5 | elite | 100% | 16 s | 70% |
| retaliacao/marca/arcano | 5 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 5 | rainha | 100% | 42 s | 67% |
| retaliacao/marca/arcano | 8 | elite | 100% | 15 s | 76% |
| retaliacao/marca/arcano | 8 | guardiao | 17% | 153 s | 5% |
| retaliacao/marca/arcano | 8 | rainha | 100% | 39 s | 74% |
| retaliacao/marca/arcano | 10 | elite | 100% | 14 s | 79% |
| retaliacao/marca/arcano | 10 | guardiao | 100% | 133 s | 25% |
| retaliacao/marca/arcano | 10 | rainha | 100% | 37 s | 80% |
| retaliacao/marca/arcano | 12 | elite | 100% | 13 s | 81% |
| retaliacao/marca/arcano | 12 | guardiao | 100% | 113 s | 40% |
| retaliacao/marca/arcano | 12 | rainha | 100% | 35 s | 81% |
| retaliacao/marca/controle | 5 | elite | 100% | 18 s | 73% |
| retaliacao/marca/controle | 5 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 5 | rainha | 100% | 45 s | 72% |
| retaliacao/marca/controle | 8 | elite | 100% | 16 s | 75% |
| retaliacao/marca/controle | 8 | guardiao | 83% | 140 s | 25% |
| retaliacao/marca/controle | 8 | rainha | 100% | 42 s | 80% |
| retaliacao/marca/controle | 10 | elite | 100% | 15 s | 77% |
| retaliacao/marca/controle | 10 | guardiao | 100% | 130 s | 36% |
| retaliacao/marca/controle | 10 | rainha | 100% | 40 s | 82% |
| retaliacao/marca/controle | 12 | elite | 100% | 15 s | 79% |
| retaliacao/marca/controle | 12 | guardiao | 100% | 124 s | 47% |
| retaliacao/marca/controle | 12 | rainha | 100% | 39 s | 77% |
| retaliacao/marca/lumen | 5 | elite | 100% | 18 s | 69% |
| retaliacao/marca/lumen | 5 | guardiao | 50% | 166 s | 16% |
| retaliacao/marca/lumen | 5 | rainha | 100% | 48 s | 68% |
| retaliacao/marca/lumen | 8 | elite | 100% | 16 s | 71% |
| retaliacao/marca/lumen | 8 | guardiao | 83% | 142 s | 23% |
| retaliacao/marca/lumen | 8 | rainha | 100% | 44 s | 75% |
| retaliacao/marca/lumen | 10 | elite | 100% | 16 s | 72% |
| retaliacao/marca/lumen | 10 | guardiao | 100% | 136 s | 39% |
| retaliacao/marca/lumen | 10 | rainha | 100% | 42 s | 82% |
| retaliacao/marca/lumen | 12 | elite | 100% | 15 s | 74% |
| retaliacao/marca/lumen | 12 | guardiao | 100% | 128 s | 48% |
| retaliacao/marca/lumen | 12 | rainha | 100% | 39 s | 83% |
| retaliacao_tele/critico/arcano | 5 | elite | 100% | 17 s | 65% |
| retaliacao_tele/critico/arcano | 5 | guardiao | 0% | — | — |
| retaliacao_tele/critico/arcano | 5 | rainha | 100% | 44 s | 67% |
| retaliacao_tele/critico/arcano | 8 | elite | 100% | 16 s | 70% |
| retaliacao_tele/critico/arcano | 8 | guardiao | 50% | 139 s | 19% |
| retaliacao_tele/critico/arcano | 8 | rainha | 100% | 40 s | 71% |
| retaliacao_tele/critico/arcano | 10 | elite | 100% | 16 s | 72% |
| retaliacao_tele/critico/arcano | 10 | guardiao | 50% | 123 s | 33% |
| retaliacao_tele/critico/arcano | 10 | rainha | 100% | 38 s | 76% |
| retaliacao_tele/critico/arcano | 12 | elite | 100% | 14 s | 74% |
| retaliacao_tele/critico/arcano | 12 | guardiao | 67% | 139 s | 23% |
| retaliacao_tele/critico/arcano | 12 | rainha | 100% | 36 s | 80% |
| retaliacao_tele/critico/controle | 5 | elite | 100% | 18 s | 71% |
| retaliacao_tele/critico/controle | 5 | guardiao | 50% | 155 s | 32% |
| retaliacao_tele/critico/controle | 5 | rainha | 100% | 48 s | 73% |
| retaliacao_tele/critico/controle | 8 | elite | 100% | 17 s | 78% |
| retaliacao_tele/critico/controle | 8 | guardiao | 100% | 144 s | 28% |
| retaliacao_tele/critico/controle | 8 | rainha | 100% | 43 s | 78% |
| retaliacao_tele/critico/controle | 10 | elite | 100% | 16 s | 77% |
| retaliacao_tele/critico/controle | 10 | guardiao | 100% | 136 s | 39% |
| retaliacao_tele/critico/controle | 10 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/critico/controle | 12 | elite | 100% | 15 s | 78% |
| retaliacao_tele/critico/controle | 12 | guardiao | 100% | 129 s | 45% |
| retaliacao_tele/critico/controle | 12 | rainha | 100% | 39 s | 80% |
| retaliacao_tele/critico/lumen | 5 | elite | 100% | 18 s | 69% |
| retaliacao_tele/critico/lumen | 5 | guardiao | 100% | 157 s | 33% |
| retaliacao_tele/critico/lumen | 5 | rainha | 100% | 50 s | 71% |
| retaliacao_tele/critico/lumen | 8 | elite | 100% | 17 s | 73% |
| retaliacao_tele/critico/lumen | 8 | guardiao | 100% | 145 s | 44% |
| retaliacao_tele/critico/lumen | 8 | rainha | 100% | 47 s | 77% |
| retaliacao_tele/critico/lumen | 10 | elite | 100% | 16 s | 74% |
| retaliacao_tele/critico/lumen | 10 | guardiao | 100% | 137 s | 53% |
| retaliacao_tele/critico/lumen | 10 | rainha | 100% | 44 s | 81% |
| retaliacao_tele/critico/lumen | 12 | elite | 100% | 15 s | 80% |
| retaliacao_tele/critico/lumen | 12 | guardiao | 100% | 131 s | 56% |
| retaliacao_tele/critico/lumen | 12 | rainha | 100% | 41 s | 82% |
| retaliacao_tele/marca/arcano | 5 | elite | 100% | 16 s | 69% |
| retaliacao_tele/marca/arcano | 5 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 5 | rainha | 100% | 42 s | 65% |
| retaliacao_tele/marca/arcano | 8 | elite | 100% | 15 s | 74% |
| retaliacao_tele/marca/arcano | 8 | guardiao | 67% | 142 s | 18% |
| retaliacao_tele/marca/arcano | 8 | rainha | 100% | 39 s | 74% |
| retaliacao_tele/marca/arcano | 10 | elite | 100% | 14 s | 77% |
| retaliacao_tele/marca/arcano | 10 | guardiao | 100% | 124 s | 33% |
| retaliacao_tele/marca/arcano | 10 | rainha | 100% | 37 s | 79% |
| retaliacao_tele/marca/arcano | 12 | elite | 100% | 14 s | 79% |
| retaliacao_tele/marca/arcano | 12 | guardiao | 100% | 114 s | 36% |
| retaliacao_tele/marca/arcano | 12 | rainha | 100% | 36 s | 80% |
| retaliacao_tele/marca/controle | 5 | elite | 100% | 18 s | 73% |
| retaliacao_tele/marca/controle | 5 | guardiao | 100% | 149 s | 26% |
| retaliacao_tele/marca/controle | 5 | rainha | 100% | 45 s | 75% |
| retaliacao_tele/marca/controle | 8 | elite | 100% | 16 s | 78% |
| retaliacao_tele/marca/controle | 8 | guardiao | 100% | 138 s | 30% |
| retaliacao_tele/marca/controle | 8 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/marca/controle | 10 | elite | 100% | 16 s | 77% |
| retaliacao_tele/marca/controle | 10 | guardiao | 100% | 130 s | 43% |
| retaliacao_tele/marca/controle | 10 | rainha | 100% | 40 s | 81% |
| retaliacao_tele/marca/controle | 12 | elite | 100% | 14 s | 79% |
| retaliacao_tele/marca/controle | 12 | guardiao | 100% | 124 s | 46% |
| retaliacao_tele/marca/controle | 12 | rainha | 100% | 38 s | 83% |
| retaliacao_tele/marca/lumen | 5 | elite | 100% | 18 s | 69% |
| retaliacao_tele/marca/lumen | 5 | guardiao | 100% | 150 s | 34% |
| retaliacao_tele/marca/lumen | 5 | rainha | 100% | 48 s | 74% |
| retaliacao_tele/marca/lumen | 8 | elite | 100% | 17 s | 72% |
| retaliacao_tele/marca/lumen | 8 | guardiao | 100% | 140 s | 49% |
| retaliacao_tele/marca/lumen | 8 | rainha | 100% | 44 s | 80% |
| retaliacao_tele/marca/lumen | 10 | elite | 100% | 15 s | 74% |
| retaliacao_tele/marca/lumen | 10 | guardiao | 100% | 132 s | 55% |
| retaliacao_tele/marca/lumen | 10 | rainha | 100% | 42 s | 83% |
| retaliacao_tele/marca/lumen | 12 | elite | 100% | 16 s | 73% |
| retaliacao_tele/marca/lumen | 12 | guardiao | 100% | 125 s | 58% |
| retaliacao_tele/marca/lumen | 12 | rainha | 100% | 40 s | 83% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 9.0 | 14.0 |
| guardiao/critico/controle | 100% | 0% | 6.5 | 12.5 |
| guardiao/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/arcano | 100% | 0% | 8.0 | 14.0 |
| guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| guardiao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao/critico/arcano | 100% | 0% | 6.5 | 12.5 |
| retaliacao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| retaliacao/critico/lumen | 100% | 0% | 4.5 | 9.5 |
| retaliacao/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| retaliacao/marca/controle | 100% | 0% | 4.5 | 9.5 |
| retaliacao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/critico/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/critico/lumen | 100% | 0% | 3.0 | 7.0 |
| retaliacao_tele/marca/arcano | 100% | 0% | 4.5 | 9.5 |
| retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 3.0 | 7.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 230 | 13.0 | 4.0 | 13 | 114 |
| guardiao/critico/controle | 233 | 13.0 | 5.0 | 12 | 87 |
| guardiao/critico/lumen | 236 | 13.0 | 5.0 | 10 | 54 |
| guardiao/marca/arcano | 233 | 13.0 | 4.0 | 12 | 106 |
| guardiao/marca/controle | 237 | 13.0 | 4.0 | 10 | 74 |
| guardiao/marca/lumen | 237 | 13.0 | 4.0 | 10 | 51 |
| retaliacao/critico/arcano | 234 | 13.0 | 4.0 | 13 | 81 |
| retaliacao/critico/controle | 237 | 13.0 | 4.0 | 12 | 78 |
| retaliacao/critico/lumen | 238 | 13.0 | 4.0 | 10 | 58 |
| retaliacao/marca/arcano | 235 | 13.0 | 4.0 | 12 | 81 |
| retaliacao/marca/controle | 237 | 13.0 | 5.0 | 10 | 58 |
| retaliacao/marca/lumen | 236 | 13.0 | 5.0 | 9 | 48 |
| retaliacao_tele/critico/arcano | 234 | 13.0 | 4.0 | 10 | 76 |
| retaliacao_tele/critico/controle | 237 | 13.0 | 5.0 | 11 | 54 |
| retaliacao_tele/critico/lumen | 236 | 14.0 | 5.0 | 10 | 42 |
| retaliacao_tele/marca/arcano | 238 | 13.0 | 4.0 | 10 | 58 |
| retaliacao_tele/marca/controle | 237 | 13.0 | 5.0 | 10 | 54 |
| retaliacao_tele/marca/lumen | 237 | 13.0 | 5.0 | 10 | 43 |

Comparação com `20260929-133512_425cac2`.
