# ITEM_POWER_SYSTEM.md

> **Versão:** 0.4

# 1. Separação obrigatória

```text
RARIDADE ≠ ITEM POWER
```

Raridade responde:

```text
quantos affixes?
qual qualidade?
há efeito único?
```

Item Power responde:

```text
quão grandes são os números?
```

---

# 2. Escala

```text
IP 1–100
```

A escala é global para a campanha planejada.

Não significa que Capítulo 1 precise chegar perto de 100.

---

# 3. Capítulo 1

```text
Normal:      IP 1–18
Elite:       IP 10–24
Mini-chefe:  IP 16–28
Boss:        IP 22–32
```

---

# 4. Stat scaling

Um affix possui:

```text
base_budget
```

e recebe escala de Item Power.

Modelo inicial:

```text
ip_factor =
0.60 + 0.80 × (item_power / 100)
```

Então:

```text
final_affix_budget =
rarity_budget
× ip_factor
```

Essa fórmula é inicial e será validada pelo simulador.

---

# 5. Clamp por conteúdo

Fonte de loot define:

```text
item_power_profile
```

Nunca gerar IP fora da banda por bug de RNG.

---

# 6. High roll

Dentro da banda:

```text
50% centro
35% médio-alto
10% alto
5% quase máximo
```

Não usar distribuição uniforme pura.

---

# 7. Upgrade

Ferreiro não aumenta Item Power infinito.

Reforço:

```text
melhora o budget do item
```

dentro do teto permitido.

Upgrade de IP, se existir no futuro, precisa de sistema próprio.

---

# 8. UI

Mostrar:

```text
Raridade
Item Power
Affixes
Efeito único
```

Não reduzir comparação a uma seta verde/vermelha única.

Um item com IP menor pode ser melhor para uma build específica.

---

# 9. QA

- [ ] raridade não altera banda de IP sozinha;
- [ ] fonte controla banda;
- [ ] IP escala números;
- [ ] Relíquia ainda paga budget pelo efeito;
- [ ] template reutilizável entre faixas;
- [ ] sem versões II/III só para inflar stats.
