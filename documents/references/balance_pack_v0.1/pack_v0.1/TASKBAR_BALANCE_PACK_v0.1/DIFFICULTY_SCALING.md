# DIFFICULTY_SCALING.md

> **Versão:** 0.1

---

# 1. Princípio

Dificuldade não deve depender apenas de HP inflado.

Cada perfil possui:

```text
stat modifiers
+
composição
+
affixes
+
mecânicas
```

---

# 2. Perfis internos

Os nomes de UI podem ser definidos depois.

| Perfil | HP | ATK | DEF | Encounter Budget | Loot |
|---|---:|---:|---:|---:|---:|
| D0 | ×1.00 | ×1.00 | ×1.00 | ×1.00 | ×1.00 |
| D1 | ×1.25 | ×1.12 | ×1.05 | ×1.10 | ×1.10 |
| D2 | ×1.60 | ×1.25 | ×1.10 | ×1.20 | ×1.25 |
| D3 | ×2.10 | ×1.40 | ×1.15 | ×1.30 | ×1.50 |

Loot multiplier representa orçamento de recompensa, não necessariamente drop rate literal.

---

# 3. Ordem

```text
Enemy Reference
→ Archetype
→ Rank
→ Content Level
→ Difficulty
→ Affix
→ Temporary Effects
```

---

# 4. Evitar sponge

Se uma dificuldade aumenta muito TTK sem criar decisão nova:

```text
FAIL
```

A partir de D2, priorizar também:

- novos padrões;
- affixes;
- composição mais inteligente;
- telegraphs mais rápidos;
- janelas menores;
- mecânicas opcionais de risco/recompensa.

---

# 5. Level delta

Conteúdo deve possuir `content_level`.

Comparar:

```text
hero_level - content_level
```

Não aplicar penalidade escondida de hit chance.

Diferença de nível já aparece por:

- stats;
- equipamento esperado;
- skills/passivas desbloqueadas.

Evitar sistema invisível do tipo:

```text
“você erra porque está 3 níveis abaixo”
```

---

# 6. Progressão por capítulo

Capítulo define:

```text
faixa de nível
pool de inimigos
affixes
loot tier
materiais
boss
```

Não deve redefinir as fórmulas centrais.

---

# 7. Teste de dificuldade

Para cada perfil:

- [ ] herói referência;
- [ ] build ofensiva;
- [ ] build defensiva;
- [ ] build de controle;
- [ ] equipamento abaixo do esperado;
- [ ] equipamento esperado;
- [ ] equipamento acima do esperado;
- [ ] boss;
- [ ] elite;
- [ ] encontro com múltiplos arquétipos.

D3 pode exigir otimização.

D0 não pode exigir build específica.
