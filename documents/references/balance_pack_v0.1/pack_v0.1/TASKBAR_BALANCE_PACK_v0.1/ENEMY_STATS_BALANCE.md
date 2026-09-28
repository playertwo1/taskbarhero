# ENEMY_STATS_BALANCE.md

> **Versão:** 0.1  
> **Dependências:** `STATUS_SYSTEM_BASE.md`, `HERO_STATS_BALANCE.md`

---

## 1. Reference Hero

Todo conteúdo de combate é balanceado contra uma entidade abstrata chamada:

```text
HERO_REFERENCE
```

Ela não é um herói jogável.

### Status

```text
HP:      115 → 470
Attack:   12 → 50
Defense:   9 → 36
AS:        1.00
Crit:      5%
Crit DMG:  1.50×
```

Progressão L1→L100 usa a mesma interpolação linear dos heróis.

### DPS de referência

```text
basic_dps =
attack
× attack_speed
× (1 + crit_chance × (crit_damage - 1))

sustained_reference_dps =
basic_dps × 1.75
```

`1.75` representa contribuição média de skills/passivas em uma janela longa.

Esse multiplicador é de BALANCEAMENTO, não precisa existir na runtime do combate.

---

# 2. Arquétipos básicos

Primeiro gerar os status do `HERO_REFERENCE` para o nível do conteúdo.

Depois aplicar:

| Arquétipo | HP | ATK | DEF | AS | Uso |
|---|---:|---:|---:|---:|---|
| Swarm | ×0.35 | ×0.55 | ×0.50 | ×1.25 | inimigos numerosos e frágeis |
| Standard | ×0.85 | ×0.75 | ×0.75 | ×1.00 | inimigo comum |
| Heavy | ×1.40 | ×0.85 | ×1.25 | ×0.70 | lento e resistente |
| Ranged | ×0.65 | ×0.95 | ×0.55 | ×0.90 | pressão à distância |
| Assassin | ×0.55 | ×1.15 | ×0.50 | ×1.25 | rápido, frágil, burst |
| Controller | ×0.75 | ×0.65 | ×0.80 | ×0.80 | status/control |
| Support | ×0.70 | ×0.55 | ×0.70 | ×0.85 | cura/buffs/invocações |

Arquétipo define **forma de lutar**.

Rank define **peso do encontro**.

---

# 3. Rank

Aplicar depois do arquétipo.

| Rank | HP | ATK | DEF | Tenacidade |
|---|---:|---:|---:|---:|
| Normal | ×1.00 | ×1.00 | ×1.00 | +0 |
| Elite | ×2.30 | ×1.25 | ×1.15 | +25 |
| Mini-chefe | ×7.00 | ×1.55 | ×1.35 | +50 |
| Chefe | ×20.00 | ×1.80 | ×1.50 | +100 |

Um chefe não deve ser apenas um “Normal com HP ×20”.

O multiplicador serve como orçamento de resistência; chefes precisam de:

- fases;
- telegraph;
- skills;
- janelas;
- invocações;
- arenas;
- padrões próprios.

---

# 4. Tempo-alvo de combate

Contra herói de nível/conteúdo equivalente e equipamento esperado:

| Tipo | Tempo-alvo |
|---|---:|
| Swarm individual | 1–2 s |
| Normal | 3–6 s |
| Heavy | 6–10 s |
| Elite | 15–30 s |
| Mini-chefe | 40–75 s |
| Chefe | 120–210 s |

Os tempos são referências de QA, não timers obrigatórios.

---

# 5. Dano inimigo

O objetivo não é matar o jogador em 2 golpes sem telegraph.

### Ataque comum

Uma sequência contínua de inimigo Standard equivalente deve levar aproximadamente:

```text
25–35 s
```

para consumir 100% do EHP do `HERO_REFERENCE`, sem cura/esquiva/controle.

Heavy:

```text
golpe forte, frequência menor
```

Assassin:

```text
burst maior, janela de vulnerabilidade maior
```

Boss:

```text
ataques básicos previsíveis
+
golpes perigosos claramente sinalizados
```

Ataques telegráficos podem causar muito mais dano que ataques automáticos porque são evitáveis.

---

# 6. Capítulos

Cada inimigo possui:

```yaml
content_level:
archetype:
rank:
chapter_modifier:
affixes:
```

Capítulos não devem duplicar fórmulas.

Exemplo:

```text
Bosque de Lúmen
→ inimigos do capítulo
→ nível do conteúdo
→ arquétipo
→ rank
→ affixes do capítulo
```

```text
Minas de Cinza
→ mesma pipeline
→ novos comportamentos/mecânicas
```

A identidade do capítulo deve vir mais de mecânica e composição que de inflação bruta de HP.

---

# 7. Composição de encontro

Usar `Encounter Budget`.

Valores iniciais:

```text
Swarm       = 0.35
Normal      = 1.00
Heavy       = 1.40
Ranged      = 1.10
Assassin    = 1.25
Controller  = 1.30
Support     = 1.25
Elite       = ×2.50 no custo do arquétipo
```

Exemplo:

```text
3 Normals = 3.0
2 Swarms + 1 Heavy + 1 Ranged = 3.2
```

Composição perigosa recebe custo extra se houver sinergia forte.

Exemplo:

```text
Controller + Assassin
```

não deve ser avaliado apenas pela soma seca.

---

# 8. Affixes de Elite

Elite pode receber inicialmente:

```text
1 affix
```

Mais tarde:

```text
conteúdo alto → até 2
```

Um affix deve alterar comportamento, não só +X% HP.

Boas famílias:

- Berserker;
- Shielded;
- Vampiric;
- Volatile;
- Summoner;
- Haste;
- Thorns;
- Aura;
- Teleporter.

Evitar combinações que removam counterplay.

---

# 9. Boss anti-infinito

Chefes devem ter:

```text
Tenacidade alta
```

em vez de imunidade universal.

Controles consecutivos podem gerar resistência temporária:

```text
CC Resistance Stack
```

Exemplo conceitual:

```text
cada hard CC recebido em 8 s:
+25 Tenacidade temporária
máximo +100
```

Evita stun-lock sem invalidar builds de controle.

---

# 10. QA

Para cada novo inimigo:

- [ ] validar nível;
- [ ] validar arquétipo;
- [ ] validar rank;
- [ ] medir TTK;
- [ ] medir dano recebido;
- [ ] testar melee;
- [ ] testar ranged;
- [ ] testar build defensiva;
- [ ] testar build ofensiva;
- [ ] testar controle;
- [ ] verificar telegraphs;
- [ ] verificar combinações de encontro;
- [ ] nenhum ataque inevitável causa burst absurdo sem contrajogo.
