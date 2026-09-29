---
status: DESIGN
certainty: HIPOTESE
---

# HERO_003 — Íris: kit mínimo do SLICE-1

**Herói:** [HERO_003 — Íris](hero_003_iris.md)
**Escopo:** só o que o [recorte do slice](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) usa: 4 skills em 2 builds, passiva de identidade, 2 nós iniciais por build e 1 Trait por build. O restante do padrão de [HERO_STANDARD](../../HERO_STANDARD.md) (16 passivas, 3 Traits, Mastery 1–10, 5 missões, 6ª skill/Signature) **não** está definido aqui e continua pendente para HERO-1.

**Origem:** as skills vêm dos conceitos já catalogados no [overview do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) e no [registro](../CONTENT_REGISTRY.md); as builds Arcano e Controle vêm da matriz do roster do HERO_STANDARD. As passivas e Traits abaixo são **conteúdo novo** de design, escritos em 2026-09-29, sem números. Valores, gatilhos, cooldowns e alvos são **EM ABERTO** (dono: BALANCE-FOUNDATION-1).

**Regra local do slice:** o kit é um loadout fixo, sem gate de nível ([SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md), seção 1). Cada herói equipa 2 skills; o [Sistema de skills](../03_systems/SKILL_SYSTEM.md) mantém gatilho simples e alvo automático.

## Skills e builds

| Build | Skill 1 | Skill 2 | Papel |
| --- | --- | --- | --- |
| **Arcano** | Lança de Lúmen (`SKILL_IRI_001`) | Prisma de Retorno (`SKILL_IRI_005`) | Dano concentrado em sequência sobre alvo marcado ou exposto. |
| **Controle** | Fratura Arcana (`SKILL_IRI_003`) | Véu de Micélio (`SKILL_IRI_002`) | Abrir a defesa de inimigos protegidos e sustentar a party. |

Descrições de intenção em [OVERVIEW.md](../04_content/chapters/chapter_01/OVERVIEW.md). Pulso Restaurador (`SKILL_IRI_004`) e a build Lúmen ficam fora do slice. O atordoamento/congelamento citado na ficha da Íris não ganhou skill própria: fica concentrado no Trait Contenção Arcana.

## Passiva de identidade — Sensível ao Lúmen

`PASS_IRI_001`. A Íris reconhece alvos **marcados** (Marca do Caçador, Flecha) ou **expostos** (Desequilíbrio, Bastião), e seus feixes ficam mais consistentes contra eles. Liga a Íris às outras duas heroínas do trio sem criar recurso ou segundo sistema de stacks. Bônus exato: **EM ABERTO**.

## Build Arcano

| ID | Nó | Efeito de design |
| --- | --- | --- |
| `PASS_IRI_002` | A1 — Foco do Cristal | Ataques básicos contra o alvo da última Lança de Lúmen ganham consistência. Recompensa foco. |
| `PASS_IRI_003` | A2 — Dispersão de Choque | A Lança de Lúmen também atinge, com dano reduzido, inimigos adjacentes ao alvo. |
| `TRAIT_IRI_001` | **Trait — Feixe Tecido** | O disparo liberado pelo Prisma de Retorno passa a ser em área ao redor do alvo, **sem aumentar o dano no alvo principal**. |

**Trait — Feixe Tecido.** Muda a regra do Prisma de Retorno (de alvo único para área). Trade-off: perde valor contra um único alvo importante. Não cria segunda liberação, não acumula e não troca o alvo marcado.

## Build Controle

| ID | Nó | Efeito de design |
| --- | --- | --- |
| `PASS_IRI_004` | B1 — Rede de Micélio | Inimigos atingidos pela Fratura Arcana ficam mais lentos por pouco tempo. |
| `PASS_IRI_005` | B2 — Fissura Persistente | A fratura dura mais enquanto o alvo estiver sob outro efeito da party (Marca ou Desequilíbrio), com teto definido no balanceamento. |
| `TRAIT_IRI_002` | **Trait — Contenção Arcana** | A Fratura Arcana em um alvo já marcado ou Desequilibrado o contém por um instante (atordoamento curto), com limite por alvo e efeito reduzido contra elites, mini-bosses e boss. |

**Trait — Contenção Arcana.** Muda a regra da Fratura Arcana (de enfraquecimento para enfraquecimento com contenção condicional). Trade-off: depende de Flecha ou Bastião terem preparado o alvo. Sem acúmulo de contenção e sem substituir a Tenacidade do inimigo. O Trait **não** cria imunidade a controle nem contém o boss sem limite.

## Sinergias com o trio

- Marca (Flecha) e Desequilíbrio (Bastião) alimentam Sensível ao Lúmen, Lança de Lúmen e Contenção Arcana.
- Fratura Arcana enfraquece proteção de alvos que a Flecha Perfurante (build Crítico) já sabe atravessar.
- Prisma de Retorno depende de alvo marcado; a build Arcano combina naturalmente com a build Marca da Flecha.

## Pendências e limites

- **EM ABERTO:** todos os números, cooldowns e gatilhos; tabela de Tenacidade/imunidade de elites, mini-bosses e boss; valor exato de "consistência", lentidão e atordoamento curto.
- **EM ABERTO:** nós A3–A5, B3–B5 e as passivas C; Trait Lúmen; Mastery e missões pessoais.
- **HIPÓTESE:** que dois nós iniciais por build bastem para a identidade de cada build. Validar no `SLICE-1E`.
- Nada aqui autoriza implementação: o [registro](../CONTENT_REGISTRY.md) trata as skills como `DESIGN` e o runtime não tem `data/skills/`.
