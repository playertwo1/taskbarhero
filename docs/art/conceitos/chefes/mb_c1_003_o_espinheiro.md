# O Espinheiro

**ID:** `MB_C1_003` <br>
**Estado do conteúdo:** `APPROVED` conforme bestiário v0.4 <br>
**Estado visual:** `CONCEPT` — proposta inicial, ainda sem aprovação de arte.

## Identidade e função

- **Categoria:** Minichefe · Controlador.
- **Arquétipo:** `CONTROLLER` · **perfil de status:** `CONTROLLER_MINIBOSS`.
- **Função no encontro:** Ocupação progressiva da arena por raízes e espinhos.
- **Comportamento-base proposto:** Espalha raízes e zonas de espinhos aos poucos, reduzindo espaço seguro; deixa uma janela vulnerável após expandir o campo.

## Base visual para sprite

Uma entidade vegetal compacta formada por um núcleo lenhoso e uma coroa de espinhos grossos, com raízes curtas como pernas. Ramos assimétricos criam uma silhueta reconhecível; evitar visual humanoide e excesso de espinhos finos.

**Direção comum:** sprite 2D original em pixel art, vista lateral estrita e voltado para a esquerda. Priorizar silhueta e leitura em tamanho pequeno, iluminação do alto à esquerda e paleta registrada no guia. Esta é uma hipótese visual, sem contrato de produção nem definição de canvas/animação. Antes de gerar, seguir o [fluxo de conceitos](../README.md), o [blueprint visual](../../ASSET_VISUAL_BLUEPRINT.md), o [guia de estilo](../../SPRITE_STYLE_GUIDE.md), a [paleta](../../PALETTE.md) e o contrato/Golden aplicável. Não usar sprites legados como referência automática.

## Status de combate para balanceamento

Multiplicadores do perfil sobre o `HERO_REFERENCE`, antes do nível de conteúdo e modificadores de capítulo: **HP ×5,25 · ATK ×1,0075 · DEF ×1,08 · AS ×0,80**; tenacidade **+50**. O nível de conteúdo é `C1_DYNAMIC`. Multiplicadores são referências de design, não valores de runtime nem status absolutos. Consulte [ENEMY_STATS_BALANCE](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md) e [fórmulas de combate](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md).

## Drops canônicos (resumo)

- **Ouro:** 90–130.
- **Material principal:** `MAT_C1_ANCESTRAL_FIBER` — chance 100%, quantidade 2–4 (garantido).
- **Essência Corrompida:** MAT_C1_CORRUPTED_ESSENCE · garantida, quantidade 1.
- **Equipamento:** Garantido · ITEM_R_009, ITEM_R_008 ou ITEM_E_003; chance adicional 35%.
- **Drops assinatura:** ITEM_R_009 · 18%; ITEM_R_008 · 12%; ITEM_E_003 · 7%.
- **Eco:** ITEM_E_003 · base 7%; sem proteção de bestiário.
- **Recompensa à escolha:** Escolha de recompensa: 25%; 3 opções, escolher 1; pool POOL_C1_MINIBOSS.

O [JSON canônico do bestiário](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) é a fonte de verdade para campos, pools, chances e quantidades. Este resumo é somente guia de leitura; não editar valores aqui para balancear. Skills e imunidades específicas ainda não estão definidas no registro canônico; não as invente ao implementar.

## Referências

- [Ficha canônica completa e loot](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) — buscar por `MB_C1_003`.
- [Bestiário do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md).
