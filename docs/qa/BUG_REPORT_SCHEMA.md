# Schema Padrão de Relatórios de Bug — Argos

Todo achado reportado pelo Argos deve seguir estritamente este esquema para que Ergane possa reproduzir e corrigir sem ambiguidade:

```yaml
type: BUG | EXPLOIT | BALANCE | PACING | UX | VISUAL | PERFORMANCE | SAVE
severity: CRITICAL | HIGH | MEDIUM | LOW | INFO

build:
  commit: "<git_commit_sha>"
  branch: "main"

device:
  model: "Galaxy S25 Ultra" # ou emulador/PC
  os: "Android 16"
  resolution: "432x960"

scenario:
  profile: "chaos" # beginner, optimizer, idle, hoarder, chaos, exploit_hunter
  seed: 847291
  stage: "forest_01"

steps:
  - "open app"
  - "wait until battle begins"
  - "kill first enemy"
  - "open inventory"
  - "background app"
  - "resume app"

expected:
  description: "Recompensa de ouro e XP deve ser creditada exatamente uma vez."
  reward_count: 1

observed:
  description: "Ao suspender e retomar o aplicativo, o sinal de recompensa foi emitido novamente."
  reward_count: 2

evidence:
  screenshot_before: "tools/argos/reports/evidence/bug_001_before.png"
  screenshot_after: "tools/argos/reports/evidence/bug_001_after.png"
  log_snippet: "GameManager: battle_ended emitted twice for same session"
  state_snapshot: "tools/argos/snapshots/snapshot_bug_001.json"

reproducibility:
  runs_tested: 10
  reproduced_count: 8
```
