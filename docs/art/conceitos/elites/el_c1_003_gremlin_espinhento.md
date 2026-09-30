# Gremlin Espinhento

**ID:** `EL_C1_003` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Elite · Assassino.
- **Arquétipo:** `ASSASSIN` · **perfil de status:** `ASSASSIN_ELITE`.
- **Função no encontro:** Assassino que pressiona a retaguarda.
- **Comportamento-base proposto:** Procura uma abertura para saltar sobre a retaguarda; o ataque de avanço precisa de telegraph legível e janela de resposta.

## Base visual para sprite

Uma criatura pequena e angular, com espinhos curvos de madeira escura ao longo dos ombros e antebraços. Silhueta inclinada para frente, pernas longas e máscara facial simples sugerem velocidade e ameaça; não reaproveitar automaticamente o Gremlin de Folha legado.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×1,265 · ATK ×1,4375 · DEF ×0,575 · AS ×1,25**; tenacidade **+25**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 25–45.
- **Material principal:** `MAT_C1_ANCESTRAL_FIBER` — chance 100%, quantidade 1–2 (garantido).
- **Essência Corrompida:** MAT_C1_CORRUPTED_ESSENCE · 25%, quantidade 1.
- **Equipamento:** Garantido · ITEM_W_002 ou ITEM_A_001; chance adicional 20%.
- **Drops assinatura:** ITEM_W_002 · 12%; ITEM_A_001 · 10%.
- **Eco:** Nenhum drop de Eco definido.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EL_C1_003`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/elites/EL_C1_003_gremlin_espinhento_conceito_v002.png) — referência atual, não sprite final.
- [Conceito visual anterior v001](../../referencia/capitulo_01/elites/EL_C1_003_gremlin_espinhento_conceito_v001.png) — histórico.
