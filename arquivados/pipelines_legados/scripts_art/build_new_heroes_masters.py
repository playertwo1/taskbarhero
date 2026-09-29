"""
Pocket Hero — Process Generated Concepts into Master 48x48 Base Sprites
Strictly conforming to:
- Canvas: 48x48
- Baseline: Y=44, Pivot: (24, 44)
- Facing: RIGHT
- Palette: TY High Fantasy 40 (authorized subsets)
- 1px dark selective outline
- Binary alpha [0, 255]
"""

import os
from PIL import Image
import numpy as np

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
    return np.array([int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)], dtype=np.float32)

HEROES = [
    {
        'id': 'hero_brasa',
        'folder': 'brasa',
        'name': 'Brasa',
        'subsets': ['crimson', 'iron', 'wood', 'gold'],
        'max_colors': 15,
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\hero_brasa_concept_1790570461627.jpg',
        'target_h': 38,
        'y_offset': 0
    },
    {
        'id': 'hero_veu',
        'folder': 'veu',
        'name': 'Véu',
        'subsets': ['iron', 'crimson', 'neutral_stone'],
        'max_colors': 14,
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\hero_veu_concept_1790570436962.jpg',
        'target_h': 36,
        'y_offset': 0
    },
    {
        'id': 'hero_orvalho',
        'folder': 'orvalho',
        'name': 'Orvalho',
        'subsets': ['forest', 'wood', 'lumen', 'neutral_stone'],
        'max_colors': 14,
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\hero_orvalho_concept_1790570494668.jpg',
        'target_h': 34,
        'y_offset': 0
    },
    {
        'id': 'hero_forja',
        'folder': 'forja',
        'name': 'Forja',
        'subsets': ['iron', 'gold', 'lumen', 'wood'],
        'max_colors': 15,
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\hero_forja_concept_1790570523305.jpg',
        'target_h': 37,
        'y_offset': 0
    },
    {
        'id': 'hero_sino',
        'folder': 'sino',
        'name': 'Sino',
        'subsets': ['lumen', 'gold', 'crimson', 'iron'],
        'max_colors': 15,
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\hero_sino_concept_1790570552639.jpg',
        'target_h': 38,
        'y_offset': 0
    },
]

def process_all():
    base_dir = r'C:\Users\notefael\projetos\taskbarhero'
    
    for h in HEROES:
        src_img = Image.open(h['source']).convert('RGB')
        arr = np.array(src_img)
        
        # Pure white background removal
        is_bg = (arr[:, :, 0] > 235) & (arr[:, :, 1] > 235) & (arr[:, :, 2] > 235)
        
        rgba = np.zeros((arr.shape[0], arr.shape[1], 4), dtype=np.uint8)
        rgba[:, :, :3] = arr
        rgba[:, :, 3] = np.where(is_bg, 0, 255)
        
        ys, xs = np.where(rgba[:, :, 3] > 0)
        crop = rgba[ys.min():ys.max()+1, xs.min():xs.max()+1]
        crop_im = Image.fromarray(crop, mode='RGBA')
        
        # Proportional scale
        orig_w, orig_h = crop_im.size
        aspect = orig_w / float(orig_h)
        new_h = h['target_h']
        new_w = max(1, int(round(new_h * aspect)))
        if new_w > 42:
            new_w = 42
            new_h = int(round(new_w / aspect))
            
        scaled = crop_im.resize((new_w, new_h), Image.Resampling.LANCZOS)
        
        # Center horizontally and ground at Y=44
        canvas = Image.new('RGBA', (48, 48), (0, 0, 0, 0))
        pos_x = (48 - new_w) // 2
        pos_y = 44 - new_h + h['y_offset']
        if pos_y < 0:
            pos_y = 0
        canvas.paste(scaled, (pos_x, pos_y), scaled)
        
        # Color quantization to authorized subset
        allowed_hex = set()
        for s in h['subsets']:
            allowed_hex.update(PALETTE_SUBSETS[s])
        allowed_rgbs = np.array([hex_to_rgb(hx) for hx in allowed_hex])
        
        c_arr = np.array(canvas)
        bin_alpha = np.where(c_arr[:, :, 3] > 100, 255, 0).astype(np.uint8)
        out_arr = np.zeros_like(c_arr)
        out_arr[:, :, 3] = bin_alpha
        
        ys_c, xs_c = np.where(bin_alpha > 0)
        if len(ys_c) > 0:
            pxs = c_arr[ys_c, xs_c, :3].astype(np.float32)
            dists = np.sum((pxs[:, None, :] - allowed_rgbs[None, :, :]) ** 2, axis=2)
            best = np.argmin(dists, axis=1)
            for i in range(len(ys_c)):
                out_arr[ys_c[i], xs_c[i], :3] = allowed_rgbs[best[i]]
                
        # 1px outline crispness
        alpha_mask = out_arr[:, :, 3] > 0
        dark_tone = hex_to_rgb('#182029')
        for y in range(1, 47):
            for x in range(1, 47):
                if alpha_mask[y, x]:
                    if not (alpha_mask[y-1, x] and alpha_mask[y+1, x] and alpha_mask[y, x-1] and alpha_mask[y, x+1]):
                        # Perimeter pixel: if high luminance, snap to dark outline
                        if np.mean(out_arr[y, x, :3]) > 120:
                            out_arr[y, x, :3] = dark_tone
                            
        # Ensure total unique colors <= max_colors
        # Find frequency of each color
        color_counts = {}
        for y in range(48):
            for x in range(48):
                if out_arr[y, x, 3] > 0:
                    c = tuple(out_arr[y, x, :3])
                    color_counts[c] = color_counts.get(c, 0) + 1
                    
        if len(color_counts) > h['max_colors']:
            # Sort colors by frequency descending
            sorted_colors = sorted(color_counts.keys(), key=lambda c: color_counts[c], reverse=True)
            # Ensure essential dark outline '#000000' or '#182029' is kept
            top_k = sorted_colors[:h['max_colors']]
            top_k_arr = np.array(top_k, dtype=np.float32)
            
            for y in range(48):
                for x in range(48):
                    if out_arr[y, x, 3] > 0:
                        c = tuple(out_arr[y, x, :3])
                        if c not in top_k:
                            # Remap to nearest in top_k
                            dists = np.sum((np.array(c, dtype=np.float32)[None, :] - top_k_arr) ** 2, axis=1)
                            out_arr[y, x, :3] = top_k[np.argmin(dists)]
                            
        final_master = Image.fromarray(out_arr, mode='RGBA')
        
        hero_out_dir = os.path.join(base_dir, 'assets', 'sprites', 'heroes', h['folder'])
        os.makedirs(hero_out_dir, exist_ok=True)
        master_path = os.path.join(hero_out_dir, 'master_base.png')
        final_master.save(master_path)
        
        # Calculate color count
        pix_list = [tuple(p) for p in final_master.convert('RGBA').getdata() if p[3] > 0]
        unique_opaque = set(pix_list)
        print(f"Generated {h['name']} ({h['id']}): {master_path} | {len(unique_opaque)} colors (max allowed: {h['max_colors']})")

if __name__ == '__main__':
    process_all()
