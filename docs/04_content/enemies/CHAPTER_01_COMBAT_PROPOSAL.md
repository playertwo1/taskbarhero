---
id: CHAPTER_01_COMBAT_PROPOSAL
status: DESIGN
certainty: HIPOTESE
---

# Capítulo 1 — atributos e skills numéricas dos 17 inimigos

**HIPÓTESE de combate, não runtime.** Identidade, rank, arquétipo, loot e
formações seguem o JSON canônico e o plano de encontros. Todos os 17 registros
do JSON ainda possuem `combat.skills: []`; a tabela abaixo é uma proposta
numérica que precisa ser migrada e simulada.

## Fórmula e amostra reproduzível

Em qualquer encontro: `REF(level) × arquétipo × rank`. HP dos elites,
mini-bosses e boss é multiplicado por 3 **somente** na hipótese local de party;
o ATK não recebe ×3. ATK da tabela inclui o `enemy_damage_scale=0,50`
registrado no contrato do slice. Defesa usa `DEF/(DEF+100)` no dano. Normais
usam o nível do conteúdo do encontro; a tabela mostra um nível representativo.
Não escalar o boss automaticamente com o nível do herói.

| ID | Nível | HP base | ATK após 0,50 | DEF | Golpes/s | Skill candidata: efeito e recarga |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `EN_C1_001` | 1 | 97,75 | 4,50 | 6,75 | 1,00 | Salto: `1,20×ATK` no alvo; 9 s |
| `EN_C1_002` | 2 | 88,94 | 4,02 | 7,42 | 0,80 | Raiz: `0,60×ATK` + imobilização 1 s; 12 s |
| `EN_C1_003` | 2 | 65,22 | 7,12 | 4,64 | 1,25 | Emboscada: `1,50×ATK` na retaguarda, aviso 0,75 s; 11 s |
| `EN_C1_004` | 2 | 166,02 | 5,26 | 11,59 | 0,70 | Investida: `1,60×ATK`, aviso 1,2 s; 15 s |
| `EN_C1_005` | 1 | 80,50 | 3,30 | 6,30 | 0,85 | Pó luminoso: +10% ATK a um aliado inimigo por 5 s; 15 s |
| `EN_C1_006` | 2 | 88,94 | 4,02 | 7,42 | 0,80 | Esporos: −15% velocidade de ataque de um herói por 4 s; 12 s |
| `EN_C1_007` | 3 | 171,04 | 5,43 | 11,93 | 0,70 | Vinhas: `1,30×ATK` em 2 heróis, aviso 1 s; 14 s |
| `EN_C1_008` | 3 | 171,04 | 5,43 | 11,93 | 0,70 | Carapaça: +20% DEF próprio por 6 s; 18 s |
| `EN_C1_009` | 4 | 69,17 | 7,56 | 4,91 | 1,25 | Salto lateral: `1,50×ATK` na retaguarda, aviso 0,75 s; 11 s |
| `EN_C1_010` | 1 | 97,75 | 4,50 | 6,75 | 1,00 | Pulo: `1,15×ATK` no alvo; 10 s |
| `EL_C1_001` | 2 | 231,84 | 5,80 | 8,00 | 1,00 | Onda: `1,30×ATK` em 2 heróis, aviso 1 s; 13 s; adds só da formação |
| `EL_C1_002` | 3 | 393,39 | 6,78 | 13,72 | 0,70 | Investida: `1,80×ATK`, aviso 1,3 s; 16 s |
| `EL_C1_003` | 4 | 159,08 | 9,45 | 5,65 | 1,25 | Espinhos: `1,40×ATK` na retaguarda, aviso 1 s; 12 s |
| `MB_C1_001` | 3 | 726,92 | 7,42 | 9,66 | 1,00 | Onda: `1,35×ATK` em 2 heróis, aviso 1,2 s; 14 s; adds a 70%/35% HP, um por vez |
| `MB_C1_002` | 4 | 1.232,42 | 8,66 | 16,57 | 0,70 | Carga: `1,90×ATK`, aviso 1,5 s; 18 s |
| `MB_C1_003` | 5 | 679,05 | 6,82 | 10,90 | 0,80 | Espinheiro: `1,20×ATK` em 2 heróis + imobilização 1 s, aviso 1,2 s; 16 s |
| `BOSS_C1_001` | 5 | 3.621,62 | 10,35 | 18,92 | 0,70 | Padrões por fase abaixo; +100 Tenacidade |

Exemplo: Geleia nível 1 tem `HP=115×0,85=97,75`, `ATK=12×0,75×0,50=4,50`,
`DEF=9×0,75=6,75`. Boss nível 5: HP base
`(115+355×4/99)×1,40×20=3.621,62`; hipótese de party `×3=10.864,85`.

### Boss: padrão mínimo testável

| Fase | Gatilho | Ação | Recarga e limite |
| --- | --- | --- | --- |
| 1 | início a 70% HP | Golpe de Chifre: `1,50×ATK` no alvo atual, aviso 1,5 s | 14 s |
| 2 | abaixo de 70% | 1 Geleia; Galhada: `1,25×ATK` em até 2 heróis, aviso 1,5 s | add uma vez; Galhada 17 s |
| 3 | abaixo de 35% | Chifre passa a `1,65×ATK`; pausa de 2 s após Galhada | Chifre 14 s; sem novo add |

Skill ofensiva **substitui** o ataque básico da mesma ação; não há golpe
simultâneo. Buff não dá dano instantâneo. Tenacidade reduz duração de controle
por `duração/(1+tenacidade/100)`. Recarga começa após o primeiro básico.
Ataques fortes anunciados de inimigos diferentes não resolvem no mesmo
instante num encontro de até 3. Alvos seguem ameaça, exceto ações de
retaguarda e script do boss.

Ainda faltam resistências elementais, dano de Stagger, chance de acerto e IA
real. `stats_profile`/`resistance_profile` do JSON requerem mapeamento explícito.
