# Mariposa Luminosa

**ID:** `EN_C1_005` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Comum · Suporte.
- **Arquétipo:** `SUPPORT` · **perfil de status:** `SUPPORT_NORMAL`.
- **Função no encontro:** Fortalece aliados e sustenta a formação.
- **Comportamento-base proposto:** Fica atrás dos aliados e emite pulsos de luz que os fortalecem; interromper sua ação reduz a pressão do grupo.

## Base visual para sprite

Uma mariposa pequena, de asas largas e translúcidas, com marcas luminosas em forma de veios. O corpo é delicado e a luz se concentra no tórax; as asas devem formar uma silhueta legível mesmo em tamanho reduzido.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×0,70 · ATK ×0,55 · DEF ×0,70 · AS ×0,85**; tenacidade **0**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 4–7.
- **Material principal:** `MAT_C1_LUMEN_RESIDUE` — chance 70%, quantidade 1.
- **Equipamento:** 11% · ITEM_R_005.
- **Drops assinatura:** ITEM_R_005 · 1%.
- **Eco:** ITEM_E_002 · base 0,35%; proteção de bestiário ativa.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EN_C1_005`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/inimigos_comuns/EN_C1_005_mariposa_luminosa_conceito_v002.png) — referência atual, não sprite final.
- [Conceito visual anterior v001](../../referencia/capitulo_01/inimigos_comuns/EN_C1_005_mariposa_luminosa_conceito_v001.png) — histórico.
