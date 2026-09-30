---
document_type: balance-domain
id: BALANCE_V1_04_ITENS_RARIDADE
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 01_STATUS_E_COMBATE]
---

# 04 — Itens, raridade e Item Power

Arquitetura dos slots e dos artesãos: [EQUIPMENT_AND_CRAFTING_SYSTEM](../../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) (`CRAFT-1`/`ITEM-1`). Catálogo do Capítulo 1: [CHAPTER_01_ITEM_CATALOG](../../04_content/items/CHAPTER_01_ITEM_CATALOG.md). Valores runtime: `combat_core.json → item_budget` e [`SliceItemStats.gd`](../../../scripts/combat/SliceItemStats.gd). Equipamento + craft ocupam a fatia "equipamento" da [constituição §4](00_CONSTITUICAO.md#4-orçamento-de-poder).

## 1. Princípios

- Equipamento altera build, oferece escolha e complementa o herói; nunca substitui o kit nem apaga a fraqueza central ([02 §3](02_HEROIS.md#3-papéis-e-fraquezas-declaradas)).
- **Raridade ≠ Item Power.** Raridade diz quantos affixes, qual qualidade e se há efeito único; IP diz o tamanho dos números.
- Template reutilizável entre faixas: o mesmo item cai com IP maior mais tarde. Nada de "Casco II/III" só para inflar números.
- DECIDIDO (2026-09-28/30): 6 slots (Arma, Secundário, Armadura, Acessório I e II, Echo); só armas são exclusivas por herói; equipamento só muda no Hub; drops vão para o inventário; build não depende de item aleatório específico.

## 2. Budget Points (BP)

BP é unidade interna, nunca exibida. `BP_bruto = BP(raridade) × multiplicador do slot × fator de IP`.

**Escada de nove níveis de raridade — DECIDIDO (Rafael, 2026-09-30), curva convexa:** `BP(n) = 2 + 13/8 × (n−1)` até `n = 4`; depois `BP(n) = BP(n−1) + 0,4 + 0,2·n`. Nomes dos níveis 5–9 EM ABERTO (não inventar).

| Nível | 1 Comum | 2 Incomum | 3 Raro | 4 Épico | 5 | 6 | 7 | 8 | 9 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| BP | 2,000 | 3,625 | 5,250 | 6,875 | 8,275 | 9,875 | 11,675 | 13,675 | 15,875 |
| Salto da peça | — | +81% | +45% | +31% | +20% | +19% | +18% | +17% | +16% |
| Poder do set (alvo, HIPÓTESE) | +10% | +18% | +26% | +35% | +42% | +50% | +59% | +69% | +80% |

- Poder do set = 5 slots no nível do conteúdo contra o herói nu, métrica `ATK × HP × (1−mit_nua)/(1−mit_final)`. Âncoras DECIDIDAS: Comum ~+10%, Épico ~+35%, topo ~+80%.
- Medição (2026-09-30, IP 27, nível 10, sets do trio): Épico +29% a +38%; nível 9 +73% a +95%.
- **Multiplicador de slot:** Arma e Armadura 1,20; Secundário e Echo 1,00; Acessórios 0,90.
- **Valor de 1 BP (runtime, calibrado em 2026-09-30):** ATK, HP e DEF = 1,8% da referência do nível do item; velocidade de ataque 1,08%; crítico 0,63 p.p.; Haste 2,16; Tenacidade 2,7. Dano crítico e movimento: 2,7 p.p. e 0,9% (RECOMENDADO, mesma proporção sobre o herdado).
- **Reserva de efeito:** só item **com** modificador desconta parte do BP para o efeito (Comum 0, Incomum 10%, Raro 20%, Épico 35%, Relíquia 50%, Memória 60%). Item sem modificador usa o BP inteiro em status (DECIDIDO). Efeito que custe mais que a reserva (burst, proc, controle) reduz os status-base; custo por uptime ([03 §2](03_SKILLS_PASSIVAS.md#2-orçamento-por-tipo-de-skill-coeficiente--atk-hipótese-herdada)).
- Não permitir que equipamento multiplique o poder total por 3× ou 5× no mesmo tier.

## 3. Famílias de status por slot

Cada slot tem conjunto previsível de status, para comparar itens de relance (UI_S12).

| Slot | Status principais | Limite |
| --- | --- | --- |
| Arma | ATK, crítico, dano crítico, AS, penetração, efeitos ofensivos | ≤ 25% do BP em defesa pura |
| Secundário | flexível: defesa, ataque, recurso, skill, invocação | slot híbrido |
| Armadura | HP, DEF, Tenacidade, sustento, mitigação | ≤ 25% do BP em dano bruto |
| Acessórios | especialização: crítico, Haste, buffs, cura, status, recurso, mecânica de build | — |
| Echo | efeito de build/lore | ≥ 50% do BP em efeito; ≤ 50% em status |

**Caps só da contribuição do equipamento:** crítico +35 p.p.; AS +60%; movimento +25%; roubo de vida 25%; Haste +80. Os caps finais de [01 §4](01_STATUS_E_COMBATE.md#4-caps) continuam valendo.

## 4. Item Power (IP)

- Escala global IP 1–100; fator `0,60 + 0,80 × IP/100` (×0,6 a ×1,4; DECIDIDO como multiplicador até o fim do jogo).
- **Faixa de IP por capítulo e fonte (RECOMENDADO; HIPÓTESE):** `b(c) = 7,5 × (c−1)`.

| Fonte | Faixa | Capítulo 1 | Capítulo 10 |
| --- | --- | --- | --- |
| Normal | 1+b a 18+b | 1–18 | 68–86 |
| Elite | 10+b a 24+b | 10–24 | 78–92 |
| Minichefe | 16+b a 28+b | 16–28 | 84–96 |
| Chefe | 22+b a 32+b | 22–32 | 90–100 |

- Distribuição dentro da faixa: 50% centro, 35% médio-alto, 10% alto, 5% quase máximo. Primeira vitória sobre chefe: mínimo 70% da faixa.
- A fonte fixa a faixa; o IP nunca sai dela por RNG. Dificuldades não aumentam o IP além de 100; elas liberam raridades ([09](09_DIFICULDADE_ENDGAME.md)).
- A escada de BP foi calibrada em IP 27 (meio do chefe do Capítulo 1).
- O nível do item (referência de status) é gravado no roll e é o nível do conteúdo da fonte.

## 5. Raridade por conteúdo

- **DECIDIDO (Rafael, 2026-09-30):** o slice usa Comum, Incomum, Raro e Épico; Épico é recompensa de boss com status superiores e pode ter modificador.
- **Normal (D0):** Comum a Épico (níveis 1–4). Chances por fonte em [07 §3](07_ECONOMIA_LOOT.md#3-raridade-por-fonte).
- **Dificuldades:** níveis 5–9 ([09 §2](09_DIFICULDADE_ENDGAME.md#2-camadas)).
- **Qualidade mínima (quality floor):** Comum 1 affix principal; Incomum 1 principal + 1 secundário; Raro 2–3 affixes com ≥ 1 de sinergia; Épico 3–4 com ≥ 1 de alto valor e ≥ 1 de sinergia. Níveis 5–9: +1 affix a cada 2 níveis (RECOMENDADO).

## 6. Categorias fora da escada

- **Relíquia (DECIDIDO, 2026-09-30):** item único de história ou chefe, fora da escada; BP especial (hoje 6,0, HIPÓTESE) e efeito único obrigatório, podendo ter contrapartida. Nunca "Épico com números maiores".
- **Memória:** raridade narrativa, normalmente Echo; efeito e lore fixos, sem rolagem comum; normalmente não desmontável.
- **Echo (DECIDIDO):** usa a mesma escada com multiplicador de slot 1,0, mas a raridade é fixa por template (Capítulo 1: Geleia e Mariposa no nível 3; Espinheiro no nível 4).
- EM ABERTO: BP e efeito da Casca do Guardião e da Memória do Guardião ([11](11_DECISOES_ABERTAS.md)).

## 7. Janela de relevância

Regra da [constituição §9](00_CONSTITUICAO.md#9-relevância-e-diferença-de-nível): item de mesma raridade do capítulo `c` vale ≥ 80% de um do `c+1` e ≤ 65% de um do `c+2`. Três forças produzem isso: a referência de status do nível do item (`REF(L)` do item), o fator de IP (+7,5 IP por capítulo ≈ +6% por capítulo) e a raridade típica do jogador de referência. Métrica: poder do set do jogador de referência com o equipamento guardado do capítulo anterior contra o do capítulo atual.

## 8. Poder do set por capítulo

O jogador de referência ([00 §6](00_CONSTITUICAO.md#6-jogador-de-referência-por-capítulo)) define raridade e IP típicos. O Argos usa perfis de equipamento (`nu`, `tipico`, `bom`; [equipment_profiles.json](../../../tools/argos/simulator/combat/equipment_profiles.json)); cada capítulo novo ganha seus perfis antes de ser medido.

## 9. Exibição de números

DECIDIDO (Rafael, 2026-09-30): números inteiros; abreviar a partir de 10 mil; o total do conjunto é calculado em precisão total e exibido arredondado, sem somar peças já arredondadas. Tooltip mostra raridade, IP, affixes e efeito único. Comparação nunca se reduz a uma seta verde/vermelha: um item com IP menor pode ser melhor para uma build (contrato de UI: [UI_S12](../../09_ui/screens/s12_numeros_de_item.md)).

## 10. QA de item

BP correto; slot e affixes permitidos; sem duplicação proibida; efeito único com custo; não é BiS para todos; Reforço e reforja preservam orçamento; tooltip mostra valor real; breakdown identifica `source_id`; raridade não muda a faixa de IP.
