# Pocket Hero — Incremental Design Guide

> Minimum Sufficient Context para Hermes, Theia, Ergane, Têmis, Research, Daedalus e modelos executores.

## Definição do gênero

Pocket Hero = **Incremental RPG + Idle + Auto-battler + Loot RPG**.

O jogador não deve ficar tocando repetidamente para produzir recurso. Ele toma decisões, configura a party/build e observa essas decisões produzirem resultados.

## Princípio central

Um bom incremental não é um jogo em que os números apenas sobem. É um jogo em que o significado desses números muda conforme o jogador:

- descobre sistemas;
- automatiza tarefas antigas;
- quebra paredes;
- cria sinergias;
- entende melhor as builds;
- comprime conteúdo antigo;
- vê sua máquina de progressão ficar mais eficiente.

## Doutrina do Pocket Hero

1. **Progresso precisa ser visível.**
2. **O jogo deve se desdobrar (unfolding).**
3. **Mecânica antiga deve poder virar automação.**
4. **Presença acelera; ausência não pune.**
5. **Paredes devem gerar decisões.**
6. **RNG nunca é a única saída.**
7. **Upgrades devem criar sinergias.**
8. **Builds dependem do objetivo.**
9. **Conteúdo antigo deve poder voltar a ser útil.**
10. **Prestige somente se mudar o jogo.**
11. **O jogador precisa sempre ver o próximo marco.**
12. **Conhecimento deve gerar eficiência.**
13. **O mundo deve mudar visualmente com a progressão.**
14. **Não transformar idle em trabalho.**
15. **Nada de poder pago.**

## Unfolding

Não mostrar todos os sistemas no início. Sequência sugerida:

1. combate básico;
2. equipamento;
3. segundo/terceiro herói;
4. party;
5. meta-progressão;
6. crafting/forja;
7. Ecos/pets;
8. tracker;
9. desafios/endgame.

Cada novo sistema deve aparecer depois que o jogador já entendeu o anterior.

## Automação como recompensa

| Tarefa inicial | Depois vira |
| --- | --- |
| Equipar loot | Auto-equip por regras |
| Desmontar itens | Auto-salvage + filtros |
| Avançar fase | Auto-advance |
| Repetir boss fácil | Auto-retry |
| Comprar upgrades em massa | Auto-upgrade |

Regra: **não obrigar o jogador experiente a repetir manualmente uma tarefa que já dominou.**

## Decisão ↔ observação

```text
DECIDIR
  ↓
observar
  ↓
ACUMULAR
  ↓
retornar
  ↓
ANALISAR
  ↓
otimizar
  ↓
observar novamente
```

O combate luta sozinho, mas a eficiência depende do jogador.

## Active vs idle

- **Idle:** progresso seguro.
- **Ativo:** oportunidade de otimizar.
- **Offline:** não punir por fechar o jogo.

O ganho ativo deve vir de decisões, não de repetição física de toques.

## Offline progress

Ao retornar, mostrar claramente tempo ausente, inimigos derrotados, XP, ouro, itens, raridades e milestones. MVP: limite inicial de até **8h**, ajustável depois por balanceamento.

## Próximo objetivo sempre visível

Números sem destino viram ruído. Mostrar coisas como:

- `Lv. 47 → Lv. 50: desbloqueia skill`;
- `782/1000 Lobos → Eco do Lobo`;
- `87% até Forja II`;
- `Boss atual → desbloqueia nova região`.

## Upgrades e sinergias

Misturar upgrades numéricos, transformacionais, condicionais, conversões e automações.

```text
Sangramento
   +
Crítico
   +
Explodir sangramento ao critar
   =
BUILD
```

Quando o jogador descobre combinações, progressão vira conhecimento.

## Builds dependem do objetivo

Evitar uma melhor build universal. Possíveis objetivos:

- XP/h;
- ouro/h;
- boss;
- loot;
- sobrevivência;
- offline;
- Eco Corrompido.

## Paredes

### Boa parede

Boss difícil e múltiplas soluções: farmar gear, trocar party, melhorar skill, craftar, melhorar meta-progressão ou buscar Eco.

### Parede ruim

`Espere 17 horas.`

Regra: **o problema não é desacelerar; é desacelerar sem oferecer decisões.**

## Ritmo

```text
crescimento
↓
parede
↓
descoberta
↓
explosão
↓
crescimento
↓
parede maior
↓
nova mecânica
↓
explosão maior
```

## Prestige

Não entra no MVP. Só considerar quando:

- conteúdo antigo puder ser percorrido muito mais rápido;
- o reset abrir novas regras, automações ou árvores;
- a recompensa for previsível;
- o jogador não precisar repetir tutorial lento.

Prestige bom = **compressão + novas possibilidades**.

## Conteúdo antigo continua útil

Regiões antigas podem continuar relevantes por Ecos, bestiário, crafting materials, bounties, desafios, mutações e versões corrompidas.

## Progressão de conhecimento

O jogador deve ficar **melhor**, não apenas mais forte.

```text
iniciante:
maior ATK = melhor

intermediário:
crit + attack speed

avançado:
lifesteal + crit + bleed + breakpoint + buff de party + fase ideal
```

## Feedback visual

Progressão deve aparecer no mundo: equipamentos mudam o herói, auras/partículas surgem, Ecos acompanham a party, cenários ficam mais densos e elites/bosses ganham presença visual.

## Camadas de tempo

| Escala | Progresso |
| --- | --- |
| Segundos | ataque → kill → XP/ouro/loot |
| Minutos | level, item, skill, upgrade |
| Horas | nova fase, herói, sistema, boss |
| Dias | Ecos, bestiário, crafting, builds |
| Longo prazo | biomas, dificuldades, endgame |

Quando uma camada desacelera, outra deve continuar oferecendo movimento.

## Compressão

```text
operário
↓
supervisor
↓
gerente
↓
arquiteto
```

No início o jogador executa ações. Depois define regras. Mais tarde escolhe estratégias. No fim, projeta uma máquina eficiente.

## Anti-padrões

Evitar:

- números subindo sem mudar o jogo;
- prestige com bônus insignificante;
- repetir tutorial após reset;
- clique manual infinito;
- automação tarde demais;
- automação cedo demais;
- esperas sem decisão;
- RNG sem proteção;
- uma build dominando tudo;
- conteúdo antigo inútil;
- muitas moedas cedo;
- muitos menus no início;
- offline fraco;
- ativo obrigatório demais;
- upgrades só de `+1%/+2%`;
- ausência de próximo marco;
- qualquer paywall de poder.

## Aplicação no MVP

- Unfolding gradual.
- Auto-advance/filtros depois do domínio do básico.
- Boss aceita múltiplas soluções.
- Loot aleatório + crafting/garantias.
- Offline até 8h inicialmente.
- Próximo objetivo sempre visível.
- Builds diferentes para XP, ouro, boss, loot e sobrevivência.
- Ecos/bestiário/materiais preservam conteúdo antigo.
- Prestige fora do MVP.
- Todo poder conquistável jogando.

## Métricas

Monitorar:

- tempo até primeiro upgrade;
- tempo até primeiro unlock;
- tempo entre decisões relevantes;
- tempo até parede;
- tempo de recuperação após parede;
- XP/h;
- ouro/h;
- kills/h;
- TTK por onda/boss;
- drops úteis/h;
- retorno ao jogo;
- variedade de builds.

## Checklist para qualquer sistema novo

- Qual problema do jogador resolve?
- Cria decisão ou apenas números?
- Aparece no momento certo do unfolding?
- Torna uma tarefa antiga desnecessariamente manual?
- Pode ser automatizado mais tarde?
- Cria uma nova sinergia/build?
- Adiciona parede sem rota alternativa?
- Existe proteção contra RNG extremo?
- Existe próximo objetivo visível?
- Melhora idle e/ou jogo ativo?
- Mantém conteúdo anterior relevante?
- Funciona sem compra?
- Existe métrica para balancear?
- Pode ser removido sem quebrar o core loop?

## Prompt-base para agentes

```text
Você está trabalhando no Pocket Hero.

Use esta doutrina incremental como regra de design.

Antes de propor um sistema, determine:
1. problema do jogador;
2. decisão nova;
3. momento do unfolding;
4. tarefa antiga que ele comprime;
5. proteção contra RNG;
6. próximo marco;
7. build/sinergia;
8. utilidade no longo prazo;
9. como é conquistado jogando;
10. métrica que valida diversão.

Regras:
- presença acelera; ausência não pune;
- não transformar idle em trabalho;
- nenhuma vantagem paga;
- prestige só com compressão + novas possibilidades;
- paredes devem oferecer escolhas;
- conteúdo antigo não morre inutilmente;
- o jogador deve perceber que ficou mais eficiente por decisões próprias.
```

> **Frase-guia:** O jogo luta sozinho. Mas ele fica bom porque o jogador ensinou a máquina a lutar melhor.

## Referências

- Anthony Pecorella / Game Developer — *The Math of Idle Games, Part I*
- Kongregate — *The Math of Idle Games, Part III*
- Kongregate — *Quest for Progress: The Math of Idle Games*
- estudo acadêmico sobre Neko Atsume (ScienceDirect)
- *The pleasure of playing less* — Kittens Game (Monash University)
- Antimatter Dimensions
- (the) Gnorp Apologue
- The Perfect Tower II
- Rusty's Retirement
- discussões qualitativas em r/incremental_games

O DOCX completo com referências e explicações detalhadas está arquivado em Google Drive → Taskbar.
