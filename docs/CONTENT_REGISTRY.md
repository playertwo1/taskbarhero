# Pocket Hero — registro central de conteúdo

Este registro é autoridade para IDs locais do jogo e aponta às fichas de detalhe. Para combate/loot, os IDs, nomes e registros da base canônica v0.4 têm como fonte única os arquivos listados no [índice canônico](../documents/canonical/INDEX.md); este registro não duplica esses catálogos. IDs já usados pelo runtime continuam sob autoridade dos arquivos em `data/` até migração.

**Status permitidos:** `CONCEPT`, `DESIGN`, `APPROVED`, `IMPLEMENTING`, `IMPLEMENTED`, `QA`, `PASS`, `DEPRECATED`. `HIPÓTESE` e `EM ABERTO` descrevem certeza de conteúdo, não são status de ciclo.

**Convenções locais:** `HERO_###`; `SKILL_<herói>_###`; `TREE_<ramo>_###`; `CHAPTER_##`; `STAGE_01_##`; `PASS_<herói>_###` e `TRAIT_<herói>_###` (passivas e Traits, registrados somente quando a ficha do nó existir; hoje só os da [Íris no slice](02_heroes/hero_003_iris_slice_kit.md)); `EVENT_C1_###` (eventos de expedição; hoje `EVENT_C1_001` Poço de Lúmen, ver o [recorte do slice](04_content/chapters/chapter_01/SLICE_1_SCOPE.md)). **Convenções canônicas v0.4:** `EN_C1_###`, `EL_C1_###`, `MB_C1_###`, `BOSS_C1_###`; `ITEM_W_###`, `ITEM_S_###`, `ITEM_A_###`, `ITEM_R_###`, `ITEM_E_###`; `MAT_C1_<NOME>`. IDs são persistentes: não reutilizar nem renumerar. Consulte [a ponte de compatibilidade runtime](04_content/LEGACY_RUNTIME_CATALOG.md) antes de qualquer migração.

## Contagem atual e fonte de detalhe

| Tipo | Catálogo registrado | Estado resumido | Fonte de detalhe/runtime |
| --- | --- | --- | --- |
| Heróis | 8 cenas Godot estão presentes; conclusão de design varia por herói. Presença de cena não significa conformidade completa ao padrão. | Runtime: `IMPLEMENTED`; design: ver ficha | [Heróis](02_heroes/INDEX.md) e [Padrão Canônico](../HERO_STANDARD.md) |
| Skills | 17 skills vigentes conceituadas para Bastião, Flecha e Íris: Bastião com as 6 do Golden Reference (5 normais e a Signature), Flecha com 6 (5 normais e a Signature) e Íris com 5 normais; os 5 conceitos anteriores do Bastião e os 5 da Flecha estão `DEPRECATED`. O roster completo requer 48; as outras 31 ainda não estão catalogadas. | `DESIGN` | [Skills](04_content/skills/INDEX.md) |
| Inimigos do Capítulo 1 | 17 canônicos: 10 normais, 3 elites, 3 minichefes e 1 boss; runtime atual contém 11 entidades legadas. | Design: `APPROVED`; runtime: em migração futura | [Catálogo canônico](../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) · [Aliases](04_content/LEGACY_RUNTIME_CATALOG.md) |
| Equipamentos do Capítulo 1 | 30 canônicos; runtime atual contém 15 registros legados. | Design: `APPROVED`; runtime: em migração futura | [Catálogo canônico](../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md) · [Aliases](04_content/LEGACY_RUNTIME_CATALOG.md) |
| Materiais do Capítulo 1 | 7 no catálogo canônico. | Design: `APPROVED`; uso/runtime conforme fases de economia | [Catálogo canônico](../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_MATERIAL_CATALOG.md) |
| Sistema de combate e loot | Regras e contratos da versão canônica v0.4. | Design: `APPROVED`; implementação: conferir runtime e roadmap | [Índice canônico](../documents/canonical/taskbar_sistema_v0.4/README.md) |
| Subfases | Dez propostas; o jogo runtime tem cinco fases macro. | `DESIGN` | [Capítulos](04_content/chapters/INDEX.md) |
| Ecos | Um Echo funcional opcional está planejado no design de `SLICE-1`; nenhum Eco tem ficha runtime ou implementação. | `CONCEPT` | [Sistema de Ecos](03_systems/ECHO_SYSTEM.md) · [Catálogo](04_content/echoes/INDEX.md) |
| Hub | Direção visual escolhida; especificação global de sistema ainda não aprovada. Há uma cena isolada de protótipo de UI, não integrada ao fluxo principal. | `CONCEPT` | [Hub](05_hub/INDEX.md) |

Não confundir catálogo canônico de design com conteúdo atualmente carregado. As diferenças e aliases permanecem no [manifesto de compatibilidade runtime](04_content/LEGACY_RUNTIME_CATALOG.md); não inferir equivalências.

## Heróis

[`HERO_STANDARD.md`](../HERO_STANDARD.md) é obrigatório para novos designs e expansões; são seis skills por herói, incluindo uma Signature. O [padrão compartilhado de balanceamento](06_balance/COMBAT_BALANCE_STANDARD.md) define a estrutura dos atributos. A tabela separa ciclo registrado na ficha da presença de cena; uma cena não comprova que o conteúdo do herói está completo em relação ao padrão.

| ID | Nome | Ciclo registrado na ficha | Cena Godot | Fonte de design |
| --- | --- | --- | --- | --- |
| `HERO_001` | Bastião | `DESIGN` | Presente | [Golden Reference](02_heroes/BASTIAO_GOLDEN_REFERENCE.md) · [ponteiro de compatibilidade](02_heroes/hero_001_bastiao.md) |
| `HERO_002` | Flecha | `DESIGN` | Presente; runtime MVP implementado | [Ficha](02_heroes/hero_002_flecha.md) |
| `HERO_003` | Íris | `IMPLEMENTED` | Presente | [Ficha](02_heroes/hero_003_iris.md) |
| `HERO_004` | Brasa | `APPROVED` | Presente | [Ficha](02_heroes/hero_004_brasa.md) |
| `HERO_005` | Véu | `APPROVED` | Presente | [Ficha](02_heroes/hero_005_veu.md) |
| `HERO_006` | Orvalho | `APPROVED` | Presente | [Ficha](02_heroes/hero_006_orvalho.md) |
| `HERO_007` | Forja | `APPROVED` | Presente | [Ficha](02_heroes/hero_007_forja.md) |
| `HERO_008` | Sino | `APPROVED` | Presente | [Ficha](02_heroes/hero_008_sino.md) |

## Skills

IDs e status são registrados aqui. O padrão de 48 skills (cinco normais e uma Signature por herói) vem de [HERO_STANDARD](../HERO_STANDARD.md). Não há skills runtime em `/data/skills/`; números, gatilhos e regras de runtime continuam em aberto.

| ID | Nome | Status | Fonte |
| --- | --- | --- | --- |
| `SKILL_BAS_001` | Amparo de Raiz (conceito anterior) | `DEPRECATED` | [Skills do Capítulo 1](04_content/chapters/chapter_01/OVERVIEW.md) |
| `SKILL_BAS_002` | Contra-golpe de Casca (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_BAS_003` | Desafio do Guardião (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_BAS_004` | Trama de Escudos (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_BAS_005` | Voto da Clareira (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_BAS_006` | Muralha Viva | `DESIGN` | [Golden Reference](02_heroes/BASTIAO_GOLDEN_REFERENCE.md) |
| `SKILL_BAS_007` | Contra-Golpe | `DESIGN` | idem |
| `SKILL_BAS_008` | Desafio | `DESIGN` | idem |
| `SKILL_BAS_009` | Fortaleza | `DESIGN` | idem |
| `SKILL_BAS_010` | Impacto de Escudo | `DESIGN` | idem |
| `SKILL_BAS_011` | Último Bastião (Signature) | `DESIGN` | idem |
| `SKILL_FLE_001` | Marca da Caçada (conceito anterior) | `DEPRECATED` | [Histórico](../arquivados/FLECHA_SKILLS_LEGADO.md) |
| `SKILL_FLE_002` | Tiro de Ruptura (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_FLE_003` | Rajada da Copa (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_FLE_004` | Flecha de Execução (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_FLE_005` | Passo do Rastro (conceito anterior) | `DEPRECATED` | idem |
| `SKILL_FLE_006` | Marca do Caçador | `DESIGN` | [Skills canônicas da Flecha](04_content/skills/FLECHA_SKILLS.md) |
| `SKILL_FLE_007` | Flecha Perfurante | `DESIGN` | idem |
| `SKILL_FLE_008` | Olho Aguçado | `DESIGN` | idem |
| `SKILL_FLE_009` | Rajada | `DESIGN` | idem |
| `SKILL_FLE_010` | Ricochete | `DESIGN` | idem |
| `SKILL_FLE_011` | Chuva de Flechas (Signature) | `DESIGN` | idem |
| `SKILL_IRI_001` | Lança de Lúmen | `DESIGN` | idem |
| `SKILL_IRI_002` | Véu de Micélio | `DESIGN` | idem |
| `SKILL_IRI_003` | Fratura Arcana | `DESIGN` | idem |
| `SKILL_IRI_004` | Pulso Restaurador | `DESIGN` | idem |
| `SKILL_IRI_005` | Prisma de Retorno | `DESIGN` | idem |

## Inimigos e chefes

Os IDs, nomes, ranks, arquétipos e registros de loot dos 17 inimigos do Capítulo 1 são definidos pelo [JSON canônico v0.4](../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json). O catálogo Markdown correspondente é uma visão resumida desse JSON. Todos têm status de ciclo `APPROVED` para design; implementação runtime ainda é legada. Consulte o [índice de inimigos](04_content/enemies/INDEX.md) e a [ponte de aliases](04_content/LEGACY_RUNTIME_CATALOG.md).

## Itens e materiais

O [catálogo canônico v0.4](../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md) é autoridade para os 30 itens do Capítulo 1; o [catálogo de materiais](../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_MATERIAL_CATALOG.md) é autoridade para os sete materiais. As regras de raridade e economia estão no [índice canônico](../documents/canonical/taskbar_sistema_v0.4/README.md). Os registros antigos presentes em runtime permanecem identificados na [ponte de compatibilidade](04_content/LEGACY_RUNTIME_CATALOG.md) até migração. Consulte também os índices de [itens](04_content/items/INDEX.md) e [balanceamento](06_balance/INDEX.md).

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
