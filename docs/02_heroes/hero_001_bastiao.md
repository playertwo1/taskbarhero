# HERO_001 — Bastião (O Guardião Resoluto)

**Status de design:** `HERO_DESIGN_WIP`  
**Status de engine/runtime:** `IMPLEMENTED` (Cena Godot e Spritesheet integrados)  
**ID de design:** `HERO_001`  
**ID runtime:** `bastiao` / `hero_bastiao`  
**Papel central:** Tank / Protector  
**Recurso exclusivo:** Guarda (0/100)  
**Posição de combate:** Vanguarda (`front`)  
**Orientação visual:** Direita ($\rightarrow$)  
**Conformidade:** [`HERO_STANDARD.md`](../../HERO_STANDARD.md)

---

## 1. Identidade

* **Nome:** Bastião
* **Arquétipo:** Tank defensivo focado em:
  * absorver pressão;
  * proteger aliados;
  * controlar inimigos;
  * bloquear ataques importantes;
  * converter defesa em dano;
  * sobreviver quando todos os outros cairiam.
* **Fantasia:** «"Eu fico."»  
  Bastião não luta porque acredita que é invencível. Ele luta porque alguém precisa permanecer de pé.

---

## 2. Filosofia de gameplay

Bastião não deve ser: «personagem com 300% mais HP que simplesmente apanha.»  
Ele deve recompensar decisões do jogador: quem está sendo atacado → de onde vem o perigo → quando bloquear → quando gastar Guarda.

```
Loop principal:

INIMIGO ATACA
      ↓
BASTIÃO BLOQUEIA
      ↓
GERA GUARDA
      ↓
PROTEGE ALIADOS
      ↓
ACUMULA PRESSÃO
      ↓
CONVERTE DEFESA EM ATAQUE
      ↓
CONTROLA O CAMPO
      ↓
VOLTA A DEFENDER
```

---

## 3. Mecânica exclusiva — GUARDA

Bastião possui um recurso chamado **GUARDA** (Valor inicial: `0 / 100`).  
Guarda representa sua capacidade de manter posição sob pressão.

| Evento | Guarda Gerada |
| --- | :---: |
| Receber ataque | +2 |
| Bloquear ataque | +5 |
| Perfect Block | +12 |
| Aliado protegido receber ataque | +4 |
| Provocar inimigo | +3 |
| Contra-Golpe acertar | +5 |

*Limite:* Máximo de 100 de Guarda. Guarda não desaparece imediatamente fora de combate; decai lentamente após alguns segundos de calmaria.

---

## 4. Perfect Block

Existe uma janela curta ao levantar a defesa. Se um golpe inimigo atingir Bastião nessa janela: **PERFECT BLOCK**.
* Dano recebido drasticamente reduzido.
* Gera +12 de Guarda adicional.
* Aplica status de **Desequilíbrio** ao atacante.
* Ativa interações de skills e passivas.

---

## 5. Status exclusivo — Desequilíbrio

Algumas ações de Bastião aplicam **Desequilíbrio**:
* **Dano causado pelo inimigo:** -10%
* **Resistência a stagger:** -20%
* **Duração:** 4 segundos

---

## 6. Ataque básico — MARCHA DE FERRO

Combo contínuo de espada e escudo:
* **Golpe 1:** Espada horizontal
* **Golpe 2:** Pancada de escudo
* **Golpe 3:** Corte pesado descendente (Gera **+4 Guarda**; se atingir inimigo Desequilibrado, gera **+6 Guarda**).

---

## 7. Defesa básica — Erguer Escudo

* **Redução frontal inicial:** 70%
* **Movimento:** -35% de velocidade
* Bastião pode avançar lentamente enquanto mantém o arco frontal de proteção erguido.

---

## 8. Catálogo das 6 Skills

| Slot | Skill | Função | Cooldown |
| :---: | --- | --- | :---: |
| **S1** | Muralha Viva | Proteção de retaguarda | 14s |
| **S2** | Contra-Golpe | Retaliação e resposta | 8s |
| **S3** | Desafio | Controle de aggro e taunt | 15s |
| **S4** | Fortaleza | Ancoragem e mitigação maciça | 20s |
| **S5** | Impacto de Escudo | Investida, dano e colisão | 10s |
| **Signature** | Último Bastião | Intervenção suprema | 100 Guarda |

---

## 9. Detalhamento das Habilidades

### S1 — Muralha Viva
Bastião projeta uma barreira protetora para trás. Aliados posicionados atrás do escudo recebem **-40% de dano à distância**. Parte do dano mitigado gera Guarda. (Duração: 6s | CD: 14s).
* **Ranks:** R1 básico → R2 +1s duração → R3 +10% resistência a aliados → R4 área expandida → R5 Perfect Blocks prolongam a barreira.

### S2 — Contra-Golpe
Postura reativa: se golpeado na janela, desfere contra-ataque imediato causando **180% Weapon Damage** (ou **250%** em Perfect Block) e aplicando **Desequilíbrio**. (CD: 8s).
* **Ranks:** R1 básico → R2 +20% dano → R3 gera +10 Guarda → R4 pequeno stun → R5 Perfect Block emite onda de choque.

### S3 — Desafio
Bate a lâmina no escudo. Inimigos próximos são provocados por 4s, causando **-15% dano a aliados** e focando Bastião. Cada inimigo provocado gera **+3 Guarda**. (CD: 15s).
* **Ranks:** R1 básico → R2 área maior → R3 duração +1s → R4 inimigos provocados recebem Desequilíbrio → R5 abates reduzem cooldown.

### S4 — Fortaleza
Escudo fincado ao solo por 5s: **+40% redução de dano**, **+100% resistência a knockback** e **+50% geração de Guarda**, perdendo mobilidade. (CD: 20s).
* **Ranks:** R1 básico → R2 +1s duração → R3 regeneração leve → R4 aliados próximos ganham resistência → R5 inabalável (imune a interrupções).

### S5 — Impacto de Escudo
Investida linear que empurra inimigos. O primeiro alvo a colidir em obstáculos ou outros inimigos sofre dano extra e atordoamento. Causa **140% Weapon Damage**. Custo: 20 Guarda. (CD: 10s).
* **Ranks:** R1 básico → R2 maior alcance → R3 maior knockback → R4 colisões aplicam Desequilíbrio → R5 alvos desequilibrados geram explosão de impacto.

### Signature — Último Bastião
Custo: **100 Guarda**. Duração: **8s**.
Bastião ergue o escudo em postura sagrada: não pode cair abaixo de 1 HP, redireciona dano de aliados para si, todo bloqueio conta como Perfect Block, Contra-Golpe resfria 2x mais rápido e torna-se imune a empurrões. Ao encerrar, descarrega uma onda de choque de Lúmen proporcional a todo o dano absorvido.
* **Ranks:** R1 padrão → R2 duração sobe para 10s → R3 restaura a vida dos aliados proporcional ao dano absorvido.

---

## 10. Passiva de Identidade — Inabalável

A cada Perfect Block, Bastião recebe geração acelerada de Guarda, aplica Desequilíbrio e ganha bônus cumulativo temporário de mitigação de dano (com teto máximo balanceado).

---

## 11. As 3 Branches de Passivas (16 Passivas no Total)

### Build A — Guardião (Foco em Proteção de Grupo)
* **A1 — Ombro a Ombro:** Aliados adjacentes recebem bônus de resistência passiva.
* **A2 — Escudo Compartilhado:** Fração do dano sofrido pela retaguarda é absorvida por Bastião.
* **A3 — Presença Protetora:** Muralha Viva confere resistência a efeitos de atordoamento/lentidão.
* **A4 — Ninguém Fica Para Trás:** Se um aliado atinge menos de 30% HP, Bastião ganha arranque e velocidade.
* **A5 — CAPSTONE: Guarda Eterna:** Se um aliado sofrer dano letal dentro do alcance de proteção, sobrevive com 1 HP (cooldown interno alto).

### Build B — Retaliação (Foco em Defesa Ofensiva)
* **B1 — Peso do Escudo:** Perfect Blocks refletem dano imediato ao atacante.
* **B2 — Momento:** Contra-Golpe desfere dano crítico amplificado contra alvos Desequilibrados.
* **B3 — Pressão Acumulada:** Cada bloqueio absorvido empilha bônus para o próximo golpe retaliador.
* **B4 — Quebre-se Contra Mim:** Inimigos de elite e chefes sofrem dano de postura severo ao golpear a guarda.
* **B5 — CAPSTONE: Julgamento de Ferro:** A cada 3 Perfect Blocks, o próximo Contra-Golpe dispara uma onda de choque de longo alcance.

### Build C — Controle (Foco em Posicionamento e Interrupção)
* **C1 — Voz de Comando:** Raio de alcance do Desafio ampliado.
* **C2 — Sem Passagem:** Inimigos que tentarem flanquear ou ultrapassar Bastião sofrem lentidão extrema.
* **C3 — Choque de Linha:** Impacto de Escudo perfura e colide com múltiplos inimigos em fila.
* **C4 — Formação Quebrada:** Inimigos em Desequilíbrio sofrem o dobro de distância de empurrão.
* **C5 — CAPSTONE: Linha Inquebrável:** Impacto de Escudo marca uma fenda de Lúmen no solo; inimigos que a cruzarem são interrompidos e desequilibrados.

---

## 12. Traits de Especialização (Escolha de 1 Ativo)

1. **Guardião — Voto do Escudo:** Mitigação bônus sempre que defender um aliado (*Favorece: Muralha Viva + Fortaleza*).
2. **Retaliação — Ferro Responde:** Perfect Blocks reduzem diretamente a recarga do Contra-Golpe (*Favorece: Contra-Golpe*).
3. **Controle — Não Passarão:** Inimigos Desequilibrados sofrem lentidão na proximidade de Bastião (*Favorece: Desafio + Impacto de Escudo*).

---

## 13. Builds Recomendadas

* **Tank Puro:** Muralha Viva + Fortaleza (`Voto do Escudo`). Máxima longevidade e mitigação de equipe.
* **Counter Tank:** Contra-Golpe + Fortaleza (`Ferro Responde`). Recompensa alta por precisão de bloqueio.
* **Control Tank:** Desafio + Impacto de Escudo (`Não Passarão`). Agrupamento e gestão de multidões.
* **Tank Agressivo:** Contra-Golpe + Impacto de Escudo. Troca proteção de retaguarda por pressão ofensiva contínua.

---

## 14. Fraquezas Declaradas

* **Mobilidade Baixa:** Vulnerável a inimigos com teleporte ou kiting de longa distância.
* **Flanqueamento:** O arco defensivo frontal não mitiga ataques pelas costas.
* **Dano Contínuo (DoTs):** Sangramento, veneno e queima ignoram janelas de Perfect Block.
* **Inimigos Espalhados:** O controle de terreno perde eficácia em arenas muito amplas.
* **Vazio de Guarda:** Sem acúmulo de Guarda, as opções ativas de resposta caem expressivamente.

---

## 15. Equipamentos Exclusivos Iniciais

* **Escudo — Muralha do Primeiro Juramento (Lendário):** Concede +50% de geração de Guarda em Perfect Blocks.
* **Espada — Vigília (Lendário):** Contra-Golpe causa +40% de dano contra inimigos Desequilibrados.
* **Echo — A Sentinela que Ficou (Eco Único):** Muralha Viva estende proteção ao aliado mais fragilizado mesmo fora do raio estrito. *(Lore: "Todos fugiram. Um ficou.")*

---

## 16. Recursos Técnicos e Arte

* **Cena Godot:** [`scenes/heroes/Bastiao.tscn`](../../scenes/heroes/Bastiao.tscn)
* **Script de Combate:** [`scenes/heroes/Bastiao.gd`](../../scenes/heroes/Bastiao.gd)
* **Spritesheet:** [`assets/sprites/heroes/bastiao/hero_bastiao_sheet.png`](../../assets/sprites/heroes/bastiao/hero_bastiao_sheet.png) (16 frames 48×48)
* **Contrato de Arte:** [`docs/art/contracts/hero_bastiao.yaml`](../art/contracts/hero_bastiao.yaml)

---

## 17. Checklist de Conclusão (Definition of Done)

| Requisito | Estado |
| --- | :---: |
| Identidade e Fantasia | ✅ Concluído |
| Mecânica Central (Guarda) | ✅ Concluído |
| Fraquezas Declaradas | ✅ Concluído |
| Ataque Básico (Marcha de Ferro) | ✅ Concluído |
| 6 Habilidades com Ranks | ✅ Concluído |
| Signature Skill (Último Bastião) | ✅ Concluído |
| 16 Passivas (Identidade + 3 Capstones) | ✅ Concluído |
| 3 Traits de Especialização | ✅ Concluído |
| 3 Builds Definidas | ✅ Concluído |
| Sinergias Preliminares | 🟡 Preliminar |
| 3 Equipamentos Exclusivos | 🟡 Rascunho inicial |
| Progressão Mastery 1–10 | ❌ Pendente |
| 5 Capítulos de Lore Pessoal | ❌ Pendente |
| 4 Estágios Visuais Evolutivos | ❌ Pendente |
| Balanceamento Numérico Final | ❌ Pendente |

**Classificação Oficial:** `HERO_DESIGN_WIP`
