# Pocket Hero

RPG mobile de combate automático, party, equipamentos e progressão, desenvolvido em Godot. O produto se chama **Pocket Hero**; `taskbarhero` é o nome do repositório. Android em um aplicativo normal é a plataforma inicial, com personagens, mundo, interface e arte originais.

O MVP foi homologado no gate `R19` e substituído pelo vertical slice no `1A-CUT` (2026-09-29). O fluxo jogável atual é `TitleScreen → SliceCampaign`, com expedições, escolhas, loot, inventário e save mínimo; QA mobile formal segue no `1E`. A prioridade e os gates atuais estão em [`ROADMAP.md`](ROADMAP.md); o histórico concluído está em [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

## Navegação

- [`AGENTS.md`](AGENTS.md) — índice operacional, regras e mapa do repositório.
- [`PROJECT_STATE.md`](PROJECT_STATE.md) — fontes de estado e implementação observável.
- [`ROADMAP.md`](ROADMAP.md) — prioridade atual e gates.
- [`docs/INDEX.md`](docs/INDEX.md) — documentação de design por área.
- [`docs/CONTENT_REGISTRY.md`](docs/CONTENT_REGISTRY.md) — IDs de design e roteamento dos catálogos.
- [`docs/06_balance/GLOBAL_BALANCE_SYSTEM.md`](docs/06_balance/GLOBAL_BALANCE_SYSTEM.md) — composição global de balanceamento, validação, métricas e gates.
- [`documents/INDEX.md`](documents/INDEX.md) — guias completos e fontes originais.
- [`arquivados/INDEX.md`](arquivados/INDEX.md) — documentação histórica preservada.

Código do jogo fica em `scenes/` e `scripts/`; dados de runtime em `data/`; arte final em `assets/`; evidências executáveis em `tests/`. Consulte os índices antes de abrir ou editar uma área.

## Verificação

```text
python tools/run_godot_tests.py                          # suíte de testes Godot (headless)
python tools/balance/validate_balance_data.py            # perfis, IDs e referências de balanceamento
python tools/argos/run.py --scenario slice_quick         # regressão rápida do capítulo configurado
python tools/argos/run.py --scenario slice_run_layer     # eventos, escolhas e loot da campanha
python tools/argos/run.py --scenario slice_balance       # Argos: simulação de balanceamento + relatório
```

O **Argos** é o playtester automático do projeto: resolve núcleo global + perfil do capítulo + overrides temporários, roda expedições no Godot sem interface, verifica invariantes e gera um `REPORT.md` com hash das entradas. Como usar e regras para agentes: [`tools/argos/README.md`](tools/argos/README.md) e a seção "Testes e Argos" de [`AGENTS.md`](AGENTS.md).

**Evidência de 2026-09-29:** validador `OK`, 25/25 cenas Godot e 10 testes do Analyst; `slice_quick` e `slice_run_layer` sem `BUG` (192 execuções no cenário de campanha). Os achados e números continuam **HIPÓTESE** até playtest e telemetria real.
