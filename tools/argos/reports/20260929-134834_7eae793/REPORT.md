# Argos — relatório `slice_economy`

- Commit: `7eae793` · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: retaliacao_tele/critico/lumen** — 33% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: retaliacao_tele/marca/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Combinações que nunca vencem na campanha** — 6: guardiao/critico/arcano, guardiao/marca/arcano, retaliacao/critico/arcano, retaliacao/marca/arcano, retaliacao_tele/critico/arcano, retaliacao_tele/marca/arcano _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: guardiao/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: guardiao/marca/controle** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao/critico/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao_tele/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: retaliacao_tele/marca/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 0% | 0% | — | — |
| guardiao/critico/controle | 100% | 0% | 10.0 | 15.0 |
| guardiao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| guardiao/marca/arcano | 0% | 0% | — | — |
| guardiao/marca/controle | 83% | 0% | 9.0 | 14.0 |
| guardiao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| retaliacao/critico/arcano | 0% | 0% | — | — |
| retaliacao/critico/controle | 100% | 0% | 9.5 | 14.5 |
| retaliacao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| retaliacao/marca/arcano | 0% | 0% | — | — |
| retaliacao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| retaliacao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| retaliacao_tele/critico/arcano | 0% | 0% | — | — |
| retaliacao_tele/critico/controle | 100% | 0% | 10.0 | 15.0 |
| retaliacao_tele/critico/lumen | 100% | 33% | 2.0 | 5.0 |
| retaliacao_tele/marca/arcano | 0% | 0% | — | — |
| retaliacao_tele/marca/controle | 100% | 0% | 9.5 | 14.5 |
| retaliacao_tele/marca/lumen | 100% | 17% | 2.0 | 5.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/arcano | 136 | 10.0 | 3.0 | 13 | 102 |
| guardiao/critico/controle | 228 | 12.0 | 4.0 | 15 | 119 |
| guardiao/critico/lumen | 360 | 13.0 | 4.5 | 6 | 28 |
| guardiao/marca/arcano | 221 | 12.0 | 3.5 | 14 | 115 |
| guardiao/marca/controle | 225 | 12.0 | 4.0 | 14 | 112 |
| guardiao/marca/lumen | 360 | 13.0 | 5.0 | 6 | 26 |
| retaliacao/critico/arcano | 215 | 12.0 | 4.0 | 13 | 116 |
| retaliacao/critico/controle | 225 | 11.0 | 4.0 | 12 | 111 |
| retaliacao/critico/lumen | 367 | 13.0 | 4.0 | 6 | 26 |
| retaliacao/marca/arcano | 221 | 12.0 | 3.0 | 14 | 114 |
| retaliacao/marca/controle | 234 | 12.0 | 4.0 | 12 | 96 |
| retaliacao/marca/lumen | 356 | 13.0 | 5.0 | 7 | 26 |
| retaliacao_tele/critico/arcano | 217 | 11.0 | 3.0 | 14 | 107 |
| retaliacao_tele/critico/controle | 225 | 12.0 | 4.0 | 12 | 116 |
| retaliacao_tele/critico/lumen | 500 | 13.0 | 4.0 | 5 | 24 |
| retaliacao_tele/marca/arcano | 220 | 11.5 | 4.0 | 12 | 117 |
| retaliacao_tele/marca/controle | 230 | 12.0 | 4.0 | 14 | 110 |
| retaliacao_tele/marca/lumen | 481 | 13.0 | 5.0 | 5 | 25 |
