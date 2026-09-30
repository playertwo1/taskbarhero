---
id: SLICE_1_SCOPE
status: DESIGN
certainty: HIPOTESE
---

# SLICE-1 — recorte do slice (SLICE-0)

**Status:** `DESIGN`; os recortes abaixo foram escolhidos por Rafael em 2026-09-29 e são **DECIDIDO** como escopo. Números, gatilhos e duração são **HIPÓTESE** ou **EM ABERTO** e não são dados runtime.

Este arquivo é a única fonte do **recorte**: diz *o que* do que já está aprovado entra no `SLICE-1`. Ele não copia stats, loot, kits ou fórmulas; cada linha aponta para a fonte que mantém o fato. Consumidores: [BALANCE-FOUNDATION-1](../../../06_balance/COMBAT_BALANCE_STANDARD.md) e `SLICE-1` (1A–1E) do [ROADMAP](../../../../ROADMAP.md).

Fluxo alvo: `Hub → party → build → expedição → combate → escolha → evento → elite → mini-boss → boss → retorno → Árvore/Ferreiro → evolução do Hub`.

## 1. Trio, skills, passivas e Traits

**DECIDIDO:** party Bastião, Flecha e Íris, com **4 skills por herói** em **2 builds**. Cada herói equipa 2 skills; sem Signature no slice (o [Sistema de skills](../../../03_systems/SKILL_SYSTEM.md) só a torna elegível no T6).

**DECIDIDO (regra local do slice):** o slice entrega cada build como **loadout fixo, sem gate de nível**: passiva de identidade, dois nós iniciais da build e o Trait dela. A tabela de tiers do [HERO_STANDARD](../../../../HERO_STANDARD.md) (seção 7) e o desbloqueio por marcos do Sistema de skills continuam vigentes e só são aplicados no `BALANCE-1`. O segundo slot de skill (`TREE_FOR_001`) e o slot de Echo são liberados por essa mesma regra local.

| Herói | Build | Skills equipadas | Passivas | Trait | Fonte |
| --- | --- | --- | --- | --- | --- |
| **Bastião** | Guardião | Muralha Viva (`SKILL_BAS_006`) + Fortaleza (`SKILL_BAS_009`) | Inabalável (identidade), A1 Ombro a Ombro, A2 Escudo Compartilhado | Voto do Escudo | [Golden Reference](../../../02_heroes/BASTIAO_GOLDEN_REFERENCE.md) · [passivas](../../../02_heroes/hero_001_bastiao_passives.md) · [Traits](../../../02_heroes/hero_001_bastiao_traits.md) |
| **Bastião** | Retaliação | Contra-Golpe (`SKILL_BAS_007`) + Desafio (`SKILL_BAS_008`) | Inabalável, B1 Peso do Escudo, B2 Momento | Ferro Responde | idem |
| **Flecha** | Crítico (Precisão) | Olho Aguçado (`SKILL_FLE_008`) + Flecha Perfurante (`SKILL_FLE_007`) | Instinto de Caçadora (identidade), A1 Respiração Controlada, A2 Ponta de Penetração | Ponto de Mira | [skills](../../skills/FLECHA_SKILLS.md) · [passivas](../../../02_heroes/hero_002_flecha_passives.md) · [Traits](../../../02_heroes/hero_002_flecha_traits.md) |
| **Flecha** | Marca (Caçada) | Marca do Caçador (`SKILL_FLE_006`) + Rajada (`SKILL_FLE_009`) | Instinto de Caçadora, B1 Rastro Aberto, B2 Pressão Coordenada | Caçada Coordenada | idem |
| **Íris** | Arcano | Lança de Lúmen (`SKILL_IRI_001`) + Prisma de Retorno (`SKILL_IRI_005`) | Sensível ao Lúmen (identidade), A1 Foco do Cristal, A2 Dispersão de Choque | Feixe Tecido | [kit mínimo do slice](../../../02_heroes/hero_003_iris_slice_kit.md) |
| **Íris** | Controle | Fratura Arcana (`SKILL_IRI_003`) + Véu de Micélio (`SKILL_IRI_002`) | Sensível ao Lúmen, B1 Rede de Micélio, B2 Fissura Persistente | Contenção Arcana | idem |

Fora do slice: Impacto de Escudo e Último Bastião; Ricochete, Chuva de Flechas e a build Velocidade da Flecha; Pulso Restaurador e a build Lúmen da Íris; nós A3–A5, B3–B5 e todas as passivas C.

**Regras compartilhadas de Bastião no slice**

- **Perfect Block por prontidão com recarga — HIPÓTESE.** Bastião mantém um estado *Guarda pronta* que recarrega com o tempo. O primeiro ataque que o atinge com o estado pronto é Perfect Block e consome a prontidão. É determinístico (sem RNG e sem comando do jogador), como exige o [Golden Reference](../../../02_heroes/BASTIAO_GOLDEN_REFERENCE.md) para o combate automático. **EM ABERTO:** intervalo de recarga e efeito de passivas sobre ele; dono: BALANCE-FOUNDATION-1.
- **Guarda, Desequilíbrio/Stagger e Marca** entram no pipeline compartilhado conforme o BALANCE-FOUNDATION-1.
- O bloqueio de Contra-Golpe usa a mesma regra de prontidão; a variante *Perfect Block* do Contra-Golpe depende dela.

## 2. Expedição — 10 encontros, 23 derrotas

**DECIDIDO:** expedição média, com formações já existentes em [encounter_plan.json](encounter_plan.json). Custos são a soma de `encounter_cost` do [catálogo v0.4](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json) e ficam dentro dos limites locais de [ENCOUNTERS.md](ENCOUNTERS.md).

| # | ID do plano | Encontro | Tipo | Fase macro runtime | Custo |
| --- | --- | --- | --- | --- | --- |
| 1 | `C1_1_1_A` | Primeira luz | Comum | 1 | 2,0 |
| 2 | `C1_1_2_A` | Vigia da trilha | Comum | 1 | 2,0 |
| 3 | `C1_1_2_B` | Sinalizador tomado | Comum | 1 | 3,25 |
| 4 | `C1_2_1_A` | Raiz e emboscada | Comum | 2 | 2,55 |
| 5 | `C1_2_2_A` | Ravina do musgo | Comum | 2 | 2,7 |
| 6 | `C1_2_2_B` | Geleia Anciã | **Elite** | 2 | 4,5 |
| 7 | `C1_3_1_A` | Galeria de raízes | Comum | 3 | 2,8 |
| — | `EVENT_C1_001` | Poço de Lúmen (seção 4) | Evento | 3 | — |
| 8 | `C1_4_1_A` | Caçada cruzada | Comum | 4 | 2,5 |
| 9 | `C1_3_2_A` | Rainha das Geleias | **Mini-boss** | 3 | 9,0 |
| — | Reserva de Resíduo | Evento sem escolha | Evento | 3 | — |
| 10 | `C1_5_2_A` | Guardião-Cervo de Pedra | **Boss** | 5 | 21,0 |

- **Ordem local ao slice.** `C1_4_1_A` vem antes da Rainha, e a Reserva de Resíduo vem depois dela. O [encounter_plan.json](encounter_plan.json) continua sendo a proposta do capítulo completo e não foi alterado: a ordem do slice é uma decisão deste recorte.
- **Cobertura:** os 10 inimigos comuns, a Geleia Anciã, a Rainha e o Guardião (13 dos 17 registros canônicos). Ficam fora Javali Cicatrizado, Gremlin Espinhento, Javali da Ponte e O Espinheiro.
- **Guardião-Cervo:** fases e critério de dificuldade em [ENCOUNTERS.md](ENCOUNTERS.md); o add da fase 2 é a Geleia de Lúmen.
- **Reserva de Resíduo:** recompensa única do plano (`optional_blacksmith_event`); no slice fica depois do `C1_3_2_A`, e não depois do `MB_C1_003`.

## 3. Equipamentos, raridades e Ferreiro

**DECIDIDO:** os **6 slots** do HERO_STANDARD entram no slice. O runtime atual só tem 3 tipos (`weapon`, `armor`, `amulet`) e 4 raridades; a migração de slots e raridades acontece no `SLICE-1A`, apenas para o subconjunto abaixo.

| Slot | Itens do slice |
| --- | --- |
| Arma | `ITEM_W_001` Galho de Vigília (espada de Bastião, Comum), `ITEM_W_002` Arco de Folha Tensa (Flecha, Incomum), `ITEM_W_003` Presa do Javali de Musgo (espada de Bastião, Raro), `ITEM_W_006` Cajado Prismático (Íris, Comum–Épico) |
| Secundário | `ITEM_S_001` Broquel de Casca (escudo de Bastião, Comum–Épico), `ITEM_S_002` Lanterna de Esporos (Íris, Incomum), `ITEM_S_003` Totem da Raiz Antiga (compartilhável, Raro), `ITEM_S_004` Farol Prismático (Íris, Épico), `ITEM_S_006` Aljava da Trilha (Flecha, Comum–Épico), `ITEM_S_007` Foco de Micélio (Íris, Comum–Épico) |
| Armadura | `ITEM_A_001` Manto de Folhas (Comum), `ITEM_A_002` Couraça de Musgo (Incomum), `ITEM_A_003` Casco Cristalino (Raro), `ITEM_A_004` Coração de Pedra (Épico), `ITEM_A_005` Casca do Guardião (Relíquia) |
| Acessório I / II | `ITEM_R_001` Gota de Lúmen (Comum), `ITEM_R_004` Olho de Vidro Verde (Raro), `ITEM_R_005` Fragmento Prismático (Raro) |
| Echo | *A Sentinela que Ficou* (seção 5); sem ID v0.4 |

São **18 templates** de equipamento no recorte (fora o Echo), incluindo os novos cajado, aljava e foco e o broquel agora necessário ao Bastião. Nomes, slot, identidade e compatibilidade vêm do [catálogo de itens v0.4 adaptado](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md). A integração desses quatro secundários/arma adicionais em `/data`, loot e testes permanece trabalho de `SLICE-1A`; esta alteração documental não declara implementação.

- **Raridades:** Comum, Incomum, Raro nos drops normais; Épico como pool do equipamento garantido no primeiro clear do boss (`FIRST_CLEAR`, `minimum_rarity: EPIC`); Relíquia (Casca do Guardião) como drop do boss. **EM ABERTO:** as tabelas `RARITY_C1_*` v0.4 permitem Épico em outros drops, então a renormalização para o recorte fica para o BALANCE-FOUNDATION-1.
- **Ferreiro:** desmontagem e Reforço +1 em Arma, Secundário e Armadura. Custo e definição do Reforço em [ENCOUNTERS.md](ENCOUNTERS.md) e no [modelo econômico](../../../06_balance/ECONOMY_MODEL.md).
- **Resíduo de Lúmen — HIPÓTESE:** o mínimo garantido antes do boss é 5 (elite 1–2, Rainha 2–4, Reserva 2), igual a um Reforço +1 (5 Resíduos), sem contar as Geleias comuns (65%). Melhoria opcional; não é requisito para vencer.
- **Fora do slice:** Épico em drops não garantidos, Memória (`ITEM_E_005`) e Echos do catálogo v0.4 (`ITEM_E_001`, `ITEM_E_002`, `ITEM_E_003`, `ITEM_E_004`). **EM ABERTO:** a Memória do Guardião é `FIRST_CLEAR` determinística no v0.4; fica desativada no slice enquanto o único Echo for *A Sentinela que Ficou*.
- **Drops da Geleia Anciã e da Rainha:** a chance de Echo (`ITEM_E_001`) fica desativada no recorte. O [Sistema de Ecos](../../../03_systems/ECHO_SYSTEM.md) só admite recompensa determinística no slice.

## 4. Evento de expedição com escolha — Poço de Lúmen

**DECIDIDO:** `EVENT_C1_001`, candidato registrado em [DESIGN_SEEDS](DESIGN_SEEDS.md). Posição proposta: depois do encontro 7 e antes do 8, para que a escolha pese sobre o encontro 8 e a Rainha (**HIPÓTESE**).

- **Escolha:** recuperar HP da party **ou** sacrificar HP/recurso por uma recompensa mais rara.
- **EM ABERTO:** valores de cura e sacrifício, e a recompensa mais rara. Restrições: sair do catálogo de itens/materiais deste recorte, não ser necessária para vencer o boss e não somar Resíduo além do orçamento sem nova simulação do ECON-1. Dono: BALANCE-FOUNDATION-1 e `SLICE-1B`.
- Medida no `SLICE-1E`: frequência de cada escolha, efeito sobre a taxa de vitória na primeira tentativa e sobre o TTK.

## 5. Echo opcional — A Sentinela que Ficou

**DECIDIDO:** é o único Echo do slice ([Sistema de Ecos](../../../03_systems/ECHO_SYSTEM.md)). Modifica **Muralha Viva** para também proteger o aliado com menor HP mesmo ligeiramente fora da área ([Golden Reference](../../../02_heroes/BASTIAO_GOLDEN_REFERENCE.md), seção do Echo). Ocupa o slot Echo dedicado, não é necessário para vencer e só é equipado ou trocado no Hub.

- **Entrega (DECIDIDO):** recompensa determinística na **primeira vitória sobre a Geleia Anciã** (encontro 6), para poder ser equipada no Hub e usada contra a Rainha e o boss.
- **Sem ID registrado.** O [registro](../../../CONTENT_REGISTRY.md) só reserva ID de Echo depois da ficha, que fica para o `ECHO-1`.
- **Direção escolhida para o protótipo (Rafael, 2026-09-29; HIPÓTESE até playtest):** para a formação padrão de três heróis, o Echo também pode proteger Bastião quando ele tiver a menor porcentagem de HP da party; empate segue a ordem da formação. Preserva os valores e a duração de Muralha Viva e não cria regra de alcance. A interpretação inclui o próprio portador como alvo elegível. Validar a interação em jogo; ver [recomendações SLICE-1D](../../../05_hub/SLICE_1D_RECOMMENDATIONS.md). O ID continua sem registro.

## 6. Árvore dos Ecos — ramo da Oficina, 6 nós

**DECIDIDO:** somente os nós abaixo entram. Catálogo, dependências e custos relativos em [GLOBAL_RESONANCE_TREE](../../../03_systems/GLOBAL_RESONANCE_TREE.md).

| Nó | Função no slice | Custo relativo |
| --- | --- | --- |
| `TREE_VIG_001` | Semente da Vigília (raiz, gratuita) | Grátis |
| `TREE_VIG_002` | Pulso Vital | Baixo |
| `TREE_VIG_005` | Ressonância Estável (keystone, abre os outros ramos) | Keystone |
| `TREE_OFI_001` | Forja Reerguida (Ferreiro no Refúgio) | Médio |
| `TREE_OFI_002` | Desmontagem Protegida | Baixo |
| `TREE_OFI_003` | Aprimoramento Controlado (Reforço +1) | Médio |

- **Diferidos e documentados:** `TREE_FOR_001` (2º slot de skill), `TREE_MEM_001` e `TREE_MEM_002` (equipar Echo). No slice esses dois acessos vêm da regra local da seção 1.
- **EM ABERTO:** quantos Fragmentos de Ressonância a expedição rende e se o keystone é alcançável numa expedição. Não há valor definido para o slice; medir no `SLICE-1E` e decidir custo/fonte no BALANCE-FOUNDATION-1. Se não for alcançável, é um bloqueio do gate de progressão, não um ajuste de texto.

## 7. Refúgio depois do boss

**DECIDIDO:** uma camada visual na **Lanterna-Mãe** (Lúmen verde e um toque de vegetação na praça) depois do primeiro clear do Guardião. O **Fragmento do Coração Verde** (`MAT_C1_HEART_FRAGMENT`, `FIRST_CLEAR`) tem efeito **narrativo e visual, sem efeito numérico** no slice; o efeito mecânico é **EM ABERTO**. Não entram novo estágio da Árvore nem nova região no mapa. Direção visual em [HUB_VISUAL_DIRECTION](../../../05_hub/HUB_VISUAL_DIRECTION.md).

## 8. IDs e aliases

Registro central: [CONTENT_REGISTRY](../../../CONTENT_REGISTRY.md). Aliases de inimigos vivem na [ponte legada](../../LEGACY_RUNTIME_CATALOG.md).

| Entidade | ID v0.4 | ID runtime atual (alias) |
| --- | --- | --- |
| Geleia de Lúmen | `EN_C1_001` | `geleia_de_lumen` |
| Espírito de Raiz | `EN_C1_002` | `espirito_de_raiz` |
| Gremlin de Folhas | `EN_C1_003` | `gremlin_de_folha` |
| Javali de Musgo | `EN_C1_004` | `javali_de_musgo` |
| Guardião-Cervo de Pedra | `BOSS_C1_001` | `guardiao_cervo_de_pedra` |
| Mariposa Luminosa, Cogumelo Sonolento, Trepa-Cadáver, Caracol Cristalino, Raposa Oca, Sapinho do Lúmen | `EN_C1_005` a `EN_C1_010` | **nenhum** (entidades novas) |
| Geleia Anciã | `EL_C1_001` | **nenhum** |
| Rainha das Geleias | `MB_C1_001` | **nenhum** |
| Os 14 itens da seção 3 | `ITEM_*` | **nenhum** (catálogo legado sem equivalência de identidade) |

- **DECIDIDO (Rafael, 2026-09-29):** o conteúdo legado é **removido** de `/data`, do código e dos testes no `1A-CUT`, inclusive os IDs não usados (`saqueador_da_mata`, `xama_de_esporos` e os demais). Até o corte ele coexiste e a suíte segue verde. O alias (`legacy_alias`) serve para reaproveitar nome e sprite, não mantém o registro legado vivo.
- **Skills:** `SKILL_BAS_006` a `011` (Golden Reference) substituem `SKILL_BAS_001` a `005`, que passam a `DEPRECATED`; `SKILL_IRI_001`, `002`, `003` e `005` são mantidos; `SKILL_FLE_006` a `010` já estão registrados.
- **Passivas e Traits do slice:** convenção `PASS_<herói>_###` e `TRAIT_<herói>_###`. Só os nós novos da Íris recebem ID (`PASS_IRI_001` a `005`, `TRAIT_IRI_001` e `002`, no [kit](../../../02_heroes/hero_003_iris_slice_kit.md)). Os nós de Bastião e Flecha continuam referenciados pelo nome nas suas fichas, sem ID inventado aqui.
- **Evento:** `EVENT_C1_001`. **Echo:** sem ID.

## 9. Inventário de arte do recorte

Contratos e regras em [MVP_SPRITE_INVENTORY](../../../art/MVP_SPRITE_INVENTORY.md), [Golden](../../../art/golden/README.md) e [conceitos](../../../art/conceitos/README.md). Assets novos seguem contrato, QA técnico e auditoria visual independente.

| Categoria | Já utilizável (folha `v002`/PASS) | Precisa de contrato novo |
| --- | --- | --- |
| Heróis | Bastião, Flecha, Íris | — |
| Inimigos | Geleia, Espírito de Raiz, Gremlin, Javali de Musgo, Guardião-Cervo | **8:** Sapinho, Mariposa, Cogumelo, Trepa-Cadáver, Caracol, Raposa Oca, Geleia Anciã, Rainha das Geleias (todos com [ficha de conceito](../../../art/conceitos/README.md)) |
| Ícones de itens | nenhum (os 30 existentes são dos itens legados ou candidatos com outros nomes) | **14** |
| Ícones de skills | Íris: Lança de Lúmen, Véu de Micélio, Fratura Arcana, Prisma de Retorno | **8:** as 4 de Bastião e as 4 de Flecha (os ícones atuais são dos conceitos antigos) |
| Efeitos | nenhum (`assets/sprites/effects/` está vazio) | efeitos das skills, feedback de Perfect Block, cena do Poço de Lúmen |
| Ambiente | Bosque de Lúmen (4 camadas), ícones de fase, santuário do Guardião | camada da Lanterna-Mãe no Refúgio |

- **DECIDIDO:** os 8 ícones de skills de Bastião e Flecha ganham contrato novo; nenhum ícone de conceito `DEPRECATED` é reaproveitado por semelhança.
- **DECIDIDO:** o primeiro asset novo a passar pelo gate de arte é a **Geleia Anciã**; os demais 7 inimigos, a Rainha e os ícones só começam depois do PASS dele.
- Geleia Anciã e Rainha não herdam a folha da Geleia por recolor; qualquer reaproveitamento precisa de decisão de Rafael no contrato.

## 10. Fora do slice e pendências

- **Fora:** árvore completa (~84 nós), os outros 5 heróis, artesãos em nível máximo, crafting profundo, affixes aleatórios/reforja, campanhas pessoais, Mastery em runtime, Signature, nova região no mapa.
- **EM ABERTO (donos):** Perfect Block (intervalo), renormalização de raridade, Poço de Lúmen (valores e recompensa), Fragmentos de Ressonância (fonte e custo), Echo para quem joga Retaliação, Memória do Guardião. Cada um está registrado na seção correspondente.
- **Pendente do roadmap:** [overview do Capítulo 1](OVERVIEW.md) ao padrão de 6 skills (Bastião e Íris atualizados junto com este recorte; os demais heróis ficam para HERO-1).

## 11. Rastreio contra o gate do SLICE-0

| Item do roadmap | Onde |
| --- | --- |
| Trio, skills, passivas e Traits, 2+ builds | seção 1 |
| Equipamentos e raridades | seção 3 |
| Inimigos, elite, mini-boss e Guardião | seção 2 |
| 1 evento com escolha real | seção 4 |
| 1 Echo funcional opcional | seção 5 |
| Árvore e Ferreiro | seções 3 e 6 |
| Refúgio depois do boss | seção 7 |
| IDs v0.4 e aliases | seção 8 |
| Inventário de arte | seção 9 |
| Overview ao padrão de 6 skills | seção 10 |

O gate só é dado como PASS depois da revisão de Rafael deste arquivo; os checkboxes do [ROADMAP](../../../../ROADMAP.md) não foram marcados.
