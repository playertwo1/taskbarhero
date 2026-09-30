# Argos — relatório `slice_quick`

- Commit: `8d8c473` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 4 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `bbc68261021f86d0e5246515aa26e84b7dff3a1988652b8d87316293b9dfacc8`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[INFO/INFO] Regra de caminhos não avaliada** — níveis cobertos: [5]; requer ao menos nível 10 _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| retaliacao_tele/marca/arcano | 5 | 0% | +0 p.p. | c1_5_2_a | 39% | 0 |
| retaliacao_tele/marca/controle | 5 | 0% | +0 p.p. | c1_5_2_a | 55% | 0 |
| retaliacao_tele/marca/lumen | 5 | 0% | +0 p.p. | c1_5_2_a | 48% | 74 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| retaliacao_tele/marca/arcano | 5 | 3 | elite | 100% | 17 s | 67% |
| retaliacao_tele/marca/arcano | 5 | 10 | guardiao | 0% | — | — |
| retaliacao_tele/marca/arcano | 5 | 5 | rainha | 100% | 45 s | 61% |
| retaliacao_tele/marca/controle | 5 | 3 | elite | 100% | 18 s | 71% |
| retaliacao_tele/marca/controle | 5 | 10 | guardiao | 50% | 169 s | 3% |
| retaliacao_tele/marca/controle | 5 | 5 | rainha | 100% | 49 s | 72% |
| retaliacao_tele/marca/lumen | 5 | 3 | elite | 100% | 19 s | 70% |
| retaliacao_tele/marca/lumen | 5 | 10 | guardiao | 100% | 140 s | 32% |
| retaliacao_tele/marca/lumen | 5 | 5 | rainha | 100% | 51 s | 72% |

Comparação com `20260929-214752_45e7939`.
