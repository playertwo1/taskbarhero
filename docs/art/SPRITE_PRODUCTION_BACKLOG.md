# Fila de sprites do SLICE-1

**Status:** `DESIGN`. Este arquivo liga cada referência visual atual a um pacote de sprites e às peças do contrato que o pacote deve entregar. É uma lista de produção; não aprova telas nem altera valores de gameplay.

## Ordem e dependências

1. **`ui_kit` primeiro:** pixel cleanup → QA técnico → auditoria visual independente. O conceito foi aprovado por Rafael; as peças ainda não passaram pelos gates.
2. Depois do PASS do kit, seguir a ordem explícita do [ROADMAP](../../ROADMAP.md): Refúgio (`UI_S02`) e Expedição em curso (`UI_S05`) primeiro; os demais pacotes seguem os contratos de tela.
3. A camada pós-boss da Lanterna-Mãe depende da cena modular do Refúgio. Seu contrato determina que `lantern_glow` passe primeiro pelo gate próprio.

Use a lista para ligar imagem e trabalho. As dimensões, a paleta, os estados e o aceite vivem nos contratos indicados. Peças `shared` e sprites Golden são reutilizados, nunca duplicados.

## Mapa imagem → item de produção

| Imagem de referência | Item de produção | Contrato / fonte das peças |
| --- | --- | --- |
| [Conceito do ui_kit v003](candidates/ui_kit_v003/concept_ui_kit_v003.png) | `ui_kit` — kit compartilhado | [Contrato](contracts/screens/ui_kit.yaml) |
| [Título](mockups/title_screen_reference.png) | `UI_S01` — Tela de Título | [Contrato](contracts/screens/s01_titulo.yaml) |
| [Refúgio](mockups/slice_1e_references/s02_refugio_concept_v001.png) | `UI_S02` — Cena e pontos de serviço do Refúgio | [Contrato](contracts/screens/s02_refugio.yaml) · [direção modular](../05_hub/HUB_VISUAL_DIRECTION.md) |
| [Expedição](mockups/slice_1e_references/s03_expedicao_concept_v001.png) | `UI_S03` — Trilha e nós da rota | [Contrato](contracts/screens/s03_expedicao.yaml) |
| [Loadout](mockups/slice_1e_references/s04_loadout_concept_v001.png) | `UI_S04` — Retratos, skills e slots | [Contrato](contracts/screens/s04_loadout.yaml) |
| [Combate](mockups/slice_1e_references/s05_expedicao_em_curso_concept_v001.png) | `UI_S05` — HUD de combate | [Contrato](contracts/screens/s05_expedicao_em_curso.yaml) |
| [Evento no Poço](mockups/slice_1e_references/s06_event_choice_concept_v001.png) e [Reward Choice](mockups/slice_1e_references/s06_reward_choice_concept_v001.png) | `UI_S06` — Cartões de escolha | [Contrato](contracts/screens/s06_escolha.yaml) |
| [Resultado: vitória](mockups/slice_1e_references/s07_resultado_concept_v001.png) e [derrota](mockups/slice_1e_references/s07_resultado_derrota_concept_v001.png) | `UI_S07` — Estados de resultado | [Contrato](contracts/screens/s07_resultado.yaml) |
| [Inventário e seção Echo](mockups/slice_1e_references/s08_inventario_echo_section_concept_v001.png) | `UI_S08` + `UI_S11` — Inventário e cartão do Echo | [Inventário](contracts/screens/s08_inventario.yaml) · [Gravadora](contracts/screens/s11_gravadora_de_ecos.yaml) |
| [Árvore dos Ecos](mockups/slice_1d_references/01_arvore_dos_ecos_v003.png) | `UI_S09` — Nós e ligações da Árvore | [Contrato](contracts/screens/s09_arvore_dos_ecos.yaml) |
| [Ferreiro](mockups/slice_1d_references/02_ferreiro_v003.png) | `UI_S10` — Forja, confirmação e Reforço +1 | [Contrato](contracts/screens/s10_ferreiro.yaml) |
| [Refúgio depois do boss](mockups/slice_1d_references/03_refugio_pos_boss_v003.png) e [estudos dos módulos](mockups/slice_1d_references/04_lanterna_overlay_modules_v001.png) | `hub_lanterna_mae_pos_boss` — camada modular cosmética | [Contrato](contracts/hub_environment/hub_lanterna_mae_pos_boss.yaml) |

## Itens de produção

### `ui_kit` — compartilhado; fechar primeiro

- [ ] `button_primary` — normal, pressionado e desabilitado.
- [ ] `button_secondary` — normal, pressionado e desabilitado.
- [ ] `panel_frame` — moldura opaca 9-slice.
- [ ] `divider` — divisor/cabeçalho.
- [ ] `icon_fragment_16`, `icon_fragment_24`.
- [ ] `icon_residue_16`, `icon_residue_24`.
- [ ] `icon_xp_16`, `icon_xp_24`.

### `UI_S01` — Título

- [ ] `background`.
- [ ] `logo`.
- [ ] `lumen_particles`.

### `UI_S02` — Refúgio

- [ ] `background` — produzir por módulos conforme a direção do Hub; a referência não autoriza achatar a cena num único fundo final.
- [ ] `forge_active`.
- [ ] `campfire`.
- [ ] `service_locked_badge`.
- [ ] `party_rest` — reaproveitar os sprites Golden de Bastião, Flecha e Íris; não redesenhar.

### `UI_S03` — Expedição

- [ ] `background`.
- [ ] `stage_icons` — nós por tipo de encontro.
- [ ] `trail_line` — trecho concluído/pendente.
- [ ] `milestone_badge`.

### `UI_S04` — Loadout

- [ ] `background`.
- [ ] `hero_portraits` — derivar das folhas aprovadas; não redesenhar os heróis.
- [ ] `skill_icons_bastiao_flecha` — 8 ícones novos, ligados às skills do recorte.
- [ ] `skill_icons_iris` — 4 ícones novos, ligados às skills do recorte.
- [ ] `slot_frame`.
- [ ] `button_states` — reutilizar `ui_kit`.

### `UI_S05` — Expedição em curso

- [ ] `background` — reutilizar as quatro camadas existentes do Bosque de Lúmen.
- [ ] `hero_sprites` — reutilizar as folhas aprovadas do trio.
- [ ] `enemy_sprites_existing` — reutilizar Geleia, Espírito de Raiz, Gremlin, Javali de Musgo e Guardião-Cervo.
- [ ] `enemy_sprites_new` — oito fichas abaixo têm referência visual; criar contrato próprio antes da folha de animação:
  - [ ] `EN_C1_005` Mariposa Luminosa — [conceito atual](referencia/capitulo_01/inimigos_comuns/EN_C1_005_mariposa_luminosa_conceito_v002.png).
  - [ ] `EN_C1_006` Cogumelo Sonolento — [conceito atual](referencia/capitulo_01/inimigos_comuns/EN_C1_006_cogumelo_sonolento_conceito_v002.png).
  - [ ] `EN_C1_007` Trepa-Cadáver — [conceito atual](referencia/capitulo_01/inimigos_comuns/EN_C1_007_trepa_cadaver_conceito_v002.png).
  - [ ] `EN_C1_008` Caracol Cristalino — [conceito atual](referencia/capitulo_01/inimigos_comuns/EN_C1_008_caracol_cristalino_conceito_v002.png).
  - [ ] `EN_C1_009` Raposa Oca — [conceito atual](referencia/capitulo_01/inimigos_comuns/EN_C1_009_raposa_oca_conceito_v002.png).
  - [ ] `EN_C1_010` Sapinho do Lúmen — [conceito atual](referencia/capitulo_01/inimigos_comuns/EN_C1_010_sapinho_do_lumen_conceito_v002.png).
  - [ ] `EL_C1_001` Geleia Anciã — [conceito atual](referencia/capitulo_01/elites/EL_C1_001_geleia_ancia_conceito_v002.png).
  - [ ] `MB_C1_001` Rainha das Geleias — [conceito atual](referencia/capitulo_01/minichefes/MB_C1_001_rainha_das_geleias_conceito_v002.png).
- [ ] `hp_bar`.
- [ ] `telegraph_marker`.
- [ ] `skill_effects` e feedback de Perfect Block — usar contratos/fontes das skills; a referência de tela não define efeitos.

### `UI_S06` — Escolha

- [ ] `background`.
- [ ] `event_frame`.
- [ ] `well_scene` — a imagem de evento acima é referência de composição.
- [ ] `item_icons` — 14 ícones 32×32; selecionar IDs pelo recorte antes de desenhar. O [catálogo visual dos 30 conceitos](referencia/itens_v04/README.md) liga cada imagem ao ID e nome do item; escolher dali os 14 definidos em [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md). Não inventar itens pela imagem.
- [ ] `rarity_borders` — sem cores/estados promocionais.
- [ ] `button_states` — reutilizar `ui_kit`.

### `UI_S07` — Resultado

- [ ] `background`.
- [ ] `result_banner_win`.
- [ ] `result_banner_lose`.
- [ ] `reward_row_icons` — reutilizar ícones de Fragmento, Resíduo e XP do `ui_kit`; item usa a coleção de `item_icons`.
- [ ] `button_states` — reutilizar `ui_kit`.

### `UI_S08` + `UI_S11` — Inventário / Echo

- [ ] `background` de S08 — manter o painel opaco já existente; não criar fundo só por causa da referência.
- [ ] `item_icons` — reutilizar o conjunto de 14 ícones de S06.
- [ ] `rarity_borders` — reutilizar o conjunto de S06.
- [ ] `slot_tabs`.
- [ ] `favorite_star`.
- [ ] `echo_card` — uma seção dentro do Inventário, sem nova tela.
- [ ] `echo_icon` — *A Sentinela que Ficou*.
- [ ] `button_states` — reutilizar `ui_kit`.

### `UI_S09` — Árvore dos Ecos

- [ ] `background`.
- [ ] `node_frame` — 4 estados do contrato.
- [ ] `node_icons` — um para cada nó do slice.
- [ ] `link_line` — ativa/inativa.
- [ ] `fragment_icon` — reutilizar `icon_fragment_16` do `ui_kit`.
- [ ] `button_states` — reutilizar `ui_kit`.

### `UI_S10` — Ferreiro

- [ ] `background`.
- [ ] `anvil_scene`.
- [ ] `confirm_dialog`.
- [ ] `residue_icon` — reutilizar `icon_residue_16` do `ui_kit`.
- [ ] `reinforce_badge`.
- [ ] `button_states` — reutilizar `ui_kit`.

### `hub_lanterna_mae_pos_boss` — camada do Refúgio

- [ ] `lantern_glow` — primeiro módulo deste contrato; folha de 6 quadros.
- [ ] `lantern_core` — 4 quadros; começar após o gate do brilho.
- [ ] `plaza_vegetation_a`.
- [ ] `plaza_vegetation_b`.
- [ ] `plaza_sprout` — 2 quadros.
- Dependência: cena modular do Refúgio e âncoras/pivôs definidos. A camada não cria cenário ou marco novo.

## Regras de uso da fila

- Os checkboxes indicam trabalho de sprite ainda não entregue; a referência conceitual não conta como sprite.
- Não produza peças `shared` duas vezes nem substitua Golden/arquivos `existing`.
- Os IDs, tamanhos e requisitos são os dos contratos. Texto rasterizado, contadores e ícones das mockups não definem conteúdo ou valores.
- Não comece sprites de entidade sem ficha/contrato correspondente e sem cumprir a ordem de gates do [ROADMAP](../../ROADMAP.md) e do [recorte](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md).
