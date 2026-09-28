# RESOURCE_SYSTEM_BASE.md

> **Versão:** 0.2  
> **Estado:** CONTRATO BASE

---

# 1. Princípio

Recursos de herói usam uma engine única.

Cada herói pode ter recurso próprio, mas não fórmula própria de armazenamento.

Objeto universal:

```yaml
resource:
  id:
  current:
  max:
  min:
  generation_mode:
  decay_mode:
  decay_rate:
  persist_between_combats:
  overflow_policy:
```

---

# 2. Operações permitidas

```text
ADD
SPEND
SET
FILL
DRAIN
LOCK
UNLOCK
```

Nunca modificar o número diretamente fora do Resource System.

---

# 3. Geração

Fontes possíveis:

```text
ON_HIT
ON_CRIT
ON_DAMAGE_TAKEN
ON_KILL
ON_SKILL_CAST
ON_STATUS_APPLIED
PER_SECOND
PASSIVE
SCRIPTED
```

---

# 4. Decaimento

Modos:

```text
NONE
OUT_OF_COMBAT
ALWAYS
AFTER_DELAY
```

---

# 5. Overflow

Políticas:

```text
CLAMP
CONVERT
TRIGGER
IGNORE
```

Padrão:

```text
CLAMP
```

---

# 6. Recursos dos 8 heróis

## Bastião

Recurso recomendado:

```text
GUARD
```

Ganha por:

- bloquear/absorver dano;
- proteger aliado;
- provocar;
- determinadas passivas.

Gasta em:

- skills defensivas;
- retaliação;
- fortalecimento.

Faixa inicial:

```text
0–100
```

---

## Flecha

Recurso recomendado:

```text
FOCUS
```

Ganha por:

- atacar sem sofrer dano;
- acertar Marca;
- crítico;
- manter distância.

Perde parcialmente ao sofrer dano pesado.

Faixa:

```text
0–100
```

---

## Íris

Recurso:

```text
LUMEN
```

Ganha por:

- usar skills;
- acertar múltiplos alvos;
- interações arcanas.

Gasta em:

- amplificação;
- controle;
- assinatura.

Faixa:

```text
0–100
```

---

## Brasa

Recurso:

```text
FURY
```

Ganha por:

- atacar;
- receber dano;
- aplicar Burn;
- permanecer em combate.

Pode decair fora de combate.

Faixa:

```text
0–100
```

---

## Véu

Recurso recomendado:

```text
SHADOW
```

Ganha por:

- crítico;
- execução;
- atacar alvo marcado;
- evitar dano.

Gasta em:

- mobilidade;
- burst;
- ocultação/escape.

Faixa:

```text
0–100
```

---

## Orvalho

Recurso:

```text
SEEDS
```

Modelo híbrido de cargas.

Exemplo:

```text
0–5
```

Ganha por:

- cura efetiva;
- aplicar regen;
- interações naturais.

Gasta por:

- cura forte;
- proteção;
- crescimento.

---

## Forja

Recurso:

```text
SCRAP
```

ou nome diegético equivalente.

Faixa:

```text
0–100
```

Ganha por:

- dano de constructs;
- destruição de summon;
- acertos técnicos.

Gasta em:

- sentinelas;
- armadilhas;
- overclock.

---

## Sino

Recursos:

```text
RHYTHM
RESONANCE
```

Pode usar resource pair.

`RHYTHM`:

```text
0–100
```

`RESONANCE`:

```text
0–3 stacks
```

Ritmo representa cadência.

Ressonância representa picos.

---

# 7. Regra de poder

Recurso não pode ser “mana azul genérica”.

Cada recurso deve:

```text
mudar decisão
```

Exemplo:

- guardar para burst;
- gastar para sobreviver;
- consumir stacks;
- manter ritmo;
- escolher timing.

---

# 8. Persistência

Padrão:

```text
não persistir entre runs/combates
```

Exceções devem ser explícitas.

---

# 9. Save

Salvar:

```text
resource configuration
```

Não salvar recurso temporário se o design reiniciar o combate com recurso vazio.

---

# 10. QA

- [ ] nunca ultrapassa max;
- [ ] nunca fica abaixo de min;
- [ ] geração não duplica;
- [ ] gasto falha de modo previsível;
- [ ] HUD atualiza;
- [ ] save/load respeita persistência;
- [ ] resource event aparece no debug.
