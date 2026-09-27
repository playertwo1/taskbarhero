"""
ComfyUI API Client Driver para o Agente Daedalus.
Permite executar workflows JSON sem necessidade de interface grafica.
"""

import json
import urllib.request
import urllib.parse
import time
import sys
import os

DEFAULT_SERVER = "http://127.0.0.1:8188"

class ComfyClient:
    def __init__(self, server_address=DEFAULT_SERVER):
        self.server = server_address.rstrip('/')

    def check_health(self) -> bool:
        """Verifica se o servidor ComfyUI esta online e respondendo."""
        try:
            req = urllib.request.Request(f"{self.server}/system_stats")
            with urllib.request.urlopen(req, timeout=3) as response:
                return response.status == 200
        except Exception:
            return False

    def queue_prompt(self, workflow_dict: dict, client_id: str = "daedalus_agent") -> dict:
        """Enfileira um workflow para execucao no ComfyUI."""
        payload = {
            "prompt": workflow_dict,
            "client_id": client_id
        }
        data = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(f"{self.server}/prompt", data=data, headers={'Content-Type': 'application/json'})
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))

    def get_history(self, prompt_id: str) -> dict:
        """Consulta o historico de execucao de um prompt ID."""
        req = urllib.request.Request(f"{self.server}/history/{prompt_id}")
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))

    def wait_for_completion(self, prompt_id: str, timeout_sec: int = 180, poll_interval: float = 1.0) -> dict:
        """Aguarda a conclusao da execucao de um prompt e retorna os dados de saida."""
        start = time.time()
        while time.time() - start < timeout_sec:
            history = self.get_history(prompt_id)
            if prompt_id in history:
                return history[prompt_id]
            time.sleep(poll_interval)
        raise TimeoutError(f"Execucao do prompt {prompt_id} excedeu o tempo limite de {timeout_sec}s.")

    def download_image(self, filename: str, subfolder: str = "", folder_type: str = "output", dest_path: str = ""):
        """Baixa um arquivo de imagem gerado pelo ComfyUI."""
        params = urllib.parse.urlencode({
            "filename": filename,
            "subfolder": subfolder,
            "type": folder_type
        })
        url = f"{self.server}/view?{params}"
        urllib.request.urlretrieve(url, dest_path)

if __name__ == "__main__":
    client = ComfyClient()
    online = client.check_health()
    print(f"[ComfyClient] Servidor em {DEFAULT_SERVER}: {'ONLINE' if online else 'OFFLINE'}")
    if not online:
        print("[INFO] Para iniciar o ComfyUI localmente: consulte docs/art/COMFY_PIPELINE.md")
