---
document_type: balance-domain
id: BALANCE_V1_06_INIMIGOS_CHEFES
version: "1.0"
status: DESIGN
certainty: HIPOTESE
last_reviewed: 2026-09-30
depends_on: [00_CONSTITUICAO, 01_STATUS_E_COMBATE]
---

# 06 — Inimigos, elites e chefes

Valores runtime: `combat_core.json` (`reference_hero`, `archetypes`, `ranks`), perfis de capítulo (`enemy_damage_scale`, `party_hp_scale`) e [`data/enemies/enemies.json`](../../../data/enemies/enemies.json). Schema completo de inimigo com loot: [specs/ENEMY_CANONICAL_SCHEMA](specs/ENEMY_CANONICAL_SCHEMA.md). Conteúdo do Capítulo 1: [CHAPTER_01_ENEMIES_CANONICAL.json](../../04_content/enemies/CHAPTER_01_ENEMIES_CANONICAL.json).

## 1. Herói de referência

Entidade abstrata contra a qual todo conteúdo é balanceado. HP 115→470, ATK 12→50, DEF 9→36 (1×; runtime ×10), AS 1,0, crítico 5%, dano crítico 1,5×, curva `p = 0,8`.

```text
DPS básico da referência      = ATK × AS × (1 + crit × (dano_crit − 1))
DPS sustentado da referência  = DPS básico × 1,75     (1,75 = contribuição média de skills/passivas;
                                                       regra de balanceamento, não existe no runtime)
```

## 2. Fórmula do inimigo

`inimigo = REF(L) × arquétipo × rank × 1,08^(c−1) × dificuldade × escalas locais do capítulo`

| Arquétipo | HP | ATK | DEF | AS | Uso |
| --- | ---: | ---: | ---: | ---: | --- |
| Enxame | ×0,35 | ×0,55 | ×0,50 | ×1,25 | numerosos e frágeis |
| Padrão | ×0,85 | ×0,75 | ×0,75 | ×1,00 | comum |
| Pesado | ×1,40 | ×0,85 | ×1,25 | ×0,70 | lento e resistente |
| À distância | ×0,65 | ×0,95 | ×0,55 | ×0,90 | pressão de longe |
| Assassino | ×0,55 | ×1,15 | ×0,50 | ×1,25 | rápido, frágil, burst |
| Controlador | ×0,75 | ×0,65 | ×0,80 | ×0,80 | status/controle |
| Suporte | ×0,70 | ×0,55 | ×0,70 | ×0,85 | cura, buffs, invocações |

| Rank | HP | ATK | DEF | Tenacidade |
| --- | ---: | ---: | ---: | ---: |
| Normal | ×1,00 | ×1,00 | ×1,00 | +0 |
| Elite | ×2,30 | ×1,25 | ×1,15 | +25 |
| Minichefe | ×7,00 | ×1,55 | ×1,35 | +50 |
| Chefe | ×20,00 | ×1,80 | ×1,50 | +100 |

Arquétipo define a forma de lutar; rank define o peso do encontro. O fator ×1,08 por capítulo é DECIDIDO como direção (HIPÓTESE como valor). A identidade do capítulo vem mais de mecânica e composição que de inflação de HP.

**Escalas locais que precisam virar regra global (RECOMENDADO, [11 D-05](11_DECISOES_ABERTAS.md)):**

- `enemy_damage_scale` (Capítulo 1: 0,50, decisão de Rafael): as tabelas herdadas faziam um inimigo comum matar a referência em 14–17 s, contra a meta de 25–35 s. Como a meta é global, o fator deve virar global em `combat_core`, não local de capítulo.
- HP de party (Capítulo 1: elite e minichefe ×3, chefe ×2): a party tem sempre 3 heróis, então a escala também deve ser global por rank.

## 3. Tempo e dano

| Tipo | TTK-alvo (party no nível, equipamento típico) |
| --- | ---: |
| Enxame (indivíduo) | 1–2 s |
| Normal | 3–6 s |
| Pesado | 6–10 s |
| Elite | 15–30 s |
| Minichefe | 40–75 s |
| Chefe | 120–210 s |

- Ataque comum de um inimigo Padrão contínuo consome 100% do EHP da referência em **25–35 s** sem cura, controle nem esquiva.
- Golpes telegrafados podem causar muito mais dano porque são evitáveis/respondíveis. Quanto maior o dano, maior o aviso e o contrajogo.
- Cada capítulo introduz **pressões novas** em vez de só números maiores ([§6](#6-pressões-por-capítulo)).

## 4. Encontros

Orçamento de encontro: Enxame 0,35 · Normal 1,00 · Pesado 1,40 · À distância 1,10 · Assassino 1,25 · Controlador 1,30 · Suporte 1,25 · Elite ×2,5 sobre o arquétipo. Composições com sinergia forte (ex.: Controlador + Assassino) recebem custo extra. Adds de chefe contam no orçamento; se adds são a mecânica central, o dano do chefe cai.

**Affixes de elite:** 1 affix (conteúdo alto até 2), que muda comportamento, não só +HP. Famílias: Berserker, Blindado, Vampírico, Volátil, Invocador, Veloz, Espinhos, Aura, Teleportador. Proibido combinar affixes que removam o contrajogo.

## 5. Regras de chefe

- Todo chefe tem pelo menos: 1 identidade, 2 padrões principais, 1 mecânica de pressão, 1 janela de vulnerabilidade, 1 mudança de fase ou escalada.
- Fases: base 100–70% / 70–35% / 35–0% (`phase_thresholds` nos dados).
- **Anti-infinito:** enrage suave em todo chefe (ataques mais rápidos, adds, menor recuperação). Enrage duro é raro.
- Sem invulnerabilidade invisível: fase que não pode ser pulada tem `phase_gate` explícito com feedback.
- Controle: Tenacidade +100 e resistência temporária a controle repetido ([01 §8](01_STATUS_E_COMBATE.md#8-controle-em-chefes)). Postura: quebrável, com imunidade de 3–5 s após a quebra.
- One-shot só se telegrafado, evitável, raro e coerente com a dificuldade; nunca no Normal.
- Anti-cura/anti-escudo só em janelas temporárias, nunca a luta toda.
- Script de chefe pode mudar fase, invocar adds, forçar alvo, alterar arena e aplicar mecânica; não pode alterar status-base, quebrar caps nem mexer no save.
- QA: chefe funciona com corpo a corpo, à distância, tanque, suporte, burst, DOT, controle e invocação; sem build obrigatória; sem fase impossível por RNG.

## 6. Pressões por capítulo

Cada capítulo adiciona 1–2 pressões que pedem builds diferentes (HIPÓTESE; o conteúdo de cada capítulo confirma):

| Capítulo | Pressão nova proposta |
| ---: | --- |
| 1 — Bosque de Lúmen | golpes telegrafados na linha de frente; ondas de adds |
| 2 — Minas de Cinza (nome herdado, não aprovado) | dano em área e Fogo |
| 3 | cura e escudos inimigos (suportes a priorizar) |
| 4 | controle (atordoar, silenciar) |
| 5 | invocadores |
| 6 | DOT Tóxico acumulado |
| 7 | assassinos na retaguarda |
| 8 | resistências de tipo e troca de fraqueza por fase |
| 9 | janelas de burst curtas (enrage mais cedo) |
| 10 | combinação das anteriores |

## 7. Alvos de loot e XP por rank

Drops, raridade e pity por rank ficam em [07](07_ECONOMIA_LOOT.md); XP por rank e nível em [02 §5](02_HEROIS.md#5-xp-e-ritmo-de-nível).

## 8. QA de inimigo novo

Validar nível, arquétipo e rank; medir TTK e dano recebido; testar build defensiva, ofensiva e de controle; verificar telegraphs e combinações; nenhum ataque inevitável com burst absurdo sem contrajogo.
