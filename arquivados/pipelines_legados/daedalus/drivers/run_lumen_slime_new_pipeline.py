"""
Script do Novo Pipeline (V2) para o Slime de Lumen:
1. Gera 4 conceitos em ~512x512 (A, B, C, D)
2. Permite selecionar a Master Reference (ou seleciona a melhor com base em silhouette e clareza)
3. Converte via SpriteFusion Pixel Snapper e PixelGridHelpers:
   - Compara 16, 20 e 24 cores
   - Snap para grid 48x48
   - Remocao de fundo com hard alpha
4. Executa Silhouette Test e Native Size Test (1x, 2x, 4x)
5. Executa acabamento cirurgico no Aseprite
6. Gera Idle Frame 1 e Idle Frame 2 com a mesma Master Reference
"""

import os
import sys
import json
import time
from PIL import Image, ImageDraw, ImageOps
import numpy as np

sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "slime_pipeline_v2")
os.makedirs(BUILD_DIR, exist_ok=True)

PROMPT_BASE = (
    "2D side-view fantasy game character, clean iconic silhouette, compact proportions, "
    "strong readable shapes, limited details, clear separation between head torso arms legs and weapon, "
    "animation-friendly design, polished indie game asset, plain isolated background"
)

CHARACTER_PROMPT = (
    "a cute glowing magical bioluminescent slime creature, round blob body, big expressive bright eye highlights, "
    "translucent cyan jelly, glowing core nucleus, side view facing LEFT, solid white background"
)

PIXEL_STYLE = (
    "intentional handcrafted pixel art, clean pixel clusters, hard edges, hard shading, "
    "limited palette, selective one-pixel outline, no antialiasing, no smooth gradients, no subpixel details"
)

FULL_POSITIVE_PROMPT = f"{PROMPT_BASE}, {CHARACTER_PROMPT}, {PIXEL_STYLE}"

NEGATIVE_PROMPT = (
    "blurry, antialiasing, smooth edges, painterly, photorealistic, 3D render, soft shading, "
    "gradient, excessive detail, micro details, noisy pixels, random pixels, muddy colors, "
    "weak silhouette, inconsistent outline, malformed weapon, extra limbs, design drift, "
    "text, watermark, background scenery, realistic"
)

# Paleta canonica Lumen (docs/art/PALETTE.md)
LUMEN_PALETTE_HEX = [
    "#061114", "#0c2229", "#14444d", "#1f7580", "#279499",
    "#32b2a6", "#4ed2b8", "#67f0cc", "#9effe3", "#d4fffa", "#ffffff"
]

def build_concept_workflow(seed, prompt_text, neg_text, filename_prefix):
    return {
        "3": {
            "inputs": {
                "seed": seed,
                "steps": 4,
                "cfg": 1.6,
                "sampler_name": "euler",
                "scheduler": "sgm_uniform",
                "denoise": 1.0,
                "model": ["4", 0],
                "positive": ["6", 0],
                "negative": ["7", 0],
                "latent_image": ["5", 0]
            },
            "class_type": "KSampler"
        },
        "4": {
            "inputs": {
                "ckpt_name": "sdxl_lightning_4step.safetensors"
            },
            "class_type": "CheckpointLoaderSimple"
        },
        "5": {
            "inputs": {
                "width": 512,
                "height": 512,
                "batch_size": 1
            },
            "class_type": "EmptyLatentImage"
        },
        "6": {
            "inputs": {
                "text": prompt_text,
                "clip": ["4", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "7": {
            "inputs": {
                "text": neg_text,
                "clip": ["4", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "8": {
            "inputs": {
                "samples": ["3", 0],
                "vae": ["4", 2]
            },
            "class_type": "VAEDecode"
        },
        "9": {
            "inputs": {
                "filename_prefix": filename_prefix,
                "images": ["8", 0]
            },
            "class_type": "SaveImage"
        }
    }

def main():
    client = ComfyClient()
    print("=== [1/6] Verificando conexao com ComfyUI ===")
    if not client.check_health():
        print("ERRO: ComfyUI nao acessivel!")
        sys.exit(1)
    print("ComfyUI ONLINE.")

    # Gerar 4 alternativas A/B/C/D
    alternatives = [
        {"id": "A", "seed": 401},
        {"id": "B", "seed": 402},
        {"id": "C", "seed": 403},
        {"id": "D", "seed": 404},
    ]

    concept_paths = {}
    print("\n=== [2/6] Gerando 4 conceitos em 512x512 (A, B, C, D) ===")
    for alt in alternatives:
        alt_id = alt["id"]
        seed = alt["seed"]
        prefix = f"slime_concept_512_{alt_id}"
        dest_path = os.path.join(BUILD_DIR, f"{prefix}.png")
        if os.path.exists(dest_path):
            print(f"  Alternativa {alt_id} ja existe em cache: {dest_path}")
            concept_paths[alt_id] = dest_path
            continue

        print(f"  Gerando Alternativa {alt_id} (seed={seed})...")
        wf = build_concept_workflow(seed, FULL_POSITIVE_PROMPT, NEGATIVE_PROMPT, prefix)
        t0 = time.time()
        res = client.queue_prompt(wf, client_id=f"slime_concept_{alt_id}")
        prompt_id = res.get("prompt_id")
        history = client.wait_for_completion(prompt_id, timeout_sec=300, poll_interval=2.0)
        dt = round(time.time() - t0, 1)
        print(f"    Concluido em {dt}s!")

        outputs = history.get("outputs", {})
        node_9_images = outputs.get("9", {}).get("images", [])
        if node_9_images:
            fn = node_9_images[0]["filename"]
            sub = node_9_images[0].get("subfolder", "")
            client.download_image(fn, subfolder=sub, dest_path=dest_path)
            concept_paths[alt_id] = dest_path
            print(f"    Salvo: {dest_path}")

    print("\nConceitos gerados com sucesso:")
    for k, v in concept_paths.items():
        print(f"  [{k}] {v}")

if __name__ == "__main__":
    main()
