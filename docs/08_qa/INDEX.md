# QA — índice

- [Estratégia de teste](TEST_STRATEGY.md)
- [Relatos de bug](BUG_REPORT_SCHEMA.md)
- [ARGOS](ARGOS_ARCHITECTURE.md) e [tooling](../../tools/argos/README.md)
- [Achados de balanceamento](BALANCE_FINDINGS.md)
- [Testes no repositório](../../tests/) — execute todos com `python tools/run_godot_tests.py` (headless; sai com 1 se alguma cena falhar).
- [Validador de balanceamento](../../tools/balance/validate_balance_data.py) — composição, status, arquivos e referências cruzadas antes do Argos.
- [QA visual de arte](../art/QA_SPRITES.md)
- [Registro de auditoria do MVP (histórico R7–R19)](../../arquivados/REGISTRO_DE_AUDITORIA_MVP.md)
- [ROADMAP e gates atuais](../../ROADMAP.md)

Testes sob `tests/` documentam evidência executável; planos e checklists em docs não equivalem a um teste executado ou a `PASS`.

**Última evidência registrada (2026-09-29):** 27/28 cenas Godot (a falha é `TestExpeditionChoices`, seed 101, exceção aceita por Rafael no gate 1C); novas cenas: `TestResonanceTree`, `TestBlacksmith`, `TestHubPanels`, `TestRunSpeedControls`, `TestLoadoutBuilds` (29/30 no total); 10 testes do Analyst; `slice_quick` e `slice_run_layer` sem `BUG` (192 execuções no cenário de campanha). O Argos determinístico não substitui playtest; achados de balanceamento e pacing permanecem em [BALANCE_FINDINGS.md](BALANCE_FINDINGS.md).
