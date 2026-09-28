---
status: APPROVED
---

# Padrão de balanceamento de combate e entidades

**Escopo:** contrato compartilhado para organizar os dados de balanceamento de heróis, inimigos, equipamentos e efeitos no Pocket Hero.

**Fonte canônica:** [TASKBAR Sistema Completo v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md). Os arquivos do pacote definem a base de combate, status, balanceamento e loot aprovada para o design de Pocket Hero. O [Balance Pack v0.1/v0.2](../../documents/references/balance_pack_v0.1/README.md) é histórico de apoio e não prevalece sobre v0.4.

**Estado:** estrutura canônica aprovada para o design de balanceamento. A integração/runtime ainda requer os gates e a migração da roadmap; a validação declarada pelo pacote não comprova equilíbrio nem implementação no Pocket Hero. Nada aqui altera `/data`, scripts ou cenas existentes.

## 1. Regras de fonte de verdade

- `HERO_STANDARD.md` rege a anatomia e a completude de design dos heróis. Esta ficha governa apenas a estrutura de balanceamento compartilhada.
- O [índice de inimigos](../04_content/enemies/INDEX.md) e fichas de conteúdo guardam identidade, comportamento e intenção de encontro; o runtime atual continua em `data/enemies/enemies.json`.
- O [contrato de equipamento](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) rege slots, raridade e intenção; valores carregados atualmente continuam em `data/items/items.json`.
- Este documento define o vocabulário, a forma dos registros e a ordem de cálculo. Não duplica números individuais de entidade.
- Uma entidade pode referenciar uma regra compartilhada; não cria uma fórmula paralela para uma classe, inimigo, slot ou origem de modificador.
- IDs de design e IDs runtime são separados. Não renomear nem migrar IDs de runtime sem decisão e migração aprovadas.

## 2. Registro compartilhado de status

Heróis, inimigos e efeitos usam o mesmo vocabulário de design. Os IDs abaixo são canônicos para novos registros de balanceamento. O runtime atual tem um subconjunto e alguns nomes legados; sua comparação e qualquer migração pertencem à fase `BALANCE-FOUNDATION-1`.

| Grupo | IDs canônicos | Aplicação |
| --- | --- | --- |
| Núcleo | `max_hp`, `attack`, `defense`, `attack_speed`, `move_speed`, `crit_chance`, `crit_damage`, `skill_haste`, `tenacity` | Base comum de heróis e inimigos. |
| Condicional | `armor_pen_flat`, `armor_pen_pct`, `damage_bonus`, `damage_taken`, `life_steal`, `healing_power`, `healing_received`, `shield_power`, `status_power`, `status_resistance`, `range` | Só registrar quando houver mecânica concreta que o use. |
| Progressão/loot | `xp_gain`, `gold_find`, `loot_find`, `loot_quality` | Não entram diretamente no cálculo de combate. |

Status não são recursos nem estados temporários. Por exemplo, `max_hp` é status; `current_hp`, `current_shield`, recurso de classe, stacks e cooldowns restantes são estado de combate. A experiência do Pocket Hero inclui Guard, Perfect Block, Desequilíbrio/Stagger e recursos próprios de herói; `BALANCE-FOUNDATION-1` deve definir se cada um é recurso, estado, status ou regra de evento sem duplicar seu papel.

Não introduzir STR/DEX/INT/VIT ou status universal especulativo sem provar que o status existente não representa a mecânica e que haverá uma fonte real para utilizá-lo.

## 3. Pipeline de modificadores

Forma de referência:

```text
valor-base
+ soma de FLAT
× (1 + soma de ADD_PERCENT)
× produto de MULTIPLY
→ OVERRIDE excepcional, se aplicável
→ clamp/cap definido para o status
= valor final
```

Operações canônicas:

- `FLAT`: soma direta ao valor-base;
- `ADD_PERCENT`: percentuais do grupo são somados antes de multiplicar;
- `MULTIPLY`: multiplicador especial, restrito a efeitos de alto impacto;
- `OVERRIDE`: substituição rara de valor/regra, nunca usada quando uma operação normal resolve.

A origem do modificador não deve mudar a matemática. A origem é preservada para remoção, inspeção e telemetria, com uma chave conceitual como `source_type` + `source_id`. A lista final de origens permitidas e a precedência entre efeitos conflitantes serão fechadas em `BALANCE-FOUNDATION-1`.

## 4. Estruturas canônicas por tipo

Os exemplos são contratos de documentação, não schemas de runtime aprovados. Os campos `TODO` devem ser preenchidos a partir das fontes de conteúdo e balanceamento; não criar valores para completar o template.

### Herói

```yaml
id: HERO_001
status: DESIGN
identity_ref: docs/02_heroes/BASTIAO_GOLDEN_REFERENCE.md
combat_profile:
  level_range: [1, 100]
  base_stats: {}       # IDs do registro compartilhado
  growth_model: TODO
  class_resources: []  # Referenciar sistema/recurso, sem convertê-lo em status
  basic_attack_ref: TODO
  skill_refs: []       # 6 no total, incluindo 1 Signature; ver HERO_STANDARD.md
  passive_refs: []
  trait_refs: []
  build_profiles: []
balance_targets:
  reference_scenario: TODO
  damage_role: TODO
  survival_role: TODO
  support_control_role: TODO
  known_tradeoffs: []
```

Identidade, lore, anatomia e completude continuam em [`HERO_STANDARD.md`](../../HERO_STANDARD.md) e na ficha específica. Os alvos de equilíbrio não substituem a identidade do herói nem aprovam números.

### Inimigo, elite, minichefe ou chefe

```yaml
id: EN_C1_001
runtime_id: geleia_de_lumen  # preservar o ID existente; omitir se ainda não implementado
status: APPROVED
rank: NORMAL               # NORMAL | ELITE | MINI_BOSS | BOSS
archetype: TODO
content_level: TODO
base_stats: {}             # mesmo registro compartilhado dos heróis
behavior_ref: TODO
telegraphs: []
counterplay: []
encounter_role: TODO
rewards_ref: TODO
balance_targets:
  target_ttk: TODO
  expected_incoming_damage: TODO
```

Arquétipo responde como a entidade luta; rank representa peso/escala do encontro. O modelo de rank não deve transformar chefe em inimigo comum com vida multiplicada. Boss precisa de comportamento, fases/janelas legíveis e counterplay conforme o conteúdo do capítulo. Valores de rank e tempos-alvo permanecem **HIPÓTESE** até a simulação do elenco/encontro.

### Equipamento

```yaml
id: ITEM_W_001
runtime_id: adaga_de_luz    # preservar o ID existente; omitir se ainda não implementado
status: DESIGN
slot_family: WEAPON
rarity: TODO
compatibility: []
modifiers: []               # status + operação + valor + origem
budget:
  method: TODO
  points: TODO
build_purpose: TODO
unique_effect: null
```

Os slots canônicos permanecem os seis definidos por `HERO_STANDARD.md` e `EQUIPMENT_AND_CRAFTING_SYSTEM.md` — cinco equipamentos convencionais e um Echo. A forma e os valores de design de raridade, Item Power e budgets seguem a fonte v0.4; integração no runtime exige migração e QA. Não declarar balanceamento comprovado antes de simulação/playtest.

### Buff, debuff e efeito periódico

```yaml
id: TODO
polarity: BUFF             # BUFF | DEBUFF | NEUTRAL
tags: []
duration_type: TODO
duration: TODO
stacking: TODO             # política explícita
max_stacks: TODO
source_id: TODO
dispellable: TODO
modifiers: []
periodic_effect: null      # dano/cura, intervalo, coeficiente, stat de escala
```

Cada efeito deve declarar o status exato que modifica, duração, acumulação e interação com Tenacidade/chefes. DOT/HOT não deve ser calculado por frame. Política de snapshot/dinâmica, stacking, caps e imunidade ainda requer decisão em `BALANCE-FOUNDATION-1`.

## 5. Curvas, orçamento e perfis

O cânone v0.4 define a interpolação de nível, o herói de referência, arquétipos/ranks inimigos, Stat Budget de equipamento, uptime budget, perfis de dificuldade e envelopes de TTK/DPS/EHP. Os valores são o baseline canônico de design; suas próprias notas exigem recalibração por simulação e playtest antes de serem afirmados como balanceados ou migrados ao runtime.

Para todo número candidato, registrar:

1. fonte e papel do dado (runtime observado, decisão, hipótese ou recomendação);
2. entidade, nível, composição/build e conteúdo usados na comparação;
3. fórmula completa e ordem dos modificadores;
4. média e extremos relevantes, não só um cenário ideal;
5. critério de aceitação, simulação/telemetria e limitações.

Nenhuma planilha de equilíbrio pode alterar silenciosamente os valores de `/data`. Um dado aprovado para runtime exige migração explícita e QA correspondente.

## 6. Critérios de auditoria

- Herói e inimigo compartilham os mesmos IDs de status e a mesma semântica.
- Item, skill, passiva, Trait, buff/debuff e árvore declaram modificadores com origem rastreável.
- Recursos de classe, stacks, HP atual e cooldown não são tratados como status-base.
- Poder efetivo de controle, cura, escudo, summon, AoE e efeitos condicionais entra na comparação, não apenas dano direto.
- Rank/dificuldade não geram cópias desconexas de entidades nem apenas inflacionam HP.
- Valores de design e runtime podem ser comparados, mas não confundidos.
- Critérios de QA cobrem heróis, builds, ranks, equipamento, efeitos, bosses e as plataformas-alvo.

## 7. Escopo restante de BALANCE-FOUNDATION-1

O [sistema v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md) é agora a base canônica para esses tópicos: tipos de dano, fórmulas, recursos, stagger, threat/aggro, summons, stats de heróis/inimigos, equipamento/affixes, buffs/debuffs, bosses, dificuldade, telemetria, QA, schema, materiais, tabelas e algoritmo de loot. `BALANCE-FOUNDATION-1` e `LOOT-EXPANSION-1` executam a integração, reconciliação dos IDs legados, simulações e migração de runtime; não reabrem a decisão sobre a autoridade do v0.4.
