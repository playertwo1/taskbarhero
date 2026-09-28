# STAT_BUDGETS.md

> **Versão:** 0.1  
> **Uso:** ferramenta interna de balanceamento.

---

# 1. Por que existe

Números diferentes não têm o mesmo valor real.

Exemplo:

```text
+10 HP
+10% Crit
```

não podem custar igual.

O Budget converte efeitos para uma moeda comum aproximada.

---

# 2. Budget Point

`BP` é uma unidade abstrata.

### Equipamento — 1 BP

| Stat | Valor |
|---|---:|
| Attack flat | 1.0% REF_ATTACK |
| HP flat | 1.0% REF_HP |
| Defense flat | 1.0% REF_DEF |
| Attack Speed | 0.60% |
| Crit Chance | 0.35 p.p. |
| Crit Damage | 1.50 p.p. |
| Skill Haste | 1.20 |
| Tenacity | 1.50 |
| Move Speed | 0.50% |

Valores são v0.1 e devem ser recalibrados por simulação.

---

# 3. Efeitos condicionais

Aplicar desconto pelo uptime.

```text
budget_real =
budget_if_active × expected_uptime
```

Exemplo:

```text
efeito equivalente a 8 BP
ativo ~50% do tempo

budget real ≈ 4 BP
```

Burst pode justificar prêmio adicional.

---

# 4. Proc chance

```text
expected_value =
proc_value
× proc_chance
× triggers_per_second
× useful_fraction
```

Nunca balancear proc apenas olhando “20% de chance”.

Attack Speed muda drasticamente o número real de procs.

---

# 5. AoE

Valor esperado:

```text
effective_coefficient =
coefficient_per_target
× expected_targets
```

Usar número de alvos realista.

Não balancear AoE supondo 10 inimigos se encontros normais têm 3.

Baseline de teste:

```text
single = 1 alvo
small AoE = 3 alvos
large AoE = 5 alvos
```

---

# 6. Controle

Hard CC possui custo alto.

Valor depende de:

```text
duração
uptime
alvos
Tenacidade esperada
dano perdido para aplicá-lo
```

Não converter stun em BP fixo sem contexto.

---

# 7. Cura e escudo

Avaliar por:

```text
effective_health_generated
/
janela de tempo
```

Overheal não conta como valor integral.

Shield expirado sem ser consumido também não.

---

# 8. Lendários

Efeito lendário deve consumir orçamento.

Classificação inicial:

```text
efeito pequeno      = 1–2 BP
efeito médio        = 2–3 BP
build-defining      = 3–4 BP
```

Se o efeito não puder ser expresso com segurança em BP:

```text
simular
```

e ajustar pelo resultado.

---

# 9. Árvore dos Ecos

Progressão global deve ter orçamento total limitado.

Meta inicial para bônus de combate permanentes da árvore:

```text
~10–20% de poder real
```

quando uma seção relevante estiver bem desenvolvida.

A árvore também deve oferecer:

- economia;
- crafting;
- qualidade de vida;
- jornada;
- memória;

para não virar apenas “mais dano”.

---

# 10. Ferreiro e Alquimista

Ferreiro manipula budget existente.

Alquimista manipula:

- efeitos temporários;
- materiais;
- conversões.

Nenhum deve criar multiplicação infinita de BP.

---

# 11. Red flags

Rebalancear se:

```text
1 stat >70% de presença em builds
1 item >60% de uso no mesmo slot
1 passiva >80% de escolha
1 skill >80% de equip rate
1 build >20% mais rápida em conteúdo neutro
```

Esses números são gatilhos de investigação, não nerf automático.
