# STATUS_SYSTEM_BASE.md

> **Projeto:** Taskbar Mobile RPG  
> **Documento:** Sistema Base de Status  
> **Versão:** 1.0  
> **Estado:** BASE / CONTRATO DE PROJETO  
> **Objetivo:** definir uma linguagem única de status para heróis, inimigos, equipamentos, passivas, buffs, debuffs e efeitos futuros.

---

## 1. Princípio central

Todo o jogo deve usar **um único registro de status** e **um único pipeline de cálculo**.

Nunca criar um `attack` especial para herói, outro para inimigo, outro para equipamento e outro para buff.

A regra é:

```text
BASE
+ modificadores FLAT
× modificadores PERCENTUAIS ADITIVOS
× modificadores MULTIPLICATIVOS especiais
= VALOR FINAL
→ aplicar limites/caps
```

Forma canônica:

```text
final =
CLAMP(
    (base + Σ flat)
    × (1 + Σ add_percent)
    × Π multiply,
    min,
    max
)
```

### Regra de ouro

- Heróis e inimigos **possuem status**.
- Equipamentos, passivas, árvore global, ferreiro, alquimista, buffs e debuffs **modificam status**.
- Skills normalmente **consomem os status finais** para calcular dano, cura, escudo, duração etc.
- O jogo salva as fontes e valores-base; **não salva o resultado calculado como verdade definitiva**.

Isso permite recalcular tudo de forma segura quando um item é removido, um buff termina ou uma passiva muda.

---

# 2. Registro canônico de status

## 2.1 Status principais — obrigatórios

Esses são os status que formam o núcleo do combate.

| ID canônico | Nome UI | Tipo | Uso |
|---|---|---:|---|
| `max_hp` | Vida Máxima | número | quantidade máxima de vida |
| `attack` | Ataque | número | base do dano de ataques e várias skills |
| `defense` | Defesa | número | reduz dano recebido |
| `attack_speed` | Velocidade de Ataque | ataques/s | frequência dos ataques básicos |
| `move_speed` | Velocidade de Movimento | multiplicador | deslocamento em combate |
| `crit_chance` | Chance Crítica | % | chance de causar crítico |
| `crit_damage` | Dano Crítico | multiplicador | multiplicador aplicado no crítico |
| `skill_haste` | Aceleração de Skill | rating | reduz cooldown com retorno decrescente |
| `tenacity` | Tenacidade | rating | reduz duração de efeitos de controle |

### Decisão de design

**Não teremos STR/DEX/INT/VIT como uma segunda camada obrigatória.**

O jogo trabalha diretamente com valores que o jogador entende: Ataque, Defesa, Vida, Velocidade etc.

Se no futuro uma classe precisar de “Força”, “Fé”, “Energia”, “Fúria” ou outro atributo temático, ele deve existir como **recurso/mecânica própria da classe**, e não como uma segunda planilha universal escondida.

---

## 2.2 Status secundários — permitidos

Só entram quando uma skill, item, personagem ou sistema realmente precisar deles.

| ID | Nome UI | Uso |
|---|---|---|
| `armor_pen_flat` | Penetração de Defesa | remove pontos de Defesa |
| `armor_pen_pct` | Penetração de Defesa % | ignora parte percentual da Defesa |
| `damage_bonus` | Dano Bônus | bônus geral de dano |
| `damage_taken` | Dano Recebido | multiplicador recebido; usado por vulnerabilidade |
| `life_steal` | Roubo de Vida | converte parte do dano em cura |
| `healing_power` | Poder de Cura | aumenta curas causadas |
| `healing_received` | Cura Recebida | modifica curas recebidas |
| `shield_power` | Poder de Escudo | aumenta escudos gerados |
| `status_power` | Poder de Efeito | aumenta magnitude/duração de certos efeitos |
| `status_resistance` | Resistência a Efeito | reduz chance/magnitude de efeitos aplicáveis |
| `range` | Alcance | alcance do ataque/skill quando modificável |

### Regra

Um status secundário só deve virar global quando existir **mais de uma fonte real** usando-o.

Não criar status “só porque talvez algum dia seja útil”.

---

## 2.3 Status de progressão/loot — separados do combate

Esses valores usam o mesmo sistema de modificadores, mas nunca entram diretamente nas fórmulas de dano.

| ID | Nome UI |
|---|---|
| `xp_gain` | Experiência Recebida |
| `gold_find` | Ouro Encontrado |
| `loot_find` | Chance de Loot |
| `loot_quality` | Qualidade de Loot |

Devem ser raros em equipamento para não transformar todo item de combate em item obrigatório de farm.

---

# 3. Recursos NÃO são status

Alguns números mudam constantemente durante a luta e devem existir separados do sistema de status.

Exemplos:

```text
current_hp
current_shield
class_resource
stacks_temporarios
cooldown_remaining
```

`max_hp` é status.

`current_hp` é estado de combate.

Essa separação é obrigatória.

---

# 4. Fórmulas canônicas

## 4.1 Dano básico

```text
raw_damage = attack × skill_coefficient
```

Exemplo:

```text
Ataque = 100
skill_coefficient = 1.20

raw_damage = 120
```

---

## 4.2 Defesa

Modelo de retorno decrescente:

```text
effective_defense =
MAX(
    0,
    defense × (1 - armor_pen_pct) - armor_pen_flat
)

mitigation =
effective_defense / (effective_defense + DEFENSE_K)

final_damage =
MAX(
    MIN_DAMAGE,
    raw_damage × (1 - mitigation) × damage_taken
)
```

### Valor inicial recomendado

```text
DEFENSE_K = 100
MIN_DAMAGE = 1
```

Exemplos com `DEFENSE_K = 100`:

| Defesa | Redução aproximada |
|---:|---:|
| 0 | 0% |
| 25 | 20% |
| 50 | 33% |
| 100 | 50% |
| 200 | 67% |
| 300 | 75% |

A Defesa nunca chega matematicamente a 100% de redução.

`DEFENSE_K` deve ser configurável globalmente e poderá ser rebalanceado após testes.

---

## 4.3 Crítico

Padrão inicial:

```text
crit_chance base = 5%
crit_damage base = 1.50
```

Quando ocorre crítico:

```text
damage_after_crit = damage × crit_damage
```

Limite:

```text
0% <= crit_chance <= 100%
```

Não usar “chance acima de 100%” no sistema base.

---

## 4.4 Velocidade de ataque

`attack_speed` é medido em ataques por segundo.

```text
attack_interval = 1 / attack_speed
```

Exemplo:

```text
1.00 ataques/s = 1 ataque a cada 1.00 s
2.00 ataques/s = 1 ataque a cada 0.50 s
```

### Proteção de performance

```text
MIN_ATTACK_INTERVAL = 0.20 s
```

Logo, o máximo efetivo inicial é:

```text
5 ataques/s
```

Pode ser alterado posteriormente após profiling real no Android.

---

## 4.5 Skill Haste

Não usar Cooldown Reduction aditivo como status principal.

Usar:

```text
final_cooldown =
base_cooldown / (1 + skill_haste / 100)
```

Exemplos:

| Skill Haste | Cooldown de 10 s |
|---:|---:|
| 0 | 10.00 s |
| 50 | 6.67 s |
| 100 | 5.00 s |
| 200 | 3.33 s |

Isso gera retorno decrescente naturalmente.

Proteção inicial:

```text
MIN_SKILL_COOLDOWN = 0.25 s
```

---

## 4.6 Tenacidade

```text
final_control_duration =
base_duration / (1 + tenacity / 100)
```

Exemplo:

```text
Stun base = 2 s
Tenacidade = 100

Stun final = 1 s
```

Chefes podem receber Tenacidade muito alta em vez de imunidade total.

Imunidades duras devem ser exceção explícita.

---

# 5. Modificadores

Todo bônus ou penalidade deve virar um `StatModifier`.

## 5.1 Tipos permitidos

### `FLAT`

Soma/subtrai valor direto.

```text
+20 attack
-10 defense
+150 max_hp
```

### `ADD_PERCENT`

Percentuais do mesmo grupo são somados antes de multiplicar.

```text
+10% attack
+20% attack
= +30% attack
```

### `MULTIPLY`

Multiplicador separado.

Usar apenas para:

- skills especiais;
- passivas únicas;
- efeitos condicionais;
- itens lendários;
- mecânicas de alto impacto.

Exemplo:

```text
damage × 1.25 enquanto HP < 30%
```

Não transformar cada bônus em multiplicativo.

### `OVERRIDE`

Substitui um valor/regra.

Uso excepcional.

Exemplo:

```text
move_speed = 0 durante ROOT
```

Nunca usar `OVERRIDE` quando FLAT/PERCENT/MULTIPLY resolverem.

---

# 6. Ordem de cálculo obrigatória

```text
1. valor base
2. soma dos FLAT
3. soma dos ADD_PERCENT
4. produto dos MULTIPLY
5. OVERRIDE válido, quando aplicável
6. clamp/cap do status
7. valor final
```

A origem do bônus **não muda a matemática**.

Equipamento, buff, árvore global e passiva usam a mesma pipeline.

---

# 7. Fontes de modificadores

Todo modificador precisa conhecer sua origem.

```yaml
modifier:
  stat: attack
  operation: ADD_PERCENT
  value: 0.15
  source_type: EQUIPMENT
  source_id: sword_iron_001
```

`source_type` permitido:

```text
HERO_BASE
LEVEL
EQUIPMENT
AFFIX
PASSIVE
SKILL
GLOBAL_TREE
BLACKSMITH
ALCHEMIST
BUFF
DEBUFF
ENEMY_AFFIX
CHAPTER_RULE
DIFFICULTY
TEMPORARY_EVENT
```

Isso permite remover uma fonte sem tentar “desfazer” números manualmente.

---

# 8. Heróis

Todo herói usa o mesmo bloco:

```yaml
stats:
  max_hp: 100
  attack: 10
  defense: 10
  attack_speed: 1.0
  move_speed: 1.0
  crit_chance: 0.05
  crit_damage: 1.50
  skill_haste: 0
  tenacity: 0
```

Cada herói se diferencia por:

- valores-base;
- crescimento;
- ataque básico;
- skills;
- passivas;
- recursos próprios;
- sinergias;
- modificadores exclusivos.

**Não criar uma fórmula de status diferente para cada herói.**

---

# 9. Inimigos

Inimigos usam exatamente os mesmos IDs dos heróis.

```yaml
stats:
  max_hp: 80
  attack: 8
  defense: 5
  attack_speed: 0.8
  move_speed: 0.9
  crit_chance: 0
  crit_damage: 1.50
  skill_haste: 0
  tenacity: 0
```

Diferenças de Normal / Elite / Mini-chefe / Chefe devem ser aplicadas por **perfil de rank**, não por fórmulas paralelas.

Exemplo conceitual:

```yaml
rank_modifier:
  rank: ELITE
  max_hp: MULTIPLY
  attack: MULTIPLY
  defense: MULTIPLY
  tenacity: ADD_FLAT
```

Os números de cada rank serão definidos no documento de balanceamento.

---

# 10. Equipamentos

Equipamento **não possui um segundo sistema de atributos**.

Ele contém modificadores para o mesmo registro global.

Exemplo:

```yaml
item:
  id: sword_iron_001
  modifiers:
    - stat: attack
      operation: FLAT
      value: 12

    - stat: attack_speed
      operation: ADD_PERCENT
      value: 0.08
```

---

## 10.1 Affixes

Todo affix deve ser dado estruturado.

```yaml
affix:
  id: affix_attack_pct
  stat: attack
  operation: ADD_PERCENT
  roll:
    min: 0.05
    max: 0.10
```

Ferreiro, loot, upgrade e sistemas equivalentes manipulam esses mesmos affixes.

---

## 10.2 Stat Budget

Cada item deverá possuir um **orçamento de poder**.

Um item não pode simplesmente receber:

```text
+Ataque
+Crítico
+Velocidade
+Vida
+Defesa
+Haste
```

todos em valor máximo.

Cada status terá futuramente um `budget_weight`.

Exemplo conceitual:

```yaml
stat_budget:
  attack_flat: TBD
  attack_pct: TBD
  crit_chance: TBD
  attack_speed: TBD
```

Os pesos só serão congelados depois dos primeiros testes de combate.

---

# 11. Buffs e Debuffs

Buffs e debuffs devem usar um único objeto `StatusEffect`.

```yaml
status_effect:
  id: fury
  polarity: BUFF
  duration: 6.0
  duration_type: TIME
  max_stacks: 1
  stacking: REFRESH
  modifiers:
    - stat: attack
      operation: ADD_PERCENT
      value: 0.20
```

---

# 12. Campos obrigatórios de StatusEffect

```yaml
id:
display_name:
polarity:
tags:
duration_type:
duration:
max_stacks:
stacking:
source_id:
dispellable:
modifiers:
periodic_effect:
```

### `polarity`

```text
BUFF
DEBUFF
NEUTRAL
```

### `tags`

Exemplos:

```text
OFFENSIVE
DEFENSIVE
CONTROL
DOT
HOT
POISON
BLEED
BURN
MOVEMENT
CURSE
BLESSING
```

Tags servem para interações de skills e imunidades.

---

# 13. Regras de stacking

Todo efeito precisa declarar sua política.

## `REFRESH`

Não aumenta magnitude.

Reaplicar apenas reinicia duração.

Bom para buffs simples.

---

## `STACK`

Aumenta o número de stacks até `max_stacks`.

Todos usam a mesma duração compartilhada.

Bom para:

- marcas;
- cargas;
- efeitos de combo.

---

## `INDEPENDENT`

Cada aplicação possui timer próprio.

Bom principalmente para:

- bleed;
- poison;
- outros DOTs específicos.

Usar com cautela por custo de processamento.

---

## `REPLACE_STRONGER`

Só o efeito mais forte fica ativo.

Bom para:

- auras;
- bônus de mesma família;
- slows de várias fontes.

---

## `UNIQUE`

Só pode existir uma instância total.

Bom para efeitos especiais de boss ou estados exclusivos.

---

# 14. Tick de DOT/HOT

Nunca calcular DOT/HOT “por frame”.

Cada efeito possui seu próprio intervalo.

```yaml
periodic_effect:
  type: DAMAGE
  tick_interval: 1.0
  coefficient: 0.20
  scaling_stat: attack
```

Exemplo:

```text
20% do Ataque por segundo durante 5 s
```

O sistema precisa declarar se o valor é:

```text
SNAPSHOT
```

usa os status no momento da aplicação;

ou:

```text
DYNAMIC
```

recalcula a cada tick.

### Padrão

```text
DOT/HOT = SNAPSHOT
Auras = DYNAMIC
```

Isso evita resultados imprevisíveis.

---

# 15. Controles

Categorias recomendadas:

```text
STUN
ROOT
SLOW
KNOCKBACK
SILENCE
DISARM
```

Não criar um sistema diferente para cada controle.

Todos usam:

- tag;
- duração;
- tenacidade;
- política de imunidade;
- stacking.

### Regra para chefes

Preferir:

```text
tenacity alta
```

em vez de:

```text
immune_to_everything = true
```

Imunidade completa só quando necessária para a mecânica do encontro.

---

# 16. Catálogo inicial de Buffs

| ID | Efeito |
|---|---|
| `fury` | aumenta Ataque |
| `haste` | aumenta Velocidade de Ataque |
| `fortify` | aumenta Defesa |
| `precision` | aumenta Chance Crítica |
| `focus` | aumenta Skill Haste |
| `regeneration` | cura periódica |
| `barrier` | concede escudo |
| `unstoppable` | proteção temporária contra controles específicos |

Os valores pertencem às skills/itens que aplicam o efeito, não ao nome do efeito.

---

# 17. Catálogo inicial de Debuffs

| ID | Efeito |
|---|---|
| `weakness` | reduz Ataque |
| `armor_break` | reduz Defesa |
| `vulnerable` | aumenta Dano Recebido |
| `slow` | reduz Movimento e/ou Ataque conforme a fonte |
| `bleed` | DOT |
| `poison` | DOT empilhável |
| `burn` | DOT |
| `stun` | impede ação |
| `root` | impede movimento |
| `silence` | impede determinadas skills |

Cada aplicação precisa dizer exatamente o que faz.

Exemplo: `slow` não deve secretamente reduzir 3 status sem que a fonte declare isso.

---

# 18. Buff/debuff não deve alterar valor-base

Errado:

```text
hero.attack += 20
...
hero.attack -= 20
```

Correto:

```text
add_modifier(source=buff_123)
...
remove_modifiers(source=buff_123)
```

O valor-base permanece intacto.

---

# 19. Caps e limites

Valores iniciais de segurança:

| Status | Limite |
|---|---|
| `max_hp` | mínimo 1 |
| `attack` | mínimo 0 |
| `defense` | mínimo 0 |
| `attack_speed` | intervalo mínimo 0.20 s |
| `crit_chance` | 0–100% |
| `crit_damage` | mínimo 1.00× |
| `move_speed` | mínimo técnico > 0, exceto ROOT |
| `skill_haste` | mínimo -50; máximo técnico a definir |
| `life_steal` | cap inicial sugerido: 25% |
| cooldown | mínimo 0.25 s |

Caps de balanceamento podem mudar.

Caps de segurança/performance não podem ser ignorados por conteúdo comum.

---

# 20. Progressão

A progressão de nível não deve alterar a fórmula do sistema.

Ela apenas modifica os valores-base.

Exemplo:

```yaml
growth:
  max_hp_per_level: ...
  attack_per_level: ...
  defense_per_level: ...
```

### Recomendação

Usar crescimento de nível relativamente previsível e deixar saltos maiores de poder para:

- equipamento;
- raridade;
- capítulos;
- árvore global;
- ferreiro;
- alquimista;
- evolução do herói;
- dificuldade.

Evitar crescimento exponencial simultâneo em herói + item + inimigo + buff.

---

# 21. Dificuldade e capítulos

Dificuldade não cria versões duplicadas de inimigos.

Aplicar modificadores por camada.

```text
Enemy Base Stats
→ Level/Chapter
→ Rank
→ Difficulty
→ Enemy Affixes
→ Buffs/Debuffs
→ Final Stats
```

Assim o mesmo inimigo pode existir em várias dificuldades sem possuir arquivos quase idênticos.

---

# 22. Identidade dos heróis

Status dão **perfil**.

Skills e passivas dão **identidade**.

Exemplo conceitual:

```text
Tank:
HP ↑
Defense ↑
Attack Speed ↓

Assassino:
HP ↓
Attack ↑
Crit ↑
Attack Speed ↑

Mago:
Attack moderado
Skill Haste ↑
Skills com coeficientes altos
```

Não é necessário inventar 20 status exclusivos para diferenciar classes.

---

# 23. Regras para criação de novos status

Antes de adicionar um novo status, responder:

```text
1. Existe uma mecânica real que precisa dele?
2. O efeito não pode ser representado por um status existente?
3. Mais de uma fonte pode utilizá-lo?
4. O jogador entende seu efeito?
5. Ele cria uma decisão de build?
6. Ele consegue ser balanceado isoladamente?
```

Se a maioria for “não”, o novo status provavelmente não deve existir.

---

# 24. Dados e IDs

IDs nunca mudam por tradução.

Correto:

```text
attack
crit_chance
armor_break
```

A UI resolve:

```text
pt-BR → Ataque
en-US → Attack
```

Não salvar `"Ataque"` como identificador interno.

---

# 25. Precisão e arredondamento

Internamente:

```text
float
```

ou precisão equivalente.

Arredondar apenas na UI quando necessário.

Exemplo:

```text
interno: 17.4832
UI: 17.5
```

Nunca usar valores já arredondados como entrada para a próxima fórmula.

---

# 26. Debug obrigatório

Toda entidade deve permitir visualizar:

```text
STAT: attack

Base ................. 100
Espada ................ +20
Árvore Global ......... +10%
Buff Fury ............. +20%
Passiva Berserker ..... ×1.25
--------------------------------
Final ................. 195
```

Isso é requisito do sistema.

Sem breakdown por fonte, bugs de balanceamento serão muito difíceis de rastrear.

---

# 27. Combat Log técnico

Quando o modo debug estiver ativo:

```yaml
event:
  source: hero_01
  target: enemy_14
  action: basic_attack
  raw_damage: 120
  defense: 50
  damage_after_defense: 80
  critical: true
  final_damage: 120
  effects_applied:
    - bleed
```

O log não precisa aparecer para o jogador normal.

---

# 28. Testes mínimos obrigatórios

Antes de considerar o sistema pronto:

- [ ] adicionar/remover item retorna exatamente ao valor anterior;
- [ ] dois bônus `ADD_PERCENT` somam corretamente;
- [ ] `MULTIPLY` ocorre depois dos bônus aditivos;
- [ ] buff expirado remove apenas sua própria fonte;
- [ ] dois buffs iguais respeitam `stacking`;
- [ ] DOT usa timer e não frame;
- [ ] crítico respeita 0–100%;
- [ ] Defesa nunca gera dano negativo;
- [ ] Penetração não torna Defesa negativa;
- [ ] Skill Haste nunca gera cooldown zero;
- [ ] Attack Speed respeita intervalo mínimo;
- [ ] Tenacidade reduz controles corretamente;
- [ ] boss usa o mesmo sistema de status;
- [ ] equipamento usa IDs do registro canônico;
- [ ] save/load reconstrói o mesmo valor final;
- [ ] debug mostra todas as fontes do cálculo.

---

# 29. Anti-padrões proibidos

Não fazer:

```text
hero.attack += item.attack
```

Não criar:

```text
hero_attack
enemy_attack
item_attack
buff_attack
```

Não misturar:

```text
0.15
15
115
```

para representar “15%” em sistemas diferentes.

### Convenção

Percentuais internos usam decimal:

```text
15% = 0.15
100% = 1.00
```

Exceção:

`skill_haste` e `tenacity` são ratings e usam pontos inteiros/float de rating.

---

# 30. Estrutura recomendada de arquivos

```text
data/
└── stats/
    ├── STAT_REGISTRY.md
    ├── stat_definitions.*
    ├── status_effects.*
    ├── buff_catalog.*
    ├── debuff_catalog.*
    ├── balance_constants.*
    └── schemas/
        ├── stat_modifier.*
        └── status_effect.*
```

Documentação:

```text
docs/
└── systems/
    └── STATUS_SYSTEM_BASE.md
```

---

# 31. Contrato entre sistemas

Todos os sistemas futuros devem consumir esta base:

```text
HERÓIS
     ↓
INIMIGOS
     ↓
EQUIPAMENTOS
     ↓
SKILLS
     ↓
PASSIVAS
     ↓
ÁRVORE GLOBAL
     ↓
FERREIRO
     ↓
ALQUIMISTA
     ↓
BUFFS / DEBUFFS
     ↓
DIFICULDADE
     ↓
STATUS ENGINE
     ↓
FINAL STATS
```

Nenhum desses sistemas pode inventar uma pipeline paralela.

---

# 32. Decisões congeladas na v1

- Um registro único de status.
- Heróis e inimigos compartilham os mesmos IDs.
- Equipamentos fornecem modificadores.
- Buffs/debuffs fornecem modificadores/efeitos temporários.
- Base e valor final ficam separados.
- Percentuais comuns são aditivos.
- Multiplicadores são especiais e raros.
- Defesa usa retorno decrescente.
- Skill Haste substitui CDR aditivo.
- Tenacidade reduz duração de controle.
- Não usar STR/DEX/INT/VIT como camada universal.
- Não usar Hit Chance/Evasion como sistema universal na v1.
- DOT/HOT não atualiza por frame.
- Toda origem precisa de `source_id`.
- Todo status novo precisa entrar no registro canônico.
- Todo cálculo final deve ser explicável no debug.

---

# 33. Pontos ainda ajustáveis por playtest

Estes valores NÃO são contratos permanentes:

```text
DEFENSE_K
MIN_ATTACK_INTERVAL
MIN_SKILL_COOLDOWN
life_steal cap
crescimento por nível
budget de affixes
multiplicadores de dificuldade
multiplicadores de Normal/Elite/Mini-chefe/Chefe
valores-base de cada herói
valores-base de cada inimigo
```

A arquitetura fica fixa.

Os números ficam ajustáveis.

---

# 34. Próximos documentos derivados

A partir desta base, criar separadamente:

1. `HERO_STATS_BALANCE.md`
2. `ENEMY_STATS_BALANCE.md`
3. `EQUIPMENT_AFFIXES.md`
4. `BUFF_DEBUFF_CATALOG.md`
5. `COMBAT_FORMULAS.md`
6. `DIFFICULTY_SCALING.md`
7. `STAT_BUDGETS.md`
8. `STATUS_SYSTEM_SCHEMA.md`

Esses documentos devem referenciar esta base e nunca contradizê-la.

---

# 35. Resumo executivo

O sistema deve ser simples de entender e difícil de quebrar:

```text
STATUS BASE
     +
MODIFICADORES
     ↓
FINAL STATUS
     ↓
COMBATE
```

A complexidade do jogo deve vir de:

- combinações;
- skills;
- passivas;
- equipamentos;
- affixes;
- builds;
- buffs/debuffs;
- inimigos;
- bosses;
- sinergias;

e não de dezenas de atributos quase iguais.

**Este arquivo é a fonte de verdade estrutural para qualquer sistema que altere números de combate ou progressão.**
