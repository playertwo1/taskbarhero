"""Roda uma única cena de teste Godot em headless e mostra só o que importa.

Uso: python tools/run_one_scene.py tests/unit/TestNome.tscn [--timeout 100]
Atalho de desenvolvimento; a suíte oficial continua sendo tools/run_godot_tests.py.
"""
import argparse
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import run_godot_tests as runner  # noqa: E402


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("scene")
    parser.add_argument("--timeout", type=int, default=100)
    parser.add_argument("--godot", default=os.environ.get("GODOT", runner.DEFAULT_GODOT))
    args = parser.parse_args()
    try:
        result = subprocess.run([args.godot, "--headless", "--path", runner.ROOT, f"res://{args.scene}"],
                                capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=args.timeout)
    except subprocess.TimeoutExpired as exc:
        partial = (exc.stdout or b"") + (exc.stderr or b"")
        text = partial.decode("utf-8", errors="replace") if isinstance(partial, bytes) else partial
        for line in text.splitlines():
            if any(key in line for key in ("SCRIPT ERROR", "Parse Error", "Compile Error", "FALHA", "[PASS]", "[FAIL]")):
                print(line)
        sys.exit(f"TIMEOUT {args.timeout}s (a cena provavelmente não compilou ou travou)")
    for line in (result.stdout + result.stderr).splitlines():
        if any(key in line for key in ("SCRIPT ERROR", "Parse Error", "Compile Error", "FALHA", "[PASS]", "[FAIL]", "ERROR:")):
            print(line)
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
