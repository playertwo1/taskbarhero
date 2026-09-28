---
id: CHAPTER_01
status: DESIGN
---

# Capítulo 1 — Bosque de Lúmen

**Status:** `DESIGN` — a direção do Bosque permanece a região inicial. O bestiário, catálogo de equipamentos, materiais e loot canônicos são os da versão v0.4, aprovados por Rafael em 2026-09-28; conteúdo e valores runtime ainda aguardam migração e validação.
**Escopo:** estrutura de campanha, encontros, inimigos, chefes, skills e equipamentos. Não é especificação de balanceamento, aprovação de arte nem autorização para produção em massa.

## Fontes e nível de certeza

- **DECIDIDO:** o Bosque de Lúmen é a primeira região; a espinha do MVP tem cinco fases macro. A party é Bastião, Flecha e Íris. O bestiário canônico do capítulo é o pacote v0.4, com 17 entidades e IDs definidos no [JSON canônico](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json). As entidades distintas no jogo atual ficam listadas como legado em [`LEGACY_RUNTIME_CATALOG.md`](../../LEGACY_RUNTIME_CATALOG.md).
- **DECIDIDO:** o catálogo v0.4 contém 30 equipamentos em cinco categorias, sete materiais e regras canônicas de loot. Consulte os [catálogos v0.4](../../../../documents/canonical/taskbar_sistema_v0.4/README.md). O runtime preserva temporariamente seus registros antigos. As skills deste documento continuam conceitos parciais; consulte o [padrão canônico](../../../../HERO_STANDARD.md) e o [registro central](../../../CONTENT_REGISTRY.md).
- **RECOMENDADO:** preservar as cinco fases macro e a estrutura-base de dez subfases e dar a cada uma encontros com função própria e marcos de progressão. Isso amplia o conteúdo sem invalidar os gates históricos do MVP.
- **HIPÓTESE:** história, composição dos encontros, comportamento detalhado, skills e equipamentos abaixo são propostas originais. A composição passou por simulação de budgets e loot, mas não por validação em runtime.
- **EM ABERTO:** história final, dificuldade/pacing em playtest, composição da party por encontro, detalhes de skills/unlocks e comportamento runtime. A autoridade para IDs, nomes, raridades e regras de loot é v0.4.

Fontes: [`ROADMAP.md`](../../../../ROADMAP.md), [`POCKET_HERO_PROJECT_BRIEF.md`](../../../POCKET_HERO_PROJECT_BRIEF.md), [`REFERENCIAS_TBH.md`](../../../REFERENCIAS_TBH.md), [guia de design incremental](../../../../documents/GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) e [guia de economia e pacing](../../../../documents/GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md). Referências externas deste projeto servem para princípios; nomes, arte, mapas, texto e balanceamento permanecem próprios.

## Promessa do capítulo

**HIPÓTESE narrativa:** a party atravessa o Bosque seguindo rastros de Lúmen que estão ficando fracos, da entrada até as ruínas do santuário. Os inimigos parecem responder a essa mudança, mas sua causa e o papel do Guardião ficam para a história decidir.

**Objetivo de jogo:** ensinar o jogador a ler ameaças, combinar as funções dos três heróis e preparar a party para o Guardião. Cada obstáculo deve introduzir uma razão compreensível para trocar equipamento ou aproveitar uma skill; não deve ser resolvido apenas esperando ou acumulando atributos.

## Estrutura proposta

As cinco fases macro e dez subfases preservam a estrutura aprovada. A proposta atual tem **15 encontros, 32 derrotas de entidades contando adds e formações mistas**. Composições, quantidades e funções de combate estão em [ENCOUNTERS.md](ENCOUNTERS.md), com uma fonte estruturada para simulação em [encounter_plan.json](encounter_plan.json). O plano continua sendo design, não dado runtime.

### Recompensas de primeira conclusão — hipótese para ECON-1

**HIPÓTESE:** cada uma das cinco fases macro concede uma parcela única de Fragmentos de Ressonância ao ser concluída pela primeira vez. O orçamento e a distribuição propostos estão na seção [Árvore dos Ecos do modelo ECON-1](../../../06_balance/ECONOMY_MODEL.md#árvore-dos-ecos); esta ficha define os eventos de conteúdo, sem duplicar valores.

| Fase macro concluída | Evento de primeira conclusão | Função de progressão pretendida |
| --- | --- | --- |
| Entrada do Bosque | Completar a fase após a Trilha dos Marcos Apagados e o Posto de Vigia Tomado. | Primeiro investimento acessível na Árvore. |
| Clareira da Pressão | Completar a fase após a Clareira Micelial e a Ravina do Musgo. | Reforçar ou guardar recursos para desbloqueios maiores. |
| Ninho Silvestre | Completar a fase após a Galeria de Raízes e a Câmara do Micélio. | Marco de progressão associado a um dos minichefes canônicos, após definir o mapeamento de encontros. |
| Covil do Alfa | Completar a fase e derrotar o elite canônica v0.4. | Atingir o orçamento que permite abrir os ramos da Árvore se os Fragmentos forem guardados para essa rota. |
| Santuário do Guardião | Completar a fase após derrotar o Guardião-Cervo de Pedra. | Fechar o orçamento proposto para a rota inicial do Ferreiro; gastos em outros nós podem adiar o serviço. |

Os Fragmentos são registrados uma única vez por fase macro concluída. Se a expedição terminar antes da conclusão, a fase recomeça, mas XP, Ouro e itens já obtidos permanecem salvos; kills repetidos não repetem a recompensa de primeira conclusão, conforme as regras de [run e meta-progressão](../../../03_systems/RUN_META_PROGRESSION.md). A aplicação real aguarda os gates de `CONTENT-1`, `ECON-1` e `SLICE-1`.

### Recompensa opcional para experimentar o Ferreiro — decisão de conteúdo

**DECIDIDO por delegação:** incluir em um evento opcional pré-boss uma recompensa de primeira conclusão, não repetível, de Resíduo de Lúmen (`MAT_C1_LUMEN_RESIDUE`), usando a garantia idempotente v0.4. A proposta de quantidade e o custo da melhoria foram simulados; consulte [ENCOUNTERS.md](ENCOUNTERS.md). O serviço continua opcional e não é requisito para vencer.

**Proposta simulada em `ECON-1`:** evento e custo do primeiro Reforço estão detalhados no [modelo de economia](../../../06_balance/ECONOMY_MODEL.md) e na fonte estruturada do [plano de encontros](encounter_plan.json). São hipóteses de design, não valores runtime. A desmontagem continua voluntária e usa materiais do catálogo v0.4; não introduzir Sucata como recurso paralelo.

### Papel do encontro secundário

**DECIDIDO:** um minichefe canônico v0.4 é um minichefe existente do Capítulo 1. **HIPÓTESE de encontro:** ela pode ensinar a interromper ou priorizar um inimigo de suporte; posicionamento, janelas de ataque e recompensa ainda precisam de design e balanceamento. Ajustar a quantidade de encontros ao ritmo do capítulo sem remover a entidade aprovada do bestiário.

### Fio narrativo candidato

1. Os marcos de luz na trilha começam a falhar.
2. A clareira mostra que algumas criaturas estão reagindo à mudança; o jogador encontra o primeiro suporte inimigo.
3. O ninho revela uma concentração de micélio e oferece o primeiro encontro que combina ameaças.
4. O Alfa bloqueia a rota para o santuário.
5. O Guardião é confrontado no coração das ruínas; o desfecho explica o que acontecia com o Lúmen.

Não definir ainda quem causou a mudança, por que o Guardião combate a party ou o estado final do bosque. São decisões de lore ainda abertas.

## Inimigos e leitura de combate

O bestiário canônico contém **10 inimigos normais, 3 elites, 3 minichefes e 1 boss**. IDs, papéis, arquétipos, stats e loot têm uma única fonte machine-readable no [JSON canônico do Capítulo 1](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json), com regras no [schema de inimigos](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/ENEMY_CANONICAL_SCHEMA.md). A [tabela resumida](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMY_CATALOG.md) é derivada desse JSON.

O MVP ainda carrega 11 IDs de uma versão anterior. Quatro normais e o Guardião-Cervo têm aliases de identidade documentados; os demais são conteúdo runtime legado sem equivalente direto. Não atribuir habilidades, loot ou identidade de um inimigo canônico aos legados por semelhança de nome/arquétipo. Consulte a [ponte de compatibilidade](../../LEGACY_RUNTIME_CATALOG.md).

Os telegraphs, janelas de resposta, comportamentos de elite/minichefe/boss e distribuição pelas subfases estão propostos em [ENCOUNTERS.md](ENCOUNTERS.md); não duplicar aqui stats ou dados de loot.

## Encontros de chefe

O Capítulo 1 canônico tem três minichefes e o Guardião-Cervo de Pedra como boss (`BOSS_C1_001`). A ficha v0.4 define dados e regras comuns; a proposta de localização e leitura de combate está em [ENCOUNTERS.md](ENCOUNTERS.md). Os resultados finais dependem de playtest no `SLICE-1`.

## Skills dos heróis — catálogo inicial

O catálogo deste overview contém **15 conceitos de skills normais: cinco para cada um dos três heróis listados**. É uma seleção parcial e não representa o total canônico por herói, pois as Signature Skills não estão incluídas. São conceitos automáticos e legíveis; não significam que todas serão equipadas ao mesmo tempo. A contagem atual e a meta para o roster completo estão no [registro central](../../../CONTENT_REGISTRY.md). O [Sistema de skills](../../../03_systems/SKILL_SYSTEM.md) e o [padrão canônico dos heróis](../../../../HERO_STANDARD.md) definem slots, Signature Skills e ranks. A distribuição das skills por tier, efeitos dos ranks, cooldowns, potência, duração e alvos continuam **EM ABERTO** e precisam de validação de design. Nenhuma skill deve exigir toques repetitivos.

| Herói | Skill | Efeito pretendido | Sinergia/uso |
| --- | --- | --- | --- |
| **Bastião** | **Amparo de Raiz** | Quando um aliado fica em risco, concede proteção temporária a ele. | Ajuda a party a atravessar investidas do Javali, Alfa e Guardião. |
|  | **Contra-golpe de Casca** | Após defender um golpe anunciado, responde e reduz a guarda do inimigo por uma janela curta. | Abre oportunidade para Flecha e Íris; contra ameaças defensivas e elites do bestiário v0.4. |
|  | **Desafio do Guardião** | Atrai para Bastião um ataque que atingiria um aliado mais frágil. | Protege a retaguarda de investidas do Lobo de Sombra e ataques de chefe. |
|  | **Trama de Escudos** | Uma proteção aplicada a um aliado deixa uma proteção menor nos demais. | Combina sobrevivência da party com a skill Amparo de Raiz; pode ser escolha de defesa em área. |
|  | **Voto da Clareira** | Depois de resistir a uma sequência de golpes, Bastião fortalece a próxima defesa ou contra-ofensiva da party. | Recompensa sobreviver à janela de pressão sem tornar a luta passiva. |
| **Flecha** | **Marca da Caçada** | Marca o alvo prioritário; a party recebe uma oportunidade de dano coordenado. | Cria alvo comum e prepara skills/itens da Íris. |
|  | **Tiro de Ruptura** | Disparo concentrado que aproveita a marca ou uma postura defensiva aberta. | Resposta a inimigos controladores, elites e minichefes do bestiário v0.4. |
|  | **Rajada da Copa** | Dispara uma sequência curta contra um único alvo, com ataques individuais legíveis. | Pressiona janelas de vulnerabilidade de elite e boss sem exigir vários inimigos simultâneos. |
|  | **Flecha de Execução** | Prioriza um alvo ferido e ganha força quando ele se aproxima da derrota. | Acelera a limpeza de inimigos frágeis; a condição exata não está definida. |
|  | **Passo do Rastro** | Após esquivar de um golpe anunciado, dispara um contra-ataque. | Cria uma opção mais arriscada/ofensiva contra Javali, Lobo de Sombra e chefe. |
| **Íris** | **Lança de Lúmen** | Ataque mágico concentrado com bônus contra o alvo marcado ou exposto. | Converte setup da Flecha/Bastião em dano de chefe. |
|  | **Véu de Micélio** | Aplica uma proteção curta à party, acionada por uma condição visível de perigo. | Sustenta lutas longas e oferece uma rota defensiva. |
|  | **Fratura Arcana** | Enfraquece temporariamente a defesa de um inimigo protegido. | Resposta a inimigos protegidos, elites e minichefes do bestiário v0.4; prepara dano dos outros heróis. |
|  | **Pulso Restaurador** | Recupera um aliado em condição crítica. | Opção de recuperação direta, distinta do escudo do Véu de Micélio. |
|  | **Prisma de Retorno** | Um ataque mágico bem-sucedido contra alvo marcado deixa energia para um disparo seguinte mais forte. | Liga setup da Flecha à magia da Íris; cria sequência, sem recurso/moeda manual. |

**Recomendação de implementação:** manter as 15 skills atualmente catalogadas como conceitos de design e testar primeiro uma skill automática por herói. Expandir até a meta registrada no [CONTENT_REGISTRY](../../../CONTENT_REGISTRY.md) após reconciliar listas e fichas. Liberar skills adicionais nos tiers do padrão canônico, seguindo o desbloqueio por nível já decidido. Não criar árvore extensa, energia ou custo de skill sem demonstrar que acrescentam decisões úteis.

## Equipamentos — catálogo total de 30 itens

O catálogo canônico v0.4 tem **30 itens**: 5 Armas, 5 Secundários, 5 Armaduras, 10 Acessórios e 5 Ecos. IDs, nomes, slots, raridade permitida e identidade estão no [catálogo canônico](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ITEM_CATALOG.md); não duplicar as fichas aqui. Os seis slots do herói continuam sendo Arma, Secundário, Armadura, Acessório I, Acessório II e Echo.

O runtime mantém 15 registros antigos (`weapon`, `armor`, `amulet`) com quatro raridades. Eles continuam carregáveis até uma migração explícita; nenhum recebe ID ou identidade de item canônico por semelhança de categoria. Consulte a [ponte de compatibilidade](../../LEGACY_RUNTIME_CATALOG.md).

As sete matérias-primas e suas fontes estão no [catálogo canônico de materiais](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_MATERIAL_CATALOG.md). A ordem, condições e persistência das recompensas estão no [Drop Resolver](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/DROP_RESOLVER_SPEC.md). O recorte funcional do slice precisa ser selecionado sem alterar a autoridade global v0.4.

## Desbloqueios e ritmo

| Marco | O que o jogador aprende/ganha | Estado |
| --- | --- | --- |
| Primeiros encontros | Reconhecer ataques comuns e o próximo objetivo. | Reusar onboarding existente; validar com jogadores. |
| Entrada → Clareira | Receber uma skill automática inicial por herói e aprender a ler seu gatilho. | **Hipótese**; definir gate após medir ritmo. |
| Clareira → Ninho | Primeiro encontro combinado de suporte + ameaça pesada; ensinar prioridade de alvo. | **Hipótese.** |
| Vitória de elite/minichefe | Recompensa determinística que abre uma resposta de build. | **Hipótese**; definir entidade/item/material após mapear os encontros canônicos. |
| Vitória no Santuário | Fechar o capítulo e abrir próxima decisão/campanha. | **Em aberto**; próximo destino não está escolhido aqui. |

Não fixar minutos, nível requerido, XP, ouro ou kill count com as propostas de referência do guia. Usar essas métricas como perguntas de playtest, não requisitos finais.

## Economia, balanceamento e critérios de aceite

Este documento não declara os itens ou bosses balanceados. Antes de implementar números:

1. Registrar fórmula e faixa inicial de HP/dano/XP/recompensa para inimigos, subfases e skills.
2. Para cada item/recurso, declarar fonte (*source*) e saída (*sink*); manter inicialmente XP e ouro, sem moeda nova.
3. Simular o início, o meio e o boss do capítulo, incluindo party/gear improvisados e builds propostas.
4. Medir TTK por encontro, tentativas/vitórias do boss, XP/h, ouro/h, drops úteis/h, tempo até upgrade/unlock e participação de build.
5. Rodar playtest humano sem explicar a interface e observar leitura de ameaça, escolha de alvo/gear e clareza do próximo marco.
6. Ajustar e repetir; simulação elimina extremos, mas não substitui a sensação de jogo.

**Gate de design do Capítulo 1 — PASS quando:**

- cinco fases macro e subfases estiverem aprovadas, com função clara e progressão sem repetição vazia;
- cada inimigo e chefe tiver leitura visual, resposta viável, recompensa e lugar na curva;
- catálogo canônico v0.4 de 17 inimigos, 30 itens e sete materiais estar ligado às cinco fases macro/dez subfases, sem IDs duplicados ou aliases implícitos;
- catálogo respeitar os seis slots do [padrão do herói](../../../../HERO_STANDARD.md) e as regras canônicas v0.4;
- fórmulas, sources/sinks, hipóteses e métricas estiverem registradas;
- artefatos preservarem identidade original e o conteúdo puder ser aprovado sem depender de arte ainda bloqueada pelo ART-0.

Após esse gate, a próxima fatia será definir dados de conteúdo e implementar um segmento curto vertical do capítulo; a produção de arte continua sujeita ao gate ART-0 vigente.
