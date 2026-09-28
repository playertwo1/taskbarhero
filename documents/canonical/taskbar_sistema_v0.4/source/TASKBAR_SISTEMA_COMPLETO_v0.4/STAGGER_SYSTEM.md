# STAGGER_SYSTEM.md

> **Versão:** 0.2

---

# 1. Objetivo

Criar uma segunda camada de combate além do HP:

```text
POSTURE / STAGGER
```

Ataques podem causar:

```text
HP Damage
+
Stagger Damage
```

---

# 2. Dados

```yaml
stagger:
  current:
  max:
  recovery_delay:
  recovery_per_second:
  broken_duration:
```

---

# 3. Valores por rank

Baseline:

```text
Normal      = 100
Elite       = 180
Mini-chefe  = 350
Chefe       = 600+
```

Esses valores são referência relativa e podem escalar com capítulo.

---

# 4. Stagger Damage

Ataques possuem:

```yaml
stagger_coefficient:
```

Baseline:

| Tipo | Stagger |
|---|---:|
| ataque rápido | 5–10 |
| ataque comum | 10–20 |
| ataque pesado | 20–35 |
| skill forte | 25–45 |
| skill focada em postura | 40–70 |

---

# 5. Break

Ao chegar a:

```text
current_stagger <= 0
```

entra em:

```text
STAGGERED
```

---

# 6. Duração

```text
Normal:      1.5–2.5 s
Elite:       1.5–2.0 s
Mini-chefe:  1.0–1.75 s
Chefe:       0.75–1.50 s
```

Tenacidade não modifica Stagger Break.

Boss rules podem modificar.

---

# 7. Vulnerabilidade durante break

Baseline:

```text
+15% damage_taken
```

Boss:

```text
+10%
```

Evitar +50% ou números enormes.

O principal prêmio é:

```text
janela segura + interrupção
```

---

# 8. Recovery

Se não receber Stagger Damage por:

```text
3.0 s
```

começa regeneração.

Baseline:

```text
10% max_stagger por segundo
```

Boss pode recuperar mais rápido.

---

# 9. Interrupções

Ataques marcados:

```yaml
interrupt_power:
```

podem interromper casting mesmo sem quebrar toda a postura.

Categorias:

```text
NONE
LIGHT
HEAVY
```

---

# 10. Bastião

Bastião deve ser referência de Stagger.

Skills de escudo/impacto podem possuir:

```text
stagger_coefficient alto
```

Isso lhe dá utilidade ofensiva sem exigir DPS alto.

---

# 11. Forja

Constructs podem acumular Stagger gradualmente.

Evitar que múltiplas torres quebrem boss em loop infinito.

Aplicar:

```text
summon_stagger_modifier
```

Baseline:

```text
0.50
```

---

# 12. Anti-chain break

Após sair de STAGGERED:

```text
STAGGER_IMMUNITY = 2.0 s
```

Boss:

```text
3.0–5.0 s
```

Durante imunidade:

```text
stagger damage = 0
```

---

# 13. QA

- [ ] barra reseta corretamente;
- [ ] recovery funciona;
- [ ] break não encadeia infinitamente;
- [ ] boss continua quebrável;
- [ ] builds de stagger são viáveis;
- [ ] builds sem stagger continuam viáveis;
- [ ] feedback visual/sonoro é claro.
