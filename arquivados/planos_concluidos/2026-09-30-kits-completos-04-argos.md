# Kits completos — Plano 04: validação de ~3000 runs no Argos e ajuste

> **Para agentes:** SUB-SKILL OBRIGATÓRIA: use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans. Os passos usam checkbox (`- [ ]`). **Pré-requisito:** Plano 00 concluído e pelo menos um dos planos 01–03 integrado (os cenários de foco de heróis ainda não integrados podem ser pulados).

**Meta:** rodar ≈3000 execuções do Argos sobre os kits novos (≈1000 por herói), medir viabilidade, dominância, uso de skills e disparo das passivas novas, e **ajustar somente os números introduzidos nos planos 01–03** até os critérios de aceite passarem — ou registrar o achado para decisão de Rafael.

**Arquitetura:** três cenários de **foco** (`kits_focus_bastiao|flecha|iris`): variam todas as builds de um herói e fixam os outros dois numa party de referência viável. O Argos passa a registrar dano por skill e contadores dos eventos de kit; um relatório novo (`kit_report.py`) transforma o `runs.jsonl` em tabelas e achados por herói. Um laço curto de ajuste (máx. 3 números por iteração, máx. 5 iterações por herói) registra hipótese, mudança e resultado.

**Tecnologias:** Argos (`python tools/argos/run.py --scenario <id>`), GDScript (`tools/argos/simulator/combat/argos_sim.gd`), Python (biblioteca padrão) para o relatório.

**Spec:** [ARGOS_SOUL](../../tools/argos/ARGOS_SOUL.md), [README do Argos](../../tools/argos/README.md), [rules_slice.json](../../tools/argos/analyzer/rules_slice.json), [v1 · perfil do Capítulo 1](../../docs/06_balance/v1/capitulos/CAPITULO_01.md), [BALANCE_FINDINGS](../../docs/08_qa/BALANCE_FINDINGS.md).

## Restrições globais

Todas as do [Plano 00](2026-09-30-kits-completos-00-fundacao.md#restrições-globais). Adicionais, vindas do AGENTS.md:

- Resultado do Argos é **simulação determinística, não playtest**: não concluir diversão nem declarar "balanceado". Registrar o commit do relatório como evidência.
- Leia só o `REPORT.md` e o relatório de kit; abra `runs.jsonl` apenas para investigar um achado específico.
- Achado `BUG` (violação de oráculo) é defeito a corrigir no código. Achados `BALANCE`/`PACING` vão para `docs/08_qa/BALANCE_FINDINGS.md` com hipótese e proposta.
- **Não** alterar `rules_slice.json`, `enemy_damage_scale`, dados de inimigos, números de skills/passivas que já existiam antes dos planos 01–03, nem `/data` só para medir. Cenário hipotético = cenário com `variants`/`overrides` em `tools/argos/simulator/combat/scenarios/`.
- **Alavancas permitidas no ajuste:** apenas parâmetros das linhas **novas** (skills 010/011 do Bastião; 010/011 da Flecha; 006 da Íris; as passivas/Traits novos; seus `unlock_level`; blocos `guard`). Tudo com `"status": "HIPOTESE"`.
- Cada ajuste é registrado no log (Tarefa 6) **antes** de reexecutar.

## Contagem de execuções

Por combinação de builds o Argos faz `seeds × (3 níveis × (1 rota + 3 segmentos)) + seeds campanhas` = `13 × seeds` execuções (confere com o baseline: 18 combinações × 6 sementes × 13 = 1404).

| Cenário | Builds do herói em foco | Sementes | Execuções |
| --- | --- | --- | --- |
| `kits_focus_bastiao` | 4 (`guardiao`, `retaliacao`, `retaliacao_tele`, `controle`) | 20 | 4 × 13 × 20 = **1040** |
| `kits_focus_flecha` | 3 (`critico`, `marca`, `velocidade`) | 26 | 3 × 13 × 26 = **1014** |
| `kits_focus_iris` | 3 (`arcano`, `controle`, `lumen`) | 26 | 3 × 13 × 26 = **1014** |
| **Total** | | | **3068** |

A Signature é o 3º slot fixo de cada herói (decisão de Rafael, 2026-09-30): não há variantes `_sig`. Para medir a Signature isoladamente, o `kit_report` usa `skill_damage` e `casts` da própria skill.

Party de referência dos outros dois heróis: `hero_001: guardiao`, `hero_002: marca`, `hero_003: controle` (a combinação "Guardião" do Hub: sem cura obrigatória).

## Estrutura de arquivos

- Create `tools/argos/simulator/combat/scenarios/kits_focus_bastiao.json`, `kits_focus_flecha.json`, `kits_focus_iris.json`.
- Modify `tools/argos/simulator/combat/argos_sim.gd` — `skill_damage` e `counters` no registro.
- Create `tools/argos/analyzer/kit_report.py`, `tools/argos/analyzer/test_kit_report.py`.
- Create `docs/08_qa/KITS_TUNING_LOG.md`, `docs/08_qa/KITS_VALIDATION_2026-09-30.md`.
- Modify `docs/08_qa/BALANCE_FINDINGS.md`, `ROADMAP.md` (registro de estado).

---

### Tarefa 1: Cenários de foco

**Files:** Create os três JSON em `tools/argos/simulator/combat/scenarios/`.

- [ ] **Step 1: `kits_focus_bastiao.json`**

```json
{
  "id": "kits_focus_bastiao",
  "chapter_id": "CHAPTER_01",
  "party": ["hero_001", "hero_002", "hero_003"],
  "description": "Foco no Bastião: 4 builds contra a party de referência (Flecha marca, Íris controle). 20 sementes × 13 execuções por combinação = 1040. Kits completos, 2026-09-30.",
  "seeds": 20,
  "levels": [8, 10, 12],
  "builds": {
    "hero_001": ["guardiao", "retaliacao", "retaliacao_tele", "controle"],
    "hero_002": ["marca"],
    "hero_003": ["controle"]
  },
  "modes": ["route", "segments", "campaign"],
  "campaign": {"start_level": 1, "max_attempts": 16, "loot": true},
  "rank_milestones": [3, 5, 7, 9, 11, 13, 15, 17, 19],
  "max_time": 3600,
  "stuck_seconds": 30
}
```

- [ ] **Step 2: `kits_focus_flecha.json`** — igual, trocando `id`, `description` ("Foco na Flecha: 6 builds… 13 sementes = 1014"), `seeds: 26` e:

```json
  "builds": {
    "hero_001": ["guardiao"],
    "hero_002": ["critico", "marca", "velocidade"],
    "hero_003": ["controle"]
  },
```

- [ ] **Step 3: `kits_focus_iris.json`** — igual, `seeds: 26` e:

```json
  "builds": {
    "hero_001": ["guardiao"],
    "hero_002": ["marca"],
    "hero_003": ["arcano", "controle", "lumen"]
  },
```

- [ ] **Step 4: Verificar contagem (com os builds já integrados)**

Run: `python tools/argos/run.py --scenario kits_focus_iris`
Expected: `Argos: 1014 execuções, N achados (0 BUG)`. Se a contagem diferir de 1014 em mais de 1%, ajuste `seeds` (a fórmula está na tabela acima) e corrija a tabela.

- [ ] **Step 5: Checkpoint.** Se um plano de herói ainda não foi integrado, **não** rode o cenário dele (o build inexistente derruba a run): registre "pendente" no log.

---

### Tarefa 2: Argos registra dano por skill e contadores de kit

Hoje o registro só tem `damage_dealt` por herói e `casts` por skill. Para medir a Signature e o disparo das passivas, acrescentar `skill_damage` (dano por skill) e `counters` (contagem de eventos de kit).

**Files:**
- Modify: `tools/argos/simulator/combat/argos_sim.gd` (`_summarize`)
- Test: `tests/unit/test_argos_oracles.gd` (cena `TestArgosOracles.tscn` existente)

**Interfaces:**
- Produces, no registro de cada run de `route` e `segment`: `"skill_damage": {skill_id: float}` e `"counters": {tipo_de_evento: int}`.
- Eventos contados: `guard_spent`, `guard_gained`, `last_bastion_started`, `ally_saved`, `iron_response`, `enemy_marked` (com `transferred`), `enemy_stunned`, `enemy_imbalanced`, `telegraph_interrupted`.

- [ ] **Step 1: Teste (falha)** — em `tests/unit/test_argos_oracles.gd` o `sim` já é uma instância de `argos_sim.gd` e `_summarize(run, events, level)` é chamado com `_finished_run()`. Acrescentar a chamada `_test_kit_fields()` logo depois de `_test_real_run_is_clean()` em `_ready`, e a função:

```gdscript
func _test_kit_fields() -> void:
	var events := [
		_start(),
		{"type": "skill_damage", "time": 1.0, "source": "hero_001", "skill": "skill_bas_010", "target": "x", "damage": 5.0},
		{"type": "skill_damage", "time": 2.0, "source": "hero_001", "skill": "skill_bas_010", "target": "x", "damage": 7.0},
		{"type": "guard_spent", "time": 2.0, "hero": "hero_001", "amount": 20.0, "total": 0.0},
	]
	var rec: Dictionary = sim._summarize(_finished_run(), events, 1)
	if absf(float(rec.get("skill_damage", {}).get("skill_bas_010", 0.0)) - 12.0) < 0.001 and int(rec.get("counters", {}).get("guard_spent", 0)) == 1:
		print("[PASS] registro traz skill_damage e counters")
	else:
		success = false
		print("FALHA: skill_damage/counters ausentes: %s" % JSON.stringify(rec))

- [ ] **Step 2: Falha esperada** — chaves ausentes.

- [ ] **Step 3: Implementar** — em `_summarize`: declarar

```gdscript
	var skill_damage := {}
	var counters := {}
	const COUNTED := ["guard_spent", "guard_gained", "last_bastion_started", "ally_saved", "iron_response", "enemy_marked", "enemy_stunned", "enemy_imbalanced", "telegraph_interrupted"]
```

no ramo `"hero_attack", "skill_damage", "counter_attack", "passive_damage":` acrescentar

```gdscript
				if String(e["type"]) == "skill_damage":
					skill_damage[e["skill"]] = float(skill_damage.get(e["skill"], 0.0)) + float(e["damage"])
```

e, antes do `match`, contar:

```gdscript
		if COUNTED.has(String(e["type"])):
			counters[e["type"]] = int(counters.get(e["type"], 0)) + 1
```

No dicionário de retorno acrescentar `"skill_damage": skill_damage, "counters": counters,`.

- [ ] **Step 4: Passar** — `TestArgosOracles.tscn` e `python tools/run_godot_tests.py`.

- [ ] **Step 5: Regressão do Argos** — `python tools/argos/run.py --scenario slice_quick` (esperado: `0 BUG`; o Analyst ignora chaves desconhecidas). Depois `python -m unittest tools/argos/analyzer/test_analyze.py` (esperado: OK).

- [ ] **Step 6: Checkpoint.**

---

### Tarefa 3: Relatório de kit (`kit_report.py`)

**Files:**
- Create: `tools/argos/analyzer/kit_report.py`
- Create: `tools/argos/analyzer/test_kit_report.py`

**Interfaces:**
- Consumes: `runs.jsonl` do cenário de foco (registros `kind` = `route`, `segment`, `campaign`, com `build_map`, `won`, `level`, `casts`, `skill_damage`, `counters`, `damage_dealt`, `attempts`, `final_level`).
- Produces: `python tools/argos/analyzer/kit_report.py <pasta_do_relatorio> <hero_id> [--out KIT_REPORT.md]` → escreve `KIT_REPORT_<hero_id>.md` na pasta e devolve código 0; funções `load_runs(path)`, `per_build(runs, hero_id)`, `findings(stats, hero_id)`.

Critérios de aceite implementados (HIPÓTESE de simulação, um só lugar):

| Código | Regra | Fonte |
| --- | --- | --- |
| `VIABLE` | vitória de rota ≥ 0,5 em algum nível ≤ 11 para a build | `rules_slice.viable_path` |
| `CAMPAIGN` | mediana de tentativas entre 3 e 8 e nível de vitória entre 9 e 12 | `rules_slice.campaign` |
| `DOMINANT` | diferença de vitória de rota (nível 10) entre a melhor e a pior build do herói > 0,35 | `rules_slice.dominance` (0,5), endurecida para 0,35 pelos kits |
| `DEAD_SKILL` | uma skill equipada com média de casts por rota < 0,5 | Plano 04 |
| `SIG_DEAD` | a Signature com média de casts por rota < 0,5 (não é lançada) | Plano 04 |
| `DEAD_PASSIVE` | contador esperado igual a 0 em todas as rotas (tabela abaixo) | Plano 04 |

Contadores esperados por herói: Bastião → `guard_spent` (builds `controle*` e `*_sig`), `last_bastion_started` (`*_sig`), `iron_response` (`retaliacao*`); Flecha → nenhum contador dedicado (usar `casts` de `skill_fle_010`/`011`); Íris → `enemy_stunned` (`controle*`).

- [ ] **Step 1: Teste (falha)** — `test_kit_report.py`:

```python
import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit_report  # noqa: E402


def run(build, won, level=10, kind="route", casts=None, skill_damage=None, counters=None, hero="hero_001"):
    return {"kind": kind, "build": build, "build_map": {"hero_001": build, "hero_002": "marca", "hero_003": "controle"},
            "won": won, "level": level, "casts": casts or {}, "skill_damage": skill_damage or {}, "counters": counters or {},
            "damage_dealt": {"hero_001": 100.0, "hero_002": 100.0, "hero_003": 100.0}}


class KitReportTest(unittest.TestCase):
    def test_per_build_win_rate(self):
        runs = [run("guardiao", True), run("guardiao", False), run("controle", True), run("controle", True)]
        stats = kit_report.per_build(runs, "hero_001")
        self.assertAlmostEqual(stats["guardiao"]["route_win"][10], 0.5)
        self.assertAlmostEqual(stats["controle"]["route_win"][10], 1.0)

    def test_dominance_finding(self):
        runs = [run("guardiao", True)] * 10 + [run("controle", False)] * 10
        stats = kit_report.per_build(runs, "hero_001")
        codes = [f["code"] for f in kit_report.findings(stats, "hero_001")]
        self.assertIn("DOMINANT", codes)

    def test_dead_skill_finding(self):
        runs = [run("guardiao", True, casts={"skill_bas_006": 2})] * 4
        stats = kit_report.per_build(runs, "hero_001", equipped={"guardiao": ["skill_bas_006", "skill_bas_009"]})
        found = [f for f in kit_report.findings(stats, "hero_001") if f["code"] == "DEAD_SKILL"]
        self.assertEqual(len(found), 1)
        self.assertIn("skill_bas_009", found[0]["detail"])

    def test_signature_weak(self):
        runs = [run("guardiao", True)] * 10 + [run("guardiao_sig", False)] * 10
        stats = kit_report.per_build(runs, "hero_001")
        codes = [f["code"] for f in kit_report.findings(stats, "hero_001")]
        self.assertIn("SIG_WEAK", codes)

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
```

- [ ] **Step 2: Falha esperada** — `python -m unittest tools/argos/analyzer/test_kit_report.py` → `ModuleNotFoundError: kit_report`.

- [ ] **Step 3: Implementar** — `kit_report.py`:

```python
"""Relatório de kit do Argos: por herói em foco, agrega runs.jsonl por build e gera achados.

Uso: python tools/argos/analyzer/kit_report.py <pasta_do_relatorio> <hero_id>
Só biblioteca padrão. Simulação não é playtest: nada aqui avalia diversão.
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
    "dominance_gap": 0.35, "signature_gap": 0.25, "dead_skill_casts": 0.5,
}

EXPECTED_COUNTERS = {
    "hero_001": {"guard_spent": ("controle", "_sig"), "last_bastion_started": ("_sig",), "iron_response": ("retaliacao",)},
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
    """build -> skills equipadas, lidas de data/heroes/heroes.json."""
    with open(os.path.join(ROOT, "data", "heroes", "heroes.json"), encoding="utf-8") as f:
        rows = json.load(f)
    for row in rows:
        if row["id"] == hero_id:
            return {key: b["skills"] for key, b in row.get("builds", {}).items()}
    return {}


def build_key(run, hero_id):
    return run["build_map"][hero_id].replace("_tele", "")


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
        stats[key] = {
            "route_win": wins,
            "runs": sum(len(v) for v in route[key].values()),
            "casts": {s: statistics.mean(v) for s, v in casts[key].items()},
            "skill_damage": {s: statistics.mean(v) for s, v in skill_damage[key].items()},
            "counters": {n: statistics.mean(v) for n, v in counters[key].items()},
            "campaign_win": statistics.mean([1.0 if c["won"] else 0.0 for c in camp]) if camp else None,
            "campaign_attempts": statistics.median([c["attempts"] for c in camp if c["won"]]) if any(c["won"] for c in camp) else None,
            "campaign_level": statistics.median([c["final_level"] for c in camp if c["won"]]) if any(c["won"] for c in camp) else None,
        }
    return stats


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
        dead = [s for s, mean_casts in v["casts"].items() if mean_casts < RULES["dead_skill_casts"]]
        for skill in dead:
            out.append({"code": "DEAD_SKILL", "severity": "BALANCE", "detail": f"{key}: {skill} com {v['casts'][skill]:.2f} casts por rota (mínimo {RULES['dead_skill_casts']})"})
        for counter, suffixes in EXPECTED_COUNTERS.get(hero_id, {}).items():
            if any(key.endswith(sfx) or key.startswith(sfx) for sfx in suffixes) and v["counters"].get(counter, 0.0) == 0.0 and v["runs"] > 0:
                out.append({"code": "DEAD_PASSIVE", "severity": "BALANCE", "detail": f"{key}: contador {counter} nunca disparou"})
    if len(at10) >= 2:
        best_key, worst_key = max(at10, key=at10.get), min(at10, key=at10.get)
        if at10[best_key] - at10[worst_key] > RULES["dominance_gap"]:
            out.append({"code": "DOMINANT", "severity": "BALANCE", "detail": f"nível 10: {best_key} {at10[best_key]:.0%} × {worst_key} {at10[worst_key]:.0%} (gap > {RULES['dominance_gap']:.0%})"})
    for key in list(at10):
        if key.endswith("_sig") and key[:-4] in at10:
            gap = at10[key] - at10[key[:-4]]
            if gap < -RULES["signature_gap"]:
                out.append({"code": "SIG_WEAK", "severity": "BALANCE", "detail": f"{key} perde {-gap:.0%} contra {key[:-4]} no nível 10"})
            elif gap > RULES["signature_gap"]:
                out.append({"code": "SIG_DOMINANT", "severity": "BALANCE", "detail": f"{key} ganha {gap:.0%} sobre {key[:-4]} no nível 10"})
    return out


def write_report(folder, hero_id):
    runs = load_runs(os.path.join(folder, "runs.jsonl"))
    stats = per_build(runs, hero_id)
    lines = [f"# Relatório de kit — {hero_id}", "", "Simulação determinística, não playtest. Regras: `RULES` em `kit_report.py`.", "",
             "| Build | Rotas | Vitória L8 | L10 | L12 | Campanha vence | Mediana tentativas | Nível de vitória |", "| --- | --- | --- | --- | --- | --- | --- | --- |"]
    for key in sorted(stats):
        v = stats[key]
        cell = lambda lvl: f"{v['route_win'][lvl]:.0%}" if lvl in v["route_win"] else "–"
        camp = f"{v['campaign_win']:.0%}" if v["campaign_win"] is not None else "–"
        lines.append(f"| {key} | {v['runs']} | {cell(8)} | {cell(10)} | {cell(12)} | {camp} | {v['campaign_attempts'] if v['campaign_attempts'] is not None else '–'} | {v['campaign_level'] if v['campaign_level'] is not None else '–'} |")
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
```

- [ ] **Step 4: Passar** — `python -m unittest tools/argos/analyzer/test_kit_report.py` (5 testes OK; o `sys.path.insert` no topo é o mesmo padrão de `test_analyze.py`).

- [ ] **Step 5: Checkpoint.**

---

### Tarefa 4: Rodar o cenário de um herói e ler o relatório

Repetir para cada herói já integrado (`bastiao`, `flecha`, `iris`).

- [ ] **Step 1: Rodar**

Run: `python tools/argos/run.py --scenario kits_focus_<heroi>`
Expected: `Argos: ~1000 execuções, N achados (0 BUG)`. Anote a pasta `tools/argos/reports/<data>_<commit>/`.

Se aparecer `BUG` (violações como `hit_defeated_enemy`, `dead_hero_acted`, `defeated_enemy_acted`): **parar**, abrir só as linhas do `runs.jsonl` com `violations` não vazio (`python - <<'EOF'` filtrando), reproduzir por seed em um teste novo em `tests/unit/test_kit_<heroi>.gd` e corrigir no código antes de qualquer ajuste de número. Causas prováveis: efeito de fim de encontro (`last_bastion` ao terminar depois da morte dos inimigos), onda/explosão em inimigo já derrotado, evento com `time` no passado.

- [ ] **Step 2: Gerar o relatório de kit**

Run: `python tools/argos/analyzer/kit_report.py tools/argos/reports/<pasta> hero_00N` (N = 1, 2 ou 3)
Expected: caminho de `KIT_REPORT_hero_00N.md`.

- [ ] **Step 3: Ler `REPORT.md` e `KIT_REPORT_*.md`** (nunca o `runs.jsonl` inteiro) e classificar cada achado:

| Achado | Classe | Ação |
| --- | --- | --- |
| violação de oráculo | BUG | corrigir no código (Step 1) |
| `DEAD_SKILL` | BALANCE | verificar gatilho/recarga da skill nova; ajuste da Tarefa 5 |
| `DEAD_PASSIVE` | BALANCE | conferir condição do gancho; se a condição é rara por desenho, registrar em `BALANCE_FINDINGS.md` sem mudar nada |
| `VIABLE`, `CAMPAIGN`, `DOMINANT`, `SIG_*` | BALANCE/PACING | ajuste da Tarefa 5 |

- [ ] **Step 4: Registrar a linha-base do herói** em `docs/08_qa/KITS_TUNING_LOG.md` (Tarefa 6), iteração 0.

---

### Tarefa 5: Laço de ajuste (máx. 5 iterações por herói)

Regras do laço: (a) até **3 números** por iteração, só nas alavancas permitidas; (b) hipótese escrita antes; (c) mesma seed e mesmo cenário para comparar; (d) parar quando **todos** os achados BALANCE/PACING do herói sumirem ou na 5ª iteração — o que sobrar vai para Rafael.

Mapa sintoma → alavanca (todas HIPÓTESE e nas linhas novas):

| Sintoma | Alavanca (primeira escolha → segunda) |
| --- | --- |
| build nova vence quase sempre (`DOMINANT`, alto) | `coefficient` da skill nova −10% → `unlock_level` do capstone +2 |
| build nova nunca vence (`VIABLE`) | `coefficient` +10% → recarga −10% (`cooldown`) |
| Signature domina (`SIG_DOMINANT`) | `cooldown` +5 s → `primary_coefficient`/`coefficient` −10% |
| Signature fraca (`SIG_WEAK`) | `cooldown` −5 s → gatilho mais permissivo (ex.: `guard_and_hp_below.threshold` 0,5 → 0,6) |
| `DEAD_SKILL` por gatilho | relaxar o gatilho (Bastião: `guard_at_least.amount` 20 → 15; Ricochete/Chuva já usam `enemies_alive`) |
| `DEAD_PASSIVE` Julgamento de Ferro (Bastião) | `required` 3 → 2 ou `window` 12 → 16 |
| campanha vence antes do nível 9 | reduzir o ganho das passivas de tier alto (`unlock_level` +2) |
| campanha vence depois do nível 12 | aumentar o ganho do capstone ou baixar seu `unlock_level` em 2 |

- [ ] **Step 1: Escrever a hipótese** na tabela do log (Tarefa 6): "Achado X (código, métrica). Hipótese: alavanca Y causa. Mudança: campo Z de A para B."

- [ ] **Step 2: Editar `/data`** (só os campos declarados) e validar:

Run: `python tools/balance/validate_balance_data.py`
Expected: `Balance data: OK`.

- [ ] **Step 3: Testes** — `python tools/run_godot_tests.py`. Testes de kit que fixam números (por exemplo razões 0,7 ou 1,15) precisam ser atualizados **junto com** o dado, no mesmo passo; testes de comportamento (piso de 1 HP, cooldown, alvo) não devem mudar.

- [ ] **Step 4: Reexecutar o mesmo cenário e o relatório de kit** (comandos da Tarefa 4) e anotar no log: achados antes → depois.

- [ ] **Step 5: Decidir** — se o sintoma sumiu sem criar outro, seguir; se criou outro, reverter a mudança (registrar a reversão) e tentar a segunda alavanca da tabela. Se a iteração 5 terminar com achados, parar e encaminhar.

- [ ] **Step 6: Checkpoint por herói** (suíte verde, validador OK, `0 BUG`).

---

### Tarefa 6: Log de ajuste e registro dos achados

**Files:** Create `docs/08_qa/KITS_TUNING_LOG.md`; Modify `docs/08_qa/BALANCE_FINDINGS.md`.

- [ ] **Step 1: Criar o log** com esta estrutura (uma seção por herói):

```markdown
# Ajuste dos kits — log (2026-09-30)

Simulação do Argos, não playtest. Cada linha é uma iteração do laço da Tarefa 5 do Plano 04.

## Bastião — cenário `kits_focus_bastiao`

| It. | Relatório (pasta) | Achados antes | Hipótese | Mudança (campo: de → para) | Achados depois | Decisão |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | `<data>_<commit>` | — | linha-base | — | (lista) | — |
```

- [ ] **Step 2: Achados que sobrarem** → `BALANCE_FINDINGS.md`, no formato existente do arquivo (título, métrica com relatório, hipótese, proposta). Cada um termina com "**Decisão: Rafael**".

- [ ] **Step 3: Checkpoint.**

---

### Tarefa 7: Validação final (≈3000 runs) e regressão

Só depois de os três heróis estarem integrados e ajustados.

**Files:** Create `docs/08_qa/KITS_VALIDATION_2026-09-30.md`; Modify `ROADMAP.md`.

- [ ] **Step 1: Rodar os três cenários em sequência**

```bash
python tools/argos/run.py --scenario kits_focus_bastiao
python tools/argos/run.py --scenario kits_focus_flecha
python tools/argos/run.py --scenario kits_focus_iris
```
Expected: `1040`, `1014`, `1014` execuções, todas com `0 BUG`.

- [ ] **Step 2: Gerar os três relatórios de kit** (`kit_report.py … hero_001|hero_002|hero_003`).

- [ ] **Step 3: Regressão do cenário histórico**

Run: `python tools/argos/run.py --scenario slice_balance`
Expected: `1404 execuções … (0 BUG)`; compare com o baseline do Plano 00, Tarefa 3 (`docs/08_qa/KITS_BASELINE_2026-09-30.md`) e registre as diferenças de vitória por build e a mediana de tentativas da campanha.

Atenção: `slice_balance` lista só as builds antigas. Elas agora carregam passivas novas (as listas de `passives` das builds cresceram), então **as taxas de vitória vão mudar**. Isso é esperado e vira achado, não regressão de código.

- [ ] **Step 4: Suíte completa e analisador**

Run: `python tools/run_godot_tests.py` → todas PASS.
Run: `python -m unittest tools/argos/analyzer/test_analyze.py` e `test_kit_report.py` → OK.
Run: `python tools/balance/validate_balance_data.py` → `Balance data: OK`.

- [ ] **Step 5: Escrever `KITS_VALIDATION_2026-09-30.md`** — seções: (1) o que foi medido (3 cenários, total de execuções, commits dos relatórios); (2) tabela por herói: melhor/pior build (nível 10), mediana de tentativas, achados restantes; (3) o que **não** foi provado (diversão, feeling, balanceamento real — só simulação); (4) itens para Rafael.

- [ ] **Step 6: `ROADMAP.md`** — na seção 1 ("Onde estamos") acrescentar uma linha de estado: "Kits completos dos 3 heróis implementados como HIPÓTESE e medidos em ~3000 runs do Argos (2026-09-30); ver `KITS_VALIDATION_2026-09-30.md`". Não marcar gates como PASS: o playtest humano do `1E` continua pendente.

- [ ] **Step 7: Checkpoint final** — relatar a Rafael: totais, achados restantes e decisões pedidas. **Não** fazer commit.
