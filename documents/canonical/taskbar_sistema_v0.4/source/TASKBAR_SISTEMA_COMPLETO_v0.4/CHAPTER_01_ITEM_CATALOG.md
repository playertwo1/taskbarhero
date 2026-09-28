# CHAPTER_01_ITEM_CATALOG.md

> **Versão:** 0.3  
> **Capítulo:** Bosque de Lúmen  
> **Meta:** 30 itens iniciais

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
| `ITEM_W_001` | Galho de Vigília | WEAPON | COMUM | Comum–Épico | Ataque básico; template simples do Bosque. |
| `ITEM_W_002` | Arco de Folha Tensa | WEAPON | INCOMUM | Incomum–Épico | Ataque + crítico; favorece Flecha sem ser exclusivo. |
| `ITEM_W_003` | Presa do Javali de Musgo | WEAPON | RARO | Raro–Épico | Dano físico + Stagger em golpes pesados. |
| `ITEM_W_004` | Lâmina da Raposa Oca | WEAPON | RARO | Raro–Épico | Crítico/mobilidade; bônus breve após reposicionamento. |
| `ITEM_W_005` | Agulha da Viúva | WEAPON | RELIQUIA | Relíquia | Veneno pode causar crítico; build-defining. |
| `ITEM_S_001` | Broquel de Casca | SECONDARY | COMUM | Comum–Épico | Defesa + geração moderada de shield. |
| `ITEM_S_002` | Lanterna de Esporos | SECONDARY | INCOMUM | Incomum–Épico | Status Power; melhora zonas/debuffs. |
| `ITEM_S_003` | Totem da Raiz Antiga | SECONDARY | RARO | Raro–Épico | Tenacidade + interação com Root/controle. |
| `ITEM_S_004` | Farol Prismático | SECONDARY | EPICO | Épico | Arcano + Skill Haste ao acertar múltiplos alvos. |
| `ITEM_S_005` | Engrenagem Impossível | SECONDARY | RELIQUIA | Relíquia | Engenhocas duram mais em troca de poder pessoal de Forja. |
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
Armas:       5
Secundários: 5
Armaduras:   5
Acessórios: 10
Ecos:        5
TOTAL:      30
```

---

# 4. Regras

- item com raridade variável respeita Stat Budget da raridade sorteada;
- Relíquia possui efeito único e budget reservado para esse efeito;
- Memória não participa de reforja normal;
- nenhum item é exclusivo de um herói, mesmo quando favorece uma build;
- itens de build precisam continuar úteis em mais de uma composição quando possível.

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
