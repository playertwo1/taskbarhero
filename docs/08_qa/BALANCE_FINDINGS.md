# Registro de Achados de Balanceamento e Pacing — Argos Analyst

Este arquivo centraliza anomalias de balanceamento estatístico, curvas de progressão e taxas de vitória de chefes identificadas pelo Argos Analyst durante simulações massivas e playtests.

---

## Template de Finding

```markdown
### [BAL-001] Nome do Achado
* **Data:** YYYY-MM-DD
* **Build Commit:** <sha>
* **Métrica Observada:** (ex: Win rate do Guardião-Cervo = 4% para heróis nível 10)
* **Hipótese:** Dano por segundo do chefe excede regeneração e defesa base em 3.5x.
* **Proposta do Argos:** Reduzir ataque base de 20 para 16 ou estender janela de ataque de 0.85s para 1.10s.
* **Decisão Humana:** (Pendente / Aprovada por Rafael)
```

---

## Log Histórico de Achados

Fonte dos números: `python tools/argos/run.py --scenario slice_balance` (6 sementes por célula), relatório versionado em `tools/argos/reports/`. Simulação determinística, não playtest; os números do slice são HIPÓTESE.

### [BAL-001] Cura é o único caminho viável da rota
* **Data:** 2026-09-29
* **Métrica observada:** as 6 combinações com Íris Lúmen vencem a rota em 2 tentativas (nível ~5); nenhuma combinação sem cura atinge 50% de vitória na rota até o nível 8.
* **Hipótese:** sem recuperação de HP fora do Hub, os comuns e a elite consomem ~70% do HP antes da Rainha; o contrato já previa custo de 5–8% por comum, 41% na elite e 127% na Rainha.
* **Proposta do Argos:** escolher entre reduzir `enemy_damage_scale` (0,35 leva parties sem cura a vencer o Guardião isolado a partir do nível 3), encurtar a rota ou permitir recuperação pontual (o Poço de Lúmen do recorte). O cenário `slice_paths` comparou poções, fôlego, Poço, Véu maior, Caçada e Muralha R5: só recuperação limitada (poções ou fôlego) abriu caminhos sem cura.
* **Decisão humana:** Rafael escolheu **fôlego entre encontros** (2026-09-29) e fixou a meta de vencer o Guardião por volta do nível 10–11. Com fôlego e o Pulso reduzido para 0,3×/16 s, as 18 combinações vencem a campanha entre os níveis 7 e 14 (`slice_balance`). **Estado:** resolvido em simulação; pendente de playtest.

### [BAL-002] Build Arcano nunca vence a campanha
* **Data:** 2026-09-29
* **Métrica observada:** 0% em 10 tentativas nas 6 combinações com Íris Arcano.
* **Hipótese:** o Arcano não tem sustentação nem resposta a golpe forte; passivas de Íris ainda com números de simulação.
* **Proposta do Argos:** revisar após a decisão de BAL-001; medir o Arcano com Retaliação (Desequilíbrio alimenta o Prisma).
* **Decisão humana:** após o fôlego, o Arcano vence em 4,5–9 tentativas (nível 9,5–14); com Guardião ainda fica tarde (nível 14). Ajuste fino pendente.

### [BAL-003] Controle vence só depois de ~10 tentativas
* **Data:** 2026-09-29
* **Métrica observada:** mediana de 8,5–10 tentativas, vitória por volta do nível 13–15.
* **Hipótese:** a curva linear 1–100 dá ~2,5% de força por nível; o progresso após derrotas precisa vir de ranks, itens e Árvore.
* **Proposta do Argos:** definir os marcos de rank e o ganho de itens/Árvore antes de ajustar a curva.
* **Decisão humana:** meta definida (nível 10–11, jogo incremental). Com fôlego, Controle vence em 4–6,5 tentativas (nível 9–12,5), dentro ou perto da meta.
