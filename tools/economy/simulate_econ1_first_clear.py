#!/usr/bin/env python3
"""Reproducible ECON-1 baseline simulation for the current five-stage route."""

from __future__ import annotations

import argparse
import json
import math
import random
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
ENEMY_PATH = ROOT / "data" / "enemies" / "enemies.json"
STAGE_PATH = ROOT / "data" / "stages" / "stages.json"
ITEM_PATH = ROOT / "data" / "items" / "items.json"

SCRAP_BY_RARITY = {
    "Comum": 1,
    "Raro": 2,
    "Épico": 3,
    "Lendário": 4,
}


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8-sig") as file:
        return json.load(file)


def weighted_choice(rng: random.Random, rows: list[tuple[Any, int]]) -> Any:
    total = sum(weight for _, weight in rows)
    if total <= 0:
        raise ValueError("Weighted table must have a positive total weight")
    roll = rng.randint(1, total)
    cumulative = 0
    for value, weight in rows:
        cumulative += weight
        if roll <= cumulative:
            return value
    raise RuntimeError("Weighted selection fell through")


def xp_for_level(level: int) -> int:
    raw = 25.0 * math.pow(1.15, level - 1) + 5.0 * level
    return math.floor(raw + 0.5)  # Godot round() behavior for positive values.


def resulting_level(xp: int) -> int:
    level = 1
    remainder = xp
    while remainder >= xp_for_level(level):
        remainder -= xp_for_level(level)
        level += 1
    return level


def percentile(values: list[int], p: float) -> int:
    ordered = sorted(values)
    return ordered[min(len(ordered) - 1, math.floor(len(ordered) * p))]


def simulate(runs: int, combat_seed: int, loot_seed: int) -> dict[str, Any]:
    stages = load_json(STAGE_PATH)
    enemies = {enemy["id"]: enemy for enemy in load_json(ENEMY_PATH)}
    items = load_json(ITEM_PATH)

    combat_rng = random.Random(combat_seed)
    loot_rng = random.Random(loot_seed)
    item_rows = [(item, int(item.get("weight", 10))) for item in items]

    xp_totals: list[int] = []
    gold_totals: list[int] = []
    item_counts: list[int] = []
    scrap_all: list[int] = []
    scrap_keep_best_slot: list[int] = []
    level_counts: Counter[int] = Counter()

    for _ in range(runs):
        total_xp = 0
        total_gold = 0
        drops: list[dict[str, Any]] = []

        for stage in stages:
            pool = [
                (enemies[entry["id"]], int(entry.get("weight", 10)))
                for entry in stage.get("enemy_pool", [])
            ]
            if not pool:
                raise ValueError(f"Stage {stage.get('stage')} has no enemy pool")

            kill_count = int(stage.get("kills_to_advance", 0))
            for _ in range(kill_count):
                enemy = weighted_choice(combat_rng, pool)
                total_xp += int(enemy.get("xp", 10))
                total_gold += combat_rng.randint(
                    int(enemy.get("gold_min", 1)),
                    int(enemy.get("gold_max", 5)),
                )
                if loot_rng.random() < 0.25:
                    drops.append(weighted_choice(loot_rng, item_rows))

            leader_id = stage.get("boss_id")
            if leader_id:
                leader = enemies[leader_id]
                total_xp += int(leader.get("xp", 10))
                total_gold += combat_rng.randint(
                    int(leader.get("gold_min", 1)),
                    int(leader.get("gold_max", 5)),
                )
                # Runtime passes only the `boss` flag to roll_drop; elites keep 25%.
                drop_chance = 0.60 if leader.get("boss", False) else 0.25
                if loot_rng.random() < drop_chance:
                    drops.append(weighted_choice(loot_rng, item_rows))

        scrap_values = [SCRAP_BY_RARITY[item["rarity"]] for item in drops]
        total_scrap = sum(scrap_values)
        best_scrap_per_slot: dict[str, int] = {}
        for item, scrap in zip(drops, scrap_values):
            slot = str(item["slot"])
            best_scrap_per_slot[slot] = max(best_scrap_per_slot.get(slot, 0), scrap)

        xp_totals.append(total_xp)
        gold_totals.append(total_gold)
        item_counts.append(len(drops))
        scrap_all.append(total_scrap)
        scrap_keep_best_slot.append(total_scrap - sum(best_scrap_per_slot.values()))
        level_counts[resulting_level(total_xp)] += 1

    return {
        "runs": runs,
        "combat_seed": combat_seed,
        "loot_seed": loot_seed,
        "xp": xp_totals,
        "gold": gold_totals,
        "items": item_counts,
        "scrap_all": scrap_all,
        "scrap_keep_best_slot": scrap_keep_best_slot,
        "level_counts": level_counts,
    }


def report(name: str, values: list[int]) -> None:
    print(
        f"| {name} | {sum(values) / len(values):.2f} | "
        f"{percentile(values, 0.10)}–{percentile(values, 0.90)} |"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runs", type=int, default=100_000)
    parser.add_argument("--combat-seed", type=int, default=41_783)
    parser.add_argument("--loot-seed", type=int, default=41_784)
    args = parser.parse_args()
    if args.runs < 1:
        parser.error("--runs must be at least 1")

    result = simulate(args.runs, args.combat_seed, args.loot_seed)
    print(
        f"runs={result['runs']} combat_seed={result['combat_seed']} "
        f"loot_seed={result['loot_seed']}"
    )
    print("| Métrica | Média | P10–P90 |")
    print("| --- | ---: | ---: |")
    report("XP", result["xp"])
    report("Ouro", result["gold"])
    report("Itens", result["items"])
    report("Sucata: desmontar tudo", result["scrap_all"])
    report("Sucata: manter melhor por tipo runtime", result["scrap_keep_best_slot"])

    levels: Counter[int] = result["level_counts"]
    for level in sorted(levels):
        share = levels[level] / result["runs"] * 100
        print(f"Nível {level}: {share:.2f}%")

    retained_scrap = result["scrap_keep_best_slot"]
    can_upgrade = sum(value >= 4 for value in retained_scrap) / result["runs"] * 100
    print(f"P(Sucata >= 4 após manter melhor item por tipo): {can_upgrade:.2f}%")


if __name__ == "__main__":
    main()
