# Pocket Hero

RPG mobile de combate automático, party, equipamentos e progressão incremental, feito em Godot 4.7.2 para Android (app normal). O produto se chama **Pocket Hero**; `taskbarhero` é só o nome do repositório. Personagens, mundo, interface e arte são originais.

**Onde estamos:** o vertical slice do Capítulo 1 (`TitleScreen → SliceCampaign`) está jogável e passou no QA mobile (Pixel 9). Falta o playtest humano. O balanceamento global v1.0 está escrito e aguarda decisões. Detalhes: [`ROADMAP.md`](ROADMAP.md).

## Por onde começar

| Você é… | Leia |
| --- | --- |
| Agente de IA (Claude, ChatGPT, Antigravity) | [`AGENTS.md`](AGENTS.md) → [`PROJECT_STATE.md`](PROJECT_STATE.md) → [`ROADMAP.md`](ROADMAP.md) seções 1 e 3 |
| Pessoa conhecendo o projeto | [resumo do projeto](docs/00_project/POCKET_HERO_PROJECT_BRIEF.md) → [pilares](docs/00_project/GAME_PILLARS.md) → [loop](docs/00_project/CORE_LOOP.md) |
| Quem vai mexer em números | [balanceamento global v1.0](docs/06_balance/v1/README.md) |
| Quem procura onde algo mora | [estrutura do repositório](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md) |

## Estrutura

```text
data/        valores que o jogo carrega          docs/        design por área (00_project … 09_ui, art)
scenes/      cenas Godot                         documents/   guias-base e fontes DOCX
scripts/     GDScript do jogo                    arquivados/  histórico e trabalho concluído
assets/      sprites e UI usados pelo jogo       tools/       ferramentas (Argos, balance, docs, arte, Android)
tests/unit/  testes Godot
```

Regras de onde criar cada tipo de arquivo: [ESTRUTURA_DO_REPOSITORIO](docs/00_project/ESTRUTURA_DO_REPOSITORIO.md).

## Índices

- [`docs/INDEX.md`](docs/INDEX.md) — documentação de design por área.
- [`docs/CONTENT_REGISTRY.md`](docs/CONTENT_REGISTRY.md) — IDs e roteamento dos catálogos.
- [`documents/INDEX.md`](documents/INDEX.md) — guias completos e fontes originais.
- [`arquivados/INDEX.md`](arquivados/INDEX.md) — histórico.
- [`CHANGELOG.md`](CHANGELOG.md) — mudanças estruturais.

## Verificação

```text
python tools/run_godot_tests.py                      # testes Godot (headless)
python tools/balance/validate_balance_data.py        # dados de balanceamento
python tools/argos/run.py --scenario slice_quick     # simulação rápida (Argos)
python tools/argos/run.py --scenario slice_balance   # matriz de balanceamento do Capítulo 1
python tools/docs/check_links.py --orphans           # links, âncoras e documentos órfãos
```

O **Argos** é o playtester automático: roda expedições no Godot sem interface, verifica invariantes e gera um `REPORT.md`. Regras de uso: [`tools/argos/README.md`](tools/argos/README.md). Simulação não é playtest; os números continuam **HIPÓTESE** até playtest e telemetria.

Evidência atual (testes, validador, último Argos): seção 1 do [`ROADMAP.md`](ROADMAP.md).
