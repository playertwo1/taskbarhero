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

### [BAL-004] Arcano com Guardião vence tarde (v0.5)
* **Data:** 2026-09-29
* **Métrica observada:** `slice_balance` v0.5: Guardião/Crítico/Arcano no nível 15 (10 tentativas); demais Arcano 11–13.
* **Hipótese:** falta de sobrevivência; +30% de dano no Arcano não mudou o nível de vitória (`tune_v05_builds`).
* **Proposta do Argos:** dar ao Arcano uma resposta defensiva leve (ex.: Prisma com Desequilíbrio aplicando lentidão) ou aceitar como combinação fraca.
* **Decisão humana:** pendente.

### [BAL-005] Guardião na borda inferior de 120–210 s (v0.5)
* **Data:** 2026-09-29
* **Métrica observada:** TTK mediano 120 s no nível 10 (110–133 s) com HP ×1,5.
* **Hipótese:** a redução de HP que centrou a vitória no nível 11 encurtou a luta.
* **Proposta do Argos:** testar HP ×2 com golpe forte mais leve; manter se o playtest achar a duração boa.
* **Decisão humana:** pendente.

### [BAL-006] Builds com Lúmen dominam a rota no nível 10
* **Data:** 2026-09-29
* **Build Commit:** `cd47758` com alterações locais; entradas identificadas pelo `balance_hash` no relatório.
* **Métrica observada:** `slice_balance` após a fundação global: melhor taxa de vitória 100% contra mediana de 25% no nível 10. Quatro líderes usam Lúmen; ainda existem 2 caminhos sem Lúmen entre os 7 caminhos com vitória ≥50%.
* **Hipótese:** a cura de Lúmen converte diretamente o HP acumulado da rota, enquanto Arcano depende de sobrevivência e três combinações Arcano vencem a campanha acima da faixa 9–12. O resultado também pode estar amplificado pela amostra de 6 sementes.
* **Proposta do Argos:** manter os valores runtime por enquanto; no playtest, comparar taxa de escolha, HP antes do Guardião e mortes por build. Se a dominância se repetir, mover parte da sobrevivência de Lúmen para ferramentas de Controle/Arcano ou reduzir sua cura antes de alterar a escala global.
* **Decisão humana:** pendente. A exigência de ao menos um caminho sem cura está atendida na simulação; diversidade e sensação ainda precisam de playtest/telemetria.

### [BAL-007] Sacrifício no Poço reduz a consistência de conclusão da run
* **Data:** 2026-09-29
* **Build Commit:** `cd47758` com alterações locais; entradas identificadas pelo `balance_hash` no relatório `20260929-172102_cd47758`.
* **Métrica observada:** `slice_run_layer` executou 192 campanhas sem `BUG`. O Poço apareceu em aproximadamente 100 de cada 100 tentativas que chegaram ao nó. As variantes `base`, `eventos_frequentes` e `poco_curar` escolheram curar em 100% das ofertas; `poco_sacrificar` sacrificou em 100%. Resíduo mediano ficou em 12–13 por tentativa frente à meta hipotética de 5. O Analyst marcou 13 combinações com vitória tardia (acima do nível 12) e uma sem vitória sob sacrifício forçado.
* **Hipótese:** o custo de HP do sacrifício pode reduzir a sobrevivência mais do que a recompensa rara compensa; as 6 sementes por configuração e a política forçada não descrevem escolha humana nem provam dominância em jogo.
* **Proposta do Argos:** manter valores runtime; no playtest comparar curar, sacrificar e política livre com as mesmas builds/sementes, acompanhando HP antes do boss, vitórias, raridade recebida e Resíduo. Rever a meta de Resíduo separadamente se a medição real confirmar excedente.
* **Decisão humana:** pendente. Métricas são HIPÓTESE e não justificam ajuste de números por si só.

### [BAL-008] A fase final do Guardião pressiona a vitória na faixa de nível 12
* **Data:** 2026-09-29
* **Build Commit:** `a976815` com alterações locais; relatório `20260929-193319_a976815`.
* **Métrica observada:** `slice_run_layer` marcou 18 combinações com pacing tardio (vitória entre níveis 12,5 e 15) e uma combinação sem vitória. O relatório anterior `20260929-172102_cd47758` marcava 13 combinações tardias e uma sem vitória. Na cena `TestExpeditionChoices`, o trio Guardião/Crítico/Controle no nível 12 e seed 101 perdeu nas duas cadências. Uma comparação pareada de 24 seeds da mesma build/nível, com uma cópia em memória dos dados, resultou em 1/24 vitórias com telegraph a cada 2 ataques e 7/24 a cada 3. A fase durou em média 52,7 s e 65,3 s, respectivamente; o progresso médio nos fragmentos foi 79,9% e 87,0%; golpes telegrafados médios 12,4 e 11,4; heróis vivos ao final 0,08 e 0,50. Na seed 101, a fase começou em 184,4 s; os dois primeiros fragmentos caíram em 200,2 s e 221,6 s; a party caiu em 242,6 s com 49% de HP restante no terceiro fragmento.
* **Hipótese:** o fluxo sequencial está funcionando. A cadência a cada 3 ataques teve mais vitórias e sobreviventes na amostra, apesar de alongar a fase, e é a opção menos punitiva. O seed 101 ainda perde nas duas variantes; a cadência não explica sozinha essa regressão. Simulação determinística não substitui playtest.
* **Recomendação:** preferir a cadência a cada 3 ataques, preservando os três alvos sequenciais e os ataques do Guardião. Manter a falha da seed 101 visível; não enfraquecer nem reescrever o teste para fazê-lo passar.
* **Decisão humana:** Rafael adotou a recomendação em 2026-09-29; `telegraph_every` foi ajustado para 3 em [`enemies.json`](../../data/enemies/enemies.json). A hipótese de balanceamento permanece sujeita a playtest.

### Evidência complementar — campanha completa com progressão (2026-09-29)

* **Relatório:** [`slice_balance`, commit `7c2d173`](../../tools/argos/reports/20260929-210328_7c2d173/REPORT.md) — 1.404 execuções, 18 builds, seis seeds por célula, 0 `BUG`.
* **Métrica observada:** todas as 18 builds concluíram a campanha após progressão; medianas de 4–10 tentativas e vitória entre os níveis 9 e 15,5. A build `guardiao/critico/controle` no nível 12 venceu 50% das rotas na primeira tentativa. Com HP cheio, o encontro isolado contra o Guardião venceu em 100% das seis seeds nessa mesma build.
* **Relação com a regressão fixa:** a derrota da seed 101 na run completa sem equipamento inicial é compatível com a taxa de 50% observada para essa build. A campanha com retornos ao Hub, XP e equipamento vence; a seed fixa não demonstra que a rota seja impossível.
* **Cadência:** na comparação em memória de 24 seeds (101–124), cadência 3 venceu 7 e cadência 4 venceu 10; 9 seeds favoreceram a 4, 6 favoreceram a 3 e 8 perderam nas duas. Em outra amostra de 100 seeds, os resultados agregados foram 48/100 para 3 e 46/100 para 4. A diferença não aponta uma vantagem consistente da cadência 4; manter 3 conforme decisão de Rafael.
* **Limites:** as simulações são determinísticas, usam escolhas automatizadas e seis seeds por célula no Argos. Não substituem playtest nem tornam a seed 101 um requisito de vitória garantida. A expectativa do teste de first clear não representa a taxa de primeira tentativa registrada; Rafael aceitou essa diferença como exceção do gate 1C.
* **Decisão humana:** Rafael aceitou a expectativa fixa de vitória da seed 101 como exceção para fechar 1C (2026-09-29). O teste permanece inalterado e a suíte segue registrada em 24/25; decidir no playtest `1E` se a luta precisa de mais balanceamento.

