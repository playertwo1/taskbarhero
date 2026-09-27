"""
Pocket Hero — Master Styled Heroes Spritesheet Builder
Directly derived from the Campfire Heroes master reference image
and conforming strictly to docs/art/SPRITE_STYLE_GUIDE.md.

Produces 768x48 PNG sheets (16 frames of 48x48) for:
1. Bastião (Paladin/Knight): Steel bascinet, visor slit, crimson crest, red heater shield, arming sword
2. Íris (Mage): Floppy purple witch hat, pointed elf ears, cute anime chibi face, purple robes, crystal staff
3. Flecha (Archer): Golden blonde hair, green ribbon/leaf, blue eyes, green tunic, recurve bow

16 Frames layout:
- 0..3: Idle (looping 4-frame breathing/bobbing)
- 4..7: Attack (windup, strike, extension with effect, recovery)
- 8..9: Hit (recoil + red flash)
- 10..15: Death (collapse + ethereal dither fade)
"""

import os
from PIL import Image

def hex_to_rgba(hex_str, alpha=255):
    h = hex_str.lstrip('#')
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), alpha)

def get_base_heroes(base_dir):
    b_path = os.path.join(base_dir, "assets", "sprites", "heroes", "bastiao", "master_base.png")
    i_path = os.path.join(base_dir, "assets", "sprites", "heroes", "iris", "master_base.png")
    f_path = os.path.join(base_dir, "assets", "sprites", "heroes", "flecha", "master_base.png")
    return Image.open(b_path), Image.open(i_path), Image.open(f_path)

def apply_hit_flash(img):
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    pix_in = img.load()
    pix_out = out.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix_in[x, y]
            if a > 0:
                pix_out[x, y] = (min(255, r + 110), max(0, g - 25), max(0, b - 25), a)
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
                    pix_out[x, y] = (min(255, r + 30), min(255, g + 40), min(255, b + 60), int(a * (1.0 - threshold * 0.7)))
    return out

# =========================================================================
# ANIMATION SHEET BUILDERS
# =========================================================================
def build_bastiao_sheet(base_sprite):
    sheet = Image.new("RGBA", (48 * 16, 48), (0, 0, 0, 0))
    sw, sh = base_sprite.size
    ground_y = 42

    def create_frame(dx=0, dy=0, sword_ext=0, slash=False, hit=False, death_step=-1):
        f = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
        px = 24 - sw // 2 + dx
        py = ground_y - sh + dy
        f.paste(base_sprite, (px, py), base_sprite)

        # Extended sword thrust
        if sword_ext > 0:
            pix = f.load()
            sword_y = py + 16
            blade_start = px + sw - 2
            for i in range(sword_ext):
                bx = blade_start + i
                if bx < 47:
                    pix[bx, sword_y] = (240, 245, 255, 255)
                    pix[bx, sword_y + 1] = (160, 180, 205, 255)

        # Slash trail on forward swing
        if slash:
            pix = f.load()
            tip_x = min(46, px + sw + sword_ext)
            tip_y = py + 16
            for d in range(1, 5):
                if tip_x - d >= 0 and tip_y - d >= 0:
                    pix[tip_x - d, tip_y - d] = (255, 255, 255, 220)
                if tip_x - d >= 0 and tip_y + d < 48:
                    pix[tip_x - d, tip_y + d] = (210, 230, 255, 200)

        if hit:
            f = apply_hit_flash(f)
        elif death_step >= 0:
            f = apply_death_dither(f, death_step)
        return f

    # Idle (0..3): Subtle breathing
    sheet.paste(create_frame(0, 0), (0 * 48, 0))
    sheet.paste(create_frame(0, 1), (1 * 48, 0))
    sheet.paste(create_frame(0, 0), (2 * 48, 0))
    sheet.paste(create_frame(0, -1), (3 * 48, 0))

    # Attack (4..7): Powerful sword thrust & lunge
    sheet.paste(create_frame(-1, 0, sword_ext=0), (4 * 48, 0))
    sheet.paste(create_frame(2, 0, sword_ext=3, slash=False), (5 * 48, 0))
    sheet.paste(create_frame(3, -1, sword_ext=5, slash=True), (6 * 48, 0))
    sheet.paste(create_frame(1, 0, sword_ext=1), (7 * 48, 0))

    # Hit (8..9): Flinch back
    sheet.paste(create_frame(-2, 1, hit=True), (8 * 48, 0))
    sheet.paste(create_frame(-1, 0, hit=True), (9 * 48, 0))

    # Death (10..15): Topple & dissolve
    for i in range(6):
        sheet.paste(create_frame(-i // 2, i, death_step=i), ((10 + i) * 48, 0))

    return sheet

def build_iris_sheet(base_sprite):
    sheet = Image.new("RGBA", (48 * 16, 48), (0, 0, 0, 0))
    sw, sh = base_sprite.size
    ground_y = 42

    def create_frame(dx=0, dy=0, cast_level=0, hit=False, death_step=-1):
        f = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
        px = 24 - sw // 2 + dx
        py = ground_y - sh + dy
        f.paste(base_sprite, (px, py), base_sprite)

        # Magic crystal flare on staff
        if cast_level > 0:
            pix = f.load()
            orb_x = min(44, px + sw - 2)
            orb_y = py + 7
            if cast_level == 1:
                for ox, oy in [(-1,0),(1,0),(0,-1),(0,1)]:
                    pix[orb_x + ox, orb_y + oy] = (120, 240, 255, 230)
                pix[orb_x, orb_y] = (255, 255, 255, 255)
            elif cast_level == 2:
                for ox in range(-2, 3):
                    for oy in range(-2, 3):
                        if abs(ox) + abs(oy) <= 2:
                            pix[orb_x + ox, orb_y + oy] = (70, 230, 245, 240)
                pix[orb_x, orb_y] = (255, 255, 255, 255)
                for i in range(3, 9):
                    if orb_x + i < 47:
                        pix[orb_x + i, orb_y] = (180, 250, 255, 255)
                        pix[orb_x + i, orb_y - 1] = (80, 210, 240, 200)
                        pix[orb_x + i, orb_y + 1] = (80, 210, 240, 200)

        if hit:
            f = apply_hit_flash(f)
        elif death_step >= 0:
            f = apply_death_dither(f, death_step)
        return f

    # Idle (0..3)
    sheet.paste(create_frame(0, 0), (0 * 48, 0))
    sheet.paste(create_frame(0, 1), (1 * 48, 0))
    sheet.paste(create_frame(0, 0), (2 * 48, 0))
    sheet.paste(create_frame(0, -1), (3 * 48, 0))

    # Attack (4..7)
    sheet.paste(create_frame(0, -1, cast_level=1), (4 * 48, 0))
    sheet.paste(create_frame(1, -2, cast_level=2), (5 * 48, 0))
    sheet.paste(create_frame(2, -1, cast_level=2), (6 * 48, 0))
    sheet.paste(create_frame(0, 0, cast_level=0), (7 * 48, 0))

    # Hit (8..9)
    sheet.paste(create_frame(-2, 1, hit=True), (8 * 48, 0))
    sheet.paste(create_frame(-1, 0, hit=True), (9 * 48, 0))

    # Death (10..15)
    for i in range(6):
        sheet.paste(create_frame(-i // 2, i, death_step=i), ((10 + i) * 48, 0))

    return sheet

def build_flecha_sheet(base_sprite):
    sheet = Image.new("RGBA", (48 * 16, 48), (0, 0, 0, 0))
    sw, sh = base_sprite.size
    ground_y = 42

    def create_frame(dx=0, dy=0, arrow_state=0, hit=False, death_step=-1):
        f = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
        px = 24 - sw // 2 + dx
        py = ground_y - sh + dy
        f.paste(base_sprite, (px, py), base_sprite)

        # Arrow rendering
        if arrow_state > 0:
            pix = f.load()
            arrow_y = py + 16
            bow_x = px + sw - 4
            if arrow_state == 1:
                for i in range(6):
                    pix[bow_x - i, arrow_y] = (200, 170, 110, 255)
                pix[bow_x + 1, arrow_y] = (240, 245, 255, 255)
            elif arrow_state == 2:
                for i in range(10):
                    bx = bow_x + 2 + i
                    if bx < 47:
                        pix[bx, arrow_y] = (240, 245, 255, 255)
                if bow_x + 6 < 47:
                    pix[bow_x + 6, arrow_y - 1] = (120, 230, 240, 180)
                    pix[bow_x + 6, arrow_y + 1] = (120, 230, 240, 180)

        if hit:
            f = apply_hit_flash(f)
        elif death_step >= 0:
            f = apply_death_dither(f, death_step)
        return f

    # Idle (0..3)
    sheet.paste(create_frame(0, 0), (0 * 48, 0))
    sheet.paste(create_frame(0, 1), (1 * 48, 0))
    sheet.paste(create_frame(0, 0), (2 * 48, 0))
    sheet.paste(create_frame(0, -1), (3 * 48, 0))

    # Attack (4..7)
    sheet.paste(create_frame(0, 0, arrow_state=1), (4 * 48, 0))
    sheet.paste(create_frame(1, -1, arrow_state=1), (5 * 48, 0))
    sheet.paste(create_frame(2, 0, arrow_state=2), (6 * 48, 0))
    sheet.paste(create_frame(0, 0, arrow_state=0), (7 * 48, 0))

    # Hit (8..9)
    sheet.paste(create_frame(-2, 1, hit=True), (8 * 48, 0))
    sheet.paste(create_frame(-1, 0, hit=True), (9 * 48, 0))

    # Death (10..15)
    for i in range(6):
        sheet.paste(create_frame(-i // 2, i, death_step=i), ((10 + i) * 48, 0))

    return sheet

if __name__ == "__main__":
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    bastiao_base, iris_base, flecha_base = get_base_heroes(base_dir)

    b_sheet = build_bastiao_sheet(bastiao_base)
    i_sheet = build_iris_sheet(iris_base)
    f_sheet = build_flecha_sheet(flecha_base)

    b_path = os.path.join(base_dir, "assets", "sprites", "heroes", "bastiao", "hero_bastiao_sheet.png")
    i_path = os.path.join(base_dir, "assets", "sprites", "heroes", "iris", "hero_iris_sheet.png")
    f_path = os.path.join(base_dir, "assets", "sprites", "heroes", "flecha", "hero_flecha_sheet.png")

    b_sheet.save(b_path, "PNG")
    i_sheet.save(i_path, "PNG")
    f_sheet.save(f_path, "PNG")

    print(f"Bastião sheet saved: {b_path} ({b_sheet.size})")
    print(f"Íris sheet saved: {i_path} ({i_sheet.size})")
    print(f"Flecha sheet saved: {f_path} ({f_sheet.size})")
    print("Master styled heroes generated successfully with zero background bleed!")
