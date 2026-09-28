# HERO_STANDARD.md

## Padrão Canônico dos Heróis

**Status:** CANONICAL  
**Aplica-se a:** todos os heróis jogáveis  
**Roster inicial:** 8 heróis  
**Objetivo:** impedir inconsistências entre personagens e garantir profundidade suficiente de progressão.

---

### 1. Regra principal

Todo herói jogável deve possuir exatamente:

| Sistema | Quantidade |
| --- | --- |
| Ataque básico | 1 |
| Skills ativas | 6 |
| Passivas | 16 |
| Builds principais | 3 |
| Traits de especialização | 3 |
| Tiers da árvore | 8 |
| Slots de skill em combate | 2 |
| Slots de equipamento | 10 |
| Níveis normais | 100 |
| Níveis de Maestria | 10 |
| Missões pessoais | 5 |
| Estágios visuais | 4 |
| Mecânica exclusiva | 1 |
| Fraqueza clara | 1 |
| Signature Skill | 1 |

Nenhum herói deve ser considerado completo sem esses elementos.

---

### 2. Anatomia de um herói

```
HERÓI
│
├── Identidade
│   ├── Fantasia
│   ├── Papel
│   ├── Mecânica exclusiva
│   ├── Fraqueza
│   └── Lore
│
├── Combate
│   ├── Ataque básico
│   ├── Skill 1
│   ├── Skill 2
│   ├── Skill 3
│   ├── Skill 4
│   ├── Skill 5
│   └── Signature Skill
│
├── Skill Tree
│   ├── Passiva de Identidade
│   ├── Build A — 5 passivas
│   ├── Build B — 5 passivas
│   └── Build C — 5 passivas
│
├── Especialização
│   ├── Trait A
│   ├── Trait B
│   └── Trait C
│
├── Progressão
│   ├── Level 1–100
│   └── Mastery 1–10
│
├── Equipamento
│   └── 10 slots
│
├── Lore
│   └── 5 capítulos
│
└── Aparência
    └── 4 estágios
```

---

### 3. Skills

Cada herói possui:

1 ataque básico + 5 skills normais + 1 Signature Skill.

Total:

**7 ações próprias por personagem.**

Com 8 personagens:

8 ataques básicos + 48 skills = **56 ações únicas.**

#### Skills normais

Cada skill normal possui até 5 ranks.

Uma skill não deve simplesmente ganhar mais dano.

Sempre que possível, os ranks mais altos também devem alterar alguma propriedade:

- alcance;
- área;
- duração;
- número de alvos;
- interação com a mecânica do herói;
- status aplicado;
- geração de recurso.

#### Signature Skill

É a habilidade que representa o personagem.

Possui 3 ranks.

Deve:

- ser visualmente reconhecível;
- explorar a mecânica exclusiva do herói;
- provocar mudança perceptível no combate;
- ser importante para pelo menos uma build;
- nunca ser apenas "300% de dano".

---

### 4. Slots de habilidade

O personagem pode possuir 6 skills, mas somente:

**2 skills ativas equipadas simultaneamente.**

Isso obriga a criação de builds.

```
6 skills disponíveis
        ↓
Escolher 2
        ↓
Equipamentos
        ↓
Passivas
        ↓
Trait
        ↓
BUILD
```

O primeiro slot existe desde o início.

O segundo slot é desbloqueado através da progressão global do Hub, valendo para todos os heróis.

---

### 5. Passivas

Cada herói possui exatamente 16 nós passivos.

Estrutura:

1 Passiva de Identidade

```
BUILD A
├── A1
├── A2
├── A3
├── A4
└── A5 — Capstone

BUILD B
├── B1
├── B2
├── B3
├── B4
└── B5 — Capstone

BUILD C
├── C1
├── C2
├── C3
├── C4
└── C5 — Capstone
```

Total:

`1 + 5 + 5 + 5 = 16`.

Cada passiva pode possuir até 5 ranks.

O último nó de cada branch é um Capstone e precisa mudar significativamente a forma como aquela build funciona.

---

### 6. Traits

Cada herói possui exatamente 3 Traits.

Existe um Trait associado a cada build.

Exemplo:

**BASTIÃO**
- Guardião
- Retaliação
- Controle

O jogador escolhe 1 Trait ativo por vez.

Traits não devem ser simplesmente:
«+10% de dano.»

Devem modificar alguma regra.

Exemplo:
«Bloqueios perfeitos agora provocam Contra-Golpe automaticamente.»

Isso altera gameplay.

---

### 7. Árvore de progressão

Existem 8 Tiers.

| Tier | Requisito | Conteúdo principal |
| --- | --- | --- |
| T0 | Lv.1 | identidade + primeiras skills |
| T1 | Lv.10 | início das três builds |
| T2 | Lv.20 | skill adicional + passivas |
| T3 | Lv.30 | Traits + nova skill |
| T4 | Lv.40 | skill avançada |
| T5 | Lv.50 | passivas avançadas |
| T6 | Lv.60 | Signature Skill |
| T7 | Lv.70 | Capstones |

O Tier 70 encerra a abertura estrutural da árvore.

Do nível 70 ao 100 o jogador passa a aperfeiçoar a build que criou.

---

### 8. Skill Points

O herói recebe pontos de árvore durante a progressão.

O orçamento final deve ser inferior ao custo necessário para maximizar tudo.

Regra:

«Um personagem jamais deve conseguir maximizar completamente as três builds simultaneamente.»

A árvore completa possui aproximadamente 108 pontos possíveis de investimento.

O personagem recebe no máximo aproximadamente 75 Skill Points durante sua progressão normal.

Resultado:

Não existe build perfeita. Existe escolha.

Respec deve existir através do Hub para incentivar experimentação.

---

### 9. Equipamentos

Cada herói possui 10 slots.

| Slot | Função |
| --- | --- |
| Weapon | principal fonte ofensiva |
| Secondary | escudo, foco, ferramenta etc. |
| Head | defesa/utilidade |
| Chest | defesa principal |
| Gloves | ataque/velocidade |
| Boots | velocidade/esquiva |
| Amulet | efeitos especiais |
| Ring | especialização |
| Relic | modificadores raros |
| Echo | efeitos ligados à lore |

#### Echo

O slot Echo será exclusivo do nosso universo.

Ecos são fragmentos de memória preservados através do Lúmen.

Um Echo poderá modificar:

- skills;
- mecânica do herói;
- interação com aliados;
- Signature Skill;
- comportamento de summons;
- recursos especiais.

Exemplo:

*Eco da Sentinela Perdida:*  
Muralha Viva passa a proteger também o aliado com menor HP.

Isso conecta diretamente:  
**LOOT + BUILD + LORE.**

---

### 10. Level

Level máximo: **100**

A progressão é dividida em quatro etapas:

- **Lv.1–30 — Descoberta:** O jogador aprende a mecânica do personagem.
- **Lv.31–60 — Especialização:** A build começa a tomar forma.
- **Lv.61–70 — Consolidação:** Signature Skill e Capstones aparecem.
- **Lv.71–100 — Aperfeiçoamento:** O jogador otimiza equipamentos, ranks e sinergias.

---

### 11. Maestria

Depois do nível 100 começa:

**Mastery 1–10**

Maestria representa domínio daquele personagem.

Não deve existir progressão infinita.

Marcos principais:

| Mastery | Recompensa |
| --- | --- |
| M1 | bônus pequeno da mecânica central |
| M3 | modificador de skill |
| M5 | evolução visual |
| M7 | modificador avançado |
| M10 | Signature Modifier + aparência final |

O M10 representa um personagem verdadeiramente dominado.

---

### 12. Evolução visual

Cada herói possui 4 versões visuais.

- **Forma I — Base:** Personagem original.
- **Forma II — Desperto:** Desbloqueada durante a campanha pessoal. Mudanças pequenas: detalhes, partículas, arma, acessórios.
- **Forma III — Ressonante:** Lúmen começa a se manifestar visualmente.
- **Forma IV — Lendária:** Mastery 10. É a versão visual definitiva daquele personagem.

A silhueta base deve continuar reconhecível em todas as formas.

---

### 13. Lore pessoal

Todo herói recebe 5 missões próprias.

- **CAPÍTULO I:** Quem ele era.
- **CAPÍTULO II:** O que perdeu.
- **CAPÍTULO III:** Sua relação com o Apagamento.
- **CAPÍTULO IV:** Sua memória/Eco mais importante.
- **CAPÍTULO V:** Resolução pessoal.

Essas missões podem liberar:
- skins;
- Ecos;
- diálogos;
- itens;
- entradas no Codex;
- pequenas alterações no Hub.

Gameplay importante nunca deve exigir pagamento.

---

### 14. Os oito heróis

#### BASTIÃO
- **Role:** Tank
- **Mecânica:** Escudo / Proteção
- **Builds:** Guardião / Retaliação / Controle
- **Skills existentes:**
  1. Muralha Viva
  2. Contra-Golpe
  3. Desafio
  4. Fortaleza
  5. Impacto de Escudo ← nova
  6. Último Bastião — Signature
- **Fantasia:** «"Eu fico."»  
  Bastião deve ser o personagem que transforma receber ataques em vantagem para o grupo.

---

#### FLECHA
- **Role:** Ranged DPS
- **Mecânica:** Marca / Crítico
- **Builds:** Crítico / Marca / Velocidade
- **Skills:**
  1. Marca do Caçador
  2. Flecha Perfurante
  3. Olho Aguçado
  4. Rajada
  5. Ricochete ← nova
  6. Chuva de Flechas — Signature
- **Fantasia:** «Encontrar o ponto fraco antes que o inimigo perceba que está sendo caçado.»

---

#### ÍRIS
- **Role:** Mage / Control
- **Mecânica:** Lúmen / Controle
- **Builds:** Arcano / Controle / Lúmen
- **Skills:**
  1. Pulso Prismático
  2. Prisão de Lúmen
  3. Refração
  4. Véu Astral
  5. Eco Prismático ← nova
  6. Colapso Prismático — Signature
- **Fantasia:** Íris deve ser a personagem que mais diretamente percebe o Lúmen, Ecos e memórias.

---

#### BRASA
- **Role:** Bruiser / Berserker
- **Mecânica:** Fúria / HP baixo
- **Builds:** Fúria / Queimadura / Sobrevivência
- **Skills:**
  1. Sangue Quente
  2. Golpe Incandescente
  3. Fúria Crescente
  4. Devorar Chamas
  5. Investida de Cinzas ← nova
  6. Última Centelha — Signature
- **Fantasia:** Quanto mais próximo da derrota, mais perigoso Brasa se torna.

---

#### VÉU
- **Role:** Assassin
- **Mecânica:** Exposição / Execução
- **Builds:** Execução / Veneno / Sombra
- **Skills:**
  1. Passo Entre Mundos
  2. Corte Silencioso
  3. Veneno Negro
  4. Marca da Morte
  5. Fenda Sombria ← nova
  6. Fim Inevitável — Signature
- **Fantasia:** Véu deve ser excelente contra inimigos prioritários, mas vulnerável quando pressionada.

---

#### ORVALHO
- **Role:** Healer / Support
- **Mecânica:** Sementes
- **Builds:** Cura / Jardim / Simbiose
- **Skills:**
  1. Semente Vital
  2. Espinhos Vivos
  3. Raízes Protetoras
  4. Simbiose
  5. Florescer ← nova
  6. Última Primavera — Signature
- **Fantasia:** Orvalho deve transformar batalhas longas em vantagem.

---

#### FORJA
- **Role:** Engineer / Summoner
- **Mecânica:** Engenhocas
- **Builds:** Torres / Armadilhas / Autômatos
- **Skills:**
  1. Sentinela
  2. Mina de Lúmen
  3. Farol
  4. Drone Catador
  5. Sobrecarga ← nova
  6. Projeto Impossível — Signature
- **Fantasia:** Forja não precisa ser a maior causadora direta de dano. Sua força está em construir um pequeno sistema dentro da batalha.

---

#### SINO
- **Role:** Buffer / Tempo
- **Mecânica:** Ritmo / Memória
- **Builds:** Ritmo / Ressonância / Memória
- **Skills:**
  1. Primeira Nota
  2. Ressonância
  3. Compasso
  4. Memória Persistente
  5. Crescendo ← nova
  6. Encore — Signature
- **Fantasia:** Sino recompensa sequências, timing e composição de equipe.

---

### 15. Matriz do roster

| Herói | Papel | Mecânica | Build A | Build B | Build C |
| --- | --- | --- | --- | --- | --- |
| **Bastião** | Tank | Escudo | Guardião | Retaliação | Controle |
| **Flecha** | DPS | Marca | Crítico | Marca | Velocidade |
| **Íris** | Mage | Lúmen | Arcano | Controle | Lúmen |
| **Brasa** | Bruiser | Fúria | Fúria | Queimadura | Sobrevivência |
| **Véu** | Assassin | Exposição | Execução | Veneno | Sombra |
| **Orvalho** | Healer | Sementes | Cura | Jardim | Simbiose |
| **Forja** | Summoner | Engenhocas | Torres | Armadilhas | Autômatos |
| **Sino** | Buffer | Ritmo | Ritmo | Ressonância | Memória |

O objetivo é que nenhum dos oito concorra exatamente pelo mesmo espaço.

---

### 16. Conteúdo total do roster

Com oito heróis teremos:
- 8 ataques básicos
- 48 skills ativas
- 128 passivas
- 24 Traits
- 24 builds principais
- 80 slots de equipamento
- 40 missões pessoais
- 32 formas visuais
- 80 níveis de Maestria

Somente o sistema de heróis já produz **176 elementos de build**, considerando apenas:
`48 skills + 128 passivas`.  
Sem contar equipamentos, Ecos, Traits e sinergias.

---

### 17. Estrutura no repositório

Cada personagem deverá possuir sua própria pasta.

```
game/ (ou docs/02_heroes/)
└── heroes/
    ├── bastiao/
    ├── flecha/
    ├── iris/
    ├── brasa/
    ├── veu/
    ├── orvalho/
    ├── forja/
    └── sino/
```

Dentro de cada pasta:

```
[heroi]/
├── HERO.md
├── SKILLS.md
├── PASSIVES.md
├── TRAITS.md
├── MASTERY.md
├── LORE.md
├── ITEMS.md
├── SYNERGIES.md
└── art/
```

`HERO.md` é a fonte principal de verdade.  
Os outros documentos detalham os sistemas.

---

### 18. Definition of Done

Um herói somente pode receber o status:  
`HERO_DESIGN_COMPLETE`

quando possuir:
- identidade;
- role;
- mecânica central;
- fraqueza;
- ataque básico;
- 6 skills;
- Signature Skill;
- 16 passivas;
- 3 Traits;
- 3 builds;
- árvore T0–T7;
- 10 slots compatíveis;
- pelo menos 3 itens exclusivos;
- 5 capítulos de lore;
- 4 estágios visuais;
- sinergias com outros personagens;
- sprites definidos pelo padrão oficial de arte;
- números iniciais de balanceamento.

Enquanto qualquer item estiver ausente:  
`HERO_DESIGN_WIP`

---

### 19. Regra de ouro

Quantidade sozinha não cria profundidade.

Cada personagem deve responder claramente a três perguntas:

1. **Por que eu escolheria esse herói?**
2. **Que decisões diferentes posso tomar ao montá-lo?**
3. **Por que eu voltaria a jogar com ele depois de 20 horas?**

Se essas respostas não forem claras, o personagem ainda não está pronto.
