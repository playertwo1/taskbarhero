# Argos — relatório `kits_focus_flecha`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 26 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `f9afe3f10ce59c199a62d3ad009b414cf68eb7062f473ff854736eb6b07eb398`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 1/3 combinações vencedoras fora; mediana 120 s; pior guardiao/marca/controle nível 10: 116 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 3; sem lumen: 3; guardiao/critico/controle, guardiao/marca/controle, guardiao/velocidade/controle _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 69% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/critico/controle | 8 | 8% | -15 p.p. | c1_5_2_a | 68% | 0 |
| guardiao/critico/controle | 10 | 58% | -42 p.p. | c1_5_2_a | 74% | 0 |
| guardiao/critico/controle | 12 | 85% | -15 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/marca/controle | 8 | 4% | -73 p.p. | c1_5_2_a | 67% | 0 |
| guardiao/marca/controle | 10 | 65% | -35 p.p. | c1_5_2_a | 69% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 71% | 0 |
| guardiao/velocidade/controle | 8 | 0% | -85 p.p. | c1_5_2_a | 71% | 0 |
| guardiao/velocidade/controle | 10 | 69% | -31 p.p. | c1_5_2_a | 72% | 0 |
| guardiao/velocidade/controle | 12 | 100% | +0 p.p. |  | 74% | 0 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/critico/controle | 8 | 3 | elite | 100% | 14 s | 81% |
| guardiao/critico/controle | 8 | 10 | guardiao | 81% | 129 s | 22% |
| guardiao/critico/controle | 8 | 5 | rainha | 100% | 48 s | 77% |
| guardiao/critico/controle | 10 | 3 | elite | 100% | 13 s | 85% |
| guardiao/critico/controle | 10 | 10 | guardiao | 100% | 120 s | 31% |
| guardiao/critico/controle | 10 | 5 | rainha | 100% | 44 s | 80% |
| guardiao/critico/controle | 12 | 3 | elite | 100% | 12 s | 88% |
| guardiao/critico/controle | 12 | 10 | guardiao | 100% | 116 s | 33% |
| guardiao/critico/controle | 12 | 5 | rainha | 100% | 42 s | 82% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 14 s | 83% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 129 s | 25% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 43 s | 76% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 89% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 116 s | 35% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 41 s | 79% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 107 s | 43% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 39 s | 79% |
| guardiao/velocidade/controle | 8 | 3 | elite | 100% | 13 s | 84% |
| guardiao/velocidade/controle | 8 | 10 | guardiao | 100% | 138 s | 19% |
| guardiao/velocidade/controle | 8 | 5 | rainha | 100% | 45 s | 80% |
| guardiao/velocidade/controle | 10 | 3 | elite | 100% | 12 s | 87% |
| guardiao/velocidade/controle | 10 | 10 | guardiao | 100% | 120 s | 33% |
| guardiao/velocidade/controle | 10 | 5 | rainha | 100% | 43 s | 79% |
| guardiao/velocidade/controle | 12 | 3 | elite | 100% | 12 s | 88% |
| guardiao/velocidade/controle | 12 | 10 | guardiao | 100% | 114 s | 43% |
| guardiao/velocidade/controle | 12 | 5 | rainha | 100% | 42 s | 81% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/critico/controle | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/controle | 100% | 0% | 4.0 | 9.0 |
| guardiao/velocidade/controle | 100% | 0% | 4.0 | 9.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/critico/controle | 238 | 13.0 | 4.0 | 11 | 57 |
| guardiao/marca/controle | 235 | 13.0 | 4.0 | 11 | 54 |
| guardiao/velocidade/controle | 237 | 13.0 | 4.0 | 10 | 54 |

Comparação com `20260930-141834_82571ad`.
