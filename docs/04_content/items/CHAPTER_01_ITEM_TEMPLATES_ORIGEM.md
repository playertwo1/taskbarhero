# CHAPTER_01_ITEM_CATALOG.md

> **Templates de origem (v0.4) dos 33 itens do Capítulo 1**, movidos em 2026-09-30. O catálogo ativo e adaptado é [CHAPTER_01_ITEM_CATALOG](CHAPTER_01_ITEM_CATALOG.md), que prevalece; as regras de itens estão em [04_ITENS_RARIDADE](../../06_balance/v1/04_ITENS_RARIDADE.md). Mantido porque lista pools, fontes especiais e compatibilidade original que o catálogo adaptado referencia.

> **Versão:** 0.4 — adaptação Pocket Hero de compatibilidade por herói
> **Capítulo:** Bosque de Lúmen  
> **Base importada:** 30 itens; três templates adicionais de arma/secundário para o trio inicial. Alteração de design solicitada por Rafael em 2026-09-29; números de affix permanecem hipótese.

---

# 1. Regra

Há dois grupos.

## Templates de equipamento

Podem existir em mais de uma raridade:

```text
Comum → Épico
```

dependendo do template.

## Únicos

```text
RELÍQUIA
MEMÓRIA
```

Possuem identidade fixa.

---

# 2. Catálogo

| ID | Item | Slot | Base | Raridade permitida | Identidade |
|---|---|---|---|---|---|
| `ITEM_W_001` | Galho de Vigília | WEAPON | COMUM | Comum–Épico | Espada de madeira; ataque básico de Bastião. |
| `ITEM_W_002` | Arco de Folha Tensa | WEAPON | INCOMUM | Incomum–Épico | Arco da Flecha; ataque + crítico. |
| `ITEM_W_003` | Presa do Javali de Musgo | WEAPON | RARO | Raro–Épico | Espada de presa para Bastião; dano físico + Stagger em golpes pesados. |
| `ITEM_W_004` | Lâmina da Raposa Oca | WEAPON | RARO | Raro–Épico | Crítico/mobilidade; bônus breve após reposicionamento. |
| `ITEM_W_005` | Agulha da Viúva | WEAPON | RELIQUIA | Relíquia | Veneno pode causar crítico; build-defining. |
| `ITEM_W_006` | Cajado Prismático | WEAPON | COMUM | Comum–Épico | Cajado da Íris; ataque arcano, área e recarga conforme raridade. |
| `ITEM_S_001` | Broquel de Casca | SECONDARY | COMUM | Comum–Épico | Defesa + geração moderada de shield. |
| `ITEM_S_002` | Lanterna de Esporos | SECONDARY | INCOMUM | Incomum–Épico | Status Power; melhora zonas/debuffs. |
| `ITEM_S_003` | Totem da Raiz Antiga | SECONDARY | RARO | Raro–Épico | Tenacidade + interação com Root/controle. |
| `ITEM_S_004` | Farol Prismático | SECONDARY | EPICO | Épico | Arcano + Skill Haste ao acertar múltiplos alvos. |
| `ITEM_S_005` | Engrenagem Impossível | SECONDARY | RELIQUIA | Relíquia | Engenhocas duram mais em troca de poder pessoal de Forja. |
| `ITEM_S_006` | Aljava da Trilha | SECONDARY | COMUM | Comum–Épico | Secundário da Flecha; ataques e Marca. |
| `ITEM_S_007` | Foco de Micélio | SECONDARY | COMUM | Comum–Épico | Secundário da Íris; Skill Haste e escudo. |
| `ITEM_A_001` | Manto de Folhas | ARMOR | COMUM | Comum–Épico | HP leve + movimento. |
| `ITEM_A_002` | Couraça de Musgo | ARMOR | INCOMUM | Incomum–Épico | HP + Defesa. |
| `ITEM_A_003` | Casco Cristalino | ARMOR | RARO | Raro–Épico | Defesa alta; janela defensiva após receber golpe forte. |
| `ITEM_A_004` | Coração de Pedra | ARMOR | EPICO | Épico | Quanto menor o HP, maior a resistência. |
| `ITEM_A_005` | Casca do Guardião | ARMOR | RELIQUIA | Relíquia | Receber shield gera pequena onda de dano. |
| `ITEM_R_001` | Gota de Lúmen | ACCESSORY | COMUM | Comum–Raro | Melhora geração de recurso. |
| `ITEM_R_002` | Esporo Sonolento | ACCESSORY | INCOMUM | Incomum–Épico | Slow/status; aumenta duração de lentidão. |
| `ITEM_R_003` | Talismã do Salto de Lúmen | ACCESSORY | INCOMUM | Incomum–Épico | Movimento e pequena vantagem após mobilidade. |
| `ITEM_R_004` | Olho de Vidro Verde | ACCESSORY | RARO | Raro | Críticos aplicam Marca. |
| `ITEM_R_005` | Fragmento Prismático | ACCESSORY | RARO | Raro–Épico | Atingir múltiplos inimigos com magia reduz cooldown. |
| `ITEM_R_006` | Dente da Raposa Oca | ACCESSORY | RARO | Raro–Épico | Bônus contra alvos feridos/expostos. |
| `ITEM_R_007` | Flor de Musgo | ACCESSORY | RARO | Raro–Épico | Healing Received + Regeneration. |
| `ITEM_R_008` | Pétala do Primeiro Jardim | ACCESSORY | EPICO | Épico | Cura pode gerar Semente. |
| `ITEM_R_009` | Raiz Faminta | ACCESSORY | EPICO | Épico | Cura excedente pode virar shield. |
| `ITEM_R_010` | Cinza Eterna | ACCESSORY | EPICO | Épico | Inimigos queimados explodem ao morrer. |
| `ITEM_E_001` | Eco da Geleia | ECHO | RARO | Raro | Pequeno sustain; evolução futura no Arquivo dos Ecos. |
| `ITEM_E_002` | Eco da Mariposa | ECHO | RARO | Raro | Buffs próprios duram um pouco mais. |
| `ITEM_E_003` | Eco do Espinheiro | ECHO | EPICO | Épico | Interação entre Root, espinhos e Stagger. |
| `ITEM_E_004` | Sino Partido | ECHO | RELIQUIA | Relíquia | Toda terceira skill pode repetir parcialmente. |
| `ITEM_E_005` | Memória do Guardião | ECHO | MEMORIA | Memória | Lore do Guardião + efeito único de progressão. |

---

# 3. Contagem

```text
Armas:       6
Secundários: 7
Armaduras:   5
Acessórios: 10
Ecos:        5
TOTAL:      33
```

---

# 4. Regras

- item com raridade variável respeita Stat Budget da raridade sorteada;
- Relíquia possui efeito único e budget reservado para esse efeito;
- Memória não participa de reforja normal;
- armas e secundários respeitam a forma de uso do herói: Bastião usa espada/escudo, Flecha usa arco/aljava, Íris usa cajado/foco ou lanterna; nenhum deles equipa arma ou secundário das outras duas classes;
- armaduras, acessórios e Ecos podem ser compartilhados quando o efeito funciona para o herói; itens cujo efeito exige uma skill ou recurso ausente não entram no pool útil desse herói;
- a compatibilidade completa dos outros cinco heróis fica para seus kits e não é inferida a partir do trio.

### Compatibilidade inicial do trio

| Herói | Armas | Secundários | Armaduras | Acessórios |
| --- | --- | --- | --- | --- |
| Bastião | `ITEM_W_001`, `ITEM_W_003` | `ITEM_S_001`, `ITEM_S_003` | `ITEM_A_001`–`ITEM_A_005` | `ITEM_R_001`, `ITEM_R_003`, `ITEM_R_006`, `ITEM_R_007` |
| Flecha | `ITEM_W_002` | `ITEM_S_006`, `ITEM_S_003` | `ITEM_A_001`–`ITEM_A_003` | `ITEM_R_001`, `ITEM_R_002`, `ITEM_R_003`, `ITEM_R_004`, `ITEM_R_006`, `ITEM_R_007` |
| Íris | `ITEM_W_006` | `ITEM_S_002`, `ITEM_S_003`, `ITEM_S_004`, `ITEM_S_007` | `ITEM_A_001`–`ITEM_A_003` | `ITEM_R_001`, `ITEM_R_002`, `ITEM_R_005`, `ITEM_R_007`, `ITEM_R_009` |

Os intervalos de armaduras indicam compatibilidade física, não disponibilidade no primeiro clear. `ITEM_A_005` continua sendo drop do boss. A Gota de Lúmen (`ITEM_R_001`) só produz valor quando o herói usa o recurso que ela melhora; até esse recurso estar ativo, não oferecê-la como opção útil. O Totem (`ITEM_S_003`) é secundário compartilhado de controle/tenacidade, não escudo, aljava ou arma.

---

# 5. Fontes especiais

## Ruínas de Lúmen

Podem conceder:

```text
Farol Prismático
Engrenagem Impossível
Fragmento Prismático
```

## Pool Regional Relíquia

Pode conter:

```text
Agulha da Viúva
Engrenagem Impossível
Sino Partido
```

Boss possui pool próprio adicional:

```text
Casca do Guardião
Memória do Guardião
```
