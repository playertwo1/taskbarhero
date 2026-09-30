"""Verifica a documentação Markdown do repositório.

Uso:
    python tools/docs/check_links.py            # links quebrados + âncoras inválidas (sai com 1 se houver)
    python tools/docs/check_links.py --orphans  # também lista .md que nenhum outro .md aponta

Regras:
- Considera links Markdown `[texto](caminho)`; ignora URLs externas e blocos de código.
- Âncoras seguem o formato do GitHub (minúsculas, sem pontuação, espaços viram hífen; acentos preservados).
- Pastas locais/ferramentas de terceiros ficam de fora (ver SKIP).
"""
from __future__ import annotations

import argparse
import os
import re
import sys
import urllib.parse

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SKIP = {".git", ".godot", "work", "build", "Aseprite", "Pixelorama", "node_modules", "reports",
        "pixel-mcp", "comfyui", "ComfyUI-PixelGridHelpers", "spritefusion-pixel-snapper",
        "__pycache__", ".codex-remote-attachments"}
ORPHAN_OK = {"README.md", "AGENTS.md"}  # pontos de entrada
LINK = re.compile(r"\[[^\]]*\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")
HEADING = re.compile(r"^#{1,6}\s+(.*)$", re.M)
CODE = re.compile(r"```.*?```", re.S)


def slug(heading: str) -> str:
    heading = re.sub(r"[^\w\- ]", "", heading.strip().lower(), flags=re.U)
    return heading.replace(" ", "-")


def markdown_files() -> list[str]:
    found = []
    for directory, dirs, files in os.walk(ROOT):
        dirs[:] = [d for d in dirs if d not in SKIP]
        found += [os.path.join(directory, f) for f in files if f.endswith(".md")]
    return found


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--orphans", action="store_true", help="lista .md sem nenhum link de entrada")
    args = parser.parse_args()
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")

    files = markdown_files()
    anchors_cache: dict[str, set[str]] = {}
    linked: set[str] = set()
    problems: list[str] = []

    def anchors(path: str) -> set[str]:
        if path not in anchors_cache:
            text = CODE.sub("", open(path, encoding="utf-8", errors="ignore").read())
            anchors_cache[path] = {slug(h) for h in HEADING.findall(text)}
        return anchors_cache[path]

    for path in files:
        text = CODE.sub("", open(path, encoding="utf-8", errors="ignore").read())
        for target in LINK.findall(text):
            if re.match(r"^(https?|mailto):", target):
                continue
            raw, _, anchor = target.partition("#")
            resolved = path if not raw else os.path.normpath(
                os.path.join(os.path.dirname(path), urllib.parse.unquote(raw)))
            rel = os.path.relpath(path, ROOT)
            if not os.path.exists(resolved):
                problems.append(f"LINK   {rel} -> {target}")
                continue
            linked.add(os.path.normpath(resolved))
            if anchor and resolved.endswith(".md") and urllib.parse.unquote(anchor) not in anchors(resolved):
                problems.append(f"ANCORA {rel} -> {target}")

    for line in problems:
        print(line)
    print(f"{len(files)} arquivos .md; {len(problems)} problema(s).")

    if args.orphans:
        orphans = [os.path.relpath(p, ROOT) for p in files
                   if os.path.normpath(p) not in linked and os.path.basename(p) not in ORPHAN_OK
                   and os.path.dirname(os.path.relpath(p, ROOT))]
        for orphan in sorted(orphans):
            print(f"ORFAO  {orphan}")
        print(f"{len(orphans)} órfão(s).")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
