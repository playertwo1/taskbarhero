---
id: SLICE_1B_RUN_SPEC
status: DESIGN
certainty: HIPOTESE
---

# SLICE-1B — Run: eventos, recompensas, loot e save mínimo

**Status:** `IMPLEMENTED` (núcleo, textos, tela e camada Argos entregues em 2026-09-29). As escolhas de escopo abaixo são **DECIDIDO**; chances, valores e tabelas são **HIPÓTESE** até o `SLICE-1E`. Os textos dos eventos seguem `DESIGN`, aguardando revisão de Rafael. Este arquivo é a fonte única do desenho do `1B`; recorte de conteúdo em [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md), regras de run/meta em [RUN_META_PROGRESSION](RUN_META_PROGRESSION.md) e contrato de números em [v1 · perfil do Capítulo 1](../06_balance/v1/capitulos/CAPITULO_01.md). Não copia stats, loot ou fórmulas.

## 1. Decisões (Rafael, 2026-09-29)

| Tema | Decisão |
| --- | --- |
| Escolhas na run | **DECIDIDO:** só eventos e Reward Choice. O loadout de skills e a build seguem travados durante a expedição e mudam só no Hub. |
| Loot | **DECIDIDO:** sorteio simples por seed com as tabelas do recorte do slice; sem pity, Smart Loot, Duplicate Protection nem Slot Pity (`LOOT-EXPANSION-1`). As tabelas herdadas vêm da origem v0.4, incorporada à base ativa. |
| Persistência | **DECIDIDO:** save mínimo versionado + tela simples de inventário/equipar/reciclar entre expedições. Hub visual, offline, Ferreiro, Árvore e Echo ficam no `1D`/`1E`. |
| Eventos | **DECIDIDO:** framework orientado a dados + **10 eventos** no slice (o pool inicial de 5 foi ampliado em 2026-09-29 para evitar repetição); 2 janelas fixas mantidas + chance de evento aleatório nas transições entre encontros comuns. |

## 2. Unidades

| Unidade | Papel | Depende de |
| --- | --- | --- |
| `ExpeditionRun` (existente) | Simulação pura e determinística. Ganha nós de pausa: `reward_offered` e `event_offered`, resolvidos por `choose(...)`. | `CombatMath`, `SliceStats` |
| `EventDirector` (novo, puro) | Escolhe e resolve eventos: condições, sorteio por peso, efeitos. RNG **separado** do combate. | catálogo de eventos, flags do save |
| `LootRoller` (novo, puro) | Sorteia drops e ofertas de Reward Choice por seed e tabela. | tabelas do recorte, itens |
| `SliceInventory` (novo, puro) | Regras de equipar, trocar, reciclar e compatibilidade herói/slot. | itens, `SliceItemStats` |
| `SliceSave` (novo) | JSON versionado em `user://`; grava a cada recompensa. | `SliceInventory` |
| Tela de inventário (nova) | Chama a API do `SliceInventory`; sem regra própria. | `SliceInventory`, `SliceSave` |
| `SliceTelemetry` (existente) | Continua só observando; ganha contadores de eventos, ofertas e reciclagem. | eventos do run |

Fluxo: `run.step → eventos → EventDirector/LootRoller → SliceSave → SliceInventory`. Nenhum cálculo de combate lê telemetria, e o combate não conhece o save.

**Determinismo:** dado (rota, seed, build, escolhas) o resultado é idêntico. O `EventDirector` e o `LootRoller` usam streams de RNG derivadas da seed, distintas do RNG de combate; adicionar um evento nunca muda o resultado de uma luta reproduzida no Argos.

## 3. Camada de eventos

**Catálogo:** `data/expedition/events_c1.json`, uma linha por evento com `id`, `kind`, `weight` ou `chance`, `conditions`, `once_per_save`, `choices` (cada uma com `effects`), texto e fonte. Escopo de duração declarado por efeito (encontro, expedição, persistente), conforme [RUN_META_PROGRESSION](RUN_META_PROGRESSION.md).

**Tipos:** `fixed` (posição na rota), `random` (rolado nas transições), `personal` (depende de herói na party), `secret` (chance muito baixa, uma vez por save).

**Condições (vocabulário fechado):** `party_has(hero)`, `hero_level_at_least(hero, n)`, `item_equipped(item|rarity)`, `previous_encounter_no_falls`, `flag(name)`. Condição desconhecida invalida o catálogo no teste de dados.

**Efeitos (vocabulário fechado):** `heal_fraction`, `damage_fraction`, `grant_material`, `grant_reward_choice`, `set_flag`, `reveal_lore` e `modify_next_encounter` (bônus de status da party ou marca no primeiro inimigo, valendo só para o(s) próximo(s) encontro(s), sem persistir). Um evento nunca executa código próprio.

**Janelas:** o Poço de Lúmen (`EVENT_C1_001`) e a Reserva de Resíduo mantêm as posições do [SLICE_1_SCOPE](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md). Cada transição entre dois encontros comuns tem uma chance **HIPÓTESE** de rolar um evento `random`; `personal` e `secret` entram no mesmo sorteio quando as condições valem.

**Guardas de balanceamento (DECIDIDO como regra, valores HIPÓTESE):** nenhum evento é necessário para vencer o boss; segredos dão lore, flags e recompensas pequenas ou não numéricas; o Resíduo total continua dentro do orçamento do [ECON-1](../06_balance/v1/07_ECONOMIA_LOOT.md), verificado no Argos.

### Eventos do slice

Nomes vindos dos candidatos de [DESIGN_SEEDS](../04_content/chapters/chapter_01/DESIGN_SEEDS.md), que não são conteúdo aprovado por si; entram no slice por esta decisão.

| Evento | Tipo | Condição | Escolhas |
| --- | --- | --- | --- |
| Poço de Lúmen | `fixed` | — | curar a party **ou** sacrificar HP por recompensa mais rara |
| Criatura Ferida | `random` | — | salvar, ignorar ou consumir recurso |
| Raiz Oca | `random` | — | abrir (chance de esconderijo com item) ou ignorar |
| Eco Percebido | `personal` | Íris na party | reagir ao Eco: lore e pequeno bônus |
| Árvore Cantante | `random` | — | tocar, cortar ou ignorar |
| Cristal Partido | `random` | — | absorver o poder ou deixar |
| Memorial Esquecido | `random` | — | escolher um herói da party: memória e cura |
| Rastro da Caçada | `personal` | Flecha na party | seguir o rastro ou ignorar |
| O Sobrevivente | `personal` | Bastião na party | proteger ou passar |
| O Observador | `secret` | qualquer party, chance muito baixa, uma vez por save | sem escolha: flag e lore; não ataca nem pode ser enfrentado |

### Valores iniciais propostos — HIPÓTESE (Rafael escolheu propor valores em 2026-09-29; aprovação pendente)

Âncoras: o Argos já simula o Poço curando 35% do HP máximo (`slice_paths.json`, variante `poco_lumen`) e o fôlego entre encontros é 10% só sem baixas. Frações são do HP máximo do herói. Ninguém morre por evento: o custo nunca reduz um herói abaixo de 1 HP.

**Sorteio nas transições** (cada transição elegível entre dois encontros comuns, ~4 por run na rota atual: 1→2, 2→3, 3→4 e 4→5; a ordem é: secreto, depois aleatório):

| Passo | Chance | Efeito |
| --- | --- | --- |
| Secreto | 1% por transição (~4% por run) | rola O Observador, se ainda não visto no save |
| Evento | 25% por transição (~1,0 por run; máximo 2 por run) | escolhe por peso entre os elegíveis |
| Pesos | Criatura Ferida 60, Árvore Cantante 50, Raiz Oca 40, Cristal Partido 30, Memorial Esquecido 30; pessoais 30 cada (Eco Percebido, Rastro da Caçada, O Sobrevivente), só com o herói vivo na party | Com o trio completo o pool tem 8 eventos e cada pessoal aparece em ~1 de cada 4–5 runs; **um evento não se repete na mesma run** |

**Eventos:**

| Evento | Opção | Custo | Ganho |
| --- | --- | --- | --- |
| Poço de Lúmen | Curar | — | +35% de HP máximo dos vivos |
| Poço de Lúmen | Sacrificar | −25% de HP máximo de cada vivo (mínimo 1 HP) | Reward Choice de 3 itens com pelo menos 1 Raro garantido; **sem Resíduo extra** (respeita o orçamento) |
| Criatura Ferida | Salvar | −10% de HP máximo da party | 1 item Comum e flag de lore |
| Criatura Ferida | Ignorar | — | — |
| Raiz Oca | Abrir | 20%: espinhos, −10% de HP máximo da party | 15%: esconderijo na raiz com 1 item Incomum (a rota e os encontros não mudam); 65%: nada |
| Raiz Oca | Ignorar | — | — |
| Eco Percebido (Íris) | Reagir | — | lore e +5% de dano da party no próximo encontro |
| Árvore Cantante | Tocar | — | +8% de velocidade de ataque da party no próximo encontro |
| Árvore Cantante | Cortar | −5% de HP máximo da party | 1 item Comum |
| Árvore Cantante | Ignorar | — | — |
| Cristal Partido | Absorver | −15% de HP máximo da party | +12% de dano da party nos próximos 2 encontros |
| Cristal Partido | Deixar | — | — |
| Memorial Esquecido | Honrar um herói (a escolha lista os vivos) | — | +15% de HP máximo curado ao herói escolhido e memória de lore desse herói |
| Rastro da Caçada (Flecha) | Seguir | −8% de HP máximo da party (fadiga) | o primeiro inimigo do próximo encontro começa Marcado |
| Rastro da Caçada (Flecha) | Ignorar | — | — |
| O Sobrevivente (Bastião) | Proteger | −15% de HP máximo do Bastião | 1 item Incomum e lore |
| O Sobrevivente (Bastião) | Passar | — | — |
| O Observador | (sem escolha) | — | flag `observador_visto` e lore; sem efeito numérico |

- *Consumir recurso* da Criatura Ferida saiu do slice: não existe consumível (poções ficam desligadas por padrão). Volta com o Alquimista.
- **Medir no `1E`:** frequência real de cada evento, escolha curar × sacrificar, efeito na taxa de vitória na primeira tentativa e no total de Resíduo. Se o sacrifício for dominante ou ignorado, ajusta-se custo e ganho, não a estrutura.
- **Argos:** o Poço vira variante com as duas escolhas e a Raiz Oca com esconderijo forçado, para medir o pior e o melhor caso sem depender de sorte.

**Textos de lore escritos (2026-09-29):** fonte única em [`data/expedition/event_texts_c1.json`](../../data/expedition/event_texts_c1.json); [EVENT_TEXTS.md](../04_content/chapters/chapter_01/EVENT_TEXTS.md) é vista derivada. O conteúdo está em `DESIGN`, aguardando revisão de Rafael. A forma de `modify_next_encounter` está implementada em `EventDirector`/`ExpeditionRun` para os usos deste recorte.

## 4. Recompensas e loot

- **Drop comum:** cada inimigo derrotado rola a tabela do recorte (Comum/Incomum/Raro) com a seed da run. Fonte das chances herdadas: [CHAPTER_01_ENEMIES_CANONICAL.json](../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json); a renormalização para o recorte é `EM ABERTO` (BALANCE-FOUNDATION-1).
- **Reward Choice:** elite e mini-boss oferecem 1 item entre 3; o jogador escolhe pela tela, sem pausa de combate.
- **Boss:** Casca do Guardião (Relíquia) e equipamento Épico garantido no primeiro clear, conforme o recorte.
- **Sem Echo aleatório:** a chance de Echo continua desativada; a entrega da Sentinela é `1D`.

## 5. Inventário e reciclagem

- Equipar e trocar só entre expedições. O loadout fica travado durante a run; itens achados vão ao inventário sem substituir peças equipadas.
- **Reciclar (HIPÓTESE):** rende Resíduo de Lúmen (`MAT_C1_LUMEN_RESIDUE`), o único material do recorte. Tabela proposta: Comum 1, Incomum 2, Raro 3, Épico 5. O Reforço +1 do `1D` custa 5 Resíduos e o mínimo garantido antes do boss já cobre um Reforço; reciclar é opcional. Rendimento real **EM ABERTO** até simulação do ECON-1.
- Sem descarte destrutivo automático e sem venda por ouro (não há fonte/sink definido).

## 6. Save mínimo

`SliceSave` (JSON, campo `version`): inventário, equipado por herói, XP/nível do trio, fases concluídas, Resíduo, flags de eventos (`once_per_save`). Grava ao receber cada recompensa. Versão desconhecida é rejeitada **sem apagar** o arquivo. Sem progresso offline, sem nuvem. HP volta cheio ao fim da expedição, conforme [RUN_META_PROGRESSION](RUN_META_PROGRESSION.md).

## 7. Testes e evidência

Cada item fecha com teste novo em `tests/unit/` e a suíte completa passando:

1. Rota com seed e escolhas fixas: mesmo loot, mesmos eventos, mesmo resultado; combate idêntico com o `EventDirector` ligado ou desligado.
2. Condições: `personal` só aparece com o herói na party; `secret` respeita `once_per_save`.
3. Catálogo: toda condição e efeito pertence ao vocabulário; nenhum evento sem escolha válida.
4. Poço e Reward Choice: cada opção altera o estado esperado.
5. `SliceInventory`: equipar, trocar, reciclar, compatibilidade e travamento durante a run.
6. `SliceSave`: ida e volta sem perda; versão desconhecida preserva o arquivo.
7. Argos: cenário com loot e eventos mede itens equipáveis por run, Resíduo total contra o orçamento e frequência de cada evento.

## 8. Fora do `1B`

Progresso offline, Hub visual, Ferreiro, Árvore dos Ecos, Echo, QA mobile formal (etapa `1E`), pity, Smart Loot, Duplicate Protection, eventos além dos 10, eventos que pulam encontros (descartados por reduzir XP e loot), Comerciante Gremlin (sem ouro/moeda no slice) e os eventos pessoais dos outros 5 heróis (capítulo completo).
