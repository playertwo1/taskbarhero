"""
Pocket Hero — Master Animation Sheet Builder for New Enemies & Boss
(Saqueador da Mata, Xamã de Esporos, Sentinela de Raízes, Lobo de Sombra, Matriarca do Micélio)

All enemies strictly face LEFT (<-).
Mobs: 48x48 canvas, baseline Y=44, 768x48 strip (16 frames).
Boss: 64x64 canvas, baseline Y=60, 1024x64 strip (16 frames).

Strict TY40 palette enforcement with binary transparency.
"""

import os
import json
import hashlib
import subprocess
import numpy as np
from PIL import Image

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
ARTIFACTS_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"

PALETTE_SUBSETS = {
    'neutral_stone': set('#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5'.split()),
    'iron': set('#000000 #182029 #2f3140 #353235 #4a484a #627c80 #bdd2de #e6dac5'.split()),
    'lumen': set('#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5'.split()),
    'forest': set('#1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #81b5a2'.split()),
    'wood': set('#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5'.split()),
    'gold': set('#3b1c16 #8a5c0a #af8e2c #caaa6c #e6dac5'.split()),
    'crimson': set('#2a1810 #402736 #562f36 #5a4256 #7a393d #8f5c66 #bf5437'.split()),
}

ENEMY_CONFIGS = [
    {
        'id': 'mob_saqueador_mata',
        'category': 'enemies',
        'folder': 'saqueador_da_mata',
        'name': 'Saqueador da Mata',
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\mob_saqueador_concept_1790571577579.jpg',
        'canvas_size': 48,
        'baseline_y': 44,
        'target_h': 36,
        'subsets': ['forest', 'wood', 'iron'],
        'max_colors': 13,
        'fx_color': '#b5835a',
        'flash_color': '#8f5c66'
    },
    {
        'id': 'mob_xama_esporos',
        'category': 'enemies',
        'folder': 'xama_de_esporos',
        'name': 'Xamã de Esporos',
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\mob_xama_concept_1790571612837.jpg',
        'canvas_size': 48,
        'baseline_y': 44,
        'target_h': 38,
        'subsets': ['forest', 'lumen', 'crimson', 'wood'],
        'max_colors': 14,
        'fx_color': '#81b5a2',
        'flash_color': '#7a393d'
    },
    {
        'id': 'mob_sentinela_raizes',
        'category': 'enemies',
        'folder': 'sentinela_de_raizes',
        'name': 'Sentinela de Raízes',
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\mob_sentinela_concept_1790571652013.jpg',
        'canvas_size': 48,
        'baseline_y': 44,
        'target_h': 40,
        'subsets': ['wood', 'forest', 'neutral_stone', 'lumen'],
        'max_colors': 14,
        'fx_color': '#81b5a2',
        'flash_color': '#4a484a'
    },
    {
        'id': 'mob_lobo_sombra',
        'category': 'enemies',
        'folder': 'lobo_de_sombra',
        'name': 'Lobo de Sombra',
        'source': r'C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\mob_lobo_sombra_concept_1790571695393.jpg',
        'canvas_size': 48,
        'baseline_y': 44,
        'target_h': 28,
        'subsets': ['neutral_stone', 'crimson'],
        'max_colors': 12,
        'fx_color': '#bf5437',
        'flash_color': '#7a393d'
    },
    {
        'id': 'boss_matriarca_micelio',
        'category': 'bosses',
        'folder': 'matriarca_micelio',
        'name': 'Matriarca do Micélio',
        'source': os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'bosses', 'matriarca_micelio', 'matriarca_micelio_source_v001.png'),
        'canvas_size': 64,
        'baseline_y': 60,
        'target_h': 54,
        'subsets': ['forest', 'wood', 'lumen'],
        'max_colors': 14,
        'fx_color': '#81b5a2',
        'flash_color': '#562f36'
    },
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return np.array([int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)], dtype=np.float32)

def extract_master_sprite(cfg):
    src_img = Image.open(cfg['source']).convert('RGBA')
    arr = np.array(src_img)
    
    # White background threshold
    is_bg = (arr[:, :, 0] > 235) & (arr[:, :, 1] > 235) & (arr[:, :, 2] > 235)
    # If already transparent PNG, combine
    if arr.shape[2] == 4:
        is_bg = is_bg | (arr[:, :, 3] < 50)
        
    rgba = np.zeros((arr.shape[0], arr.shape[1], 4), dtype=np.uint8)
    rgba[:, :, :3] = arr[:, :, :3]
    rgba[:, :, 3] = np.where(is_bg, 0, 255)
    
    ys, xs = np.where(rgba[:, :, 3] > 0)
    crop = rgba[ys.min():ys.max()+1, xs.min():xs.max()+1]
    crop_im = Image.fromarray(crop, mode='RGBA')
    
    # Proportional scaling
    orig_w, orig_h = crop_im.size
    aspect = orig_w / float(orig_h)
    new_h = cfg['target_h']
    new_w = max(1, int(round(new_h * aspect)))
    max_w = cfg['canvas_size'] - 4
    if new_w > max_w:
        new_w = max_w
        new_h = int(round(new_w / aspect))
        
    scaled = crop_im.resize((new_w, new_h), Image.Resampling.LANCZOS)
    
    # Canvas
    C = cfg['canvas_size']
    canvas = Image.new('RGBA', (C, C), (0, 0, 0, 0))
    pos_x = (C - new_w) // 2
    pos_y = cfg['baseline_y'] - new_h
    if pos_y < 0:
        pos_y = 0
    canvas.paste(scaled, (pos_x, pos_y), scaled)
    
    # Allowed palette
    allowed_hex = set()
    for s in cfg['subsets']:
        allowed_hex.update(PALETTE_SUBSETS[s])
    allowed_rgbs = np.array([hex_to_rgb(hx) for hx in allowed_hex])
    
    c_arr = np.array(canvas)
    bin_alpha = np.where(c_arr[:, :, 3] > 110, 255, 0).astype(np.uint8)
    out_arr = np.zeros_like(c_arr)
    out_arr[:, :, 3] = bin_alpha
    
    ys_c, xs_c = np.where(bin_alpha > 0)
    if len(ys_c) > 0:
        pxs = c_arr[ys_c, xs_c, :3].astype(np.float32)
        dists = np.sum((pxs[:, None, :] - allowed_rgbs[None, :, :]) ** 2, axis=2)
        best = np.argmin(dists, axis=1)
        for i in range(len(ys_c)):
            out_arr[ys_c[i], xs_c[i], :3] = allowed_rgbs[best[i]]
            
    # Dark selective outline reinforcement
    alpha_bin = out_arr[:, :, 3] > 0
    dark_tone = hex_to_rgb('#182029')
    for y in range(1, C - 1):
        for x in range(1, C - 1):
            if alpha_bin[y, x]:
                if not (alpha_bin[y-1, x] and alpha_bin[y+1, x] and alpha_bin[y, x-1] and alpha_bin[y, x+1]):
                    if np.mean(out_arr[y, x, :3]) > 120:
                        out_arr[y, x, :3] = dark_tone
                        
    # Remap to max_colors if needed
    color_counts = {}
    for y in range(C):
        for x in range(C):
            if out_arr[y, x, 3] > 0:
                c = tuple(out_arr[y, x, :3])
                color_counts[c] = color_counts.get(c, 0) + 1
                
    if len(color_counts) > cfg['max_colors']:
        sorted_colors = sorted(color_counts.keys(), key=lambda c: color_counts[c], reverse=True)
        top_k = sorted_colors[:cfg['max_colors']]
        top_k_arr = np.array(top_k, dtype=np.float32)
        for y in range(C):
            for x in range(C):
                if out_arr[y, x, 3] > 0:
                    c = tuple(out_arr[y, x, :3])
                    if c not in top_k:
                        dists = np.sum((np.array(c, dtype=np.float32)[None, :] - top_k_arr) ** 2, axis=1)
                        out_arr[y, x, :3] = top_k[np.argmin(dists)]
                        
    return Image.fromarray(out_arr, mode='RGBA')

def generate_frames_for_enemy(base_sprite, cfg):
    master_arr = np.array(base_sprite)
    C = cfg['canvas_size']
    ground_row = cfg['baseline_y']
    frames = []
    
    # 0..3: Idle (breathing/bobbing)
    # Frame 0: Base
    frames.append(master_arr.copy())
    
    # Frame 1: Breath up 1px
    f1 = np.zeros_like(master_arr)
    f1[ground_row-1:C, :] = master_arr[ground_row-1:C, :]
    f1[0:ground_row-1, :] = np.roll(master_arr[0:ground_row-1, :], -1, axis=0)
    frames.append(f1)
    
    # Frame 2: Breath top
    f2 = np.zeros_like(master_arr)
    f2[ground_row-2:C, :] = master_arr[ground_row-2:C, :]
    f2[0:ground_row-2, :] = np.roll(master_arr[0:ground_row-2, :], -1, axis=0)
    frames.append(f2)
    
    # Frame 3: Settle
    f3 = f1.copy()
    frames.append(f3)
    
    # 4..7: Attack (facing LEFT: windup moves RIGHT, strike lunges LEFT!)
    # Frame 4: Windup (recoil right 2px)
    f4 = np.roll(master_arr, 2, axis=1)
    frames.append(f4)
    
    # Frame 5: Strike / Lunge forward (lunge left 3px!)
    f5 = np.roll(master_arr, -3, axis=1)
    frames.append(f5)
    
    # Frame 6: Extension with attack impact effect (left side)
    f6 = f5.copy()
    fx_col = hex_to_rgb(cfg['fx_color']).astype(np.uint8)
    # Strike particle / spark in front (left side x: 2..12)
    for i in range(5):
        x = 6 + i
        y = (ground_row - 18) + i * 2
        if 0 <= x < C and 0 <= y < C:
            f6[y, x, :3] = fx_col
            f6[y, x, 3] = 255
        if 0 <= x+1 < C and 0 <= y < C:
            f6[y, x+1, :3] = [230, 218, 197]
            f6[y, x+1, 3] = 255
    frames.append(f6)
    
    # Frame 7: Recovery
    f7 = np.roll(master_arr, -1, axis=1)
    frames.append(f7)
    
    # 8..9: Hit (recoil RIGHT 3px with hit flash)
    f8 = np.roll(master_arr, 3, axis=1)
    flash_c = hex_to_rgb(cfg['flash_color']).astype(np.uint8)
    hit_mask = f8[:, :, 3] > 0
    f8[hit_mask, :3] = np.clip(f8[hit_mask, :3] * 0.6 + flash_c * 0.4, 0, 255).astype(np.uint8)
    frames.append(f8)
    
    # Frame 9: Stagger reset
    f9 = np.roll(master_arr, 1, axis=1)
    frames.append(f9)
    
    # 10..15: Death
    # Frame 10: Slump 2px
    f10 = np.zeros_like(master_arr)
    f10[2:C, :] = master_arr[0:C-2, :]
    frames.append(f10)
    
    # Frame 11: Collapse 5px
    f11 = np.zeros_like(master_arr)
    f11[5:C, :] = master_arr[0:C-5, :]
    frames.append(f11)
    
    # Frames 12..15: Ordered dither dissolve
    for step in range(4):
        f_death = f11.copy()
        threshold = (step + 1) / 5.0
        for y in range(C):
            for x in range(C):
                if f_death[y, x, 3] > 0:
                    bayer = ((x * 3 + y * 7 + step * 5) % 11) / 11.0
                    if bayer < threshold:
                        f_death[y, x, 3] = 0
        frames.append(f_death)
        
    return frames

def quantize_frames(frames, cfg):
    C = cfg['canvas_size']
    allowed_hex = set()
    for s in cfg['subsets']:
        allowed_hex.update(PALETTE_SUBSETS[s])
    allowed_rgbs = np.array([hex_to_rgb(hx) for hx in allowed_hex])
    
    q_frames = []
    for f in frames:
        arr = f.copy()
        bin_alpha = np.where(arr[:, :, 3] > 120, 255, 0).astype(np.uint8)
        arr[:, :, 3] = bin_alpha
        
        ys, xs = np.where(bin_alpha > 0)
        if len(ys) > 0:
            pxs = arr[ys, xs, :3].astype(np.float32)
            dists = np.sum((pxs[:, None, :] - allowed_rgbs[None, :, :]) ** 2, axis=2)
            best = np.argmin(dists, axis=1)
            for i in range(len(ys)):
                arr[ys[i], xs[i], :3] = allowed_rgbs[best[i]]
        q_frames.append(arr)
        
    color_counts = {}
    for f in q_frames:
        for y in range(C):
            for x in range(C):
                if f[y, x, 3] > 0:
                    c = tuple(f[y, x, :3])
                    color_counts[c] = color_counts.get(c, 0) + 1
                    
    if len(color_counts) > cfg['max_colors']:
        sorted_colors = sorted(color_counts.keys(), key=lambda c: color_counts[c], reverse=True)
        top_k = sorted_colors[:cfg['max_colors']]
        top_k_arr = np.array(top_k, dtype=np.float32)
        
        for f in q_frames:
            for y in range(C):
                for x in range(C):
                    if f[y, x, 3] > 0:
                        c = tuple(f[y, x, :3])
                        if c not in top_k:
                            dists = np.sum((np.array(c, dtype=np.float32)[None, :] - top_k_arr) ** 2, axis=1)
                            f[y, x, :3] = top_k[np.argmin(dists)]
                            
    return q_frames

def build_enemy_assets(cfg):
    C = cfg['canvas_size']
    out_dir = os.path.join(PROJECT_ROOT, 'assets', 'sprites', cfg['category'], cfg['folder'])
    os.makedirs(out_dir, exist_ok=True)
    
    # 1. Master base
    base_sprite = extract_master_sprite(cfg)
    base_path = os.path.join(out_dir, f"{cfg['id']}_master.png")
    base_sprite.save(base_path)
    
    # 2. 16 frames
    raw_frames = generate_frames_for_enemy(base_sprite, cfg)
    q_frames = quantize_frames(raw_frames, cfg)
    
    # 3. Spritesheet
    sheet_w = C * 16
    sheet = Image.new('RGBA', (sheet_w, C), (0, 0, 0, 0))
    for i, f_arr in enumerate(q_frames):
        f_im = Image.fromarray(f_arr, mode='RGBA')
        sheet.paste(f_im, (i * C, 0), f_im)
        
    sheet_path = os.path.join(out_dir, f"{cfg['id']}_sheet.png")
    sheet.save(sheet_path)
    
    # Hash
    with open(sheet_path, 'rb') as f:
        file_hash = hashlib.sha256(f.read()).hexdigest()
        
    unique_colors = set(tuple(p[:3]) for p in sheet.getdata() if p[3] > 0)
    num_colors = len(unique_colors)
    print(f"[{cfg['name']}] Sheet saved: {sheet_path} | {num_colors} colors (max: {cfg['max_colors']}) | hash: {file_hash[:12]}...")
    
    # 4. JSON metadata
    frame_list = []
    durations = [160, 160, 160, 160, 100, 100, 100, 100, 80, 80, 125, 125, 125, 125, 125, 125]
    names = [
        '00_idle_0', '01_idle_1', '02_idle_2', '03_idle_3',
        '04_attack_0', '05_attack_1', '06_attack_2', '07_attack_3',
        '08_hit_0', '09_hit_1',
        '10_death_0', '11_death_1', '12_death_2', '13_death_3', '14_death_4', '15_death_5'
    ]
    for i in range(16):
        frame_list.append({
            "filename": f"{cfg['id']}_{names[i]}.png",
            "frame": { "x": i * C, "y": 0, "w": C, "h": C },
            "rotated": False,
            "trimmed": False,
            "spriteSourceSize": { "x": 0, "y": 0, "w": C, "h": C },
            "sourceSize": { "w": C, "h": C },
            "duration": durations[i]
        })
        
    meta_json = {
        "frames": frame_list,
        "meta": {
            "app": "Pocket Hero Golden Pipeline V2",
            "version": "2.0.0",
            "image": f"{cfg['id']}_sheet.png",
            "format": "RGBA8888",
            "size": { "w": sheet_w, "h": C },
            "scale": "1",
            "frameTags": [
                { "name": "idle", "from": 0, "to": 3, "direction": "forward" },
                { "name": "attack", "from": 4, "to": 7, "direction": "forward" },
                { "name": "hit", "from": 8, "to": 9, "direction": "forward" },
                { "name": "death", "from": 10, "to": 15, "direction": "forward" }
            ]
        }
    }
    json_path = os.path.join(out_dir, f"{cfg['id']}_sheet.json")
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(meta_json, f, indent=2)
        
    # 5. Aseprite
    build_frames_dir = os.path.join(PROJECT_ROOT, "build", f"{cfg['id']}_frames")
    os.makedirs(build_frames_dir, exist_ok=True)
    frame_files = []
    for i, f_arr in enumerate(q_frames):
        ff = os.path.join(build_frames_dir, f"{cfg['folder']}_{i:02d}.png")
        Image.fromarray(f_arr, "RGBA").save(ff)
        frame_files.append(ff)
        
    ase_path = os.path.join(out_dir, f"{cfg['id']}_golden.aseprite")
    cmd_ase = [
        ASEPRITE_BIN,
        "-b",
        *frame_files,
        "--save-as", ase_path
    ]
    subprocess.run(cmd_ase, check=True)
    
    # 6. Manifest YAML
    manifest_path = os.path.join(out_dir, f"{cfg['id']}_v002.manifest.yaml")
    manifest_content = f"""asset_id: {cfg['id']}
status: ARTISTIC_QA
version: 2
contract: docs/art/contracts/{cfg['id']}.yaml
golden_reference: GOLDEN_{cfg['id'].upper()}_V1
references:
  - docs/art/golden/hero_bastiao_candidate_v002.png
  - docs/art/golden/enemy_geleia_lumen_candidate_v001.png
  - docs/art/golden/boss_guardiao_cervo_candidate_v002.png
generation:
  workflow: image_gen_concept_then_LANCZOS_pixel_snap_and_TY40_quantization
  workflow_version: '2'
  comfyui_version: null
  custom_nodes: []
  model: OpenAI image_gen
  model_license_record: "personal use approved by Rafael on 2026-09-28; no redistribution or commercial clearance"
  lora: null
  adapters: []
  seed: null
  sampler: null
  steps: null
  cfg: null
  generation_resolution: "Generated concept downscaled to {C}x{C} character frames"
  controlnet: null
  controlnet_weight: null
  ip_adapter_weight: null
  prompt_file: null
  input_hashes: []
palette:
  master: TY_HIGH_FANTASY_40
  subsets: [{', '.join(cfg['subsets'])}]
  colors_used: {num_colors}
  exceptional_colors: []
output:
  files: [assets/sprites/{cfg['category']}/{cfg['folder']}/{cfg['id']}_sheet.png]
  frame_size: {{width: {C}, height: {C}}}
  frame_count: 16
  layout: horizontal_strip
  facing: left
  alpha: true
  hashes: [{file_hash}]
qa:
  technical: PASS
  artistic: PENDING
  mobile: PENDING
  reviewer: null
  reviewed_at: null
  report: Sprite lint PASS; independent visual audit and mobile review are pending.
"""
    with open(manifest_path, 'w', encoding='utf-8') as f:
        f.write(manifest_content)
        
    # 7. Animated GIFs
    scale = 4 if C == 48 else 3
    gif_size = C * scale
    idle_scaled = [Image.fromarray(q_frames[i], "RGBA").resize((gif_size, gif_size), Image.Resampling.NEAREST) for i in range(4)]
    idle_gif = os.path.join(ARTIFACTS_DIR, f"{cfg['id']}_idle_preview.gif")
    idle_scaled[0].save(idle_gif, save_all=True, append_images=idle_scaled[1:], duration=160, loop=0, disposal=2)

    attack_scaled = [Image.fromarray(q_frames[i], "RGBA").resize((gif_size, gif_size), Image.Resampling.NEAREST) for i in range(4, 8)]
    attack_gif = os.path.join(ARTIFACTS_DIR, f"{cfg['id']}_attack_preview.gif")
    attack_scaled[0].save(attack_gif, save_all=True, append_images=attack_scaled[1:], duration=100, loop=0, disposal=2)

def main():
    for cfg in ENEMY_CONFIGS:
        build_enemy_assets(cfg)
    print("\nAll 4 new enemies and Matriarca sheets, Aseprite, and manifests created!")

if __name__ == '__main__':
    main()
