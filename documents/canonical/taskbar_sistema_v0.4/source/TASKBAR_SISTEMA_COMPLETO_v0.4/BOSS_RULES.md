# BOSS_RULES.md

> **Versão:** 0.2

---

# 1. Boss não é saco de HP

Todo boss deve possuir pelo menos:

```text
1 identidade
2 padrões principais
1 mecânica de pressão
1 janela de vulnerabilidade
1 mudança de fase ou escalada
```

---

# 2. Fases

Baseline:

```text
Phase 1: 100–70%
Phase 2: 70–35%
Phase 3: 35–0%
```

Nem todo boss precisa exatamente desses thresholds.

Mas thresholds precisam ser dados:

```yaml
phase_thresholds:
```

---

# 3. Enrage

Soft Enrage preferido.

Exemplos:

- ataques mais rápidos;
- arena menor;
- adds;
- menor recovery;
- novas combinações.

Hard Enrage deve ser raro.

---

# 4. Burst Protection

Não usar invulnerabilidade invisível.

Se uma fase não pode ser pulada:

```text
phase_gate explícito
```

com feedback claro.

Evitar:

```text
HP “trava” sem explicação
```

---

# 5. CC

Boss recebe controles.

Baseline:

```text
Tenacity +100
```

Mais:

```text
+25 Tenacity temporária
por hard CC recente
cap +100
```

---

# 6. Stagger

Boss pode ser quebrado.

Após break:

```text
stagger immunity 3–5 s
```

Janela:

```text
0.75–1.50 s
```

---

# 7. Resistências

Resistências devem refletir identidade.

Exemplo:

```text
boss de fogo:
FIRE resistance positiva
TOXIC neutral
PHYSICAL neutral
ARCANE talvez vulnerável
```

Evitar resistência alta em 3–4 tipos simultaneamente.

---

# 8. Adds

Adds contam no Encounter Budget.

Boss + adds não recebe orçamento infinito.

Quando adds são mecânica central:

```text
reduzir dano/pressão própria do boss
```

---

# 9. Telegraph

Ataque perigoso precisa de pelo menos um:

```text
visual
som
animação
marcador
tempo de antecipação
```

Quanto maior o dano:

```text
maior o telegraph/counterplay
```

---

# 10. One-shot

One-shot só é aceitável se:

```text
claramente telegráfico
evitável
raro
coerente com dificuldade
```

D0 não deve depender de one-shot.

---

# 11. Anti-heal / Anti-shield

Nunca neutralizar completamente uma classe por toda a luta.

Preferir:

```text
janela temporária
```

em vez de:

```text
healing_disabled = true por 3 minutos
```

---

# 12. Script Contract

Boss script pode:

```text
mudar fase
spawnar adds
forçar alvo
alterar arena
aplicar mecânica
```

Boss script não pode:

```text
alterar arbitrariamente stat base
quebrar caps
modificar save
```

---

# 13. QA

- [ ] boss funciona com melee;
- [ ] ranged;
- [ ] tank;
- [ ] support;
- [ ] burst;
- [ ] DOT;
- [ ] control;
- [ ] summon;
- [ ] stagger;
- [ ] sem build obrigatória;
- [ ] sem fase impossível por RNG.
