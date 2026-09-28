# BALANCE_QA_CHECKLIST.md

> **Versão:** 0.1

---

# 1. Matriz mínima

Testar níveis:

```text
1
25
50
75
100
```

Equipamento:

```text
sem gear
gear abaixo do esperado
gear esperado
gear alto
```

Dificuldade:

```text
D0
D1
D2
D3
```

---

# 2. Métricas por herói

Registrar:

```text
Basic DPS
Sustained DPS 30 s
Burst 5 s
EHP
Healing/s
Shielding/s
Control uptime
Move speed
TTK
Survival Time
```

---

# 3. Métricas de encontro

```text
duração
dano recebido
cura usada
número de skills
número de controles
tempo sob CC
picos de dano
mortes
```

---

# 4. Golden Reference

Primeiro implementar testes completos no Bastião.

Depois executar a mesma suíte nos outros 7 heróis.

Não escrever teste especial diferente para cada um quando a regra for universal.

---

# 5. Gate — Heróis

PASS se:

- [ ] nenhum bug de fórmula;
- [ ] breakdown fecha matematicamente;
- [ ] clear time em conteúdo neutro dentro do envelope planejado;
- [ ] três builds viáveis;
- [ ] duas skills equipadas geram escolhas reais;
- [ ] nenhuma passiva universalmente obrigatória;
- [ ] nenhum herói domina simultaneamente dano + sustain + controle.

---

# 6. Gate — Inimigos

PASS se:

- [ ] TTK dentro da banda;
- [ ] dano recebido razoável;
- [ ] telegraphs legíveis;
- [ ] elite não é apenas HP sponge;
- [ ] mini-chefe possui mecânica;
- [ ] boss possui fases/padrões;
- [ ] controle continua útil;
- [ ] composição não cria morte inevitável.

---

# 7. Gate — Equipamento

PASS se:

- [ ] orçamento correto;
- [ ] conjunto completo dentro da faixa de ganho;
- [ ] nenhuma stat universal;
- [ ] lendário tem tradeoff;
- [ ] Eco altera build;
- [ ] reforço não explode a curva;
- [ ] reforja não cria BP gratuito.

---

# 8. Gate — Buff/Debuff

PASS se:

- [ ] uptime calculado;
- [ ] stacks corretos;
- [ ] caps corretos;
- [ ] tenacidade correta;
- [ ] dispel correto;
- [ ] DOT/HOT correto;
- [ ] boss não fica stun-lockado;
- [ ] efeito não some/deixa resíduo após expirar.

---

# 9. Registro de alteração

Toda mudança de balanceamento:

```yaml
date:
system:
entity:
old_value:
new_value:
reason:
test:
expected_impact:
result:
```

Sem motivo + teste, não é balance patch; é chute.

---

# 10. Prioridade

Ao encontrar problema:

```text
P0 — quebra fórmula/save/runtime
P1 — exploit/infinito/one-shot inevitável
P2 — build/item/herói claramente dominante
P3 — ajuste fino
P4 — texto/UI/telemetria
```
