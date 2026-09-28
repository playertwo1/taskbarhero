# LOOT_ECONOMY_SYSTEM.md

> **Versão:** 0.4  
> **Estado:** BASE DE LOOT / ECONOMIA  
> **Capítulo de referência:** Bosque de Lúmen

---

# 1. Filosofia

```text
DROPS dão emoção.
OURO dá liberdade.
MATERIAIS dão progressão.
CRAFTING protege contra azar.
RELÍQUIAS mudam a build.
MEMÓRIAS entregam lore + efeitos especiais.
```

O melhor equipamento deve vir principalmente de:

- combate;
- elites;
- mini-chefes;
- chefes;
- eventos;
- crafting direcionado.

A loja normal serve como:

```text
anti-frustração + completar build + consumir ouro
```

e não como fonte principal de poder máximo.

---

# 2. Recursos econômicos

## Ouro

Moeda universal.

Fontes:

- todos os inimigos;
- encontros;
- eventos;
- venda de itens;
- recompensas.

Usos:

- Mercador;
- Ferreiro;
- reforço;
- reforja;
- crafting;
- Alquimista;
- serviços do Hub.

---

## Materiais

Não aparecem como moedas globais.

Capítulo 1:

```text
Resíduo de Lúmen
Fibra Ancestral
Musgo Denso
Cristal Verde
Essência Corrompida
```

---

## Recurso de progressão de boss

```text
Fragmento do Coração Verde
```

Primeira vitória:

```text
100%
```

Uso:

- progressão narrativa;
- Lanterna-Mãe;
- desbloqueio regional.

Não é moeda comum.

---

# 3. Raridades

Ordem:

```text
COMUM
INCOMUM
RARO
ÉPICO
RELÍQUIA
MEMÓRIA
```

## COMUM

- status simples;
- baixo orçamento;
- frequente.

## INCOMUM

- status principal;
- propriedade secundária.

## RARO

- sinergia de build;
- affix relevante;
- pode mudar decisões.

## ÉPICO

- efeito mecânico forte;
- build enabler.

## RELÍQUIA

- item único;
- efeito especial;
- pode possuir tradeoff;
- não é apenas “Épico com números maiores”.

## MEMÓRIA

- raridade narrativa;
- ligada a personagens, guardiões, eventos ou capítulos;
- normalmente Eco;
- não entra no roll genérico comum.

---

# 4. Pipeline de drop

Para cada inimigo derrotado:

```text
1. GOLD_ROLL
2. MATERIAL_ROLL
3. EQUIPMENT_ROLL
4. SIGNATURE_ROLL
5. ECHO/MEMORY_ROLL
6. PITY_UPDATE
```

Os rolls são independentes.

Assim:

```text
cair equipamento
```

não impede:

```text
cair ouro/material
```

---

# 5. Equipamento: roll em duas etapas

## Etapa A — caiu equipamento?

Exemplo:

```text
Geleia de Lúmen
equipment_drop_chance = 10%
```

## Etapa B — qual raridade?

Se passou:

```text
roll_rarity()
```

Somente depois selecionar:

```text
item_template
```

do pool do inimigo/região.

---

# 6. Raridade por rank

## Inimigo comum

Condicional ao equipamento cair:

| Raridade | Chance |
|---|---:|
| Comum | 62.0% |
| Incomum | 27.0% |
| Raro | 9.0% |
| Épico | 1.8% |
| Relíquia | 0.2% |

Memória:

```text
0% no roll genérico
```

---

## Elite

1 equipamento garantido.

Raridade:

| Raridade | Chance |
|---|---:|
| Comum | 0% |
| Incomum | 35% |
| Raro | 45% |
| Épico | 18% |
| Relíquia | 2% |

Roll adicional:

```text
20% para segundo equipamento
```

---

## Mini-chefe

1 equipamento garantido.

| Raridade | Chance |
|---|---:|
| Comum | 0% |
| Incomum | 0% |
| Raro | 45% |
| Épico | 48% |
| Relíquia | 7% |

Segundo equipamento:

```text
35%
```

---

## Boss — repetição

1 equipamento garantido.

| Raridade | Chance |
|---|---:|
| Raro | 15% |
| Épico | 70% |
| Relíquia | 15% |

Segundo equipamento:

```text
50%
```

Primeira vitória possui regras próprias e não usa apenas essa tabela.

---

# 7. Primeiro clear de boss

Primeira vitória sobre Guardião-Cervo:

```text
100% Fragmento do Coração Verde
100% Memória do Guardião
100% equipamento ÉPICO ou superior
100% Ouro de boss
100% Essência Corrompida
```

A primeira vitória precisa sempre parecer importante.

---

# 8. Ouro — baseline

## Inimigos comuns

```text
3–8
```

## Elite

```text
25–45
```

## Mini-chefe

```text
80–130
```

## Boss

```text
250–400
```

Os valores são v0.3 e devem ser validados contra preços do Hub.

---

# 9. Material drops

## Normal

```text
1 material comum quando roll passa
```

## Elite

```text
1–2 materiais
+
chance de Essência Corrompida
```

## Mini-chefe

```text
2–4 materiais
+
Essência Corrompida garantida
```

## Boss

```text
4–8 materiais
+
Essência Corrompida
+
material narrativo quando aplicável
```

---

# 10. Signature Drops

Alguns inimigos possuem item assinatura.

Esse roll é independente do gear genérico.

Exemplo:

```text
Raposa Oca
→ Olho de Vidro Verde
```

Signature Drops devem normalmente ficar entre:

```text
1–3% em inimigos comuns
5–20% em elites/mini-chefes
```

Relíquias signature:

```text
mais raras
```

---

# 11. Relíquia regional

Inimigos comuns podem acertar jackpot extremamente raro.

Baseline:

```text
0.2% dentro do roll de raridade
```

Isso NÃO significa 0.2% por kill.

Exemplo:

```text
12% chance de equipamento
×
0.2% chance de Relíquia

= 0.024% por kill
≈ 1 em 4.167 kills
```

Isso mantém a possibilidade de surpresa sem tornar farm de comuns a melhor estratégia.

---

# 12. Pity — boss

Boss Relic Pity:

```text
kill 1–5 sem Relíquia:
chance normal

kill 6:
+10 pontos percentuais

kill 7:
+20 pontos percentuais

kill 8:
RELÍQUIA garantida
```

Após Relíquia:

```text
contador = 0
```

O pity é por boss.

---

# 13. Pity — equipamento Épico

Contar apenas drops de equipamento, não kills.

```text
25 drops sem Épico+:
Soft Pity
```

Soft Pity:

```text
peso de Épico ×3
```

```text
40 drops sem Épico+:
Épico garantido
```

Relíquia não é garantida por esse sistema.

---

# 14. Desmontagem

Valor sugerido:

| Raridade | Retorno |
|---|---|
| Comum | material comum |
| Incomum | material comum + chance extra |
| Raro | material + pequena Essência |
| Épico | material + Essência |
| Relíquia | material especial + Essência |
| Memória | normalmente NÃO desmontável |

---

# 15. Mercador

Inventário:

```text
Comum
Incomum
Raro
```

Épico:

```text
aparição rara
```

Relíquia:

```text
não aparece na loja normal
```

Memória:

```text
nunca
```

---

# 16. Crafting direcionado

Ferreiro permite escolher:

```text
SLOT
```

mas não resultado exato.

Exemplo:

```text
Forjar Arma Rara
→ garante slot Arma
→ rolla template/affixes permitidos
```

Isso reduz RNG sem matar o loot.

---

# 17. Regra de farm

O jogo não deve incentivar:

```text
ficar 3 horas matando a Geleia inicial
```

para obter o melhor equipamento.

Soluções:

- melhores ranks aumentam qualidade;
- Relíquias possuem pools direcionados;
- bosses possuem pity;
- crafting converte materiais em progresso;
- capítulos posteriores possuem Item Power maior.

---

# 18. Telemetria

Registrar:

```text
drops_per_run
rarity_distribution
gold_per_run
materials_per_run
signature_drop_rate
pity_trigger_rate
items_dismantled
items_equipped
items_never_used
```

Se a distribuição real divergir muito da tabela:

```text
BUG ou RNG implementation review
```


---

# 19. Extensões v0.4

A camada de qualidade está definida em:

```text
LOOT_QUALITY_SYSTEM_v0.4.md
```

A partir desta versão:

- Smart Loot 70/30;
- Duplicate Protection;
- Slot Pity;
- Quality Floor;
- Item Power;
- Reward Choice;
- Boss Fragments;
- Eco/Bestiário;

fazem parte do contrato de loot.

A definição de drops migrou para:

```text
enemy.loot
```

conforme `ENEMY_CANONICAL_SCHEMA.md`.

`CHAPTER_01_DROP_TABLES.md` passa a ser documentação humana/QA, não uma segunda fonte canônica.
