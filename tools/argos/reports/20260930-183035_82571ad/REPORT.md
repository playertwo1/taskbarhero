# Argos — relatório `argos_profiles`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 4 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `48381612cda7d7842ac5f1aea228a5d958a29b0d9513b1f51e6abe9e98fe4896`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| aggressor · retaliacao/critico/arcano | 100% | 0% | 7.5 | 12.5 |
| beginner · guardiao/marca/arcano | 0% | 0% | — | — |
| beginner · guardiao/marca/lumen | 100% | 0% | 4.0 | 8.0 |
| beginner · retaliacao/marca/arcano | 25% | 0% | 6.0 | 11.0 |
| beginner · retaliacao/marca/lumen | 100% | 0% | 4.0 | 9.0 |
| chaos · guardiao/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| chaos · guardiao/marca/lumen | 100% | 0% | 5.0 | 10.0 |
| chaos · retaliacao/marca/arcano | 100% | 0% | 5.0 | 10.0 |
| chaos · retaliacao/marca/lumen | 100% | 0% | 5.0 | 10.0 |
| grinder · guardiao/marca/controle | 100% | 0% | 65.0 | 32.0 |
| optimizer · guardiao/marca/arcano | 100% | 0% | 6.5 | 11.5 |
| optimizer · guardiao/marca/lumen | 100% | 0% | 4.0 | 8.0 |
| optimizer · retaliacao/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| optimizer · retaliacao/marca/lumen | 100% | 0% | 3.5 | 8.0 |
| turtle · guardiao/marca/lumen | 100% | 0% | 4.0 | 8.0 |

## Perfis de jogador (simulação de comportamento; não é playtest)

| Perfil | Campanhas | Vence | Abandona | 1ª vitória (tentativa) | Nível final | Itens guardados | Save (KB) | Fuzz: ações (recusadas) | Bordas | Violações |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| aggressor | 4 | 100% | 0% | 7.5 | 14 | 30 | 3.3 | — | — | — |
| beginner | 16 | 56% | 44% | 4.0 | 12 | 20 | 2.2 | — | — | — |
| chaos | 16 | 100% | 0% | 5.0 | 12 | 24 | 2.5 | 2000 (962) | — | — |
| edge_case | — | — | — | — | — | — | — | 1600 (575) | 32 | — |
| exploit_hunter | — | — | — | — | — | — | — | 3200 (2064) | — | — |
| grinder | 4 | 100% | 0% | 5.0 | 33 | 338 | 27.2 | — | — | — |
| optimizer | 16 | 100% | 0% | 5.0 | 12 | 22 | 2.5 | — | — | — |
| turtle | 4 | 100% | 0% | 4.0 | 10 | 16 | 2.0 | — | — | — |

## Comparação de variantes (hero_003 fora da build lumen)

| Variante | Rota: lumen | Rota: melhor sem lumen | Sem lumen com rota ≥ 50% | Tentativas: lumen | Tentativas: melhor sem lumen | Caminhos sem lumen em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| aggressor | — | — | 0/1 | — | 7.5 | 0/1 |
| beginner | — | — | 0/2 | 4.0 | 6.0 | 0/2 |
| chaos | — | — | 0/2 | 5.0 | 5.0 | 2/2 (guardiao/marca/arcano, retaliacao/marca/arcano) |
| grinder | — | — | 0/1 | — | 65.0 | 0/1 |
| optimizer | — | — | 0/2 | 3.8 | 6.5 | 0/2 |
| turtle | — | — | 0/0 | 4.0 | — | 0/0 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| aggressor · retaliacao/critico/arcano | 0 | 13.0 | 4.0 | 13 | 87 |
| beginner · guardiao/marca/arcano | 0 | 13.0 | 3.5 | 12 | 68 |
| beginner · guardiao/marca/lumen | 0 | 11.0 | 3.0 | 12 | 43 |
| beginner · retaliacao/marca/arcano | 0 | 13.0 | 4.0 | 12 | 69 |
| beginner · retaliacao/marca/lumen | 0 | 13.0 | 4.0 | 11 | 50 |
| chaos · guardiao/marca/arcano | 0 | 12.0 | 4.0 | 11 | 56 |
| chaos · guardiao/marca/lumen | 0 | 12.0 | 4.0 | 11 | 56 |
| chaos · retaliacao/marca/arcano | 0 | 12.0 | 4.0 | 11 | 56 |
| chaos · retaliacao/marca/lumen | 0 | 12.0 | 4.0 | 11 | 56 |
| grinder · guardiao/marca/controle | 0 | 13.0 | 5.0 | 15 | 852 |
| optimizer · guardiao/marca/arcano | 0 | 13.0 | 4.0 | 12 | 76 |
| optimizer · guardiao/marca/lumen | 0 | 11.0 | 3.0 | 10 | 43 |
| optimizer · retaliacao/marca/arcano | 0 | 12.5 | 4.0 | 12 | 82 |
| optimizer · retaliacao/marca/lumen | 0 | 13.0 | 4.0 | 9 | 44 |
| turtle · guardiao/marca/lumen | 0 | 11.0 | 3.0 | 10 | 43 |

## Eventos e loot da run (SLICE-1B, campanha com o núcleo real)

| Variante | Evento | Oferecido | Por 100 tentativas | Escolhas |
| --- | --- | ---: | ---: | --- |
| aggressor | event_c1_001 | 29 | 97 | heal: 29 |
| aggressor | event_c1_arvore_cantante | 1 | 3 | touch: 1 |
| aggressor | event_c1_criatura_ferida | 5 | 17 | save: 5 |
| aggressor | event_c1_cristal_partido | 4 | 13 | absorb: 4 |
| aggressor | event_c1_eco_percebido | 4 | 13 | react: 4 |
| aggressor | event_c1_memorial | 1 | 3 | honor_hero_001: 1 |
| aggressor | event_c1_observador | 2 | 7 | witness: 2 |
| aggressor | event_c1_raiz_oca | 3 | 10 | open: 3 |
| aggressor | event_c1_rastro_cacada | 4 | 13 | follow: 4 |
| aggressor | event_c1_reserva_residuo | 26 | 87 | collect: 26 |
| aggressor | event_c1_sobrevivente | 4 | 13 | protect: 4 |
| beginner | event_c1_001 | 79 | 100 | heal: 79 |
| beginner | event_c1_arvore_cantante | 4 | 5 | touch: 4 |
| beginner | event_c1_criatura_ferida | 12 | 15 | save: 12 |
| beginner | event_c1_cristal_partido | 8 | 10 | absorb: 8 |
| beginner | event_c1_eco_percebido | 14 | 18 | react: 14 |
| beginner | event_c1_memorial | 4 | 5 | honor_hero_001: 4 |
| beginner | event_c1_observador | 4 | 5 | witness: 4 |
| beginner | event_c1_raiz_oca | 5 | 6 | open: 5 |
| beginner | event_c1_rastro_cacada | 6 | 8 | follow: 6 |
| beginner | event_c1_reserva_residuo | 67 | 85 | collect: 67 |
| beginner | event_c1_sobrevivente | 12 | 15 | protect: 12 |
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
| grinder | event_c1_001 | 260 | 100 | heal: 260 |
| grinder | event_c1_arvore_cantante | 33 | 13 | touch: 33 |
| grinder | event_c1_criatura_ferida | 47 | 18 | save: 47 |
| grinder | event_c1_cristal_partido | 27 | 10 | absorb: 27 |
| grinder | event_c1_eco_percebido | 34 | 13 | react: 34 |
| grinder | event_c1_memorial | 21 | 8 | honor_hero_001: 21 |
| grinder | event_c1_observador | 4 | 2 | witness: 4 |
| grinder | event_c1_raiz_oca | 35 | 13 | open: 35 |
| grinder | event_c1_rastro_cacada | 27 | 10 | follow: 27 |
| grinder | event_c1_reserva_residuo | 259 | 100 | collect: 259 |
| grinder | event_c1_sobrevivente | 21 | 8 | protect: 21 |
| optimizer | event_c1_001 | 84 | 100 | heal: 84 |
| optimizer | event_c1_arvore_cantante | 5 | 6 | touch: 5 |
| optimizer | event_c1_criatura_ferida | 12 | 14 | save: 12 |
| optimizer | event_c1_cristal_partido | 10 | 12 | absorb: 10 |
| optimizer | event_c1_eco_percebido | 14 | 17 | react: 14 |
| optimizer | event_c1_memorial | 3 | 4 | honor_hero_001: 3 |
| optimizer | event_c1_observador | 4 | 5 | witness: 4 |
| optimizer | event_c1_raiz_oca | 7 | 8 | open: 7 |
| optimizer | event_c1_rastro_cacada | 9 | 11 | follow: 9 |
| optimizer | event_c1_reserva_residuo | 72 | 86 | collect: 72 |
| optimizer | event_c1_sobrevivente | 12 | 14 | protect: 12 |
| turtle | event_c1_001 | 16 | 100 | heal: 16 |
| turtle | event_c1_arvore_cantante | 1 | 6 | touch: 1 |
| turtle | event_c1_criatura_ferida | 3 | 19 | save: 3 |
| turtle | event_c1_cristal_partido | 1 | 6 | absorb: 1 |
| turtle | event_c1_eco_percebido | 3 | 19 | react: 3 |
| turtle | event_c1_memorial | 1 | 6 | honor_hero_001: 1 |
| turtle | event_c1_observador | 1 | 6 | witness: 1 |
| turtle | event_c1_raiz_oca | 1 | 6 | open: 1 |
| turtle | event_c1_rastro_cacada | 1 | 6 | follow: 1 |
| turtle | event_c1_reserva_residuo | 12 | 75 | collect: 12 |
| turtle | event_c1_sobrevivente | 2 | 12 | protect: 2 |

Itens recebidos por raridade: Comum 765, Incomum 436, Raro 1049, Relíquia 93, Épico 253.
