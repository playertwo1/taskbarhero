---
document_type: balance-domain
id: BALANCE_V1_10_TELEMETRIA_ARGOS
version: "1.0"
status: IMPLEMENTING
certainty: DESIGN
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO]
---

# 10 — Arquitetura runtime, medição, Argos e gates

Ferramenta: [tools/argos/README.md](../../../tools/argos/README.md). Achados: [BALANCE_FINDINGS](../../08_qa/BALANCE_FINDINGS.md). Arquitetura do Argos: [ARGOS_ARCHITECTURE](../../08_qa/ARGOS_ARCHITECTURE.md).

## 1. Arquitetura runtime do balanceamento (IMPLEMENTED)

Precedência de valores no runtime:

1. [`combat_core.json`](../../../data/balance/combat_core.json): fórmulas, referências, caps, ranks, ameaça, stagger, orçamento de item, XP, `combat_scale`, `level_curve_p`.
2. `data/balance/chapters/<capítulo>.json`: escalas, recuperação, metas e caminhos do capítulo.
3. `overrides` do cenário do Argos: hipótese temporária; nunca grava em `/data`.

[`combat_profiles.json`](../../../data/balance/combat_profiles.json) só compõe; [`BalanceProfiles.gd`](../../../scripts/combat/BalanceProfiles.gd) aplica a precedência; `SliceStats.gd` é adaptador de compatibilidade, não autoridade.

**Contrato de um capítulo:** `chapter_id`, `content_set`, `balance_version`, fonte; caminhos de rota, heróis, inimigos, skills, passivas e itens; party padrão, encontros isolados e nó de medição antes do chefe; escalas locais, recuperação e metas. Para adicionar um capítulo: criar o perfil, registrar no manifesto, criar cenário com `chapter_id`, `party`, `builds`, `levels`, `seeds`, `modes`. O simulador não recebe IDs de capítulo no código.

**`combat_scale` e `level_curve_p`:** detalhes em [00 §2–3](00_CONSTITUICAO.md#2-unidade-e-escala--decidido-rafael-2026-09-30). Testes que conferem números à mão fixam 1× e curva linear com `BalanceProfiles.pin_test_units()`. Invariância provada por `tests/unit/test_combat_scale.gd` e pelo cenário `scale_equivalence` (`tools/balance/check_scale_equivalence.py`).

## 2. Métricas

| Camada | Medidas |
| --- | --- |
| Encontro | TTK, HP restante, dano por fonte/skill/tipo/invocação, crítico, DOT, recebido por fonte, maior golpe, cura efetiva, overheal, escudo gerado/consumido/expirado, casts, hits, `missed_opportunities`, uptime de buff/debuff, recurso (gerado, gasto, overflow, tempo em 0 e no máximo), postura (dano, quebras, tempo até quebrar, dano na quebra) |
| Rota | vitória, ponto de derrota, HP antes do chefe, fôlego usado |
| Build | vitória por nível, caminhos viáveis, dominância, taxa de escolha |
| Campanha | tentativas, nível da vitória, XP, itens, recursos, tempo |
| Economia | [07 §10](07_ECONOMIA_LOOT.md#10-telemetria-de-economia) |
| Runtime | telemetria local (desligável, sem rede) equivalente, para confrontar a simulação com sessões reais ([`SliceTelemetry.gd`](../../../scripts/combat/SliceTelemetry.gd)) |

Sempre percentis (P10, P25, P50, P75, P90), nunca só a média. Logs guardam a seed.

## 3. Regra → métrica

Toda regra da constituição tem uma verificação. As regras executáveis ficam em [`rules_slice.json`](../../../tools/argos/analyzer/rules_slice.json) hoje e migram para um `rules_global.json` derivado desta tabela quando houver mais de um capítulo (RECOMENDADO). Afrouxar uma regra exige decisão de Rafael.

| Regra | Métrica | Estado |
| --- | --- | --- |
| Chefe vencido em `10c`–`10c+1` | nível de início da tentativa vencedora (campanha) | avaliada (Cap. 1) |
| 3–8 tentativas | tentativas por combinação | avaliada |
| > 1 caminho viável, > 1 sem cura | vitória ≥ 50% na rota com perfil `tipico` | avaliada |
| Nenhuma build domina | melhor vs mediana por nível | avaliada |
| TTK por rank | TTK P50 no nível do conteúdo | avaliada |
| Fatias de poder por fonte | ablação por fonte dentro do capítulo | **não avaliada** (novo cenário) |
| Teto de sinergia | soma de buffs de aliados por categoria | **não avaliada** |
| Fraqueza declarada preservada | DPS/EHP do herói com perfil `bom` vs referência | **não avaliada** |
| Janela de relevância | set do capítulo anterior vs atual | **não avaliada** |
| Passiva com efeito mensurável | ganho por ablação ≥ 1% | parcial (BAL-011) |
| Offline ≤ 30% do progresso | taxa × teto de horas | **não avaliada** |
| Recursos com sink | saldo por hora limitado | parcial (BAL-014) |
| Velocidade não muda resultado | mesma seed em ×1 e ×4 | teste Godot |
| Variância aceitável | spread entre seeds (§5) | **não avaliada** |

## 4. Jogador de referência no Argos

Cenário por capítulo que reproduz a tabela da [constituição §6](00_CONSTITUICAO.md#6-jogador-de-referência-por-capítulo): nível, raridade e IP típicos, ranks e nós da Árvore. Para capítulos que ainda não existem, usa inimigos sintéticos gerados pela fórmula de [06 §2](06_INIMIGOS_CHEFES.md#2-fórmula-do-inimigo), só para validar as curvas (TTK, fatias, relevância, teto). É o primeiro trabalho de implementação da v1.

## 5. Orçamento de variância

- Mesma build, mesmo nível, sementes diferentes: P10–P90 das tentativas até vencer ≤ 3; taxa de vitória por célula com pelo menos 6 sementes (hoje) e 20 para decisões finais.
- Perfis de jogador do Argos (Core e Balance Lab) cobrem comportamentos: [profiles/README](../../../tools/argos/profiles/README.md).

## 6. Gates

1. **Estrutura:** `python tools/balance/validate_balance_data.py` sem erros.
2. **Regressão:** `python tools/run_godot_tests.py` e testes do Analyst sem falhas.
3. **Simulação rápida:** nenhum `BUG`; regras sem cobertura ficam explícitas.
4. **Matriz do capítulo:** metas avaliadas na cobertura declarada e achados registrados.
5. **Playtest/telemetria:** resultado humano confrontado com a simulação antes de promover `HIPÓTESE` para `APPROVED`.

Regra de cobertura: uma execução rápida no nível 5 não aprova nem reprova uma meta do nível 10–11; a regra fica "não avaliada". Faixas de TTK só valem quando o nível da party coincide com o do encontro.

## 7. Registro de alterações

Toda mudança de número: valor anterior, novo, motivo, cenário/relatório do Argos e impacto esperado; `balance_version` do perfil sobe ([00 §11](00_CONSTITUICAO.md#11-política-de-mudanças-de-números)). Achados `BALANCE`/`PACING` vão para [BALANCE_FINDINGS](../../08_qa/BALANCE_FINDINGS.md) com hipótese e proposta; a decisão é de Rafael.
