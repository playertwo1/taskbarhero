# Perfis de jogador do Argos

Perfis são **tipos de jogador artificial**, não níveis de dificuldade: cada um é uma política de decisão (o que escolher, quando equipar, quanto gastar, quando desistir) aplicada ao jogo real, mais os oráculos que o perfil pode violar. Eles respondem perguntas diferentes e são escolhidos pela área que mudou, não rodados todos sempre.

Simulação determinística; **não é playtest** e não avalia diversão. As escolhas de cada perfil são **HIPÓTESE do Argos**, não dado de jogadores reais. Antecedente: os seis perfis de 2026-09-27 eram declarações de intenção para um jogo idle, nunca executadas; estão em [`arquivados/`](../../../arquivados/argos_perfis_iniciais_2026-09-27/README.md).

## Como rodar

```text
python tools/argos/run.py --scenario argos_profiles                      # os oito perfis (~8 min)
python tools/argos/run.py --scenario argos_profiles --profiles chaos,beginner
python tools/argos/run.py --scenario argos_profiles --area inventory_equipment   # perfis do mapa selection.json
python -m unittest tools/argos/analyzer/test_analyze.py
```

`selection.json` liga a **área alterada** aos perfis que vale rodar (por exemplo, `loot` → Optimizer, Exploit Hunter, Chaos, Grinder). O relatório ganha a seção **Perfis de jogador**; violações de oráculo viram achados `BUG` ou `EXPLOIT`, e dupe ou corrupção de save são `CRITICAL`.

## Formato de um perfil

Um arquivo `<id>.json` por perfil: `id`, `tier`, `status`, `question`, `description`, `modes` (`campaign`, `fuzz`, `edge`), `policy`, e conforme o modo `fuzz`, `edge` ou `builds` fixas; além de `looks_for` e `not_modeled` (o que o perfil **não** cobre). O cenário ativa um perfil com uma variante `{"id": "...", "profile": "..."}`.

### Política (`policy`, modo `campaign`)

| Chave | Valores | Efeito |
| --- | --- | --- |
| `reward` | `best`, `first`, `lowest`, `random`, `by_ip` | escolha entre os itens oferecidos (melhor por raridade e IP; maior número; etc.) |
| `events` | `first`, `random` (ou mapa evento → opção) | escolha nos eventos da run |
| `equip` | `best`, `none`, `by_ip`, `focus_attack`, `focus_defense`, `random` | como equipa no Hub; `best` é o `auto_equip` real |
| `equip_from_attempt` | N | só equipa a partir da tentativa N |
| `spend` | `none`, `full`, `random` | Árvore e Ferreiro entre as tentativas |
| `build` | `fixed`, `random_per_attempt` | troca a build de cada herói a cada tentativa |
| `quit_after_losses` | N | desiste depois de N derrotas seguidas sem nunca ter vencido |
| `continue_after_win` | N | tentativas extras depois da primeira vitória (farm) |
| `max_attempts` | N | limite de tentativas |

Toda decisão passa pela API do jogo (`SliceCampaign`, `SliceInventory`); nenhuma regra do jogo vive nos perfis.

### Modo `fuzz`

Ações aleatórias, inclusive ilegais, sobre o inventário real (equipar, equipar item já equipado, desequipar, desmontar comum/equipado/favorito, reforçar, reforçar em sequência, favoritar, comprar nó, Echo, Equipar os melhores, trava/destrava de expedição, loot, materiais). `weights` pesa cada ação. Oráculos: `uid_duplicated`, `equipped_unknown_uid`, `equipped_twice`, `slot_overflow`, `incompatible_equipped`, `negative_material`, `echo_not_owned`, `refused_changed_state`, `locked_mutation`, `equipped_recycled`, `favorite_recycled`, `recycle_credit_mismatch`, `reinforce_overflow`, `reinforce_cost_mismatch`, `equip_not_applied`, `tree_cost_mismatch`, `save_roundtrip_mismatch`. Cada achado traz seed, passo e os últimos 12 comandos para reproduzir.

**Os oráculos foram validados com mutação deliberada:** seis defeitos injetados no inventário real (desmontar favorito, equipar sem tirar do dono, equipar com o inventário travado, Reforço sem cobrar, recusa que altera o estado, desmontar sem remover o item) foram todos detectados.

### Modo `edge`

Combate em extremos: party nível 1 e 100, sem equipamento e com equipamento máximo (IP 100, nível de item 100, Reforço 1), HP cheio e HP 1. Oráculos: `non_finite_number`, `hp_out_of_range`, `edge_run_did_not_end` e os do simulador.

## Situação dos perfis

### Implementados

| Perfil | Camada | Modos | Pergunta |
| --- | --- | --- | --- |
| `beginner` | Core | campaign | Um humano normal consegue jogar? |
| `optimizer` | Core | campaign | Qual estratégia domina o jogo? |
| `chaos` | Core | campaign, fuzz | O que acontece quando ninguém segue o caminho esperado? |
| `exploit_hunter` | Core | fuzz | Como eu quebro o jogo? |
| `grinder` | Core | campaign | O que acontece depois de repetir isso muitas vezes? |
| `edge_case` | Core | edge, fuzz | O sistema continua correto nos extremos? |
| `aggressor` | Balance Lab | campaign | Um time todo de ataque vence, e com que fragilidade? |
| `turtle` | Balance Lab | campaign | Um time todo de sobrevivência vence, e com que lentidão? |

### Adiados de propósito (e por quê)

Construir todos de uma vez seria estrutura sem retorno. Cada item abaixo volta quando a condição dele existir.

| Perfil | Situação | Motivo |
| --- | --- | --- |
| Idle | não se aplica | O slice não tem progressão offline nem recompensa por tempo fora do app. |
| Merchant | não se aplica | Não há compra, venda, preço nem Ouro. |
| Build Switcher | coberto | `chaos` usa `build: random_per_attempt`. |
| Hoarder | adiado | O inventário não tem capacidade; o crescimento aparece em `grinder` (itens guardados, KB de save) e em `edge_case` (centenas de itens). Volta com capacidade de inventário. |
| Crafter | adiado | O Ferreiro só tem Reforço +1 e desmontagem; `optimizer` gasta tudo e `exploit_hunter` ataca as duas regras. Volta com crafting profundo. |
| Speedrunner | adiado | Não há conteúdo opcional nem atalhos; o nível mais baixo que vence é medido pela rota do `slice_balance`. |
| Death Tester | adiado | A derrota só devolve o grupo ao Hub com HP cheio e não há penalidade; HP 1 já está em `edge_case`. |
| Collector | adiado | Não há Bestiário, conquistas nem completude para medir. |
| Specialist, Generalist | adiados (Balance Lab) | Cada herói tem só 2 builds; o espaço de builds é pequeno demais para distinguir especialista de generalista. |
| Mobile Stress, Long Runner | adiados | Exigem aparelho ou Maestro (a pasta `maestro/` está vazia) e sessões de horas. |
| Personas (Casual, Min-Max, Collector, Speedrunner) | adiadas | São composições dos perfis acima com horizontes de 30 min, 2 h e 10 h; o slice não tem modelo de tempo de sessão. |
| Hero Master (um por herói) | adiado | O dano dado e o dano recebido por herói já são gravados em cada execução; falta decidir o **papel esperado** e os limites de fidelidade (decisão de Rafael). Até lá, nada é inventado. |

## Evidência inicial (2026-09-30, relatório `20260930-183035_82571ad`, 4 sementes)

| Perfil | O que mediu |
| --- | --- |
| `exploit_hunter` | 3.200 ações sobre a API de inventário (2.064 recusadas), **0 violações**. |
| `chaos` | 16 campanhas caóticas (todas vencem, nível 10) e 2.000 ações de fuzz, **0 violações**. |
| `edge_case` | 32 casos de borda de combate (17 vitórias) e 1.600 ações de fuzz com estoque zero, **0 violações**. |
| `grinder` | 65 tentativas por campanha: nível 33, ~340 itens, ~27 KB de save, ~850 Resíduo (BAL-014). |
| `beginner` | 44% de abandono, todo nas builds com Íris Arcano (BAL-015). |
| `aggressor` / `turtle` | `aggressor` vence em 7,5 tentativas (nível 12,5) e `turtle` em 4 (nível 8): o time ofensivo vence bem mais tarde que o defensivo com cura. |
| `optimizer` | 16 campanhas, todas vencem; de 3,5 a 7 tentativas (nível 8 a 12), com as builds `lumen` vencendo mais cedo que as `arcano`. |

Zero violações não prova ausência de defeito: prova que, nessas seeds e nessas ações, as invariantes valem. A capacidade de detecção foi verificada com mutações deliberadas (seção Modo `fuzz`).

## Limites

- Os perfis `campaign` jogam o slice do Capítulo 1 em simulação; as escolhas dos perfis são hipóteses.
- Campanhas de perfis não entram nas regras de ritmo (níveis e tentativas de vitória), que valem só para o jogador de referência (`slice_balance`).
- O fuzz cobre a API de inventário/campanha; não cobre interface, toque nem ciclo de vida do app.
