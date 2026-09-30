---
id: CHAPTER_01_ITEM_CATALOG_V0_5
status: DESIGN
certainty: HIPOTESE
---

# Catálogo de itens do Capítulo 1

**Catálogo ativo do Capítulo 1** (movido para `docs/04_content/items/` em 2026-09-30). Regras de BP, raridade, IP e exibição: [04_ITENS_RARIDADE](../../06_balance/v1/04_ITENS_RARIDADE.md). Este catálogo parte dos 33 templates
de origem ([CHAPTER_01_ITEM_TEMPLATES_ORIGEM](CHAPTER_01_ITEM_TEMPLATES_ORIGEM.md)) e registra as decisões mais recentes para o trio do
slice. A nova variedade proposta ainda não tem IDs atribuídos; veja a
[proposta de itens](CHAPTER_01_INCREMENTAL_ITEM_PROPOSAL.md).
A escala de combate é 10× (decidida em 2026-09-30); os números de status por item/raridade ficam em aberto até a matriz de BALANCE-1.

## Regras do slice

- Cada template previsto para o slice terá variantes **Comum, Incomum, Raro e
  Épico**. A diferença de atributos cresce por raridade; Épicos podem trazer
  modificadores além dos atributos.
- **Épicos só são obtidos como recompensa de boss.** Não entram nos drops de
  inimigos comuns, eventos, elite ou mini-boss.
- Armas são exclusivas de um personagem. Secundário, armadura, acessórios e
  Echo podem ser equipados por qualquer herói do trio; seus efeitos devem ter
  utilidade universal, sem exigir skill ou recurso exclusivo.
- Os seis slots são Arma, Secundário, Armadura, Acessório I, Acessório II e
  Echo. Acessórios I e II usam a mesma família.
- Estas decisões substituem, para o slice, as faixas de raridade e as
  restrições de compatibilidade herdadas. Não renumerar IDs já registrados.

## Templates herdados e identidade

| ID | Item | Slot | Identidade proposta | Compatibilidade no trio |
| --- | --- | --- | --- | --- |
| `ITEM_W_001` | Galho de Vigília | Arma | Espada de madeira; ataques e defesa. | Bastião |
| `ITEM_W_002` | Arco de Folha Tensa | Arma | Ataque à distância e crítico. | Flecha |
| `ITEM_W_003` | Presa do Javali de Musgo | Arma | Golpes pesados e Stagger. | Bastião |
| `ITEM_W_004` | Lâmina da Raposa Oca | Arma | Crítico e reposicionamento. | Arma exclusiva; portador futuro a definir |
| `ITEM_W_005` | Agulha da Viúva | Arma | Veneno com interação crítica. | Arma exclusiva; portador futuro a definir |
| `ITEM_W_006` | Cajado Prismático | Arma | Ataque arcano, área e recarga. | Íris |
| `ITEM_S_001` | Broquel de Casca | Secundário | Defesa e proteção breve. | Bastião, Flecha e Íris |
| `ITEM_S_002` | Lanterna de Esporos | Secundário | Poder de status e efeitos de área. | Bastião, Flecha e Íris |
| `ITEM_S_003` | Totem da Raiz Antiga | Secundário | Tenacidade e resistência a controle. | Bastião, Flecha e Íris |
| `ITEM_S_004` | Farol Prismático | Secundário | Recarga ao atingir vários inimigos. | Bastião, Flecha e Íris |
| `ITEM_S_005` | Engrenagem Impossível | Secundário | Duração de efeitos em troca de poder. | Bastião, Flecha e Íris; efeito universal a definir |
| `ITEM_S_006` | Aljava da Trilha | Secundário | Precisão, ataque e leitura de alvo. | Bastião, Flecha e Íris |
| `ITEM_S_007` | Foco de Micélio | Secundário | Recarga e potência de escudo. | Bastião, Flecha e Íris |
| `ITEM_A_001` | Manto de Folhas | Armadura | HP e mobilidade. | Bastião, Flecha e Íris |
| `ITEM_A_002` | Couraça de Musgo | Armadura | HP e defesa equilibrados. | Bastião, Flecha e Íris |
| `ITEM_A_003` | Casco Cristalino | Armadura | Defesa e resposta a golpes fortes. | Bastião, Flecha e Íris |
| `ITEM_A_004` | Coração de Pedra | Armadura | Resistência maior com HP baixo. | Bastião, Flecha e Íris |
| `ITEM_A_005` | Casca do Guardião | Armadura | Interação entre escudo e proteção. | Bastião, Flecha e Íris |
| `ITEM_R_001` | Gota de Lúmen | Acessório | Recurso e recarga. | Bastião, Flecha e Íris |
| `ITEM_R_002` | Esporo Sonolento | Acessório | Lentidão e efeitos de status. | Bastião, Flecha e Íris |
| `ITEM_R_003` | Talismã do Salto de Lúmen | Acessório | Mobilidade e bônus após reposicionamento. | Bastião, Flecha e Íris |
| `ITEM_R_004` | Olho de Vidro Verde | Acessório | Crítico que aplica Marca. | Bastião, Flecha e Íris |
| `ITEM_R_005` | Fragmento Prismático | Acessório | Acertos múltiplos e recarga. | Bastião, Flecha e Íris |
| `ITEM_R_006` | Dente da Raposa Oca | Acessório | Dano contra alvos feridos. | Bastião, Flecha e Íris |
| `ITEM_R_007` | Flor de Musgo | Acessório | Cura recebida e regeneração. | Bastião, Flecha e Íris |
| `ITEM_R_008` | Pétala do Primeiro Jardim | Acessório | Cura que pode gerar proteção. | Bastião, Flecha e Íris |
| `ITEM_R_009` | Raiz Faminta | Acessório | Cura excedente convertida em escudo. | Bastião, Flecha e Íris |
| `ITEM_R_010` | Cinza Eterna | Acessório | Explosão ao derrotar alvo afetado. | Bastião, Flecha e Íris |
| `ITEM_E_001` | Eco da Geleia | Echo | Recuperação limitada em combate. | Bastião, Flecha e Íris |
| `ITEM_E_002` | Eco da Mariposa | Echo | Prolonga bônus temporários. | Bastião, Flecha e Íris |
| `ITEM_E_003` | Eco do Espinheiro | Echo | Interação com controle e Stagger. | Bastião, Flecha e Íris |
| `ITEM_E_004` | Sino Partido | Echo | Repete parcialmente uma skill em janela controlada. | Bastião, Flecha e Íris |
| `ITEM_E_005` | Memória do Guardião | Echo | Lore e efeito de progressão universal a definir. | Bastião, Flecha e Íris |

Os efeitos das linhas compartilhadas são identidades de design a adaptar, não
valores ou efeitos runtime aprovados. A Sentinela que Ficou, o Echo atualmente
implementado no slice, ainda depende de Muralha Viva; sua adaptação universal
é uma pendência de design e implementação.

## Faixa quantitativa

Cada item do slice terá quatro registros de status: Comum, Incomum, Raro e
Épico. Os valores são calculados pelas regras de [04_ITENS_RARIDADE](../../06_balance/v1/04_ITENS_RARIDADE.md)
(BP × slot × IP × valor por BP) a partir da distribuição de status de cada template abaixo; o runtime
guarda a distribuição em `stat_weights` de `data/items/items.json` e calcula os números em
`SliceItemStats.gd`. A matriz item × raridade continua EM ABERTO em `BALANCE-1`: não preencher
valores por inferência.

### Distribuição de status por template (HIPÓTESE)

Frações do BP de status de cada template; somam 100%. `A`=ATK, `H`=HP, `D`=DEF, `V`=velocidade
de ataque, `C`=chance crítica, `S`=Skill Haste, `T`=Tenacidade. Movida da antiga proposta de
escala/status em 2026-09-30; para os 18 itens do slice, `stat_weights` em `/data` prevalece.

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

## Novos templates em avaliação

Os itens adicionais sem ID aparecem na [proposta integrada](CHAPTER_01_INCREMENTAL_ITEM_PROPOSAL.md).
Se aprovados, registrar seus IDs no `CONTENT_REGISTRY` e nesta tabela antes da
integração de dados e loot.
