---
id: SLICE_BALANCE_CONTRACT
status: DESIGN
certainty: HIPOTESE
---

# Contrato de balanceamento do SLICE-1 (BALANCE-FOUNDATION-1)

**Status:** `DESIGN`. Este arquivo define **o que o combate do slice usa** do [cânone v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md) e as escolhas locais necessárias para calculá-lo. Ele **não declara o jogo balanceado**: todo número candidato é **HIPÓTESE** até simulação e playtest no `SLICE-1E`.

**Escopo:** somente o recorte de [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md). O restante do contrato (tipos de dano, affixes, stacking/dispel, DOT/HOT, escala de capítulo e dificuldade, matriz completa de builds) fica para o `BALANCE-1`. Vocabulário, forma dos registros e ordem de cálculo continuam em [COMBAT_BALANCE_STANDARD](COMBAT_BALANCE_STANDARD.md); unidades e fórmulas continuam nos arquivos do v0.4, sem cópia aqui (um fato → uma autoridade).

**Reprodução dos números:** `python tools/balance/slice_baseline.py` (determinístico, sem RNG). Ele lê as mesmas fontes do ECON-1 e reproduz a seção 5.

## 1. Compatibilidade com o combate atual

**DECIDIDO (Rafael, 2026-09-29; revisado no mesmo dia):** o combate do slice usa as fórmulas v0.4. O conteúdo legado do MVP e a matemática atual (`atk − def`) são **removidos** no `1A-CUT`, quando a rota do slice já funciona; até lá coexistem, com a fórmula escolhida pelo conjunto de conteúdo. Depois do corte só existe a fórmula v0.4.

| | Combate atual (removido no `1A-CUT`) | Slice (v0.4) |
| --- | --- | --- |
| Dano | `max(1, ataque − defesa)` ([GameManager.gd](../../scripts/combat/GameManager.gd)) | `ataque × (1 − defesa/(defesa+100))`, mínimo 1 |
| Crítico | ×2,0 fixo; chance por herói (5% a 20%) | `crit_damage` base ×1,5 por herói; `crit_chance` base 5% |
| Ritmo | `cd_interval` em segundos | `attack_speed` em golpes/s; intervalo = 1 ÷ `attack_speed` |
| Nível | +10 HP, +1,5 ATK, +0,5 DEF por nível | interpolação linear até o nível 100 |
| Inimigos | 1 inimigo ativo por vez (`active_enemy`) | encontros de 1 a 3 inimigos |

- **Coexistência temporária (até o `1A-CUT`):** a fórmula é escolhida pelo **conjunto de conteúdo da expedição** (`content_set`), não por entidade. Legado usa a fórmula atual; slice usa a v0.4; nunca há party ou encontro que misture os dois.
- Nenhum arquivo em `/data` é alterado por este contrato. A migração do subconjunto e a remoção do legado são trabalho do `SLICE-1A` (`1A-2` a `1A-CUT`); o alias serve para reaproveitar nome e sprite, registrado no [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md), seção 8.
- O suporte a vários inimigos simultâneos e a skills equipadas não existe hoje no runtime e é escopo do `SLICE-1A`, não deste contrato.

## 2. Status do slice — DECIDIDO

13 status, com unidade e fórmula no v0.4 ([COMBAT_FORMULAS](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md), [STATUS_SYSTEM_BASE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/STATUS_SYSTEM_BASE.md)). A coluna do runtime é só o nome atual, sem migração de ID.

| Grupo | ID canônico | Origem no slice | Nome no runtime atual |
| --- | --- | --- | --- |
| Núcleo | `max_hp`, `attack`, `defense`, `crit_chance` | base de todos | `base_hp`, `base_attack`, `base_defense`, `crit_rate` |
| Núcleo | `attack_speed` | base; alvo de lentidão (Rede de Micélio) | `cd_interval` (`attack_speed` = 1 ÷ intervalo) |
| Núcleo | `crit_damage` | base e itens | fixo em ×2,0 no código |
| Núcleo | `skill_haste`, `tenacity` | itens (Farol e Fragmento Prismático, Totem) e limites de controle | sem equivalente |
| Condicional | `armor_pen_pct` | Ponta de Penetração, Flecha Perfurante | sem equivalente |
| Condicional | `damage_bonus` | Marca, alvo exposto, Sensível ao Lúmen | sem equivalente |
| Condicional | `damage_taken` | Muralha Viva, Fortaleza, Desequilíbrio | sem equivalente |
| Condicional | `shield_power` | Véu de Micélio | sem equivalente |
| Condicional | `status_power` | Lanterna de Esporos | sem equivalente |

- **Fora do slice:** `move_speed` (o combate é uma faixa estática, sem movimento), `armor_pen_flat`, `life_steal`, `healing_power`, `healing_received`, `status_resistance`, `range` (o `attack_range` atual não entra no dano) e todos os de progressão e loot.
- **Lentidão da Rede de Micélio (DECIDIDO):** reduz `attack_speed` do alvo por tempo limitado. A postura de Bastião que reduz movimento ao bloquear fica fora do slice.
- Nenhum status novo foi criado. A regra do padrão (status só com mecânica concreta que o use) foi aplicada.

## 3. Recursos, estados e regras especiais

| Conceito | Classe | Regra no slice |
| --- | --- | --- |
| **Guarda** | Recurso de classe (estado de combate, 0–100), não status | **Fora do slice (DECIDIDO).** Sem gasto equipado (Impacto de Escudo e Último Bastião estão fora), o recurso não teria função. |
| **Perfect Block** | Regra de evento com estado booleano *Guarda pronta* e recarga | **HIPÓTESE.** O primeiro ataque que atinge Bastião com o estado pronto vira Perfect Block e consome a prontidão. Efeitos: dano recebido drasticamente reduzido e Desequilíbrio no atacante. Determinístico, sem RNG e sem comando do jogador ([SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md), seção 1). |
| **Desequilíbrio** | Debuff, 4 s | `damage_bonus` −10% do alvo e aumento do dano de Stagger que ele sofre. A conversão exata do "−20% de resistência a stagger" é **EM ABERTO** (dono: `BALANCE-1`, junto do stacking). |
| **Stagger** | Barra de postura do v0.4, separada do HP | Break, vulnerabilidade durante o break, imunidade anti-encadeamento e regras de boss vêm do [STAGGER_SYSTEM](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/STAGGER_SYSTEM.md) e do [BOSS_RULES](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/BOSS_RULES.md). |
| **Marca** | Estado do alvo, não status | Não modifica números por si só; skills, passivas e itens consultam se o alvo está marcado. Sem acúmulo. |

- **Cláusulas de Guarda dormentes (DECIDIDO):** todas as cláusulas "+Guarda" e "geração de Guarda" das passivas e Traits do slice (Inabalável, Escudo Compartilhado, Momento, Voto do Escudo, Contra-Golpe, e o ganho de Guarda do Perfect Block) ficam **inativas** e registradas como **EM ABERTO**. Voltam quando o recurso entrar, no `BALANCE-1`. O restante desses nós continua ativo.
- **EM ABERTO:** intervalo de recarga do Perfect Block e efeito de passivas sobre ele (dono: este contrato, na calibração do `SLICE-1E`).
- **EM ABERTO:** Tenacidade contra a Contenção Arcana da Íris em elite, mini-boss e boss; o v0.4 já dá tenacidade por rank (+25, +50, +100), mas o efeito exato do atordoamento curto não está fechado.

## 4. Fórmulas, ordem e limites

Fonte única: [COMBAT_FORMULAS](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/COMBAT_FORMULAS.md). Este contrato adota a ordem do v0.4 e fixa só o que o slice usa:

```text
status finais (base → nível → equipamento → passivas/Traits → buffs/debuffs)
→ dano bruto (ataque básico = attack; skill = attack × coeficiente)
→ crítico (× crit_damage, se ocorrer)
→ defesa e penetração   mitigação = def_efetiva / (def_efetiva + 100)
→ damage_taken genérico
→ mitigação especial (rara)
→ escudo → HP        dano final mínimo 1
```

- `def_efetiva = max(0, defense × (1 − armor_pen_pct))`; `armor_pen_flat` não existe no slice.
- **Limites (v0.4):** `crit_chance` máximo 100%; intervalo de ataque mínimo 0,20 s; cooldown de skill mínimo 0,25 s; escudo é consumido antes do HP; DOT/HOT fora do slice.
- **Cooldown:** `cooldown = base ÷ (1 + skill_haste/100)`. **Controle:** `duração = base ÷ (1 + tenacity/100)`. **Escudo:** `base × (1 + shield_power)`.
- **Arredondamento:** o runtime mantém precisão; só a UI arredonda. **RNG:** seed disponível em debug e testes.
- **Ordem dos modificadores de status:** `(base + ΣFLAT) × (1 + ΣADD_PERCENT) × ΠMULTIPLY → OVERRIDE → clamp`, com origem rastreável (`source_type` + `source_id`). O `OVERRIDE` não é usado no slice.

### Exemplos calculados à mão (nível 1)

Bastião: HP 160, ATK 10, DEF 18, AS 0,80, crit 3%, crit dmg ×1,5. Geleia de Lúmen (`EN_C1_001`, Standard Normal, nível 1): HP 97,75, ATK 9 × 0,5, DEF 6,75, AS 1,00.

| Conta | Resultado |
| --- | --- |
| Mitigação da Geleia: 6,75 ÷ (6,75 + 100) | 6,32% |
| Golpe de Bastião: 10 × (1 − 0,0632) | 9,37 |
| Golpe médio com crítico: 9,37 × (1 + 0,03 × 0,5) | 9,51 |
| DPS básico de Bastião: 9,51 × 0,80 | 7,61 |
| Mitigação de Bastião: 18 ÷ 118 | 15,25% |
| Golpe da Geleia em Bastião: 4,5 × (1 − 0,1525) | 3,81 |
| Tempo para a Geleia matar Bastião sozinha: 160 ÷ 3,81 | 42,0 s |

**Contra o combate atual:** com a fórmula do MVP, Bastião (ATK 8) contra a Geleia legada (HP 30, DEF 0) dá `max(1, 8 − 0)` = 8 por golpe, e a Geleia legada dá `max(1, 4 − 4)` = 1. As escalas de HP e dano diferem (Geleia legada 30 HP; Geleia v0.4 97,75 HP), o que mostra a diferença de escala entre os dois modelos; o legado sai no `1A-CUT`.

## 5. Baselines do trio e dos inimigos

**Método (HIPÓTESE):** herói no nível do conteúdo ([HERO_STATS_BALANCE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/HERO_STATS_BALANCE.md), interpolação linear); inimigo = `HERO_REFERENCE` do nível × arquétipo × rank ([ENEMY_STATS_BALANCE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_STATS_BALANCE.md)). O DPS usa o multiplicador sustentado ×1,75 do v0.4, que é regra de balanceamento e **não** existe no runtime.

- **Nível do conteúdo (DECIDIDO):** o `min_level` da fase macro em [stages.json](../../data/stages/stages.json). Os encontros das fases 1 a 5 usam nível 1 a 5 e o Guardião usa o nível 5; a party esperada tem o mesmo nível. Os valores são HIPÓTESE, medidos no `SLICE-1E`.
- **Dano inimigo (DECIDIDO, HIPÓTESE local):** as tabelas do v0.4 dão 14 a 17 s para um inimigo comum consumir o HP do herói de referência, contra os 25 a 35 s que o próprio v0.4 pede. A meta de 25 a 35 s governa: um único `enemy_damage_scale` = **0,50** multiplica o `attack` dos inimigos do slice (27,9 s no nível 1, 28,1 s no 5, 30,8 s no 50, 34,1 s no 100). As tabelas do v0.4 **não são editadas**; a divergência fica registrada para o `BALANCE-1`.
- **Escala de party (HIPÓTESE):** HP de elite, mini-boss e boss ×3 (tamanho da party), critério já usado no ECON-1 para o Guardião. Comuns não são escalados.

Resultado de `slice_baseline.py` (party Bastião, Flecha e Íris, sem equipamento, sem cura e sem escudo):

| Encontro | Tipo | Nível | TTK | Faixa v0.4 | Dano recebido no TTK / HP da party |
| --- | --- | ---: | ---: | --- | ---: |
| Comuns (7 encontros) | Comum | 1 a 4 | 1,9 a 5,2 s | 3–6 s por alvo em 1 herói | 5% a 8% |
| Geleia Anciã | Elite | 2 | 13,5 s | 15–30 s | 41% |
| Rainha das Geleias | Mini-boss | 3 | 35,3 s | 40–75 s | 127% |
| Guardião-Cervo de Pedra | Boss | 5 | 165,7 s | 120–210 s | 423% |

- **Comuns:** a faixa do v0.4 é para um herói; com 3 heróis, cerca de 1 a 2 s por inimigo é o esperado. Nenhum ajuste.
- **Elite e mini-boss ficam abaixo da faixa** (10,5 s contra 15–30 s; 32,3 s contra 40–75 s por alvo principal), mesmo com ×3. **HIPÓTESE:** ajustar HP por rank só depois de medir no `SLICE-1E`; não inventar novo multiplicador agora.
- **Risco principal — sobrevivência no boss:** sem equipamento, a party recebe cerca de 4,2 vezes o HP total dela durante os 166 s do Guardião (1 685 de dano contra 399 de HP). O modelo só conta **ganho ofensivo** de skills (×1,75) e não modela cura, escudo, provocação, Muralha Viva, Fortaleza, Véu de Micélio ou Perfect Block. O equipamento do v0.4 sozinho não fecha essa distância: um conjunto completo Lendário rende +30% a +45% sobre o personagem nu. Portanto, o critério é: a sobrevivência precisa vir do kit e das sinergias, e a taxa de vitória na primeira tentativa só pode ser lida no `SLICE-1E`.
- **Se o `SLICE-1E` ficar fora de 40–60% de vitórias na primeira tentativa:** ajustar primeiro telegraphs, recuperação, adds e dano recebido (regra de [ENCOUNTERS.md](../04_content/chapters/chapter_01/ENCOUNTERS.md)); ajustar HP só se o TTK também sair da faixa.
- **Baseline do trio:** as linhas de [HERO_STATS_BALANCE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/HERO_STATS_BALANCE.md) para Bastião, Flecha e Íris. A referência do Bastião é EHP alto com DPS abaixo do herói de referência, como o v0.4 admite; a das outras duas fica na faixa de 85–115% do `HERO_REFERENCE` **com o kit completo**, que o slice ainda não mede.

### Meta de progressão e recuperação (Rafael, 2026-09-29)

> **Atualizado pelo [balanceamento v0.5](BALANCE_V0.5.md):** nível de conteúdo por fase, escala de HP do chefe, golpes telegrafados e demais mudanças; em caso de divergência com este contrato, vale o v0.5 e os valores de `/data`.

- **DECIDIDO:** o jogo é incremental (níveis 1–100). O Guardião do Capítulo 1 deve ser vencido **por volta do nível 10–11**, depois de derrotas e vitórias parciais; vencer no nível 5 não é objetivo. O alvo está em `chapter_targets` de [combat_profiles.json](../../data/balance/combat_profiles.json).
- **DECIDIDO:** HP volta ao máximo no Hub; dentro da expedição existe **fôlego entre encontros**. **HIPÓTESE:** 10% do HP máximo dos vivos ao fim de um encontro em que ninguém caiu (`recovery_between_encounters` no mesmo arquivo).
- **Medido (Argos, simulação, não playtest):** com fôlego e o Pulso Restaurador experimental reduzido, as 18 combinações de builds vencem a campanha entre os níveis 7 e 14 (mediana perto de 9–12). Relatórios e achados: [BALANCE_FINDINGS](../08_qa/BALANCE_FINDINGS.md) e `tools/argos/reports/`.

## 6. Orçamentos de slots e raridades do recorte

Fonte: [EQUIPMENT_BALANCE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/EQUIPMENT_BALANCE.md) e [STAT_BUDGETS](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/STAT_BUDGETS.md). BP é ferramenta interna e não aparece para o jogador.

BP efetivo = BP da raridade × multiplicador do slot (Arma ×1,20; Secundário ×1,00; Armadura ×1,20; Acessório I e II ×0,90; Eco ×1,00):

| Raridade (BP base) | Arma | Secundário | Armadura | Acessório | Eco |
| --- | ---: | ---: | ---: | ---: | ---: |
| Comum (2) | 2,4 | 2,0 | 2,4 | 1,8 | 2,0 |
| Incomum (3) | 3,6 | 3,0 | 3,6 | 2,7 | 3,0 |
| Raro (4) | 4,8 | 4,0 | 4,8 | 3,6 | 4,0 |
| Épico (5) | 6,0 | 5,0 | 6,0 | 4,5 | 5,0 |

- **Relíquia e Memória — EM ABERTO:** a tabela do v0.4 lista Comum a Lendário (6 BP), enquanto o catálogo v0.4 usa Relíquia e Memória. A equivalência Relíquia = Lendário não está declarada e não é inferida aqui. A Casca do Guardião (`ITEM_A_005`) entra no slice como drop do boss, e seu BP e efeito único exigem decisão antes da implementação.
- **Regras por slot (v0.4):** no máximo 25% do BP da Arma em defesa pura e da Armadura em dano bruto.
- **Conjunto completo:** cerca de 12 BP (Comum), 19 (Incomum), 25 (Raro) e 31 (Épico); um conjunto não deve multiplicar o poder total por 3× ou 5×.
- **Reforço +1 do Ferreiro:** `+2%` de status base, sem affix, conforme o contrato v0.4 ([ENCOUNTERS](../04_content/chapters/chapter_01/ENCOUNTERS.md)). Não cria BP novo.
- **Renormalização das tabelas de raridade `RARITY_C1_*`:** **EM ABERTO** (Épico entra só como pool do garantido do boss; ver [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md), seção 3).
- Os efeitos únicos dos itens do recorte precisam de BP descontado por uptime (`STAT_BUDGETS`, seção 3) e, quando não expressáveis com segurança, de simulação.

## 7. Telemetria mínima do slice

Fonte: [BALANCE_TELEMETRY](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/BALANCE_TELEMETRY.md). Local-first, desligável, e nenhum cálculo do combate pode depender dela.

| Grupo | Métricas do slice |
| --- | --- |
| Dano | `damage_dealt_total`, `damage_by_source`, `damage_by_skill`, `critical_damage` |
| Recebido | `damage_taken_total`, `damage_taken_by_source`, `largest_hit_received` |
| Cura e escudo | `healing_done`, `effective_healing`, `shield_generated`, `shield_consumed`, `shield_expired` |
| Skills | `casts`, `hits`, `cooldown_uptime` (uso de skills por herói e build) |
| Debuffs | `debuff_uptime` e `debuff_applications` de Marca, Desequilíbrio, Fratura Arcana e lentidão |
| Stagger | `stagger_damage`, `breaks`, `time_to_break`, `damage_during_break` (elite, mini-boss e boss) |
| Perfect Block (local) | tempo com *Guarda pronta*, número de Perfect Blocks e dano evitado |
| Resultado do encontro | `duration`, `victory`, `deaths`, `damage_dealt`, `damage_taken`, `healing`, `shielding`, `ttk`, `survival_time`, `build_id`, `equipment_score` |
| Economia | Resíduo de Lúmen, Ouro e Fragmentos de Ressonância ganhos e gastos por run |

- O evento base (`combat_event`) e o resultado do encontro seguem o v0.4; os campos de seed e `run_id` entram para reproduzir críticos, procs e loot.
- **Lacuna atual:** [Telemetry.gd](../../scripts/debug/Telemetry.gd) registra apenas abates, mortes de herói e drops. Os eventos acima são trabalho do `SLICE-1A` a `1E`.
- Métricas fora do slice: summons, DOT e as de recursos de outros heróis.

## 8. Rastreio dos números

| Número ou regra | Estado | Fonte | Método |
| --- | --- | --- | --- |
| Fórmula v0.4 no slice; legado removido no `1A-CUT` | DECIDIDO | Rafael, 2026-09-29 (revisão) | Coexistência só até o corte |
| 13 status do slice | DECIDIDO | Rafael, 2026-09-29 | Seção 2 |
| Guarda fora do slice; cláusulas dormentes | DECIDIDO | Rafael, 2026-09-29 | Sem gasto equipado |
| Perfect Block por prontidão com recarga | HIPÓTESE | Rafael, 2026-09-29 | Regra determinística; intervalo EM ABERTO |
| Nível do conteúdo = `min_level` da fase macro | DECIDIDO (mapeamento); valores HIPÓTESE | Rafael, 2026-09-29 | Seção 5 |
| `enemy_damage_scale` = 0,50 | HIPÓTESE | Rafael, 2026-09-29 | Consistência interna do v0.4; recalibrar no `SLICE-1E` |
| HP ×3 em elite, mini-boss e boss | HIPÓTESE | ECON-1 | Tamanho da party |
| Multiplicador sustentado ×1,75 | Regra de balanceamento (v0.4) | ENEMY_STATS_BALANCE | Não existe no runtime |
| `DEFENSE_K` = 100, cap de crítico, intervalos mínimos | Base canônica | COMBAT_FORMULAS | Aplicado sem alteração |
| BP por raridade e por slot | Base canônica | EQUIPMENT_BALANCE | v0.1, recalibrar por simulação |

## 9. Pendências e gate

- **EM ABERTO:** intervalo do Perfect Block; conversão do −20% de resistência a stagger; Tenacidade contra a Contenção Arcana; BP de Relíquia e Memória; renormalização de raridade; multiplicadores de HP por rank fora do ×3; efeito de skills defensivas na sobrevivência do boss.
- **Depende do `SLICE-1E`:** taxa de vitória na primeira tentativa, TTK de elite e mini-boss, sobrevivência no Guardião, `enemy_damage_scale`.

| Item do gate BALANCE-FOUNDATION-1 | Onde |
| --- | --- |
| Status canônicos usados pelo slice | seção 2 |
| Guarda, Perfect Block, Desequilíbrio/Stagger e Marca | seção 3 |
| Fórmulas, caps, ordem e exemplos contra o combate atual | seções 1 e 4 |
| Baseline do trio e dos inimigos | seção 5 |
| Budgets dos slots e raridades | seção 6 |
| Telemetria mínima | seção 7 |
| Rastreio DECIDIDO/HIPÓTESE/EM ABERTO | seção 8 |

O gate só é dado como PASS depois da revisão de Rafael deste arquivo; os checkboxes do [ROADMAP](../../ROADMAP.md) não foram marcados.
