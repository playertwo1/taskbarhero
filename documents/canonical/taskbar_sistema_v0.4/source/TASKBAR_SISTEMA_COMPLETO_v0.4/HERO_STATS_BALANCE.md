# HERO_STATS_BALANCE.md

> **Versão:** 0.1 — First Playable Balance  
> **Dependência:** `STATUS_SYSTEM_BASE.md`  
> **Objetivo:** estabelecer a régua inicial de poder dos 8 heróis sem substituir a identidade criada por skills, passivas e Traits.

---

## 1. Regra de progressão 1–100

Os status que crescem por nível usam interpolação linear:

```text
T = (level - 1) / 99

stat(level) =
base_level_1
+ (target_level_100 - base_level_1) × T
```

Arredondamento é apenas de UI.

### Não crescem automaticamente por nível

```text
attack_speed
move_speed
crit_chance
crit_damage
skill_haste
tenacity
```

Esses valores crescem por:

- equipamento;
- passivas;
- Traits/builds;
- Árvore dos Ecos;
- buffs;
- efeitos específicos.

Isso reduz power creep e mantém loot relevante até o final.

---

## 2. Tabela-base dos 8 heróis

| Herói | Papel | HP L1→L100 | ATK L1→L100 | DEF L1→L100 | AS | MS | Crit | Crit DMG | Haste | Tenacidade |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Bastião | Tank / Protector | 160 → 700 | 10 → 42 | 18 → 80 | 0.80 | 0.92 | 3% | 1.50× | 0 | 20 |
| Flecha | Ranged DPS | 100 → 380 | 14 → 60 | 7 → 28 | 1.20 | 1.08 | 10% | 1.60× | 0 | 0 |
| Íris | Mage / Control | 95 → 360 | 15 → 63 | 6 → 25 | 0.90 | 1.00 | 5% | 1.50× | 15 | 0 |
| Brasa | Bruiser / Berserker | 140 → 600 | 13 → 55 | 12 → 50 | 1.00 | 1.00 | 5% | 1.50× | 0 | 10 |
| Véu | Assassin | 90 → 330 | 15 → 60 | 5 → 22 | 1.25 | 1.12 | 10% | 1.65× | 5 | 0 |
| Orvalho | Healer / Support | 110 → 440 | 9 → 42 | 8 → 32 | 0.95 | 1.00 | 3% | 1.50× | 20 | 5 |
| Forja | Engineer / Summoner | 120 → 500 | 11 → 48 | 10 → 38 | 0.90 | 0.95 | 5% | 1.50× | 10 | 5 |
| Sino | Buffer / Tempo | 105 → 430 | 10 → 40 | 9 → 35 | 1.00 | 1.03 | 5% | 1.50× | 18 | 10 |

---

## 3. Perfil esperado por herói

### Bastião

Maior EHP do elenco; dano básico baixo. Escudo, proteção, provocação, retaliação e controle compensam.

### Flecha

DPS sustentado alto; depende de distância, Marca e crítico. Pouca margem defensiva.

### Íris

Ataque básico mediano; maior orçamento em skills, área, Lúmen e controle.

### Brasa

Boa combinação de EHP e dano; picos de poder devem depender de Fúria/HP baixo.

### Véu

Maior pressão de alvo único e execução; EHP mínimo e dependência de janela/posicionamento.

### Orvalho

Dano básico baixo; orçamento migra para cura, Sementes, sustain e utilidade.

### Forja

Dano pessoal abaixo da média; Sentinelas/armadilhas/autômatos completam o DPS.

### Sino

Dano direto baixo; Ritmo/Ressonância/Memória transferem poder para buffs e janelas de burst.

---

## 4. Envelope de poder

Os heróis não precisam ter o mesmo DPS básico.

O que deve permanecer próximo é a **capacidade de completar conteúdo solo equivalente** quando o kit completo é considerado.

### Meta de combate sustentado — janela de 30 s

Após incluir ataque básico + 2 skills equipadas + passivas relevantes:

```text
85%–115% do HERO_REFERENCE
```

é a faixa normal para dano sustentado.

Exceções justificadas:

- Bastião pode ficar abaixo em DPS por EHP/controle;
- Orvalho pode ficar abaixo por cura/sustain;
- Sino pode ficar abaixo por buffs/utilidade;
- Véu pode ultrapassar temporariamente em alvo único, mas não em dano sustentado + sobrevivência ao mesmo tempo.

### Nenhum herói pode:

- matar chefe equivalente >25% mais rápido que todos os outros sem contrapartida;
- sobreviver indefinidamente sem perder dano/recursos;
- atingir melhor AoE + melhor single target + melhor sustain simultaneamente.

---

## 5. Regra de especialização

Cada build pode empurrar **2 eixos principais** e, no máximo, **1 eixo secundário**.

Eixos:

```text
DANO
SOBREVIVÊNCIA
CONTROLE
CURA/SUPORTE
MOBILIDADE
ECONOMIA/RECURSO
```

Exemplo:

```text
Bastião / Guardião:
SOBREVIVÊNCIA + SUPORTE
CONTROLE secundário
```

Evitar build que maximiza 4–5 eixos.

---

## 6. Skills — orçamento inicial

### Ataque básico

```text
coefficient = 1.00 × attack
```

### Skill normal — alvo único

```text
1.60–2.40 × attack
cooldown típico: 6–12 s
```

### Skill normal — área

```text
1.00–1.60 × attack por alvo
cooldown típico: 8–14 s
```

### Skill com controle forte

```text
0.70–1.30 × attack
+
controle
```

Quanto maior o controle, menor deve ser o dano direto.

### Cura normal

```text
1.30–2.00 × scaling_stat
cooldown típico: 8–14 s
```

### Signature

```text
single target: 3.00–5.00 × attack
AoE:          2.00–3.25 × attack por alvo
cooldown típico: 30–60 s
```

Signature de suporte pode trocar dano por:

- cura;
- escudo;
- controle;
- buff;
- reset parcial;
- invocação.

---

## 7. Regra das 2 skills equipadas

Como o combate usa 2 slots de skill:

- nenhuma combinação de 2 skills pode ser obrigatória para todas as builds;
- cada build precisa de pelo menos 3 combinações viáveis;
- uma skill não deve fornecer simultaneamente dano máximo + defesa máxima + controle máximo;
- Signature deve competir com outro ativo forte quando ocupar slot, caso essa seja a regra final de loadout.

---

## 8. Passivas

As 16 passivas de cada herói devem usar orçamento em bandas.

### Pequena

```text
~3–5% de ganho real de poder
```

### Média

```text
~6–9%
```

### Maior / build-defining

```text
~10–15%
```

Ganho deve ser calculado em resultado de combate, não apenas lendo o percentual escrito.

Passivas condicionais podem ter número maior porque não ficam ativas 100% do tempo.

---

## 9. Traits / builds

Cada um dos 3 caminhos deve alcançar desempenho total semelhante, mas por mecanismos diferentes.

Meta:

```text
diferença de clear time entre builds igualmente equipadas:
<= 15% em conteúdo neutro
```

Conteúdo favorável pode gerar diferenças maiores.

---

## 10. Bastião como Golden Reference

Bastião é a referência dourada de implementação do sistema:

- dados completos;
- IDs estáveis;
- breakdown de status;
- testes;
- passivas;
- skills;
- equipamento;
- save/load.

**Golden Reference não significa herói mais forte.**

Significa implementação mais completa para validar os demais.

---

## 11. Testes obrigatórios

- [ ] simular L1, L25, L50, L75 e L100;
- [ ] calcular EHP;
- [ ] calcular Basic DPS;
- [ ] calcular Sustained DPS 30 s;
- [ ] calcular Burst 5 s;
- [ ] comparar clear time;
- [ ] testar sem equipamento;
- [ ] testar equipamento médio;
- [ ] testar equipamento máximo razoável;
- [ ] testar cada uma das 3 builds;
- [ ] testar combinações das 2 skills;
- [ ] nenhum herói fora do envelope sem justificativa documentada.

---

## 12. Valores de playtest

Os números deste arquivo são **baseline v0.1**.

Podem mudar.

Não podem mudar sem registrar:

```text
valor anterior
valor novo
motivo
teste usado
impacto esperado
```
