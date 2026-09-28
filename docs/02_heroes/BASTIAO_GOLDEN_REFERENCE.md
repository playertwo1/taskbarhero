---
status: DESIGN
source: "[3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx](../../documents/3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx)"
---

# Bastião Golden Reference

> **Fonte e escopo:** Esta ficha é o modelo de profundidade e organização para os próximos heróis; reutilize a estrutura, não copie a mecânica ou os números exclusivos do Bastião. “Golden Reference” aqui significa referência de design, não aprovação de sprite Golden. O padrão HERO_STANDARD e as decisões recentes de Rafael prevalecem. Valores e sistemas adicionais permanecem em DESIGN/HIPÓTESE até revisão, balanceamento e aceite.
> **Documento original:** [3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx](../../documents/3-Taskbar_Hero_Bastiao_Golden_Reference_v0.1.docx). A conversão preserva texto e tabelas; elementos visuais do Word, se houver, continuam disponíveis apenas no DOCX.

## Regras de precedência no Pocket Hero

- [`HERO_STANDARD.md`](../../HERO_STANDARD.md) continua sendo a fonte única para a anatomia e os requisitos compartilhados dos oito heróis. A parte repetida sobre o padrão canônico abaixo é preservada para consulta da fonte, não cria uma segunda autoridade.
- A ficha de Bastião serve como exemplo de profundidade, não como autorização para copiar kit, passivas, Traits, Maestria, lore ou valores para os demais heróis.
- As decisões atuais do [Sistema de skills](../03_systems/SKILL_SYSTEM.md) prevalecem. A fonte descreve observação/timing de Perfect Block; como o combate do Pocket Hero é automático, qualquer uso precisa ser adaptado a regras automáticas e não pode exigir comando durante a luta.
- A lista de skills de outros heróis na parte de padrão geral é apenas proposta da fonte. O [catálogo do Capítulo 1](../04_content/chapters/chapter_01/OVERVIEW.md) e decisões recentes de Rafael não são substituídos por esses nomes.
- Números de Guarda, dano, cooldown, duração, ranks, custos, Maestria e progressão visual são propostas. Não copiar para `/data/` nem tratar seções rotuladas `DESIGN_COMPLETE` no DOCX como aceite do Pocket Hero.
- O diretório `game/heroes/` sugerido pela fonte não existe neste repositório Godot. Para implementação, siga [`AGENTS.md`](../../AGENTS.md), cenas em `scenes/` e scripts em `scripts/`.

## BASTIÃO — GOLDEN REFERENCE

Projeto: Taskbar Hero Mobile
Versão: 0.1
Status geral: HERO_DESIGN_WIP
Documento-base: padrão canônico + kit de combate + passivas + traits + maestria

Documento consolidado para servir como referência de implementação do Bastião e como molde estrutural para os demais heróis.

## Parte I — Padrão Canônico dos Heróis

## 1. Regra principal

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

## 2. Anatomia de um herói

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

## 3. Skills

Cada herói possui 1 ataque básico + 5 skills normais + 1 Signature Skill.

Total: 7 ações próprias por personagem.

Com 8 personagens: 8 ataques básicos + 48 skills = 56 ações únicas.

### Skills normais

Cada skill normal possui até 5 ranks.

Uma skill não deve simplesmente ganhar mais dano. Sempre que possível, os ranks mais altos também devem alterar alguma propriedade:

alcance;

área;

duração;

número de alvos;

interação com a mecânica do herói;

status aplicado;

geração de recurso.

### Signature Skill

É a habilidade que representa o personagem. Possui 3 ranks.

Deve:

ser visualmente reconhecível;

explorar a mecânica exclusiva do herói;

provocar mudança perceptível no combate;

ser importante para pelo menos uma build;

nunca ser apenas "300% de dano".

## 4. Slots de habilidade

O personagem pode possuir 6 skills, mas somente 2 skills ativas equipadas simultaneamente.

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

O primeiro slot existe desde o início. O segundo slot é desbloqueado através da progressão global do Hub, valendo para todos os heróis.

## 5. Passivas

Cada herói possui exatamente 16 nós passivos.

1 Passiva de Identidade

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

Total: 1 + 5 + 5 + 5 = 16.

Cada passiva pode possuir até 5 ranks. O último nó de cada branch é um Capstone e precisa mudar significativamente a forma como aquela build funciona.

## 6. Traits

Cada herói possui exatamente 3 Traits. Existe um Trait associado a cada build.

Exemplo:

BASTIÃO

Guardião
Retaliação
Controle

O jogador escolhe 1 Trait ativo por vez.

Traits não devem ser simplesmente +10% de dano. Devem modificar alguma regra.

## 7. Árvore de progressão

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

O Tier 70 encerra a abertura estrutural da árvore. Do nível 70 ao 100 o jogador passa a aperfeiçoar a build que criou.

## 8. Skill Points

O herói recebe pontos de árvore durante a progressão. O orçamento final deve ser inferior ao custo necessário para maximizar tudo.

Regra: um personagem jamais deve conseguir maximizar completamente as três builds simultaneamente.

A árvore completa possui aproximadamente 108 pontos possíveis de investimento. O personagem recebe no máximo aproximadamente 75 Skill Points durante sua progressão normal.

Não existe build perfeita.
Existe escolha.

Respec deve existir através do Hub para incentivar experimentação.

## 9. Equipamentos

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

### Echo

O slot Echo será exclusivo do nosso universo. Ecos são fragmentos de memória preservados através do Lúmen.

Um Echo poderá modificar:

skills;

mecânica do herói;

interação com aliados;

Signature Skill;

comportamento de summons;

recursos especiais.

Exemplo:

Eco da Sentinela Perdida
Muralha Viva passa a proteger também o aliado com menor HP.

Isso conecta diretamente LOOT + BUILD + LORE.

## 10. Level

Level máximo: 100.

### Lv.1–30 — Descoberta

O jogador aprende a mecânica do personagem.

### Lv.31–60 — Especialização

A build começa a tomar forma.

### Lv.61–70 — Consolidação

Signature Skill e Capstones aparecem.

### Lv.71–100 — Aperfeiçoamento

O jogador otimiza equipamentos, ranks e sinergias.

## 11. Maestria

Depois do nível 100 começa Mastery 1–10.

Maestria representa domínio daquele personagem. Não deve existir progressão infinita.


| Mastery | Recompensa |
| --- | --- |
| M1 | bônus pequeno da mecânica central |
| M3 | modificador de skill |
| M5 | evolução visual |
| M7 | modificador avançado |
| M10 | Signature Modifier + aparência final |

O M10 representa um personagem verdadeiramente dominado.

## 12. Evolução visual

Cada herói possui 4 versões visuais.

### Forma I — Base

Personagem original.

### Forma II — Desperto

Desbloqueada durante a campanha pessoal. Mudanças pequenas: detalhes, partículas, arma e acessórios.

### Forma III — Ressonante

Lúmen começa a se manifestar visualmente.

### Forma IV — Lendária

Mastery 10. É a versão visual definitiva daquele personagem.

A silhueta base deve continuar reconhecível em todas as formas.

## 13. Lore pessoal

### Lore pessoal do Bastião — decisões atuais

**Status:** `DESIGN`; fatos abaixo são canônicos para a concepção narrativa atual. Diálogos, encontros finais e implementação continuam pendentes.

- Bastião foi membro da **Guarda da Primeira Muralha**.
- Seu nome verdadeiro foi perdido pelo Apagamento. **Não revelá-lo nesta etapa.**
- “Bastião” é o nome que assumiu a partir da função que passou a representar.
- Seu **Primeiro Juramento** é: “Enquanto houver alguém atrás de mim, eu permaneço.”
- A **Porta da Vigília** concentra sua memória perdida.
- Seu arco explora dever, memória, culpa e a diferença entre resistir e viver.

As cinco missões pessoais são:

1. **A Porta** — retorno às ruínas da Primeira Muralha.
2. **Nomes no Ferro** — origem do escudo e dos companheiros perdidos.
3. **O Último a Sair** — descoberta de que permaneceu mesmo após a evacuação.
4. **O Nome Esquecido** — recusa recuperar sua identidade ao custo das memórias alheias.
5. **Eu Fico** — repetição da antiga batalha, agora com aliados permanecendo ao seu lado.

Esta seção é a fonte autoritativa da lore pessoal do Bastião. A [Bíblia de Lore](../01_world/LORE_BIBLE.md) define apenas as regras globais do universo.

Todo herói recebe 5 missões próprias.

CAPÍTULO I
Quem ele era.

CAPÍTULO II
O que perdeu.

CAPÍTULO III
Sua relação com o Apagamento.

CAPÍTULO IV
Sua memória/Eco mais importante.

CAPÍTULO V
Resolução pessoal.

Essas missões podem liberar skins, Ecos, diálogos, itens, entradas no Codex e pequenas alterações no Hub.

Gameplay importante nunca deve exigir pagamento.

## 14. Os oito heróis


| Herói | Papel | Mecânica | Build A | Build B | Build C |
| --- | --- | --- | --- | --- | --- |
| Bastião | Tank | Escudo | Guardião | Retaliação | Controle |
| Flecha | DPS | Marca | Crítico | Marca | Velocidade |
| Íris | Mage | Lúmen | Arcano | Controle | Lúmen |
| Brasa | Bruiser | Fúria | Fúria | Queimadura | Sobrevivência |
| Véu | Assassin | Exposição | Execução | Veneno | Sombra |
| Orvalho | Healer | Sementes | Cura | Jardim | Simbiose |
| Forja | Summoner | Engenhocas | Torres | Armadilhas | Autômatos |
| Sino | Buffer | Ritmo | Ritmo | Ressonância | Memória |

### Bastião

Role: Tank. Mecânica: Escudo / Proteção. Builds: Guardião / Retaliação / Controle.

Skills: Muralha Viva; Contra-Golpe; Desafio; Fortaleza; Impacto de Escudo; Último Bastião (Signature).

Fantasia: "Eu fico."

### Flecha

Role: Ranged DPS. Mecânica: Marca / Crítico. Builds: Crítico / Marca / Velocidade.

Skills: Marca do Caçador; Flecha Perfurante; Olho Aguçado; Rajada; Ricochete; Chuva de Flechas (Signature).

### Íris

Role: Mage / Control. Mecânica: Lúmen / Controle. Builds: Arcano / Controle / Lúmen.

Skills: Pulso Prismático; Prisão de Lúmen; Refração; Véu Astral; Eco Prismático; Colapso Prismático (Signature).

### Brasa

Role: Bruiser / Berserker. Mecânica: Fúria / HP baixo. Builds: Fúria / Queimadura / Sobrevivência.

Skills: Sangue Quente; Golpe Incandescente; Fúria Crescente; Devorar Chamas; Investida de Cinzas; Última Centelha (Signature).

### Véu

Role: Assassin. Mecânica: Exposição / Execução. Builds: Execução / Veneno / Sombra.

Skills: Passo Entre Mundos; Corte Silencioso; Veneno Negro; Marca da Morte; Fenda Sombria; Fim Inevitável (Signature).

### Orvalho

Role: Healer / Support. Mecânica: Sementes. Builds: Cura / Jardim / Simbiose.

Skills: Semente Vital; Espinhos Vivos; Raízes Protetoras; Simbiose; Florescer; Última Primavera (Signature).

### Forja

Role: Engineer / Summoner. Mecânica: Engenhocas. Builds: Torres / Armadilhas / Autômatos.

Skills: Sentinela; Mina de Lúmen; Farol; Drone Catador; Sobrecarga; Projeto Impossível (Signature).

### Sino

Role: Buffer / Tempo. Mecânica: Ritmo / Memória. Builds: Ritmo / Ressonância / Memória.

Skills: Primeira Nota; Ressonância; Compasso; Memória Persistente; Crescendo; Encore (Signature).

## 15. Conteúdo total do roster

8 ataques básicos
48 skills ativas
128 passivas
24 Traits
24 builds principais
80 slots de equipamento
40 missões pessoais
32 formas visuais
80 níveis de Maestria

Somente o sistema de heróis já produz 176 elementos de build, considerando apenas 48 skills + 128 passivas.

## 16. Estrutura no repositório

game/
└── heroes/
    ├── bastiao/
    ├── flecha/
    ├── iris/
    ├── brasa/
    ├── veu/
    ├── orvalho/
    ├── forja/
    └── sino/

Dentro de cada herói:

bastiao/
├── HERO.md
├── SKILLS.md
├── PASSIVES.md
├── TRAITS.md
├── MASTERY.md
├── LORE.md
├── ITEMS.md
├── SYNERGIES.md
└── art/

HERO.md é a fonte principal de verdade. Os outros documentos detalham os sistemas.

## 17. Definition of Done

Um herói somente pode receber HERO_DESIGN_COMPLETE quando possuir:

identidade;

role;

mecânica central;

fraqueza;

ataque básico;

6 skills;

Signature Skill;

16 passivas;

3 Traits;

3 builds;

árvore T0–T7;

10 slots compatíveis;

pelo menos 3 itens exclusivos;

5 capítulos de lore;

4 estágios visuais;

sinergias com outros personagens;

sprites definidos pelo padrão oficial de arte;

números iniciais de balanceamento.

Enquanto qualquer item estiver ausente: HERO_DESIGN_WIP.

## 18. Regra de ouro

Quantidade sozinha não cria profundidade. Cada personagem deve responder claramente:

Por que eu escolheria esse herói?

Que decisões diferentes posso tomar ao montá-lo?

Por que eu voltaria a jogar com ele depois de 20 horas?

Se essas respostas não forem claras, o personagem ainda não está pronto.

## Parte II — Bastião: Kit Base

## 1. Identidade

Nome: Bastião
Arquétipo: Tank defensivo focado em absorver pressão, proteger aliados, controlar inimigos, bloquear ataques importantes, converter defesa em dano e sobreviver quando todos os outros cairiam.

Fantasia:

"Eu fico."

Bastião não luta porque acredita que é invencível. Ele luta porque alguém precisa permanecer de pé.

## 2. Filosofia de gameplay

Bastião não deve ser um personagem com 300% mais HP que simplesmente apanha. Ele deve recompensar decisões.

O jogador precisa observar: quem está sendo atacado → de onde vem o perigo → quando bloquear → quando gastar Guarda.

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

## 3. Mecânica exclusiva — Guarda

Valor inicial: 0 / 100.

Guarda representa sua capacidade de manter posição sob pressão.


| Evento | Guarda |
| --- | --- |
| receber ataque | +2 |
| bloquear ataque | +5 |
| Perfect Block | +12 |
| aliado protegido receber ataque | +4 |
| provocar inimigo | +3 |
| Contra-Golpe acertar | +5 |

Máximo: 100 Guarda.

Guarda não desaparece imediatamente fora de combate. Após alguns segundos sem combate começa a decair lentamente.

## 4. Perfect Block

Existe uma pequena janela ao levantar a defesa. Se um ataque atingir Bastião durante essa janela ocorre um PERFECT BLOCK.

Efeito básico:

dano recebido drasticamente reduzido;

gera Guarda adicional;

aplica Desequilíbrio ao atacante;

ativa interações de skills e passivas.

Isso cria diferença entre Bastião iniciante e Bastião dominado.

## 5. Status exclusivo — Desequilíbrio

Inimigos Desequilibrados sofrem:


| Efeito | Valor inicial |
| --- | --- |
| dano causado | -10% |
| resistência a stagger | -20% |
| duração | 4s |

Algumas builds poderão explorar esse estado agressivamente.

## 6. Ataque básico — Marcha de Ferro

Combo de espada e escudo:

Golpe 1 — Espada horizontal
↓
Golpe 2 — Golpe de escudo
↓
Golpe 3 — Corte pesado

O terceiro golpe gera +4 Guarda. Se atingir inimigo Desequilibrado: +6 Guarda.

## 7. Defesa básica

Segurar defesa: Erguer Escudo.

Redução inicial de dano frontal: 70%.
Movimento: -35% velocidade.

Bastião pode continuar avançando lentamente enquanto bloqueia. O escudo possui um pequeno arco frontal de proteção.

## 8. Skills


| Slot | Skill | Função |
| --- | --- | --- |
| S1 | Muralha Viva | proteção |
| S2 | Contra-Golpe | retaliação |
| S3 | Desafio | controle |
| S4 | Fortaleza | defesa |
| S5 | Impacto de Escudo | controle/dano |
| Signature | Último Bastião | emergência |

### Skill 1 — Muralha Viva

Bastião cria uma zona de proteção atrás de si. Aliados posicionados atrás do escudo recebem -40% dano à distância. Parte do dano mitigado gera Guarda.

Duração inicial: 6 segundos.
Cooldown: 14 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | proteção básica |
| 2 | +1s duração |
| 3 | aliados recebem +10% resistência |
| 4 | área maior |
| 5 | Perfect Blocks prolongam a duração |

Identidade: essa skill define Bastião como protetor. O posicionamento do personagem importa.

### Skill 2 — Contra-Golpe

Bastião assume postura defensiva. Se for atingido dentro da janela:

BLOCK
↓
ESCUDO
↓
CONTRA-ATAQUE

Dano: 180% Weapon Damage.
Aplica: Desequilíbrio.
Perfect Block: 250% Weapon Damage.
Cooldown: 8 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | counter básico |
| 2 | +20% dano |
| 3 | gera +10 Guarda |
| 4 | pequeno stun |
| 5 | Perfect Block cria onda de choque |

### Skill 3 — Desafio

Bastião bate sua arma contra o escudo. Inimigos próximos são Provocados por 4 segundos. Enquanto estiverem provocados causam -15% dano a aliados e priorizam Bastião.

Cada inimigo provocado gera +3 Guarda.
Cooldown: 15 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | taunt |
| 2 | área maior |
| 3 | duração +1s |
| 4 | inimigos provocados recebem Desequilíbrio |
| 5 | matar inimigo provocado reduz cooldown |

### Skill 4 — Fortaleza

Bastião ancora o escudo no chão. Durante 5 segundos recebe:


| Status | Bônus |
| --- | --- |
| redução de dano | +40% |
| resistência a knockback | +100% |
| geração de Guarda | +50% |

Bastião perde mobilidade significativa.
Cooldown: 20 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | defesa básica |
| 2 | +1s duração |
| 3 | regeneração leve |
| 4 | aliados próximos recebem resistência |
| 5 | não pode ser interrompido |

### Skill 5 — Impacto de Escudo

Bastião avança violentamente.

BASTIÃO
██████►

Inimigos atingidos são empurrados. O primeiro inimigo que colidir contra parede, objeto ou outro inimigo recebe dano adicional e stun.

Dano inicial: 140% Weapon Damage.
Custo: 20 Guarda.
Cooldown: 10 segundos.


| Rank | Efeito |
| --- | --- |
| 1 | investida |
| 2 | maior distância |
| 3 | maior knockback |
| 4 | colisões aplicam Desequilíbrio |
| 5 | inimigos Desequilibrados causam explosão de impacto |

### Signature — Último Bastião

Custo: 100 Guarda.
Duração: 8 segundos.

Durante o efeito:

não pode cair abaixo de 1 HP;

aliados próximos recebem redução de dano;

ataques contra aliados parcialmente redirecionam dano para Bastião;

todos os bloqueios contam como Perfect Blocks;

Contra-Golpe recebe cooldown acelerado;

Bastião não pode ser empurrado.

Ao terminar, uma onda de choque causa dano proporcional ao dano absorvido.

Conceito visual: o chão ao redor do personagem apresenta linhas luminosas de Lúmen formando uma muralha circular. Bastião permanece no centro.


| Rank | Efeito |
| --- | --- |
| 1 | efeito padrão |
| 2 | duração 8 → 10 segundos |
| 3 | ao terminar, restaura parte da vida dos aliados proporcional ao dano absorvido |

## 9. Passiva de identidade — Inabalável

Sempre que Bastião realiza um Perfect Block:

+Guarda
+
Desequilíbrio
+
redução temporária de dano

Perfect Blocks consecutivos aumentam brevemente sua eficiência defensiva. Esse bônus possui limite.

## 10. Builds principais

### Guardião

Objetivo: proteger o grupo.

### Retaliação

Objetivo: transformar defesa em dano.

### Controle

Objetivo: controlar posicionamento inimigo.

## 11. Fraquezas


| Fraqueza | Consequência |
| --- | --- |
| mobilidade baixa | dificuldade contra inimigos móveis |
| ataques traseiros | escudo pouco eficiente |
| dano contínuo | difícil realizar Perfect Block |
| inimigos espalhados | controle menos eficiente |
| pouca Guarda | capacidades ofensivas reduzidas |
| isolamento | parte das passivas perde valor |

Isso impede que Bastião seja sempre a melhor escolha.

## 12. Sinergias preliminares

Orvalho: Bastião mantém inimigos ocupados e Orvalho cria zonas persistentes. Excelente em batalhas longas.

Flecha: Desafio mantém inimigos agrupados e Flecha ataca com segurança.

Íris: Bastião agrupa; Íris controla áreas.

Brasa: Bastião absorve pressão enquanto Brasa permanece em HP baixo.

Véu: Bastião força inimigos a olhar para ele; Véu ataca pontos vulneráveis.

Forja: Bastião mantém inimigos dentro das áreas das engenhocas.

Sino: buffs defensivos e manipulação de ritmo tornam Bastião extremamente estável.

## 13. Equipamentos exclusivos iniciais

### Escudo — Muralha do Primeiro Juramento

Raridade: Legendary.
Efeito: Perfect Blocks geram Guarda adicional.

### Espada — Vigília

Raridade: Legendary.
Efeito: Contra-Golpe causa dano aumentado contra inimigos Desequilibrados.

### Echo — A Sentinela que Ficou

Raridade: Unique Echo.
Efeito: Muralha Viva protege também o aliado com menor HP mesmo que ele esteja ligeiramente fora da área.

Lore:

Todos fugiram.
Um ficou.

## 14. Curva de aprendizado

Iniciante: bloquear + provocar.

Intermediário: Guarda + posição + proteção.

Avançado: Perfect Block + controle.

Master: transformar ataques inimigos em recursos e controlar o ritmo inteiro da batalha.

## 15. Regra fundamental do personagem

Quando o jogador domina Bastião, deve sentir:

"Quanto mais pressão colocam em mim, mais perigoso eu fico."

Mas nunca:

"Posso simplesmente ficar parado e ser invencível."

Esse equilíbrio define o personagem.

## Parte III — Passivas do Bastião

Status: DESIGN_COMPLETE
Total: 16 passivas
Branches: Guardião / Retaliação / Controle
Ranks por passiva: 5
Capstones: 3

## 1. Estrutura

INABALÁVEL
                             │
              ┌──────────────┼──────────────┐
              │              │              │
          GUARDIÃO       RETALIAÇÃO      CONTROLE
              │              │              │
             A1             B1             C1
              ↓              ↓              ↓
             A2             B2             C2
              ↓              ↓              ↓
             A3             B3             C3
              ↓              ↓              ↓
             A4             B4             C4
              ↓              ↓              ↓
         A5 CAPSTONE    B5 CAPSTONE    C5 CAPSTONE

Total: 1 Passiva de Identidade + 5 Guardião + 5 Retaliação + 5 Controle = 16.

## 2. Passiva de Identidade — Inabalável

Tipo: Core Passive.
Ranks: 5.
Disponível: início.

Perfect Blocks fortalecem temporariamente Bastião. Cada Perfect Block concede uma carga de Inabalável.

Duração base: 4 segundos.
Máximo: 3 cargas.
Cada nova carga renova a duração.


| Rank | Efeito por carga |
| --- | --- |
| 1 | +2% redução de dano |
| 2 | +3% redução de dano |
| 3 | +3% redução + 2 Guarda adicional |
| 4 | +4% redução + 2 Guarda |
| 5 | +5% redução + 3 Guarda |

Com três cargas no Rank 5: +15% redução de dano enquanto o jogador continuar executando Perfect Blocks.

Objetivo: criar a base da identidade mecânica do personagem — jogar melhor = defender melhor.

## Build A — Guardião

Objetivo: transformar Bastião na principal proteção do grupo.

## A1 — Ombro a Ombro

Tipo: Aura defensiva.
Ranks: 5.

Aliados próximos recebem redução de dano. Raio inicial: 4 metros.


| Rank | Redução de dano |
| --- | --- |
| 1 | 2% |
| 2 | 3% |
| 3 | 4% |
| 4 | 5% |
| 5 | 6% |

No Rank 5, aliados dentro da área também recebem +10% resistência a knockback.

## A2 — Escudo Compartilhado

Tipo: Proteção.
Ranks: 5.

Parte do dano recebido por aliados próximos é redirecionado para Bastião. O dano transferido sofre mitigação normal da defesa de Bastião.


| Rank | Dano redirecionado |
| --- | --- |
| 1 | 4% |
| 2 | 6% |
| 3 | 8% |
| 4 | 10% |
| 5 | 12% |

Limite: não pode transferir dano suficiente para matar Bastião diretamente.

No Rank 5, cada instância de dano redirecionado gera +1 Guarda, com cooldown interno de 1 segundo.

Sinergia: Muralha Viva, Fortaleza e Último Bastião.

## A3 — Presença Protetora

Tipo: Modificador de Muralha Viva.
Ranks: 5.

Aliados protegidos por Muralha Viva recebem resistência adicional a controle.


| Rank | Resistência a controle |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Rank 3: reduz também duração de Slow.
Rank 5: ao entrar em Muralha Viva, o aliado remove imediatamente um efeito leve de Slow.

Não remove Stun, Freeze, efeitos de chefe ou mecânicas especiais.

## A4 — Ninguém Fica Para Trás

Tipo: Resposta de emergência.
Ranks: 5.

Quando um aliado fica abaixo de 30% HP, Bastião recebe bônus de movimento ao se deslocar em direção a ele.


| Rank | Movimento |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Duração: 5 segundos.
Cooldown por aliado: 15 segundos.

Rank 3: chegar próximo do aliado gera +10 Guarda.
Rank 5: ao alcançar o aliado, ambos recebem 10% redução de dano por 3s.

## A5 — Capstone: Guarda Eterna

Tipo: Capstone — Guardião.
Ranks: 5.

Quando um aliado próximo sofreria dano fatal, Bastião pode impedir sua morte. O aliado permanece com 1 HP e recebe proteção temporária.

Rank 1: ativa uma vez a cada 120 segundos; proteção 20% redução de dano por 2s.

Rank 2: cooldown 105 segundos.

Rank 3: proteção 30% por 3s.

Rank 4: cooldown 90 segundos.

Rank 5: ao salvar o aliado, Bastião recebe +30 Guarda e o aliado recebe 40% redução de dano por 3s.

Não funciona contra mecânicas de morte obrigatória, quedas, execução de encounter ou efeitos explicitamente marcados como inevitáveis.

## Build B — Retaliação

Objetivo: transformar ataques inimigos em dano. É a árvore com maior recompensa mecânica para Perfect Block.

## B1 — Peso do Escudo

Tipo: Retaliação.
Ranks: 5.

Perfect Blocks causam dano físico ao atacante.


| Rank | Weapon Damage |
| --- | --- |
| 1 | 20% |
| 2 | 30% |
| 3 | 40% |
| 4 | 50% |
| 5 | 60% |

Rank 5: o ataque também causa pequeno stagger. Não ativa efeitos de ataque básico.

## B2 — Momento

Tipo: Amplificador.
Ranks: 5.

Contra-Golpe causa dano adicional contra inimigos com Desequilíbrio.


| Rank | Dano adicional |
| --- | --- |
| 1 | +8% |
| 2 | +12% |
| 3 | +16% |
| 4 | +20% |
| 5 | +25% |

Rank 3: Contra-Golpe prolonga Desequilíbrio em 1 segundo.
Rank 5: se o inimigo estiver Desequilibrado, Contra-Golpe gera +5 Guarda.

## B3 — Pressão Acumulada

Tipo: Acúmulo ofensivo.
Ranks: 5.

Bloquear ataques gera Pressão. Máximo: 5 cargas. Cada carga aumenta o próximo Contra-Golpe.


| Rank | Dano por carga |
| --- | --- |
| 1 | +3% |
| 2 | +4% |
| 3 | +5% |
| 4 | +6% |
| 5 | +8% |

Rank 5: cinco cargas completas também aumentam o raio do Contra-Golpe. Usar Contra-Golpe consome todas as cargas. Duração: 8 segundos.

## B4 — Quebre-se Contra Mim

Tipo: Anti-Elite / Anti-Boss.
Ranks: 5.

Quando elites ou chefes atingem o escudo de Bastião, recebem aumento de dano de stagger.


| Rank | Stagger recebido |
| --- | --- |
| 1 | +5% |
| 2 | +8% |
| 3 | +11% |
| 4 | +14% |
| 5 | +18% |

Perfect Block dobra o bônus daquele ataque. Rank 5: Perfect Block contra Elite/Boss também gera +5 Guarda.

## B5 — Capstone: Julgamento de Ferro

Tipo: Capstone — Retaliação.
Ranks: 5.

Perfect Blocks consecutivos geram cargas de Julgamento. Após acumular a quantidade necessária, o próximo Contra-Golpe se transforma em Julgamento de Ferro, criando uma onda de choque frontal.

Rank 1: requer 4 Perfect Blocks; dano da onda 180% Weapon Damage.

Rank 2: requer 4; dano 210%.

Rank 3: requer 3 Perfect Blocks; dano 230%.

Rank 4: dano 260%; aplica Desequilíbrio.

Rank 5: dano 300% Weapon Damage; inimigos já Desequilibrados também sofrem Heavy Stagger.

As cargas permanecem por 10 segundos entre Perfect Blocks.

## Build C — Controle

Objetivo: manipular posicionamento e fluxo da batalha.

## C1 — Voz de Comando

Tipo: Modificador de Desafio.
Ranks: 5.

Aumenta o alcance de Desafio.


| Rank | Área |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Rank 3: inimigos provocados recebem -5% velocidade.
Rank 5: Desafio gera +1 Guarda adicional por inimigo atingido.

## C2 — Sem Passagem

Tipo: Controle de proximidade.
Ranks: 5.

Inimigos próximos de Bastião recebem redução de movimento quando tentam atravessar sua posição.


| Rank | Slow |
| --- | --- |
| 1 | 5% |
| 2 | 8% |
| 3 | 11% |
| 4 | 14% |
| 5 | 18% |

Área: 3 metros. Rank 5: inimigos Desequilibrados recebem 25% Slow em vez de 18%.

## C3 — Choque de Linha

Tipo: Modificador de Impacto de Escudo.
Ranks: 5.

Rank 1: pode empurrar 2 inimigos.

Rank 2: dano de colisão +10%.

Rank 3: pode empurrar 3 inimigos.

Rank 4: colisão entre dois inimigos causa +25% dano.

Rank 5: pode empurrar até 4 inimigos e colisões geram pequeno dano em área.

## C4 — Formação Quebrada

Tipo: Manipulação de Desequilíbrio.
Ranks: 5.

Inimigos Desequilibrados sofrem mais efeitos de deslocamento.


| Rank | Knockback adicional |
| --- | --- |
| 1 | +10% |
| 2 | +15% |
| 3 | +20% |
| 4 | +25% |
| 5 | +30% |

Rank 3: stagger contra esses inimigos +10%.
Rank 5: quando um inimigo Desequilibrado colide contra outro, o segundo inimigo também recebe Desequilíbrio.

## C5 — Capstone: Linha Inquebrável

Tipo: Capstone — Controle.
Ranks: 5.

Usar Impacto de Escudo deixa atrás de Bastião uma linha temporária de Lúmen. Inimigos que atravessarem a linha são afetados.

Rank 1: duração 3 segundos; 20% Slow.

Rank 2: duração 4 segundos.

Rank 3: primeiro inimigo que atravessa recebe Desequilíbrio.

Rank 4: duração 5 segundos; Slow 30%.

Rank 5: o primeiro cruzamento de cada inimigo também causa interrupção e aplica Desequilíbrio.

Chefes não são interrompidos. Recebem apenas Slow reduzido, Desequilíbrio e aumento de stagger.

## 3. Custos

Cada rank custa 1 Skill Point. Cada passiva possui 5 ranks.

16 × 5 = 80 pontos possíveis

Isso é somente passivas. Skills ativas também consomem pontos. O jogador não terá pontos suficientes para maximizar tudo.

## 4. Requisitos de árvore

### Core

Inabalável disponível desde o início.

### Tier 1 — nível 10

Ombro a Ombro; Peso do Escudo; Voz de Comando.

### Tier 2 — nível 20

Escudo Compartilhado; Momento; Sem Passagem. Requer 3 pontos na branch.

### Tier 3 — nível 30

Presença Protetora; Pressão Acumulada; Choque de Linha. Requer 7 pontos na branch.

### Tier 4 — nível 50

Ninguém Fica Para Trás; Quebre-se Contra Mim; Formação Quebrada. Requer 12 pontos na branch.

### Capstone — nível 70

Guarda Eterna; Julgamento de Ferro; Linha Inquebrável. Requer 18 pontos na branch.

## 5. Filosofia de builds híbridas

O jogador não precisa permanecer em apenas uma branch.

### Protector Counter

Guardião forte + Retaliação média + Controle leve. Combina proteção de aliados com Perfect Blocks.

### Crowd Commander

Controle forte + Guardião leve + Retaliação leve. Focado em Desafio, Desequilíbrio, knockback e posicionamento.

### Iron Wall

Guardião extremo + Retaliação moderada + Controle leve. Build defensiva extrema.

## 6. Interações importantes

Desafio
↓
Voz de Comando
↓
mais inimigos provocados
↓
mais Guarda
↓
Impacto de Escudo
↓
Choque de Linha
↓
Formação Quebrada
↓
Linha Inquebrável

Perfect Block
↓
Inabalável
↓
Pressão Acumulada
↓
Julgamento
↓
Contra-Golpe
↓
Julgamento de Ferro

Aliado sofre dano
↓
Escudo Compartilhado
↓
Bastião recebe dano
↓
gera Guarda
↓
Muralha Viva
↓
Guarda Eterna

## 7. Anti-sinergias intencionais

Nem tudo deve funcionar perfeitamente junto. Fortaleza incentiva ficar parado, enquanto Ninguém Fica Para Trás incentiva movimentação. Retaliação quer que inimigos ataquem Bastião, enquanto Controle frequentemente quer empurrá-los para longe.

Essa tensão é desejável.

## 8. Regra para números

Todos os números deste documento são BALANCE_PLACEHOLDER e podem mudar durante testes. A identidade das passivas, entretanto, deve permanecer.

Nunca balancear removendo a característica principal de uma passiva. Se Julgamento de Ferro estiver forte, prefira aumentar o número de Perfect Blocks necessários, reduzir dano, colocar cooldown interno ou reduzir raio — mas mantenha Perfect Blocks → grande Contra-Golpe.

## Parte IV — Traits do Bastião

Status: DESIGN_COMPLETE
Total: 3 Traits
Traits ativos simultaneamente: 1
Desbloqueio: Tier 3 / aproximadamente Lv.30

## 1. Objetivo dos Traits

Traits definem a especialização principal do Bastião. Enquanto as passivas permitem misturar builds, o Trait responde:

Qual versão do Bastião estou jogando nesta run?

Os três caminhos são:

Guardião: proteção de aliados;

Retaliação: Perfect Block e Contra-Golpe;

Controle: posicionamento e Desequilíbrio.

O jogador pode trocar Trait fora de combate no Hub. Nunca durante combate.

## Trait — Voto do Escudo

Branch: Guardião.
Função: proteção ativa.
Dificuldade: baixa/média.

Fantasia:

"Enquanto eu estiver aqui, vocês não caem."

## Efeito principal — Juramento

Sempre que Bastião reduzir ou absorver dano que seria causado a um aliado, recebe JURAMENTO.

Duração: 6 segundos.
Máximo: 5 cargas.

Cada carga concede:

+2% redução de dano;

+2% geração de Guarda proveniente de proteção.

Máximo: +10% redução de dano e +10% geração de Guarda.

Conta como proteção: Muralha Viva, Escudo Compartilhado, Último Bastião, Guarda Eterna e efeitos de equipamento explicitamente marcados como proteção.

Não conta: cura, regeneração, buffs genéricos ou dano evitado pelo próprio aliado.

## Efeito especial — Promessa

Ao alcançar 5 cargas de Juramento, Bastião entra em PROMESSA por 5 segundos.

Durante Promessa:

Muralha Viva aumenta sua área em 25%;

aliados protegidos recebem +10% resistência a dano adicional.

Após Promessa terminar, Juramento retorna para zero. Cooldown interno: 12 segundos.

## Interações

Muralha Viva: principal gerador de Juramento em combates com projéteis.

Escudo Compartilhado: permite gerar Juramento constantemente durante pressão sobre aliados.

Fortaleza: aumenta a capacidade de permanecer na linha de frente enquanto protege.

Guarda Eterna: salvar um aliado concede imediatamente 5 cargas de Juramento.

## Estilo de jogo

aliado sofre pressão
↓
Bastião protege
↓
Juramento
↓
mais defesa
↓
mais proteção
↓
Promessa
↓
janela de defesa extrema do grupo

Fraqueza: perde bastante valor quando Bastião está sozinho, aliados permanecem longe ou inimigos ignoram completamente os outros personagens.

## Trait — Ferro Responde

Branch: Retaliação.
Função: counter tank.
Dificuldade: alta.

Fantasia:

"Todo golpe tem resposta."

## Efeito principal — Resposta

Perfect Blocks concedem RESPOSTA.

Máximo: 3 cargas.
Duração: 6 segundos.

Cada carga reduz o cooldown atual de Contra-Golpe em 0,75 segundo.

## Reação em cadeia — Resposta de Ferro

Ao alcançar 3 cargas, o próximo Contra-Golpe entra no estado RESPOSTA DE FERRO e recebe:

+20% dano;

+30% stagger;

+25% área;

não consome Guarda.

Usar Contra-Golpe remove todas as cargas.

## Perfect Counter

Se o jogador usar Contra-Golpe imediatamente após um Perfect Block, dentro de 1 segundo, realiza PERFECT COUNTER.

Além dos efeitos normais:

gera +10 Guarda;

aplica Desequilíbrio;

prolonga Desequilíbrio existente em 2s;

reduz em 1s o cooldown de Contra-Golpe.

## Sinergia com Julgamento de Ferro

Se Resposta de Ferro e Julgamento de Ferro estiverem ativos simultaneamente, o ataque recebe o estado VEREDITO:

área aumentada;

stagger aumentado;

inimigos comuns próximos são empurrados.

O ganho principal é impacto e controle, não multiplicadores absurdos de dano.

## Estilo de jogo

ataque inimigo
↓
Perfect Block
↓
Resposta
↓
Perfect Block
↓
Resposta
↓
Contra-Golpe
↓
Perfect Counter
↓
novo ciclo

Risco: se o jogador errar o timing, não recebe Resposta. Bloqueios normais não ativam o Trait.

## Trait — Não Passarão

Branch: Controle.
Função: zone control.
Dificuldade: média.

Fantasia:

"Daqui vocês não passam."

## Efeito principal — Zona de Presença

Bastião cria permanentemente uma pequena ZONA DE PRESENÇA com raio de 3 metros.

Inimigos dentro dela:

recebem -10% velocidade;

recebem +10% stagger;

geram +1 Guarda adicional quando são provocados.

Inimigos com Desequilíbrio recebem -20% velocidade em vez de -10%.

## Contenção

Quando Bastião aplica knockback a um inimigo dentro da Zona de Presença, o inimigo recebe CONTENÇÃO por 4 segundos.

Contenção faz o próximo efeito de deslocamento contra aquele inimigo ser 25% mais forte, depois é consumida.

## Barreira Humana

Se um inimigo tentar atravessar diretamente Bastião enquanto estiver dentro da Zona, sofre micro-stagger e 20% Slow por 2s.

Cooldown por inimigo: 5 segundos.

## Interação com Impacto de Escudo

Inimigos com Contenção atingidos por Impacto de Escudo:

viajam mais longe;

causam mais dano ao colidir;

aplicam Desequilíbrio ao alvo atingido.

Desafio
↓
grupo se aproxima
↓
Zona de Presença
↓
Desequilíbrio
↓
Impacto de Escudo
↓
colisão
↓
formação inimiga destruída

## Interação com Linha Inquebrável

Se Bastião possuir o Capstone Linha Inquebrável, a linha deixada por Impacto de Escudo passa a contar como extensão temporária da Zona de Presença, permitindo controlar corredores inteiros.

## Limitação contra chefes

Chefes não podem ser empurrados livremente. Não Passarão os afeta através de stagger, Desequilíbrio, redução leve de movimento e geração de Guarda — nunca por controle total.

## Comparação dos Traits


| Trait | Especialidade | Melhor situação | Fraqueza |
| --- | --- | --- | --- |
| Voto do Escudo | proteger | grupo sob pressão | pouco valor solo |
| Ferro Responde | counters | inimigos agressivos | exige timing |
| Não Passarão | controle | grupos e corredores | menos dano direto |

## Relação com as builds

Os Traits combinam naturalmente com suas branches, mas não existe bloqueio. Exemplos híbridos:

Guardião + Ferro Responde: tank defensivo que ainda recompensa Perfect Blocks.

Retaliação + Não Passarão: counter tank com forte controle de área.

Controle + Voto do Escudo: tank de posicionamento orientado à proteção.

Traits não possuem ranks. O Trait é uma alteração de regra completa. A progressão relacionada acontece através de passivas, equipamentos, Maestria e Echoes.

## Feedback visual e sonoro

Voto do Escudo: cada carga de Juramento adiciona um segmento luminoso ao redor do escudo. Com cinco cargas, o escudo apresenta borda completa de Lúmen. Som grave ao alcançar Promessa.

Ferro Responde: Perfect Blocks geram pequenas rachaduras luminosas na espada. Com três cargas, a arma fica completamente carregada. Som metálico crescente por carga.

Não Passarão: uma linha sutil de Lúmen acompanha o chão ao redor de Bastião e reage quando um inimigo entra. Som curto de impacto quando Barreira Humana interrompe um inimigo.

## Regra de balanceamento

Traits devem alterar decisão e comportamento, nunca virar apenas +15% dano ou +15% defesa.

Se um Trait for claramente superior em todas as situações, ele está mal desenhado. Cada um precisa ter situação ideal, situação ruim, risco e recompensa.

## Parte V — Maestria do Bastião

Status: DESIGN_COMPLETE
Sistema: Hero Mastery
Níveis: 10
Pré-requisito: Hero Level 100

## 1. Objetivo

A Maestria representa o quanto o jogador realmente dominou Bastião. Ela não deve ser uma segunda barra de level genérica.

A progressão deve reconhecer ações que representam o personagem:

Perfect Blocks;

dano protegido;

aliados salvos;

Guarda gerada;

inimigos Desequilibrados;

Contra-Golpes bem executados;

controle de grupos;

conclusão de desafios próprios.

## 2. Filosofia

Level 1–100 responde: Quanto eu evoluí esse personagem?
Mastery 1–10 responde: Quanto eu aprendi a jogar com ele?

## 3. Mastery XP

Depois do Level 100, Bastião começa a receber MXP — Mastery Experience.


| Ação | MXP relativo |
| --- | --- |
| concluir combate | normal |
| Perfect Block | bônus |
| proteger aliado | bônus |
| impedir morte | alto |
| quebrar postura de Elite | bônus |
| derrotar Boss | alto |
| missão pessoal | muito alto |
| desafio de Maestria | muito alto |

Farmar inimigos fracos repetidamente deve possuir retorno reduzido.

## 4. Estrutura

LEVEL 100
   ↓
M1
   ↓
M2
   ↓
M3
   ↓
M4
   ↓
M5
   ↓
M6
   ↓
M7
   ↓
M8
   ↓
M9
   ↓
M10

Marcos principais: M3 / M5 / M7 / M10.

## 5. Mastery 1 — Veterano da Linha

Bastião começa cada combate com 15 Guarda. Além disso, Perfect Block gera +1 Guarda adicional.

Objetivo: reduzir a sensação de início lento depois que o jogador já domina o herói, sem eliminar a necessidade de construir Guarda.

Visual: pequena marca adicional aparece no escudo.

## 6. Mastery 2 — Passo Firme

Enquanto Bastião estiver acima de 50 Guarda, recebe +10% resistência a knockback e redução pequena na penalidade de movimento ao bloquear.

Penalidade: -35% → -30%.

## 7. Mastery 3 — Técnica de Mestre

Primeiro grande modificador de habilidade. O jogador escolhe um dos três estilos. A escolha pode ser alterada no Hub.

### M3-A — Muralha Avançada

Muralha Viva: ao realizar Perfect Block durante Muralha Viva, a duração é estendida em 0,5 segundo, com limite de +3 segundos.

### M3-B — Resposta Precisa

Contra-Golpe: executar Perfect Counter reduz o cooldown de Contra-Golpe em 2 segundos.

### M3-C — Impacto Tático

Impacto de Escudo: colisões contra paredes ou inimigos geram +5 Guarda, com limite de 15 Guarda por uso.

A Maestria começa a permitir especialização: Proteção / Retaliação / Controle. Nenhuma opção deve ser universalmente melhor.

## 8. Mastery 4 — Vigília

Quando um aliado próximo fica abaixo de 40% HP, Bastião passa a enxergar um indicador visual discreto apontando sua direção.

Enquanto estiver se movendo em direção ao aliado: +10% velocidade.

Não acumula com Ninguém Fica Para Trás além de um limite definido pelo balanceamento.

## 9. Mastery 5 — Ressonante

Segundo grande marco. Bastião alcança FORMA III — RESSONANTE.

### Evolução visual M5

rachaduras luminosas sutis no escudo;

runas aparecem após Perfect Blocks;

bordas da armadura brilham em Guarda alta;

Contra-Golpe deixa pequena trilha luminosa;

olhos do capacete refletem Lúmen durante Último Bastião.

A silhueta original permanece intacta.

### Recompensa mecânica — Ressonância Defensiva

Ao alcançar 100 Guarda, Bastião entra em RESSONÂNCIA por 5 segundos.

Durante Ressonância:

Guarda não decai;

geração de Guarda excedente é convertida em uma pequena barreira;

Perfect Blocks prolongam Ressonância em 0,5s.

Limite de extensão: +3 segundos.
Cooldown: 20 segundos.

A barreira possui limite baixo. Seu propósito é premiar boa gestão de Guarda, não substituir cura ou defesa.

## 10. Mastery 6 — Comandante da Linha

Inimigos provocados por Bastião passam a possuir indicador mais claro.

Enquanto um inimigo estiver provocado, ataques desse inimigo contra Bastião geram +1 Guarda adicional. Elites e Bosses geram +2, com cooldown interno.

## 11. Mastery 7 — Doutrina

Segundo modificador avançado. O jogador escolhe uma Doutrina. Uma ativa por vez.

### Doutrina — Escudo

Quando Muralha Viva protege pelo menos dois aliados simultaneamente, Bastião recebe +15% geração de Guarda. Ao final da skill, aliados protegidos recebem uma pequena barreira temporária.

### Doutrina — Ferro

Três Perfect Blocks realizados em sequência sem sofrer dano não bloqueado concedem PRECISÃO DE FERRO.

O próximo Contra-Golpe recebe área maior, aplica Heavy Stagger a inimigos comuns e gera Guarda adicional.

### Doutrina — Fronteira

Inimigos que entram pela primeira vez na Zona de Presença enquanto estão Desequilibrados sofrem micro-stagger. Cooldown por inimigo: 6 segundos.

Bosses são imunes ao stagger, mas recebem aumento temporário de stagger recebido.

## 12. Mastery 8 — Juramento Antigo

Bastião recebe um segundo slot exclusivo para ECHO DE MAESTRIA. Esse slot aceita apenas Ecos específicos do personagem e não substitui o Echo normal do equipamento.

Exemplos:

### Eco — A Última Porta

Fortaleza cria uma pequena área protegida atrás de Bastião.

### Eco — O Primeiro Golpe

O primeiro Perfect Block de cada combate gera Guarda dobrada.

### Eco — Sem Recuo

Impacto de Escudo pode ser cancelado em defesa imediatamente após colisão.

## 13. Mastery 9 — Inabalável

A passiva central Inabalável recebe uma evolução.

Ao atingir 3 cargas, além dos bônus normais, Bastião recebe +10% geração de stagger e os ataques inimigos bloqueados produzem feedback visual mais forte.

Perfect Block renova todas as cargas.

## 14. Mastery 10 — O Que Ficou

Mastery máxima. Representa domínio completo do Bastião.

Desbloqueia:

FORMA IV — LENDÁRIA;

SIGNATURE MODIFIER.

### Evolução visual M10 — O Bastião Ressonante

escudo recebe padrões completos de Lúmen;

armadura possui marcas de batalhas antigas;

pequenas partículas surgem quando Guarda está alta;

Perfect Block produz um símbolo breve no chão;

Último Bastião cria uma fortificação visual muito mais marcante;

capa ou tecido secundário ganha detalhes associados à sua história.

O personagem ainda deve ser reconhecido instantaneamente.

### Signature Modifier — Ninguém Cai

Último Bastião recebe NINGUÉM CAI.

Quando Último Bastião é ativado:

todos os aliados próximos recebem imediatamente uma pequena barreira;

durante a habilidade, Perfect Blocks restauram parcialmente a barreira dos aliados;

ao terminar, a onda de choque final deixa uma zona protetora no chão por 4 segundos;

aliados dentro dela recebem 15% redução de dano.

Mastery 10 não significa invencibilidade. Não deve apagar fraquezas, posicionamento, timing, necessidade de Guarda nem importância do grupo.

## 15. Desafios de Maestria

### Desafio M3 — Reflexos de Ferro

Realizar 50 Perfect Blocks.

### Desafio M5 — Muralha

Evitar X dano destinado a aliados através de proteção. Valor definido posteriormente por telemetria.

### Desafio M7 — Sem Recuar

Derrotar uma Elite ou Boss tendo realizado 10 Perfect Blocks durante a luta.

### Desafio M10 — Eu Fico

Completar um desafio exclusivo do Bastião: proteger um grupo durante um encontro especial sem permitir que nenhum aliado seja derrotado. O desafio deverá estar ligado à lore pessoal.

## 16. Progressão visual completa

FORMA I
Bastião
Lv.1

↓

FORMA II
Desperto
Campanha pessoal

↓

FORMA III
Ressonante
Mastery 5

↓

FORMA IV
O Que Ficou
Mastery 10

### Forma II — Desperto

A Forma II não vem da Maestria. É desbloqueada através da campanha pessoal.

Alterações:

escudo reparado/modificado;

nova marca na armadura;

pequena presença de Lúmen;

mudança em detalhes da arma.

A razão dessas mudanças deve aparecer na história.

## 17. Resumo da Maestria


| Mastery | Recompensa |
| --- | --- |
| M1 | Guarda inicial |
| M2 | estabilidade ao bloquear |
| M3 | modificador de skill |
| M4 | resposta a aliados em perigo |
| M5 | Forma Ressonante + Ressonância |
| M6 | provocação aprimorada |
| M7 | Doutrina |
| M8 | Echo de Maestria |
| M9 | Inabalável evoluído |
| M10 | Forma Lendária + Signature Modifier |

## 18. Builds após Maestria

### Guardião

Passivas Guardião + Voto do Escudo + M3 Muralha Avançada + Doutrina Escudo + Echo A Última Porta.

### Retaliação

Passivas Retaliação + Ferro Responde + M3 Resposta Precisa + Doutrina Ferro + Echo O Primeiro Golpe.

### Controle

Passivas Controle + Não Passarão + M3 Impacto Tático + Doutrina Fronteira + Echo Sem Recuo.

Isso cria progressão vertical e horizontal ao mesmo tempo.

## 19. Princípio de balanceamento

Maestria deve aumentar expressão do jogador, variedade, identidade e opções de build. Ela não deve simplesmente aumentar poder infinitamente.

Meta:

Um Bastião M10 deve parecer mais completo e interessante, não dez vezes mais forte que um Bastião Lv.100.

## Parte VI — Estado Atual do Bastião


| Sistema | Estado |
| --- | --- |
| identidade | concluído |
| mecânica central | concluído |
| fraqueza | concluído |
| ataque básico | concluído |
| 6 skills | concluído |
| Signature | concluído |
| 16 passivas | concluído |
| 3 Traits | concluído |
| 3 builds | concluído |
| sinergias | preliminar |
| equipamentos exclusivos | 3 iniciais |
| Mastery 1–10 | concluído |
| Lore 5 capítulos | pendente |
| evolução visual | definida em conceito; arte pendente |
| números finais | pendente |
| balanceamento | pendente |

Status atual: HERO_DESIGN_WIP

## Próximos itens recomendados

Lore e 5 missões pessoais do Bastião.

Itens exclusivos adicionais e Echoes.

Sinergias formais com os outros 7 heróis.

Design visual das quatro formas.

Valores de balanceamento e protótipo jogável.

Sprites, VFX, SFX e feedback de UI.

Regra de ouro do Bastião:

Quanto mais pressão colocam em mim, mais perigoso eu fico — mas nunca por simplesmente ficar parado.
