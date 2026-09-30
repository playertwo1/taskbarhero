# Argos — relatório `slice_run_layer`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `78a22adb96ccda8295ff6b9db3fdd99854e508eb355e2679726cc4b37f046939`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[PACING/MEDIUM] Vence tarde demais: base · guardiao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: base · retaliacao/critico/arcano** — nível 12.5 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: com_arvore_e_ferreiro · guardiao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: eventos_frequentes · guardiao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_curar · guardiao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_curar · retaliacao/critico/arcano** — nível 12.5 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · guardiao/critico/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · guardiao/marca/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · retaliacao/critico/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · retaliacao/critico/controle** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: poco_sacrificar · retaliacao/marca/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| base · guardiao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| base · guardiao/critico/controle | 100% | 0% | 6.0 | 11.0 |
| base · guardiao/marca/arcano | 100% | 0% | 6.5 | 11.5 |
| base · guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| base · retaliacao/critico/arcano | 100% | 0% | 7.5 | 12.5 |
| base · retaliacao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| base · retaliacao/marca/arcano | 100% | 0% | 6.5 | 11.5 |
| base · retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| com_arvore_e_ferreiro · guardiao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| com_arvore_e_ferreiro · guardiao/critico/controle | 100% | 0% | 6.0 | 11.0 |
| com_arvore_e_ferreiro · guardiao/marca/arcano | 100% | 0% | 6.5 | 11.5 |
| com_arvore_e_ferreiro · guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| com_arvore_e_ferreiro · retaliacao/critico/arcano | 100% | 0% | 7.0 | 12.0 |
| com_arvore_e_ferreiro · retaliacao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| com_arvore_e_ferreiro · retaliacao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| com_arvore_e_ferreiro · retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| eventos_frequentes · guardiao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| eventos_frequentes · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| eventos_frequentes · guardiao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| eventos_frequentes · guardiao/marca/controle | 100% | 0% | 5.5 | 10.5 |
| eventos_frequentes · retaliacao/critico/arcano | 100% | 0% | 7.0 | 12.0 |
| eventos_frequentes · retaliacao/critico/controle | 100% | 0% | 5.0 | 10.0 |
| eventos_frequentes · retaliacao/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| eventos_frequentes · retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| poco_curar · guardiao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| poco_curar · guardiao/critico/controle | 100% | 0% | 6.0 | 11.0 |
| poco_curar · guardiao/marca/arcano | 100% | 0% | 6.5 | 11.5 |
| poco_curar · guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| poco_curar · retaliacao/critico/arcano | 100% | 0% | 7.5 | 12.5 |
| poco_curar · retaliacao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| poco_curar · retaliacao/marca/arcano | 100% | 0% | 6.5 | 11.5 |
| poco_curar · retaliacao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| poco_sacrificar · guardiao/critico/arcano | 100% | 0% | 9.0 | 14.0 |
| poco_sacrificar · guardiao/critico/controle | 100% | 0% | 7.0 | 12.0 |
| poco_sacrificar · guardiao/marca/arcano | 100% | 0% | 8.0 | 13.0 |
| poco_sacrificar · guardiao/marca/controle | 100% | 0% | 6.0 | 11.0 |
| poco_sacrificar · retaliacao/critico/arcano | 100% | 0% | 9.0 | 14.0 |
| poco_sacrificar · retaliacao/critico/controle | 100% | 0% | 8.0 | 13.0 |
| poco_sacrificar · retaliacao/marca/arcano | 100% | 0% | 9.0 | 14.0 |
| poco_sacrificar · retaliacao/marca/controle | 100% | 0% | 6.5 | 11.5 |

## Comparação de variantes (hero_003 fora da build lumen)

| Variante | Rota: lumen | Rota: melhor sem lumen | Sem lumen com rota ≥ 50% | Tentativas: lumen | Tentativas: melhor sem lumen | Caminhos sem lumen em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| base | — | — | 0/8 | — | 5.0 | 2/8 (guardiao/marca/controle, retaliacao/marca/controle) |
| com_arvore_e_ferreiro | — | — | 0/8 | — | 5.0 | 2/8 (guardiao/marca/controle, retaliacao/marca/controle) |
| eventos_frequentes | — | — | 0/8 | — | 5.0 | 2/8 (retaliacao/critico/controle, retaliacao/marca/controle) |
| poco_curar | — | — | 0/8 | — | 5.0 | 2/8 (guardiao/marca/controle, retaliacao/marca/controle) |
| poco_sacrificar | — | — | 0/8 | — | 6.0 | 0/8 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| base · guardiao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 98 |
| base · guardiao/critico/controle | 0 | 13.0 | 4.0 | 14 | 72 |
| base · guardiao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 76 |
| base · guardiao/marca/controle | 0 | 13.0 | 4.0 | 13 | 65 |
| base · retaliacao/critico/arcano | 0 | 12.5 | 4.0 | 14 | 86 |
| base · retaliacao/critico/controle | 0 | 13.0 | 4.0 | 14 | 78 |
| base · retaliacao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 75 |
| base · retaliacao/marca/controle | 0 | 13.0 | 4.0 | 13 | 65 |
| com_arvore_e_ferreiro · guardiao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 94 |
| com_arvore_e_ferreiro · guardiao/critico/controle | 0 | 13.0 | 4.0 | 14 | 70 |
| com_arvore_e_ferreiro · guardiao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 76 |
| com_arvore_e_ferreiro · guardiao/marca/controle | 0 | 13.0 | 4.0 | 12 | 62 |
| com_arvore_e_ferreiro · retaliacao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 82 |
| com_arvore_e_ferreiro · retaliacao/critico/controle | 0 | 13.0 | 4.0 | 14 | 76 |
| com_arvore_e_ferreiro · retaliacao/marca/arcano | 0 | 13.0 | 4.0 | 14 | 81 |
| com_arvore_e_ferreiro · retaliacao/marca/controle | 0 | 13.0 | 4.0 | 13 | 65 |
| eventos_frequentes · guardiao/critico/arcano | 0 | 12.0 | 4.0 | 13 | 92 |
| eventos_frequentes · guardiao/critico/controle | 0 | 13.0 | 4.0 | 13 | 76 |
| eventos_frequentes · guardiao/marca/arcano | 0 | 12.5 | 4.5 | 13 | 80 |
| eventos_frequentes · guardiao/marca/controle | 0 | 13.0 | 5.0 | 13 | 66 |
| eventos_frequentes · retaliacao/critico/arcano | 0 | 12.5 | 4.0 | 13 | 82 |
| eventos_frequentes · retaliacao/critico/controle | 0 | 13.0 | 5.0 | 12 | 65 |
| eventos_frequentes · retaliacao/marca/arcano | 0 | 12.0 | 4.0 | 12 | 68 |
| eventos_frequentes · retaliacao/marca/controle | 0 | 13.0 | 5.0 | 12 | 64 |
| poco_curar · guardiao/critico/arcano | 0 | 13.0 | 4.0 | 14 | 98 |
| poco_curar · guardiao/critico/controle | 0 | 13.0 | 4.0 | 14 | 72 |
| poco_curar · guardiao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 76 |
| poco_curar · guardiao/marca/controle | 0 | 13.0 | 4.0 | 13 | 65 |
| poco_curar · retaliacao/critico/arcano | 0 | 12.5 | 4.0 | 14 | 86 |
| poco_curar · retaliacao/critico/controle | 0 | 13.0 | 4.0 | 14 | 78 |
| poco_curar · retaliacao/marca/arcano | 0 | 13.0 | 4.0 | 13 | 75 |
| poco_curar · retaliacao/marca/controle | 0 | 13.0 | 4.0 | 13 | 65 |
| poco_sacrificar · guardiao/critico/arcano | 0 | 12.0 | 5.0 | 15 | 104 |
| poco_sacrificar · guardiao/critico/controle | 0 | 12.0 | 5.0 | 14 | 88 |
| poco_sacrificar · guardiao/marca/arcano | 0 | 12.0 | 5.0 | 14 | 92 |
| poco_sacrificar · guardiao/marca/controle | 0 | 12.0 | 5.0 | 14 | 72 |
| poco_sacrificar · retaliacao/critico/arcano | 0 | 12.5 | 5.0 | 15 | 108 |
| poco_sacrificar · retaliacao/critico/controle | 0 | 12.0 | 5.0 | 14 | 96 |
| poco_sacrificar · retaliacao/marca/arcano | 0 | 12.0 | 5.0 | 15 | 104 |
| poco_sacrificar · retaliacao/marca/controle | 0 | 13.0 | 5.0 | 14 | 80 |

## Eventos e loot da run (SLICE-1B, campanha com o núcleo real)

| Variante | Evento | Oferecido | Por 100 tentativas | Escolhas |
| --- | --- | ---: | ---: | --- |
| base | event_c1_001 | 296 | 98 | heal: 296 |
| base | event_c1_arvore_cantante | 9 | 3 | touch: 9 |
| base | event_c1_criatura_ferida | 39 | 13 | save: 39 |
| base | event_c1_cristal_partido | 32 | 11 | absorb: 32 |
| base | event_c1_eco_percebido | 50 | 17 | react: 50 |
| base | event_c1_memorial | 13 | 4 | honor_hero_001: 13 |
| base | event_c1_observador | 10 | 3 | witness: 10 |
| base | event_c1_raiz_oca | 29 | 10 | open: 29 |
| base | event_c1_rastro_cacada | 29 | 10 | follow: 29 |
| base | event_c1_reserva_residuo | 271 | 90 | collect: 271 |
| base | event_c1_sobrevivente | 32 | 11 | protect: 32 |
| com_arvore_e_ferreiro | event_c1_001 | 295 | 98 | heal: 295 |
| com_arvore_e_ferreiro | event_c1_arvore_cantante | 10 | 3 | touch: 10 |
| com_arvore_e_ferreiro | event_c1_criatura_ferida | 37 | 12 | save: 37 |
| com_arvore_e_ferreiro | event_c1_cristal_partido | 34 | 11 | absorb: 34 |
| com_arvore_e_ferreiro | event_c1_eco_percebido | 50 | 17 | react: 50 |
| com_arvore_e_ferreiro | event_c1_memorial | 11 | 4 | honor_hero_001: 11 |
| com_arvore_e_ferreiro | event_c1_observador | 9 | 3 | witness: 9 |
| com_arvore_e_ferreiro | event_c1_raiz_oca | 29 | 10 | open: 29 |
| com_arvore_e_ferreiro | event_c1_rastro_cacada | 29 | 10 | follow: 29 |
| com_arvore_e_ferreiro | event_c1_reserva_residuo | 270 | 90 | collect: 270 |
| com_arvore_e_ferreiro | event_c1_sobrevivente | 32 | 11 | protect: 32 |
| eventos_frequentes | event_c1_001 | 289 | 97 | heal: 289 |
| eventos_frequentes | event_c1_arvore_cantante | 80 | 27 | touch: 80 |
| eventos_frequentes | event_c1_criatura_ferida | 77 | 26 | save: 77 |
| eventos_frequentes | event_c1_cristal_partido | 89 | 30 | absorb: 89 |
| eventos_frequentes | event_c1_eco_percebido | 78 | 26 | react: 78 |
| eventos_frequentes | event_c1_memorial | 31 | 10 | honor_hero_001: 31 |
| eventos_frequentes | event_c1_raiz_oca | 52 | 17 | open: 52 |
| eventos_frequentes | event_c1_rastro_cacada | 91 | 30 | follow: 91 |
| eventos_frequentes | event_c1_reserva_residuo | 269 | 90 | collect: 269 |
| eventos_frequentes | event_c1_sobrevivente | 73 | 24 | protect: 73 |
| poco_curar | event_c1_001 | 296 | 98 | heal: 296 |
| poco_curar | event_c1_arvore_cantante | 9 | 3 | touch: 9 |
| poco_curar | event_c1_criatura_ferida | 39 | 13 | save: 39 |
| poco_curar | event_c1_cristal_partido | 32 | 11 | absorb: 32 |
| poco_curar | event_c1_eco_percebido | 50 | 17 | react: 50 |
| poco_curar | event_c1_memorial | 13 | 4 | honor_hero_001: 13 |
| poco_curar | event_c1_observador | 10 | 3 | witness: 10 |
| poco_curar | event_c1_raiz_oca | 29 | 10 | open: 29 |
| poco_curar | event_c1_rastro_cacada | 29 | 10 | follow: 29 |
| poco_curar | event_c1_reserva_residuo | 271 | 90 | collect: 271 |
| poco_curar | event_c1_sobrevivente | 32 | 11 | protect: 32 |
| poco_sacrificar | event_c1_001 | 368 | 99 | sacrifice: 368 |
| poco_sacrificar | event_c1_arvore_cantante | 18 | 5 | touch: 18 |
| poco_sacrificar | event_c1_criatura_ferida | 47 | 13 | save: 47 |
| poco_sacrificar | event_c1_cristal_partido | 38 | 10 | absorb: 38 |
| poco_sacrificar | event_c1_eco_percebido | 58 | 16 | react: 58 |
| poco_sacrificar | event_c1_memorial | 25 | 7 | honor_hero_001: 25 |
| poco_sacrificar | event_c1_observador | 12 | 3 | witness: 12 |
| poco_sacrificar | event_c1_raiz_oca | 41 | 11 | open: 41 |
| poco_sacrificar | event_c1_rastro_cacada | 46 | 12 | follow: 46 |
| poco_sacrificar | event_c1_reserva_residuo | 306 | 82 | collect: 306 |
| poco_sacrificar | event_c1_sobrevivente | 38 | 10 | protect: 38 |

Itens recebidos por raridade: Comum 1998, Incomum 1187, Raro 3542, Relíquia 240, Épico 240.

Comparação com `20260930-183255_82571ad`.
