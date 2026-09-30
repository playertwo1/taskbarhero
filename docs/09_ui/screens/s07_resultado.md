---
id: UI_S07
status: DESIGN
certainty: HIPOTESE
---

# UI_S07 — Resultado

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (texto)

## Implementação atual

`SliceCampaignScreen` modo `result`: texto de vitória ou derrota, níveis, itens, Resíduo, Fragmentos e botões Inventário/Voltar.

## Objetivo

Fechar a expedição mostrando o que mudou e apontar o próximo passo.

## Entra por

- Expedição em curso (S05).

## Sai para

- Refúgio (S02).
- Inventário (S08).

## Dados exibidos

- Vitória ou derrota; em derrota, até onde a party chegou.
- Níveis ganhos, itens novos, Resíduo, Fragmentos ganhos.
- Recompensas de primeira conclusão: Echo, Fragmento do Coração Verde e Épico garantido.
- Aviso de que a camada do Refúgio mudou, após o primeiro clear.

## Ações

- Voltar ao Refúgio.
- Abrir o Inventário para equipar o loot.

## Estados

- Vitória do Guardião (primeira vez).
- Vitória em repetição.
- Derrota: nenhum marco pago se repete, o progresso persiste.
- Save bloqueado: avisar que nada foi gravado.

## Layout e toque

- Título grande de resultado, listas curtas e o botão principal na área do polegar.

## Fora do slice

- Estatísticas de dano por herói (telemetria só em ferramentas).
- Compartilhar resultado.

## Critérios de aceite

- Os valores exibidos são os do `finish_expedition` da campanha.
- A primeira vitória apresenta cada recompensa única uma única vez.

## Decisões

- **RECOMENDADO:** Mostrar Fragmentos e Resíduo como duas linhas separadas, porque pagam sistemas diferentes.
- **EM ABERTO:** Onde a animação de primeiro clear do Guardião ocorre.

## Arte

[Contrato de arte](../../art/contracts/screens/s07_resultado.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
