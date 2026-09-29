# Pocket Hero

RPG mobile de combate automático, party, equipamentos e progressão, desenvolvido em Godot. O produto se chama **Pocket Hero**; `taskbarhero` é o nome do repositório. Android em um aplicativo normal é a plataforma inicial, com personagens, mundo, interface e arte originais.

O MVP foi homologado no gate `R19`. A prioridade pós-MVP e as etapas atuais estão em [`ROADMAP.md`](ROADMAP.md); o histórico concluído está em [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

## Navegação

- [`AGENTS.md`](AGENTS.md) — índice operacional, regras e mapa do repositório.
- [`PROJECT_STATE.md`](PROJECT_STATE.md) — fontes de estado e implementação observável.
- [`ROADMAP.md`](ROADMAP.md) — prioridade atual e gates.
- [`docs/INDEX.md`](docs/INDEX.md) — documentação de design por área.
- [`docs/CONTENT_REGISTRY.md`](docs/CONTENT_REGISTRY.md) — IDs de design e roteamento dos catálogos.
- [`documents/INDEX.md`](documents/INDEX.md) — guias completos e fontes originais.
- [`arquivados/INDEX.md`](arquivados/INDEX.md) — documentação histórica preservada.

Código do jogo fica em `scenes/` e `scripts/`; dados de runtime em `data/`; arte final em `assets/`; evidências executáveis em `tests/`. Consulte os índices antes de abrir ou editar uma área.

## Verificação

```text
python tools/run_godot_tests.py                          # suíte de testes Godot (headless)
python tools/argos/run.py --scenario slice_balance       # Argos: simulação de balanceamento + relatório
```

O **Argos** é o playtester automático do projeto: roda milhares de expedições no Godot sem interface, verifica invariantes (bugs) e gera um `REPORT.md` com achados de balanceamento. Como usar e regras para agentes: [`tools/argos/README.md`](tools/argos/README.md) e a seção "Testes e Argos" de [`AGENTS.md`](AGENTS.md).
