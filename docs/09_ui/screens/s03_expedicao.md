---
id: UI_S03
status: DESIGN
certainty: HIPOTESE
---

# UI_S03 — Expedição (seleção)

**Estado do contrato:** `DESIGN`. **Implementação:** DESIGN

## Implementação atual

Hoje é o botão 'Iniciar expedição' da preparação. O slice tem uma única rota (`route_c1.json`).

## Objetivo

Mostrar a expedição do Bosque de Lúmen, o progresso do capítulo e confirmar a partida.

## Entra por

- Refúgio (S02).

## Sai para

- Expedição em curso (S05).
- Voltar ao Refúgio.

## Dados exibidos

- Nome do capítulo e encontros da rota em ordem (nome e tipo: comum, elite, mini-boss, boss, evento), sem revelar inimigos futuros além do nome.
- Marcos já concluídos (`data.milestones`) e se o Guardião já foi vencido.
- Nível do trio e nível indicativo de cada fase (`level` da rota).
- Resumo da party e build escolhida (link para S04).

## Ações

- Iniciar expedição.
- Abrir o Loadout (S04).
- Voltar.

## Estados

- Primeira vez (nenhum marco).
- Marcos parciais.
- Guardião vencido (repetição): indicar que Fragmentos de marcos já pagos não se repetem.
- Inventário travado durante a expedição não se aplica aqui.

## Layout e toque

- Trilha vertical de encontros de baixo para cima (opção 2A), com nós legíveis a 1×.
- Botão 'Iniciar' fixo na parte inferior, na área do polegar.

## Fora do slice

- Seleção entre capítulos ou regiões.
- Estimativas de XP/h e de drops.

## Critérios de aceite

- A lista da rota vem de `route_c1.json`, sem cópia manual.
- O botão Iniciar cria a run com o loadout atual.
- Nenhum encontro futuro mostra stats.

## Decisões

- **RECOMENDADO:** Trilha vertical 2A das propostas de UI.
- **DECIDIDO:** Tela própria, separada do Refúgio (Rafael, 2026-09-29), mesmo com uma única expedição no slice. Ela mostra a rota e o resumo da party antes de partir.

## Arte

[Contrato de arte](../../art/contracts/screens/s03_expedicao.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
