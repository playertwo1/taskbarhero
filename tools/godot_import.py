"""Reimporta o projeto Godot em headless para registrar class_name novos.

Uso: python tools/godot_import.py [--godot CAMINHO]
"""
import argparse
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import run_godot_tests as runner  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default=os.environ.get("GODOT", runner.DEFAULT_GODOT))
    args = parser.parse_args()
    if not os.path.isfile(args.godot):
        sys.exit(f"Godot não encontrado em {args.godot}; use --godot ou a variável GODOT.")
    result = subprocess.run([args.godot, "--headless", "--path", runner.ROOT, "--import", "--quit"], timeout=300)
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
