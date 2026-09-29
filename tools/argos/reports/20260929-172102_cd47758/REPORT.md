# Argos — relatório `slice_run_layer`

- Commit: `cd47758` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `2033c32d2fab3b0d6cd5b61d2415ad4d61033107c4f30450f242d6318e523cf0`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[PACING/MEDIUM] Vence tarde demais: base · guardiao/critico/arcano** — nível 14.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: base · guardiao/marca/arcano** — nível 13.5 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: eventos_frequentes · guardiao/critico/arcano** — nível 14.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: eventos_frequentes · guardiao/marca/arcano** — nível 13.0 (meta 9–12), 7.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_curar · guardiao/critico/arcano** — nível 14.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_curar · guardiao/marca/arcano** — nível 13.5 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · guardiao/critico/arcano** — nível 15.0 (meta 9–12), 10.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · guardiao/critico/controle** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · guardiao/marca/arcano** — nível 14.5 (meta 9–12), 9.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · guardiao/marca/controle** — nível 13.0 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · retaliacao/critico/controle** — nível 13.0 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · retaliacao/marca/arcano** — nível 14.5 (meta 9–12), 9.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · retaliacao/marca/controle** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Combinações que nunca vencem na campanha** — 1: poco_sacrificar · retaliacao/critico/arcano _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Itens por tentativa** — mediana 4.5 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| base · guardiao/critico/arcano | 100% | 0% | 8.0 | 14.0 |
| base · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| base · guardiao/marca/arcano | 100% | 0% | 7.5 | 13.5 |
| base · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| base · retaliacao/critico/arcano | 100% | 0% | 6.5 | 12.0 |
| base · retaliacao/critico/controle | 100% | 0% | 4.5 | 9.5 |
| base · retaliacao/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| base · retaliacao/marca/controle | 100% | 0% | 4.5 | 9.5 |
| eventos_frequentes · guardiao/critico/arcano | 100% | 0% | 8.0 | 14.0 |
| eventos_frequentes · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| eventos_frequentes · guardiao/marca/arcano | 100% | 0% | 7.0 | 13.0 |
| eventos_frequentes · guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| eventos_frequentes · retaliacao/critico/arcano | 100% | 0% | 6.5 | 12.0 |
| eventos_frequentes · retaliacao/critico/controle | 100% | 0% | 5.5 | 11.0 |
| eventos_frequentes · retaliacao/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| eventos_frequentes · retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| poco_curar · guardiao/critico/arcano | 100% | 0% | 8.0 | 14.0 |
| poco_curar · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| poco_curar · guardiao/marca/arcano | 100% | 0% | 7.5 | 13.5 |
| poco_curar · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| poco_curar · retaliacao/critico/arcano | 100% | 0% | 6.5 | 12.0 |
| poco_curar · retaliacao/critico/controle | 100% | 0% | 4.5 | 9.5 |
| poco_curar · retaliacao/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| poco_curar · retaliacao/marca/controle | 100% | 0% | 4.5 | 9.5 |
| poco_sacrificar · guardiao/critico/arcano | 33% | 0% | 10.0 | 15.0 |
| poco_sacrificar · guardiao/critico/controle | 100% | 0% | 8.0 | 13.0 |
| poco_sacrificar · guardiao/marca/arcano | 67% | 0% | 9.5 | 14.5 |
| poco_sacrificar · guardiao/marca/controle | 100% | 0% | 7.5 | 13.0 |
| poco_sacrificar · retaliacao/critico/arcano | 0% | 0% | — | — |
| poco_sacrificar · retaliacao/critico/controle | 100% | 0% | 7.5 | 13.0 |
| poco_sacrificar · retaliacao/marca/arcano | 33% | 0% | 9.5 | 14.5 |
| poco_sacrificar · retaliacao/marca/controle | 100% | 0% | 8.0 | 13.0 |

## Comparação de variantes (hero_003 fora da build lumen)

| Variante | Rota: lumen | Rota: melhor sem lumen | Sem lumen com rota ≥ 50% | Tentativas: lumen | Tentativas: melhor sem lumen | Caminhos sem lumen em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| base | — | — | 0/8 | — | 4.5 | 2/8 (retaliacao/critico/controle, retaliacao/marca/controle) |
| eventos_frequentes | — | — | 0/8 | — | 5.0 | 2/8 (guardiao/marca/controle, retaliacao/marca/controle) |
| poco_curar | — | — | 0/8 | — | 4.5 | 2/8 (retaliacao/critico/controle, retaliacao/marca/controle) |
| poco_sacrificar | — | — | 0/8 | — | 7.5 | 0/8 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| base · guardiao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 100 |
| base · guardiao/critico/controle | 0 | 13.0 | 4.0 | 14 | 78 |
| base · guardiao/marca/arcano | 0 | 13.0 | 4.0 | 14 | 98 |
| base · guardiao/marca/controle | 0 | 13.0 | 4.0 | 12 | 78 |
| base · retaliacao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 78 |
| base · retaliacao/critico/controle | 0 | 13.0 | 4.0 | 13 | 58 |
| base · retaliacao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 78 |
| base · retaliacao/marca/controle | 0 | 13.0 | 4.0 | 12 | 58 |
| eventos_frequentes · guardiao/critico/arcano | 0 | 13.0 | 5.0 | 14 | 97 |
| eventos_frequentes · guardiao/critico/controle | 0 | 13.0 | 5.0 | 12 | 76 |
| eventos_frequentes · guardiao/marca/arcano | 0 | 13.0 | 5.0 | 13 | 92 |
| eventos_frequentes · guardiao/marca/controle | 0 | 13.0 | 5.0 | 12 | 61 |
| eventos_frequentes · retaliacao/critico/arcano | 0 | 13.0 | 5.0 | 13 | 84 |
| eventos_frequentes · retaliacao/critico/controle | 0 | 13.0 | 5.0 | 12 | 70 |
| eventos_frequentes · retaliacao/marca/arcano | 0 | 13.0 | 5.0 | 13 | 78 |
| eventos_frequentes · retaliacao/marca/controle | 0 | 13.0 | 5.0 | 12 | 63 |
| poco_curar · guardiao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 100 |
| poco_curar · guardiao/critico/controle | 0 | 13.0 | 4.0 | 14 | 78 |
| poco_curar · guardiao/marca/arcano | 0 | 13.0 | 4.0 | 14 | 98 |
| poco_curar · guardiao/marca/controle | 0 | 13.0 | 4.0 | 12 | 78 |
| poco_curar · retaliacao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 78 |
| poco_curar · retaliacao/critico/controle | 0 | 13.0 | 4.0 | 13 | 58 |
| poco_curar · retaliacao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 78 |
| poco_curar · retaliacao/marca/controle | 0 | 13.0 | 4.0 | 12 | 58 |
| poco_sacrificar · guardiao/critico/arcano | 0 | 12.0 | 5.0 | 15 | 119 |
| poco_sacrificar · guardiao/critico/controle | 0 | 12.0 | 5.0 | 14 | 98 |
| poco_sacrificar · guardiao/marca/arcano | 0 | 12.0 | 5.0 | 14 | 114 |
| poco_sacrificar · guardiao/marca/controle | 0 | 13.0 | 5.0 | 14 | 96 |
| poco_sacrificar · retaliacao/critico/arcano | 0 | 12.0 | 5.0 | 15 | 120 |
| poco_sacrificar · retaliacao/critico/controle | 0 | 12.0 | 5.0 | 14 | 94 |
| poco_sacrificar · retaliacao/marca/arcano | 0 | 12.0 | 5.0 | 15 | 118 |
| poco_sacrificar · retaliacao/marca/controle | 0 | 12.0 | 5.0 | 14 | 99 |

## Eventos e loot da run (SLICE-1B, campanha com o núcleo real)

| Variante | Evento | Oferecido | Por 100 tentativas | Escolhas |
| --- | --- | ---: | ---: | --- |
| base | event_c1_001 | 289 | 100 | heal: 289 |
| base | event_c1_arvore_cantante | 10 | 3 | touch: 10 |
| base | event_c1_criatura_ferida | 39 | 13 | save: 39 |
| base | event_c1_cristal_partido | 30 | 10 | absorb: 30 |
| base | event_c1_eco_percebido | 47 | 16 | react: 47 |
| base | event_c1_memorial | 11 | 4 | honor_hero_001: 11 |
| base | event_c1_observador | 12 | 4 | witness: 12 |
| base | event_c1_raiz_oca | 23 | 8 | open: 23 |
| base | event_c1_rastro_cacada | 27 | 9 | follow: 27 |
| base | event_c1_reserva_residuo | 284 | 98 | collect: 284 |
| base | event_c1_sobrevivente | 29 | 10 | protect: 29 |
| eventos_frequentes | event_c1_001 | 290 | 100 | heal: 290 |
| eventos_frequentes | event_c1_arvore_cantante | 78 | 27 | touch: 78 |
| eventos_frequentes | event_c1_criatura_ferida | 77 | 27 | save: 77 |
| eventos_frequentes | event_c1_cristal_partido | 90 | 31 | absorb: 90 |
| eventos_frequentes | event_c1_eco_percebido | 83 | 29 | react: 83 |
| eventos_frequentes | event_c1_memorial | 31 | 11 | honor_hero_001: 31 |
| eventos_frequentes | event_c1_raiz_oca | 46 | 16 | open: 46 |
| eventos_frequentes | event_c1_rastro_cacada | 87 | 30 | follow: 87 |
| eventos_frequentes | event_c1_reserva_residuo | 285 | 98 | collect: 285 |
| eventos_frequentes | event_c1_sobrevivente | 71 | 24 | protect: 71 |
| poco_curar | event_c1_001 | 289 | 100 | heal: 289 |
| poco_curar | event_c1_arvore_cantante | 10 | 3 | touch: 10 |
| poco_curar | event_c1_criatura_ferida | 39 | 13 | save: 39 |
| poco_curar | event_c1_cristal_partido | 30 | 10 | absorb: 30 |
| poco_curar | event_c1_eco_percebido | 47 | 16 | react: 47 |
| poco_curar | event_c1_memorial | 11 | 4 | honor_hero_001: 11 |
| poco_curar | event_c1_observador | 12 | 4 | witness: 12 |
| poco_curar | event_c1_raiz_oca | 23 | 8 | open: 23 |
| poco_curar | event_c1_rastro_cacada | 27 | 9 | follow: 27 |
| poco_curar | event_c1_reserva_residuo | 284 | 98 | collect: 284 |
| poco_curar | event_c1_sobrevivente | 29 | 10 | protect: 29 |
| poco_sacrificar | event_c1_001 | 422 | 100 | sacrifice: 422 |
| poco_sacrificar | event_c1_arvore_cantante | 23 | 5 | touch: 23 |
| poco_sacrificar | event_c1_criatura_ferida | 59 | 14 | save: 59 |
| poco_sacrificar | event_c1_cristal_partido | 40 | 9 | absorb: 40 |
| poco_sacrificar | event_c1_eco_percebido | 65 | 15 | react: 65 |
| poco_sacrificar | event_c1_memorial | 34 | 8 | honor_hero_001: 34 |
| poco_sacrificar | event_c1_observador | 15 | 4 | witness: 15 |
| poco_sacrificar | event_c1_raiz_oca | 48 | 11 | open: 48 |
| poco_sacrificar | event_c1_rastro_cacada | 50 | 12 | follow: 50 |
| poco_sacrificar | event_c1_reserva_residuo | 362 | 86 | collect: 362 |
| poco_sacrificar | event_c1_sobrevivente | 44 | 10 | protect: 44 |

Itens recebidos por raridade: Comum 1687, Incomum 982, Raro 3110, Relíquia 176, Épico 176.

Comparação com `20260929-170303_cd47758`.
