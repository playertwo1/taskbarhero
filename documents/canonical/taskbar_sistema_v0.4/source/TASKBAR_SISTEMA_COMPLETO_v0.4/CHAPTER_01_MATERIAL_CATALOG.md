# CHAPTER_01_MATERIAL_CATALOG.md

> **Versão:** 0.4

| ID | Nome | Fonte | Uso |
|---|---|---|---|
| `MAT_C1_LUMEN_RESIDUE` | Resíduo de Lúmen | criaturas ligadas ao Lúmen | crafting comum / alquimia |
| `MAT_C1_ANCESTRAL_FIBER` | Fibra Ancestral | raízes, fungos e vegetação | armaduras / consumíveis / crafting |
| `MAT_C1_DENSE_MOSS` | Musgo Denso | javalis e criaturas pesadas | defesa / reforço |
| `MAT_C1_GREEN_CRYSTAL` | Cristal Verde | criaturas cristalinas / ruínas | arcano / reforja |
| `MAT_C1_CORRUPTED_ESSENCE` | Essência Corrompida | elites, mini-chefes e bosses | crafting avançado |
| `MAT_C1_GUARDIAN_SHARD` | Lasca do Guardião-Cervo | Guardião-Cervo | crafting anti-azar de Relíquias |
| `MAT_C1_HEART_FRAGMENT` | Fragmento do Coração Verde | first clear do Guardião | progressão narrativa |

## Regra

Material é entidade própria.

Inimigos apenas referenciam:

```text
material_id
chance
quantity
```

Não copiar nome/texto/economia do material em cada inimigo.
