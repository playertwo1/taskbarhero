---
id: CHAPTER_01_HERO_COMBAT_PROPOSAL
status: DESIGN
certainty: HIPOTESE
---

# Trio inicial — progressão e skills para a matriz do Capítulo 1

**Fato das fontes:** os três heróis já têm HP, ATK e DEF nos níveis 1 e 100 em
`HERO_STATS_BALANCE.md`; interpolação é linear. AS, crítico, Haste e Tenacidade
não sobem por nível. Cada herói equipa 2 skills normais, de até 5 ranks;
desbloqueios e upgrades são escolhidos no Hub após a expedição. Os números
de skill abaixo são **HIPÓTESE de simulação**, preservando a identidade e as
mudanças funcionais das fichas de Bastião, Flecha e Íris. Não são runtime.

## Atributos derivados, sem itens nem passivas

`stat(L)=stat(1)+(stat(100)-stat(1))×(L-1)/99`; arredondar só na UI.

| Herói | Ganho exato HP/ATK/DEF por nível | L1 HP/ATK/DEF | L5 | L10 | L15 | L100 |
| --- | --- | --- | --- | --- | --- | --- |
| Bastião | +5,455 / +0,323 / +0,626 | 160 / 10 / 18 | 181,82 / 11,29 / 20,51 | 209,09 / 12,91 / 23,64 | 236,36 / 14,53 / 26,77 | 700 / 42 / 80 |
| Flecha | +2,828 / +0,465 / +0,212 | 100 / 14 / 7 | 111,31 / 15,86 / 7,85 | 125,45 / 18,18 / 8,91 | 139,60 / 20,51 / 9,97 | 380 / 60 / 28 |
| Íris | +2,677 / +0,485 / +0,192 | 95 / 15 / 6 | 105,71 / 16,94 / 6,77 | 119,09 / 19,36 / 7,73 | 132,47 / 21,79 / 8,69 | 360 / 63 / 25 |

Bastião ganha mais HP e DEF por nível; Flecha e Íris ganham mais ATK. O
efeito real de um nível depende de DEF inimiga, kit, alvo e itens. Nível 10
abre T1 pelo `HERO_STANDARD`; isso é uma oportunidade de build, não bônus
automático de todos os ranks.

## Skills: rank 1 e evolução funcional proposta

Coeficientes de dano multiplicam ATK final do herói; duração de controle
é reduzida por Tenacidade. Skills com dano substituem o básico naquela ação.
Gatilho configurável pelo jogador no Hub usa os limites abaixo como default.
R2–R5 só existem quando obtidos nos marcos de upgrade; não presumir rank 5
no nível 10.

| Skill | R1: efeito, gatilho e CD | R2 | R3 | R4 | R5 |
| --- | --- | --- | --- | --- | --- |
| Bastião `SKILL_BAS_006` Muralha Viva | aliados protegidos recebem −40% dano à distância por 6 s; antes de ataque à retaguarda; CD14 s | 7 s | +10% DEF aos protegidos enquanto ativa, interpretação provisória de “resistência” | área maior, cobrindo 1 aliado adjacente adicional | Perfect Block prolonga 1 s, no máximo +2 s por uso |
| Bastião `SKILL_BAS_007` Contra-Golpe | postura ao ser alvo de ataque forte: bloqueia pela regra normal de bloqueio e revida `1,80×ATK`, aplicando Desequilíbrio; se Guarda pronta, usa Perfect Block; CD8 s | revida `2,16×ATK` (+20%) | +10 Guarda quando o recurso estiver ativo; cláusula dormente no slice | stun 0,5 s após bloqueio válido | Perfect Block cria onda `0,60×ATK` em até 2 inimigos adicionais |
| Bastião `SKILL_BAS_008` Desafio | quando aliado <70% HP e há inimigo sem provocação: provoca inimigos próximos 4 s; contra aliados, provocados causam −15% dano; CD15 s | alcança até 3 inimigos | 5 s | provocados recebem Desequilíbrio | abate provocado reduz CD restante em 3 s, uma vez por uso |
| Bastião `SKILL_BAS_009` Fortaleza | quando <70% HP: −40% dano recebido por 5 s; CD20 s | 6 s | regenera 1,5% HP máximo/s durante a postura | aliados próximos recebem −10% dano recebido enquanto ativa | postura não pode ser interrompida |
| Flecha `SKILL_FLE_006` Marca | alvo prioritário não marcado: Marca por 6 s; CD12 s; Marca sozinha não altera status | 8 s | Flecha causa +10% dano ao marcado | primeiro acerto aliado prolonga 1 s, uma vez por Marca | ao abater, transfere duração restante para próximo alvo, uma vez |
| Flecha `SKILL_FLE_007` Flecha Perfurante | 1,45×ATK no primeiro alvo e 0,65×ATK no segundo alinhado; CD12 s | alcança terceiro alvo com 0,40×ATK | +20% Stagger no marcado | ignora 15% de escudo temporário, sem ignorar DEF | marcado no fim da trajetória permite segundo disparo de 0,50×ATK, 1 vez por uso |
| Flecha `SKILL_FLE_008` Olho Aguçado | +8 pontos percentuais de crítico por 5 s; iniciar contra elite/mini/boss ou marcado; CD18 s | 6 s | +4 p.p. adicionais contra marcado | primeiro crítico estende 1 s, uma vez | próximo disparo ofensivo após crítico ganha +15% dano, uma vez |
| Flecha `SKILL_FLE_009` Rajada | 3 disparos de 0,55×ATK no alvo prioritário; CD14 s | 4 disparos de 0,48×ATK | contra marcado, último disparo +5 p.p. crítico | último disparo ganha +10% dano se todos os anteriores acertarem | último acerto no marcado estende Marca 1 s, uma vez |
| Íris `SKILL_IRI_001` Lança de Lúmen | 1,55×ATK no alvo prioritário; CD10 s | 1,70×ATK | contra marcado/Desequilibrado +15% dano | segundo alvo próximo recebe 0,45×ATK | acerto no segundo alvo reduz CD restante do Prisma em 1 s, uma vez |
| Íris `SKILL_IRI_005` Prisma de Retorno | após aliado aplicar Marca/Desequilíbrio: 1,40×ATK no alvo preparado; CD14 s | 1,55×ATK | se alvo preparado sobreviver, concede +5% dano do próximo ataque aliado nele | janela de preparação da resposta passa de 3 s para 5 s | se o Trait Feixe Tecido estiver ativo, segundo alvo atingido recebe −10% ATK por 3 s; sem Trait, o alvo principal recebe o debuff |
| Íris `SKILL_IRI_003` Fratura Arcana | alvo com maior DEF: 0,90×ATK e −15% DEF por 5 s; CD15 s | debuff 6 s | contra marcado/Desequilibrado, +20% Stagger | Rede de Micélio reduz AS do alvo em 10% por 3 s | Fratura permanece 1 s extra se alvo preparado, máximo 7 s |
| Íris `SKILL_IRI_002` Véu de Micélio | aliado com menor % HP abaixo de 70% recebe escudo de 20% do HP máximo dele por até 6 s; CD15 s | escudo 22% | escudo também ao segundo aliado com menor % HP, 10% do HP dele | duração 8 s | ao expirar, até 25% do escudo restante cura o portador; máximo 5% HP máximo |

**Restrições verificáveis:** 2 skills equipadas por herói; prioridade e gatilho
ajustados no Hub; sem acúmulo infinito de Marca, escudo ou extensão; efeitos
R5 não podem procá-los novamente. O ganho de Guarda do Contra-Golpe permanece
inativo enquanto Guarda estiver fora do slice. O Trait Feixe Tecido, quando
equipado, cria a área do Prisma sem aumentar o dano principal.

**EM ABERTO:** marcos exatos de obtenção dos ranks, custo de oportunidade em
DPS de cada skill, duração real de Perfect Block, orçamento de Stagger e
suporte a cura direta. O Pulso Restaurador está fora do recorte atual; não
tratá-lo como skill equipada sem revisão do recorte.
