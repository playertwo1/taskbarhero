"""
Pipeline de construcao do Chefe Guardiao-Cervo de Pedra (FASE R11 - Passo 7):
1. Dispara o workflow ComfyUI boss_cervo_concept_api.json para o conceito mestre.
2. Gera as variacoes de animacao (idle, attack, hit, death) no padrao 64x64 px, baseline Y=60, facing left.
3. Invoca o Aseprite CLI para empacotar em .aseprite, spritesheet PNG (1024x64 px) e metadata JSON.
"""

import os
import sys
import json
import subprocess
from PIL import Image, ImageDraw
import numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
OUT_BOSS_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "bosses", "guardiao_cervo")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "boss_cervo_frames")

sys.path.append(os.path.dirname(__file__))
try:
    from comfy_client import ComfyClient
except ImportError:
    ComfyClient = None

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

C_STONE_DEEP  = hex_to_rgb("#141824")
C_STONE_DARK  = hex_to_rgb("#262d3d")
C_STONE_BASE  = hex_to_rgb("#3d475c")
C_STONE_MID   = hex_to_rgb("#596680")
C_STONE_LIGHT = hex_to_rgb("#8392ab")

C_HORN_DEEP   = hex_to_rgb("#3d312a")
C_HORN_DARK   = hex_to_rgb("#695244")
C_HORN_BASE   = hex_to_rgb("#9c7c65")
C_HORN_LIGHT  = hex_to_rgb("#cfb199")

C_LUMEN_DARK  = hex_to_rgb("#145932")
C_LUMEN_BASE  = hex_to_rgb("#269e54")
C_LUMEN_LIGHT = hex_to_rgb("#4ee085")
C_LUMEN_BRIGHT= hex_to_rgb("#a8ffcc")

def draw_cervo_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art do Guardiao-Cervo de Pedra no grid 64x64.
    Baseline do chao: Y=60. Facing: Left.
    Corpo monolítico de granito, chifres gigantescos de rocha e madeira petrificada, fissuras e olhos de lúmen.
    """
    img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
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
            bob_y = -3
            charge_x = 3
        elif step == 1:
            bob_y = 1
            charge_x = -7
        elif step == 2:
            bob_y = 2
            charge_x = -11
        elif step == 3:
            bob_y = 0
            charge_x = -4
    elif action == "hit":
        bob_y = 1
        recoil_x = 5 if step == 0 else 2
    elif action == "death":
        collapse_y = step * 3
        dither_level = step

    by = min(62, 60 + bob_y + collapse_y)
    bx = 34 + charge_x + recoil_x

    if dither_level >= 5:
        by = 62

    # 1. Quatro Patas Monolíticas e Cascos de Pedra (Y: by-18 ate by)
    if dither_level < 5:
        # Pata traseira direita (fundo)
        d.rectangle([bx + 14, by - 16, bx + 18, by], fill=C_STONE_DEEP)
        # Pata traseira esquerda (frente)
        d.rectangle([bx + 9, by - 17, bx + 14, by], fill=C_STONE_DARK)
        d.rectangle([bx + 8, by - 4, bx + 14, by], fill=C_STONE_DEEP) # Casco pesado
        d.point([(bx + 11, by - 8)], fill=C_STONE_BASE)

        # Pata dianteira direita (fundo)
        d.rectangle([bx - 6, by - 16, bx - 2, by], fill=C_STONE_DEEP)
        # Pata dianteira esquerda (frente)
        d.rectangle([bx - 12, by - 17, bx - 7, by], fill=C_STONE_DARK)
        d.rectangle([bx - 13, by - 4, bx - 7, by], fill=C_STONE_DEEP) # Casco pesado
        d.point([(bx - 10, by - 9)], fill=C_STONE_BASE)

    # 2. Corpo Maciço de Granito (Y: by-32 ate by-14, X: bx-14 ate bx+20)
    if dither_level < 4:
        d.rectangle([bx - 14, by - 31, bx + 19, by - 15], fill=C_STONE_DARK)
        d.rectangle([bx - 12, by - 29, bx + 17, by - 17], fill=C_STONE_BASE)
        d.rectangle([bx - 9, by - 27, bx + 14, by - 19], fill=C_STONE_MID)

        # Fissuras rúnicas de Lúmen no flanco rochoso
        rune_pulse = C_LUMEN_BRIGHT if (step % 2 == 0) else C_LUMEN_LIGHT
        d.line([(bx - 4, by - 25), (bx - 1, by - 22), (bx + 4, by - 24)], fill=rune_pulse, width=1)
        d.line([(bx + 4, by - 24), (bx + 8, by - 21), (bx + 12, by - 23)], fill=C_LUMEN_BASE, width=1)
        d.point([(bx - 2, by - 23), (bx + 6, by - 22)], fill=C_LUMEN_BRIGHT)

        # Cauda curta de pedra entalhada
        d.polygon([(bx + 19, by - 26), (bx + 23, by - 24), (bx + 20, by - 21)], fill=C_STONE_DARK)

    # 3. Pescoço Monolítico e Peitoral Robusto (Y: by-44 ate by-28, X: bx-20 ate bx-7)
    if dither_level < 4:
        d.polygon([
            (bx - 12, by - 31), (bx - 7, by - 31),
            (bx - 10, by - 43), (bx - 19, by - 43),
            (bx - 21, by - 34)
        ], fill=C_STONE_DARK)
        d.polygon([
            (bx - 14, by - 33), (bx - 9, by - 33),
            (bx - 12, by - 42), (bx - 17, by - 42),
            (bx - 18, by - 36)
        ], fill=C_STONE_BASE)
        # Fissura luminosa no peito
        d.line([(bx - 16, by - 39), (bx - 14, by - 34)], fill=C_LUMEN_LIGHT, width=1)

    # 4. Cabeça Nobre do Cervo e Focinho (Y: by-48 ate by-36, X: bx-27 ate bx-13)
    if dither_level < 3:
        d.rectangle([bx - 25, by - 46, bx - 14, by - 38], fill=C_STONE_DARK)
        d.rectangle([bx - 23, by - 45, bx - 16, by - 40], fill=C_STONE_BASE)
        # Focinho esculpido na ponta esquerda
        d.rectangle([bx - 27, by - 43, bx - 24, by - 39], fill=C_STONE_DEEP)

        # Olhos Ancestrais de Lúmen
        eye_color = C_LUMEN_BRIGHT if (action != "hit") else C_HORN_LIGHT
        d.rectangle([bx - 20, by - 44, bx - 18, by - 43], fill=eye_color)
        d.point([(bx - 19, by - 44)], fill=C_LUMEN_LIGHT)

        # Orelhas de pedra apontadas para trás
        d.polygon([(bx - 15, by - 46), (bx - 11, by - 49), (bx - 11, by - 45)], fill=C_STONE_DARK)

    # 5. Galhadas Monumentais de Pedra e Madeira Petrificada (Y: by-58 ate by-43)
    if dither_level < 4:
        antler_sway = 1 if (step % 2 == 1) else 0
        # Tronco principal dos chifres erguendo-se da cabeça
        d.line([(bx - 16, by - 46), (bx - 15, by - 52 - antler_sway), (bx - 12, by - 57 - antler_sway)], fill=C_HORN_DARK, width=2)
        d.line([(bx - 12, by - 46), (bx - 8, by - 53 - antler_sway), (bx - 4, by - 58 - antler_sway)], fill=C_HORN_DARK, width=2)

        # Ramificações frontais (apontando para frente/esquerda)
        d.line([(bx - 15, by - 51 - antler_sway), (bx - 21, by - 55 - antler_sway)], fill=C_HORN_BASE, width=1)
        d.line([(bx - 13, by - 55 - antler_sway), (bx - 17, by - 58 - antler_sway)], fill=C_HORN_LIGHT, width=1)

        # Ramificações traseiras (apontando para cima/direita)
        d.line([(bx - 8, by - 52 - antler_sway), (bx - 3, by - 54 - antler_sway)], fill=C_HORN_BASE, width=1)
        d.line([(bx - 5, by - 56 - antler_sway), (bx + 1, by - 58 - antler_sway)], fill=C_HORN_LIGHT, width=1)

        # Cristais/Gemas de Lúmen incrustados nas pontas dos chifres
        d.point([(bx - 22, by - 56 - antler_sway), (bx - 18, by - 59 - antler_sway)], fill=C_LUMEN_BRIGHT)
        d.point([(bx - 12, by - 58 - antler_sway), (bx - 4, by - 59 - antler_sway), (bx + 2, by - 59 - antler_sway)], fill=C_LUMEN_LIGHT)

    # 6. Efeito Especial de Ataque (Pisotear Sismico e Explosao de Luz)
    if action == "attack":
        if step == 2:
            # Onda de choque no solo
            d.line([(bx - 30, by), (bx + 5, by)], fill=C_LUMEN_BRIGHT, width=2)
            d.line([(bx - 28, by - 2), (bx - 24, by - 6)], fill=C_LUMEN_LIGHT, width=1)
            d.line([(bx - 22, by - 2), (bx - 18, by - 8)], fill=C_LUMEN_LIGHT, width=1)
            d.point([(bx - 20, by - 9), (bx - 25, by - 7)], fill=C_STONE_LIGHT)

    # 7. Efeito Dither de Dissolucao
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

    # 8. Quantizacao estrita e alpha binario
    arr = np.array(img)
    alpha = arr[:, :, 3]
    binary_alpha = np.where(alpha > 127, 255, 0).astype(np.uint8)
    arr[:, :, 3] = binary_alpha

    palette_lut = np.array([
        (0, 0, 0, 0),
        (*C_STONE_DEEP, 255), (*C_STONE_DARK, 255), (*C_STONE_BASE, 255), (*C_STONE_MID, 255), (*C_STONE_LIGHT, 255),
        (*C_HORN_DEEP, 255), (*C_HORN_DARK, 255), (*C_HORN_BASE, 255), (*C_HORN_LIGHT, 255),
        (*C_LUMEN_DARK, 255), (*C_LUMEN_BASE, 255), (*C_LUMEN_LIGHT, 255), (*C_LUMEN_BRIGHT, 255)
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
    print("--- CONSTRUCAO CANONICA DO CHEFE GUARDIAO-CERVO DE PEDRA (FASE R11 - PASSO 7) ---")
    print("================================================================================")

    os.makedirs(OUT_BOSS_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "boss_cervo_concept_api.json")
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
    print("\nGerando 16 quadros canonicos (64x64 px, baseline Y=60, facing left)...")
    for i, (anim, step) in enumerate(frames_spec):
        frame_img = draw_cervo_frame(action=anim, step=step)
        fname = f"cervo_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    ase_file = os.path.join(OUT_BOSS_DIR, "boss_guardiao_cervo.aseprite")
    sheet_png = os.path.join(OUT_BOSS_DIR, "boss_guardiao_cervo_sheet.png")
    sheet_json = os.path.join(OUT_BOSS_DIR, "boss_guardiao_cervo_sheet.json")

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
    print(f"- Dimensoes da spritesheet: {w}x{h} px (Esperado: 1024x64)")
    assert (w, h) == (1024, 64), f"Dimensoes incorretas: {w}x{h}"

    colors = sheet_img.getcolors(maxcolors=256)
    print(f"- Total de cores unicas na spritesheet: {len(colors)}")
    assert len(colors) <= 14, f"Cores excederam o limite: {len(colors)}"

    alpha_vals = set(sheet_img.getchannel("A").get_flattened_data() if hasattr(sheet_img.getchannel("A"), "get_flattened_data") else sheet_img.getchannel("A").getdata())
    print(f"- Valores de canal Alpha presentes: {alpha_vals}")
    assert alpha_vals.issubset({0, 255}), f"Alpha nao e estritamente binario: {alpha_vals}"

    print("\n================================================================================")
    print("=== CHEFE GUARDIAO-CERVO DE PEDRA CONSTRUIDO COM SUCESSO: 16 QUADROS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
