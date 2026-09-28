# DAMAGE_TYPES_SYSTEM.md

> **Versão:** 0.2  
> **Estado:** CONTRATO BASE  
> **Objetivo:** definir tipos de dano, resistências e interações sem transformar o jogo em uma planilha excessiva.

---

# 1. Princípio

O jogo terá **poucos tipos de dano**, cada um com identidade clara.

Tipos oficiais v0.2:

```text
PHYSICAL
ARCANE
FIRE
TOXIC
TRUE
```

## Tradução sugerida

```text
PHYSICAL → Físico
ARCANE   → Arcano / Lúmen
FIRE     → Fogo
TOXIC    → Tóxico
TRUE      → Verdadeiro
```

---

# 2. Uso esperado

## PHYSICAL

Usado por:

- ataques corpo a corpo;
- projéteis físicos;
- armas;
- sangramento;
- impacto.

## ARCANE

Usado por:

- Íris;
- Lúmen;
- runas;
- energia;
- efeitos mágicos/espirituais.

## FIRE

Usado por:

- Brasa;
- explosões;
- queimadura;
- alquimia incendiária.

## TOXIC

Usado por:

- veneno;
- corrosão;
- toxinas;
- alguns monstros naturais/alquímicos.

## TRUE

Ignora mitigação comum.

Uso extremamente raro.

Reservado para:

- custo de vida;
- mecânicas específicas;
- execução;
- scripts de boss.

---

# 3. Resistências

Cada entidade pode possuir:

```yaml
resistance:
  physical: 0.00
  arcane: 0.00
  fire: 0.00
  toxic: 0.00
```

Convenção interna:

```text
20% resistência = 0.20
-15% resistência = -0.15
```

---

# 4. Fórmula

Depois da Defesa:

```text
damage_after_defense
```

Aplicar resistência elemental:

```text
damage_after_resistance =
damage_after_defense × (1 - resistance)
```

Depois:

```text
damage_taken multipliers
```

Ordem:

```text
RAW DAMAGE
→ DEFENSE/PENETRATION
→ TYPE RESISTANCE
→ DAMAGE_TAKEN
→ SPECIAL MITIGATION
→ SHIELD
→ HP
```

---

# 5. Caps

```text
resistance min = -0.50
resistance max = 0.75
```

Logo:

```text
-50% = recebe 150%
+75% = recebe 25%
```

Nunca chegar a imunidade por resistência numérica normal.

Imunidade é flag explícita.

---

# 6. Defesa vs Resistência

`Defense` continua universal.

Resistência é uma segunda camada **leve**, usada para identidade de conteúdo.

Não criar:

```text
physical_defense
fire_defense
arcane_defense
toxic_defense
```

como atributos separados.

---

# 7. Status associados

Recomendação:

```text
BLEED  → PHYSICAL
BURN   → FIRE
POISON → TOXIC
ARCANE_DOT → ARCANE
```

---

# 8. Vulnerabilidade de tipo

Usar modificador explícito:

```yaml
type_vulnerability:
  type: FIRE
  value: 0.15
```

Isso equivale a:

```text
+15% dano FIRE recebido
```

Não alterar resistência permanentemente.

---

# 9. Regras de conteúdo

Nenhum inimigo normal deve exigir um tipo específico.

Boss pode favorecer/desfavorecer tipos, mas sempre deve existir:

```text
counterplay alternativo
```

Evitar:

```text
“se não usar FIRE, impossível matar”
```

---

# 10. QA

- [ ] cada skill declara damage_type;
- [ ] DOT declara damage_type;
- [ ] resistência respeita cap;
- [ ] TRUE ignora resistência;
- [ ] imunidade é explícita;
- [ ] nenhum capítulo exige um único tipo;
- [ ] tooltip mostra resistência quando relevante.
