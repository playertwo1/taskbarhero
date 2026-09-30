---
id: SLICE_1D_RECOMMENDATIONS
status: DESIGN
certainty: HIPOTESE
---

# Recomendações para o SLICE-1D

Este documento propõe decisões para iniciar o retorno ao Refúgio. As propostas não aprovam valores runtime, não alteram o recorte e não liberam implementação. Depois da revisão de Rafael, cada decisão aceita deve ser incorporada à sua fonte de autoridade: economia em [`ECONOMY_MODEL.md`](../06_balance/ECONOMY_MODEL.md), regras gerais de Echo em [`ECHO_SYSTEM.md`](../03_systems/ECHO_SYSTEM.md), recorte do capítulo em [`SLICE_1_SCOPE.md`](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) e IDs no [`CONTENT_REGISTRY.md`](../CONTENT_REGISTRY.md).

## 1. Árvore dos Ecos e Ferreiro

### Evidência atual

O modelo de economia já propõe custos por faixa — Baixo 2, Médio 4, Alto 7 e Keystone 12 Fragmentos — e um orçamento de 24 Fragmentos para a rota inicial do Ferreiro. A distribuição proposta por macrofase é 2 / 4 / 5 / 5 / 8. Esses números são `HIPÓTESE`, não estão em runtime e não foram aprovados como balanceados.

A rota do slice precisa de 24 Fragmentos para abrir `TREE_VIG_002` → `TREE_VIG_005` → `TREE_OFI_001` → `TREE_OFI_002` → `TREE_OFI_003`. Pelos valores atuais, as quatro macrofases antes do Guardião concederiam apenas 16. Uma party que conclua essas fases e perca para o Guardião voltaria ao Refúgio sem Fragmentos suficientes para restaurar o Ferreiro; as repetições não deveriam pagar novamente os marcos de primeira conclusão.

### Recomendação

Para a primeira hipótese implementável, manter os custos dos nós e testar **32 Fragmentos únicos no Capítulo 1**, distribuídos como **4 / 6 / 7 / 7 / 8** pelas cinco macrofases. Assim, os quatro marcos anteriores ao Guardião somam 24: uma derrota no primeiro confronto ainda permite restaurar o Ferreiro, desmontar e comprar o Reforço +1 antes da próxima tentativa. A primeira vitória contra o Guardião concede os 8 restantes.

Essa proposta aumenta em 8 o orçamento atual. Antes de gravá-la em `/data`, comparar em simulação a proposta atual de 24 com esta de 32, incluindo derrotas após cada macrofase, respec sem custo dos nós numéricos e proteção contra prêmio duplicado em retries/save. Se Rafael preferir manter 24, a consequência explícita é que a rota completa do Ferreiro só fica disponível após a primeira vitória sobre o Guardião; o serviço não ajuda a preparar uma nova tentativa contra ele.

## 2. Echo — A Sentinela que Ficou

### Base aprovada

O recorte já escolhe o nome, o efeito narrativo e a recompensa: *A Sentinela que Ficou* é opcional, modifica Muralha Viva e é obtida na primeira vitória contra a Geleia Anciã. Ela fica no inventário persistente, é equipada no Hub e não custa Fragmentos. O Golden Reference do Bastião descreve proteção adicional ao aliado com menos vida que esteja ligeiramente fora da área.

### Lacuna encontrada no runtime

Muralha Viva usa atualmente `targets: "allies_behind"`. Com Bastião na frente e três heróis ativos, esse grupo já inclui os outros dois heróis. O combate não representa distância ou alcance dentro dessas posições; portanto, aplicar o Echo a outro aliado fora do conjunto atual não teria alvo na formação padrão e poderia resultar em um efeito sem função.

### Recomendação de adaptação

Para preservar o comportamento atual da skill e evitar criar um sistema de alcance no 1D, tratar como elegível para o Echo o herói ativo que ficou fora da lista normal de Muralha Viva. Na formação padrão, esse herói é Bastião. O Echo aplica a ele o mesmo efeito defensivo e a mesma duração já definidos para Muralha Viva **somente quando sua porcentagem de HP for a menor da party**. Empates seguem a ordem da formação. Assim, o Echo acrescenta proteção ao herói que normalmente fica fora do conjunto de aliados protegidos, sem inventar novos números.

Essa é uma interpretação de design, ainda `HIPÓTESE`: a ficha original diz “aliado”, o que pode excluir o próprio Bastião. Se Rafael quiser manter essa leitura estrita, a alternativa é adiar o Echo até existir um contrato de alcance que deixe outro herói fora da área normal.

Como candidato de nomenclatura, usar design ID `ECHO_C1_001` e runtime ID `echo_c1_001`. Não registrar esses IDs nem criar dados runtime até a aprovação da ficha e da convenção de IDs.

## Decisões para revisão

- **Árvore:** testar a distribuição proposta de 32 Fragmentos para disponibilizar o Reforço após uma derrota no primeiro Guardião, ou manter 24 e aceitar o desbloqueio do Ferreiro somente após a vitória.
- **Echo:** aceitar a proteção condicional do Bastião como adaptação discreta, ou adiar o Echo até definir alcance espacial.
- **ID:** aprovar ou rejeitar o candidato `ECHO_C1_001` / `echo_c1_001` antes de atualizar o registry.

Nenhuma dessas escolhas deve alterar o balanceamento do Guardião antes do playtest acordado por Rafael.
