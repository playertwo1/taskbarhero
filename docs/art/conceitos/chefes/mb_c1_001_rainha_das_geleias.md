# Rainha das Geleias

**ID:** `MB_C1_001` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Minichefe · Padrão.
- **Arquétipo:** `STANDARD` · **perfil de status:** `STANDARD_MINIBOSS`.
- **Função no encontro:** Invoca geleias e controla o campo.
- **Comportamento-base proposto:** Alterna entre convocar servos e abrir o núcleo central; a arena exige lidar com os acréscimos antes da janela de dano.

## Base visual para sprite

Uma massa régia composta por várias geleias unidas num corpo central, com uma coroa orgânica de filamentos luminosos. A parte inferior se divide em pequenas formas auxiliares; a silhueta deve continuar clara sem cenário ou efeitos.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×5,95 · ATK ×1,1625 · DEF ×1,0125 · AS ×1,00**; tenacidade **+50**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 80–110.
- **Material principal:** `MAT_C1_LUMEN_RESIDUE` — chance 100%, quantidade 2–4 (garantido).
- **Essência Corrompida:** MAT_C1_CORRUPTED_ESSENCE · garantida, quantidade 1.
- **Equipamento:** Garantido · ITEM_R_001, ITEM_E_001 ou ITEM_S_004; chance adicional 35%.
- **Drops assinatura:** ITEM_R_001 · 25%; ITEM_E_001 · 20%; ITEM_S_004 · 5%.
- **Eco:** ITEM_E_001 · base 20%; sem proteção de bestiário.
- **Recompensa à escolha:** Escolha de recompensa: 25%; 3 opções, escolher 1; pool POOL_C1_MINIBOSS.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `MB_C1_001`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
