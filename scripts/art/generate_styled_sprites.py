"""
Pocket Hero — Styled Sprite Generator
Generates high-fidelity pixel art spritesheets inspired by the Campfire Heroes reference
and conforming to the Pocket Hero Sprite Style Guide (docs/art/SPRITE_STYLE_GUIDE.md).

Pure Python + PIL (Zero external dependencies).
"""

import os
from PIL import Image, ImageDraw

def hex_to_rgba(hex_str, alpha=255):
    h = hex_str.lstrip('#')
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), alpha)

# ==========================================
# PALETTES
# ==========================================
# Pele
SKIN_SHADOW    = hex_to_rgba("#965b40")
SKIN_MID       = hex_to_rgba("#c9855b")
SKIN_LIGHT     = hex_to_rgba("#f2b68c")
SKIN_HIGHLIGHT = hex_to_rgba("#ffe0cc")

# Cavaleiro Bastião (Aço, Ouro, Vermelho Escarlate)
STEEL_OUTLINE  = hex_to_rgba("#141923")
STEEL_DEEP     = hex_to_rgba("#222d3d")
STEEL_MID      = hex_to_rgba("#41536b")
STEEL_LIGHT    = hex_to_rgba("#728ea8")
STEEL_SPEC     = hex_to_rgba("#c8e0f5")

RED_OUTLINE    = hex_to_rgba("#29080e")
RED_DEEP       = hex_to_rgba("#541219")
RED_MID        = hex_to_rgba("#8f2228")
RED_LIGHT      = hex_to_rgba("#d43538")
RED_SPEC       = hex_to_rgba("#ff635e")

GOLD_OUTLINE   = hex_to_rgba("#241a05")
GOLD_DEEP      = hex_to_rgba("#4f390a")
GOLD_MID       = hex_to_rgba("#946f17")
GOLD_LIGHT     = hex_to_rgba("#d9a729")
GOLD_SPEC      = hex_to_rgba("#ffe56b")

# Maga Íris (Roxo Real, Lavanda, Branco/Ouro, Cristal Ciano)
PURPLE_OUTLINE = hex_to_rgba("#170924")
PURPLE_DEEP    = hex_to_rgba("#2c1145")
PURPLE_MID     = hex_to_rgba("#562280")
PURPLE_LIGHT   = hex_to_rgba("#8c3ec4")
PURPLE_SPEC    = hex_to_rgba("#c47df7")

ROBE_WHITE_OUT = hex_to_rgba("#202330")
ROBE_WHITE_MID = hex_to_rgba("#8891a6")
ROBE_WHITE_LGT = hex_to_rgba("#dbe0ed")

CYAN_OUTLINE   = hex_to_rgba("#062429")
CYAN_DEEP      = hex_to_rgba("#0c474d")
CYAN_MID       = hex_to_rgba("#178a91")
CYAN_LIGHT     = hex_to_rgba("#34cbd1")
CYAN_SPEC      = hex_to_rgba("#aeffff")

WOOD_OUTLINE   = hex_to_rgba("#1f140c")
WOOD_DEEP      = hex_to_rgba("#3d2817")
WOOD_MID       = hex_to_rgba("#694729")
WOOD_LIGHT     = hex_to_rgba("#9e7247")

# Arqueira Flecha (Verde Floresta, Couro, Dourado/Cabelo Loiro)
HAIR_OUTLINE   = hex_to_rgba("#2b1e06")
HAIR_DEEP      = hex_to_rgba("#5c4210")
HAIR_MID       = hex_to_rgba("#a3791d")
HAIR_LIGHT     = hex_to_rgba("#ebba3b")
HAIR_SPEC      = hex_to_rgba("#ffe478")

GREEN_OUTLINE  = hex_to_rgba("#0a1c11")
GREEN_DEEP     = hex_to_rgba("#143822")
GREEN_MID      = hex_to_rgba("#26613c")
GREEN_LIGHT    = hex_to_rgba("#3f965e")
GREEN_SPEC     = hex_to_rgba("#7ed19c")

LEATHER_OUT    = hex_to_rgba("#1f120a")
LEATHER_DEEP   = hex_to_rgba("#3d2414")
LEATHER_MID    = hex_to_rgba("#693f23")
LEATHER_LIGHT  = hex_to_rgba("#996138")

WHITE_ARROW    = hex_to_rgba("#e6ebf5")
WHITE_ARROW_O  = hex_to_rgba("#434a59")

# Inimigos
MOSS_GREEN     = hex_to_rgba("#2f703e")
MOSS_LIGHT     = hex_to_rgba("#52ab67")
EARTH_BROWN    = hex_to_rgba("#4a321e")
EARTH_DARK     = hex_to_rgba("#26170a")
IVORY_TUSK     = hex_to_rgba("#fff4d9")
IVORY_SHADOW   = hex_to_rgba("#9c8968")
LOB_DARK       = hex_to_rgba("#121721")
LOB_MID        = hex_to_rgba("#1f2738")
LOB_LIGHT      = hex_to_rgba("#384661")
STONE_DARK     = hex_to_rgba("#19212b")
STONE_MID      = hex_to_rgba("#334254")
STONE_LIGHT    = hex_to_rgba("#586e87")
STONE_SPEC     = hex_to_rgba("#9bb2cc")

def p(img, x, y, col):
    w, h = img.size
    if 0 <= x < w and 0 <= y < h and col is not None:
        img.putpixel((int(x), int(y)), col)

def rect(img, x1, y1, x2, y2, col):
    for y in range(int(y1), int(y2) + 1):
        for x in range(int(x1), int(x2) + 1):
            p(img, x, y, col)

def apply_hit_flash(img):
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    pix_in = img.load()
    pix_out = out.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix_in[x, y]
            if a > 0:
                pix_out[x, y] = (min(255, r + 90), max(0, g - 25), max(0, b - 25), a)
    return out

def apply_death_dither(img, step, max_steps=6):
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    pix_in = img.load()
    pix_out = out.load()
    w, h = img.size
    threshold = step / float(max_steps)
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix_in[x, y]
            if a > 0:
                checker = ((x * 5 + y * 11 + step * 3) % 7) / 7.0
                if checker >= threshold:
                    pix_out[x, y] = (r, g, b, a)
    return out

# ==========================================
# 1. BASTIÃO (48x48, Facing Right)
# ==========================================
def draw_bastiao_frame(action="idle", step=0):
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    
    bob_y = 0
    shield_ox = 0
    sword_ox = 0
    
    if action == "idle":
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        if step == 0:
            bob_y = 1
            shield_ox = -1
            sword_ox = -2
        elif step == 1:
            bob_y = 0
            shield_ox = 3
            sword_ox = 4
        elif step == 2:
            bob_y = -1
            shield_ox = 5
            sword_ox = 9
        elif step == 3:
            bob_y = 0
            shield_ox = 2
            sword_ox = 3
    elif action == "hit":
        bob_y = 1
        shield_ox = -3 if step == 0 else -1
        sword_ox = -3
    elif action == "death":
        bob_y = step * 2

    by = 44 + bob_y
    bx = 20
    
    # 1. Botas e Grevas de Aço
    rect(img, bx - 6, by - 3, bx - 2, by, STEEL_DEEP)
    rect(img, bx - 5, by - 3, bx - 3, by - 1, STEEL_MID)
    rect(img, bx + 1, by - 4, bx + 6, by, STEEL_OUTLINE)
    rect(img, bx + 2, by - 3, bx + 5, by - 1, STEEL_LIGHT)
    rect(img, bx + 3, by - 3, bx + 5, by - 2, STEEL_SPEC)
    rect(img, bx + 2, by - 1, bx + 5, by, STEEL_MID)

    # Pernas e Joelheira Dourada
    rect(img, bx - 5, by - 9, bx - 1, by - 4, STEEL_OUTLINE)
    rect(img, bx - 4, by - 8, bx - 2, by - 5, STEEL_MID)
    rect(img, bx + 1, by - 10, bx + 5, by - 4, STEEL_OUTLINE)
    rect(img, bx + 2, by - 9, bx + 4, by - 5, STEEL_LIGHT)
    p(img, bx + 2, by - 8, GOLD_SPEC)
    p(img, bx + 3, by - 8, GOLD_LIGHT)
    p(img, bx + 2, by - 7, GOLD_MID)

    # 2. Cota de Malha, Cinto e Túnica Escarlate
    rect(img, bx - 6, by - 14, bx + 4, by - 10, RED_OUTLINE)
    rect(img, bx - 5, by - 13, bx + 3, by - 11, RED_MID)
    rect(img, bx - 3, by - 13, bx + 1, by - 11, RED_LIGHT)
    rect(img, bx - 6, by - 12, bx + 4, by - 11, GOLD_OUTLINE)
    rect(img, bx - 1, by - 12, bx + 1, by - 11, GOLD_SPEC)
    
    # 3. Peitoral de Aço Polido
    rect(img, bx - 7, by - 23, bx + 4, by - 13, STEEL_OUTLINE)
    rect(img, bx - 6, by - 22, bx + 3, by - 14, STEEL_MID)
    rect(img, bx - 4, by - 22, bx + 2, by - 16, STEEL_LIGHT)
    rect(img, bx - 2, by - 21, bx + 1, by - 18, STEEL_SPEC)
    rect(img, bx - 2, by - 18, bx, by - 15, RED_LIGHT)

    # 4. Ombreiras (Pauldrons)
    rect(img, bx - 9, by - 25, bx - 5, by - 20, STEEL_OUTLINE)
    rect(img, bx - 8, by - 24, bx - 6, by - 21, STEEL_MID)
    rect(img, bx + 1, by - 25, bx + 6, by - 19, STEEL_OUTLINE)
    rect(img, bx + 2, by - 24, bx + 5, by - 20, STEEL_LIGHT)
    p(img, bx + 3, by - 24, STEEL_SPEC)
    p(img, bx + 4, by - 24, STEEL_SPEC)
    p(img, bx + 2, by - 20, GOLD_LIGHT)
    p(img, bx + 3, by - 20, GOLD_LIGHT)

    # 5. Elmo Bascinet com Pluma Vermelha (Inspirado no Cavaleiro da referência!)
    # Pluma vermelha imponente
    rect(img, bx - 4, by - 37, bx + 1, by - 33, RED_OUTLINE)
    rect(img, bx - 3, by - 36, bx, by - 34, RED_LIGHT)
    p(img, bx - 2, by - 36, RED_SPEC)
    p(img, bx - 1, by - 35, RED_SPEC)
    p(img, bx - 4, by - 35, RED_DEEP)
    p(img, bx - 5, by - 34, RED_DEEP)
    
    # Domo do Elmo
    rect(img, bx - 6, by - 34, bx + 4, by - 24, STEEL_OUTLINE)
    rect(img, bx - 5, by - 33, bx + 3, by - 25, STEEL_DEEP)
    rect(img, bx - 4, by - 33, bx + 2, by - 27, STEEL_MID)
    rect(img, bx - 2, by - 33, bx + 2, by - 29, STEEL_LIGHT)
    rect(img, bx, by - 33, bx + 1, by - 31, STEEL_SPEC)
    
    # Fenda do Visor com Olhar Heróico
    rect(img, bx - 3, by - 28, bx + 3, by - 27, STEEL_OUTLINE)
    p(img, bx, by - 28, GOLD_SPEC)
    p(img, bx + 1, by - 28, GOLD_LIGHT)
    rect(img, bx - 4, by - 25, bx + 2, by - 24, STEEL_MID)

    # 6. Espada de Aço
    spx = bx + 6 + sword_ox
    spy = by - 19
    if action == "attack" and step in [1, 2]:
        rect(img, spx - 2, spy - 2, spx + 16, spy + 2, STEEL_OUTLINE)
        rect(img, spx, spy - 1, spx + 15, spy + 1, STEEL_LIGHT)
        rect(img, spx + 2, spy, spx + 14, spy, STEEL_SPEC)
        p(img, spx + 16, spy, STEEL_SPEC)
        rect(img, spx - 2, spy - 4, spx, spy + 4, GOLD_OUTLINE)
        rect(img, spx - 1, spy - 3, spx, spy + 3, GOLD_LIGHT)
        # Rastro de golpe prateado
        p(img, spx + 10, spy - 3, STEEL_SPEC)
        p(img, spx + 14, spy - 4, STEEL_LIGHT)
    else:
        for i in range(10):
            p(img, spx + i, spy - i // 2, STEEL_LIGHT)
            p(img, spx + i, spy - i // 2 - 1, STEEL_SPEC)
            p(img, spx + i, spy - i // 2 + 1, STEEL_OUTLINE)
        rect(img, spx - 2, spy - 3, spx, spy + 3, GOLD_OUTLINE)
        rect(img, spx - 1, spy - 2, spx, spy + 2, GOLD_LIGHT)
        p(img, spx - 1, spy, GOLD_SPEC)

    # 7. Escudo Escarlate & Ouro (Heater Shield)
    sx = bx + 3 + shield_ox
    sy = by - 27
    rect(img, sx, sy, sx + 10, sy + 18, RED_OUTLINE)
    rect(img, sx + 1, sy + 1, sx + 9, sy + 17, RED_MID)
    rect(img, sx + 2, sy + 2, sx + 8, sy + 15, RED_LIGHT)
    rect(img, sx + 3, sy + 3, sx + 5, sy + 12, RED_SPEC)
    # Borda de Aço
    rect(img, sx, sy, sx + 10, sy + 1, STEEL_LIGHT)
    p(img, sx + 1, sy, STEEL_SPEC)
    p(img, sx + 9, sy, STEEL_SPEC)
    rect(img, sx, sy, sx + 1, sy + 18, STEEL_LIGHT)
    rect(img, sx + 9, sy, sx + 10, sy + 18, STEEL_DEEP)
    # Cruz Dourada
    rect(img, sx + 3, sy + 8, sx + 7, sy + 10, GOLD_OUTLINE)
    rect(img, sx + 4, sy + 9, sx + 6, sy + 9, GOLD_SPEC)
    rect(img, sx + 4, sy + 5, sx + 6, sy + 13, GOLD_OUTLINE)
    rect(img, sx + 5, sy + 6, sx + 5, sy + 12, GOLD_SPEC)
    # Base afunilada
    rect(img, sx + 1, sy + 18, sx + 9, sy + 19, RED_OUTLINE)
    rect(img, sx + 2, sy + 18, sx + 8, sy + 19, RED_MID)
    rect(img, sx + 3, sy + 20, sx + 7, sy + 21, RED_OUTLINE)
    rect(img, sx + 4, sy + 20, sx + 6, sy + 21, RED_DEEP)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)

    return img

# ==========================================
# 2. ÍRIS — A MAGA DE LÚMEN (48x48, Facing Right)
# ==========================================
def draw_iris_frame(action="idle", step=0):
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    
    bob_y = 0
    staff_ox = 0
    cast_pulse = 0
    
    if action == "idle":
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        if step == 0:
            bob_y = 1
            staff_ox = -1
        elif step == 1:
            bob_y = 0
            staff_ox = 2
            cast_pulse = 1
        elif step == 2:
            bob_y = -1
            staff_ox = 5
            cast_pulse = 2
        elif step == 3:
            bob_y = 0
            staff_ox = 2
    elif action == "hit":
        bob_y = 1
        staff_ox = -3 if step == 0 else -1
    elif action == "death":
        bob_y = step * 2

    by = 44 + bob_y
    bx = 20

    # 1. Pés e Botinas de Couro Escuro sob a saia
    rect(img, bx - 4, by - 3, bx - 1, by, PURPLE_OUTLINE)
    rect(img, bx - 3, by - 2, bx - 2, by, PURPLE_DEEP)
    rect(img, bx + 1, by - 3, bx + 4, by, PURPLE_OUTLINE)
    rect(img, bx + 2, by - 2, bx + 3, by, PURPLE_MID)

    # 2. Vestes Místicas e Saia Plissada Roxa
    rect(img, bx - 6, by - 14, bx + 5, by - 4, PURPLE_OUTLINE)
    rect(img, bx - 5, by - 13, bx + 4, by - 5, PURPLE_MID)
    rect(img, bx - 3, by - 13, bx + 2, by - 5, PURPLE_LIGHT)
    rect(img, bx - 1, by - 13, bx + 1, by - 7, PURPLE_SPEC)
    # Bainha dourada na saia
    rect(img, bx - 5, by - 4, bx + 4, by - 4, GOLD_LIGHT)
    p(img, bx - 1, by - 4, GOLD_SPEC)

    # 3. Túnica Branca com Broche Dourado e Capinha Roxa
    rect(img, bx - 6, by - 21, bx + 4, by - 14, ROBE_WHITE_OUT)
    rect(img, bx - 5, by - 20, bx + 3, by - 15, ROBE_WHITE_MID)
    rect(img, bx - 3, by - 20, bx + 2, by - 16, ROBE_WHITE_LGT)
    # Broche com cristal de Lúmen no decote
    rect(img, bx - 1, by - 19, bx + 1, by - 17, GOLD_OUTLINE)
    p(img, bx, by - 18, CYAN_LIGHT)
    p(img, bx, by - 17, CYAN_SPEC)
    # Capa com gola alta nas costas
    rect(img, bx - 8, by - 22, bx - 5, by - 10, PURPLE_OUTLINE)
    rect(img, bx - 7, by - 21, bx - 6, by - 11, PURPLE_DEEP)

    # 4. Rosto Chibi Expressivo com Cabelos Castanhos/Lilás
    rect(img, bx - 3, by - 28, bx + 4, by - 22, SKIN_SHADOW)
    rect(img, bx - 2, by - 27, bx + 3, by - 23, SKIN_LIGHT)
    rect(img, bx - 1, by - 27, bx + 2, by - 24, SKIN_HIGHLIGHT)
    # Cabelo franja
    rect(img, bx - 4, by - 28, bx - 2, by - 23, PURPLE_DEEP)
    rect(img, bx + 3, by - 28, bx + 5, by - 24, PURPLE_DEEP)
    # Olhos expressivos com brilho violeta/ciano
    p(img, bx, by - 25, PURPLE_OUTLINE)
    p(img, bx + 1, by - 25, CYAN_LIGHT)
    p(img, bx + 1, by - 26, CYAN_SPEC)
    p(img, bx + 2, by - 25, PURPLE_OUTLINE)
    # Bochecha corada
    p(img, bx + 2, by - 23, hex_to_rgba("#e67a7a"))

    # 5. Chapéu Cônico de Bruxa / Maga de Lúmen (Inspirado na referência!)
    # Aba larga circular do chapéu (Y: by-31 a by-29)
    rect(img, bx - 10, by - 31, bx + 8, by - 29, PURPLE_OUTLINE)
    rect(img, bx - 9, by - 30, bx + 7, by - 30, PURPLE_DEEP)
    rect(img, bx - 6, by - 30, bx + 4, by - 30, PURPLE_MID)
    rect(img, bx - 2, by - 30, bx + 2, by - 30, PURPLE_LIGHT)
    # Faixa do chapéu com fivela dourada
    rect(img, bx - 5, by - 33, bx + 4, by - 31, PURPLE_DEEP)
    rect(img, bx - 1, by - 33, bx + 1, by - 31, GOLD_LIGHT)
    p(img, bx, by - 32, GOLD_SPEC)
    # Cone dobrado com ponta charmosa (Y: by-42 a by-33)
    rect(img, bx - 5, by - 35, bx + 3, by - 33, PURPLE_OUTLINE)
    rect(img, bx - 4, by - 35, bx + 2, by - 33, PURPLE_MID)
    rect(img, bx - 1, by - 35, bx + 1, by - 33, PURPLE_LIGHT)
    
    rect(img, bx - 4, by - 38, bx + 1, by - 35, PURPLE_OUTLINE)
    rect(img, bx - 3, by - 38, bx, by - 36, PURPLE_LIGHT)
    p(img, bx - 1, by - 37, PURPLE_SPEC)
    
    # Ponta caída do chapéu para trás
    rect(img, bx - 6, by - 41, bx - 2, by - 38, PURPLE_OUTLINE)
    rect(img, bx - 5, by - 40, bx - 3, by - 39, PURPLE_MID)
    p(img, bx - 6, by - 41, PURPLE_LIGHT)

    # 6. Cajado do Luar com Cristal de Lúmen
    stx = bx + 7 + staff_ox
    sty = by - 34
    # Haste de madeira nobre polida
    for y in range(sty + 10, by):
        p(img, stx, y, WOOD_MID)
        p(img, stx - 1, y, WOOD_OUTLINE)
    # Encaixe dourado no topo
    rect(img, stx - 2, sty + 8, stx + 2, sty + 10, GOLD_OUTLINE)
    rect(img, stx - 1, sty + 9, stx + 1, sty + 10, GOLD_LIGHT)
    p(img, stx, sty + 9, GOLD_SPEC)
    
    # Anel orbital e Esfera Radiante de Lúmen
    rect(img, stx - 3, sty, stx + 3, sty + 6, CYAN_OUTLINE)
    rect(img, stx - 2, sty + 1, stx + 2, sty + 5, CYAN_DEEP)
    rect(img, stx - 1, sty + 2, stx + 1, sty + 4, CYAN_LIGHT)
    p(img, stx, sty + 2, CYAN_SPEC)
    p(img, stx - 1, sty + 3, CYAN_SPEC)
    
    # Mão da maga segurando o cajado
    rect(img, stx - 2, by - 18, stx, by - 16, SKIN_LIGHT)
    p(img, stx - 1, by - 17, SKIN_HIGHLIGHT)

    # Efeito de ataque / Projétil Arcano
    if cast_pulse > 0:
        # Partículas cintilantes ao redor do orbe
        p(img, stx + 4, sty + 1, CYAN_SPEC)
        p(img, stx + 6, sty + 3, CYAN_LIGHT)
        p(img, stx + 2, sty - 2, CYAN_SPEC)
        p(img, stx + 5, sty + 6, CYAN_MID)
        if cast_pulse == 2:
            # Projétil saindo disparado!
            rect(img, stx + 7, sty + 1, stx + 11, sty + 4, CYAN_OUTLINE)
            rect(img, stx + 8, sty + 2, stx + 10, sty + 3, CYAN_SPEC)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)

    return img

# ==========================================
# 3. FLECHA — A ARQUEIRA ÉLFICA (48x48, Facing Right)
# ==========================================
def draw_flecha_frame(action="idle", step=0):
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    
    bob_y = 0
    bow_draw = 0
    arrow_fired = 0
    
    if action == "idle":
        bobs = [0, 1, 0, -1]
        bob_y = bobs[step % 4]
    elif action == "attack":
        if step == 0:
            bob_y = 1
            bow_draw = 1
        elif step == 1:
            bob_y = 0
            bow_draw = 3
        elif step == 2:
            bob_y = -1
            bow_draw = 4
            arrow_fired = 1
        elif step == 3:
            bob_y = 0
            bow_draw = 1
            arrow_fired = 2
    elif action == "hit":
        bob_y = 1
        bow_draw = -2
    elif action == "death":
        bob_y = step * 2

    by = 44 + bob_y
    bx = 18

    # 1. Botas Ágeis de Couro e Pernas
    rect(img, bx - 5, by - 3, bx - 1, by, LEATHER_OUT)
    rect(img, bx - 4, by - 2, bx - 2, by, LEATHER_MID)
    rect(img, bx + 1, by - 4, bx + 5, by, LEATHER_OUT)
    rect(img, bx + 2, by - 3, bx + 4, by - 1, LEATHER_LIGHT)
    rect(img, bx + 2, by - 1, bx + 4, by, LEATHER_MID)

    # Pernas com calças de batedor
    rect(img, bx - 4, by - 9, bx - 1, by - 4, LEATHER_DEEP)
    rect(img, bx + 1, by - 9, bx + 4, by - 4, LEATHER_MID)

    # 2. Túnica Verde-Floresta com Detalhes Dourados
    rect(img, bx - 6, by - 15, bx + 4, by - 9, GREEN_OUTLINE)
    rect(img, bx - 5, by - 14, bx + 3, by - 10, GREEN_MID)
    rect(img, bx - 3, by - 14, bx + 1, by - 10, GREEN_LIGHT)
    p(img, bx - 1, by - 13, GREEN_SPEC)
    # Cinto de couro com bolsa e fivela de bronze
    rect(img, bx - 5, by - 11, bx + 3, by - 10, LEATHER_OUT)
    rect(img, bx - 1, by - 11, bx + 1, by - 10, GOLD_LIGHT)

    # 3. Peitoral de Couro e Capuz / Manto Élfico
    rect(img, bx - 6, by - 22, bx + 3, by - 15, GREEN_OUTLINE)
    rect(img, bx - 5, by - 21, bx + 2, by - 16, GREEN_MID)
    rect(img, bx - 3, by - 21, bx + 1, by - 17, GREEN_LIGHT)
    # Broche de folha esmeralda
    p(img, bx - 1, by - 19, GREEN_SPEC)

    # 4. Aljava de Flechas nas Costas
    rect(img, bx - 8, by - 24, bx - 5, by - 12, LEATHER_OUT)
    rect(img, bx - 7, by - 23, bx - 6, by - 13, LEATHER_MID)
    # Penas brancas das flechas saindo da aljava
    p(img, bx - 8, by - 26, WHITE_ARROW)
    p(img, bx - 7, by - 27, WHITE_ARROW)
    p(img, bx - 6, by - 25, WHITE_ARROW)

    # 5. Cabeça, Cabelo Loiro/Dourado e Orelhas Élficas (Inspirado na referência!)
    rect(img, bx - 4, by - 30, bx + 4, by - 22, SKIN_SHADOW)
    rect(img, bx - 3, by - 29, bx + 3, by - 23, SKIN_LIGHT)
    rect(img, bx - 1, by - 28, bx + 2, by - 24, SKIN_HIGHLIGHT)
    
    # Orelha pontuda élfica saindo para a esquerda/trás
    p(img, bx - 5, by - 26, SKIN_LIGHT)
    p(img, bx - 6, by - 27, SKIN_SHADOW)
    p(img, bx - 5, by - 27, SKIN_HIGHLIGHT)

    # Cabelo Loiro Dourado Volumoso
    rect(img, bx - 5, by - 33, bx + 4, by - 29, HAIR_OUTLINE)
    rect(img, bx - 4, by - 32, bx + 3, by - 30, HAIR_MID)
    rect(img, bx - 2, by - 32, bx + 2, by - 30, HAIR_LIGHT)
    p(img, bx, by - 31, HAIR_SPEC)
    p(img, bx + 1, by - 31, HAIR_SPEC)
    # Fita / Laço verde esmeralda no cabelo
    rect(img, bx - 4, by - 34, bx - 2, by - 32, GREEN_LIGHT)
    p(img, bx - 3, by - 33, GREEN_SPEC)

    # Olhos de Falcão (Foco penetrante)
    p(img, bx + 1, by - 26, GREEN_OUTLINE)
    p(img, bx + 2, by - 26, CYAN_SPEC)
    p(img, bx + 1, by - 25, CYAN_LIGHT)

    # 6. Arco Longo Recurvo Élfico e Flecha
    bow_x = bx + 6
    bow_y = by - 20
    # Mão segurando o arco
    rect(img, bow_x - 2, bow_y - 2, bow_x, bow_y, SKIN_LIGHT)
    
    # Madeira curvada do arco
    p(img, bow_x + 1, bow_y - 12, WOOD_OUTLINE)
    p(img, bow_x + 2, bow_y - 11, WOOD_LIGHT)
    p(img, bow_x + 3, bow_y - 9, WOOD_MID)
    p(img, bow_x + 4, bow_y - 6, WOOD_LIGHT)
    p(img, bow_x + 4, bow_y - 2, WOOD_MID)
    p(img, bow_x + 4, bow_y + 2, WOOD_LIGHT)
    p(img, bow_x + 4, bow_y + 6, WOOD_MID)
    p(img, bow_x + 3, bow_y + 9, WOOD_LIGHT)
    p(img, bow_x + 2, bow_y + 11, WOOD_MID)
    p(img, bow_x + 1, bow_y + 12, WOOD_OUTLINE)
    # Pontas douradas do arco
    p(img, bow_x + 1, bow_y - 13, GOLD_SPEC)
    p(img, bow_x + 1, bow_y + 13, GOLD_SPEC)

    # Corda do arco
    string_pull_x = bow_x - bow_draw
    for y in range(bow_y - 12, bow_y + 13):
        # A corda converge para a mão que puxa no centro
        t = abs(y - bow_y) / 12.0
        sx = int(string_pull_x * (1.0 - t) + bow_x * t)
        p(img, sx, y, WHITE_ARROW)

    # Flecha engastada
    if action == "attack" and arrow_fired == 1:
        # Flecha voando em alta velocidade!
        for i in range(12):
            p(img, bow_x + 2 + i, bow_y, STEEL_LIGHT)
        # Ponta de aço
        p(img, bow_x + 14, bow_y, STEEL_SPEC)
        # Rastro de vento
        p(img, bow_x + 4, bow_y - 1, CYAN_LIGHT)
        p(img, bow_x + 8, bow_y + 1, CYAN_LIGHT)
    elif action != "attack" or arrow_fired == 0:
        # Flecha pronta na corda
        for i in range(10):
            p(img, string_pull_x + i, bow_y, WOOD_LIGHT)
        p(img, string_pull_x + 10, bow_y, STEEL_SPEC)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)

    return img

print("Hero generators defined successfully.")
