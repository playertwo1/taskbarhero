# Argos — Autonomous Playtester do Pocket Hero

Consulte a [persona e as regras de operação do Argos](ARGOS_SOUL.md) antes de executar um profile.

> **Missão:** Argos é a camada autônoma de playtest do Pocket Hero. Não substitui o julgamento humano de diversão, mas executa testes repetitivos, explora diferentes perfis de jogadores, busca bugs e exploits, mede balanceamento e entrega evidências estruturadas para Têmis (auditoria) e Ergane (implementação/correção).

---

## Regras de uso (para qualquer agente)

| Pergunta | Comando | Saída |
| --- | --- | --- |
| O código continua correto? | `python tools/run_godot_tests.py` | PASS/FAIL por cena; falha também em `SCRIPT ERROR` (a suíte cobre `tests/unit/`) |
| Como estão os eventos e o loot da run? | `python tools/argos/run.py --scenario slice_run_layer` | `tools/argos/reports/<data>_<commit>/REPORT.md` |
| Como está o balanceamento do slice? | `python tools/argos/run.py --scenario slice_quick` (~2 s) ou `--scenario slice_balance` (~75 s) | idem |
| O Analyst funciona? | `python -m unittest tools/argos/analyzer/test_analyze.py` | OK/FAIL |

- Rode o Argos depois de mudar `data/`, `scripts/combat/` ou regras de combate, e compare o `REPORT.md` com o anterior.
- Leia só o `REPORT.md`; abra `runs.jsonl` apenas para investigar um achado específico.
- Achado `BUG` é defeito a corrigir. Achados `BALANCE`/`PACING` vão para [`BALANCE_FINDINGS`](../../docs/08_qa/BALANCE_FINDINGS.md) com hipótese e proposta; a decisão é de Rafael.
- Para testar uma hipótese, crie ou copie um cenário em `simulator/combat/scenarios/` com `overrides`; não altere `/data` só para medir.
- Não afrouxe `analyzer/rules_slice.json` para um relatório passar; mudar meta exige decisão de Rafael.
- Resultado do Argos é simulação determinística, não playtest: não conclua diversão; registre o commit do relatório como evidência.
- Relatórios locais não citados em documentos podem ser apagados; os versionados (`REPORT.md`, `summary.json`, `meta.json`) são evidência.

## Estrutura do Diretório

```text
tools/argos/
├── README.md               # Este documento
├── ARGOS_SOUL.md           # Persona, princípios e regras operacionais do Argos
├── profiles/               # Perfis de jogador artificial (JSON, executáveis; ver profiles/README.md)
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
├── simulator/              # Simulador headless; escala conforme o cenário e orçamento de execução
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

---

## ARGOS-SIM — simulador headless e Analyst (em uso)

Primeira camada implementada, antes do Maestro, porque o gargalo atual é balanceamento. **Não usa IA no laço:** o Godot roda o `ExpeditionRun` determinístico e o Analyst aplica regras fixas. Uma IA (ou pessoa) lê só o `REPORT.md`.

```text
python tools/balance/validate_balance_data.py        # composição e referências globais
python tools/argos/run.py --scenario slice_quick     # checagem rápida, nível 5
python tools/argos/run.py --scenario slice_balance   # matriz do Capítulo 1, níveis 8/10/12 + campanha
python tools/argos/run.py --scenario scale_equivalence   # 1× contra 10× (combat_scale); ~20 s
python tools/argos/run.py --scenario slice_route_gear   # rota e segmentos com equipamento nu, tipico e bom (~4 min)
python tools/argos/run.py --scenario argos_profiles   # perfis de jogador: campanha, fuzz de inventário e bordas (~8 min); --profiles a,b ou --area x filtram
python tools/balance/check_scale_equivalence.py <pasta_do_relatório>   # exige 0 divergências entre x1 e x10
# depuração: "dump_events": true no cenário grava o log de eventos de rota/segmento em cada registro
python -m unittest tools/argos/analyzer/test_analyze.py
```

| Cenário | Comando | O que mede |
| --- | --- | --- |
| `slice_run_layer` | `python tools/argos/run.py --scenario slice_run_layer` | Campanha com `SliceCampaign`/loot/eventos reais; consulte **Eventos e loot da run** para frequência por variante, escolhas e raridades recebidas. |

| Peça | Arquivo | Função |
| --- | --- | --- |
| Perfis | `data/balance/combat_profiles.json` + `data/balance/chapters/*.json` | núcleo global, capítulo, caminhos runtime, party, segmentos e ponto de entrada do chefe |
| Cenários | `simulator/combat/scenarios/*.json` | capítulo, party, combinações de builds, níveis, sementes, modos (`route`, `segments`, `campaign`) e overrides temporários |
| Perfis de jogador | `profiles/*.json` + `profiles/selection.json` + `simulator/combat/argos_player.gd`, `argos_fuzz.gd` | oito perfis executáveis (Core: beginner, optimizer, chaos, exploit_hunter, grinder, edge_case; Balance Lab: aggressor, turtle); política de decisão, fuzz da API de inventário com 17 oráculos (validados por mutação) e casos de borda do combate. Detalhes, política e perfis adiados: [profiles/README.md](profiles/README.md) |
| Equipamento da rota | `simulator/combat/equipment_profiles.json` | perfis `nu`, `tipico` (3 slots, Incomum, IP 15) e `bom` (5 slots, Raro, IP 22) para os modos `route` e `segments`; o cenário escolhe com `"route_equipment"` (padrão `nu`; `slice_balance` usa `tipico`) e uma variante pode trocar. A campanha não usa perfil: equipa o que dropa. |
| Simulador | `simulator/combat/argos_sim.gd` (`ArgosSim.tscn`) | uma linha JSON por execução em `runs.jsonl`, com métricas e oráculos |
| Oráculos | idem | tempo voltando, HP negativo, herói derrotado agindo, inimigo derrotado agindo ou derrotado duas vezes, XP pago ≠ esperado, combate travado, execução sem fim, log dependente do passo |
| Analyst | `analyzer/analyze.py` + `analyzer/rules_slice.json` | agrega, classifica achados (BUG, BALANCE, PACING, INFO) e compara com o relatório anterior do mesmo cenário |
| Relatórios | `reports/<data>_<commit>/` | `REPORT.md`, `summary.json`, `meta.json` versionáveis; `runs.jsonl` e `godot.log` ficam locais |

`run.py` valida os dados antes de iniciar, registra o hash das entradas e sai com código 1 se houver achado BUG ou `SCRIPT ERROR`. O Analyst só avalia uma regra quando o cenário cobre o nível exigido. As faixas de `rules_slice.json` citam a fonte; as metas de caminhos viáveis e de tentativas são **HIPÓTESE** até decisão de Rafael. Simulação não é playtest e não avalia diversão.

Próximas camadas: completar métricas de economia/jornada no estado interno e adicionar Maestro para jornadas no Android. `StateExporter`, `DebugBridge` e `SliceTelemetry` já cobrem o snapshot e os eventos disponíveis no slice atual.
