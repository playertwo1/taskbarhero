# Caracol Cristalino

**ID:** `EN_C1_008` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Comum · Pesado.
- **Arquétipo:** `HEAVY` · **perfil de status:** `HEAVY_NORMAL`.
- **Função no encontro:** Defesa alta com janela de vulnerabilidade.
- **Comportamento-base proposto:** Recolhe-se para reduzir dano e depois se expõe por um breve intervalo; a leitura visual precisa deixar claro quando está protegido.

## Base visual para sprite

Um caracol compacto cuja concha é feita de placas cristalinas verdes, facetadas em poucos blocos grandes. A concha domina a silhueta; uma abertura brilhante revela o corpo vulnerável sem excesso de reflexos.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×1,40 · ATK ×0,85 · DEF ×1,25 · AS ×0,70**; tenacidade **0**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 5–8.
- **Material principal:** `MAT_C1_GREEN_CRYSTAL` — chance 90%, quantidade 1.
- **Equipamento:** 13% · ITEM_A_003 ou ITEM_R_005.
- **Drops assinatura:** ITEM_A_003 · 2%; ITEM_R_005 · 1,5%.
- **Eco:** Nenhum drop de Eco definido.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EN_C1_008`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/inimigos_comuns/EN_C1_008_caracol_cristalino_conceito_v002.png) — referência atual, não sprite final.
- [Conceito visual anterior v001](../../referencia/capitulo_01/inimigos_comuns/EN_C1_008_caracol_cristalino_conceito_v001.png) — histórico.
