"""Testes do Argos Analyst com execuções sintéticas. Uso: python -m unittest tools/argos/analyzer/test_analyze.py"""
import json
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import analyze  # noqa: E402

RULES = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "rules_slice.json"), encoding="utf-8"))


def route(build, level, won, violations=()):
    return {"kind": "route", "build": build, "level": level, "seed": 1, "won": won, "lost_at": "" if won else "c1_3_2_a",
            "nodes": {}, "healing": 0.0, "violations": list(violations)}


def segment(build, level, seg, ttk):
    return {"kind": "segment", "build": build, "level": level, "seed": 1, "segment": seg, "won": True,
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

    def test_viable_paths_need_one_without_heal(self):
        only_heal = [route("x/y/lumen", 5, True), route("x/y/arcano", 5, False)]
        self.assertIn("Poucos caminhos viáveis", titles(only_heal))
        two_paths = [route("x/y/lumen", 5, True), route("x/y/controle", 5, True)]
        self.assertNotIn("Poucos caminhos viáveis", titles(two_paths))

    def test_dominance(self):
        runs = [route("x/y/lumen", 5, True), route("x/y/arcano", 5, False), route("x/y/controle", 5, False)]
        self.assertIn("Dominância no nível 5", titles(runs))


if __name__ == "__main__":
    unittest.main()
