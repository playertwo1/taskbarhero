# Argos — relatório `tune_v05_builds`

- Commit: `b2c730a` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[PACING/MEDIUM] Vence tarde demais: ambos · guardiao/critico/arcano** — nível 14.0 (meta 9–12), 9.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: ambos · guardiao/marca/arcano** — nível 13.5 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: ambos · retaliacao/critico/arcano** — nível 14.0 (meta 9–12), 8.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: ambos · retaliacao/marca/arcano** — nível 13.0 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: ambos_arcano2 · guardiao/critico/arcano** — nível 15.0 (meta 9–12), 10.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: ambos_arcano2 · guardiao/marca/arcano** — nível 13.5 (meta 9–12), 7.5 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: ambos_arcano2 · retaliacao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: base_v05 · guardiao/critico/arcano** — nível 15.0 (meta 9–12), 10.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: base_v05 · guardiao/marca/arcano** — nível 15.0 (meta 9–12), 10.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[PACING/MEDIUM] Vence tarde demais: base_v05 · retaliacao/critico/arcano** — nível 13.0 (meta 9–12), 8.0 tentativas _(regra: Rafael, 2026-09-29: jogo incremental; o Guardião deve ser vencido por volta do nível 10–11 após derrotas e vitórias parciais (faixa 9–12 e 3–8 tentativas são tolerância HIPÓTESE))_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| ambos · guardiao/critico/arcano | 100% | 0% | 9.0 | 14.0 |
| ambos · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| ambos · guardiao/critico/lumen | 100% | 0% | 4.5 | 9.5 |
| ambos · guardiao/marca/arcano | 100% | 0% | 8.0 | 13.5 |
| ambos · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| ambos · guardiao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| ambos · retaliacao/critico/arcano | 100% | 0% | 8.5 | 14.0 |
| ambos · retaliacao/critico/controle | 100% | 0% | 6.0 | 11.5 |
| ambos · retaliacao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| ambos · retaliacao/marca/arcano | 100% | 0% | 7.5 | 13.0 |
| ambos · retaliacao/marca/controle | 100% | 0% | 5.5 | 11.0 |
| ambos · retaliacao/marca/lumen | 100% | 0% | 4.5 | 9.5 |
| ambos · retaliacao_tele/critico/arcano | 100% | 0% | 6.5 | 11.5 |
| ambos · retaliacao_tele/critico/controle | 100% | 0% | 5.5 | 11.0 |
| ambos · retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| ambos · retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| ambos · retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| ambos · retaliacao_tele/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| ambos_arcano2 · guardiao/critico/arcano | 100% | 0% | 10.0 | 15.0 |
| ambos_arcano2 · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| ambos_arcano2 · guardiao/critico/lumen | 100% | 0% | 4.5 | 9.5 |
| ambos_arcano2 · guardiao/marca/arcano | 100% | 0% | 7.5 | 13.5 |
| ambos_arcano2 · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| ambos_arcano2 · guardiao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| ambos_arcano2 · retaliacao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| ambos_arcano2 · retaliacao/critico/controle | 100% | 0% | 6.0 | 11.5 |
| ambos_arcano2 · retaliacao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| ambos_arcano2 · retaliacao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| ambos_arcano2 · retaliacao/marca/controle | 100% | 0% | 5.5 | 11.0 |
| ambos_arcano2 · retaliacao/marca/lumen | 100% | 0% | 4.5 | 9.5 |
| ambos_arcano2 · retaliacao_tele/critico/arcano | 100% | 0% | 7.0 | 12.0 |
| ambos_arcano2 · retaliacao_tele/critico/controle | 100% | 0% | 5.5 | 11.0 |
| ambos_arcano2 · retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| ambos_arcano2 · retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| ambos_arcano2 · retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| ambos_arcano2 · retaliacao_tele/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| base_v05 · guardiao/critico/arcano | 100% | 0% | 10.0 | 15.0 |
| base_v05 · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| base_v05 · guardiao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| base_v05 · guardiao/marca/arcano | 100% | 0% | 10.0 | 15.0 |
| base_v05 · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| base_v05 · guardiao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| base_v05 · retaliacao/critico/arcano | 100% | 0% | 8.0 | 13.0 |
| base_v05 · retaliacao/critico/controle | 100% | 0% | 6.0 | 11.5 |
| base_v05 · retaliacao/critico/lumen | 100% | 0% | 5.0 | 10.0 |
| base_v05 · retaliacao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| base_v05 · retaliacao/marca/controle | 100% | 0% | 5.5 | 11.0 |
| base_v05 · retaliacao/marca/lumen | 100% | 0% | 4.5 | 9.5 |
| base_v05 · retaliacao_tele/critico/arcano | 100% | 0% | 7.0 | 12.0 |
| base_v05 · retaliacao_tele/critico/controle | 100% | 0% | 5.5 | 11.0 |
| base_v05 · retaliacao_tele/critico/lumen | 100% | 0% | 4.0 | 9.0 |
| base_v05 · retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 11.0 |
| base_v05 · retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| base_v05 · retaliacao_tele/marca/lumen | 100% | 0% | 4.0 | 9.0 |

## Comparação de variantes (sem cura = Íris fora da build Lúmen)

| Variante | Rota: cura | Rota: melhor sem cura | Sem cura com rota ≥ 50% | Tentativas: cura | Tentativas: melhor sem cura | Caminhos sem cura em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| ambos | — | — | 0/12 | 4.2 | 4.0 | 1/12 (retaliacao_tele/marca/controle) |
| ambos_arcano2 | — | — | 0/12 | 4.2 | 4.0 | 1/12 (retaliacao_tele/marca/controle) |
| base_v05 | — | — | 0/12 | 4.2 | 4.0 | 1/12 (retaliacao_tele/marca/controle) |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| ambos · guardiao/critico/arcano | 230 | 13.0 | 4.0 | 14 | 116 |
| ambos · guardiao/critico/controle | 237 | 13.0 | 4.0 | 11 | 80 |
| ambos · guardiao/critico/lumen | 238 | 13.0 | 5.0 | 10 | 58 |
| ambos · guardiao/marca/arcano | 237 | 13.0 | 4.0 | 14 | 102 |
| ambos · guardiao/marca/controle | 232 | 13.0 | 5.0 | 11 | 76 |
| ambos · guardiao/marca/lumen | 237 | 13.0 | 5.0 | 10 | 52 |
| ambos · retaliacao/critico/arcano | 228 | 13.0 | 4.0 | 12 | 105 |
| ambos · retaliacao/critico/controle | 234 | 13.0 | 4.0 | 11 | 76 |
| ambos · retaliacao/critico/lumen | 238 | 13.0 | 4.0 | 10 | 64 |
| ambos · retaliacao/marca/arcano | 230 | 12.5 | 4.0 | 12 | 94 |
| ambos · retaliacao/marca/controle | 233 | 13.0 | 4.0 | 10 | 67 |
| ambos · retaliacao/marca/lumen | 237 | 13.0 | 4.0 | 10 | 58 |
| ambos · retaliacao_tele/critico/arcano | 226 | 13.0 | 4.0 | 11 | 82 |
| ambos · retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 10 | 74 |
| ambos · retaliacao_tele/critico/lumen | 238 | 13.0 | 5.0 | 10 | 52 |
| ambos · retaliacao_tele/marca/arcano | 226 | 13.0 | 4.0 | 11 | 77 |
| ambos · retaliacao_tele/marca/controle | 236 | 13.0 | 5.0 | 11 | 54 |
| ambos · retaliacao_tele/marca/lumen | 235 | 13.0 | 4.5 | 8 | 48 |
| ambos_arcano2 · guardiao/critico/arcano | 236 | 13.0 | 4.0 | 14 | 125 |
| ambos_arcano2 · guardiao/critico/controle | 237 | 13.0 | 4.0 | 11 | 80 |
| ambos_arcano2 · guardiao/critico/lumen | 238 | 13.0 | 5.0 | 10 | 58 |
| ambos_arcano2 · guardiao/marca/arcano | 234 | 13.0 | 4.0 | 12 | 97 |
| ambos_arcano2 · guardiao/marca/controle | 232 | 13.0 | 5.0 | 11 | 76 |
| ambos_arcano2 · guardiao/marca/lumen | 237 | 13.0 | 5.0 | 10 | 52 |
| ambos_arcano2 · retaliacao/critico/arcano | 227 | 12.5 | 4.0 | 13 | 98 |
| ambos_arcano2 · retaliacao/critico/controle | 234 | 13.0 | 4.0 | 11 | 76 |
| ambos_arcano2 · retaliacao/critico/lumen | 238 | 13.0 | 4.0 | 10 | 64 |
| ambos_arcano2 · retaliacao/marca/arcano | 230 | 12.5 | 4.0 | 12 | 89 |
| ambos_arcano2 · retaliacao/marca/controle | 233 | 13.0 | 4.0 | 10 | 67 |
| ambos_arcano2 · retaliacao/marca/lumen | 237 | 13.0 | 4.0 | 10 | 58 |
| ambos_arcano2 · retaliacao_tele/critico/arcano | 228 | 13.0 | 4.0 | 12 | 89 |
| ambos_arcano2 · retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 10 | 74 |
| ambos_arcano2 · retaliacao_tele/critico/lumen | 238 | 13.0 | 5.0 | 10 | 52 |
| ambos_arcano2 · retaliacao_tele/marca/arcano | 233 | 12.0 | 4.0 | 12 | 78 |
| ambos_arcano2 · retaliacao_tele/marca/controle | 236 | 13.0 | 5.0 | 11 | 54 |
| ambos_arcano2 · retaliacao_tele/marca/lumen | 235 | 13.0 | 4.5 | 8 | 48 |
| base_v05 · guardiao/critico/arcano | 231 | 13.0 | 4.0 | 14 | 128 |
| base_v05 · guardiao/critico/controle | 235 | 13.0 | 4.0 | 12 | 82 |
| base_v05 · guardiao/critico/lumen | 238 | 13.0 | 4.0 | 12 | 70 |
| base_v05 · guardiao/marca/arcano | 231 | 13.0 | 4.0 | 14 | 131 |
| base_v05 · guardiao/marca/controle | 237 | 13.0 | 4.0 | 10 | 78 |
| base_v05 · guardiao/marca/lumen | 238 | 13.0 | 4.0 | 9 | 50 |
| base_v05 · retaliacao/critico/arcano | 226 | 13.0 | 4.0 | 12 | 102 |
| base_v05 · retaliacao/critico/controle | 234 | 13.0 | 4.0 | 11 | 76 |
| base_v05 · retaliacao/critico/lumen | 238 | 13.0 | 4.0 | 10 | 64 |
| base_v05 · retaliacao/marca/arcano | 234 | 13.0 | 4.0 | 12 | 88 |
| base_v05 · retaliacao/marca/controle | 233 | 13.0 | 4.0 | 10 | 67 |
| base_v05 · retaliacao/marca/lumen | 237 | 13.0 | 4.0 | 10 | 58 |
| base_v05 · retaliacao_tele/critico/arcano | 226 | 12.0 | 4.0 | 12 | 84 |
| base_v05 · retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 10 | 74 |
| base_v05 · retaliacao_tele/critico/lumen | 238 | 13.0 | 5.0 | 10 | 52 |
| base_v05 · retaliacao_tele/marca/arcano | 234 | 13.0 | 4.0 | 11 | 80 |
| base_v05 · retaliacao_tele/marca/controle | 236 | 13.0 | 5.0 | 11 | 54 |
| base_v05 · retaliacao_tele/marca/lumen | 235 | 13.0 | 4.5 | 8 | 48 |

Comparação com `20260929-144616_b2c730a`.
