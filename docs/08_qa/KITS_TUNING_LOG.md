# Ajuste dos kits — log (2026-09-30)

Simulação determinística do Argos, **não playtest**. Cada linha é uma iteração do laço da Tarefa 5 do [Plano 04](../../arquivados/planos_concluidos/2026-09-30-kits-completos-04-argos.md): poucos números por iteração, só em parâmetros das linhas novas dos kits, hipótese escrita antes de reexecutar. Decisão de design da sessão: Signature no 3º slot fixo (sem variantes `_sig`).

**Métrica de "nível de vitória" da campanha:** nível do grupo no **início** da tentativa vencedora (`history[-1].level`), a mesma do Analyst. Meta de Rafael: vencer o Guardião por volta do nível 10–11 (faixa tolerada 9–12 e 3–8 tentativas). A primeira leitura desta sessão usou por engano o nível *depois* da vitória (`final_level`, ~2 níveis acima) e concluiu "no alvo"; isso foi corrigido no `kit_report.py` (com teste) e **todas as conclusões abaixo foram refeitas com a métrica certa**.

Linha-base histórica (antes dos kits completos): [KITS_BASELINE_2026-09-30.md](KITS_BASELINE_2026-09-30.md) — mediana de nível de vitória **10,75** e 5,5 tentativas nas 18 combinações (1 abaixo de 9; 5 acima de 12).

## BUG corrigido antes do ajuste

| Cenário | Achado | Causa | Correção | Prova |
| --- | --- | --- | --- | --- |
| `kits_focus_bastiao` (`20260930-135915_82571ad`) | `enemy_defeated_twice` em 7 rotas `retaliacao/marca/controle` | o Julgamento de Ferro disparava a onda antes do dano do próprio contra-ataque, matava o alvo e o contra-ataque o derrotava de novo | o Julgamento dispara depois do dano do contra-ataque (`ExpeditionRun.gd`) | `test_kit_bastiao.gd` B9 (determinístico) e nova rodada com `0 BUG` |

## Estado medido antes do ajuste de números

Primeira rodada completa (`kits_focus_*`, 0 BUG) com as Signaturas em recarga 45 s (Bastião) e 30 s (Flecha e Íris): as **18 combinações históricas** (`slice_balance`, relatório `20260930-142143_82571ad`) vencem com mediana de nível **7,5** e 3,25 tentativas — cerca de **3 níveis mais fáceis** que o baseline (10,75). 10 das 18 combinações vencem abaixo do nível 9.

## Ablações (variantes do Argos, sem tocar em `/data`)

Cenário `tune_kits_party`: 18 combinações, campanha, 8 a 10 sementes. "Sem Signaturas" = gatilho que nunca dispara (um controle limpo: recarga 9999 ainda deixava cada Signature lançar uma vez por run).

| Variante | nível mediano de vitória | tentativas medianas | combinações abaixo de 9 |
| --- | ---: | ---: | ---: |
| base (recargas 45/30/30 s) | 8,5 | 3,75 | 9 de 18 |
| **sem as 3 Signaturas** | **10,0** | 5,0 | 6 de 18 |
| sem as 36 passivas novas | 8,5 | 3,75 | 9 de 18 |
| recargas ×2 | 9,5 | 4,5 | 7 de 18 |
| recargas ×3 | 9,25 | 4,25 | 7 de 18 |
| recargas ×4 | 9,5 | 4,5 | 7 de 18 |
| metade do efeito das Signaturas | 9,0 | 4,0 | 7 de 18 |
| Bastião 120 s, Flecha 60 s, Íris 60 s | **9,5** | 4,5 | 7 de 18 |
| Bastião 180 s, Flecha 120 s, Íris 120 s | 9,5 | 4,5 | 7 de 18 |

**Conclusões:** (1) as Signaturas respondem por ~1,5 nível de antecipação; (2) as 36 passivas novas somadas **não mudam** a mediana da campanha; (3) mesmo sem Signaturas os kits ficam ~0,75 nível abaixo do baseline (10,0 × 10,75, dentro do ruído de 6–8 sementes) e (4) as combinações com `lumen` ficam em 7 independentemente da recarga das Signaturas.

Ablação só da `lumen` (cenário `tune_iris_lumen`, 12 sementes, `guardiao/marca/lumen`): base nível 5 / 2 tentativas; sem a Signature da Íris ou sem as passivas Lúmen: igual (5 / 2); sem as Signaturas de Bastião e Flecha: 7 / 3; só sem a do Bastião: 7 / 3; só sem a da Flecha: 5 / 2; recarga 60 s no Bastião: 7 / 3. O Último Bastião é o que mais antecipa a vitória da `lumen`, mas com ele desligado ela ainda vence no nível 7: o restante vem do núcleo existente (Pulso Restaurador + Véu).

## Iterações

| It. | Cenário (relatório) | Achados antes | Hipótese | Mudança (campo: de → para) | Resultado | Decisão |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `kits_focus_iris` (`20260930-140925_82571ad`) | `lumen` vence cedo | os amplificadores de cura (C1, C2) e o Chama Viva deixam a `lumen` forte demais | `pass_iri_012.value` 0,10 → 0,05; `pass_iri_013.fraction` 0,5 → 0,3; `trait_iri_003.value` 0,10 → 0,05 | sem mudança nas métricas | hipótese **refutada**; valores menores mantidos (mais conservadores, sem efeito medido) |
| 2 | `tune_iris_lumen` (ablação) | `lumen` vence no nível 5 com 2 tentativas | o Último Bastião (recarga 45 s) antecipa a vitória | `skill_bas_011.cooldown` 45 → 60 | `lumen` sobe para nível 7 / 3 tentativas | aplicado; insuficiente sozinho |
| 3 | `tune_kits_party` (ablação no grupo) | mediana 7,5–8,5; 9 de 18 abaixo de 9 | as três Signaturas somam ~1,5 nível | `skill_bas_011.cooldown` 60 → 120; `skill_fle_011.cooldown` 30 → 60; `skill_iri_006.cooldown` 30 → 60 | mediana das 18 combinações **9,5** / 4,5 tentativas (ablação) e 9,5 / 4,5 na rodada completa (`20260930-151302_82571ad`) | aplicado |
| 4a | `kits_focus_bastiao` (`20260930-150027_82571ad` → `20260930-150753_82571ad`) | `VIABLE` `controle`: rota 25% no nível 10 | o Impacto de Escudo é fraco (1,4×ATK) | `skill_bas_010.coefficient` 1,4 → 1,8; `collision_coefficient` 0,4 → 0,6 (ranks R2 1,98 e R3 0,8 acompanham) | rota nível 10: **25% → 75%**; achado `VIABLE` resolvido | aplicado |
| 4b | `kits_focus_iris` (`20260930-150318_82571ad` → `20260930-150909_82571ad`) | `VIABLE` `arcano`: rota 27% no nível 10 (baseline: 0%) | os nós A3–A5 novos são fracos | `pass_iri_006.cd_reduce` 1 → 2; `pass_iri_007.value` 0,15 → 0,30; `pass_iri_008.value` 0,4 → 0,6 | `arcano` nível 10: 27% → 15% (dentro do ruído, sem ganho) | hipótese **refutada**; **revertido** aos valores originais |

Nenhum herói chegou ao limite de 5 iterações.

## Resultado final (dados atuais)

Relatórios: `kits_focus_bastiao` `20260930-150753_82571ad`; `kits_focus_flecha` `20260930-150144_82571ad`; `kits_focus_iris` `20260930-151134_82571ad`; `slice_balance` `20260930-151302_82571ad`.

| Herói / build | Rota L8 | L10 | L12 | Campanha: tentativas / nível de vitória |
| --- | ---: | ---: | ---: | --- |
| Bastião `guardiao` | 5% | 65% | 100% | 4 / 9 |
| Bastião `retaliacao` | 30% | 85% | 100% | 5 / 10 |
| Bastião `retaliacao_tele` | 95% | 100% | 100% | 3,5 / **8** |
| Bastião `controle` | 0% | 75% | 95% | 5 / 10 |
| Flecha `critico` | 8% | 58% | 85% | 4 / 9 |
| Flecha `marca` | 4% | 65% | 100% | 4 / 9 |
| Flecha `velocidade` | 0% | 69% | 100% | 4 / 9 |
| Íris `arcano` | 0% | 27% | 85% | 6 / 12 |
| Íris `controle` | 4% | 65% | 100% | 4 / 9 |
| Íris `lumen` | 100% | 100% | 100% | 3 / **7** |

As 18 combinações históricas (`slice_balance`): mediana de nível de vitória **9,5** e **4,5** tentativas (baseline 10,75 e 5,5); 8 combinações abaixo do nível 9 (mínimo 6) e 1 acima de 12; caminhos viáveis no nível 10: **12** (baseline 5), dos quais **6 sem `lumen`** (baseline 1); TTK do Guardião: mediana 113 s (baseline 123 s; faixa 120–210 s).

Achados que restam (alavancas fora do que este ajuste podia mexer) estão em [BAL-010 e BAL-011](BALANCE_FINDINGS.md).
