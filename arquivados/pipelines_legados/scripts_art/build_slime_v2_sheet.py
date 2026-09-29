"""
Gera a spritesheet oficial V2 da Geleia de Lumen (16 frames de 48x48):
- 4 frames idle (ciclo de respiracao ancorado em Y=44)
- 4 frames attack (lunge para esquerda)
- 2 frames hit (recoil)
- 6 frames death (dissolucao bioluminescente)
Total: 768x48 px, 20 cores da Rampa Lumen.
Atualiza assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png e .json
"""

import os
import json
import numpy as np
from PIL import Image

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen")
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "slime_pipeline_v2")

def build_sheet():
    ref_path = os.path.join(OUT_DIR, "lumen_slime_reference_v001.png")
    master_ref = Image.open(ref_path).convert("RGBA")
    
    # Isolar crop do slime
    arr = np.array(master_ref)
    alpha = arr[:, :, 3] > 0
    y_idx, x_idx = np.where(alpha)
    min_y, max_y = y_idx.min(), y_idx.max()
    min_x, max_x = x_idx.min(), x_idx.max()
    
    crop = arr[min_y:max_y+1, min_x:max_x+1]
    ch, cw, _ = crop.shape
    crop_img = Image.fromarray(crop, "RGBA")
    
    # Criar os 16 frames de 48x48
    frames = []
    
    # IDLE (Frames 0..3): Respiracao sutil
    idle_scales = [
        (32, 32, 0),   # 0: Neutro
        (33, 31, 0),   # 1: Compressao
        (31, 33, -1),  # 2: Expansao
        (32, 32, 0)    # 3: Retorno
    ]
    for fw, fh, dy in idle_scales:
        c_img = crop_img.resize((fw, fh), Image.Resampling.NEAREST)
        c_arr = np.array(c_img)
        canvas = np.zeros((48, 48, 4), dtype=np.uint8)
        
        target_y = 44 + dy
        start_y = target_y - fh + 1
        start_x = (48 - fw) // 2
        canvas[start_y:target_y+1, start_x:start_x+fw] = c_arr
        
        # Sombra de contato no solo em Y=45
        sw = int(fw * 0.75)
        sx = (48 - sw) // 2
        for x in range(sx, sx + sw):
            canvas[45, x] = [12, 34, 41, 160]
        frames.append(canvas)
        
    # ATTACK (Frames 4..7): Lunge para a esquerda
    attack_params = [
        (34, 28, 4, 1),   # 4: Windup / agachamento para trás
        (36, 30, -6, -3), # 5: Salto rasante para esquerda
        (30, 34, -10, 0), # 6: Impacto frontal
        (32, 32, -3, 0)   # 7: Retorno / recuperacao
    ]
    for fw, fh, dx, dy in attack_params:
        c_img = crop_img.resize((fw, fh), Image.Resampling.NEAREST)
        c_arr = np.array(c_img)
        canvas = np.zeros((48, 48, 4), dtype=np.uint8)
        
        target_y = 44 + dy
        start_y = target_y - fh + 1
        start_x = max(0, min(48 - fw, (48 - fw) // 2 + dx))
        canvas[start_y:target_y+1, start_x:start_x+fw] = c_arr
        
        # Sombra no solo
        sw = int(fw * 0.70)
        sx = max(0, min(48 - sw, (48 - sw) // 2 + dx // 2))
        for x in range(sx, sx + sw):
            canvas[45, x] = [12, 34, 41, 140]
        frames.append(canvas)
        
    # HIT (Frames 8..9): Recoil para a direita
    hit_params = [
        (30, 33, 4, 0, True),  # 8: Flash de impacto
        (31, 31, 2, 0, False)  # 9: Recuperacao
    ]
    for fw, fh, dx, dy, flash in hit_params:
        c_img = crop_img.resize((fw, fh), Image.Resampling.NEAREST)
        c_arr = np.array(c_img)
        if flash:
            # Mistura com branco para flash de dano
            alpha_mask = c_arr[:, :, 3] > 0
            c_arr[alpha_mask, :3] = np.clip(c_arr[alpha_mask, :3] * 0.5 + 128, 0, 255).astype(np.uint8)
            
        canvas = np.zeros((48, 48, 4), dtype=np.uint8)
        target_y = 44 + dy
        start_y = target_y - fh + 1
        start_x = (48 - fw) // 2 + dx
        canvas[start_y:target_y+1, start_x:start_x+fw] = c_arr
        
        sw = int(fw * 0.75)
        sx = (48 - sw) // 2 + dx
        for x in range(sx, sx + sw):
            canvas[45, x] = [12, 34, 41, 160]
        frames.append(canvas)
        
    # DEATH (Frames 10..15): Dissolução gradual
    for i in range(6):
        fh = max(6, int(32 * (1.0 - i * 0.16)))
        fw = min(44, int(32 * (1.0 + i * 0.12)))
        c_img = crop_img.resize((fw, fh), Image.Resampling.NEAREST)
        c_arr = np.array(c_img)
        
        # Dither fade no alpha
        canvas = np.zeros((48, 48, 4), dtype=np.uint8)
        target_y = 44
        start_y = target_y - fh + 1
        start_x = (48 - fw) // 2
        
        # Dissolver pixels
        for y in range(fh):
            for x in range(fw):
                if c_arr[y, x, 3] > 0:
                    if (x + y + i) % (i + 1) == 0:
                        canvas[start_y + y, start_x + x] = c_arr[y, x]
                        
        if i < 4:
            sw = int(fw * 0.70)
            sx = (48 - sw) // 2
            for x in range(sx, sx + sw):
                canvas[45, x] = [12, 34, 41, max(0, 160 - i * 40)]
        frames.append(canvas)
        
    # Concatenar todos os 16 frames horizontalmente: 16 * 48 = 768 x 48
    sheet_w = 48 * 16
    sheet_h = 48
    sheet = Image.new("RGBA", (sheet_w, sheet_h), (0, 0, 0, 0))
    for i, f_arr in enumerate(frames):
        f_img = Image.fromarray(f_arr, "RGBA")
        sheet.paste(f_img, (i * 48, 0), f_img)
        
    out_sheet_path = os.path.join(OUT_DIR, "enemy_geleia_lumen_sheet.png")
    sheet.save(out_sheet_path)
    print(f"Spritesheet salva: {out_sheet_path} ({sheet.size}, {len(sheet.getcolors(maxcolors=256) or [])} cores)")
    
    # Criar metadata JSON
    meta_json = {
        "frames": [
            {
                "filename": f"enemy_geleia_lumen {i}.aseprite",
                "frame": { "x": i * 48, "y": 0, "w": 48, "h": 48 },
                "rotated": False,
                "trimmed": False,
                "spriteSourceSize": { "x": 0, "y": 0, "w": 48, "h": 48 },
                "sourceSize": { "w": 48, "h": 48 },
                "duration": 160 if i < 4 else (100 if i < 8 else (80 if i < 10 else 125))
            } for i in range(16)
        ],
        "meta": {
            "app": "Pocket Hero V2 Pipeline",
            "version": "2.0.0",
            "image": "enemy_geleia_lumen_sheet.png",
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
    
    json_path = os.path.join(OUT_DIR, "enemy_geleia_lumen_sheet.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(meta_json, f, indent=2)
    print(f"Metadata JSON salvo: {json_path}")

if __name__ == "__main__":
    build_sheet()
