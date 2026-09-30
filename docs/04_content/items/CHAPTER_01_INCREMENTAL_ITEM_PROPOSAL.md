---
id: CHAPTER_01_INCREMENTAL_ITEM_PROPOSAL
status: DESIGN
certainty: HIPOTESE
---

# Capítulo 1 — proposta integrada de progressão e equipamento

**HIPÓTESE de design para simulação, não conteúdo runtime.** A direção de Rafael é que o
Guardião seja uma conquista incremental após tentativas com derrota e progresso
persistente. Nível da fase não limita o nível do herói. Esta proposta de itens
está em revisão: armas são exclusivas de personagem; secundários, armaduras,
acessórios e Ecos devem poder ser usados pelos três heróis quando seus efeitos
forem universais. O slice usa Comum, Incomum, Raro e Épico; Épicos são apenas
recompensas de boss. A escala dos atributos foi decidida em **10×** (Rafael,
2026-09-30); a migração e a matriz de valores seguem na próxima etapa
BALANCE-1 do roadmap. As decisões de orçamento, incluindo a
escada de nove níveis de raridade, estão em
[v1 · itens e raridade](../../06_balance/v1/04_ITENS_RARIDADE.md).
Portanto, os valores
numéricos e as chances desta proposta antiga não são base para runtime até a
revisão da escala e dos budgets.

## 1. Curva de tentativas

- O Guardião pode ser tentado antes do nível 10. Testar nível 10 como centro das
  primeiras vitórias, não como requisito ou trava. Medir níveis 7, 10 e 15.
- XP, itens e materiais obtidos antes da derrota persistem ao voltar ao Hub;
  HP se recupera no Hub. Skills e equipamento são escolhidos no Hub. Esses
  pontos são condições do modelo de teste, não prova do runtime do slice.
- A primeira derrota deve mostrar uma melhoria alcançável no Hub. Testar
  tentativas que terminam nos encontros 6 (elite), 9 (mini-boss) e 10 (boss),
  com 2–5 tentativas até a primeira vitória como faixa de exploração, não meta
  fechada. Não garantir vitória por contagem de derrotas.
- O Tier 1 abre no nível 10 pelo HERO_STANDARD. Verificar que a vitória também
  seja possível antes dele com boas escolhas e que nível 15 reduza a pressão
  sem tornar todos os ataques irrelevantes.

### XP por abate — hipótese para a matriz

O runtime legado exige 645 XP acumulados para nível 10. A rota proposta tem
21 abates antes do boss: 7 comuns de fase 1, 6 de fase 2, 4 de fase 3,
2 de fase 4, uma elite e um mini-boss. Contar adds como comuns e conceder XP
integral a cada herói da party, sem divisão por três.

| Inimigo / nível de conteúdo | XP por abate | Abates | XP |
| --- | ---: | ---: | ---: |
| Normal, fase 1 | 10 | 7 | 70 |
| Normal, fase 2 | 12 | 6 | 72 |
| Normal, fase 3 | 14 | 4 | 56 |
| Normal, fase 4 | 16 | 2 | 32 |
| Geleia Anciã (elite) | 35 | 1 | 35 |
| Rainha das Geleias (mini-boss) | 60 | 1 | 60 |
| **Total pré-boss de uma rota completa** | | **21** | **325** |

Assim, duas rotas completas pré-boss renderiam 650 XP, suficiente para o
nível 10; derrotas antecipadas tornam necessário mais tentativas. Boss: hipótese
de 100 XP, add da fase 5: 18 XP. O boss não concede XP antes de ser vencido.
XP deve ser pago por abate e preservado mesmo na derrota, sujeito à verificação
do contrato de economia. Não duplicar XP quando um add é invocado duas vezes.

## 2. Compatibilidade proposta

**DECIDIDO por Rafael:** armas são exclusivas de cada personagem. Os demais
slots são compartilháveis por Bastião, Flecha e Íris; seus efeitos não podem
depender de uma skill ou recurso que só um deles tenha.

| Categoria | Bastião | Flecha | Íris | Compartilhamento |
| --- | --- | --- | --- | --- |
| Arma | espadas/martelos do Bastião | arcos da Flecha | cajados da Íris | exclusiva do personagem |
| Secundário | todos os modelos universais | todos os modelos universais | todos os modelos universais | sim |
| Armadura | todos os modelos universais | todos os modelos universais | todos os modelos universais | sim |
| Acessórios I/II | todos os modelos universais | todos os modelos universais | todos os modelos universais | sim |
| Echo | todos os modelos universais | todos os modelos universais | todos os modelos universais | sim |

O catálogo adaptado usa `ITEM_W_001` como espada de madeira de Bastião,
`ITEM_W_002` como arco de Flecha e `ITEM_S_001` como escudo de Bastião.
Adiciona `ITEM_W_006` Cajado Prismático, `ITEM_S_006` Aljava da Trilha e
`ITEM_S_007` Foco de Micélio. Os outros IDs existentes não foram renumerados.

## 3. Famílias de item e versões de raridade

Cada linha é um **template** com versões Comum, Incomum, Rara e Épica. A versão
Épica só pode vir de recompensa de boss; ela aumenta os atributos e pode trazer
um modificador que muda a forma de usar o item. Os valores quantitativos e o
budget estão suspensos até a matriz na escala 10× descrita em
[v1 · itens e raridade](../../06_balance/v1/04_ITENS_RARIDADE.md). A lista
abaixo conserva ideias já registradas; a matriz de compatibilidade anterior do
catálogo canônico será reconciliada depois, sem alterar IDs/runtime nesta etapa.

| Template proposto | Usuário | Incomum | Raro | Épico |
| --- | --- | --- | --- | --- |
| Galho de Vigília (`ITEM_W_001`) | Bastião | ATK e DEF | golpe após Perfect Block aplica Stagger | Contra-Golpe atinge também o inimigo que ameaça o aliado mais ferido; recarga própria |
| Broquel de Casca (`ITEM_S_001`) | Bastião | HP e DEF | escudo recebido também protege por breve tempo o aliado mais ferido, com valor dividido | Perfect Block bem-sucedido renova uma fração do escudo já ativo, sem criar HP permanente |
| Arco de Folha Tensa | Flecha | ATK e chance crítica | após aplicar Marca, +20% velocidade de ataque por 2 s, recarga 25 s | quando o alvo marcado cai, transfere Marca uma vez; não duplica procs |
| Aljava da Trilha (`ITEM_S_006`) | Flecha | ATK e pequeno bônus de crítico | Flecha Perfurante ganha Stagger contra alvo marcado | Rajada prioriza alvo marcado e um segundo alvo; dano total limitado pelo budget |
| Cajado Prismático (`ITEM_W_006`) | Íris | ATK e Skill Haste | dano em dois alvos reduz parcialmente recarga da skill equipada de maior prioridade, com recarga interna | Fratura Arcana deixa zona breve que reduz velocidade de ataque, sem novo stun |
| Foco de Micélio (`ITEM_S_007`) | Íris | Skill Haste e Shield Power | Véu de Micélio alcança também o aliado de menor HP quando a condição de ativação dispara | parte do escudo não consumido vira cura limitada ao expirar; sem recuperar HP fora do combate |
| Couraça de Musgo | compartilhada | HP e DEF | após golpe grande, redução breve do próximo golpe | a proteção passa a cobrir um aliado se o usuário permanecer acima de 50% HP |
| Olho de Vidro Verde | compartilhado quando Marca for útil | — | crítico aplica Marca com recarga interna | —; a faixa canônica permite apenas Raro |
| Fragmento Prismático | Íris no trio | — | acerto em 2 alvos recupera parte da recarga, com teto por janela | o gatilho também beneficia uma skill aliada, com recarga interna |

Os efeitos por raridade da tabela são hipóteses; “—” significa variante fora
da faixa anterior do template e ficará sujeita à revisão: nesta proposta de
slice, todas as raridades Comum–Épico serão consideradas para cada template.
Itens compartilhados precisam funcionar para os três heróis. Efeitos ligados
a skill exclusiva serão substituídos por um gatilho universal ou restritos à
arma daquele personagem. A compatibilidade e as faixas v0.4 são fonte de
referência, não confirmação desta revisão local.

### Expansão de variedade em avaliação

As opções abaixo ampliam escolhas sem criar uma arma compartilhada. São nomes
e identidades candidatas, sem IDs novos; cada item deverá receber atributos nas
quatro raridades depois da decisão de escala.

| Slot | Item candidato | Identidade / decisão de build |
| --- | --- | --- |
| Arma — Bastião | Martelo do Javali | Ataques mais lentos e fortes; favorece Stagger. |
| Arma — Bastião | Lâmina do Guardião | Contra-ataques após bloquear. |
| Arma — Flecha | Arco de Espinhos | Crítico e dano contra inimigos marcados. |
| Arma — Flecha | Arco do Vento Oco | Velocidade de ataque e reposicionamento. |
| Arma — Íris | Bastão de Micélio | Controle e duração de efeitos. |
| Arma — Íris | Cetro Prismático | Acertos em vários alvos e recarga. |
| Secundário | Bússola de Lúmen | Recarga após esquiva ou reposicionamento. |
| Secundário | Lanterna de Esporos | Intensifica lentidão e efeitos de estado. |
| Armadura | Manto de Folhas | HP e mobilidade. |
| Armadura | Túnica de Esporos | Recarga e resistência a efeitos. |
| Acessório | Talismã do Salto de Lúmen | Bônus após esquiva ou reposicionamento. |
| Acessório | Pétala do Primeiro Jardim | Cura excedente pode virar escudo. |
| Acessório | Raiz Faminta | Sustentação e proteção em combates longos. |
| Echo | Eco da Mariposa | Prolonga bônus temporários do portador. |
| Echo | Eco da Geleia | Recuperação limitada durante o combate. |

Echoes que hoje dependem de uma skill específica, incluindo *A Sentinela que
Ficou*, precisam de adaptação antes de serem tratados como compartilháveis.
Esta tabela não aprova os itens nem altera o recorte/runtime vigente.

### Orçamento verificável do efeito de velocidade

Pelo v0.4, acessório Raro com IP 20 tem `4 BP × 0,9 slot ×
(0,60 + 0,80 × 20/100) = 2,736 BP`. Uma versão permanente de +20%
velocidade custaria `20/0,60 = 33,33 BP`, impossível nesse slot. A hipótese
`+20% por 2 s / 25 s` tem uptime máximo de 8% e custo médio inicial de
`20 × 0,08 / 0,60 = 2,667 BP`, deixando apenas 0,069 BP para outros
atributos se fosse um acessório Raro. Como a proposta é um **arco Raro**,
seu budget IP 20 é `4 × 1,2 × 0,76 = 3,648 BP`, restando ~0,981 BP.
Se Marca tiver uptime menor ou houver burst acima do valor médio, recalcular.

## 4. Drops propostos para uma primeira vitória incremental

**Alternativa local às tabelas canônicas, ainda não aprovada.** Primeiro rolar
equipamento; depois raridade; então escolher template compatível com inimigo,
região e pelo menos um herói ativo. Rolls Signature são independentes e precisam
de teto para não somar chances sem intenção. Itens persistem na derrota apenas
se o abate que os gerou ocorreu. Equipar é no Hub.

| Fonte | Chance de equipamento | Comum | Incomum | Raro | Épico |
| --- | ---: | ---: | ---: | ---: | ---: |
| Inimigo comum | 12% por abate | 65% | 30% | 5% | 0% |
| Primeira vitória na elite | 1 garantido | 0% | 70% | 30% | 0% |
| Repetição da elite | 1 garantido | 0% | 70% | 30% | 0% |
| Primeira vitória no mini-boss | 1 garantido | 0% | 0% | 100% | 0% |
| Repetição do mini-boss | 1 garantido | 0% | 0% | 100% | 0% |
| Primeira vitória no boss | 1 garantido | 0% | 0% | 0% | 100% |
| Repetição do boss | 1 garantido | 0% | 0% | 20% | 80% |

Raridade é condicional à queda de equipamento. Portanto um comum dá Raro
com chance absoluta `12% × 5% = 0,6%` por abate. Nos 15 comuns dos 7
encontros, o valor esperado é `15 × 0,12 = 1,8` equipamentos e a chance de
ao menos um é `1 − 0,88^15 = 85,3%`. A chance de pelo menos um Raro nesses
15 abates é `1 − 0,994^15 = 8,6%`; não financiar uma build necessária com
esse evento. Elite e mini-boss dão marcos determinísticos após serem vencidos.
Comuns devem ter pool de template distribuído por função, sem garantia de
um slot específico; proteção contra azar deve ser medida por **item útil**,
não apenas por raridade.

### Fontes candidatas dos três templates novos

Para não deixar um herói sem arma/secundário na curva inicial, incluir os
templates novos no pool **condicional ao equipamento genérico** dos inimigos
abaixo. Peso é dentro do pool compatível daquele inimigo, não chance absoluta
por kill; o Drop Resolver ainda precisa ser migrado e validado.

| Template | Inimigos comuns candidatos | Peso candidato no pool de equipamento | Chance absoluta aproximada por abate, se equipamento = 12% |
| --- | --- | ---: | ---: |
| `ITEM_W_006` Cajado Prismático | Mariposa Luminosa, Espírito de Raiz | 20% | `0,12 × 0,20 = 2,4%` |
| `ITEM_S_006` Aljava da Trilha | Gremlin de Folhas, Raposa Oca | 20% | `0,12 × 0,20 = 2,4%` |
| `ITEM_S_007` Foco de Micélio | Cogumelo Sonolento, Espírito de Raiz | 20% | `0,12 × 0,20 = 2,4%` |

Os pesos restantes (80%) permanecem para templates compatíveis do catálogo;
se o pool real tiver outra chance de equipamento, usar essa chance no produto.
Na primeira vitória da elite, gerar o item garantido para um dos heróis da
party cujo slot de arma/secundário esteja mais fraco, respeitando a raridade;
isso é hipótese anti-frustração, não smart loot já implementado. Medir se a
regra favorece demais uma classe ou elimina decisões de item compartilhado.

**Conflito explícito com o recorte atual:** o v0.4 permite Épico antes do boss,
mas o SLICE_1_SCOPE o retira dos drops normais e reserva o garantido para a
primeira vitória. Esta proposta segue esse recorte. As chances acima substituem
as tabelas de raridade do v0.4 somente se Rafael aprovar a revisão local.
Relíquia e Memória permanecem fora da tabela comum; a Casca do Guardião e a
Memória exigem decisão própria de budget e primeira vitória.

## 5. O que medir antes de aprovar

Simular seeds de combate e loot em pelo menos três trajetórias de derrota:
na elite, no mini-boss e no boss. Registrar XP/nível por tentativa, tempo até
Tier 1, itens úteis por herói, peças repetidas, ganho real de DPS/EHP/controle,
HP ao entrar em cada encontro e chance de vencer por build. Comparar com boss
fixo e com escala parcial, sem escalá-lo automaticamente ao nível do herói.
Alvo de playtest humano: progresso percebido após cada derrota e primeira
vitória desafiadora; não inferir satisfação somente de uma taxa simulada.
