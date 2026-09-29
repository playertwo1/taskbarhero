---
status: APPROVED
document_type: delegated-design-decisions
review_date: 2026-09-28
---

# Auditoria — decisões de design delegadas

> **Nota de atualização:** este documento registra decisões anteriores à aprovação de TASKBAR Sistema Completo v0.4. Para combate/loot, catálogo de inimigos, itens, raridades, materiais e economia, as partes desta auditoria que divergirem da [base canônica v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md) estão supersedidas. Os itens de run, árvore, slots de herói e artesãos continuam válidos onde não houver conflito; use suas fontes autoritativas.

Este documento registra recomendações que Rafael autorizou explicitamente o agente a aprovar durante a fundação pós-MVP. O objetivo é facilitar a revisão de Rafael. Cada regra detalhada permanece na fonte autoritativa indicada; esta auditoria não substitui esses documentos nem afirma que as regras estão implementadas.

## Expedição e persistência

- A expedição termina quando o objetivo é alcançado, quando os três heróis ativos ficam incapazes de lutar ou quando o jogador retorna voluntariamente ao Hub. Não existe cronômetro de derrota; o objetivo selecionado delimita a expedição. Fonte: [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md) e [Loop central](CORE_LOOP.md).
- Ao encerrar, o HP da party é restaurado e efeitos temporários de combate são removidos; não há ferimentos persistentes nesse escopo. Fonte: [Loop central](CORE_LOOP.md).
- O progresso offline usa um teto de tempo ausente, sem penalidade adicional de eficiência dentro do teto. Termina no objetivo/derrota, grava o resultado uma vez e não inicia outra expedição. O valor do teto e cálculo ficam para ECON-1. Fonte: [Pilares de design](GAME_PILLARS.md) e [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md).
- A duração é definida pelo objetivo; não há duração obrigatória em minutos nem cronômetro. Medir duração ativa em playtest e ajustar objetivos/pacing depois. Fonte: [Run e meta-progressão](../03_systems/RUN_META_PROGRESSION.md).

## Loop, escolhas e skills

- Cada encontro deve ensinar, testar ou combinar uma leitura legível de combate; espera passiva não pode ser a única resposta a uma parede. Fonte: [Loop central](CORE_LOOP.md).
- O slice demonstra ao menos duas rotas viáveis por party, skills e equipamentos. O jogador pode revisitar conteúdo concluído; recompensas determinísticas por marcos evitam que um drop aleatório específico seja obrigatório. O primeiro slice não tem ramificações de mapa. Fonte: [Pilares de design](GAME_PILLARS.md) e [Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md).
- Objetivos mostram progresso, recompensa/desbloqueio esperado e próximo marco útil. Atualizar sugestões em marcos significativos, baseá-las em conteúdo disponível e nunca trocar o objetivo escolhido automaticamente; novos sistemas aparecem gradualmente. Fonte: [Pilares de design](GAME_PILLARS.md) e [Loop central](CORE_LOOP.md).
- A ativação de skills resolve primeiro a skill pronta de maior prioridade; depois da ação, o sistema reavalia a outra skill. Não há atraso global artificial. Fonte: [Sistema de skills](../03_systems/SKILL_SYSTEM.md).
- Melhorias e desbloqueios devem abrir sinergias, escolhas, automação ou conteúdo; bônus numéricos isolados precisam justificar sua função. Fonte: [Pilares de design](GAME_PILLARS.md).

## Equipamento e artesãos

- Drops e recompensas determinísticas alimentam o inventário persistente; equipamento não troca nem é destruído automaticamente. Alterações de loadout acontecem no Hub, e o loadout fica fixo durante a expedição. Fonte: [Equipamentos e artesãos](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md).
- Snapshot anterior ao cânone v0.4: as raridades do runtime (quatro níveis) não definem mais a escala global; consulte a decisão atual na seção [Base canônica de combate e loot v0.4](#base-canônica-de-combate-e-loot-v04) e no [sistema de equipamentos](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md).
- O Ferreiro é o primeiro serviço: desmontagem protegida por confirmação e um serviço de melhoria controlada. O recorte de material está definido na [fonte de equipamentos e artesãos](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md) conforme o catálogo v0.4; a antiga proposta de Sucata foi substituída. Ouro pode ser custo secundário. Não entram reforja aleatória, fixação de affix, ascensão ou outras famílias de material no slice.
- Artesãos são desbloqueados gradualmente e de forma persistente na conta/Hub; Ferreiro vem primeiro, outros serviços entram quando tiverem função e economia definidas. Fonte: [Equipamentos e artesãos](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md).

## Árvore dos Ecos e meta-progressão

- A Árvore dos Ecos é global e persistente, compartilhada pelos oito heróis e separada da progressão individual e das escolhas temporárias de expedição. O foco são desbloqueios e possibilidades; bônus numéricos são complementares. Fonte: [Árvore Global de Ressonância](../03_systems/GLOBAL_RESONANCE_TREE.md).
- O escopo inicial é de 30 nós: Vigília 6, Formação 5, Fortuna 4, Oficina 5, Alquimia 4, Jornada 3 e Memória 3. A lista, pré-requisitos e efeitos individuais foram fechados em `TREE-1`. Fonte: [Árvore Global de Ressonância](../03_systems/GLOBAL_RESONANCE_TREE.md).
- Fragmentos de Ressonância são separados do ouro e vêm principalmente de primeiras vitórias e marcos de campanha; repetir conteúdo não deve ser o melhor farm. Valores e retorno ficam para ECON-1. Fonte: [Árvore Global de Ressonância](../03_systems/GLOBAL_RESONANCE_TREE.md).
- Respec pode devolver nós numéricos e efeitos reversíveis, mas nunca remove serviços ou sistemas globais já desbloqueados. Custo e limites ficam para `ECON-1`. Fonte: [Árvore Global de Ressonância](../03_systems/GLOBAL_RESONANCE_TREE.md).

**TREE-1 — decisões de catálogo aprovadas em 2026-09-28:**

- Os 30 nós estão definidos com IDs persistentes, efeitos qualitativos, pré-requisitos e faixas relativas de custo na fonte autoritativa.
- `TREE_VIG_001` é raiz gratuita; `TREE_VIG_005` abre acesso aos seis outros ramos sem exigir completar um ramo.
- A party continua com três heróis ativos. A Formação desbloqueia o segundo slot global de skill e presets de skill/equipamento/party, sem trocar loadout durante expedição.
- O catálogo não usa escolhas mutuamente exclusivas; investimento pode se espalhar pelos ramos. Desbloqueios de sistemas e conteúdos são permanentes mesmo após respec.
- Rotas alternativas e contratos existem apenas em capítulos/conteúdos que os suportem; não entram no mapa do `SLICE-1`.

Fonte autoritativa: [catálogo TREE-1](../03_systems/GLOBAL_RESONANCE_TREE.md). Custos absolutos e simulação permanecem para `ECON-1`; conteúdo de artesãos, itens, Ecos e balanceamento passa pelos gates próprios.

## Artesãos da cidade — CRAFT-1

- Ordem aprovada: Ferreiro primeiro; Gravadora de Ecos junto da primeira recompensa Echo; Alquimista quando houver materiais com fonte e sink sustentados; Ourives depois de Alquimia básica e da especificação futura de acessórios.
- No slice, o Ferreiro oferece desmontagem protegida e aprimoramento controlado usando o material canônico selecionado em `ECON-1`. Não há desmontagem automática, reforja, fabricação livre nem outras famílias de materiais.
- No slice, a Gravadora registra e permite equipar/trocar apenas Ecos possuídos no Hub. A recompensa Echo é opcional; não entram extração, cópia, infusão, melhoria ou Codex completo.
- Alquimista começa com transmutação de materiais existentes. Essência, destilada de itens elegíveis, primeiro alimenta Catalisadores usados por serviços avançados do Ferreiro; ambos ficam após o slice.
- Ourives começa futuramente com uma receita curada e determinística de acessório. Sockets, lapidação e recalibração exigem especificação de expansão e aprovação econômica próprias.
- O Cartógrafo/Mercador fica fora do gate CRAFT-1 até existir um serviço distinto com fonte e sink próprios.
- `TREE_OFI_004`/`TREE_OFI_005` passam a restaurar o Ourives e abrir sua receita após `ALQ_002`; reforja e proteção de atributo saem dos 30 nós iniciais e podem voltar em expansão posterior.

Fonte autoritativa: [Equipamentos e artesãos — CRAFT-1](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md). Receitas detalhadas, valores e economia ainda estão pendentes; não há mudança runtime.

## Base canônica de combate e loot v0.4

- Rafael aprovou TASKBAR Sistema Completo v0.4 como base canônica de design para inimigos, equipamento, seis raridades, sete materiais, combate, loot e economia. A especificação e catálogos ficam no [índice canônico](../../documents/canonical/taskbar_sistema_v0.4/README.md).
- Mantêm-se os seis slots definidos para heróis: Arma, Secundário, Armadura, Acessório I, Acessório II e Echo. O cânone contém 30 itens em cinco grupos (5 Armas, 5 Secundários, 5 Armaduras, 10 Acessórios, 5 Ecos) e 17 inimigos.
- Os 15 itens e 11 inimigos atuais em `/data` são conteúdo runtime legado, preservado até migração explícita. Consulte a [ponte de compatibilidade](../04_content/LEGACY_RUNTIME_CATALOG.md); não inferir equivalências.
- A economia ECON-1 e as decisões anteriores de raridade/material valem como hipóteses/recorte do primeiro slice onde forem compatíveis com v0.4; não definem mais o catálogo global.

Fonte autoritativa: [base canônica v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md), [padrão de balanceamento](../06_balance/COMBAT_BALANCE_STANDARD.md) e [roadmap](../../ROADMAP.md#42-balance-foundation-1--contrato-de-balanceamento). Runtime permanece separado até migração.

## Echo no primeiro slice

- O slice inclui um Echo funcional opcional, sem torná-lo obrigatório para vencer: **A Sentinela que Ficou**, que modifica Muralha Viva para também proteger o aliado com menor HP ligeiramente fora da área.
- A recompensa é determinística e persistente; o Echo só é equipado/trocado no Hub. O slice não inclui extração, infusão, cópia, upgrade, Echo de Maestria ou coleção/Codex completo.
- `CONTENT-1` define onde a recompensa narrativa aparece; `ECHO-1` faz ficha completa e implementação depois de validar a interação com herói/equipamento.

Fonte autoritativa: [Sistema de Ecos](../03_systems/ECHO_SYSTEM.md) e [Golden Reference do Bastião](../02_heroes/BASTIAO_GOLDEN_REFERENCE.md).

## Fundação de lore — LORE-1

- Lúmen é energia ligada à vida, memória e identidade; o Apagamento é associado à perda gradual de Lúmen e pode afetar memória, instintos, identidade e reconhecimento de aliados.
- Corações de Lúmen são núcleos regionais; Guardiões protegem regiões e não são automaticamente vilões; Ecos são fragmentos de memória preservados pelo Lúmen.
- A campanha pode revelar Corações e Guardiões gradualmente. Não foi decidido que cada capítulo terá um Coração, nem que corrupção explica todo conflito com Guardiões.
- Mantêm-se em aberto a causa e natureza do Apagamento, o destino do Lúmen e das memórias, a autoria das máquinas de extração, quem sabia do fenômeno e a identidade do Observador.
- A lore pessoal do Bastião e suas cinco missões permanecem na ficha dele; a lore do Bosque e seu desfecho permanecem no overview do Capítulo 1.

Fontes autoritativas: [Bíblia de Lore](../01_world/LORE_BIBLE.md), [Golden Reference do Bastião](../02_heroes/BASTIAO_GOLDEN_REFERENCE.md) e [Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md). O gate `LORE-1` passou em 2026-09-28 para a fundação narrativa, não para diálogos ou implementação.

## Encaminhado para fases seguintes

Estes pontos não são omissões da auditoria; foram deliberadamente deixados para as fases adequadas:

- Valores do teto offline, drops, custos, duração observada e parâmetros de pacing: `ECON-1`.
- Custos finais, fontes/sinks simulados e limites econômicos da Árvore: `ECON-1`.
- Migração do schema runtime, subset de itens do slice e fontes/taxas de loot: `SLICE-1`/`ECON-1`.
- Item Power numérico, raridades futuras, affixes e reforja: expansão posterior com especificação e simulação próprias.
- Fonte narrativa do Echo no capítulo, ficha e runtime: `CONTENT-1`/`ECHO-1`.
- Aquisição e ritmo de Mastery, conteúdo de outros heróis e cânone detalhado: `HERO-STD`/`LORE-1` e etapas posteriores.

## Estado da revisão

As recomendações acima foram aprovadas sob a delegação explícita de Rafael em 2026-09-28. Ajustes posteriores devem ser feitos nas fontes autoritativas e refletidos neste registro; os itens continuam sendo design pós-MVP e não alteram código ou dados runtime.
