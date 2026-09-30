# Argos — relatório `slice_route_gear`

- Commit: `82571ad` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Entradas de balanceamento: `16914d07760f78a9623b0c489a1bd283fc576c7f5776ffdcba3bbddeddd82f03`
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Dominância no nível 8** — melhor 100% vs mediana 0%; líderes: bom · guardiao/critico/lumen, bom · guardiao/marca/lumen, bom · retaliacao/marca/lumen, bom · retaliacao_tele/critico/lumen, bom · retaliacao_tele/marca/lumen, nu · retaliacao_tele/critico/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[BALANCE/MEDIUM] TTK de guardiao fora de 120–210 s** — 1/49 combinações vencedoras fora; mediana 142 s; pior bom · retaliacao_tele/marca/arcano nível 10: 115 s _(regra: docs/04_content/chapters/chapter_01/ENCOUNTERS.md (120–210 s))_
- **[INFO/INFO] Caminhos viáveis** — viáveis no nível 10 (rota ≥ 50%): 31; sem lumen: 13; bom · guardiao/critico/controle, bom · guardiao/critico/lumen, bom · guardiao/marca/arcano, bom · guardiao/marca/controle, bom · guardiao/marca/lumen, bom · retaliacao/critico/controle, bom · retaliacao/critico/lumen, bom · retaliacao/marca/arcano, bom · retaliacao/marca/controle, bom · retaliacao/marca/lumen, bom · retaliacao_tele/critico/arcano, bom · retaliacao_tele/critico/controle, bom · retaliacao_tele/critico/lumen, bom · retaliacao_tele/marca/arcano, bom · retaliacao_tele/marca/controle, bom · retaliacao_tele/marca/lumen, nu · guardiao/critico/lumen, nu · guardiao/marca/lumen, nu · retaliacao/critico/lumen, nu · retaliacao/marca/lumen, nu · retaliacao_tele/critico/lumen, nu · retaliacao_tele/marca/controle, nu · retaliacao_tele/marca/lumen, tipico · guardiao/critico/lumen, tipico · guardiao/marca/lumen, tipico · retaliacao/critico/lumen, tipico · retaliacao/marca/lumen, tipico · retaliacao_tele/critico/controle, tipico · retaliacao_tele/critico/lumen, tipico · retaliacao_tele/marca/controle, tipico · retaliacao_tele/marca/lumen _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura; vitória esperada por volta do nível 10–11)_
- **[INFO/INFO] Referência de primeira tentativa no nível 10** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_

## Rota completa (vitória por combinação e nível)

| Build (hero_001/hero_002/hero_003) | Nível | Vitória | Δ anterior | Perde mais em | HP antes do chefe | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| bom · guardiao/critico/arcano | 8 | 0% |  | c1_5_2_a | 86% | 0 |
| bom · guardiao/critico/arcano | 10 | 17% |  | c1_5_2_a | 90% | 0 |
| bom · guardiao/critico/arcano | 12 | 17% |  | c1_5_2_a | 89% | 0 |
| bom · guardiao/critico/controle | 8 | 17% |  | c1_5_2_a | 84% | 0 |
| bom · guardiao/critico/controle | 10 | 100% |  |  | 93% | 0 |
| bom · guardiao/critico/controle | 12 | 100% |  |  | 90% | 0 |
| bom · guardiao/critico/lumen | 8 | 100% |  |  | 94% | 2068 |
| bom · guardiao/critico/lumen | 10 | 100% |  |  | 91% | 1975 |
| bom · guardiao/critico/lumen | 12 | 100% |  |  | 95% | 2013 |
| bom · guardiao/marca/arcano | 8 | 0% |  | c1_5_2_a | 76% | 0 |
| bom · guardiao/marca/arcano | 10 | 50% |  | c1_5_2_a | 88% | 0 |
| bom · guardiao/marca/arcano | 12 | 100% |  |  | 90% | 0 |
| bom · guardiao/marca/controle | 8 | 50% |  | c1_5_2_a | 85% | 0 |
| bom · guardiao/marca/controle | 10 | 100% |  |  | 89% | 0 |
| bom · guardiao/marca/controle | 12 | 100% |  |  | 92% | 0 |
| bom · guardiao/marca/lumen | 8 | 100% |  |  | 92% | 1918 |
| bom · guardiao/marca/lumen | 10 | 100% |  |  | 90% | 1885 |
| bom · guardiao/marca/lumen | 12 | 100% |  |  | 93% | 1819 |
| bom · retaliacao/critico/arcano | 8 | 0% |  | c1_5_2_a | 79% | 0 |
| bom · retaliacao/critico/arcano | 10 | 33% |  | c1_5_2_a | 87% | 0 |
| bom · retaliacao/critico/arcano | 12 | 83% |  | c1_5_2_a | 95% | 0 |
| bom · retaliacao/critico/controle | 8 | 17% |  | c1_5_2_a | 87% | 0 |
| bom · retaliacao/critico/controle | 10 | 67% |  | c1_5_2_a | 87% | 0 |
| bom · retaliacao/critico/controle | 12 | 100% |  |  | 87% | 0 |
| bom · retaliacao/critico/lumen | 8 | 83% |  | c1_5_2_a | 92% | 1918 |
| bom · retaliacao/critico/lumen | 10 | 100% |  |  | 93% | 1806 |
| bom · retaliacao/critico/lumen | 12 | 100% |  |  | 93% | 1902 |
| bom · retaliacao/marca/arcano | 8 | 0% |  | c1_5_2_a | 90% | 0 |
| bom · retaliacao/marca/arcano | 10 | 83% |  | c1_5_2_a | 91% | 0 |
| bom · retaliacao/marca/arcano | 12 | 100% |  |  | 94% | 0 |
| bom · retaliacao/marca/controle | 8 | 17% |  | c1_5_2_a | 85% | 0 |
| bom · retaliacao/marca/controle | 10 | 100% |  |  | 87% | 0 |
| bom · retaliacao/marca/controle | 12 | 100% |  |  | 90% | 0 |
| bom · retaliacao/marca/lumen | 8 | 100% |  |  | 88% | 1808 |
| bom · retaliacao/marca/lumen | 10 | 100% |  |  | 90% | 1693 |
| bom · retaliacao/marca/lumen | 12 | 100% |  |  | 93% | 1665 |
| bom · retaliacao_tele/critico/arcano | 8 | 0% |  | c1_5_2_a | 88% | 0 |
| bom · retaliacao_tele/critico/arcano | 10 | 100% |  |  | 91% | 0 |
| bom · retaliacao_tele/critico/arcano | 12 | 100% |  |  | 96% | 0 |
| bom · retaliacao_tele/critico/controle | 8 | 17% |  | c1_5_2_a | 87% | 0 |
| bom · retaliacao_tele/critico/controle | 10 | 100% |  |  | 89% | 0 |
| bom · retaliacao_tele/critico/controle | 12 | 100% |  |  | 92% | 0 |
| bom · retaliacao_tele/critico/lumen | 8 | 100% |  |  | 90% | 1906 |
| bom · retaliacao_tele/critico/lumen | 10 | 100% |  |  | 92% | 1806 |
| bom · retaliacao_tele/critico/lumen | 12 | 100% |  |  | 94% | 1783 |
| bom · retaliacao_tele/marca/arcano | 8 | 0% |  | c1_5_2_a | 79% | 0 |
| bom · retaliacao_tele/marca/arcano | 10 | 67% |  | c1_5_2_a | 91% | 0 |
| bom · retaliacao_tele/marca/arcano | 12 | 100% |  |  | 94% | 0 |
| bom · retaliacao_tele/marca/controle | 8 | 83% |  | c1_5_2_a | 86% | 0 |
| bom · retaliacao_tele/marca/controle | 10 | 100% |  |  | 92% | 0 |
| bom · retaliacao_tele/marca/controle | 12 | 100% |  |  | 90% | 0 |
| bom · retaliacao_tele/marca/lumen | 8 | 100% |  |  | 88% | 1811 |
| bom · retaliacao_tele/marca/lumen | 10 | 100% |  |  | 93% | 1603 |
| bom · retaliacao_tele/marca/lumen | 12 | 100% |  |  | 96% | 1581 |
| nu · guardiao/critico/arcano | 8 | 0% |  | c1_5_2_a | 62% | 0 |
| nu · guardiao/critico/arcano | 10 | 0% |  | c1_5_2_a | 74% | 0 |
| nu · guardiao/critico/arcano | 12 | 0% |  | c1_5_2_a | 78% | 0 |
| nu · guardiao/critico/controle | 8 | 0% |  | c1_5_2_a | 70% | 0 |
| nu · guardiao/critico/controle | 10 | 0% |  | c1_5_2_a | 74% | 0 |
| nu · guardiao/critico/controle | 12 | 17% |  | c1_5_2_a | 76% | 0 |
| nu · guardiao/critico/lumen | 8 | 0% |  | c1_5_2_a | 78% | 1979 |
| nu · guardiao/critico/lumen | 10 | 100% |  |  | 79% | 2059 |
| nu · guardiao/critico/lumen | 12 | 100% |  |  | 81% | 1988 |
| nu · guardiao/marca/arcano | 8 | 0% |  | c1_5_2_a | 65% | 0 |
| nu · guardiao/marca/arcano | 10 | 0% |  | c1_5_2_a | 73% | 0 |
| nu · guardiao/marca/arcano | 12 | 50% |  | c1_5_2_a | 77% | 0 |
| nu · guardiao/marca/controle | 8 | 0% |  | c1_5_2_a | 71% | 0 |
| nu · guardiao/marca/controle | 10 | 0% |  | c1_5_2_a | 69% | 0 |
| nu · guardiao/marca/controle | 12 | 100% |  |  | 79% | 0 |
| nu · guardiao/marca/lumen | 8 | 50% |  | c1_5_2_a | 78% | 1868 |
| nu · guardiao/marca/lumen | 10 | 100% |  |  | 76% | 1826 |
| nu · guardiao/marca/lumen | 12 | 100% |  |  | 81% | 1750 |
| nu · retaliacao/critico/arcano | 8 | 0% |  | c1_5_2_a | 56% | 0 |
| nu · retaliacao/critico/arcano | 10 | 0% |  | c1_5_2_a | 69% | 0 |
| nu · retaliacao/critico/arcano | 12 | 0% |  | c1_5_2_a | 75% | 0 |
| nu · retaliacao/critico/controle | 8 | 0% |  | c1_5_2_a | 67% | 0 |
| nu · retaliacao/critico/controle | 10 | 0% |  | c1_5_2_a | 71% | 0 |
| nu · retaliacao/critico/controle | 12 | 0% |  | c1_5_2_a | 72% | 0 |
| nu · retaliacao/critico/lumen | 8 | 0% |  | c1_5_2_a | 76% | 1694 |
| nu · retaliacao/critico/lumen | 10 | 100% |  |  | 79% | 1925 |
| nu · retaliacao/critico/lumen | 12 | 100% |  |  | 79% | 1830 |
| nu · retaliacao/marca/arcano | 8 | 0% |  | c1_5_2_a | 66% | 0 |
| nu · retaliacao/marca/arcano | 10 | 0% |  | c1_5_2_a | 68% | 0 |
| nu · retaliacao/marca/arcano | 12 | 0% |  | c1_5_2_a | 76% | 0 |
| nu · retaliacao/marca/controle | 8 | 0% |  | c1_5_2_a | 69% | 0 |
| nu · retaliacao/marca/controle | 10 | 0% |  | c1_5_2_a | 74% | 0 |
| nu · retaliacao/marca/controle | 12 | 50% |  | c1_5_2_a | 77% | 0 |
| nu · retaliacao/marca/lumen | 8 | 17% |  | c1_5_2_a | 74% | 1562 |
| nu · retaliacao/marca/lumen | 10 | 100% |  |  | 77% | 1721 |
| nu · retaliacao/marca/lumen | 12 | 100% |  |  | 80% | 1613 |
| nu · retaliacao_tele/critico/arcano | 8 | 0% |  | c1_5_2_a | 60% | 0 |
| nu · retaliacao_tele/critico/arcano | 10 | 0% |  | c1_5_2_a | 72% | 0 |
| nu · retaliacao_tele/critico/arcano | 12 | 67% |  | c1_5_2_a | 75% | 0 |
| nu · retaliacao_tele/critico/controle | 8 | 0% |  | c1_5_2_a | 71% | 0 |
| nu · retaliacao_tele/critico/controle | 10 | 0% |  | c1_5_2_a | 73% | 0 |
| nu · retaliacao_tele/critico/controle | 12 | 100% |  |  | 77% | 0 |
| nu · retaliacao_tele/critico/lumen | 8 | 100% |  |  | 76% | 1837 |
| nu · retaliacao_tele/critico/lumen | 10 | 100% |  |  | 76% | 1842 |
| nu · retaliacao_tele/critico/lumen | 12 | 100% |  |  | 82% | 1830 |
| nu · retaliacao_tele/marca/arcano | 8 | 0% |  | c1_5_2_a | 66% | 0 |
| nu · retaliacao_tele/marca/arcano | 10 | 0% |  | c1_5_2_a | 70% | 0 |
| nu · retaliacao_tele/marca/arcano | 12 | 67% |  | c1_5_2_a | 77% | 0 |
| nu · retaliacao_tele/marca/controle | 8 | 0% |  | c1_5_2_a | 72% | 0 |
| nu · retaliacao_tele/marca/controle | 10 | 67% |  | c1_5_2_a | 77% | 0 |
| nu · retaliacao_tele/marca/controle | 12 | 100% |  |  | 77% | 0 |
| nu · retaliacao_tele/marca/lumen | 8 | 100% |  |  | 75% | 1684 |
| nu · retaliacao_tele/marca/lumen | 10 | 100% |  |  | 81% | 1656 |
| nu · retaliacao_tele/marca/lumen | 12 | 100% |  |  | 80% | 1622 |
| tipico · guardiao/critico/arcano | 8 | 0% |  | c1_5_2_a | 73% | 0 |
| tipico · guardiao/critico/arcano | 10 | 0% |  | c1_5_2_a | 80% | 0 |
| tipico · guardiao/critico/arcano | 12 | 0% |  | c1_5_2_a | 84% | 0 |
| tipico · guardiao/critico/controle | 8 | 0% |  | c1_5_2_a | 77% | 0 |
| tipico · guardiao/critico/controle | 10 | 17% |  | c1_5_2_a | 81% | 0 |
| tipico · guardiao/critico/controle | 12 | 67% |  | c1_5_2_a | 80% | 0 |
| tipico · guardiao/critico/lumen | 8 | 83% |  | c1_5_2_a | 87% | 1994 |
| tipico · guardiao/critico/lumen | 10 | 100% |  |  | 84% | 2002 |
| tipico · guardiao/critico/lumen | 12 | 100% |  |  | 86% | 1876 |
| tipico · guardiao/marca/arcano | 8 | 0% |  | c1_5_2_a | 71% | 0 |
| tipico · guardiao/marca/arcano | 10 | 17% |  | c1_5_2_a | 80% | 0 |
| tipico · guardiao/marca/arcano | 12 | 33% |  | c1_5_2_a | 82% | 0 |
| tipico · guardiao/marca/controle | 8 | 0% |  | c1_5_2_a | 79% | 0 |
| tipico · guardiao/marca/controle | 10 | 0% |  | c1_5_2_a | 75% | 0 |
| tipico · guardiao/marca/controle | 12 | 100% |  |  | 82% | 0 |
| tipico · guardiao/marca/lumen | 8 | 83% |  | c1_5_2_a | 82% | 1784 |
| tipico · guardiao/marca/lumen | 10 | 100% |  |  | 81% | 1840 |
| tipico · guardiao/marca/lumen | 12 | 100% |  |  | 86% | 1788 |
| tipico · retaliacao/critico/arcano | 8 | 0% |  | c1_5_2_a | 67% | 0 |
| tipico · retaliacao/critico/arcano | 10 | 17% |  | c1_5_2_a | 77% | 0 |
| tipico · retaliacao/critico/arcano | 12 | 33% |  | c1_5_2_a | 84% | 0 |
| tipico · retaliacao/critico/controle | 8 | 0% |  | c1_5_2_a | 76% | 0 |
| tipico · retaliacao/critico/controle | 10 | 0% |  | c1_5_2_a | 78% | 0 |
| tipico · retaliacao/critico/controle | 12 | 67% |  | c1_5_2_a | 83% | 0 |
| tipico · retaliacao/critico/lumen | 8 | 67% |  | c1_5_2_a | 83% | 1889 |
| tipico · retaliacao/critico/lumen | 10 | 100% |  |  | 86% | 1891 |
| tipico · retaliacao/critico/lumen | 12 | 100% |  |  | 84% | 1759 |
| tipico · retaliacao/marca/arcano | 8 | 0% |  | c1_5_2_a | 72% | 0 |
| tipico · retaliacao/marca/arcano | 10 | 0% |  | c1_5_2_a | 78% | 0 |
| tipico · retaliacao/marca/arcano | 12 | 33% |  | c1_5_2_a | 81% | 0 |
| tipico · retaliacao/marca/controle | 8 | 0% |  | c1_5_2_a | 77% | 0 |
| tipico · retaliacao/marca/controle | 10 | 33% |  | c1_5_2_a | 81% | 0 |
| tipico · retaliacao/marca/controle | 12 | 100% |  |  | 80% | 0 |
| tipico · retaliacao/marca/lumen | 8 | 67% |  | c1_5_2_a | 78% | 1679 |
| tipico · retaliacao/marca/lumen | 10 | 100% |  |  | 83% | 1672 |
| tipico · retaliacao/marca/lumen | 12 | 100% |  |  | 83% | 1648 |
| tipico · retaliacao_tele/critico/arcano | 8 | 0% |  | c1_5_2_a | 68% | 0 |
| tipico · retaliacao_tele/critico/arcano | 10 | 0% |  | c1_5_2_a | 78% | 0 |
| tipico · retaliacao_tele/critico/arcano | 12 | 100% |  |  | 84% | 0 |
| tipico · retaliacao_tele/critico/controle | 8 | 0% |  | c1_5_2_a | 80% | 0 |
| tipico · retaliacao_tele/critico/controle | 10 | 83% |  | c1_5_2_a | 77% | 0 |
| tipico · retaliacao_tele/critico/controle | 12 | 100% |  |  | 83% | 0 |
| tipico · retaliacao_tele/critico/lumen | 8 | 100% |  |  | 84% | 1784 |
| tipico · retaliacao_tele/critico/lumen | 10 | 100% |  |  | 83% | 1823 |
| tipico · retaliacao_tele/critico/lumen | 12 | 100% |  |  | 88% | 1759 |
| tipico · retaliacao_tele/marca/arcano | 8 | 0% |  | c1_5_2_a | 74% | 0 |
| tipico · retaliacao_tele/marca/arcano | 10 | 33% |  | c1_5_2_a | 77% | 0 |
| tipico · retaliacao_tele/marca/arcano | 12 | 100% |  |  | 85% | 0 |
| tipico · retaliacao_tele/marca/controle | 8 | 0% |  | c1_5_2_a | 76% | 0 |
| tipico · retaliacao_tele/marca/controle | 10 | 100% |  |  | 82% | 0 |
| tipico · retaliacao_tele/marca/controle | 12 | 100% |  |  | 82% | 0 |
| tipico · retaliacao_tele/marca/lumen | 8 | 100% |  |  | 81% | 1784 |
| tipico · retaliacao_tele/marca/lumen | 10 | 100% |  |  | 85% | 1641 |
| tipico · retaliacao_tele/marca/lumen | 12 | 100% |  |  | 85% | 1659 |

## Encontros isolados com HP cheio

| Build | Nível da party | Nível do encontro | Encontro | Vitória | TTK mediano | HP restante |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| bom · guardiao/critico/arcano | 8 | 3 | elite | 100% | 14 s | 90% |
| bom · guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| bom · guardiao/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 87% |
| bom · guardiao/critico/arcano | 10 | 3 | elite | 100% | 10 s | 99% |
| bom · guardiao/critico/arcano | 10 | 10 | guardiao | 17% | 138 s | 22% |
| bom · guardiao/critico/arcano | 10 | 5 | rainha | 100% | 34 s | 92% |
| bom · guardiao/critico/arcano | 12 | 3 | elite | 100% | 10 s | 99% |
| bom · guardiao/critico/arcano | 12 | 10 | guardiao | 100% | 136 s | 25% |
| bom · guardiao/critico/arcano | 12 | 5 | rainha | 100% | 32 s | 93% |
| bom · guardiao/critico/controle | 8 | 3 | elite | 100% | 16 s | 92% |
| bom · guardiao/critico/controle | 8 | 10 | guardiao | 33% | 183 s | 18% |
| bom · guardiao/critico/controle | 8 | 5 | rainha | 100% | 44 s | 93% |
| bom · guardiao/critico/controle | 10 | 3 | elite | 100% | 12 s | 102% |
| bom · guardiao/critico/controle | 10 | 10 | guardiao | 100% | 149 s | 32% |
| bom · guardiao/critico/controle | 10 | 5 | rainha | 100% | 39 s | 94% |
| bom · guardiao/critico/controle | 12 | 3 | elite | 100% | 11 s | 102% |
| bom · guardiao/critico/controle | 12 | 10 | guardiao | 100% | 142 s | 38% |
| bom · guardiao/critico/controle | 12 | 5 | rainha | 100% | 37 s | 94% |
| bom · guardiao/critico/lumen | 8 | 3 | elite | 100% | 16 s | 93% |
| bom · guardiao/critico/lumen | 8 | 10 | guardiao | 100% | 172 s | 31% |
| bom · guardiao/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 97% |
| bom · guardiao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 102% |
| bom · guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 154 s | 55% |
| bom · guardiao/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 95% |
| bom · guardiao/critico/lumen | 12 | 3 | elite | 100% | 11 s | 102% |
| bom · guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 147 s | 61% |
| bom · guardiao/critico/lumen | 12 | 5 | rainha | 100% | 38 s | 97% |
| bom · guardiao/marca/arcano | 8 | 3 | elite | 100% | 13 s | 95% |
| bom · guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| bom · guardiao/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 88% |
| bom · guardiao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 99% |
| bom · guardiao/marca/arcano | 10 | 10 | guardiao | 100% | 133 s | 20% |
| bom · guardiao/marca/arcano | 10 | 5 | rainha | 100% | 31 s | 91% |
| bom · guardiao/marca/arcano | 12 | 3 | elite | 100% | 8 s | 100% |
| bom · guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 114 s | 39% |
| bom · guardiao/marca/arcano | 12 | 5 | rainha | 100% | 29 s | 92% |
| bom · guardiao/marca/controle | 8 | 3 | elite | 100% | 14 s | 91% |
| bom · guardiao/marca/controle | 8 | 10 | guardiao | 100% | 149 s | 44% |
| bom · guardiao/marca/controle | 8 | 5 | rainha | 100% | 39 s | 95% |
| bom · guardiao/marca/controle | 10 | 3 | elite | 100% | 11 s | 102% |
| bom · guardiao/marca/controle | 10 | 10 | guardiao | 100% | 135 s | 43% |
| bom · guardiao/marca/controle | 10 | 5 | rainha | 100% | 35 s | 94% |
| bom · guardiao/marca/controle | 12 | 3 | elite | 100% | 10 s | 101% |
| bom · guardiao/marca/controle | 12 | 10 | guardiao | 100% | 127 s | 54% |
| bom · guardiao/marca/controle | 12 | 5 | rainha | 100% | 33 s | 95% |
| bom · guardiao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 93% |
| bom · guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 154 s | 33% |
| bom · guardiao/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 96% |
| bom · guardiao/marca/lumen | 10 | 3 | elite | 100% | 11 s | 103% |
| bom · guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 139 s | 61% |
| bom · guardiao/marca/lumen | 10 | 5 | rainha | 100% | 36 s | 96% |
| bom · guardiao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 102% |
| bom · guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 131 s | 63% |
| bom · guardiao/marca/lumen | 12 | 5 | rainha | 100% | 34 s | 94% |
| bom · retaliacao/critico/arcano | 8 | 3 | elite | 100% | 13 s | 92% |
| bom · retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| bom · retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 37 s | 90% |
| bom · retaliacao/critico/arcano | 10 | 3 | elite | 100% | 9 s | 102% |
| bom · retaliacao/critico/arcano | 10 | 10 | guardiao | 67% | 133 s | 26% |
| bom · retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 32 s | 92% |
| bom · retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 102% |
| bom · retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 123 s | 36% |
| bom · retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 30 s | 92% |
| bom · retaliacao/critico/controle | 8 | 3 | elite | 100% | 14 s | 94% |
| bom · retaliacao/critico/controle | 8 | 10 | guardiao | 100% | 156 s | 36% |
| bom · retaliacao/critico/controle | 8 | 5 | rainha | 100% | 41 s | 92% |
| bom · retaliacao/critico/controle | 10 | 3 | elite | 100% | 11 s | 98% |
| bom · retaliacao/critico/controle | 10 | 10 | guardiao | 100% | 140 s | 53% |
| bom · retaliacao/critico/controle | 10 | 5 | rainha | 100% | 35 s | 93% |
| bom · retaliacao/critico/controle | 12 | 3 | elite | 100% | 11 s | 100% |
| bom · retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 135 s | 53% |
| bom · retaliacao/critico/controle | 12 | 5 | rainha | 100% | 34 s | 95% |
| bom · retaliacao/critico/lumen | 8 | 3 | elite | 100% | 15 s | 88% |
| bom · retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 161 s | 49% |
| bom · retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 41 s | 93% |
| bom · retaliacao/critico/lumen | 10 | 3 | elite | 100% | 11 s | 102% |
| bom · retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 146 s | 61% |
| bom · retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 38 s | 97% |
| bom · retaliacao/critico/lumen | 12 | 3 | elite | 100% | 10 s | 104% |
| bom · retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 139 s | 64% |
| bom · retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 35 s | 99% |
| bom · retaliacao/marca/arcano | 8 | 3 | elite | 100% | 12 s | 95% |
| bom · retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| bom · retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 33 s | 93% |
| bom · retaliacao/marca/arcano | 10 | 3 | elite | 100% | 8 s | 102% |
| bom · retaliacao/marca/arcano | 10 | 10 | guardiao | 100% | 127 s | 32% |
| bom · retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 29 s | 92% |
| bom · retaliacao/marca/arcano | 12 | 3 | elite | 100% | 8 s | 102% |
| bom · retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 108 s | 41% |
| bom · retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 28 s | 91% |
| bom · retaliacao/marca/controle | 8 | 3 | elite | 100% | 13 s | 94% |
| bom · retaliacao/marca/controle | 8 | 10 | guardiao | 100% | 159 s | 18% |
| bom · retaliacao/marca/controle | 8 | 5 | rainha | 100% | 39 s | 91% |
| bom · retaliacao/marca/controle | 10 | 3 | elite | 100% | 10 s | 97% |
| bom · retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 128 s | 48% |
| bom · retaliacao/marca/controle | 10 | 5 | rainha | 100% | 31 s | 93% |
| bom · retaliacao/marca/controle | 12 | 3 | elite | 100% | 9 s | 100% |
| bom · retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 123 s | 60% |
| bom · retaliacao/marca/controle | 12 | 5 | rainha | 100% | 30 s | 95% |
| bom · retaliacao/marca/lumen | 8 | 3 | elite | 100% | 14 s | 89% |
| bom · retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 146 s | 50% |
| bom · retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 38 s | 91% |
| bom · retaliacao/marca/lumen | 10 | 3 | elite | 100% | 10 s | 101% |
| bom · retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 132 s | 59% |
| bom · retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 33 s | 97% |
| bom · retaliacao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 101% |
| bom · retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 125 s | 72% |
| bom · retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 31 s | 98% |
| bom · retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 12 s | 94% |
| bom · retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| bom · retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 36 s | 93% |
| bom · retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 10 s | 99% |
| bom · retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 129 s | 31% |
| bom · retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 32 s | 95% |
| bom · retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 10 s | 99% |
| bom · retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 122 s | 43% |
| bom · retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 30 s | 94% |
| bom · retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 14 s | 91% |
| bom · retaliacao_tele/critico/controle | 8 | 10 | guardiao | 100% | 163 s | 25% |
| bom · retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 40 s | 92% |
| bom · retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 11 s | 96% |
| bom · retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 139 s | 49% |
| bom · retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 38 s | 94% |
| bom · retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 10 s | 96% |
| bom · retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 134 s | 56% |
| bom · retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 35 s | 96% |
| bom · retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 15 s | 90% |
| bom · retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 160 s | 51% |
| bom · retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 41 s | 92% |
| bom · retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 11 s | 101% |
| bom · retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 145 s | 66% |
| bom · retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 37 s | 95% |
| bom · retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 11 s | 101% |
| bom · retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 138 s | 69% |
| bom · retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 34 s | 98% |
| bom · retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 12 s | 92% |
| bom · retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 17% | 156 s | 11% |
| bom · retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 33 s | 93% |
| bom · retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 8 s | 99% |
| bom · retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 115 s | 46% |
| bom · retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 29 s | 94% |
| bom · retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 8 s | 100% |
| bom · retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 107 s | 48% |
| bom · retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 28 s | 95% |
| bom · retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 14 s | 92% |
| bom · retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 143 s | 44% |
| bom · retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 38 s | 95% |
| bom · retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 10 s | 97% |
| bom · retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 130 s | 57% |
| bom · retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 34 s | 94% |
| bom · retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 9 s | 97% |
| bom · retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 123 s | 61% |
| bom · retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 31 s | 97% |
| bom · retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 14 s | 91% |
| bom · retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 146 s | 58% |
| bom · retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 38 s | 94% |
| bom · retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 10 s | 100% |
| bom · retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 131 s | 71% |
| bom · retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 32 s | 96% |
| bom · retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 10 s | 104% |
| bom · retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 124 s | 67% |
| bom · retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 31 s | 98% |
| nu · guardiao/critico/arcano | 8 | 3 | elite | 100% | 16 s | 74% |
| nu · guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| nu · guardiao/critico/arcano | 8 | 5 | rainha | 100% | 42 s | 74% |
| nu · guardiao/critico/arcano | 10 | 3 | elite | 100% | 11 s | 86% |
| nu · guardiao/critico/arcano | 10 | 10 | guardiao | 0% | — | — |
| nu · guardiao/critico/arcano | 10 | 5 | rainha | 100% | 37 s | 77% |
| nu · guardiao/critico/arcano | 12 | 3 | elite | 100% | 10 s | 88% |
| nu · guardiao/critico/arcano | 12 | 10 | guardiao | 33% | 146 s | 3% |
| nu · guardiao/critico/arcano | 12 | 5 | rainha | 100% | 36 s | 79% |
| nu · guardiao/critico/controle | 8 | 3 | elite | 100% | 18 s | 77% |
| nu · guardiao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| nu · guardiao/critico/controle | 8 | 5 | rainha | 100% | 48 s | 76% |
| nu · guardiao/critico/controle | 10 | 3 | elite | 100% | 13 s | 87% |
| nu · guardiao/critico/controle | 10 | 10 | guardiao | 0% | — | — |
| nu · guardiao/critico/controle | 10 | 5 | rainha | 100% | 43 s | 81% |
| nu · guardiao/critico/controle | 12 | 3 | elite | 100% | 12 s | 90% |
| nu · guardiao/critico/controle | 12 | 10 | guardiao | 83% | 167 s | 5% |
| nu · guardiao/critico/controle | 12 | 5 | rainha | 100% | 40 s | 80% |
| nu · guardiao/critico/lumen | 8 | 3 | elite | 100% | 17 s | 78% |
| nu · guardiao/critico/lumen | 8 | 10 | guardiao | 0% | — | — |
| nu · guardiao/critico/lumen | 8 | 5 | rainha | 100% | 48 s | 82% |
| nu · guardiao/critico/lumen | 10 | 3 | elite | 100% | 13 s | 89% |
| nu · guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 166 s | 32% |
| nu · guardiao/critico/lumen | 10 | 5 | rainha | 100% | 43 s | 81% |
| nu · guardiao/critico/lumen | 12 | 3 | elite | 100% | 12 s | 91% |
| nu · guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 157 s | 38% |
| nu · guardiao/critico/lumen | 12 | 5 | rainha | 100% | 41 s | 86% |
| nu · guardiao/marca/arcano | 8 | 3 | elite | 100% | 14 s | 80% |
| nu · guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| nu · guardiao/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 70% |
| nu · guardiao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 88% |
| nu · guardiao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| nu · guardiao/marca/arcano | 10 | 5 | rainha | 100% | 34 s | 78% |
| nu · guardiao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| nu · guardiao/marca/arcano | 12 | 10 | guardiao | 50% | 149 s | 1% |
| nu · guardiao/marca/arcano | 12 | 5 | rainha | 100% | 32 s | 78% |
| nu · guardiao/marca/controle | 8 | 3 | elite | 100% | 16 s | 76% |
| nu · guardiao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| nu · guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 78% |
| nu · guardiao/marca/controle | 10 | 3 | elite | 100% | 12 s | 90% |
| nu · guardiao/marca/controle | 10 | 10 | guardiao | 50% | 152 s | 18% |
| nu · guardiao/marca/controle | 10 | 5 | rainha | 100% | 38 s | 79% |
| nu · guardiao/marca/controle | 12 | 3 | elite | 100% | 11 s | 91% |
| nu · guardiao/marca/controle | 12 | 10 | guardiao | 100% | 139 s | 31% |
| nu · guardiao/marca/controle | 12 | 5 | rainha | 100% | 36 s | 81% |
| nu · guardiao/marca/lumen | 8 | 3 | elite | 100% | 16 s | 81% |
| nu · guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 167 s | 26% |
| nu · guardiao/marca/lumen | 8 | 5 | rainha | 100% | 42 s | 82% |
| nu · guardiao/marca/lumen | 10 | 3 | elite | 100% | 12 s | 91% |
| nu · guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 148 s | 40% |
| nu · guardiao/marca/lumen | 10 | 5 | rainha | 100% | 39 s | 82% |
| nu · guardiao/marca/lumen | 12 | 3 | elite | 100% | 11 s | 91% |
| nu · guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 140 s | 45% |
| nu · guardiao/marca/lumen | 12 | 5 | rainha | 100% | 36 s | 82% |
| nu · retaliacao/critico/arcano | 8 | 3 | elite | 100% | 14 s | 76% |
| nu · retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 75% |
| nu · retaliacao/critico/arcano | 10 | 3 | elite | 100% | 9 s | 89% |
| nu · retaliacao/critico/arcano | 10 | 10 | guardiao | 17% | 142 s | 6% |
| nu · retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 36 s | 78% |
| nu · retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 91% |
| nu · retaliacao/critico/arcano | 12 | 10 | guardiao | 67% | 138 s | 14% |
| nu · retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 33 s | 83% |
| nu · retaliacao/critico/controle | 8 | 3 | elite | 100% | 15 s | 79% |
| nu · retaliacao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao/critico/controle | 8 | 5 | rainha | 100% | 44 s | 79% |
| nu · retaliacao/critico/controle | 10 | 3 | elite | 100% | 12 s | 82% |
| nu · retaliacao/critico/controle | 10 | 10 | guardiao | 33% | 161 s | 21% |
| nu · retaliacao/critico/controle | 10 | 5 | rainha | 100% | 40 s | 78% |
| nu · retaliacao/critico/controle | 12 | 3 | elite | 100% | 11 s | 87% |
| nu · retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 144 s | 31% |
| nu · retaliacao/critico/controle | 12 | 5 | rainha | 100% | 36 s | 83% |
| nu · retaliacao/critico/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| nu · retaliacao/critico/lumen | 8 | 10 | guardiao | 67% | 175 s | 35% |
| nu · retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 45 s | 79% |
| nu · retaliacao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 85% |
| nu · retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 158 s | 32% |
| nu · retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 41 s | 83% |
| nu · retaliacao/critico/lumen | 12 | 3 | elite | 100% | 11 s | 91% |
| nu · retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 149 s | 48% |
| nu · retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 39 s | 84% |
| nu · retaliacao/marca/arcano | 8 | 3 | elite | 100% | 13 s | 79% |
| nu · retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 76% |
| nu · retaliacao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 88% |
| nu · retaliacao/marca/arcano | 10 | 10 | guardiao | 0% | — | — |
| nu · retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 31 s | 78% |
| nu · retaliacao/marca/arcano | 12 | 3 | elite | 100% | 9 s | 89% |
| nu · retaliacao/marca/arcano | 12 | 10 | guardiao | 33% | 133 s | 13% |
| nu · retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 29 s | 81% |
| nu · retaliacao/marca/controle | 8 | 3 | elite | 100% | 14 s | 80% |
| nu · retaliacao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao/marca/controle | 8 | 5 | rainha | 100% | 40 s | 79% |
| nu · retaliacao/marca/controle | 10 | 3 | elite | 100% | 10 s | 84% |
| nu · retaliacao/marca/controle | 10 | 10 | guardiao | 100% | 142 s | 23% |
| nu · retaliacao/marca/controle | 10 | 5 | rainha | 100% | 35 s | 80% |
| nu · retaliacao/marca/controle | 12 | 3 | elite | 100% | 10 s | 85% |
| nu · retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 131 s | 35% |
| nu · retaliacao/marca/controle | 12 | 5 | rainha | 100% | 33 s | 82% |
| nu · retaliacao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 73% |
| nu · retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 160 s | 34% |
| nu · retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 78% |
| nu · retaliacao/marca/lumen | 10 | 3 | elite | 100% | 11 s | 87% |
| nu · retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 142 s | 43% |
| nu · retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 37 s | 83% |
| nu · retaliacao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 88% |
| nu · retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 132 s | 51% |
| nu · retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 33 s | 87% |
| nu · retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 15 s | 74% |
| nu · retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 76% |
| nu · retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 11 s | 84% |
| nu · retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 83% | 151 s | 7% |
| nu · retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 35 s | 81% |
| nu · retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 10 s | 87% |
| nu · retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 133 s | 24% |
| nu · retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 33 s | 82% |
| nu · retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 16 s | 79% |
| nu · retaliacao_tele/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 42 s | 80% |
| nu · retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 12 s | 85% |
| nu · retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 154 s | 31% |
| nu · retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 40 s | 80% |
| nu · retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 11 s | 85% |
| nu · retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 144 s | 38% |
| nu · retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 38 s | 83% |
| nu · retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| nu · retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 171 s | 38% |
| nu · retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 80% |
| nu · retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 12 s | 84% |
| nu · retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 155 s | 52% |
| nu · retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 82% |
| nu · retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 11 s | 89% |
| nu · retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 147 s | 56% |
| nu · retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 38 s | 86% |
| nu · retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 13 s | 78% |
| nu · retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| nu · retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 37 s | 77% |
| nu · retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 9 s | 85% |
| nu · retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 148 s | 11% |
| nu · retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 32 s | 80% |
| nu · retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 9 s | 88% |
| nu · retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 123 s | 33% |
| nu · retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 30 s | 82% |
| nu · retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 14 s | 79% |
| nu · retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 171 s | 10% |
| nu · retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 39 s | 79% |
| nu · retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 10 s | 84% |
| nu · retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 138 s | 34% |
| nu · retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 36 s | 83% |
| nu · retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 10 s | 85% |
| nu · retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 130 s | 40% |
| nu · retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 34 s | 83% |
| nu · retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 16 s | 73% |
| nu · retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 156 s | 40% |
| nu · retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 40 s | 74% |
| nu · retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 11 s | 84% |
| nu · retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 141 s | 47% |
| nu · retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 36 s | 83% |
| nu · retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 10 s | 88% |
| nu · retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 131 s | 62% |
| nu · retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 34 s | 85% |
| tipico · guardiao/critico/arcano | 8 | 3 | elite | 100% | 15 s | 80% |
| tipico · guardiao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| tipico · guardiao/critico/arcano | 8 | 5 | rainha | 100% | 41 s | 80% |
| tipico · guardiao/critico/arcano | 10 | 3 | elite | 100% | 11 s | 91% |
| tipico · guardiao/critico/arcano | 10 | 10 | guardiao | 0% | — | — |
| tipico · guardiao/critico/arcano | 10 | 5 | rainha | 100% | 36 s | 83% |
| tipico · guardiao/critico/arcano | 12 | 3 | elite | 100% | 10 s | 92% |
| tipico · guardiao/critico/arcano | 12 | 10 | guardiao | 33% | 134 s | 17% |
| tipico · guardiao/critico/arcano | 12 | 5 | rainha | 100% | 34 s | 85% |
| tipico · guardiao/critico/controle | 8 | 3 | elite | 100% | 17 s | 83% |
| tipico · guardiao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| tipico · guardiao/critico/controle | 8 | 5 | rainha | 100% | 46 s | 83% |
| tipico · guardiao/critico/controle | 10 | 3 | elite | 100% | 12 s | 94% |
| tipico · guardiao/critico/controle | 10 | 10 | guardiao | 83% | 168 s | 17% |
| tipico · guardiao/critico/controle | 10 | 5 | rainha | 100% | 41 s | 84% |
| tipico · guardiao/critico/controle | 12 | 3 | elite | 100% | 12 s | 95% |
| tipico · guardiao/critico/controle | 12 | 10 | guardiao | 100% | 155 s | 20% |
| tipico · guardiao/critico/controle | 12 | 5 | rainha | 100% | 39 s | 86% |
| tipico · guardiao/critico/lumen | 8 | 3 | elite | 100% | 17 s | 86% |
| tipico · guardiao/critico/lumen | 8 | 10 | guardiao | 100% | 177 s | 31% |
| tipico · guardiao/critico/lumen | 8 | 5 | rainha | 100% | 47 s | 88% |
| tipico · guardiao/critico/lumen | 10 | 3 | elite | 100% | 13 s | 95% |
| tipico · guardiao/critico/lumen | 10 | 10 | guardiao | 100% | 161 s | 41% |
| tipico · guardiao/critico/lumen | 10 | 5 | rainha | 100% | 42 s | 87% |
| tipico · guardiao/critico/lumen | 12 | 3 | elite | 100% | 12 s | 95% |
| tipico · guardiao/critico/lumen | 12 | 10 | guardiao | 100% | 153 s | 53% |
| tipico · guardiao/critico/lumen | 12 | 5 | rainha | 100% | 40 s | 90% |
| tipico · guardiao/marca/arcano | 8 | 3 | elite | 100% | 14 s | 86% |
| tipico · guardiao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| tipico · guardiao/marca/arcano | 8 | 5 | rainha | 100% | 38 s | 77% |
| tipico · guardiao/marca/arcano | 10 | 3 | elite | 100% | 9 s | 93% |
| tipico · guardiao/marca/arcano | 10 | 10 | guardiao | 17% | 143 s | 2% |
| tipico · guardiao/marca/arcano | 10 | 5 | rainha | 100% | 32 s | 82% |
| tipico · guardiao/marca/arcano | 12 | 3 | elite | 100% | 8 s | 94% |
| tipico · guardiao/marca/arcano | 12 | 10 | guardiao | 100% | 126 s | 21% |
| tipico · guardiao/marca/arcano | 12 | 5 | rainha | 100% | 31 s | 84% |
| tipico · guardiao/marca/controle | 8 | 3 | elite | 100% | 15 s | 83% |
| tipico · guardiao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| tipico · guardiao/marca/controle | 8 | 5 | rainha | 100% | 41 s | 84% |
| tipico · guardiao/marca/controle | 10 | 3 | elite | 100% | 11 s | 95% |
| tipico · guardiao/marca/controle | 10 | 10 | guardiao | 100% | 140 s | 31% |
| tipico · guardiao/marca/controle | 10 | 5 | rainha | 100% | 37 s | 85% |
| tipico · guardiao/marca/controle | 12 | 3 | elite | 100% | 10 s | 95% |
| tipico · guardiao/marca/controle | 12 | 10 | guardiao | 100% | 133 s | 34% |
| tipico · guardiao/marca/controle | 12 | 5 | rainha | 100% | 35 s | 86% |
| tipico · guardiao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 86% |
| tipico · guardiao/marca/lumen | 8 | 10 | guardiao | 100% | 161 s | 32% |
| tipico · guardiao/marca/lumen | 8 | 5 | rainha | 100% | 41 s | 87% |
| tipico · guardiao/marca/lumen | 10 | 3 | elite | 100% | 12 s | 95% |
| tipico · guardiao/marca/lumen | 10 | 10 | guardiao | 100% | 144 s | 53% |
| tipico · guardiao/marca/lumen | 10 | 5 | rainha | 100% | 38 s | 89% |
| tipico · guardiao/marca/lumen | 12 | 3 | elite | 100% | 11 s | 96% |
| tipico · guardiao/marca/lumen | 12 | 10 | guardiao | 100% | 136 s | 57% |
| tipico · guardiao/marca/lumen | 12 | 5 | rainha | 100% | 35 s | 88% |
| tipico · retaliacao/critico/arcano | 8 | 3 | elite | 100% | 14 s | 82% |
| tipico · retaliacao/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| tipico · retaliacao/critico/arcano | 8 | 5 | rainha | 100% | 39 s | 81% |
| tipico · retaliacao/critico/arcano | 10 | 3 | elite | 100% | 9 s | 94% |
| tipico · retaliacao/critico/arcano | 10 | 10 | guardiao | 17% | 136 s | 18% |
| tipico · retaliacao/critico/arcano | 10 | 5 | rainha | 100% | 34 s | 82% |
| tipico · retaliacao/critico/arcano | 12 | 3 | elite | 100% | 9 s | 95% |
| tipico · retaliacao/critico/arcano | 12 | 10 | guardiao | 100% | 130 s | 21% |
| tipico · retaliacao/critico/arcano | 12 | 5 | rainha | 100% | 32 s | 86% |
| tipico · retaliacao/critico/controle | 8 | 3 | elite | 100% | 15 s | 84% |
| tipico · retaliacao/critico/controle | 8 | 10 | guardiao | 0% | — | — |
| tipico · retaliacao/critico/controle | 8 | 5 | rainha | 100% | 41 s | 86% |
| tipico · retaliacao/critico/controle | 10 | 3 | elite | 100% | 11 s | 91% |
| tipico · retaliacao/critico/controle | 10 | 10 | guardiao | 100% | 151 s | 26% |
| tipico · retaliacao/critico/controle | 10 | 5 | rainha | 100% | 37 s | 88% |
| tipico · retaliacao/critico/controle | 12 | 3 | elite | 100% | 11 s | 92% |
| tipico · retaliacao/critico/controle | 12 | 10 | guardiao | 100% | 140 s | 31% |
| tipico · retaliacao/critico/controle | 12 | 5 | rainha | 100% | 35 s | 89% |
| tipico · retaliacao/critico/lumen | 8 | 3 | elite | 100% | 15 s | 79% |
| tipico · retaliacao/critico/lumen | 8 | 10 | guardiao | 100% | 172 s | 26% |
| tipico · retaliacao/critico/lumen | 8 | 5 | rainha | 100% | 44 s | 84% |
| tipico · retaliacao/critico/lumen | 10 | 3 | elite | 100% | 12 s | 90% |
| tipico · retaliacao/critico/lumen | 10 | 10 | guardiao | 100% | 153 s | 46% |
| tipico · retaliacao/critico/lumen | 10 | 5 | rainha | 100% | 40 s | 88% |
| tipico · retaliacao/critico/lumen | 12 | 3 | elite | 100% | 11 s | 96% |
| tipico · retaliacao/critico/lumen | 12 | 10 | guardiao | 100% | 145 s | 54% |
| tipico · retaliacao/critico/lumen | 12 | 5 | rainha | 100% | 38 s | 88% |
| tipico · retaliacao/marca/arcano | 8 | 3 | elite | 100% | 12 s | 86% |
| tipico · retaliacao/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| tipico · retaliacao/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 84% |
| tipico · retaliacao/marca/arcano | 10 | 3 | elite | 100% | 8 s | 93% |
| tipico · retaliacao/marca/arcano | 10 | 10 | guardiao | 83% | 131 s | 20% |
| tipico · retaliacao/marca/arcano | 10 | 5 | rainha | 100% | 30 s | 83% |
| tipico · retaliacao/marca/arcano | 12 | 3 | elite | 100% | 8 s | 94% |
| tipico · retaliacao/marca/arcano | 12 | 10 | guardiao | 100% | 115 s | 33% |
| tipico · retaliacao/marca/arcano | 12 | 5 | rainha | 100% | 28 s | 86% |
| tipico · retaliacao/marca/controle | 8 | 3 | elite | 100% | 14 s | 85% |
| tipico · retaliacao/marca/controle | 8 | 10 | guardiao | 0% | — | — |
| tipico · retaliacao/marca/controle | 8 | 5 | rainha | 100% | 38 s | 85% |
| tipico · retaliacao/marca/controle | 10 | 3 | elite | 100% | 10 s | 89% |
| tipico · retaliacao/marca/controle | 10 | 10 | guardiao | 83% | 136 s | 37% |
| tipico · retaliacao/marca/controle | 10 | 5 | rainha | 100% | 34 s | 88% |
| tipico · retaliacao/marca/controle | 12 | 3 | elite | 100% | 9 s | 90% |
| tipico · retaliacao/marca/controle | 12 | 10 | guardiao | 100% | 127 s | 39% |
| tipico · retaliacao/marca/controle | 12 | 5 | rainha | 100% | 32 s | 86% |
| tipico · retaliacao/marca/lumen | 8 | 3 | elite | 100% | 15 s | 80% |
| tipico · retaliacao/marca/lumen | 8 | 10 | guardiao | 100% | 152 s | 34% |
| tipico · retaliacao/marca/lumen | 8 | 5 | rainha | 100% | 39 s | 84% |
| tipico · retaliacao/marca/lumen | 10 | 3 | elite | 100% | 10 s | 93% |
| tipico · retaliacao/marca/lumen | 10 | 10 | guardiao | 100% | 137 s | 53% |
| tipico · retaliacao/marca/lumen | 10 | 5 | rainha | 100% | 34 s | 90% |
| tipico · retaliacao/marca/lumen | 12 | 3 | elite | 100% | 10 s | 93% |
| tipico · retaliacao/marca/lumen | 12 | 10 | guardiao | 100% | 131 s | 54% |
| tipico · retaliacao/marca/lumen | 12 | 5 | rainha | 100% | 31 s | 91% |
| tipico · retaliacao_tele/critico/arcano | 8 | 3 | elite | 100% | 14 s | 80% |
| tipico · retaliacao_tele/critico/arcano | 8 | 10 | guardiao | 0% | — | — |
| tipico · retaliacao_tele/critico/arcano | 8 | 5 | rainha | 100% | 38 s | 82% |
| tipico · retaliacao_tele/critico/arcano | 10 | 3 | elite | 100% | 11 s | 89% |
| tipico · retaliacao_tele/critico/arcano | 10 | 10 | guardiao | 100% | 138 s | 24% |
| tipico · retaliacao_tele/critico/arcano | 10 | 5 | rainha | 100% | 34 s | 86% |
| tipico · retaliacao_tele/critico/arcano | 12 | 3 | elite | 100% | 10 s | 92% |
| tipico · retaliacao_tele/critico/arcano | 12 | 10 | guardiao | 100% | 129 s | 29% |
| tipico · retaliacao_tele/critico/arcano | 12 | 5 | rainha | 100% | 31 s | 87% |
| tipico · retaliacao_tele/critico/controle | 8 | 3 | elite | 100% | 15 s | 84% |
| tipico · retaliacao_tele/critico/controle | 8 | 10 | guardiao | 33% | 172 s | 16% |
| tipico · retaliacao_tele/critico/controle | 8 | 5 | rainha | 100% | 41 s | 86% |
| tipico · retaliacao_tele/critico/controle | 10 | 3 | elite | 100% | 11 s | 89% |
| tipico · retaliacao_tele/critico/controle | 10 | 10 | guardiao | 100% | 150 s | 34% |
| tipico · retaliacao_tele/critico/controle | 10 | 5 | rainha | 100% | 39 s | 87% |
| tipico · retaliacao_tele/critico/controle | 12 | 3 | elite | 100% | 10 s | 89% |
| tipico · retaliacao_tele/critico/controle | 12 | 10 | guardiao | 100% | 140 s | 42% |
| tipico · retaliacao_tele/critico/controle | 12 | 5 | rainha | 100% | 37 s | 88% |
| tipico · retaliacao_tele/critico/lumen | 8 | 3 | elite | 100% | 15 s | 81% |
| tipico · retaliacao_tele/critico/lumen | 8 | 10 | guardiao | 100% | 168 s | 47% |
| tipico · retaliacao_tele/critico/lumen | 8 | 5 | rainha | 100% | 43 s | 87% |
| tipico · retaliacao_tele/critico/lumen | 10 | 3 | elite | 100% | 12 s | 93% |
| tipico · retaliacao_tele/critico/lumen | 10 | 10 | guardiao | 100% | 152 s | 58% |
| tipico · retaliacao_tele/critico/lumen | 10 | 5 | rainha | 100% | 39 s | 88% |
| tipico · retaliacao_tele/critico/lumen | 12 | 3 | elite | 100% | 11 s | 94% |
| tipico · retaliacao_tele/critico/lumen | 12 | 10 | guardiao | 100% | 145 s | 59% |
| tipico · retaliacao_tele/critico/lumen | 12 | 5 | rainha | 100% | 36 s | 90% |
| tipico · retaliacao_tele/marca/arcano | 8 | 3 | elite | 100% | 13 s | 84% |
| tipico · retaliacao_tele/marca/arcano | 8 | 10 | guardiao | 0% | — | — |
| tipico · retaliacao_tele/marca/arcano | 8 | 5 | rainha | 100% | 36 s | 83% |
| tipico · retaliacao_tele/marca/arcano | 10 | 3 | elite | 100% | 8 s | 90% |
| tipico · retaliacao_tele/marca/arcano | 10 | 10 | guardiao | 100% | 145 s | 15% |
| tipico · retaliacao_tele/marca/arcano | 10 | 5 | rainha | 100% | 31 s | 85% |
| tipico · retaliacao_tele/marca/arcano | 12 | 3 | elite | 100% | 8 s | 92% |
| tipico · retaliacao_tele/marca/arcano | 12 | 10 | guardiao | 100% | 115 s | 39% |
| tipico · retaliacao_tele/marca/arcano | 12 | 5 | rainha | 100% | 29 s | 87% |
| tipico · retaliacao_tele/marca/controle | 8 | 3 | elite | 100% | 14 s | 85% |
| tipico · retaliacao_tele/marca/controle | 8 | 10 | guardiao | 100% | 150 s | 31% |
| tipico · retaliacao_tele/marca/controle | 8 | 5 | rainha | 100% | 39 s | 82% |
| tipico · retaliacao_tele/marca/controle | 10 | 3 | elite | 100% | 10 s | 88% |
| tipico · retaliacao_tele/marca/controle | 10 | 10 | guardiao | 100% | 134 s | 45% |
| tipico · retaliacao_tele/marca/controle | 10 | 5 | rainha | 100% | 35 s | 88% |
| tipico · retaliacao_tele/marca/controle | 12 | 3 | elite | 100% | 10 s | 90% |
| tipico · retaliacao_tele/marca/controle | 12 | 10 | guardiao | 100% | 127 s | 49% |
| tipico · retaliacao_tele/marca/controle | 12 | 5 | rainha | 100% | 32 s | 89% |
| tipico · retaliacao_tele/marca/lumen | 8 | 3 | elite | 100% | 14 s | 83% |
| tipico · retaliacao_tele/marca/lumen | 8 | 10 | guardiao | 100% | 151 s | 51% |
| tipico · retaliacao_tele/marca/lumen | 8 | 5 | rainha | 100% | 39 s | 83% |
| tipico · retaliacao_tele/marca/lumen | 10 | 3 | elite | 100% | 11 s | 91% |
| tipico · retaliacao_tele/marca/lumen | 10 | 10 | guardiao | 100% | 136 s | 59% |
| tipico · retaliacao_tele/marca/lumen | 10 | 5 | rainha | 100% | 34 s | 89% |
| tipico · retaliacao_tele/marca/lumen | 12 | 3 | elite | 100% | 10 s | 93% |
| tipico · retaliacao_tele/marca/lumen | 12 | 10 | guardiao | 100% | 130 s | 65% |
| tipico · retaliacao_tele/marca/lumen | 12 | 5 | rainha | 100% | 32 s | 90% |

## Comparação de variantes (hero_003 fora da build lumen)

| Variante | Rota: lumen | Rota: melhor sem lumen | Sem lumen com rota ≥ 50% | Tentativas: lumen | Tentativas: melhor sem lumen | Caminhos sem lumen em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| bom | 99% | 100% | 23/36 | — | — | 0/36 |
| nu | 81% | 100% | 8/36 | — | — | 0/36 |
| tipico | 94% | 100% | 10/36 | — | — | 0/36 |
