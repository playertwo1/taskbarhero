#!/usr/bin/env python3
"""Build an original, procedural ui_kit candidate from the UI contract."""
from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageDraw
import random

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "docs" / "art" / "candidates" / "ui_kit_v003"
BLACK = "#000000"
PALETTE = {
    "black": BLACK,
    "deep": "#182029",
    "slate": "#2f3140",
    "charcoal": "#353235",
    "stone": "#4a484a",
    "stone_light": "#627c80",
    "bone": "#a49983",
    "bone_light": "#e6dac5",
    "lumen_dark": "#314646",
    "lumen_mid": "#425a58",
    "lumen": "#81b5a2",
    "wood_dark": "#3b1c16",
    "wood": "#60342c",
    "wood_light": "#855139",
}


def rgba(color: str) -> tuple[int, int, int, int]:
    value = color.lstrip("#")
    return tuple(int(value[index:index + 2], 16) for index in (0, 2, 4)) + (255,)


def in_corner(x: int, y: int, size: int, cut: int) -> bool:
    return ((x < cut and y < cut and x + y < cut + 1)
            or (x >= size - cut and y < cut and (size - 1 - x) + y < cut + 1)
            or (x < cut and y >= size - cut and x + (size - 1 - y) < cut + 1)
            or (x >= size - cut and y >= size - cut
                and (size - 1 - x) + (size - 1 - y) < cut + 1))


def tile_frame(material: str, state: str = "normal", panel: bool = False) -> Image.Image:
    """Build a new root-bound stone / ironwood tile, designed for an 8px 9-slice."""
    size = 48
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(image)
    pressed = state == "pressed"
    disabled = state == "disabled"
    if disabled:
        surface, edge, hi, shade = PALETTE["charcoal"], PALETTE["deep"], PALETTE["stone"], PALETTE["slate"]
        accent = PALETTE["slate"]
    elif panel:
        surface, edge, hi, shade = PALETTE["slate"], PALETTE["deep"], PALETTE["stone_light"], PALETTE["charcoal"]
        accent = PALETTE["stone_light"]
    elif material == "lumen":
        surface, edge, hi, shade = PALETTE["lumen_dark"], PALETTE["deep"], PALETTE["stone"], PALETTE["lumen_mid"]
        accent = PALETTE["lumen_mid"]
    else:
        surface, edge, hi, shade = PALETTE["wood_dark"], PALETTE["deep"], PALETTE["stone"], PALETTE["wood"]
        accent = PALETTE["wood_light"]

    # Deep inset face. Button states shift the lip and surface together.
    d.rectangle((2, 2, 45, 45), fill=rgba(edge))
    d.rectangle((4, 4, 43, 43), fill=rgba(hi))
    d.rectangle((6, 6, 41, 41), fill=rgba(surface))
    d.rectangle((7, 7, 40, 40), fill=rgba(shade if pressed else surface))
    d.line((8, 8, 39, 8), fill=rgba(accent if not disabled else PALETTE["stone"]))
    d.line((8, 9, 39, 9), fill=rgba(surface))
    d.line((8, 39, 39, 39), fill=rgba(edge))
    d.line((8, 40, 39, 40), fill=rgba(hi))

    if material == "wood" and not panel:
        # Ironwood boards, restrained grain and riveted end plates.
        for yy in (15, 23, 31):
            d.line((9, yy, 38, yy), fill=rgba(PALETTE["wood"] if not disabled else PALETTE["stone"]))
            d.line((10, yy + 1, 37, yy + 1), fill=rgba(PALETTE["wood_dark"] if not disabled else PALETTE["deep"]))
        d.rectangle((4, 10, 7, 37), fill=rgba(PALETTE["stone"]))
        d.rectangle((40, 10, 43, 37), fill=rgba(PALETTE["stone"]))
        for x in (5, 42):
            for y in (13, 34):
                d.point((x, y), fill=rgba(PALETTE["bone"] if not disabled else PALETTE["slate"]))
                d.point((x, y + 1), fill=rgba(PALETTE["deep"]))
    elif not disabled:
        # Corner blocks and small root tendrils, kept within the 8px slice margin.
        for x, y in ((4, 4), (39, 4), (4, 39), (39, 39)):
            d.rectangle((x, y, x + 4, y + 4), fill=rgba(PALETTE["stone"]))
        root = PALETTE["wood"] if not panel else PALETTE["stone_light"]
        root_shadow = PALETTE["wood_dark"] if not panel else PALETTE["stone"]
        d.line((4, 6, 5, 6, 6, 5, 7, 4, 9, 4), fill=rgba(root))
        d.line((4, 7, 5, 7, 6, 6, 7, 5), fill=rgba(root_shadow))
        d.line((43, 4, 42, 5, 41, 6, 39, 9), fill=rgba(root))
        d.line((43, 5, 42, 6, 41, 7), fill=rgba(root_shadow))
        d.line((4, 42, 5, 42, 6, 41, 7, 39), fill=rgba(root))
        d.line((4, 41, 5, 41, 6, 40), fill=rgba(root_shadow))
        d.line((43, 43, 42, 42, 41, 41, 39, 39), fill=rgba(root))
        d.line((43, 42, 42, 41, 41, 40), fill=rgba(root_shadow))
        # Chipped highlights are deliberately sparse and pixel-aligned.
        for x, y in ((13, 4), (21, 4), (34, 4), (4, 16), (43, 27), (16, 43), (31, 43)):
            d.point((x, y), fill=rgba(PALETTE["bone"] if x % 2 else PALETTE["stone_light"]))

    if panel:
        # Opaque quiet center; only the rim carries stone/root detail.
        d.rectangle((9, 9, 38, 38), fill=rgba(PALETTE["deep"]))
        for x, y in ((13, 12), (19, 12), (28, 35), (34, 35)):
            d.point((x, y), fill=rgba(PALETTE["slate"]))
    elif not disabled:
        # Small material flecks avoid the blank, flat slab look without hurting text.
        if material == "lumen":
            d.point((11, 12), fill=rgba(PALETTE["lumen_mid"]))
            d.point((36, 35), fill=rgba(PALETTE["lumen_dark"]))
        if pressed:
            d.rectangle((9, 10, 38, 11), fill=rgba(edge))
    return image


def divider() -> Image.Image:
    image = Image.new("RGBA", (432, 8), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    draw.line((0, 3, 195, 3), fill=rgba(PALETTE["stone"]))
    draw.line((0, 4, 195, 4), fill=rgba(PALETTE["deep"]))
    draw.line((236, 3, 431, 3), fill=rgba(PALETTE["stone"]))
    draw.line((236, 4, 431, 4), fill=rgba(PALETTE["deep"]))
    # Root-and-stone knot, an environmental motif rather than a reward badge.
    draw.line((207, 3, 211, 0, 216, 3, 223, 3), fill=rgba(PALETTE["wood"]))
    draw.line((207, 4, 211, 7, 216, 4, 223, 4), fill=rgba(PALETTE["wood_dark"]))
    draw.line((212, 2, 215, 2, 215, 5, 212, 5), fill=rgba(PALETTE["stone_light"]))
    draw.point((213, 3), fill=rgba(PALETTE["lumen_mid"]))
    return image


def icon_fragment(size: int) -> Image.Image:
    image = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    # Uneven basalt sliver with a dull lumen seam; intentionally not jewel-cut.
    outline = [(5, 1), (10, 2), (12, 5), (10, 7), (11, 10),
               (7, 14), (4, 12), (3, 9), (5, 7), (3, 4)]
    draw.polygon(outline, fill=rgba(PALETTE["deep"]))
    body = [(5, 3), (9, 3), (10, 5), (8, 7), (9, 10),
            (7, 12), (5, 11), (5, 9), (6, 7), (4, 5)]
    draw.polygon(body, fill=rgba(PALETTE["lumen_dark"]))
    draw.line((6, 5, 8, 6, 7, 8, 8, 10), fill=rgba(PALETTE["lumen_mid"]))
    draw.point((6, 6), fill=rgba(PALETTE["stone_light"]))
    return image.resize((size, size), Image.Resampling.NEAREST)


def icon_residue(size: int) -> Image.Image:
    image = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    outline = [(4, 4), (7, 3), (9, 4), (12, 4), (13, 7),
               (12, 10), (10, 11), (8, 13), (5, 12), (3, 10), (3, 7)]
    draw.polygon(outline, fill=rgba(PALETTE["deep"]))
    draw.polygon([(5, 5), (8, 4), (10, 5), (11, 5), (12, 7),
                  (10, 9), (9, 11), (6, 11), (4, 9), (4, 7)],
                 fill=rgba(PALETTE["charcoal"]))
    draw.line((6, 7, 8, 8), fill=rgba(PALETTE["stone"]))
    draw.point((9, 9), fill=rgba(PALETTE["lumen_dark"]))
    return image.resize((size, size), Image.Resampling.NEAREST)


def icon_xp(size: int) -> Image.Image:
    image = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    # Rooted four-point mark for experience; matte bone and stone, no shine.
    draw.line((7, 1, 8, 1, 8, 14, 7, 14), fill=rgba(PALETTE["bone"]))
    draw.line((2, 7, 13, 7, 13, 8, 2, 8), fill=rgba(PALETTE["bone"]))
    draw.line((7, 4, 5, 6, 3, 7), fill=rgba(PALETTE["bone_light"]))
    draw.line((8, 10, 10, 9, 12, 8), fill=rgba(PALETTE["stone_light"]))
    draw.point((7, 7), fill=rgba(PALETTE["deep"]))
    draw.point((8, 8), fill=rgba(PALETTE["deep"]))
    return image.resize((size, size), Image.Resampling.NEAREST)


def nine_slice(tile: Image.Image, width: int, height: int, margin: int = 8) -> Image.Image:
    out = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    size = tile.width
    sections_x = [(0, margin, 0, margin), (margin, size - margin, margin, width - margin),
                  (size - margin, size, width - margin, width)]
    sections_y = [(0, margin, 0, margin), (margin, size - margin, margin, height - margin),
                  (size - margin, size, height - margin, height)]
    for sx0, sx1, dx0, dx1 in sections_x:
        for sy0, sy1, dy0, dy1 in sections_y:
            part = tile.crop((sx0, sy0, sx1, sy1)).resize(
                (dx1 - dx0, dy1 - dy0), Image.Resampling.NEAREST)
            out.alpha_composite(part, (dx0, dy0))
    return out


def save_piece(name: str, image: Image.Image) -> None:
    image.save(OUT / f"ui_kit_{name}.png")


def make_preview(pieces: dict[str, Image.Image]) -> Image.Image:
    sheet = Image.new("RGBA", (600, 860), rgba(PALETTE["deep"]))
    y = 18
    for name in ("button_primary_normal", "button_primary_pressed", "button_primary_disabled",
                 "button_secondary_normal", "button_secondary_pressed", "button_secondary_disabled"):
        sheet.alpha_composite(nine_slice(pieces[name], 560, 52), (20, y))
        y += 62
    sheet.alpha_composite(nine_slice(pieces["panel_frame"], 560, 190), (20, y))
    y += 208
    divider_image = pieces["divider"].resize((560, 10), Image.Resampling.NEAREST)
    sheet.alpha_composite(divider_image, (20, y))
    y += 28
    x = 72
    for name in ("icon_fragment_16", "icon_residue_16", "icon_xp_16"):
        sheet.alpha_composite(pieces[name].resize((64, 64), Image.Resampling.NEAREST), (x, y))
        x += 170
    x = 52
    y += 82
    for name in ("icon_fragment_24", "icon_residue_24", "icon_xp_24"):
        sheet.alpha_composite(pieces[name].resize((72, 72), Image.Resampling.NEAREST), (x, y))
        x += 170
    return sheet


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    pieces: dict[str, Image.Image] = {}
    for material in ("lumen", "wood"):
        for state in ("normal", "pressed", "disabled"):
            key = "primary" if material == "lumen" else "secondary"
            pieces[f"button_{key}_{state}"] = tile_frame(material, state)
    pieces["panel_frame"] = tile_frame("stone", panel=True)
    pieces["divider"] = divider()
    for name, builder in (("fragment", icon_fragment), ("residue", icon_residue), ("xp", icon_xp)):
        for size in (16, 24):
            pieces[f"icon_{name}_{size}"] = builder(size)
    for name, image in pieces.items():
        save_piece(name, image)
    make_preview(pieces).save(OUT / "preview_ui_kit_v003.png")
    print(f"Generated {len(pieces)} original UI pieces in {OUT}")


if __name__ == "__main__":
    main()
