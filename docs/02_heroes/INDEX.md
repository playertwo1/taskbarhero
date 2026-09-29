# Heróis — índice

O catálogo canônico de IDs, nomes e status do roster fica no [registro central](../CONTENT_REGISTRY.md).

> [!IMPORTANT]
> **Padrão Canônico dos Heróis:** Consulte o [HERO_STANDARD.md](../../HERO_STANDARD.md) na raiz do repositório: 7 ações (1 ataque básico + 6 skills no total, incluindo 1 Signature), 16 passivas, 3 Traits, 6 slots de equipamento (5 convencionais + 1 Echo), níveis 1–100, Mastery 1–10, missões pessoais, 4 estágios visuais e definition of done.

Para o bloco de atributos e alvos de balanceamento, siga o [padrão compartilhado de balanceamento](../06_balance/COMBAT_BALANCE_STANDARD.md). Ele não substitui a ficha de identidade nem introduz migração runtime.

O roster completo do Pocket Hero é composto por **8 heróis**, sendo que qualquer expedição é formada por um trio (3 ativos). A composição da party é uma das decisões táticas centrais do jogo: as mecânicas combinam organicamente sem necessidade de bônus artificiais.

## Roster dos 8 heróis

| ID de design | Nome | Função central | Mecânica chave | Ficha de detalhe |
| --- | --- | --- | --- | --- |
| `HERO_001` | **Bastião** | Tanque / Proteção | Escudo / Guarda (Defesa e Retaliação) | [Golden Reference de design](BASTIAO_GOLDEN_REFERENCE.md) · [Passivas](hero_001_bastiao_passives.md) · [Traits](hero_001_bastiao_traits.md) · [Mastery](hero_001_bastiao_mastery.md) · [Ficha resumida](hero_001_bastiao.md) |
| `HERO_002` | **Flecha** | Ranged DPS | Marca do Caçador / precisão e críticos | [Ficha](hero_002_flecha.md) · [Skills](../04_content/skills/FLECHA_SKILLS.md) · [Passivas](hero_002_flecha_passives.md) · [Traits](hero_002_flecha_traits.md) · [Mastery](hero_002_flecha_mastery.md) |
| `HERO_003` | **Íris** | Maga / AoE | Feixes de Lúmen / Controle arcano | [hero_003_iris.md](hero_003_iris.md) |
| `HERO_004` | **Brasa** | Bruiser / Berserker | Fúria / Dano em baixo HP | [hero_004_brasa.md](hero_004_brasa.md) |
| `HERO_005` | **Véu** | Assassino / Backline Killer | Exposição / Execução | [hero_005_veu.md](hero_005_veu.md) |
| `HERO_006` | **Orvalho** | Healer / Regeneração | Sementes / Florescimento em jardim | [hero_006_orvalho.md](hero_006_orvalho.md) |
| `HERO_007` | **Forja** | Engenheira / Invocadora | Engenhocas / Magitecnologia antiga | [hero_007_forja.md](hero_007_forja.md) |
| `HERO_008` | **Sino** | Suporte Buffer | Ritmo / Manipulação de notas e memórias | [hero_008_sino.md](hero_008_sino.md) |

IDs e status de ciclo são autoridade do [registro central](../CONTENT_REGISTRY.md). As cenas de runtime ficam em [`scenes/heroes/`](../../scenes/heroes/); uma cena existente não comprova conclusão do design no [padrão canônico](../../HERO_STANDARD.md).

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
