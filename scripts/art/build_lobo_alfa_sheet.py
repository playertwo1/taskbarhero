"""
Gera a spritesheet oficial V2 do Lobo Alfa de Lúmen no padrão Golden (16 frames de 48x48):
- Voltado estritamente para a ESQUERDA (facing left, padrão de inimigos do Pocket Hero)
- 4 frames idle (ciclo de respiração lupina ancorado em Y=44)
- 4 frames attack (lunge e mordida para a esquerda)
- 2 frames hit (recoil para a direita)
- 6 frames death (colapso e dissolução em partículas)
Total: 768x48 px, paleta canônica TY High Fantasy 40 (12 cores dos subconjuntos neutral_stone + lumen).
Alpha 100% binário (0 ou 255).
Atualiza o manifesto YAML com o hash SHA-256 correto.
"""

import os
import json
import hashlib
import subprocess
import numpy as np
from PIL import Image, ImageOps
from scipy.cluster.vq import vq

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "lobo_alfa_de_lumen")
ASEPRITE_BIN = os.path.join(PROJECT_ROOT, "Aseprite", "Aseprite.exe")
SOURCE_SHEET = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286\lobo_alfa_golden_sheet_1790566639201.jpg"

# Subconjuntos autorizados pelo contrato: neutral_stone + lumen (exatamente 12 cores)
EXACT_12_COLORS = [
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

def process_cell(cell_img, bg_color, target_h=36, dx=0, dy=0, shadow_w_ratio=0.85):
    arr = np.array(cell_img)
    diff = np.linalg.norm(arr.astype(float) - bg_color, axis=2)
    alpha = (diff > 22).astype(np.uint8) * 255
    
    y_idx, x_idx = np.where(alpha > 0)
    if len(y_idx) == 0:
        return np.zeros((48, 48, 4), dtype=np.uint8)
        
    min_y, max_y = y_idx.min(), y_idx.max()
    min_x, max_x = x_idx.min(), x_idx.max()
    
    crop = arr[min_y:max_y+1, min_x:max_x+1]
    c_alpha = alpha[min_y:max_y+1, min_x:max_x+1]
    ch, cw, _ = crop.shape
    
    rgba = np.zeros((ch, cw, 4), dtype=np.uint8)
    rgba[:, :, :3] = crop
    rgba[:, :, 3] = c_alpha
    
    tw = max(1, min(46, int(cw * (target_h / float(ch)))))
    c_img = Image.fromarray(rgba, 'RGBA').resize((tw, target_h), Image.Resampling.NEAREST)
    
    # Inverter horizontalmente para que fique voltado para a ESQUERDA (facing left)
    c_img = ImageOps.mirror(c_img)
    
    canvas = np.zeros((48, 48, 4), dtype=np.uint8)
    target_bottom_y = 44 + dy
    sy = target_bottom_y - target_h + 1
    sx = max(0, min(48 - tw, (48 - tw) // 2 + dx))
    
    c_arr = np.array(c_img)
    canvas[sy:target_bottom_y+1, sx:sx+tw] = c_arr
    
    # Sombra de contato sólida em Y=45 (binária: alpha 255, cor #182029)
    sw = int(tw * shadow_w_ratio)
    ssx = max(0, min(48 - sw, (48 - sw) // 2 + dx))
    for x in range(ssx, ssx + sw):
        canvas[45, x] = [24, 32, 41, 255]
        
    return canvas

def build_all_frames():
    sheet = Image.open(SOURCE_SHEET)
    bg_color = np.array([137.0, 137.0, 137.0])
    frames = []

    # 1. IDLE (4 quadros)
    for col in range(4):
        cell = sheet.crop((col * 256, 0, (col + 1) * 256, 256))
        f = process_cell(cell, bg_color, target_h=36, dx=0, dy=0)
        frames.append(f)

    # 2. ATTACK (4 quadros): bote para a esquerda (dx negativo)
    attack_offsets = [0, -4, -6, -2]
    for col in range(4):
        cell = sheet.crop((col * 256, 256, (col + 1) * 256, 512))
        dx = attack_offsets[col]
        f = process_cell(cell, bg_color, target_h=36, dx=dx, dy=0)
        frames.append(f)

    # 3. HIT (2 quadros): recoil para a direita (dx positivo)
    hit_cols = [0, 2]
    hit_offsets = [4, 2]
    for i, col in enumerate(hit_cols):
        cell = sheet.crop((col * 256, 512, (col + 1) * 256, 768))
        f = process_cell(cell, bg_color, target_h=36, dx=hit_offsets[i], dy=0)
        frames.append(f)

    # 4. DEATH (6 quadros): colapso ao solo e dissolução
    for col in range(4):
        cell = sheet.crop((col * 256, 768, (col + 1) * 256, 1024))
        th = 36 if col == 0 else (28 if col == 1 else (20 if col == 2 else 18))
        f = process_cell(cell, bg_color, target_h=th, dx=0, dy=0, shadow_w_ratio=0.9)
        frames.append(f)

    last_death = frames[-1].copy()
    for d_step in [1, 2]:
        f_dissolve = np.zeros((48, 48, 4), dtype=np.uint8)
        for y in range(48):
            for x in range(48):
                if last_death[y, x, 3] > 0 and y < 45:
                    if (x + y + d_step) % (d_step + 1) == 0:
                        f_dissolve[y, x] = last_death[y, x]
        if d_step == 1:
            for x in range(12, 36):
                f_dissolve[45, x] = [24, 32, 41, 255]
        frames.append(f_dissolve)

    return frames

def quantize_frames_to_palette(frames):
    canon_rgb = np.array([hex_to_rgb(hx) for hx in EXACT_12_COLORS], dtype=np.float32) / 255.0
    quantized_frames = []

    for f in frames:
        arr = f.copy()
        arr[:, :, 3] = np.where(arr[:, :, 3] > 100, 255, 0).astype(np.uint8)
        alpha = arr[:, :, 3] == 255
        if np.any(alpha):
            rgb = arr[alpha, :3].astype(np.float32) / 255.0
            labels, _ = vq(rgb, canon_rgb)
            enf_pixels = canon_rgb[labels]
            arr[alpha, :3] = (enf_pixels * 255).astype(np.uint8)
        quantized_frames.append(arr)

    return quantized_frames

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    raw_frames = build_all_frames()
    q_frames = quantize_frames_to_palette(raw_frames)

    # 1. Montar spritesheet horizontal 768x48
    sheet_w = 48 * 16
    sheet_h = 48
    sheet = Image.new("RGBA", (sheet_w, sheet_h), (0, 0, 0, 0))
    for i, f_arr in enumerate(q_frames):
        f_img = Image.fromarray(f_arr, "RGBA")
        sheet.paste(f_img, (i * 48, 0), f_img)

    sheet_path = os.path.join(OUT_DIR, "mob_lobo_alfa_sheet.png")
    sheet.save(sheet_path)
    
    with open(sheet_path, "rb") as f:
        file_hash = hashlib.sha256(f.read()).hexdigest()

    num_colors = len(sheet.getcolors(maxcolors=256) or [])
    print(f"Spritesheet salva (facing left): {sheet_path} ({sheet.size}, {num_colors} cores)")
    print(f"SHA-256: {file_hash}")

    # 2. Criar JSON de metadados
    meta_json = {
        "frames": [
            {
                "filename": f"mob_lobo_alfa {i}.aseprite",
                "frame": { "x": i * 48, "y": 0, "w": 48, "h": 48 },
                "rotated": False,
                "trimmed": False,
                "spriteSourceSize": { "x": 0, "y": 0, "w": 48, "h": 48 },
                "sourceSize": { "w": 48, "h": 48 },
                "duration": 160 if i < 4 else (100 if i < 8 else (80 if i < 10 else 120))
            } for i in range(16)
        ],
        "meta": {
            "app": "Pocket Hero Golden Pipeline V2",
            "version": "2.0.0",
            "image": "mob_lobo_alfa_sheet.png",
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

    json_path = os.path.join(OUT_DIR, "mob_lobo_alfa_sheet.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(meta_json, f, indent=2)
    print(f"Metadata JSON salvo: {json_path}")

    # 3. Exportar para .aseprite
    ase_path = os.path.join(OUT_DIR, "mob_lobo_alfa_golden.aseprite")
    build_frames_dir = os.path.join(PROJECT_ROOT, "build", "lobo_golden_frames")
    os.makedirs(build_frames_dir, exist_ok=True)
    frame_files = []
    for i, f_arr in enumerate(q_frames):
        ff = os.path.join(build_frames_dir, f"lobo_{i:02d}.png")
        Image.fromarray(f_arr, "RGBA").save(ff)
        frame_files.append(ff)

    cmd_ase = [
        ASEPRITE_BIN,
        "-b",
        *frame_files,
        "--save-as", ase_path
    ]
    subprocess.run(cmd_ase, check=True)
    print(f"Aseprite salvo: {ase_path}")

    # 4. Atualizar o manifesto YAML com o hash exato e colors_used
    manifest_path = os.path.join(OUT_DIR, "mob_lobo_alfa_v002.manifest.yaml")
    with open(manifest_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    with open(manifest_path, "w", encoding="utf-8") as f:
        for line in lines:
            if line.startswith("  colors_used:"):
                f.write(f"  colors_used: {num_colors - 1}\n")
            elif line.startswith("  hashes:"):
                f.write(f"  hashes: [{file_hash}]\n")
            else:
                f.write(line)
    print(f"Manifesto atualizado: {manifest_path}")

    # 5. Gerar GIFs atualizados voltados para a esquerda (4x)
    art_dir = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"
    idle_192 = [Image.fromarray(q_frames[i], "RGBA").resize((192, 192), Image.Resampling.NEAREST) for i in range(4)]
    idle_gif = os.path.join(art_dir, "lobo_golden_idle_preview.gif")
    idle_192[0].save(idle_gif, save_all=True, append_images=idle_192[1:], duration=160, loop=0, disposal=2)

    attack_192 = [Image.fromarray(q_frames[i], "RGBA").resize((192, 192), Image.Resampling.NEAREST) for i in range(4, 8)]
    attack_gif = os.path.join(art_dir, "lobo_golden_attack_preview.gif")
    attack_192[0].save(attack_gif, save_all=True, append_images=attack_192[1:], duration=100, loop=0, disposal=2)
    print("GIFs de preview atualizados com sucesso (facing left).")

if __name__ == "__main__":
    main()
