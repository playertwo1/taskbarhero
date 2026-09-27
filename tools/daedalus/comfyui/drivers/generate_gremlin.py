"""
Pipeline de construcao do Mob Gremlin de Folha (FASE R11 - Passo 5):
1. Dispara o workflow ComfyUI gremlin_concept_api.json para o conceito mestre.
2. Gera as variacoes de animacao (idle, attack, hit, death) no padrao 32x32 px, baseline Y=29, facing left.
3. Invoca o Aseprite CLI para empacotar em .aseprite, spritesheet PNG (512x32 px) e metadata JSON.
"""

import os
import sys
import json
import subprocess
from PIL import Image, ImageDraw
import numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
OUT_ENEMY_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "gremlin_de_folha")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "gremlin_frames")

sys.path.append(os.path.dirname(__file__))
try:
    from comfy_client import ComfyClient
except ImportError:
    ComfyClient = None

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

C_SILV_DEEP  = hex_to_rgb("#0d2615")
C_SILV_DARK  = hex_to_rgb("#184725")
C_SILV_BASE  = hex_to_rgb("#2b7a3e")
C_SILV_LIGHT = hex_to_rgb("#52b769")
C_SILV_SPEC  = hex_to_rgb("#98e2a3")

C_WOOD_DEEP  = hex_to_rgb("#2e1f14")
C_WOOD_DARK  = hex_to_rgb("#543820")
C_WOOD_BASE  = hex_to_rgb("#8a5e35")
C_WOOD_LIGHT = hex_to_rgb("#bf8c56")

C_EYE_GOLD   = hex_to_rgb("#ffe875")
C_IRON_BASE  = hex_to_rgb("#3a4e63")
C_IRON_SPEC  = hex_to_rgb("#a8c5e6")

ALL_COLORS = [
    (0, 0, 0, 0),
    (*C_SILV_DEEP, 255), (*C_SILV_DARK, 255), (*C_SILV_BASE, 255), (*C_SILV_LIGHT, 255), (*C_SILV_SPEC, 255),
    (*C_WOOD_DEEP, 255), (*C_WOOD_DARK, 255), (*C_WOOD_BASE, 255), (*C_WOOD_LIGHT, 255),
    (*C_EYE_GOLD, 255), (*C_IRON_BASE, 255), (*C_IRON_SPEC, 255),
]

def draw_gremlin_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Gremlin de Folha rigorosamente no grid 32x32.
    Baseline do chao: Y=29. Facing: Left.
    """
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    bob_y = 0
    lunge_x = 0
    dagger_stab = 0
    recoil_x = 0
    collapse_y = 0
    dither_level = 0

    if action == "idle":
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        if step == 0:
            bob_y = 1
            lunge_x = 1
        elif step == 1:
            bob_y = 0
            lunge_x = -3
            dagger_stab = 4
        elif step == 2:
            bob_y = -1
            lunge_x = -4
            dagger_stab = 5
        elif step == 3:
            bob_y = 0
            lunge_x = -1
            dagger_stab = 1
    elif action == "hit":
        bob_y = 1
        recoil_x = 3 if step == 0 else 1
    elif action == "death":
        collapse_y = step * 2
        dither_level = step

    by = min(31, 29 + bob_y + collapse_y)
    bx = 18 + lunge_x + recoil_x

    if dither_level >= 5:
        by = 31

    # 1. Pernas curtas e pés com garras (Y: by-6 ate by)
    if dither_level < 5:
        # Perna de trás
        d.rectangle([bx + 1, by - 6, bx + 3, by], fill=C_SILV_DARK)
        d.point([(bx, by)], fill=C_WOOD_DEEP)
        # Perna da frente (esquerda)
        d.rectangle([bx - 4, by - 6, bx - 2, by], fill=C_SILV_BASE)
        d.point([(bx - 5, by), (bx - 4, by)], fill=C_WOOD_BASE)

    # 2. Tanga de couro e tronco de folhas (Y: by-14 ate by-6)
    if dither_level < 4:
        # Tanga
        d.rectangle([bx - 3, by - 8, bx + 2, by - 6], fill=C_WOOD_DARK)
        # Tronco
        d.rectangle([bx - 3, by - 14, bx + 3, by - 7], fill=C_SILV_DARK)
        d.rectangle([bx - 2, by - 13, bx + 1, by - 8], fill=C_SILV_BASE)
        # Manto de folhas secas sobre os ombros
        d.point([(bx + 2, by - 13), (bx + 3, by - 12)], fill=C_WOOD_LIGHT)
        d.point([(bx - 3, by - 13), (bx - 2, by - 12)], fill=C_SILV_LIGHT)

    # 3. Cabeça feérica com orelhas pontiagudas (Y: by-22 ate by-13)
    if dither_level < 3:
        # Cabeça
        d.rectangle([bx - 4, by - 21, bx + 1, by - 14], fill=C_SILV_BASE)
        d.rectangle([bx - 3, by - 20, bx, by - 15], fill=C_SILV_LIGHT)
        # Orelha pontuda voltada para trás (direita)
        ear_bob = 1 if (step % 2 == 1) else 0
        d.line([(bx + 1, by - 18), (bx + 5, by - 20 - ear_bob)], fill=C_SILV_DARK, width=1)
        d.point([(bx + 5, by - 20 - ear_bob)], fill=C_SILV_SPEC)
        # Sombra dos olhos e focinho
        d.rectangle([bx - 4, by - 18, bx - 2, by - 16], fill=C_SILV_DEEP)
        # Olho dourado brilhante (olhando para a esquerda)
        d.point([(bx - 3, by - 17)], fill=C_EYE_GOLD)

    # 4. Braço e Adaga de Sílex
    # Segura a adaga à frente (esquerda): X: bx - 4 - dagger_stab
    if dither_level < 4:
        hand_x = bx - 4 - dagger_stab
        hand_y = by - 11
        # Braço
        d.line([(bx - 2, by - 13), (hand_x + 1, hand_y)], fill=C_SILV_BASE, width=1)
        # Cabo da adaga
        d.line([(hand_x, hand_y - 1), (hand_x, hand_y + 2)], fill=C_WOOD_DARK, width=1)
        # Lâmina de sílex lascado (apontada para a esquerda)
        d.line([(hand_x - 1, hand_y), (hand_x - 4, hand_y)], fill=C_IRON_BASE, width=1)
        d.point([(hand_x - 4, hand_y)], fill=C_IRON_SPEC)

    # 5. Dissolucao Dither para Morte
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

    # 6. Quantizacao estrita e alpha binario
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
    print("--- CONSTRUCAO CANONICA DO MOB GREMLIN DE FOLHA (FASE R11 - PASSO 5.1) ---")
    print("================================================================================")

    os.makedirs(OUT_ENEMY_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "gremlin_concept_api.json")
            if os.path.exists(workflow_path):
                with open(workflow_path, "r", encoding="utf-8") as wf:
                    workflow_prompt = json.load(wf)
                res = client.queue_prompt(workflow_prompt)
                prompt_id = res.get("prompt_id")
                print(f"[PASS] Job enfileirado com prompt_id: {prompt_id}")
        else:
            print("[INFO] ComfyUI daemon offline, prosseguindo com geracao canônica.")

    frames_spec = [
        ("idle", 0), ("idle", 1), ("idle", 2), ("idle", 3),
        ("attack", 0), ("attack", 1), ("attack", 2), ("attack", 3),
        ("hit", 0), ("hit", 1),
        ("death", 0), ("death", 1), ("death", 2), ("death", 3), ("death", 4), ("death", 5)
    ]

    frame_paths = []
    print("\nGerando 16 quadros canonicos (32x32 px, baseline Y=29, facing left)...")
    for i, (anim, step) in enumerate(frames_spec):
        frame_img = draw_gremlin_frame(action=anim, step=step)
        fname = f"gremlin_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    ase_file = os.path.join(OUT_ENEMY_DIR, "mob_gremlin_folha.aseprite")
    sheet_png = os.path.join(OUT_ENEMY_DIR, "mob_gremlin_folha_sheet.png")
    sheet_json = os.path.join(OUT_ENEMY_DIR, "mob_gremlin_folha_sheet.json")

    print("\nInvocando Aseprite CLI para montagem da spritesheet canônica...")
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
    print(f"- Dimensoes da spritesheet: {w}x{h} px (Esperado: 512x32)")
    assert (w, h) == (512, 32), f"Dimensoes incorretas: {w}x{h}"

    colors = sheet_img.getcolors(maxcolors=256)
    print(f"- Total de cores unicas na spritesheet: {len(colors)}")
    assert len(colors) <= 13, f"Cores excederam o limite: {len(colors)}"

    alpha_vals = set(sheet_img.getchannel("A").get_flattened_data() if hasattr(sheet_img.getchannel("A"), "get_flattened_data") else sheet_img.getchannel("A").getdata())
    print(f"- Valores de canal Alpha presentes: {alpha_vals}")
    assert alpha_vals.issubset({0, 255}), f"Alpha nao e estritamente binario: {alpha_vals}"

    print("\n================================================================================")
    print("=== MOB GREMLIN DE FOLHA CONSTRUIDO COM SUCESSO: 16 QUADROS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
