---
id: UI_S11
status: DESIGN
certainty: HIPOTESE
---

# UI_S11 — Gravadora de Ecos

**Estado do contrato:** `DESIGN`. **Implementação:** DESIGN (hoje o Echo é equipado no Inventário)

## Implementação atual

Não há tela própria. `SliceInventoryPanel` mostra o Echo recuperado e o botão Equipar/Desequipar.

## Objetivo

Catalogar o Echo recuperado e equipá-lo ou trocá-lo no slot Echo. No slice existe um só Echo: *A Sentinela que Ficou*.

## Entra por

- Refúgio (S02) com um Echo recuperado.
- Loadout (S04).

## Sai para

- Voltar.

## Dados exibidos

- Echo recuperado, origem (Geleia Anciã) e efeito em Muralha Viva.
- Estado equipado ou não.
- Aviso de compatibilidade: útil para a build Guardião de Bastião; para a build Retaliação a utilidade é EM ABERTO.

## Ações

- Equipar ou desequipar o Echo (só fora da expedição).

## Estados

- Nenhum Echo recuperado: serviço trancado.
- Echo recuperado e não equipado.
- Equipado.
- Travado durante a expedição.

## Layout e toque

- Cartão do Echo com ilustração, nome, efeito e um botão.

## Fora do slice

- Extração, infusão, cópia e melhoria de Echo.
- Codex e outros Echos.

## Critérios de aceite

- Só usa a API de `SliceCampaign` (`equip_echo`).
- Sem Echo, o serviço não abre uma tela vazia.

## Decisões

- **DECIDIDO:** Único Echo do slice, equipado no Hub e sem custo de Fragmentos.
- **EM ABERTO:** Se a Gravadora é uma tela própria no slice ou o painel do Inventário basta.
- **EM ABERTO:** Identidade da Gravadora (NPC) e sua arte.

## Arte

[Contrato de arte](../../art/contracts/screens/s11_gravadora_de_ecos.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
