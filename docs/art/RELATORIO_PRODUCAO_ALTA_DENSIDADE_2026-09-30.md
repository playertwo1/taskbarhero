# Relatório de Produção — Padrão de Alta Densidade e Inventário Visual (2026-09-30)

**Autoridade de aprovação:** Rafael (decisão registrada em 2026-09-30).  
**Paleta:** TY High Fantasy 40 (subconjuntos temáticos estritos, transparência binária, zero mixels).  
**Status do pipeline:** `IMPLEMENTED` / `QA` técnico.

---

## 1. Padrão Canônico de Resolução e Hierarquia Visual

Para garantir silhuetas ricas em detalhes dark fantasy mantendo a grade de pixels uniforme (1:1 no viewport mobile sem distorção ou *mixels*), Rafael aprovou a seguinte hierarquia proporcional:

| Elemento | Resolução Canônica | Baseline / Alinhamento | Destino no Projeto | Origem Pipeline |
|---|---:|---|---|---|
| **Heróis (8 personagens)** | **96×96** | $Y=94\text{--}96$ | `assets/sprites/heroes/<heroi>/hero_<heroi>_96x96.png` | `work/art_pipeline/<heroi>/` |
| **Inimigos Pequenos** | **64×64** | $Y=62\text{--}64$ | `assets/sprites/enemies/highres/` | `work/art_pipeline/enemies/` |
| **Inimigos Normais** | **96×96** | $Y=94\text{--}96$ | `assets/sprites/enemies/highres/` | `work/art_pipeline/enemies/` |
| **Elites** | **128×128** | $Y=124\text{--}126$ | `assets/sprites/enemies/highres/` | `work/art_pipeline/enemies/` |
| **Mini-chefes** | **160×160** | $Y=156\text{--}158$ | `assets/sprites/enemies/highres/` | `work/art_pipeline/enemies/` |
| **Chefe Supremo** | **224×224** | $Y=220\text{--}222$ | `assets/sprites/enemies/highres/` | `work/art_pipeline/enemies/` |
| **Ícones de Itens (v0.4)** | **64×64** | Centralizado | `assets/sprites/items/icons_64/` | `work/art_pipeline/items_64/` |
| **Ícones de Skills** | **64×64** | Centralizado | `assets/sprites/skills/icons_64/` | `work/art_pipeline/skills_64/` |
| **Painéis / Hub / Retratos** | **256×256+** | Enquadramento UI | `assets/sprites/hub/` | `work/art_pipeline/hub/` |
| **Arquivo Master de Criação**| **1024×1024** | Centralizado | `docs/art/referencia/` / pipeline | Master Comfy/Aseprite |

---

## 2. Elenco Completo dos 8 Heróis (96×96)

Todos os heróis foram gerados na resolução de **96×96**, pés no chão, voltados para a direita ($\rightarrow$), quantizados estritamente para os subconjuntos da paleta TY40:

1. **🛡️ Bastião (`HERO_001`):** `assets/sprites/heroes/bastiao/hero_bastiao_96x96.png` (Subconjuntos: *iron, gold* · 12 cores).
2. **🏹 Flecha (`HERO_002`):** `assets/sprites/heroes/flecha/hero_flecha_96x96.png` (Subconjuntos: *forest, wood, iron* · 14 cores).
3. **🔮 Íris (`HERO_003`):** `assets/sprites/heroes/iris/hero_iris_96x96.png` (Subconjuntos: *crimson, lumen, gold* · 15 cores).
4. **🔥 Brasa (`HERO_004`):** `assets/sprites/heroes/brasa/hero_brasa_96x96.png` (Subconjuntos: *crimson, iron, wood, gold* · 15 cores).
5. **🗡️ Véu (`HERO_005`):** `assets/sprites/heroes/veu/hero_veu_96x96.png` (Subconjuntos: *iron, crimson, neutral_stone* · 14 cores).
6. **💧 Orvalho (`HERO_006`):** `assets/sprites/heroes/orvalho/hero_orvalho_96x96.png` (Subconjuntos: *forest, wood, lumen, neutral_stone* · 14 cores).
7. **🔨 Forja (`HERO_007`):** `assets/sprites/heroes/forja/hero_forja_96x96.png` (Subconjuntos: *iron, gold, lumen, wood* · 15 cores).
8. **🔔 Sino (`HERO_008`):** `assets/sprites/heroes/sino/hero_sino_96x96.png` (Subconjuntos: *lumen, gold, crimson, iron* · 15 cores).

*Lineup comparativo:* `hero_roster_96_lineup.png` (disponível no relatório de validação).

---

## 3. Bestiário do Capítulo 1 — Bosque de Lúmen (17 Entidades)

Todos os adversários estão voltados para a esquerda ($\leftarrow$) na escala correta da hierarquia, localizados em `assets/sprites/enemies/highres/` e `work/art_pipeline/enemies/`:

### Inimigos Pequenos (64×64)
- **Gremlin de Folhas (`EN_C1_001`):** `mob_gremlin_de_folhas_64x64.png` (forest, wood, iron · 12 cores).
- **Sapinho do Lúmen (`EN_C1_002`):** `mob_sapinho_do_lumen_64x64.png` (lumen, forest · 10 cores).

### Inimigos Normais (96×96)
- **Geleia de Lúmen (`EN_C1_003`):** `mob_geleia_de_lumen_96x96.png` (lumen, gold · 11 cores).
- **Espírito de Raiz (`EN_C1_004`):** `mob_espirito_de_raiz_96x96.png` (forest, wood, lumen · 12 cores).
- **Javali de Musgo (`EN_C1_005`):** `mob_javali_de_musgo_96x96.png` (wood, forest, iron · 12 cores).
- **Mariposa Luminosa (`EN_C1_006`):** `mob_mariposa_luminosa_96x96.png` (lumen, crimson, gold · 13 cores).
- **Cogumelo Sonolento (`EN_C1_007`):** `mob_cogumelo_sonolento_96x96.png` (forest, crimson, lumen · 12 cores).
- **Trepa-Cadáver (`EN_C1_008`):** `mob_trepa_cadaver_96x96.png` (wood, neutral_stone, crimson · 13 cores).
- **Caracol Cristalino (`EN_C1_009`):** `mob_caracol_cristalino_96x96.png` (lumen, neutral_stone, gold · 12 cores).
- **Raposa Oca (`EN_C1_010`):** `mob_raposa_oca_96x96.png` (wood, crimson, lumen · 13 cores).

### Elites (128×128)
- **Geleia Anciã (`EL_C1_001`):** `elite_geleia_ancia_128x128.png` (lumen, gold, crimson · 14 cores).
- **Javali Cicatrizado (`EL_C1_002`):** `elite_javali_cicatrizado_128x128.png` (wood, iron, crimson · 14 cores).
- **Gremlin Espinhento (`EL_C1_003`):** `elite_gremlin_espinhento_128x128.png` (forest, wood, crimson, iron · 14 cores).

### Mini-chefes (160×160)
- **Rainha das Geleias (`MB_C1_001`):** `mb_rainha_das_geleias_160x160.png` (lumen, gold, crimson · 15 cores).
- **Javali da Ponte (`MB_C1_002`):** `mb_javali_da_ponte_160x160.png` (wood, iron, neutral_stone · 14 cores).
- **O Espinheiro (`MB_C1_003`):** `mb_o_espinheiro_160x160.png` (wood, crimson, lumen · 14 cores).

### Chefe Supremo (224×224)
- **Guardião-Cervo de Pedra (`BOSS_C1_001`):** `boss_guardiao_cervo_224x224.png` (neutral_stone, forest, lumen, gold · 15 cores).

---

## 4. Catálogo de Itens e Ecos Canônicos v0.4 (Ícones 64×64)

Todos os 30 itens canônicos do Capítulo 1 foram padronizados em **64×64** em `assets/sprites/items/icons_64/` e `work/art_pipeline/items_64/`:

- **Armas (5):** `item_galho_de_vigilia_64x64.png`, `item_arco_de_folha_tensa_64x64.png`, `item_presa_do_javali_de_musgo_64x64.png`, `item_lamina_da_raposa_oca_64x64.png`, `item_agulha_da_viuva_64x64.png`.
- **Secundários / Escudos (5):** `item_broquel_de_casca_64x64.png`, `item_lanterna_de_esporos_64x64.png`, `item_totem_da_raiz_antiga_64x64.png`, `item_farol_prismatico_64x64.png`, `item_engrenagem_impossivel_64x64.png`.
- **Armaduras (5):** `item_manto_de_folhas_64x64.png`, `item_couraca_de_musgo_64x64.png`, `item_casco_cristalino_64x64.png`, `item_coracao_de_pedra_64x64.png`, `item_casca_do_guardiao_64x64.png`.
- **Relíquias / Acessórios (10):** `item_gota_de_lumen_64x64.png`, `item_esporo_sonolento_64x64.png`, `item_talisma_do_salto_64x64.png`, `item_olho_de_vidro_verde_64x64.png`, `item_fragmento_prismatico_64x64.png`, `item_dente_da_raposa_oca_64x64.png`, `item_flor_de_musgo_64x64.png`, `item_petala_do_primeiro_jardim_64x64.png`, `item_raiz_faminta_64x64.png`, `item_cinza_eterna_64x64.png`.
- **Ecos (5):** `item_eco_da_geleia_64x64.png`, `item_eco_da_mariposa_64x64.png`, `item_eco_do_espinheiro_64x64.png`, `item_sino_partido_64x64.png`, `item_memoria_do_guardiao_64x64.png`.

---

## 5. Hub e Ilustrações de Serviço (256×256+)

Localizados em `assets/sprites/hub/` e `work/art_pipeline/hub/`:
- **Árvore dos Ecos (`hub_arvore_dos_ecos_256x256.png`):** Monólito esculpido com lanterna central e nós de ressonância.
- **Ferreiro de Lúmen (`hub_ferreiro_de_lumen_256x256.png`):** Forja e bigorna mágica para reforço e desmontagem.
- **Refúgio Pós-Boss (`hub_refugio_pos_boss_256x256.png`):** Cenário de celebração com água despoluída e Lúmen florescendo.
- **Lanterna-Mãe Módulos (`hub_lanterna_mae_modulos_256x256.png`):** Coroa vegetal e núcleos de evolução do refúgio.
- **Refúgio Retrato Mobile (`refugio_mobile_retrato_216x480.png`):** Ilustração vertical de fundo para a tela mobile portrait.

---

## 6. UI Kit e Tema AMOLED Godot

- **Assets 9-Slice:** `assets/sprites/ui/ui_kit/` (`panel_dark.png`, `panel_inner.png`, `button_normal.png`, `button_pressed.png`, `button_disabled.png`, `progress_bar_bg.png`, `progress_bar_fill.png`).
- **Tema Godot Nativo:** `assets/ui/pocket_hero_theme.tres` com `StyleBoxTexture` configurados com margens de 9-slice corretas, cantos e cores de fonte AMOLED.
- **Integração na Cena de Campanha (`scripts/ui/SliceCampaignScreen.gd`):**
  - Aplicado o tema global ao `Control` raiz.
  - Criada barra superior (TopBar) do Refúgio com ícones pixel art para Fragmentos de Lúmen, Resíduos e XP Global.
  - Implementada arena visual de combate com 4 camadas de fundo do Bosque de Lúmen e atores de combate animados para o Herói Líder e o Inimigo Atual (idle, ataque, dano, derrota).

---

## 7. Verificação Técnica e Testes

- **Suíte de Testes Godot:** `python tools/run_godot_tests.py` $\rightarrow$ **29/30 PASS** (mantém o baseline estrito homologado; zero regressões).
- **Execução Interativa:** Cena jogável `res://scenes/slice/SliceCampaign.tscn` executada e validada no Godot 4.7.2 com driver Direct3D 12.
