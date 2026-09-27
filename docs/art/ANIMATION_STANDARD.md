# Padrão de animação de sprites

O contrato individual é a autoridade para tamanho, frames, fps e duração de cada asset. Este documento define o mínimo comum e evita drift; ele não substitui decisão visual nem gameplay.

## Estrutura e export

- Canvas fixo por asset em todos os frames, inclusive efeitos de hit/death.
- Ordem declarada por tags: `idle`, `walk` (quando necessário), `attack`, `hit`, `death`.
- PNG RGBA horizontal strip ou atlas com metadata. Layout, nomes, frame count e dimensões devem coincidir com o contrato/manifesto.
- Pivot, baseline e orientação permanecem estáveis entre frames; deslocamento intencional do corpo não pode virar jitter do canvas.
- Sem interpolação, antialiasing ou escala fracionária. No Godot, importar com filtro nearest.

## Timing

Registre por tag o número exato de frames, FPS e/ou duração por frame em milissegundos. Não declarar fps e duração inconsistentes. Idle normalmente faz loop; ataques, hit e death são one-shot, salvo decisão documentada no contrato.

O FPS de renderização do aparelho é independente do relógio da animação. Validar a mesma duração visual a 60 e 120 FPS; nunca avançar frames com dependência de render FPS.

## Consistência e aceite

Preserve silhueta, rosto, equipamento, rampa de cores, escala, baseline e direção de luz. Mudança de pose deve comunicar ação sem redesenhar o personagem. Revisar playback na velocidade real e em 1×; aplicar [`QA_SPRITES.md`](./QA_SPRITES.md). A animação só pode ser GOLDEN após aprovação independente e registro de versão/hash em [`golden/README.md`](./golden/README.md).
