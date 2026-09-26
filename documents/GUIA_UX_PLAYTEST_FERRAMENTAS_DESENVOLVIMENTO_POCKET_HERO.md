<!-- Fonte original: [GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx](./GUIA_UX_PLAYTEST_FERRAMENTAS_DESENVOLVIMENTO_POCKET_HERO.docx) -->

# **POCKET HERO**

## **Guia de UX, Playtest e Ferramentas de Desenvolvimento**

*FTUE · acessibilidade · haptics · áudio · performance · bateria · Dev Mode · simulador · playtest · QA*

> OBJETIVO
> Fechar a base conceitual do Pocket Hero antes do vertical slice. Este guia define como o jogo deve ensinar, responder ao toque, comunicar eventos, respeitar bateria e acessibilidade e, principalmente, como a equipe de IA deve testar e balancear o jogo sem depender de dezenas de horas de jogo manual.

> DECISÃO DE FASE
> Depois deste documento, pausar a criação de novos guias conceituais. O próximo grande aprendizado deve vir do vertical slice real: Bastião + Slime + uma fase + loot + APK no S25 Ultra.

# 1. Papel deste guia na base do projeto

Os documentos anteriores definem a referência TBH, a doutrina incremental e a economia/pacing. Este documento cobre a camada de experiência e validação: como apresentar o jogo ao usuário, como torná-lo confortável no celular e como dar aos agentes ferramentas para medir, reproduzir e corrigir problemas.

| Documento | Pergunta principal |
| --- | --- |
| Referência TBH | O que estamos estudando e o que não devemos copiar? |
| Design Incremental | O que torna o loop divertido por horas/dias? |
| Economia/Pacing | Como custos, paredes, unlocks e métricas se comportam? |
| Este guia | Como o jogador vive a experiência e como nós a testamos? |

# 2. FTUE: primeiro divirta, depois explique

A Apple recomenda que onboarding de jogos seja rápido, divertido e útil, que ensine o core loop em contexto e que objetivos avancem dos elementos básicos para os mais complexos conforme o jogador demonstra competência. Usamos isso como referência de design, mesmo tendo Android como primeira plataforma.

```
0–5 s
Bastião já está lutando.

5–20 s
Slime cai.
+ XP
+ Ouro

20–90 s
Primeiro level up.

1–3 min
Primeiro item.
ATK 8 → 13.
[Equipar]

5–10 min
Novo sistema:
segunda fase / skill / inventário.

Depois
party, crafting, runas, Ecos...
```

> Regra
> Não abrir o jogo com uma aula. O jogador precisa ver a fantasia central funcionando antes de receber explicações longas.

# 3. Tutorial contextual, não enciclopédico

- Ensinar uma ação quando ela passa a ser útil.

- Não explicar crafting antes de o jogador possuir loot para craftar.

- Não explicar party antes de existir o segundo herói.

- Não explicar tracker antes de haver algo que valha comparar.

- Não explicar Eco Corrompido no primeiro bioma.

- Permitir pular/rever dicas sempre que possível.

| Momento | Tutorial certo | Tutorial errado |
| --- | --- | --- |
| Primeiro drop | Mostrar comparar/equipar. | Explicar todos os slots futuros. |
| Segundo herói | Mostrar formação. | Explicar seis classes inexistentes. |
| Primeira parede | Mostrar opções de melhoria. | Exibir wiki interna gigante. |
| Primeiro craft | Ensinar recipe/material. | Mostrar dezenas de receitas futuras. |

# 4. UX mobile: toque, legibilidade e hierarquia

Android recomenda áreas de toque de pelo menos 48×48 dp para elementos interativos. A Apple também enfatiza controles grandes, texto legível, safe areas e layouts adaptáveis. Para o Pocket Hero, esses princípios são mais importantes que tentar colocar informação demais na tela.

| Regra | Aplicação Pocket Hero |
| --- | --- |
| Touch target ≥ 48dp quando possível | Botões de equipar, tabs, skills, filtros. |
| Texto importante com contraste forte | HP, nível, recompensa, erro. |
| Não depender apenas de cor | Raridade = cor + nome/ícone/borda. |
| Safe areas | Evitar notch/câmera/bordas arredondadas. |
| Layout relativo | Não fixar posições em pixels de um único aparelho. |
| Hierarquia | Combate e próximo objetivo > números secundários. |

# 5. Acessibilidade como multiplicador de clareza

Acessibilidade não deve entrar como retrofit. Muitos princípios — contraste, controles simples, redundância de informação, personalização e alternativas de interação — também melhoram a experiência de todos os jogadores.

- Raridade nunca comunicada apenas por cor.

- Números críticos também têm ícone/texto.

- Animações intensas devem poder ser reduzidas.

- Vibração pode ser desligada.

- Música e SFX separados.

- Tamanho de texto deve ter margem de ajuste.

- Evitar efeitos piscantes desnecessários.

- Botões pequenos visualmente podem ter hitbox maior.

# 6. Haptics: linguagem, não ruído

Android e Apple convergem em um ponto: haptics funcionam melhor quando são consistentes, associados a eventos claros e usados com moderação. O Android resume a orientação como 'menos é mais'; a Apple também recomenda evitar excesso e tornar haptics opcionais.

| Evento | Haptic sugerido | Frequência |
| --- | --- | --- |
| Ataque normal | Nenhum | Muito frequente. |
| Botão importante | Clique sutil | Conforme interação. |
| Level up | Pulso curto positivo | Moderada. |
| Drop lendário | Padrão curto especial | Raro. |
| Boss derrotado | Padrão forte + áudio | Raro. |
| Erro/ação inválida | Pulso distinto | Baixa. |
| Milestone | Padrão comemorativo | Raro. |

> Regra
> Se o jogador sente vibração o tempo todo, nenhuma vibração significa alguma coisa.

# 7. Áudio como feedback funcional

O áudio do Pocket Hero deve servir primeiro à leitura de eventos e só depois à ornamentação. O jogador deve conseguir reconhecer eventos-chave mesmo olhando para outra parte da tela.

| Camada | Função |
| --- | --- |
| Combate | Impacto leve, sem fadiga sonora. |
| Loot | Diferenciar raridades sem depender só de cor. |
| Boss | Entrada, fase crítica, vitória. |
| UI | Confirmação, erro, equipar, craft. |
| Milestones | Level importante, herói novo, sistema novo. |

- Música e SFX com volume independente.

- Modo silencioso deve continuar plenamente jogável.

- Não usar sons agudos/repetitivos em eventos que ocorrem dezenas de vezes por minuto.

- Sincronizar áudio + visual + haptic em eventos raros.

# 8. Performance: medir antes de otimizar

A documentação do Godot 4.7 reforça que profiling existe justamente para descobrir o que otimizar primeiro. O projeto deve medir antes de fazer micro-otimizações prematuras.

| Ferramenta | Uso |
| --- | --- |
| Godot GDScript Profiler | Scripts e tempo de execução. |
| Godot Monitors | FPS, memória, objetos/nodes. |
| Android Studio Profiler | CPU, memória, energia. |
| Android GPU Inspector | Problemas gráficos avançados, se necessário. |
| Android vitals | Crashes, ANRs, memória e sinais de qualidade após distribuição. |

# 9. Bateria e temperatura são features do jogo

Android recomenda otimização energética explícita para jogos. Taxas de atualização mais altas podem aumentar consumo sem benefício quando o jogo não precisa renderizar nessa frequência. O Android também recomenda reagir a condições térmicas e oferece Game Mode para equilibrar desempenho e bateria em dispositivos compatíveis.

| Estado | Estratégia inicial |
| --- | --- |
| Combate visível | Meta de 60 FPS se estável e sustentável. |
| Menu estático | Reduzir updates e partículas; considerar 30 FPS no futuro. |
| App em background | Sem simulação contínua; usar progresso offline. |
| Modo economia | Reduzir FPS, partículas e efeitos. |
| Aparelho aquecendo | Reduzir carga de efeitos/updates em fase pós-MVP. |

> Princípio
> Um companion/idle que drena bateria ou aquece o aparelho contradiz sua própria proposta.

# 10. Estabilidade: crash, ANR e memória

Android vitals trata crash percebido pelo usuário e ANR percebido como métricas centrais de qualidade; memória e bitmap também entram nas métricas de qualidade. Para o MVP, o alvo é simples: sessões prolongadas sem crash, crescimento de memória controlado e nenhum travamento de UI.

- Executar teste prolongado de combate.

- Repetir troca de fases/menus para observar vazamentos.

- Criar e destruir mobs/efeitos em massa em Dev Mode.

- Registrar crash logs e último evento antes do erro.

- Testar save durante fechamento inesperado.

# 11. Configurações mínimas do jogador

| Configuração | MVP? | Motivo |
| --- | --- | --- |
| Música | Sim | Preferência pessoal. |
| SFX | Sim | Conforto. |
| Haptics | Sim | Acessibilidade/conforto. |
| Intensidade de partículas | Sim | Legibilidade/performance. |
| Modo economia | Desejável | Bateria. |
| Tamanho de texto | Desejável | Legibilidade. |
| Notação numérica | Depois | Útil se números crescerem muito. |
| Motion reduction | Depois/MVP se simples | Acessibilidade. |

# 12. Dev Mode: ferramenta obrigatória

DEV MODE é uma decisão própria do projeto. O objetivo é permitir que Ergane, Têmis e os modelos testem horas de progressão em minutos sem adulterar manualmente arquivos ou escrever comandos improvisados a cada teste.

| Ação | Uso |
| --- | --- |
| + Ouro / + XP | Testar economia/upgrades. |
| Set Level | Ir direto a milestones. |
| Teleport Stage | Testar qualquer fase/boss. |
| Spawn Enemy/Boss | Reprodução rápida. |
| Time Scale ×2/×10/×100 | Acelerar sessões. |
| Simular 15m/1h/8h offline | Validar cálculo offline. |
| Gerar N drops | Testar RNG e inventário. |
| Fixar RNG seed | Reproduzir bug. |
| God Mode | Testar mecânica sem morrer. |
| Reset subsystem | Resetar apenas loot/quests/party. |
| Export Debug Snapshot | Entregar evidência para auditor. |

> Regra
> Dev Mode nunca deve depender de editar save manualmente. Toda ação deve ser determinística, registrável e isolada da build de release.

# 13. Debug HUD

```
FPS: 60
Frame: 16.2 ms
Nodes: 146
Enemies: 4
Projectiles: 7
Stage: forest_01_03
TimeScale: x10

Hero DPS: 124.3
Enemy TTK avg: 4.8 s
XP/h: 14.2K
Gold/h: 3.1K
Drops/h: 18.4

Seed: 847291
Save v: 3
```

O HUD deve ser desligável e não fazer parte do layout normal. Ele serve para testes, screenshots de evidência e auditoria.

# 14. Simulador de balanceamento

O simulador não substitui playtest humano. Ele elimina erros grosseiros antes do playtest: boss matematicamente impossível, economia inflada, drop que demora semanas ou curva de XP que exige horas demais.

| Simulação | Saída esperada |
| --- | --- |
| 10.000 combates por fase | TTK, deaths, XP/h, gold/h. |
| 100.000 drops | Distribuição por raridade/slot. |
| Progressão Lv.1→50 | Tempo e recursos por milestone. |
| Boss Monte Carlo | Win rate por build/faixa de stats. |
| Economia 24h/7d | Earn vs spend, inflação. |
| Offline 15m→8h | Recompensa, inventário, caps. |

# 15. Pipeline correto de balanceamento

```
Hipótese
   ↓
Fórmula
   ↓
Simulador
   ↓
Build jogável
   ↓
Playtest humano
   ↓
Telemetria
   ↓
Ajuste
   ↓
Novo teste
```

> Regra
> Nenhum número é 'balanceado' porque parece razoável no código. Balanceamento é uma hipótese testada.

# 16. Playtest em camadas

| Tipo | Quem | O que valida |
| --- | --- | --- |
| Smoke test | Ergane/automação | Abre, roda, não quebra. |
| Functional | Ergane/Têmis | Regra e sistemas corretos. |
| Balance | Simulador + humano | Curvas, drops, paredes. |
| UX | Humano | Entendimento, toque, legibilidade. |
| Device | S25 Ultra + outros depois | FPS, bateria, layout. |
| Long session | Automação/humano | Memória, save, repetição. |
| Fresh eyes | Pessoa sem contexto | FTUE real. |

# 17. Teste do FTUE

O melhor teste de onboarding é observar alguém que não leu os documentos. Não explicar nada durante o teste.

- Quanto tempo até entender que o combate é automático?

- Sabe onde tocar após o primeiro loot?

- Entende por que ficou mais forte?

- Percebe o próximo objetivo?

- Algum menu parece obrigatório antes de ser útil?

- Precisa perguntar 'o que eu faço agora?'

- Algum texto é pequeno demais?

> Sinal vermelho
> Se o testador precisa que o desenvolvedor explique a interface, o tutorial/interface falhou; o testador não falhou.

# 18. QA visual para pixel art

- Filtro nearest/pixel-perfect.

- Sem blur/antialiasing acidental.

- Baseline consistente.

- Silhuetas distinguíveis em escala real.

- Boss maior sem bloquear leitura da party.

- FX não escondem HP/telegraphs.

- Raridade não depende apenas da cor.

- Teste em brilho baixo e alto.

- Teste com captura de tela em tamanho real.

# 19. Content budget

Toda nova feature tem custo em código, arte, UI, balanceamento, QA e manutenção. Antes de aceitar uma ideia, a IA deve avaliar retorno por custo.

| Pergunta | Exemplo |
| --- | --- |
| Reutiliza sistemas existentes? | Modificador de fase > novo modo isolado. |
| Reutiliza arte de forma legítima? | Família de inimigos > 10 silhuetas sem relação. |
| Exige UI nova? | Se sim, aumenta manutenção. |
| Cria balanceamento paralelo? | Nova moeda/árvore custa caro. |
| Melhora core loop? | Prioridade maior. |
| Pode esperar pós-MVP? | Se sim, adiar. |

# 20. Critérios de aceite do vertical slice

| Área | PASS |
| --- | --- |
| FTUE | Jogador entende combate/loot sem explicação externa. |
| Combate | Bastião x Slime é legível e satisfatório. |
| Loot | Primeiro upgrade é perceptível. |
| Incremental | Existe próximo marco visível. |
| UX | Controles fáceis no S25 Ultra. |
| Arte | Pixel-perfect, sem blur. |
| Haptics | Poucos eventos, claros e opcionais. |
| Áudio | Eventos importantes distinguíveis. |
| Performance | Sessão estável, sem stutter evidente. |
| Bateria | Sem comportamento obviamente excessivo em teste prolongado. |
| Save | Fecha/reabre sem perda. |
| Offline | Simulação correta e não duplica reward. |
| Dev Mode | Permite reproduzir cenários rapidamente. |
| Telemetria | TTK, XP/h, gold/h e eventos básicos registrados. |

# 21. Definition of Done para uma feature

- Resolve um problema claro.

- Tem comportamento documentado.

- Tem estado de erro definido.

- Tem Dev Mode/test hook quando necessário.

- Tem métricas relevantes.

- Tem feedback visual/sonoro/haptic proporcional.

- É legível no aparelho real.

- Não piora performance/bateria de forma desproporcional.

- Passa teste funcional.

- Passa teste humano quando envolve UX.

- Não depende de compra.

- É removível ou migrável sem destruir o save.

# 22. Prompt-base para Hermes/Ergane/Têmis

```
Antes de concluir qualquer feature do Pocket Hero:

UX
- O jogador entende sem explicação externa?
- O próximo passo está visível?
- Touch targets e texto funcionam no celular?
- A informação depende apenas de cor?

FEEDBACK
- Existe feedback visual?
- Áudio/haptic são proporcionais e opcionais?
- O evento é frequente demais para vibrar?

PERFORMANCE
- Foi medido antes de otimizar?
- Há risco de CPU/GPU/memória/bateria excessivos?
- A feature funciona em sessão prolongada?

TESTABILIDADE
- Existe modo rápido para reproduzir o cenário?
- RNG pode ser fixado?
- É possível simular progressão/offline?
- Há métricas para verificar resultado?

QA
- Teste funcional passou?
- Teste no S25 Ultra passou?
- Save continua compatível?
- Evidências foram registradas?

Se qualquer resposta crítica for NÃO, não marque a feature como DONE.
```

> Regra final da fase de pesquisa
> Daqui em diante, priorizar evidência do jogo rodando. Documento não substitui sensação de combate, legibilidade, pacing ou bateria medidos no aparelho.

# 23. Fontes oficiais e referências

| Fonte | Tema | URL |
| --- | --- | --- |
| Apple Developer | Onboarding for Games | https://developer.apple.com/app-store/onboarding-for-games/ |
| Apple HIG | Designing for games | https://developer.apple.com/design/human-interface-guidelines/designing-for-games |
| Apple HIG | Playing haptics | https://developer.apple.com/design/human-interface-guidelines/playing-haptics |
| Android Developers | Make apps more accessible | https://developer.android.com/guide/topics/ui/accessibility/apps |
| Android Developers | Haptics design principles | https://developer.android.com/develop/ui/views/haptics/haptics-principles |
| Android Developers | Optimize power efficiency | https://developer.android.com/games/optimize/power |
| Android Developers | Android game optimization overview | https://developer.android.com/games/optimize/overview |
| Android Developers | Game Mode API | https://developer.android.com/games/optimize/adpf/gamemode/gamemode-api |
| Android Developers | Android vitals for games | https://developer.android.com/games/optimize/vitals |
| Godot 4.7 Docs | Profiling / performance tools | https://docs.godotengine.org/en/4.7/engine_details/development/profiling/index.html |

# 24. O que é fonte e o que é decisão nossa

| Tema | Natureza |
| --- | --- |
| Touch target grande, acessibilidade, haptics moderados | Diretrizes de plataforma. |
| Medir FPS/performance e usar profilers | Documentação de engine/plataforma. |
| Eficiência energética e Game Mode | Diretrizes Android. |
| FTUE contextual/progressivo | Referência de design Apple + adaptação nossa. |
| Dev Mode | Decisão Pocket Hero. |
| Debug HUD | Decisão Pocket Hero. |
| Balance simulator | Decisão Pocket Hero. |
| Pipeline hipótese→simulação→playtest→telemetria | Decisão Pocket Hero. |
| Pausar novos guias após este documento | Decisão de execução do projeto. |

# 25. Fechamento da base conceitual

Com este guia, a base conceitual do Pocket Hero cobre referência de produto, incremental design, economia/pacing e experiência/testabilidade. A próxima pergunta importante não é 'que outro sistema podemos imaginar?', e sim 'o primeiro minuto do jogo é divertido no aparelho real?'.

> PRÓXIMO PASSO
> Construir o vertical slice: Bastião + Slime + Bosque de Lúmen mínimo + primeiro drop + level up + save + APK Android. Só depois voltar aos documentos para atualizar o que o jogo real nos ensinou.
