"""
Pipeline de construcao do Mob Elite Lobo Alfa de Lumen (FASE R11 - Passo 6):
1. Dispara o workflow ComfyUI lobo_concept_api.json para o conceito mestre.
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
OUT_ENEMY_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "lobo_alfa_de_lumen")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "lobo_frames")

sys.path.append(os.path.dirname(__file__))
try:
    from comfy_client import ComfyClient
except ImportError:
    ComfyClient = None

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

C_SLATE_DEEP  = hex_to_rgb("#0d1117")
C_SLATE_DARK  = hex_to_rgb("#161b22")
C_SLATE_BASE  = hex_to_rgb("#21262d")
C_SLATE_MID   = hex_to_rgb("#30363d")
C_SLATE_LIGHT = hex_to_rgb("#8b949e")

C_LUMEN_DEEP  = hex_to_rgb("#0d3320")
C_LUMEN_DARK  = hex_to_rgb("#1a5c38")
C_LUMEN_BASE  = hex_to_rgb("#2da44e")
C_LUMEN_LIGHT = hex_to_rgb("#56d364")
C_LUMEN_BRIGHT= hex_to_rgb("#aff5b4")

C_FANG_DARK   = hex_to_rgb("#d0d7de")
C_FANG_LIGHT  = hex_to_rgb("#f6f8fa")

ALL_COLORS = [
    (0, 0, 0, 0),
    (*C_SLATE_DEEP, 255), (*C_SLATE_DARK, 255), (*C_SLATE_BASE, 255), (*C_SLATE_MID, 255),
    (*C_LUMEN_DARK, 255), (*C_LUMEN_BASE, 255), (*C_LUMEN_LIGHT, 255), (*C_LUMEN_BRIGHT, 255),
    (*C_FANG_DARK, 255), (*C_FANG_LIGHT, 255),
]

def draw_lobo_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Lobo Alfa de Lumen no grid 48x48.
    Baseline do chao: Y=44. Facing: Left.
    Porte atletico e lupino, juba e runas de lumen pulsante, olhos esmeralda e presas marfim.
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
            bob_y = -1
            charge_x = -5
        elif step == 2:
            bob_y = 0
            charge_x = -8
        elif step == 3:
            bob_y = 0
            charge_x = -3
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

    # 1. Quatro Patas Musculosas e Garras (Y: by-12 ate by)
    if dither_level < 5:
        # Pata traseira direita (fundo)
        d.rectangle([bx + 11, by - 12, bx + 13, by], fill=C_SLATE_DEEP)
        # Pata traseira esquerda (frente)
        d.rectangle([bx + 7, by - 12, bx + 10, by], fill=C_SLATE_DARK)
        d.rectangle([bx + 6, by - 2, bx + 9, by], fill=C_SLATE_DEEP) # Pata/Garras

        # Pata dianteira direita (fundo)
        d.rectangle([bx - 3, by - 12, bx - 1, by], fill=C_SLATE_DEEP)
        # Pata dianteira esquerda (frente)
        d.rectangle([bx - 8, by - 12, bx - 5, by], fill=C_SLATE_DARK)
        d.rectangle([bx - 9, by - 2, bx - 6, by], fill=C_FANG_DARK) # Garras expostas

    # 2. Corpo e Flanco Lupino (Y: by-24 ate by-9, X: bx-9 ate bx+14)
    if dither_level < 4:
        d.rectangle([bx - 9, by - 23, bx + 14, by - 10], fill=C_SLATE_DARK)
        d.rectangle([bx - 7, by - 21, bx + 12, by - 12], fill=C_SLATE_BASE)
        # Marcas de runas de Lumen no flanco (costelas)
        rune_pulse = C_LUMEN_BRIGHT if (step % 2 == 0) else C_LUMEN_LIGHT
        d.point([(bx - 1, by - 16), (bx + 3, by - 16), (bx + 7, by - 17)], fill=rune_pulse)
        d.point([(bx, by - 15), (bx + 4, by - 15)], fill=C_LUMEN_BASE)

        # Cauda longa e elegante curvando para cima
        tail_wave = 1 if (step % 2 == 1) else 0
        d.line([(bx + 14, by - 18), (bx + 19, by - 20 - tail_wave), (bx + 21, by - 24 - tail_wave)], fill=C_SLATE_DARK, width=2)
        d.point([(bx + 21, by - 25 - tail_wave), (bx + 20, by - 24 - tail_wave)], fill=C_LUMEN_LIGHT) # Ponta luminescente

    # 3. Juba Espectral de Lumen na Nuca e Espinha (Y: by-27 ate by-18)
    if dither_level < 4:
        mane_shift = 1 if (step % 2 == 1) else 0
        d.rectangle([bx - 8, by - 26, bx + 6, by - 21], fill=C_LUMEN_DARK)
        d.rectangle([bx - 6, by - 27, bx + 3, by - 23], fill=C_LUMEN_BASE)
        # Picos de luz espectral
        d.point([(bx - 5 + mane_shift, by - 28), (bx - 1, by - 28), (bx + 2 - mane_shift, by - 27)], fill=C_LUMEN_LIGHT)
        d.point([(bx - 3, by - 29), (bx, by - 29)], fill=C_LUMEN_BRIGHT)

    # 4. Cabeça Lupina Imponente e Orelhas Alertas (Y: by-25 ate by-12, X: bx-18 ate bx-7)
    if dither_level < 3:
        d.rectangle([bx - 16, by - 22, bx - 7, by - 13], fill=C_SLATE_DARK)
        d.rectangle([bx - 14, by - 21, bx - 8, by - 15], fill=C_SLATE_BASE)
        
        # Orelhas eretas e pontiagudas
        d.polygon([(bx - 8, by - 22), (bx - 7, by - 27), (bx - 5, by - 23)], fill=C_SLATE_DARK)
        d.point([(bx - 7, by - 25)], fill=C_LUMEN_DARK) # Interior da orelha

        # Focinho afilado e mandíbula
        d.rectangle([bx - 19, by - 17, bx - 14, by - 14], fill=C_SLATE_DARK)
        d.point([(bx - 19, by - 17)], fill=C_SLATE_DEEP) # Narina

        # Olhos Esmeralda Brilhantes
        eye_color = C_LUMEN_BRIGHT if (action != "hit") else C_FANG_LIGHT
        d.point([(bx - 13, by - 19)], fill=eye_color)
        d.point([(bx - 12, by - 19)], fill=C_LUMEN_LIGHT)

    # 5. Presas Caninas Marfim e Mordida Feroz
    if dither_level < 4:
        fang_y = by - 14
        if action == "attack" and step in [1, 2]:
            # Mandíbula aberta com presas superiores e inferiores
            d.line([(bx - 19, fang_y - 2), (bx - 16, fang_y - 2)], fill=C_FANG_LIGHT, width=1)
            d.line([(bx - 19, fang_y + 2), (bx - 16, fang_y + 2)], fill=C_FANG_LIGHT, width=1)
            d.point([(bx - 18, fang_y - 1), (bx - 18, fang_y + 1)], fill=C_FANG_DARK)
            # Brilho de corte de ataque
            if step == 2:
                d.line([(bx - 22, fang_y - 3), (bx - 20, fang_y + 3)], fill=C_LUMEN_BRIGHT, width=1)
        else:
            # Presa superior fechada para fora
            d.point([(bx - 17, fang_y)], fill=C_FANG_LIGHT)
            d.point([(bx - 17, fang_y + 1)], fill=C_FANG_DARK)

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
        (*C_SLATE_DEEP, 255), (*C_SLATE_DARK, 255), (*C_SLATE_BASE, 255), (*C_SLATE_MID, 255),
        (*C_LUMEN_DARK, 255), (*C_LUMEN_BASE, 255), (*C_LUMEN_LIGHT, 255), (*C_LUMEN_BRIGHT, 255),
        (*C_FANG_DARK, 255), (*C_FANG_LIGHT, 255)
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
    print("--- CONSTRUCAO CANONICA DO ELITE LOBO ALFA DE LUMEN (FASE R11 - PASSO 6) ---")
    print("================================================================================")

    os.makedirs(OUT_ENEMY_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "lobo_concept_api.json")
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
        frame_img = draw_lobo_frame(action=anim, step=step)
        fname = f"lobo_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    ase_file = os.path.join(OUT_ENEMY_DIR, "mob_lobo_alfa.aseprite")
    sheet_png = os.path.join(OUT_ENEMY_DIR, "mob_lobo_alfa_sheet.png")
    sheet_json = os.path.join(OUT_ENEMY_DIR, "mob_lobo_alfa_sheet.json")

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
    print("=== MOB ELITE LOBO ALFA DE LUMEN CONSTRUIDO COM SUCESSO: 16 QUADROS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
