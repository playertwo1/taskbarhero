"""Executa todas as cenas de teste Godot em headless e resume PASS/FAIL.

Uso: python tools/run_godot_tests.py [--godot CAMINHO] [--timeout SEGUNDOS]

Cada cena de teste encerra com quit(0) em sucesso e quit(1) em falha; o
código de saída deste script é 1 se qualquer cena falhar ou estourar o tempo.
"""
import argparse
import glob
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_GODOT = os.path.join(
    ROOT, "Godot_v4.7.2-stable_win64.exe", "Godot_v4.7.2-stable_win64_console.exe"
)


def find_scenes():
    scenes = glob.glob(os.path.join(ROOT, "tests", "*.tscn"))
    scenes += glob.glob(os.path.join(ROOT, "tests", "unit", "*.tscn"))
    return sorted(os.path.relpath(s, ROOT).replace(os.sep, "/") for s in scenes)


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--godot", default=os.environ.get("GODOT", DEFAULT_GODOT))
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()

    if not os.path.isfile(args.godot):
        sys.exit(f"Godot não encontrado em {args.godot}; use --godot ou a variável GODOT.")

    failures = []
    for scene in find_scenes():
        try:
            result = subprocess.run(
                [args.godot, "--headless", "--path", ROOT, f"res://{scene}"],
                capture_output=True, text=True, encoding="utf-8", errors="replace",
                timeout=args.timeout,
            )
            log = result.stdout + result.stderr
            # Erro de parse/compilação pode sair com código 0; trate como falha.
            script_error = "SCRIPT ERROR" in log
            ok = result.returncode == 0 and not script_error
            detail = "" if ok else ("SCRIPT ERROR" if script_error else f"exit {result.returncode}")
        except subprocess.TimeoutExpired:
            ok, detail, log = False, f"timeout {args.timeout}s", ""
        print(f"[{'PASS' if ok else 'FAIL'}] {scene} {detail}".rstrip())
        if not ok:
            failures.append(scene)
            print("\n".join(log.strip().splitlines()[-15:]))

    total = len(find_scenes())
    print(f"\n{total - len(failures)}/{total} cenas passaram.")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
