---
status: DESIGN
---

# Loop central — Pocket Hero

**Versão:** rascunho inicial da EXP-DESIGN-1  
**Autoridade:** modelo de experiência proposto. O código e os dados continuam sendo autoridade do comportamento atual; este documento não declara novos sistemas implementados.

## Base registrada

- **DECIDIDO:** a proposta do MVP combina combate automático, heróis, fases, XP/nível, ouro, equipamento, itens, save local e progresso offline. O [resumo do projeto](../POCKET_HERO_PROJECT_BRIEF.md) registra esse escopo; consulte código/testes para afirmar comportamento exato.
- **DECIDIDO:** a região inicial é o Bosque de Lúmen, com cinco fases macro. O [overview do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) é a fonte de detalhe da expansão de conteúdo.
- **DECIDIDO:** a direção atual de party é um trio de heróis ativos, conforme o [índice de heróis](../02_heroes/INDEX.md).
- **DECIDIDO por Rafael:** as escolhas sobre preparação, acompanhamento de objetivos e progresso offline estão em [Pilares de design](GAME_PILLARS.md); este documento as aplica ao fluxo, sem duplicar suas regras.
- **DECIDIDO por Rafael em 2026-09-28:** o objetivo apresenta progresso, recompensa/desbloqueio esperado e sugestão de próximo passo.
- **DECIDIDO por Rafael em 2026-09-28:** a campanha progride continuamente pelas fases, organizada em expedições finitas por objetivo. Ao alcançar o objetivo selecionado, a expedição termina e retorna ao Hub.
- **DECIDIDO por delegação explícita de Rafael em 2026-09-28:** uma expedição também termina em derrota quando os três heróis ativos ficam incapazes de lutar; não há limite de tempo que cause derrota. Retorno voluntário continua disponível.
- **DECIDIDO por Rafael em 2026-09-28:** uma derrota encerra a expedição e retorna a party ao Hub. XP, ouro e itens já obtidos são conservados; regras adicionais de persistência estão em [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md).
- **DECIDIDO por Rafael em 2026-09-28:** após alcançar o objetivo ou sofrer derrota, o jogo apresenta um resumo breve e retorna automaticamente ao Hub.
- **DECIDIDO por Rafael em 2026-09-28:** o jogador pode encerrar voluntariamente uma expedição e retornar ao Hub a qualquer momento. Fases concluídas permanecem concluídas; se sair antes de concluir a fase atual, ela recomeça do início na próxima expedição, mantendo as recompensas obtidas. Veja as regras de persistência em [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md).
- **DECIDIDO:** slots, seleção e regras de uso de skills durante a expedição estão no [Sistema de skills](../03_systems/SKILL_SYSTEM.md).
- **DECIDIDO por delegação explícita de Rafael em 2026-09-28:** ao encerrar a expedição, todo o HP é restaurado e condições temporárias de combate são removidas da party; não há ferimentos persistentes neste escopo.
- **EM ABERTO:** distribuição das skills por tier, conjuntos de escolha por marco e valores de gatilhos, ranks e cooldowns. Consulte o [Sistema de skills](../03_systems/SKILL_SYSTEM.md) e [HERO_STANDARD.md](../../HERO_STANDARD.md).

## Loop macro candidato

**HIPÓTESE:** o ciclo de longo prazo pode ser organizado assim:

```text
Refúgio / preparação
        ↓
Definir objetivo e preparar expedição (regras em [Pilares de design](GAME_PILLARS.md))
        ↓
Expedição pelo Bosque até o objetivo selecionado
        ↓
Combate automático → observar ameaças e resultados
        ↓
Ganhar progresso/recompensas → reconhecer resultados e marcos
        ↓
Alcançar objetivo ─────────────────────┐
Derrota ───────────────────────────────┼→ Encerrar expedição → resumo breve → retorno automático ao Refúgio
Retorno voluntário pelo jogador ───────┘
                                              ↓
                                  avaliar resultado e preparar próxima expedição
```

O Refúgio é uma proposta de meta-progressão; sua presença e seus serviços mínimos têm especificação própria pendente em [`docs/05_hub/`](../05_hub/INDEX.md). O conteúdo e a apresentação do resumo ainda precisam de especificação.

## Loop curto candidato

1. No Hub, revisar party, equipamento e skills ativas; conferir o objetivo, progresso e próximo marco; escolher ou alterar o objetivo; iniciar a expedição.
2. Uma ameaça dá sinais que o jogador consegue reconhecer.
3. A party executa seu combate automático e skills conforme as regras do [Sistema de skills](../03_systems/SKILL_SYSTEM.md).
4. O jogador entende o resultado e recebe progresso/recompensa apropriados.
5. O resultado de uma parede informa a próxima preparação: rever party/build ou buscar progresso em conteúdo já disponível.
6. O próximo encontro testa uma lição conhecida ou apresenta uma novidade legível.

As escolhas de composição, equipamento e skills acontecem antes da expedição, conforme [Pilares de design](GAME_PILLARS.md) e [Sistema de skills](../03_systems/SKILL_SYSTEM.md); o jogador não envia comandos durante a batalha. **DECIDIDO seguindo a recomendação delegada por Rafael:** o loadout de equipamento fica travado durante a expedição; drops são guardados e podem ser equipados no Hub após seu encerramento. Esta regra é alvo do design pós-MVP, não descreve o comportamento atual do MVP. O jogador pode retornar ao Hub voluntariamente, encerrando a expedição. A primeira fatia não terá um estado separado de pausa/retomada; sair ou deixar o app em segundo plano segue as regras de progresso offline, ainda a especificar.

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** cada encontro deve ensinar, testar ou combinar uma leitura de combate; espera passiva não pode ser a única resposta a uma parede.

## Ativo, idle e offline

- **DECIDIDO por delegação explícita de Rafael em 2026-09-28:** durante o jogo, observação e decisões podem melhorar a eficiência sem exigir repetição física de toques.
- **DECIDIDO como alvo do MVP:** o progresso offline é limitado por um teto de tempo ausente, conforme [Pilares de design](GAME_PILLARS.md). Na expedição atual, o cálculo para ao atingir o objetivo ou ocorrer derrota; o resultado é registrado uma única vez e retorna ao Hub, sem iniciar outra expedição automaticamente. Dentro do teto não há penalidade adicional de eficiência. Fórmula, teto numérico, resolução de combate, recompensas e resumo continuam em aberto.
- **HIPÓTESE:** ao voltar, resumir tempo ausente e progresso em linguagem compreensível. O [guia incremental](../../documents/GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md) propõe esse tipo de retorno, mas layout, números e recompensas permanecem abertos.

## O que não está definido por este loop

- Como skills escolhidas antes da expedição são ativadas automaticamente e se há decisões em intervalos entre batalhas.
- Fórmula, teto de tempo, resolução de combate, recompensas e resumo do cálculo offline continuam em aberto.
- Alcançar o objetivo, sofrer derrota ou retornar voluntariamente encerra a expedição e retorna ao Hub. Fases concluídas e recompensas persistentes seguem as regras decididas no [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md).
- Conteúdo e apresentação do resumo após a expedição; persistência de condições além de HP, fórmula offline e demais questões em aberto estão no [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md).
- O slice inclui um Echo funcional opcional; aquisição e escopo mínimo estão no [Sistema de Ecos](../03_systems/ECHO_SYSTEM.md), enquanto o sistema completo permanece para `ECHO-1`.
- Como uma expedição se liga aos serviços do Refúgio.

Esses pontos são **EM ABERTO**. Antes de fixá-los, registrar a escolha de Rafael na fonte autoritativa da área e atualizar os índices que apontam para ela.

## Critério para revisar este rascunho

O loop estará pronto para aprovação quando cada transição tiver um estado inicial, uma decisão ou automação clara, uma saída observável para o jogador e sua regra de persistência identificada. A aprovação do diagrama não prova implementação nem balanceamento.
