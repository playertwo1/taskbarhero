#!/usr/bin/env python3
"""Gera o CANDIDATO do ui_kit (UI_S* compartilhado) em pixel art, sem geração por IA.

Contrato: docs/art/contracts/screens/ui_kit.yaml. Paleta: TY_HIGH_FANTASY_40, subconjuntos
neutral_stone, wood e lumen (docs/art/PALETTE.md). Luz vinda de cima à esquerda.
Saída: docs/art/candidates/ui_kit/ (fora de assets/: é candidato, sem aprovação nem integração).
Uso: python tools/art/build_ui_kit.py
"""
from __future__ import annotations

from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "docs" / "art" / "candidates" / "ui_kit"

BLACK = "#000000"
SUBSETS = {
    "neutral_stone": set("#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5".split()),
    "lumen": set("#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5".split()),
    "wood": set("#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5".split()),
}
ALLOWED = set().union(*SUBSETS.values())
MAX_COLORS = 16


def rgba(hex_color: str) -> tuple[int, int, int, int]:
    h = hex_color.lstrip("#")
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), 255


def frame(size: int, outline: str, ring: str, hi: str, sh: str, fill: str, inner: str | None) -> Image.Image:
    """Moldura 9-slice size×size: contorno, anel, bisel (hi em cima/esquerda, sh embaixo/direita), miolo."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    last = size - 1
    for y in range(size):
        for x in range(size):
            d = min(x, y, last - x, last - y)
            if d == 0:
                color = outline
                if (x, y) in {(0, 0), (last, 0), (0, last), (last, last)}:
                    continue  # canto arredondado: pixel transparente
            elif d == 1:
                color = ring
            elif d == 2:
                # bisel: claro em cima/esquerda, escuro embaixo/direita
                top_left = (y == 2 and x <= last - 2) or (x == 2 and y <= last - 2)
                color = hi if top_left else sh
            elif d == 4 and inner:
                color = inner
            else:
                color = fill
            px[x, y] = rgba(color)
    return img


# Desabilitado: sem bisel e mais escuro que qualquer botão ativo; igual nos dois tipos.
DISABLED = dict(outline=BLACK, ring="#353235", hi="#353235", sh="#353235", fill="#182029", inner=None)

BUTTONS = {
    "button_primary": {
        "normal": dict(outline=BLACK, ring="#314646", hi="#bdd2de", sh="#182029", fill="#425a58", inner="#314646"),
        "pressed": dict(outline=BLACK, ring="#314646", hi="#182029", sh="#bdd2de", fill="#314646", inner=None),
        "disabled": DISABLED,
    },
    "button_secondary": {
        "normal": dict(outline=BLACK, ring="#4a484a", hi="#e6dac5", sh="#2f3140", fill="#353235", inner="#4a484a"),
        "pressed": dict(outline=BLACK, ring="#4a484a", hi="#2f3140", sh="#e6dac5", fill="#2f3140", inner=None),
        "disabled": DISABLED,
    },
}
PANEL = dict(outline=BLACK, ring="#4a484a", hi="#627c80", sh="#000000", fill="#182029", inner="#2f3140")


def divider() -> Image.Image:
    img = Image.new("RGBA", (432, 8), (0, 0, 0, 0))
    px = img.load()
    for x in range(432):
        if 200 <= x < 232:
            continue
        px[x, 3] = rgba("#627c80")  # linha clara
        px[x, 4] = rgba("#2f3140")  # sombra
    # losango central 8×8
    diamond = [
        "...oo...",
        "..owwo..",
        ".owwwgo.",
        "owwwwggo",
        ".owwggo.",
        "..owgo..",
        "...oo...",
        "........",
    ]
    colors = {"o": "#000000", "w": "#e6dac5", "g": "#a49983"}
    for y, row in enumerate(diamond):
        for x, ch in enumerate(row):
            if ch in colors:
                px[212 + x, y] = rgba(colors[ch])
    return img


ICON_COLORS = {"o": "#182029", "a": "#bdd2de", "b": "#81b5a2", "c": "#425a58", "d": "#314646", "w": "#e6dac5", "g": "#a49983"}
ICONS = {
    # Fragmento: losango claro e brilhante (predomina a/b).
    "icon_fragment": [
        "................",
        ".......oo.......",
        "......oaao......",
        ".....oaabbo.....",
        "....oaabbbbo....",
        "...oaabbbbbbo...",
        "..oaabbbbbbbco..",
        "..oabbbbbbbccdo.",
        "..oabbbbbbccdo..",
        "...obbbbbccdo...",
        "....obbbccdo....",
        ".....obccdo.....",
        "......ocdo......",
        ".......oo.......",
        "................",
        "................",
    ],
    # Resíduo: gota escura e opaca (predomina c/d), com um único brilho.
    "icon_residue": [
        "................",
        "................",
        ".......oo.......",
        "......occo......",
        ".....occcco.....",
        ".....occcbo.....",
        "....occbbcco....",
        "....occbcccdo...",
        "...occcccccddo..",
        "...occcccccddo..",
        "...occcccddddo..",
        "....ocddddddo...",
        ".....oodddoo....",
        ".......oo.......",
        "................",
        "................",
    ],
    # XP: estrela de quatro pontas em tom de osso.
    "icon_xp": [
        "................",
        ".......oo.......",
        "......owwo......",
        "......owwo......",
        ".....owwwwo.....",
        "..oooowwwwoooo..",
        ".owwwwwwwwwwwwo.",
        ".owwwwwwwwwwggo.",
        "..oooowwwggoooo.",
        ".....owwggo.....",
        "......owgo......",
        "......owgo......",
        ".......oo.......",
        "................",
        "................",
        "................",
    ],
}


def icon(name: str) -> Image.Image:
    rows = ICONS[name]
    assert len(rows) == 16, name
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    px = img.load()
    for y, row in enumerate(rows):
        assert len(row) == 16, (name, y, len(row))
        for x, ch in enumerate(row):
            if ch in ICON_COLORS:
                px[x, y] = rgba(ICON_COLORS[ch])
    return img


def nine_slice(tile: Image.Image, width: int, height: int, margin: int = 6) -> Image.Image:
    """Estica um tile 9-slice para width×height (vizinho mais próximo)."""
    w, h = tile.size
    out = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    xs = [(0, margin, 0, margin), (margin, w - margin, margin, width - margin), (w - margin, w, width - margin, width)]
    ys = [(0, margin, 0, margin), (margin, h - margin, margin, height - margin), (h - margin, h, height - margin, height)]
    for sx0, sx1, dx0, dx1 in xs:
        for sy0, sy1, dy0, dy1 in ys:
            part = tile.crop((sx0, sy0, sx1, sy1)).resize((dx1 - dx0, dy1 - dy0), Image.NEAREST)
            out.paste(part, (dx0, dy0))
    return out


def pixels(img: Image.Image):
    px = img.load()
    return [px[x, y] for y in range(img.size[1]) for x in range(img.size[0])]


def lint(name: str, img: Image.Image) -> list[str]:
    errors = []
    colors = set()
    for r, g, b, a in pixels(img):
        if a not in (0, 255):
            errors.append("alpha não binário")
            break
        if a == 255:
            colors.add("#%02x%02x%02x" % (r, g, b))
    outside = colors - ALLOWED
    if outside:
        errors.append("cores fora dos subconjuntos: %s" % sorted(outside))
    if len(colors) > MAX_COLORS:
        errors.append("%d cores (máximo %d)" % (len(colors), MAX_COLORS))
    return errors


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    pieces: dict[str, Image.Image] = {}
    for kind, states in BUTTONS.items():
        for state, spec in states.items():
            pieces[f"{kind}_{state}"] = frame(48, **spec)
    pieces["panel_frame"] = frame(48, **PANEL)
    pieces["divider"] = divider()
    for name in ICONS:
        pieces[name] = icon(name)

    failed = False
    for name, img in pieces.items():
        img.save(OUT / f"{name}.png")
        errs = lint(name, img)
        colors = len({p for p in pixels(img) if p[3] == 255})
        print(f"{'FAIL' if errs else 'ok  '} {name}: {img.size[0]}x{img.size[1]}, {colors} cores {errs or ''}")
        failed = failed or bool(errs)

    # Prévia: peças 9-slice esticadas, divisor e ícones, ampliadas 3× sobre fundo escuro.
    scale = 3
    sheet = Image.new("RGBA", (440, 700), rgba("#10141a"))
    y = 10
    for kind in BUTTONS:
        for state in ("normal", "pressed", "disabled"):
            sheet.alpha_composite(nine_slice(pieces[f"{kind}_{state}"], 400, 50), (20, y))
            y += 58
    sheet.alpha_composite(nine_slice(pieces["panel_frame"], 400, 150), (20, y))
    y += 160
    sheet.alpha_composite(pieces["divider"], (4, y))
    y += 16
    preview = sheet.crop((0, 0, 440, y)).resize((440 * scale // 2, y * scale // 2), Image.NEAREST)
    strip = Image.new("RGBA", (preview.size[0], 16 * 8 + 24), rgba("#10141a"))
    x = 20
    for name in ICONS:
        strip.alpha_composite(pieces[name].resize((128, 128), Image.NEAREST), (x, 12))
        x += 152
    full = Image.new("RGBA", (preview.size[0], preview.size[1] + strip.size[1]), rgba("#10141a"))
    full.alpha_composite(preview, (0, 0))
    full.alpha_composite(strip, (0, preview.size[1]))
    preview = full
    preview.save(OUT / "preview_ui_kit.png")
    print("prévia:", OUT / "preview_ui_kit.png")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
