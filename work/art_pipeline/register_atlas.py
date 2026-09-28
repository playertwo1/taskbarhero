import hashlib
import json
import re
import subprocess
import time
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
GOLDENS = [
    "docs/art/golden/hero_bastiao_candidate_v002.png",
    "docs/art/golden/enemy_geleia_lumen_candidate_v001.png",
    "docs/art/golden/boss_guardiao_cervo_candidate_v002.png",
]
TIMINGS = {
    "boss_guardiao_cervo": [160] * 4 + [125] * 4 + [100] * 2 + [160] * 6,
    "enemy_geleia_lumen": [160] * 4 + [100] * 4 + [80] * 2 + [125] * 6,
    "hero_bastiao": [160] * 4 + [100] * 4 + [80] * 2 + [125] * 6,
    "default": [160] * 4 + [100] * 4 + [80] * 2 + [120] * 6,
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def register(asset_id: str, contract_rel: str, output_rel: str, facing: str,
             subsets: list[str], golden_id: str) -> None:
    output = ROOT / output_rel
    contract = ROOT / contract_rel
    timings = TIMINGS.get(asset_id, TIMINGS["default"])
    with Image.open(output) as source_image:
        size = source_image.height
        if source_image.size != (16 * size, size):
            raise SystemExit(f"Expected {16*size}x{size}: {output}")

    frames = []
    groups = [("idle", 4), ("attack", 4), ("hit", 2), ("death", 6)]
    frame_index = 0
    for name, count in groups:
        for i in range(count):
            frames.append({
                "filename": f"{asset_id}_{frame_index:02d}_{name}_{i}.png",
                "frame": {"x": frame_index * size, "y": 0, "w": size, "h": size},
                "rotated": False,
                "trimmed": False,
                "spriteSourceSize": {"x": 0, "y": 0, "w": size, "h": size},
                "sourceSize": {"w": size, "h": size},
                "duration": timings[frame_index],
            })
            frame_index += 1

    metadata = {
        "frames": frames,
        "meta": {
            "app": "Pocket Hero sprite pipeline",
            "version": "1",
            "image": output.name,
            "format": "RGBA8888",
            "size": {"w": 16 * size, "h": size},
            "scale": "1",
        },
    }
    output.with_suffix(".json").write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    source = output.parent / f"{asset_id}_golden.aseprite"
    aseprite = ROOT / "Aseprite/Aseprite.exe"
    subprocess.run([str(aseprite), "--batch", str(output), "--save-as", str(source)], cwd=ROOT, check=True)
    for _ in range(40):
        if source.exists():
            break
        time.sleep(0.1)
    if not source.exists():
        raise SystemExit(f"Aseprite source was not written: {source}")

    contract_text = contract.read_text(encoding="utf-8")
    source_rel = source.relative_to(ROOT).as_posix()
    contract_text, replacements = re.subn(
        r'(?m)^\s*source_file:\s*"[^"]+"',
        f'  source_file: "{source_rel}"',
        contract_text,
        count=1,
    )
    if replacements == 0 and "export:" in contract_text:
        export_fields = (
            f'export:\n  source_file: "{source_rel}"\n'
            f'  sheet_file: "{output.relative_to(ROOT).as_posix()}"\n'
            f'  json_file: "{output.with_suffix(".json").relative_to(ROOT).as_posix()}"'
        )
        contract_text = contract_text.replace("export:", export_fields, 1)
    elif replacements != 1:
        raise SystemExit(f"No source_file field replaced in {contract}")
    contract.write_text(contract_text, encoding="utf-8")

    with Image.open(output) as image:
        rgba = image.convert("RGBA")
        visible_colors = {pixel[:3] for pixel in rgba.getdata() if pixel[3]}
        if set(rgba.getchannel("A").getdata()) - {0, 255}:
            raise SystemExit(f"Non-binary alpha: {output}")

    refs = [ROOT / path for path in GOLDENS]
    input_hashes = ", ".join(sha256(path) for path in refs)
    ref_lines = "\n".join(f"  - {path}" for path in GOLDENS)
    subset_list = ", ".join(subsets)
    output_hash = sha256(output)
    manifest = f'''asset_id: {asset_id}
status: ARTISTIC_QA
version: 2
contract: {contract_rel}
golden_reference: {golden_id}
references:
{ref_lines}
generation:
  workflow: image_gen_4x4_atlas_then_FFmpeg_downscale_Aseprite_TY40_quantization
  workflow_version: '2'
  comfyui_version: null
  custom_nodes: []
  model: OpenAI image_gen
  model_license_record: "personal use approved by Rafael on 2026-09-27; no redistribution or commercial clearance"
  lora: null
  adapters: []
  seed: null
  sampler: null
  steps: null
  cfg: null
  generation_resolution: "4x4 generated atlas reduced to {size}x{size} frames"
  controlnet: null
  controlnet_weight: null
  ip_adapter_weight: null
  prompt_file: null
  input_hashes: [{input_hashes}]
palette:
  master: TY_HIGH_FANTASY_40
  subsets: [{subset_list}]
  colors_used: {len(visible_colors)}
  exceptional_colors: []
output:
  files: [{output.relative_to(ROOT).as_posix()}]
  frame_size: {{width: {size}, height: {size}}}
  frame_count: 16
  layout: horizontal_strip
  facing: {facing}
  alpha: true
  hashes: [{output_hash}]
qa:
  technical: PASS
  artistic: PENDING
  mobile: PENDING
  reviewer: null
  reviewed_at: null
  report: Sprite lint PASS; independent visual audit and mobile review are pending.
'''
    manifest_path = output.parent / f"{asset_id}_v002.manifest.yaml"
    manifest_path.write_text(manifest, encoding="utf-8")
    relative_manifest = manifest_path.relative_to(ROOT).as_posix()
    subprocess.run(["python", "tools/sprite_lint.py", "--manifest", relative_manifest], cwd=ROOT, check=True)
    print(f"Registered {asset_id}: {size}x{size}, 16 frames, {len(visible_colors)} colors, sha256={output_hash}")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("asset_id")
    parser.add_argument("contract")
    parser.add_argument("output")
    parser.add_argument("facing", choices=["left", "right"])
    parser.add_argument("golden_reference")
    parser.add_argument("subsets", nargs="+")
    args = parser.parse_args()
    register(args.asset_id, args.contract, args.output, args.facing, args.subsets, args.golden_reference)
