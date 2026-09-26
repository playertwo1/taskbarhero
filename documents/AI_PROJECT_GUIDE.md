---
document_type: ai-project-context-and-build-guide
project_id: pocket-hero
repository: playertwo1/taskbarhero
language: pt-BR
status_as_of: 2026-09-26
authority: summary; defer to Rafael, code/tests, and ROADMAP.md
---

# Pocket Hero — contexto e guia de construção para agentes

> Leia este arquivo para se orientar; consulte o roadmap e a fonte temática antes de agir. Este resumo não prova implementação, não aprova hipóteses e não substitui uma decisão de Rafael.

## 1. Identidade do projeto

- **Nome de trabalho do jogo:** Pocket Hero.
- **Repositório:** `playertwo1/taskbarhero`; o nome do repositório não torna “Taskbar Hero” o nome do nosso produto.
- **TBH / Task Bar Hero:** jogo de referência analisado nos documentos, não é nosso jogo. Use-o somente para aprender princípios e estruturas; não copie conteúdo distintivo ou protegido.
- **Objetivo:** RPG incremental/idle de combate automático, loot e builds, com identidade dark fantasy original, primeiro como aplicativo Android normal.
- **Experiência-alvo:** uma party luta com pouca atenção contínua; o jogador melhora resultados por decisões de equipe, equipamento, progressão e eficiência — não por clicar freneticamente.

## 2. Autoridade e linguagem de certeza

Em caso de conflito, siga esta ordem:

1. Decisão/instrução mais recente de Rafael.
2. Código e testes executados — provam apenas o comportamento que cobrem.
3. [`../ROADMAP.md`](../ROADMAP.md) — sequência e critérios do trabalho.
4. [`../docs/POCKET_HERO_PROJECT_BRIEF.md`](../docs/POCKET_HERO_PROJECT_BRIEF.md) — resumo do projeto e estado registrado.
5. Este guia e os documentos temáticos — fundamentos e propostas; não superam os itens acima.

Ao escrever ou conversar, rotule as afirmações importantes:

- **DECIDIDO:** requisito explícito nos documentos-base.
- **RECOMENDADO:** princípio de design, sujeito a conflito com uma decisão posterior.
- **HIPÓTESE:** número, fórmula ou proposta a simular e testar; nunca apresentar como balanceamento final.
- **EM ABERTO:** depende de escolha/validação de Rafael.
- **STATUS REGISTRADO:** observação com data; conferir de novo se o estado puder ter mudado.

Não marque etapa como concluída por inferência, plano, mock, teste parcial ou texto deste guia.

## 3. Estado registrado e próximo marco

**STATUS REGISTRADO — 2026-09-26:**

- O roadmap mantém `SETUP-01` como primeiro marco e seu checklist ainda está desmarcado; reabra o [`../ROADMAP.md`](../ROADMAP.md) para conferir o estado atual antes de executar.
- A consolidação do projeto registra o MCP `pixel-art` conectado e com health check aprovado, mas ainda sem sprite de teste gerado.
- A mesma consolidação registra Aseprite 1.3.7, abaixo do alvo de instalação 1.3.10+ do roadmap, e Godot 4.7.2 presente mas não validado. A presença de um executável não prova que Godot, Android export ou aparelho estejam prontos.
- Ainda não há evidência registrada de um vertical slice jogável, APK do jogo, save/offline testados ou sessão de jogo validada em aparelho real. Não invente assets, cenas ou testes que ainda não existem.

**Ordem de alto nível prevista:** concluir `SETUP-01` → provar o pipeline artístico com um único Slime (R9/ART-01) → provar o loop e um smoke Android mínimo (R10) → expandir conteúdo após essa prova → validar o slice Android ampliado após R15–R16 → preparar a build candidata ao MVP (R18) → auditoria técnica, visual e de gameplay (R19; só `PASS` fecha o MVP). Veja os gates exatos em `ROADMAP.md`.

**EM ABERTO:** os documentos recomendam testar primeiro um sprite Slime de ponta a ponta, enquanto outro material sugere iniciar o pacote maior `ART-C0-LUMEN`. Não comece produção em lote até Rafael escolher. O guia de UX também recomenda pausar novos guias conceituais e obter aprendizado de um vertical slice real.

## 4. Escopo do MVP

### DECIDIDO / registrado como alvo

- Android primeiro; aplicativo portrait convencional, com combate legível numa faixa na parte inferior.
- Engine planejada: Godot 4.7.2 Standard e GDScript.
- Pixel art original, vista lateral, legível em escala mobile.
- **Bosque de Lúmen**, com cinco momentos/fases: entrada, pressão, ninho/farm, elite e chefe.
- Três heróis originais: **Bastião** (proteção/frontline), **Flecha** (dano à distância) e **Íris** (magia em área).
- Quatro inimigos comuns originais: **Geleia de Lúmen**, **Gremlin de Folha**, **Javali de Musgo** e **Espírito de Raiz**, mais uma elite e o **Guardião-Cervo de Pedra**.
- Combate automático, XP/nível, ouro, equipamento, 15 itens iniciais, save local e progresso offline.
- APK debug instalável, sessão prolongada sem crash e legibilidade validada em aparelho real. O roadmap cita o S25 Ultra como referência de validação; confira a disponibilidade real antes de planejar o teste.
- Todo conteúdo de gameplay conquistável jogando; nenhuma vantagem de poder paga. Monetização não faz parte do MVP.

### Fora do MVP

Overlay sobre outros aplicativos; Google Play/publicação; servidor/backend; contas/login; multiplayer; cloud save; monetização; dezenas de regiões, centenas de itens e o endgame completo de Eco Corrompido. A fase de overlay só começa depois que o MVP estiver aceito.

### HIPÓTESE / confirmar antes de congelar

- Distribuição dos 15 itens em cinco armas, cinco armaduras e cinco amuletos aparece como modelo recomendado no guia de referência; trate como proposta até confirmar no escopo/roadmap.
- O limite offline inicial de 8 horas é hipótese de balanceamento, não regra imutável.
- Canvas de sprite 32×32 versus 48×48 ainda deve ser comparado antes de congelar.
- Tempos de onboarding, custos, razões de crescimento, drop rates, TTK, raridades além do MVP e metas de XP/h/ouro/h são hipóteses: exigem simulação e playtest.

## 5. Doutrina de experiência e design

Aplique estes princípios ao avaliar sistemas; cada proposta ainda precisa de escopo e aceite:

1. **Unfolding:** revelar sistemas conforme o jogador aprende; não despejar menus/tutorial enciclopédico no início.
2. **Progresso legível:** sempre mostrar um próximo objetivo útil; números sem destino viram ruído.
3. **Idle sem trabalho:** presença pode acelerar por decisões; ausência não deve punir nem exigir toques repetitivos.
4. **Automação por domínio:** ensinar a tarefa primeiro e automatizá-la quando ficar repetitiva; automação futura não significa requisito imediato do MVP.
5. **Paredes com escolhas:** desafio deve oferecer pelo menos duas rotas razoáveis (por exemplo, gear, party/build ou crafting/meta-progressão); não resolver tudo com espera.
6. **RNG protegido:** sorte pode variar recompensa, mas não pode ser a única rota para sair de uma parede; prever progresso determinístico, milestones ou crafting direcionado.
7. **Builds com propósito:** testar diversidade por objetivo; não assumir uma build universal.
8. **Crescimento transformacional:** upgrades podem mudar sinergias e comportamento, não apenas somar percentuais pequenos.
9. **Conteúdo antigo com função:** só criar nova camada quando ela trouxer decisão/uso real e puder ser medida.
10. **Sem pressão predatória:** sem paywall de poder, FOMO punitivo, streak que apaga progresso, countdown falso ou energia comprável.
11. **Prestige/Ascensão:** fora do MVP; reconsiderar apenas se comprimir conteúdo antigo e abrir possibilidades novas.

## 6. Economia, pacing e telemetria

Antes de criar recurso, custo, drop, curva, boss ou meta-progressão:

- Defina objetivo de experiência, fórmula/faixa e ponto de progressão que resolve.
- Documente fonte (*source*) e saída (*sink*) para cada moeda/material; comece com poucas moedas. Ouro, XP e talvez um material principal são recomendação, não especificação final.
- Teste curvas no início, meio e fim do conteúdo atual; não espalhe constantes de balanceamento pelo código sem contrato.
- Evite BigNumber no MVP até limites reais de engine/design justificarem.
- Progresso offline deve ser calculado a partir do tempo/desempenho salvo, não simulado frame a frame. Aplicar cada recompensa uma única vez e proteger o save contra corrupção/migração.
- Priorize telemetria local antes de backend. Métricas sugeridas: TTK, win rate de boss, XP/h, ouro/h, kills/h, drops úteis/h, tempo até upgrade/unlock/parede e diversidade de builds.
- Use o ciclo **hipótese → fórmula → simulador → build jogável → playtest humano → telemetria → ajuste → novo teste**. Simulação elimina absurdos; não substitui sensação real de jogo.

## 7. UX, qualidade e critérios de validação

- FTUE deve mostrar a fantasia central em ação e ensinar em contexto; observar um jogador sem contexto e não explicar a interface durante o teste.
- Não comunicar raridade, estado ou erro apenas por cor. Priorizar contraste, hierarquia, texto legível, safe areas e alvos de toque adequados.
- Áudio e haptics são feedback funcional, moderado e configurável; eventos comuns não devem vibrar/soar constantemente.
- Medir performance, memória, bateria e temperatura em vez de assumir otimizações. Em background, não manter simulação contínua; usar cálculo offline.
- Dev Mode, HUD e aceleradores são ferramentas de teste, determinísticas e isoladas da release; nunca dependem de editar save manualmente.
- Separar smoke, teste funcional, balanceamento, UX, dispositivo, sessão longa e teste de primeira experiência (*fresh eyes*).
- R10 prova o loop e um smoke Android mínimo: Bastião + Slime + uma fase do Bosque + primeiro drop + level-up + save mínimo + APK debug. Depois de R15–R16, o guia de UX descreve um **slice Android ampliado** com offline, Dev Mode e telemetria; não confundir seus critérios com R10.
- R18 prepara uma build candidata com MVP jogável, save/offline/tracker e estabilidade; só `PASS` em R19 fecha o MVP. Critérios completos estão no roadmap, não neste resumo.

## 8. Identidade original e uso de referências

TBH serve para estudar estrutura de campanha, sensação de baixa fricção, party, loot e automação. É proibido copiar sprites, assets, nomes distintivos, UI, mapas, textos, tabelas exatas de balanceamento ou lore. Crie silhuetas, nomes, mundo, recompensas e números próprios.

Ao propor algo inspirado externamente, registre: **origem da inspiração → princípio aprendido → adaptação original → risco de semelhança → métrica/aceite**. Separe fonte oficial, fonte de comunidade/datamining, opinião de jogador e decisão original. Datas e fatos atuais sobre jogos/fontes externas precisam de nova verificação; os guias são registros datados, não feed vivo.

## 9. Papéis e pipeline de trabalho

- **Rafael:** dono do produto; decide escopo, trade-offs, artefatos e escolhas em aberto.
- **Theia:** direção, prioridade e definição do escopo.
- **Research:** pesquisa quando houver lacuna; registra qualidade/data da fonte.
- **Daedalus:** contrato e produção de arte; não altera gameplay por conta própria.
- **Têmis:** auditoria independente de arte/código/aceite; quem implementou não aprova o próprio trabalho.
- **Ergane:** implementação e integração no Godot após contrato/aceite.
- **Hermes:** roteamento, contexto mínimo e handoff.
- **Pixelorama:** revisão manual opcional.

**Gate de asset:** contrato → arte → QA técnico (dimensões, frames, transparência, paleta, exportação) → auditoria visual independente → integração Godot após `PASS` → validação mobile. R9 só passa quando o sprite foi criado pela IA, auditado, integrado, animado e legível no dispositivo previsto. Se falhar, corrija o pipeline antes de escalar assets.

## 10. Contrato mínimo para novas propostas de sistema

Antes de implementar, documente:

1. problema e benefício para o jogador;
2. etapa do roadmap e momento do unfolding;
3. nova decisão oferecida;
4. estado normal, erro e recuperação;
5. se há recurso: source, sink, fórmula e faixa inicial;
6. alternativas para paredes e proteção contra RNG;
7. métrica e método de validação;
8. impacto em UX, acessibilidade, bateria, save e migração;
9. custo de arte/código/QA e critério de remoção;
10. prova de originalidade e confirmação de que não depende de compra.

Se faltam fontes, decisão de produto ou critério testável, proponha primeiro um protótipo menor ou peça decisão. Não invente sistemas para preencher o roadmap.

## 11. Fontes do projeto

- [`INDEX.md`](./INDEX.md) — mapa e roteamento destes documentos.
- [`../README.md`](../README.md) — entrada do repositório.
- [`../ROADMAP.md`](../ROADMAP.md) — plano canônico, fases e gates.
- [`../docs/POCKET_HERO_PROJECT_BRIEF.md`](../docs/POCKET_HERO_PROJECT_BRIEF.md) — status e resumo consolidado registrado em 2026-09-26.
- [`../docs/design/INCREMENTAL_DESIGN_GUIDE.md`](../docs/design/INCREMENTAL_DESIGN_GUIDE.md) — versão curta da doutrina incremental.
- [`GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md`](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) e [`GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx`](./GUIA_DESIGN_INCREMENTAL_POCKET_HERO.docx) — fonte completa de design incremental.
- [`GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md`](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.md) e [`GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx`](./GUIA_AVANCADO_ECONOMIA_PACING_BALANCEAMENTO_POCKET_HERO.docx) — fonte de economia/telemetria.
- [`GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.md`](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.md) e [`GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx`](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx) — fonte de UX, ferramentas e QA.
- [`GUIA_IA_REFERENCIA_TBH_POCKET_HERO.md`](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.md) + [`DOCX original`](./GUIA_IA_REFERENCIA_TBH_POCKET_HERO.docx) — análise de referência e limites de originalidade.
- [`../docs/PIPELINE_IA_SPRITES.md`](../docs/PIPELINE_IA_SPRITES.md) — pipeline de sprites.
- [`../docs/REFERENCIAS_TBH.md`](../docs/REFERENCIAS_TBH.md) — banco de ideias anterior; não é aprovação de escopo.
