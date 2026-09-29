"""
Pipeline de construcao do Mob Espirito de Raiz (FASE R11 - Passo 5.3):
1. Dispara o workflow ComfyUI espirito_concept_api.json para o conceito mestre.
2. Gera as variacoes de animacao (idle, attack, hit, death) no padrao 48x48 px, baseline Y=44, facing left.
3. Invoca o Aseprite CLI para empacotar em .aseprite, spritesheet PNG (768x48 px) e metadata JSON.
"""

import os
import sys
import json
import subprocess
from PIL import Image, ImageDraw
import numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
OUT_ENEMY_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "espirito_de_raiz")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "espirito_frames")

sys.path.append(os.path.dirname(__file__))
try:
    from comfy_client import ComfyClient
except ImportError:
    ComfyClient = None

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

C_WOOD_DEEP  = hex_to_rgb("#2e1f14")
C_WOOD_DARK  = hex_to_rgb("#543820")
C_WOOD_BASE  = hex_to_rgb("#8a5e35")
C_WOOD_LIGHT = hex_to_rgb("#bf8c56")

C_LUM_DEEP   = hex_to_rgb("#0b2920")
C_LUM_DARK   = hex_to_rgb("#14533d")
C_LUM_BASE   = hex_to_rgb("#1db97a")
C_LUM_LIGHT  = hex_to_rgb("#5eedaa")
C_LUM_SPEC   = hex_to_rgb("#c4ffea")

ALL_COLORS = [
    (0, 0, 0, 0),
    (*C_WOOD_DEEP, 255), (*C_WOOD_DARK, 255), (*C_WOOD_BASE, 255), (*C_WOOD_LIGHT, 255),
    (*C_LUM_DEEP, 255), (*C_LUM_DARK, 255), (*C_LUM_BASE, 255), (*C_LUM_LIGHT, 255), (*C_LUM_SPEC, 255),
]

def draw_espirito_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Espirito de Raiz no grid 48x48.
    Baseline do chao: Y=44. Facing: Left.
    Entidade vegetal ancestral com raízes retorcidas, flutuando, núcleo de Lúmen no centro.
    """
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    bob_y = 0
    whip_x = 0
    whip_attack = False
    recoil_x = 0
    collapse_y = 0
    dither_level = 0

    if action == "idle":
        bobs = [0, -1, -2, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        if step == 0:
            bob_y = 0
            whip_x = 2
        elif step == 1:
            bob_y = -1
            whip_x = -3
            whip_attack = True
        elif step == 2:
            bob_y = -2
            whip_x = -7
            whip_attack = True
        elif step == 3:
            bob_y = -1
            whip_x = -2
    elif action == "hit":
        bob_y = 1
        recoil_x = 4 if step == 0 else 2
    elif action == "death":
        collapse_y = step * 3
        dither_level = step

    by = min(46, 44 + bob_y + collapse_y)
    bx = 24 + whip_x + recoil_x

    if dither_level >= 5:
        by = 46

    # 1. Raízes Rastejantes Inferiores (Y: by-12 ate by)
    if dither_level < 5:
        # Raiz traseira
        d.line([(bx + 4, by - 12), (bx + 8, by - 6), (bx + 11, by - 1)], fill=C_WOOD_DARK, width=2)
        d.point([(bx + 12, by)], fill=C_WOOD_DEEP)
        # Raiz central
        d.line([(bx, by - 12), (bx + 1, by - 5), (bx - 2, by)], fill=C_WOOD_BASE, width=2)
        # Raiz frontal (esquerda)
        d.line([(bx - 4, by - 12), (bx - 7, by - 6), (bx - 10, by - 1)], fill=C_WOOD_DARK, width=2)
        d.point([(bx - 11, by)], fill=C_WOOD_DEEP)

    # 2. Casca e Tronco Retorcido (Y: by-28 ate by-12)
    if dither_level < 4:
        d.rectangle([bx - 6, by - 26, bx + 6, by - 12], fill=C_WOOD_DARK)
        d.rectangle([bx - 4, by - 24, bx + 4, by - 14], fill=C_WOOD_BASE)
        # Sulcos de casca ancestral
        d.line([(bx - 2, by - 26), (bx - 2, by - 14)], fill=C_WOOD_DEEP, width=1)
        d.line([(bx + 3, by - 24), (bx + 3, by - 13)], fill=C_WOOD_DEEP, width=1)

    # 3. Núcleo Bioluminescente de Lúmen no Peito (X: bx-2 a bx+2, Y: by-22 a by-18)
    if dither_level < 3:
        pulse = 1 if (step % 2 == 1) else 0
        d.ellipse([bx - 3 - pulse, by - 23 - pulse, bx + 3 + pulse, by - 17 + pulse], fill=C_LUM_BASE)
        d.ellipse([bx - 2, by - 22, bx + 2, by - 18], fill=C_LUM_LIGHT)
        d.point([(bx, by - 20)], fill=C_LUM_SPEC)

    # 4. Galhos Superiores e Cabeça Feral (Y: by-38 ate by-26)
    if dither_level < 3:
        # Chifres/galhos de raiz se elevando
        d.line([(bx - 3, by - 28), (bx - 7, by - 35), (bx - 9, by - 38)], fill=C_WOOD_BASE, width=2)
        d.point([(bx - 9, by - 38)], fill=C_WOOD_LIGHT)
        d.line([(bx + 3, by - 28), (bx + 6, by - 34), (bx + 8, by - 37)], fill=C_WOOD_DARK, width=2)
        d.point([(bx + 8, by - 37)], fill=C_WOOD_BASE)
        # Cabeça / Máscara de casca
        d.rectangle([bx - 5, by - 32, bx + 2, by - 26], fill=C_WOOD_DARK)
        d.rectangle([bx - 4, by - 31, bx, by - 27], fill=C_WOOD_BASE)
        # Olho de Lúmen cintilante olhando para a esquerda
        d.point([(bx - 3, by - 29)], fill=C_LUM_SPEC)
        d.point([(bx - 2, by - 29)], fill=C_LUM_LIGHT)

    # 5. Chicote de Raízes e Disparo de Lúmen no Ataque
    if whip_attack and dither_level < 4:
        # Raiz frontal chicoteando para a esquerda
        d.line([(bx - 6, by - 20), (bx - 14, by - 20), (bx - 18, by - 22)], fill=C_WOOD_LIGHT, width=2)
        # Espinhos mágicos de Lúmen disparados
        d.line([(bx - 19, by - 22), (bx - 23, by - 22)], fill=C_LUM_SPEC, width=1)
        d.point([(bx - 16, by - 24), (bx - 16, by - 20)], fill=C_LUM_LIGHT)

    # 6. Efeito Dither de Dissolucao
    if dither_level > 0:
        pixels = img.load()
        w, h = img.size
        for y in range(h):
            for x in range(w):
                if pixels[x, y][3] > 0:
                    if dither_level == 1:
                        if (x + y) % 6 == 0:
                            pixels[x, y] = (0, 0, 0, 0)
                    elif dither_level == 2:
                        if (x + y) % 4 == 0:
                            pixels[x, y] = (0, 0, 0, 0)
                    elif dither_level == 3:
                        if (x + y) % 2 == 0:
                            pixels[x, y] = (0, 0, 0, 0)
                    elif dither_level == 4:
                        if (x % 2 == 0) or (y % 2 == 0):
                            pixels[x, y] = (0, 0, 0, 0)
                    elif dither_level >= 5:
                        if (x + y) % 2 == 0 or (x * y) % 3 != 0:
                            pixels[x, y] = (0, 0, 0, 0)

    # 7. Quantizacao estrita e alpha binario
    arr = np.array(img)
    alpha = arr[:, :, 3]
    binary_alpha = np.where(alpha > 127, 255, 0).astype(np.uint8)
    arr[:, :, 3] = binary_alpha

    palette_lut = np.array(ALL_COLORS, dtype=np.int32)
    rgb = arr[:, :, :3]
    h, w, _ = arr.shape
    flat_rgb = rgb.reshape(-1, 3)

    dists = np.sum((flat_rgb[:, None, :] - palette_lut[1:, :3][None, :, :]) ** 2, axis=2)
    nearest_indices = np.argmin(dists, axis=1) + 1

    quantized_rgba = palette_lut[nearest_indices].reshape(h, w, 4)
    quantized_rgba[:, :, 3] = binary_alpha

    return Image.fromarray(quantized_rgba.astype(np.uint8), "RGBA")

def main():
    print("================================================================================")
    print("--- CONSTRUCAO CANONICA DO MOB ESPIRITO DE RAIZ (FASE R11 - PASSO 5.3) ---")
    print("================================================================================")

    os.makedirs(OUT_ENEMY_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "espirito_concept_api.json")
            if os.path.exists(workflow_path):
                with open(workflow_path, "r", encoding="utf-8") as wf:
                    workflow_prompt = json.load(wf)
                res = client.queue_prompt(workflow_prompt)
                prompt_id = res.get("prompt_id")
                print(f"[PASS] Job enfileirado com prompt_id: {prompt_id}")
        else:
            print("[INFO] ComfyUI daemon offline, prosseguindo com geracao canonica.")

    frames_spec = [
        ("idle", 0), ("idle", 1), ("idle", 2), ("idle", 3),
        ("attack", 0), ("attack", 1), ("attack", 2), ("attack", 3),
        ("hit", 0), ("hit", 1),
        ("death", 0), ("death", 1), ("death", 2), ("death", 3), ("death", 4), ("death", 5)
    ]

    frame_paths = []
    print("\nGerando 16 quadros canonicos (48x48 px, baseline Y=44, facing left)...")
    for i, (anim, step) in enumerate(frames_spec):
        frame_img = draw_espirito_frame(action=anim, step=step)
        fname = f"espirito_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    ase_file = os.path.join(OUT_ENEMY_DIR, "mob_espirito_raiz.aseprite")
    sheet_png = os.path.join(OUT_ENEMY_DIR, "mob_espirito_raiz_sheet.png")
    sheet_json = os.path.join(OUT_ENEMY_DIR, "mob_espirito_raiz_sheet.json")

    print("\nInvocando Aseprite CLI para montagem da spritesheet canonica...")
    cmd = [
        ASEPRITE_BIN, "-b",
        *frame_paths,
        "--sheet-type", "horizontal",
        "--sheet", sheet_png,
        "--data", sheet_json,
        "--format", "json-array",
        "--save-as", ase_file
    ]

    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print("ERRO ao executar Aseprite:", res.stderr)
        sys.exit(1)

    print(f"[PASS] Arquivo fonte Aseprite gerado: {ase_file}")
    print(f"[PASS] Spritesheet PNG gerada: {sheet_png}")
    print(f"[PASS] Metadados JSON gerados: {sheet_json}")

    sheet_img = Image.open(sheet_png)
    w, h = sheet_img.size
    print(f"\n[VALIDACAO TECNICA]")
    print(f"- Dimensoes da spritesheet: {w}x{h} px (Esperado: 768x48)")
    assert (w, h) == (768, 48), f"Dimensoes incorretas: {w}x{h}"

    colors = sheet_img.getcolors(maxcolors=256)
    print(f"- Total de cores unicas na spritesheet: {len(colors)}")
    assert len(colors) <= 11, f"Cores excederam o limite: {len(colors)}"

    alpha_vals = set(sheet_img.getchannel("A").get_flattened_data() if hasattr(sheet_img.getchannel("A"), "get_flattened_data") else sheet_img.getchannel("A").getdata())
    print(f"- Valores de canal Alpha presentes: {alpha_vals}")
    assert alpha_vals.issubset({0, 255}), f"Alpha nao e estritamente binario: {alpha_vals}"

    print("\n================================================================================")
    print("=== MOB ESPIRITO DE RAIZ CONSTRUIDO COM SUCESSO: 16 QUADROS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
