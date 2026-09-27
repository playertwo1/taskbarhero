"""
Gera preview da Party completa de 3 Herois (Bastiao, Iris, Flecha)
no padrao de composicao da FASE R12 (front: Bastiao, mid: Iris, back: Flecha).
"""

import os
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ARTIFACT_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"

BASTIAO_SHEET = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "bastiao", "hero_bastiao_sheet.png")
FLECHA_SHEET  = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "flecha", "hero_flecha_sheet.png")
IRIS_SHEET    = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "iris", "hero_iris_sheet.png")

WIDTH = 432
HEIGHT = 220
SCALE = 2

COLOR_BG = (6, 8, 7, 255)
COLOR_BORDER = (23, 35, 28, 255)
COLOR_TREE_BG = (11, 22, 18, 255)
COLOR_TREE_MID = (17, 34, 27, 255)
COLOR_GROUND = (16, 24, 20, 255)
COLOR_GROUND_LINE = (43, 66, 53, 255)
COLOR_MOSS = (30, 48, 37, 255)
COLOR_LUMEN_ORB = (56, 217, 169, 110)

def render_bg():
    img = Image.new("RGBA", (WIDTH, HEIGHT), COLOR_BG)
    d = ImageDraw.Draw(img, "RGBA")
    d.line([(0, 1), (WIDTH, 1)], fill=COLOR_BORDER, width=2)
    ground_y = HEIGHT - 42
    for tx in [20, 80, 140, 210, 280, 350, 410]:
        d.rectangle([tx, 40, tx + 8, ground_y], fill=COLOR_TREE_BG)
        pts = [(tx + 4, 18), (tx - 18, 75), (tx + 26, 75)]
        d.polygon(pts, fill=COLOR_TREE_MID)
    d.ellipse([int(WIDTH * 0.18 - 3.5), 55 - 3, int(WIDTH * 0.18 + 3.5), 55 + 4], fill=COLOR_LUMEN_ORB)
    d.ellipse([int(WIDTH * 0.52 - 2.5), 38 - 2, int(WIDTH * 0.52 + 2.5), 38 + 3], fill=COLOR_LUMEN_ORB)
    d.ellipse([int(WIDTH * 0.82 - 4.0), 65 - 4, int(WIDTH * 0.82 + 4.0), 65 + 4], fill=COLOR_LUMEN_ORB)
    d.rectangle([0, ground_y, WIDTH, HEIGHT], fill=COLOR_GROUND)
    d.line([(0, ground_y), (WIDTH, ground_y)], fill=COLOR_GROUND_LINE, width=2)
    for x in range(0, WIDTH, 28):
        d.line([(x, ground_y + 8), (x + 12, ground_y + 4)], fill=COLOR_MOSS, width=2)
    return img

def get_frame(sheet_path, idx=0):
    sheet = Image.open(sheet_path).convert("RGBA")
    return sheet.crop((idx * 48, 0, (idx + 1) * 48, 48))

def main():
    b_idle = get_frame(BASTIAO_SHEET, 0).resize((48 * SCALE, 48 * SCALE), Image.NEAREST)
    f_idle = get_frame(FLECHA_SHEET, 0).resize((48 * SCALE, 48 * SCALE), Image.NEAREST)
    i_idle = get_frame(IRIS_SHEET, 0).resize((48 * SCALE, 48 * SCALE), Image.NEAREST)

    ground_y = HEIGHT - 42
    pos_y = ground_y - (44 * SCALE)

    # Formacao Canônica da Party:
    # Flecha (Back): X = 50
    # Iris (Mid): X = 130
    # Bastiao (Front): X = 210
    bg = render_bg()
    bg.alpha_composite(f_idle, (50 - 24 * SCALE, pos_y))
    bg.alpha_composite(i_idle, (130 - 24 * SCALE, pos_y))
    bg.alpha_composite(b_idle, (210 - 24 * SCALE, pos_y))

    hd = bg.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST)

    out_repo = os.path.join(PROJECT_ROOT, "docs", "art", "preview_party_heroes.png")
    hd.save(out_repo)
    print("Preview da Party salvo em:", out_repo)

    out_art = os.path.join(ARTIFACT_DIR, "preview_party_heroes.png")
    hd.save(out_art)
    print("Preview da Party salvo em:", out_art)

if __name__ == "__main__":
    main()
