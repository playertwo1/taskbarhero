---
id: BALANCE_V0_5
status: IMPLEMENTING
certainty: HIPOTESE
---

# Balanceamento v0.5 — Capítulo 1 incremental

**Autoridade:** intenção, regras de escala e registro das mudanças do balanceamento do slice sobre a base canônica [TASKBAR v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md). **Os valores ficam em `/data`**: [núcleo global](../../data/balance/combat_core.json), [perfil do Capítulo 1](../../data/balance/chapters/chapter_01.json), [heroes](../../data/heroes/heroes.json), [enemies](../../data/enemies/enemies.json), [skills](../../data/skills/skills_slice.json), [passivas](../../data/skills/passives_slice.json), [items](../../data/items/items.json) e [rota](../../data/expedition/route_c1.json). O [manifesto](../../data/balance/combat_profiles.json) apenas compõe esses perfis. A tabela abaixo é histórico. O v0.4 não é editado. Tudo aqui é **simulação** do Argos, não playtest.

## 1. O que queremos (DECIDIDO por Rafael, 2026-09-29)

- Jogo **incremental**, níveis 1–100. Progredir é alternar derrotas e vitórias parciais, voltar ao Hub mais forte e tentar de novo.
- O **Guardião-Cervo (fim do Capítulo 1) é vencido por volta do nível 10–11**, não no 5.
- **HP volta ao máximo no Hub**; na expedição só existe o **fôlego entre encontros**.
- **Mais de um caminho viável**: a cura não pode ser obrigatória nem dominante.

## 2. Como cada sistema escala

| Sistema | Regra | Autoridade | Estado |
| --- | --- | --- | --- |
| Status dos heróis | HP/ATK/DEF lineares do nível 1 ao 100 pela tabela do v0.4; ~2,5% de força por nível. Velocidade, crítico, Haste e Tenacidade não sobem por nível | `heroes.json` · [HERO_STATS_BALANCE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/HERO_STATS_BALANCE.md) | canônico |
| XP e nível | XP por rank do inimigo e curva do runtime; uma rota completa rende ~2 níveis no início. XP de derrotas também conta | `combat_core.xp` | HIPÓTESE |
| Skills | 2 por herói; ranks R1–R5 com números **e** comportamento por skill; 1 rank a cada 2 níveis a partir do 3 (marcos EM ABERTO) | `skills_slice.json` (`ranks`) · [proposta](CHAPTER_01_HERO_COMBAT_PROPOSAL.md) | HIPÓTESE |
| Passivas e Traits | pacote fixo por build no slice; Bastião com números da ficha, Íris e Flecha com números de simulação | `passives_slice.json` | DESIGN/HIPÓTESE |
| Equipamentos | orçamento canônico: raridade × slot × item power × nível do item; conjunto lendário completo = +30–45%. Drops pelas tabelas do v0.4; nível do item = nível do encontro | `items.json` · [SliceItemStats](../../scripts/combat/SliceItemStats.gd) · [EQUIPMENT_BALANCE](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/EQUIPMENT_BALANCE.md) | canônico |
| Inimigos | `HERO_REFERENCE` do nível × arquétipo × rank × `enemy_damage_scale`; HP de elite/mini-boss/boss × escala de party | `combat_core.json` + `chapters/chapter_01.json` | HIPÓTESE |
| Nível do conteúdo | **nível recomendado por fase: 1 / 3 / 5 / 7 e Guardião 10** | `route_c1.json` | **v0.5** |
| Mecânicas | golpe forte telegrafado na linha de frente, Stagger/quebra, Perfect Block, Desequilíbrio, fases com adds, ameaça de cura/escudo | `enemies.json` (`mechanics`) · [ExpeditionRun](../../scripts/combat/ExpeditionRun.gd) | HIPÓTESE |
| Recuperação | fôlego: fração do HP máximo dos vivos ao fim de um encontro sem queda; nada depois do último encontro | `chapters/chapter_01.json → recovery_between_encounters` | DECIDIDO (valor HIPÓTESE) |

**Consequência para o jogo incremental:** o nível sozinho rende pouco. O progresso entre tentativas vem da soma de nível + ranks de skill + itens; por isso a vitória no nível 10–11 exige de 4 a 10 tentativas, e não uma parede que só XP resolve.

## 3. Mudanças do v0.4 para o v0.5

| # | O quê | Antes | v0.5 | Por quê (evidência) |
| --- | --- | --- | --- | --- |
| 1 | Recuperação na expedição | nenhuma | fôlego 10% sem queda | Rafael escolheu; `slice_paths`: única alavanca, com poções, que abriu caminhos sem cura |
| 2 | Nível do conteúdo | fases 1–5, Guardião 5 | 1/3/5/7, Guardião 10 | meta de vitória no nível 10–11; nível do inimigo = nível recomendado (`tune_v05_levels`) |
| 3 | HP do chefe pela party | ×3 (contrato) → ×2 | ×1,5 | ×2 com Guardião nível 10 levava a vitória ao nível 13; ×1,5 centra em 11 sem mexer no dano de Rafael (`tune_v05_levels`) |
| 4 | Golpes do Guardião, elite e Rainha | só ataque comum | comum ×0,6 + golpe forte telegrafado na frente; Rainha ×0,6 com 2 ondas de adds | [BOSS_RULES](../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/BOSS_RULES.md): dano alto precisa de telegraph; com resposta, a cura deixou de ser o único caminho |
| 5 | Pulso Restaurador (experimental) | 2,0× ATK / 10 s | 0,3× / 16 s | com fôlego, 1,2× vencia no nível 1 (`tune_heal`) |
| 6 | Muralha Viva e Fortaleza | −40%; Fortaleza 20 s | −50%; Fortaleza 16 s | Guardião era o caminho mais lento (`tune_v05_builds`) |
| 7 | Ranks de skill | regra genérica | R2–R5 por skill da proposta | fidelidade ao design; números e comportamento |
| 8 | Passivas/Traits | ausentes | 13 com efeito em combate | builds rodavam com metade do kit |
| — | `enemy_damage_scale` | 0,50 (Rafael) | **inalterado** | 0,40 também atinge a meta, mas mexeria numa decisão de Rafael |

## 4. Resultado medido (v0.5)

`python tools/argos/run.py --scenario slice_balance` — 18 combinações, 6 sementes, campanha com loot até 16 tentativas; relatório em `tools/argos/reports/`.

- **Todas as 18 combinações vencem o Guardião.** Nível mediano de vitória **11** (faixa 9–15); tentativas medianas ~6 (4–10).
- **Caminhos:** Controle, Lúmen e Arcano vencem; Controle e Lúmen ficam em 9–12; Arcano em 11–15 (mais arriscado).
- **TTK:** elite ~16 s, Rainha ~44 s, Guardião ~120 s no nível 10.

## 5. Em aberto

- **Arcano com Guardião vence tarde (nível 13–15):** as duas builds não respondem ao golpe forte. Aumentar dano do Arcano não mudou nada; o problema é sobrevivência. Aceito como combinação fraca até decisão.
- **Guardião perto do piso de 120–210 s** (110–133 s no nível 10): efeito do ×1,5. Alternativa: HP ×2 com ajuste de outra alavanca.
- **Marcos de rank, números das passivas da Íris e da Flecha, XP por encontro** e o valor do fôlego seguem HIPÓTESE.
- **Rainha no nível 5 depois de um encontro nível 7:** efeito da ordem local do slice; revisar com a ordem final das fases.
- Só playtest decide diversão e sensação de progresso; a meta humana de 40–60% na primeira tentativa não é medida aqui.

## 6. Como re-medir

```text
python tools/argos/run.py --scenario slice_balance      # matriz v0.5 (~2 min)
python tools/argos/run.py --scenario slice_paths        # caminhos alternativos à cura
python tools/argos/analyzer/variant_matrix.py           # tabela build × variante do último relatório
```

Cenários de calibração: `tune_heal`, `tune_v05_levels`, `tune_v05_builds` em `tools/argos/simulator/combat/scenarios/`.
