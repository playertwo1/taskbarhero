"""
Gerador de Camadas Cenicas em Pixel Art para o Bosque de Lumen (FASE R11 - Passo 8):
Produz as 4 texturas modulares com paleta estrita AMOLED e contraste Dark Fantasy:
1. bg_distant.png (216x110 px) - Silhuetas distantes, montanhas e bruma esmeralda.
2. mid_trees.png (216x110 px) - Troncos musgosos, ruinas antigas e copas medias.
3. ground_strip.png (216x42 px) - Solo, terra batida, raizes e musgo luminar.
4. fg_elements.png (216x24 px) - Samambaias, cogumelos luminosos e folhagem frontal.
"""

import os
from PIL import Image, ImageDraw
import numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT_ENV_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "environment", "bosque_lumen")

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def save_clean_png(img, path):
    # Garante alpha estritamente binario ou solido
    arr = np.array(img)
    if arr.shape[2] == 4:
        alpha = arr[:, :, 3]
        binary_alpha = np.where(alpha > 127, 255, 0).astype(np.uint8)
        arr[:, :, 3] = binary_alpha
    Image.fromarray(arr).save(path)
    print(f"[OK] Gerado: {path} ({img.size[0]}x{img.size[1]} px)")

def generate_bg_distant():
    # 216x110 px
    w, h = 216, 110
    img = Image.new("RGBA", (w, h), hex_to_rgb("#060807") + (255,))
    d = ImageDraw.Draw(img)

    c_fog1 = hex_to_rgb("#09140f")
    c_fog2 = hex_to_rgb("#0f2119")
    c_tree_far = hex_to_rgb("#142b20")

    # Bruma sutil ao fundo
    d.rectangle([0, 50, w, h], fill=c_fog1 + (255,))
    d.rectangle([0, 75, w, h], fill=c_fog2 + (255,))

    # Silhuetas de copas distantes em estilo pinheiro/arvore antiga
    for tx in [8, 32, 60, 92, 124, 156, 188]:
        tree_h = 35 + (tx % 15)
        # Copa em camadas triangulares
        d.polygon([(tx, h - tree_h), (tx - 12, h - 15), (tx + 12, h - 15)], fill=c_tree_far + (255,))
        d.polygon([(tx, h - tree_h + 8), (tx - 16, h - 10), (tx + 16, h - 10)], fill=c_tree_far + (255,))
        # Tronco
        d.rectangle([tx - 2, h - 15, tx + 2, h], fill=c_fog2 + (255,))

    save_clean_png(img, os.path.join(OUT_ENV_DIR, "bg_distant.png"))

def generate_mid_trees():
    # 216x110 px transparente
    w, h = 216, 110
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    c_bark_dark = hex_to_rgb("#16261d")
    c_bark_mid  = hex_to_rgb("#233d2f")
    c_moss      = hex_to_rgb("#325942")
    c_lumen_dot = hex_to_rgb("#56d364")
    c_stone     = hex_to_rgb("#1e2530")
    c_stone_lit = hex_to_rgb("#2f3a4a")

    # Ruína de arco de pedra à esquerda
    d.rectangle([18, 45, 26, h], fill=c_stone + (255,))
    d.rectangle([20, 48, 24, h - 10], fill=c_stone_lit + (255,))
    d.rectangle([14, 40, 30, 45], fill=c_stone + (255,))
    # Hera na pedra
    d.point([(21, 52), (22, 53), (25, 60), (19, 65)], fill=c_moss + (255,))

    # Três grandes troncos de árvores ancestrais com textura de casca e musgo
    trees_x = [55, 118, 175]
    for tx in trees_x:
        # Tronco largo
        d.rectangle([tx - 6, 25, tx + 6, h], fill=c_bark_dark + (255,))
        d.rectangle([tx - 4, 25, tx + 2, h], fill=c_bark_mid + (255,))
        # Faixas de musgo
        d.rectangle([tx - 5, 42, tx - 1, 52], fill=c_moss + (255,))
        d.rectangle([tx - 4, 68, tx + 1, 76], fill=c_moss + (255,))
        # Esporos luminescentes na casca
        d.point([(tx - 3, 46), (tx - 1, 72)], fill=c_lumen_dot + (255,))

        # Galhos curvados saindo do tronco
        d.line([(tx - 6, 38), (tx - 18, 30), (tx - 24, 24)], fill=c_bark_dark + (255,), width=2)
        d.line([(tx + 6, 42), (tx + 18, 35), (tx + 26, 32)], fill=c_bark_dark + (255,), width=2)
        # Folhagem/musgo pendurado nos galhos
        d.rectangle([tx - 20, 31, tx - 14, 35], fill=c_moss + (255,))
        d.rectangle([tx + 16, 36, tx + 22, 40], fill=c_moss + (255,))

    save_clean_png(img, os.path.join(OUT_ENV_DIR, "mid_trees.png"))

def generate_ground_strip():
    # 216x42 px
    w, h = 216, 42
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    c_soil_deep = hex_to_rgb("#0b120d")
    c_soil_dark = hex_to_rgb("#132118")
    c_moss_base = hex_to_rgb("#1e3b2b")
    c_moss_lit  = hex_to_rgb("#306346")
    c_lumen_glow= hex_to_rgb("#4ee085")

    # Solo profundo
    d.rectangle([0, 8, w, h], fill=c_soil_deep + (255,))
    d.rectangle([0, 4, w, 16], fill=c_soil_dark + (255,))

    # Camada superficial de musgo e tufos de relva
    d.rectangle([0, 2, w, 6], fill=c_moss_base + (255,))
    for x in range(0, w, 4):
        grass_h = 2 + (x % 3)
        d.line([(x, 2), (x, 2 - grass_h)], fill=c_moss_lit + (255,), width=1)
        if x % 16 == 0:
            d.point([(x, 1 - grass_h)], fill=c_lumen_glow + (255,))

    # Raízes horizontais entranhadas no solo
    for rx in range(12, w, 36):
        d.line([(rx, 10), (rx + 18, 12), (rx + 28, 9)], fill=c_soil_dark + (255,), width=2)
        d.point([(rx + 8, 11), (rx + 20, 11)], fill=c_moss_base + (255,))

    save_clean_png(img, os.path.join(OUT_ENV_DIR, "ground_strip.png"))

def generate_fg_elements():
    # 216x24 px transparente (primeiro plano na base da tela)
    w, h = 216, 24
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    c_fg_dark   = hex_to_rgb("#060a08")
    c_fg_mid    = hex_to_rgb("#0d1712")
    c_fg_moss   = hex_to_rgb("#172e21")
    c_shroom_cap= hex_to_rgb("#4ee085")
    c_shroom_stem=hex_to_rgb("#bdfcd3")

    # Folhas e samambaias recortadas na extremidade esquerda e direita
    # Esquerda:
    d.polygon([(0, h), (14, h), (8, 6), (0, 12)], fill=c_fg_dark + (255,))
    d.polygon([(10, h), (26, h), (18, 10)], fill=c_fg_mid + (255,))
    d.line([(8, h), (16, 8)], fill=c_fg_moss + (255,), width=1)

    # Cogumelos luminosos pequenos na base (X=32)
    d.rectangle([32, 16, 33, h], fill=c_shroom_stem + (255,))
    d.rectangle([30, 13, 35, 15], fill=c_shroom_cap + (255,))
    d.point([(32, 12)], fill=(255, 255, 255, 255))

    # Rocha musgosa recortada no canto direito (X=190 a 216)
    d.polygon([(190, h), (216, h), (216, 8), (196, 14)], fill=c_fg_dark + (255,))
    d.polygon([(194, h), (212, h), (210, 12), (198, 16)], fill=c_fg_mid + (255,))
    d.line([(198, 15), (206, 13)], fill=c_fg_moss + (255,), width=1)

    # Cogumelo luminoso duplo no canto direito (X=184)
    d.rectangle([184, 17, 185, h], fill=c_shroom_stem + (255,))
    d.rectangle([182, 14, 187, 16], fill=c_shroom_cap + (255,))

    save_clean_png(img, os.path.join(OUT_ENV_DIR, "fg_elements.png"))

def main():
    print("================================================================================")
    print("--- CONSTRUCAO DE CAMADAS DO CENARIO DO BOSQUE DE LUMEN (FASE R11 - PASSO 8) ---")
    print("================================================================================")

    os.makedirs(OUT_ENV_DIR, exist_ok=True)
    generate_bg_distant()
    generate_mid_trees()
    generate_ground_strip()
    generate_fg_elements()

    print("\n================================================================================")
    print("=== CAMADAS DE CENARIO GERADAS COM SUCESSO: ZERO MIXELS E AMOLED PASS ===")
    print("================================================================================")

if __name__ == "__main__":
    main()
