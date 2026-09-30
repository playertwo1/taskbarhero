# UI_S12 — referências de layout v002

**Status:** conceitos gerados em 2026-09-30 com as âncoras de UI do Pocket Hero e o [contrato global de criação de imagens](../../IMAGE_CREATION_CONTRACT.md). Aguardam revisão de Rafael; ainda não são layouts aprovados nem assets de produção.

## Imagens

| Componente | Referência | Escopo desta imagem |
| --- | --- | --- |
| Linha de item | [s12_layout_item_row_v002.png](s12_layout_item_row_v002.png) | Quatro itens, atributos, seleção de herói e ações em tela de inventário. |
| Gaveta de detalhe | [s12_layout_detail_drawer_v002.png](s12_layout_detail_drawer_v002.png) | Bônus, comparação com equipamento, resumo de Bastião e ações sobre Inventário S08. |
| Ficha de status do herói | [s12_layout_hero_stats_v002.png](s12_layout_hero_stats_v002.png) | Bastião, seis slots de equipamento e sete linhas de status. |

## Revisão visual

Esta rodada usou o [ui_kit v003](../../candidates/ui_kit_v003/concept_ui_kit_v003.png), o [Inventário S08](../slice_1e_references/s08_inventario_echo_section_concept_v001.png) e o [Loadout S04](../slice_1e_references/s04_loadout_concept_v001.png) como imagens de referência passadas ao gerador.

A textura escura de pedra e madeira, as raízes nas bordas, o teal contido e a hierarquia dos painéis seguem melhor as referências do jogo. As cores de raridade continuam um pouco mais vivas que a TY40 em alguns pontos; devem ser acertadas no pixel cleanup e no contrato de peças. O texto rasterizado e a legibilidade não foram validados em 432×960 nem em aparelho. Estes arquivos são estudos de layout, sem integração.

## Prompts e limites

Geradas com a ferramenta integrada `image_gen`, com uma solicitação por layout e duas âncoras visuais do projeto por chamada. A linha de item usou ui_kit v003 + S08; a gaveta usou ui_kit v003 + S08; a ficha do herói usou S04 + ui_kit v003. Os pedidos especificaram a identidade Pocket Hero, materiais opacos, baixa saturação, uso comedido do Lúmen e exclusão explícita de loja, gacha, energia, moeda premium, brilho de raridade e banners de oferta. Os textos e valores seguem o brief e são ilustrativos.

Esta é a única versão de referência de layout UI_S12 no repositório. Ela não substitui os contratos e aguarda revisão de Rafael.

## Navegação

[Contrato global de criação de imagens](../../IMAGE_CREATION_CONTRACT.md) · [Contrato UX UI_S12](../../../09_ui/screens/s12_numeros_de_item.md) · [Contrato de arte](../../contracts/screens/s12_numeros_de_item.yaml) · [Brief de geração](../../conceitos/ui/README.md) · [Índice UI](../../../09_ui/INDEX.md) · [Índice de arte](../../../07_art/INDEX.md)
