# Argos — relatório `slice_quick`

- Commit: `cd47758` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 4 · `enemy_damage_scale` 0.5
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[INFO/INFO] Regra de caminhos não avaliada** — níveis cobertos: [5]; requer ao menos nível 10 _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_

## Rota completa (vitória por combinação e nível)

| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| retaliacao_tele/marca/arcano | 5 | 0% |  | c1_5_2_a | 39% | 0 |
| retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 55% | 0 |
| retaliacao_tele/marca/lumen | 5 | 0% |  | c1_5_2_a | 48% | 76 |

## Encontros isolados com HP cheio

| Build | Nível | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | --- | ---: | ---: | ---: |
| retaliacao_tele/marca/arcano | 5 | elite | 100% | 17 s | 67% |
| retaliacao_tele/marca/arcano | 5 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 5 | rainha | 100% | 45 s | 61% |
| retaliacao_tele/marca/controle | 5 | elite | 100% | 18 s | 71% |
| retaliacao_tele/marca/controle | 5 | guardiao | 50% | 170 s | 4% |
| retaliacao_tele/marca/controle | 5 | rainha | 100% | 49 s | 72% |
| retaliacao_tele/marca/lumen | 5 | elite | 100% | 19 s | 70% |
| retaliacao_tele/marca/lumen | 5 | guardiao | 100% | 134 s | 29% |
| retaliacao_tele/marca/lumen | 5 | rainha | 100% | 51 s | 72% |
