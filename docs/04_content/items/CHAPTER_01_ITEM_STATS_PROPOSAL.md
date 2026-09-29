---
id: CHAPTER_01_ITEM_STATS_PROPOSAL
status: DESIGN
certainty: HIPOTESE
---

# Status propostos dos 33 equipamentos — Capítulo 1

**Não são valores runtime.** Esta é a fonte única da proposta numérica dos
afixos-base para todos os 33 templates do catálogo adaptado. Identidade, compatibilidade
e raridades permitidas estão no `CHAPTER_01_ITEM_CATALOG.md` adaptado. Não
gerar uma variante fora da faixa daquele catálogo. Efeitos funcionais de
raridades altas ainda precisam ser precificados e **subtraídos** do orçamento
abaixo antes de qualquer migração para `/data`.

## Cálculo de qualquer roll

1. `BP_bruto = BP_raridade × mult_slot × (0,60 + 0,80 × IP/100)`.
   BP: Comum 2, Incomum 3, Raro 4, Épico 5. **HIPÓTESE local** para itens
   especiais sem BP canônico: Relíquia 6, Memória 6. Multiplicadores: arma e
   armadura 1,20; secundário e Echo 1,00; acessório 0,90.
2. Reservar `BP_efeito = BP_bruto × fração_efeito`: Comum 0%, Incomum 10%,
   Raro 20%, Épico 35%, Relíquia 50%, Memória 60%. Então
   `BP_status = BP_bruto − BP_efeito`. A reserva é hipótese de orçamento e
   **não prova** que o efeito funcional projetado caiba nela; efeitos de burst,
   proc ou controle que custem mais exigem reduzir os afixos-base.
3. Distribuir `BP_status` pelas frações da tabela. Para `b` BP em cada status:
   ATK flat `+b × 1% × ATK_REF(nível_do_item)`; HP flat `+b × 1% ×
   HP_REF(nível_do_item)`; DEF flat `+b × 1% × DEF_REF(nível_do_item)`;
   velocidade de ataque `+b × 0,60%`; crítico `+b × 0,35 ponto percentual`;
   Skill Haste `+b × 1,20 rating`; Tenacidade `+b × 1,50 rating`.
4. Precisão interna sem arredondamento; arredondar apenas para UI. O nível do
   item usado na referência precisa ser gravado no roll. IP não é nível do
   herói nem raridade.

Frações somam 100%; `A`=ATK, `H`=HP, `D`=DEF, `V`=velocidade de ataque,
`C`=chance crítica, `S`=Skill Haste, `T`=Tenacidade.

| ID | Slot | A | H | D | V | C | S | T | Direção |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `ITEM_W_001` | arma | 70% | — | 30% | — | — | — | — | espada inicial de Bastião |
| `ITEM_W_002` | arma | 65% | — | — | — | 35% | — | — | arco da Flecha |
| `ITEM_W_003` | arma | 60% | — | 40% | — | — | — | — | espada pesada de Bastião |
| `ITEM_W_004` | arma | 55% | — | — | 20% | 25% | — | — | lâmina da Raposa; herói futuro compatível |
| `ITEM_W_005` | arma | 55% | — | — | 20% | 25% | — | — | Agulha da Viúva; Relíquia de herói futuro |
| `ITEM_W_006` | arma | 70% | — | — | — | — | 30% | — | cajado da Íris |
| `ITEM_S_001` | secundário | — | 45% | 55% | — | — | — | — | escudo de Bastião |
| `ITEM_S_002` | secundário | 35% | — | — | — | — | 65% | — | lanterna da Íris |
| `ITEM_S_003` | secundário | — | — | 40% | — | — | — | 60% | totem compartilhável |
| `ITEM_S_004` | secundário | 50% | — | — | — | — | 50% | — | farol da Íris, só Épico |
| `ITEM_S_005` | secundário | 40% | 30% | — | — | — | 30% | — | Engrenagem; Relíquia de Forja |
| `ITEM_S_006` | secundário | 65% | — | — | — | 35% | — | — | aljava da Flecha |
| `ITEM_S_007` | secundário | — | 55% | — | — | — | 45% | — | foco da Íris |
| `ITEM_A_001` | armadura | — | 70% | 30% | — | — | — | — | armadura leve |
| `ITEM_A_002` | armadura | — | 60% | 40% | — | — | — | — | armadura compartilhada |
| `ITEM_A_003` | armadura | — | 30% | 70% | — | — | — | — | armadura defensiva |
| `ITEM_A_004` | armadura | — | 50% | 50% | — | — | — | — | só Épico, Bastião |
| `ITEM_A_005` | armadura | — | 55% | 45% | — | — | — | — | Casca do Guardião, Relíquia |
| `ITEM_R_001` | acessório | — | 50% | — | — | — | 50% | — | Gota de Lúmen; recurso ainda sem custo em BP |
| `ITEM_R_002` | acessório | — | — | — | — | — | 65% | 35% | Esporo Sonolento, controle |
| `ITEM_R_003` | acessório | 50% | 50% | — | — | — | — | — | Talismã de mobilidade |
| `ITEM_R_004` | acessório | 40% | — | — | — | 60% | — | — | Olho de Vidro; só Raro |
| `ITEM_R_005` | acessório | 30% | — | — | — | — | 70% | — | Fragmento Prismático |
| `ITEM_R_006` | acessório | 60% | — | — | — | 40% | — | — | Dente da Raposa |
| `ITEM_R_007` | acessório | — | 65% | 35% | — | — | — | — | Flor de Musgo |
| `ITEM_R_008` | acessório | — | 55% | — | — | — | 45% | — | Pétala, só Épico |
| `ITEM_R_009` | acessório | — | 65% | — | — | — | 35% | — | Raiz Faminta, só Épico |
| `ITEM_R_010` | acessório | 70% | — | — | — | — | 30% | — | Cinza Eterna, só Épico |
| `ITEM_E_001` | Echo | — | 70% | 30% | — | — | — | — | Eco da Geleia, só Raro |
| `ITEM_E_002` | Echo | — | 40% | — | — | — | 60% | — | Eco da Mariposa, só Raro |
| `ITEM_E_003` | Echo | 40% | 30% | — | — | — | 30% | — | Eco do Espinheiro, só Épico |
| `ITEM_E_004` | Echo | 40% | — | — | — | — | 60% | — | Sino Partido, Relíquia |
| `ITEM_E_005` | Echo | — | 60% | — | — | — | 40% | — | Memória do Guardião |

Todos os 33 templates possuem uma distribuição de atributos. Relíquia e
Memória usam a hipótese explícita de 6 BP **somente para teste**; a equivalência
não é regra do v0.4. Seus efeitos únicos usam pelo menos metade desse budget.
Itens obtidos do boss não financiam a primeira vitória nele.

**Tabela calculada de versões:** `python tools/balance/export_chapter1_item_variants.py`
gera `CHAPTER_01_ITEM_VARIANTS_IP20_L10.csv`: 70 variantes legalmente permitidas
pelas faixas de raridade dos 33 templates, comparadas no mesmo IP 20 e nível
de item 10. Esses dois valores são uma régua de comparação, não a regra de
drop; uma peça real usa o IP/nível do próprio roll. O CSV é derivado deste
documento e do catálogo, não uma segunda autoridade.

## Exemplos reproduzíveis sem efeito funcional

Se IP=20 e nível do item=10, o HERO_REFERENCE tem ATK `12+38×9/99=15,455`,
HP `115+355×9/99=147,273`, DEF `9+27×9/99=11,455`.

- **Cajado Prismático Raro**, se essa raridade cair: `4×1,20×0,76=3,648 BP`.
  Após reservar 20% para efeito, restam `2,918 BP`. Com 70% ATK e 30%
  Haste, dá `+0,316 ATK` e `+1,050 Skill Haste`.
- **Broquel de Casca Raro**: `4×1,00×0,76=3,04 BP`. Restam `2,432 BP`;
  a divisão 45/55 dá `+1,612 HP` e `+0,153 DEF`.
- **Arco de Folha Tensa Raro com efeito de velocidade**: orçamento bruto
  `3,648 BP`. O efeito candidato `+20% AS por 2 s/25 s` custa inicialmente
  `20×(2/25)/0,60=2,667 BP` por uptime médio, **acima** da reserva comum
  de 20% (`0,730 BP`). Este caso exige reserva própria. Restam `0,981 BP` para os
  afixos-base: `+0,0985 ATK` e `+0,120 ponto percentual de crítico` com a
  distribuição 65/35. O burst e o uptime real podem exigir custo maior.

Os exemplos mostram que o v0.4 produz incrementos modestos por peça. Se isso
for pouco perceptível ao jogador, reavaliar a equivalência de BP ou os efeitos
funcionais por simulação da rota inteira; não inflar uma peça isoladamente.
