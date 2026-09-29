"""
Pipeline de construcao do Mob Javali de Musgo (FASE R11 - Passo 5.2):
1. Dispara o workflow ComfyUI javali_concept_api.json para o conceito mestre.
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
OUT_ENEMY_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "javali_de_musgo")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "javali_frames")

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

C_SILV_DEEP  = hex_to_rgb("#0d2615")
C_SILV_DARK  = hex_to_rgb("#184725")
C_SILV_BASE  = hex_to_rgb("#2b7a3e")
C_SILV_LIGHT = hex_to_rgb("#52b769")

C_TUSK_DARK  = hex_to_rgb("#adb5bd")
C_TUSK_LIGHT = hex_to_rgb("#f1f3f5")

ALL_COLORS = [
    (0, 0, 0, 0),
    (*C_WOOD_DEEP, 255), (*C_WOOD_DARK, 255), (*C_WOOD_BASE, 255), (*C_WOOD_LIGHT, 255),
    (*C_SILV_DEEP, 255), (*C_SILV_DARK, 255), (*C_SILV_BASE, 255), (*C_SILV_LIGHT, 255),
    (*C_TUSK_DARK, 255), (*C_TUSK_LIGHT, 255),
]

def draw_javali_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Javali de Musgo no grid 48x48.
    Baseline do chao: Y=44. Facing: Left.
    Corpo quadrúpede massivo, musgo no dorso, focinho e presas de marfim viradas para a esquerda.
    """
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    bob_y = 0
    charge_x = 0
    recoil_x = 0
    collapse_y = 0
    dither_level = 0

    if action == "idle":
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        if step == 0:
            bob_y = 1
            charge_x = 2
        elif step == 1:
            bob_y = 0
            charge_x = -4
        elif step == 2:
            bob_y = -1
            charge_x = -7
        elif step == 3:
            bob_y = 0
            charge_x = -2
    elif action == "hit":
        bob_y = 1
        recoil_x = 4 if step == 0 else 2
    elif action == "death":
        collapse_y = step * 3
        dither_level = step

    by = min(46, 44 + bob_y + collapse_y)
    bx = 24 + charge_x + recoil_x

    if dither_level >= 5:
        by = 46

    # 1. Quatro Patas Troncudas e Cascos (Y: by-10 ate by)
    if dither_level < 5:
        # Pata traseira direita (fundo)
        d.rectangle([bx + 11, by - 10, bx + 14, by], fill=C_WOOD_DEEP)
        # Pata traseira esquerda (frente)
        d.rectangle([bx + 7, by - 10, bx + 10, by], fill=C_WOOD_DARK)
        d.rectangle([bx + 7, by - 2, bx + 10, by], fill=C_WOOD_DEEP) # Casco
        # Pata dianteira direita (fundo)
        d.rectangle([bx - 4, by - 10, bx - 1, by], fill=C_WOOD_DEEP)
        # Pata dianteira esquerda (frente)
        d.rectangle([bx - 9, by - 10, bx - 5, by], fill=C_WOOD_DARK)
        d.rectangle([bx - 9, by - 2, bx - 5, by], fill=C_WOOD_DEEP) # Casco

    # 2. Corpo e Lombo de Cerda Terrosa (Y: by-24 ate by-8, X: bx-10 ate bx+16)
    if dither_level < 4:
        d.rectangle([bx - 10, by - 22, bx + 15, by - 9], fill=C_WOOD_DARK)
        d.rectangle([bx - 8, by - 20, bx + 13, by - 11], fill=C_WOOD_BASE)
        # Cauda curta
        d.line([(bx + 15, by - 18), (bx + 18, by - 15)], fill=C_WOOD_DARK, width=1)

    # 3. Carapaça de Musgo e Líquens no Dorso (Y: by-26 ate by-18)
    if dither_level < 4:
        moss_shift = 1 if (step % 2 == 1) else 0
        d.rectangle([bx - 7, by - 25, bx + 12, by - 20], fill=C_SILV_DARK)
        d.rectangle([bx - 5, by - 26, bx + 10, by - 22], fill=C_SILV_BASE)
        d.point([(bx - 3 + moss_shift, by - 27), (bx + 2, by - 27), (bx + 7 - moss_shift, by - 27)], fill=C_SILV_LIGHT)
        d.point([(bx - 6, by - 22), (bx + 11, by - 21)], fill=C_SILV_DEEP)

    # 4. Cabeça, Focinho Pesado e Olho Furioso (Y: by-22 ate by-10, X: bx-17 ate bx-8)
    if dither_level < 3:
        d.rectangle([bx - 16, by - 20, bx - 8, by - 10], fill=C_WOOD_DARK)
        d.rectangle([bx - 14, by - 19, bx - 9, by - 12], fill=C_WOOD_BASE)
        # Focinho na ponta esquerda
        d.rectangle([bx - 17, by - 15, bx - 15, by - 11], fill=C_WOOD_DEEP)
        # Olho vermelho/terroso
        d.point([(bx - 12, by - 17)], fill=(241, 70, 104, 255))
        # Orelha felpuda atrás da cabeça
        d.polygon([(bx - 8, by - 22), (bx - 6, by - 25), (bx - 5, by - 21)], fill=C_WOOD_DARK)

    # 5. Presas de Marfim Recurvadas para Cima (X: bx-18 ate bx-13)
    if dither_level < 4:
        tusk_x = bx - 16
        tusk_y = by - 13
        # Presa curva apontada para cima e esquerda
        d.line([(tusk_x, tusk_y), (tusk_x - 3, tusk_y - 2), (tusk_x - 4, tusk_y - 6)], fill=C_TUSK_DARK, width=1)
        d.point([(tusk_x - 4, tusk_y - 6), (tusk_x - 3, tusk_y - 7)], fill=C_TUSK_LIGHT)

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

    palette_lut = np.array([
        (0, 0, 0, 0),
        (*C_WOOD_DEEP, 255), (*C_WOOD_DARK, 255), (*C_WOOD_BASE, 255), (*C_WOOD_LIGHT, 255),
        (*C_SILV_DEEP, 255), (*C_SILV_DARK, 255), (*C_SILV_BASE, 255), (*C_SILV_LIGHT, 255),
        (*C_TUSK_DARK, 255), (*C_TUSK_LIGHT, 255), (241, 70, 104, 255)
    ], dtype=np.int32)
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
    print("--- CONSTRUCAO CANONICA DO MOB JAVALI DE MUSGO (FASE R11 - PASSO 5.2) ---")
    print("================================================================================")

    os.makedirs(OUT_ENEMY_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "javali_concept_api.json")
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
        frame_img = draw_javali_frame(action=anim, step=step)
        fname = f"javali_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    ase_file = os.path.join(OUT_ENEMY_DIR, "mob_javali_musgo.aseprite")
    sheet_png = os.path.join(OUT_ENEMY_DIR, "mob_javali_musgo_sheet.png")
    sheet_json = os.path.join(OUT_ENEMY_DIR, "mob_javali_musgo_sheet.json")

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
    assert len(colors) <= 12, f"Cores excederam o limite: {len(colors)}"

    alpha_vals = set(sheet_img.getchannel("A").get_flattened_data() if hasattr(sheet_img.getchannel("A"), "get_flattened_data") else sheet_img.getchannel("A").getdata())
    print(f"- Valores de canal Alpha presentes: {alpha_vals}")
    assert alpha_vals.issubset({0, 255}), f"Alpha nao e estritamente binario: {alpha_vals}"

    print("\n================================================================================")
    print("=== MOB JAVALI DE MUSGO CONSTRUIDO COM SUCESSO: 16 QUADROS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
