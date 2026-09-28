# Trepa-Cadáver

**ID:** `EN_C1_007` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Comum · Pesado.
- **Arquétipo:** `HEAVY` · **perfil de status:** `HEAVY_NORMAL`.
- **Função no encontro:** Inimigo resistente que retorna se não for finalizado.
- **Comportamento-base proposto:** Avança devagar e pode se recompor depois de cair se a party não concluir a finalização dentro da janela prevista.

## Base visual para sprite

Uma criatura de raízes retorcidas que carrega restos de madeira e folhas como uma carapaça. Tronco largo, membros compridos e uma cavidade central sugerem que ela se ergue de matéria morta; evitar aparência humana explícita.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×1,40 · ATK ×0,85 · DEF ×1,25 · AS ×0,70**; tenacidade **0**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 5–8.
- **Material principal:** `MAT_C1_ANCESTRAL_FIBER` — chance 85%, quantidade 1.
- **Equipamento:** 12% · ITEM_R_009 ou ITEM_R_007.
- **Drops assinatura:** ITEM_R_009 · 1,25%; ITEM_R_007 · 1%.
- **Eco:** Nenhum drop de Eco definido.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EN_C1_007`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
