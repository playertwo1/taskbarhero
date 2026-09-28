# Sapinho do Lúmen

**ID:** `EN_C1_010` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Comum · Padrão.
- **Arquétipo:** `STANDARD` · **perfil de status:** `STANDARD_NORMAL`.
- **Função no encontro:** Mobilidade e interrupção.
- **Comportamento-base proposto:** Salta entre linhas e interrompe ações vulneráveis com investidas curtas; a pose de preparação deve anunciar o salto.

## Base visual para sprite

Um anfíbio pequeno de pernas fortes, pele verde profunda e pontos de lúmen nas costas. Olhos grandes e postura agachada antecipam o salto; poucos pontos luminosos, agrupados em marcas claras.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×0,85 · ATK ×0,75 · DEF ×0,75 · AS ×1,00**; tenacidade **0**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 3–7.
- **Material principal:** `MAT_C1_LUMEN_RESIDUE` — chance 65%, quantidade 1.
- **Equipamento:** 11% · ITEM_R_003 ou ITEM_R_001.
- **Drops assinatura:** ITEM_R_003 · 2%; ITEM_R_001 · 1%.
- **Eco:** Nenhum drop de Eco definido.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EN_C1_010`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
