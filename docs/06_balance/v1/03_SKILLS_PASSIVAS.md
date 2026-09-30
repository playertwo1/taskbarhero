---
document_type: balance-domain
id: BALANCE_V1_03_SKILLS_PASSIVAS
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 01_STATUS_E_COMBATE, 02_HEROIS]
---

# 03 — Skills, passivas, Traits e Mastery

Regras de seleção e uso: [SKILL_SYSTEM](../../03_systems/SKILL_SYSTEM.md). Estrutura: [HERO_STANDARD](../../02_heroes/HERO_STANDARD.md). Valores runtime: [`skills_slice.json`](../../../data/skills/skills_slice.json) e [`passives_slice.json`](../../../data/skills/passives_slice.json). Este arquivo define o **orçamento** do kit, que no total ocupa a fatia "kit" da [constituição §4](00_CONSTITUICAO.md#4-orçamento-de-poder).

## 1. Loadout

- 2 skills normais equipadas por build + a **Signature em um 3º slot fixo** (DECIDIDO por Rafael em 2026-09-30 para o slice; conflita com o HERO_STANDARD, que abre a Signature só no Tier 6/nível 60: [11 D-02](11_DECISOES_ABERTAS.md)).
- Nenhuma combinação de 2 skills é obrigatória para todas as builds; cada build tem pelo menos 3 combinações viáveis.
- Uma skill não entrega dano máximo + defesa máxima + controle máximo ao mesmo tempo.

## 2. Orçamento por tipo de skill (coeficiente × ATK; HIPÓTESE herdada)

| Tipo | Coeficiente | Recarga típica |
| --- | --- | --- |
| Ataque básico | 1,00 | — |
| Alvo único | 1,60–2,40 | 6–12 s |
| Área (por alvo) | 1,00–1,60 | 8–14 s |
| Controle forte | 0,70–1,30 + controle | quanto mais controle, menos dano |
| Cura | 1,30–2,00 × status de escala | 8–14 s |
| Signature alvo único | 3,00–5,00 | 30–60 s |
| Signature área (por alvo) | 2,00–3,25 | 30–60 s |

- Área é avaliada com alvos realistas: 1 (único), 3 (área pequena), 5 (área grande). Nunca 10.
- Controle custa pelo contexto (duração, uptime, alvos, Tenacidade esperada, dano perdido), nunca BP fixo.
- Cura e escudo valem pela vida efetiva gerada por janela; overheal e escudo expirado não contam.
- Signature de suporte troca dano por cura, escudo, controle, buff, reset parcial ou invocação. Nunca é "300% de dano".
- Medição do slice: recargas de Signature 120/60/60 s trouxeram a mediana de vitória de 7,5 para 9,5 ([KITS_TUNING_LOG](../../08_qa/KITS_TUNING_LOG.md)); valores vigentes em `/data`.

## 3. Ranks

- Normais R1–R5; Signature R1–R3. Ranks altos mudam comportamento (alcance, área, duração, alvos, interação com a mecânica, status, recurso), não só dano.
- **Orçamento de rank (RECOMENDADO):** R1→R5 soma no máximo +60% do valor da skill em R1, dos quais pelo menos 1 rank é mudança funcional. Signature R1→R3: +40%.
- Marcos de rank: 1 melhoria a cada 2 níveis a partir do 3 no slice (HIPÓTESE); no jogo inteiro, os pontos de melhoria acompanham os ~75 pontos de árvore ([02 §7](02_HEROIS.md#7-pontos-de-árvore-do-herói-e-respec)).

## 4. Passivas e Traits

- 16 passivas por herói (1 de identidade + A1–A5, B1–B5, C1–C5), até 5 ranks cada. Bandas de ganho **real** medido em combate:

| Banda | Ganho real de poder | Uso |
| --- | ---: | --- |
| Pequena | 3–5% | A1–A2 |
| Média | 6–9% | A3–A4 |
| Maior / definidora | 10–15% | Capstone (A5) e identidade |

- Passiva condicional pode ter número maior, porque não fica ativa 100% do tempo (magnitude × uptime).
- **Regra de medição (resposta ao BAL-011):** toda passiva precisa de efeito mensurável. O Argos roda a ablação (desliga a passiva) e registra o ganho; passiva com ganho < 1% em todos os cenários é achado `BALANCE` (fraca ou sem cobertura do simulador).
- Capstones de tier alto entram por `unlock_level` para não mexer no equilíbrio dos níveis baixos.
- **Traits:** 3 por herói, 1 ativo, um por build. Mudam uma regra (ex.: "Perfect Block provoca Contra-Golpe"), nunca "+10% de dano". Orçamento de um Trait ≈ uma passiva definidora.

## 5. Mastery 1–10

- Começa depois do nível 100 (HERO_STANDARD): M1 bônus pequeno da mecânica, M3 modificador de skill, M5 visual, M7 modificador avançado, M10 modificador de Signature + aparência.
- **Orçamento (RECOMENDADO):** M1–M10 somam no máximo +10% de poder real e ficam dentro da fatia do kit no endgame. Mastery nunca é progressão infinita.
- XP de Mastery vem do conteúdo de dificuldade ([09](09_DIFICULDADE_ENDGAME.md)).

## 6. Recurso e IA de uso

- Cada recurso ([01 §10](01_STATUS_E_COMBATE.md#10-recursos-de-herói)) tem orçamento de ciclo: tempo médio para encher de 0 ao gasto principal entre 6 e 15 s em combate contínuo (HIPÓTESE). Alertas: overflow > 30% do combate ou recurso vazio > 50% do combate.
- **IA de uso é parte do balanceamento:** o combate é automático. A prioridade entre as duas skills e o limite do gatilho são escolhidos pelo jogador no Hub (DECIDIDO, 2026-09-28). O Argos mede cada skill com o gatilho padrão e com o melhor gatilho; diferença > 30% entre os dois indica gatilho padrão ruim, não skill fraca.
- `missed_opportunities` (skill pronta sem alvo válido) entra na telemetria.

## 7. Alertas de dominância (gatilhos de investigação, não nerf automático)

Skill com equip rate > 80%; passiva com escolha > 80%; build > 20% mais rápida em conteúdo neutro; skill nunca escolhida por nenhum perfil do Argos.
