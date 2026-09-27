# Arquitetura do Argos — Autonomous Playtester

> **Princípio:** Argos não é um bot monolítico. Ele é uma **camada de orquestração** sobre testes determinísticos, automação Android real, telemetria interna, simuladores massivos e relatórios de anomalias.

---

## 1. Visão Geral da Arquitetura em Camadas

```text
                     NOVA BUILD DISPONÍVEL
                               │
                               ▼
                    ┌─────────────────────┐
                    │   GdUnit4 Runner    │  (Testes internos unitários e de integração)
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

1. **GdUnit4:** Framework embutido no Godot 4 para testes unitários, asserções, mocks/spies, scene runner, fuzzing e CI.
2. **Maestro + MCP:** Operação externa no Android/emulador via servidor MCP oficial (`maestro mcp`). Inspeciona telas, tira screenshots e executa jornadas completas de usuário.
3. **DebugBridge & Telemetry (`scripts/debug/`):** Interface interna controlada que expõe estado, eventos (TTK, XP/h, gold/h) e hooks para Dev Mode sem vazar para compilações de release.
4. **Android CLI (Fallback Visual):** Comandos `android screen capture` e `android screen resolve` para mapeamento de coordenadas #N quando o canvas não expõe nós semânticos.
5. **Simulador Headless:** Execução massiva em tempo acelerado (10k a 100k runs) para estimar TTK, win rate de bosses, inflação de ouro e distribuição de raridades de itens.
6. **Argos Analyst:** Motor de detecção de anomalias estatísticas a partir de logs e snapshots de sessões de teste.

---

## 3. Os Dois Olhos do Argos

* **Olho Interno (Estado):** Snapshot estruturado JSON via `StateExporter.gd` (HP, atributos, inventário, seeds, tempo de jogo).
* **Olho Externo (Visual):** Screenshot da tela Android capturada pelo Maestro ou Android CLI.
* **Detecção de Divergências:** Permite ao Argos acusar quando o que está desenhado na tela diverge do que realmente foi processado na lógica interna (ex.: barra de vida cheia na UI, mas entidade morta na memória).
