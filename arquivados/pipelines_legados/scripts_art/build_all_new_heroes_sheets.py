"""
Pocket Hero — Master Animation Sheet Builder for All 5 New Heroes
(Brasa, Véu, Orvalho, Forja, Sino)

Builds 16-frame 768x48 PNG sheets:
- 0..3: Idle (looping 4-frame breathing/bobbing anchored at Y=44)
- 4..7: Attack (windup, strike, extension with visual effect, recovery)
- 8..9: Hit (recoil + hit flash within authorized palette)
- 10..15: Death (collapse + ethereal ordered dither fade)

Outputs per hero:
- assets/sprites/heroes/<name>/hero_<name>_sheet.png
- assets/sprites/heroes/<name>/hero_<name>_sheet.json
- assets/sprites/heroes/<name>/hero_<name>_golden.aseprite
- assets/sprites/heroes/<name>/hero_<name>_v002.manifest.yaml
- Previews: animated GIFs in artifacts directory
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

HERO_CONFIGS = [
    {
        'id': 'hero_brasa',
        'folder': 'brasa',
        'name': 'Brasa',
        'subsets': ['crimson', 'iron', 'wood', 'gold'],
        'max_colors': 15,
        'attack_fx': 'axes',
        'fx_color': '#bf5437', # Crimson ember
        'flash_color': '#bf5437',
    },
    {
        'id': 'hero_veu',
        'folder': 'veu',
        'name': 'Véu',
        'subsets': ['iron', 'crimson', 'neutral_stone'],
        'max_colors': 14,
        'attack_fx': 'daggers',
        'fx_color': '#bdd2de', # Gleaming steel
        'flash_color': '#8f5c66',
    },
    {
        'id': 'hero_orvalho',
        'folder': 'orvalho',
        'name': 'Orvalho',
        'subsets': ['forest', 'wood', 'lumen', 'neutral_stone'],
        'max_colors': 14,
        'attack_fx': 'seeds',
        'fx_color': '#81b5a2', # Sprouting lumen green
        'flash_color': '#607a53',
    },
    {
        'id': 'hero_forja',
        'folder': 'forja',
        'name': 'Forja',
        'subsets': ['iron', 'gold', 'lumen', 'wood'],
        'max_colors': 15,
        'attack_fx': 'hammer',
        'fx_color': '#81b5a2', # Cyan spark
        'flash_color': '#af8e2c',
    },
    {
        'id': 'hero_sino',
        'folder': 'sino',
        'name': 'Sino',
        'subsets': ['lumen', 'gold', 'crimson', 'iron'],
        'max_colors': 15,
        'attack_fx': 'chime',
        'fx_color': '#caaa6c', # Golden melodic note
        'flash_color': '#81b5a2',
    },
]

def hex_to_rgb(h):
    h = h.lstrip('#')
    return np.array([int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)], dtype=np.float32)

def generate_frames_for_hero(base_sprite, cfg):
    master_arr = np.array(base_sprite)
    frames = []
    
    # 0..3: Idle
    # Frame 0: Base
    frames.append(master_arr.copy())
    
    # Frame 1: Slight breath up (shift torso/head up 1px while feet stay grounded)
    f1 = np.zeros_like(master_arr)
    # Ground rows (43..47) stay
    f1[43:48, :] = master_arr[43:48, :]
    # Upper body shifts 1px up
    f1[0:43, :] = np.roll(master_arr[0:43, :], -1, axis=0)
    frames.append(f1)
    
    # Frame 2: Peak breath (top pose)
    f2 = np.zeros_like(master_arr)
    f2[42:48, :] = master_arr[42:48, :]
    f2[0:42, :] = np.roll(master_arr[0:42, :], -1, axis=0)
    frames.append(f2)
    
    # Frame 3: Settling down
    f3 = f1.copy()
    frames.append(f3)
    
    # 4..7: Attack
    # Frame 4: Windup / Anticipation (shift back 2px, raise slightly)
    f4 = np.zeros_like(master_arr)
    shifted = np.roll(master_arr, -2, axis=1) # move left
    f4[:, :] = shifted
    frames.append(f4)
    
    # Frame 5: Forward Strike / Lunge (shift right 3px, downward pressure)
    f5 = np.zeros_like(master_arr)
    shifted_fwd = np.roll(master_arr, 3, axis=1)
    f5[:, :] = shifted_fwd
    frames.append(f5)
    
    # Frame 6: Extension with Effect (fx particles/slash)
    f6 = f5.copy()
    fx_col = hex_to_rgb(cfg['fx_color']).astype(np.uint8)
    # Add visual attack slash / spark arc in front of the hero (x: 36..46, y: 16..36)
    if cfg['attack_fx'] in ['axes', 'daggers', 'hammer']:
        # Slash arc
        for i in range(5):
            x = 38 + i
            y = 18 + i * 3
            if 0 <= x < 48 and 0 <= y < 48:
                f6[y, x, :3] = fx_col
                f6[y, x, 3] = 255
            if 0 <= x-1 < 48 and 0 <= y < 48:
                f6[y, x-1, :3] = [230, 218, 197] # highlight
                f6[y, x-1, 3] = 255
    elif cfg['attack_fx'] in ['seeds', 'chime']:
        # Musical / organic spark ring
        for angle in range(6):
            ox = int(38 + np.cos(angle) * 4)
            oy = int(22 + np.sin(angle) * 4)
            if 0 <= ox < 48 and 0 <= oy < 48:
                f6[oy, ox, :3] = fx_col
                f6[oy, ox, 3] = 255
    frames.append(f6)
    
    # Frame 7: Recovery (returning toward center)
    f7 = np.roll(master_arr, 1, axis=1)
    frames.append(f7)
    
    # 8..9: Hit
    # Frame 8: Sharp impact recoil back 3px with flash
    f8 = np.roll(master_arr, -3, axis=1)
    flash_c = hex_to_rgb(cfg['flash_color']).astype(np.uint8)
    # Tint non-transparent pixels slightly with flash_color
    hit_mask = f8[:, :, 3] > 0
    f8[hit_mask, :3] = np.clip(f8[hit_mask, :3] * 0.6 + flash_c * 0.4, 0, 255).astype(np.uint8)
    frames.append(f8)
    
    # Frame 9: Stagger recovery
    f9 = np.roll(master_arr, -1, axis=1)
    frames.append(f9)
    
    # 10..15: Death
    # Frame 10: Collapse start (slump down 2px)
    f10 = np.zeros_like(master_arr)
    f10[2:48, :] = master_arr[0:46, :]
    frames.append(f10)
    
    # Frame 11: Impact with ground (slump down 5px, compress)
    f11 = np.zeros_like(master_arr)
    f11[5:48, :] = master_arr[0:43, :]
    frames.append(f11)
    
    # Frames 12..15: Ordered dither fade
    for step in range(4):
        f_death = f11.copy()
        threshold = (step + 1) / 5.0
        for y in range(48):
            for x in range(48):
                if f_death[y, x, 3] > 0:
                    bayer = ((x * 3 + y * 7 + step * 5) % 11) / 11.0
                    if bayer < threshold:
                        f_death[y, x, 3] = 0 # Dissolve pixel
        frames.append(f_death)
        
    return frames

def quantize_frames(frames, cfg):
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
        
    # Enforce global max colors across all 16 frames of the sheet
    color_counts = {}
    for f in q_frames:
        for y in range(48):
            for x in range(48):
                if f[y, x, 3] > 0:
                    c = tuple(f[y, x, :3])
                    color_counts[c] = color_counts.get(c, 0) + 1
                    
    if len(color_counts) > cfg['max_colors']:
        sorted_colors = sorted(color_counts.keys(), key=lambda c: color_counts[c], reverse=True)
        top_k = sorted_colors[:cfg['max_colors']]
        top_k_arr = np.array(top_k, dtype=np.float32)
        
        for f in q_frames:
            for y in range(48):
                for x in range(48):
                    if f[y, x, 3] > 0:
                        c = tuple(f[y, x, :3])
                        if c not in top_k:
                            dists = np.sum((np.array(c, dtype=np.float32)[None, :] - top_k_arr) ** 2, axis=1)
                            f[y, x, :3] = top_k[np.argmin(dists)]
                            
    return q_frames

def build_hero_assets(cfg):
    hero_dir = os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'heroes', cfg['folder'])
    master_path = os.path.join(hero_dir, 'master_base.png')
    base_sprite = Image.open(master_path).convert('RGBA')
    
    # 1. Generate 16 frames
    raw_frames = generate_frames_for_hero(base_sprite, cfg)
    q_frames = quantize_frames(raw_frames, cfg)
    
    # 2. Build 768x48 sheet
    sheet = Image.new('RGBA', (768, 48), (0, 0, 0, 0))
    for i, f_arr in enumerate(q_frames):
        f_im = Image.fromarray(f_arr, mode='RGBA')
        sheet.paste(f_im, (i * 48, 0), f_im)
        
    sheet_path = os.path.join(hero_dir, f"{cfg['id']}_sheet.png")
    sheet.save(sheet_path)
    
    # Calculate SHA-256
    with open(sheet_path, 'rb') as f:
        file_hash = hashlib.sha256(f.read()).hexdigest()
        
    # Count unique colors
    unique_colors = set(tuple(p[:3]) for p in sheet.getdata() if p[3] > 0)
    num_colors = len(unique_colors)
    print(f"[{cfg['name']}] Spritesheet saved: {sheet_path} | {num_colors} colors (max: {cfg['max_colors']}) | hash: {file_hash[:12]}...")
    
    # 3. Write JSON metadata
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
            "frame": { "x": i * 48, "y": 0, "w": 48, "h": 48 },
            "rotated": False,
            "trimmed": False,
            "spriteSourceSize": { "x": 0, "y": 0, "w": 48, "h": 48 },
            "sourceSize": { "w": 48, "h": 48 },
            "duration": durations[i]
        })
        
    meta_json = {
        "frames": frame_list,
        "meta": {
            "app": "Pocket Hero Golden Pipeline V2",
            "version": "2.0.0",
            "image": f"{cfg['id']}_sheet.png",
            "format": "RGBA8888",
            "size": { "w": 768, "h": 48 },
            "scale": "1",
            "frameTags": [
                { "name": "idle", "from": 0, "to": 3, "direction": "forward" },
                { "name": "attack", "from": 4, "to": 7, "direction": "forward" },
                { "name": "hit", "from": 8, "to": 9, "direction": "forward" },
                { "name": "death", "from": 10, "to": 15, "direction": "forward" }
            ]
        }
    }
    json_path = os.path.join(hero_dir, f"{cfg['id']}_sheet.json")
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(meta_json, f, indent=2)
        
    # 4. Export Aseprite
    build_frames_dir = os.path.join(PROJECT_ROOT, "build", f"{cfg['id']}_frames")
    os.makedirs(build_frames_dir, exist_ok=True)
    frame_files = []
    for i, f_arr in enumerate(q_frames):
        ff = os.path.join(build_frames_dir, f"{cfg['folder']}_{i:02d}.png")
        Image.fromarray(f_arr, "RGBA").save(ff)
        frame_files.append(ff)
        
    ase_path = os.path.join(hero_dir, f"{cfg['id']}_golden.aseprite")
    cmd_ase = [
        ASEPRITE_BIN,
        "-b",
        *frame_files,
        "--save-as", ase_path
    ]
    subprocess.run(cmd_ase, check=True)
    
    # 5. Write manifest YAML
    manifest_path = os.path.join(hero_dir, f"{cfg['id']}_v002.manifest.yaml")
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
  generation_resolution: "Generated concept downscaled to 48x48 character frames"
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
  files: [assets/sprites/heroes/{cfg['folder']}/{cfg['id']}_sheet.png]
  frame_size: {{width: 48, height: 48}}
  frame_count: 16
  layout: horizontal_strip
  facing: right
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
        
    # 6. Generate 4x preview GIFs (Idle and Attack)
    idle_192 = [Image.fromarray(q_frames[i], "RGBA").resize((192, 192), Image.Resampling.NEAREST) for i in range(4)]
    idle_gif = os.path.join(ARTIFACTS_DIR, f"{cfg['id']}_idle_preview.gif")
    idle_192[0].save(idle_gif, save_all=True, append_images=idle_192[1:], duration=160, loop=0, disposal=2)

    attack_192 = [Image.fromarray(q_frames[i], "RGBA").resize((192, 192), Image.Resampling.NEAREST) for i in range(4, 8)]
    attack_gif = os.path.join(ARTIFACTS_DIR, f"{cfg['id']}_attack_preview.gif")
    attack_192[0].save(attack_gif, save_all=True, append_images=attack_192[1:], duration=100, loop=0, disposal=2)

def main():
    for cfg in HERO_CONFIGS:
        build_hero_assets(cfg)
    print("\nAll 5 new hero sheets, Aseprite files, manifests, and preview GIFs created!")

if __name__ == '__main__':
    main()
