"""
Script de teste de fumaca automatizado para o pipeline ComfyUI / Daedalus.
Executa o workflow pixel_quantize_api.json, valida resposta da API e download do asset gerado.
"""

import os
import sys
import json
from PIL import Image

# Importar o driver ComfyClient
sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

def run_smoke_test():
    client = ComfyClient()
    print("[1/5] Verificando conexao com o servidor ComfyUI...")
    if not client.check_health():
        print("FALHA: Servidor ComfyUI nao esta acessivel em http://127.0.0.1:8188")
        return False
    print("      PASS: ComfyUI esta ONLINE e respondendo.")

    workflow_path = os.path.join(os.path.dirname(__file__), "..", "workflows", "pixel_quantize_api.json")
    print(f"[2/5] Carregando workflow: {workflow_path}")
    with open(workflow_path, "r", encoding="utf-8") as f:
        workflow = json.load(f)

    print("[3/5] Enfileirando prompt via API /prompt...")
    res = client.queue_prompt(workflow, client_id="daedalus_smoke_test")
    prompt_id = res.get("prompt_id")
    if not prompt_id:
        print(f"FALHA: Nao foi possivel obter prompt_id. Resposta: {res}")
        return False
    print(f"      PASS: Prompt enfileirado com sucesso (prompt_id: {prompt_id}).")

    print("[4/5] Aguardando execucao e consultando /history...")
    history = client.wait_for_completion(prompt_id, timeout_sec=60)
    print("      PASS: Execucao concluida pelo servidor ComfyUI.")

    outputs = history.get("outputs", {})
    save_node_output = outputs.get("4", {})
    images = save_node_output.get("images", [])
    if not images:
        print(f"FALHA: Nenhum arquivo de saida encontrado no historico: {history}")
        return False

    out_image_info = images[0]
    filename = out_image_info["filename"]
    subfolder = out_image_info.get("subfolder", "")
    print(f"      Arquivo gerado: {filename} (subfolder: '{subfolder}')")

    out_dir = os.path.join(os.path.dirname(__file__), "..", "..", "..", "build")
    os.makedirs(out_dir, exist_ok=True)
    dest_path = os.path.join(out_dir, "comfy_smoke_slime_48.png")

    print(f"[5/5] Baixando asset gerado para {dest_path} e auditando...")
    client.download_image(filename, subfolder=subfolder, dest_path=dest_path)

    if not os.path.exists(dest_path):
        print(f"FALHA: Arquivo nao encontrado em {dest_path}")
        return False

    with Image.open(dest_path) as img:
        width, height = img.size
        colors = img.getcolors(maxcolors=256)
        num_colors = len(colors) if colors else 0

        print(f"      Dimensoes: {width}x{height} (Esperado: 48x48)")
        print(f"      Numero de cores unicas: {num_colors}")

        if (width, height) != (48, 48):
            print(f"FALHA: Resolucao incorreta {width}x{height}")
            return False

        if num_colors > 16:
            print(f"FALHA: Muitas cores para o padrao de pixel art ({num_colors} > 16)")
            return False

    print("\n=======================================================")
    print("VEREDITO COMFY-00: PASS (Pipeline ComfyUI 100% Operacional!)")
    print("=======================================================")
    return True

if __name__ == "__main__":
    success = run_smoke_test()
    sys.exit(0 if success else 1)
