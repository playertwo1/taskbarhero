---
id: GLOBAL_BALANCE_SYSTEM
status: IMPLEMENTING
certainty: DESIGN
---

# Sistema global de balanceamento

## Objetivo

Este contrato permite usar as mesmas fórmulas, validações e métricas em qualquer capítulo. Valores específicos continuam no perfil do conteúdo. Simulação fornece evidência reproduzível; playtest e telemetria decidem se a experiência atingiu a meta.

## Autoridades e precedência

A visão runtime é resolvida nesta ordem:

1. [`combat_core.json`](../../data/balance/combat_core.json): fórmulas, referências, caps, ranks, ameaça, stagger e progressão compartilhados.
2. `data/balance/chapters/<capítulo>.json`: escala, recuperação, metas e caminhos do capítulo.
3. `overrides` do cenário: hipótese temporária do Argos; nunca grava valores em `/data`.

[`combat_profiles.json`](../../data/balance/combat_profiles.json) é somente o manifesto de composição. [`BalanceProfiles.gd`](../../scripts/combat/BalanceProfiles.gd) aplica a precedência. `SliceStats.gd` permanece como adaptador de compatibilidade e não é autoridade.

## Contrato para um capítulo

Cada perfil de capítulo declara:

- `chapter_id`, `content_set`, versão e fonte;
- caminhos runtime de rota, heróis, inimigos, skills, passivas e itens;
- party padrão, encontros isolados e nó usado para medir HP antes do chefe;
- escalas locais, recuperação e metas do capítulo.

Para adicionar um capítulo, crie o perfil, registre-o no manifesto e crie um cenário com `chapter_id`, `party`, `builds`, `levels`, `seeds` e `modes`. O simulador não deve receber IDs do capítulo no código.

## Métricas mínimas

| Camada | Medidas | Uso |
| --- | --- | --- |
| Encontro | TTK, HP restante, dano por fonte, cura/escudo, casts | localizar picos e skills inativas |
| Rota | vitória, ponto de derrota, HP antes do chefe, recuperação | medir desgaste acumulado |
| Build | vitória por nível, caminhos viáveis, dominância | preservar escolhas |
| Campanha | tentativas, nível da vitória, XP, itens e recursos | medir progressão incremental |
| Runtime | telemetria agregada equivalente | confrontar simulação com sessões reais |

Toda regra deve declarar cobertura. Uma execução rápida no nível 5 não pode aprovar ou reprovar uma meta definida para os níveis 10–11; o Analyst registra a regra como não avaliada. Faixas de TTK definidas para oponentes e heróis de nível equivalente só são avaliadas quando o nível da party coincide com o nível do encontro.

## Reprodutibilidade e validação

`python tools/balance/validate_balance_data.py` valida composição, arquivos, IDs da party, builds, inimigos e nós. `tools/argos/run.py` executa essa validação antes da simulação e registra SHA-256 do manifesto, núcleo, capítulo e cenário em `meta.json`.

Os schemas em [`data/balance/schemas`](../../data/balance/schemas) documentam os formatos. A validação executável continua deliberadamente sem dependências externas.

## Gates

1. **Estrutura:** validador sem erros.
2. **Regressão:** testes Godot e Analyst sem falhas.
3. **Simulação rápida:** nenhum `BUG`; regras sem cobertura ficam explícitas.
4. **Matriz do capítulo:** metas avaliadas na cobertura declarada e achados registrados.
5. **Playtest/telemetria:** resultado humano confrontado com a simulação antes de promover números de `HIPOTESE` para `APPROVED`.

## Estado dos números

- **DECIDIDO:** arquitetura em camadas e HP integral apenas ao voltar ao Hub.
- **HIPÓTESE:** números do núcleo herdados do v0.4 e valores do Capítulo 1 v0.5, inclusive fôlego de 10%.
- **EM ABERTO:** calibração por playtest, metas dos capítulos futuros e promoção dos valores atuais.
