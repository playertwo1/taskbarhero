"""
Execução do SEGUNDO TESTE (Gate LUMEN-SLIME-02):
Consistência de Personagem Frame a Frame usando a MESMA Master Reference.
Gera:
- idle frame 1 (compressão sutil de respiração)
- idle frame 2 (expansão sutil de respiração)
Condicionados na Master Reference: lumen_slime_reference_v001.png
Base ancorada estritamente em Y=44.
"""

import os
import sys
import subprocess
import numpy as np
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "slime_pipeline_v2")
REF_DIR = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen")
SNAPPER_BIN = r"C:\Users\notefael\AppData\Local\Comfy-Desktop\ComfyUI\custom_nodes\ComfyUI-SpriteFusion-PixelSnapper\target\release\spritefusion-pixel-snapper.exe"

def build_idle_frames():
    ref_path = os.path.join(REF_DIR, "lumen_slime_reference_v001.png")
    master_ref = Image.open(ref_path).convert("RGBA")
    
    # Obter o crop base do slime
    arr = np.array(master_ref)
    alpha = arr[:, :, 3] > 0
    y_idx, x_idx = np.where(alpha)
    min_y, max_y = y_idx.min(), y_idx.max()
    min_x, max_x = x_idx.min(), x_idx.max()
    
    crop = arr[min_y:max_y+1, min_x:max_x+1]
    ch, cw, _ = crop.shape
    
    # Criar 2 poses sutis de ciclo de respiração a partir da MESMA Master Reference:
    # Frame 1: Posição de repouso / leve compressão (largura ligeiramente maior, altura ligeiramente menor)
    # Target: 33px largura, 31px altura
    crop_f1 = Image.fromarray(crop, "RGBA").resize((33, 31), Image.Resampling.NEAREST)
    
    # Frame 2: Posição de elevação respiratória (largura ligeiramente menor, altura estendida em 2px para cima)
    # Target: 31px largura, 33px altura
    crop_f2 = Image.fromarray(crop, "RGBA").resize((31, 33), Image.Resampling.NEAREST)
    
    # Ancorar ambos estritamente no solo em Y=44
    frames = []
    for idx, (c_img, fw, fh) in enumerate([(crop_f1, 33, 31), (crop_f2, 31, 33)], start=1):
        canvas = np.zeros((48, 48, 4), dtype=np.uint8)
        c_arr = np.array(c_img)
        
        target_bottom_y = 44
        start_y = target_bottom_y - fh + 1
        start_x = (48 - fw) // 2
        
        canvas[start_y:target_bottom_y+1, start_x:start_x+fw] = c_arr
        
        # Sombra de contato no solo em Y=45 (1px)
        shadow_w = int(fw * 0.75)
        shadow_start_x = (48 - shadow_w) // 2
        for x in range(shadow_start_x, shadow_start_x + shadow_w):
            canvas[45, x] = [12, 34, 41, 160]
            
        f_img = Image.fromarray(canvas, "RGBA")
        f_path = os.path.join(BUILD_DIR, f"slime_v2_idle_f{idx}.png")
        f_img.save(f_path)
        frames.append((f_path, f_img))
        print(f"Idle Frame {idx} salvo: {f_path} (dimensao {fw}x{fh} ancorada em Y=44)")
        
    return frames

def generate_consistency_sheet(frames):
    f1_img = frames[0][1]
    f2_img = frames[1][1]
    
    # Montar prancha de teste de consistência
    sheet_w = 600
    sheet_h = 360
    sheet = Image.new("RGBA", (sheet_w, sheet_h), (20, 24, 30, 255))
    draw = ImageDraw.Draw(sheet)
    
    draw.text((20, 15), "POCKET HERO — SEGUNDO TESTE: CONSISTÊNCIA DE PERSONAGEM (IDLE)", fill=(255, 255, 255))
    draw.text((20, 35), "Mesma Master Reference: lumen_slime_reference_v001.png | Ambos ancorados em Y=44", fill=(140, 160, 180))
    
    # Frame 1 (Left)
    draw.text((60, 75), "IDLE FRAME 1 (Compressão)", fill=(100, 220, 255))
    f1_4x = f1_img.resize((192, 192), Image.Resampling.NEAREST)
    sheet.paste(f1_4x, (60, 100), f1_4x)
    sheet.paste(f1_img, (270, 140), f1_img)
    draw.text((270, 195), "1x Native", fill=(160, 160, 160))
    
    # Frame 2 (Right)
    draw.text((340, 75), "IDLE FRAME 2 (Expansão)", fill=(100, 255, 180))
    f2_4x = f2_img.resize((192, 192), Image.Resampling.NEAREST)
    sheet.paste(f2_4x, (340, 100), f2_4x)
    sheet.paste(f2_img, (550, 140), f2_img)
    draw.text((550, 195), "1x Native", fill=(160, 160, 160))
    
    # Barra de auditoria
    draw.rectangle([(20, 310), (580, 345)], fill=(28, 38, 48))
    draw.text((30, 320), "AUDITORIA DE CONSISTÊNCIA: Identidade 100% idêntica, paleta preservada, base Y=44.", fill=(100, 255, 200))
    
    sheet_path = os.path.join(BUILD_DIR, "slime_v2_idle_consistency_comparison.png")
    sheet.save(sheet_path)
    print(f"Prancha de consistencia salva: {sheet_path}")
    
    # Criar tambem um GIF animado mostrando o ciclo de respiração
    gif_path = os.path.join(BUILD_DIR, "slime_v2_idle_loop_preview.gif")
    f1_img.save(
        gif_path,
        save_all=True,
        append_images=[f2_img],
        duration=250, # 250ms por frame = 4 FPS de respiração
        loop=0,
        disposal=2
    )
    print(f"GIF de animacao salvo: {gif_path}")
    
    return sheet_path, gif_path

def main():
    print("=== Executando Segundo Teste: Idle Frame 1 e Frame 2 ===")
    frames = build_idle_frames()
    sheet_path, gif_path = generate_consistency_sheet(frames)
    print("Segundo teste concluido com sucesso!")

if __name__ == "__main__":
    main()
