#!/usr/bin/env python3
"""Deterministic BALANCE-FOUNDATION-1 baseline for the SLICE-1 route.

Derives hero and enemy stats with the v0.4 formulas and compares theoretical
time-to-kill and incoming damage against the v0.4 targets. All numbers are
HIPOTESE: no AI, telegraphs, shields, heals, target selection or player input.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "economy"))
import simulate_chapter1_balance as econ  # noqa: E402  (reuses the ECON-1 parsers)

STAGES_PATH = ROOT / "data" / "stages" / "stages.json"

# SLICE_1_SCOPE.md, section 2. Order is the route order.
SLICE_ROUTE = [
    "C1_1_1_A", "C1_1_2_A", "C1_1_2_B", "C1_2_1_A", "C1_2_2_A",
    "C1_2_2_B", "C1_3_1_A", "C1_4_1_A", "C1_3_2_A", "C1_5_2_A",
]
TRIO = ("Bastião", "Flecha", "Íris")

ARCHETYPE = {  # HP, ATK, DEF, AS (ENEMY_STATS_BALANCE.md, section 2)
    "STANDARD": (0.85, 0.75, 0.75, 1.00), "HEAVY": (1.40, 0.85, 1.25, 0.70),
    "ASSASSIN": (0.55, 1.15, 0.50, 1.25), "CONTROLLER": (0.75, 0.65, 0.80, 0.80),
    "SUPPORT": (0.70, 0.55, 0.70, 0.85),
}
RANK = {  # HP, ATK, DEF, tenacity (section 3)
    "NORMAL": (1.00, 1.00, 1.00, 0), "ELITE": (2.30, 1.25, 1.15, 25),
    "MINIBOSS": (7.00, 1.55, 1.35, 50), "BOSS": (20.00, 1.80, 1.50, 100),
}
TARGET_TTK = {"NORMAL": (3, 6), "ELITE": (15, 30), "MINIBOSS": (40, 75), "BOSS": (120, 210)}
DEFENSE_K = 100.0
ENEMY_DAMAGE_SCALE = 0.50  # slice-local HIPOTESE: makes Standard Normal consume HERO_REFERENCE HP in ~25-35 s
SUSTAINED = 1.75  # HERO_REFERENCE skill/passive contribution; balance-only, not a runtime rule


def lerp(low: float, high: float, level: int) -> float:
    return low + (high - low) * (level - 1) / 99


def mitigation(defense: float, pen_pct: float = 0.0, pen_flat: float = 0.0) -> float:
    effective = max(0.0, defense * (1 - pen_pct) - pen_flat)
    return effective / (effective + DEFENSE_K)


def hero_stats(name: str, level: int) -> dict:
    row = econ.table_row(econ.HERO_BALANCE_PATH, name)
    hp, atk, dfn = (econ.pair(row[i]) for i in (2, 3, 4))
    return {
        "name": name, "hp": lerp(*hp, level), "attack": lerp(*atk, level), "defense": lerp(*dfn, level),
        "attack_speed": float(row[5]), "crit": float(row[7].rstrip("%")) / 100,
        "crit_damage": float(row[8].rstrip("×")),
    }


def reference_stats(level: int) -> dict:
    text = econ.ENEMY_BALANCE_PATH.read_text(encoding="utf-8-sig")
    m = re.search(r"HP:\s*(\d+)\s*→\s*(\d+).*?Attack:\s*(\d+)\s*→\s*(\d+).*?Defense:\s*(\d+)\s*→\s*(\d+).*?AS:\s*([\d.]+)", text, re.S)
    if not m:
        raise ValueError("Could not parse HERO_REFERENCE")
    return {
        "hp": lerp(float(m[1]), float(m[2]), level), "attack": lerp(float(m[3]), float(m[4]), level),
        "defense": lerp(float(m[5]), float(m[6]), level), "attack_speed": float(m[7]),
    }


def enemy_stats(entity: dict, level: int) -> dict:
    ident = entity["identity"]
    ref = reference_stats(level)
    a_hp, a_atk, a_def, a_as = ARCHETYPE[ident["archetype"]]
    r_hp, r_atk, r_def, tenacity = RANK[ident["rank"]]
    return {
        "id": ident["id"], "rank": ident["rank"], "archetype": ident["archetype"],
        "hp": ref["hp"] * a_hp * r_hp, "attack": ref["attack"] * a_atk * r_atk * ENEMY_DAMAGE_SCALE,
        "defense": ref["defense"] * a_def * r_def, "attack_speed": ref["attack_speed"] * a_as,
        "tenacity": tenacity,
    }


def party_dps_vs(party: list[dict], enemy: dict) -> float:
    total = 0.0
    for hero in party:
        hit = hero["attack"] * (1 - mitigation(enemy["defense"]))
        avg = hit * (1 + hero["crit"] * (hero["crit_damage"] - 1))
        total += avg * hero["attack_speed"]
    return total * SUSTAINED


def encounter_row(encounter: dict, enemies: dict, level: int, party_scale: int) -> dict:
    party = [hero_stats(n, level) for n in TRIO]
    party_hp = sum(h["hp"] for h in party)
    foes = []
    for member in encounter["members"]:
        stats = enemy_stats(enemies[member["enemy_id"]], level)
        if stats["rank"] != "NORMAL":
            stats["hp"] *= party_scale
        foes += [dict(stats) for _ in range(member["count"])]
    front = party[0]
    elapsed = damage = 0.0
    kills = []
    for i, foe in enumerate(foes):
        t = foe["hp"] / party_dps_vs(party, foe)
        alive_dps = sum(f["attack"] * (1 - mitigation(front["defense"])) * f["attack_speed"] for f in foes[i:])
        damage += alive_dps * t
        elapsed += t
        kills.append(t)
    return {"foes": foes, "ttk": elapsed, "per_enemy": kills, "damage": damage, "party_hp": party_hp,
            "front_hp": front["hp"], "level": level}


def canon_consistency() -> None:
    """ENEMY_STATS_BALANCE.md section 5: a Standard Normal should consume 100% of HERO_REFERENCE EHP in 25-35 s."""
    print("\nConsistência interna v0.4 (Standard Normal contra HERO_REFERENCE, sem cura/escudo/esquiva):")
    print("| Nível | Dano por golpe | Golpes/s | Tempo (tabela v0.4) | Tempo (fator local) | Alvo v0.4 |")
    print("| ---: | ---: | ---: | ---: | ---: | --- |")
    for level in (1, 5, 50, 100):
        ref = reference_stats(level)
        a_hp, a_atk, a_def, a_as = ARCHETYPE["STANDARD"]
        atk, aspd = ref["attack"] * a_atk, ref["attack_speed"] * a_as
        dmg = atk * (1 - mitigation(ref["defense"]))
        scaled = dmg * ENEMY_DAMAGE_SCALE
        print(f"| {level} | {dmg:.2f} | {aspd:.2f} | {ref['hp'] / (dmg * aspd):.1f} s | com fator {ENEMY_DAMAGE_SCALE:g}: {ref['hp'] / (scaled * aspd):.1f} s | 25–35 s |")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--party-scale", type=int, default=3,
                        help="HP multiplier for ELITE/MINIBOSS/BOSS entities (party size); use 1 to disable")
    args = parser.parse_args()

    plan = econ.load(econ.PLAN_PATH)
    enemies = {e["identity"]["id"]: e for e in econ.load(econ.ENEMIES_PATH)["enemies"]}
    stages = econ.load(STAGES_PATH)
    plan_by_id = {e["id"]: e for e in plan["encounters"]}
    assert set(SLICE_ROUTE) <= set(plan_by_id), "Slice route references an unknown encounter"

    print(f"party_scale={args.party_scale} (HP x for ELITE/MINIBOSS/BOSS); sustained x{SUSTAINED}; defense K={DEFENSE_K:g}")
    print("| Encontro | Nível | Tipo | TTK total | Faixa v0.4 (por alvo principal) | Dano à party durante o TTK | HP da party | Dano/HP party |")
    print("| --- | ---: | --- | ---: | --- | ---: | ---: | ---: |")
    for enc_id in SLICE_ROUTE:
        enc = plan_by_id[enc_id]
        stage = int(enc_id.split("_")[1])
        level = int(stages[stage - 1]["min_level"])
        row = encounter_row(enc, enemies, level, args.party_scale)
        main_rank = enc["kind"]
        lo, hi = TARGET_TTK[main_rank]
        main_t = max(row["per_enemy"]) if main_rank != "NORMAL" else row["ttk"] / len(row["foes"])
        flag = "dentro" if lo <= main_t <= hi else ("abaixo" if main_t < lo else "acima")
        print(f"| {enc_id} {enc['name']} | {level} | {main_rank} | {row['ttk']:.1f} s | {lo}–{hi} s: {main_t:.1f} s ({flag}) "
              f"| {row['damage']:.0f} | {row['party_hp']:.0f} | {row['damage'] / row['party_hp']:.0%} |")

    canon_consistency()


if __name__ == "__main__":
    main()
