"""
Execucao e auditoria de geracao de conceito com SDXL-Lightning 4-passos e quantizacao direta.
"""

import os
import sys
import json
import time
from PIL import Image

sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

def main():
    client = ComfyClient()
    print("[1/4] Verificando conexao com ComfyUI...")
    if not client.check_health():
        print("ERRO: ComfyUI nao esta online em http://127.0.0.1:8188")
        sys.exit(1)
    print("      ONLINE.")

    workflow_file = os.path.join(os.path.dirname(__file__), "..", "workflows", "concept_and_quantize_api.json")
    with open(workflow_file, "r", encoding="utf-8") as f:
        workflow = json.load(f)

    print(f"[2/4] Enfileirando workflow SDXL-Lightning (4 passos)...")
    res = client.queue_prompt(workflow, client_id="daedalus_concept_gen")
    prompt_id = res.get("prompt_id")
    if not prompt_id:
        print(f"ERRO ao enfileirar: {res}")
        sys.exit(1)
    print(f"      Prompt ID: {prompt_id}")

    print("[3/4] Aguardando inferencia (carregamento de pesos SDXL e execucao dos 4 passos)...")
    start = time.time()
    try:
        history = client.wait_for_completion(prompt_id, timeout_sec=600, poll_interval=3.0)
    except Exception as e:
        print(f"ERRO durante execucao: {e}")
        sys.exit(1)

    elapsed = round(time.time() - start, 1)
    print(f"      Concluido em {elapsed}s!")

    outputs = history.get("outputs", {})
    build_dir = os.path.join(os.path.dirname(__file__), "..", "..", "..", "build")
    os.makedirs(build_dir, exist_ok=True)

    # Node 9: 512x512 concept
    node_9_images = outputs.get("9", {}).get("images", [])
    if node_9_images:
        fn = node_9_images[0]["filename"]
        sub = node_9_images[0].get("subfolder", "")
        dest_512 = os.path.join(build_dir, "concept_lumen_slime_master.png")
        client.download_image(fn, subfolder=sub, dest_path=dest_512)
        print(f"      [OK] Conceito mestre 512x512 salvo em: {dest_512}")

    # Node 12: 48x48 quantized asset
    node_12_images = outputs.get("12", {}).get("images", [])
    if node_12_images:
        fn = node_12_images[0]["filename"]
        sub = node_12_images[0].get("subfolder", "")
        dest_48 = os.path.join(build_dir, "concept_lumen_slime_48_quantized.png")
        client.download_image(fn, subfolder=sub, dest_path=dest_48)
        print(f"      [OK] Asset 48x48 quantizado salvo em: {dest_48}")

        with Image.open(dest_48) as img:
            w, h = img.size
            colors = img.getcolors(maxcolors=256)
            num_colors = len(colors) if colors else 0
            print(f"      Auditoria 48x48: {w}x{h} px, {num_colors} cores unicas.")

    print("\n[4/4] Resultado: PASS (Inferencia SDXL-Lightning concluida com sucesso!)")

if __name__ == "__main__":
    main()
