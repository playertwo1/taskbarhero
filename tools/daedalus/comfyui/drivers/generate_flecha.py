"""
Pipeline completo de geracao e construcao do Heroi Flecha (FASE R11 - Passo 3):
1. Dispara o workflow ComfyUI flecha_concept_api.json para obter o conceito mestre quantizado.
2. Gera as variacoes de animacao (idle, attack, hit, death) no padrao 48x48 px, baseline Y=44.
3. Invoca o Aseprite CLI para empacotar em .aseprite, spritesheet PNG (768x48 px) e metadata JSON.
"""

import os
import sys
import json
import time
import subprocess
from PIL import Image, ImageDraw
import numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
OUT_HERO_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "flecha")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "flecha_frames")

sys.path.append(os.path.dirname(__file__))
try:
    from comfy_client import ComfyClient
except ImportError:
    ComfyClient = None

# Rampas oficiais do Heroi Flecha: Silvestre, Madeira e Ferro (docs/art/PALETTE.md)
PALETTE_SILVESTRE = [
    "#0d2615", # Sombra profunda capuz/tunica
    "#184725", # Sombra media
    "#2b7a3e", # Tom base verde silvestre
    "#52b769", # Realce folhagem/couro
    "#98e2a3", # Ponto de luz
]

PALETTE_MADEIRA = [
    "#2e1f14", # Sombra profunda arco
    "#543820", # Sombra media
    "#8a5e35", # Tom base madeira nobre
    "#bf8c56", # Realce do arco
    "#e3ba88", # Luz da empunhadura
]

PALETTE_FERRO = [
    "#131921", # Sombra metal / ponta
    "#3a4e63", # Tom base ferro
    "#a8c5e6", # Ponto especular flecha
]

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
C_WOOD_SPEC  = hex_to_rgb("#e3ba88")

C_IRON_DEEP  = hex_to_rgb("#131921")
C_IRON_BASE  = hex_to_rgb("#3a4e63")
C_IRON_SPEC  = hex_to_rgb("#a8c5e6")

ALL_COLORS = [
    (0, 0, 0, 0),
    (*C_SILV_DEEP, 255), (*C_SILV_DARK, 255), (*C_SILV_BASE, 255), (*C_SILV_LIGHT, 255), (*C_SILV_SPEC, 255),
    (*C_WOOD_DEEP, 255), (*C_WOOD_DARK, 255), (*C_WOOD_BASE, 255), (*C_WOOD_LIGHT, 255), (*C_WOOD_SPEC, 255),
    (*C_IRON_DEEP, 255), (*C_IRON_BASE, 255), (*C_IRON_SPEC, 255),
]

def draw_flecha_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Flecha rigorosamente alinhado ao grid 48x48.
    Baseline do chao: Y=44.
    Heroi: Arqueiro esguio com capuz silvestre, capa curta, aljava nas costas e arco longo, virado para a direita.
    """
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    bob_y = 0
    bow_pull = 0
    bow_release = False
    recoil_x = 0
    collapse_y = 0
    dither_level = 0

    if action == "idle":
        # 4 frames: respiracao/bobbing leve (0, 1, 0, -1)
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        # 4 frames:
        # 0: retira flecha da aljava / encaixa
        # 1: puxa a corda com tensao total (wind-up)
        # 2: soltura da flecha (release!) com overshoot para frente
        # 3: recuperacao / volta a postura
        if step == 0:
            bob_y = 1
            bow_pull = 2
        elif step == 1:
            bob_y = 0
            bow_pull = 6
        elif step == 2:
            bob_y = -1
            bow_pull = 0
            bow_release = True
        elif step == 3:
            bob_y = 0
            bow_pull = 1
    elif action == "hit":
        # 2 frames: impacto seco recuando para trás
        bob_y = 1
        recoil_x = -3 if step == 0 else -1
    elif action == "death":
        # 6 frames: colapso no chão com dissolução dither
        collapse_y = step * 3
        dither_level = step

    by = min(46, 44 + bob_y + collapse_y)
    bx = 20 + recoil_x

    if dither_level >= 5:
        # Ultimo frame: repouso escurecido/dissolvido
        by = 46

    # 1. Aljava nas costas (X: bx-6, Y: by-26)
    if dither_level < 4:
        d.rectangle([bx - 6, by - 26, bx - 3, by - 14], fill=C_WOOD_DARK)
        d.rectangle([bx - 5, by - 28, bx - 4, by - 26], fill=C_WOOD_BASE)
        # Pontas de flechas prateadas saindo
        d.point([(bx - 5, by - 29), (bx - 4, by - 30)], fill=C_IRON_SPEC)

    # 2. Pernas / Botas de caçador (Y: by-12 ate by)
    if dither_level < 5:
        # Perna esquerda (sombra)
        d.rectangle([bx - 4, by - 12, bx - 1, by], fill=C_WOOD_DEEP)
        d.rectangle([bx - 4, by - 3, bx - 1, by], fill=C_WOOD_DARK)
        # Perna direita (frente)
        d.rectangle([bx + 1, by - 12, bx + 5, by], fill=C_WOOD_DARK)
        d.rectangle([bx + 2, by - 10, bx + 4, by - 4], fill=C_WOOD_BASE)
        d.rectangle([bx + 1, by - 3, bx + 5, by], fill=C_WOOD_DEEP)

    # 3. Tronco e Túnica Silvestre (Y: by-24 ate by-12)
    if dither_level < 4:
        d.rectangle([bx - 4, by - 24, bx + 6, by - 12], fill=C_SILV_DARK)
        d.rectangle([bx - 2, by - 23, bx + 4, by - 14], fill=C_SILV_BASE)
        d.rectangle([bx, by - 22, bx + 3, by - 15], fill=C_SILV_LIGHT)
        # Cinto de couro
        d.rectangle([bx - 3, by - 14, bx + 5, by - 12], fill=C_WOOD_DEEP)
        d.rectangle([bx + 1, by - 14, bx + 3, by - 12], fill=C_IRON_SPEC)

    # 4. Capuz e Cabeça (Y: by-35 ate by-24)
    if dither_level < 3:
        # Capuz silvestre
        d.rectangle([bx - 3, by - 35, bx + 5, by - 24], fill=C_SILV_DARK)
        d.rectangle([bx - 1, by - 34, bx + 4, by - 26], fill=C_SILV_BASE)
        d.rectangle([bx, by - 33, bx + 3, by - 28], fill=C_SILV_LIGHT)
        # Ponta do capuz atrás
        d.point([(bx - 4, by - 32), (bx - 5, by - 31)], fill=C_SILV_DEEP)
        # Viseira/Sombra do rosto
        d.rectangle([bx + 1, by - 30, bx + 5, by - 27], fill=C_SILV_DEEP)
        # Olho afiado/brilho no escuro
        d.point([(bx + 3, by - 29)], fill=C_SILV_SPEC)

    # 5. Capa curta atrás (ondulando no vento)
    if dither_level < 4:
        cape_ox = -1 if (step % 2 == 1) else 0
        d.polygon([(bx - 3, by - 24), (bx - 7 + cape_ox, by - 15), (bx - 4, by - 14)], fill=C_SILV_DEEP)

    # 6. Arco Longo de Madeira e Braços
    # Posicionado a frente (X: bx+8 a bx+14)
    if dither_level < 4:
        bow_x = bx + 9
        bow_top_y = by - 36
        bow_bot_y = by - 8
        bow_mid_y = by - 22

        # Arco curvado (duas hastes)
        # Haste superior
        d.line([(bow_x, bow_mid_y), (bow_x + 3, bow_mid_y - 7), (bow_x + 2, bow_top_y)], fill=C_WOOD_BASE, width=1)
        d.point([(bow_x + 2, bow_top_y - 1)], fill=C_WOOD_LIGHT)
        # Haste inferior
        d.line([(bow_x, bow_mid_y), (bow_x + 3, bow_mid_y + 7), (bow_x + 2, bow_bot_y)], fill=C_WOOD_BASE, width=1)
        d.point([(bow_x + 2, bow_bot_y + 1)], fill=C_WOOD_LIGHT)
        # Empunhadura central
        d.rectangle([bow_x - 1, bow_mid_y - 2, bow_x + 1, bow_mid_y + 2], fill=C_WOOD_SPEC)

        # Corda do arco
        string_x = bow_x - bow_pull
        d.line([(bow_x + 2, bow_top_y), (string_x, bow_mid_y), (bow_x + 2, bow_bot_y)], fill=C_IRON_BASE, width=1)

        # Flecha nockada se puxando
        if bow_pull > 0:
            arrow_start_x = string_x
            arrow_end_x = bow_x + 10
            d.line([(arrow_start_x, bow_mid_y), (arrow_end_x, bow_mid_y)], fill=C_WOOD_LIGHT, width=1)
            # Ponta da flecha
            d.point([(arrow_end_x, bow_mid_y), (arrow_end_x + 1, bow_mid_y)], fill=C_IRON_SPEC)

        # Se soltou a flecha (frame de disparo)
        if bow_release:
            # Traço de disparo e flecha voando para a direita
            d.line([(bow_x + 6, bow_mid_y), (bow_x + 18, bow_mid_y)], fill=C_IRON_SPEC, width=1)
            d.point([(bow_x + 19, bow_mid_y)], fill=(255, 255, 255, 255))
            # Efeito de brilho de disparo
            d.point([(bow_x + 4, bow_mid_y - 1), (bow_x + 4, bow_mid_y + 1)], fill=C_SILV_SPEC)

        # Braço esquerdo (segurando o arco)
        d.rectangle([bx + 4, by - 24, bow_x, by - 20], fill=C_SILV_BASE)
        d.rectangle([bow_x - 2, by - 23, bow_x, by - 21], fill=C_WOOD_DARK)

    # 7. Efeito de Dissolucao Dither para Morte
    if dither_level > 0:
        pixels = img.load()
        w, h = img.size
        for y in range(h):
            for x in range(w):
                if pixels[x, y][3] > 0:
                    # Padrao de xadrez progressivo
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

    # 8. Quantizacao estrita para garantir 0 cores fora da rampa e alpha estritamente binario
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
    print("--- CONSTRUCAO CANONICA DO HEROI FLECHA (FASE R11 - PASSO 3) ---")
    print("================================================================================")

    os.makedirs(OUT_HERO_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    # 1. Trigger opcional ComfyUI Concept
    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "flecha_concept_api.json")
            if os.path.exists(workflow_path):
                with open(workflow_path, "r", encoding="utf-8") as wf:
                    workflow_prompt = json.load(wf)
                res = client.queue_prompt(workflow_prompt)
                prompt_id = res.get("prompt_id")
                print(f"[PASS] Job enfileirado com prompt_id: {prompt_id}")
        else:
            print("[INFO] ComfyUI daemon nao detectado, prosseguindo com construcao canônica direta.")

    # 2. Gerar os 16 quadros canonicos
    frames_spec = [
        ("idle", 0), ("idle", 1), ("idle", 2), ("idle", 3),
        ("attack", 0), ("attack", 1), ("attack", 2), ("attack", 3),
        ("hit", 0), ("hit", 1),
        ("death", 0), ("death", 1), ("death", 2), ("death", 3), ("death", 4), ("death", 5)
    ]

    frame_paths = []
    print("\nGerando 16 quadros canonicos (48x48 px, baseline Y=44)...")
    for i, (anim, step) in enumerate(frames_spec):
        frame_img = draw_flecha_frame(action=anim, step=step)
        fname = f"flecha_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    # 3. Invocar Aseprite CLI para consolidar .aseprite e spritesheet
    ase_file = os.path.join(OUT_HERO_DIR, "hero_flecha.aseprite")
    sheet_png = os.path.join(OUT_HERO_DIR, "hero_flecha_sheet.png")
    sheet_json = os.path.join(OUT_HERO_DIR, "hero_flecha_sheet.json")

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

    # 4. Validacao do Spritesheet gerado
    sheet_img = Image.open(sheet_png)
    w, h = sheet_img.size
    print(f"\n[VALIDACAO TECNICA]")
    print(f"- Dimensoes da spritesheet: {w}x{h} px (Esperado: 768x48)")
    assert (w, h) == (768, 48), f"Dimensoes incorretas: {w}x{h}"

    colors = sheet_img.getcolors(maxcolors=256)
    print(f"- Total de cores unicas na spritesheet: {len(colors)}")
    assert len(colors) <= 14, f"Cores excederam o limite: {len(colors)}"

    # Verificar alpha binario
    alpha_vals = set(sheet_img.getchannel("A").getdata())
    print(f"- Valores de canal Alpha presentes: {alpha_vals}")
    assert alpha_vals.issubset({0, 255}), f"Alpha nao e estritamente binario: {alpha_vals}"

    print("\n================================================================================")
    print("=== HEROI FLECHA CONSTRUIDO COM SUCESSO: 16 QUADROS CANONICOS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
