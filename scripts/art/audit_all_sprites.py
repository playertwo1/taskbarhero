import os
import hashlib
from collections import defaultdict
from PIL import Image

SPRITES_DIR = os.path.abspath("assets/sprites")

def get_file_md5(path):
    with open(path, "rb") as f:
        return hashlib.md5(f.read()).hexdigest()

def get_image_hash(im):
    return hashlib.md5(im.tobytes()).hexdigest()

def analyze_facing(im):
    # Analyze center of mass / density of features
    # Or count opaque pixels on left half vs right half
    w, h = im.size
    left_pixels = 0
    right_pixels = 0
    for x in range(w):
        for y in range(h):
            p = im.getpixel((x, y))
            alpha = p[3] if len(p) >= 4 else 255
            if alpha > 30:
                if x < w / 2:
                    left_pixels += 1
                elif x > w / 2:
                    right_pixels += 1
    return left_pixels, right_pixels

print("=================================================================")
print("=== AUDITORIA COMPLETA DE SPRITES (POCKET HERO) ===")
print("=================================================================")

all_pngs = []
for root, dirs, files in os.walk(SPRITES_DIR):
    for f in files:
        if f.lower().endswith(".png"):
            all_pngs.append(os.path.join(root, f))

print(f"Total de arquivos PNG encontrados em assets/sprites: {len(all_pngs)}")

# 1. VERIFICAR DUPLICATAS EXATAS DE ARQUIVOS (MD5)
md5_map = defaultdict(list)
for p in all_pngs:
    m = get_file_md5(p)
    rel = os.path.relpath(p, SPRITES_DIR)
    md5_map[m].append(rel)

duplicates = {k: v for k, v in md5_map.items() if len(v) > 1}
print(f"\n--- 1. VERIFICAÇÃO DE ARQUIVOS DUPLICADOS (MD5 IDÊNTICO) ---")
if duplicates:
    print(f"ATENÇÃO: Encontrados {len(duplicates)} grupos de arquivos com conteúdo idêntico:")
    for m, paths in duplicates.items():
        print(f"  [MD5 {m[:8]}]")
        for pt in paths:
            print(f"    - {pt}")
else:
    print("Nenhum arquivo PNG duplicado encontrado entre todos os assets!")

# 2. VERIFICAR ÍCONES DE ITENS (30 ITENS)
print(f"\n--- 2. AUDITORIA DE ÍCONES DE ITENS ---")
items_dir = os.path.join(SPRITES_DIR, "items", "icons")
if os.path.exists(items_dir):
    item_files = [f for f in os.listdir(items_dir) if f.endswith(".png")]
    print(f"Total de ícones de itens: {len(item_files)}")
    item_hashes = {}
    for f in sorted(item_files):
        p = os.path.join(items_dir, f)
        im = Image.open(p)
        h = get_image_hash(im)
        if h in item_hashes:
            print(f"  [ERRO DUPLICATA] Item '{f}' tem imagem idêntica a '{item_hashes[h]}'")
        else:
            item_hashes[h] = f
        if im.size != (32, 32):
            print(f"  [AVISO DIMENSÃO] Item '{f}' tem tamanho {im.size}, esperado (32, 32)")
    print("Verificação de itens concluída.")

# 3. VERIFICAR ÍCONES DE SKILLS
print(f"\n--- 3. AUDITORIA DE ÍCONES DE SKILLS ---")
skills_dir = os.path.join(SPRITES_DIR, "skills", "icons")
if os.path.exists(skills_dir):
    skill_files = [f for f in os.listdir(skills_dir) if f.endswith(".png")]
    print(f"Total de ícones de skills: {len(skill_files)}")
    skill_hashes = {}
    for f in sorted(skill_files):
        p = os.path.join(skills_dir, f)
        im = Image.open(p)
        h = get_image_hash(im)
        if h in skill_hashes:
            print(f"  [ERRO DUPLICATA] Skill '{f}' tem imagem idêntica a '{skill_hashes[h]}'")
        else:
            skill_hashes[h] = f
        if im.size != (32, 32):
            print(f"  [AVISO DIMENSÃO] Skill '{f}' tem tamanho {im.size}, esperado (32, 32)")
    print("Verificação de skills concluída.")

# 4. AUDITORIA DE SPRITESHEETS DE HERÓIS (8 HERÓIS)
print(f"\n--- 4. AUDITORIA DE SPRITESHEETS DE HERÓIS (8 HERÓIS) ---")
heroes = ["bastiao", "flecha", "iris", "brasa", "veu", "orvalho", "forja", "sino"]
for h in heroes:
    sheet_p = os.path.join(SPRITES_DIR, "heroes", h, f"hero_{h}_sheet.png")
    if not os.path.exists(sheet_p):
        print(f"  [ERRO] Planilha ausente: {sheet_p}")
        continue
    im = Image.open(sheet_p)
    w, h_img = im.size
    frame_w = w // 16
    print(f"Heroi '{h.upper()}': {w}x{h_img} -> 16 frames de {frame_w}x{h_img}")
    if frame_w != 48 or h_img != 48:
        print(f"  [AVISO DIMENSÃO] Esperado 48x48 por frame, encontrado {frame_w}x{h_img}")
    
    # Extrair frames
    frames = []
    frame_hashes = []
    for i in range(16):
        box = (i * frame_w, 0, (i + 1) * frame_w, h_img)
        fr = im.crop(box)
        frames.append(fr)
        frame_hashes.append(get_image_hash(fr))
    
    # Conferir animações:
    # 0..3: idle, 4..7: attack, 8..11: hit, 12..15: death
    idle_h = frame_hashes[0:4]
    atk_h = frame_hashes[4:8]
    hit_h = frame_hashes[8:12]
    dth_h = frame_hashes[12:16]
    
    # Checar se todos os frames de idle sao estáticos (idênticos)
    if len(set(idle_h)) == 1:
        print(f"  [AVISO] Idle tem 4 frames idênticos (sem movimento)")
    else:
        print(f"  [OK] Idle animado ({len(set(idle_h))} quadros distintos)")
        
    if len(set(atk_h)) == 1:
        print(f"  [AVISO] Attack tem 4 frames idênticos")
    else:
        print(f"  [OK] Attack animado ({len(set(atk_h))} quadros distintos)")

    if len(set(hit_h)) == 1:
        print(f"  [AVISO] Hit tem 4 frames idênticos")
    else:
        print(f"  [OK] Hit animado ({len(set(hit_h))} quadros distintos)")

    if len(set(dth_h)) == 1:
        print(f"  [AVISO] Death tem 4 frames idênticos")
    else:
        print(f"  [OK] Death animado ({len(set(dth_h))} quadros distintos)")

    # Checar se attack é cópia de idle
    if set(atk_h).issubset(set(idle_h)):
        print(f"  [ERRO] Attack é cópia exata do Idle!")

# 5. AUDITORIA DE SPRITESHEETS DE INIMIGOS E CHEFES
print(f"\n--- 5. AUDITORIA DE SPRITESHEETS DE INIMIGOS E CHEFES ---")
enemies_info = [
    ("geleia_de_lumen", "enemy_geleia_lumen_sheet.png", 48), # or comfy?
    ("gremlin_de_folha", "mob_gremlin_folha_sheet.png", 48),
    ("javali_de_musgo", "mob_javali_musgo_sheet.png", 48),
    ("espirito_de_raiz", "mob_espirito_raiz_sheet.png", 48),
    ("lobo_alfa_de_lumen", "mob_lobo_alfa_sheet.png", 48),
    ("guardiao_cervo", "boss_guardiao_cervo_sheet.png", 64),
    ("saqueador_da_mata", "mob_saqueador_mata_sheet.png", 48),
    ("xama_de_esporos", "mob_xama_esporos_sheet.png", 48),
    ("sentinela_de_raizes", "mob_sentinela_raizes_sheet.png", 48),
    ("lobo_de_sombra", "mob_lobo_sombra_sheet.png", 48),
    ("matriarca_micelio", "boss_matriarca_micelio_sheet.png", 64),
]

for folder, sheet_name, exp_dim in enemies_info:
    sub = "enemies" if "boss" not in sheet_name else "bosses"
    sheet_p = os.path.join(SPRITES_DIR, sub, folder, sheet_name)
    if not os.path.exists(sheet_p):
        print(f"  [ERRO] Planilha ausente: {sheet_p}")
        continue
    im = Image.open(sheet_p)
    w, h_img = im.size
    frame_w = w // 16
    print(f"Inimigo '{folder.upper()}': {w}x{h_img} -> 16 frames de {frame_w}x{h_img}")
    if frame_w != exp_dim or h_img != exp_dim:
        print(f"  [AVISO DIMENSÃO] Esperado {exp_dim}x{exp_dim} por frame, encontrado {frame_w}x{h_img}")
    
    # Extrair frames
    frame_hashes = []
    for i in range(16):
        box = (i * frame_w, 0, (i + 1) * frame_w, h_img)
        fr = im.crop(box)
        frame_hashes.append(get_image_hash(fr))
    
    idle_h = frame_hashes[0:4]
    atk_h = frame_hashes[4:8]
    hit_h = frame_hashes[8:12]
    dth_h = frame_hashes[12:16]
    
    print(f"  [Quadros distintos] Idle: {len(set(idle_h))}, Atk: {len(set(atk_h))}, Hit: {len(set(hit_h))}, Death: {len(set(dth_h))}")
    if set(atk_h).issubset(set(idle_h)):
        print(f"  [ERRO] Attack é cópia exata do Idle!")

print("\nAuditoria concluída!")
