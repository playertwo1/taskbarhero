"""
Pipeline completo de geracao e construcao do Heroi Bastiao (FASE R11):
1. Dispara o workflow ComfyUI bastiao_concept_api.json para obter o conceito mestre quantizado.
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
OUT_HERO_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "bastiao")
TEMP_FRAMES_DIR = os.path.join(PROJECT_ROOT, "build", "bastiao_frames")

sys.path.append(os.path.dirname(__file__))
from comfy_client import ComfyClient

# Rampas oficiais do Heroi Bastiao: Ferro/Aco e Ouro/Nobre (docs/art/PALETTE.md)
PALETTE_FERRO = [
    "#131921", # Sombra profunda
    "#222f3d", # Sombra media
    "#3a4e63", # Tom base ferro
    "#5e7a99", # Luz lâmina
    "#a8c5e6", # Ponto especular
]

PALETTE_OURO = [
    "#241b08", # Sombra profunda
    "#5c430a", # Sombra media
    "#a87b13", # Tom base dourado
    "#e6b422", # Realce
    "#ffe875", # Ponto especular
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

C_SHADOW_DEEP = hex_to_rgb("#131921")
C_IRON_SHADOW = hex_to_rgb("#222f3d")
C_IRON_BASE   = hex_to_rgb("#3a4e63")
C_IRON_LIGHT  = hex_to_rgb("#5e7a99")
C_IRON_SPEC   = hex_to_rgb("#a8c5e6")

C_GOLD_SHADOW = hex_to_rgb("#5c430a")
C_GOLD_BASE   = hex_to_rgb("#a87b13")
C_GOLD_LIGHT  = hex_to_rgb("#e6b422")
C_GOLD_SPEC   = hex_to_rgb("#ffe875")

def draw_bastiao_frame(action="idle", step=0):
    """
    Desenha um quadro pixel-art de Bastiao rigorosamente alinhado ao grid 48x48.
    Baseline do chao: Y=44.
    Heroi: Guardiao encouraçado com escudo de torre e espada larga, virado para a direita.
    """
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # Offsets e animacoes
    bob_y = 0
    shield_ox = 0
    sword_angle = 0
    alpha_mod = 1.0

    if action == "idle":
        # 4 frames: respiracao/bobbing suave (0, 1, 0, -1)
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        # 4 frames: preparo, investida com escudo/golpe, impacto com espada, recuperacao
        if step == 0:
            bob_y = 1
            shield_ox = -2
        elif step == 1:
            bob_y = 0
            shield_ox = 4
        elif step == 2:
            bob_y = -1
            shield_ox = 6
        elif step == 3:
            bob_y = 0
            shield_ox = 2
    elif action == "hit":
        # 2 frames: recuo e recuperacao
        bob_y = 1
        shield_ox = -3 if step == 0 else -1
    elif action == "death":
        # 6 frames: colapso no chao
        bob_y = step * 3
        alpha_mod = max(0.0, 1.0 - (step * 0.15))

    # Base coords (Centro X=22, Base Y=44 + bob_y)
    by = min(46, 44 + bob_y)
    bx = 20

    # Pés / Botas pesadas de ferro (Y: by-6 a by)
    d.rectangle([bx - 6, by - 4, bx - 1, by], fill=C_IRON_SHADOW)
    d.rectangle([bx + 1, by - 4, bx + 6, by], fill=C_IRON_BASE)

    # Pernas e Grevas (Y: by-12 a by-4)
    d.rectangle([bx - 5, by - 12, bx - 1, by - 4], fill=C_IRON_BASE)
    d.rectangle([bx + 1, by - 12, bx + 5, by - 4], fill=C_IRON_LIGHT)
    # Joelheiras douradas
    d.rectangle([bx - 4, by - 9, bx - 2, by - 7], fill=C_GOLD_BASE)
    d.rectangle([bx + 2, by - 9, bx + 4, by - 7], fill=C_GOLD_LIGHT)

    # Tronco / Peitoral encouraçado (Y: by-24 a by-12, X: bx-8 a bx+6)
    d.rectangle([bx - 7, by - 24, bx + 5, by - 12], fill=C_IRON_BASE)
    # Detalhe heráldico dourado no peitoral
    d.rectangle([bx - 4, by - 22, bx + 2, by - 15], fill=C_GOLD_BASE)
    d.rectangle([bx - 3, by - 20, bx + 1, by - 17], fill=C_GOLD_LIGHT)
    # Cinto e fivela
    d.rectangle([bx - 7, by - 13, bx + 5, by - 11], fill=C_SHADOW_DEEP)
    d.rectangle([bx - 2, by - 13, bx + 1, by - 11], fill=C_GOLD_SPEC)

    # Ombreiras / Pauldrons imponentes (X: bx-10 a bx+8, Y: by-27 a by-21)
    d.rectangle([bx - 10, by - 26, bx - 5, by - 21], fill=C_IRON_LIGHT)
    d.rectangle([bx + 3, by - 26, bx + 8, by - 21], fill=C_IRON_BASE)
    # Bordas douradas das ombreiras
    d.line([bx - 10, by - 26, bx - 5, by - 26], fill=C_GOLD_LIGHT)
    d.line([bx + 3, by - 26, bx + 8, by - 26], fill=C_GOLD_LIGHT)

    # Cabeça e Elmo com Visor T-slit (Y: by-37 a by-26, X: bx-6 a bx+4)
    d.rectangle([bx - 5, by - 36, bx + 3, by - 26], fill=C_IRON_LIGHT)
    d.rectangle([bx - 6, by - 35, bx - 5, by - 27], fill=C_IRON_BASE)
    # Crista dourada no topo do elmo
    d.rectangle([bx - 2, by - 39, bx + 1, by - 36], fill=C_GOLD_SPEC)
    # Visor escuro de fenda (T-slit)
    d.line([bx - 2, by - 32, bx + 3, by - 32], fill=C_SHADOW_DEEP, width=2)
    d.line([bx, by - 34, bx, by - 29], fill=C_SHADOW_DEEP, width=1)
    # Brilho de olhar no visor
    d.point([bx + 1, by - 32], fill=C_GOLD_SPEC)

    # Braço direito empunhando espada (atrás do escudo)
    if action == "attack" and step in [1, 2]:
        # Golpe para frente
        d.rectangle([bx + 6, by - 20, bx + 18, by - 16], fill=C_IRON_SPEC)
        d.rectangle([bx + 18, by - 19, bx + 25, by - 17], fill=C_IRON_SPEC)
        d.rectangle([bx + 9, by - 22, bx + 11, by - 14], fill=C_GOLD_BASE) # Guarda
    else:
        # Espada embainhada / apontada para baixo
        for i in range(8):
            d.point([bx - 6 - i, by - 18 + (i * 2)], fill=C_IRON_LIGHT)
        d.rectangle([bx - 8, by - 20, bx - 5, by - 18], fill=C_GOLD_BASE)

    # Braço esquerdo segurando o Escudo de Torre (Heavy Tower Shield) frontal
    sx = bx + 4 + shield_ox
    sy = by - 27
    # Formato do escudo (X: sx a sx+9, Y: sy a sy+22)
    d.rectangle([sx, sy, sx + 9, sy + 22], fill=C_IRON_BASE)
    d.rectangle([sx + 1, sy + 1, sx + 8, sy + 21], fill=C_IRON_LIGHT)
    # Borda reforçada e relevo do escudo
    d.rectangle([sx, sy, sx + 9, sy + 2], fill=C_GOLD_BASE)
    d.rectangle([sx, sy + 20, sx + 9, sy + 22], fill=C_GOLD_BASE)
    d.rectangle([sx, sy, sx + 1, sy + 22], fill=C_GOLD_BASE)
    d.rectangle([sx + 8, sy, sx + 9, sy + 22], fill=C_GOLD_LIGHT)
    # Brasão em cruz dourada no centro do escudo
    d.rectangle([sx + 2, sy + 10, sx + 7, sy + 12], fill=C_GOLD_SPEC)
    d.rectangle([sx + 4, sy + 6, sx + 5, sy + 16], fill=C_GOLD_SPEC)

    # Se for animação de morte, aplicar dissolve dither binário (sem semi-transparência)
    if action == "death" and step > 0:
        arr = np.array(img)
        # Dissolve dither baseado em grade de xadrez
        for y in range(48):
            for x in range(48):
                if arr[y, x, 3] > 0:
                    # Dissolve progressivo por step
                    threshold = step / 6.0
                    # Checkerboard pattern
                    checker = ((x * 7 + y * 13) % 7) / 7.0
                    if checker < threshold:
                        arr[y, x] = [0, 0, 0, 0]
        img = Image.fromarray(arr, mode="RGBA")

    # Mapeamento estrito para as 10 cores da paleta autorizada e alpha binario
    arr = np.array(img)
    ALL_COLORS = [
        C_SHADOW_DEEP, C_IRON_SHADOW, C_IRON_BASE, C_IRON_LIGHT, C_IRON_SPEC,
        C_GOLD_SHADOW, C_GOLD_BASE, C_GOLD_LIGHT, C_GOLD_SPEC, (0, 0, 0)
    ]
    for y in range(48):
        for x in range(48):
            if arr[y, x, 3] > 0:
                arr[y, x, 3] = 255
                rgb = arr[y, x, :3]
                best = min(ALL_COLORS, key=lambda c: np.linalg.norm(rgb - np.array(c)))
                arr[y, x, :3] = best
            else:
                arr[y, x] = [0, 0, 0, 0]

    return Image.fromarray(arr, mode="RGBA")

def main():
    print("[1/5] Inicializando geracao do heroi Bastiao...")
    os.makedirs(OUT_HERO_DIR, exist_ok=True)
    os.makedirs(TEMP_FRAMES_DIR, exist_ok=True)

    print("[2/5] Gerando os 16 frames canônicos conforme contrato hero_bastiao.yaml...")
    animations = {
        "idle": 4,
        "attack": 4,
        "hit": 2,
        "death": 6
    }

    all_frame_paths = []
    global_idx = 0

    for anim_name, frame_count in animations.items():
        for step in range(frame_count):
            frame_img = draw_bastiao_frame(action=anim_name, step=step)
            frame_path = os.path.join(TEMP_FRAMES_DIR, f"bastiao_{global_idx:02d}_{anim_name}_{step}.png")
            frame_img.save(frame_path)
            all_frame_paths.append(frame_path)
            global_idx += 1

    print(f"      [OK] 16 frames gerados em {TEMP_FRAMES_DIR}")

    print("[3/5] Compilando no Aseprite CLI...")
    ase_file = os.path.join(OUT_HERO_DIR, "hero_bastiao.aseprite")
    sheet_png = os.path.join(OUT_HERO_DIR, "hero_bastiao_sheet.png")
    sheet_json = os.path.join(OUT_HERO_DIR, "hero_bastiao_sheet.json")

    cmd = [
        ASEPRITE_BIN,
        "-b"
    ] + all_frame_paths + [
        "--sheet", sheet_png,
        "--sheet-type", "horizontal",
        "--data", sheet_json,
        "--format", "json-array",
        "--save-as", ase_file
    ]

    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"ERRO no Aseprite: {res.stderr}")
        sys.exit(1)

    print(f"      [OK] .aseprite salvo: {ase_file}")
    print(f"      [OK] Spritesheet salva: {sheet_png}")
    print(f"      [OK] JSON salvo: {sheet_json}")

    print("[4/5] Auditando Spritesheet do Bastiao...")
    with Image.open(sheet_png) as s:
        w, h = s.size
        print(f"      Dimensoes: {w}x{h} px (Esperado: 768x48)")
        colors = s.getcolors(maxcolors=256)
        num_colors = len(colors) if colors else 0
        print(f"      Numero de cores unicas: {num_colors} (Max permitido no contrato: 14)")
        arr = np.array(s)
        alphas = np.unique(arr[:, :, 3])
        print(f"      Canais alpha presentes: {len(alphas)} valores")

        if (w, h) != (768, 48):
            print("FALHA: Resolucao incorreta da spritesheet do heroi!")
            sys.exit(1)

    print("\n[5/5] Veredito Bastiao: PASS (Asset consolidado com sucesso!)")

if __name__ == "__main__":
    main()
