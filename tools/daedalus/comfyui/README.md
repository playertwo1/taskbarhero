# ComfyUI Tooling — Daedalus Generative Engine

Este diretório contém os scripts, drivers e grafos de automação do **ComfyUI**, utilizado pelo agente **Daedalus** como motor generativo principal de sprites, conceitos e variações para o **Pocket Hero**.

---

## Estrutura do Diretório

```text
tools/daedalus/comfyui/
├── README.md               # Este guia
├── configs/                # Arquivos de configuração local do ComfyUI
├── drivers/                # Clientes Python/Node para disparo de jobs via API
│   └── comfy_client.py     # Driver REST/WebSocket para /prompt, /history e outputs
├── manifests/              # Catálogo de modelos e seeds de geração
│   └── models.yaml         # Manifesto com licenças e hashes
└── workflows/              # Grafos ComfyUI exportados no formato API JSON
    ├── character_concept_api.json   # Conceito inicial de personagem
    ├── enemy_variant_api.json       # Variações e paletas de inimigos
    ├── pose_frame_api.json          # Geração frame a frame com OpenPose ControlNet
    ├── background_remove_api.json   # Extração de transparência alpha pura
    ├── pixelize_api.json            # Quantização e alinhamento de grid
    └── spritesheet_api.json         # Montagem preliminar de fita de animação
```

---

## Como Operar a API Local

O ComfyUI opera por padrão na porta `http://127.0.0.1:8188`.
Para enfileirar um job via terminal sem interação visual:

```bash
python tools/daedalus/comfyui/drivers/comfy_client.py --workflow tools/daedalus/comfyui/workflows/character_concept_api.json --prompt "slime luminescente, dark fantasy, pixel art"
```

O cliente monitora o endpoint `/history`, faz o download do resultado gerado na pasta de saída e o envia para a bancada técnica do Aseprite (`pixel-mcp`).
