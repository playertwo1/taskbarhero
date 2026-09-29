# Argos — relatório `slice_balance`

- Commit: `425cac2` · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Poucos caminhos viáveis** — viáveis até o nível 8 (rota ≥ 50%): 6; sem lumen: 0 _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura)_
- **[BALANCE/HIGH] Dominância no nível 3** — melhor 100% vs mediana 0%; líderes: retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 5** — melhor 100% vs mediana 0%; líderes: guardiao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 0%; líderes: guardiao/critico/lumen, guardiao/marca/lumen, retaliacao/critico/lumen, retaliacao/marca/lumen, retaliacao_tele/critico/lumen, retaliacao_tele/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de elite fora de 15–30 s** — 1/54 combinações vencedoras fora; mediana 18 s; pior retaliacao/marca/arcano nível 8: 15 s _(regra: docs/06_balance/SLICE_BALANCE_CONTRACT.md, seção 5 (faixa v0.4))_
- **[BALANCE/MEDIUM] TTK de rainha fora de 40–75 s** — 2/54 combinações vencedoras fora; mediana 47 s; pior retaliacao_tele/marca/arcano nível 8: 39 s _(regra: docs/06_balance/SLICE_BALANCE_CONTRACT.md, seção 5 (faixa v0.4))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: retaliacao_tele/critico/lumen** — 33% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: retaliacao_tele/marca/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Combinações que nunca vencem na campanha** — 6: guardiao/critico/arcano, guardiao/marca/arcano, retaliacao/critico/arcano, retaliacao/marca/arcano, retaliacao_tele/critico/arcano, retaliacao_tele/marca/arcano _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: guardiao/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: guardiao/marca/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao/marca/controle** — mediana 8.5 tentativas, nível 13.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao_tele/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao_tele/marca/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[INFO/INFO] Referência de primeira tentativa no nível 5** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_

## Rota completa (vitória por combinação e nível)

| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/arcano | 3 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/critico/arcano | 8 | 0% |  | c1_3_2_a | 17% | 0 |
| guardiao/critico/controle | 3 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/critico/controle | 5 | 0% |  | c1_3_2_a | 5% | 0 |
| guardiao/critico/controle | 8 | 0% |  | c1_5_2_a | 17% | 0 |
| guardiao/critico/lumen | 3 | 83% |  | c1_5_2_a | 50% | 575 |
| guardiao/critico/lumen | 5 | 100% |  |  | 57% | 567 |
| guardiao/critico/lumen | 8 | 100% |  |  | 62% | 568 |
| guardiao/marca/arcano | 3 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/marca/arcano | 8 | 0% |  | c1_3_2_a | 16% | 0 |
| guardiao/marca/controle | 3 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/marca/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| guardiao/marca/controle | 8 | 0% |  | c1_5_2_a | 21% | 0 |
| guardiao/marca/lumen | 3 | 67% |  | c1_5_2_a | 49% | 555 |
| guardiao/marca/lumen | 5 | 83% |  | c1_5_2_a | 56% | 548 |
| guardiao/marca/lumen | 8 | 100% |  |  | 68% | 546 |
| retaliacao/critico/arcano | 3 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao/critico/arcano | 8 | 0% |  | c1_5_2_a | 13% | 0 |
| retaliacao/critico/controle | 3 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao/critico/controle | 5 | 0% |  | c1_3_2_a | 17% | 0 |
| retaliacao/critico/controle | 8 | 0% |  | c1_5_2_a | 34% | 0 |
| retaliacao/critico/lumen | 3 | 50% |  | c1_5_2_a | 35% | 438 |
| retaliacao/critico/lumen | 5 | 67% |  | c1_5_2_a | 48% | 508 |
| retaliacao/critico/lumen | 8 | 100% |  |  | 63% | 528 |
| retaliacao/marca/arcano | 3 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao/marca/arcano | 8 | 0% |  | c1_5_2_a | 17% | 0 |
| retaliacao/marca/controle | 3 | 0% |  | c1_3_2_a | 4% | 0 |
| retaliacao/marca/controle | 5 | 0% |  | c1_3_2_a | 14% | 0 |
| retaliacao/marca/controle | 8 | 0% |  | c1_5_2_a | 33% | 0 |
| retaliacao/marca/lumen | 3 | 17% |  | c1_5_2_a | 38% | 487 |
| retaliacao/marca/lumen | 5 | 100% |  |  | 50% | 498 |
| retaliacao/marca/lumen | 8 | 100% |  |  | 63% | 506 |
| retaliacao_tele/critico/arcano | 3 | 0% |  | c1_4_1_a | — | 0 |
| retaliacao_tele/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao_tele/critico/arcano | 8 | 0% |  | c1_5_2_a | 10% | 0 |
| retaliacao_tele/critico/controle | 3 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao_tele/critico/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao_tele/critico/controle | 8 | 0% |  | c1_3_2_a | 17% | 0 |
| retaliacao_tele/critico/lumen | 3 | 100% |  |  | 36% | 526 |
| retaliacao_tele/critico/lumen | 5 | 100% |  |  | 43% | 518 |
| retaliacao_tele/critico/lumen | 8 | 100% |  |  | 58% | 506 |
| retaliacao_tele/marca/arcano | 3 | 0% |  | c1_4_1_a | — | 0 |
| retaliacao_tele/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| retaliacao_tele/marca/arcano | 8 | 0% |  | c1_5_2_a | 6% | 0 |
| retaliacao_tele/marca/controle | 3 | 0% |  | c1_3_2_a | 5% | 0 |
| retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 6% | 0 |
| retaliacao_tele/marca/controle | 8 | 0% |  | c1_5_2_a | 26% | 0 |
| retaliacao_tele/marca/lumen | 3 | 100% |  |  | 43% | 515 |
| retaliacao_tele/marca/lumen | 5 | 100% |  |  | 44% | 508 |
| retaliacao_tele/marca/lumen | 8 | 100% |  |  | 59% | 508 |

## Encontros isolados com HP cheio

| Build | Nível | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/arcano | 3 | elite | 100% | 19 s | 62% |
| guardiao/critico/arcano | 3 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 3 | rainha | 100% | 50 s | 61% |
| guardiao/critico/arcano | 5 | elite | 100% | 18 s | 65% |
| guardiao/critico/arcano | 5 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 5 | rainha | 100% | 48 s | 67% |
| guardiao/critico/arcano | 8 | elite | 100% | 17 s | 69% |
| guardiao/critico/arcano | 8 | guardiao | 0% | — | — |
| guardiao/critico/arcano | 8 | rainha | 100% | 43 s | 73% |
| guardiao/critico/controle | 3 | elite | 100% | 21 s | 67% |
| guardiao/critico/controle | 3 | guardiao | 0% | — | — |
| guardiao/critico/controle | 3 | rainha | 100% | 55 s | 68% |
| guardiao/critico/controle | 5 | elite | 100% | 20 s | 70% |
| guardiao/critico/controle | 5 | guardiao | 0% | — | — |
| guardiao/critico/controle | 5 | rainha | 100% | 52 s | 69% |
| guardiao/critico/controle | 8 | elite | 100% | 18 s | 74% |
| guardiao/critico/controle | 8 | guardiao | 17% | 163 s | 12% |
| guardiao/critico/controle | 8 | rainha | 100% | 48 s | 75% |
| guardiao/critico/lumen | 3 | elite | 100% | 21 s | 69% |
| guardiao/critico/lumen | 3 | guardiao | 100% | 186 s | 55% |
| guardiao/critico/lumen | 3 | rainha | 100% | 57 s | 82% |
| guardiao/critico/lumen | 5 | elite | 100% | 20 s | 77% |
| guardiao/critico/lumen | 5 | guardiao | 100% | 175 s | 67% |
| guardiao/critico/lumen | 5 | rainha | 100% | 53 s | 86% |
| guardiao/critico/lumen | 8 | elite | 100% | 18 s | 80% |
| guardiao/critico/lumen | 8 | guardiao | 100% | 161 s | 73% |
| guardiao/critico/lumen | 8 | rainha | 100% | 50 s | 89% |
| guardiao/marca/arcano | 3 | elite | 100% | 18 s | 67% |
| guardiao/marca/arcano | 3 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 3 | rainha | 100% | 50 s | 62% |
| guardiao/marca/arcano | 5 | elite | 100% | 17 s | 71% |
| guardiao/marca/arcano | 5 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 5 | rainha | 100% | 44 s | 68% |
| guardiao/marca/arcano | 8 | elite | 100% | 15 s | 76% |
| guardiao/marca/arcano | 8 | guardiao | 0% | — | — |
| guardiao/marca/arcano | 8 | rainha | 100% | 41 s | 75% |
| guardiao/marca/controle | 3 | elite | 100% | 21 s | 64% |
| guardiao/marca/controle | 3 | guardiao | 0% | — | — |
| guardiao/marca/controle | 3 | rainha | 100% | 54 s | 68% |
| guardiao/marca/controle | 5 | elite | 100% | 19 s | 69% |
| guardiao/marca/controle | 5 | guardiao | 0% | — | — |
| guardiao/marca/controle | 5 | rainha | 100% | 49 s | 72% |
| guardiao/marca/controle | 8 | elite | 100% | 18 s | 71% |
| guardiao/marca/controle | 8 | guardiao | 33% | 157 s | 17% |
| guardiao/marca/controle | 8 | rainha | 100% | 45 s | 76% |
| guardiao/marca/lumen | 3 | elite | 100% | 21 s | 74% |
| guardiao/marca/lumen | 3 | guardiao | 100% | 182 s | 60% |
| guardiao/marca/lumen | 3 | rainha | 100% | 56 s | 85% |
| guardiao/marca/lumen | 5 | elite | 100% | 20 s | 79% |
| guardiao/marca/lumen | 5 | guardiao | 100% | 166 s | 67% |
| guardiao/marca/lumen | 5 | rainha | 100% | 50 s | 88% |
| guardiao/marca/lumen | 8 | elite | 100% | 18 s | 86% |
| guardiao/marca/lumen | 8 | guardiao | 100% | 153 s | 71% |
| guardiao/marca/lumen | 8 | rainha | 100% | 46 s | 87% |
| retaliacao/critico/arcano | 3 | elite | 100% | 18 s | 61% |
| retaliacao/critico/arcano | 3 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 3 | rainha | 100% | 46 s | 64% |
| retaliacao/critico/arcano | 5 | elite | 100% | 17 s | 65% |
| retaliacao/critico/arcano | 5 | guardiao | 0% | — | — |
| retaliacao/critico/arcano | 5 | rainha | 100% | 44 s | 64% |
| retaliacao/critico/arcano | 8 | elite | 100% | 16 s | 71% |
| retaliacao/critico/arcano | 8 | guardiao | 50% | 134 s | 8% |
| retaliacao/critico/arcano | 8 | rainha | 100% | 41 s | 71% |
| retaliacao/critico/controle | 3 | elite | 100% | 19 s | 67% |
| retaliacao/critico/controle | 3 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 3 | rainha | 100% | 50 s | 69% |
| retaliacao/critico/controle | 5 | elite | 100% | 18 s | 72% |
| retaliacao/critico/controle | 5 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 5 | rainha | 100% | 48 s | 73% |
| retaliacao/critico/controle | 8 | elite | 100% | 16 s | 75% |
| retaliacao/critico/controle | 8 | guardiao | 0% | — | — |
| retaliacao/critico/controle | 8 | rainha | 100% | 44 s | 78% |
| retaliacao/critico/lumen | 3 | elite | 100% | 20 s | 72% |
| retaliacao/critico/lumen | 3 | guardiao | 100% | 170 s | 60% |
| retaliacao/critico/lumen | 3 | rainha | 100% | 52 s | 86% |
| retaliacao/critico/lumen | 5 | elite | 100% | 19 s | 75% |
| retaliacao/critico/lumen | 5 | guardiao | 100% | 159 s | 71% |
| retaliacao/critico/lumen | 5 | rainha | 100% | 49 s | 80% |
| retaliacao/critico/lumen | 8 | elite | 100% | 17 s | 81% |
| retaliacao/critico/lumen | 8 | guardiao | 100% | 147 s | 78% |
| retaliacao/critico/lumen | 8 | rainha | 100% | 46 s | 88% |
| retaliacao/marca/arcano | 3 | elite | 100% | 17 s | 67% |
| retaliacao/marca/arcano | 3 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 3 | rainha | 100% | 46 s | 63% |
| retaliacao/marca/arcano | 5 | elite | 100% | 16 s | 70% |
| retaliacao/marca/arcano | 5 | guardiao | 0% | — | — |
| retaliacao/marca/arcano | 5 | rainha | 100% | 42 s | 67% |
| retaliacao/marca/arcano | 8 | elite | 100% | 15 s | 76% |
| retaliacao/marca/arcano | 8 | guardiao | 17% | 153 s | 5% |
| retaliacao/marca/arcano | 8 | rainha | 100% | 39 s | 74% |
| retaliacao/marca/controle | 3 | elite | 100% | 19 s | 69% |
| retaliacao/marca/controle | 3 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 3 | rainha | 100% | 50 s | 70% |
| retaliacao/marca/controle | 5 | elite | 100% | 18 s | 73% |
| retaliacao/marca/controle | 5 | guardiao | 0% | — | — |
| retaliacao/marca/controle | 5 | rainha | 100% | 45 s | 72% |
| retaliacao/marca/controle | 8 | elite | 100% | 16 s | 75% |
| retaliacao/marca/controle | 8 | guardiao | 83% | 140 s | 25% |
| retaliacao/marca/controle | 8 | rainha | 100% | 42 s | 80% |
| retaliacao/marca/lumen | 3 | elite | 100% | 19 s | 73% |
| retaliacao/marca/lumen | 3 | guardiao | 100% | 168 s | 63% |
| retaliacao/marca/lumen | 3 | rainha | 100% | 52 s | 81% |
| retaliacao/marca/lumen | 5 | elite | 100% | 18 s | 76% |
| retaliacao/marca/lumen | 5 | guardiao | 100% | 154 s | 70% |
| retaliacao/marca/lumen | 5 | rainha | 100% | 48 s | 83% |
| retaliacao/marca/lumen | 8 | elite | 100% | 16 s | 81% |
| retaliacao/marca/lumen | 8 | guardiao | 100% | 142 s | 79% |
| retaliacao/marca/lumen | 8 | rainha | 100% | 44 s | 82% |
| retaliacao_tele/critico/arcano | 3 | elite | 100% | 18 s | 61% |
| retaliacao_tele/critico/arcano | 3 | guardiao | 0% | — | — |
| retaliacao_tele/critico/arcano | 3 | rainha | 100% | 47 s | 63% |
| retaliacao_tele/critico/arcano | 5 | elite | 100% | 17 s | 65% |
| retaliacao_tele/critico/arcano | 5 | guardiao | 0% | — | — |
| retaliacao_tele/critico/arcano | 5 | rainha | 100% | 44 s | 67% |
| retaliacao_tele/critico/arcano | 8 | elite | 100% | 16 s | 70% |
| retaliacao_tele/critico/arcano | 8 | guardiao | 50% | 139 s | 19% |
| retaliacao_tele/critico/arcano | 8 | rainha | 100% | 40 s | 71% |
| retaliacao_tele/critico/controle | 3 | elite | 100% | 20 s | 66% |
| retaliacao_tele/critico/controle | 3 | guardiao | 0% | — | — |
| retaliacao_tele/critico/controle | 3 | rainha | 100% | 50 s | 71% |
| retaliacao_tele/critico/controle | 5 | elite | 100% | 18 s | 71% |
| retaliacao_tele/critico/controle | 5 | guardiao | 50% | 155 s | 32% |
| retaliacao_tele/critico/controle | 5 | rainha | 100% | 48 s | 73% |
| retaliacao_tele/critico/controle | 8 | elite | 100% | 17 s | 78% |
| retaliacao_tele/critico/controle | 8 | guardiao | 100% | 144 s | 28% |
| retaliacao_tele/critico/controle | 8 | rainha | 100% | 43 s | 78% |
| retaliacao_tele/critico/lumen | 3 | elite | 100% | 20 s | 72% |
| retaliacao_tele/critico/lumen | 3 | guardiao | 100% | 167 s | 70% |
| retaliacao_tele/critico/lumen | 3 | rainha | 100% | 52 s | 83% |
| retaliacao_tele/critico/lumen | 5 | elite | 100% | 18 s | 77% |
| retaliacao_tele/critico/lumen | 5 | guardiao | 100% | 157 s | 83% |
| retaliacao_tele/critico/lumen | 5 | rainha | 100% | 50 s | 84% |
| retaliacao_tele/critico/lumen | 8 | elite | 100% | 17 s | 83% |
| retaliacao_tele/critico/lumen | 8 | guardiao | 100% | 145 s | 86% |
| retaliacao_tele/critico/lumen | 8 | rainha | 100% | 47 s | 88% |
| retaliacao_tele/marca/arcano | 3 | elite | 100% | 17 s | 66% |
| retaliacao_tele/marca/arcano | 3 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 3 | rainha | 100% | 46 s | 64% |
| retaliacao_tele/marca/arcano | 5 | elite | 100% | 16 s | 69% |
| retaliacao_tele/marca/arcano | 5 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 5 | rainha | 100% | 42 s | 65% |
| retaliacao_tele/marca/arcano | 8 | elite | 100% | 15 s | 74% |
| retaliacao_tele/marca/arcano | 8 | guardiao | 67% | 142 s | 18% |
| retaliacao_tele/marca/arcano | 8 | rainha | 100% | 39 s | 74% |
| retaliacao_tele/marca/controle | 3 | elite | 100% | 19 s | 69% |
| retaliacao_tele/marca/controle | 3 | guardiao | 0% | — | — |
| retaliacao_tele/marca/controle | 3 | rainha | 100% | 50 s | 70% |
| retaliacao_tele/marca/controle | 5 | elite | 100% | 18 s | 73% |
| retaliacao_tele/marca/controle | 5 | guardiao | 100% | 149 s | 26% |
| retaliacao_tele/marca/controle | 5 | rainha | 100% | 45 s | 75% |
| retaliacao_tele/marca/controle | 8 | elite | 100% | 16 s | 78% |
| retaliacao_tele/marca/controle | 8 | guardiao | 100% | 138 s | 30% |
| retaliacao_tele/marca/controle | 8 | rainha | 100% | 41 s | 80% |
| retaliacao_tele/marca/lumen | 3 | elite | 100% | 19 s | 74% |
| retaliacao_tele/marca/lumen | 3 | guardiao | 100% | 164 s | 79% |
| retaliacao_tele/marca/lumen | 3 | rainha | 100% | 52 s | 83% |
| retaliacao_tele/marca/lumen | 5 | elite | 100% | 18 s | 78% |
| retaliacao_tele/marca/lumen | 5 | guardiao | 100% | 150 s | 79% |
| retaliacao_tele/marca/lumen | 5 | rainha | 100% | 48 s | 84% |
| retaliacao_tele/marca/lumen | 8 | elite | 100% | 17 s | 82% |
| retaliacao_tele/marca/lumen | 8 | guardiao | 100% | 140 s | 82% |
| retaliacao_tele/marca/lumen | 8 | rainha | 100% | 44 s | 87% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 0% | 0% | — | — |
| guardiao/critico/controle | 50% | 0% | 10.0 | 15.0 |
| guardiao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| guardiao/marca/arcano | 0% | 0% | — | — |
| guardiao/marca/controle | 50% | 0% | 10.0 | 15.0 |
| guardiao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| retaliacao/critico/arcano | 0% | 0% | — | — |
| retaliacao/critico/controle | 100% | 0% | 10.0 | 15.0 |
| retaliacao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| retaliacao/marca/arcano | 0% | 0% | — | — |
| retaliacao/marca/controle | 100% | 0% | 8.5 | 13.5 |
| retaliacao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| retaliacao_tele/critico/arcano | 0% | 0% | — | — |
| retaliacao_tele/critico/controle | 50% | 0% | 10.0 | 15.0 |
| retaliacao_tele/critico/lumen | 100% | 33% | 2.0 | 5.0 |
| retaliacao_tele/marca/arcano | 0% | 0% | — | — |
| retaliacao_tele/marca/controle | 100% | 0% | 9.5 | 14.5 |
| retaliacao_tele/marca/lumen | 100% | 17% | 2.0 | 5.0 |
