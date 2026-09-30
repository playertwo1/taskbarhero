"""Confere a invariância do combat_scale em um relatório do Argos (cenário scale_equivalence).

Uso: python tools/balance/check_scale_equivalence.py <pasta_do_relatório> [--base x1] [--scaled x10] [--factor 10]

Pareia cada execução da variante base com a da variante escalada (mesmo modo, build, nível,
seed e segmento) e compara campo a campo. Cada valor numérico precisa ser igual (unidade
inalterada) ou multiplicado pelo fator (valor absoluto de HP/dano/cura). Os campos que
escalaram são listados para conferência humana. Só lê o relatório; não altera /data.
"""
import argparse
import json
import math
import os
import sys


def flatten(value, prefix=""):
    if isinstance(value, dict):
        for key, child in value.items():
            yield from flatten(child, f"{prefix}.{key}" if prefix else str(key))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from flatten(child, f"{prefix}[{index}]")
    else:
        yield prefix, value


def identity(record):
    parts = [record.get("kind"), json.dumps(record.get("build_map", record.get("build", "")), sort_keys=True),
             record.get("level"), record.get("seed"), record.get("segment"), record.get("attempt")]
    return tuple(str(part) for part in parts)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("report")
    parser.add_argument("--base", default="x1")
    parser.add_argument("--scaled", default="x10")
    parser.add_argument("--factor", type=float, default=10.0)
    parser.add_argument("--tolerance", type=float, default=1e-6)
    args = parser.parse_args()

    by_variant = {args.base: {}, args.scaled: {}}
    with open(os.path.join(args.report, "runs.jsonl"), encoding="utf-8") as handle:
        for line in handle:
            record = json.loads(line)
            variant = record.get("variant")
            if record.get("kind") == "meta" or variant not in by_variant:
                continue
            key = identity(record)
            by_variant[variant].setdefault(key, []).append(record)

    problems, scaled_paths, compared = [], {}, 0
    keys = set(by_variant[args.base]) | set(by_variant[args.scaled])
    for key in sorted(keys):
        a_list, b_list = by_variant[args.base].get(key, []), by_variant[args.scaled].get(key, [])
        if len(a_list) != len(b_list) or not a_list:
            problems.append(f"{key}: {len(a_list)} registro(s) em {args.base} e {len(b_list)} em {args.scaled}")
            continue
        for a, b in zip(a_list, b_list):
            compared += 1
            fa, fb = dict(flatten(a)), dict(flatten(b))
            for path in sorted(set(fa) | set(fb)):
                if path in ("variant", "build") or path.startswith("variant"):
                    continue
                va, vb = fa.get(path), fb.get(path)
                if isinstance(va, (int, float)) and isinstance(vb, (int, float)) and not isinstance(va, bool):
                    scale = 1.0 if abs(va) < 1e-12 and abs(vb) < 1e-12 else None
                    if math.isclose(va, vb, rel_tol=args.tolerance, abs_tol=1e-9):
                        continue
                    if math.isclose(va * args.factor, vb, rel_tol=args.tolerance, abs_tol=1e-6):
                        label = path.split("[")[0]
                        label = ".".join(part for part in label.split(".") if not part.startswith(("hero_", "c1_")))
                        scaled_paths[label] = scaled_paths.get(label, 0) + 1
                        continue
                    problems.append(f"{key} {path}: {va} × {args.factor:g} != {vb}")
                elif va != vb:
                    problems.append(f"{key} {path}: {va!r} != {vb!r}")

    print(f"Execuções pareadas: {compared}; divergências: {len(problems)}")
    print("Campos que escalaram pelo fator (conferir se são valores absolutos):")
    for label, count in sorted(scaled_paths.items()):
        print(f"  {label} ({count})")
    for line in problems[:25]:
        print("DIVERGÊNCIA:", line)
    sys.exit(1 if problems or compared == 0 else 0)


if __name__ == "__main__":
    main()
