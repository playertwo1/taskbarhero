# Kits completos — baseline do Argos (2026-09-30)

Referência **antes** dos kits completos ([plano 00](../../arquivados/planos_concluidos/2026-09-30-kits-completos-00-fundacao.md), Tarefa 3). Simulação determinística; não é playtest e não avalia diversão.

- Cenário: `slice_balance` (18 combinações × 6 sementes, 1404 execuções, `0 BUG`).
- Relatório: `tools/argos/reports/20260930-122635_82571ad/REPORT.md` (commit `82571ad` com alterações locais: passivas de Flecha e Íris e ranks R3–R5 já implementados; kits completos ainda não).
- Estado do código: suíte 31/31 cenas PASS; `enemy_damage_scale` 0,5.

## O que o baseline mostra

- **Dominância**: nível 10, melhor build 100% de vitória de rota contra mediana de 17%. Líderes: `guardiao/marca/lumen`, `retaliacao_tele/critico/lumen`, `retaliacao_tele/marca/lumen`. As builds com a cura da Íris (`lumen`) dominam.
- **Caminhos viáveis no nível 10** (rota ≥ 50%): 5, dos quais só 1 sem a build `lumen` (`retaliacao_tele/marca/controle`). Meta de Rafael: mais de um caminho sem depender da cura.
- **Campanha**: várias combinações com Íris `arcano` vencem tarde (nível 13–14,5; 7–9,5 tentativas; meta 9–12 e 3–8); `retaliacao_tele/marca/lumen` vence cedo (nível 8,5).
- **TTK do Guardião**: mediana 123 s (faixa 120–210 s); 2/16 vitórias abaixo da faixa.
- **Primeira tentativa no nível 10**: melhor combinação 100% (referência humana 40–60%).

## Como usar

Os planos 01–03 comparam cada build antiga com estes números (mesmo nome de build) antes de qualquer ajuste. Como as builds antigas passam a carregar passivas novas, as taxas mudam: isso é esperado e vira achado no plano 04, não regressão de código.
