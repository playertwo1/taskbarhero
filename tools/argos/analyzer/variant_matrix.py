"""Tabela build × variante (vitória e nível mediano na campanha) de um relatório do Argos.

Uso: python tools/argos/analyzer/variant_matrix.py [pasta_do_relatorio]   (padrão: o mais recente)
"""
import json
import os
import sys
from collections import defaultdict

REPORTS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "reports")


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    folder = sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPORTS, sorted(os.listdir(REPORTS))[-1])
    data = json.load(open(os.path.join(folder, "summary.json"), encoding="utf-8"))
    table, variants = defaultdict(dict), []
    for r in data["campaign"]:
        v, b = r["build"].split(" · ", 1) if " · " in r["build"] else ("", r["build"])
        if v not in variants:
            variants.append(v)
        table[b][v] = r
    print(f"{os.path.basename(folder)} — vitória na campanha e nível mediano da vitória (L)")
    print("build".ljust(34) + "".join(v[:18].rjust(19) for v in variants))
    levels = defaultdict(list)
    for b in sorted(table):
        row = b.ljust(34)
        for v in variants:
            r = table[b].get(v)
            if r is None:
                row += "".rjust(19)
                continue
            lvl = r["median_win_level"]
            if lvl is not None:
                levels[v].append(lvl)
            row += (f"{r['win_rate']:.0%} L{lvl:g}" if lvl is not None else f"{r['win_rate']:.0%} —").rjust(19)
        print(row)
    print("mediana".ljust(34) + "".join((f"L{sorted(levels[v])[len(levels[v]) // 2]:g}" if levels[v] else "—").rjust(19) for v in variants))
    print("faixa".ljust(34) + "".join((f"{min(levels[v]):g}–{max(levels[v]):g}" if levels[v] else "—").rjust(19) for v in variants))


if __name__ == "__main__":
    main()
