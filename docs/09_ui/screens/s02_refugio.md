---
id: UI_S02
status: DESIGN
certainty: HIPOTESE
---

# UI_S02 — Refúgio (Hub)

**Estado do contrato:** `DESIGN`. **Implementação:** DESIGN (a preparação da campanha é um substituto provisório)

## Implementação atual

Não existe cena de Refúgio no slice. `SliceCampaignScreen` (modo `prep`) mostra nível, XP, itens, Resíduo e Fragmentos, e abre Inventário, Árvore e Ferreiro. `scenes/ui/HubScreen.tscn` é protótipo do MVP legado e não serve de base.

## Objetivo

Espaço recorrente entre expedições: mostra o estado da campanha e dá acesso a todos os serviços e à expedição.

## Entra por

- Título (S01).
- Resultado (S07).
- Fechar qualquer painel de serviço.

## Sai para

- Expedição (S03).
- Loadout (S04).
- Inventário (S08).
- Árvore dos Ecos (S09).
- Ferreiro (S10), só depois de `TREE_OFI_001`.
- Gravadora de Ecos (S11), só com um Echo recuperado.

## Dados exibidos

- Nível e XP do trio (`data.party`).
- Fragmentos de Ressonância, Resíduo de Lúmen e número de itens.
- Estado da camada pós-boss (`data.boss_cleared`).
- Serviços disponíveis e trancados.

## Ações

- Tocar em um serviço abre seu painel.
- Tocar na saída/portão abre a Expedição.
- Botões dev (Sondagem, Voltar ao título) só em build de debug.

## Estados

- Antes do primeiro boss.
- Depois do primeiro clear do Guardião: camada da Lanterna-Mãe ([contrato](../../art/contracts/hub_environment/hub_lanterna_mae_pos_boss.yaml)).
- Save bloqueado: aviso fixo de que nada será gravado.
- Serviço trancado: visível, sem ação, indicando o nó que o abre.

## Layout e toque

- Cena vertical modular conforme [HUB_VISUAL_DIRECTION](../../05_hub/HUB_VISUAL_DIRECTION.md).
- Serviços como áreas tocáveis com alvo mínimo de 48 dp e rótulo legível.
- Barra de recursos no topo; navegação pelos serviços na própria cena.

## Fora do slice

- Alquimista e Ourives (fachadas apenas, sem função).
- Bestiário/Codex, missões de herói e retorno offline.

## Critérios de aceite

- Todos os serviços do slice alcançáveis com um toque a partir do Refúgio.
- Serviço trancado nunca abre painel vazio.
- A camada pós-boss aparece só com `boss_cleared`.
- Legível em 432×960 sem rolagem horizontal.

## Decisões

- **DECIDIDO:** Base visual escolhida por Rafael em 2026-09-28: composição com party e serviços; produção modular, não uma imagem única.
- **RECOMENDADO:** Manter a preparação atual como fallback enquanto a cena do Refúgio não existir.
- **EM ABERTO:** Posição exata dos serviços na cena; depende do protótipo de composição.
- **EM ABERTO:** Se a expedição parte de um portão no Refúgio ou de um botão fixo.

## Arte

[Contrato de arte](../../art/contracts/screens/s02_refugio.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
