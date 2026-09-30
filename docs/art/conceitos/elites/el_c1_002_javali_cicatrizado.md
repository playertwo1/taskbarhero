# Javali Cicatrizado

**ID:** `EL_C1_002` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Elite · Pesado.
- **Arquétipo:** `HEAVY` · **perfil de status:** `HEAVY_ELITE`.
- **Função no encontro:** Investidas pesadas e pressão de stagger.
- **Comportamento-base proposto:** Telegrava investidas longas que empurram e desequilibram; após errar, fica vulnerável por um intervalo.

## Base visual para sprite

Um javali largo, com cicatrizes grossas cruzando o focinho e a placa frontal. Musgo denso cresce sobre o dorso como proteção irregular; presas quebradas e uma postura baixa comunicam força sem copiar o conceito legado do Javali de Musgo.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×3,22 · ATK ×1,0625 · DEF ×1,4375 · AS ×0,70**; tenacidade **+25**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 30–45.
- **Material principal:** `MAT_C1_DENSE_MOSS` — chance 100%, quantidade 1–2 (garantido).
- **Essência Corrompida:** MAT_C1_CORRUPTED_ESSENCE · 30%, quantidade 1.
- **Equipamento:** Garantido · ITEM_W_003 ou ITEM_A_004; chance adicional 20%.
- **Drops assinatura:** ITEM_W_003 · 12%; ITEM_A_004 · 7%.
- **Eco:** Nenhum drop de Eco definido.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `EL_C1_002`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
- [Conceito visual v002](../../referencia/capitulo_01/elites/EL_C1_002_javali_cicatrizado_conceito_v002.png) — referência atual, não sprite final.
- [Conceito visual anterior v001](../../referencia/capitulo_01/elites/EL_C1_002_javali_cicatrizado_conceito_v001.png) — histórico.
