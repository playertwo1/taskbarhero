# BASTIAO_HERO.md

**Status:** HERO_DESIGN_WIP  
**Version:** 0.1  
**Role:** Tank / Protector  
**Difficulty:** 2/5  
**Resource:** Guarda  
**Primary fantasy:** transformar ataques inimigos em proteção e contra-ataques.  
**Padrão Canônico:** em conformidade com [`HERO_STANDARD.md`](../../HERO_STANDARD.md)

---

### 1. Identidade

**Nome:** Bastião

**Arquétipo:** Tank defensivo focado em:
- absorver pressão;
- proteger aliados;
- controlar inimigos;
- bloquear ataques importantes;
- converter defesa em dano;
- sobreviver quando todos os outros cairiam.

**Fantasia:** «"Eu fico."»  
Bastião não luta porque acredita que é invencível. Ele luta porque alguém precisa permanecer de pé.

---

### 2. Filosofia de gameplay

Bastião não deve ser:
«personagem com 300% mais HP que simplesmente apanha.»

Ele deve recompensar decisões.

O jogador precisa observar:  
quem está sendo atacado → de onde vem o perigo → quando bloquear → quando gastar Guarda.

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

### 3. Mecânica exclusiva — GUARDA

Bastião possui um recurso chamado: **GUARDA**  
Valor inicial: `0 / 100`

Guarda representa sua capacidade de manter posição sob pressão.

#### Geração

| Evento | Guarda |
| --- | --- |
| receber ataque | +2 |
| bloquear ataque | +5 |
| Perfect Block | +12 |
| aliado protegido receber ataque | +4 |
| provocar inimigo | +3 |
| Contra-Golpe acertar | +5 |

#### Limite

Máximo: **100 Guarda**

Guarda não desaparece imediatamente fora de combate. Após alguns segundos sem combate começa a decair lentamente.

---

### 4. Perfect Block

Existe uma pequena janela ao levantar a defesa. Se um ataque atingir Bastião durante essa janela: **PERFECT BLOCK**

Efeito básico:
- dano recebido drasticamente reduzido;
- gera Guarda adicional;
- aplica Desequilíbrio ao atacante;
- ativa interações de skills e passivas.

Isso cria diferença entre Bastião iniciante e Bastião dominado.

---

### 5. Status exclusivo — Desequilíbrio

Algumas ações de Bastião aplicam: **Desequilíbrio**

Inimigos Desequilibrados:

| Efeito | Valor inicial |
| --- | --- |
| dano causado | -10% |
| resistência a stagger | -20% |
| duração | 4s |

Algumas builds poderão explorar esse estado agressivamente.

---

### 6. Ataque básico — MARCHA DE FERRO

Combo de espada e escudo:

```
Golpe 1: Espada horizontal
   ↓
Golpe 2: Golpe de escudo
   ↓
Golpe 3: Corte pesado
```

O terceiro golpe gera: **+4 Guarda**  
Se atingir inimigo Desequilibrado: **+6 Guarda**

---

### 7. Defesa básica

Segurar defesa: **Erguer Escudo**

- Redução inicial de dano frontal: **70%**
- Movimento: **-35% velocidade**

Bastião pode continuar avançando lentamente enquanto bloqueia. O escudo possui um pequeno arco frontal de proteção.

---

### 8. Skills

Bastião possui seis habilidades:

| Slot | Skill | Função |
| --- | --- | --- |
| S1 | Muralha Viva | proteção |
| S2 | Contra-Golpe | retaliação |
| S3 | Desafio | controle |
| S4 | Fortaleza | defesa |
| S5 | Impacto de Escudo | controle/dano |
| Signature | Último Bastião | emergência |

---

### 9. SKILL 1 — MURALHA VIVA

Bastião cria uma zona de proteção atrás de si.

Aliados posicionados atrás do escudo recebem: **-40% dano à distância.**  
Parte do dano mitigado gera Guarda.

- Duração inicial: **6 segundos**
- Cooldown: **14 segundos**

#### Ranks

| Rank | Efeito |
| --- | --- |
| 1 | proteção básica |
| 2 | +1s duração |
| 3 | aliados recebem +10% resistência |
| 4 | área maior |
| 5 | Perfect Blocks prolongam a duração |

**Identidade:** Essa skill define Bastião como protetor. O posicionamento do personagem importa.

---

### 10. SKILL 2 — CONTRA-GOLPE

Bastião assume postura defensiva. Se for atingido dentro da janela:

```
BLOCK → ESCUDO → CONTRA-ATAQUE
```

- Dano: **180% Weapon Damage**
- Aplica: **Desequilíbrio**
- Perfect Block: **250% Weapon Damage**
- Cooldown: **8 segundos**

#### Ranks

| Rank | Efeito |
| --- | --- |
| 1 | counter básico |
| 2 | +20% dano |
| 3 | gera +10 Guarda |
| 4 | pequeno stun |
| 5 | Perfect Block cria onda de choque |

---

### 11. SKILL 3 — DESAFIO

Bastião bate sua arma contra o escudo.

Inimigos próximos são **Provocados** por **4 segundos**.

Enquanto estiverem provocados causam:
- **-15% dano a aliados** e priorizam Bastião.
- Cada inimigo provocado gera **+3 Guarda**.
- Cooldown: **15 segundos**

#### Ranks

| Rank | Efeito |
| --- | --- |
| 1 | taunt |
| 2 | área maior |
| 3 | duração +1s |
| 4 | inimigos provocados recebem Desequilíbrio |
| 5 | matar inimigo provocado reduz cooldown |

---

### 12. SKILL 4 — FORTALEZA

Bastião ancora o escudo no chão.

Durante **5 segundos**, recebe:

| Status | Bônus |
| --- | --- |
| redução de dano | +40% |
| resistência a knockback | +100% |
| geração de Guarda | +50% |

Bastião perde mobilidade significativa.  
Cooldown: **20 segundos**

#### Ranks

| Rank | Efeito |
| --- | --- |
| 1 | defesa básica |
| 2 | +1s duração |
| 3 | regeneração leve |
| 4 | aliados próximos recebem resistência |
| 5 | não pode ser interrompido |

---

### 13. SKILL 5 — IMPACTO DE ESCUDO

Bastião avança violentamente:

`BASTIÃO ██████►`

Inimigos atingidos são empurrados.

O primeiro inimigo que colidir contra:
- parede;
- objeto;
- outro inimigo;

recebe dano adicional e stun.

- Dano inicial: **140% Weapon Damage**
- Custo: **20 Guarda**
- Cooldown: **10 segundos**

#### Ranks

| Rank | Efeito |
| --- | --- |
| 1 | investida |
| 2 | maior distância |
| 3 | maior knockback |
| 4 | colisões aplicam Desequilíbrio |
| 5 | inimigos Desequilibrados causam explosão de impacto |

---

### 14. SIGNATURE — ÚLTIMO BASTIÃO

**Custo:** 100 GUARDA

Bastião ergue o escudo e declara posição.

Duração: **8 segundos**

Durante o efeito:
- não pode cair abaixo de 1 HP;
- aliados próximos recebem redução de dano;
- ataques contra aliados parcialmente redirecionam dano para Bastião;
- todos os bloqueios contam como Perfect Blocks;
- Contra-Golpe recebe cooldown acelerado;
- Bastião não pode ser empurrado.

Ao terminar: uma onda de choque causa dano proporcional ao dano absorvido.

**Conceito visual:** O chão ao redor do personagem começa a apresentar linhas luminosas de Lúmen formando uma muralha circular. Bastião permanece no centro.

- **Rank 1:** Efeito padrão.
- **Rank 2:** Duração: `8 → 10 segundos`
- **Rank 3:** Ao terminar, restaura parte da vida dos aliados proporcional ao dano absorvido.

---

### 15. Passiva de identidade — INABALÁVEL

Sempre que Bastião realiza um Perfect Block:  
`+Guarda` + `Desequilíbrio` + `redução temporária de dano`

Perfect Blocks consecutivos aumentam brevemente sua eficiência defensiva. Esse bônus possui limite.

---

### 16. BUILD A — GUARDIÃO

**Objetivo:** proteger o grupo.

- **A1 — Ombro a Ombro:** Aliados próximos recebem resistência adicional.
- **A2 — Escudo Compartilhado:** Parte do dano recebido por aliados próximos é transferida para Bastião.
- **A3 — Presença Protetora:** Muralha Viva aumenta resistência a controle.
- **A4 — Ninguém Fica Para Trás:** Quando um aliado fica abaixo de 30% HP, Bastião ganha velocidade em direção a ele.
- **A5 — CAPSTONE: GUARDA ETERNA:** Quando Bastião protege um aliado de dano fatal, o aliado permanece com 1 HP. Cooldown interno elevado.

---

### 17. BUILD B — RETALIAÇÃO

**Objetivo:** transformar defesa em dano.

- **B1 — Peso do Escudo:** Perfect Blocks causam pequeno dano ao atacante.
- **B2 — Momento:** Contra-Golpe causa mais dano contra inimigos Desequilibrados.
- **B3 — Pressão Acumulada:** Cada ataque bloqueado aumenta temporariamente o próximo Contra-Golpe.
- **B4 — Quebre-se Contra Mim:** Chefes e elites recebem aumento de stagger ao atacar Bastião.
- **B5 — CAPSTONE: JULGAMENTO DE FERRO:** Após três Perfect Blocks, o próximo Contra-Golpe cria uma enorme onda de choque.

---

### 18. BUILD C — CONTROLE

**Objetivo:** controlar posicionamento inimigo.

- **C1 — Voz de Comando:** Desafio possui área maior.
- **C2 — Sem Passagem:** Inimigos tentando atravessar Bastião ficam mais lentos.
- **C3 — Choque de Linha:** Impacto de Escudo pode atingir múltiplos inimigos.
- **C4 — Formação Quebrada:** Inimigos Desequilibrados recebem maior knockback.
- **C5 — CAPSTONE: LINHA INQUEBRÁVEL:** Impacto de Escudo deixa temporariamente uma linha de Lúmen no chão. Inimigos que atravessarem a linha são interrompidos e recebem Desequilíbrio.

---

### 19. Traits

Bastião possui três Traits (apenas um pode estar ativo):

- **GUARDIÃO — VOTO DO ESCUDO:** Quando Bastião protege outro personagem, ganha temporariamente redução de dano. *(Favorece: Muralha Viva + Fortaleza)*
- **RETALIAÇÃO — FERRO RESPONDE:** Perfect Blocks reduzem o cooldown de Contra-Golpe. *(Favorece: Contra-Golpe)*
- **CONTROLE — NÃO PASSARÃO:** Inimigos Desequilibrados movem-se mais lentamente quando próximos de Bastião. *(Favorece: Desafio + Impacto de Escudo)*

---

### 20. Builds esperadas

- **Tank puro:** Muralha Viva + Fortaleza | Trait: Voto do Escudo. Excelente proteção, dano menor.
- **Counter Tank:** Contra-Golpe + Fortaleza | Trait: Ferro Responde. Alta recompensa por timing, mais difícil de jogar.
- **Control Tank:** Desafio + Impacto de Escudo | Trait: Não Passarão. Manipula grupos inteiros de inimigos.
- **Tank agressivo:** Contra-Golpe + Impacto de Escudo. Menos proteção para aliados, muito mais pressão ofensiva.

---

### 21. Fraquezas

| Fraqueza | Consequência |
| --- | --- |
| mobilidade baixa | dificuldade contra inimigos móveis |
| ataques traseiros | escudo pouco eficiente |
| dano contínuo | difícil realizar Perfect Block |
| inimigos espalhados | controle menos eficiente |
| pouca Guarda | capacidades ofensivas reduzidas |
| isolamento | parte das passivas perde valor |

Isso impede que Bastião seja sempre a melhor escolha.

---

### 22. Sinergias preliminares

- **+ Orvalho:** Bastião mantém inimigos ocupados; Orvalho cria zonas persistentes. Excelente combinação para batalhas longas.
- **+ Flecha:** Desafio mantém inimigos agrupados; Flecha consegue atacar com segurança.
- **+ Íris:** Bastião agrupa; Íris controla áreas.
- **+ Brasa:** Bastião absorve pressão enquanto Brasa permanece em HP baixo. Combinação poderosa, mas perigosa.
- **+ Véu:** Bastião força inimigos a olhar para ele; Véu consegue atacar pontos vulneráveis.
- **+ Forja:** Bastião mantém inimigos dentro das áreas das engenhocas.
- **+ Sino:** Buffs defensivos e manipulação de ritmo tornam Bastião extremamente estável.

---

### 23. Equipamentos exclusivos iniciais

- **ESCUDO — MURALHA DO PRIMEIRO JURAMENTO** (Legendary)  
  *Efeito:* Perfect Blocks geram Guarda adicional.
- **ESPADA — VIGÍLIA** (Legendary)  
  *Efeito:* Contra-Golpe causa dano aumentado contra inimigos Desequilibrados.
- **ECHO — A SENTINELA QUE FICOU** (Unique Echo)  
  *Efeito:* Muralha Viva protege também o aliado com menor HP mesmo que ele esteja ligeiramente fora da área.  
  *Lore:* «Todos fugiram. Um ficou.»

---

### 24. Curva de aprendizado

- **Iniciante:** Aprende a bloquear + provocar.
- **Intermediário:** Aprende Guarda + posição + proteção.
- **Avançado:** Aprende Perfect Block + controle.
- **Master:** Aprende a transformar ataques inimigos em recursos e controlar o ritmo inteiro da batalha.

---

### 25. Regra fundamental do personagem

Quando o jogador domina Bastião, deve sentir:  
«"Quanto mais pressão colocam em mim, mais perigoso eu fico."»

Mas nunca:  
«"Posso simplesmente ficar parado e ser invencível."»

Esse equilíbrio define o personagem.

---

### 26. Estado atual

| Sistema | Estado |
| --- | :---: |
| identidade | ✅ |
| mecânica central | ✅ |
| fraqueza | ✅ |
| ataque básico | ✅ |
| 6 skills | ✅ |
| Signature | ✅ |
| 16 passivas | ✅ |
| 3 Traits | ✅ |
| 3 builds | ✅ |
| sinergias | 🟡 preliminar |
| equipamentos exclusivos | 🟡 3 iniciais |
| Mastery 1–10 | ❌ |
| Lore 5 capítulos | ❌ |
| evolução visual | ❌ |
| números finais | ❌ |
| balanceamento | ❌ |

**Status formal:** `HERO_DESIGN_WIP`
