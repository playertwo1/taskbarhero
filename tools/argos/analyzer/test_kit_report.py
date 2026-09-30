"""Testes do relatório de kit. Uso: python -m unittest tools/argos/analyzer/test_kit_report.py"""
import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit_report  # noqa: E402


def run(build, won, level=10, kind="route", casts=None, skill_damage=None, counters=None):
    return {"kind": kind, "build": build, "build_map": {"hero_001": build, "hero_002": "marca", "hero_003": "controle"},
            "won": won, "level": level, "casts": casts or {}, "skill_damage": skill_damage or {}, "counters": counters or {},
            "damage_dealt": {"hero_001": 100.0, "hero_002": 100.0, "hero_003": 100.0}}


class KitReportTest(unittest.TestCase):
    def test_per_build_win_rate(self):
        runs = [run("guardiao", True), run("guardiao", False), run("controle", True), run("controle", True)]
        stats = kit_report.per_build(runs, "hero_001", equipped={})
        self.assertAlmostEqual(stats["guardiao"]["route_win"][10], 0.5)
        self.assertAlmostEqual(stats["controle"]["route_win"][10], 1.0)

    def test_dominance_finding(self):
        runs = [run("guardiao", True)] * 10 + [run("controle", False)] * 10
        stats = kit_report.per_build(runs, "hero_001", equipped={})
        codes = [f["code"] for f in kit_report.findings(stats, "hero_001")]
        self.assertIn("DOMINANT", codes)

    def test_dead_skill_finding_includes_signature(self):
        runs = [run("guardiao", True, casts={"skill_bas_006": 2})] * 4
        equipped = {"guardiao": ["skill_bas_006", "skill_bas_009", "skill_bas_011"]}
        stats = kit_report.per_build(runs, "hero_001", equipped=equipped)
        details = " ".join(f["detail"] for f in kit_report.findings(stats, "hero_001") if f["code"] == "DEAD_SKILL")
        self.assertIn("skill_bas_009", details)
        self.assertIn("skill_bas_011", details)
        self.assertNotIn("skill_bas_006", details)

    def test_equipped_skills_has_signature_slot(self):
        equipped = kit_report.equipped_skills("hero_001")
        for skills in equipped.values():
            self.assertEqual(len(skills), 3)
            self.assertEqual(skills[-1], "skill_bas_011")

    def test_dead_counter(self):
        runs = [run("controle", True, counters={})] * 3
        stats = kit_report.per_build(runs, "hero_001", equipped={})
        found = [f for f in kit_report.findings(stats, "hero_001") if f["code"] == "DEAD_PASSIVE"]
        self.assertTrue(found)

    def test_campaign_level_is_level_when_winning_attempt_starts(self):
        camp = {"kind": "campaign", "build": "guardiao", "build_map": {"hero_001": "guardiao", "hero_002": "marca", "hero_003": "controle"},
                "won": True, "attempts": 3, "final_level": 10, "history": [{"level": 1}, {"level": 5}, {"level": 7}]}
        stats = kit_report.per_build([camp], "hero_001", equipped={})
        self.assertEqual(stats["guardiao"]["campaign_level"], 7)

    def test_report_file(self):
        with tempfile.TemporaryDirectory() as folder:
            with open(os.path.join(folder, "runs.jsonl"), "w", encoding="utf-8") as f:
                f.write(json.dumps({"kind": "meta"}) + "\n")
                for r in [run("guardiao", True), run("controle", False)]:
                    f.write(json.dumps(r) + "\n")
            path = kit_report.write_report(folder, "hero_001")
            self.assertTrue(os.path.exists(path))
            self.assertIn("guardiao", open(path, encoding="utf-8").read())


if __name__ == "__main__":
    unittest.main()
