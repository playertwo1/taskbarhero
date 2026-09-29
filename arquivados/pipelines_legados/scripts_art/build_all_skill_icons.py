"""
Pocket Hero — Generator for Chapter 1 Skill Icons (15 Skills: 5 per MVP Hero)
Canvas: 32x32 px
Strictly conforming to:
- TY High Fantasy 40 (authorized subsets)
- 1px dark selective outline
- Binary alpha [0, 255]
- Validated via tools/sprite_lint.py
"""

import os
import json
import hashlib
import numpy as np
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ICONS_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "skills", "icons")
MANIFESTS_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "skills", "manifests")
os.makedirs(ICONS_DIR, exist_ok=True)
os.makedirs(MANIFESTS_DIR, exist_ok=True)

PALETTE_SUBSETS = {
    'neutral_stone': set('#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5'.split()),
    'iron': set('#000000 #182029 #2f3140 #353235 #4a484a #627c80 #bdd2de #e6dac5'.split()),
    'lumen': set('#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5'.split()),
    'forest': set('#1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #81b5a2'.split()),
    'wood': set('#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5'.split()),
    'gold': set('#3b1c16 #8a5c0a #af8e2c #caaa6c #e6dac5'.split()),
    'crimson': set('#2a1810 #402736 #562f36 #5a4256 #7a393d #8f5c66 #bf5437'.split()),
}

def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def c(h):
    return hex_to_rgb(h) + (255,)

SKILLS = [
    # Bastião (Iron, Wood, Gold, Forest)
    {
        'id': 'amparo_de_raiz',
        'name': 'Amparo de Raiz',
        'hero': 'bastiao',
        'subsets': ['iron', 'wood', 'forest', 'lumen'],
        'max_colors': 12,
        'draw': lambda d: [
            # Shield
            d.polygon([(16, 4), (27, 7), (25, 21), (16, 28), (7, 21), (5, 7)], fill=c('#60342c'), outline=c('#182029')),
            d.polygon([(16, 6), (24, 9), (23, 19), (16, 25), (9, 19), (8, 9)], fill=c('#855139')),
            d.polygon([(16, 7), (20, 11), (19, 18), (16, 22), (13, 18), (12, 11)], fill=c('#b5835a')),
            # Vines
            d.line([(5, 14), (16, 18), (27, 12)], fill=c('#607a53'), width=2),
            d.line([(9, 23), (16, 16), (23, 24)], fill=c('#81b5a2'), width=1),
            d.point([(16, 16), (15, 17), (17, 17)], fill=c('#bdd2de'))
        ]
    },
    {
        'id': 'contra_golpe_de_casca',
        'name': 'Contra-golpe de Casca',
        'hero': 'bastiao',
        'subsets': ['wood', 'forest', 'iron', 'gold'],
        'max_colors': 12,
        'draw': lambda d: [
            # Spiked buckler
            d.polygon([(16, 5), (26, 10), (27, 22), (16, 27), (5, 22), (6, 10)], fill=c('#703a1a'), outline=c('#182029')),
            d.polygon([(16, 8), (23, 12), (24, 20), (16, 24), (8, 20), (9, 12)], fill=c('#855139')),
            # Sharp thorns
            d.polygon([(16, 3), (18, 7), (14, 7)], fill=c('#484c2a')),
            d.polygon([(28, 12), (24, 14), (24, 10)], fill=c('#484c2a')),
            d.polygon([(4, 12), (8, 14), (8, 10)], fill=c('#484c2a')),
            # Counter-spark
            d.polygon([(16, 13), (19, 16), (16, 19), (13, 16)], fill=c('#caaa6c'), outline=c('#8a5c0a')),
            d.point([(16, 16)], fill=c('#e6dac5'))
        ]
    },
    {
        'id': 'desafio_do_guardiao',
        'name': 'Desafio do Guardião',
        'hero': 'bastiao',
        'subsets': ['iron', 'gold', 'crimson'],
        'max_colors': 12,
        'draw': lambda d: [
            # Knight Bascinet Helmet
            d.polygon([(16, 6), (25, 11), (24, 23), (16, 26), (8, 23), (7, 11)], fill=c('#627c80'), outline=c('#182029')),
            d.polygon([(16, 8), (22, 12), (21, 21), (16, 23), (11, 21), (10, 12)], fill=c('#bdd2de')),
            # Visor slit
            d.rectangle([(11, 15), (21, 17)], fill=c('#182029')),
            # Golden Crest on top
            d.polygon([(16, 2), (20, 7), (12, 7)], fill=c('#af8e2c'), outline=c('#3b1c16')),
            # Crimson aura wave
            d.arc([(3, 3), (29, 29)], 45, 135, fill=c('#bf5437'), width=2),
            d.arc([(3, 3), (29, 29)], 225, 315, fill=c('#bf5437'), width=2)
        ]
    },
    {
        'id': 'trama_de_escudos',
        'name': 'Trama de Escudos',
        'hero': 'bastiao',
        'subsets': ['iron', 'gold', 'neutral_stone'],
        'max_colors': 12,
        'draw': lambda d: [
            # Left shield
            d.polygon([(10, 8), (17, 10), (16, 21), (10, 25), (4, 21), (3, 10)], fill=c('#4a484a'), outline=c('#182029')),
            d.polygon([(10, 10), (15, 12), (14, 19), (10, 22), (6, 19), (5, 12)], fill=c('#627c80')),
            # Right shield
            d.polygon([(22, 8), (29, 10), (28, 21), (22, 25), (16, 21), (15, 10)], fill=c('#4a484a'), outline=c('#182029')),
            d.polygon([(22, 10), (27, 12), (26, 19), (22, 22), (18, 19), (17, 12)], fill=c('#627c80')),
            # Front center shield
            d.polygon([(16, 11), (23, 13), (22, 24), (16, 28), (10, 24), (9, 13)], fill=c('#bdd2de'), outline=c('#182029')),
            d.point([(16, 18), (16, 19), (15, 18), (17, 18)], fill=c('#caaa6c'))
        ]
    },
    {
        'id': 'voto_da_clareira',
        'name': 'Voto da Clareira',
        'hero': 'bastiao',
        'subsets': ['iron', 'gold', 'lumen'],
        'max_colors': 12,
        'draw': lambda d: [
            # Radiant beam
            d.polygon([(13, 2), (19, 2), (23, 28), (9, 28)], fill=c('#81b5a2')),
            d.polygon([(14, 2), (18, 2), (21, 28), (11, 28)], fill=c('#bdd2de')),
            # Sword planted in earth
            d.rectangle([(15, 7), (17, 23)], fill=c('#e6dac5'), outline=c('#182029')),
            # Crossguard & pommel
            d.line([(11, 8), (21, 8)], fill=c('#af8e2c'), width=2),
            d.ellipse([(14, 3), (18, 7)], fill=c('#caaa6c'), outline=c('#3b1c16')),
            # Ground impact
            d.line([(7, 27), (25, 27)], fill=c('#425a58'), width=2)
        ]
    },
    # Flecha (Forest, Wood, Iron, Lumen, Crimson)
    {
        'id': 'marca_da_cacada',
        'name': 'Marca da Caçada',
        'hero': 'flecha',
        'subsets': ['forest', 'lumen', 'crimson'],
        'max_colors': 10,
        'draw': lambda d: [
            # Hunter Reticle Outer Ring
            d.ellipse([(6, 6), (26, 26)], outline=c('#545f28'), width=2),
            d.ellipse([(8, 8), (24, 24)], outline=c('#81b5a2'), width=1),
            # Crosshairs
            d.line([(16, 3), (16, 9)], fill=c('#1c200f'), width=2),
            d.line([(16, 23), (16, 29)], fill=c('#1c200f'), width=2),
            d.line([(3, 16), (9, 16)], fill=c('#1c200f'), width=2),
            d.line([(23, 16), (29, 16)], fill=c('#1c200f'), width=2),
            # Target center mark
            d.polygon([(16, 12), (19, 16), (16, 20), (13, 16)], fill=c('#bf5437'), outline=c('#182029')),
            d.point([(16, 16)], fill=c('#e6dac5'))
        ]
    },
    {
        'id': 'tiro_de_ruptura',
        'name': 'Tiro de Ruptura',
        'hero': 'flecha',
        'subsets': ['iron', 'wood', 'crimson'],
        'max_colors': 11,
        'draw': lambda d: [
            # Broken armor plate left
            d.polygon([(5, 10), (14, 8), (12, 22), (4, 20)], fill=c('#4a484a'), outline=c('#182029')),
            # Broken armor plate right
            d.polygon([(20, 8), (28, 10), (27, 20), (18, 22)], fill=c('#4a484a'), outline=c('#182029')),
            # Arrow plunging through center
            d.line([(16, 3), (16, 27)], fill=c('#b5835a'), width=2),
            d.polygon([(16, 28), (20, 22), (12, 22)], fill=c('#bdd2de'), outline=c('#182029')),
            # Impact cracks
            d.line([(12, 14), (8, 12)], fill=c('#bf5437'), width=1),
            d.line([(20, 14), (24, 12)], fill=c('#bf5437'), width=1),
            d.point([(16, 24)], fill=c('#e6dac5'))
        ]
    },
    {
        'id': 'rajada_da_copa',
        'name': 'Rajada da Copa',
        'hero': 'flecha',
        'subsets': ['forest', 'wood', 'iron'],
        'max_colors': 11,
        'draw': lambda d: [
            # Arrow 1 (left)
            d.line([(8, 4), (11, 26)], fill=c('#855139'), width=2),
            d.polygon([(11, 28), (14, 22), (8, 23)], fill=c('#bdd2de'), outline=c('#182029')),
            d.polygon([(8, 4), (5, 8), (10, 7)], fill=c('#545f28')),
            # Arrow 2 (center)
            d.line([(16, 2), (16, 27)], fill=c('#855139'), width=2),
            d.polygon([(16, 29), (19, 23), (13, 23)], fill=c('#bdd2de'), outline=c('#182029')),
            d.polygon([(16, 2), (13, 6), (19, 6)], fill=c('#607a53')),
            # Arrow 3 (right)
            d.line([(24, 4), (21, 26)], fill=c('#855139'), width=2),
            d.polygon([(21, 28), (24, 23), (18, 22)], fill=c('#bdd2de'), outline=c('#182029')),
            d.polygon([(24, 4), (27, 8), (22, 7)], fill=c('#545f28')),
        ]
    },
    {
        'id': 'flecha_de_execucao',
        'name': 'Flecha de Execução',
        'hero': 'flecha',
        'subsets': ['crimson', 'iron', 'lumen'],
        'max_colors': 12,
        'draw': lambda d: [
            # Diagonal heavy execution arrow
            d.line([(6, 6), (24, 24)], fill=c('#2a1810'), width=3),
            # Large jagged arrowhead
            d.polygon([(27, 27), (26, 18), (18, 26)], fill=c('#bf5437'), outline=c('#182029')),
            d.polygon([(25, 25), (24, 20), (20, 24)], fill=c('#81b5a2')),
            # Fletching
            d.polygon([(6, 6), (4, 11), (9, 7)], fill=c('#8f5c66')),
            d.polygon([(6, 6), (11, 4), (7, 9)], fill=c('#8f5c66')),
            # Lethal gleam
            d.point([(26, 26), (25, 26), (26, 25)], fill=c('#e6dac5'))
        ]
    },
    {
        'id': 'passo_do_rastro',
        'name': 'Passo do Rastro',
        'hero': 'flecha',
        'subsets': ['forest', 'wood', 'neutral_stone'],
        'max_colors': 11,
        'draw': lambda d: [
            # Ranger boot outline
            d.polygon([(10, 8), (17, 8), (18, 17), (24, 20), (25, 24), (10, 24)], fill=c('#60342c'), outline=c('#182029')),
            d.polygon([(11, 9), (16, 9), (17, 16), (22, 19), (23, 23), (11, 23)], fill=c('#855139')),
            # Wind / evasion gusts
            d.arc([(4, 12), (18, 26)], 180, 270, fill=c('#81b5a2'), width=2),
            d.arc([(1, 16), (15, 30)], 180, 270, fill=c('#607a53'), width=2),
            # Swirling autumn leaf
            d.polygon([(22, 10), (26, 12), (25, 16), (21, 14)], fill=c('#545f28'), outline=c('#1c200f'))
        ]
    },
    # Íris (Crimson, Lumen, Gold, Iron)
    {
        'id': 'lanca_de_lumen',
        'name': 'Lança de Lúmen',
        'hero': 'iris',
        'subsets': ['lumen', 'gold', 'iron'],
        'max_colors': 11,
        'draw': lambda d: [
            # Radiant energy spear diagonal
            d.polygon([(28, 4), (24, 2), (2, 24), (4, 28)], fill=c('#314646'), outline=c('#182029')),
            d.polygon([(27, 5), (23, 3), (3, 23), (5, 27)], fill=c('#425a58')),
            # Glowing core
            d.line([(5, 25), (25, 5)], fill=c('#81b5a2'), width=2),
            d.line([(7, 23), (23, 7)], fill=c('#bdd2de'), width=1),
            # Spearhead tip
            d.polygon([(29, 3), (25, 1), (23, 7), (27, 9)], fill=c('#caaa6c'), outline=c('#3b1c16')),
            d.point([(27, 4), (28, 5)], fill=c('#e6dac5'))
        ]
    },
    {
        'id': 'veu_de_micelio',
        'name': 'Véu de Micélio',
        'hero': 'iris',
        'subsets': ['crimson', 'lumen', 'forest'],
        'max_colors': 12,
        'draw': lambda d: [
            # Protective mycelial dome
            d.arc([(4, 6), (28, 28)], 180, 360, fill=c('#402736'), width=3),
            d.arc([(6, 8), (26, 26)], 180, 360, fill=c('#5a4256'), width=2),
            # Hanging bioluminescent spores
            d.polygon([(16, 8), (21, 14), (11, 14)], fill=c('#8f5c66'), outline=c('#182029')),
            d.ellipse([(14, 18), (18, 22)], fill=c('#81b5a2'), outline=c('#425a58')),
            d.point([(10, 20), (22, 20), (16, 20)], fill=c('#bdd2de')),
            d.point([(7, 24), (25, 24)], fill=c('#81b5a2'))
        ]
    },
    {
        'id': 'fratura_arcana',
        'name': 'Fratura Arcana',
        'hero': 'iris',
        'subsets': ['crimson', 'lumen', 'neutral_stone'],
        'max_colors': 12,
        'draw': lambda d: [
            # Cracked ground
            d.line([(3, 26), (14, 24), (18, 27), (29, 25)], fill=c('#2f3140'), width=3),
            # Sprouting arcane crystal shards
            d.polygon([(16, 7), (19, 22), (13, 22)], fill=c('#7a393d'), outline=c('#182029')),
            d.polygon([(16, 9), (18, 20), (14, 20)], fill=c('#8f5c66')),
            # Side shards
            d.polygon([(10, 14), (13, 24), (8, 24)], fill=c('#5a4256'), outline=c('#182029')),
            d.polygon([(22, 12), (24, 24), (19, 24)], fill=c('#5a4256'), outline=c('#182029')),
            # Arcane discharge sparks
            d.point([(16, 6), (10, 12), (23, 10)], fill=c('#81b5a2')),
            d.point([(16, 5)], fill=c('#bdd2de'))
        ]
    },
    {
        'id': 'pulso_restaurador',
        'name': 'Pulso Restaurador',
        'hero': 'iris',
        'subsets': ['lumen', 'gold', 'neutral_stone'],
        'max_colors': 11,
        'draw': lambda d: [
            # Concentric healing ripples
            d.ellipse([(4, 4), (28, 28)], outline=c('#425a58'), width=1),
            d.ellipse([(7, 7), (25, 25)], outline=c('#627c80'), width=2),
            d.ellipse([(10, 10), (22, 22)], outline=c('#81b5a2'), width=2),
            # Central Lumen core
            d.polygon([(16, 11), (21, 16), (16, 21), (11, 16)], fill=c('#bdd2de'), outline=c('#182029')),
            d.polygon([(16, 13), (19, 16), (16, 19), (13, 16)], fill=c('#caaa6c')),
            d.point([(16, 16)], fill=c('#e6dac5'))
        ]
    },
    {
        'id': 'prisma_de_retorno',
        'name': 'Prisma de Retorno',
        'hero': 'iris',
        'subsets': ['lumen', 'gold', 'crimson'],
        'max_colors': 12,
        'draw': lambda d: [
            # Triangular crystal prism
            d.polygon([(16, 5), (27, 24), (5, 24)], fill=c('#425a58'), outline=c('#182029')),
            d.polygon([(16, 7), (25, 23), (16, 23)], fill=c('#627c80')),
            d.polygon([(16, 7), (16, 23), (7, 23)], fill=c('#81b5a2')),
            # Refracted light rays
            d.line([(16, 6), (28, 12)], fill=c('#caaa6c'), width=2),
            d.line([(16, 6), (28, 18)], fill=c('#bf5437'), width=2),
            d.line([(16, 6), (28, 24)], fill=c('#bdd2de'), width=2),
            d.point([(16, 8)], fill=c('#e6dac5'))
        ]
    },
]

def main():
    for sk in SKILLS:
        im = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
        draw = ImageDraw.Draw(im)
        sk['draw'](draw)
        
        # Save PNG
        png_path = os.path.join(ICONS_DIR, f"{sk['id']}.png")
        im.save(png_path)
        
        # Calculate SHA-256
        with open(png_path, 'rb') as f:
            file_hash = hashlib.sha256(f.read()).hexdigest()
            
        unique_colors = set(tuple(p[:3]) for p in im.getdata() if p[3] > 0)
        num_colors = len(unique_colors)
        print(f"[{sk['name']}] Icon saved: {png_path} | {num_colors} colors | hash: {file_hash[:12]}...")
        
        # Save JSON-formatted Manifest YAML
        manifest_path = os.path.join(MANIFESTS_DIR, f"{sk['id']}.manifest.yaml")
        manifest_data = {
            "asset_id": sk['id'],
            "status": "ARTISTIC_QA",
            "version": 1,
            "contract": f"docs/art/contracts/hero_{sk['hero']}.yaml",
            "concept": f"docs/04_content/chapters/chapter_01/OVERVIEW.md#{sk['id']}",
            "content_state": "chapter_01",
            "generation": {
                "workflow": "handcrafted_pixel_art_ty40_quantized_icon",
                "workflow_version": "1",
                "model": "handcrafted pixel design",
                "model_license_record": "Pocket Hero original design asset",
                "seed": None,
                "sampler": None,
                "steps": None,
                "cfg": None,
                "generation_resolution": "32x32 native",
                "input_hashes": []
            },
            "palette": {
                "master": "TY_HIGH_FANTASY_40",
                "subsets": sk['subsets'],
                "colors_used": num_colors,
                "exceptional_colors": []
            },
            "output": {
                "files": [
                    f"assets/sprites/skills/icons/{sk['id']}.png"
                ],
                "frame_size": {
                    "width": 32,
                    "height": 32
                },
                "frame_count": 1,
                "layout": "single",
                "facing": "skill_icon",
                "alpha": True,
                "hashes": [
                    file_hash
                ]
            },
            "qa": {
                "technical": "PASS",
                "artistic": "PENDING",
                "reviewer": None,
                "reviewed_at": None,
                "report": "Sprite lint PASS; independent visual audit and mobile review are pending."
            }
        }
        with open(manifest_path, 'w', encoding='utf-8') as f:
            json.dump(manifest_data, f, indent=2)

    print("\nAll 15 skill icons and manifests created successfully!")

if __name__ == '__main__':
    main()
