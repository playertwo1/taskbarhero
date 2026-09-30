---
status: DESIGN
---

# Sistema de Ecos

**Autoridade:** escopo e regras de design dos Ecos. Esta especificação não declara implementação nem cria conteúdo individual.

## Decisão de escopo para a primeira fatia

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** incluir no `SLICE-1` **um Echo funcional**, de forma limitada, para demonstrar a ligação entre loot, build e lore. A decisão substitui o estado temporário “em aberto até DESIGN-1”; o Echo não é necessário para vencer nenhuma batalha nem para completar o slice.

O Echo do slice é **A Sentinela que Ficou**, do [Golden Reference de design do Bastião](../02_heroes/BASTIAO_GOLDEN_REFERENCE.md): modifica **Muralha Viva** para também proteger o aliado com menor HP mesmo ligeiramente fora da área. Como o combate do slice não modela distância e os três heróis ativos já cabem em `allies_behind`, a direção escolhida por Rafael para o protótipo permite proteger Bastião quando ele tiver a menor porcentagem de HP da party; empate segue a ordem da formação. A regra reutiliza valores e duração da skill. Continua `HIPÓTESE` até implementação e playtest; ver o [escopo do capítulo](../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) e as [recomendações do SLICE-1D](../05_hub/SLICE_1D_RECOMMENDATIONS.md).

O Echo do slice é uma recompensa determinística de conteúdo, fica permanentemente no inventário ao ser recebido e só pode ser equipado/trocado no Hub. Ele ocupa o slot Echo dedicado e não consome os slots de equipamento comuns. Não há extração, infusão, cópia, aprimoramento, Echo de Maestria nem catálogo aleatório no slice. A etapa `CONTENT-1` escolhe a fonte narrativa/recompensa que o apresenta antes do encontro em que será útil.

## Sistemas completos reservados para fases futuras

As propostas abaixo são referências de design e não fazem parte do Echo mínimo aprovado para o `SLICE-1`:

- O slot de Echo, extração/infusão e a Gravadora de Ecos na [proposta de equipamentos e artesãos](EQUIPMENT_AND_CRAFTING_SYSTEM.md).
- O ramo da Memória, Fragmentos de Ressonância, desbloqueios e nós da [proposta da Árvore Global de Ressonância](GLOBAL_RESONANCE_TREE.md).
- Ecos Corrompidos como endgame no [brief do projeto](../POCKET_HERO_PROJECT_BRIEF.md).

As propostas maiores continuam subordinadas a esta decisão de escopo: extração/infusão, Codex e Coleção não fazem parte do slice. Podem ser avaliados em `ECHO-1` depois que o Echo mínimo passar pelo slice.

## Catálogo e implementação

O [índice de conteúdo dos Ecos](../04_content/echoes/INDEX.md) continua sem ficha runtime ou autorização para implementação. `A Sentinela que Ficou` tem direção de design escolhida para o slice; ficha completa, ID registrado e dado runtime continuam pendentes de `ECHO-1` e validação da interação com os sistemas de herói/equipamento.
