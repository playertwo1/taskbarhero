# Javali da Ponte

**ID:** `MB_C1_002` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Minichefe · Pesado.
- **Arquétipo:** `HEAVY` · **perfil de status:** `HEAVY_MINIBOSS`.
- **Função no encontro:** Investidas e controle de espaço na ponte.
- **Comportamento-base proposto:** Domina uma faixa estreita com investidas telegráficas e golpes que ocupam espaço; a party deve ler direção e reposicionar-se.

## Base visual para sprite

Um javali colossal cuja armadura de casca e musgo lembra tábuas partidas de uma ponte antiga. Presas largas apontam para a frente e cicatrizes claras cruzam a testa; não incluir elementos de cenário incorporados que confundam a silhueta.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×9,80 · ATK ×1,3175 · DEF ×1,6875 · AS ×0,70**; tenacidade **+50**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [v1 · inimigos e chefes](../../../06_balance/v1/06_INIMIGOS_CHEFES.md) e [fórmulas de combate](../../../06_balance/v1/01_STATUS_E_COMBATE.md).

## Drops canônicos (resumo)

- **Ouro:** 90–130.
- **Material principal:** `MAT_C1_DENSE_MOSS` — chance 100%, quantidade 2–4 (garantido).
- **Essência Corrompida:** MAT_C1_CORRUPTED_ESSENCE · garantida, quantidade 1.
- **Equipamento:** Garantido · ITEM_W_003, ITEM_A_004 ou ITEM_A_003; chance adicional 35%.
- **Drops assinatura:** ITEM_W_003 · 20%; ITEM_A_004 · 15%; ITEM_A_003 · 8%.
- **Eco:** Nenhum drop de Eco definido.
- **Recompensa à escolha:** Escolha de recompensa: 25%; 3 opções, escolher 1; pool POOL_C1_MINIBOSS.

O [JSON canônico do bestiário](../../../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `MB_C1_002`.
- [Bestiário do Capítulo 1](../../../04_content/enemies/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/minichefes/MB_C1_002_javali_da_ponte_conceito_v002.png) — referência atual, não sprite final.
