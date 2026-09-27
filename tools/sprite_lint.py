#!/usr/bin/env python3
"""Technical lint for a Pocket Hero per-asset YAML manifest.

Requires Pillow and PyYAML. Visual quality, licensing decisions, and Golden
approval remain independent human QA responsibilities.
"""

from __future__ import annotations

import argparse
import ast
import hashlib
import json
import re
import sys
import tempfile
import uuid
from pathlib import Path
from typing import Any

try:
    from PIL import Image
except ImportError as exc:  # pragma: no cover - environment-dependent message
    print(f"DEPENDENCY: install Pillow to run sprite_lint.py ({exc})", file=sys.stderr)
    raise SystemExit(2)


ROOT = Path(__file__).resolve().parents[1]
PALETTE_DOC = ROOT / "docs" / "art" / "PALETTE.md"
PALETTE_SUBSETS: dict[str, set[str]] = {
    "neutral_stone": set("#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5".split()),
    "iron": set("#000000 #182029 #2f3140 #353235 #4a484a #627c80 #bdd2de #e6dac5".split()),
    "lumen": set("#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5".split()),
    "forest": set("#1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #81b5a2".split()),
    "wood": set("#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5".split()),
    "gold": set("#3b1c16 #8a5c0a #af8e2c #caaa6c #e6dac5".split()),
    "crimson": set("#2a1810 #402736 #562f36 #5a4256 #7a393d #8f5c66 #bf5437".split()),
}
TY40 = set("""
    #e6dac5 #a49983 #7b7d6a #6a6548 #4a484a #353235 #425a58 #314646 #2f3140 #182029
    #bdd2de #81b5a2 #627c80 #607a53 #545f28 #484c2a #223925 #000000 #8f5c66 #5a4256
    #7a393d #562f36 #402736 #bf5437 #842d17 #5a231d #caaa6c #b5835a #855139 #60342c
    #af8e2c #8a5c0a #af5722 #703a1a #3b1c16 #2a1810 #80592e #554323 #353021 #1c200f
""".split())


class Lint:
    def __init__(self) -> None:
        self.errors: list[str] = []
        self.warnings: list[str] = []

    def error(self, code: str, message: str) -> None:
        self.errors.append(f"{code}: {message}")


def _yaml(path: Path, lint: Lint, label: str) -> dict[str, Any] | None:
    try:
        source = path.read_text(encoding="utf-8")
        try:
            loaded = json.loads(source)  # JSON is also valid YAML, and needs no extra parser.
        except json.JSONDecodeError:
            loaded = _parse_project_yaml(source)
    except (OSError, ValueError, SyntaxError) as exc:
        lint.error("SPR-008", f"{label} não pôde ser lido ({path}): {exc}")
        return None
    if not isinstance(loaded, dict):
        lint.error("SPR-008", f"{label} deve ser um objeto YAML.")
        return None
    return loaded


def _split_flow_items(value: str) -> list[str]:
    items: list[str] = []
    start = 0
    quote: str | None = None
    depth = 0
    for index, char in enumerate(value):
        if quote:
            if char == quote and (index == 0 or value[index - 1] != "\\"):
                quote = None
        elif char in "'\"":
            quote = char
        elif char in "[{":
            depth += 1
        elif char in "]}":
            depth -= 1
        elif char == "," and depth == 0:
            items.append(value[start:index].strip())
            start = index + 1
    tail = value[start:].strip()
    if tail:
        items.append(tail)
    return items


def _scalar(value: str) -> Any:
    value = value.strip()
    if not value:
        return None
    if value.startswith("[") and value.endswith("]"):
        return [_scalar(item) for item in _split_flow_items(value[1:-1])]
    if value.startswith("{") and value.endswith("}"):
        result: dict[str, Any] = {}
        for item in _split_flow_items(value[1:-1]):
            key, separator, child = item.partition(":")
            if not separator:
                raise ValueError(f"invalid inline mapping: {value}")
            result[str(_scalar(key))] = _scalar(child)
        return result
    if value[0:1] in ("'", '"'):
        if value.startswith('"'):
            return json.loads(value)
        return ast.literal_eval(value)
    lowered = value.lower()
    if lowered in ("true", "false"):
        return lowered == "true"
    if lowered in ("null", "~"):
        return None
    if re.fullmatch(r"[-+]?(?:0|[1-9][0-9]*)", value):
        return int(value)
    if re.fullmatch(r"[-+]?(?:[0-9]+\.[0-9]*|\.[0-9]+)(?:[eE][-+]?[0-9]+)?", value):
        return float(value)
    return value


def _strip_yaml_comment(value: str) -> str:
    quote: str | None = None
    for index, char in enumerate(value):
        if quote:
            if char == quote and (index == 0 or value[index - 1] != "\\"):
                quote = None
        elif char in "'\"":
            quote = char
        elif char == "#" and (index == 0 or value[index - 1].isspace()):
            return value[:index].rstrip()
    return value.rstrip()


def _parse_project_yaml(source: str) -> Any:
    """Parse the project's indentation-based YAML subset without third-party deps."""
    lines: list[tuple[int, str, int]] = []
    for number, raw in enumerate(source.splitlines(), 1):
        if "\t" in raw[: len(raw) - len(raw.lstrip())]:
            raise ValueError(f"tabs are not supported for YAML indentation (line {number})")
        clean = _strip_yaml_comment(raw)
        if not clean.strip() or clean.strip() in ("---", "..."):
            continue
        indent = len(clean) - len(clean.lstrip(" "))
        lines.append((indent, clean.strip(), number))
    if not lines:
        return None

    def split_mapping(text: str, line_no: int) -> tuple[str, str] | None:
        quote: str | None = None
        depth = 0
        for position, char in enumerate(text):
            if quote:
                if char == quote and (position == 0 or text[position - 1] != "\\"):
                    quote = None
            elif char in "'\"":
                quote = char
            elif char in "[{":
                depth += 1
            elif char in "]}":
                depth -= 1
            elif char == ":" and depth == 0 and (position + 1 == len(text) or text[position + 1].isspace()):
                return text[:position].strip(), text[position + 1:].strip()
        return None

    def block(index: int, indent: int) -> tuple[Any, int]:
        is_list = lines[index][1] == "-" or lines[index][1].startswith("- ")
        result: Any = [] if is_list else {}
        while index < len(lines) and lines[index][0] == indent:
            _, text, line_no = lines[index]
            if is_list:
                if not (text == "-" or text.startswith("- ")):
                    break
                item = text[1:].strip()
                index += 1
                mapping = split_mapping(item, line_no) if item else None
                if mapping:
                    key, raw_value = mapping
                    child: dict[str, Any] = {str(_scalar(key)): _scalar(raw_value) if raw_value else None}
                    if index < len(lines) and lines[index][0] > indent:
                        nested, index = block(index, lines[index][0])
                        if not isinstance(nested, dict):
                            raise ValueError(f"expected mapping continuation on line {line_no}")
                        child.update(nested)
                    result.append(child)
                elif item:
                    result.append(_scalar(item))
                elif index < len(lines) and lines[index][0] > indent:
                    nested, index = block(index, lines[index][0])
                    result.append(nested)
                else:
                    result.append(None)
            else:
                mapping = split_mapping(text, line_no)
                if not mapping:
                    raise ValueError(f"expected key: value on line {line_no}")
                key, raw_value = mapping
                index += 1
                if raw_value:
                    result[str(_scalar(key))] = _scalar(raw_value)
                elif index < len(lines) and lines[index][0] > indent:
                    nested, index = block(index, lines[index][0])
                    result[str(_scalar(key))] = nested
                else:
                    result[str(_scalar(key))] = None
        return result, index

    if lines[0][0] != 0:
        raise ValueError("top-level YAML content must start at column zero")
    parsed, end = block(0, 0)
    if end != len(lines):
        raise ValueError(f"unsupported YAML structure near line {lines[end][2]}")
    return parsed


def _palette_doc_matches() -> bool:
    try:
        text = PALETTE_DOC.read_text(encoding="utf-8")
    except OSError:
        return False
    section = text.split("## Paleta-mestre — exatamente 40 cores", 1)
    if len(section) != 2:
        return False
    section = section[1].split("## Subconjuntos do projeto", 1)[0]
    documented = {value.lower() for value in re.findall(r"`(#[0-9a-fA-F]{6})`", section)}
    return documented == TY40 and len(documented) == 40


def lint_manifest(manifest_path: Path) -> Lint:
    lint = Lint()
    manifest_path = manifest_path.resolve()
    data = _yaml(manifest_path, lint, "Manifesto")
    if data is None:
        return lint

    required = ("asset_id", "status", "version", "contract", "generation", "palette", "output", "qa")
    missing = [key for key in required if key not in data]
    if missing:
        lint.error("SPR-008", f"campos obrigatórios ausentes no manifesto: {', '.join(missing)}")
        return lint

    asset_id = data.get("asset_id")
    if not isinstance(asset_id, str) or not re.fullmatch(r"[a-z][a-z0-9_]+", asset_id):
        lint.error("SPR-006", "asset_id deve usar snake_case minúsculo.")
        return lint

    if not _palette_doc_matches():
        lint.error("SPR-008", "a TY40 embutida no linter diverge da lista de 40 cores em docs/art/PALETTE.md.")

    contract_value = data.get("contract")
    if not isinstance(contract_value, str):
        lint.error("SPR-008", "contract deve ser um caminho relativo ao repositório.")
        contract = None
    else:
        contract_path = (ROOT / contract_value).resolve()
        try:
            contract_path.relative_to(ROOT)
        except ValueError:
            lint.error("SPR-008", "contract precisa apontar para dentro do repositório.")
            contract = None
        else:
            contract = _yaml(contract_path, lint, "Contrato")

    palette = data.get("palette")
    output = data.get("output")
    if not isinstance(palette, dict) or not isinstance(output, dict):
        lint.error("SPR-008", "palette e output precisam ser objetos YAML.")
        return lint
    generation = data.get("generation")
    qa = data.get("qa")
    if not isinstance(generation, dict) or not isinstance(qa, dict):
        lint.error("SPR-008", "generation e qa precisam ser objetos YAML.")
        return lint
    for section, fields in ((generation, ("workflow", "workflow_version", "model", "model_license_record", "seed", "sampler", "steps", "cfg", "generation_resolution", "input_hashes")),
                             (qa, ("technical", "artistic", "reviewer", "reviewed_at"))):
        absent = [field for field in fields if field not in section]
        if absent:
            lint.error("SPR-008", f"campos ausentes no manifesto: {', '.join(absent)}.")
    if data.get("status") not in ("DRAFT", "CONCEPT_APPROVED", "REFERENCE_LOCKED", "PIXELIZED", "CLEANUP", "TECHNICAL_QA", "ARTISTIC_QA", "APPROVED", "INTEGRATED", "REJECTED"):
        lint.error("SPR-008", "status não pertence à máquina oficial de estados.")
    if qa.get("technical") not in ("PENDING", "PASS", "FAIL") or qa.get("artistic") not in ("PENDING", "PASS", "FAIL"):
        lint.error("SPR-008", "qa.technical e qa.artistic devem ser PENDING, PASS ou FAIL.")
    subsets = palette.get("subsets")
    if palette.get("master") != "TY_HIGH_FANTASY_40" or not isinstance(subsets, list) or not subsets:
        lint.error("SPR-008", "palette.master deve ser TY_HIGH_FANTASY_40 e subsets não pode ser vazio.")
        return lint
    unknown = [name for name in subsets if name not in PALETTE_SUBSETS]
    if unknown:
        lint.error("SPR-008", f"subconjuntos desconhecidos: {', '.join(map(str, unknown))}.")
        return lint
    allowed = set().union(*(PALETTE_SUBSETS[name] for name in subsets))
    exceptions = palette.get("exceptional_colors", []) or []
    if not isinstance(exceptions, list) or any(not re.fullmatch(r"#[0-9a-fA-F]{6}", str(color)) for color in exceptions):
        lint.error("SPR-008", "exceptional_colors deve ser lista de cores HEX #RRGGBB aprovadas.")
        return lint
    allowed.update(color.lower() for color in exceptions)

    if contract:
        contract_asset = contract.get("asset_id")
        if contract_asset and contract_asset != asset_id:
            lint.error("SPR-008", f"asset_id {asset_id} diverge do contrato ({contract_asset}).")
        contract_palette = contract.get("palette") or (contract.get("style") or {}).get("palette")
        if contract_palette:
            contract_master = contract_palette.get("master")
            contract_subsets = contract_palette.get("subsets")
            max_colors = contract_palette.get("max_colors")
            if contract_master != palette.get("master") or set(contract_subsets or []) != set(subsets):
                lint.error("SPR-008", "subconjuntos/master do manifesto divergem do contrato.")
            if isinstance(max_colors, int) and isinstance(palette.get("colors_used"), int) and palette["colors_used"] > max_colors:
                lint.error("SPR-005", f"colors_used do manifesto excede max_colors do contrato ({max_colors}).")
    else:
        max_colors = None

    size = output.get("frame_size")
    files = output.get("files")
    layout = output.get("layout")
    frame_count = output.get("frame_count")
    if not isinstance(size, dict) or not isinstance(files, list) or not files:
        lint.error("SPR-008", "output.frame_size e output.files são obrigatórios.")
        return lint
    width, height = size.get("width"), size.get("height")
    if not isinstance(width, int) or not isinstance(height, int) or width < 1 or height < 1:
        lint.error("SPR-008", "frame_size.width/height devem ser inteiros positivos.")
        return lint
    if not isinstance(frame_count, int) or frame_count < 1:
        lint.error("SPR-008", "frame_count deve ser inteiro positivo.")
        return lint
    if contract:
        canvas = contract.get("canvas") or {}
        if canvas and (canvas.get("width") != width or canvas.get("height") != height):
            lint.error("SPR-002", "frame_size do manifesto diverge do canvas do contrato.")
        animations = contract.get("animations")
        if isinstance(animations, dict):
            expected_frames = [animation.get("frames") for animation in animations.values() if isinstance(animation, dict)]
            if expected_frames and all(isinstance(count, int) for count in expected_frames) and sum(expected_frames) != frame_count:
                lint.error("SPR-006", f"frame_count={frame_count}, mas o contrato totaliza {sum(expected_frames)} frames.")

    seen_colors: set[str] = set()
    png_count = 0
    actual_hashes: list[str] = []
    for relative in files:
        if not isinstance(relative, str):
            lint.error("SPR-001", "cada item em output.files deve ser um caminho relativo.")
            continue
        path = (ROOT / relative).resolve()
        try:
            path.relative_to(ROOT)
        except ValueError:
            lint.error("SPR-001", f"arquivo fora do repositório não permitido: {relative}.")
            continue
        if not path.is_file():
            lint.error("SPR-001", f"arquivo ausente: {relative}.")
            continue
        actual_hashes.append(hashlib.sha256(path.read_bytes()).hexdigest())
        if path.suffix.lower() != ".png":
            lint.error("SPR-001", f"formato de saída precisa ser PNG: {relative}.")
            continue
        if not path.name.lower().startswith(asset_id):
            lint.error("SPR-006", f"nome de arquivo deve começar com {asset_id}: {path.name}.")
        try:
            with Image.open(path) as image:
                image.load()
                png_count += 1
                if image.format != "PNG":
                    lint.error("SPR-001", f"conteúdo não é PNG: {relative}.")
                    continue
                if image.mode != "RGBA":
                    lint.error("SPR-003", f"modo {image.mode}; esperado RGBA: {relative}.")
                    continue
                expected = (width, height)
                if layout == "horizontal_strip":
                    expected = (width * frame_count, height)
                elif layout == "vertical_strip":
                    expected = (width, height * frame_count)
                if image.size != expected:
                    lint.error("SPR-002", f"dimensão {image.width}x{image.height}; esperado {expected[0]}x{expected[1]}: {relative}.")
                alpha = image.getchannel("A")
                alpha_values = set(alpha.tobytes())
                if output.get("alpha") is True and 255 not in alpha_values:
                    lint.error("SPR-003", f"imagem totalmente transparente: {relative}.")
                if 0 not in alpha_values:
                    lint.error("SPR-003", f"canal alpha não contém pixels transparentes: {relative}.")
                if not alpha_values.issubset({0, 255}):
                    lint.error("SPR-003", f"alpha semitransparente detectado: {relative}.")
                pixels = image.tobytes()
                for offset in range(0, len(pixels), 4):
                    if pixels[offset + 3]:
                        seen_colors.add("#{:02x}{:02x}{:02x}".format(*pixels[offset:offset + 3]))
        except OSError as exc:
            lint.error("SPR-001", f"PNG não pôde ser aberto ({relative}): {exc}")

    if png_count == 0:
        lint.error("SPR-001", "nenhum PNG de saída foi verificado.")
    outside = sorted(seen_colors - allowed)
    if outside:
        lint.error("SPR-004", f"cores fora dos subconjuntos autorizados: {', '.join(outside)}.")
    declared_colors = palette.get("colors_used")
    if isinstance(declared_colors, int) and declared_colors != len(seen_colors):
        lint.error("SPR-008", f"colors_used={declared_colors}, mas foram encontradas {len(seen_colors)} cores visíveis.")
    limit = max_colors
    if isinstance(limit, int) and len(seen_colors) > limit:
        lint.error("SPR-005", f"{len(seen_colors)} cores visíveis excedem max_colors={limit}.")
    elif isinstance(declared_colors, int) and len(seen_colors) > declared_colors:
        lint.error("SPR-005", f"{len(seen_colors)} cores visíveis excedem colors_used={declared_colors}.")

    if output.get("alpha") is not True:
        lint.error("SPR-003", "output.alpha deve ser true para PNGs RGBA de sprite.")
    declared_hashes = output.get("hashes")
    if not isinstance(declared_hashes, list) or len(declared_hashes) != len(actual_hashes):
        lint.error("SPR-008", "output.hashes deve conter um SHA-256 para cada arquivo PNG de saída.")
    elif [str(value).lower() for value in declared_hashes] != actual_hashes:
        lint.error("SPR-008", "um ou mais hashes SHA-256 divergem dos arquivos de saída.")
    return lint


def self_test() -> int:
    """Exercise a valid sprite and confirm an out-of-palette pixel is caught."""
    from PIL import Image

    with tempfile.TemporaryDirectory(prefix="pocket-hero-sprite-lint-") as temporary:
        temp = Path(temporary)
        sprite = temp / "hero_bastiao_selftest.png"
        image = Image.new("RGBA", (768, 48), (0, 0, 0, 0))
        image.putpixel((0, 0), (24, 32, 41, 255))  # TY40 #182029
        image.save(sprite)
        nonce = uuid.uuid4().hex
        target = ROOT / f"hero_bastiao_selftest_{nonce}.png"
        test_manifest = ROOT / f"hero_bastiao_selftest_{nonce}.manifest.yaml"
        try:
            target.write_bytes(sprite.read_bytes())
            digest = hashlib.sha256(target.read_bytes()).hexdigest()
            manifest_text = f"""asset_id: hero_bastiao
status: DRAFT
version: 1
contract: docs/art/contracts/hero_bastiao.yaml
generation:
  workflow: self-test
  workflow_version: '1'
  model: self-test
  model_license_record: docs/art/MODEL_LICENSES.md
  seed: null
  sampler: null
  steps: null
  cfg: null
  generation_resolution: null
  input_hashes: []
palette:
  master: TY_HIGH_FANTASY_40
  subsets: [iron, gold]
  colors_used: 1
output:
  files:
    - {target.name}
  frame_size:
    width: 48
    height: 48
  frame_count: 16
  layout: horizontal_strip
  facing: right
  alpha: true
  hashes: [{digest}]
qa:
  technical: PENDING
  artistic: PENDING
  reviewer: null
  reviewed_at: null
"""
            test_manifest.write_text(manifest_text, encoding="utf-8")
            clean_result = lint_manifest(test_manifest)
            if clean_result.errors:
                print("SELF-TEST FAIL: valid TY40 image rejected: " + "; ".join(clean_result.errors), file=sys.stderr)
                return 1
            image = Image.open(target).convert("RGBA")
            image.putpixel((1, 1), (255, 0, 255, 255))
            image.save(target)
            invalid_result = lint_manifest(test_manifest)
            if not any(error.startswith("SPR-004:") for error in invalid_result.errors):
                print("SELF-TEST FAIL: out-of-palette color was not detected.", file=sys.stderr)
                return 1
        finally:
            target.unlink(missing_ok=True)
            test_manifest.unlink(missing_ok=True)
    print("SELF-TEST PASS: valid TY40 PNG accepted; out-of-palette color rejected.")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Valida PNGs de sprites contra o manifesto individual e o contrato.")
    parser.add_argument("--manifest", type=Path, help="caminho do manifesto YAML individual do asset")
    parser.add_argument("--self-test", action="store_true", help="executa teste sintético do linter")
    args = parser.parse_args(argv)
    if args.self_test:
        return self_test()
    if not args.manifest:
        parser.error("informe --manifest ou --self-test")
    result = lint_manifest(args.manifest)
    if result.errors:
        for message in result.errors:
            print(f"FAIL {message}", file=sys.stderr)
        print(f"SPRITE LINT FAIL ({len(result.errors)} erro(s))")
        return 1
    print(f"SPRITE LINT PASS: {args.manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
