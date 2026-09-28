import os
from PIL import Image

PROJECT_ROOT = os.path.abspath(".")
MOCKUPS_DIR = os.path.join(PROJECT_ROOT, "docs", "art", "mockups")
UI_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "ui")

os.makedirs(os.path.join(UI_DIR, "title"), exist_ok=True)
os.makedirs(os.path.join(UI_DIR, "hub"), exist_ok=True)
os.makedirs(os.path.join(UI_DIR, "stages"), exist_ok=True)
os.makedirs(os.path.join(UI_DIR, "party"), exist_ok=True)
os.makedirs(os.path.join(UI_DIR, "frames"), exist_ok=True)

# TY40 palette
ty40_hexes = [
    '#e6dac5', '#a49983', '#7b7d6a', '#6a6548', '#4a484a', '#353235', '#425a58', '#314646',
    '#2f3140', '#182029', '#bdd2de', '#81b5a2', '#627c80', '#607a53', '#545f28', '#484c2a',
    '#223925', '#000000', '#8f5c66', '#5a4256', '#7a393d', '#562f36', '#402736', '#bf5437',
    '#842d17', '#5a231d', '#caaa6c', '#b5835a', '#855139', '#60342c', '#af8e2c', '#8a5c0a',
    '#af5722', '#703a1a', '#3b1c16', '#2a1810', '#80592e', '#554323', '#353021', '#1c200f'
]

pal_img = Image.new('P', (1, 1))
flat_pal = []
for h in ty40_hexes:
    flat_pal.extend(int(h.lstrip('#')[i:i+2], 16) for i in (0, 2, 4))
flat_pal.extend([0] * (768 - len(flat_pal)))
pal_img.putpalette(flat_pal)

def process_screen(src_filename, out_subdir, out_filename, target_size=(432, 960)):
    src_path = os.path.join(MOCKUPS_DIR, src_filename)
    im = Image.open(src_path).convert('RGB')
    
    # Resize to target viewport size
    resized = im.resize(target_size, Image.Resampling.BILINEAR)
    # Quantize to strict TY40
    quant = resized.quantize(palette=pal_img, dither=Image.Dither.FLOYDSTEINBERG)
    
    out_path = os.path.join(UI_DIR, out_subdir, out_filename)
    quant.save(out_path)
    print(f"[OK] Gerado {out_path} ({target_size[0]}x{target_size[1]})")
    return quant

# 1. Title Screen background
title_img = process_screen('ty40_title_screen_reference.png', 'title', 'title_background_432x960.png')

# 2. Hub Screen background
hub_img = process_screen('ty40_hub_screen_reference.png', 'hub', 'hub_background_432x960.png')

# 3. Stage Select background
stage_img = process_screen('ty40_stage_select_reference.png', 'stages', 'stage_select_background_432x960.png')

# 4. Party Loadout background
party_img = process_screen('ty40_party_loadout_reference.png', 'party', 'party_loadout_background_432x960.png')

print("\nProcessamento de texturas de tela concluido!")
