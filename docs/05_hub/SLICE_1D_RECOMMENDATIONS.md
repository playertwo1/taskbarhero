---
id: SLICE_1D_RECOMMENDATIONS
status: DESIGN
certainty: HIPOTESE
---

# Recomendações para o SLICE-1D

Este documento registra as decisões e as hipóteses adotadas para iniciar o retorno ao Refúgio. O Echo escolhido já foi implementado; a hipótese de economia continua sem aprovação para runtime. Fontes de autoridade: economia em [`ECONOMY_MODEL.md`](../06_balance/ECONOMY_MODEL.md), regras gerais de Echo em [`ECHO_SYSTEM.md`](../03_systems/ECHO_SYSTEM.md), recorte do capítulo em [`SLICE_1_SCOPE.md`](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) e IDs no [`CONTENT_REGISTRY.md`](../CONTENT_REGISTRY.md).

## 1. Árvore dos Ecos e Ferreiro

### Evidência atual

O modelo de economia já propõe custos por faixa — Baixo 2, Médio 4, Alto 7 e Keystone 12 Fragmentos — e um orçamento de 24 Fragmentos para a rota inicial do Ferreiro. A distribuição proposta por macrofase é 2 / 4 / 5 / 5 / 8. Esses números são `HIPÓTESE`, não estão em runtime e não foram aprovados como balanceados.

A rota do slice precisa de 24 Fragmentos para abrir `TREE_VIG_002` → `TREE_VIG_005` → `TREE_OFI_001` → `TREE_OFI_002` → `TREE_OFI_003`. Pelos valores atuais, as quatro macrofases antes do Guardião concederiam apenas 16. Uma party que conclua essas fases e perca para o Guardião voltaria ao Refúgio sem Fragmentos suficientes para restaurar o Ferreiro; as repetições não deveriam pagar novamente os marcos de primeira conclusão.

### Recomendação

Para a primeira hipótese implementável, manter os custos dos nós e testar **32 Fragmentos únicos no Capítulo 1**, distribuídos como **4 / 6 / 7 / 7 / 8** pelas cinco macrofases. Assim, os quatro marcos anteriores ao Guardião somam 24: uma derrota no primeiro confronto ainda permite restaurar o Ferreiro, desmontar e comprar o Reforço +1 antes da próxima tentativa. A primeira vitória contra o Guardião concede os 8 restantes.

Essa proposta aumenta em 8 o orçamento atual. A comparação aritmética está registrada no [modelo econômico](../06_balance/ECONOMY_MODEL.md): com recompensas únicas, 32 libera a rota completa depois da quarta macrofase; 24 só a libera após a recompensa do Guardião. A simulação ainda não modela persistência/save, gastos concorrentes nem respec. Os números seguem como `HIPÓTESE`; não foram gravados em `/data` nem aprovados como balanceados.

## 2. Echo — A Sentinela que Ficou

### Base aprovada

O recorte já escolhe o nome, o efeito narrativo e a recompensa: *A Sentinela que Ficou* é opcional, modifica Muralha Viva e é obtida na primeira vitória contra a Geleia Anciã. Ela fica no inventário persistente, é equipada no Hub e não custa Fragmentos. O Golden Reference do Bastião descreve proteção adicional ao aliado com menos vida que esteja ligeiramente fora da área.

### Lacuna encontrada no runtime

Muralha Viva usa atualmente `targets: "allies_behind"`. Com Bastião na frente e três heróis ativos, esse grupo já inclui os outros dois heróis. O combate não representa distância ou alcance dentro dessas posições; portanto, aplicar o Echo a outro aliado fora do conjunto atual não teria alvo na formação padrão e poderia resultar em um efeito sem função.

### Recomendação de adaptação

Para preservar o comportamento atual da skill e evitar criar um sistema de alcance no 1D, tratar como elegível para o Echo o herói ativo que ficou fora da lista normal de Muralha Viva. Na formação padrão, esse herói é Bastião. O Echo aplica a ele o mesmo efeito defensivo e a mesma duração já definidos para Muralha Viva **somente quando sua porcentagem de HP for a menor da party**. Empates seguem a ordem da formação. Assim, o Echo acrescenta proteção ao herói que normalmente fica fora do conjunto de aliados protegidos, sem inventar novos números.

Rafael escolheu seguir esta adaptação para o protótipo em 2026-09-29. A regra fica registrada como direção de design para validação em jogo: ainda é `HIPÓTESE` até a interação ser implementada e jogada. Ela interpreta “aliado” como um membro ativo da party, incluindo Bastião; não altera números, duração nem o contrato atual de alvos da skill.

Rafael autorizou testar e implementar esta recomendação em 2026-09-29. O Echo está registrado como `ECHO_C1_001` / `echo_c1_001`; ficha e evidência em [conteúdo](../04_content/echoes/echo_c1_001_a_sentinela_que_ficou.md). A regra continua `HIPÓTESE` até playtest.

## Estado das decisões (2026-09-29)

- **Árvore (2026-09-29):** Rafael aprovou os 32 Fragmentos (4/6/7/7/8) para o runtime do slice; marcos em `route_c1.json`, nós em `data/progression/resonance_tree_slice.json`. Continua `HIPÓTESE` até o playtest do 1E. Histórico: Rafael pediu a simulação de 32 Fragmentos. O resultado favorece essa hipótese para abrir o Ferreiro antes do Guardião, mas a rota ainda precisa de marcos ordenados e a economia completa precisa cobrir persistência, respec e gastos concorrentes antes de gravar recompensas no runtime.
- **Echo:** adaptação condicional implementada e coberta pelos testes Godot focados; o playtest ainda deve validar sua utilidade e leitura.
- **ID:** `ECHO_C1_001` / `echo_c1_001` registrado para o Echo do slice.

Nenhuma dessas escolhas deve alterar o balanceamento do Guardião antes do playtest acordado por Rafael.
