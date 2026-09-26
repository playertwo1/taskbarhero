# Referências TBH e Banco de Ideias — Pocket Hero

## Fontes guardadas

- https://tbhindex.com/pt
- https://mobalytics.gg/gamebase/tbh-task-bar-hero
- https://taskbarhero.org/
- https://www.xmodhub.com/info/blog/tbh-task-bar-hero-tracker-guide/

Esses sites são referências de pesquisa para entender estrutura de progressão, fases, inimigos, heróis, pets, loot e métricas. Não devem ser usados para copiar arte, textos, nomes ou assets.

## Ideias observadas nas referências

### Estrutura de campanha

Uma estrutura interessante é dividir a campanha em atos e estágios e depois reutilizar o conteúdo com dificuldades mais altas.

Para o Pocket Hero, a proposta inicial é:

1. Bosque de Lúmen
2. Distrito Cinzento
3. Mar de Vidro
4. Espinha do Inverno
5. Fortaleza Rubra
6. Eco Corrompido — endgame

Cada região pode conter:

- 6–10 estágios;
- 3–5 famílias de inimigos;
- elites;
- miniboss;
- boss final;
- loot temático;
- pet/Eco associado.

## Biomas originais

### Bosque de Lúmen

Tema: floresta antiga, fungos luminosos e ruínas cobertas pela vegetação.

Inimigos possíveis:

- slime de musgo;
- lobo de sombra;
- saqueador da mata;
- xamã de esporos;
- sentinela de raízes.

Elite:

- Lobo Alfa de Lúmen.

Boss:

- Guardião Enraizado.

### Distrito Cinzento

Tema: cidade industrial abandonada, fumaça, metal e autômatos.

Inimigos:

- catador de sucata;
- autômato leve;
- atirador enferrujado;
- drone de faísca;
- cultista da fuligem.

Boss:

- Motor-Coração.

### Mar de Vidro

Tema: litoral cristalizado, cavernas translúcidas e criaturas marinhas alteradas.

Inimigos:

- caranguejo vítreo;
- espectro de sal;
- enguia de cristal;
- saqueador costeiro;
- elemental de maré.

Boss:

- Leviatã Prismático.

### Espinha do Inverno

Tema: montanhas geladas e fortalezas congeladas.

Inimigos:

- lobo branco;
- morto congelado;
- arqueiro do gelo;
- elemental de geada;
- gigante jovem.

Boss:

- Rei da Geada Partida.

### Fortaleza Rubra

Tema: fortaleza vulcânica e tropas corrompidas.

Inimigos:

- legionário rubro;
- cão de cinzas;
- mago de brasa;
- sentinela pesada;
- demônio menor.

Boss:

- General da Fornalha.

## Eco Corrompido

Modo de endgame que reutiliza regiões existentes de forma transformada.

Ideias:

- modificadores de dificuldade;
- inimigos mutantes;
- variantes corrompidas de bosses;
- melhor loot;
- efeitos visuais adicionais;
- recurso consumível para entrar;
- escolha de intensidade;
- combinações aleatórias de afixos.

Isso aumenta variedade sem exigir construir regiões totalmente novas para cada etapa de progressão.

## Famílias de inimigos

Em vez de gerar cada criatura isoladamente, produzir famílias visuais.

Exemplo:

```text
Goblin base
├── saqueador
├── arqueiro
├── xamã
├── brutamontes
└── elite
```

Outro:

```text
Esqueleto base
├── espada
├── escudo
├── arqueiro
├── mago
└── campeão
```

Vantagens:

- identidade consistente;
- menos custo de arte;
- mais variedade;
- Daedalus consegue derivar sprites de uma matriz aprovada.

## Heróis / aliados originais

### Bastião
Função: tanque/melee.

- vida alta;
- defesa;
- provocação;
- escudo.

### Flecha
Função: ranged DPS.

- ataque rápido;
- crítico;
- execução.

### Íris
Função: magia/AoE.

- dano elemental;
- explosões em área;
- controle.

### Vesper
Função: sustain/suporte.

- cura;
- regeneração;
- buffs.

### Nóx
Função: controle/debuff.

- veneno;
- redução de defesa;
- lentidão.

### Ruptor
Função: bruiser.

- dano crescente;
- quebra de armadura;
- sobrevivência.

## Grupo

Meta inicial:

- até 3 heróis ativos;
- sinergias por função;
- posicionamento simples;
- combate automático;
- decisão concentrada em composição, equipamento e upgrades.

## Pets / Ecos

Companheiros chamados provisoriamente de Ecos.

Exemplos:

- Eco do Lobo — velocidade de ataque;
- Eco do Slime — regeneração;
- Eco do Corvo — crítico;
- Eco da Tartaruga — defesa;
- Eco do Fungo — resistência a veneno;
- Eco da Brasa — dano elemental.

Desbloqueio pode vir de milestones de combate:

- derrotar determinada quantidade da família;
- completar bestiário;
- matar boss específico;
- concluir desafios.

Bônus permanentes podem ser separados do pet visualmente equipado.

## Loot

Categorias:

- arma;
- armadura;
- amuleto;
- anel;
- relíquia;
- consumível.

Raridades iniciais:

- comum;
- raro;
- épico;
- lendário.

Afixos:

- ataque;
- defesa;
- vida;
- velocidade;
- crítico;
- dano crítico;
- regeneração;
- roubo de vida;
- dano elemental;
- resistência.

## Tracker interno

Métricas úteis para balanceamento:

- EXP/h;
- ouro/h;
- inimigos derrotados/h;
- drops/h;
- raridade por hora;
- tempo médio para matar;
- mortes/h;
- dano recebido;
- ocupação do inventário;
- progresso offline;
- desempenho por região;
- desempenho por composição.

O tracker deve ser ferramenta interna e também pode futuramente virar uma tela de estatísticas para o jogador.

## Sprites necessários no primeiro pacote

### Heróis

- Bastião
- Flecha
- Íris

### Inimigos

- slime de musgo
- lobo de sombra
- saqueador da mata
- xamã de esporos

### Elite

- Lobo Alfa de Lúmen

### Boss

- Guardião Enraizado

### Ecos

- Eco do Lobo
- Eco do Slime
- Eco do Corvo

### Cenário

Camadas:

1. céu/fundo;
2. silhuetas distantes;
3. árvores;
4. chão principal;
5. elementos frontais;
6. partículas ambientais.

## Estratégia para geração por IA

1. aprovar primeiro uma direção de arte;
2. gerar uma sprite-mãe por família;
3. auditar;
4. congelar características principais;
5. derivar variantes;
6. importar no Godot;
7. verificar leitura na tela real do celular;
8. só então aumentar o volume de assets.

## Regra de originalidade

Podemos estudar:

- estrutura;
- pacing;
- funções de classe;
- progressão;
- tipos de inimigo;
- economia;
- métricas.

Não devemos copiar:

- sprites;
- personagens;
- nomes distintivos;
- ícones;
- cenários;
- UI;
- textos;
- assets;
- animações específicas.

A meta é criar um jogo reconhecível como nosso, usando o TBH apenas como uma das referências de gênero.
