# Geleia Anciã

**ID:** `EL_C1_001` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Elite · Padrão.
- **Arquétipo:** `STANDARD` · **perfil de status:** `STANDARD_ELITE`.
- **Função no encontro:** Adiciona aliados e sustenta o combate.
- **Comportamento-base proposto:** Invoca geleias menores e se recupera ao absorver energia do campo; eliminar as invocações diminui a sustentação da elite.

## Base visual para sprite

Uma geleia grande, antiga e assimétrica, com camadas internas como anéis de crescimento. Núcleo dourado-esverdeado e fragmentos de musgo presos no corpo distinguem-na da geleia comum; não reutilizar o Golden da geleia comum como sprite final.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×1,955 · ATK ×0,9375 · DEF ×0,8625 · AS ×1,00**; tenacidade **+25**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 25–40.
- **Material principal:** `MAT_C1_LUMEN_RESIDUE` — chance 100%, quantidade 1–2 (garantido).
- **Essência Corrompida:** MAT_C1_CORRUPTED_ESSENCE · 25%, quantidade 1.
- **Equipamento:** Garantido · ITEM_R_001 ou ITEM_E_001; chance adicional 20%.
- **Drops assinatura:** ITEM_E_001 · 8%; ITEM_R_001 · 12%.
- **Eco:** ITEM_E_001 · base 8%; proteção de bestiário ativa.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EL_C1_001`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/elites/EL_C1_001_geleia_ancia_conceito_v002.png) — referência atual, não sprite final.
- [Conceito visual anterior v001](../../referencia/capitulo_01/elites/EL_C1_001_geleia_ancia_conceito_v001.png) — histórico.
