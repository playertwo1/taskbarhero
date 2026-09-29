#!/usr/bin/env python3
"""Exploratory, seeded Chapter 1 sustain comparison; never runtime balance data.

Uses the v0.4 hero/enemy tables and the SLICE-1 route via slice_baseline.py.
"scale" multiplies the original v0.4 enemy attack (0.40 means 40% of it).
Target weights, run DPS variation, and hit variation are experimental inputs,
not observations of the Godot AI. The x1.75 sustained DPS approximation is
charged 8% per substituted support skill. Enemy skills, phase mechanics, gear,
position, control, Stagger, and Perfect Block are not simulated.
No HP is restored between encounters. Shields expire between encounters.
"""

from __future__ import annotations

import argparse
import random
from dataclasses import dataclass

import slice_baseline as base


@dataclass(frozen=True)
class Scenario:
    name: str
    heal: bool = False
    regen: bool = False
    shield: bool = False
    party_shield: bool = False
    guard: bool = False
    offense: float = 1.0


# Skill substitutions cost offense because the baseline x1.75 includes skills.
# Each support slot is charged 8% of the modeled sustained DPS; guard is an
# existing Bastião defensive slot and also receives this cost for consistency.
SCENARIOS = (
    Scenario("sem_sustain"),
    Scenario("cura", heal=True, offense=.92),
    Scenario("regen", regen=True, offense=.92),
    Scenario("escudo", shield=True, offense=.92),
    Scenario("guarda_cura", heal=True, guard=True, offense=.84),
    Scenario("escudo_cura", heal=True, shield=True, offense=.84),
    Scenario("escudo_party_cura", heal=True, party_shield=True, offense=.84),
    Scenario("escudo_party_regen", regen=True, party_shield=True, offense=.84),
    Scenario("escudo_party_guarda", guard=True, party_shield=True, offense=.84),
    Scenario("escudo_regen", regen=True, shield=True, offense=.84),
    Scenario("cura_regen", heal=True, regen=True, offense=.84),
    Scenario("escudo_cura_regen", heal=True, regen=True, shield=True, offense=.76),
)


def load_route() -> list[list[dict]]:
    plan = base.econ.load(base.econ.PLAN_PATH)
    encounters = {e["id"]: e for e in plan["encounters"]}
    enemies = {e["identity"]["id"]: e for e in base.econ.load(base.econ.ENEMIES_PATH)["enemies"]}
    route = []
    for enc_id in base.SLICE_ROUTE:
        foes = []
        for member in encounters[enc_id]["members"]:
            stats = base.enemy_stats(enemies[member["enemy_id"]], 3)
            if stats["rank"] != "NORMAL":
                stats["hp"] *= 3
            foes.extend(dict(stats) for _ in range(member["count"]))
        route.append(foes)
    return route


def choose_target(rng: random.Random, hp: list[float], weights: tuple[float, ...]) -> int:
    active = [i for i in range(3) if hp[i] > 0]
    total = sum(weights[i] for i in active)
    pick = rng.random() * total
    for i in active:
        pick -= weights[i]
        if pick <= 0:
            return i
    return active[-1]


def weakest(hp: list[float], maximum: list[float], condition: float) -> int | None:
    active = [i for i in range(3) if hp[i] > 0 and hp[i] / maximum[i] < condition]
    return min(active, key=lambda i: hp[i] / maximum[i]) if active else None


def simulate(
    seed: int, route: list[list[dict]], scenario: Scenario, scale: float,
    weights: tuple[float, float, float], boss_weights: tuple[float, float, float], variance: float,
    party_shield_pct: float, shield_cooldown: float, heal_coeff: float,
    regen_pct: float, regen_duration: float,
    gear_bp: float, gear_profile: str, offense_boost: float,
    control_suppression: float, life_steal: float,
) -> tuple[int, list[float], float, float, float, float, float]:
    rng = random.Random(seed)
    heroes = [base.hero_stats(n, 3) for n in base.TRIO]
    # BP translations are from STAT_BUDGETS.md; an entire same-rarity set is
    # an upper-bound sensitivity case, not a guaranteed Chapter 1 inventory.
    shares = {
        "none": (0.0, 0.0, 0.0, 0.0),
        "offense": (.72, 0.0, 0.0, .28),
        "balanced": (.32, .36, .32, 0.0),
        "defense": (0.0, .72, .28, 0.0),
    }[gear_profile]
    reference = base.reference_stats(3)
    for hero in heroes:
        hero["attack"] += gear_bp * shares[0] * .01 * reference["attack"]
        hero["hp"] += gear_bp * shares[1] * .01 * reference["hp"]
        hero["defense"] += gear_bp * shares[2] * .01 * reference["defense"]
        hero["crit"] = min(1.0, hero["crit"] + gear_bp * shares[3] * .0035)
    maximum = [h["hp"] for h in heroes]
    hp = maximum.copy()
    iris_atk = heroes[2]["attack"]
    party_damage_factor = rng.uniform(1 - variance, 1 + variance)
    total_time = healing = absorbed = 0.0
    boss_entry_hp = 0.0

    for encounter_no, original in enumerate(route, 1):
        if encounter_no == 10:
            boss_entry_hp = sum(hp) / sum(maximum)
        # The reference baseline has scale=.50 baked into enemy_stats().
        foes = [dict(e, hp_left=e["hp"], next_hit=rng.random() / e["attack_speed"]) for e in original]
        shield = [0.0] * 3
        regen_end = [0.0] * 3
        next_cast = {"heal": 0.0, "regen": 0.0, "shield": 0.0, "guard": 0.0}
        guard_end = 0.0
        t = 0.0
        while foes and t < 600:
            dt = .25
            # Damage to one target at a time. Dead heroes cease contributing.
            individual_dps = [
                h["attack"] * h["attack_speed"]
                * (1 + h["crit"] * (h["crit_damage"] - 1))
                * (1 - base.mitigation(foes[0]["defense"]))
                * base.SUSTAINED * scenario.offense * party_damage_factor * offense_boost
                if hp[i] > 0 else 0.0
                for i, h in enumerate(heroes)
            ]
            dps = sum(individual_dps)
            foes[0]["hp_left"] -= dps * dt
            if life_steal and hp[1] > 0:
                amount = min(maximum[1] - hp[1], individual_dps[1] * life_steal * dt)
                hp[1] += amount
                healing += amount
            if foes[0]["hp_left"] <= 0:
                foes.pop(0)
            if not foes:
                t += dt
                break

            if scenario.guard and hp[0] > 0 and t >= next_cast["guard"]:
                guard_end = t + 5.0   # Fortaleza: 40% reduction for 5/20 s.
                next_cast["guard"] = t + 20.0
            if scenario.party_shield and hp[0] > 0 and t >= next_cast["shield"]:
                for target in range(3):
                    if hp[target] > 0:
                        shield[target] = min(.5 * maximum[target], shield[target] + party_shield_pct * maximum[target])
                next_cast["shield"] = t + shield_cooldown
            if scenario.shield and hp[0] > 0 and t >= next_cast["shield"]:
                target = weakest(hp, maximum, 1.01)
                if target is not None:
                    # Barrier: 20% of recipient maximum HP, cap 50%.
                    shield[target] = min(.5 * maximum[target], shield[target] + .2 * maximum[target])
                    next_cast["shield"] = t + shield_cooldown
            if scenario.heal and hp[2] > 0 and t >= next_cast["heal"]:
                target = weakest(hp, maximum, .80)
                if target is not None:
                    amount = min(maximum[target] - hp[target], heal_coeff * iris_atk)
                    hp[target] += amount
                    healing += amount
                    next_cast["heal"] = t + 10.0
            if scenario.regen and hp[2] > 0 and t >= next_cast["regen"]:
                target = weakest(hp, maximum, .90)
                if target is not None:
                    regen_end[target] = t + regen_duration
                    next_cast["regen"] = t + 12.0
            for i in range(3):
                if hp[i] > 0 and regen_end[i] > t:
                    amount = min(maximum[i] - hp[i], regen_pct * maximum[i] * dt)
                    hp[i] += amount
                    healing += amount

            for foe in foes:
                if not any(h > 0 for h in hp):
                    break
                if t + 1e-9 < foe["next_hit"]:
                    continue
                foe["next_hit"] += 1 / foe["attack_speed"]
                # Proxy: a cancelled attack represents CC/Stagger/slow uptime.
                # Tenacity shortens control duration; actual application rate is unknown.
                if rng.random() < control_suppression / (1 + foe["tenacity"] / 100):
                    continue
                target = choose_target(rng, hp, boss_weights if foe["rank"] == "BOSS" else weights)
                damage = foe["attack"] * (scale / .5)
                damage *= 1 - base.mitigation(heroes[target]["defense"])
                damage *= rng.uniform(1 - variance, 1 + variance)
                if scenario.guard and target == 0 and t < guard_end:
                    damage *= .6
                used = min(shield[target], damage)
                shield[target] -= used
                absorbed += used
                hp[target] = max(0.0, hp[target] - (damage - used))
            t += dt
            if not any(h > 0 for h in hp):
                return encounter_no, hp, total_time + t, healing, absorbed, party_damage_factor, boss_entry_hp
        total_time += t
        if foes:  # A 600 s fight is treated as a loss.
            return encounter_no, hp, total_time, healing, absorbed, party_damage_factor, boss_entry_hp
    return 11, hp, total_time, healing, absorbed, party_damage_factor, boss_entry_hp


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runs", type=int, default=500)
    parser.add_argument("--seed", type=int, default=4172)
    parser.add_argument("--scales", type=float, nargs="+", default=[.30, .35, .40, .50])
    parser.add_argument("--scenarios", nargs="+", default=[s.name for s in SCENARIOS],
                        choices=[s.name for s in SCENARIOS])
    parser.add_argument("--weights", type=float, nargs=3, default=[.70, .20, .10],
                        metavar=("BASTIAO", "FLECHA", "IRIS"))
    parser.add_argument("--boss-weights", type=float, nargs=3,
                        metavar=("BASTIAO", "FLECHA", "IRIS"),
                        help="Target share for boss attacks; defaults to --weights")
    parser.add_argument("--variance", type=float, default=.10,
                        help="Uniform +/- variation in run DPS and each incoming hit")
    parser.add_argument("--party-shield-pct", type=float, default=.15)
    parser.add_argument("--shield-cooldown", type=float, default=12.0)
    parser.add_argument("--heal-coeff", type=float, default=1.6)
    parser.add_argument("--regen-pct", type=float, default=.03)
    parser.add_argument("--regen-duration", type=float, default=5.0)
    parser.add_argument("--gear-bp", type=float, default=0.0,
                        help="Weighted BP of a full same-rarity set per hero; 12/19/25 are v0.4 approximations")
    parser.add_argument("--gear-profile", choices=["none", "offense", "balanced", "defense"], default="none")
    parser.add_argument("--offense-boost", type=float, default=1.0,
                        help="Extra party DPS hypothesis for rank/passive/mark sensitivity, 1.0 = none")
    parser.add_argument("--control-suppression", type=float, default=0.0,
                        help="Proxy fraction of cancelled normal attacks; diminished by rank tenacity")
    parser.add_argument("--life-steal", type=float, default=0.0,
                        help="Flecha self-heal fraction of effective damage; gear cap in v0.4 is 25%%")
    args = parser.parse_args()
    if (args.runs < 1 or min(args.weights) < 0 or sum(args.weights) <= 0
            or (args.boss_weights and (min(args.boss_weights) < 0 or sum(args.boss_weights) <= 0))
            or not 0 <= args.variance < 1 or not 0 <= args.party_shield_pct <= .5
            or args.shield_cooldown <= 0 or args.heal_coeff < 0
            or args.regen_pct < 0 or args.regen_duration < 0 or args.gear_bp < 0
            or args.offense_boost <= 0 or not 0 <= args.control_suppression <= 1
            or not 0 <= args.life_steal <= .25):
        parser.error("invalid runs, weights, or variance")
    weights = tuple(x / sum(args.weights) for x in args.weights)
    boss_weights = tuple(x / sum(args.boss_weights) for x in args.boss_weights) if args.boss_weights else weights
    route = load_route()
    print(f"level=3 runs={args.runs} seed={args.seed} weights={weights} boss_weights={boss_weights} variance=+/-{args.variance:.0%} party_shield={args.party_shield_pct:.1%}/{args.shield_cooldown:g}s heal_coeff={args.heal_coeff:g} regen={args.regen_pct:.1%}/s x {args.regen_duration:g}s gear={args.gear_bp:g}BP/{args.gear_profile} offense={args.offense_boost:g} control={args.control_suppression:.0%} life_steal={args.life_steal:.0%}")
    print("scale,scenario,wins,win_pct,reach_boss_pct,median_boss_entry_hp_pct,median_win_hp_pct,median_time_s,mean_heal,mean_shield_absorb")
    for scale in args.scales:
        for scenario in (s for s in SCENARIOS if s.name in args.scenarios):
            outcomes = [simulate(args.seed + i, route, scenario, scale, weights, boss_weights,
                                 args.variance, args.party_shield_pct, args.shield_cooldown, args.heal_coeff,
                                 args.regen_pct, args.regen_duration, args.gear_bp, args.gear_profile,
                                 args.offense_boost, args.control_suppression, args.life_steal)
                        for i in range(args.runs)]
            wins = [o for o in outcomes if o[0] == 11]
            reaches = [o for o in outcomes if o[0] >= 10]
            def median(values: list[float]) -> float:
                sorted_values = sorted(values)
                return sorted_values[len(sorted_values) // 2] if sorted_values else 0.0
            max_hp = sum(base.hero_stats(n, 3)["hp"] for n in base.TRIO)
            print(f"{scale:.3f},{scenario.name},{len(wins)},{len(wins)/args.runs:.1%},"
                  f"{len(reaches)/args.runs:.1%},"
                  f"{median([o[6] for o in reaches]):.1%},"
                  f"{median([sum(o[1])/max_hp for o in wins]):.1%},"
                  f"{median([o[2] for o in wins]):.1f},"
                  f"{sum(o[3] for o in outcomes)/args.runs:.1f},"
                  f"{sum(o[4] for o in outcomes)/args.runs:.1f}")


if __name__ == "__main__":
    main()
