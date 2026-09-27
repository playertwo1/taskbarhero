# Registro de Modelos, Checkpoints e Licenças de IA

> **Regra de Governança:** Nenhum modelo, LoRA ou nó customizado pode ser utilizado no pipeline do Pocket Hero sem ter sua licença de uso comercial, restrições de redistribuição e hash SHA-256 devidamente documentados neste arquivo e aprovados por Rafael.

---

## 1. Manifesto de Modelos e Adaptadores

```yaml
models:
  - id: sdxl_lightning_4step
    purpose: Gerador ultrarrápido (4 passos) de conceitos de personagens e variações de pose para CPU e GPU.
    source: "https://huggingface.co/ByteDance/SDXL-Lightning"
    license: "CreativeML OpenRAIL++-M"
    commercial_use: "yes"
    redistribution: "yes"
    filename: "sdxl_lightning_4step.safetensors"
    sha256: "e0d996ee0013e79d9d3561f50fcafb9a17e3ff07b780358e3b66d67932c4d490"
    approved: true

  - id: sd_xl_base_1.0
    purpose: Gerador base de conceitos e referências de personagens em alta definição.
    source: "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0"
    license: "CreativeML OpenRAIL++-M"
    commercial_use: "yes (com restrições OpenRAIL de uso ético)"
    redistribution: "yes"
    filename: "sd_xl_base_1.0.safetensors"
    sha256: "31e35c80fc4829d14f90153f40f6701b7a2d4b8e8f85f52eb4089947"
    approved: true

  - id: pixel_art_xl_lora
    purpose: LoRA de estilo de pixel art refinado para SDXL.
    source: "https://civitai.com/models/120096/pixel-art-xl"
    license: "Permissive AI Generative / CivitAI Commercial Allowed"
    commercial_use: "yes"
    redistribution: "yes"
    filename: "pixel-art-xl.safetensors"
    sha256: "pendente_download"
    approved: false

  - id: controlnet_openpose_xl
    purpose: Condicionamento de pose frame a frame por esqueleto 2D para sprites.
    source: "https://huggingface.co/thibaud/controlnet-openpose-sdxl-1.0"
    license: "Apache-2.0"
    commercial_use: "yes"
    redistribution: "yes"
    filename: "control-lora-openposeXL2-rank256.safetensors"
    sha256: "pendente_download"
    approved: false

  - id: ip_adapter_plus_sdxl
    purpose: Reference conditioning para preservar identidade do herói e inimigo entre poses.
    source: "https://huggingface.co/h94/IP-Adapter"
    license: "Apache-2.0"
    commercial_use: "yes"
    redistribution: "yes"
    filename: "ip-adapter-plus_sdxl_vit-h.safetensors"
    sha256: "pendente_download"
    approved: false

  - id: birefnet_general
    purpose: Segmentação de alta resolução para remoção de fundo e extração de canal alpha puro.
    source: "https://huggingface.co/ZhengPeng7/BiRefNet"
    license: "MIT"
    commercial_use: "yes"
    redistribution: "yes"
    filename: "BiRefNet-general-epoch_244.pth"
    sha256: "pendente_download"
    approved: false
```

---

## 2. Política de Não Versionamento de Binários Pesados

* **Checkpoints e pesos de modelos (.safetensors, .pth, .ckpt) JAMAIS são comitados no repositório Git.**
* Todos os diretórios de modelos são ignorados via `.gitignore`:
  ```gitignore
  # Modelos de IA e caches
  tools/daedalus/comfyui/models/
  tools/daedalus/comfyui/custom_nodes/
  tools/daedalus/comfyui/output/
  tools/daedalus/comfyui/input/
  *.safetensors
  *.ckpt
  *.pth
  *.bin
  ```
* Apenas os arquivos de manifesto (`models.yaml`), receitas (`prompts/`) e grafos de execução (`workflows/*_api.json`) são mantidos sob controle de versão.
