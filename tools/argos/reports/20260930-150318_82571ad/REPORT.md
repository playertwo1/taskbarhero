# Argos — relatório `kits_focus_iris`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 26 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `995e46408fbad7f52b27f9f715f5e797439852dfcc08400a10b543860f4c2a7b`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 4%; líderes: guardiao/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 3/3 combinações vencedoras fora; mediana 116 s; pior guardiao/marca/arcano nível 10: 105 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[PACING/MEDIUM] Vence cedo demais: guardiao/marca/lumen** — nível 7.0 (meta 9–12), 3.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 2; sem lumen: 1; guardiao/marca/controle, guardiao/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| guardiao/marca/arcano | 8 | 0% | +0 p.p. | c1_5_2_a | 62% | 0 |
| guardiao/marca/arcano | 10 | 27% | -42 p.p. | c1_5_2_a | 70% | 0 |
| guardiao/marca/arcano | 12 | 85% | -15 p.p. | c1_5_2_a | 75% | 0 |
| guardiao/marca/controle | 8 | 4% | -73 p.p. | c1_5_2_a | 67% | 0 |
| guardiao/marca/controle | 10 | 65% | -35 p.p. | c1_5_2_a | 69% | 0 |
| guardiao/marca/controle | 12 | 100% | +0 p.p. |  | 71% | 0 |
| guardiao/marca/lumen | 8 | 100% | +0 p.p. |  | 75% | 136 |
| guardiao/marca/lumen | 10 | 100% | +0 p.p. |  | 78% | 136 |
| guardiao/marca/lumen | 12 | 100% | +0 p.p. |  | 77% | 131 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| guardiao/marca/arcano | 8 | 3 | elite | 100% | 12 s | 84% |
| guardiao/marca/arcano | 8 | 10 | guardiao | 8% | 109 s | 16% |
| guardiao/marca/arcano | 8 | 5 | rainha | 100% | 40 s | 72% |
| guardiao/marca/arcano | 10 | 3 | elite | 100% | 10 s | 87% |
| guardiao/marca/arcano | 10 | 10 | guardiao | 100% | 105 s | 23% |
| guardiao/marca/arcano | 10 | 5 | rainha | 100% | 36 s | 76% |
| guardiao/marca/arcano | 12 | 3 | elite | 100% | 10 s | 88% |
| guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 100 s | 32% |
| guardiao/marca/arcano | 12 | 5 | rainha | 100% | 34 s | 78% |
| guardiao/marca/controle | 8 | 3 | elite | 100% | 14 s | 83% |
| guardiao/marca/controle | 8 | 10 | guardiao | 100% | 129 s | 25% |
| guardiao/marca/controle | 8 | 5 | rainha | 100% | 43 s | 76% |
| guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 89% |
| guardiao/marca/controle | 10 | 10 | guardiao | 100% | 116 s | 35% |
| guardiao/marca/controle | 10 | 5 | rainha | 100% | 41 s | 79% |
| guardiao/marca/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| guardiao/marca/controle | 12 | 10 | guardiao | 100% | 107 s | 43% |
| guardiao/marca/controle | 12 | 5 | rainha | 100% | 39 s | 79% |
| guardiao/marca/lumen | 8 | 3 | elite | 100% | 14 s | 85% |
| guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 124 s | 43% |
| guardiao/marca/lumen | 8 | 5 | rainha | 100% | 44 s | 78% |
| guardiao/marca/lumen | 10 | 3 | elite | 100% | 13 s | 88% |
| guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 118 s | 46% |
| guardiao/marca/lumen | 10 | 5 | rainha | 100% | 42 s | 79% |
| guardiao/marca/lumen | 12 | 3 | elite | 100% | 12 s | 91% |
| guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 112 s | 51% |
| guardiao/marca/lumen | 12 | 5 | rainha | 100% | 40 s | 83% |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| guardiao/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| guardiao/marca/controle | 100% | 0% | 4.0 | 9.0 |
| guardiao/marca/lumen | 100% | 0% | 3.0 | 7.0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| guardiao/marca/arcano | 236 | 13.0 | 4.0 | 11 | 76 |
| guardiao/marca/controle | 235 | 13.0 | 4.0 | 11 | 54 |
| guardiao/marca/lumen | 240 | 13.0 | 5.0 | 9 | 40 |

Comparação com `20260930-142004_82571ad`.
