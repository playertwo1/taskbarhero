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

### [BAL-009] Arcano tardio e Guardião sem folga após o 1D (início do 1E)
* **Data:** 2026-09-29
* **Build Commit:** `4c14e22` com alterações locais; relatório [`slice_balance`](../../tools/argos/reports/20260929-224410_4c14e22/REPORT.md), 1.404 execuções, 0 `BUG`, 12 achados.
* **Métrica observada:** (1) sete builds vencem tarde demais, entre os níveis 13 e 15,5, com 7 a 10,5 tentativas (meta 9–12 e 3–8): cinco com Íris no Arcano e duas com Íris no Controle (`retaliacao/critico/controle` e `retaliacao/marca/controle`); (2) dominância `HIGH` nos níveis 10 e 12, com melhor build a 100% contra mediana de 0% (nível 10) e 50% (nível 12); (3) 6 caminhos viáveis no nível 10, só 2 sem Lúmen; (4) com HP cheio no nível 10, as builds Lúmen vencem o Guardião com 24% de HP restante e TTK mediano de 126–164 s; (5) mediana de 4 itens por tentativa. Esta rodada já inclui Fragmentos e Ferreiro, mas o simulador não compra nós nem reforça itens: o efeito do 1D sobre o combate não foi medido.
* **Hipótese:** Arcano e Controle dependem de sobrevivência que a rota não entrega sem a cura de Lúmen; a diferença de dominância é amplificada pelas 6 sementes por célula. O Reforço +1 (+2% dos afixos-base) provavelmente não move esses números.
* **Proposta do Argos:** não alterar valores agora. No playtest, comparar taxa de escolha por build, HP antes do Guardião e mortes por fase; se o Arcano continuar tardio, mover sobrevivência para Arcano/Controle em vez de reduzir Lúmen. Adicionar ao simulador a compra da Árvore e o Reforço para medir o efeito real do 1D.
* **Decisão humana:** Rafael decidiu esperar o playtest (2026-09-29): nenhum valor é alterado. Antes, o simulador passa a comprar a Árvore e reforçar itens para medir o efeito real do 1D; a decisão sobre Arcano, Controle e Guardião volta depois do playtest humano.

* **Evidência complementar do BAL-009 — efeito do 1D (2026-09-29):** o cenário `slice_run_layer` ganhou a variante `com_arvore_e_ferreiro` (política do Argos: compra a rota `VIG_002` → `OFI_003` assim que há Fragmentos e reforça os itens equipados enquanto houver Resíduo; não desmonta itens). Relatório `20260929-233509_08923dd`, 240 execuções, 0 `BUG`. Contra a variante `base` (48 campanhas cada, mesmas builds e sementes): tentativas médias 6,48 contra 6,52 e nível final médio 13,38 contra 13,42; vitórias 47/48 contra 48/48. A variante fez 604 reforços e comprou os 5 nós em ao menos uma tentativa. **Leitura:** o Reforço +1 e a Árvore do slice não mudam o ritmo de forma mensurável (diferença dentro do ruído de 6 sementes), o que confirma a hipótese de que não movem os achados de Arcano/Controle. O Pulso Vital não tem efeito no runtime (`effect: "none"`), então só o Reforço foi medido. Isso é simulação, não playtest.

### [BAL-010] Kits completos: `lumen` e `retaliacao_tele` vencem cedo demais
* **Data:** 2026-09-30
* **Build Commit:** `82571ad` (com alterações locais; kits completos dos 3 heróis)
* **Métrica observada** (campanha, nível no início da tentativa vencedora; meta 9–12 e 3–8 tentativas): as seis combinações com Íris `lumen` vencem nos níveis **6–7** em 2,5–3 tentativas; `retaliacao_tele` vence no nível **8** (3,5 tentativas) e a rota nível 8 é vencida em 95% das vezes (dominância nos níveis 8 e 10). No baseline (antes dos kits) só `retaliacao_tele/marca/lumen` estava abaixo de 9 (8,5). Relatórios: `20260930-151302_82571ad` (`slice_balance`), `20260930-151134_82571ad` e `20260930-150753_82571ad` (focos).
* **Hipótese:** a parte das Signaturas foi tratada (recarga 120/60/60 s devolveu a mediana das 18 combinações de 7,5 para 9,5). O que sobra nessas duplas vem do núcleo existente (Pulso Restaurador + Véu; Contra-Golpe guardado para o golpe telegrafado): com todas as Signaturas desligadas e as 36 passivas novas desligadas, as combinações `lumen` seguem em 7 (`tune_kits_party`). Uma ressalva: a variante "Pulso sem os ranks novos" foi idêntica à base, então não ficou provado que o override de ranks foi aplicado; os ranks que dei ao Pulso (Plano 03, I3) continuam suspeitos até outra medição.
* **Proposta do Argos:** as alavancas que sobram são decisões de Rafael (não foram alteradas): (a) reduzir o Pulso Restaurador (hoje 0,3×ATK / 16 s) ou seus ranks novos, (b) reduzir o bônus do gatilho telegrafado do Contra-Golpe em `retaliacao_tele`, (c) aceitar `lumen` como a build de cura mais rápida, já que `rules_slice` pede só mais de um caminho viável sem cura (12 caminhos no nível 10, 6 sem `lumen`).
* **Decisão humana:** **Pendente (Rafael).**

### [BAL-011] Kits completos: Íris `arcano` fraca e 36 passivas novas sem efeito medido
* **Data:** 2026-09-30
* **Métrica observada:** Íris `arcano` vence a rota no nível 10 em 27% (baseline: 0%) e a campanha no nível 12 com 6 tentativas (limite alto). Além disso, desligar as 36 passivas novas (A3–C5 e Traits dos três heróis) **não altera** a mediana da campanha (`tune_kits_party`: 8,5 com e sem elas).
* **Hipótese:** a fraqueza do `arcano` é anterior aos kits (Prisma de Retorno exige alvo preparado e dependia da Marca da Flecha). Subir os três nós novos (`pass_iri_006`/`007`/`008`) não ajudou (iteração 4b, revertida). Quanto às passivas em geral, ou os valores são pequenos para a rota e a campanha, ou o Argos não captura o que elas fazem (por exemplo, leitura de alvo); só playtest distingue.
* **Proposta do Argos:** nenhuma mudança agora; decidir no playtest do `1E` se alguma passiva precisa de mais peso e se o Prisma de Retorno precisa de outro gatilho.
* **Decisão humana:** **Pendente (Rafael).**

### [BAL-012] Kits completos: TTK do Guardião abaixo da faixa
* **Data:** 2026-09-30
* **Métrica observada:** mediana de 113 s (faixa 120–210 s de `ENCOUNTERS.md`); 15 de 18 combinações vencedoras abaixo da faixa (baseline: mediana 123 s; 2 de 16 fora).
* **Hipótese:** as Signaturas e o dano dos novos nós encurtam a luta. Recargas maiores ajudaram (antes do ajuste a mediana era menor), mas não trouxeram a mediana para a faixa.
* **Proposta do Argos:** seguir o roteiro do contrato (`SLICE_BALANCE_CONTRACT.md`): ajustar telégrafos, recuperação e adds do Guardião antes do HP; decisão depois do playtest.
* **Decisão humana:** **Pendente (Rafael).**

### [BAL-013] Itens novos: o modo "rota" do Argos mede o trio sem equipamento
* **Data:** 2026-09-30
* **Build Commit:** `82571ad` (com alterações locais); relatórios `slice_balance` [`172838`](../../tools/argos/reports/20260930-172838_82571ad/REPORT.md) (antes) e [`174431`](../../tools/argos/reports/20260930-174431_82571ad/REPORT.md) (depois); varredura [`tune_items_boss`](../../tools/argos/reports/20260930-173719_82571ad/REPORT.md).
* **Métrica observada:** com a escada de nove níveis, o valor de 1,8% por BP e o Reforço de +10%, a mediana do nível de vitória do Guardião na campanha caiu de 10,0 para 9,0 (as builds que vencem cedo demais passaram de 7 para 9; depois do chefe ×2 ficaram 2, mais 1 que vence tarde demais, `guardiao/critico/arcano`, nível 13). O HP do chefe foi recalibrado de ×1,5 para ×2 (decisão de Rafael: manter a meta 10–11): mediana **10,2** (10,8 sem as builds Lúmen), faixa 7–13, 5,2 tentativas; o TTK mediano do Guardião passou de 113 s para **147,5 s** (faixa de projeto 120–210 s). Em contrapartida, "caminhos viáveis no nível 10" (rota com HP cheio, vitória ≥ 50%) caiu de 15 para **7** (de 9 para **1** sem Lúmen).
* **Hipótese:** o modo `route` do Argos roda o trio **sem equipamento**. Enquanto os itens valiam ~+3%, isso aproximava o jogador real; com itens de ~+30%, o modo mede um personagem que o jogo não produz. A campanha, que acumula drops e equipa, vence em 18 de 18 combinações. A regra "mais de um caminho viável sem cura" deixou de ser medida de forma fiel.
* **Proposta do Argos:** dar ao modo `route` um perfil de equipamento típico por nível (por exemplo, Raro em IP 27 nos seis slots) antes de julgar caminhos viáveis; não afrouxar `rules_slice.json`. Ainda vale rever as builds Lúmen (BAL-010), que seguem vencendo cedo.
* **Atualização (2026-09-30):** o modo `route` agora aceita perfis de equipamento (`tools/argos/simulator/combat/equipment_profiles.json`). Com `slice_route_gear` (`180307`), no nível 10: `nu` 37% de vitória média e 7 caminhos viáveis (1 sem Lúmen); **`tipico`** (3 slots, Incomum, IP 15; calibrado nos ~9 de 15 slots equipados quando a campanha vence) **50%**, 8 viáveis (2 sem Lúmen), no meio da meta humana de 40–60% na primeira tentativa; `bom` (5 slots, Raro, IP 22) 84%, 16 viáveis (10 sem Lúmen). `slice_balance` passou a usar `tipico` na rota e nos segmentos (relatório `180715`). A regra de caminhos viáveis agora mede um personagem equipado de forma típica.
* **Decisão humana:** **Pendente (Rafael)** quanto ao perfil de equipamento da rota; o HP do chefe ×2 foi autorizado no debate de 2026-09-30 ("manter a meta 10–11 e recalibrar o inimigo depois").

### [BAL-014] Grinder: Resíduo de Lúmen e inventário crescem sem limite
* **Data:** 2026-09-30
* **Build Commit:** `82571ad` (com alterações locais); relatório [`argos_profiles`](../../tools/argos/reports/20260930-183035_82571ad/REPORT.md), perfil `grinder` (build `guardiao/marca/controle`, 4 sementes, 65 tentativas por campanha: 5 até a primeira vitória e 60 extras).
* **Métrica observada:** nível 10 na tentativa 5, 23 na 20, 28 na 40 e 33 na 65 (ganho de ~0,1 nível por tentativa depois da 40); **~340 itens guardados** e save de **~27 KB**; **~850 Resíduo de Lúmen** acumulado. O único consumo do Resíduo é o Reforço +1 (5 por item, nível máximo 1, só arma, secundário e armadura), que gasta no máximo ~45 com os itens equipados (9 × 5). O inventário não tem capacidade e o Argos nunca desmonta.
* **Hipótese:** o Resíduo não tem sumidouro depois do primeiro Reforço de cada peça, e o inventário cresce ~5 itens por tentativa, linearmente. Com Reforço de nível único isso é esperado pelo recorte, mas é exatamente o que um jogador que repete a expedição sente. O Argos não mede diversão nem desempenho no aparelho.
* **Proposta do Argos:** nenhuma mudança agora. Decidir, junto com níveis de Reforço acima de +1 e a capacidade de inventário (fora do slice), quais são os sumidouros do Resíduo e dos itens; o perfil `hoarder` volta quando houver capacidade.
* **Decisão humana:** **Pendente (Rafael).**

### [BAL-015] Beginner: 44% de abandono, concentrado nas builds com Íris Arcano
* **Data:** 2026-09-30
* **Build Commit:** `82571ad` (com alterações locais); relatório [`argos_profiles`](../../tools/argos/reports/20260930-183035_82571ad/REPORT.md), perfil `beginner` (primeira opção em toda escolha, equipa só a partir da 2ª tentativa, não usa Árvore nem Ferreiro, desiste após 6 derrotas seguidas).
* **Métrica observada:** 16 campanhas; **56% vencem** (mediana da primeira vitória: tentativa 4) e **44% abandonam**. As duas builds `guardiao/marca/arcano` e `retaliacao/marca/arcano` abandonam (0% e 25% de vitória); as duas com `lumen` vencem 100% em 4 tentativas (nível 8–9).
* **Hipótese:** consistente com BAL-011 (Íris `arcano` fraca): sem a escolha do melhor item, sem gastar e sem ler o kit, a build sem cura não sustenta o Guardião. As escolhas do perfil são HIPÓTESE do Argos, não dado de jogadores reais; o resultado mede sensibilidade, não a taxa de abandono humana.
* **Proposta do Argos:** nenhuma mudança agora; no playtest do `1E`, observar quem escolhe Arcano e o que faz depois de três derrotas.
* **Decisão humana:** **Pendente (Rafael).**
