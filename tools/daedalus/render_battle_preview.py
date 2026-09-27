"""
Renderizador de Preview Visual da BattleStrip (Bosque de Lumen)
Combina os spritesheets reais de Bastiao e Geleia de Lumen sobre o cenario AMOLED.
Gera:
1. battle_strip_preview.png (Frame estático de alta resolução em pixel art)
2. battle_combat_loop.gif (GIF animado do ciclo de combate real)
3. Salva tambem no diretorio de artefatos para visualizacao direta pelo usuario.
"""

import os
import sys
import base64
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ARTIFACT_DIR = r"C:\Users\notefael\.gemini\antigravity\brain\a967aa1b-4428-4099-947a-ad6f69740286"

BASTIAO_SHEET_PATH = os.path.join(PROJECT_ROOT, "assets", "sprites", "heroes", "bastiao", "hero_bastiao_sheet.png")
SLIME_SHEET_PATH = os.path.join(PROJECT_ROOT, "assets", "sprites", "enemies", "geleia_de_lumen", "enemy_geleia_lumen_sheet.png")

# Cores oficiais da BattleStrip.gd
COLOR_BG = (6, 8, 7, 255)         # #060807
COLOR_BORDER = (23, 35, 28, 255)  # #17231c
COLOR_TREE_BG = (11, 22, 18, 255) # #0b1612
COLOR_TREE_MID = (17, 34, 27, 255)# #11221b
COLOR_GROUND = (16, 24, 20, 255)  # #101814
COLOR_GROUND_LINE = (43, 66, 53, 255) # #2b4235
COLOR_MOSS = (30, 48, 37, 255)    # #1e3025
COLOR_LUMEN_ORB = (56, 217, 169, 110) # #38d9a9 com alpha
COLOR_BAR_BG = (32, 35, 42, 255)  # #20232a
COLOR_HERO_HP = (72, 199, 116, 255) # #48c774
COLOR_ENEMY_HP = (241, 70, 104, 255) # #f14668

WIDTH = 432
HEIGHT = 220
SCALE = 2 # Escala interna dos sprites

def load_frames(sheet_path, frame_w, frame_h, count):
    sheet = Image.open(sheet_path).convert("RGBA")
    frames = []
    for i in range(count):
        crop = sheet.crop((i * frame_w, 0, (i + 1) * frame_w, frame_h))
        frames.append(crop)
    return frames

def render_background(w=WIDTH, h=HEIGHT):
    img = Image.new("RGBA", (w, h), COLOR_BG)
    d = ImageDraw.Draw(img, "RGBA")
    
    # Borda superior
    d.line([(0, 1), (w, 1)], fill=COLOR_BORDER, width=2)
    
    # Silhuetas de árvores distantes
    ground_y = h - 42
    tree_xs = [20, 80, 140, 210, 280, 350, 410]
    for tx in tree_xs:
        # Tronco
        d.rectangle([tx, 40, tx + 8, ground_y], fill=COLOR_TREE_BG)
        # Copa
        pts = [(tx + 4, 18), (tx - 18, 75), (tx + 26, 75)]
        d.polygon(pts, fill=COLOR_TREE_MID)
        
    # Orbes de Lumen flutuantes
    d.ellipse([int(w * 0.18 - 3.5), 55 - 3, int(w * 0.18 + 3.5), 55 + 4], fill=COLOR_LUMEN_ORB)
    d.ellipse([int(w * 0.52 - 2.5), 38 - 2, int(w * 0.52 + 2.5), 38 + 3], fill=COLOR_LUMEN_ORB)
    d.ellipse([int(w * 0.82 - 4.0), 65 - 4, int(w * 0.82 + 4.0), 65 + 4], fill=COLOR_LUMEN_ORB)
    
    # Solo musgoso
    d.rectangle([0, ground_y, w, h], fill=COLOR_GROUND)
    d.line([(0, ground_y), (w, ground_y)], fill=COLOR_GROUND_LINE, width=2)
    for x in range(0, w, 28):
        d.line([(x, ground_y + 8), (x + 12, ground_y + 4)], fill=COLOR_MOSS, width=2)
        
    return img

def render_health_bar(d, x, y, w, h, ratio, fill_color):
    d.rectangle([x, y, x + w, y + h], fill=COLOR_BAR_BG)
    fill_w = int(w * max(0.0, min(1.0, ratio)))
    if fill_w > 0:
        d.rectangle([x, y, x + fill_w, y + h], fill=fill_color)

def build_scene_frame(hero_frame, slime_frame, hero_hp=1.0, enemy_hp=1.0):
    bg = render_background(WIDTH, HEIGHT)
    d = ImageDraw.Draw(bg, "RGBA")
    
    ground_y = HEIGHT - 42
    hero_x = int(WIDTH * 0.25)
    enemy_x = int(WIDTH * 0.73)
    
    # Desenhar Barras de Vida
    render_health_bar(d, hero_x - 55, 18, 110, 10, hero_hp, COLOR_HERO_HP)
    render_health_bar(d, enemy_x - 55, 18, 110, 10, enemy_hp, COLOR_ENEMY_HP)
    
    # Textos indicadores de HP
    # Posicionar Bastiao:
    # Canvas 48x48, Baseline Y=44, Offset Y=-20
    # No Godot: hero_visual.position = (hero_x, ground_y)
    # Com escala 2x: largura 96, altura 96
    # O baseline Y=44 com escala 2 fica em (ground_y):
    # Topo do sprite em Y = ground_y - (44 * 2) = ground_y - 88
    # Centro X fica em hero_x - (24 * 2) = hero_x - 48
    hero_scaled = hero_frame.resize((48 * SCALE, 48 * SCALE), Image.NEAREST)
    hero_pos_x = hero_x - (24 * SCALE)
    hero_pos_y = ground_y - (44 * SCALE)
    bg.alpha_composite(hero_scaled, (hero_pos_x, hero_pos_y))
    
    # Posicionar Geleia:
    # Canvas 32x32, Baseline Y=29, Offset Y=-13
    # Com escala 2x: largura 64, altura 64
    # Topo do sprite em Y = ground_y - (29 * 2) = ground_y - 58
    # Centro X fica em enemy_x - (16 * SCALE)
    slime_scaled = slime_frame.resize((32 * SCALE, 32 * SCALE), Image.NEAREST)
    slime_pos_x = enemy_x - (16 * SCALE)
    slime_pos_y = ground_y - (29 * SCALE)
    bg.alpha_composite(slime_scaled, (slime_pos_x, slime_pos_y))
    
    return bg

def main():
    print("Carregando spritesheets...")
    bastiao_frames = load_frames(BASTIAO_SHEET_PATH, 48, 48, 16)
    # 0..3: idle, 4..7: attack, 8..9: hit, 10..15: death
    
    slime_frames = load_frames(SLIME_SHEET_PATH, 32, 32, 16)
    # 0..3: idle, 4..7: attack, 8..9: hit, 10..15: death
    
    # 1. Gerar imagem estática (Idle comparativo)
    static_preview = build_scene_frame(bastiao_frames[0], slime_frames[0], 1.0, 1.0)
    
    # Upscale 2x para visualização nítida em alta densidade (864x440)
    static_hd = static_preview.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST)
    
    out_static_repo = os.path.join(PROJECT_ROOT, "docs", "art", "preview_bosque_lumen_r11.png")
    static_hd.save(out_static_repo)
    print("Salvo em:", out_static_repo)
    
    out_static_art = os.path.join(ARTIFACT_DIR, "preview_bosque_lumen_r11.png")
    static_hd.save(out_static_art)
    print("Salvo em:", out_static_art)
    
    # 2. Gerar GIF animado do ciclo completo de combate
    # Timeline:
    # 0..3: Idle sincrono (4 quadros)
    # 4..7: Bastiao ataca (4 quadros), Slime toma hit nos quadros 6 e 7
    # 8..11: Slime contra-ataca (4 quadros), Bastiao toma hit nos quadros 10 e 11
    # 12..15: Idle de volta
    anim_frames = []
    durations = []
    
    # Ciclo 1: Idle
    for i in range(4):
        f = build_scene_frame(bastiao_frames[i % 4], slime_frames[i % 4], 1.0, 1.0)
        anim_frames.append(f.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST))
        durations.append(150)
        
    # Bastiao Ataca (attack frames 4, 5, 6, 7)
    # Slime toma hit (frames 8, 9) durante o impacto
    slime_react = [0, 1, 8, 9]
    for i, b_idx in enumerate([4, 5, 6, 7]):
        s_idx = slime_react[i]
        hp = 1.0 if i < 2 else 0.75
        f = build_scene_frame(bastiao_frames[b_idx], slime_frames[s_idx], 1.0, hp)
        anim_frames.append(f.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST))
        durations.append(110)
        
    # Retorno breve
    for i in range(2):
        f = build_scene_frame(bastiao_frames[i], slime_frames[i], 1.0, 0.75)
        anim_frames.append(f.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST))
        durations.append(130)
        
    # Slime Ataca (attack frames 4, 5, 6, 7)
    # Bastiao toma hit (frames 8, 9) durante o impacto
    hero_react = [0, 1, 8, 9]
    for i, s_idx in enumerate([4, 5, 6, 7]):
        b_idx = hero_react[i]
        hp = 1.0 if i < 2 else 0.88
        f = build_scene_frame(bastiao_frames[b_idx], slime_frames[s_idx], hp, 0.75)
        anim_frames.append(f.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST))
        durations.append(110)
        
    # Morte do Slime no final
    for s_d in [10, 11, 12, 13, 14, 15]:
        f = build_scene_frame(bastiao_frames[0], slime_frames[s_d], 0.88, 0.0)
        anim_frames.append(f.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST))
        durations.append(120)
        
    # Pausa com Slime derrotado
    for _ in range(2):
        # Frame transparente para o slime após morte
        empty_slime = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
        f = build_scene_frame(bastiao_frames[0], empty_slime, 0.88, 0.0)
        anim_frames.append(f.resize((WIDTH * 2, HEIGHT * 2), Image.NEAREST))
        durations.append(250)
        
    out_gif_repo = os.path.join(PROJECT_ROOT, "docs", "art", "combat_loop_bosque_lumen.gif")
    anim_frames[0].save(
        out_gif_repo,
        save_all=True,
        append_images=anim_frames[1:],
        duration=durations,
        loop=0,
        optimize=False
    )
    print("GIF salvo em:", out_gif_repo)
    
    out_gif_art = os.path.join(ARTIFACT_DIR, "combat_loop_bosque_lumen.gif")
    anim_frames[0].save(
        out_gif_art,
        save_all=True,
        append_images=anim_frames[1:],
        duration=durations,
        loop=0,
        optimize=False
    )
    print("GIF salvo em:", out_gif_art)
    
    # Criar versão base64 para embutir diretamente no HTML generativo
    with open(out_gif_art, "rb") as gf:
        gif_b64 = base64.b64encode(gf.read()).decode("utf-8")
        
    with open(out_static_art, "rb") as sf:
        png_b64 = base64.b64encode(sf.read()).decode("utf-8")
        
    b64_json_path = os.path.join(ARTIFACT_DIR, "preview_base64.json")
    import json
    with open(b64_json_path, "w", encoding="utf-8") as jf:
        json.dump({"gif_b64": gif_b64, "png_b64": png_b64}, jf)
    print("Base64 salvo com sucesso para uso no generative_ui!")

if __name__ == "__main__":
    main()
