# Heróis — índice

O catálogo canônico de IDs, nomes e status do roster fica no [registro central](../CONTENT_REGISTRY.md).

> [!IMPORTANT]
> **Padrão Canônico dos Heróis:** Consulte o [HERO_STANDARD.md](../../HERO_STANDARD.md) na raiz do repositório para a especificação canônica obrigatória de anatomia, 7 ações (1 básica + 5 skills + 1 Signature), 16 passivas, 3 Traits, 10 slots de equipamento, níveis 1–100, Mastery 1–10, missões pessoais, 4 estágios visuais e definition of done. O arquivo local `HERO_STANDARD.md` é apenas um ponteiro de compatibilidade.

O roster completo do Pocket Hero é composto por **8 heróis**, sendo que qualquer expedição é formada por um trio (3 ativos). A composição da party é uma das decisões táticas centrais do jogo: as mecânicas combinam organicamente sem necessidade de bônus artificiais.

## Roster dos 8 heróis

| ID de design | Nome | Função central | Mecânica chave | Status | Ficha de detalhe |
| --- | --- | --- | --- | --- | --- |
| `HERO_001` | **Bastião** | Tanque / Proteção | Escudo / Guarda (Defesa e Retaliação) | `DESIGN` | [Modelo Golden de design](BASTIAO_GOLDEN_REFERENCE.md) / [Ficha](hero_001_bastiao.md) / [Perfil anterior](BASTIAO_HERO.md) |
| `HERO_002` | **Flecha** | Ranged DPS | Marca da Caçada / Crítico contínuo | `IMPLEMENTED` | [hero_002_flecha.md](hero_002_flecha.md) |
| `HERO_003` | **Íris** | Maga / AoE | Feixes de Lúmen / Controle arcano | `IMPLEMENTED` | [hero_003_iris.md](hero_003_iris.md) |
| `HERO_004` | **Brasa** | Bruiser / Berserker | Fúria / Dano em baixo HP | `APPROVED` | [hero_004_brasa.md](hero_004_brasa.md) |
| `HERO_005` | **Véu** | Assassino / Backline Killer | Exposição / Execução | `APPROVED` | [hero_005_veu.md](hero_005_veu.md) |
| `HERO_006` | **Orvalho** | Healer / Regeneração | Sementes / Florescimento em jardim | `APPROVED` | [hero_006_orvalho.md](hero_006_orvalho.md) |
| `HERO_007` | **Forja** | Engenheira / Invocadora | Engenhocas / Magitecnologia antiga | `APPROVED` | [hero_007_forja.md](hero_007_forja.md) |
| `HERO_008` | **Sino** | Suporte Buffer | Ritmo / Manipulação de notas e memórias | `APPROVED` | [hero_008_sino.md](hero_008_sino.md) |

## Progressão narrativa e impacto no Hub (Refúgio da Vigília)

Os heróis são resgatados progressivamente ao longo dos capítulos:
* **Trio inicial (MVP):** Bastião, Flecha e Íris.
* **Bosque de Lúmen:** Encontro com Orvalho $\rightarrow$ Desbloqueia o **Jardim do Refúgio**.
* **Capítulos seguintes:**
  * Forja constrói a **Oficina do Refúgio**.
  * Sino restaura o **Memorial da Vigília**.
  * Brasa monta a **Área de Treinamento**.
  * Véu passa a rondar as sombras do Refúgio.

A chegada de cada herói significa uma nova moradora/morador no mundo, alterando física e funcionalmente o Hub.

## Recursos de desenvolvimento

- [Direção aprovada para modelos conceituais](../art/CONCEPT_MODEL_STYLE.md) · [modelos dos cinco heróis restantes v001](../art/mockups/hero_model_concepts_v001/README.md) · [trio inicial v002](../art/mockups/hero_model_concepts_v002/README.md) · [Íris revisada v003](../art/mockups/hero_model_concepts_v003/README.md). Conceitos visuais não substituem fichas, contratos ou sprites atuais.

O [Modelo Golden de design do Bastião](BASTIAO_GOLDEN_REFERENCE.md) é a referência de profundidade para fichas futuras. Reutilize sua organização, respeitando a anatomia de [HERO_STANDARD.md](../../HERO_STANDARD.md); mecânicas e números pertencem a cada herói e não devem ser copiados. “Golden” neste documento não indica aprovação visual de sprite.

* Cenas runtime: [`scenes/heroes/`](../../scenes/heroes/)
* Contratos de arte: [`docs/art/contracts/`](../art/contracts/)
* Folhas de sprites e manifests: [`assets/sprites/heroes/`](../../assets/sprites/heroes/)
