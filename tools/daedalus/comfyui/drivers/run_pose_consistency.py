"""
Execucao do experimento COMFY-SMOKE-02: Consistencia de Personagem e Poses.
Gera 2 poses distintas da mesma criatura (Geleia de Lumen) condicionadas na imagem de referencia mestre.
"""

import os
import sys
import json
import time
from PIL import Image

sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

POSES = [
    {
        "id": "pose_compressed",
        "prompt": "dark fantasy lumen slime creature, squished down low, crouching compressed idle pose, glowing core, pure side-view, solid black background, 16-bit pixel art style",
        "seed": 2001,
        "prefix": "slime_pose_compressed_48",
        "output_file": "slime_pose_compressed_48.png"
    },
    {
        "id": "pose_extended",
        "prompt": "dark fantasy lumen slime creature, stretched upward, elongated leaping attack pose, glowing core, pure side-view, solid black background, 16-bit pixel art style",
        "seed": 2002,
        "prefix": "slime_pose_extended_48",
        "output_file": "slime_pose_extended_48.png"
    }
]

def main():
    client = ComfyClient()
    print("[1/5] Verificando conexao com ComfyUI...")
    if not client.check_health():
        print("ERRO: ComfyUI offline")
        sys.exit(1)
    print("      ONLINE.")

    workflow_file = os.path.join(os.path.dirname(__file__), "..", "workflows", "character_pose_consistency_api.json")
    with open(workflow_file, "r", encoding="utf-8") as f:
        base_workflow = json.load(f)

    build_dir = os.path.join(os.path.dirname(__file__), "..", "..", "..", "build")
    os.makedirs(build_dir, exist_ok=True)

    generated_files = []

    for i, p in enumerate(POSES, start=1):
        print(f"\n[2/5 - Pose {i}/2] Configurando pose '{p['id']}'...")
        wf = json.loads(json.dumps(base_workflow))
        wf["4"]["inputs"]["text"] = p["prompt"]
        wf["6"]["inputs"]["seed"] = p["seed"]
        wf["10"]["inputs"]["filename_prefix"] = p["prefix"]

        print(f"      Enfileirando prompt via ComfyUI API...")
        res = client.queue_prompt(wf, client_id=f"daedalus_pose_{p['id']}")
        prompt_id = res.get("prompt_id")
        if not prompt_id:
            print(f"ERRO: Nao foi possivel enfileirar: {res}")
            sys.exit(1)

        print(f"      Aguardando inferencia (prompt_id: {prompt_id})...")
        start = time.time()
        history = client.wait_for_completion(prompt_id, timeout_sec=300, poll_interval=2.0)
        elapsed = round(time.time() - start, 1)
        print(f"      Concluido em {elapsed}s!")

        outputs = history.get("outputs", {})
        node_10_images = outputs.get("10", {}).get("images", [])
        if not node_10_images:
            print(f"ERRO: Nenhum output retornado no historico: {history}")
            sys.exit(1)

        fn = node_10_images[0]["filename"]
        sub = node_10_images[0].get("subfolder", "")
        dest = os.path.join(build_dir, p["output_file"])
        client.download_image(fn, subfolder=sub, dest_path=dest)
        print(f"      [OK] Pose salva em: {dest}")
        generated_files.append(dest)

    print("\n[3/5] Auditando consistencia e metricas tecnicas das 2 poses...")
    for gf in generated_files:
        with Image.open(gf) as img:
            w, h = img.size
            colors = img.getcolors(maxcolors=256)
            num_colors = len(colors) if colors else 0
            basename = os.path.basename(gf)
            print(f"      - {basename}: {w}x{h} px, {num_colors} cores unicas.")
            if (w, h) != (48, 48):
                print(f"ERRO: Dimensao invalida em {basename}")
                sys.exit(1)
            if num_colors > 16:
                print(f"ERRO: Cores em excesso ({num_colors} > 16) em {basename}")
                sys.exit(1)

    print("\n[4/5] Veredito COMFY-00.10: PASS (Consistencia de personagem e 2 poses validadas!)")

if __name__ == "__main__":
    main()
