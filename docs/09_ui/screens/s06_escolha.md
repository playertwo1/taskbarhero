---
id: UI_S06
status: DESIGN
certainty: HIPOTESE
---

# UI_S06 — Escolha (Reward Choice e evento)

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (botões de texto)

## Implementação atual

`SliceCampaignScreen`: `pending_labels()` vira botões na tela de run, com o item (Reward Choice) ou o texto da opção (evento).

## Objetivo

Deixar o jogador decidir em Reward Choice (elite e mini-boss) e em eventos, com o combate parado.

## Entra por

- Expedição em curso (S05).

## Sai para

- De volta a S05 depois de escolher.

## Dados exibidos

- Título e texto do evento (`event_texts_c1.json`), quando evento.
- Para Reward Choice: 3 itens com nome, slot, raridade, bônus e comparação com o item equipado.
- Consequência de cada opção quando definida (cura, sacrifício, recompensa).

## Ações

- Tocar em uma opção confirma a escolha.
- Não há cancelar: a run só continua depois de escolher.

## Estados

- Evento (2 a 3 opções).
- Reward Choice (3 itens).
- Após a escolha: resultado curto no log.

## Layout e toque

- Modal opaco sobre a run, com texto no topo e opções empilhadas na parte inferior.
- Cada opção com alvo de 50 px e texto que quebra linha.

## Fora do slice

- Comparação avançada de itens.
- Rerrolagem de ofertas.

## Critérios de aceite

- A run não avança até `choose`.
- Cada opção mostra o efeito real, sem esconder custos.
- Textos vêm de dados, nunca fixos na cena.

## Decisões

- **EM ABERTO:** Se Reward Choice mostra a comparação numérica com o item equipado.
- **EM ABERTO:** Ilustração por evento: a cena do Poço de Lúmen tem arte prevista, os outros eventos não.

## Arte

[Contrato de arte](../../art/contracts/screens/s06_escolha.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
