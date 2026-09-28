# BUFF_DEBUFF_BALANCE.md

> **Versão:** 0.1  
> **Dependência:** `STATUS_SYSTEM_BASE.md`

---

# 1. Bandas de potência

## Buff de status

| Banda | Potência típica | Duração típica |
|---|---:|---:|
| Minor | +8–12% | 8–15 s |
| Standard | +15–20% | 5–10 s |
| Major | +25–35% | 3–6 s |
| Signature | +40–60% | 2–4 s / condicional |

Quanto maior uptime, menor o número.

---

# 2. Uptime Budget

Poder efetivo aproximado:

```text
effective_power =
magnitude × uptime
```

Exemplo:

```text
+30% Attack durante 5 s
cooldown 15 s

uptime ideal = 33%
ganho médio teórico ≈ 10%
```

Essa conta não captura burst, mas é excelente para detectar exageros.

---

# 3. Buffs iniciais

| Efeito | Baseline |
|---|---|
| Fury | +15–25% Attack |
| Haste | +15–25% Attack Speed |
| Fortify | +20–30% Defense |
| Precision | +8–15 p.p. Crit Chance |
| Focus | +20–35 Skill Haste |
| Regeneration | 2–4% Max HP/s |
| Barrier | 10–25% Max HP em shield |
| Unstoppable | imunidade específica e curta; não universal |

---

# 4. Debuffs iniciais

| Efeito | Baseline |
|---|---|
| Weakness | -10–20% Attack |
| Armor Break | -15–25% Defense |
| Vulnerable | +10–15% Damage Taken |
| Slow | -15–30% Move Speed |
| Attack Slow | -10–20% Attack Speed |
| Stun | 0.50–1.25 s |
| Root | 1.00–2.50 s |
| Silence | 1.00–2.00 s |

---

# 5. Hard caps

```text
Vulnerability total:     +25% Damage Taken
Armor Break agregado:    -50% Defense
Move Slow agregado:      -50%
Attack Slow agregado:    -40%
```

Excedentes podem existir no dado, mas o valor final é clampado.

---

# 6. DOT

Dano total da aplicação completa:

## DOT normal

```text
0.80–1.60 × Attack
```

distribuído durante sua duração.

## DOT de build especializada

```text
1.50–2.50 × Attack
```

com condição, setup ou stacking.

## Signature DOT

```text
2.50–4.00 × Attack
```

com cooldown alto.

Não somar o dano completo novamente a cada stack sem budget.

---

# 7. Poison / Bleed / Burn

Papéis recomendados:

```text
BLEED
→ curto/médio
→ físico
→ recompensa ataques repetidos

POISON
→ longo
→ stacking
→ pressão sustentada

BURN
→ médio
→ forte
→ pode interagir com AoE/explosão
```

A identidade vem das interações; não apenas da cor.

---

# 8. Stacking

### Buffs comuns

```text
REFRESH
```

### Marcas/cargas de build

```text
STACK
```

### DOTs específicos

```text
INDEPENDENT
```

somente quando necessário.

### Auras

```text
REPLACE_STRONGER
```

### Estados exclusivos

```text
UNIQUE
```

---

# 9. Controle em chefes

Chefes usam Tenacidade.

Além disso, hard CC repetido pode aplicar resistência temporária:

```text
+25 Tenacidade
por hard CC recebido nos últimos 8 s
máximo +100
```

Isso evita lock infinito sem tornar controle inútil.

---

# 10. Dispel

Efeitos precisam declarar:

```text
dispellable: true/false
```

Não-dispellable deve ser exceção.

Mecânicas fundamentais de boss podem ser:

```text
NEUTRAL
```

e não buffs/debuffs comuns.

---

# 11. Shields

Escudo não aumenta `max_hp`.

É recurso separado:

```text
current_shield
```

Cap inicial recomendado para escudos comuns acumulados:

```text
50% do Max HP
```

Signature pode ultrapassar temporariamente se explicitamente permitido.

---

# 12. Cura

Cura instantânea normal:

```text
8–18% Max HP equivalente
```

ou scaling equivalente.

Cura grande:

```text
20–35%
```

deve ter:

- cooldown alto;
- condição;
- recurso;
- ou risco.

Evitar sustain infinito sem custo.

---

# 13. QA

- [ ] magnitude × uptime;
- [ ] cap;
- [ ] stacking;
- [ ] dispel;
- [ ] snapshot/dynamic;
- [ ] interação com boss;
- [ ] interação com múltiplas fontes;
- [ ] duração real após Tenacidade;
- [ ] efeito removido corretamente;
- [ ] source_id aparece no debug.
