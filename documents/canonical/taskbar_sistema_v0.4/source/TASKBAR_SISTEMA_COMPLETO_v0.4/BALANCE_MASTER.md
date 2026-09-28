# BALANCE_MASTER.md

> **Taskbar Mobile RPG — Balance / Loot Pack v0.4**

A v0.4 congela a arquitetura de loot antes da expansão para novos capítulos.

---

# Fonte de verdade

## Inimigos

```text
ENEMY_CANONICAL_SCHEMA.md
CHAPTER_01_ENEMIES_CANONICAL.json
```

Todo inimigo contém seu próprio bloco:

```text
enemy.loot
```

com:

- ouro;
- materiais;
- equipamentos;
- rarity table;
- Item Power;
- personal pool;
- regional pool;
- signatures;
- Eco;
- Memória;
- garantias;
- reward choice;
- pity profile.

---

# Loot

```text
LOOT_ECONOMY_SYSTEM.md
LOOT_QUALITY_SYSTEM_v0.4.md
DROP_RESOLVER_SPEC.md
ITEM_POWER_SYSTEM.md
```

---

# Conteúdo do Capítulo 1

```text
10 inimigos normais
3 elites
3 mini-chefes
1 boss
30 itens
7 materiais
```

---

# Novidades v0.4

```text
SMART LOOT 70/30
DUPLICATE PROTECTION
SLOT PITY
QUALITY FLOOR
ITEM POWER
REWARD CHOICE
BOSS FRAGMENTS / CRAFTING
ECO + BESTIÁRIO
CANONICAL ENEMY LOOT
```

---

# Regra de manutenção

Documentos como:

```text
CHAPTER_01_DROP_TABLES.md
CHAPTER_01_ENEMY_CATALOG.md
```

são visões humanas.

Não devem divergir do JSON canônico.

Quando valores mudarem:

```text
1. alterar canonical data
2. atualizar tabela gerada
3. rodar validação
```

---

# Próximo passo

A engine de loot está pronta para conteúdo.

Próximos trabalhos podem seguir em paralelo:

```text
A) balancear skills/passivas dos 8 heróis
B) criar Capítulo 2 — Minas de Cinza
C) completar stats/skills dos inimigos do Bosque
```

Capítulo 2 deve reutilizar a MESMA estrutura canônica.
