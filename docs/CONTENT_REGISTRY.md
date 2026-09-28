# Pocket Hero — registro central de conteúdo

Este registro é autoridade para **IDs de design**, nomes de catálogo e status de ciclo de vida. Ele só aponta para as fichas de detalhe; não replica lore, efeitos nem valores. Os IDs `id` já usados no runtime continuam sendo propriedade dos arquivos em `data/` e não são alterados por esta convenção.

**Status permitidos:** `CONCEPT`, `DESIGN`, `APPROVED`, `IMPLEMENTING`, `IMPLEMENTED`, `QA`, `PASS`, `DEPRECATED`. `HIPÓTESE` e `EM ABERTO` descrevem certeza de conteúdo, não são status de ciclo.

**Convenções adotadas:** `HERO_###`; `SKILL_<herói>_###`; `ITEM_WPN_###` (arma), `ITEM_ARM_###` (armadura), `ITEM_REL_###` (relíquia/amuleto); `ENEMY_LUM_###`; `BOSS_LUM_###`; `ECHO_LUM_###`; `TREE_<ramo>_###` para nós da Árvore dos Ecos (`VIG`, `FOR`, `FRT`, `OFI`, `ALQ`, `JOR`, `MEM`); `CHAPTER_##`; `STAGE_01_##` para subfases do Capítulo 1. IDs são persistentes: não reutilizar nem renumerar. Registrar aqui antes de implementar; o runtime usa os IDs do JSON até uma migração explícita.

## Contagem atual e fonte de detalhe

| Tipo | Catálogo registrado | Estado resumido | Fonte de detalhe/runtime |
| --- | --- | --- | --- |
| Heróis | 8 nomes no registro; 8 implementados na engine e conformes ao padrão canônico. | `IMPLEMENTED` | [Heróis](02_heroes/INDEX.md) e [Padrão Canônico](../HERO_STANDARD.md) |
| Skills | 15 skills normais fichadas para Bastião, Flecha e Íris; o roster completo requer 48 skills: cinco normais e uma Signature por cada um dos oito heróis. As outras 33 ainda não estão catalogadas. | `DESIGN` | [Skills](04_content/skills/INDEX.md) |
| Itens | 30: 15 runtime e 15 candidatos novos. | Misto | [Itens](04_content/items/INDEX.md) |
| Inimigos comuns | 8; todos presentes no runtime. | `IMPLEMENTED` | [Inimigos](04_content/enemies/INDEX.md) |
| Elite | 1; presente no runtime. | `IMPLEMENTED` | [Inimigos](04_content/enemies/INDEX.md) |
| Chefes | 2: um minichefe e um chefe; ambos presentes no runtime. | `IMPLEMENTED` | [Capítulo 1](04_content/chapters/chapter_01/OVERVIEW.md) |
| Subfases | Dez propostas; o jogo runtime tem cinco fases macro. | `DESIGN` | [Capítulos](04_content/chapters/INDEX.md) |
| Ecos | Um Echo funcional opcional está planejado no design de `SLICE-1`; nenhum Eco tem ficha runtime ou implementação. | `CONCEPT` | [Sistema de Ecos](03_systems/ECHO_SYSTEM.md) · [Catálogo](04_content/echoes/INDEX.md) |
| Hub | Visão futura sem especificação aprovada. | `CONCEPT` | [Hub](05_hub/INDEX.md) |

O catálogo atual contém 11 entidades nomeadas: oito inimigos comuns, uma elite, um minichefe e um chefe. Não completar qualquer diferença para contagens citadas em materiais antigos por inferência.

## Heróis

> [!NOTE]
> Todos os 8 heróis seguem a arquitetura mandatória de [`HERO_STANDARD.md`](../HERO_STANDARD.md).

| ID | Nome | Status | Fonte |
| --- | --- | --- | --- |
| `HERO_001` | Bastião | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_001_bastiao.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_002` | Flecha | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_002_flecha.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_003` | Íris | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_003_iris.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_004` | Brasa | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_004_brasa.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_005` | Véu | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_005_veu.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_006` | Orvalho | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_006_orvalho.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_007` | Forja | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_007_forja.md) e [Cena](02_heroes/INDEX.md) |
| `HERO_008` | Sino | `IMPLEMENTED` | [Ficha de design](02_heroes/hero_008_sino.md) e [Cena](02_heroes/INDEX.md) |

## Skills

O ID segue a ordem do catálogo de design no overview; números, gatilhos e regras runtime ainda não existem em `/data/skills/`. O padrão de 48 skills (cinco normais e uma Signature por herói) vem do [HERO_STANDARD](../HERO_STANDARD.md); só as 15 skills normais listadas abaixo têm ficha de conceito até agora, sem as Signature Skills.

| ID | Nome | Status | Fonte |
| --- | --- | --- | --- |
| `SKILL_BAS_001` | Amparo de Raiz | `DESIGN` | [Skills do Capítulo 1](04_content/chapters/chapter_01/OVERVIEW.md) |
| `SKILL_BAS_002` | Contra-golpe de Casca | `DESIGN` | idem |
| `SKILL_BAS_003` | Desafio do Guardião | `DESIGN` | idem |
| `SKILL_BAS_004` | Trama de Escudos | `DESIGN` | idem |
| `SKILL_BAS_005` | Voto da Clareira | `DESIGN` | idem |
| `SKILL_FLE_001` | Marca da Caçada | `DESIGN` | idem |
| `SKILL_FLE_002` | Tiro de Ruptura | `DESIGN` | idem |
| `SKILL_FLE_003` | Rajada da Copa | `DESIGN` | idem |
| `SKILL_FLE_004` | Flecha de Execução | `DESIGN` | idem |
| `SKILL_FLE_005` | Passo do Rastro | `DESIGN` | idem |
| `SKILL_IRI_001` | Lança de Lúmen | `DESIGN` | idem |
| `SKILL_IRI_002` | Véu de Micélio | `DESIGN` | idem |
| `SKILL_IRI_003` | Fratura Arcana | `DESIGN` | idem |
| `SKILL_IRI_004` | Pulso Restaurador | `DESIGN` | idem |
| `SKILL_IRI_005` | Prisma de Retorno | `DESIGN` | idem |

## Itens

`id runtime` identifica o registro usado pelo jogo. IDs de design organizam o catálogo e não substituem esses IDs.

| ID de design | Item | ID runtime | Status | Detalhe |
| --- | --- | --- | --- | --- |
| `ITEM_WPN_001` | Adaga de Luz | `adaga_de_luz` | `IMPLEMENTED` | [Catálogo/runtime e design](04_content/items/INDEX.md) |
| `ITEM_WPN_002` | Espada de Musgo | `espada_de_musgo` | `IMPLEMENTED` | idem |
| `ITEM_WPN_003` | Lâmina Silvestre | `lamina_silvestre` | `IMPLEMENTED` | idem |
| `ITEM_WPN_004` | Machado Ancestral | `machado_ancestral` | `IMPLEMENTED` | idem |
| `ITEM_WPN_005` | Cajado de Lúmen | `cajado_de_lumen` | `IMPLEMENTED` | idem |
| `ITEM_WPN_006` | Maça da Raiz-Clara | — | `DESIGN` | [Overview do Capítulo 1](04_content/chapters/chapter_01/OVERVIEW.md) |
| `ITEM_WPN_007` | Arco da Copa Silente | — | `DESIGN` | idem |
| `ITEM_WPN_008` | Cetro do Veio Âmbar | — | `DESIGN` | idem |
| `ITEM_WPN_009` | Lâmina da Trilha Partida | — | `DESIGN` | idem |
| `ITEM_WPN_010` | Ramo de Pedra-Runa | — | `DESIGN` | idem |
| `ITEM_ARM_001` | Túnica de Folhas | `tunica_de_folhas` | `IMPLEMENTED` | [Catálogo/runtime e design](04_content/items/INDEX.md) |
| `ITEM_ARM_002` | Gibão de Casca | `gibao_de_casca` | `IMPLEMENTED` | idem |
| `ITEM_ARM_003` | Couraça de Javali | `couraca_de_javali` | `IMPLEMENTED` | idem |
| `ITEM_ARM_004` | Placa Rochosa | `placa_rochosa` | `IMPLEMENTED` | idem |
| `ITEM_ARM_005` | Armadura do Guardião | `armadura_do_guardiao` | `IMPLEMENTED` | idem |
| `ITEM_ARM_006` | Couraça de Casca Musgosa | — | `DESIGN` | [Overview do Capítulo 1](04_content/chapters/chapter_01/OVERVIEW.md) |
| `ITEM_ARM_007` | Jaqueta do Rastro Longo | — | `DESIGN` | idem |
| `ITEM_ARM_008` | Manto de Micélio Trançado | — | `DESIGN` | idem |
| `ITEM_ARM_009` | Peitoral do Vigia Caído | — | `DESIGN` | idem |
| `ITEM_ARM_010` | Capa da Névoa Verde | — | `DESIGN` | idem |
| `ITEM_REL_001` | Pedra Polida | `pedra_polida` | `IMPLEMENTED` | [Catálogo/runtime e design](04_content/items/INDEX.md) |
| `ITEM_REL_002` | Semente Vital | `semente_vital` | `IMPLEMENTED` | idem |
| `ITEM_REL_003` | Colar de Espíritos | `colar_de_espiritos` | `IMPLEMENTED` | idem |
| `ITEM_REL_004` | Amuleto do Cervo | `amuleto_do_cervo` | `IMPLEMENTED` | idem |
| `ITEM_REL_005` | Coração da Floresta | `coracao_da_floresta` | `IMPLEMENTED` | idem |
| `ITEM_REL_006` | Nó dos Marcos Antigos | — | `DESIGN` | [Overview do Capítulo 1](04_content/chapters/chapter_01/OVERVIEW.md) |
| `ITEM_REL_007` | Presa da Matilha | — | `DESIGN` | idem |
| `ITEM_REL_008` | Semente do Veio Vivo | — | `DESIGN` | idem |
| `ITEM_REL_009` | Broche do Eco Claro | — | `DESIGN` | idem |
| `ITEM_REL_010` | Dente de Basalto | — | `DESIGN` | idem |

## Inimigos e chefes

| ID | Nome | Tipo | ID runtime | Status | Fonte |
| --- | --- | --- | --- | --- | --- |
| `ENEMY_LUM_001` | Geleia de Lúmen | Comum | `geleia_de_lumen` | `IMPLEMENTED` | [Inimigos](04_content/enemies/INDEX.md) |
| `ENEMY_LUM_002` | Gremlin de Folha | Comum | `gremlin_de_folha` | `IMPLEMENTED` | idem |
| `ENEMY_LUM_003` | Javali de Musgo | Comum | `javali_de_musgo` | `IMPLEMENTED` | idem |
| `ENEMY_LUM_004` | Espírito de Raiz | Comum | `espirito_de_raiz` | `IMPLEMENTED` | idem |
| `ENEMY_LUM_005` | Saqueador da Mata | Comum | `saqueador_da_mata` | `IMPLEMENTED` | [Dados e cenas](04_content/enemies/INDEX.md) |
| `ENEMY_LUM_006` | Xamã de Esporos | Comum | `xama_de_esporos` | `IMPLEMENTED` | idem |
| `ENEMY_LUM_007` | Sentinela de Raízes | Comum | `sentinela_de_raizes` | `IMPLEMENTED` | idem |
| `ENEMY_LUM_008` | Lobo de Sombra | Comum | `lobo_de_sombra` | `IMPLEMENTED` | idem |
| `ENEMY_LUM_009` | Lobo Alfa de Lúmen | Elite | `lobo_alfa_de_lumen` | `IMPLEMENTED` | [Inimigos](04_content/enemies/INDEX.md) |
| `BOSS_LUM_001` | Guardião-Cervo de Pedra | Boss | `guardiao_cervo_de_pedra` | `IMPLEMENTED` | idem |
| `BOSS_LUM_002` | Matriarca do Micélio | Minichefe | `matriarca_do_micelio` | `IMPLEMENTED` | [Dados, cena e design de encontro](04_content/enemies/INDEX.md) |

## Capítulo 1 e subfases

| ID | Nome | Subfase da macrofase runtime | Status | Fonte |
| --- | --- | --- | --- | --- |
| `CHAPTER_01` | Bosque de Lúmen | — | `DESIGN` | [Overview](04_content/chapters/chapter_01/OVERVIEW.md) |
| `STAGE_01_01` | Trilha dos Marcos Apagados | 1 — Entrada do Bosque | `DESIGN` | [Estrutura proposta](04_content/chapters/chapter_01/OVERVIEW.md) |
| `STAGE_01_02` | Posto de Vigia Tomado | 1 — Entrada do Bosque | `DESIGN` | idem |
| `STAGE_01_03` | Clareira Micelial | 2 — Clareira da Pressão | `DESIGN` | idem |
| `STAGE_01_04` | Ravina do Musgo | 2 — Clareira da Pressão | `DESIGN` | idem |
| `STAGE_01_05` | Galeria de Raízes | 3 — Ninho Silvestre | `DESIGN` | idem |
| `STAGE_01_06` | Câmara do Micélio | 3 — Ninho Silvestre | `DESIGN` | idem |
| `STAGE_01_07` | Trilha da Matilha | 4 — Covil do Alfa | `DESIGN` | idem |
| `STAGE_01_08` | Pedra da Matilha | 4 — Covil do Alfa | `DESIGN` | idem |
| `STAGE_01_09` | Pátio das Raízes | 5 — Santuário do Guardião | `DESIGN` | idem |
| `STAGE_01_10` | Coração do Santuário | 5 — Santuário do Guardião | `DESIGN` | idem |

Não há IDs individuais de Eco registrados ainda. Registrar somente quando existirem entidades nomeadas e seus documentos de design; não reservar ou reutilizar números por contagem-alvo.

## Árvore dos Ecos

Os IDs de nó abaixo identificam o catálogo de design e ainda não existem como IDs runtime.

| Ramo | IDs reservados e detalhe | Estado |
| --- | --- | --- |
| Vigília | `TREE_VIG_001`–`TREE_VIG_006` · [catálogo e dependências](03_systems/GLOBAL_RESONANCE_TREE.md) | `APPROVED` para design |
| Formação | `TREE_FOR_001`–`TREE_FOR_005` · idem | `APPROVED` para design |
| Fortuna | `TREE_FRT_001`–`TREE_FRT_004` · idem | `APPROVED` para design |
| Oficina | `TREE_OFI_001`–`TREE_OFI_005` · idem | `APPROVED` para design |
| Alquimia | `TREE_ALQ_001`–`TREE_ALQ_004` · idem | `APPROVED` para design |
| Jornada | `TREE_JOR_001`–`TREE_JOR_003` · idem | `APPROVED` para design |
| Memória | `TREE_MEM_001`–`TREE_MEM_003` · idem | `APPROVED` para design |
