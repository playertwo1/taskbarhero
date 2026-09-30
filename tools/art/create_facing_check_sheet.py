import os
from PIL import Image, ImageDraw, ImageFont

PROJECT_ROOT = r"C:\Users\notefael\projetos\taskbarhero"
ARTIFACTS_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"

HEROES = [
    ("Bastiao", "assets/sprites/heroes/bastiao/hero_bastiao_sheet.png", 48),
    ("Flecha", "assets/sprites/heroes/flecha/hero_flecha_sheet.png", 48),
    ("Iris", "assets/sprites/heroes/iris/hero_iris_sheet.png", 48),
    ("Brasa", "assets/sprites/heroes/brasa/hero_brasa_sheet.png", 48),
    ("Veu", "assets/sprites/heroes/veu/hero_veu_sheet.png", 48),
    ("Orvalho", "assets/sprites/heroes/orvalho/hero_orvalho_sheet.png", 48),
    ("Forja", "assets/sprites/heroes/forja/hero_forja_sheet.png", 48),
    ("Sino", "assets/sprites/heroes/sino/hero_sino_sheet.png", 48),
]

ENEMIES = [
    ("Geleia", "assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png", 64),
    ("Gremlin", "assets/sprites/enemies/gremlin_de_folha/mob_gremlin_folha_sheet.png", 32),
    ("Javali", "assets/sprites/enemies/javali_de_musgo/mob_javali_musgo_sheet.png", 48),
    ("Espirito", "assets/sprites/enemies/espirito_de_raiz/mob_espirito_raiz_sheet.png", 48),
    ("Lobo Alfa", "assets/sprites/enemies/lobo_alfa_de_lumen/mob_lobo_alfa_sheet.png", 48),
    ("Guardiao Cervo", "assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_sheet.png", 64),
    ("Saqueador", "assets/sprites/enemies/saqueador_da_mata/mob_saqueador_mata_sheet.png", 48),
    ("Xama", "assets/sprites/enemies/xama_de_esporos/mob_xama_esporos_sheet.png", 48),
    ("Sentinela", "assets/sprites/enemies/sentinela_de_raizes/mob_sentinela_raizes_sheet.png", 48),
    ("Lobo Sombra", "assets/sprites/enemies/lobo_de_sombra/mob_lobo_sombra_sheet.png", 48),
    ("Matriarca", "assets/sprites/bosses/matriarca_micelio/boss_matriarca_micelio_sheet.png", 64),
]

cell_size = 64
scale = 3 # 64 * 3 = 192px per cell

# Create image:
# Section 1: HEROES (should face RIGHT ->)
# Section 2: ENEMIES (should face LEFT <-)
cols = 8
rows_heroes = 1
rows_enemies = 2

out_w = cols * (cell_size * scale + 10) + 20
out_h = 40 + (rows_heroes + rows_enemies) * (cell_size * scale + 40) + 60
sheet = Image.new("RGBA", (out_w, out_h), (18, 20, 26, 255))
draw = ImageDraw.Draw(sheet)

# Title
draw.text((20, 10), "HEROIS (Devem olhar para a DIREITA ->)", fill=(240, 200, 70, 255))

for i, (name, path, sz) in enumerate(HEROES):
    full_p = os.path.join(PROJECT_ROOT, path)
    im = Image.open(full_p)
    fr0 = im.crop((0, 0, sz, sz))
    # normalize to 64x64
    c64 = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    offset_y = 64 - sz
    c64.paste(fr0, ((64 - sz) // 2, offset_y), fr0)
    scaled = c64.resize((cell_size * scale, cell_size * scale), Image.Resampling.NEAREST)
    
    x = 20 + i * (cell_size * scale + 10)
    y = 35
    # card background
    draw.rectangle([x, y, x + cell_size * scale, y + cell_size * scale], fill=(28, 32, 42, 255), outline=(50, 60, 80, 255))
    sheet.paste(scaled, (x, y), scaled)
    draw.text((x + 5, y + cell_size * scale + 5), name, fill=(220, 220, 230, 255))

y_enemies_start = 35 + cell_size * scale + 50
draw.text((20, y_enemies_start - 25), "INIMIGOS (Devem olhar para a ESQUERDA <-)", fill=(230, 90, 80, 255))

for i, (name, path, sz) in enumerate(ENEMIES):
    full_p = os.path.join(PROJECT_ROOT, path)
    im = Image.open(full_p)
    fr0 = im.crop((0, 0, sz, sz))
    c64 = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    offset_y = 64 - sz
    c64.paste(fr0, ((64 - sz) // 2, offset_y), fr0)
    scaled = c64.resize((cell_size * scale, cell_size * scale), Image.Resampling.NEAREST)
    
    col = i % cols
    row = i // cols
    x = 20 + col * (cell_size * scale + 10)
    y = y_enemies_start + row * (cell_size * scale + 40)
    
    draw.rectangle([x, y, x + cell_size * scale, y + cell_size * scale], fill=(28, 32, 42, 255), outline=(60, 40, 50, 255))
    sheet.paste(scaled, (x, y), scaled)
    draw.text((x + 5, y + cell_size * scale + 5), name, fill=(220, 220, 230, 255))

out_path = os.path.join(ARTIFACTS_DIR, "all_characters_facing_check.png")
sheet.save(out_path)
print(f"Salvo em {out_path}")
