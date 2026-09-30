---
id: UI_S10
status: DESIGN
certainty: HIPOTESE
---

# UI_S10 — Ferreiro

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (lista de texto)

## Implementação atual

`scripts/ui/BlacksmithPanel.gd`: itens com Favoritar, Reforçar (após `OFI_003`) e Desmontar em dois toques (após `OFI_002`). Só aparece depois de `TREE_OFI_001`.

## Objetivo

Desmontar equipamento em Resíduo e aplicar o Reforço +1, com proteção contra acidente.

## Entra por

- Refúgio (S02) depois de `TREE_OFI_001`.
- Inventário (S08).

## Sai para

- Voltar ao Refúgio.

## Dados exibidos

- Resíduo de Lúmen atual e custo do Reforço.
- Itens com Reforço, favorito e quem os usa.
- Resultado de cada operação e serviços abertos ou fechados.

## Ações

- Favoritar ou tirar favorito.
- Reforçar (5 Resíduos, uma vez por item).
- Desmontar com confirmação; equipado, favorito e travado são recusados.

## Estados

- Ferreiro fechado (nó não comprado): o Refúgio não oferece a entrada.
- Serviço fechado: explicado no resumo.
- Confirmação pendente em um item.
- Recusas com motivo (favorito, equipado, Resíduo insuficiente, ineligível, já reforçado).

## Layout e toque

- Item selecionado em destaque com prévia do resultado (Resíduo ganho ou bônus do reforço). A prévia do Reforço mostra os números antes e depois conforme [UI_S12](s12_numeros_de_item.md) (C5).
- Confirmação com texto explícito, cancelável por toque fora.

## Fora do slice

- Reforja aleatória, níveis acima de +1, forja livre e auto-desmontagem.
- Ouro no custo (o slice não tem Ouro).

## Critérios de aceite

- Toda operação passa por `SliceCampaign`; a tela não calcula custo.
- Desmontar nunca acontece em um só toque.
- Prévia mostra o resultado antes de confirmar.

## Decisões

- **DECIDIDO:** Desmontagem com confirmação e favoritos protegidos; reforço +1 opcional (CRAFT-1).
- **HIPÓTESE:** Custo de 5 Resíduos e +2% dos afixos-base.
- **EM ABERTO:** Personagem e nome do Ferreiro (contrato próprio).

## Arte

[Contrato de arte](../../art/contracts/screens/s10_ferreiro.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
