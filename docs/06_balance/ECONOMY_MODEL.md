---
status: DESIGN
---

# ECON-1 — Modelo econômico inicial

**Revisão:** 2026-09-28  
**Escopo:** diagnóstico estático do runtime MVP e cenário econômico inicial do slice.  
**Autoridade:** este documento contém hipóteses e resultados da versão ECON-1 v0.1; não define a economia global. Para materiais, raridades, tabelas e regras de loot, prevalece a [base canônica v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md). Não altera runtime nem declara números balanceados.

## Objetivo e limites

Definir fontes, usos, custos relativos e ritmo-alvo para que o primeiro slice possa testar uma economia pequena, sem adicionar moedas sem função. A implementação atual serve como baseline observável; seus valores não são automaticamente a proposta do slice.

- **DECIDIDO:** Ouro e XP continuam recursos do jogo; Fragmentos de Ressonância financiam a Árvore dos Ecos. Por delegação, o material inicial do Ferreiro no recorte do slice é Resíduo de Lúmen (`MAT_C1_LUMEN_RESIDUE`), existente no catálogo canônico v0.4. Sucata não consta no cânone e está fora do recorte.
- **DECIDIDO:** Fragmentos vêm principalmente de primeiras vitórias e marcos de campanha; repetir conteúdo não deve ser o melhor farm. Desbloqueios de serviços permanecem depois de respec.
- **LIMITE DOS CÁLCULOS v0.1:** a simulação inicial usa o runtime antigo e uma conversão hipotética para Sucata. Ela serve como diagnóstico histórico do MVP, não como estimativa de rendimento dos materiais v0.4. O catálogo global e suas regras permanecem na base canônica; a simulação do slice ainda precisa ser refeita com conteúdo selecionado.
- **HIPÓTESE neste modelo:** custos quantitativos e metas de ritmo abaixo são pontos de partida para simulação, conteúdo e playtest, não valores finais nem aprovação de runtime.

## Fontes e usos

| Recurso | Fonte do modelo | Uso/sink | Tratamento no primeiro slice |
| --- | --- | --- | --- |
| XP | Vitórias em combate; o runtime atual também concede XP offline. | Nível do herói/conta conforme sistema existente. | Calibrar a curva de conteúdo para chegar ao boss no nível previsto; sem gasto de XP. |
| Ouro | Kills e líderes; runtime atual também concede Ouro offline. | **HIPÓTESE:** custo secundário de uma melhoria controlada do Ferreiro. | Não comprar nós da Árvore nem obrigar repetição de fase para pagar um serviço essencial. |
| Resíduo de Lúmen (`MAT_C1_LUMEN_RESIDUE`) | Drops canônicos e recompensa determinística opcional de primeiro clear; desmontagem explícita também pode retornar material do catálogo conforme v0.4. | Aprimoramento controlado do Ferreiro. | Único material no recorte proposto para o ciclo inicial; sem concessão repetível por evento. Quantidade e rendimento seguem em aberto. |
| Fragmentos de Ressonância | Primeiras vitórias e objetivos/marcos de campanha determinísticos. | Nós da Árvore dos Ecos. | Não vêm de kills comuns; repetição concede zero ou retorno deliberadamente baixo, definido antes de publicação. |
| Equipamento | Drops e recompensas determinísticas curadas. | Equipar ou desmontar voluntariamente para obter material canônico compatível. | Uma build necessária para vencer não depende de um drop aleatório específico. |

XP não é moeda e não deve ser misturado à economia de compra. Ouro não compra a progressão principal da Árvore. O Echo funcional do slice é recompensa determinística opcional e não tem custo recorrente.

## Custos-proposta para simular

### Árvore dos Ecos

**HIPÓTESE v0.1 — conversão das faixas relativas do catálogo `TREE-1`:**

| Faixa atual do nó | Custo inicial proposto |
| --- | ---: |
| Grátis | 0 Fragmentos |
| Baixo | 2 Fragmentos |
| Médio | 4 Fragmentos |
| Alto | 7 Fragmentos |
| Keystone | 12 Fragmentos |

Aplicada às 30 linhas atuais do catálogo (5 Baixos, 12 Médios, 11 Altos, 1 Keystone e 1 Grátis), a proposta soma **147 Fragmentos** para comprar todos os nós. Não representa a duração definitiva da progressão, porque parte do catálogo abre serviços/conteúdo ainda fora do slice.

**HIPÓTESE de ritmo:** a primeira conclusão do Capítulo 1 concede **24 Fragmentos no total**, em recompensas únicas de conclusão das cinco fases macro. O orçamento permite a rota `TREE_VIG_002` (2) → `TREE_VIG_005` (12) → `TREE_OFI_001` (4) → `TREE_OFI_002` (2) → `TREE_OFI_003` (4), abrindo restauração, desmontagem e uma melhoria do Ferreiro. Gastar Fragmentos em outros nós pode adiar essa rota; isso é uma escolha válida, desde que o jogador tenha novos marcos de campanha próximos e não precise repetir conteúdo já concluído. A recompensa de cada macrofase só é concedida uma vez; sair antes de completá-la reinicia a fase, sem repetir o prêmio. `CONTENT-1` deverá validar os eventos de concessão da [ficha do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) e revisar o ritmo; não usar repetição para completar o orçamento.

| Orçamento de primeira conclusão | Resultado possível pela proposta | Leitura para playtest |
| ---: | --- | --- |
| 18 Fragmentos | Abre `TREE_VIG_002` e `TREE_VIG_005`; sobram 4 para um nó Médio. Só restaura o Ferreiro se esse for o nó escolhido; não cobre o ciclo de melhoria. | Cenário baixo; comparar o valor da escolha contra a falta do loop de crafting. |
| **24 Fragmentos** | Cobre exatamente a rota `VIG_002` → `VIG_005` → `OFI_001` → `OFI_002` → `OFI_003`. | **Hipótese-base:** demonstra o primeiro serviço sem deixar pontos livres nessa rota. |
| 30 Fragmentos | Cobre a mesma rota e deixa 6 para um nó Médio e um Baixo acessíveis. | Cenário alto; verificar se ainda preserva metas para capítulos seguintes. |

Distribuição inicial para testar nas cinco fases macro: **2 / 4 / 5 / 5 / 8 Fragmentos**, respectivamente, total 24. As dez subfases continuam beats de conteúdo; o prêmio é dado ao concluir cada macrofase, alinhado à regra de fases concluídas persistentes. Esses valores são uma proposta para `CONTENT-1`, não fonte runtime.

### Ferreiro

**RECOMENDADO para o recorte do slice:** desmontagem usa a regra de materiais de v0.4, limitada inicialmente a Resíduo de Lúmen. Demonstrar um nível de Reforço `+1` por item, que concede `+2%` do poder de status base sem alterar Item Power nem rolar affixes. Cada aplicação usa o custo da fonte estruturada do [plano de encontros](../04_content/chapters/chapter_01/encounter_plan.json); custos de níveis superiores, faixa de raridade e elegibilidade permanecem **EM ABERTO**. A regra de retorno-base de material v0.4 é **25–40%** e varia conforme raridade, Item Power e nível de reforço. Itens equipados, favoritos ou protegidos não podem ser desmontados. Ver [balanceamento de equipamentos](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/EQUIPMENT_BALANCE.md) e [sistema de Item Power](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ITEM_POWER_SYSTEM.md).

**Revisão ECON-1 (2026-09-28):** as formações propostas do capítulo e os parâmetros da simulação estão em [ENCOUNTERS.md](../04_content/chapters/chapter_01/ENCOUNTERS.md) e [encounter_plan.json](../04_content/chapters/chapter_01/encounter_plan.json), fonte estruturada das quantidades, recompensa e custo. A hipótese é **5 Resíduos de Lúmen + 50 Ouros por item** para aplicar `+1` e receber `+2%`; o evento opcional entrega **2 Resíduos** uma vez. A rota simulada sustenta em média 2,49 itens melhorados sem evento e 2,88 com evento; o evento aumenta de 49,2% para 82,2% a chance de melhorar pelo menos três itens. Execute `python tools/economy/simulate_chapter1_balance.py` para reproduzir os resultados. Eles não alteram runtime nem fecham o gate de `ECON-1`.

### Baseline de loot do bestiário canônico — hipótese

Para obter uma primeira leitura sem inventar número de ondas, usar **uma derrota de cada uma das 17 entidades canônicas** na rota: 10 normais, 3 elites, 3 minichefes e o boss. Esta é uma baseline de cobertura do catálogo, não uma composição final de encontros. O mapeamento de aparições está no [overview do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md#estrutura-proposta); adds além dos inimigos nomeados e a recompensa opcional do evento ficam excluídos até fechar suas quantidades.

Com as chances canônicas de material por inimigo normal, essa baseline gera em valor esperado **2,75 Resíduos de Lúmen**, **3,10 Fibras Ancestrais**, **0,85 Musgos Densos** e **0,90 Cristais Verdes**. Os três elites e os três minichefes garantem materiais principais em faixas de quantidade; ao somar esses ranges aos valores esperados dos normais, a referência fica:

| Material | Base esperada dos normais | Material principal garantido de elite/minichefe | Leitura desta baseline |
| --- | ---: | ---: | ---: |
| Resíduo de Lúmen | 2,75 | 1–2 da Geleia Anciã + 2–4 da Rainha das Geleias | 5,75–8,75, antes do evento e de adds extras |
| Fibra Ancestral | 3,10 | 1–2 do Gremlin Espinhento + 2–4 do Espinheiro | 6,10–9,10, antes de adds extras |
| Musgo Denso | 0,85 | 1–2 do Javali Cicatrizado + 2–4 do Javali da Ponte | 3,85–6,85, antes de adds extras |
| Cristal Verde | 0,90 | Nenhum na aparição única do catálogo | Apenas contribuição esperada dos normais |

Esses intervalos combinam o valor esperado dos rolls normais com quantidades garantidas mín./máx. de ranks altos; não são P10–P90. Ainda não estimam a distribuição por run: repetições de inimigos, derrotas, escolhas do jogador e pesos efetivos do resolver mudam os resultados. Essência Corrompida e recompensa de primeira vitória do boss continuam conforme as regras canônicas v0.4; o [JSON de inimigos](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte dos rolls.

### Respec

**RECOMENDADO para o primeiro slice:** respec sem custo de Ouro. Reembolsar somente nós numéricos/efeitos reversíveis; manter serviços, rotas e conteúdos desbloqueados permanentemente, conforme decisão de `TREE-1`. Não há escolhas mutuamente exclusivas no catálogo inicial que justifiquem um custo punitivo de experimentação.

## Diagnóstico estático do runtime atual

Os dados e fórmulas inspecionados são os do runtime legado, removido no `1A-CUT` e recuperável no git a partir do commit `cd47758` (`data/stages/stages.json`, `data/enemies/enemies.json`, `data/items/items.json`, `ProgressionManager.gd`, `GameManager.gd` e `LootManager.gd`). A estimativa supõe uma primeira passagem pelas cinco fases, todos os kills exigidos, um líder nas fases 4 e 5 e as distribuições de inimigos descritas em `stages.json`.

### Primeira conclusão do Bosque nos dados atuais

| Fase runtime | Kills comuns antes de avançar | XP esperado | Ouro esperado |
| --- | ---: | ---: | ---: |
| Entrada do Bosque | 4 | 38,4 | 12,4 |
| Clareira da Pressão | 5 | 75 | 23,75 |
| Ninho Silvestre | 5 | 111 | 36,5 |
| Covil do Alfa + Alfa | 4 + 1 | 133,8 | 44,2 |
| Santuário + Guardião-Cervo | 3 + 1 | 195 | 70,5 |
| **Total esperado** | **23 encontros** | **553,2 XP** | **187,35 Ouros** |

Os valores decimais são médias ponderadas de pools e intervalos aleatórios, não recompensas que o runtime conceda fracionadas. A fórmula de XP pede 244 XP acumulados para sair do nível 1 e alcançar o nível 6; 324 XP para alcançar o nível 7. Portanto, a recompensa média está acima da faixa de nível 5–6 indicada para o final do capítulo e alcança aproximadamente o nível 9 antes de considerar equipamento. Isso é um **finding de curva**, não uma instrução para alterar retroativamente o MVP.

### Progresso offline atual

O runtime estima um kill a cada 4 segundos, usa 8 horas como limite e concede por kill `8 + 4 × fase` XP e `2 + 2 × fase` Ouros. A tabela abaixo é consequência direta dessas fórmulas:

| Fase selecionada | Kills em 8 h | XP | Ouro | Limite de itens do cálculo |
| --- | ---: | ---: | ---: | ---: |
| 1 | 7.200 | 86.400 | 28.800 | até 5 |
| 5 | 7.200 | 201.600 | 86.400 | até 5 |

Esse ganho offline excede muitas vezes a recompensa de uma conclusão inteira do capítulo. A fórmula não usa desempenho recente, TTK medido ou a cadência real do jogador. **Não transportar essa taxa para o slice.** Para a economia futura, usar as mesmas regras de recompensa ativa e processar a expedição até objetivo, derrota ou teto de ausência aprovado; não iniciar outra expedição automaticamente nem aplicar redutor de eficiência offline. A fórmula, a taxa observada e o teto continuam abertos para `ECON-1`/`SLICE-1` e precisam de simulação e playtest.

### Cenário offline limitado à expedição

**DECIDIDO:** a expedição offline termina no objetivo selecionado ou em derrota, volta ao Hub e não inicia outra expedição. Dentro do teto aprovado, usa as mesmas regras de recompensa ativas, sem redutor offline. O teto numérico continua **EM ABERTO**.

Como não há duração de combate/TTK aprovada, não converter horas ausentes em quantidade de encontros nem inventar recompensa por hora. Como limite superior verificável para o objetivo de concluir o Bosque inteiro, uma vitória sem derrotas produz a mesma distribuição de uma única primeira passagem da simulação abaixo: média de 553,32 XP e 187,43 Ouros, com cerca de 6,11 itens. O total real depende de onde objetivo/derrota interrompe a expedição; após o encerramento, ausência adicional não gera recompensas até uma nova expedição ser iniciada pelo jogador. Essa limitação impede a extrapolação atual de até 8 horas, que gera 86.400–201.600 XP e 28.800–86.400 Ouros, conforme a fase selecionada.

Este cenário fecha o limite estrutural para análise econômica, mas não fecha a conversão tempo→progresso, persistência/salvamento nem o teto numérico. Esses pontos dependem de duração medida e implementação em `SLICE-1`.

### Baseline histórico do runtime (cenário com Sucata v0.1)

Os cálculos abaixo descrevem exclusivamente o runtime antigo e a hipótese local de rendimento de Sucata. Sucata não integra o catálogo v0.4; esses números não devem ser usados para determinar o rendimento de Resíduo de Lúmen nem para dimensionar o slice.

Na rota acima, há 22 encontros que usam chance normal de 25% e um boss que usa 60%, resultando em **6,1 itens esperados** por conclusão. A seleção atual é feita numa tabela global de 15 itens com pesos por raridade; não é filtrada pela fase ou por compatibilidade com a build. O peso lendário soma 9 de 258, aproximadamente 3,5% por item sorteado. O cálculo histórico aplicou 1/2/3/4 Sucatas por raridade: isso não é regra canônica e não estima o rendimento de materiais v0.4. A média de itens também não garante equipamento útil e não deve financiar um serviço obrigatório.

O rendimento de material calculado a partir desses drops é apenas um cenário legado: parte dos drops pode ser útil/equipada, a tabela não é segmentada por capítulo e uma média não garante rendimento mínimo. No slice, a garantia opcional de Resíduo de Lúmen controla uma fonte mínima do material sem tornar o serviço obrigatório.

### Simulação de primeira passagem — Monte Carlo v0.1

Foi executada uma simulação Monte Carlo reproduzível de **100.000** primeiras passagens, seed `41783` para combate/recompensas e `41784` para drops. Ela amostra pools e recompensas do conteúdo runtime atual. Cada inimigo comum usa as chances atuais de drop; o Lobo Alfa usa a chance normal por não ter a flag `boss`, e o Guardião-Cervo usa a chance de boss. Os itens foram sorteados pelos pesos existentes. As saídas em Sucata aplicam uma hipótese de rendimento local, agora legada e não compatível com o catálogo v0.4. O script executável é [`simulate_econ1_first_clear.py`](../../arquivados/pipelines_legados/simulate_econ1_first_clear.py), arquivado no `1A-CUT` porque depende do runtime legado removido (`data/stages/stages.json` e linhas legadas de inimigos/itens; recuperáveis pelo git); não é mais executável.

| Métrica da primeira passagem | Média / resultado | Intervalo central P10–P90 |
| --- | ---: | ---: |
| XP ganho | 553,3 | 537–570 |
| Ouro ganho | 187,4 | 170–205 |
| Itens obtidos | 6,1 | 3–9 |
| Sucata se todos os itens forem desmontados | 9,0 | 5–14 |
| Sucata desmontando tudo exceto o melhor item de cada tipo runtime | 4,0 | 1–7 |

Com a curva de XP runtime, **98,9%** das amostras terminam no nível 9 e **1,1%** no nível 8; todas passam do nível 7. No cenário histórico em que se preserva o melhor item de arma, armadura e amuleto, só **53,6%** das amostras rendem as 4 Sucatas propostas. Essa porcentagem só descreve a hipótese antiga e não se transfere ao material v0.4. A melhoria continua opcional; o recorte novo precisa ser simulado com os dados v0.4 e com a recompensa de evento definida em CONTENT-1.

Esta é uma simulação de economia/curva, não teste do jogo: não modela TTK, derrota, durações de expedição, escolha de equipamento útil ou comportamento humano. A seed e a quantidade de amostras tornam o cenário reproduzível; não substituem validação no runtime.

## Findings e recomendações

1. **XP e progressão de capítulo — risco alto:** a rota runtime média entrega 553 XP para fases destinadas aos níveis 1–6. Para o futuro slice, usar como alvo de simulação que a primeira conclusão leve a party ao nível 6, com nível 7 como limite de teste inicial (244–324 XP acumulados na curva atual). Ajustar distribuição e curva somente em dados de conteúdo futuros e validar contra duração/TTK.
2. **Offline — risco alto:** o cálculo estático domina a economia ativa e ignora desempenho. Preservar o comportamento homologado do MVP; para o slice, processar apenas a expedição atual até objetivo, derrota ou teto de ausência, usando as mesmas regras de recompensa ativa sem redutor offline e sem iniciar outra expedição.
3. **Drops — risco médio/alto:** 6,1 itens esperados e pool global não equivalem a 6 itens úteis. Recompensas essenciais do Ferreiro, árvore e progressão de build devem ser determinísticas; drops aleatórios complementam a escolha.
4. **Material do Ferreiro — risco moderado:** o recorte de Resíduo de Lúmen e o custo proposto de `+1` por item foram simulados com o plano v0.4. O custo continua hipótese até playtest; não tornar a melhoria condição de vitória nem exigir o sacrifício da única peça útil.
5. **Fragmentos — risco de farm dominante:** ligar o orçamento inicial a marcos de primeira vitória e limitar repetição. Testar quanto do catálogo se abre no primeiro arco e se a decisão de rota continua significativa.

## Plano mínimo de validação do modelo

1. Aplicar os valores propostos ao catálogo de 30 nós e confirmar custo total, pré-requisitos e caminhos elegíveis.
2. Rodar cenários baixo/médio/alto de recompensas por conclusão, variação dos drops, materiais desmontados e composição de party.
3. Simular primeiro arco, primeira vitória do boss, repetição e retorno offline; registrar saldos de XP, Ouro, Resíduo de Lúmen e Fragmentos, tempo até primeiro upgrade e nós compráveis.
4. Expandir a simulação para repetição e retorno offline depois da validação dos drops; a atual cobre a primeira rota de quinze encontros, materiais/Ouro e quantos itens recebem `+1`.
5. Validar playtest humano e telemetria (XP/h, Ouro/h, itens úteis/h, TTK, tentativas de boss, tempo até melhoria e gasto de Fragmentos). Simulação estática não comprova diversão nem equilíbrio.

## Gate ECON-1

**Estado:** `DESIGN` — modelo e diagnóstico inicial registrados; `ECON-1` ainda não está `PASS`.

O gate pode passar depois que:

- fontes e sinks da economia do slice estiverem definidos, sem recurso necessário sem source ou sink;
- o custo de todos os nós disponíveis no slice e do primeiro serviço do Ferreiro estiverem simulados;
- a primeira passagem e repetição não exigirem farm excessivo; o cenário offline limitado ao objetivo não encadear expedições nem conceder mais que o percurso selecionado; teto e conversão temporal final ficam para medição no `SLICE-1`;
- houver uma rota de conteúdo não repetível para obter o material canônico do Ferreiro, sem obrigar o jogador a sacrificar a única peça útil nem tornar a melhoria condição para concluir o capítulo;
- cenários de variação e critérios de telemetria/playtest estiverem registrados;
- números continuarem marcados como hipóteses até validação humana, sem alterar `/data` ou código neste gate documental.

Próximo passo: validar a rota e o custo `+1` por item em `SLICE-1`, medir duração, TTK e taxa de vitória na primeira tentativa do Guardião, além de converter o cenário limitado por objetivo em cálculo offline com teto numérico.
