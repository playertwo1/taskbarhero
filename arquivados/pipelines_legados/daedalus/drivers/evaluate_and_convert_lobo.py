"""
Pipeline de Conversão e Testes de Qualidade do Lobo Alfa de Lúmen (Novo Pipeline V2):
1. Isola e salva a Master Reference (512x512 PNG transparente).
2. Converte via SpriteFusion Pixel Snapper para 12, 16 e 20 cores (TY High Fantasy 40).
3. Ancora no canvas 48x48 com baseline Y=44 e sombra de contato em Y=45.
4. Aplica Median Fixer e Enforce Palette (subsets neutral_stone + lumen).
5. Executa Silhouette Test.
6. Executa Native Size Test (1x, 2x, 4x).
7. Gera comparação Current vs New.
"""

import os
import sys
import subprocess
import numpy as np
from PIL import Image, ImageDraw, ImageOps
from scipy.cluster.vq import kmeans, vq
from collections import deque

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "lobo_pipeline_v2")
OUT_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "lobo_alfa_de_lumen")
os.makedirs(BUILD_DIR, exist_ok=True)
os.makedirs(OUT_DIR, exist_ok=True)

SNAPPER_BIN = r"C:\Users\notefael\AppData\Local\Comfy-Desktop\ComfyUI\custom_nodes\ComfyUI-SpriteFusion-PixelSnapper\target\release\spritefusion-pixel-snapper.exe"

# Subconjuntos TY40: neutral_stone + lumen (docs/art/PALETTE.md e mob_lobo_alfa.yaml)
CANONICAL_LOBO_RAMP = [
    "#000000",
    "#182029",
    "#2f3140",
    "#314646",
    "#353235",
    "#425a58",
    "#4a484a",
    "#627c80",
    "#81b5a2",
    "#a49983",
    "#bdd2de",
    "#e6dac5",
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def isolate_clean_master_reference():
    src_path = os.path.join(BUILD_DIR, "lobo_concept_512_B.png")
    img = Image.open(src_path).convert('RGB')
    arr = np.array(img)
    h, w, _ = arr.shape

    bg_color = np.array([101.0, 125.0, 131.0])
    visited = np.zeros((h, w), dtype=bool)
    q = deque()

    # Add border pixels
    for y in range(h):
        for x in [0, 1, 2, 3, w-4, w-3, w-2, w-1]:
            q.append((y, x))
            visited[y, x] = True
    for x in range(w):
        for y in [0, 1, 2, 3, h-4, h-3, h-2, h-1]:
            if not visited[y, x]:
                q.append((y, x))
                visited[y, x] = True

    # Inner negative spaces
    q.append((360, 205))
    visited[360, 205] = True
    q.append((380, 315))
    visited[380, 315] = True

    while q:
        cy, cx = q.popleft()
        for dy, dx in [(-1,0), (1,0), (0,-1), (0,1)]:
            ny, nx = cy + dy, cx + dx
            if 0 <= ny < h and 0 <= nx < w and not visited[ny, nx]:
                p = arr[ny, nx].astype(float)
                d_bg = np.linalg.norm(p - bg_color)
                is_dark_outer = (ny < 25 or ny > 450 or nx < 25 or nx > 490) and (np.mean(p) < 60)
                if d_bg < 38 or is_dark_outer:
                    visited[ny, nx] = True
                    q.append((ny, nx))

    clean_arr = np.zeros((h, w, 4), dtype=np.uint8)
    clean_arr[~visited, :3] = arr[~visited]
    clean_arr[~visited, 3] = 255

    clean_arr[:20, :, :] = 0
    clean_arr[:, :20, :] = 0
    clean_arr[:, 495:, :] = 0
    clean_arr[455:, :, :] = 0

    for y in range(442, h):
        for x in range(w):
            if np.mean(arr[y, x]) < 40 and (x < 85 or x > 425 or (x > 145 and x < 185) or (x > 265 and x < 335)):
                clean_arr[y, x] = 0

    clean_img = Image.fromarray(clean_arr, 'RGBA')
    ref_path = os.path.join(OUT_DIR, "lobo_alfa_reference_v001.png")
    clean_img.save(ref_path)
    ref_build_path = os.path.join(BUILD_DIR, "lobo_alfa_reference_v001.png")
    clean_img.save(ref_build_path)
    print(f"Master Reference salva em: {ref_path}")
    return ref_path

def convert_to_48_grounded(raw_snapped_path, target_color_count):
    """
    Reduz o crop do lobo alfa proporcionalmente para o canvas 48x48.
    Como é um elite imponente, ocupa ~36px de altura por ~42px de largura.
    Base ancorada exatamente em Y=44 (solo da arena), sombra de contato em Y=45.
    """
    img = Image.open(raw_snapped_path).convert("RGBA")
    arr = np.array(img)
    alpha = arr[:, :, 3] > 0

    y_idx, x_idx = np.where(alpha)
    min_y, max_y = y_idx.min(), y_idx.max()
    min_x, max_x = x_idx.min(), x_idx.max()

    crop = arr[min_y:max_y+1, min_x:max_x+1]
    ch, cw, _ = crop.shape

    target_h = 36
    target_w = max(1, min(44, int(cw * (target_h / float(ch)))))
    crop_img = Image.fromarray(crop, "RGBA").resize((target_w, target_h), Image.Resampling.NEAREST)
    resized_arr = np.array(crop_img)

    canvas = np.zeros((48, 48, 4), dtype=np.uint8)

    target_bottom_y = 44
    start_y = target_bottom_y - target_h + 1
    start_x = (48 - target_w) // 2

    canvas[start_y:target_bottom_y+1, start_x:start_x+target_w] = resized_arr

    # Sombra de contato em Y=45
    shadow_w = int(target_w * 0.85)
    shadow_start_x = (48 - shadow_w) // 2
    for x in range(shadow_start_x, shadow_start_x + shadow_w):
        canvas[45, x] = [24, 32, 41, 170]

    out_img = Image.fromarray(canvas, "RGBA")
    out_path = os.path.join(BUILD_DIR, f"lobo_v2_{target_color_count}c_grounded_48.png")
    out_img.save(out_path)

    num_colors = len(out_img.getcolors(maxcolors=256) or [])
    print(f"Asset Grounded {target_color_count}c: {num_colors} cores, base Y=44.")
    return out_path, out_img

def main():
    print("=== [1/6] Isolando Master Reference ===")
    ref_path = isolate_clean_master_reference()

    print("\n=== [2/6] Executando SpriteFusion Pixel Snapper (12, 16 e 20 cores) ===")
    snapper_files = {}
    for c in [12, 16, 20]:
        raw_out = os.path.join(BUILD_DIR, f"snapped_clean_{c}c.png")
        cmd = [
            SNAPPER_BIN,
            ref_path,
            raw_out,
            str(c),
            "--cell-method", "majority",
            "--grid-mode", "adaptive"
        ]
        subprocess.run(cmd, check=True)
        g_path, g_img = convert_to_48_grounded(raw_out, c)
        snapper_files[c] = (g_path, g_img)

    # 12 cores é o limite do contrato (neutral_stone + lumen)
    final_12_img = snapper_files[12][1]
    final_v2_path = os.path.join(BUILD_DIR, "lobo_v2_final_48.png")
    final_12_img.save(final_v2_path)

    print("\n=== [3/6] Aplicando nós PixelGridHelpers (Median Fixer + Enforce Palette) ===")
    arr_12 = np.array(final_12_img)
    alpha = arr_12[:, :, 3] > 100
    rgb = arr_12[:, :, :3].astype(np.float32) / 255.0

    # Median Fixer
    h, w, _ = rgb.shape
    median_rgb = rgb.copy()
    for y in range(1, h - 1):
        for x in range(1, w - 1):
            if alpha[y, x]:
                patch = rgb[y-1:y+2, x-1:x+2]
                mask_p = alpha[y-1:y+2, x-1:x+2]
                if mask_p.sum() >= 5:
                    median_rgb[y, x] = np.median(patch[mask_p], axis=0)

    # Quantize K-Means para 12 cores
    pixels = median_rgb[alpha]
    centroids, _ = kmeans(pixels, 12, iter=20)
    labels, _ = vq(pixels, centroids)
    quantized_pixels = centroids[labels]

    # Enforce Palette nos subconjuntos canônicos
    canon_rgb = np.array([hex_to_rgb(hx) for hx in CANONICAL_LOBO_RAMP], dtype=np.float32) / 255.0
    enf_labels, _ = vq(quantized_pixels, canon_rgb)
    enf_pixels = canon_rgb[enf_labels]

    pg_canvas = np.zeros((48, 48, 4), dtype=np.uint8)
    pg_canvas[alpha, :3] = (enf_pixels * 255).astype(np.uint8)
    pg_canvas[alpha, 3] = 255
    # Sombra
    pg_canvas[45, 6:42] = [24, 32, 41, 170]

    pg_img = Image.fromarray(pg_canvas, "RGBA")
    pg_path = os.path.join(BUILD_DIR, "lobo_pixelgrid_helpers_final.png")
    pg_img.save(pg_path)
    print(f"PixelGridHelpers final salvo: {len(pg_img.getcolors(maxcolors=256) or [])} cores.")

    print("\n=== [4/6] Executando Silhouette Test ===")
    sil_arr = np.full((48, 48, 3), 255, dtype=np.uint8)
    sil_arr[alpha] = [15, 25, 35]
    sil_img = Image.fromarray(sil_arr, "RGB")
    sil_path = os.path.join(BUILD_DIR, "lobo_v2_silhouette_test.png")
    sil_img.save(sil_path)
    print(f"Silhouette Test salvo: {sil_path}")

    print("\n=== [5/6] Executando Native Size Test (1x, 2x, 4x) ===")
    img_1x = pg_img
    img_2x = pg_img.resize((96, 96), Image.Resampling.NEAREST)
    img_4x = pg_img.resize((192, 192), Image.Resampling.NEAREST)

    sheet_w = 48 + 96 + 192 + 100
    sheet_h = 240
    sheet = Image.new("RGBA", (sheet_w, sheet_h), (24, 28, 36, 255))
    draw_s = ImageDraw.Draw(sheet)
    sheet.paste(img_1x, (20, 100), img_1x)
    draw_s.text((20, 70), "1x (48px Native)", fill=(200, 220, 240))
    sheet.paste(img_2x, (90, 80), img_2x)
    draw_s.text((90, 50), "2x (96px)", fill=(200, 220, 240))
    sheet.paste(img_4x, (210, 30), img_4x)
    draw_s.text((210, 10), "4x (192px Zoom)", fill=(200, 220, 240))
    native_path = os.path.join(BUILD_DIR, "lobo_v2_native_size_test.png")
    sheet.save(native_path)
    print(f"Native Size Test salvo: {native_path}")

    print("\n=== [6/6] Comparação Current vs New ===")
    # Carregar o sprite procedural atual
    old_sheet = Image.open(os.path.join(OUT_DIR, "mob_lobo_alfa_sheet.png"))
    old_idle = old_sheet.crop((0, 0, 48, 48))

    comp_w = 48 * 4 * 2 + 80
    comp_h = 260
    comp = Image.new("RGBA", (comp_w, comp_h), (20, 24, 30, 255))
    draw_c = ImageDraw.Draw(comp)

    old_4x = old_idle.resize((192, 192), Image.Resampling.NEAREST)
    new_4x = pg_img.resize((192, 192), Image.Resampling.NEAREST)

    comp.paste(old_4x, (20, 40), old_4x)
    draw_c.text((20, 15), "CURRENT (Procedural Retalhado)", fill=(255, 120, 120))

    comp.paste(new_4x, (240, 40), new_4x)
    draw_c.text((240, 15), "NEW (Pipeline V2 512->Snapper->TY40)", fill=(120, 255, 180))

    comp_path = os.path.join(BUILD_DIR, "current_vs_new_lobo_comparison.png")
    comp.save(comp_path)
    print(f"Comparacao Current vs New salva: {comp_path}")

if __name__ == "__main__":
    main()
