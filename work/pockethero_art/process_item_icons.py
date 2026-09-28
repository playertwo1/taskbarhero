from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[2]
SOURCE_MAP = ROOT / "work/item_source_map.json"
ICON_DIR = ROOT / "assets/sprites/items/icons"
MANIFEST_DIR = ROOT / "assets/sprites/items/manifests"
CONTRACT_DIR = ROOT / "docs/art/contracts/item_icons"
PREVIEW_DIR = ROOT / "docs/art/previews"

PALETTES = {
    "neutral_stone": "#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5",
    "iron": "#000000 #182029 #2f3140 #353235 #4a484a #627c80 #bdd2de #e6dac5",
    "lumen": "#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5",
    "forest": "#1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #81b5a2",
    "wood": "#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5",
    "gold": "#3b1c16 #8a5c0a #af8e2c #caaa6c #e6dac5",
    "crimson": "#2a1810 #402736 #562f36 #5a4256 #7a393d #8f5c66 #bf5437",
}

# key -> (final ID, concept fiche, category, status, palette subsets)
ASSETS = {
    "adaga_de_luz": ("adaga_de_luz", "adaga_luz", "weapon", "mvp", ["iron", "lumen"]),
    "espada_de_musgo": ("espada_de_musgo", "espada_musgo", "weapon", "mvp", ["iron", "forest"]),
    "lamina_silvestre": ("lamina_silvestre", "lamina_silvestre", "weapon", "mvp", ["iron", "forest", "wood"]),
    "machado_ancestral": ("machado_ancestral", "machado_ancestral", "weapon", "mvp", ["neutral_stone", "wood"]),
    "cajado_de_lumen": ("cajado_de_lumen", "cajado_lumen", "weapon", "mvp", ["wood", "lumen"]),
    "tunica_de_folhas": ("tunica_de_folhas", "tunica_folhas", "armor", "mvp", ["forest", "wood"]),
    "gibao_de_casca": ("gibao_de_casca", "gibao_casca", "armor", "mvp", ["wood", "forest"]),
    "couraca_de_javali": ("couraca_de_javali", "couraca_javali", "armor", "mvp", ["wood", "forest", "neutral_stone"]),
    "placa_rochosa": ("placa_rochosa", "placa_rochosa", "armor", "mvp", ["neutral_stone", "wood"]),
    "armadura_do_guardiao": ("armadura_do_guardiao", "armadura_guardiao", "armor", "mvp", ["neutral_stone", "wood", "lumen"]),
    "pedra_polida": ("pedra_polida", "pedra_polida", "amulet", "mvp", ["neutral_stone"]),
    "semente_vital": ("semente_vital", "semente_vital", "amulet", "mvp", ["forest", "wood", "lumen"]),
    "colar_de_espiritos": ("colar_de_espiritos", "colar_espiritos", "amulet", "mvp", ["wood", "lumen", "neutral_stone"]),
    "amuleto_do_cervo": ("amuleto_do_cervo", "amuleto_cervo", "amulet", "mvp", ["wood", "neutral_stone", "lumen"]),
    "coracao_da_floresta": ("coracao_da_floresta", "coracao_floresta", "amulet", "mvp", ["forest", "wood", "lumen"]),
    "arco_da_copa_silente": ("arco_copa_silente", "arco_copa_silente", "weapon", "visual_candidate", ["wood", "forest", "lumen"]),
    "broche_eco_claro": ("broche_eco_claro", "broche_eco_claro", "amulet", "visual_candidate", ["iron", "gold", "lumen"]),
    "capa_da_nevoa_verde": ("capa_nevoa_verde", "capa_nevoa_verde", "armor", "visual_candidate", ["forest", "wood", "lumen"]),
    "cetro_do_veio_ambar": ("cetro_veio_ambar", "cetro_veio_ambar", "weapon", "visual_candidate", ["gold", "iron", "wood"]),
    "couraca_de_casca_muscosa": ("couraca_casca_muscosa", "couraca_casca_muscosa", "armor", "visual_candidate", ["wood", "forest", "neutral_stone"]),
    "dente_de_basalto": ("dente_basalto", "dente_basalto", "amulet", "visual_candidate", ["neutral_stone", "wood"]),
    "jaqueta_do_rastro_longo": ("jaqueta_rastro_longo", "jaqueta_rastro_longo", "armor", "visual_candidate", ["wood", "forest"]),
    "lamina_da_trilha_partida": ("lamina_trilha_partida", "lamina_trilha_partida", "weapon", "visual_candidate", ["iron", "neutral_stone"]),
    "maca_da_raiz_clara": ("maca_raiz_clara", "maca_raiz_clara", "weapon", "visual_candidate", ["wood", "lumen", "iron"]),
    "manto_de_micelio_trancado": ("manto_micelio_trancado", "manto_micelio_trancado", "armor", "visual_candidate", ["forest", "wood", "lumen"]),
    "no_dos_marcos_antigos": ("no_marcos_antigos", "no_marcos_antigos", "amulet", "visual_candidate", ["wood", "neutral_stone", "gold"]),
    "peitoral_do_vigia_caido": ("peitoral_vigia_caido", "peitoral_vigia_caido", "armor", "visual_candidate", ["neutral_stone", "wood", "iron"]),
    "presa_da_matilha": ("presa_matilha", "presa_matilha", "amulet", "visual_candidate", ["wood", "iron", "lumen"]),
    "ramo_de_pedra_runa": ("ramo_pedra_runa", "ramo_pedra_runa", "weapon", "visual_candidate", ["wood", "neutral_stone", "lumen"]),
    "semente_do_veio_vivo": ("semente_veio_vivo", "semente_veio_vivo", "amulet", "visual_candidate", ["forest", "wood", "lumen"]),
}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def nearest_color(color: tuple[int, int, int], palette: list[tuple[int, int, int]]) -> tuple[int, int, int]:
    return min(palette, key=lambda p: (p[0] - color[0]) ** 2 + (p[1] - color[1]) ** 2 + (p[2] - color[2]) ** 2)


def to_hex(rgb: tuple[int, int, int]) -> str:
    return "#%02x%02x%02x" % rgb


def title_from_fiche(path: Path) -> str:
    match = re.search(r"^#\s+(.+)$", path.read_text(encoding="utf-8"), re.M)
    return match.group(1).strip() if match else path.stem.replace("_", " ").title()


def main() -> None:
    source_map = json.loads(SOURCE_MAP.read_text(encoding="utf-8-sig"))
    ICON_DIR.mkdir(parents=True, exist_ok=True)
    MANIFEST_DIR.mkdir(parents=True, exist_ok=True)
    CONTRACT_DIR.mkdir(parents=True, exist_ok=True)
    PREVIEW_DIR.mkdir(parents=True, exist_ok=True)

    source_hashes = {}
    for ref in (
        ROOT / "docs/art/golden/hero_bastiao_candidate_v002.png",
        ROOT / "docs/art/golden/enemy_geleia_lumen_candidate_v001.png",
        ROOT / "docs/art/golden/boss_guardiao_cervo_candidate_v002.png",
    ):
        source_hashes[ref.relative_to(ROOT).as_posix()] = sha(ref)

    generated = []
    contract_paths = {}
    for generated_id, values in ASSETS.items():
        asset_id, fiche_stem, slot, data_state, subsets = values
        source = Path(source_map[generated_id])
        fiche = ROOT / f"docs/art/conceitos/itens/{fiche_stem}.md"
        if not source.is_file() or not fiche.is_file():
            raise FileNotFoundError(f"Missing source or concept fiche for {generated_id}: {source}, {fiche}")
        title = title_from_fiche(fiche)

        allowed = []
        for subset in subsets:
            allowed.extend(PALETTES[subset].split())
        allowed_hex = sorted(set(allowed))
        allowed_rgb = [tuple(int(value[i:i + 2], 16) for i in (1, 3, 5)) for value in allowed_hex]

        image = Image.open(source).convert("RGBA")
        alpha = image.getchannel("A").point(lambda value: 255 if value >= 24 else 0)
        bbox = alpha.getbbox()
        if bbox is None:
            raise ValueError(f"No visible pixels in generated source: {source}")
        image = image.crop(bbox)
        image.putalpha(alpha.crop(bbox))
        image.thumbnail((28, 28), Image.Resampling.NEAREST)

        # Clamp generated colors to a maximum 14-color palette, then snap them to
        # the exact declared TY40 subsets without dithering.
        rgb = Image.new("RGB", image.size, (0, 0, 0))
        rgb.paste(image.convert("RGB"), mask=image.getchannel("A"))
        quantized = rgb.quantize(colors=14, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
        final = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
        x = (32 - image.width) // 2
        y = (32 - image.height) // 2
        alpha_values = image.getchannel("A")
        for py in range(image.height):
            for px in range(image.width):
                if alpha_values.getpixel((px, py)) == 0:
                    continue
                color = nearest_color(quantized.getpixel((px, py)), allowed_rgb)
                final.putpixel((x + px, y + py), (*color, 255))

        output = ICON_DIR / f"{asset_id}.png"
        final.save(output, format="PNG", optimize=True)
        colors_used = sorted({to_hex(pixel[:3]) for pixel in final.get_flattened_data() if pixel[3] == 255})
        palette_key = "_".join(sorted(subsets))
        contract_name = f"item_icon_{palette_key}"
        contract_path = CONTRACT_DIR / f"{contract_name}.yaml"
        contract_paths[contract_name] = (subsets, allowed_hex)

        manifest = {
            "asset_id": asset_id,
            "status": "TECHNICAL_QA",
            "version": 1,
            "contract": contract_path.relative_to(ROOT).as_posix(),
            "concept": fiche.relative_to(ROOT).as_posix(),
            "content_state": data_state,
            "generation": {
                "workflow": "image_gen_single_icon_alpha_crop_nearest_scale_ty40_quantize",
                "workflow_version": "1",
                "model": "OpenAI image_gen",
                "model_license_record": "Uso pessoal aprovado por Rafael em 2026-09-27; não autoriza redistribuição ou uso comercial.",
                "seed": None,
                "sampler": None,
                "steps": None,
                "cfg": None,
                "generation_resolution": f"{Image.open(source).size[0]}x{Image.open(source).size[1]} source, final 32x32",
                "input_hashes": [sha(source), *source_hashes.values()],
            },
            "palette": {
                "master": "TY_HIGH_FANTASY_40",
                "subsets": subsets,
                "colors_used": len(colors_used),
                "exceptional_colors": [],
            },
            "output": {
                "files": [output.relative_to(ROOT).as_posix()],
                "frame_size": {"width": 32, "height": 32},
                "frame_count": 1,
                "layout": "single",
                "facing": "inventory_icon",
                "alpha": True,
                "hashes": [sha(output)],
            },
            "qa": {
                "technical": "PENDING",
                "artistic": "PENDING",
                "reviewer": None,
                "reviewed_at": None,
            },
        }
        (MANIFEST_DIR / f"{asset_id}.manifest.yaml").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        generated.append({
            "id": asset_id,
            "name": title,
            "slot": slot,
            "status": data_state,
            "icon": f"res://assets/sprites/items/icons/{asset_id}.png",
            "concept": fiche.relative_to(ROOT).as_posix(),
            "manifest": (MANIFEST_DIR / f"{asset_id}.manifest.yaml").relative_to(ROOT).as_posix(),
        })

    for contract_name, (subsets, allowed_hex) in contract_paths.items():
        data = {
            "contract_version": "1.0.0",
            "category": "item_icon",
            "canvas": {"width": 32, "height": 32, "baseline_y": 32, "pivot": [16, 32]},
            "style": "dark_fantasy_pixel_art",
            "palette": {"master": "TY_HIGH_FANTASY_40", "subsets": sorted(subsets), "max_colors": 14},
            "export": {"format": "png", "color_depth": "rgba_32", "transparent_background": True, "icon_only": True},
            "acceptance_criteria": {"technical": ["canvas_size_exact: 32x32", "binary_alpha: true", "only_declared_TY40_subsets: true", "max_colors: 14"]},
        }
        (CONTRACT_DIR / f"{contract_name}.yaml").write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    live_items = json.loads((ROOT / "data/items/items.json").read_text(encoding="utf-8"))
    live_by_id = {item["id"]: item for item in live_items}
    for item in generated:
        if item["status"] == "mvp":
            item["gameplay"] = live_by_id[item["id"]]
            item["state_label"] = "MVP"
        else:
            item["state_label"] = "Candidato visual · sem dados de gameplay"
    (ROOT / "data/items/item_visual_catalog.json").write_text(json.dumps(generated, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    # A review-only contact sheet enlarges the actual 32×32 PNGs with nearest scaling.
    font_path = Path("C:/Windows/Fonts/arial.ttf")
    font = ImageFont.truetype(str(font_path), 12) if font_path.exists() else ImageFont.load_default()
    cols, cell_w, cell_h, scale = 5, 210, 174, 4
    rows = (len(generated) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * cell_w, rows * cell_h), (18, 23, 26))
    draw = ImageDraw.Draw(sheet)
    for index, item in enumerate(generated):
        icon = Image.open(ROOT / item["icon"].replace("res://", "")).convert("RGBA")
        icon = icon.resize((32 * scale, 32 * scale), Image.Resampling.NEAREST)
        col, row = index % cols, index // cols
        left, top = col * cell_w + (cell_w - 32 * scale) // 2, row * cell_h + 8
        tile = Image.new("RGBA", (32 * scale, 32 * scale), (31, 40, 41, 255))
        tile.alpha_composite(icon)
        sheet.paste(tile.convert("RGB"), (left, top))
        label = item["name"]
        if item["status"] != "mvp":
            label += " · candidato"
        lines, current = [], ""
        for word in label.split():
            proposed = (current + " " + word).strip()
            if current and draw.textlength(proposed, font=font) > cell_w - 10:
                lines.append(current)
                current = word
            else:
                current = proposed
        if current:
            lines.append(current)
        for line_index, line in enumerate(lines[:2]):
            bounds = draw.textbbox((0, 0), line, font=font)
            x = col * cell_w + max(4, (cell_w - (bounds[2] - bounds[0])) // 2)
            draw.text((x, top + 32 * scale + 6 + line_index * 15), line, fill=(221, 226, 216), font=font)
    sheet.save(PREVIEW_DIR / "item_icons_32x32_contact_sheet.png", optimize=True)

    print(f"Created {len(generated)} 32x32 icons; {len(contract_paths)} palette contracts.")
    print(f"Preview: docs/art/previews/item_icons_32x32_contact_sheet.png")


if __name__ == "__main__":
    main()
