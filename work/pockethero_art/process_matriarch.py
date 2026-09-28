from __future__ import annotations

import hashlib
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "work/matriarca_master_fullres_v001.png"
OUT_DIR = ROOT / "assets/sprites/bosses/matriarca_micelio"
ASSET_ID = "boss_matriarca_micelio"
CONTRACT_PATH = ROOT / "docs/art/contracts/boss_matriarca_micelio.yaml"
PALETTE = "#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5 #1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    source_saved = OUT_DIR / "matriarca_micelio_source_v001.png"
    source_saved.write_bytes(SOURCE.read_bytes())

    palette = [tuple(int(color[i:i + 2], 16) for i in (1, 3, 5)) for color in PALETTE.split()]
    image = Image.open(SOURCE).convert("RGBA")
    alpha = image.getchannel("A").point(lambda value: 255 if value >= 24 else 0)
    bbox = alpha.getbbox()
    if bbox is None:
        raise ValueError("Matriarch master is fully transparent")
    image = image.crop(bbox)
    image.putalpha(alpha.crop(bbox))
    image.thumbnail((60, 60), Image.Resampling.NEAREST)
    rgb = Image.new("RGB", image.size, (0, 0, 0))
    rgb.paste(image.convert("RGB"), mask=image.getchannel("A"))
    reduced = rgb.quantize(colors=14, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    output = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    ox, oy = (64 - image.width) // 2, (64 - image.height) // 2
    for y in range(image.height):
        for x in range(image.width):
            if image.getchannel("A").getpixel((x, y)) == 0:
                continue
            color = reduced.getpixel((x, y))
            nearest = min(palette, key=lambda p: sum((p[i] - color[i]) ** 2 for i in range(3)))
            output.putpixel((ox + x, oy + y), (*nearest, 255))

    # Keep the one core readable at the boss's actual 64×64 size.
    core = [
        [None, None, None, "#314646", None, None, None],
        [None, None, "#314646", "#425a58", "#314646", None, None],
        [None, "#314646", "#425a58", "#81b5a2", "#425a58", "#314646", None],
        ["#314646", "#425a58", "#81b5a2", "#bdd2de", "#81b5a2", "#425a58", "#314646"],
        [None, "#314646", "#425a58", "#81b5a2", "#425a58", "#314646", None],
        [None, None, "#314646", "#425a58", "#314646", None, None],
        [None, None, None, "#314646", None, None, None],
    ]
    core_x, core_y = 20, 29
    for cy, row in enumerate(core):
        for cx, value in enumerate(row):
            if value is not None:
                color = tuple(int(value[i:i + 2], 16) for i in (1, 3, 5))
                output.putpixel((core_x + cx, core_y + cy), (*color, 255))
    final = OUT_DIR / f"{ASSET_ID}_v001.png"
    output.save(final, format="PNG", optimize=True)
    used = sorted({"#%02x%02x%02x" % p[:3] for p in output.get_flattened_data() if p[3] == 255})

    contract = {
        "contract_version": "1.0.0",
        "asset_id": ASSET_ID,
        "name": "Matriarca do Micélio",
        "category": "boss_visual_candidate",
        "content_state": "visual hypothesis; no gameplay, loot or behavior approval",
        "canvas": {"width": 64, "height": 64, "baseline_y": 60, "pivot": [32, 60]},
        "style": {"genre": "dark_fantasy", "technique": "pixel_art", "facing": "left", "palette": {"master": "TY_HIGH_FANTASY_40", "subsets": ["forest", "wood", "lumen"], "max_colors": 14}},
        "pose": "single neutral key pose; no animation frames implied",
        "export": {"format": "png", "color_depth": "rgba_32", "transparent_background": True, "frame_count": 1},
        "acceptance_criteria": {"technical": ["canvas_size_exact: 64x64", "transparent_background: true", "binary_alpha: true", "max_colors: 14"], "visual": ["three mushroom caps at different heights", "single visible center core", "root arch base", "side view enemy facing left"]},
    }
    CONTRACT_PATH.parent.mkdir(parents=True, exist_ok=True)
    CONTRACT_PATH.write_text(json.dumps(contract, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    manifest = {
        "asset_id": ASSET_ID,
        "status": "TECHNICAL_QA",
        "version": 1,
        "contract": CONTRACT_PATH.relative_to(ROOT).as_posix(),
        "golden_reference": "GOLDEN_BOSS_GUARDIAO_CERVO_V1 (style reference only)",
        "generation": {"workflow": "image_gen_reference_to_single_pose_alpha_crop_nearest_scale_ty40_quantize", "workflow_version": "1", "model": "OpenAI image_gen", "model_license_record": "Uso pessoal aprovado por Rafael em 2026-09-27; não autoriza redistribuição ou uso comercial.", "seed": None, "sampler": None, "steps": None, "cfg": None, "generation_resolution": "1254x1254 source reduced to 64x64", "input_hashes": [sha(SOURCE)]},
        "palette": {"master": "TY_HIGH_FANTASY_40", "subsets": ["forest", "wood", "lumen"], "colors_used": len(used), "exceptional_colors": []},
        "output": {"files": [final.relative_to(ROOT).as_posix()], "frame_size": {"width": 64, "height": 64}, "frame_count": 1, "layout": "single", "facing": "left", "alpha": True, "hashes": [sha(final)]},
        "qa": {"technical": "PENDING", "artistic": "PENDING", "reviewer": None, "reviewed_at": None, "report": "Single neutral key pose candidate; no animation sheet or gameplay content implied."},
    }
    (OUT_DIR / f"{ASSET_ID}_v001.manifest.yaml").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Created {final.relative_to(ROOT).as_posix()} with {len(used)} colors; source preserved at {source_saved.relative_to(ROOT).as_posix()}.")


if __name__ == "__main__":
    main()
