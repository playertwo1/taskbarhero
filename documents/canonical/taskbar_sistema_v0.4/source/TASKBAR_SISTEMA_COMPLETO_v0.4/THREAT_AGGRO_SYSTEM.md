# THREAT_AGGRO_SYSTEM.md

> **Versão:** 0.2

---

# 1. Objetivo

Definir por que um inimigo escolhe um alvo.

Mesmo em conteúdo majoritariamente solo, este sistema será usado por:

- summons;
- companions;
- objetos;
- cenários futuros;
- provocação do Bastião.

---

# 2. Threat Table

Cada inimigo mantém:

```yaml
threat_table:
  entity_id:
    threat_value:
```

---

# 3. Geração

Baseline:

```text
1 dano efetivo = 1 threat
1 cura efetiva = 0.50 threat
1 shield efetivamente consumido = 0.50 threat
```

Overheal:

```text
0 threat
```

Shield que expira sem consumo:

```text
0 threat
```

---

# 4. Multiplicador

Entidades podem ter:

```text
threat_generation
```

Padrão:

```text
1.00
```

Bastião:

```text
1.50 baseline
```

quando usar determinados efeitos defensivos.

---

# 5. Taunt

Taunt não é apenas “+muito threat”.

Aplicar:

```yaml
status:
  id: TAUNT
  forced_target:
  duration:
```

Enquanto ativo:

```text
AI prioriza forced_target
```

Ao terminar:

```text
Threat Table normal volta a decidir.
```

---

# 6. Anti-taunt boss

Boss pode reduzir duração via:

```text
Tenacity
```

Alguns ataques roteirizados podem ignorar threat.

Exemplo:

```text
arena mechanic
random marked target
highest distance target
```

Esses casos devem ser explícitos.

---

# 7. Target Switching

Para evitar alvo “tremendo” entre dois entities:

```text
novo alvo precisa superar threat atual em 15%
```

Baseline:

```text
SWITCH_THRESHOLD = 1.15
```

---

# 8. Decay

Threat não decai durante combate por padrão.

Ao sair do combate:

```text
clear
```

---

# 9. QA

- [ ] dano gera threat;
- [ ] overheal não gera;
- [ ] shield consumido gera;
- [ ] taunt força alvo;
- [ ] boss scripts podem ignorar;
- [ ] target não troca a cada frame;
- [ ] summons entram corretamente.
