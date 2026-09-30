---
document_type: chapter-balance-profile
id: BALANCE_V1_CAPITULO_01
chapter: CHAPTER_01 — Bosque de Lúmen
version: "1.0"
status: IMPLEMENTING
certainty: HIPOTESE
last_reviewed: 2026-09-30
runtime_profile: data/balance/chapters/chapter_01.json
depends_on: [00_CONSTITUICAO]
---

# Capítulo 1 — perfil local de balanceamento

Aplicação das regras globais ao Capítulo 1 (níveis 1–10) e registro do que foi medido. Este arquivo só define **valores locais**; fórmulas, caps e orçamentos vêm dos domínios v1. Valores runtime: [`chapter_01.json`](../../../../data/balance/chapters/chapter_01.json), [`route_c1.json`](../../../../data/expedition/route_c1.json) e os catálogos em `/data`. Conteúdo: [overview](../../../04_content/chapters/chapter_01/OVERVIEW.md), [encontros](../../../04_content/chapters/chapter_01/ENCOUNTERS.md), [recorte do slice](../../../04_content/chapters/chapter_01/SLICE_1_SCOPE.md).

## 1. Metas — DECIDIDO (Rafael, 2026-09-29)

- Jogo incremental: progredir é alternar derrotas e vitórias parciais, voltar ao Hub mais forte e tentar de novo.
- O Guardião-Cervo é vencido por volta do **nível 10–11** (`chapter_targets.CHAPTER_01.boss_win_level`), não no 5.
- HP volta ao máximo no Hub; na expedição só existe o fôlego.
- Mais de um caminho viável; a cura não pode ser obrigatória nem dominante.

## 2. Valores locais (fonte: `/data`, 2026-09-30)

| Parâmetro | Valor | Estado |
| --- | --- | --- |
| Nível do conteúdo por fase | 1 / 3 / 5 / 7; Guardião 10 | v0.5 (HIPÓTESE) |
| `enemy_damage_scale` | 0,50 | decisão de Rafael; candidata a regra global ([11 D-05](../11_DECISOES_ABERTAS.md)) |
| HP de party | elite ×3, minichefe ×3, chefe ×2 | HIPÓTESE; chefe ×2 autorizado em 2026-09-30 |
| Fôlego entre encontros | 10% do HP máximo dos vivos, só se ninguém caiu, nada após o último | DECIDIDO (valor HIPÓTESE) |
| Fragmentos únicos | 32 (4/6/7/7/8) nos marcos `c1_1_2_b`, `c1_2_2_b`, `c1_3_2_a`, `c1_4_1_a`, `c1_5_2_a` | hipótese de runtime aprovada (2026-09-29) |
| Árvore do slice | 6 nós da Oficina/Vigília | [`resonance_tree_slice.json`](../../../../data/progression/resonance_tree_slice.json) |
| Ferreiro | desmontagem exige `TREE_OFI_002` (favoritos protegidos); Reforço +1 exige `TREE_OFI_003`, custa 5 Resíduos, +10% nos status-base, 1 vez por item | [`blacksmith_slice.json`](../../../../data/progression/blacksmith_slice.json) |
| Raridades | Comum, Incomum, Raro, Épico (Épico só de chefe) | DECIDIDO (2026-09-30) |
| IP | Normal 1–18, Elite 10–24, Minichefe 16–28, Chefe 22–32 | herdado |
| Perfil de equipamento da rota no Argos | `tipico` (3 slots, Incomum, IP 15) | BAL-013, decisão pendente |

## 3. Status usados pelo slice

13 status: núcleo `max_hp`, `attack`, `defense`, `crit_chance`, `attack_speed` (alvo da lentidão da Rede de Micélio), `crit_damage`, `skill_haste`, `tenacity`; condicionais `armor_pen_pct` (Ponta de Penetração, Flecha Perfurante), `damage_bonus` (Marca, alvo exposto, Sensível ao Lúmen), `damage_taken` (Muralha Viva, Fortaleza, Desequilíbrio), `shield_power` (Véu de Micélio), `status_power` (Lanterna de Esporos). Fora do slice: movimento, penetração fixa, roubo de vida, poder de cura, cura recebida, resistência a efeito, alcance e status de loot.

## 4. Regras locais do slice

| Conceito | Classe | Regra |
| --- | --- | --- |
| Guarda | recurso de Bastião (0–100) | ativa nos kits completos (2026-09-30); as cláusulas "+Guarda" das passivas que ficaram dormentes no slice inicial seguem EM ABERTO onde não têm gasto |
| Perfect Block | evento com estado "Guarda pronta" e recarga | o primeiro ataque que atinge Bastião com o estado pronto vira Perfect Block: dano muito reduzido e Desequilíbrio no atacante. Determinístico, sem comando. Recarga EM ABERTO |
| Desequilíbrio | debuff de 4 s | `damage_bonus` −10% do alvo e +20% de postura sofrida (conversão HIPÓTESE; `combat_core.imbalance`) |
| Postura | barra separada do HP | [01 §7](../01_STATUS_E_COMBATE.md#7-postura-stagger) |
| Marca | estado do alvo | não muda números sozinha; skills, passivas e itens consultam se o alvo está marcado; sem acúmulo |

EM ABERTO: recarga do Perfect Block; conversão exata do Desequilíbrio; Tenacidade contra a Contenção Arcana em elite/minichefe/chefe.

## 5. Resultado medido (Argos, simulação — não é playtest)

Estado em 2026-09-30, escala 10×, `p = 0,8`, valores de item migrados, chefe ×2, perfil de rota `tipico`:

- Mediana do nível de vitória do Guardião na campanha: **10,2** (10,8 sem as builds Lúmen); faixa 7–13; ~5,2 tentativas; 18/18 combinações vencem.
- TTK mediano do Guardião: **147,5 s** (faixa 120–210 s).
- Rota nível 10 com `tipico`: 50% de vitória média, 8 caminhos viáveis (2 sem Lúmen).
- Kits completos: 3068 execuções nos cenários `kits_focus_*`, 0 `BUG` ([validação](../../../08_qa/KITS_VALIDATION_2026-09-30.md)).
- Achados abertos: BAL-009 a BAL-015 ([BALANCE_FINDINGS](../../../08_qa/BALANCE_FINDINGS.md)). Relatórios em `tools/argos/reports/`.

## 6. Histórico de mudanças do perfil

| # | Mudança | Antes | Depois | Evidência |
| --- | --- | --- | --- | --- |
| 1 | Fôlego na expedição | nenhum | 10% sem queda | `slice_paths`: única alavanca que abriu caminhos sem cura |
| 2 | Nível do conteúdo | fases 1–5, Guardião 5 | 1/3/5/7, Guardião 10 | meta de vitória em 10–11 (`tune_v05_levels`) |
| 3 | HP de party do chefe | ×3 → ×2 | ×1,5 | ×2 com Guardião nível 10 levava a vitória ao 13 |
| 4 | Golpes do Guardião, elite e Rainha | só comum | comum ×0,6 + golpe forte telegrafado na frente; Rainha com 2 ondas de adds | regra de chefe: dano alto precisa de aviso |
| 5 | Pulso Restaurador | 2,0×ATK / 10 s | 0,3× / 16 s | com fôlego, 1,2× vencia no nível 1 (`tune_heal`) |
| 6 | Muralha Viva / Fortaleza | −40%; 20 s | −50%; 16 s | Guardião era o caminho mais lento (`tune_v05_builds`) |
| 7 | Ranks de skill | regra genérica | R2–R5 por skill | fidelidade ao design |
| 8 | Passivas/Traits | ausentes | 13 com efeito, depois kits completos (16 passivas, 3 Traits por herói) | builds rodavam com metade do kit |
| 9 | Escala | 1× | `combat_scale` 10, `DEFENSE_K` junto | decisão de Rafael; invariância provada |
| 10 | Curva de nível | linear | `p = 0,8` | mediana 9,5 → 10,0 |
| 11 | Itens | BP 2/3/4/5, 1% por BP, Reforço +2% | escada convexa, 1,8% por BP, reserva só com modificador, Reforço +10% | set Épico de ~+3% para ~+29–38% |
| 12 | HP de party do chefe | ×1,5 | ×2 | itens novos baixaram a mediana para 9,0; ×2 → 10,2 e TTK 147,5 s |
| — | `enemy_damage_scale` | 0,50 | inalterado | decisão de Rafael |

## 7. Como re-medir

```text
python tools/balance/validate_balance_data.py
python tools/argos/run.py --scenario slice_quick        # ~2 s
python tools/argos/run.py --scenario slice_balance      # matriz das 18 combinações
python tools/argos/run.py --scenario slice_run_layer    # eventos e loot da run
python tools/argos/run.py --scenario slice_paths        # caminhos alternativos à cura
python tools/argos/run.py --scenario argos_profiles     # perfis de jogador
python tools/argos/analyzer/variant_matrix.py           # build × variante do último relatório
```

Cenários de calibração: `tune_heal`, `tune_v05_levels`, `tune_v05_builds`, `tune_items_boss`, `tune_kits_party` em `tools/argos/simulator/combat/scenarios/`.
