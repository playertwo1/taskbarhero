---
status: DESIGN
---

# Sistema de skills

**Autoridade:** regras de seleção e uso das skills. Este documento descreve decisões de design; não declara implementação nem valores runtime.

## Loadout de expedição

- **DECIDIDO conforme o padrão canônico:** cada herói pode equipar **2 skills simultaneamente** em combate. O primeiro slot existe desde o início; o segundo é liberado pela progressão global do Hub para todos os heróis. Consulte [HERO_STANDARD.md](../../HERO_STANDARD.md).
- **DECIDIDO por Rafael em 2026-09-28:** as skills ativas são escolhidas antes da expedição e permanecem fixas até ela terminar. Não podem ser trocadas entre encontros.
- **DECIDIDO por Rafael em 2026-09-28:** a prioridade de ativação automática entre as duas skills equipadas é escolhida pelo jogador no Hub.
- **DECIDIDO por Rafael em 2026-09-28:** o jogador pode configurar gatilhos básicos de ativação automática das skills no Hub.
- **DECIDIDO por Rafael em 2026-09-28:** cada skill usa um gatilho simples definido para ela, e o jogador ajusta seu limite no Hub.
- **DECIDIDO por Rafael em 2026-09-28:** o limite do gatilho é ajustado por um controle deslizante no Hub.
- **DECIDIDO por Rafael em 2026-09-28:** se as duas skills estiverem prontas para ativar, o combate ativa uma primeiro e depois a outra, respeitando a prioridade escolhida.
- **DECIDIDO por Rafael em 2026-09-28 ao aceitar a recomendação:** cada skill seleciona seus alvos automaticamente conforme seu próprio design; o jogador não configura prioridade de alvo separadamente no Hub.
- **DECIDIDO:** o combate acontece automaticamente; o jogador não comanda skills durante a batalha. Consulte [Pilares de design](../00_project/GAME_PILLARS.md).

## Catálogo

Cada herói possui cinco skills normais e uma Signature Skill. O [padrão canônico](../../HERO_STANDARD.md) define a estrutura e os ranks; o [overview do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) contém conceitos atualmente catalogados para os três heróis iniciais, sem suas Signature Skills. Ter uma skill no catálogo não significa que ela esteja equipada ou desbloqueada.

## Desbloqueio, evolução e ativação

- **DECIDIDO por Rafael em 2026-09-28:** skills são desbloqueadas pela progressão de nível do próprio herói.
- **DECIDIDO por Rafael em 2026-09-28:** ao alcançar um marco de nível que libera uma skill, o jogador escolhe qual skill ainda bloqueada daquele herói desbloquear.
- **DECIDIDO por Rafael em 2026-09-28:** a escolha de desbloqueio aparece no Hub após o fim da expedição, inclusive se o nível for alcançado durante ela.
- **DECIDIDO por Rafael em 2026-09-28:** as escolhas de desbloqueio aparecem em níveis-marco, não a cada nível do herói.
- **DECIDIDO por Rafael em 2026-09-28:** melhorias de skills também são obtidas em marcos de nível do herói; no Hub, o jogador escolhe qual skill já desbloqueada melhorar.
- **DECIDIDO conforme o padrão canônico:** skills normais têm até **5 ranks**; a Signature Skill tem até **3 ranks**. Consulte [HERO_STANDARD.md](../../HERO_STANDARD.md).
- **DECIDIDO por Rafael em 2026-09-28:** o jogador pode concentrar melhorias numa única skill já desbloqueada, sem precisar desbloquear ou melhorar as demais, respeitando o limite de ranks de cada tipo.
- **DECIDIDO por Rafael em 2026-09-28:** ranks podem evoluir tanto números quanto o comportamento/propriedades funcionais da skill. Para diretrizes de evolução por tipo de skill, seguir o [padrão canônico](../../HERO_STANDARD.md).
- **DECIDIDO por Rafael ao delegar recomendações em 2026-09-28:** os tiers do [padrão canônico](../../HERO_STANDARD.md) limitam quais skills podem ser escolhidas para desbloqueio; a Signature Skill só fica elegível no T6. Em cada marco no Hub, o jogador escolhe entre skills ainda bloqueadas e elegíveis; escolhas não feitas continuam disponíveis nos marcos seguintes.
- **EM ABERTO:** atribuir cada skill normal ao seu tier elegível e definir quantas skills entram no conjunto de escolha em cada tier, sem contrariar o padrão canônico.
- **EM ABERTO:** mapear os efeitos numéricos e funcionais concretos de cada rank de cada skill.
- **DECIDIDO por delegação explícita de Rafael em 2026-09-28:** quando duas skills estiverem aptas, resolver primeiro a de maior prioridade; após a ação dela terminar, reavaliar a outra e ativá-la se continuar pronta e seu gatilho ainda for válido. Não introduzir atraso global artificial; o ritmo deve vir da resolução das ações e dos cooldowns próprios.
- **EM ABERTO:** mapear o gatilho e os valores/escala ajustáveis de cada skill, o intervalo efetivo de resolução, cooldowns, duração e números.
- Como a interface apresenta as duas skills equipadas e suas sinergias antes da expedição.

Não copiar conceitos para `/data/` nem definir números runtime antes dos gates de design e balanceamento correspondentes.
