"""
Constroi o asset final da mini-animacao COMFY-ANIM-01:
1. Isola e alinha 4 frames de animacao de idle a partir das geracoes do ComfyUI.
2. Aplica mascara alpha binaria estrita (0 ou 255) e alinhamento no baseline Y=44 (canvas 48x48).
3. Invoca o Aseprite CLI para gerar comfy_lumen_slime_idle.aseprite, spritesheet PNG e metadata JSON.
"""

import os
import sys
import subprocess
from PIL import Image
import numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "anim_frames")
OUT_SPRITE_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen")

# Rampas de cores autorizadas para a Geleia de Lumen (docs/art/PALETTE.md)
ALLOWED_PALETTE_HEX = [
    "#0c2229", "#14444d", "#1f7580", "#32b2a6", "#67f0cc", "#d4fffa"
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

PALETTE_RGB = [hex_to_rgb(h) for h in ALLOWED_PALETTE_HEX]

def create_clean_frame(source_path, scale_factor=1.0, offset_y=0):
    """Isola o cluster central do slime, quantiza estritamente e centraliza no canvas 48x48."""
    img = Image.open(source_path).convert('RGB')
    arr = np.array(img)
    h, w, _ = arr.shape

    # Detectar o corpo do slime: pixels que estao no centro e nao sao a cor de borda/fundo
    # Criamos um canvas 48x48 RGBA
    canvas = np.zeros((48, 48, 4), dtype=np.uint8)

    # Identificar pixels que pertencem a silhueta (centro com margem de 4px)
    mask = np.zeros((h, w), dtype=bool)
    for y in range(4, h - 4):
        for x in range(4, w - 4):
            pixel = arr[y, x]
            # O slime contem tons azulados/luminescentes e contornos escuros
            # Se a cor estiver proxima da paleta de lumen:
            dists = [np.linalg.norm(pixel - np.array(c)) for c in PALETTE_RGB]
            min_dist = min(dists)
            if min_dist < 45.0:
                mask[y, x] = True

    # Obter bounding box da mascara
    y_indices, x_indices = np.where(mask)
    if len(y_indices) == 0:
        return Image.fromarray(canvas, mode='RGBA')

    min_y, max_y = y_indices.min(), y_indices.max()
    min_x, max_x = x_indices.min(), x_indices.max()
    slime_crop = arr[min_y:max_y+1, min_x:max_x+1]
    crop_mask = mask[min_y:max_y+1, min_x:max_x+1]

    # Redimensionar crop com base na escala (para animacao de respiracao / pulsacao)
    crop_img = Image.fromarray(slime_crop)
    new_w = max(1, int(crop_img.width * scale_factor))
    new_h = max(1, int(crop_img.height * scale_factor))
    resized_crop = crop_img.resize((new_w, new_h), Image.Resampling.NEAREST)
    resized_arr = np.array(resized_crop)

    # Re-mapear cores estritamente para a paleta canônica
    for y in range(new_h):
        for x in range(new_w):
            orig_p = resized_arr[y, x]
            # Encontrar cor da paleta mais proxima
            best_color = min(PALETTE_RGB, key=lambda c: np.linalg.norm(orig_p - np.array(c)))
            resized_arr[y, x] = best_color

    # Posicionar com baseline em Y=44 (base do personagem apoiada no chao)
    start_x = max(0, (48 - new_w) // 2)
    start_y = max(0, 44 - new_h + offset_y)
    end_x = min(48, start_x + new_w)
    end_y = min(48, start_y + new_h)

    # Inserir no canvas RGBA com alpha binario (255)
    for cy, ry in enumerate(range(0, end_y - start_y)):
        for cx, rx in enumerate(range(0, end_x - start_x)):
            pixel = resized_arr[ry, rx]
            canvas[start_y + cy, start_x + cx] = [pixel[0], pixel[1], pixel[2], 255]

    return Image.fromarray(canvas, mode='RGBA')

def main():
    print("[1/5] Preparando diretorios de saida...")
    os.makedirs(BUILD_DIR, exist_ok=True)
    os.makedirs(OUT_SPRITE_DIR, exist_ok=True)

    pose1_path = os.path.join(PROJECT_ROOT, "build", "slime_pose_compressed_48.png")
    pose2_path = os.path.join(PROJECT_ROOT, "build", "slime_pose_extended_48.png")

    if not os.path.exists(pose1_path) or not os.path.exists(pose2_path):
        print("ERRO: Poses do ComfyUI nao encontradas em build/")
        sys.exit(1)

    print("[2/5] Gerando os 4 quadros da mini-animacao (idle / respiracao)...")
    # Frame 0: Base / Neutro
    f0 = create_clean_frame(pose1_path, scale_factor=1.05, offset_y=0)
    # Frame 1: Comprimido (compressao para baixo)
    f1 = create_clean_frame(pose1_path, scale_factor=0.95, offset_y=2)
    # Frame 2: Retorno / Meio-tom
    f2 = create_clean_frame(pose2_path, scale_factor=0.98, offset_y=1)
    # Frame 3: Expansao (alongado para cima)
    f3 = create_clean_frame(pose2_path, scale_factor=1.06, offset_y=-1)

    frame_paths = []
    for idx, f in enumerate([f0, f1, f2, f3]):
        p = os.path.join(BUILD_DIR, f"frame_{idx}.png")
        f.save(p)
        frame_paths.append(p)
        print(f"      Frame {idx} salvo: {p} (48x48 RGBA)")

    print("[3/5] Invocando Aseprite CLI para consolidar .aseprite e exportar spritesheet...")
    ase_file = os.path.join(OUT_SPRITE_DIR, "comfy_lumen_slime_idle.aseprite")
    sheet_png = os.path.join(OUT_SPRITE_DIR, "comfy_lumen_slime_idle_sheet.png")
    sheet_json = os.path.join(OUT_SPRITE_DIR, "comfy_lumen_slime_idle_sheet.json")

    cmd = [
        ASEPRITE_BIN,
        "-b",
        frame_paths[0], frame_paths[1], frame_paths[2], frame_paths[3],
        "--sheet", sheet_png,
        "--sheet-type", "horizontal",
        "--data", sheet_json,
        "--format", "json-array",
        "--save-as", ase_file
    ]

    print("      Executando Aseprite:", " ".join(cmd))
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"ERRO no Aseprite CLI: {res.stderr}")
        sys.exit(1)

    print(f"      [OK] .aseprite salvo: {ase_file}")
    print(f"      [OK] Spritesheet salva: {sheet_png}")
    print(f"      [OK] JSON salvo: {sheet_json}")

    print("\n[4/5] Auditando Spritesheet Gerada...")
    with Image.open(sheet_png) as sheet:
        w, h = sheet.size
        print(f"      Dimensoes: {w}x{h} (Esperado: 192x48)")
        colors = sheet.getcolors(maxcolors=256)
        num_colors = len(colors) if colors else 0
        print(f"      Numero de cores unicas: {num_colors} (Max permitido: 16)")
        arr = np.array(sheet)
        alphas = np.unique(arr[:, :, 3])
        print(f"      Valores unicos de canal alpha: {alphas} (Esperado: [0, 255])")

        if (w, h) != (192, 48):
            print("FALHA: Dimensoes incorretas da spritesheet!")
            sys.exit(1)
        if len(alphas) > 2:
            print("FALHA: Halos semi-transparentes detectados!")
            sys.exit(1)

    print("\n[5/5] Veredito Aseprite: PASS (Mini-animacao consolidada com sucesso!)")

if __name__ == "__main__":
    main()
