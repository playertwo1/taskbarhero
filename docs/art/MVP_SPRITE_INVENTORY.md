# Inventário de sprites do MVP — Pocket Hero

Atualizado em 2026-09-27 após Rafael autorizar refazer os sprites com base nos quatro Golden aprovados. Os PNGs canônicos foram substituídos mantendo seus caminhos; contratos, manifests v002 e JSONs registram dimensões, paletas e tempos. O lint técnico passou nos nove sprites animados. Auditoria visual independente e validação no layout mobile continuam pendentes, portanto os manifests ainda não declaram aprovação final.

## Escopo coberto

O Bosque de Lúmen inclui três heróis, quatro inimigos comuns, uma elite e um chefe, além de quatro camadas de ambiente. Todas as nove folhas têm 16 quadros; a Geleia usa quadros 64×64. O pedido atual cobre os sprites de entidades e o ambiente que já compõem o MVP. Os documentos disponíveis não especificam um pacote obrigatório de ícones para os 15 itens nem uma lista de efeitos; verificar as telas implementadas antes de abrir esse escopo.

## Entidades — folhas substituídas

| Entidade | Folha canônica | Quadro | Estado técnico | Manifesto |
|---|---|---:|---|---|
| Bastião | `assets/sprites/heroes/bastiao/hero_bastiao_sheet.png` | 16 quadros de 48×48 | TY40, 12 cores, lint PASS | `hero_bastiao_v002.manifest.yaml` |
| Flecha | `assets/sprites/heroes/flecha/hero_flecha_sheet.png` | 16 quadros de 48×48 | TY40, 14 cores, lint PASS | `hero_flecha_v002.manifest.yaml` |
| Íris | `assets/sprites/heroes/iris/hero_iris_sheet.png` | 16 quadros de 48×48 | TY40, 15 cores, lint PASS | `hero_iris_v002.manifest.yaml` |
| Geleia de Lúmen | `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png` | 16 quadros de 64×64 | TY40, 12 cores, lint PASS; cena atualizada para regiões 64×64 | `enemy_geleia_lumen_v002.manifest.yaml` |
| Gremlin de Folha | `assets/sprites/enemies/gremlin_de_folha/mob_gremlin_folha_sheet.png` | 16 quadros de 32×32 | TY40, 13 cores, lint PASS | `mob_gremlin_folha_v002.manifest.yaml` |
| Javali de Musgo | `assets/sprites/enemies/javali_de_musgo/mob_javali_musgo_sheet.png` | 16 quadros de 48×48 | TY40, 12 cores, lint PASS | `mob_javali_musgo_v002.manifest.yaml` |
| Espírito de Raiz | `assets/sprites/enemies/espirito_de_raiz/mob_espirito_raiz_sheet.png` | 16 quadros de 48×48 | TY40, 11 cores, lint PASS | `mob_espirito_raiz_v002.manifest.yaml` |
| Lobo Alfa de Lúmen | `assets/sprites/enemies/lobo_alfa_de_lumen/mob_lobo_alfa_sheet.png` | 16 quadros de 48×48 | TY40, 12 cores, lint PASS | `mob_lobo_alfa_v002.manifest.yaml` |
| Guardião-Cervo de Pedra | `assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_sheet.png` | 16 quadros de 64×64 | TY40, 13 cores, lint PASS | `boss_guardiao_cervo_v002.manifest.yaml` |

Os manifests distinguem QA técnico de QA artístico e mobile. O resultado do lint não equivale a uma avaliação de movimento, leitura em tela ou qualidade final. As quatro referências Golden aprovadas e seus hashes estão em [`golden/README.md`](golden/README.md).

## Ambiente — quatro camadas substituídas

Os nomes e dimensões usados pelo jogo foram preservados:

| Camada | Arquivo | Tamanho | Nota |
|---|---|---:|---|
| Fundo distante | `assets/sprites/environment/bosque_lumen/bg_distant.png` | 216×110 | Fundo opaco quantizado em TY40 |
| Árvores intermediárias | `assets/sprites/environment/bosque_lumen/mid_trees.png` | 216×110 | Camada transparente, TY40 |
| Faixa de chão | `assets/sprites/environment/bosque_lumen/ground_strip.png` | 216×42 | Camada transparente, TY40 |
| Elementos frontais | `assets/sprites/environment/bosque_lumen/fg_elements.png` | 216×24 | Camada transparente, TY40 |

As quatro camadas precisam de revisão de composição no cenário e na câmera mobile antes do aceite visual de release.

## Aceite restante

1. Fazer auditoria visual do conjunto de animações e das quatro camadas no cenário real.
2. Revisar escala, baseline, sobreposições e leitura em tela mobile.
3. Investigar ícones de itens e efeitos somente se forem exigidos pelas telas do MVP.
4. Atualizar QA e manifests para `APPROVED`/`INTEGRATED` depois dos aceites, sem confundir PASS técnico com aprovação artística.
