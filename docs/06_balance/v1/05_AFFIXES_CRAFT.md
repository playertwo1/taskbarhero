---
document_type: balance-domain
id: BALANCE_V1_05_AFFIXES_CRAFT
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 04_ITENS_RARIDADE]
---

# 05 — Affixes e craft

Papéis e ordem de abertura dos artesãos: [EQUIPMENT_AND_CRAFTING_SYSTEM](../../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) (`CRAFT-1`, APPROVED). Proposta futura de crafting profundo: [TASKBAR_Artesaos_Crafting_Affixes_v2.docx](../../../documents/TASKBAR_Artesaos_Crafting_Affixes_v2.docx) (não aprova números; reconciliar em `CRAFT-AFFIXES-1`). Valores runtime do Ferreiro do slice: [`blacksmith_slice.json`](../../../data/progression/blacksmith_slice.json).

## 1. Princípio

**Craft é controle sobre o RNG, não fonte de poder bruto.** Todo o poder de craft fica **dentro** da fatia de equipamento da [constituição §4](00_CONSTITUICAO.md#4-orçamento-de-poder); ele nunca soma uma fatia própria. Nenhuma operação cria multiplicação infinita de BP. Toda operação tem fonte, sink, custo visível e não destrói investimento sem confirmação (linha vermelha 9).

No slice (DECIDIDO, 2026-09-28/30): itens com identidade e propriedades fixas, sem affixes aleatórios nem reforja. As regras abaixo valem a partir de `LOOT-EXPANSION-1`/`CRAFT-AFFIXES-1`.

## 2. Famílias de affix e slots

Famílias: `OFFENSE`, `CRITICAL`, `SPEED`, `DEFENSE`, `SUSTAIN`, `SKILL`, `CONTROL`, `SUMMON`, `RESOURCE`, `ELEMENTAL`, `UTILITY`, `ECONOMY`, `UNIQUE`.

| Slot | Permitidas | Restritas |
| --- | --- | --- |
| Arma | OFFENSE, CRITICAL, SPEED, SKILL, ELEMENTAL, RESOURCE, UNIQUE | DEFENSE, SUSTAIN |
| Secundário | todas, exceto ECONOMY em tiers altos de combate | — |
| Armadura | DEFENSE, SUSTAIN, CONTROL, RESOURCE, UTILITY, UNIQUE | OFFENSE, CRITICAL |
| Acessórios | CRITICAL, SPEED, SKILL, CONTROL, RESOURCE, ELEMENTAL, SUMMON, UTILITY | — |
| Echo | todas | ≥ 50% do BP em efeito/build |

## 3. Conflitos, unicidade e procs

- Proibido no mesmo item em valores altos: roubo de vida + cura recebida; crítico + dano crítico + AS; dano de invocação + dano do herói; movimento + AS no máximo; economia + poder máximo de combate. Em valores baixos podem coexistir se o orçamento permitir.
- Flags: `exclusive_group`, `max_per_item`, `max_per_loadout` (ex.: explosão ao acertar: 1 por item, 2 por loadout).
- Todo proc declara `trigger`, `chance`, `internal_cooldown` (≥ 0,5 s para procs ofensivos comuns) e `effect`. Valor esperado = valor × chance × gatilhos/s × fração útil; AS muda o número real de procs.
- **Tiers de affix:** T1 80%, T2 90%, T3 100%, T4 110% do valor nominal. Rolagem sempre em faixa curta (80–110%): nenhum item "perfeito" 5× melhor que outro da mesma raridade.
- **Anti-BiS:** investigar affix em > 70% das builds ou item em > 60% no mesmo slot.
- Validação após gerar: conflitos, orçamento, qualidade mínima; se falhar, rerrolar até 10 vezes e depois usar template determinístico. Nunca entregar item inválido.

## 4. Operações de craft e seus limites

| Operação | O que faz | Limite | Estado |
| --- | --- | --- | --- |
| Reforço (Ferreiro) | +10% nos status-base por nível, sem affix novo e sem mudar IP | soma dos Reforços de uma peça ≤ ~metade do degrau até a raridade seguinte no mesmo nível | DECIDIDO (Rafael, 2026-09-30); slice: nível máximo 1, custo 5 Resíduos |
| Reforja | troca um affix por vez; mantém raridade e orçamento; respeita famílias; mostra antes/depois | custo sobe por tentativa; bloqueio de affix custa mais | pós-slice |
| Masterwork / refinamento | estado de investimento da peça | dentro do teto do Reforço | proposta DOCX v2 |
| Desmontagem | devolve material | nunca 100%: material-base 25–40%, material de reforço 50–70% do investido; favoritos protegidos | DECIDIDO (proteção); valores HIPÓTESE |
| Forja direcionada | escolhe o **slot**, não o resultado | reduz RNG sem matar o loot | herdado |
| Transmutação (Alquimista) | converte material de faixa inferior em superior | perda na conversão (RECOMENDADO 3:1) | pós-slice |
| Receita de acessório (Ourives) | resultado determinístico | custa mais que o drop equivalente | pós-slice |
| Lascas de chefe | 6 → Relíquia aleatória do pool; 10 → Relíquia escolhida | uma recompensa por receita | herdado; HIPÓTESE |

- **EM ABERTO ([11 D-06](11_DECISOES_ABERTAS.md)):** Reforço com mais de um nível. Com a curva convexa, o salto da peça cai para +16–20% nos níveis altos, e metade do degrau (8–10%) fica no limite de um único Reforço de +10%. Opções: reduzir o Reforço por nível nas raridades altas ou relaxar a regra de proteção.
- O Ferreiro manipula orçamento existente; o Alquimista manipula efeitos temporários, materiais e conversões; nenhum cria status paralelos (consumíveis aplicam `StatusEffect`).

## 5. Papéis dos artesãos (DECIDIDO, `CRAFT-1`)

Ferreiro: Arma, Secundário, Armadura. Ourives: Acessórios. Gravadora de Ecos: Echo (catalogar/equipar; sem cópia). Alquimista: materiais, catalisadores, transmutação, consumíveis. Ordem de abertura: Ferreiro → Gravadora → Alquimista → Ourives. A abertura é progressão de conta ([08](08_META.md)).

## 6. Métricas

Reforços por item; custo médio por ponto de poder ganho; itens desmontados, equipados e nunca usados; rerolagens por item; frequência de uso da forja direcionada. Alerta: craft respondendo por mais de 1/3 da fatia de equipamento de um capítulo.
