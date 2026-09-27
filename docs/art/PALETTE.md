# Pocket Hero — TY High Fantasy 40 e subconjuntos

**Status:** paleta-mestre adotada para produção (2026-09-27). **Master ID:** `TY_HIGH_FANTASY_40`. **Fonte:** Toby_Yasha, [TY - High Fantasy 40 (Lospec)](https://lospec.com/palette-list/ty-high-fantasy-40).
**Escopo:** cores RGB opacas para pixel art; alpha é transparência, não uma cor da paleta.

**Aprovação de escopo:** Rafael aprovou o uso pessoal/privado da TY40 no Pocket Hero em 2026-09-27. A página-fonte identifica Toby_Yasha, mas não apresenta uma licença explícita; esta aprovação interna não é uma licença do autor e não autoriza redistribuição, publicação ou uso comercial da paleta. Revalidar com o titular antes de qualquer uso fora do escopo pessoal.

## Regra de uso

Use somente cores da paleta-mestre e dos subconjuntos abaixo. Cada contrato declara seus subconjuntos autorizados e o limite total de cores. Não misture tons próximos de rampas antigas com TY40. Exceções exigem alteração aprovada do contrato e deste documento, com justificativa registrada no manifesto.

Os nomes dos subconjuntos são papéis práticos do Pocket Hero; não são rampas oficiais publicadas pelo criador da TY40. Podem compartilhar cores. Não force o uso de todas as cores de um subconjunto num asset.

## Paleta-mestre — exatamente 40 cores

| # | HEX | # | HEX | # | HEX | # | HEX |
|---:|---|---:|---|---:|---|---:|---|
| 1 | `#e6dac5` | 11 | `#bdd2de` | 21 | `#7a393d` | 31 | `#af8e2c` |
| 2 | `#a49983` | 12 | `#81b5a2` | 22 | `#562f36` | 32 | `#8a5c0a` |
| 3 | `#7b7d6a` | 13 | `#627c80` | 23 | `#402736` | 33 | `#af5722` |
| 4 | `#6a6548` | 14 | `#607a53` | 24 | `#bf5437` | 34 | `#703a1a` |
| 5 | `#4a484a` | 15 | `#545f28` | 25 | `#842d17` | 35 | `#3b1c16` |
| 6 | `#353235` | 16 | `#484c2a` | 26 | `#5a231d` | 36 | `#2a1810` |
| 7 | `#425a58` | 17 | `#223925` | 27 | `#caaa6c` | 37 | `#80592e` |
| 8 | `#314646` | 18 | `#000000` | 28 | `#b5835a` | 38 | `#554323` |
| 9 | `#2f3140` | 19 | `#8f5c66` | 29 | `#855139` | 39 | `#353021` |
| 10 | `#182029` | 20 | `#5a4256` | 30 | `#60342c` | 40 | `#1c200f` |

Os hexadecimais acima reproduzem a lista publicada em Lospec. `tools/sprite_lint.py` também mantém uma cópia dessa lista para detectar cores fora da paleta; ao atualizar, mantenha ambas sincronizadas.

## Subconjuntos do projeto

Cada contrato pode unir mais de um subconjunto, respeitando `max_colors`.

| ID | Uso recomendado | Cores permitidas |
|---|---|---|
| `neutral_stone` | pedra, sombras e contornos minerais | `#000000 #182029 #2f3140 #353235 #4a484a #627c80 #a49983 #e6dac5` |
| `iron` | aço, armas e armadura | `#000000 #182029 #2f3140 #353235 #4a484a #627c80 #bdd2de #e6dac5` |
| `lumen` | slime, magia verde-azulada e energia | `#000000 #182029 #314646 #425a58 #627c80 #81b5a2 #bdd2de #e6dac5` |
| `forest` | musgo, folhas e vegetação | `#1c200f #223925 #353021 #484c2a #545f28 #607a53 #7b7d6a #81b5a2` |
| `wood` | madeira, chifres e couro | `#2a1810 #3b1c16 #60342c #703a1a #80592e #855139 #b5835a #e6dac5` |
| `gold` | ouro e detalhes de raridade | `#3b1c16 #8a5c0a #af8e2c #caaa6c #e6dac5` |
| `crimson` | olhos, alertas e acentos de dano | `#2a1810 #402736 #562f36 #5a4256 #7a393d #8f5c66 #bf5437` |

Subconjuntos são seleções da TY40, não licenças para combinar arbitrariamente todos os tons. A direção de luz continua top-left; contraste e legibilidade a 1× continuam obrigatórios.

## Migração e compatibilidade

As rampas nomeadas e os códigos hex antigos presentes em contratos, scripts ou notas são **LEGADO**, não autorizados para novos assets. Atualize um asset por vez pelo contrato e faça revisão visual; não quantize sprites aprovados em massa sem revalidação. Os três contratos principais apontam para os subconjuntos TY40 correspondentes.

## Uso no Aseprite / pixel-mcp

Carregue a paleta/subconjunto declarado no contrato, preserve transparência binária e valide o PNG final com [`sprite_lint.py`](../../tools/sprite_lint.py). A paleta não aprova sozinha a qualidade visual nem o contraste no jogo.
