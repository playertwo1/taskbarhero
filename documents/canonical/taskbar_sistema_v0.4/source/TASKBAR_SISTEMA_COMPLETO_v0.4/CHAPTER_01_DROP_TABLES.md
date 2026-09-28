# CHAPTER_01_DROP_TABLES.md

> **Versão:** 0.3  
> **Importante:** chances de Signature são rolls independentes do equipamento genérico.

---

# 1. Inimigos comuns

| ID | Inimigo | Ouro | Material | Equipamento | Signature A | Signature B / Eco |
|---|---|---:|---:|---:|---|---|
| `EN_C1_001` | Geleia de Lúmen | 3–6 | 65% | 10% | Gota de Lúmen 2.0% | Eco da Geleia 0.35% |
| `EN_C1_002` | Espírito de Raiz | 4–7 | 75% | 11% | Totem da Raiz Antiga 1.5% | Raiz Faminta 0.15% |
| `EN_C1_003` | Gremlin de Folhas | 4–8 | 70% | 12% | Arco de Folha Tensa 2.0% | Manto de Folhas 1.5% |
| `EN_C1_004` | Javali de Musgo | 5–8 | 85% | 12% | Presa do Javali 2.0% | Couraça de Musgo 1.5% |
| `EN_C1_005` | Mariposa Luminosa | 4–7 | 70% | 11% | Fragmento Prismático 1.0% | Eco da Mariposa 0.35% |
| `EN_C1_006` | Cogumelo Sonolento | 3–7 | 80% | 10% | Esporo Sonolento 2.0% | Lanterna de Esporos 1.25% |
| `EN_C1_007` | Trepa-Cadáver | 5–8 | 85% | 12% | Raiz Faminta 1.25% | Flor de Musgo 1.0% |
| `EN_C1_008` | Caracol Cristalino | 5–8 | 90% | 13% | Casco Cristalino 2.0% | Fragmento Prismático 1.5% |
| `EN_C1_009` | Raposa Oca | 5–8 | 75% | 14% | Dente da Raposa Oca 2.0% | Olho de Vidro Verde 1.0% |
| `EN_C1_010` | Sapinho do Lúmen | 3–7 | 65% | 11% | Talismã do Salto 2.0% | Gota de Lúmen 1.0% |

Se o roll de equipamento genérico passar:

```text
62.0% Comum
27.0% Incomum
 9.0% Raro
 1.8% Épico
 0.2% Relíquia
```

O template é escolhido de:

```text
pool do inimigo
+
pool regional do Bosque
```

---

# 2. Elite — Geleia Anciã

```text
Ouro:                    25–40
Material:                100% / 1–2
Essência Corrompida:     25%
Equipamento:             100%
Segundo equipamento:     20%
Eco da Geleia:            8%
Gota de Lúmen:           12%
```

Raridade do equipamento:

```text
35% Incomum
45% Raro
18% Épico
 2% Relíquia
```

---

# 3. Elite — Javali Cicatrizado

```text
Ouro:                    30–45
Material:                100% / 1–2
Essência Corrompida:     30%
Equipamento:             100%
Segundo equipamento:     20%
Presa do Javali:         12%
Coração de Pedra:         7%
```

---

# 4. Elite — Gremlin Espinhento

```text
Ouro:                    25–45
Material:                100% / 1–2
Essência Corrompida:     25%
Equipamento:             100%
Segundo equipamento:     20%
Arco de Folha Tensa:     12%
Manto de Folhas:         10%
Regional Relic Roll:      1%
```

---

# 5. Mini-chefe — Rainha das Geleias

```text
Ouro:                    80–110
Material:                100% / 2–4
Essência Corrompida:     100%
Equipamento:             100%
Segundo equipamento:     35%
Gota de Lúmen:           25%
Eco da Geleia:           20%
Farol Prismático:         5%
```

Raridade:

```text
45% Raro
48% Épico
 7% Relíquia
```

---

# 6. Mini-chefe — Javali da Ponte

```text
Ouro:                    90–130
Material:                100% / 2–4
Essência Corrompida:     100%
Equipamento:             100%
Segundo equipamento:     35%
Presa do Javali:         20%
Coração de Pedra:        15%
Casco Cristalino:         8%
```

---

# 7. Mini-chefe — O Espinheiro

```text
Ouro:                    90–130
Material:                100% / 2–4
Essência Corrompida:     100%
Equipamento:             100%
Segundo equipamento:     35%
Raiz Faminta:            18%
Pétala do Primeiro Jardim:12%
Eco do Espinheiro:        7%
```

---

# 8. Boss — Guardião-Cervo de Pedra

## Primeira vitória

```text
Ouro:                         300–400
Material regional:            100% / 5–8
Essência Corrompida:          100% / 2–3
Fragmento do Coração Verde:   100%
Memória do Guardião:          100%
Equipamento Épico+:           100%
```

## Repetições

```text
Ouro:                         250–400
Material regional:            100% / 4–8
Essência Corrompida:          100% / 1–3
Equipamento:                  100%
Segundo equipamento:          50%
Casca do Guardião:             8%
Memória do Guardião:           1%
Regional Relic Roll:          10%
```

Raridade do equipamento:

```text
15% Raro
70% Épico
15% Relíquia
```

### Pity

```text
8 derrotas sem Relíquia
→ próxima recompensa de equipamento contém Relíquia
```

Soft pity começa após a quinta derrota sem Relíquia.

---

# 9. Pool regional do Bosque

Templates comuns:

```text
Galho de Vigília
Broquel de Casca
Manto de Folhas
Gota de Lúmen
Flor de Musgo
```

Pool avançado:

```text
Farol Prismático
Fragmento Prismático
Cinza Eterna
```

Pool Relíquia regional:

```text
Agulha da Viúva
Engrenagem Impossível
Sino Partido
```

Relíquia regional não substitui Relíquia signature de boss.

---

# 10. Fontes não-combate

## Ruínas de Lúmen

Chance aumentada para:

```text
Farol Prismático
Fragmento Prismático
Engrenagem Impossível
```

## Comerciante Gremlin

Pode vender:

```text
Comum
Incomum
Raro
```

Chance pequena de Épico.

Nunca vende:

```text
Memória
```

Relíquias apenas em evento explicitamente especial, nunca em loja normal.

---

# 11. Regra para futuras regiões

Cada capítulo deve criar:

```text
regional_pool
material_pool
enemy_signature_pool
elite_pool
miniboss_pool
boss_pool
memory_pool
```

Sem copiar percentuais cegamente.

Os percentuais deste arquivo são baseline do Bosque de Lúmen.
