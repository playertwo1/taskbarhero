---
id: HERO_002
nome: Flecha
titulo: A Caçadora Silvestre
status: DESIGN
certainty: DECIDIDO
document_type: hero-canonical-sheet
source_lore: "docs/01_world/loreparte1.md"
---

# HERO_002 — Flecha (A Caçadora Silvestre)

**Status de design:** `DESIGN` — Ficha canônica expandida no padrão [`HERO_STANDARD.md`](HERO_STANDARD.md).<br>
**Status do runtime:** `IMPLEMENTED` (`scenes/heroes/Flecha.tscn`, sprite 96×96 em `assets/sprites/heroes/flecha/`).<br>
**ID de design:** `HERO_002`  
**ID runtime:** `flecha` / `hero_flecha`  
**Papel central:** Atiradora Ranged DPS / Marca & Crítico  
**Posição de combate:** Retaguarda (`back`, range 400)  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Identidade e Filosofia

### Fantasia
> *"Aquela que nunca erra — exceto o passado."*

Flecha lembra com precisão cirúrgica de cada detalhe mecânico do tiro: distância, vento, velocidade, ângulo, curvatura da haste e movimento da presa. Seus olhos decompõem a floresta em vetores de abate antes que qualquer criatura note sua presença. No entanto, ela não consegue lembrar quem lhe ensinou a atirar, de onde veio ou por que seus dedos tremem apenas quando ela pousa o arco.

### Arquétipo
Atiradora de longa distância focada em preparar presas com **Marca do Caçador**, converter pontos fracos em **Acertos Críticos devastadores**, disparar rajadas perfurantes e abater ameaças antes que elas alcancem a linha de frente do grupo.

### Mecânica Exclusiva: Marca do Caçador
Flecha marca um alvo prioritário com runas de Lúmen. Um alvo marcado:
- Revela suas falhas de armadura, concedendo bônus cumulativo de taxa crítica para Flecha.
- Serve de catalisador tático para a party (alimenta a *Sensível ao Lúmen* e a *Contenção Arcana* de Íris, além de coordenar o contra-golpe de Bastião).
- Impede que o inimigo se camufle ou recue na névoa.

### Fraqueza Clara
Extrema vulnerabilidade a emboscadas e pressão corpo a corpo. Se inimigos ultrapassam a vanguarda e colam na retaguarda, Flecha perde sua vantagem de tração de arco e sua defesa de couro leve não suporta ataques pesados. Ela depende do espaço mantido por Bastião e do controle territorial de Íris para operar em eficácia máxima.

---

## 2. Lore Canônica

*(Baseada no documento de fundação [`loreparte1.md`](../01_world/loreparte1.md))*

Flecha não despertou em uma cama, nem entre sobreviventes. Ela abriu os olhos sob a terra encharcada após uma tempestade colossal de Lúmen na orla norte do Bosque.

Ao seu lado, fincado na lama, havia um arco recurvo de madeira escura e uma aljava pesada de couro cru. Dentro da aljava repousavam dezenas de flechas talhadas à mão. Em cada uma das hastes de madeira, um nome humano havia sido cuidadosamente entalhado.

Alguns nomes estavam riscados com traços firmes de faca. Outros permaneciam intocados.

Sem memória de sua própria infância, de sua família ou até mesmo de seu nome de nascença, ela passou a caminhar pelas trilhas esquecidas seguindo os nomes das flechas ainda intactas. Conforme encontrava vilarejos engolidos pela névoa e postos destruídos da Primeira Muralha, descobria que aqueles nomes pertenciam a pessoas que haviam desaparecido durante os primeiros dias do Apagamento.

A dúvida que consome sua mente é uma ferida aberta:
*Ela era uma guardiã que jurou encontrar e resgatar cada uma daquelas pessoas... ou era uma assassina impiedosa encarregada de caçá-las antes que o mundo esquecesse quem elas eram?*

Essa incerteza gerou sua obsessão compulsiva por marcar alvos. Para Flecha, o Apagamento é o inimigo supremo porque destrói pela desatenção e pelo esquecimento. Em sua visão:
> *"O que é marcado não pode sumir. O que eu tenho na mira é forçado a existir."*

Cada monstro que enfrenta recebe seu símbolo de mira. Cada trilha aberta no Bosque de Lúmen é entalhada em troncos. Cada aliado caído tem seu nome repetido por ela ao redor da fogueira do Refúgio. Esquecer algo pela segunda vez seria um crime que seu arco jamais perdoaria.

---

## 3. As 5 Missões Pessoais

A progressão narrativa pessoal de Flecha desenvolve-se em 5 capítulos que destravam diálogos, cosméticos, entradas de códice e Ecos únicos no Refúgio da Vigília:

### Capítulo I: Os Nomes na Madeira *(Quem ela era)*
- **Premissa:** Flecha encontra restos de um posto avançado de patrulha na fronteira entre o Bosque e as Terras Centrais. Lá, encontra marcas de flechas cravadas em alvos de treino com o mesmo padrão de entalhe de suas hastes.
- **Conflito:** Ela precisa rastrear vestígios de uma unidade de arqueiros batedores que operava antes do Apagamento para descobrir a que ordem pertencia.
- **Revelação:** Ela era a primeira sentinela de uma tropa de batedores de fronteira; a aljava era um juramento de guarnição.
- **Recompensa:** Entrada no Códice: *A Guarda Silvestre de Lúmen* + Cosmético de arco refinado.

### Capítulo II: O Alvo Que Faltava *(O que perdeu)*
- **Premissa:** Durante uma expedição profunda, Flecha reconhece uma flecha partida fincada em uma ruína tomada por micélio. A haste traz o nome de uma pessoa que ela acreditava ter salvado.
- **Conflito:** O medo de descobrir que ela mesma riscou nomes após falhar em resgatá-los. Ela enfrenta a Besta de Esporos que guardava os restos daquele acampamento.
- **Revelação:** As flechas riscadas não representavam abates de contrato, mas funerais de honra: eram pessoas cujos corpos ela encontrou e sepultou para que seus nomes não fossem devorados pela corrupção.
- **Recompensa:** Desbloqueio do Trait aprimorado / Diálogo pessoal com Bastião sobre o fardo de ser quem sobrevive.

### Capítulo III: O Que Não Se Apaga *(Sua relação com o Apagamento)*
- **Premissa:** Criaturas corrompidas no bosque começam a manifestar runas espectrais similares à sua *Marca do Caçador*. Íris alerta que o Lúmen corrompido está tentando "marcar de volta" a arqueira.
- **Conflito:** Combate contra uma projeção espectral na névoa que copia a cadência e a distância dos seus disparos.
- **Revelação:** A Marca de Flecha é uma imposição da vontade sobre o vazio: ela não apenas mira, ela ancora a realidade do alvo através da concentração pura. O Apagamento não consegue apagar aquilo em que Flecha mantém foco constante.
- **Recompensa:** Desbloqueio da **Forma II (Desperta)** de Flecha + Aprimoramento da passiva de Identidade.

### Capítulo IV: A Última Flecha Intacta *(Sua memória mais importante)*
- **Premissa:** Resta apenas uma única flecha na aljava original cujo nome nunca foi tocado nem riscado. A inscrição está gasta pelo atrito constante dos seus dedos.
- **Conflito:** No Santuário do Guardião, em ressonância com o Coração de Lúmen, o Lúmen devolve a Flecha a visão do momento em que a aljava foi forjada e quem entalhou aquela última haste.
- **Revelação:** O nome gravado na última flecha é o seu próprio nome verdadeiro, entalhado por quem a amava antes de partir na tempestade. A promessa era: *"Quando você se esquecer de quem é, siga esta flecha até voltar para casa."*
- **Recompensa:** Acesso ao Eco de Referência Exclusivo: **A Flecha Sem Nome**.

### Capítulo V: Mira Firme *(Resolução pessoal)*
- **Premissa:** Diante de uma ameaça que avança contra os portões do Refúgio da Vigília, Flecha se vê na mesma encruzilhada do passado: guardar a última flecha para tentar resgatar seu passado, ou dispará-la para garantir o futuro dos vivos.
- **Conflito:** Ela ajusta a corda do arco e coloca na fresta a última flecha com seu nome verdadeiro.
- **Resolução:** Flecha dispara a flecha para salvar Bastião e Íris de uma investida mortal. Ao ver a haste se desintegrar em pura luz de Lúmen, ela compreende a resposta da existência: não importa quem ela foi antes do Apagamento; o que a define é onde sua mira pousa agora para proteger quem está atrás de si.
- **Recompensa:** Título *A Sentinela Silvestre* + Desbloqueio do visual definitivo e estátua restaurada no Memorial do Refúgio.

---

## 4. Equipamentos Canônicos de Referência

Seguindo o padrão de 6 slots estabelecido em `HERO_STANDARD.md`:

| Slot | Nome do Equipamento de Referência | Descrição e Função de Gameplay |
| :--- | :--- | :--- |
| **Arma** | **Arco de Folha Tensa** | Arco longo confeccionado em teixo flexível do Bosque de Lúmen. Proporciona alto alcance e acertos críticos com penetração linear. |
| **Secundário** | **Aljava dos Esquecidos** | Aljava reforçada com couro cru e cerda de javali de musgo. Reduz o tempo de recarga de *Rajada* e aumenta o dano contra alvos marcados. |
| **Armadura** | **Gibão de Camuflagem Silvestre** | Conjunto leve de peitoral e grevas em couro curtido com pigmentos de musgo. Aumenta esquiva e velocidade de movimento ao receber dano de retaguarda. |
| **Acessório I** | **Olho de Raposa de Lúmen** | Amuleto de quartzo lapidado que reflete pontos vitais dos inimigos. Converte 15% do excesso de taxa crítica em dano crítico puro. |
| **Acessório II** | **Pingente do Vento Sul** | Pena fossilizada impregnada com Lúmen. Aumenta a cadência de disparos automáticos em +10%. |
| **Echo** | **A Flecha Sem Nome** | Eco cristalizado da última flecha da aljava. **Efeito Especial:** A Signature *Chuva de Flechas* aplica instantaneamente *Marca do Caçador* em todos os alvos atingidos e concede +20% de Velocidade de Ataque para a party por 6 s contra esses alvos. |

---

## 5. Evolução Visual (4 Estágios)

1. **Forma I — Base:** Arqueira ágil com capuz verde-oliva, cabelos loiros presos, gibão de couro rústico e arco de caça simples.
2. **Forma II — Desperta (Desbloqueada no Cap. III):** Detalhes folheados em ouro antigo na aljava, corda do arco resplandecendo com brilho verde-claro e runas gravadas nos protetores de braço.
3. **Forma III — Ressonante (Maestria 5):** A névoa de Lúmen envolve suas flechas; pequenas folhas espectrais desprendem-se de seus passos e a aljava projeta contornos luminescentes.
4. **Forma IV — Lendária (Maestria 10):** *A Caçadora Primordial*. Traje etéreo de caçadora com capuz sombrio onde seus olhos brilham como estrelas de Lúmen puro; o arco é talhado da madeira viva do Coração do Bosque, disparando flechas de pura luz concentrada.

---

## 6. Sinergias e Relações no Trio

- **Com Bastião (`HERO_001`):** Flecha confia cegamente que Bastião manterá a linha. Enquanto o escudo dele suporta o impacto frontal, Flecha tem o tempo e o silêncio necessários para engatilhar tiros perfurantes. Na narrativa, ela se irrita com o silêncio dele, mas reconhece que os dois são as duas metades da mesma perda: ele guarda a porta de onde ninguém voltou, e ela carrega os nomes de quem nunca chegou lá.
- **Com Íris (`HERO_003`):** Sinergia tática perfeita entre Marca e Arcano. A *Marca do Caçador* de Flecha foca a dispersão caótica das magias de Íris em feixes concentrados (*Sensível ao Lúmen*). Na convivência, Flecha é pragmática e terrena, enquanto Íris ouve vozes que não estão ali; Flecha costuma puxar Íris de volta para o presente quando os sussurros do Lúmen ameaçam afogá-la.

---

## 7. Navegação e Arquitetura do Herói

- **Kit de Combate & 6 Skills:** [`FLECHA_SKILLS.md`](../04_content/skills/FLECHA_SKILLS.md)
- **16 Passivas (Identidade + 3 Builds de 5):** [`hero_002_flecha_passives.md`](hero_002_flecha_passives.md)
- **3 Traits de Especialização:** [`hero_002_flecha_traits.md`](hero_002_flecha_traits.md)
- **Progressão de Maestria 1–10:** [`hero_002_flecha_mastery.md`](hero_002_flecha_mastery.md)
- **Padrão Arquitetural Mandatório:** [`HERO_STANDARD.md`](HERO_STANDARD.md)
