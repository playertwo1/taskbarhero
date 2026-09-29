"""Argos Analyst: agrega runs.jsonl do ARGOS-SIM e gera summary.json + REPORT.md.

Uso: python tools/argos/analyzer/analyze.py <pasta_do_relatorio> [--rules caminho] [--previous pasta]

Só usa a biblioteca padrão. Os achados são classificados (BUG, BALANCE, PACING, INFO) e cada um
aponta a métrica e a regra que o gerou. Simulação não é playtest: diversão não é avaliada aqui.
"""
import argparse
import json
import os
import statistics
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
REPORTS = os.path.join(os.path.dirname(HERE), "reports")
SEVERITY_ORDER = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3, "INFO": 4}


def load_runs(path):
    meta, runs = {}, []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            rec = json.loads(line)
            if rec.get("kind") == "meta":
                meta = rec
            else:
                runs.append(rec)
    return meta, runs


def median(values):
    return statistics.median(values) if values else None


def summarize(runs):
    route = defaultdict(list)
    segments = defaultdict(list)
    campaign = defaultdict(list)
    violations = defaultdict(int)
    violation_examples = {}
    for r in runs:
        for v in r.get("violations", []):
            violations[v] += 1
            violation_examples.setdefault(v, {k: r.get(k) for k in ("kind", "build", "level", "seed", "segment")})
        if r["kind"] == "route":
            route[(r["build"], r["level"])].append(r)
        elif r["kind"] == "segment":
            segments[(r["build"], r["level"], r["segment"])].append(r)
        elif r["kind"] == "campaign":
            campaign[r["build"]].append(r)
            for h in r.get("history", []):
                for v in h.get("violations", []):
                    violations[v] += 1
                    violation_examples.setdefault(v, {"kind": "campaign", "build": r["build"], "seed": r["seed"]})

    route_rows = []
    for (build, level), rs in sorted(route.items()):
        lost = defaultdict(int)
        for r in rs:
            if not r["won"]:
                lost[r["lost_at"]] += 1
        entry = [r["nodes"]["c1_3_2_a"]["party_hp_pct"] for r in rs if "c1_3_2_a" in r["nodes"]]
        route_rows.append({
            "build": build, "level": level, "runs": len(rs),
            "win_rate": sum(r["won"] for r in rs) / len(rs),
            "main_loss": max(lost, key=lost.get) if lost else "",
            "hp_before_boss_pct": median(entry),
            "healing": median([r["healing"] for r in rs]),
        })
    seg_rows = []
    for (build, level, seg), rs in sorted(segments.items()):
        wins = [r for r in rs if r["won"]]
        seg_rows.append({
            "build": build, "level": level, "segment": seg, "runs": len(rs),
            "win_rate": len(wins) / len(rs),
            "ttk": median([list(r["nodes"].values())[0]["ttk"] for r in wins if r["nodes"]]),
            "hp_left_pct": median([list(r["nodes"].values())[0]["party_hp_pct"] for r in wins if r["nodes"]]),
        })
    camp_rows = []
    econ_rows = []
    for build, cs in sorted(campaign.items()):
        looted = [c for c in cs if c.get("loot")]
        if looted:
            hist = [h for c in looted for h in c["history"]]
            econ_rows.append({
                "build": build,
                "gold_per_attempt": median([h["gold"] for h in hist]),
                "residue_per_attempt": median([h["residue"] for h in hist]),
                "items_per_attempt": median([h["items_dropped"] for h in hist]),
                "equipped_at_end": median([c["history"][-1]["equipped_after"] for c in looted]),
                "residue_total": median([c["totals"]["residue"] for c in looted]),
            })
        won = [c for c in cs if c["won"]]
        camp_rows.append({
            "build": build, "campaigns": len(cs), "win_rate": len(won) / len(cs),
            "first_try": sum(1 for c in won if c["attempts"] == 1) / len(cs),
            "median_attempts": median([c["attempts"] for c in won]),
            "median_win_level": median([c["history"][-1]["level"] for c in won]),
        })
    return {
        "route": route_rows, "segments": seg_rows, "campaign": camp_rows, "economy": econ_rows,
        "violations": dict(violations), "violation_examples": violation_examples,
    }


def split_label(label):
    """'variante · b/f/i' → (variante, 'b/f/i'); sem variante → ('', label)."""
    if " · " in label:
        v, b = label.split(" · ", 1)
        return v, b
    return "", label


def variant_rows(summary, heal_build="lumen", max_attempts_ok=5):
    """Por variante: rota da cura vs. sem cura, e caminhos sem cura que vencem a campanha em até N tentativas."""
    variants = []
    for r in summary["route"] + summary["campaign"]:
        v, _ = split_label(r["build"])
        if v and v not in variants:
            variants.append(v)
    out = []
    for v in variants:
        route = [r for r in summary["route"] if split_label(r["build"])[0] == v]
        camp = [r for r in summary["campaign"] if split_label(r["build"])[0] == v]
        heal_route = [r["win_rate"] for r in route if split_label(r["build"])[1].split("/")[2] == heal_build]
        other_route = [r for r in route if split_label(r["build"])[1].split("/")[2] != heal_build]
        heal_camp = [r for r in camp if split_label(r["build"])[1].split("/")[2] == heal_build]
        other_camp = [r for r in camp if split_label(r["build"])[1].split("/")[2] != heal_build]
        good = [r for r in other_camp if r["win_rate"] >= 0.5 and r["median_attempts"] is not None and r["median_attempts"] <= max_attempts_ok]
        out.append({
            "variant": v,
            "heal_route_win": statistics.mean(heal_route) if heal_route else None,
            "no_heal_route_best": max((r["win_rate"] for r in other_route), default=None),
            "no_heal_route_viable": sum(1 for r in other_route if r["win_rate"] >= 0.5),
            "no_heal_combos": len(other_route) or len(other_camp),
            "heal_attempts": median([r["median_attempts"] for r in heal_camp if r["median_attempts"] is not None]),
            "no_heal_attempts_best": min((r["median_attempts"] for r in other_camp if r["median_attempts"] is not None), default=None),
            "no_heal_paths_ok": len(good),
            "no_heal_paths_ok_list": sorted({split_label(r["build"])[1] for r in good}),
        })
    return out


def finding(kind, severity, title, metric, rule):
    return {"type": kind, "severity": severity, "title": title, "metric": metric, "rule": rule}


def evaluate(summary, rules):
    findings = []
    for v, n in sorted(summary["violations"].items()):
        severity = "CRITICAL" if v in ("enemy_defeated_twice", "xp_mismatch") else "HIGH"
        findings.append(finding("BUG", severity, f"Oráculo violado: {v}", f"{n} execução(ões); exemplo {summary['violation_examples'][v]}", "invariante do simulador"))

    for seg, rng in rules["ttk_ranges"].items():
        rows = [r for r in summary["segments"] if r["segment"] == seg and r["ttk"] is not None]
        if not rows:
            continue
        ttks = [r["ttk"] for r in rows]
        out = [r for r in rows if not (rng["min"] <= r["ttk"] <= rng["max"])]
        if out:
            worst = max(out, key=lambda r: abs(r["ttk"] - (rng["min"] + rng["max"]) / 2))
            findings.append(finding("BALANCE", "MEDIUM", f"TTK de {seg} fora de {rng['min']}–{rng['max']} s",
                                    f"{len(out)}/{len(rows)} combinações vencedoras fora; mediana {median(ttks):.0f} s; pior {worst['build']} nível {worst['level']}: {worst['ttk']:.0f} s",
                                    rng["source"]))

    if not summary["route"]:
        return _campaign_and_economy(summary, rules, findings)
    vp = rules["viable_path"]
    viable = sorted({r["build"] for r in summary["route"] if r["level"] <= vp["max_level"] and r["win_rate"] >= vp["min_route_win_rate"]})
    excluded_hero, excluded_build = next(iter(vp["min_paths_without"].items()))
    idx = {"hero_001": 0, "hero_002": 1, "hero_003": 2}[excluded_hero]
    without = [b for b in viable if b.split("/")[idx] != excluded_build]
    metric = f"viáveis até o nível {vp['max_level']} (rota ≥ {vp['min_route_win_rate']:.0%}): {len(viable)}; sem {excluded_build}: {len(without)}"
    if len(viable) < vp["min_paths"] or len(without) < vp["min_paths_without_count"]:
        findings.append(finding("BALANCE", "HIGH", "Poucos caminhos viáveis", metric, vp["source"]))
    else:
        findings.append(finding("INFO", "INFO", "Caminhos viáveis", metric + "; " + ", ".join(viable), vp["source"]))

    by_level = defaultdict(list)
    for r in summary["route"]:
        by_level[r["level"]].append(r)
    for level, rows in sorted(by_level.items()):
        rates = [r["win_rate"] for r in rows]
        best = max(rows, key=lambda r: r["win_rate"])
        gap = best["win_rate"] - statistics.median(rates)
        if gap >= rules["dominance"]["win_rate_gap"]:
            top = [r["build"] for r in rows if r["win_rate"] >= best["win_rate"] - 0.001]
            findings.append(finding("BALANCE", "HIGH", f"Dominância no nível {level}",
                                    f"melhor {best['win_rate']:.0%} vs mediana {statistics.median(rates):.0%}; líderes: {', '.join(top[:6])}",
                                    rules["dominance"]["source"]))

    ref = rules["first_try_reference"]
    rows = [r for r in summary["route"] if r["level"] == ref["level"]]
    if rows:
        best = max(r["win_rate"] for r in rows)
        findings.append(finding("INFO", "INFO", f"Referência de primeira tentativa no nível {ref['level']}",
                                f"melhor combinação {best:.0%} (meta humana {ref['min']:.0%}–{ref['max']:.0%})", ref["source"]))

    return _campaign_and_economy(summary, rules, findings)


def _campaign_and_economy(summary, rules, findings):
    cr = rules["campaign"]
    for r in summary["campaign"]:
        if r["win_rate"] == 0:
            continue
        if r["first_try"] > 0:
            findings.append(finding("PACING", "MEDIUM", f"Vitória na 1ª tentativa desde o nível inicial: {r['build']}",
                                    f"{r['first_try']:.0%} das campanhas vencem na tentativa 1", cr["source"]))
        elif r["median_attempts"] is not None and not (cr["median_attempts_min"] <= r["median_attempts"] <= cr["median_attempts_max"]):
            findings.append(finding("PACING", "LOW", f"Tentativas fora da faixa: {r['build']}",
                                    f"mediana {r['median_attempts']:.1f} tentativas, nível {r['median_win_level']:.1f}", cr["source"]))
    never = [r["build"] for r in summary["campaign"] if r["win_rate"] == 0]
    if never:
        findings.append(finding("PACING", "MEDIUM", "Combinações que nunca vencem na campanha",
                                f"{len(never)}: {', '.join(never)}", cr["source"]))
    er = rules.get("economy")
    if er and summary.get("economy"):
        low = [r for r in summary["economy"] if r["residue_per_attempt"] is not None and r["residue_per_attempt"] < er["residue_per_attempt_min"]]
        if low:
            findings.append(finding("ECONOMY", "MEDIUM", "Resíduo de Lúmen abaixo de um Reforço +1 por tentativa",
                                    f"{len(low)}/{len(summary['economy'])} combinações; mediana mínima {min(r['residue_per_attempt'] for r in low)} (meta ≥ {er['residue_per_attempt_min']})",
                                    er["source"]))
        items = [r["items_per_attempt"] for r in summary["economy"] if r["items_per_attempt"] is not None]
        if items:
            findings.append(finding("INFO", "INFO", "Itens por tentativa",
                                    f"mediana {median(items):.1f} item(ns) por tentativa entre combinações", er["source"]))
    findings.sort(key=lambda f: SEVERITY_ORDER[f["severity"]])
    return findings


def previous_summary(current_dir, explicit, scenario):
    if explicit:
        path = os.path.join(explicit, "summary.json")
        return json.load(open(path, encoding="utf-8")) if os.path.exists(path) else None
    if not os.path.isdir(REPORTS):
        return None
    current = os.path.basename(os.path.normpath(current_dir))
    candidates = sorted(d for d in os.listdir(REPORTS) if d < current and os.path.exists(os.path.join(REPORTS, d, "summary.json")))
    for d in reversed(candidates):
        data = json.load(open(os.path.join(REPORTS, d, "summary.json"), encoding="utf-8"))
        if data["meta"].get("scenario") == scenario:
            data["_dir"] = d
            return data
    return None


def pct(v):
    return "—" if v is None else f"{v:.0%}"


def num(v, fmt="{:.0f}"):
    return "—" if v is None else fmt.format(v)


def write_report(out_dir, meta, summary, findings, prev):
    lines = [f"# Argos — relatório `{meta.get('scenario', '?')}`", ""]
    lines.append(f"- Commit: `{meta.get('commit', '?')}`{' (com alterações locais)' if meta.get('dirty') else ''} · Godot {meta.get('godot', '?')}")
    lines.append(f"- Sementes por célula: {int(meta['seeds']) if isinstance(meta.get('seeds'), (int, float)) else '?'} · `enemy_damage_scale` {meta.get('enemy_damage_scale', '?')}")
    lines.append("- Simulação determinística; **não é playtest** e não avalia diversão.")
    lines += ["", "## Achados", ""]
    for f in findings:
        lines.append(f"- **[{f['type']}/{f['severity']}] {f['title']}** — {f['metric']} _(regra: {f['rule']})_")
    if not findings:
        lines.append("- Nenhum.")

    prev_route = {(r["build"], r["level"]): r["win_rate"] for r in prev["route"]} if prev else {}
    lines += ["", "## Rota completa (vitória por combinação e nível)", "",
              "| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |",
              "| --- | ---: | ---: | ---: | --- | ---: | ---: |"]
    for r in summary["route"]:
        key = (r["build"], r["level"])
        delta = "" if key not in prev_route else f"{(r['win_rate'] - prev_route[key]) * 100:+.0f} p.p."
        lines.append(f"| {r['build']} | {r['level']} | {pct(r['win_rate'])} | {delta} | {r['main_loss']} | {num(r['hp_before_boss_pct'], '{:.0f}%')} | {num(r['healing'])} |")

    if summary["segments"]:
        lines += ["", "## Encontros isolados com HP cheio", "",
                  "| Build | Nível | Encontro | Vitória | TTK mediano | HP restante |", "| --- | ---: | --- | ---: | ---: | ---: |"]
        for r in summary["segments"]:
            lines.append(f"| {r['build']} | {r['level']} | {r['segment']} | {pct(r['win_rate'])} | {num(r['ttk'], '{:.0f} s')} | {num(r['hp_left_pct'], '{:.0f}%')} |")

    if summary["campaign"]:
        lines += ["", "## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)", "",
                  "| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |", "| --- | ---: | ---: | ---: | ---: |"]
        for r in summary["campaign"]:
            lines.append(f"| {r['build']} | {pct(r['win_rate'])} | {pct(r['first_try'])} | {num(r['median_attempts'], '{:.1f}')} | {num(r['median_win_level'], '{:.1f}')} |")
    variants = variant_rows(summary)
    if variants:
        lines += ["", "## Comparação de variantes (sem cura = Íris fora da build Lúmen)", "",
                  "| Variante | Rota: cura | Rota: melhor sem cura | Sem cura com rota ≥ 50% | Tentativas: cura | Tentativas: melhor sem cura | Caminhos sem cura em ≤ 5 tentativas |",
                  "| --- | ---: | ---: | ---: | ---: | ---: | --- |"]
        for r in variants:
            paths = f"{r['no_heal_paths_ok']}/{r['no_heal_combos']}"
            if r["no_heal_paths_ok_list"]:
                paths += " (" + ", ".join(r["no_heal_paths_ok_list"][:4]) + ("…" if len(r["no_heal_paths_ok_list"]) > 4 else "") + ")"
            lines.append(f"| {r['variant']} | {pct(r['heal_route_win'])} | {pct(r['no_heal_route_best'])} | {r['no_heal_route_viable']}/{r['no_heal_combos']} | {num(r['heal_attempts'], '{:.1f}')} | {num(r['no_heal_attempts_best'], '{:.1f}')} | {paths} |")
    if summary.get("economy"):
        lines += ["", "## Economia e loot na campanha (modelo canônico simplificado)", "",
                  "| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |",
                  "| --- | ---: | ---: | ---: | ---: | ---: |"]
        for r in summary["economy"]:
            lines.append(f"| {r['build']} | {num(r['gold_per_attempt'])} | {num(r['residue_per_attempt'], '{:.1f}')} | {num(r['items_per_attempt'], '{:.1f}')} | {num(r['equipped_at_end'])} | {num(r['residue_total'])} |")
    if prev:
        lines += ["", f"Comparação com `{prev.get('_dir', 'anterior')}`."]
    open(os.path.join(out_dir, "REPORT.md"), "w", encoding="utf-8").write("\n".join(lines) + "\n")


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("report_dir")
    parser.add_argument("--rules", default=os.path.join(HERE, "rules_slice.json"))
    parser.add_argument("--previous")
    args = parser.parse_args()
    meta_file = os.path.join(args.report_dir, "meta.json")
    meta, runs = load_runs(os.path.join(args.report_dir, "runs.jsonl"))
    if os.path.exists(meta_file):
        meta.update(json.load(open(meta_file, encoding="utf-8")))
    if not runs:
        sys.exit("Argos: nenhuma execução em runs.jsonl")
    rules = json.load(open(args.rules, encoding="utf-8"))
    summary = summarize(runs)
    findings = evaluate(summary, rules)
    data = {"meta": meta, "findings": findings, "variants": variant_rows(summary), **summary}
    prev = previous_summary(args.report_dir, args.previous, meta.get("scenario"))
    json.dump(data, open(os.path.join(args.report_dir, "summary.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    write_report(args.report_dir, meta, summary, findings, prev)
    bugs = [f for f in findings if f["type"] == "BUG"]
    print(f"Argos: {len(runs)} execuções, {len(findings)} achados ({len(bugs)} BUG). Relatório: {os.path.join(args.report_dir, 'REPORT.md')}")
    sys.exit(1 if bugs else 0)


if __name__ == "__main__":
    main()
