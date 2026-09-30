# Raposa Oca

**ID:** `EN_C1_009` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Comum · Assassino.
- **Arquétipo:** `ASSASSIN` · **perfil de status:** `ASSASSIN_NORMAL`.
- **Função no encontro:** Ilusões e duplicatas para confundir alvos.
- **Comportamento-base proposto:** Cria imagens falsas e tenta atacar de lado; a duplicata deve ser distinguível por contorno e brilho, sem depender de cor apenas.

## Base visual para sprite

Uma raposa esguia de pelo escuro, com partes do corpo parecendo vazias ou recortadas pela sombra. Cauda bifurcada em rastros translúcidos sugere duplicação; mantenha olhos e focinho nítidos para leitura em pixel art.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×0,55 · ATK ×1,15 · DEF ×0,50 · AS ×1,25**; tenacidade **0**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [v1 · inimigos e chefes](../../../06_balance/v1/06_INIMIGOS_CHEFES.md) e [fórmulas de combate](../../../06_balance/v1/01_STATUS_E_COMBATE.md).

## Drops canônicos (resumo)

- **Ouro:** 5–8.
- **Material principal:** `MAT_C1_LUMEN_RESIDUE` — chance 75%, quantidade 1.
- **Equipamento:** 14% · ITEM_W_004, ITEM_R_006 ou ITEM_R_004.
- **Drops assinatura:** ITEM_R_006 · 2%; ITEM_R_004 · 1%.
- **Eco:** Nenhum drop de Eco definido.

O [JSON canônico do bestiário](../../../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EN_C1_009`.
- [Bestiário do Capítulo 1](../../../04_content/enemies/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/inimigos_comuns/EN_C1_009_raposa_oca_conceito_v002.png) — referência atual, não sprite final.
