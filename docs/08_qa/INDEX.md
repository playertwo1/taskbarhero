# QA — índice

- [Estratégia de teste](TEST_STRATEGY.md)
- [Relatos de bug](BUG_REPORT_SCHEMA.md)
- [ARGOS](ARGOS_ARCHITECTURE.md) e [tooling](../../tools/argos/README.md)
- [Achados de balanceamento](BALANCE_FINDINGS.md)
- [QA mobile do slice (1E)](QA_MOBILE_1E.md) — relatório de homologação tátil no emulador Pixel 9 (1080×2424); PASS com loop completo verificado.
- [Evidências de QA Mobile no Pixel 9](QA_MOBILE_PIXEL9_REPORT.md) — matriz de testes tácteis, tela a tela, validação do Ferreiro e conformidade mobile.
- [Roteiro de playtest do slice (1E)](PLAYTEST_1E.md) — perguntas, registro por tentativa e como o resultado volta ao balanceamento; `DESIGN`, ainda não executado.
- [Testes no repositório](../../tests/) — execute todos com `python tools/run_godot_tests.py` (headless; sai com 1 se alguma cena falhar).
- [Validador de balanceamento](../../tools/balance/validate_balance_data.py) — composição, status, arquivos e referências cruzadas antes do Argos.
- [QA visual de arte](../art/QA_SPRITES.md)
- [Registro de auditoria do MVP (histórico R7–R19)](../../arquivados/REGISTRO_DE_AUDITORIA_MVP.md)
- [ROADMAP e gates atuais](../../ROADMAP.md)

Testes sob `tests/` documentam evidência executável; planos e checklists em docs não equivalem a um teste executado ou a `PASS`.

**Última evidência registrada (2026-09-30):** 29/30 cenas Godot PASS (a falha é `TestExpeditionChoices`, seed 101, exceção aceita por Rafael no gate 1C); 10 testes do Analyst OK; `slice_balance` com 1404 execuções sem `BUG`; QA Mobile no Pixel 9 (`1080x2424`) homologado PASS em todas as 11 etapas do loop do slice. O Argos determinístico não substitui playtest; achados de balanceamento e pacing permanecem em [BALANCE_FINDINGS.md](BALANCE_FINDINGS.md).
