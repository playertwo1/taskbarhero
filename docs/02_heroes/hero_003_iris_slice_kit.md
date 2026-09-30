---
status: DESIGN
certainty: HIPOTESE
---

# HERO_003 — Íris: kit do SLICE-1 (completo)

**Herói:** [HERO_003 — Íris](hero_003_iris.md)
**Escopo (atualizado em 2026-09-30, decisão de Rafael):** o kit completo do padrão de [HERO_STANDARD](HERO_STANDARD.md) para o slice: 5 skills normais (`SKILL_IRI_001`–`005`, com o Pulso Restaurador promovido ao recorte) + a Signature **Convergência de Lúmen** (`SKILL_IRI_006`) no **3º slot fixo**, 16 passivas (identidade + 3 builds de 5), 3 Traits e 3 builds. Mastery 1–10 e as 5 missões pessoais seguem pendentes. Todos os números são **HIPÓTESE** de simulação (Plano 03 dos kits completos).

**Origem:** as skills vêm dos conceitos já catalogados no [overview do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) e no [registro](../CONTENT_REGISTRY.md); as builds Arcano e Controle vêm da matriz do roster do HERO_STANDARD. As passivas e Traits abaixo são **conteúdo novo** de design, escritos em 2026-09-29, sem números. Valores, gatilhos, cooldowns e alvos são **EM ABERTO** (dono: BALANCE-FOUNDATION-1).

**Regra local do slice:** o kit é um loadout fixo, sem gate de nível ([SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md), seção 1). Cada herói equipa 2 skills da build **mais a Signature no 3º slot fixo**; o [Sistema de skills](../03_systems/SKILL_SYSTEM.md) mantém gatilho simples e alvo automático.

## Skills e builds

| Build | Skill 1 | Skill 2 | Papel |
| --- | --- | --- | --- |
| **Arcano** | Lança de Lúmen (`SKILL_IRI_001`) | Prisma de Retorno (`SKILL_IRI_005`) | Dano concentrado em sequência sobre alvo marcado ou exposto. |
| **Controle** | Fratura Arcana (`SKILL_IRI_003`) | Véu de Micélio (`SKILL_IRI_002`) | Abrir a defesa de inimigos protegidos e sustentar a party. |

Descrições de intenção em [OVERVIEW.md](../04_content/chapters/chapter_01/OVERVIEW.md). Pulso Restaurador (`SKILL_IRI_004`) e a build Lúmen ficam fora do slice. O atordoamento/congelamento citado na ficha da Íris não ganhou skill própria: fica concentrado no Trait Contenção Arcana.

## Skills do kit completo (HIPÓTESE)

| ID | Skill | Papel | Recarga | Observação |
| --- | --- | --- | --- | --- |
| `SKILL_IRI_001` | Lança de Lúmen | dano concentrado | 10 s | 1,55×ATK |
| `SKILL_IRI_005` | Prisma de Retorno | resposta ao alvo preparado | 14 s | 1,40×ATK |
| `SKILL_IRI_003` | Fratura Arcana | quebra de defesa | 15 s | −15% de DEF |
| `SKILL_IRI_002` | Véu de Micélio | escudo | 15 s | 20% do HP máximo |
| `SKILL_IRI_004` | Pulso Restaurador | cura (promovida ao recorte em 2026-09-30) | 16 s | 0,3×ATK |
| `SKILL_IRI_006` | **Convergência de Lúmen** (Signature, 3º slot) | salva em todos os inimigos | 30 s | 2,2×ATK no alvo prioritário e 1,0×ATK nos demais; +50% contra alvos preparados; R2 +stagger; R3 +8% de ATK para a equipe por 4 s |

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

## Nós A3–A5, B3–B5 e build Lúmen (HIPÓTESE, 2026-09-30)

`unlock_level` = nível da party em que a passiva passa a valer no slice.

| ID | Build | Nó | Efeito no slice | Nível |
| --- | --- | --- | --- | ---: |
| `PASS_IRI_006` | Arcano | A3 — Eco de Cristal | a Lança que acerta alvo preparado reduz 1 s da própria recarga | 4 |
| `PASS_IRI_007` | Arcano | A4 — Prisma Ressonante | Prisma de Retorno +15% com 2+ inimigos vivos | 7 |
| `PASS_IRI_008` | Arcano | A5 — Convergência Arcana (capstone) | depois do Prisma, a próxima Lança em 8 s causa +40% (uma vez) | 10 |
| `PASS_IRI_009` | Controle | B3 — Micélio Denso | Véu: +25% de escudo em aliado com HP ≤ 40% | 4 |
| `PASS_IRI_010` | Controle | B4 — Fratura Profunda | a Fratura também reduz o ATK do alvo em 10% pela duração | 7 |
| `PASS_IRI_011` | Controle | B5 — Teia Total (capstone) | a Fratura também reduz a DEF dos demais inimigos com 50% da força | 10 |
| `PASS_IRI_012` | Lúmen | C1 — Luz Constante | Pulso cura +10% | 1 |
| `PASS_IRI_013` | Lúmen | C2 — Pulso Duplo | o Pulso também cura o 2º aliado mais ferido com 50% do valor | 1 |
| `PASS_IRI_014` | Lúmen | C3 — Cristal de Cura | o excedente da cura vira escudo de 50% (máx. 10% do HP máximo, 6 s) | 4 |
| `PASS_IRI_015` | Lúmen | C4 — Lúmen Prolongado | o Véu dura +2 s | 7 |
| `PASS_IRI_016` | Lúmen | C5 — Fonte de Lúmen (capstone) | aliado abaixo de 25% de HP refaz o Pulso (1 vez a cada 30 s) | 10 |
| `TRAIT_IRI_003` | Lúmen | **Trait — Chama Viva** | cura e escudos da Íris dão +10% de ATK ao receptor por 4 s | 1 |

**Builds:** Arcano (Lança + Prisma), Controle (Fratura + Véu) e Lúmen (Pulso + Véu); a Signature é o 3º slot de todas.

## Sinergias com o trio

- Marca (Flecha) e Desequilíbrio (Bastião) alimentam Sensível ao Lúmen, Lança de Lúmen e Contenção Arcana.
- Fratura Arcana enfraquece proteção de alvos que a Flecha Perfurante (build Crítico) já sabe atravessar.
- Prisma de Retorno depende de alvo marcado; a build Arcano combina naturalmente com a build Marca da Flecha.

## Pendências e limites

- **EM ABERTO:** todos os números, cooldowns e gatilhos; tabela de Tenacidade/imunidade de elites, mini-bosses e boss; valor exato de "consistência", lentidão e atordoamento curto.
- **Resolvido em 2026-09-30 (HIPÓTESE):** nós A3–A5, B3–B5, passivas C, Trait Lúmen, Signature e promoção do Pulso. **EM ABERTO:** Mastery 1–10, missões pessoais e o bônus exato da identidade.
- **HIPÓTESE:** que dois nós iniciais por build bastem para a identidade de cada build. Validar no `SLICE-1E`.
- Nada aqui autoriza implementação: o [registro](../CONTENT_REGISTRY.md) trata as skills como `DESIGN` e o runtime não tem `data/skills/`.
