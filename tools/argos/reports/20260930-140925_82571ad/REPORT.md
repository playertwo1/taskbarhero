# Argos — relatório `kits_focus_iris`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 26 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `995e46408fbad7f52b27f9f715f5e797439852dfcc08400a10b543860f4c2a7b`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 3/3 combinações vencedoras fora; mediana 111 s; pior guardiao/marca/arcano nível 10: 109 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/marca/controle** — nível 8.0 (meta 9–12), 3.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/marca/lumen** — nível 5.0 (meta 9–12), 2.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 3; sem lumen: 2; guardiao/marca/arcano, guardiao/marca/controle, guardiao/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 69% | 0 |
| guardiao/marca/arcano | 10 | 77% | +0 p.p. | c1_5_2_a | 73% | 0 |
| guardiao/marca/arcano | 12 | 100% | +0 p.p. |  | 77% | 0 |
| guardiao/marca/controle | 8 | 73% | +0 p.p. | c1_5_2_a | 71% | 0 |
| guardiao/marca/controle | 10 | 100% | +0 p.p. |  | 77% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 77% | 0 |
| guardiao/marca/lumen | 8 | 100% | +0 p.p. |  | 76% | 127 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 75% | 132 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 81% | 132 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 12 s | 84% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 50% | 129 s | 2% |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 74% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 10 s | 87% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 100% | 109 s | 28% |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 34 s | 80% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 10 s | 88% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 92 s | 43% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 32 s | 78% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 14 s | 83% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 120 s | 35% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 77% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 89% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 111 s | 41% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 39 s | 80% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 104 s | 44% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 37 s | 81% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 14 s | 85% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 120 s | 51% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 42 s | 78% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 13 s | 88% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 116 s | 50% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 40 s | 79% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 12 s | 91% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 106 s | 58% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 38 s | 82% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| guardiao/marca/controle | 100% | 0% | 3.5 | 8.0 |
| guardiao/marca/lumen | 100% | 0% | 2.0 | 5.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/marca/arcano | 236 | 13.0 | 4.0 | 10 | 60 |
| guardiao/marca/controle | 240 | 13.0 | 4.0 | 10 | 46 |
| guardiao/marca/lumen | 246 | 13.0 | 5.0 | 8 | 29 |

Comparação com `20260930-140746_82571ad`.
