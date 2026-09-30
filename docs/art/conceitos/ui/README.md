# UI — conceitos visuais e brief de geração

**Status:** `DESIGN`. Brief de conceito para o contrato [UI_S12 — Números de item](../../../09_ui/screens/s12_numeros_de_item.md) e sua peça de arte [`s12_numeros_de_item.yaml`](../../contracts/screens/s12_numeros_de_item.yaml). A única versão atual de layout é [v002](../../mockups/s12_numeros_de_item_concepts_v002/README.md), gerada com referências visuais do Pocket Hero. As folhas de peças ainda aguardam geração. As imagens são **estudos de conceito**: não são assets finais nem fonte de valores e passam por pixel cleanup, `tools/sprite_lint.py`, QA técnico e auditoria visual independente antes de entrar no jogo.

Siga primeiro o [contrato global de criação de imagens](../../IMAGE_CREATION_CONTRACT.md). Para manter a UI dentro da identidade visual do Pocket Hero, use como referências concretas o [ui_kit v003](../../candidates/ui_kit_v003/concept_ui_kit_v003.png), o [Inventário S08](../../mockups/slice_1e_references/s08_inventario_echo_section_concept_v001.png) e o [Loadout S04](../../mockups/slice_1e_references/s04_loadout_concept_v001.png). O contrato global explica como usar essas âncoras e quais linguagens visuais rejeitar.

**Layouts atuais:** [índice das três referências v002](../../mockups/s12_numeros_de_item_concepts_v002/README.md) — linha de item, gaveta de detalhe e ficha de status do herói. As folhas de peças (ícones, molduras e chips) continuam separadas e não foram geradas nesta etapa.

## Leia antes

1. [`../README.md`](../README.md) — fluxo geral de conceito e regras compartilhadas para prompts.
2. [`../../SPRITE_STYLE_GUIDE.md`](../../SPRITE_STYLE_GUIDE.md) e [`../../PALETTE.md`](../../PALETTE.md) — estilo e paleta. A lista de cores abaixo é uma **cópia de conveniência**; em caso de divergência vale `PALETTE.md`.
3. O contrato de UX e o contrato de arte acima: tamanhos, peças e critérios de aceite.

## Contexto do jogo (para o gerador)

**Pocket Hero** é um RPG de expedições para celular, em **retrato 432×960**, jogo 2D original de fantasia sombria acolhedora (pixel art limpo, luz no alto à esquerda, sombreado duro em 2–3 níveis). O jogador equipa três heróis com armas, escudos, armaduras, acessórios e um Echo. Hoje a interface não mostra nenhum número de bônus; este pacote define como mostrá-los. **Não copie** identidade, interface ou arte de outro jogo.

## Regras para todas as imagens

- Pixel art manual e limpa, **sem** gradiente, blur, antialiasing, pintura realista, ruído, pixels soltos ou microdetalhe.
- **Sem texto, letras ou numerais dentro dos sprites** (ícones, molduras, setas, pips, chips). Nas imagens de **layout** (tela inteira), texto e números são permitidos apenas como ilustração e devem seguir os exemplos deste documento.
- Só cores da **TY High Fantasy 40**, no máximo **16 por peça**. Cópia de conveniência dos subconjuntos usados:

| Subconjunto | Cores |
| --- | --- |
| `neutral_stone` | `#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5` |
| `forest` | `#1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #81b5a2` |
| `lumen` | `#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5` |
| `crimson` | `#2a1810 #402736 #562f36 #5a4256 #7a393d #8f5c66 #bf5437` |
| `gold` | `#3b1c16 #8a5c0a #af8e2c #caaa6c #e6dac5` |
| `wood` | `#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5` |

- **Forma antes de cor:** cada distinção (raridade, melhora/piora, tipo de status) precisa funcionar em **escala de cinza**.
- Nas folhas de sprites, desenhe em pixels lógicos pequenos e **mostre ampliado** (vizinho mais próximo, sem suavização), sobre **fundo chapado `#353235`** (será removido). Uma peça por célula, sem sobreposição, com margem.
- Gere uma imagem por vez, sem variações de pose. Peça variantes só quando precisar de uma decisão visual.

## O que gerar (em ordem)

Os prompts específicos dos layouts foram removidos para evitar reutilização fora da identidade visual do jogo. Consulte a [referência visual atual UI_S12 v002](../../mockups/s12_numeros_de_item_concepts_v002/README.md). Uma nova geração deve começar pelo [contrato global](../../IMAGE_CREATION_CONTRACT.md), abrir as âncoras atuais do Pocket Hero e usar nova versão. Os prompts dos itens 1–4 são propostas ainda não geradas e também ficam subordinados ao contrato global.

### 1. Ícones de status — `s12_stat_icons_v001.png`

Sete ícones em uma linha (24×24 lógicos por célula, mostrados a 8×): Vida, Ataque, Defesa, Velocidade de ataque, Crítico, Recarga, Tenacidade. Símbolos distintos só pela silhueta.

```text
Pixel art sprite sheet, 7 icons in one row, each icon 24x24 logical pixels shown at 8x with nearest-neighbor look (hard pixel edges, no smoothing), flat solid background #353235, each in its own cell with margin. Icons, left to right: (1) a heart for health, (2) a short sword for attack, (3) a heater shield for defense, (4) a double lightning bolt for attack speed, (5) a target with a center dot for critical chance, (6) an hourglass for cooldown reduction, (7) a chain link or clenched fist for tenacity. Dark fantasy cozy style, top-left lighting, hard shading in 2-3 tones, 1-pixel selective dark outline, readable as silhouette alone. Limited palette: #000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5 plus one accent per icon from #7a393d #bf5437 #607a53 #81b5a2 #af8e2c #caaa6c #bdd2de. No text, no letters, no numbers, no gradients, no glow, no blur.
```

### 2. Molduras de raridade — `s12_rarity_frames_v001.png`

Cinco molduras de 72×72 lógicos (mostradas a 6×), com **centro vazio** preenchido por `#182029` (será removido): Comum, Incomum, Raro, Épico, Relíquia. Cada nível acrescenta um ornamento de canto (0, 1, 2, 3, 4).

```text
Pixel art sprite sheet, 5 square item frames in one row, each 72x72 logical pixels shown at 6x with nearest-neighbor look, flat solid background #353235, empty dark center square (#182029) for where an item icon will sit, margin between frames. Follow the Pocket Hero ui_kit and S08 references plus the global image-creation contract. Same restrained matte stone frame gains one small non-luminous corner mark per tier: (1) Common: plain stone-grey border; (2) Uncommon: muted forest accent and one leaf or rivet; (3) Rare: muted teal accent and two small corner cuts, no gems; (4) Epic: desaturated wine accent and three corner marks, matte double border; (5) Relic: aged bronze/gold accent and four corner marks, no glow. Use only the listed TY40 subsets; keep all colors subdued and materials worn. Hard pixel clusters, top-left ambient light, no neon, no gemstone highlights, no reward effects, no text, no numbers, no gradients, no blur.
```

### 3. Setas, pips, marcas e glifos de slot — `s12_marks_and_glyphs_v001.png`

```text
Pixel art sprite sheet with four groups in fixed order, nearest-neighbor look, flat solid background #353235, each piece in its own cell: Group A (12x12 logical pixels, shown at 10x): comparison arrows up, down, equal, distinguished by shape; Group B (12x12): one filled and one empty reinforcement pip; Group C (16x16): small equipped badge; Group D (24x24): five slot glyphs for weapon, secondary, armor, accessory, and Echo. Echo glyph is a matte shard with only a restrained teal detail, not a light source. Use subdued TY40 subsets, hard pixel clusters, selective outline and the Pocket Hero ui_kit language. Keep marks recognizable in grayscale. No neon, glow, gem, price, premium badge, text, number, gradient or blur.
```

### 4. Fundos de chip de status — `s12_stat_chips_v001.png`

Três pílulas 9-slice de 24×24 lógicos (margem de 8 px), mostradas a 8×, e uma versão esticada para 96×24 de cada para provar que não há costura.

```text
Pixel art sprite sheet, 3 pill-shaped UI chip backgrounds for a 9-slice, each 24x24 logical pixels with 8-pixel corner margins, shown at 8x with nearest-neighbor look, flat solid background #353235; below each one, the same chip stretched horizontally to 96x24 logical pixels to prove the middle stretches without a visible seam. Variants left to right: (1) neutral: dark slate pill (#2f3140 fill, #4a484a border); (2) positive: dark green pill (#223925 fill, #607a53 border) with a tiny up-pointing triangle marker in the top-left corner; (3) negative: dark wine pill (#402736 fill, #7a393d border) with a tiny down-pointing triangle marker in the top-left corner. Dark fantasy cozy, hard shading, 1-pixel border, no gradients, no blur, no text, no numbers.
```

### 5. Referências de layout atuais

Os três layouts do componente já estão no [índice de referências UI_S12 v002](../../mockups/s12_numeros_de_item_concepts_v002/README.md). Consulte esse índice e o contrato UX antes de propor outra rodada.

## Como devolver

- Uma imagem por arquivo, nos nomes acima, em PNG. Liste para cada uma: o que ficou fora do contrato, o que você mudou de propósito e as cores que acha que saíram da TY40.
- **Não** reescreva regras nem valores. Se uma peça do contrato parecer ruim ou ambígua, diga qual e por quê.
- Depois de gerar, o próximo passo não é integrar: é revisão de Rafael, pixel cleanup, lint, QA técnico e auditoria independente (ver critérios de aceite no contrato de arte).

## Fontes

[Contrato global de criação de imagens](../../IMAGE_CREATION_CONTRACT.md) · [UI_S12](../../../09_ui/screens/s12_numeros_de_item.md) · [contrato de arte](../../contracts/screens/s12_numeros_de_item.yaml) · [ui_kit](../../contracts/screens/ui_kit.yaml) · [convenções de tela](../../../09_ui/SCREEN_CONVENTIONS.md) · [guia de estilo](../../SPRITE_STYLE_GUIDE.md) · [paleta](../../PALETTE.md)
