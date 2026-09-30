# Kits completos — validação no Argos (2026-09-30)

Simulação determinística do Argos, **não playtest**: nada aqui prova diversão nem declara o jogo balanceado. Todos os números dos kits são **HIPÓTESE** ([planos 00–04](../../arquivados/planos_concluidos/2026-09-30-kits-completos-00-fundacao.md)). Histórico do ajuste, ablações e a correção de método (métrica de nível de vitória): [KITS_TUNING_LOG.md](KITS_TUNING_LOG.md).

## O que foi medido (dados finais)

| Cenário | Execuções | Relatório (commit `82571ad` + alterações locais) | BUG |
| --- | ---: | --- | ---: |
| `kits_focus_bastiao` | 1040 | `tools/argos/reports/20260930-150753_82571ad` | 0 |
| `kits_focus_flecha` | 1014 | `tools/argos/reports/20260930-150144_82571ad` | 0 |
| `kits_focus_iris` | 1014 | `tools/argos/reports/20260930-151134_82571ad` | 0 |
| **Total dos kits** | **3068** | | **0** |
| `slice_balance` (regressão histórica, 18 combinações) | 1404 | `tools/argos/reports/20260930-151302_82571ad` | 0 |

Cada cenário de foco varia as builds de um herói e fixa os outros dois na party de referência `guardiao/marca/controle`. A Signature é o **3º slot fixo** de cada herói (decisão de Rafael).

## Resultado por build

Campanha: "nível" = nível do grupo no início da tentativa vencedora (meta 9–12; Rafael: ~10–11) e tentativas (meta 3–8).

| Herói / build | Rota L8 | L10 | L12 | Campanha: tentativas / nível |
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

Achados de kit que restam (relatórios `KIT_REPORT_*.md`): Bastião `retaliacao_tele` vence cedo e domina; Íris `lumen` vence cedo e domina; Íris `arcano` tem rota fraca no nível 10. Flecha: nenhum.

## Comparação com o baseline (18 combinações históricas)

| | Baseline (antes dos kits) | Com os kits (dados finais) |
| --- | --- | --- |
| Mediana do nível de vitória da campanha | 10,75 | **9,5** |
| Mediana de tentativas | 5,5 | 4,5 |
| Combinações abaixo do nível 9 / acima de 12 | 1 / 5 | 8 / 1 |
| Menor / maior nível de vitória | 8,5 / 14,5 | 6 / 12,5 |
| Caminhos viáveis no nível 10 (rota ≥ 50%) | 5 (1 sem `lumen`) | 12 (6 sem `lumen`) |
| TTK do Guardião (mediana; faixa 120–210 s) | 123 s | 113 s |

A meta "mais de um caminho viável sem depender da cura" passou a ser cumprida com folga. A mediana ficou ~1 nível abaixo do baseline: os kits deixaram o jogo um pouco mais fácil, concentrado nas duplas com `lumen` e com `retaliacao_tele`.

## O que o ajuste fez

- 1 **BUG** corrigido (`enemy_defeated_twice`; Julgamento de Ferro), com teste de regressão.
- Recargas das Signaturas 45→120 s (Bastião), 30→60 s (Flecha e Íris): levaram a mediana de 7,5 para 9,5.
- Impacto de Escudo 1,4→1,8 ×ATK e colisão 0,4→0,6: a build `controle` do Bastião foi de 25% para 75% na rota do nível 10.
- 3 números da build Lúmen reduzidos sem efeito medido (mantidos) e 3 números do `arcano` aumentados e **revertidos** (sem ganho).
- **Correção de método:** a primeira leitura usou o nível depois da vitória e concluiu, errado, que a campanha estava no alvo; o `kit_report.py` passou a usar a mesma métrica do Analyst (com teste) e todas as conclusões foram refeitas.

## O que **não** foi provado / decisões para Rafael

- Diversão, sensação de combate e leitura na tela: só playtest humano no `1E`.
- [BAL-010](BALANCE_FINDINGS.md): `lumen` (níveis 6–7) e `retaliacao_tele` (nível 8) vencem cedo; alavancas restantes são do núcleo existente (Pulso Restaurador, gatilho telegrafado do Contra-Golpe).
- [BAL-011](BALANCE_FINDINGS.md): `arcano` fraco e as 36 passivas novas sem efeito medido na campanha.
- [BAL-012](BALANCE_FINDINGS.md): TTK do Guardião (113 s) abaixo da faixa 120–210 s.
- Os ranks que dei ao Pulso Restaurador (Plano 03, I3) não tiveram efeito isolado medido (a variante que os remove foi idêntica à base); tratar como suspeitos.
- Julgamento de Ferro usa 3 Perfect Blocks (o design pede 4); o Argos ainda não tem contador próprio para ele, então a frequência de disparo **não foi medida** (só o BUG de dupla derrota foi encontrado e corrigido).
