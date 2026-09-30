# Argos — relatório `kits_focus_bastiao`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 20 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `d4dcffd9a8ec125abc73dd99002b41beff9d10b729e0701611781cff15eb4001`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BUG/CRITICAL] Oráculo violado: enemy_defeated_twice** — 7 execução(ões); exemplo {'kind': 'route', 'build': 'retaliacao/marca/controle', 'level': 10, 'seed': 10, 'segment': None} _(regra: invariante do simulador)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 4/4 combinações vencedoras fora; mediana 107 s; pior retaliacao_tele/marca/controle nível 10: 104 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao/marca/controle** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: retaliacao_tele/marca/controle** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 4; sem lumen: 4; controle/marca/controle, guardiao/marca/controle, retaliacao/marca/controle, retaliacao_tele/marca/controle _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| controle/marca/controle | 8 | 0% |  | c1_5_2_a | 69% | 0 |
| controle/marca/controle | 10 | 85% |  | c1_5_2_a | 78% | 0 |
| controle/marca/controle | 12 | 95% |  | c1_5_2_a | 79% | 0 |
| guardiao/marca/controle | 8 | 75% |  | c1_5_2_a | 71% | 0 |
| guardiao/marca/controle | 10 | 100% |  |  | 76% | 0 |
| guardiao/marca/controle | 12 | 100% |  |  | 78% | 0 |
| retaliacao/marca/controle | 8 | 60% |  | c1_5_2_a | 68% | 0 |
| retaliacao/marca/controle | 10 | 90% |  | c1_5_2_a | 74% | 0 |
| retaliacao/marca/controle | 12 | 100% |  |  | 77% | 0 |
| retaliacao_tele/marca/controle | 8 | 95% |  | c1_5_2_a | 66% | 0 |
| retaliacao_tele/marca/controle | 10 | 100% |  |  | 77% | 0 |
| retaliacao_tele/marca/controle | 12 | 100% |  |  | 79% | 0 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| controle/marca/controle | 8 | 3 | elite | 100% | 12 s | 82% |
| controle/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| controle/marca/controle | 8 | 5 | rainha | 100% | 40 s | 78% |
| controle/marca/controle | 10 | 3 | elite | 100% | 12 s | 82% |
| controle/marca/controle | 10 | 10 | guardiao | 100% | 109 s | 25% |
| controle/marca/controle | 10 | 5 | rainha | 100% | 38 s | 80% |
| controle/marca/controle | 12 | 3 | elite | 100% | 11 s | 84% |
| controle/marca/controle | 12 | 10 | guardiao | 100% | 103 s | 35% |
| controle/marca/controle | 12 | 5 | rainha | 100% | 35 s | 80% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 14 s | 83% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 120 s | 35% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 77% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 89% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 109 s | 41% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 39 s | 80% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 104 s | 44% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 36 s | 81% |
| retaliacao/marca/controle | 8 | 3 | elite | 100% | 13 s | 77% |
| retaliacao/marca/controle | 8 | 10 | guardiao | 100% | 115 s | 28% |
| retaliacao/marca/controle | 8 | 5 | rainha | 100% | 39 s | 77% |
| retaliacao/marca/controle | 10 | 3 | elite | 100% | 12 s | 80% |
| retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 104 s | 40% |
| retaliacao/marca/controle | 10 | 5 | rainha | 100% | 36 s | 80% |
| retaliacao/marca/controle | 12 | 3 | elite | 100% | 11 s | 83% |
| retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 102 s | 45% |
| retaliacao/marca/controle | 12 | 5 | rainha | 100% | 33 s | 82% |
| retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 13 s | 80% |
| retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 112 s | 42% |
| retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 39 s | 81% |
| retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 12 s | 84% |
| retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 104 s | 47% |
| retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 36 s | 82% |
| retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 11 s | 85% |
| retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 101 s | 53% |
| retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 35 s | 85% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| controle/marca/controle | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/controle | 100% | 0% | 4.0 | 9.0 |
| retaliacao/marca/controle | 100% | 0% | 3.0 | 7.0 |
| retaliacao_tele/marca/controle | 100% | 0% | 3.0 | 7.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| controle/marca/controle | 237 | 13.0 | 4.0 | 10 | 55 |
| guardiao/marca/controle | 240 | 13.0 | 4.0 | 10 | 48 |
| retaliacao/marca/controle | 242 | 13.0 | 5.0 | 10 | 42 |
| retaliacao_tele/marca/controle | 241 | 13.0 | 4.0 | 8 | 40 |
