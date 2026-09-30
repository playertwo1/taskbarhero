# Argos — relatório `slice_balance`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `f94403646d2b845ea5ac7b5f96563d9653d23152babbdf5740b997609e5a56bd`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 0%; líderes: retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 10** — melhor 100% vs mediana 0%; líderes: guardiao/critico/lumen, guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[PACING/MEDIUM] Vence tarde demais: guardiao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/critico/lumen** — nível 8.0 (meta 9–12), 4.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 7; sem lumen: 1; guardiao/critico/lumen, guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/controle, retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/critico/arcano | 10 | 0% | +0 p.p. | c1_5_2_a | 74% | 0 |
| guardiao/critico/arcano | 12 | 0% | -33 p.p. | c1_5_2_a | 78% | 0 |
| guardiao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/critico/controle | 10 | 0% | -100 p.p. | c1_5_2_a | 74% | 0 |
| guardiao/critico/controle | 12 | 17% | -83 p.p. | c1_5_2_a | 76% | 0 |
| guardiao/critico/lumen | 8 | 0% | -100 p.p. | c1_5_2_a | 78% | 1979 |
| guardiao/critico/lumen | 10 | 100% | +0 p.p. |  | 79% | 2059 |
| guardiao/critico/lumen | 12 | 100% | +0 p.p. |  | 81% | 1988 |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 65% | 0 |
| guardiao/marca/arcano | 10 | 0% | -50 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/marca/arcano | 12 | 50% | -50 p.p. | c1_5_2_a | 77% | 0 |
| guardiao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 0 |
| guardiao/marca/controle | 10 | 0% | -100 p.p. | c1_5_2_a | 69% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 79% | 0 |
| guardiao/marca/lumen | 8 | 50% | -50 p.p. | c1_5_2_a | 78% | 1868 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 76% | 1826 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 81% | 1750 |
| retaliacao/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 56% | 0 |
| retaliacao/critico/arcano | 10 | 0% | -17 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/critico/arcano | 12 | 0% | -100 p.p. | c1_5_2_a | 75% | 0 |
| retaliacao/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 67% | 0 |
| retaliacao/critico/controle | 10 | 0% | -83 p.p. | c1_5_2_a | 71% | 0 |
| retaliacao/critico/controle | 12 | 0% | -83 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao/critico/lumen | 8 | 0% | -83 p.p. | c1_5_2_a | 76% | 1694 |
| retaliacao/critico/lumen | 10 | 100% | +0 p.p. |  | 79% | 1925 |
| retaliacao/critico/lumen | 12 | 100% | +0 p.p. |  | 79% | 1830 |
| retaliacao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao/marca/arcano | 10 | 0% | -33 p.p. | c1_5_2_a | 68% | 0 |
| retaliacao/marca/arcano | 12 | 0% | -83 p.p. | c1_5_2_a | 76% | 0 |
| retaliacao/marca/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 69% | 0 |
| retaliacao/marca/controle | 10 | 0% | -83 p.p. | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 12 | 50% | -50 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao/marca/lumen | 8 | 17% | -67 p.p. | c1_5_2_a | 74% | 1562 |
| retaliacao/marca/lumen | 10 | 100% | +0 p.p. |  | 77% | 1721 |
| retaliacao/marca/lumen | 12 | 100% | +0 p.p. |  | 80% | 1613 |
| retaliacao_tele/critico/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 60% | 0 |
| retaliacao_tele/critico/arcano | 10 | 0% | -67 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/critico/arcano | 12 | 67% | -33 p.p. | c1_5_2_a | 75% | 0 |
| retaliacao_tele/critico/controle | 8 | 0% | +0 p.p. | c1_5_2_a | 71% | 0 |
| retaliacao_tele/critico/controle | 10 | 0% | -100 p.p. | c1_5_2_a | 73% | 0 |
| retaliacao_tele/critico/controle | 12 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao_tele/critico/lumen | 8 | 100% | +0 p.p. |  | 76% | 1837 |
| retaliacao_tele/critico/lumen | 10 | 100% | +0 p.p. |  | 76% | 1842 |
| retaliacao_tele/critico/lumen | 12 | 100% | +0 p.p. |  | 82% | 1830 |
| retaliacao_tele/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 66% | 0 |
| retaliacao_tele/marca/arcano | 10 | 0% | -100 p.p. | c1_5_2_a | 70% | 0 |
| retaliacao_tele/marca/arcano | 12 | 67% | -33 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao_tele/marca/controle | 8 | 0% | -67 p.p. | c1_5_2_a | 72% | 0 |
| retaliacao_tele/marca/controle | 10 | 67% | -33 p.p. | c1_5_2_a | 77% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% | +0 p.p. |  | 77% | 0 |
| retaliacao_tele/marca/lumen | 8 | 100% | +0 p.p. |  | 75% | 1684 |
| retaliacao_tele/marca/lumen | 10 | 100% | +0 p.p. |  | 81% | 1656 |
| retaliacao_tele/marca/lumen | 12 | 100% | +0 p.p. |  | 80% | 1622 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 8 | 3 | elite | 100% | 16 s | 74% |
| guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | 5 | rainha | 100% | 42 s | 74% |
| guardiao/critico/arcano | 10 | 3 | elite | 100% | 11 s | 86% |
| guardiao/critico/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 10 | 5 | rainha | 100% | 37 s | 77% |
| guardiao/critico/arcano | 12 | 3 | elite | 100% | 10 s | 88% |
| guardiao/critico/arcano | 12 | 10 | guardiao | 33% | 146 s | 3% |
| guardiao/critico/arcano | 12 | 5 | rainha | 100% | 36 s | 79% |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 18 s | 77% |
| guardiao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 48 s | 76% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 13 s | 87% |
| guardiao/critico/controle | 10 | 10 | guardiao | 0% | — | — |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 43 s | 81% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/critico/controle | 12 | 10 | guardiao | 83% | 167 s | 5% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 40 s | 80% |
| guardiao/critico/lumen | 8 | 3 | elite | 100% | 17 s | 78% |
| guardiao/critico/lumen | 8 | 10 | guardiao | 0% | — | — |
| guardiao/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 82% |
| guardiao/critico/lumen | 10 | 3 | elite | 100% | 13 s | 89% |
| guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 166 s | 32% |
| guardiao/critico/lumen | 10 | 5 | rainha | 100% | 43 s | 81% |
| guardiao/critico/lumen | 12 | 3 | elite | 100% | 12 s | 91% |
| guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 157 s | 38% |
| guardiao/critico/lumen | 12 | 5 | rainha | 100% | 41 s | 86% |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 14 s | 80% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 70% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 88% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 34 s | 78% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 50% | 149 s | 1% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 32 s | 78% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 16 s | 76% |
| guardiao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 78% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 10 | 10 | guardiao | 50% | 152 s | 18% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 38 s | 79% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 11 s | 91% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 139 s | 31% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 36 s | 81% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 16 s | 81% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 167 s | 26% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 42 s | 82% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 12 s | 91% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 148 s | 40% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 39 s | 82% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 11 s | 91% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 140 s | 45% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 36 s | 82% |
| retaliacao/critico/arcano | 8 | 3 | elite | 100% | 14 s | 76% |
| retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 75% |
| retaliacao/critico/arcano | 10 | 3 | elite | 100% | 9 s | 89% |
| retaliacao/critico/arcano | 10 | 10 | guardiao | 17% | 142 s | 6% |
| retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 36 s | 78% |
| retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 91% |
| retaliacao/critico/arcano | 12 | 10 | guardiao | 67% | 138 s | 14% |
| retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 33 s | 83% |
| retaliacao/critico/controle | 8 | 3 | elite | 100% | 15 s | 79% |
| retaliacao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 8 | 5 | rainha | 100% | 44 s | 79% |
| retaliacao/critico/controle | 10 | 3 | elite | 100% | 12 s | 82% |
| retaliacao/critico/controle | 10 | 10 | guardiao | 33% | 161 s | 21% |
| retaliacao/critico/controle | 10 | 5 | rainha | 100% | 40 s | 78% |
| retaliacao/critico/controle | 12 | 3 | elite | 100% | 11 s | 87% |
| retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 144 s | 31% |
| retaliacao/critico/controle | 12 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao/critico/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| retaliacao/critico/lumen | 8 | 10 | guardiao | 67% | 175 s | 35% |
| retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 45 s | 79% |
| retaliacao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 85% |
| retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 158 s | 32% |
| retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 41 s | 83% |
| retaliacao/critico/lumen | 12 | 3 | elite | 100% | 11 s | 91% |
| retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 149 s | 48% |
| retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 39 s | 84% |
| retaliacao/marca/arcano | 8 | 3 | elite | 100% | 13 s | 79% |
| retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 76% |
| retaliacao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 88% |
| retaliacao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 31 s | 78% |
| retaliacao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| retaliacao/marca/arcano | 12 | 10 | guardiao | 33% | 133 s | 13% |
| retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 29 s | 81% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 14 s | 80% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 40 s | 79% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 10 s | 84% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 142 s | 23% |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 35 s | 80% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 10 s | 85% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 131 s | 35% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 33 s | 82% |
| retaliacao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 73% |
| retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 160 s | 34% |
| retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 78% |
| retaliacao/marca/lumen | 10 | 3 | elite | 100% | 11 s | 87% |
| retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 142 s | 43% |
| retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 37 s | 83% |
| retaliacao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 88% |
| retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 132 s | 51% |
| retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 33 s | 87% |
| retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 15 s | 74% |
| retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 76% |
| retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 11 s | 84% |
| retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 83% | 151 s | 7% |
| retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 35 s | 81% |
| retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 10 s | 87% |
| retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 133 s | 24% |
| retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 33 s | 82% |
| retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 16 s | 79% |
| retaliacao_tele/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 42 s | 80% |
| retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 12 s | 85% |
| retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 154 s | 31% |
| retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 40 s | 80% |
| retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 11 s | 85% |
| retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 144 s | 38% |
| retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 38 s | 83% |
| retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 171 s | 38% |
| retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 80% |
| retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 12 s | 84% |
| retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 155 s | 52% |
| retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 82% |
| retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 11 s | 89% |
| retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 147 s | 56% |
| retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 38 s | 86% |
| retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 13 s | 78% |
| retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 37 s | 77% |
| retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 9 s | 85% |
| retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 148 s | 11% |
| retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 32 s | 80% |
| retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 9 s | 88% |
| retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 123 s | 33% |
| retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 30 s | 82% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 14 s | 79% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 171 s | 10% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 39 s | 79% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 10 s | 84% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 138 s | 34% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 10 s | 85% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 130 s | 40% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 34 s | 83% |
| retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 156 s | 40% |
| retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 74% |
| retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 11 s | 84% |
| retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 141 s | 47% |
| retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 36 s | 83% |
| retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 10 s | 88% |
| retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 131 s | 62% |
| retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 34 s | 85% |

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

Comparação com `20260930-173515_82571ad`.
