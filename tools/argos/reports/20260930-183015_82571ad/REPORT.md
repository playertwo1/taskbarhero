# Argos — relatório `argos_profiles__exploit_hunter+chaos`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 4 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `36dc08a58fd197926339c946d3a8e490d7d5d5d1048dd9d920ebf42002ef9e54`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[EXPLOIT/HIGH] Oráculo violado: recycle_credit_mismatch** — 8 execução(ões); exemplo {'kind': 'fuzz', 'build': 'fuzz', 'level': None, 'seed': 1, 'segment': None} _(regra: invariante do simulador)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| chaos · guardiao/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| chaos · guardiao/marca/lumen | 100% | 0% | 5.0 | 10.0 |
| chaos · retaliacao/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| chaos · retaliacao/marca/lumen | 100% | 0% | 5.0 | 10.0 |

## Perfis de jogador (simulação de comportamento; não é playtest)

| Perfil | Campanhas | Vence | Abandona | 1ª vitória (tentativa) | Nível final | Itens guardados | Save (KB) | Fuzz: ações (recusadas) | Bordas | Violações |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| chaos | 16 | 100% | 0% | 5.0 | 12 | 24 | 2.5 | 2000 (943) | — | recycle_credit_mismatch ×4 |
| exploit_hunter | — | — | — | — | — | — | — | 3200 (2060) | — | recycle_credit_mismatch ×4 |

## Comparação de variantes (hero_003 fora da build lumen)

| Variante | Rota: lumen | Rota: melhor sem lumen | Sem lumen com rota ≥ 50% | Tentativas: lumen | Tentativas: melhor sem lumen | Caminhos sem lumen em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| chaos | — | — | 0/2 | 5.0 | 5.0 | 2/2 (guardiao/marca/arcano, retaliacao/marca/arcano) |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| chaos · guardiao/marca/arcano | 0 | 12.0 | 4.0 | 11 | 56 |
| chaos · guardiao/marca/lumen | 0 | 12.0 | 4.0 | 11 | 56 |
| chaos · retaliacao/marca/arcano | 0 | 12.0 | 4.0 | 11 | 56 |
| chaos · retaliacao/marca/lumen | 0 | 12.0 | 4.0 | 11 | 56 |

## Eventos e loot da run (SLICE-1B, campanha com o núcleo real)

| Variante | Evento | Oferecido | Por 100 tentativas | Escolhas |
| --- | --- | ---: | ---: | --- |
| chaos | event_c1_001 | 80 | 100 | heal: 40, sacrifice: 40 |
| chaos | event_c1_arvore_cantante | 4 | 5 | ignore: 4 |
| chaos | event_c1_criatura_ferida | 12 | 15 | ignore: 4, save: 8 |
| chaos | event_c1_cristal_partido | 8 | 10 | leave: 8 |
| chaos | event_c1_eco_percebido | 16 | 20 | react: 16 |
| chaos | event_c1_memorial | 4 | 5 | honor_hero_003: 4 |
| chaos | event_c1_observador | 4 | 5 | witness: 4 |
| chaos | event_c1_raiz_oca | 4 | 5 | open: 4 |
| chaos | event_c1_rastro_cacada | 4 | 5 | follow: 4 |
| chaos | event_c1_reserva_residuo | 60 | 75 | collect: 60 |
| chaos | event_c1_sobrevivente | 16 | 20 | pass: 8, protect: 8 |

Itens recebidos por raridade: Comum 108, Incomum 96, Raro 128, Relíquia 16, Épico 16.

Comparação com `20260930-183001_82571ad`.
