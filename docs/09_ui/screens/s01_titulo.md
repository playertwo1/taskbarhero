---
id: UI_S01
status: DESIGN
certainty: HIPOTESE
---

# UI_S01 — Título

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (provisório)

## Implementação atual

`scenes/ui/TitleScreen.tscn` + `scripts/ui/TitleScreen.gd`: fundo `title_background_432x960.png`, texto de toque e transição de 0,3 s para `SliceCampaign`.

## Objetivo

Entrada do app. Leva o jogador ao Refúgio com um toque, em menos de 2 s, sem telas intermediárias.

## Entra por

- Abertura do app.

## Sai para

- Refúgio (S02) com um toque em qualquer ponto.

## Dados exibidos

- Logotipo Pocket Hero.
- Aviso de save ilegível (`save_error`), quando existir, antes de continuar.

## Ações

- Toque em qualquer ponto: continuar.
- Sem botão de configurações no slice.

## Estados

- Normal.
- Iniciando (transição; ignora novos toques).
- Save bloqueado: aviso curto e continuar mesmo assim, sem gravar.

## Layout e toque

- Logotipo no terço superior; prompt de toque no terço inferior, dentro da área segura.
- Partículas sutis de Lúmen; sem animação que atrase a entrada.

## Fora do slice

- Retorno offline (fora do slice).
- Menu de configurações, créditos e conta.

## Critérios de aceite

- Abre o Refúgio em menos de 2 s após o primeiro toque.
- Legível em 432×960 e em 1080×2424 sem cortes.
- Aviso de save bloqueado aparece quando o save é ilegível.

## Decisões

- **RECOMENDADO:** Opção 3A 'Chama na Penumbra' das [propostas de UI](../../art/mockups/UI_SCREEN_PROPOSALS.md).
- **EM ABERTO:** Onde o aviso de save ilegível aparece hoje: a tela atual não o mostra; ele só aparece na preparação.

## Arte

[Contrato de arte](../../art/contracts/screens/s01_titulo.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
