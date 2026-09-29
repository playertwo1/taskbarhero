#!/usr/bin/env python3
"""Export a reproducible comparison of all legal Chapter 1 item variants.

This reads the design catalog and the stat-allocation proposal. It does not
write runtime data or validate combat balance. Defaults compare items at IP 20,
item level 10; actual drop IP/level depend on the loot source.
"""

from __future__ import annotations

import argparse
import csv
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CATALOG = ROOT / "documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md"
ALLOCATIONS = ROOT / "docs/04_content/items/CHAPTER_01_ITEM_STATS_PROPOSAL.md"
DEFAULT_OUTPUT = ROOT / "docs/04_content/items/CHAPTER_01_ITEM_VARIANTS_IP20_L10.csv"
RARITIES = ("COMUM", "INCOMUM", "RARO", "EPICO", "RELIQUIA", "MEMORIA")
BP = dict(zip(RARITIES, (2, 3, 4, 5, 6, 6)))
SLOTS = {"W": 1.2, "S": 1.0, "A": 1.2, "R": .9, "E": 1.0}
RESERVE = dict(zip(RARITIES, (0, .10, .20, .35, .50, .60)))
STAT_NAMES = ("attack", "hp", "defense", "attack_speed_pct", "crit_pp", "skill_haste", "tenacity")


def normalized(value: str) -> str:
    value = unicodedata.normalize("NFKD", value)
    return "".join(ch for ch in value if not unicodedata.combining(ch)).upper()


def allowed(value: str) -> list[str]:
    value = normalized(value.replace("–", "-"))
    ends = [part.strip() for part in value.split("-")]
    if any(end not in RARITIES for end in ends) or len(ends) not in (1, 2):
        raise ValueError(f"Unknown rarity range: {value}")
    if len(ends) == 2:
        return list(RARITIES[RARITIES.index(ends[0]): RARITIES.index(ends[1]) + 1])
    return ends


def rows(path: Path) -> list[list[str]]:
    return [[cell.strip().strip("`") for cell in line.split("|")[1:-1]]
            for line in path.read_text(encoding="utf-8").splitlines()
            if line.startswith("| ") and re.search(r"ITEM_[WSARE]_\d{3}", line)]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ip", type=int, default=20)
    parser.add_argument("--item-level", type=int, default=10)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    if not 1 <= args.ip <= 100 or not 1 <= args.item_level <= 100:
        parser.error("IP and item level must be in 1..100")

    catalog = {row[0]: row for row in rows(CATALOG) if re.fullmatch(r"ITEM_[WSARE]_\d{3}", row[0])}
    allocation = {row[0]: row for row in rows(ALLOCATIONS) if re.fullmatch(r"ITEM_[WSARE]_\d{3}", row[0])}
    if len(catalog) != 33 or len(allocation) != 33 or set(catalog) != set(allocation):
        raise ValueError(f"Catalog/stats must have same 33 IDs: {set(catalog) ^ set(allocation)}")

    ref_attack = 12 + 38 * (args.item_level - 1) / 99
    ref_hp = 115 + 355 * (args.item_level - 1) / 99
    ref_defense = 9 + 27 * (args.item_level - 1) / 99
    factor = .60 + .80 * args.ip / 100
    result = []
    for item_id, cat in catalog.items():
        weights = [float(cell.rstrip("%")) / 100 if cell.endswith("%") else 0.0
                   for cell in allocation[item_id][2:9]]
        if len(weights) != 7 or abs(sum(weights) - 1.0) > 1e-8:
            raise ValueError(f"Invalid stat fractions: {item_id}: {weights}")
        for rarity in allowed(cat[4]):
            gross = BP[rarity] * SLOTS[item_id.split("_")[1]] * factor
            reserved = gross * RESERVE[rarity]
            stat_bp = gross - reserved
            values = [stat_bp * weights[0] * .01 * ref_attack,
                      stat_bp * weights[1] * .01 * ref_hp,
                      stat_bp * weights[2] * .01 * ref_defense,
                      stat_bp * weights[3] * .60,
                      stat_bp * weights[4] * .35,
                      stat_bp * weights[5] * 1.20,
                      stat_bp * weights[6] * 1.50]
            result.append({"item_id": item_id, "rarity": rarity,
                           "item_power": args.ip, "item_level": args.item_level,
                           "gross_bp": round(gross, 4), "effect_reserved_bp": round(reserved, 4),
                           **{name: round(value, 4) for name, value in zip(STAT_NAMES, values)}})
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=result[0].keys())
        writer.writeheader()
        writer.writerows(result)
    print(f"{len(catalog)} templates; {len(result)} legal variants -> {args.output}")


if __name__ == "__main__":
    main()
