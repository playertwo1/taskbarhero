"""
Driver para Geração dos Conceitos 512x512 do Lobo Alfa de Lúmen (Etapa 1 do Novo Pipeline V2).
Gera 4 alternativas (A, B, C, D) no ComfyUI, salva os conceitos, gera teste de silhueta e cria o lineup A/B/C/D.
"""

import os
import sys
import time
import numpy as np
from PIL import Image, ImageDraw, ImageOps

sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "lobo_pipeline_v2")
os.makedirs(BUILD_DIR, exist_ok=True)

PROMPT_BASE = (
    "2D side-view fantasy game character, clean iconic silhouette, compact proportions, "
    "strong readable shapes, limited details, clear separation between head torso arms legs and weapon, "
    "animation-friendly design, polished indie game asset, plain isolated background"
)

CHARACTER_PROMPT = (
    "imposing ancient apex predator wolf beast, quadruped creature, deep muscular chest, "
    "high glowing bioluminescent lumen mane crest on neck and shoulders, glowing emerald eyes, "
    "dark slate pelt with glowing lumen runic markings, strong legs and paws, ivory fangs, "
    "full body side view facing LEFT, solid white background"
)

PIXEL_STYLE = (
    "intentional handcrafted pixel art, clean pixel clusters, hard edges, hard shading, "
    "limited palette, selective one-pixel outline, no antialiasing, no smooth gradients, no subpixel details"
)

FULL_POSITIVE_PROMPT = f"{PROMPT_BASE}, {CHARACTER_PROMPT}, {PIXEL_STYLE}"

NEGATIVE_PROMPT = (
    "blurry, antialiasing, smooth edges, painterly, photorealistic, 3D render, soft shading, "
    "gradient, excessive detail, micro details, noisy pixels, random pixels, muddy colors, "
    "weak silhouette, inconsistent outline, extra limbs, design drift, front view, human, "
    "two legs, biped, scenery, ground, grass, text, watermark, realistic"
)

def build_workflow(seed: int, filename_prefix: str) -> dict:
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
                "text": FULL_POSITIVE_PROMPT,
                "clip": ["4", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "7": {
            "inputs": {
                "text": NEGATIVE_PROMPT,
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

def extract_silhouette(img_path: str) -> Image.Image:
    """Extrai uma silhueta binária para teste de forma."""
    img = Image.open(img_path).convert("RGB")
    arr = np.array(img)
    # Fundo branco/claro
    is_bg = (arr[:, :, 0] > 230) & (arr[:, :, 1] > 230) & (arr[:, :, 2] > 230)
    sil = np.full((512, 512, 3), 255, dtype=np.uint8)
    sil[~is_bg] = [15, 25, 35] # silhueta escura
    return Image.fromarray(sil)

def main():
    client = ComfyClient()
    print("=== [1/3] Verificando conexao com ComfyUI ===")
    if not client.check_health():
        print("ERRO: ComfyUI nao acessivel!")
        sys.exit(1)
    print("ComfyUI ONLINE.")

    alternatives = [
        {"id": "A", "seed": 601},
        {"id": "B", "seed": 602},
        {"id": "C", "seed": 603},
        {"id": "D", "seed": 604},
    ]

    concept_paths = {}
    print("\n=== [2/3] Gerando 4 conceitos em 512x512 para o Lobo Alfa (A, B, C, D) ===")
    for alt in alternatives:
        alt_id = alt["id"]
        seed = alt["seed"]
        prefix = f"lobo_concept_512_{alt_id}"
        dest_path = os.path.join(BUILD_DIR, f"{prefix}.png")
        if os.path.exists(dest_path):
            print(f"  Alternativa {alt_id} ja existe: {dest_path}")
            concept_paths[alt_id] = dest_path
            continue

        print(f"  Gerando Alternativa {alt_id} (seed={seed})...")
        wf = build_workflow(seed, prefix)
        t0 = time.time()
        res = client.queue_prompt(wf, client_id=f"lobo_concept_{alt_id}")
        prompt_id = res.get("prompt_id")
        history = client.wait_for_completion(prompt_id, timeout_sec=180, poll_interval=1.5)
        dt = round(time.time() - t0, 1)
        print(f"    Concluido em {dt}s!")

        outputs = history.get("outputs", {})
        node_9_images = outputs.get("9", {}).get("images", [])
        if node_9_images:
            fn = node_9_images[0]["filename"]
            sub = node_9_images[0].get("subfolder", "")
            client.download_image(fn, subfolder=sub, dest_path=dest_path)
            concept_paths[alt_id] = dest_path
            print(f"    Salvo em: {dest_path}")

    print("\n=== [3/3] Criando Lineup Comparativo A/B/C/D com Silhuetas ===")
    # Montar lineup: 4 colunas de 512x512 (conceito em cima, silhueta embaixo)
    thumb_w, thumb_h = 256, 256
    lineup_w = thumb_w * 4 + 50
    lineup_h = thumb_h * 2 + 100
    lineup = Image.new("RGB", (lineup_w, lineup_h), (20, 24, 30))
    draw = ImageDraw.Draw(lineup)

    for i, alt in enumerate(alternatives):
        alt_id = alt["id"]
        cp = concept_paths[alt_id]
        img = Image.open(cp).resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        sil = extract_silhouette(cp).resize((thumb_w, thumb_h), Image.Resampling.NEAREST)

        x = 10 + i * (thumb_w + 10)
        y_top = 40
        y_bot = y_top + thumb_h + 30

        lineup.paste(img, (x, y_top))
        lineup.paste(sil, (x, y_bot))

        draw.text((x + 10, y_top - 25), f"Opcao {alt_id} (Seed {alt['seed']})", fill=(180, 230, 200))
        draw.text((x + 10, y_bot - 20), f"Silhueta {alt_id}", fill=(140, 170, 180))

    lineup_path = os.path.join(BUILD_DIR, "lobo_concepts_ABCD_lineup.png")
    lineup.save(lineup_path)
    print(f"Lineup salvo em: {lineup_path}")

if __name__ == "__main__":
    main()
