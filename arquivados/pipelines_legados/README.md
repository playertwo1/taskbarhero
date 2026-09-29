# Pipelines legados de sprites

Scripts e workflows que produziram sprites e prévias anteriores aos Golden `v002`. Foram movidos de `scripts/art/` e `tools/daedalus/` em 2026-09-29 para tirar do caminho ativo código que o [`AGENTS.md`](../../AGENTS.md) proíbe executar para o MVP (`build_styled_*`, `generate_*`, `build_comfy_anim.py` e similares).

**Não execute.** Caminhos internos e imports não foram ajustados após a mudança; os arquivos existem só como registro de linhagem citado em auditorias antigas. Para produção atual siga [`docs/art/golden/README.md`](../../docs/art/golden/README.md), os contratos e [`docs/art/MVP_SPRITE_INVENTORY.md`](../../docs/art/MVP_SPRITE_INVENTORY.md).

- `scripts_art/` — geradores de folhas, ícones, contratos de skill e cenas de entidade do MVP.
- `daedalus/drivers/` e `daedalus/workflows/` — drivers e workflows ComfyUI por entidade. A infraestrutura genérica (`comfy_client.py`, workflows `character_*`/`pixel_quantize`) continua em `tools/daedalus/comfyui/`.
- `daedalus/previews/` — geradores de prévias HTML/PNG de party, roster e cenário.
