# Argos — relatório `slice_balance`

- Commit: `cd47758` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `440f011118bd0c77f92ebfe728b1bc0044268e14218f39e3b0143f04de59fa3d`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 10** — melhor 100% vs mediana 25%; líderes: guardiao/critico/lumen, guardiao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 8/16 combinações vencedoras fora; mediana 120 s; pior retaliacao/critico/arcano nível 10: 110 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 15.0 (meta 9–12), 10.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/marca/arcano** — nível 13.0 (meta 9–12), 7.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: retaliacao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 7; sem lumen: 2; guardiao/critico/lumen, guardiao/marca/controle, guardiao/marca/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/controle, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
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
| guardiao/critico/controle | 12 | 67% | +0 p.p. | c1_5_2_a | 74% | 0 |
| guardiao/critico/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 94 |
| guardiao/critico/lumen | 10 | 100% | +0 p.p. |  | 77% | 99 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 77% | 98 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| guardiao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/marca/arcano | 12 | 50% | +0 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/marca/controle | 10 | 67% | +0 p.p. | c1_5_2_a | 72% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 74% | 0 |
| guardiao/marca/lumen | 8 | 17% | +0 p.p. | c1_5_2_a | 74% | 88 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 78% | 87 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 80% | 85 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 49% | 0 |
| retaliacao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 54% | 0 |
| retaliacao/critico/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 64% | 0 |
| retaliacao/critico/controle | 10 | 17% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao/critico/controle | 12 | 33% | +0 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/critico/lumen | 8 | 0% | +0 p.p. | c1_5_2_a | 58% | 77 |
| retaliacao/critico/lumen | 10 | 33% | +0 p.p. | c1_5_2_a | 70% | 87 |
| retaliacao/critico/lumen | 12 | 100% | +0 p.p. |  | 76% | 85 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 53% | 0 |
| retaliacao/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 58% | 0 |
| retaliacao/marca/arcano | 12 | 0% | +0 p.p. | c1_5_2_a | 63% | 0 |
| retaliacao/marca/controle | 8 | 17% | +0 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 10 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| retaliacao/marca/controle | 12 | 33% | +0 p.p. | c1_5_2_a | 71% | 0 |
| retaliacao/marca/lumen | 8 | 17% | +0 p.p. | c1_5_2_a | 66% | 77 |
| retaliacao/marca/lumen | 10 | 50% | +0 p.p. | c1_5_2_a | 74% | 81 |
| retaliacao/marca/lumen | 12 | 67% | +0 p.p. | c1_5_2_a | 77% | 79 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 53% | 0 |
| retaliacao_tele/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 57% | 0 |
| retaliacao_tele/critico/arcano | 12 | 17% | +0 p.p. | c1_5_2_a | 61% | 0 |
| retaliacao_tele/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 64% | 0 |
| retaliacao_tele/critico/controle | 10 | 50% | +0 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 72% | 0 |
| retaliacao_tele/critico/lumen | 8 | 33% | +0 p.p. | c1_5_2_a | 61% | 88 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 73% | 84 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 75% | 85 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 50% | 0 |
| retaliacao_tele/marca/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 59% | 0 |
| retaliacao_tele/marca/arcano | 12 | 67% | +0 p.p. | c1_5_2_a | 65% | 0 |
| retaliacao_tele/marca/controle | 8 | 17% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao_tele/marca/controle | 10 | 33% | +0 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% | +0 p.p. |  | 75% | 0 |
| retaliacao_tele/marca/lumen | 8 | 17% | +0 p.p. | c1_5_2_a | 65% | 83 |
| retaliacao_tele/marca/lumen | 10 | 100% | +0 p.p. |  | 72% | 81 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 75% | 79 |

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
| guardiao/critico/arcano | 12 | 10 | guardiao | 17% | 131 s | 7% |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 41 s | 74% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 19 s | 73% |
| guardiao/critico/controle | 8 | 10 | guardiao | 50% | 137 s | 25% |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 51 s | 73% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/controle | 10 | 10 | guardiao | 100% | 132 s | 18% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 48 s | 76% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 16 s | 83% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 122 s | 37% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 46 s | 78% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 19 s | 76% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 17% | 149 s | 16% |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 52 s | 82% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 133 s | 31% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 50 s | 79% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 17 s | 82% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 128 s | 40% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 48 s | 82% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 16 s | 74% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 43 s | 72% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 15 s | 78% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 42 s | 73% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 14 s | 79% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 67% | 114 s | 14% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 39 s | 77% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 18 s | 73% |
| guardiao/marca/controle | 8 | 10 | guardiao | 50% | 143 s | 2% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 48 s | 76% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 17 s | 73% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 123 s | 31% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 45 s | 77% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 16 s | 75% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 117 s | 39% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 42 s | 81% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 18 s | 76% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 50% | 138 s | 17% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 49 s | 81% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 18 s | 79% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 127 s | 30% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 46 s | 80% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 17 s | 79% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 120 s | 42% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 44 s | 84% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 16 s | 69% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 17% | 118 s | 8% |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 43 s | 66% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 15 s | 72% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 50% | 110 s | 25% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 41 s | 71% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 14 s | 73% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 105 s | 31% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 17 s | 75% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 83% | 130 s | 19% |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 47 s | 75% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 16 s | 77% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 100% | 127 s | 25% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 45 s | 78% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 16 s | 79% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 114 s | 33% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 18 s | 70% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 131 s | 22% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 72% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 17 s | 71% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 122 s | 38% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 47 s | 76% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 16 s | 77% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 117 s | 40% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 44 s | 78% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 15 s | 74% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 33% | 131 s | 4% |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 42 s | 70% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 14 s | 77% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 100% | 111 s | 27% |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 39 s | 74% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 13 s | 79% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 105 s | 33% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 37 s | 80% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 16 s | 75% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 83% | 122 s | 27% |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 45 s | 78% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 16 s | 76% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 125 s | 21% |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 42 s | 79% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 15 s | 78% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 110 s | 41% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 40 s | 82% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 17 s | 70% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 83% | 127 s | 15% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 47 s | 71% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 16 s | 71% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 120 s | 35% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 44 s | 76% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 16 s | 74% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 112 s | 50% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 42 s | 83% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 16 s | 68% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 33% | 116 s | 14% |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 43 s | 68% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 16 s | 70% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 111 s | 24% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 41 s | 71% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 14 s | 73% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 123 s | 28% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 18 s | 77% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 100% | 125 s | 36% |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 47 s | 76% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 16 s | 76% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 118 s | 43% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 43 s | 79% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 16 s | 78% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 114 s | 41% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 18 s | 71% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 127 s | 43% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 49 s | 75% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 17 s | 72% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 121 s | 50% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 47 s | 77% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 16 s | 78% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 116 s | 53% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 44 s | 81% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 15 s | 73% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 67% | 131 s | 17% |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 41 s | 70% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 14 s | 76% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 116 s | 23% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 39 s | 74% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 14 s | 78% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 100 s | 43% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 37 s | 79% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 17 s | 77% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 120 s | 41% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 44 s | 77% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 16 s | 76% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 114 s | 43% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 15 s | 80% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 108 s | 38% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 40 s | 81% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 17 s | 71% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 123 s | 44% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 47 s | 76% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 16 s | 73% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 118 s | 49% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 44 s | 81% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 16 s | 72% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 111 s | 60% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 42 s | 83% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 100% | 0% | 10.0 | 15.0 |
| guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| guardiao/critico/lumen | 100% | 0% | 4.5 | 9.5 |
| guardiao/marca/arcano | 100% | 0% | 7.0 | 13.0 |
| guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| guardiao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| retaliacao/critico/controle | 100% | 0% | 6.0 | 11.5 |
| retaliacao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| retaliacao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| retaliacao/marca/controle | 100% | 0% | 5.5 | 11.0 |
| retaliacao/marca/lumen | 100% | 0% | 4.5 | 9.5 |
| retaliacao_tele/critico/arcano | 100% | 0% | 7.0 | 12.0 |
| retaliacao_tele/critico/controle | 100% | 0% | 5.5 | 11.0 |
| retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao_tele/marca/lumen | 100% | 0% | 4.0 | 9.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 232 | 13.0 | 4.0 | 14 | 129 |
| guardiao/critico/controle | 237 | 13.0 | 4.0 | 11 | 80 |
| guardiao/critico/lumen | 238 | 13.0 | 5.0 | 10 | 58 |
| guardiao/marca/arcano | 237 | 13.0 | 4.0 | 12 | 90 |
| guardiao/marca/controle | 232 | 13.0 | 5.0 | 11 | 76 |
| guardiao/marca/lumen | 237 | 13.0 | 5.0 | 10 | 52 |
| retaliacao/critico/arcano | 226 | 13.0 | 4.0 | 12 | 102 |
| retaliacao/critico/controle | 234 | 13.0 | 4.0 | 11 | 76 |
| retaliacao/critico/lumen | 238 | 13.0 | 4.0 | 10 | 64 |
| retaliacao/marca/arcano | 234 | 13.0 | 4.0 | 12 | 88 |
| retaliacao/marca/controle | 233 | 13.0 | 4.0 | 10 | 67 |
| retaliacao/marca/lumen | 237 | 13.0 | 4.0 | 10 | 58 |
| retaliacao_tele/critico/arcano | 226 | 12.0 | 4.0 | 12 | 84 |
| retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 10 | 74 |
| retaliacao_tele/critico/lumen | 238 | 13.0 | 5.0 | 10 | 52 |
| retaliacao_tele/marca/arcano | 234 | 13.0 | 4.0 | 11 | 80 |
| retaliacao_tele/marca/controle | 236 | 13.0 | 5.0 | 11 | 54 |
| retaliacao_tele/marca/lumen | 235 | 13.0 | 4.5 | 8 | 48 |

Comparação com `20260929-154143_cd47758`.
