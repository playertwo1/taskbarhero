---
document_type: balance-domain
id: BALANCE_V1_02_HEROIS
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 01_STATUS_E_COMBATE]
---

# 02 — Heróis: base, crescimento, papéis e XP

Anatomia do herói (6 skills, 16 passivas, 3 Traits, Mastery 1–10, 6 slots, 5 missões): [HERO_STANDARD](../../02_heroes/HERO_STANDARD.md). Este arquivo trata só dos números e do orçamento. Valores runtime do trio: [`data/heroes/heroes.json`](../../../data/heroes/heroes.json) (prevalece sobre a tabela abaixo para Bastião, Flecha e Íris).

## 1. Tabela-base dos 8 heróis (unidade 1×; runtime multiplica por 10)

Herdada da base v0.5 (HIPÓTESE). Crescimento pela curva-mestra `p = 0,8` ([00 §3](00_CONSTITUICAO.md#3-curva-mestra--única-para-o-jogo-inteiro)).

| Herói | Papel | HP L1→L100 | ATK L1→L100 | DEF L1→L100 | AS | Crítico | Dano crítico | Haste | Tenacidade |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Bastião | Tanque / protetor | 160 → 700 | 10 → 42 | 18 → 80 | 0,80 | 3% | 1,50× | 0 | 20 |
| Flecha | DPS à distância | 100 → 380 | 14 → 60 | 7 → 28 | 1,20 | 10% | 1,60× | 0 | 0 |
| Íris | Maga / controle | 95 → 360 | 15 → 63 | 6 → 25 | 0,90 | 5% | 1,50× | 15 | 0 |
| Brasa | Bruiser / berserker | 140 → 600 | 13 → 55 | 12 → 50 | 1,00 | 5% | 1,50× | 0 | 10 |
| Véu | Assassino | 90 → 330 | 15 → 60 | 5 → 22 | 1,25 | 10% | 1,65× | 5 | 0 |
| Orvalho | Cura / suporte | 110 → 440 | 9 → 42 | 8 → 32 | 0,95 | 3% | 1,50× | 20 | 5 |
| Forja | Engenheiro / invocador | 120 → 500 | 11 → 48 | 10 → 38 | 0,90 | 5% | 1,50× | 10 | 5 |
| Sino | Buffer / tempo | 105 → 430 | 10 → 40 | 9 → 35 | 1,00 | 5% | 1,50× | 18 | 10 |

Não crescem por nível: AS, movimento, crítico, dano crítico, Haste e Tenacidade ([01 §1](01_STATUS_E_COMBATE.md#1-registro-único-de-status)).

## 2. Foco de crescimento por papel

- **DECIDIDO (Rafael, 2026-09-30) — só a direção:** o tanque cresce mais HP e DEF que ATK; os frágeis (Flecha, Íris, Véu) crescem mais ATK. Hoje todos crescem ~4× em tudo e o papel só aparece no nível 1.
- **EM ABERTO ([11 D-03](11_DECISOES_ABERTAS.md)):** os números. Uma proposta (Bastião HP ×6/ATK ×3,5/DEF ×5,5; Flecha ATK ×5,5; Íris ATK ×6) levaria o ATK de Flecha e Íris a 154% e 180% do herói de referência no nível 100, fora do envelope de 85–115%. A regra da v1: **o foco muda a forma do crescimento, não o envelope** ([§4](#4-envelope-de-poder)). Proposta RECOMENDADA: foco limitado a ±25% do fator de crescimento de cada status, compensado no status oposto.

## 3. Papéis e fraquezas declaradas

Cada herói empurra no máximo **2 eixos principais + 1 secundário** entre: dano, sobrevivência, controle, cura/suporte, mobilidade, economia/recurso. Cada herói declara 1–2 **fraquezas centrais**; o Argos verifica que nenhum conjunto de equipamento típico ou bom as zera (linha vermelha 3 da constituição).

| Herói | Eixos principais | Secundário | Fraqueza central declarada (HIPÓTESE) | Métrica que o Argos verifica |
| --- | --- | --- | --- | --- |
| Bastião | sobrevivência + suporte | controle | dano pessoal baixo | DPS pessoal ≤ 80% da referência com qualquer equipamento |
| Flecha | dano (alvo único) | controle (Marca) | pouca margem defensiva | EHP ≤ 75% da referência |
| Íris | controle + dano em área | suporte | frágil e dependente de alvo preparado | EHP ≤ 75%; dano cai sem preparo |
| Brasa | dano + sobrevivência | recurso | picos dependem de Fúria/HP baixo | DPS abaixo da referência com Fúria baixa |
| Véu | dano (burst) | mobilidade | EHP mínimo; depende de janela | EHP ≤ 65% |
| Orvalho | cura/suporte | sobrevivência | dano pessoal baixo | DPS pessoal ≤ 60% |
| Forja | dano via invocações | controle | dano pessoal baixo; invocações quebráveis | DPS pessoal ≤ 60% |
| Sino | suporte (buffs, tempo) | dano em janela | dano direto baixo | DPS pessoal ≤ 60% |

## 4. Envelope de poder

- Os heróis não precisam do mesmo DPS básico; precisam da mesma **capacidade de completar conteúdo equivalente** com o kit completo.
- Dano sustentado (30 s, básico + skills equipadas + passivas relevantes): **85–115% da referência**. Exceções justificadas: Bastião (EHP/controle), Orvalho (cura), Sino (buffs) abaixo; Véu acima só em alvo único e nunca com sobrevivência alta ao mesmo tempo.
- Nenhum herói pode: matar chefe equivalente > 25% mais rápido que todos sem contrapartida; sobreviver indefinidamente sem perder dano/recurso; ter o melhor dano em área, alvo único e sustento ao mesmo tempo.
- Três builds por herói: desempenho total semelhante por mecanismos diferentes; diferença de tempo ≤ 15% em conteúdo neutro.
- Testes obrigatórios por herói: níveis 1, 25, 50, 75, 100; EHP; DPS básico; DPS sustentado 30 s; burst 5 s; sem equipamento, típico e bom; cada build; combinações de skills.

## 5. XP e ritmo de nível

**Achado (2026-09-30):** a curva atual (`combat_core.xp`) pede `25 × 1,15^(L−1) + 5L` XP por nível, mas o XP por inimigo é fixo (Normal 6, Elite 25, Minichefe 45, Chefe 80). Isso funciona no Capítulo 1 e torna o nível 100 inalcançável: do 99 ao 100 seriam ~22 milhões de XP (~1,7 × 10⁸ no total).

**Regra v1 (RECOMENDADO; números HIPÓTESE, [11 D-04](11_DECISOES_ABERTAS.md)):**

- O alvo é **tempo por nível**, não XP bruto. Cada capítulo rende ~10 níveis nas horas do jogador de referência ([00 §6](00_CONSTITUICAO.md#6-jogador-de-referência-por-capítulo)).
- O XP concedido cresce com o nível do conteúdo pela mesma taxa da curva de XP exigido (`xp_recompensa = base_rank × 1,15^(L_conteúdo − 1)`), então o número de encontros por nível fica estável dentro de um capítulo e cresce só com as horas-alvo.
- Derrotas contam: o XP dos encontros vencidos na expedição é mantido. O chefe não dá XP se não for derrotado.
- Anti-farm pela diferença de nível ([00 §9](00_CONSTITUICAO.md#9-relevância-e-diferença-de-nível)).

## 6. Heróis no banco — catch-up — DECIDIDO (Rafael, 2026-09-30)

- Só quem joga ganha XP. Um herói abaixo do herói de maior nível da conta ganha **XP ×3 até ficar 5 níveis abaixo do topo** (multiplicador e distância HIPÓTESE). Trocar de herói no capítulo 6 não exige refazer 50 níveis.
- Mastery e ranks de skill continuam individuais e sem catch-up.

## 7. Pontos de árvore do herói e respec

- ~75 pontos recebidos até o nível 100 contra ~108 possíveis (HERO_STANDARD): ninguém maximiza as três builds.
- Pontos entram nos marcos de nível; a escolha acontece no Hub após a expedição (decisões de [SKILL_SYSTEM](../../03_systems/SKILL_SYSTEM.md)).
- **Respec (RECOMENDADO):** barato para incentivar experimentação. Primeiro respec por capítulo grátis; depois custo em Ouro proporcional ao capítulo, nunca em Fragmentos. Respec nunca remove desbloqueios da Árvore dos Ecos.

## 8. Referência de implementação

Bastião é a Golden Reference de implementação (dados completos, IDs estáveis, breakdown de status, testes), não o herói mais forte. Mudanças nos números da tabela do §1 exigem registro (anterior, novo, motivo, teste, impacto).
