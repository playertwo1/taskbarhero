---
document_type: balance-domain
id: BALANCE_V1_01_STATUS_E_COMBATE
version: "1.0"
status: DESIGN
certainty: DESIGN
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO]
---

# 01 — Status e regras de combate

Arquitetura do combate compartilhada por heróis, inimigos, itens, passivas, Árvore, artesãos e efeitos. **A arquitetura é DECIDIDA** (herdada da base de status v1.0 e mantida); os números marcados são HIPÓTESE ajustável por playtest. Implementação: [`CombatMath.gd`](../../../scripts/combat/CombatMath.gd), [`ExpeditionRun.gd`](../../../scripts/combat/ExpeditionRun.gd), [`BalanceProfiles.gd`](../../../scripts/combat/BalanceProfiles.gd).

## 1. Registro único de status

Heróis e inimigos usam os mesmos IDs. Sem STR/DEX/INT/VIT, sem precisão/esquiva universais.

| Grupo | IDs | Regra |
| --- | --- | --- |
| Núcleo (obrigatório) | `max_hp`, `attack`, `defense`, `attack_speed`, `move_speed`, `crit_chance`, `crit_damage`, `skill_haste`, `tenacity` | base de todas as entidades |
| Condicional | `armor_pen_flat`, `armor_pen_pct`, `damage_bonus`, `damage_taken`, `life_steal`, `healing_power`, `healing_received`, `shield_power`, `status_power`, `status_resistance`, `range` | só entra com mecânica concreta e mais de uma fonte real |
| Progressão/loot | `xp_gain`, `gold_find`, `loot_find`, `loot_quality` | nunca entram na fórmula de dano; raros em equipamento de combate |

- **Status ≠ estado de combate:** `max_hp` é status; `current_hp`, `current_shield`, recurso de herói, stacks e recargas restantes são estado.
- **Status novo** só se todas estas forem "sim": existe mecânica real; nenhum status atual representa; mais de uma fonte usa; o jogador entende; cria decisão de build; é balanceável isolado.
- Não crescem por nível: `attack_speed`, `move_speed`, `crit_chance`, `crit_damage`, `skill_haste`, `tenacity`. Crescem por item, passiva, Trait, Árvore e buff.

## 2. Pipeline de modificadores

```text
final = CLAMP( (base + ΣFLAT) × (1 + ΣADD_PERCENT) × ΠMULTIPLY → OVERRIDE , min, max )
```

- `ADD_PERCENT` do mesmo status somam antes de multiplicar. `MULTIPLY` é raro (skills especiais, capstones, Relíquias, efeitos condicionais). `OVERRIDE` é exceção (ex.: movimento 0 durante ROOT).
- Todo modificador tem `source_type` e `source_id`. Tipos: `HERO_BASE`, `LEVEL`, `EQUIPMENT`, `AFFIX`, `PASSIVE`, `SKILL`, `GLOBAL_TREE`, `BLACKSMITH`, `ALCHEMIST`, `BUFF`, `DEBUFF`, `ENEMY_AFFIX`, `CHAPTER_RULE`, `DIFFICULTY`, `TEMPORARY_EVENT`.
- Buff/debuff nunca altera o valor-base: adiciona e remove modificadores pela fonte.
- Ordem das camadas do inimigo: referência → arquétipo → rank → nível do conteúdo → dificuldade → affix → efeitos temporários.
- **Debug obrigatório:** breakdown de cada status por fonte; combat log técnico com bruto, defesa, crítico, final e efeitos.

## 3. Fórmulas

```text
ataque básico      bruto = attack
skill              bruto = attack × coeficiente (+ componente fixo raro; preferir coeficiente)
dano médio         attack × (1 + crit_chance × (crit_damage − 1))
DPS básico         dano médio × attack_speed
defesa efetiva     max(0, defense × (1 − armor_pen_pct) − armor_pen_flat)
mitigação          def_efetiva / (def_efetiva + DEFENSE_K)          DEFENSE_K = 100 × combat_scale
resistência        × (1 − resistência do tipo)                       após a defesa
dano final         max(MIN_DAMAGE, bruto × (1 − mitigação) × (1 − resist) × damage_taken)
                   MIN_DAMAGE = 1 × combat_scale
EHP                max_hp / (1 − mitigação)
recarga            base / (1 + skill_haste/100)
controle           duração_base / (1 + tenacity/100)
cura               base × (1 + healing_power) × (1 + healing_received)   sem crítico por padrão
escudo             base × (1 + shield_power); consumido antes do HP
DOT/HOT            efeito total = status × coeficiente total; tick = total / nº de ticks
```

Ordem da redução de dano: bruto → defesa/penetração → resistência de tipo → `damage_taken` → mitigação especial (rara) → escudo → HP. DOT/HOT fazem snapshot; auras são dinâmicas. DOT não crita salvo `can_crit: true`. Sem cálculo por frame.

Crítico base: 5% de chance e 1,5× de dano. RNG sempre com seed disponível em debug/teste (crítico, procs, loot, affixes, IA).

## 4. Caps

| Status/efeito | Limite | Tipo |
| --- | --- | --- |
| `crit_chance` | 0–100% | segurança |
| `crit_damage` | mínimo 1,0× | segurança |
| intervalo de ataque | mínimo 0,20 s (máx. 5 golpes/s) | segurança/performance |
| recarga de skill | mínimo 0,25 s | segurança |
| `skill_haste` | mínimo −50 | segurança |
| `damage_taken` final | mínimo 0,25 (redução máxima 75%) | balanceamento (`combat_core.stat_caps`) |
| `life_steal` total | 25% | balanceamento |
| Resistência de tipo | −50% a +75%; imunidade só por flag explícita | balanceamento |
| Vulnerabilidade somada | +25% de dano recebido | balanceamento |
| Quebra de armadura somada | −50% de defesa | balanceamento |
| Lentidão de movimento / de ataque somadas | −50% / −40% | balanceamento |
| Escudos comuns acumulados | 50% do HP máximo (Signature pode exceder se declarar) | balanceamento |
| Invocações ativas | 3 por herói | performance |

Caps de segurança não são ignorados por conteúdo comum; caps de balanceamento mudam só com decisão registrada. Tetos de sinergia entre aliados: [00 §5](00_CONSTITUICAO.md#5-poder-da-party-e-teto-de-sinergia).

## 5. Tipos de dano

| Tipo | Uso | Status associado |
| --- | --- | --- |
| Físico | armas, projéteis, impacto | Sangramento |
| Arcano (Lúmen) | Íris, runas, energia | DOT arcano |
| Fogo | Brasa, explosões | Queimadura |
| Tóxico | venenos, corrosão | Veneno |
| Verdadeiro | ignora mitigação comum; raríssimo (custo de vida, execução, script de chefe) | — |

- Defesa é universal; resistência é uma segunda camada leve, só para identidade de conteúdo. Não existem defesas por tipo.
- Nenhum inimigo comum exige um tipo; chefe pode favorecer tipos, sempre com contrajogo. Evitar resistência alta em 3–4 tipos ao mesmo tempo.
- Toda skill e DOT declara `damage_type`.

## 6. Buffs, debuffs e efeitos

Um único objeto `StatusEffect` com: `id`, `polarity` (`BUFF`/`DEBUFF`/`NEUTRAL`), `tags`, `duration_type`, `duration`, `max_stacks`, `stacking`, `source_id`, `dispellable`, `modifiers`, `periodic_effect`.

**Bandas de potência de buff (herdado; HIPÓTESE):**

| Banda | Potência | Duração |
| --- | ---: | ---: |
| Menor | +8–12% | 8–15 s |
| Padrão | +15–20% | 5–10 s |
| Maior | +25–35% | 3–6 s |
| Signature | +40–60% | 2–4 s ou condicional |

- Valor real = magnitude × uptime (ex.: +30% por 5 s a cada 15 s ≈ +10%). Quanto maior o uptime, menor o número.
- Buffs de referência: Fúria +15–25% ATK; Pressa +15–25% AS; Fortificar +20–30% DEF; Precisão +8–15 p.p. de crítico; Foco +20–35 Haste; Regeneração 2–4% HP/s; Barreira 10–25% HP em escudo; Imparável (imunidade específica e curta).
- Debuffs de referência: Fraqueza −10–20% ATK; Quebra de armadura −15–25% DEF; Vulnerável +10–15% dano recebido; Lento −15–30% movimento; Ataque lento −10–20% AS; Atordoar 0,5–1,25 s; Enraizar 1–2,5 s; Silenciar 1–2 s.
- DOT: normal 0,8–1,6×ATK no total; de build especializada 1,5–2,5×ATK com setup; Signature 2,5–4×ATK com recarga alta. Sangramento curto/físico; Veneno longo/acumulável; Queimadura médio/forte/área.
- Cura instantânea normal: 8–18% do HP máximo; grande (20–35%) exige recarga alta, condição, recurso ou risco.
- **Stacking:** buffs comuns `REFRESH`; marcas/cargas `STACK`; DOTs específicos `INDEPENDENT` só se necessário; auras `REPLACE_STRONGER`; estados exclusivos `UNIQUE`.
- **Dispel:** todo efeito declara `dispellable`; não-dispelável é exceção. Mecânicas fundamentais de chefe são `NEUTRAL`.

## 7. Postura (Stagger)

Segunda barra além do HP. Valores atuais em `combat_core.stagger` (HIPÓTESE, meio das faixas herdadas).

| Rank | Postura | Quebra | Vulnerável durante quebra | Imunidade após quebra |
| --- | ---: | ---: | ---: | ---: |
| Normal | 100 | 1,5–2,5 s | +15% | 2 s |
| Elite | 180 | 1,5–2,0 s | +15% | 2 s |
| Minichefe | 350 | 1,0–1,75 s | +15% | 3 s |
| Chefe | 600+ | 0,75–1,5 s | +10% | 3–5 s |

- Dano de postura por ação: golpe rápido 5–10, comum 10–20, pesado 20–35, skill forte 25–45, skill de postura 40–70.
- Recupera 10%/s após 3 s sem sofrer postura. Tenacidade não reduz a quebra. Invocações causam 50% da postura.
- `interrupt_power` (`NONE`/`LIGHT`/`HEAVY`) interrompe conjuração sem quebrar a barra.
- Bastião é a referência de postura: utilidade ofensiva sem DPS alto.

## 8. Controle em chefes

Chefes usam Tenacidade (+100 por rank) em vez de imunidade. Cada controle forte recebido nos últimos 8 s dá +25 de Tenacidade temporária (máx. +100). Controle nunca é inútil nem permite travar o chefe para sempre.

## 9. Ameaça (aggro)

- 1 de dano efetivo = 1 de ameaça; cura efetiva e escudo consumido = 0,5; overheal e escudo expirado = 0.
- Multiplicador por entidade (`threat_generation`, padrão 1,0; Bastião 1,5 com efeitos defensivos ativos; perfis em `combat_core.threat_profiles`).
- Provocar é um estado (`TAUNT`, alvo forçado por uma duração), não "muita ameaça". Chefes reduzem a duração por Tenacidade; ataques roteirizados podem ignorar ameaça se declararem.
- Troca de alvo só se a nova ameaça superar a atual em 15%. Empate dentro da tolerância favorece o herói mais à frente. Ameaça não decai em combate.

## 10. Recursos de herói

Um único motor: `id`, `current`, `max`, `min`, `generation_mode`, `decay_mode`, `decay_rate`, `persist_between_combats`, `overflow_policy` (padrão `CLAMP`). Operações: `ADD`, `SPEND`, `SET`, `FILL`, `DRAIN`, `LOCK`, `UNLOCK`; nunca editar direto.

| Herói | Recurso | Faixa | Ganha por | Gasta em |
| --- | --- | --- | --- | --- |
| Bastião | Guarda | 0–100 | bloquear/absorver, proteger, provocar | defesa, retaliação, fortalecimento |
| Flecha | Foco | 0–100 | atacar sem sofrer dano, acertar Marca, crítico | disparos fortes; perde parte com golpe pesado |
| Íris | Lúmen | 0–100 | usar skills, acertar vários alvos | amplificação, controle, Signature |
| Brasa | Fúria | 0–100 | atacar, sofrer dano, Queimadura | picos de dano; decai fora de combate |
| Véu | Sombra | 0–100 | crítico, execução, alvo marcado | mobilidade, burst, fuga |
| Orvalho | Sementes | 0–5 cargas | cura efetiva, regeneração | cura forte, proteção |
| Forja | Sucata | 0–100 | dano de construtos, destruição de invocação | sentinelas, armadilhas, sobrecarga |
| Sino | Ritmo + Ressonância | 0–100 + 0–3 | cadência / picos | buffs e janelas de burst |

Recurso nunca é "mana genérica": precisa mudar decisão (guardar, gastar para sobreviver, manter ritmo). Não persiste entre combates salvo exceção declarada. Orçamento de geração/decaimento: [03 §6](03_SKILLS_PASSIVAS.md#6-recurso-e-ia-de-uso).

## 11. Invocações e companheiros

- Usam o mesmo motor de status e herdam do dono (padrão Forja: HP 35%, ATK 40%, DEF 50%, crítico 100% do dono). Status em snapshot na invocação.
- **Dano do herói + dano das invocações = orçamento total do herói.** Invocação não é dano extra grátis (Forja: 40–60% do DPS pode vir de construtos).
- Não herdam procs do dono sem `applies_to_summons: true`. Kill da invocação conta para o dono (XP, loot); passivas `ON_KILL` declaram se incluem invocações.
- Ao morrer: remover modificadores, ameaça, colisão e efeitos periódicos.

## 12. Eventos canônicos e dependências

Eventos: `DAMAGE_DEALT`, `DAMAGE_TAKEN`, `HEAL_APPLIED`, `SHIELD_APPLIED`, `STATUS_APPLIED`, `STATUS_REMOVED`, `RESOURCE_CHANGED`, `STAGGER_DAMAGED`, `STAGGER_BROKEN`, `SUMMON_CREATED`, `SUMMON_REMOVED`, `TARGET_CHANGED`, `SKILL_CAST`, `ENTITY_KILLED`, `PHASE_CHANGED`. Um sistema dependente lê, emite evento ou pede operação; nunca edita estado interno de outro sistema. A telemetria observa e nunca altera o combate.

## 13. Testes mínimos do motor

Adicionar e remover item volta ao valor anterior; `ADD_PERCENT` somam; `MULTIPLY` vem depois; buff expirado remove só a própria fonte; stacking respeitado; DOT por timer; crítico em 0–100%; defesa nunca gera dano negativo; penetração não deixa defesa negativa; Haste nunca zera recarga; intervalo mínimo de ataque; Tenacidade reduz controle; chefe usa o mesmo sistema; save/load reconstrói o mesmo valor final; mesma seed e velocidade ×1 ou ×4 dão o mesmo resultado; `combat_scale` 1× e 10× dão o mesmo resultado (`tests/unit/test_combat_scale.gd`).
