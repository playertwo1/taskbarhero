# EQUIPMENT_BALANCE.md

> **Versão:** 0.1  
> **Slots oficiais:** 6  
> **Slots:** Arma, Secundário, Armadura, Acessório I, Acessório II, Eco

---

# 1. Objetivo

Equipamento deve:

- alterar build;
- oferecer escolhas;
- complementar o herói;
- criar especializações;
- nunca substituir completamente o kit do herói.

Poder do personagem vem de:

```text
HERÓI
+ SKILLS/PASSIVAS
+ EQUIPAMENTO
+ PROGRESSÃO GLOBAL
```

e não exclusivamente de loot.

---

# 2. Stat Budget

Todo item possui `Budget Points` (`BP`).

BP é ferramenta interna.

Não aparece para o jogador.

## Equivalência inicial de 1 BP

Para status flat, usar o `HERO_REFERENCE` do nível do item:

| Status | 1 BP |
|---|---:|
| Attack flat | 1.0% do REF_ATTACK |
| Max HP flat | 1.0% do REF_HP |
| Defense flat | 1.0% do REF_DEF |
| Attack Speed | +0.60% |
| Crit Chance | +0.35 p.p. |
| Crit Damage | +1.50 p.p. |
| Skill Haste | +1.20 |
| Tenacity | +1.50 |
| Move Speed | +0.50% |

Isso mantém o orçamento válido no nível 1 e no 100.

---

# 3. Budget por raridade

Nomes podem ser reloreados posteriormente; os valores são a regra importante.

| Raridade | BP base | Affixes típicos |
|---|---:|---:|
| Comum | 2 | 1 |
| Incomum | 3 | 2 |
| Raro | 4 | 2–3 |
| Épico | 5 | 3–4 |
| Lendário | 6 | 3–4 + efeito único |

Lendário não deve simplesmente ter “mais de tudo”.

Parte do BP deve financiar o efeito único.

---

# 4. Multiplicador por slot

| Slot | Budget Mult. | Vocação |
|---|---:|---|
| Arma | ×1.20 | ofensivo |
| Secundário | ×1.00 | híbrido |
| Armadura | ×1.20 | defensivo |
| Acessório I | ×0.90 | flexível |
| Acessório II | ×0.90 | flexível |
| Eco | ×1.00 | build/efeito especial |

Exemplo:

```text
Arma Épica:
5 BP × 1.20 = 6 BP efetivos
```

---

# 5. Poder total do conjunto

Conjunto completo de raridade equivalente deve fornecer aproximadamente:

```text
Comum:      ~12 BP ponderados
Incomum:    ~19 BP
Raro:       ~25 BP
Épico:      ~31 BP
Lendário:   ~37 BP
```

Como os BP serão distribuídos entre vários status, um conjunto lendário normal deve gerar ganho real total aproximadamente na faixa:

```text
+30% a +45%
```

sobre o personagem nu de mesmo nível.

Não permitir que equipamento multiplique o poder total por 3× ou 5× no mesmo tier.

---

# 6. Regras por slot

## Arma

Prioriza:

- Attack;
- Crit;
- Attack Speed;
- Penetração;
- efeitos ofensivos.

No máximo 25% do budget pode ser dedicado puramente a defesa.

## Secundário

Pode ser:

- defesa;
- ataque;
- recurso;
- skill;
- invocação;
- híbrido.

É o slot de maior flexibilidade.

## Armadura

Prioriza:

- HP;
- Defense;
- Tenacity;
- sustain;
- mitigação.

No máximo 25% do budget em dano bruto.

## Acessórios

Especialização:

- Crit;
- Haste;
- buffs;
- healing;
- status;
- recurso;
- build mechanics.

## Eco

Slot de identidade.

Regra:

```text
máximo 50% do BP em status brutos
mínimo 50% reservado para efeito/build
```

Eco deve criar decisão de gameplay.

---

# 7. Affix tiers

Affixes usam potência relativa ao BP.

```text
T1 = 80% do valor nominal
T2 = 90%
T3 = 100%
T4 = 110%
```

Um tier maior consome mais Item Power/raridade disponível.

Não usar rolls de 20%–100%; isso gera lixo demais.

Faixa curta facilita comparar itens.

---

# 8. Reforço — Ferreiro

Reforço aumenta gradualmente o budget existente.

Baseline:

```text
+1 a +5
```

Cada nível:

```text
+2% do poder de status base do item
```

Total em +5:

```text
~+10%
```

Reforço não adiciona novo affix aleatório.

---

# 9. Reforja

Reforja altera:

```text
um affix por vez
```

Regras:

- mantém raridade;
- mantém orçamento total;
- respeita famílias permitidas pelo slot;
- nunca duplica affix proibido;
- custo sobe com tentativas;
- resultado deve mostrar antes/depois.

---

# 10. Desmontagem

Retorno de material depende de:

```text
raridade
Item Power
nível de reforço
```

Nunca devolver 100% do investimento.

Valor inicial:

```text
material-base: 25–40%
material de reforço: 50–70%
```

Valores econômicos serão calibrados separadamente.

---

# 11. Alquimista

Não cria status paralelos.

Consumíveis aplicam `StatusEffect`.

Transmutação pode:

- converter materiais;
- criar Essências;
- criar Catalisadores;
- produzir consumíveis;
- alterar famílias permitidas em receitas especiais.

---

# 12. Anti-BiS universal

Se um affix aparecer em:

```text
>70% das builds testadas
```

é sinal de que:

- está forte demais;
- outros affixes estão fracos;
- ou é uma necessidade estrutural que deveria pertencer ao herói/sistema.

Nenhum único atributo deve dominar todos os slots.

---

# 13. Caps de equipamento

Recomendação inicial apenas para contribuição de EQUIPAMENTO:

```text
Crit Chance adicional:    +35 p.p.
Attack Speed adicional:   +60%
Move Speed adicional:     +25%
Life Steal total:         25%
Skill Haste do gear:      +80
```

Outras fontes ainda passam pelo cap final definido no sistema de status.

---

# 14. QA de item

- [ ] budget correto;
- [ ] slot permitido;
- [ ] affixes permitidos;
- [ ] sem duplicação proibida;
- [ ] efeito único possui custo;
- [ ] não é BiS para todos;
- [ ] reforço preserva budget;
- [ ] reforja preserva budget;
- [ ] tooltip mostra valor real;
- [ ] breakdown identifica source_id.
