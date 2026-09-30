---
document_type: balance-index
id: BALANCE_V1_INDEX
project: Pocket Hero
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
language: pt-BR
---

# Balanceamento global v1.0 — Pocket Hero

A **v1.0 é a única autoridade de design do balanceamento do jogo inteiro**: capítulos 1–10, dificuldades, heróis, skills, passivas, itens, raridades, affixes, craft, inimigos, chefes, economia, meta-progressão e medição. Ela substitui a base canônica v0.5, a origem v0.4 e os contratos antigos de `docs/06_balance/`, que foram absorvidos aqui e excluídos em 2026-09-30. O histórico está no git.

## Como ler (qualquer agente: Claude, ChatGPT, Antigravity/Gemini)

1. Comece pela [constituição](00_CONSTITUICAO.md). Ela define a curva-mestra, o orçamento de poder, o jogador de referência, os alvos e as linhas vermelhas. Todo o resto obedece a ela.
2. Abra **só** o domínio da tarefa (tabela abaixo). Cada arquivo é a autoridade do seu assunto; os outros apenas apontam para ele.
3. Valores que o jogo carrega estão em [`/data`](../../../data/). Quando um número aparece aqui e em `/data`, **`/data` vale para o runtime** e este texto registra a intenção. Divergência é achado a registrar.
4. Rótulos de certeza: **DECIDIDO** (Rafael decidiu, com data) · **RECOMENDADO** (proposta a aplicar salvo objeção) · **HIPÓTESE** (número a medir) · **EM ABERTO** (decisão de Rafael pendente; nunca invente). Toda decisão aberta está em [11_DECISOES_ABERTAS](11_DECISOES_ABERTAS.md).
5. Nenhum número daqui está "balanceado". Simulação do Argos não é playtest; os números viram `APPROVED` somente depois de playtest/telemetria (gate 5 em [10_TELEMETRIA_ARGOS](10_TELEMETRIA_ARGOS.md)).

## Mapa dos arquivos

| Arquivo | Autoridade sobre |
| --- | --- |
| [00_CONSTITUICAO](00_CONSTITUICAO.md) | Precedência, unidade 10×, curva-mestra, orçamento de poder, jogador de referência por capítulo, alvos globais, tempo, teto, linhas vermelhas, política de mudanças |
| [01_STATUS_E_COMBATE](01_STATUS_E_COMBATE.md) | Registro de status, pipeline de modificadores, fórmulas, caps, tipos de dano, buffs/debuffs, stagger, ameaça, recursos, invocações |
| [02_HEROIS](02_HEROIS.md) | Base e crescimento dos 8 heróis, papéis, fraquezas declaradas, envelope de poder, XP, catch-up, pontos de árvore, respec |
| [03_SKILLS_PASSIVAS](03_SKILLS_PASSIVAS.md) | Orçamento de skills, Signature, ranks, passivas, Traits, Mastery, IA de uso |
| [04_ITENS_RARIDADE](04_ITENS_RARIDADE.md) | BP, escada de nove raridades, Item Power, slots, famílias de status, Echo, Relíquia/Memória, relevância, exibição |
| [05_AFFIXES_CRAFT](05_AFFIXES_CRAFT.md) | Affixes, famílias e conflitos, procs, Reforço, reforja, desmontagem, papéis dos artesãos |
| [06_INIMIGOS_CHEFES](06_INIMIGOS_CHEFES.md) | Herói de referência, arquétipos, ranks, fator por capítulo, TTK, dano inimigo, encontros, elites, chefes, pressões por capítulo |
| [07_ECONOMIA_LOOT](07_ECONOMIA_LOOT.md) | Recursos, fontes e sinks, pipeline de drop, raridade por fonte, pity, Smart Loot, inventário, offline |
| [08_META](08_META.md) | Árvore dos Ecos, Hub, artesãos como progressão de conta, custos em Fragmentos |
| [09_DIFICULDADE_ENDGAME](09_DIFICULDADE_ENDGAME.md) | Camadas de dificuldade D1–D3, raridades 5–9, teto por camada, Mastery no endgame |
| [10_TELEMETRIA_ARGOS](10_TELEMETRIA_ARGOS.md) | Arquitetura runtime do balanceamento, métricas, regra → métrica, Argos, gates, variância |
| [11_DECISOES_ABERTAS](11_DECISOES_ABERTAS.md) | Tudo que depende de Rafael, com opções e recomendação |
| [capitulos/CAPITULO_01](capitulos/CAPITULO_01.md) | Perfil local do Capítulo 1: metas, níveis, escalas, regras do slice, resultados medidos e histórico |
| [specs/ENEMY_CANONICAL_SCHEMA](specs/ENEMY_CANONICAL_SCHEMA.md) | Schema de dados de inimigo com loot (anexo técnico) |
| [specs/DROP_RESOLVER_SPEC](specs/DROP_RESOLVER_SPEC.md) | Algoritmo determinístico do resolvedor de drops (anexo técnico) |

Conteúdo específico do Capítulo 1 (JSON canônico dos 17 inimigos, catálogos de inimigos, itens e materiais, tabelas de drop) fica em [`docs/04_content/`](../../04_content/INDEX.md); ele segue estas regras e não as redefine.

## Onde os valores moram

| Camada | Arquivo | Papel |
| --- | --- | --- |
| Núcleo global | [`data/balance/combat_core.json`](../../../data/balance/combat_core.json) | fórmulas, `combat_scale`, `level_curve_p`, referência, arquétipos, ranks, caps, stagger, orçamento de item, XP |
| Capítulo | [`data/balance/chapters/`](../../../data/balance/chapters/) | escalas locais, recuperação, metas e caminhos do capítulo |
| Manifesto | [`data/balance/combat_profiles.json`](../../../data/balance/combat_profiles.json) | só compõe núcleo + capítulos |
| Conteúdo | `data/heroes`, `data/enemies`, `data/skills`, `data/items`, `data/expedition`, `data/progression` | valores de cada entidade |
| Hipótese temporária | `tools/argos/simulator/combat/scenarios/*.json` (`overrides`) | nunca grava em `/data` |

## Histórico da versão

- **2026-09-30 — v1.0 (DESIGN):** Rafael aprovou a estrutura "constituição + domínios", o orçamento de poder equilibrado, dificuldades como endgame, farm offline limitado e catch-up de XP para o banco. A v1.0 absorveu a base v0.5 e a origem v0.4 (status, fórmulas, heróis, inimigos, equipamento, loot, affixes, stagger, ameaça, recursos, invocações, telemetria) e os contratos `GLOBAL_BALANCE_SYSTEM`, `SLICE_BALANCE_CONTRACT`, `COMBAT_BALANCE_STANDARD`, `BALANCE_V0.5`, `ECONOMY_MODEL`, `CHAPTER_01_ITEM_STATS_PROPOSAL`, `CHAPTER_01_HERO_COMBAT_PROPOSAL` e `COMBAT_SCALE_AND_GROWTH_PROPOSAL`.
- A versão de dados carregada pelo jogo é `balance_version` em cada perfil de capítulo; ela muda quando `/data` muda (política em [00 §11](00_CONSTITUICAO.md#11-política-de-mudanças-de-números)).
