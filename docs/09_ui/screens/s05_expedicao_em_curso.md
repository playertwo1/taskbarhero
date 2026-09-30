---
id: UI_S05
status: DESIGN
certainty: HIPOTESE
---

# UI_S05 — Expedição em curso

**Estado do contrato:** `DESIGN`. **Implementação:** IMPLEMENTED (texto, sem arte de combate)

## Implementação atual

`SliceCampaignScreen` modo `run`: encontro, HP por herói em texto, botão de velocidade (×1/×4/×20) e log das últimas linhas. Sem sprites de combate.

## Objetivo

Acompanhar o combate automático e ler o que acontece, sem controle direto do jogador além da velocidade e das escolhas.

## Entra por

- Expedição (S03).

## Sai para

- Escolha (S06) quando `run.state == choice`.
- Resultado (S07) ao vencer ou perder.

## Dados exibidos

- Nome do encontro e posição na rota.
- Botão de pausa e velocidade atual (×1 a ×4).
- HP atual/máximo por herói e quais caíram.
- Inimigos vivos com nome e vida.
- Eventos de combate: telégrafos, fases do chefe, Perfect Block, Fragmentos ganhos.
- Velocidade atual e se está pausado.

## Ações

- Pausar e retomar o combate.
- Escolher a velocidade: ×1, ×2, ×3 ou ×4.
- Não há comando de skill no slice.

## Estados

- Combate.
- Pausado: o tempo não avança e os botões de velocidade continuam ativos.
- Transição entre encontros (0,6 s).
- Aguardando escolha (tempo parado; abre S06).
- Terminada.

## Layout e toque

- Campo de combate no terço superior com heróis à esquerda e inimigos à direita.
- HP e nomes no centro; log rolável e resumido embaixo.
- Telegrafo do chefe com aviso visível em ≥ 1,5 s antes do impacto.

## Fora do slice

- Controle manual de skills.
- Velocidade ×20 (existe só em ferramentas de desenvolvimento).
- Efeitos visuais de skills (não há arte de efeitos).

## Critérios de aceite

- O log usa `SliceLogText`, sem lógica própria.
- A tela nunca avança o tempo durante uma escolha pendente.
- Legível e sem sobreposição em 432×960.

## Decisões

- **DECIDIDO:** O loadout e a build travam durante a expedição.
- **DECIDIDO:** Pausa e velocidades ×1, ×2, ×3 e ×4 (Rafael, 2026-09-29). A implementação atual tem ×1/×4/×20 e sem pausa; precisa ser ajustada.
- **RECOMENDADO:** Pausa não altera a simulação, só deixa de chamar o passo; a escolha aberta (S06) já para o tempo sozinha.
- **EM ABERTO:** Velocidade inicial de cada expedição.

## Arte

[Contrato de arte](../../art/contracts/screens/s05_expedicao_em_curso.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
