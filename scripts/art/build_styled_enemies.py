"""
Pocket Hero — Master Styled Enemies Spritesheet Builder
Directly conforming to docs/art/SPRITE_STYLE_GUIDE.md and elevated to
the master chibi pixel art quality of the reference.

Builds 16-frame spritesheets for all 6 Bosque de Lúmen creatures:
1. Geleia de Lúmen (32x32, 512x32)
2. Gremlin de Folha (32x32, 512x32)
3. Javali de Musgo (48x48, 768x48)
4. Espírito de Raiz (48x48, 768x48)
5. Lobo Alfa de Lúmen (48x48, 768x48)
6. Guardião-Cervo de Pedra (64x64, 1024x64)

Facing direction: LEFT (towards the player party).
"""

import os
from PIL import Image

def hex_to_rgba(hex_str, alpha=255):
    h = hex_str.lstrip('#')
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), alpha)

# ==========================================
# PALETTES
# ==========================================
OUT_DARK       = hex_to_rgba("#0f1419")
OUT_CYAN       = hex_to_rgba("#082229")
OUT_GREEN      = hex_to_rgba("#0c1c11")
OUT_BROWN      = hex_to_rgba("#211409")
OUT_SLIME      = hex_to_rgba("#062624")
OUT_WOLF       = hex_to_rgba("#0e131f")
OUT_STONE      = hex_to_rgba("#141a24")

# Geleia de Lúmen
SLIME_DARK     = hex_to_rgba("#0f474d")
SLIME_MID      = hex_to_rgba("#1a828a")
SLIME_LIGHT    = hex_to_rgba("#32c2cc")
SLIME_HIGH     = hex_to_rgba("#6dedf7")
SLIME_SPEC     = hex_to_rgba("#dffffc")
CORE_DARK      = hex_to_rgba("#07595e")
CORE_GLOW      = hex_to_rgba("#a1ffff")

# Gremlin de Folha
GREM_SKIN_DARK = hex_to_rgba("#2e5728")
GREM_SKIN_MID  = hex_to_rgba("#4f823f")
GREM_SKIN_LGT  = hex_to_rgba("#7cb565")
GREM_SKIN_HIGH = hex_to_rgba("#aee092")
LEAF_DARK      = hex_to_rgba("#1c3b1e")
LEAF_MID       = hex_to_rgba("#2f6133")
LEAF_LGT       = hex_to_rgba("#509455")
LEAF_HIGH      = hex_to_rgba("#7fd686")
EYE_YELLOW     = hex_to_rgba("#ffe642")
EYE_PUPIL      = hex_to_rgba("#5e1100")
WOOD_DARK      = hex_to_rgba("#382213")
WOOD_MID       = hex_to_rgba("#613f26")
WOOD_LGT       = hex_to_rgba("#8c603e")
THORN_WHITE    = hex_to_rgba("#e8e2d5")

# Javali de Musgo
BOAR_HIDE_DARK = hex_to_rgba("#291c14")
BOAR_HIDE_MID  = hex_to_rgba("#473225")
BOAR_HIDE_LGT  = hex_to_rgba("#6e503c")
MOSS_DARK      = hex_to_rgba("#1d4022")
MOSS_MID       = hex_to_rgba("#326939")
MOSS_LGT       = hex_to_rgba("#529e5d")
MOSS_HIGH      = hex_to_rgba("#85db92")
TUSK_DARK      = hex_to_rgba("#8a7c65")
TUSK_MID       = hex_to_rgba("#ded4ba")
TUSK_LGT       = hex_to_rgba("#fff9eb")
EYE_RED        = hex_to_rgba("#ff3838")
EYE_RED_GLOW   = hex_to_rgba("#ffa8a8")

# Espírito de Raiz
BARK_DARK      = hex_to_rgba("#24160d")
BARK_MID       = hex_to_rgba("#422b1b")
BARK_LGT       = hex_to_rgba("#69472e")
BARK_HIGH      = hex_to_rgba("#9c714e")
LUMEN_CORE_D   = hex_to_rgba("#0c4f52")
LUMEN_CORE_M   = hex_to_rgba("#1ba6ab")
LUMEN_CORE_L   = hex_to_rgba("#45f1f7")
LUMEN_CORE_H   = hex_to_rgba("#d4ffff")
ROOT_MOSS_D    = hex_to_rgba("#1d3820")
ROOT_MOSS_L    = hex_to_rgba("#467a4b")

# Lobo Alfa de Lúmen
WOLF_DARK      = hex_to_rgba("#101524")
WOLF_MID       = hex_to_rgba("#1b253d")
WOLF_LGT       = hex_to_rgba("#2f3e61")
WOLF_HIGH      = hex_to_rgba("#506494")
ASTRAL_CYAN_D  = hex_to_rgba("#12666e")
ASTRAL_CYAN_M  = hex_to_rgba("#22aab5")
ASTRAL_CYAN_L  = hex_to_rgba("#51ecf7")
ASTRAL_CYAN_H  = hex_to_rgba("#c9ffff")
FANG_WHITE     = hex_to_rgba("#edf2fa")

# Guardião-Cervo de Pedra
STONE_DARK     = hex_to_rgba("#1c222e")
STONE_MID      = hex_to_rgba("#313b4d")
STONE_LGT      = hex_to_rgba("#51607a")
STONE_HIGH     = hex_to_rgba("#8295b8")
STONE_SPEC     = hex_to_rgba("#bad1fa")
ANTLER_WOOD_D  = hex_to_rgba("#332415")
ANTLER_WOOD_M  = hex_to_rgba("#5c422a")
ANTLER_WOOD_L  = hex_to_rgba("#876442")
RUNE_GOLD_D    = hex_to_rgba("#634808")
RUNE_GOLD_M    = hex_to_rgba("#b5881f")
RUNE_GOLD_L    = hex_to_rgba("#fad04d")
RUNE_GOLD_H    = hex_to_rgba("#fff6b8")
BOSS_MOSS_D    = hex_to_rgba("#1d3d22")
BOSS_MOSS_L    = hex_to_rgba("#487d50")
LANTERN_GLOW   = hex_to_rgba("#61fff5")

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
                pix_out[x, y] = (min(255, r + 110), max(0, g - 20), max(0, b - 20), a)
    return out

def apply_death_dither(img, step, max_steps=6):
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    pix_in = img.load()
    pix_out = out.load()
    w, h = img.size
    threshold = (step + 1) / float(max_steps)
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix_in[x, y]
            if a > 0:
                checker = ((x * 7 + y * 13 + step * 5) % 11) / 11.0
                if checker >= threshold:
                    pix_out[x, y] = (min(255, r + 40), min(255, g + 60), min(255, b + 80), int(a * (1.0 - threshold * 0.7)))
    return out

# =========================================================================
# 1. GELEIA DE LÚMEN (32x32)
# =========================================================================
def draw_geleia_frame(action="idle", step=0):
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    squish_x, squish_y, offset_x = (0, 0, 0)
    if action == "idle":
        cycle = [(0, 0), (1, -1), (0, -2), (-1, -1)]
        squish_x, squish_y = cycle[step % 4]
    elif action == "attack":
        if step == 0: squish_x, squish_y, offset_x = (2, 1, 2)
        elif step == 1: squish_x, squish_y, offset_x = (-1, -3, -4)
        elif step == 2: squish_x, squish_y, offset_x = (3, 2, -6)
        elif step == 3: squish_x, squish_y, offset_x = (1, 0, -2)
    elif action == "hit":
        squish_x, squish_y, offset_x = (-2, 2, 3)
    elif action == "death":
        squish_y = step
        squish_x = step * 2

    base_x = 16 + offset_x
    base_y = 28 + squish_y
    rx = 8 + squish_x
    ry = 7 - squish_y // 2

    for dy in range(-ry - 4, 1):
        progress = (dy + ry + 4) / float(ry + 5)
        w_cur = int(rx * (progress ** 0.65))
        y = base_y + dy
        if w_cur > 0:
            rect(img, base_x - w_cur - 1, y, base_x + w_cur + 1, y, OUT_SLIME)
            rect(img, base_x - w_cur, y, base_x + w_cur, y, SLIME_DARK)
            rect(img, base_x - w_cur + 1, y, base_x + w_cur - 1, y, SLIME_MID)
            rect(img, base_x - w_cur + 2, y, base_x + 1, y, SLIME_LIGHT)

    core_y = base_y - 4 + squish_y // 2
    core_x = base_x - 1
    rect(img, core_x - 2, core_y - 2, core_x + 2, core_y + 2, CORE_DARK)
    rect(img, core_x - 1, core_y - 1, core_x + 1, core_y + 1, SLIME_HIGH)
    p(img, core_x, core_y, CORE_GLOW)
    p(img, core_x - 1, core_y - 1, SLIME_SPEC)

    eye_x = base_x - 3
    eye_y = base_y - 4
    p(img, eye_x - 2, eye_y, OUT_SLIME)
    p(img, eye_x - 2, eye_y + 1, OUT_SLIME)
    p(img, eye_x - 2, eye_y - 1, SLIME_SPEC)
    p(img, eye_x + 2, eye_y, OUT_SLIME)
    p(img, eye_x + 2, eye_y + 1, OUT_SLIME)
    p(img, eye_x + 2, eye_y - 1, SLIME_SPEC)

    p(img, base_x - 4, base_y - ry - 2, SLIME_SPEC)
    p(img, base_x - 3, base_y - ry - 3, SLIME_SPEC)
    p(img, base_x - 2, base_y - ry - 3, SLIME_HIGH)
    p(img, base_x - 1, base_y - ry - 2, SLIME_HIGH)

    if action == "attack" and step == 2:
        p(img, base_x - rx - 3, base_y - 2, SLIME_HIGH)
        p(img, base_x - rx - 5, base_y - 4, SLIME_SPEC)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)
    return img

# =========================================================================
# 2. GREMLIN DE FOLHA (32x32)
# =========================================================================
def draw_gremlin_frame(action="idle", step=0):
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    bob_y, club_rot, offset_x = (0, 0, 0)
    if action == "idle":
        bob_y = [0, 1, 0, -1][step % 4]
    elif action == "attack":
        if step == 0: bob_y, club_rot, offset_x = (1, -2, 2)
        elif step == 1: bob_y, club_rot, offset_x = (0, 0, 1)
        elif step == 2: bob_y, club_rot, offset_x = (-1, 4, -4)
        elif step == 3: bob_y, club_rot, offset_x = (0, 2, -2)
    elif action == "hit":
        bob_y, offset_x = (1, 3)
    elif action == "death":
        bob_y = step * 2
        offset_x = step

    bx = 16 + offset_x
    by = 28 + bob_y

    rect(img, bx - 3, by - 3, bx - 1, by, GREM_SKIN_DARK)
    p(img, bx - 2, by - 1, GREM_SKIN_MID)
    rect(img, bx + 2, by - 3, bx + 4, by, GREM_SKIN_DARK)
    p(img, bx + 3, by - 1, GREM_SKIN_MID)

    rect(img, bx - 4, by - 10, bx + 4, by - 4, OUT_GREEN)
    rect(img, bx - 3, by - 9, bx + 3, by - 5, LEAF_DARK)
    rect(img, bx - 2, by - 8, bx + 2, by - 6, LEAF_MID)
    p(img, bx - 1, by - 7, LEAF_LGT)

    rect(img, bx - 5, by - 13, bx + 5, by - 10, OUT_GREEN)
    rect(img, bx - 4, by - 12, bx + 4, by - 11, LEAF_MID)
    p(img, bx, by - 12, LEAF_HIGH)

    rect(img, bx - 4, by - 19, bx + 3, by - 13, OUT_GREEN)
    rect(img, bx - 3, by - 18, bx + 2, by - 14, GREM_SKIN_MID)
    rect(img, bx - 2, by - 17, bx + 1, by - 15, GREM_SKIN_LGT)
    p(img, bx - 1, by - 16, GREM_SKIN_HIGH)

    # Big goblin ears
    p(img, bx - 5, by - 16, GREM_SKIN_DARK)
    p(img, bx - 6, by - 17, GREM_SKIN_MID)
    p(img, bx - 7, by - 18, GREM_SKIN_LGT)
    p(img, bx - 8, by - 19, GREM_SKIN_HIGH)
    p(img, bx + 4, by - 16, GREM_SKIN_DARK)
    p(img, bx + 5, by - 17, GREM_SKIN_MID)
    p(img, bx + 6, by - 18, GREM_SKIN_LGT)

    # Eyes
    p(img, bx - 3, by - 16, EYE_YELLOW)
    p(img, bx - 2, by - 16, EYE_PUPIL)
    p(img, bx, by - 16, EYE_YELLOW)
    p(img, bx + 1, by - 16, EYE_PUPIL)

    cx = bx - 6 - club_rot
    cy = by - 14 - (club_rot // 2)
    rect(img, cx - 1, cy - 1, cx + 1, cy + 5, WOOD_DARK)
    p(img, cx, cy, WOOD_MID)
    rect(img, cx - 3, cy - 6, cx + 2, cy - 2, OUT_BROWN)
    rect(img, cx - 2, cy - 5, cx + 1, cy - 3, WOOD_MID)
    p(img, cx - 4, cy - 4, THORN_WHITE)
    p(img, cx - 1, cy - 7, THORN_WHITE)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)
    return img

# =========================================================================
# 3. JAVALI DE MUSGO (48x48) — Curved Natural Anatomy
# =========================================================================
def draw_javali_frame(action="idle", step=0):
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    bob_y, offset_x = (0, 0)
    if action == "idle":
        bob_y = [0, 1, 0, -1][step % 4]
    elif action == "attack":
        if step == 0: bob_y, offset_x = (1, 3)
        elif step == 1: bob_y, offset_x = (0, 2)
        elif step == 2: bob_y, offset_x = (-1, -7)
        elif step == 3: bob_y, offset_x = (0, -3)
    elif action == "hit":
        bob_y, offset_x = (1, 4)
    elif action == "death":
        bob_y = step * 2
        offset_x = step * 2

    bx = 26 + offset_x
    by = 42 + bob_y

    # Hind leg (angled back with joint)
    rect(img, bx + 9, by - 7, bx + 13, by - 4, BOAR_HIDE_DARK)
    rect(img, bx + 8, by - 4, bx + 11, by, OUT_BROWN)
    p(img, bx + 9, by, OUT_DARK)
    p(img, bx + 10, by, OUT_DARK)

    # Front leg (stout shoulder and hoof)
    rect(img, bx - 6, by - 7, bx - 2, by - 4, BOAR_HIDE_MID)
    rect(img, bx - 5, by - 4, bx - 2, by, OUT_BROWN)
    p(img, bx - 4, by, OUT_DARK)
    p(img, bx - 3, by, OUT_DARK)

    # Arched, sloping organic torso (tapered haunches to massive shoulders)
    for dy in range(-16, -4):
        # Progress from belly to spine
        t = (dy + 16) / 12.0
        w_left = int(8 + 3 * t)
        w_right = int(14 - 2 * (1.0 - t))
        y = by + dy
        rect(img, bx - w_left - 1, y, bx + w_right + 1, y, OUT_BROWN)
        rect(img, bx - w_left, y, bx + w_right, y, BOAR_HIDE_DARK)
        rect(img, bx - w_left + 1, y, bx + w_right - 1, y, BOAR_HIDE_MID)
        rect(img, bx - w_left + 2, y, bx + 4, y, BOAR_HIDE_LGT)

    # Lush curved carpet of moss along the arched back
    for mx in range(-9, 13):
        curve_h = int(3 * (1.0 - ((mx - 2) / 12.0) ** 2))
        top_y = by - 16 - max(0, curve_h)
        for my in range(top_y, top_y + 4):
            col = MOSS_HIGH if my == top_y else (MOSS_LGT if my == top_y + 1 else MOSS_MID)
            p(img, bx + mx, my, col)
        p(img, bx + mx, top_y - 1, OUT_GREEN)
    # Lúmen flower sprouts on moss
    p(img, bx - 3, by - 21, LUMEN_CORE_L)
    p(img, bx + 2, by - 20, LUMEN_CORE_L)

    # Head and Snout (Snorting boar facing left)
    hx = bx - 11
    hy = by - 12
    rect(img, hx - 6, hy - 6, hx + 2, hy + 2, OUT_BROWN)
    rect(img, hx - 5, hy - 5, hx + 1, hy + 1, BOAR_HIDE_MID)
    p(img, hx - 4, hy - 4, BOAR_HIDE_LGT)
    # Snout
    rect(img, hx - 8, hy - 3, hx - 6, hy, OUT_DARK)
    p(img, hx - 7, hy - 2, BOAR_HIDE_DARK)
    # Glowing red eye
    p(img, hx - 3, hy - 5, EYE_RED)
    p(img, hx - 2, hy - 5, EYE_RED_GLOW)
    # Big curved ivory tusks
    p(img, hx - 7, hy + 1, OUT_BROWN)
    p(img, hx - 8, hy, TUSK_DARK)
    p(img, hx - 9, hy - 1, TUSK_MID)
    p(img, hx - 9, hy - 2, TUSK_LGT)
    p(img, hx - 8, hy - 3, TUSK_LGT)
    p(img, hx - 7, hy - 4, OUT_DARK)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)
    return img

# =========================================================================
# 4. ESPÍRITO DE RAIZ (48x48) — Gnarled Treant with Wisp Core
# =========================================================================
def draw_espirito_frame(action="idle", step=0):
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    bob_y, arm_ext, offset_x = (0, 0, 0)
    if action == "idle":
        bob_y = [0, 1, 0, -1][step % 4]
    elif action == "attack":
        if step == 0: bob_y, arm_ext, offset_x = (1, -2, 2)
        elif step == 1: bob_y, arm_ext, offset_x = (0, 2, 0)
        elif step == 2: bob_y, arm_ext, offset_x = (-1, 7, -5)
        elif step == 3: bob_y, arm_ext, offset_x = (0, 3, -2)
    elif action == "hit":
        bob_y, offset_x = (1, 4)
    elif action == "death":
        bob_y = step * 2
        offset_x = step

    bx = 24 + offset_x
    by = 42 + bob_y

    # Twisting root legs
    for rx, ry in [(-5, -5), (-3, -3), (-6, 0), (3, -5), (5, -3), (6, 0), (0, -4), (1, 0)]:
        p(img, bx + rx, by + ry, BARK_DARK)
        p(img, bx + rx, by + ry - 1, BARK_MID)

    # Hollow gnarled bark torso
    rect(img, bx - 7, by - 24, bx + 7, by - 7, OUT_BROWN)
    rect(img, bx - 6, by - 23, bx + 6, by - 8, BARK_DARK)
    rect(img, bx - 5, by - 22, bx + 5, by - 9, BARK_MID)
    p(img, bx - 4, by - 20, BARK_LGT)

    # Radiant cyan Lúmen wisp heart in hollow cavity
    cx, cy = bx - 1, by - 16
    rect(img, cx - 3, cy - 3, cx + 3, cy + 3, LUMEN_CORE_D)
    rect(img, cx - 2, cy - 2, cx + 2, cy + 2, LUMEN_CORE_M)
    rect(img, cx - 1, cy - 1, cx + 1, cy + 1, LUMEN_CORE_L)
    p(img, cx, cy, LUMEN_CORE_H)

    # Ancient carved mask face
    rect(img, bx - 6, by - 32, bx + 4, by - 25, OUT_BROWN)
    rect(img, bx - 5, by - 31, bx + 3, by - 26, BARK_MID)
    p(img, bx - 4, by - 30, BARK_LGT)
    # Luminous slit eyes
    p(img, bx - 4, by - 28, LUMEN_CORE_L)
    p(img, bx - 3, by - 28, LUMEN_CORE_H)
    p(img, bx, by - 28, LUMEN_CORE_L)
    p(img, bx + 1, by - 28, LUMEN_CORE_H)
    # Sprouting leaves on head
    p(img, bx - 3, by - 34, ROOT_MOSS_L)
    p(img, bx - 2, by - 35, LEAF_HIGH)
    p(img, bx + 2, by - 34, LEAF_HIGH)

    # Giant root fist
    fx = bx - 6 - arm_ext
    fy = by - 14
    for x in range(fx, bx - 5):
        p(img, x, fy, BARK_MID)
        p(img, x, fy + 1, BARK_DARK)
    rect(img, fx - 4, fy - 3, fx, fy + 3, OUT_BROWN)
    rect(img, fx - 3, fy - 2, fx - 1, fy + 2, BARK_MID)
    p(img, fx - 4, fy, LUMEN_CORE_L)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)
    return img

# =========================================================================
# 5. LOBO ALFA DE LÚMEN (48x48) — Sleek Lupine Anatomy
# =========================================================================
def draw_lobo_frame(action="idle", step=0):
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    bob_y, offset_x, jaw_open = (0, 0, 0)
    if action == "idle":
        bob_y = [0, 1, 0, -1][step % 4]
    elif action == "attack":
        if step == 0: bob_y, offset_x, jaw_open = (1, 2, 0)
        elif step == 1: bob_y, offset_x, jaw_open = (-2, 0, 1)
        elif step == 2: bob_y, offset_x, jaw_open = (0, -7, 2)
        elif step == 3: bob_y, offset_x, jaw_open = (1, -3, 1)
    elif action == "hit":
        bob_y, offset_x = (1, 4)
    elif action == "death":
        bob_y = step * 2
        offset_x = step * 2

    bx = 27 + offset_x
    by = 41 + bob_y

    # Slender hind legs with curved hocks
    rect(img, bx + 8, by - 9, bx + 12, by - 5, WOLF_MID)
    rect(img, bx + 9, by - 5, bx + 11, by, OUT_WOLF)
    p(img, bx + 10, by, WOLF_DARK)

    # Muscular front legs
    rect(img, bx - 8, by - 9, bx - 4, by - 5, WOLF_LGT)
    rect(img, bx - 7, by - 5, bx - 5, by, OUT_WOLF)
    p(img, bx - 6, by, WOLF_DARK)

    # Sleek curved wolf torso (arched spine, tucked abdomen)
    for dy in range(-16, -5):
        t = (dy + 16) / 11.0
        w_left = int(9 + 2 * t)
        w_right = int(13 - 3 * (1.0 - t))
        y = by + dy
        rect(img, bx - w_left - 1, y, bx + w_right + 1, y, OUT_WOLF)
        rect(img, bx - w_left, y, bx + w_right, y, WOLF_DARK)
        rect(img, bx - w_left + 1, y, bx + w_right - 1, y, WOLF_MID)
        rect(img, bx - w_left + 2, y, bx + 2, y, WOLF_LGT)

    # Fluffy curving tail with glowing tip
    for tx, ty in [(13, -11), (15, -13), (17, -16), (18, -19), (17, -22)]:
        p(img, bx + tx, by + ty, OUT_WOLF)
        p(img, bx + tx - 1, by + ty, WOLF_MID)
    p(img, bx + 17, by - 22, ASTRAL_CYAN_L)
    p(img, bx + 18, by - 19, ASTRAL_CYAN_H)

    # Glowing astral stripes on flank
    p(img, bx + 4, by - 15, ASTRAL_CYAN_H)
    p(img, bx + 5, by - 14, ASTRAL_CYAN_L)
    p(img, bx - 1, by - 15, ASTRAL_CYAN_H)
    p(img, bx, by - 14, ASTRAL_CYAN_L)

    # Fur mane and neck
    rect(img, bx - 11, by - 22, bx - 3, by - 15, OUT_WOLF)
    rect(img, bx - 10, by - 21, bx - 4, by - 16, WOLF_MID)
    p(img, bx - 8, by - 20, ASTRAL_CYAN_L)

    # Head and predatory snout
    hx, hy = bx - 12, by - 19
    rect(img, hx - 5, hy - 5, hx + 1, hy + 1, OUT_WOLF)
    rect(img, hx - 4, hy - 4, hx, hy, WOLF_MID)
    # Snout & Fangs
    rect(img, hx - 8, hy - 2, hx - 5, hy + 1, OUT_WOLF)
    p(img, hx - 8, hy - 1, OUT_DARK) # nose
    p(img, hx - 7, hy + 1 + jaw_open, FANG_WHITE) # fang
    # Pointed ears
    p(img, hx + 1, hy - 7, WOLF_LGT)
    p(img, hx + 2, hy - 8, WOLF_HIGH)
    # Luminous cyan eye
    p(img, hx - 2, hy - 3, ASTRAL_CYAN_H)
    p(img, hx - 1, hy - 3, ASTRAL_CYAN_L)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)
    return img

# =========================================================================
# 6. GUARDIÃO-CERVO DE PEDRA (Boss, 64x64) — Majestic Monolithic Stag
# =========================================================================
def draw_cervo_frame(action="idle", step=0):
    img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    bob_y, offset_x, antler_tilt = (0, 0, 0)
    if action == "idle":
        bob_y = [0, 1, 0, -1][step % 4]
    elif action == "attack":
        if step == 0: bob_y, offset_x, antler_tilt = (1, 3, -2)
        elif step == 1: bob_y, offset_x, antler_tilt = (0, 1, -4)
        elif step == 2: bob_y, offset_x, antler_tilt = (-2, -8, 3)
        elif step == 3: bob_y, offset_x, antler_tilt = (0, -3, 1)
    elif action == "hit":
        bob_y, offset_x = (1, 5)
    elif action == "death":
        bob_y = step * 3
        offset_x = step * 2

    bx = 36 + offset_x
    by = 58 + bob_y

    # Monolithic stone hooves and legs
    rect(img, bx + 10, by - 12, bx + 15, by - 6, STONE_MID)
    rect(img, bx + 11, by - 6, bx + 14, by, OUT_STONE)
    p(img, bx + 12, by, STONE_DARK)
    rect(img, bx - 12, by - 12, bx - 7, by - 6, STONE_LGT)
    rect(img, bx - 11, by - 6, bx - 8, by, OUT_STONE)
    p(img, bx - 10, by, STONE_DARK)

    # Curved granite body
    for dy in range(-26, -11):
        t = (dy + 26) / 15.0
        w_l = int(14 + 2 * t)
        w_r = int(18 - 3 * (1.0 - t))
        y = by + dy
        rect(img, bx - w_l - 1, y, bx + w_r + 1, y, OUT_STONE)
        rect(img, bx - w_l, y, bx + w_r, y, STONE_DARK)
        rect(img, bx - w_l + 1, y, bx + w_r - 1, y, STONE_MID)
        rect(img, bx - w_l + 2, y, bx + 6, y, STONE_LGT)

    # Moss mantle on back
    rect(img, bx - 10, by - 30, bx + 14, by - 26, OUT_GREEN)
    rect(img, bx - 9, by - 29, bx + 13, by - 27, BOSS_MOSS_D)
    rect(img, bx - 8, by - 28, bx + 10, by - 27, BOSS_MOSS_L)
    p(img, bx - 6, by - 29, MOSS_HIGH)
    p(img, bx + 2, by - 29, MOSS_HIGH)

    # Golden runic inlays
    p(img, bx - 4, by - 21, RUNE_GOLD_H)
    p(img, bx - 4, by - 20, RUNE_GOLD_L)
    p(img, bx - 3, by - 19, RUNE_GOLD_M)
    p(img, bx + 3, by - 21, RUNE_GOLD_H)
    p(img, bx + 4, by - 20, RUNE_GOLD_L)

    # Noble neck and carved stag head
    nx, ny = bx - 16, by - 34
    rect(img, nx - 8, ny - 8, nx + 4, ny + 8, OUT_STONE)
    rect(img, nx - 7, ny - 7, nx + 3, ny + 7, STONE_MID)
    rect(img, nx - 6, ny - 6, nx + 1, ny + 4, STONE_LGT)
    # Muzzle
    rect(img, nx - 12, ny - 3, nx - 8, ny + 2, OUT_STONE)
    rect(img, nx - 11, ny - 2, nx - 8, ny + 1, STONE_MID)
    # Spectral radiant eye
    p(img, nx - 6, ny - 4, LANTERN_GLOW)
    p(img, nx - 5, ny - 4, hex_to_rgba("#ffffff"))

    # Towering petrified antlers
    ax = nx - 2
    ay = ny - 8 + antler_tilt
    for dx, dy in [(0,-3), (-2,-6), (-4,-9), (-5,-13), (-4,-17), (-2,-20),
                   (2,-5), (5,-8), (8,-12), (9,-16), (8,-19), (6,-21)]:
        p(img, ax + dx, ay + dy, OUT_BROWN)
        p(img, ax + dx + 1, ay + dy, ANTLER_WOOD_M)
        p(img, ax + dx, ay + dy + 1, ANTLER_WOOD_L)
    p(img, ax - 7, ay - 11, ANTLER_WOOD_L)
    p(img, ax + 11, ay - 14, ANTLER_WOOD_L)

    # Glowing Lúmen lanterns hanging from antler tips
    rect(img, ax - 10, ay - 7, ax - 7, ay - 4, OUT_CYAN)
    rect(img, ax - 9, ay - 6, ax - 8, ay - 5, LANTERN_GLOW)
    rect(img, ax + 9, ay - 9, ax + 12, ay - 6, OUT_CYAN)
    rect(img, ax + 10, ay - 8, ax + 11, ay - 7, LANTERN_GLOW)

    if action == "hit":
        img = apply_hit_flash(img)
    elif action == "death" and step > 0:
        img = apply_death_dither(img, step)
    return img

# =========================================================================
# BUILD ALL
# =========================================================================
def build_and_save_sheet(draw_func, frame_size, out_path):
    sheet = Image.new("RGBA", (frame_size * 16, frame_size), (0, 0, 0, 0))
    for i in range(4):
        sheet.paste(draw_func("idle", i), (i * frame_size, 0))
    for i in range(4):
        sheet.paste(draw_func("attack", i), ((4 + i) * frame_size, 0))
    for i in range(2):
        sheet.paste(draw_func("hit", i), ((8 + i) * frame_size, 0))
    for i in range(6):
        sheet.paste(draw_func("death", i), ((10 + i) * frame_size, 0))

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    sheet.save(out_path, "PNG")
    print(f"Generated {out_path} ({sheet.size[0]}x{sheet.size[1]})")

if __name__ == "__main__":
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    
    # 1. Geleia de Lúmen
    slime_path = os.path.join(base_dir, "assets", "sprites", "enemies", "geleia_de_lumen", "enemy_geleia_lumen_sheet.png")
    build_and_save_sheet(draw_geleia_frame, 32, slime_path)
    comfy_slime_path = os.path.join(base_dir, "assets", "sprites", "enemies", "geleia_de_lumen", "comfy_lumen_slime_idle_sheet.png")
    comfy_sheet = Image.new("RGBA", (128, 32), (0, 0, 0, 0))
    for i in range(4):
        comfy_sheet.paste(draw_geleia_frame("idle", i), (i * 32, 0))
    comfy_sheet.save(comfy_slime_path, "PNG")

    # 2. Gremlin de Folha
    gremlin_path = os.path.join(base_dir, "assets", "sprites", "enemies", "gremlin_de_folha", "mob_gremlin_folha_sheet.png")
    build_and_save_sheet(draw_gremlin_frame, 32, gremlin_path)

    # 3. Javali de Musgo
    javali_path = os.path.join(base_dir, "assets", "sprites", "enemies", "javali_de_musgo", "mob_javali_musgo_sheet.png")
    build_and_save_sheet(draw_javali_frame, 48, javali_path)

    # 4. Espírito de Raiz
    espirito_path = os.path.join(base_dir, "assets", "sprites", "enemies", "espirito_de_raiz", "mob_espirito_raiz_sheet.png")
    build_and_save_sheet(draw_espirito_frame, 48, espirito_path)

    # 5. Lobo Alfa de Lúmen
    lobo_path = os.path.join(base_dir, "assets", "sprites", "enemies", "lobo_alfa_de_lumen", "mob_lobo_alfa_sheet.png")
    build_and_save_sheet(draw_lobo_frame, 48, lobo_path)

    # 6. Guardião-Cervo de Pedra (Boss)
    cervo_path = os.path.join(base_dir, "assets", "sprites", "bosses", "guardiao_cervo", "boss_guardiao_cervo_sheet.png")
    build_and_save_sheet(draw_cervo_frame, 64, cervo_path)

    print("All 6 Bosque de Lúmen enemy sheets generated successfully!")
