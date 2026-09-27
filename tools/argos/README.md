# Argos — Autonomous Playtester do Pocket Hero

> **Missão:** Argos é a camada autônoma de playtest do Pocket Hero. Não substitui o julgamento humano de diversão, mas executa testes repetitivos, explora diferentes perfis de jogadores, busca bugs e exploits, mede balanceamento e entrega evidências estruturadas para Têmis (auditoria) e Ergane (implementação/correção).

---

## Estrutura do Diretório

```text
tools/argos/
├── README.md               # Este documento
├── ARGOS_SOUL.md           # Persona, princípios e regras operacionais do Argos
├── profiles/               # Perfis de comportamento sintético
│   ├── beginner.yaml       # Jogador novato (FTUE, clareza de UI)
│   ├── optimizer.yaml      # Maximizador de XP/h e builds dominantes
│   ├── idle.yaml           # Jogador casual e retorno offline
│   ├── hoarder.yaml        # Gestão de inventário e limites de itens
│   ├── chaos.yaml          # Interrupções, lifecycle e entradas anômalas
│   └── exploit_hunter.yaml # Quebra de economia e duplicação de recompensas
├── maestro/                # Automação Android externa via Maestro CLI e MCP
│   ├── journeys/           # Jornadas completas de ponta a ponta
│   ├── regression/         # Testes de regressão de tela
│   └── smoke/              # Smoke tests básicos de inicialização
├── simulator/              # Simulador headless massivo (10k a 100k runs)
│   ├── combat/             # TTK e taxas de vitória de bosses
│   ├── economy/            # Balanço de fontes vs sumidouros (sources & sinks)
│   └── loot/               # Distribuição real de drops e raridades
├── analyzer/               # Argos Analyst (detecção de anomalias em logs)
├── reports/                # Relatórios estruturados de findings (YAML/Markdown)
└── snapshots/              # Capturas determinísticas de estado JSON
```

---

## Como Operar os Perfis

Argos é acionado pelo Hermes especificando o profile desejado e o commit da build:

```text
Use Argos no profile beginner.
Build: <commit_sha>.
Execute a primeira sessão no Android.
Objetivos: chegar ao primeiro drop, equipar, primeiro level-up.
Entregue: timeline, findings classificados e steps reproduzíveis.
```
