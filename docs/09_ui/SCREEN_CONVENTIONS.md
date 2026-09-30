---
id: SCREEN_CONVENTIONS
status: DESIGN
certainty: HIPOTESE
---

# Convenções de tela — Pocket Hero

Regras compartilhadas por todos os contratos de tela do slice. Cada contrato de [`screens/`](screens/) cita este arquivo em vez de repeti-lo. Uma regra só muda aqui.

## Viewport e orientação

- **DECIDIDO:** retrato, `432×960`, esticamento `canvas_items` com aspecto `expand` e orientação retrato, conforme `project.godot`.
- **Verificado no emulador Pixel 9 (1080×2424):** a proporção é próxima o bastante para o layout de 432×960 funcionar sem cortes. Toda tela precisa ser conferida em ambas as resoluções no `1E`.
- Sem rolagem horizontal. Rolagem vertical só em listas.

## Toque e legibilidade

- **RECOMENDADO:** alvo tocável mínimo de 48 dp. O código atual usa `custom_minimum_size.y = 50` em botões; em 432 px de largura isso equivale a cerca de 47 dp num aparelho de 1080 px, então 50 px é o piso, não o teto.
- **RECOMENDADO:** texto de corpo com 16 px ou mais; títulos de tela com 23 px (valor atual das telas do slice).
- Ação principal na metade inferior da tela, alcançável com o polegar; ação destrutiva nunca é a mais fácil de tocar.
- Estado nunca depende só de cor: ativo, bloqueado e desabilitado também mudam texto, ícone ou forma.
- Botão desabilitado explica o motivo em texto perto dele; nunca fica mudo.

## Painéis e navegação

- **DECIDIDO (implementado):** painéis de serviço são sobreposições em tela cheia com **fundo opaco** (alpha 1,0), com botão 'Voltar' na parte inferior e sinal `closed`. Fundo translúcido deixou a tela de baixo aparecer no emulador e foi corrigido.
- Uma tela por vez; sem pilhas de modais, exceto a confirmação de ação destrutiva.
- Toda tela devolve para a anterior com 'Voltar'; nada de gestos escondidos.

## Regras de dados

- **Uma tela não tem regra própria.** Ela chama `SliceCampaign`/`SliceInventory`/`ResonanceTree`, lê números dos dados de `/data` e mostra o resultado. Custos, chances e efeitos nunca são fixados em texto de cena.
- Textos de conteúdo (eventos, skills, itens) vêm dos arquivos de dados. Rótulos de UI ficam no código da tela.
- O save é escrito ao receber cada recompensa; a tela só reflete. Save ilegível (`save_blocked`) mostra um aviso fixo de que nada será gravado.
- Durante a expedição (`inventory.locked`), equipar, desequipar e serviços do Refúgio ficam indisponíveis e dizem por quê.

## Arte compartilhada (`ui_kit`)

Peças reutilizadas em todas as telas, produzidas uma vez e marcadas `shared: ui_kit` nos contratos de arte:

| Peça | Uso | Tamanho | Estado |
| --- | --- | --- | --- |
| Botão 9-slice (primário, secundário, desabilitado, pressionado) | todas as telas | 48×48 | `new` |
| Moldura de painel opaco | painéis de serviço | 48×48 | `new` |
| Divisor e cabeçalho | listas | 432×8 | `new` |
| Ícones de recurso (Fragmento, Resíduo, XP) | resultado, Árvore, Ferreiro | 16×16 e 24×24 | `new` |

Um [candidato v001](../art/candidates/ui_kit/README.md) foi gerado por script em 2026-09-29 e aguarda auditoria. O ui_kit é o **primeiro asset de UI** a passar o gate de arte (contrato → conceito → pixel cleanup → QA técnico → auditoria independente); as telas só começam a receber arte depois do PASS dele.

## Estados de contrato e implementação

- Contrato `DESIGN`: escrito, sem aprovação de Rafael.
- Marcadores de decisão nos contratos: **DECIDIDO**, **RECOMENDADO**, **HIPÓTESE**, **EM ABERTO**.
- Uma tela só vai a `APPROVED` depois que Rafael revisar o contrato, e a `PASS` depois de teste em 432×960 e no emulador.

## Fontes

[Propostas de UI](../art/mockups/UI_SCREEN_PROPOSALS.md) · [Direção visual do Refúgio](../05_hub/HUB_VISUAL_DIRECTION.md) · [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) · [Guia de estilo](../art/SPRITE_STYLE_GUIDE.md) · [Paleta](../art/PALETTE.md)
