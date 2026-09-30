---
document_type: balance-domain
id: BALANCE_V1_07_ECONOMIA_LOOT
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 04_ITENS_RARIDADE, 06_INIMIGOS_CHEFES]
---

# 07 — Economia e loot

Algoritmo do resolvedor: [specs/DROP_RESOLVER_SPEC](specs/DROP_RESOLVER_SPEC.md). Loot por inimigo: bloco `enemy.loot` do [schema canônico](specs/ENEMY_CANONICAL_SCHEMA.md). Tabelas do Capítulo 1 (visão humana): [CHAPTER_01_DROP_TABLES](../../04_content/chapters/chapter_01/CHAPTER_01_DROP_TABLES.md). Runtime do slice: [`LootRoller`](../../../scripts/run/) e `route_c1.json`.

## 1. Filosofia

Drops dão emoção. Ouro dá liberdade. Materiais dão progressão. Craft protege contra azar. Relíquias mudam a build. Memórias entregam lore e efeitos especiais. O melhor equipamento vem de combate, elites, minichefes, chefes, eventos e craft direcionado; a loja completa build e consome ouro, nunca é a fonte do poder máximo.

## 2. Recursos — fonte, uso e sink

| Recurso | Escopo | Fontes | Usos / sinks | Regras |
| --- | --- | --- | --- | --- |
| XP | herói | encontros vencidos (também em derrota) | nível | não é moeda; [02 §5](02_HEROIS.md#5-xp-e-ritmo-de-nível) |
| Ouro | conta | inimigos, eventos, venda | Mercador, custos secundários de craft, respec | não compra a Árvore nem progressão principal |
| Materiais de capítulo | conta | drops, desmontagem | Reforço, receitas, transmutação | 2–3 materiais novos por capítulo; os antigos mantêm sink via transmutação |
| Essência | conta | elites, chefes, destilação | catalisadores, craft avançado | pós-slice |
| Lascas de chefe | conta | chefe (1–2 por repetição, 2 na primeira vitória) | receitas de Relíquia (6 aleatória / 10 escolhida) | uma por chefe |
| Fragmentos de Ressonância | conta | primeiras vitórias e marcos de campanha | Árvore dos Ecos | nunca de farm nem offline ([08](08_META.md)) |
| Fragmento narrativo do chefe (ex.: Coração Verde) | conta | 1ª vitória | desbloqueio regional/narrativo | não é moeda |

Todo recurso tem fonte e sink; recurso sem uso é achado. Taxas por hora (online e offline) e teto de acúmulo são medidas pelo Argos por capítulo; alerta quando o saldo de um recurso cresce sem limite (caso BAL-014).

## 3. Raridade por fonte

Pipeline por inimigo derrotado, com rolagens independentes: Ouro → material → equipamento (cai? depois qual raridade? depois qual template) → drop assinatura → Echo/Memória → atualização de pity.

**Normal (D0), condicional a cair equipamento (herdado; o slice aplica os recortes de Rafael):**

| Fonte | Comum | Incomum | Raro | Épico | Relíquia | 2º item |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Inimigo comum | 62% | 27% | 9% | 1,8% | 0,2% | — |
| Elite (1 garantido) | — | 35% | 45% | 18% | 2% | 20% |
| Minichefe (1 garantido) | — | — | 45% | 48% | 7% | 35% |
| Chefe, repetição (1 garantido) | — | — | 15% | 70% | 15% | 50% |

- **DECIDIDO para o slice (Rafael, 2026-09-30):** Épico só como recompensa de chefe; Relíquia e Memória fora do slice. A renormalização das tabelas sem Épico fica EM ABERTO ([11](11_DECISOES_ABERTAS.md)).
- Primeira vitória sobre chefe: fragmento narrativo, Memória do chefe (quando existir), equipamento Épico ou superior, Ouro e material de chefe garantidos; Reward Choice garantido.
- Drops assinatura: 1–3% em comuns, 5–20% em elites/minichefes. Relíquia regional em comum: 0,2% dentro da rolagem de raridade (~1 em 4 mil kills), surpresa e nunca estratégia de farm.

## 4. Proteções contra azar

| Mecanismo | Regra (herdada; HIPÓTESE) |
| --- | --- |
| Smart Loot | 70% do peso favorece slots/afinidades úteis à party ativa; 30% livre. Nunca garante build exata nem remove itens de outros heróis |
| Proteção contra duplicata | últimos 6 templates: 1× → ×0,70; 2× → ×0,40; 3× → ×0,15; nunca zero |
| Pity de slot | 12 drops sem um slot → ×1,5; 18 → ×2,5; 24 → próximo compatível prioriza o slot |
| Pity de Épico | conta drops, não kills: 25 sem Épico+ → peso ×3; 40 → Épico garantido |
| Pity de Relíquia de chefe | kills 6 e 7 sem Relíquia → +10 e +20 p.p.; kill 8 → garantida; por chefe |
| Reward Choice | 3 opções, escolhe 1: minichefe 25%; chefe 1ª vitória garantido, repetição 35%; sem template duplicado, ≥ 2 slots, ≥ 1 relevante à party |
| Echo + Bestiário | chance de Echo × 1,00/1,25/1,60/2,00 por tier; tier final sem o Echo → concessão única. Comum: 15/40/80 kills; elite: 5/12/25 |

Pity é transacional e salvo; seed reproduzível ([specs/DROP_RESOLVER_SPEC](specs/DROP_RESOLVER_SPEC.md)).

## 5. Ouro e materiais — base do Capítulo 1 (escala por capítulo)

Ouro: comum 3–8, elite 25–45, minichefe 80–130, chefe 250–400 (herdado; Capítulo 1). **Regra global (RECOMENDADO):** Ouro e preços crescem juntos por capítulo pelo fator `1,15^(c−1)`, para os preços antigos não virarem troco nem os novos virarem parede. Materiais: normal 1 quando a rolagem passa; elite 1–2 + chance de Essência; minichefe 2–4 + Essência; chefe 4–8 + Essência + material narrativo.

## 6. Desmontagem

Retorno por raridade: Comum → material comum; Incomum → + chance extra; Raro → + pequena Essência; Épico → + Essência; Relíquia → material especial + Essência; Memória normalmente não desmontável. Nunca devolve 100% do investimento ([05 §4](05_AFFIXES_CRAFT.md#4-operações-de-craft-e-seus-limites)).

## 7. Mercador

Vende Comum, Incomum e Raro; Épico em aparição rara; nunca Relíquia nem Memória.

## 8. Inventário e excesso

- **Limite de inventário (RECOMENDADO; resposta ao BAL-014):** 60 espaços no início, ampliáveis pela Árvore (Fortuna/Oficina) até 150. Número HIPÓTESE.
- Com o inventário cheio, nada raro é destruído: Comum/Incomum vão para desmontagem automática configurável (desligada por padrão) ou caixa temporária; Raro+ vai para uma caixa de recompensas garantida.
- Auto-loot no mobile: Ouro, materiais e equipamento entram direto; Relíquia/Memória têm apresentação especial.

## 9. Progresso offline

**DECIDIDO (Rafael, 2026-09-30):** farm limitado.

- Offline **repete só conteúdo já vencido**: não avança capítulo, não enfrenta chefe novo, não concede recompensa de primeira vitória, Fragmentos nem pity de Relíquia de chefe.
- Taxa: ~50% da taxa online do mesmo conteúdo (HIPÓTESE), com teto de 8 h (HIPÓTESE; a Árvore pode ampliar para 12 h).
- O cálculo offline usa estatística derivada do motor (taxa medida por conteúdo), não uma simulação diferente com regras próprias.
- Soma de todo o offline de um capítulo ≤ ~30% do progresso do jogador de referência ([00 §6](00_CONSTITUICAO.md#6-jogador-de-referência-por-capítulo)).
- A expedição em andamento continua valendo: ao fechar o app, ela termina no objetivo ou na derrota sem começar outra (decisão de `ECON-1`).

## 10. Telemetria de economia

Por run e por hora: drops, distribuição de raridade, Ouro, materiais, drops assinatura, disparos de pity, desmontados, equipados, nunca usados, relevância do Smart Loot, rerolagens de qualidade, escolhas de Reward Choice, Lascas ganhas/usadas, garantias do Bestiário, distribuição de IP. Divergência grande entre a distribuição real e a tabela = `BUG` ou revisão de RNG.
