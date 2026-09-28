#!/usr/bin/env python3
"""Check the proposed C1 encounter plan against canonical enemies and balance targets."""

from __future__ import annotations

import argparse
import json
import math
import random
import re
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PLAN_PATH = ROOT / "docs/04_content/chapters/chapter_01/encounter_plan.json"
ENEMIES_PATH = ROOT / "documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json"
ENEMY_BALANCE_PATH = ROOT / "documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md"
HERO_BALANCE_PATH = ROOT / "documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/HERO_STATS_BALANCE.md"

ARCHETYPE_HP = {"STANDARD": 0.85, "HEAVY": 1.40, "ASSASSIN": 0.55, "CONTROLLER": 0.75, "SUPPORT": 0.70}
RANK_HP = {"NORMAL": 1.0, "ELITE": 2.3, "MINIBOSS": 7.0, "BOSS": 20.0}
LOCAL_BUDGET_LIMIT = {"NORMAL": 3.25, "ELITE": 5.0, "MINIBOSS": 11.5, "BOSS": 21.5}
MATERIAL_ID = "MAT_C1_LUMEN_RESIDUE"


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def table_row(path: Path, name: str) -> list[str]:
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        if line.startswith(f"| {name} |"):
            return [cell.strip() for cell in line.strip().strip("|").split("|")]
    raise ValueError(f"Could not find '{name}' in {path}")


def pair(cell: str) -> tuple[float, float]:
    values = re.findall(r"\d+(?:\.\d+)?", cell)
    if len(values) != 2:
        raise ValueError(f"Expected a two-value range, got {cell!r}")
    return float(values[0]), float(values[1])


def level_value(low: float, high: float, level: int) -> float:
    return low + (high - low) * (level - 1) / 99


def encounter_results(plan: dict, enemies: dict[str, dict]) -> tuple[list[dict], Counter[str]]:
    results = []
    represented: Counter[str] = Counter()
    for encounter in plan["encounters"]:
        budget = 0.0
        for member in encounter["members"]:
            entity = enemies[member["enemy_id"]]
            count = int(member["count"])
            budget += float(entity["ai"]["encounter_cost"]) * count
            represented[member["enemy_id"]] += count
        results.append({**encounter, "budget": budget})
    return results, represented


def sample_loot(rng: random.Random, enemy: dict, count: int) -> tuple[int, int]:
    residue = gold = 0
    for _ in range(count):
        gold_rule = enemy.get("loot", {}).get("gold", {})
        if rng.random() < float(gold_rule.get("chance", 0)):
            gold += rng.randint(int(gold_rule["min"]), int(gold_rule["max"]))
        for rule in enemy.get("loot", {}).get("materials", []):
            if rng.random() < float(rule["chance"]):
                amount = rng.randint(int(rule["quantity_min"]), int(rule["quantity_max"]))
                if rule["material_id"] == MATERIAL_ID:
                    residue += amount
    return residue, gold


def simulate_economy(runs: int, seed: int, encounters: list[dict], enemies: dict[str, dict], plan: dict) -> dict:
    rng = random.Random(seed)
    upgrade = plan["first_blacksmith_upgrade_per_item"]
    material_cost = int(upgrade["material_quantity"])
    gold_cost = int(upgrade["gold_quantity"])
    event_quantity = int(plan["optional_blacksmith_event"]["reward"]["quantity"])
    with_event = []
    without_event = []
    gold_totals = []
    for _ in range(runs):
        residue = gold = 0
        for encounter in encounters:
            for member in encounter["members"]:
                found, earned = sample_loot(rng, enemies[member["enemy_id"]], int(member["count"]))
                residue += found
                gold += earned
        without_event.append(residue)
        with_event.append(residue + event_quantity)
        gold_totals.append(gold)

    upgrades_without_event = [min(m // material_cost, g // gold_cost) for m, g in zip(without_event, gold_totals)]
    upgrades_with_event = [min(m // material_cost, g // gold_cost) for m, g in zip(with_event, gold_totals)]
    return {
        "residue_mean": sum(without_event) / runs,
        "residue_p10": percentile(without_event, 0.10),
        "residue_p90": percentile(without_event, 0.90),
        "upgrades_mean_without_event": sum(upgrades_without_event) / runs,
        "upgrades_mean_with_event": sum(upgrades_with_event) / runs,
        "upgrade_count_without_event": [sum(x >= n for x in upgrades_without_event) / runs for n in (1, 2, 3)],
        "upgrade_count_with_event": [sum(x >= n for x in upgrades_with_event) / runs for n in (1, 2, 3)],
        "gold_mean": sum(gold_totals) / runs,
        "gold_p10": percentile(gold_totals, 0.10),
        "gold_p90": percentile(gold_totals, 0.90),
        "p_gold_cost": sum(x >= gold_cost for x in gold_totals) / runs,
    }


def percentile(values: list[int], p: float) -> int:
    ordered = sorted(values)
    return ordered[min(len(ordered) - 1, math.floor(len(ordered) * p))]


def boss_ttk(level: int, hero_stats: list[dict], ref: dict) -> tuple[float, float]:
    ref_hp = level_value(ref["hp"][0], ref["hp"][1], level)
    ref_attack = level_value(ref["attack"][0], ref["attack"][1], level)
    ref_dps = ref_attack * ref["attack_speed"] * (1 + ref["crit"] * (ref["crit_damage"] - 1)) * 1.75
    boss_hp = ref_hp * ARCHETYPE_HP["HEAVY"] * RANK_HP["BOSS"] * 3

    party_dps = 0.0
    for hero in hero_stats:
        attack = level_value(hero["attack"][0], hero["attack"][1], level)
        party_dps += attack * hero["attack_speed"] * (1 + hero["crit"] * (hero["crit_damage"] - 1)) * 1.75
    return boss_hp / (ref_dps * 3), boss_hp / party_dps


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runs", type=int, default=100_000)
    parser.add_argument("--seed", type=int, default=41_785)
    args = parser.parse_args()
    if args.runs < 1:
        parser.error("--runs must be at least 1")

    plan = load(PLAN_PATH)
    catalog = load(ENEMIES_PATH)
    enemies = {entry["identity"]["id"]: entry for entry in catalog["enemies"]}
    encounters, represented = encounter_results(plan, enemies)

    assert len({entry["id"] for entry in encounters}) == len(encounters), "Duplicate encounter IDs"
    assert set(enemies).issubset(represented), f"Unplaced canonical enemies: {sorted(set(enemies) - set(represented))}"
    for encounter in encounters:
        assert encounter["budget"] <= LOCAL_BUDGET_LIMIT[encounter["kind"]], (
            f"{encounter['id']} budget {encounter['budget']:.2f} exceeds "
            f"{LOCAL_BUDGET_LIMIT[encounter['kind']]:.2f}"
        )

    enemy_balance = ENEMY_BALANCE_PATH.read_text(encoding="utf-8-sig")
    match = re.search(r"HP:\s*(\d+)\s*→\s*(\d+).*?Attack:\s*(\d+)\s*→\s*(\d+).*?AS:\s*([\d.]+).*?Crit:\s*([\d.]+)%.*?Crit DMG:\s*([\d.]+)×", enemy_balance, re.S)
    if not match:
        raise ValueError("Could not parse HERO_REFERENCE stats")
    ref = {"hp": (float(match[1]), float(match[2])), "attack": (float(match[3]), float(match[4])),
           "attack_speed": float(match[5]), "crit": float(match[6]) / 100, "crit_damage": float(match[7])}

    hero_stats = []
    for name in ("Bastião", "Flecha", "Íris"):
        row = table_row(HERO_BALANCE_PATH, name)
        hero_stats.append({"hp": pair(row[2]), "attack": pair(row[3]), "defense": pair(row[4]),
                           "attack_speed": float(row[5]), "crit": float(row[7].rstrip("%")) / 100,
                           "crit_damage": float(row[8].rstrip("×"))})

    economy = simulate_economy(args.runs, args.seed, encounters, enemies, plan)
    counts_by_rank = Counter()
    for enemy_id, count in represented.items():
        counts_by_rank[enemies[enemy_id]["identity"]["rank"]] += count

    print(f"runs={args.runs} seed={args.seed}")
    print(f"encounters={len(encounters)} defeated_entities={sum(represented.values())} ranks={dict(sorted(counts_by_rank.items()))}")
    print("| Encontro | Tipo | Budget | Limite |")
    print("| --- | --- | ---: | ---: |")
    for encounter in encounters:
        print(f"| {encounter['id']} — {encounter['name']} | {encounter['kind']} | {encounter['budget']:.2f} | {LOCAL_BUDGET_LIMIT[encounter['kind']]:.2f} |")
    upgrade = plan["first_blacksmith_upgrade_per_item"]
    print(f"\nFerreiro proposto: primeiro Reforço +1 = {upgrade['material_quantity']} Resíduos + {upgrade['gold_quantity']} Ouros")
    print(f"Resíduo sem evento: média {economy['residue_mean']:.2f}, P10–P90 {economy['residue_p10']}–{economy['residue_p90']}")
    print(f"Reforços +1 em itens diferentes, média por rota: sem evento {economy['upgrades_mean_without_event']:.2f}; com evento {economy['upgrades_mean_with_event']:.2f}")
    print("| Número de itens melhorados em +1 | Sem evento | Com evento |")
    print("| ---: | ---: | ---: |")
    for i, (no_event, event) in enumerate(zip(economy["upgrade_count_without_event"], economy["upgrade_count_with_event"]), 1):
        print(f"| pelo menos {i} | {no_event:.1%} | {event:.1%} |")
    print(f"Ouro: média {economy['gold_mean']:.1f}, P10–P90 {economy['gold_p10']}–{economy['gold_p90']}; P(>= {upgrade['gold_quantity']}) {economy['p_gold_cost']:.1%}")
    print("\nGuardião: HP escala ×3; DPS sustentado usa ×1.75. Referência compara três HERO_REFERENCE contra três heróis iniciais.")
    print("| Nível da party | TTK party de referência | TTK party inicial | Faixa canônica |")
    print("| ---: | ---: | ---: | --- |")
    for level in (1, 6):
        reference_ttk, party_ttk = boss_ttk(level, hero_stats, ref)
        print(f"| {level} | {reference_ttk:.1f} s | {party_ttk:.1f} s | 120–210 s |")
        assert 120 <= reference_ttk <= 210, "Boss theoretical TTK falls outside canonical reference target"
        assert 120 <= party_ttk <= 210, "Party-scaled boss theoretical TTK falls outside canonical reference target"
    assert economy["upgrade_count_with_event"][0] == 1.0, "Optional event plus guaranteed drops should afford one first upgrade"
    assert economy["p_gold_cost"] == 1.0, "Proposed Gold cost should be available on the first route"
    print("\nCHECKS: PASS (coverage, local budgets, canonical TTK, first optional upgrade affordability)")
    print("LIMIT: this model does not simulate boss attacks, player decisions, survival, skills at runtime, or first-attempt win rate.")


if __name__ == "__main__":
    main()
