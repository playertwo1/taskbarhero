---
id: UI_S08
status: DESIGN
certainty: HIPOTESE
---

# UI_S08 — Inventário

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (lista de texto)

## Implementação atual

`scripts/ui/SliceInventoryPanel.gd`: lista de itens com equipar/desequipar por herói compatível, 'Equipar os melhores', Echo equipável e resumo. Reciclar saiu daqui e ficou no Ferreiro. Fundo agora opaco.

## Objetivo

Ver o que a party possui, equipar e comparar equipamento entre expedições.

## Entra por

- Refúgio (S02).
- Loadout (S04).
- Resultado (S07).

## Sai para

- Voltar à tela anterior.
- Ferreiro (S10) para desmontar ou reforçar.

## Dados exibidos

- Itens com nome, slot, raridade, Item Power, Reforço e favorito.
- Seção Echo (Gravadora de Ecos): Echo recuperado, origem, efeito em Muralha Viva e estado equipado.
- Quem usa cada item.
- Resíduo de Lúmen.
- Echo recuperado e estado de equipar.

## Ações

- Equipar em herói compatível.
- Desequipar.
- Equipar os melhores.
- Equipar ou trocar o Echo na seção Echo do painel (Gravadora).

## Estados

- Vazio.
- Com itens.
- Travado durante a expedição (botões desabilitados com explicação).
- Item incompatível: recusa com o motivo.

## Layout e toque

- Lista com filtro por slot; cada linha com ícone, nome, raridade e ação principal.
- Detalhe do item em gaveta com bônus e comparação com o equipado. Números, chips, comparação e regras de formatação: [UI_S12](s12_numeros_de_item.md).

## Fora do slice

- Ordenação e filtros avançados.
- Auto-desmontagem e venda.

## Critérios de aceite

- Toda regra passa por `SliceCampaign`; a tela não decide compatibilidade.
- Nenhum botão de desmontar aqui.
- Ícones de item aparecem quando existirem, com fallback de texto.

## Decisões

- **DECIDIDO:** Desmontar fica no Ferreiro, com confirmação e proteção de favoritos.
- **RECOMENDADO:** Filtro por slot com 6 abas (Arma, Secundário, Armadura, Acessório I/II, Echo).
- **DECIDIDO:** A Gravadora fica dentro do painel de Inventário como a seção Echo (Rafael, 2026-09-29); não há tela própria. Ver UI_S11.

## Arte

[Contrato de arte](../../art/contracts/screens/s08_inventario.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
