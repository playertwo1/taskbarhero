"""
Script utilitario para download autenticado/otimizado de modelos aprovados do Hugging Face.
Salva diretamente no diretorio de checkpoints compartilhado do ComfyUI.
"""

import os
import sys
from huggingface_hub import hf_hub_download

CHECKPOINTS_DIR = r"C:\Users\notefael\AppData\Local\Comfy-Desktop\ComfyUI-Shared\models\checkpoints"

def download_sdxl_lightning():
    repo_id = "ByteDance/SDXL-Lightning"
    filename = "sdxl_lightning_4step.safetensors"
    print(f"[Download] Iniciando download de {repo_id}/{filename}...")
    print(f"[Download] Destino: {CHECKPOINTS_DIR}")
    
    os.makedirs(CHECKPOINTS_DIR, exist_ok=True)
    file_path = hf_hub_download(
        repo_id=repo_id,
        filename=filename,
        local_dir=CHECKPOINTS_DIR,
        local_dir_use_symlinks=False
    )
    print(f"[Download] Concluido com sucesso: {file_path}")
    print(f"[Download] Tamanho: {os.path.getsize(file_path)} bytes")

if __name__ == "__main__":
    download_sdxl_lightning()
