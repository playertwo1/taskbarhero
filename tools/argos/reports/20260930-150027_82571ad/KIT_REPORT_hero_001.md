# Relatório de kit — hero_001

Simulação determinística, não playtest. Regras: `RULES` em `kit_report.py`.

| Build | Rotas | Vitória L8 | L10 | L12 | Campanha vence | Mediana tentativas | Nível de vitória |
| --- | --- | --- | --- | --- | --- | --- | --- |
| controle | 60 | 0% | 25% | 100% | 100% | 5.0 | 10.0 |
| guardiao | 60 | 5% | 65% | 100% | 100% | 4.0 | 9.0 |
| retaliacao | 60 | 30% | 85% | 100% | 100% | 5.0 | 10.0 |
| retaliacao_tele | 60 | 95% | 100% | 100% | 100% | 3.5 | 8.0 |

## Skills (média de casts e dano por rota)

- **controle** — skill_bas_008: 13.1 casts / 0 dano; skill_bas_010: 19.1 casts / 431 dano; skill_bas_011: 0.9 casts / 4 dano
- **guardiao** — skill_bas_006: 11.5 casts / 0 dano; skill_bas_009: 8.3 casts / 0 dano; skill_bas_011: 1.0 casts / 4 dano
- **retaliacao** — skill_bas_007: 27.9 casts / 293 dano; skill_bas_008: 12.9 casts / 0 dano; skill_bas_011: 1.0 casts / 4 dano
- **retaliacao_tele** — skill_bas_007: 18.0 casts / 263 dano; skill_bas_008: 14.0 casts / 0 dano; skill_bas_011: 1.0 casts / 4 dano

## Contadores de kit (média por rota)

- **controle** — enemy_imbalanced: 43.6; enemy_marked: 19.0; enemy_stunned: 15.9; guard_gained: 183.3; guard_spent: 20.1; last_bastion_started: 1.0; telegraph_interrupted: 2.3
- **guardiao** — ally_saved: 1.0; enemy_imbalanced: 21.5; enemy_marked: 19.6; enemy_stunned: 10.3; guard_gained: 114.5; guard_spent: 1.0; last_bastion_started: 1.0; telegraph_interrupted: 1.5
- **retaliacao** — enemy_imbalanced: 45.7; enemy_marked: 18.9; enemy_stunned: 34.3; guard_gained: 118.7; guard_spent: 1.0; iron_response: 1.4; last_bastion_started: 1.0; telegraph_interrupted: 1.3
- **retaliacao_tele** — enemy_imbalanced: 40.7; enemy_marked: 19.2; enemy_stunned: 28.0; guard_gained: 118.5; guard_spent: 1.0; iron_response: 1.1; last_bastion_started: 1.0; telegraph_interrupted: 1.5

## Achados

- **[PACING/CAMPAIGN]** retaliacao_tele: vitória no nível 8.0 (meta 9–12)
- **[BALANCE/VIABLE]** controle: vitória de rota máxima 25% até o nível 11
- **[BALANCE/DOMINANT]** nível 8: retaliacao_tele 95% vs mediana 18% (gap > 50%)
- **[BALANCE/DOMINANT]** nível 10: retaliacao_tele 100% × controle 25% (gap > 35%)
