# Inventário de sprites e catálogo visual — Pocket Hero

Atualizado em 2026-09-28 após produção do elenco completo de 8 heróis, bestiário do Capítulo 1 (8 comuns, 1 elite, 1 minichefe, 1 chefe), 30 ícones de itens, 15 ícones de skills e 5 ícones de fases. Todas as folhas e ícones seguem contratos formais em `docs/art/contracts/`, subconjuntos da paleta TY High Fantasy 40, transparência binária, e alcançaram 100% PASS no `tools/sprite_lint.py`.

## 1. Heróis — Roster completo de 8 personagens

Todos os heróis usam canvas 48×48 com baseline $Y=44$, voltados para a **DIREITA** ($\rightarrow$), com folha de 16 quadros (4 Idle, 4 Run, 4 Attack, 4 Hit).

| Herói | Folha canônica | Quadro | Cores TY40 | Estado técnico | Manifesto |
|---|---|---:|---|---|---|
| 🛡️ Bastião | `assets/sprites/heroes/bastiao/hero_bastiao_sheet.png` | 16 quadros de 48×48 | 12 cores | TY40, PASS | `hero_bastiao_v002.manifest.yaml` |
| 🏹 Flecha | `assets/sprites/heroes/flecha/hero_flecha_sheet.png` | 16 quadros de 48×48 | 14 cores | TY40, PASS | `hero_flecha_v002.manifest.yaml` |
| 🔮 Íris | `assets/sprites/heroes/iris/hero_iris_sheet.png` | 16 quadros de 48×48 | 15 cores | TY40, PASS | `hero_iris_v002.manifest.yaml` |
| 🔥 Brasa | `assets/sprites/heroes/brasa/hero_brasa_sheet.png` | 16 quadros de 48×48 | 11 cores | TY40, PASS | `hero_brasa_v002.manifest.yaml` |
| 🗡️ Véu | `assets/sprites/heroes/veu/hero_veu_sheet.png` | 16 quadros de 48×48 | 10 cores | TY40, PASS | `hero_veu_v002.manifest.yaml` |
| 💧 Orvalho | `assets/sprites/heroes/orvalho/hero_orvalho_sheet.png` | 16 quadros de 48×48 | 11 cores | TY40, PASS | `hero_orvalho_v002.manifest.yaml` |
| 🔨 Forja | `assets/sprites/heroes/forja/hero_forja_sheet.png` | 16 quadros de 48×48 | 12 cores | TY40, PASS | `hero_forja_v002.manifest.yaml` |
| 🔔 Sino | `assets/sprites/heroes/sino/hero_sino_sheet.png` | 16 quadros de 48×48 | 10 cores | TY40, PASS | `hero_sino_v002.manifest.yaml` |

## 2. Inimigos e Chefes — Bestiário do Capítulo 1 (Bosque de Lúmen)

Todos os inimigos estão voltados para a **ESQUERDA** ($\leftarrow$), com folha de 16 quadros (4 Idle, 4 Run, 4 Attack, 4 Hit).

| Entidade | Categoria | Folha canônica | Quadro | Baseline | Cores TY40 | Estado técnico |
|---|---|---|---:|---:|---|---|
| Geleia de Lúmen | Comum | `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png` | 64×64 | $Y=60$ | 12 cores | TY40, PASS |
| Gremlin de Folha | Comum | `assets/sprites/enemies/gremlin_de_folha/mob_gremlin_folha_sheet.png` | 32×32 | $Y=29$ | 13 cores | TY40, PASS |
| Javali de Musgo | Comum | `assets/sprites/enemies/javali_de_musgo/mob_javali_musgo_sheet.png` | 48×48 | $Y=44$ | 12 cores | TY40, PASS |
| Espírito de Raiz | Comum | `assets/sprites/enemies/espirito_de_raiz/mob_espirito_raiz_sheet.png` | 48×48 | $Y=44$ | 11 cores | TY40, PASS |
| Saqueador da Mata | Comum | `assets/sprites/enemies/saqueador_da_mata/mob_saqueador_mata_sheet.png` | 48×48 | $Y=44$ | 11 cores | TY40, PASS |
| Xamã de Esporos | Comum | `assets/sprites/enemies/xama_de_esporos/mob_xama_esporos_sheet.png` | 48×48 | $Y=44$ | 11 cores | TY40, PASS |
| Sentinela de Raízes | Comum | `assets/sprites/enemies/sentinela_de_raizes/mob_sentinela_raizes_sheet.png` | 48×48 | $Y=44$ | 11 cores | TY40, PASS |
| Lobo de Sombra | Comum | `assets/sprites/enemies/lobo_de_sombra/mob_lobo_sombra_sheet.png` | 48×48 | $Y=44$ | 11 cores | TY40, PASS |
| Lobo Alfa de Lúmen | Elite | `assets/sprites/enemies/lobo_alfa_de_lumen/mob_lobo_alfa_sheet.png` | 48×48 | $Y=44$ | 12 cores | TY40, PASS |
| Matriarca do Micélio | Minichefe | `assets/sprites/bosses/matriarca_micelio/boss_matriarca_micelio_sheet.png` | 64×64 | $Y=60$ | 12 cores | TY40, PASS |
| Guardião-Cervo de Pedra | Chefe | `assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_sheet.png` | 64×64 | $Y=60$ | 13 cores | TY40, PASS |

## 3. Ícones de Itens (30 ícones — 32×32)

Localizados em `assets/sprites/items/icons/` com manifestos em `assets/sprites/items/manifests/`:
- **15 itens do MVP:** Adaga de Luz, Amuleto do Cervo, Arco da Copa Silente, Armadura do Guardião, Cajado de Lúmen, Capa da Névoa Verde, Colar de Espíritos, Coração da Floresta, Couraça de Javali, Dente de Basalto, Espada de Musgo, Gibão de Casca, Pedra Polida, Placa Rochosa, Túnica de Folhas.
- **15 novos itens de design:** Broche do Eco Claro, Cetro do Veio Âmbar, Couraça de Casca Musgosa, Jaqueta do Rastro Longo, Lâmina Silvestre, Lâmina da Trilha Partida, Maça da Raiz-Clara, Machado Ancestral, Manto de Micélio Trançado, Nó dos Marcos Antigos, Peitoral do Vigia Caído, Presa da Matilha, Ramo de Pedra-Runa, Semente do Veio Vivo, Semente Vital.
- **Status técnico:** 30/30 PASS no `sprite_lint.py`.

## 4. Ícones de Skills (15 ícones — 32×32)

Localizados em `assets/sprites/skills/icons/` com manifestos em `assets/sprites/skills/manifests/`:
- **Bastião (5):** Amparo de Raiz, Contra-golpe de Casca, Desafio do Guardião, Trama de Escudos, Voto da Clareira.
- **Flecha (5):** Marca da Caçada, Tiro de Ruptura, Rajada da Copa, Flecha de Execução, Passo do Rastro.
- **Íris (5):** Lança de Lúmen, Véu de Micélio, Fratura Arcana, Pulso Restaurador, Prisma de Retorno.
- **Status técnico:** 15/15 PASS no `sprite_lint.py`.

## 5. Ícones de Fases (5 ícones — 32×32)

Localizados em `assets/sprites/environment/stages/` com manifestos em `assets/sprites/environment/manifests/`:
- `stage_01_entrada_do_bosque.png`
- `stage_02_clareira_da_pressao.png`
- `stage_03_ninho_silvestre.png`
- `stage_04_covil_do_alfa.png`
- `stage_05_santuario_do_guardiao.png`
- **Status técnico:** 5/5 PASS no `sprite_lint.py`.

## 6. Ambiente — Bosque de Lúmen (4 Camadas)

Localizados em `assets/sprites/environment/bosque_lumen/`:
- Fundo distante (`bg_distant.png`, 216×110, opaco)
- Árvores intermediárias (`mid_trees.png`, 216×110, transparente)
- Faixa de chão (`ground_strip.png`, 216×42, transparente)
- Elementos frontais (`fg_elements.png`, 216×24, transparente)

## 7. Próximos passos de validação visual

1. Auditoria visual independente e revisão mobile dos novos lotes integrados.
2. Homologação das proporções e composições na cena de combate do Godot.

## 8. Padrão de Alta Densidade (Aprovado em 2026-09-30 por Rafael)

Para conferir fidelidade às referências conceituais e eliminar mixels na proporção de entidades maiores, Rafael aprovou o Padrão de Alta Densidade com hierarquia escalonada:

- **Heróis (8):** 96×96 com baseline $Y=94\text{--}96$ em `assets/sprites/heroes/<heroi>/hero_<heroi>_96x96.png` e `work/art_pipeline/<heroi>/`.
- **Inimigos Pequenos (2):** 64×64 (Gremlin de Folhas, Sapinho de Lúmen) em `assets/sprites/enemies/highres/` e `work/art_pipeline/enemies/`.
- **Inimigos Normais (8):** 96×96 (Geleia de Lúmen, Espírito de Raiz, Javali de Musgo, Mariposa Luminosa, Cogumelo Sonolento, Trepa-Cadáver, Caracol Cristalino, Raposa Oca) em `assets/sprites/enemies/highres/` e `work/art_pipeline/enemies/`.
- **Elites (3):** 128×128 (Geleia Anciã, Javali Cicatrizado, Gremlin Espinhento) em `assets/sprites/enemies/highres/` e `work/art_pipeline/enemies/`.
- **Mini-chefes (3):** 160×160 (Rainha das Geleias, Javali da Ponte, O Espinheiro) em `assets/sprites/enemies/highres/` e `work/art_pipeline/enemies/`.
- **Chefe Supremo (1):** 224×224 (Guardião-Cervo de Pedra) em `assets/sprites/enemies/highres/` e `work/art_pipeline/enemies/`.
- **Ícones de Itens v0.4 (30):** 64×64 em `assets/sprites/items/icons_64/` e `work/art_pipeline/items_64/`.
- **Painéis do Hub / Refúgio (5):** 256×256+ (Árvore dos Ecos, Ferreiro de Lúmen, Refúgio Pós-Boss, Lanterna-Mãe Módulos, Retrato Mobile) em `assets/sprites/hub/` e `work/art_pipeline/hub/`.
- **UI Kit & Tema:** `assets/sprites/ui/ui_kit/` e `assets/ui/pocket_hero_theme.tres`.

Relatório completo de especificações e paletas: [`docs/art/RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md`](RELATORIO_PRODUCAO_ALTA_DENSIDADE_2026-09-30.md).

