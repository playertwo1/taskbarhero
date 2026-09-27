"""
Pipeline completo de geracao e construcao da Heroina Iris (FASE R11 - Passo 4):
1. Dispara o workflow ComfyUI iris_concept_api.json para obter o conceito mestre quantizado.
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
OUT_HERO_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "iris")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "iris_frames")

sys.path.append(os.path.dirname(__file__))
try:
    from comfy_client import ComfyClient
except ImportError:
    ComfyClient = None

# Rampas oficiais da Heroina Iris: Nobre, Lumen e Ouro (docs/art/PALETTE.md)
PALETTE_NOBRE = [
    "#190d26", # Sombra profunda tunica
    "#321453", # Sombra media
    "#5a1db9", # Tom base purpura
    "#915eed", # Realce de seda mistica
    "#dcc4ff", # Ponto de luz
]

PALETTE_LUMEN = [
    "#0b2920", # Sombra orbe/runa
    "#14533d", # Sombra verde floresta
    "#1db97a", # Tom base verde lumen
    "#5eedaa", # Realce ciano luminoso
    "#c4ffea", # Ponto especular orbe
]

PALETTE_OURO = [
    "#5c430a", # Sombra media aro do cajado
    "#a87b13", # Tom base dourado
    "#e6b422", # Realce ouro
    "#ffe875", # Ponto especular
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

C_NOB_DEEP  = hex_to_rgb("#190d26")
C_NOB_DARK  = hex_to_rgb("#321453")
C_NOB_BASE  = hex_to_rgb("#5a1db9")
C_NOB_LIGHT = hex_to_rgb("#915eed")
C_NOB_SPEC  = hex_to_rgb("#dcc4ff")

C_LUM_DEEP  = hex_to_rgb("#0b2920")
C_LUM_DARK  = hex_to_rgb("#14533d")
C_LUM_BASE  = hex_to_rgb("#1db97a")
C_LUM_LIGHT = hex_to_rgb("#5eedaa")
C_LUM_SPEC  = hex_to_rgb("#c4ffea")

C_GOLD_DARK  = hex_to_rgb("#5c430a")
C_GOLD_BASE  = hex_to_rgb("#a87b13")
C_GOLD_LIGHT = hex_to_rgb("#e6b422")
C_GOLD_SPEC  = hex_to_rgb("#ffe875")

ALL_COLORS = [
    (0, 0, 0, 0),
    (*C_NOB_DEEP, 255), (*C_NOB_DARK, 255), (*C_NOB_BASE, 255), (*C_NOB_LIGHT, 255), (*C_NOB_SPEC, 255),
    (*C_LUM_DEEP, 255), (*C_LUM_DARK, 255), (*C_LUM_BASE, 255), (*C_LUM_LIGHT, 255), (*C_LUM_SPEC, 255),
    (*C_GOLD_DARK, 255), (*C_GOLD_BASE, 255), (*C_GOLD_LIGHT, 255), (*C_GOLD_SPEC, 255),
]

def draw_iris_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Iris rigorosamente alinhado ao grid 48x48.
    Baseline do chao: Y=44.
    Heroina: Maga altiva com túnica púrpura, capuz místico, empunhando cajado com aro dourado e orbe de Lúmen flutuante.
    """
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    bob_y = 0
    staff_lift = 0
    orb_pulse = 0
    cast_flash = False
    recoil_x = 0
    collapse_y = 0
    dither_level = 0

    if action == "idle":
        # 4 frames: respiracao suave e orbe flutuando (0, 1, 0, -1)
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
        # Orbe flutuando ligeiramente descompassado
        orb_bobs = [0, -1, -2, -1]
        orb_pulse = orb_bobs[step % 4]
    elif action == "attack":
        # 4 frames:
        # 0: ergue o cajado, energia comeca a convergir
        # 1: acúmulo radiante máximo no topo
        # 2: disparo de rajada mística de Lúmen para a frente
        # 3: recuperacao / retorno
        if step == 0:
            staff_lift = 2
            orb_pulse = -2
        elif step == 1:
            staff_lift = 4
            orb_pulse = -3
            cast_flash = True
        elif step == 2:
            staff_lift = 2
            orb_pulse = 0
            cast_flash = True
        elif step == 3:
            staff_lift = 0
            orb_pulse = -1
    elif action == "hit":
        # 2 frames: impacto seco recuando para trás
        bob_y = 1
        recoil_x = -3 if step == 0 else -1
        staff_lift = -2
    elif action == "death":
        # 6 frames: colapso no chão com dissolução dither
        collapse_y = step * 3
        dither_level = step

    by = min(46, 44 + bob_y + collapse_y)
    bx = 20 + recoil_x

    if dither_level >= 5:
        by = 46

    # 1. Túnica Talare Mística Púrpura (Y: by-24 ate by)
    if dither_level < 5:
        # Base da saia / manto no solo
        d.rectangle([bx - 6, by - 12, bx + 4, by], fill=C_NOB_DARK)
        d.rectangle([bx - 4, by - 10, bx + 2, by - 2], fill=C_NOB_BASE)
        # Borda inferior com dobra de seda
        d.rectangle([bx - 5, by - 3, bx + 3, by], fill=C_NOB_DEEP)
        # Runa bordada de Lúmen no centro da túnica
        if dither_level < 3:
            d.line([(bx - 1, by - 9), (bx - 1, by - 5)], fill=C_LUM_LIGHT, width=1)
            d.point([(bx - 2, by - 7), (bx, by - 7)], fill=C_LUM_BASE)

    # 2. Tronco e Corpete (Y: by-26 ate by-12)
    if dither_level < 4:
        d.rectangle([bx - 4, by - 26, bx + 4, by - 12], fill=C_NOB_DARK)
        d.rectangle([bx - 2, by - 25, bx + 2, by - 14], fill=C_NOB_BASE)
        d.rectangle([bx - 1, by - 24, bx + 1, by - 16], fill=C_NOB_LIGHT)
        # Broche dourado com orbe central no pescoço
        d.rectangle([bx - 1, by - 25, bx + 1, by - 23], fill=C_GOLD_BASE)
        d.point([(bx, by - 24)], fill=C_LUM_SPEC)

    # 3. Capuz e Rosto Místico (Y: by-36 ate by-26)
    if dither_level < 3:
        # Capuz pontiagudo
        d.rectangle([bx - 4, by - 36, bx + 3, by - 26], fill=C_NOB_DARK)
        d.rectangle([bx - 2, by - 35, bx + 2, by - 28], fill=C_NOB_BASE)
        d.rectangle([bx - 1, by - 34, bx + 1, by - 30], fill=C_NOB_LIGHT)
        # Ponta de seda do capuz atrás
        d.point([(bx - 5, by - 34), (bx - 6, by - 33)], fill=C_NOB_DEEP)
        # Sombra do rosto sob o capuz
        d.rectangle([bx, by - 31, bx + 3, by - 28], fill=C_NOB_DEEP)
        # Olhar iluminado em Lúmen cintilante
        d.point([(bx + 2, by - 30)], fill=C_LUM_SPEC)

    # 4. Capa ondulante atrás
    if dither_level < 4:
        cape_shift = 1 if (step % 2 == 1) else 0
        d.polygon([(bx - 4, by - 26), (bx - 8 - cape_shift, by - 12), (bx - 5, by - 10)], fill=C_NOB_DEEP)

    # 5. Cajado Místico com Aro Dourado e Orbe de Lúmen
    # Segurado na frente (X: bx+7 a bx+11)
    if dither_level < 4:
        staff_x = bx + 8
        staff_bot_y = by - 2
        staff_top_y = by - 34 - staff_lift

        # Haste do cajado (madeira escura/ferro)
        d.line([(staff_x, staff_top_y + 6), (staff_x, staff_bot_y)], fill=C_GOLD_DARK, width=1)
        d.point([(staff_x, staff_top_y + 12), (staff_x, staff_top_y + 20)], fill=C_GOLD_BASE)

        # Braço segurando o cajado
        d.rectangle([bx + 2, by - 24 - staff_lift, staff_x, by - 21 - staff_lift], fill=C_NOB_BASE)
        d.rectangle([staff_x - 1, by - 23 - staff_lift, staff_x + 1, by - 21 - staff_lift], fill=C_NOB_LIGHT)

        # Aro Dourado Superior (anel aberto que acolhe o orbe)
        ring_y = staff_top_y + 3
        d.ellipse([staff_x - 4, ring_y - 6, staff_x + 4, ring_y + 2], outline=C_GOLD_BASE)
        d.point([(staff_x - 3, ring_y - 5), (staff_x + 3, ring_y - 5)], fill=C_GOLD_LIGHT)
        d.point([(staff_x, ring_y + 2)], fill=C_GOLD_SPEC)

        # Orbe Bioluminescente de Lúmen Flutuante (X: staff_x, Y: ring_y - 2 + orb_pulse)
        orb_y = ring_y - 2 + orb_pulse
        d.ellipse([staff_x - 2, orb_y - 2, staff_x + 2, orb_y + 2], fill=C_LUM_BASE)
        d.point([(staff_x, orb_y)], fill=C_LUM_SPEC)
        d.point([(staff_x - 1, orb_y - 1), (staff_x + 1, orb_y - 1)], fill=C_LUM_LIGHT)

        # Se atacando / lançando feitiço
        if cast_flash:
            # Efeito de clarão radiante do orbe
            d.line([(staff_x - 4, orb_y), (staff_x + 4, orb_y)], fill=C_LUM_SPEC, width=1)
            d.line([(staff_x, orb_y - 4), (staff_x, orb_y + 4)], fill=C_LUM_SPEC, width=1)
            # Projétil / feixe de lúmen disparado para frente
            if action == "attack" and step == 2:
                # Feixe avançando para a direita
                d.line([(staff_x + 5, orb_y), (staff_x + 16, orb_y)], fill=C_LUM_LIGHT, width=2)
                d.line([(staff_x + 16, orb_y), (staff_x + 20, orb_y)], fill=C_LUM_SPEC, width=1)
                d.point([(staff_x + 10, orb_y - 2), (staff_x + 14, orb_y + 2)], fill=C_LUM_BASE)

    # 6. Efeito de Dissolucao Dither para Morte
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

    # 7. Quantizacao estrita para garantir 0 cores fora da rampa e alpha estritamente binario
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
    print("--- CONSTRUCAO CANONICA DA HEROINA IRIS (FASE R11 - PASSO 4) ---")
    print("================================================================================")

    os.makedirs(OUT_HERO_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    # 1. Trigger opcional ComfyUI Concept
    if ComfyClient:
        client = ComfyClient("http://127.0.0.1:8188")
        if client.check_health():
            print("[INFO] ComfyUI daemon ativo na porta 8188. Disparando conceito mestre...")
            workflow_path = os.path.join(PROJECT_ROOT, "tools", "daedalus", "comfyui", "workflows", "iris_concept_api.json")
            if os.path.exists(workflow_path):
                with open(workflow_path, "r", encoding="utf-8") as wf:
                    workflow_prompt = json.load(wf)
                res = client.queue_prompt(workflow_prompt)
                prompt_id = res.get("prompt_id")
                print(f"[PASS] Job enfileirado com prompt_id: {prompt_id}")
        else:
            print("[INFO] ComfyUI daemon nao detectado, prosseguindo com construcao canonica direta.")

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
        frame_img = draw_iris_frame(action=anim, step=step)
        fname = f"iris_{i:02d}_{anim}_{step}.png"
        fpath = os.path.join(TEMP_FRAMES_DIR, fname)
        frame_img.save(fpath)
        frame_paths.append(fpath)
        print(f"  Frame {i:02d}: {anim} [{step}] -> {fname} (OK)")

    # 3. Invocar Aseprite CLI para consolidar .aseprite e spritesheet
    ase_file = os.path.join(OUT_HERO_DIR, "hero_iris.aseprite")
    sheet_png = os.path.join(OUT_HERO_DIR, "hero_iris_sheet.png")
    sheet_json = os.path.join(OUT_HERO_DIR, "hero_iris_sheet.json")

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

    # 4. Validacao do Spritesheet gerado
    sheet_img = Image.open(sheet_png)
    w, h = sheet_img.size
    print(f"\n[VALIDACAO TECNICA]")
    print(f"- Dimensoes da spritesheet: {w}x{h} px (Esperado: 768x48)")
    assert (w, h) == (768, 48), f"Dimensoes incorretas: {w}x{h}"

    colors = sheet_img.getcolors(maxcolors=256)
    print(f"- Total de cores unicas na spritesheet: {len(colors)}")
    assert len(colors) <= 15, f"Cores excederam o limite: {len(colors)}"

    # Verificar alpha binario
    alpha_vals = set(sheet_img.getchannel("A").get_flattened_data() if hasattr(sheet_img.getchannel("A"), "get_flattened_data") else sheet_img.getchannel("A").getdata())
    print(f"- Valores de canal Alpha presentes: {alpha_vals}")
    assert alpha_vals.issubset({0, 255}), f"Alpha nao e estritamente binario: {alpha_vals}"

    print("\n================================================================================")
    print("=== HEROINA IRIS CONSTRUIDA COM SUCESSO: 16 QUADROS CANONICOS PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
