"""Testes do Argos Analyst com execuções sintéticas. Uso: python -m unittest tools/argos/analyzer/test_analyze.py"""
import json
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import analyze  # noqa: E402

RULES = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "rules_slice.json"), encoding="utf-8"))


def route(build, level, won, violations=(), build_map=None):
    return {"kind": "route", "build": build, "level": level, "seed": 1, "won": won, "lost_at": "" if won else "c1_3_2_a",
            "build_map": build_map or {}, "nodes": {}, "healing": 0.0, "violations": list(violations)}


def segment(build, level, seg, ttk, content_level=None):
    return {"kind": "segment", "build": build, "level": level, "seed": 1, "segment": seg, "won": True,
            "content_level": level if content_level is None else content_level,
            "nodes": {"n": {"ttk": ttk, "party_hp_pct": 50.0}}, "violations": []}


def titles(runs):
    return [f["title"] for f in analyze.evaluate(analyze.summarize(runs), RULES)]


class AnalyzeTest(unittest.TestCase):
    def test_violation_becomes_bug(self):
        findings = analyze.evaluate(analyze.summarize([route("a/b/lumen", 5, True, ["xp_mismatch"])]), RULES)
        bug = [f for f in findings if f["type"] == "BUG"]
        self.assertEqual(bug[0]["severity"], "CRITICAL")

    def test_boss_ttk_out_of_range(self):
        self.assertIn("TTK de guardiao fora de 120–210 s", titles([segment("a/b/c", 5, "guardiao", 260.0)]))
        self.assertNotIn("TTK de guardiao fora de 120–210 s", titles([segment("a/b/c", 5, "guardiao", 150.0)]))

    def test_ttk_rule_requires_equivalent_content_level(self):
        runs = [segment("a/b/c", 12, "elite", 10.0, content_level=3)]
        self.assertNotIn("TTK de elite fora de 15–30 s", titles(runs))

    def test_viable_paths_need_one_without_heal(self):
        only_heal = [route("x/y/lumen", 10, True, build_map={"hero_003": "lumen"}),
                     route("x/y/arcano", 10, False, build_map={"hero_003": "arcano"})]
        self.assertIn("Poucos caminhos viáveis", titles(only_heal))
        two_paths = [route("x/y/lumen", 10, True, build_map={"hero_003": "lumen"}),
                     route("x/y/controle", 10, True, build_map={"hero_003": "controle"})]
        self.assertNotIn("Poucos caminhos viáveis", titles(two_paths))

    def test_viable_paths_are_not_evaluated_without_level_coverage(self):
        findings = analyze.evaluate(analyze.summarize([
            route("x/y/lumen", 5, True, build_map={"hero_003": "lumen"})
        ]), RULES)
        self.assertIn("Regra de caminhos não avaliada", [f["title"] for f in findings])
        self.assertNotIn("Poucos caminhos viáveis", [f["title"] for f in findings])

    def test_dominance(self):
        runs = [route("x/y/lumen", 5, True), route("x/y/arcano", 5, False), route("x/y/controle", 5, False)]
        self.assertIn("Dominância no nível 5", titles(runs))


def campaign_with_events(build, offered, resolved, loot=None):
    hist = [{"level": 10, "won": True, "furthest": 11, "xp": 100, "violations": [], "gold": 0, "residue": 6,
             "items_dropped": 2, "equipped_after": 3,
             "events": {"offered": offered, "resolved": resolved, "loot_by_rarity": loot or {"Comum": 2}}}]
    return {"kind": "campaign", "build": build, "seed": 1, "won": True, "attempts": 1, "final_level": 10, "history": hist,
            "loot": True, "run_layer": True, "build_map": {}, "totals": {"gold": 0, "residue": 6, "items": 2}}


class RunLayerTest(unittest.TestCase):
    def test_event_rows_count_offers_and_choices(self):
        runs = [
            campaign_with_events("a/b/c", {"event_c1_001": 1}, {"event_c1_001:heal": 1}),
            campaign_with_events("a/b/c", {"event_c1_001": 1, "event_c1_raiz_oca": 1}, {"event_c1_001:sacrifice": 1, "event_c1_raiz_oca:open": 1}),
        ]
        rows = {r["event"]: r for r in analyze.summarize(runs)["run_layer"]["events"]}
        self.assertEqual(rows["event_c1_001"]["offered"], 2)
        self.assertEqual(rows["event_c1_001"]["choices"], {"heal": 1, "sacrifice": 1})
        self.assertEqual(rows["event_c1_raiz_oca"]["offered"], 1)
        self.assertAlmostEqual(rows["event_c1_001"]["per_100_attempts"], 100.0)

    def test_loot_by_rarity_is_summed(self):
        runs = [campaign_with_events("a/b/c", {}, {}, {"Comum": 2, "Raro": 1}), campaign_with_events("a/b/c", {}, {}, {"Comum": 1})]
        loot = analyze.summarize(runs)["run_layer"]["loot_by_rarity"]
        self.assertEqual(loot, {"Comum": 3, "Raro": 1})

    def test_no_run_layer_data_is_empty(self):
        self.assertEqual(analyze.summarize([route("a/b/c", 5, True)])["run_layer"], {"events": [], "loot_by_rarity": {}})

    def test_event_choices_are_separated_by_variant(self):
        runs = [
            campaign_with_events("poco_curar · a/b/c", {"event_c1_001": 1}, {"event_c1_001:heal": 1}),
            campaign_with_events("poco_sacrificar · a/b/c", {"event_c1_001": 1}, {"event_c1_001:sacrifice": 1}),
        ]
        rows = {(r["variant"], r["event"]): r for r in analyze.summarize(runs)["run_layer"]["events"]}
        self.assertEqual(rows[("poco_curar", "event_c1_001")]["choices"], {"heal": 1})
        self.assertEqual(rows[("poco_sacrificar", "event_c1_001")]["choices"], {"sacrifice": 1})
        self.assertEqual(rows[("poco_curar", "event_c1_001")]["per_100_attempts"], 100.0)


def profile_campaign(profile, won, attempts, first_win=0, abandoned=False, level=11, items=8, save_bytes=2048, violations=()):
    return {"kind": "campaign", "build": f"{profile} · a/b/c", "build_map": {}, "seed": 1, "won": won, "attempts": attempts,
            "final_level": level, "history": [{"level": level, "events": None, "violations": [], "gold": 0, "residue": 0, "items_dropped": 0, "equipped_after": 0}] * attempts, "profile": profile,
            "first_win_attempt": first_win, "abandoned": abandoned, "items_held": items, "save_bytes": save_bytes,
            "violations": list(violations), "totals": {"residue": 0, "items": 0}, "loot": True}


def fuzz_run(profile, accepted, refused, violations=()):
    return {"kind": "fuzz", "build": "fuzz", "seed": 1, "profile": profile, "accepted": accepted, "refused": refused,
            "violations": list(violations)}


class ProfileTest(unittest.TestCase):
    def test_inventory_dupe_is_a_critical_exploit(self):
        findings = analyze.evaluate(analyze.summarize([fuzz_run("exploit_hunter", 10, 5, ["uid_duplicated"])]), RULES)
        found = [f for f in findings if f["title"] == "Oráculo violado: uid_duplicated"]
        self.assertEqual((found[0]["type"], found[0]["severity"]), ("EXPLOIT", "CRITICAL"))

    def test_plain_oracle_stays_a_bug(self):
        findings = analyze.evaluate(analyze.summarize([fuzz_run("edge_case", 1, 0, ["non_finite_number"])]), RULES)
        found = [f for f in findings if f["title"] == "Oráculo violado: non_finite_number"]
        self.assertEqual((found[0]["type"], found[0]["severity"]), ("BUG", "HIGH"))

    def test_profile_rows_summarize_each_profile(self):
        runs = [profile_campaign("beginner", True, 5, first_win=5), profile_campaign("beginner", False, 6, abandoned=True),
                fuzz_run("exploit_hunter", 30, 70, ["favorite_recycled"])]
        rows = {r["profile"]: r for r in analyze.summarize(runs)["profiles"]}
        self.assertEqual(rows["beginner"]["campaigns"], 2)
        self.assertAlmostEqual(rows["beginner"]["win_rate"], 0.5)
        self.assertAlmostEqual(rows["beginner"]["abandon_rate"], 0.5)
        self.assertEqual(rows["beginner"]["first_win_attempt"], 5)
        self.assertEqual(rows["exploit_hunter"]["fuzz_actions"], 100)
        self.assertEqual(rows["exploit_hunter"]["fuzz_refused"], 70)
        self.assertEqual(rows["exploit_hunter"]["violations"], {"favorite_recycled": 1})

    def test_profile_campaigns_do_not_get_pacing_findings(self):
        titles_found = titles([profile_campaign("chaos", True, 12, first_win=12, level=30)])
        self.assertFalse([t for t in titles_found if t.startswith("Vence ")])

    def test_profiles_are_absent_without_profile_runs(self):
        self.assertEqual(analyze.summarize([route("a/b/c", 5, True)])["profiles"], [])


if __name__ == "__main__":
    unittest.main()
