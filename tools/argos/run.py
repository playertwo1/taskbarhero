"""Argos — executa um cenário do simulador headless e gera o relatório do Analyst.

Uso: python tools/argos/run.py [--scenario slice_quick] [--godot CAMINHO] [--timeout SEGUNDOS]

Sem IA no laço: o Godot roda o simulador determinístico e o Analyst aplica regras fixas.
Saída em tools/argos/reports/<AAAAMMDD-HHMMSS>_<commit>/ (runs.jsonl fica fora do Git).
"""
import argparse
import datetime
import hashlib
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
DEFAULT_GODOT = os.path.join(ROOT, "Godot_v4.7.2-stable_win64.exe", "Godot_v4.7.2-stable_win64_console.exe")
SCENARIOS = os.path.join(HERE, "simulator", "combat", "scenarios")
VALIDATOR = os.path.join(ROOT, "tools", "balance", "validate_balance_data.py")


def git(*args):
    try:
        return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True, check=True).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        return ""


def resource_path(value):
    return os.path.join(ROOT, *value[6:].split("/"))


def balance_inputs(scenario_file):
    manifest_file = os.path.join(ROOT, "data", "balance", "combat_profiles.json")
    manifest = json.load(open(manifest_file, encoding="utf-8"))
    scenario = json.load(open(scenario_file, encoding="utf-8"))
    chapter_id = scenario.get("chapter_id", manifest["default_chapter"])
    files = [manifest_file, resource_path(manifest["global_profile"]),
             resource_path(manifest["chapter_profiles"][chapter_id]), scenario_file]
    hashes = {}
    combined = hashlib.sha256()
    for path in files:
        digest = hashlib.sha256(open(path, "rb").read()).hexdigest()
        rel = os.path.relpath(path, ROOT).replace(os.sep, "/")
        hashes[rel] = digest
        combined.update(rel.encode("utf-8") + b"\0" + digest.encode("ascii") + b"\0")
    return hashes, combined.hexdigest()


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--scenario", default="slice_quick")
    parser.add_argument("--godot", default=os.environ.get("GODOT", DEFAULT_GODOT))
    parser.add_argument("--timeout", type=int, default=3600)
    args = parser.parse_args()

    scenario_file = os.path.join(SCENARIOS, args.scenario + ".json")
    if not os.path.isfile(scenario_file):
        sys.exit(f"Cenário não encontrado: {scenario_file}")
    if not os.path.isfile(args.godot):
        sys.exit(f"Godot não encontrado em {args.godot}; use --godot ou a variável GODOT.")

    validation = subprocess.run([sys.executable, VALIDATOR, "--scenario", scenario_file], cwd=ROOT)
    if validation.returncode:
        sys.exit("Argos: dados de balanceamento inválidos; simulação cancelada.")

    commit = git("rev-parse", "--short", "HEAD") or "sem-git"
    dirty = bool(git("status", "--porcelain", "--untracked-files=no"))
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    out_dir = os.path.join(HERE, "reports", f"{stamp}_{commit}")
    os.makedirs(out_dir, exist_ok=True)
    runs = os.path.join(out_dir, "runs.jsonl")
    inputs, balance_hash = balance_inputs(scenario_file)
    json.dump({"commit": commit, "dirty": dirty, "scenario_file": os.path.relpath(scenario_file, ROOT).replace(os.sep, "/"),
               "balance_hash": balance_hash, "balance_inputs": inputs},
              open(os.path.join(out_dir, "meta.json"), "w", encoding="utf-8"), indent=1)

    res_path = "res://" + os.path.relpath(scenario_file, ROOT).replace(os.sep, "/")
    cmd = [args.godot, "--headless", "--path", ROOT, "res://tools/argos/simulator/combat/ArgosSim.tscn", "--",
           f"scenario={res_path}", f"out={runs}"]
    print(f"Argos: cenário {args.scenario} no commit {commit}{' (com alterações locais)' if dirty else ''}…")
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=args.timeout)
    except subprocess.TimeoutExpired:
        sys.exit(f"Argos: simulador passou de {args.timeout} s")
    log = result.stdout + result.stderr
    open(os.path.join(out_dir, "godot.log"), "w", encoding="utf-8").write(log)
    if result.returncode != 0 or "SCRIPT ERROR" in log:
        print("\n".join(log.strip().splitlines()[-20:]))
        sys.exit(f"Argos: o simulador falhou (exit {result.returncode}); veja {out_dir}/godot.log")
    analyze = [sys.executable, os.path.join(HERE, "analyzer", "analyze.py"), out_dir]
    sys.exit(subprocess.run(analyze).returncode)


if __name__ == "__main__":
    main()
