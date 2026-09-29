# Arquitetura do Argos — Autonomous Playtester

> **Princípio:** Argos não é um bot monolítico. Ele é uma **camada de orquestração** sobre testes determinísticos, automação Android real, telemetria interna, simuladores massivos e relatórios de anomalias.

---

## 1. Visão Geral da Arquitetura em Camadas

```text
                     NOVA BUILD DISPONÍVEL
                               │
                               ▼
                    ┌─────────────────────┐
                    │  GODOT HEADLESS     │  (Cenas de teste unitário e integração)
                    └──────────┬──────────┘
                               │ PASS
                               ▼
                    ┌─────────────────────┐
                    │  SIMULADOR HEADLESS │  (Milhares de runs: economia, bosses, loot)
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   ARGOS STATE AI    │  (Joga pelo estado interno via DebugBridge)
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   ARGOS VISUAL AI   │  (Maestro CLI / MCP no Android real/emulador)
                    └──────────┬──────────┘
                               │
                               ▼
                     TELEMETRIA & SNAPSHOTS
                               │
                               ▼
                         ARGOS ANALYST
                     (Detecção de Padrões)
                     ┌─────────┼─────────┐
                     ▼         ▼         ▼
                    BUG     BALANCE     UX
                     └─────────┬─────────┘
                               ▼
                             TÊMIS (Auditoria de Conformidade)
                               │
                               ▼
                            ERGANE (Implementação de Fix)
                               │
                               ▼
                         ARGOS RETEST
```

---

## 2. Componentes da Stack

1. **Runner Godot headless (implementado):** `tools/run_godot_tests.py` descobre as cenas em `tests/`, executa cada uma e falha também em `SCRIPT ERROR`. GdUnit4 continua como possibilidade futura, sem instalação atual.
2. **Maestro + MCP:** Operação externa no Android/emulador via servidor MCP oficial (`maestro mcp`). Inspeciona telas, tira screenshots e executa jornadas completas de usuário.
3. **Estado e telemetria (parcialmente implementado):** `StateExporter`/`DebugBridge` expõem o snapshot do slice; `SliceTelemetry` agrega eventos do `ExpeditionRun` sem influenciar o combate. Métricas de economia e jornada dependem das etapas seguintes.
4. **Android CLI (Fallback Visual):** Comandos `android screen capture` e `android screen resolve` para mapeamento de coordenadas #N quando o canvas não expõe nós semânticos.
5. **Simulador Headless (implementado para o slice):** cenários configuram capítulo, party, builds, níveis, sementes e modos. A matriz vigente roda 1.404 execuções; 10k–100k continua meta para cargas futuras.
6. **Argos Analyst (implementado):** agrega `runs.jsonl`, aplica regras com cobertura explícita, compara relatórios e classifica `BUG`, `BALANCE`, `PACING` e `INFO`.

Antes da simulação, [`validate_balance_data.py`](../../tools/balance/validate_balance_data.py) verifica a composição núcleo → capítulo → cenário. Cada relatório registra SHA-256 das entradas usadas; detalhes em [GLOBAL_BALANCE_SYSTEM](../06_balance/GLOBAL_BALANCE_SYSTEM.md).

---

## 3. Os Dois Olhos do Argos

* **Olho Interno (Estado):** snapshot estruturado via `StateExporter.gd` e eventos agregados por `SliceTelemetry`; inventário e save retornam no `1B`/`1D`.
* **Olho Externo (Visual):** Screenshot da tela Android capturada pelo Maestro ou Android CLI.
* **Detecção de Divergências:** Permite ao Argos acusar quando o que está desenhado na tela diverge do que realmente foi processado na lógica interna (ex.: barra de vida cheia na UI, mas entidade morta na memória).
