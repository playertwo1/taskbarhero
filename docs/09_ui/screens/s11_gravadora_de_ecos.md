---
id: UI_S11
status: DESIGN
certainty: HIPOTESE
---

# UI_S11 — Gravadora de Ecos (seção do Inventário)

**Estado do contrato:** `DESIGN`. **Implementação:** DECIDIDO como seção do Inventário (UI_S08); sem tela própria

## Implementação atual

Não há tela própria. `SliceInventoryPanel` mostra o Echo recuperado e o botão Equipar/Desequipar.

## Objetivo

Seção Echo dentro do painel de Inventário (UI_S08): catalogar o Echo recuperado e equipá-lo ou trocá-lo no slot Echo. No slice existe um só Echo: *A Sentinela que Ficou*. Este contrato descreve só o conteúdo dessa seção.

## Entra por

- Seção do Inventário (S08).
- Slot Echo do Loadout (S04) abre o Inventário nessa seção.

## Sai para

- Voltar ao Inventário.

## Dados exibidos

- Echo recuperado, origem (Geleia Anciã) e efeito em Muralha Viva.
- Estado equipado ou não.
- Aviso de compatibilidade: útil para a build Guardião de Bastião; para a build Retaliação a utilidade é EM ABERTO.

## Ações

- Equipar ou desequipar o Echo (só fora da expedição).

## Estados

- Nenhum Echo recuperado: a seção mostra o estado vazio, sem botão.
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
- Sem Echo, a seção explica que nenhum foi recuperado.

## Decisões

- **DECIDIDO:** Único Echo do slice, equipado no Hub e sem custo de Fragmentos.
- **DECIDIDO:** Sem tela própria no slice: a Gravadora é uma seção do Inventário (Rafael, 2026-09-29).
- **EM ABERTO:** Identidade da Gravadora (NPC) e sua arte; só necessária se ela virar cena no Refúgio.

## Arte

[Contrato de arte](../../art/contracts/screens/s11_gravadora_de_ecos.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
