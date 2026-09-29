# Conceitos-piloto de chefes e itens — 2026-09-28

**Estado atualizado:** Rafael definiu a tela do inventário em grade visual e o canvas final dos itens em 32×32. O pedido explícito de produção autorizou os 30 ícones visuais. Nenhum dado de gameplay foi alterado para os 15 itens candidatos.

## Entregas atuais

- [Grade de prévia dos 30 ícones](./previews/item_icons_32x32_contact_sheet.png) — lote visual do catálogo anterior (15 runtime + 15 candidatos), não mapeado ao catálogo canônico v0.4; PNGs em [`assets/sprites/items/`](../../assets/sprites/items/).
- [Catálogo visual usado pela interface](../../data/items/item_visual_catalog.json) — inclui estado `mvp` ou `visual_candidate`; não substitui a tabela de loot.
- Tela de inventário em grade (removida no `1A-CUT`; recuperável no git, commit `cd47758`) — acessível pelo botão “Itens” na tela principal; só permite equipar itens MVP que realmente estejam na mochila.
- [Matriarca do Micélio 64×64](./previews/matriarca_micelio_64x64_preview_8x.png) — uma pose neutra candidata. O Guardião-Cervo continua usando o Golden aprovado e sua folha existente, sem redesenho.

O linter de sprites passou para **31/31 manifestos** (30 ícones e a pose da Matriarca). Auditoria visual independente e validação mobile continuam pendentes. A pose da Matriarca não define animações nem aprova lore, atributos, loot ou comportamento.

## Histórico preservado

Na primeira etapa foram criados estes conceitos amplos, mantidos como referências de processo:

- [Matriarca do Micélio — conceito candidato v001](./conceitos/chefes/matriarca_micelio_candidate_v001.png) — SHA-256 `03c9fe495f22a879fcd257168cb10f754de11629399183a017a6edec394ceb38`.
- [Adaga de Luz — conceito candidato v001](./conceitos/itens/adaga_luz_candidate_v001.png) — SHA-256 `76a04c27379d409204245866799205088a9387ad15aa815f677fc8e79bb254bc`.
- Rafael gostou da referência conceitual Matriarca v002; ela permanece preservada na ficha da [Matriarca](./conceitos/chefes/matriarca_micelio.md).

Naquela etapa, o tamanho final dos ícones e a tela de inventário estavam em aberto. A decisão de 32×32 e a escolha pela grade visual acima substituem essa pendência.

## Fronteira de conteúdo

Os 15 itens MVP continuam sendo os únicos definidos na tabela de loot. Os 15 ícones extras estão marcados como candidatos visuais e não receberam efeitos ou valores de balanceamento. O Guardião-Cervo é o boss Golden existente; a Matriarca permanece candidata de conteúdo e sua arte atual é apenas uma pose estática.
