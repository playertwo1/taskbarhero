---
id: UI_S09
status: DESIGN
certainty: HIPOTESE
---

# UI_S09 — Árvore dos Ecos

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (lista linear de 6 nós)

## Implementação atual

`scripts/ui/ResonanceTreePanel.gd`: saldo, 6 nós com custo, estado e descrição, botão Comprar. Fundo opaco.

## Objetivo

Gastar Fragmentos de Ressonância em nós permanentes e ver o que cada um abre.

## Entra por

- Refúgio (S02).

## Sai para

- Voltar ao Refúgio.

## Dados exibidos

- Saldo de Fragmentos.
- Para cada nó: nome, custo, estado (ativo, disponível, faltam Fragmentos, bloqueado), pré-requisito e efeito.
- Fonte dos Fragmentos: marcos da rota, sem repetição.

## Ações

- Comprar um nó disponível e com saldo.
- Ver a descrição de um nó bloqueado.

## Estados

- Ativo.
- Disponível.
- Faltam Fragmentos (botão desabilitado).
- Bloqueado (mostra o nó exigido).
- Compra recusada com motivo.

## Layout e toque

- Sequência vertical de nós ligados por linha, com o ramo Oficina destacado.
- Nó ativo, disponível e bloqueado distinguíveis sem depender só de cor.

## Fora do slice

- Árvore completa (~84 nós), respec e ramos futuros.
- Efeito numérico do Pulso Vital (EM ABERTO).

## Critérios de aceite

- Custos e pré-requisitos vêm de `resonance_tree_slice.json`.
- A compra grava no save e emite `changed`.
- O texto de efeito não promete o que o runtime ainda não faz.

## Decisões

- **DECIDIDO:** Só os 6 nós do slice; catálogo em GLOBAL_RESONANCE_TREE.
- **HIPÓTESE:** Custos por faixa 0/2/4/12 e 32 Fragmentos no capítulo, até o playtest.
- **EM ABERTO:** Efeito do Pulso Vital e de `TREE_VIG_005` além de abrir ramos.

## Arte

[Contrato de arte](../../art/contracts/screens/s09_arvore_dos_ecos.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
