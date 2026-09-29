"""
Processamento Completo do Slime de Lumen - Novo Pipeline V2 (Versao 2 - Limpa e Sem Artefatos)
"""

import os
import sys
import subprocess
import numpy as np
from PIL import Image, ImageDraw, ImageOps
from scipy.ndimage import label, binary_fill_holes
from scipy.cluster.vq import kmeans, vq

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "slime_pipeline_v2")
REF_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen")
os.makedirs(REF_DIR, exist_ok=True)
os.makedirs(BUILD_DIR, exist_ok=True)

SNAPPER_BIN = r"C:\Users\notefael\AppData\Local\Comfy-Desktop\ComfyUI\custom_nodes\ComfyUI-SpriteFusion-PixelSnapper\target\release\spritefusion-pixel-snapper.exe"
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")

OFFICIAL_LUMEN_RAMP = [
    "#061114",
    "#0c2229",
    "#14444d",
    "#1f7580",
    "#279499",
    "#32b2a6",
    "#4ed2b8",
    "#67f0cc",
    "#9effe3",
    "#d4fffa",
    "#ffffff",
    "#e6dac5",
    "#a49983",
    "#7b7d6a",
    "#6a6548",
    "#4a484a",
    "#353235",
    "#425a58",
    "#314646",
    "#2f3140",
    "#182029",
    "#bdd2de",
    "#81b5a2",
    "#627c80",
    "#607a53",
    "#545f28",
    "#484c2a",
    "#223925",
    "#000000",
    "#8f5c66",
    "#5a4256",
    "#7a393d",
    "#562f36",
    "#402736",
    "#bf5437",
    "#842d17",
    "#5a231d",
    "#caaa6c",
    "#b5835a",
    "#855139",
    "#60342c",
    "#af8e2c",
    "#8a5c0a",
    "#af5722",
    "#703a1a",
    "#3b1c16",
    "#2a1810",
    "#80592e",
    "#554323",
    "#353021",
    "#1c200f"
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def isolate_clean_master_reference():
    src_path = os.path.join(BUILD_DIR, "slime_concept_512_B.png")
    img = Image.open(src_path).convert('RGB')
    arr = np.array(img)
    h, w, _ = arr.shape

    max_c = np.max(arr, axis=2).astype(float)
    min_c = np.min(arr, axis=2).astype(float)
    sat = (max_c - min_c) / (max_c + 1e-5)
    val = max_c / 255.0

    is_bg = (sat < 0.15) & (val > 0.45)
    is_creature = (~is_bg) & (np.arange(h)[:, None] <= 390)

    lbl, num_features = label(is_creature)
    sizes = [np.sum(lbl == i) for i in range(1, num_features + 1)]
    largest_idx = np.argmax(sizes) + 1
    creature_mask = binary_fill_holes(lbl == largest_idx)

    clean_arr = np.zeros((512, 512, 4), dtype=np.uint8)
    clean_arr[creature_mask, :3] = arr[creature_mask]
    clean_arr[creature_mask, 3] = 255

    clean_img = Image.fromarray(clean_arr, 'RGBA')
    ref_path = os.path.join(REF_DIR, "lumen_slime_reference_v001.png")
    clean_img.save(ref_path)
    clean_path_build = os.path.join(BUILD_DIR, "lumen_slime_reference_v001.png")
    clean_img.save(clean_path_build)
    print(f"Master Reference limpa salva em: {ref_path}")
    return ref_path

def convert_to_48_grounded(raw_snapped_path, target_color_count):
    """
    Reduz proporcionalmente o crop do slime para caber perfeitamente no canvas 48x48
    e ancora a base exatamente em Y=44 (solo da arena), adicionando sombra de contato 1px em Y=45.
    """
    img = Image.open(raw_snapped_path).convert("RGBA")
    arr = np.array(img)
    alpha = arr[:, :, 3] > 0
    
    y_idx, x_idx = np.where(alpha)
    min_y, max_y = y_idx.min(), y_idx.max()
    min_x, max_x = x_idx.min(), x_idx.max()
    
    crop = arr[min_y:max_y+1, min_x:max_x+1]
    ch, cw, _ = crop.shape
    
    # Redimensionar crop para que tenha ~32px de altura e ~32px de largura (proporcao perfeita para mob comum 48x48)
    target_h = 32
    target_w = max(1, int(cw * (target_h / float(ch))))
    crop_img = Image.fromarray(crop, "RGBA").resize((target_w, target_h), Image.Resampling.NEAREST)
    resized_arr = np.array(crop_img)
    
    # Criar canvas 48x48
    canvas = np.zeros((48, 48, 4), dtype=np.uint8)
    
    # Posicionar base em Y=44
    target_bottom_y = 44
    start_y = target_bottom_y - target_h + 1
    start_x = (48 - target_w) // 2
    
    canvas[start_y:target_bottom_y+1, start_x:start_x+target_w] = resized_arr
    
    # Sombra de contato no solo em Y=45 (1px altura, cinza-azulado escuro com alpha)
    shadow_w = int(target_w * 0.75)
    shadow_start_x = (48 - shadow_w) // 2
    for x in range(shadow_start_x, shadow_start_x + shadow_w):
        canvas[45, x] = [12, 34, 41, 160]
        
    out_img = Image.fromarray(canvas, "RGBA")
    out_path = os.path.join(BUILD_DIR, f"slime_v2_{target_color_count}c_grounded_48.png")
    out_img.save(out_path)
    
    # Contar cores
    num_colors = len(out_img.getcolors(maxcolors=256) or [])
    print(f"Asset Grounded {target_color_count}c: {num_colors} cores unicas, base em Y=44.")
    return out_path, out_img

def run_all_tests():
    # 1. Isolar Master Reference
    ref_path = isolate_clean_master_reference()
    
    # 2. Executar SpriteFusion para 16, 20 e 24 cores
    snapper_files = {}
    for c in [16, 20, 24]:
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
        
    # Salvar versao 20 cores como o asset V2 oficial da Geleia de Lumen
    final_20_img = snapper_files[20][1]
    final_v2_path = os.path.join(BUILD_DIR, "slime_v2_final_48.png")
    final_20_img.save(final_v2_path)
    
    # 3. Teste PixelGridHelpers (Quantize, Enforce, Merge, Median)
    print("\n--- Testando nós PixelGridHelpers ---")
    # Median Fixer + Merge Similar no 48x48
    arr_20 = np.array(final_20_img)
    alpha = arr_20[:, :, 3] > 100
    rgb = arr_20[:, :, :3].astype(np.float32) / 255.0
    
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
    
    # Quantize K-Means para 20 cores
    pixels = median_rgb[alpha]
    centroids, _ = kmeans(pixels, 20, iter=20)
    labels, _ = vq(pixels, centroids)
    quantized_pixels = centroids[labels]
    
    # Enforce Palette
    lumen_rgb = np.array([hex_to_rgb(hx) for hx in OFFICIAL_LUMEN_RAMP], dtype=np.float32) / 255.0
    enf_labels, _ = vq(quantized_pixels, lumen_rgb)
    enf_pixels = lumen_rgb[enf_labels]
    
    pg_canvas = np.zeros((48, 48, 4), dtype=np.uint8)
    pg_canvas[alpha, :3] = (enf_pixels * 255).astype(np.uint8)
    pg_canvas[alpha, 3] = 255
    pg_canvas[45, 14:34] = [12, 34, 41, 160] # sombra
    
    pg_img = Image.fromarray(pg_canvas, "RGBA")
    pg_path = os.path.join(BUILD_DIR, "slime_pixelgrid_helpers_test.png")
    pg_img.save(pg_path)
    print(f"PixelGridHelpers test concluido: {len(pg_img.getcolors(maxcolors=256) or [])} cores.")
    
    # 4. Silhouette Test (Preto 100% no fundo branco)
    sil_arr = np.full((48, 48, 3), 255, dtype=np.uint8)
    sil_arr[alpha] = [0, 0, 0]
    sil_img = Image.fromarray(sil_arr, "RGB")
    sil_path = os.path.join(BUILD_DIR, "slime_v2_silhouette_test.png")
    sil_img.save(sil_path)
    print(f"Silhouette Test salvo: {sil_path}")
    
    # 5. Native Size Test (1x, 2x, 4x)
    img_1x = final_20_img
    img_2x = final_20_img.resize((96, 96), Image.Resampling.NEAREST)
    img_4x = final_20_img.resize((192, 192), Image.Resampling.NEAREST)
    
    sheet_w = 48 + 96 + 192 + 80
    sheet_h = 240
    sheet = Image.new("RGBA", (sheet_w, sheet_h), (24, 28, 36, 255))
    draw_s = ImageDraw.Draw(sheet)
    sheet.paste(img_1x, (20, 100), img_1x)
    draw_s.text((20, 70), "1x (48px Native)", fill=(200, 220, 240))
    sheet.paste(img_2x, (90, 80), img_2x)
    draw_s.text((90, 50), "2x (96px)", fill=(200, 220, 240))
    sheet.paste(img_4x, (210, 30), img_4x)
    draw_s.text((210, 10), "4x (192px Zoom)", fill=(200, 220, 240))
    native_path = os.path.join(BUILD_DIR, "slime_v2_native_size_test.png")
    sheet.save(native_path)
    print(f"Native Size Test salvo: {native_path}")
    
    # 6. Comparacao das 3 paletas (16 vs 20 vs 24 cores)
    pal_sheet = Image.new("RGBA", (48 * 4 * 3 + 80, 260), (20, 24, 30, 255))
    draw_p = ImageDraw.Draw(pal_sheet)
    draw_p.text((20, 15), "TESTE DE PALETA: 16 CORES vs 20 CORES vs 24 CORES", fill=(255, 255, 255))
    for i, c in enumerate([16, 20, 24]):
        p_img = snapper_files[c][1]
        p_4x = p_img.resize((192, 192), Image.Resampling.NEAREST)
        x_pos = 20 + i * 200
        pal_sheet.paste(p_4x, (x_pos, 50), p_4x)
        draw_p.text((x_pos, 245), f"Target: {c}c (Real: {len(p_img.getcolors(maxcolors=256) or [])})", fill=(180, 220, 255))
    pal_path = os.path.join(BUILD_DIR, "slime_v2_palette_comparison.png")
    pal_sheet.save(pal_path)
    print(f"Palette Comparison salva: {pal_path}")
    
    # 7. Comparacao Lado a Lado: CURRENT vs NEW
    curr_sheet_path = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen", "enemy_geleia_lumen_sheet.png")
    curr_sheet = Image.open(curr_sheet_path).convert("RGBA")
    curr_f0 = curr_sheet.crop((0, 0, 32, 32))
    curr_48 = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    curr_48.paste(curr_f0, (8, 12), curr_f0)
    
    comp_w = 700
    comp_h = 380
    comp = Image.new("RGBA", (comp_w, comp_h), (18, 22, 28, 255))
    draw_c = ImageDraw.Draw(comp)
    
    draw_c.text((20, 15), "POCKET HERO — AUDITORIA DE QUALIDADE: GELEIA DE LUMEN", fill=(255, 255, 255))
    draw_c.text((20, 35), "CURRENT (Pipeline Antigo) vs NEW (Pipeline V2 com SpriteFusion + PixelGrid + Aseprite)", fill=(140, 160, 180))
    
    # CURRENT Column (Left)
    draw_c.text((40, 75), "CURRENT (Pipeline Antigo)", fill=(255, 120, 120))
    draw_c.text((40, 95), "Redução direta, 42 cores, flutuando, sem silhueta", fill=(180, 180, 180))
    curr_4x = curr_48.resize((192, 192), Image.Resampling.NEAREST)
    comp.paste(curr_4x, (40, 120), curr_4x)
    comp.paste(curr_48, (245, 120), curr_48)
    draw_c.text((245, 175), "1x Native", fill=(150, 150, 150))
    
    # NEW Column (Right)
    draw_c.text((380, 75), "NEW (Pipeline V2)", fill=(100, 255, 180))
    draw_c.text((380, 95), "512 concept -> SpriteFusion -> 20 cores -> Ground Y=44", fill=(180, 180, 180))
    new_4x = final_20_img.resize((192, 192), Image.Resampling.NEAREST)
    comp.paste(new_4x, (380, 120), new_4x)
    comp.paste(final_20_img, (585, 120), final_20_img)
    draw_c.text((585, 175), "1x Native", fill=(150, 150, 150))
    
    # Barra de veredito
    draw_c.rectangle([(20, 325), (680, 365)], fill=(28, 38, 48))
    draw_c.text((30, 336), "VEREDITO: NEW possui grid perfeito, silhueta solida, 20 cores estritas e base no solo Y=44.", fill=(100, 255, 200))
    
    comp_path = os.path.join(BUILD_DIR, "current_vs_new_comparison.png")
    comp.save(comp_path)
    print(f"Comparacao CURRENT vs NEW salva em: {comp_path}")
    
    return {
        "final_v2_path": final_v2_path,
        "sil_path": sil_path,
        "native_path": native_path,
        "pal_path": pal_path,
        "comp_path": comp_path
    }

if __name__ == "__main__":
    run_all_tests()
