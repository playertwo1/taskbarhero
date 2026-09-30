# Balanceamento — índice

**Autoridade única:** [balanceamento global v1.0](v1/README.md). Comece pela [constituição](v1/00_CONSTITUICAO.md) e abra só o domínio da tarefa.

| Preciso de… | Abra |
| --- | --- |
| Curva-mestra, orçamento de poder, jogador de referência, alvos, teto, linhas vermelhas | [00 · constituição](v1/00_CONSTITUICAO.md) |
| Status, fórmulas, caps, tipos de dano, buffs, postura, ameaça, recursos, invocações | [01 · status e combate](v1/01_STATUS_E_COMBATE.md) |
| Base e crescimento dos 8 heróis, fraquezas, XP, catch-up, respec | [02 · heróis](v1/02_HEROIS.md) |
| Orçamento de skills, Signature, ranks, passivas, Traits, Mastery, IA de uso | [03 · skills e passivas](v1/03_SKILLS_PASSIVAS.md) |
| BP, nove raridades, Item Power, slots, Echo, Relíquia, relevância, exibição | [04 · itens e raridade](v1/04_ITENS_RARIDADE.md) |
| Affixes, conflitos, procs, Reforço, reforja, desmontagem, artesãos | [05 · affixes e craft](v1/05_AFFIXES_CRAFT.md) |
| Referência, arquétipos, ranks, TTK, encontros, chefes, pressões por capítulo | [06 · inimigos e chefes](v1/06_INIMIGOS_CHEFES.md) |
| Recursos, drops, pity, Smart Loot, inventário, offline | [07 · economia e loot](v1/07_ECONOMIA_LOOT.md) |
| Árvore dos Ecos, Hub, custos em Fragmentos | [08 · meta](v1/08_META.md) |
| Dificuldades D1–D3, raridades 5–9, endgame | [09 · dificuldade e endgame](v1/09_DIFICULDADE_ENDGAME.md) |
| Arquitetura runtime, métricas, regra → métrica, Argos, gates | [10 · telemetria e Argos](v1/10_TELEMETRIA_ARGOS.md) |
| O que Rafael ainda precisa decidir | [11 · decisões abertas](v1/11_DECISOES_ABERTAS.md) |
| Valores locais e medições do Capítulo 1 | [perfil do Capítulo 1](v1/capitulos/CAPITULO_01.md) |
| Schema de inimigo, Drop Resolver, contrato de loot em JSON | [specs](v1/specs/ENEMY_CANONICAL_SCHEMA.md) · [Drop Resolver](v1/specs/DROP_RESOLVER_SPEC.md) · [LOOT_CONTRACT.json](v1/specs/LOOT_CONTRACT.json) |

## Valores e ferramentas

- **Números runtime:** [núcleo global](../../data/balance/combat_core.json), [perfil do Capítulo 1](../../data/balance/chapters/chapter_01.json), [manifesto](../../data/balance/combat_profiles.json), heróis, inimigos, skills, itens, rota e progressão em `data/`. `/data` prevalece para o que o jogo carrega.
- **Validação:** `python tools/balance/validate_balance_data.py` antes do Argos.
- **Simulação:** [Argos](../../tools/argos/README.md); achados em [BALANCE_FINDINGS](../08_qa/BALANCE_FINDINGS.md).
- **Metodologia (contexto, não autoridade):** [guia avançado de economia, pacing e balanceamento](../../documents/GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md).

Em 2026-09-30 a v1.0 absorveu e substituiu a base canônica v0.5, a origem v0.4, o Balance Pack v0.1/v0.2 e os contratos antigos desta pasta (`GLOBAL_BALANCE_SYSTEM`, `SLICE_BALANCE_CONTRACT`, `COMBAT_BALANCE_STANDARD`, `BALANCE_V0.5`, `ECONOMY_MODEL`, `CHAPTER_01_HERO_COMBAT_PROPOSAL`, `COMBAT_SCALE_AND_GROWTH_PROPOSAL`) e a proposta `CHAPTER_01_ITEM_STATS_PROPOSAL`. Esses arquivos foram excluídos; o histórico está no git.
