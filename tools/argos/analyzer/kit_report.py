"""Relatório de kit do Argos: por herói em foco, agrega runs.jsonl por build e gera achados.

Uso: python tools/argos/analyzer/kit_report.py <pasta_do_relatorio> <hero_id>
Só biblioteca padrão. Simulação não é playtest: nada aqui avalia diversão.
A Signature é o 3º slot fixo do herói (decisão de Rafael, 2026-09-30): conta como skill equipada em toda build.
"""
import json
import os
import statistics
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))

RULES = {
    "viable_route_win": 0.5, "viable_max_level": 11,
    "campaign_attempts": (3, 8), "campaign_level": (9, 12),
    "dominance_gap": 0.35, "median_gap": 0.5, "dead_skill_casts": 0.5,
}

# contador -> builds em que deve disparar ("*" = todas). Sufixos/prefixos comparados com a chave da build.
EXPECTED_COUNTERS = {
    "hero_001": {"guard_spent": ("*",), "last_bastion_started": ("*",), "iron_response": ("retaliacao",)},
    "hero_003": {"enemy_stunned": ("controle",)},
}


def load_runs(path):
    runs = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                rec = json.loads(line)
                if rec.get("kind") != "meta":
                    runs.append(rec)
    return runs


def equipped_skills(hero_id):
    """build -> skills equipadas (2 da build + a Signature fixa), lidas de data/heroes/heroes.json."""
    with open(os.path.join(ROOT, "data", "heroes", "heroes.json"), encoding="utf-8") as f:
        rows = json.load(f)
    for row in rows:
        if row["id"] == hero_id:
            signature = [row["signature"]] if row.get("signature") else []
            return {key: list(b["skills"]) + signature for key, b in row.get("builds", {}).items()}
    return {}


def build_key(run, hero_id):
    return run["build_map"][hero_id].replace("_tele", "")


def win_level(campaign):
    """Nível do grupo no início da tentativa vencedora (mesma definição do Analyst: history[-1]["level"])."""
    history = campaign.get("history") or []
    return history[-1]["level"] if history else campaign["final_level"]


def per_build(runs, hero_id, equipped=None):
    equipped = equipped if equipped is not None else equipped_skills(hero_id)
    route = defaultdict(lambda: defaultdict(list))
    casts = defaultdict(lambda: defaultdict(list))
    skill_damage = defaultdict(lambda: defaultdict(list))
    counters = defaultdict(lambda: defaultdict(list))
    campaign = defaultdict(list)
    for r in runs:
        key = r["build_map"][hero_id]
        if r["kind"] == "route":
            route[key][int(r["level"])].append(1.0 if r["won"] else 0.0)
            for skill in equipped.get(build_key(r, hero_id), []):
                casts[key][skill].append(int(r.get("casts", {}).get(skill, 0)))
            for skill, dmg in r.get("skill_damage", {}).items():
                skill_damage[key][skill].append(float(dmg))
            for name, n in r.get("counters", {}).items():
                counters[key][name].append(int(n))
        elif r["kind"] == "campaign":
            campaign[key].append(r)
    stats = {}
    for key in set(route) | set(campaign):
        wins = {lvl: statistics.mean(v) for lvl, v in route[key].items()}
        camp = campaign.get(key, [])
        won = [c for c in camp if c["won"]]
        stats[key] = {
            "route_win": wins,
            "runs": sum(len(v) for v in route[key].values()),
            "casts": {s: statistics.mean(v) for s, v in casts[key].items()},
            "skill_damage": {s: statistics.mean(v) for s, v in skill_damage[key].items()},
            "counters": {n: statistics.mean(v) for n, v in counters[key].items()},
            "campaign_win": statistics.mean([1.0 if c["won"] else 0.0 for c in camp]) if camp else None,
            "campaign_attempts": statistics.median([c["attempts"] for c in won]) if won else None,
            "campaign_level": statistics.median([win_level(c) for c in won]) if won else None,
        }
    return stats


def _matches(key, patterns):
    return any(p == "*" or key.startswith(p) or key.endswith(p) for p in patterns)


def findings(stats, hero_id):
    out = []
    at10 = {k: v["route_win"].get(10) for k, v in stats.items() if v["route_win"].get(10) is not None}
    for key, v in stats.items():
        levels = [lvl for lvl in v["route_win"] if lvl <= RULES["viable_max_level"]]
        best = max((v["route_win"][lvl] for lvl in levels), default=0.0)
        if best < RULES["viable_route_win"]:
            out.append({"code": "VIABLE", "severity": "BALANCE", "detail": f"{key}: vitória de rota máxima {best:.0%} até o nível {RULES['viable_max_level']}"})
        attempts, level = v["campaign_attempts"], v["campaign_level"]
        lo, hi = RULES["campaign_attempts"]
        if attempts is not None and not (lo <= attempts <= hi):
            out.append({"code": "CAMPAIGN", "severity": "PACING", "detail": f"{key}: mediana de {attempts} tentativas (meta {lo}–{hi})"})
        if level is not None and not (RULES["campaign_level"][0] <= level <= RULES["campaign_level"][1]):
            out.append({"code": "CAMPAIGN", "severity": "PACING", "detail": f"{key}: vitória no nível {level} (meta {RULES['campaign_level'][0]}–{RULES['campaign_level'][1]})"})
        for skill, mean_casts in sorted(v["casts"].items()):
            if mean_casts < RULES["dead_skill_casts"]:
                out.append({"code": "DEAD_SKILL", "severity": "BALANCE", "detail": f"{key}: {skill} com {mean_casts:.2f} casts por rota (mínimo {RULES['dead_skill_casts']})"})
        for counter, patterns in EXPECTED_COUNTERS.get(hero_id, {}).items():
            if _matches(key, patterns) and v["counters"].get(counter, 0.0) == 0.0 and v["runs"] > 0:
                out.append({"code": "DEAD_PASSIVE", "severity": "BALANCE", "detail": f"{key}: contador {counter} nunca disparou"})
    # Mesma definição do Analyst (rules_slice.dominance): melhor vs mediana das builds acima de 0,5, nos níveis 8 e 10.
    for lvl in (8, 10):
        by_level = {k: v["route_win"][lvl] for k, v in stats.items() if lvl in v["route_win"]}
        if len(by_level) >= 3:
            top = max(by_level, key=by_level.get)
            med = statistics.median(by_level.values())
            if by_level[top] - med > RULES["median_gap"]:
                out.append({"code": "DOMINANT", "severity": "BALANCE", "detail": f"nível {lvl}: {top} {by_level[top]:.0%} vs mediana {med:.0%} (gap > {RULES['median_gap']:.0%})"})
    if len(at10) >= 2:
        best_key, worst_key = max(at10, key=at10.get), min(at10, key=at10.get)
        if at10[best_key] - at10[worst_key] > RULES["dominance_gap"]:
            out.append({"code": "DOMINANT", "severity": "BALANCE", "detail": f"nível 10: {best_key} {at10[best_key]:.0%} × {worst_key} {at10[worst_key]:.0%} (gap > {RULES['dominance_gap']:.0%})"})
    return out


def write_report(folder, hero_id):
    runs = load_runs(os.path.join(folder, "runs.jsonl"))
    stats = per_build(runs, hero_id)
    lines = [f"# Relatório de kit — {hero_id}", "", "Simulação determinística, não playtest. Regras: `RULES` em `kit_report.py`.", "",
             "| Build | Rotas | Vitória L8 | L10 | L12 | Campanha vence | Mediana tentativas | Nível de vitória |", "| --- | --- | --- | --- | --- | --- | --- | --- |"]
    for key in sorted(stats):
        v = stats[key]

        def cell(lvl):
            return f"{v['route_win'][lvl]:.0%}" if lvl in v["route_win"] else "–"

        camp = f"{v['campaign_win']:.0%}" if v["campaign_win"] is not None else "–"
        attempts = v["campaign_attempts"] if v["campaign_attempts"] is not None else "–"
        level = v["campaign_level"] if v["campaign_level"] is not None else "–"
        lines.append(f"| {key} | {v['runs']} | {cell(8)} | {cell(10)} | {cell(12)} | {camp} | {attempts} | {level} |")
    lines += ["", "## Skills (média de casts e dano por rota)", ""]
    for key in sorted(stats):
        parts = [f"{s}: {c:.1f} casts / {stats[key]['skill_damage'].get(s, 0.0):.0f} dano" for s, c in sorted(stats[key]["casts"].items())]
        lines.append(f"- **{key}** — " + ("; ".join(parts) if parts else "sem dados"))
    lines += ["", "## Contadores de kit (média por rota)", ""]
    for key in sorted(stats):
        parts = [f"{n}: {c:.1f}" for n, c in sorted(stats[key]["counters"].items())]
        lines.append(f"- **{key}** — " + ("; ".join(parts) if parts else "nenhum"))
    lines += ["", "## Achados", ""]
    found = findings(stats, hero_id)
    lines += [f"- **[{f['severity']}/{f['code']}]** {f['detail']}" for f in found] or ["- nenhum"]
    path = os.path.join(folder, f"KIT_REPORT_{hero_id}.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    return path


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit("uso: kit_report.py <pasta_do_relatorio> <hero_id>")
    print(write_report(sys.argv[1], sys.argv[2]))
