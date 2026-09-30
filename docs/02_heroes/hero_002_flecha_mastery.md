---
status: DESIGN
certainty: HIPOTESE
---

# HERO_002 — Flecha: Maestria 1–10

**Fonte estrutural:** [HERO_STANDARD.md](HERO_STANDARD.md), seção 11 (marcos M1 / M3 / M5 / M7 / M10).  
**Referência de formato:** [Maestria do Bastião](hero_001_bastiao_mastery.md).  
**Herói:** [ficha da Flecha](hero_002_flecha.md) · [skills](../04_content/skills/FLECHA_SKILLS.md) · [passivas](hero_002_flecha_passives.md) · [Traits](hero_002_flecha_traits.md)  
**Pré-requisito:** Hero Level 100.

> Proposta de design. Nenhum número, duração, cooldown ou quantidade abaixo está aprovado; onde o texto precisa de um valor, ele aparece como **EM ABERTO** para BALANCE-FOUNDATION-1 e SLICE-1. A Maestria não pode apagar a fraqueza de retaguarda da Flecha nem a dependência de espaço e de party.

## 1. Objetivo e filosofia

Level 1–100 responde quanto a Flecha evoluiu; Mastery 1–10 responde quanto o jogador aprendeu a caçar com ela. As recompensas refinam a Marca do Caçador, a precisão e a cadência — não criam recurso novo, stacks paralelos nem um segundo sistema de mira.

## 2. Mastery XP (MXP)

Depois do Level 100, Flecha recebe MXP por ações que expressam o papel dela:

| Ação | MXP relativo |
| --- | --- |
| concluir combate | normal |
| derrotar a presa marcada | bônus |
| aliado atingir a presa marcada (dano coordenado) | bônus |
| crítico contra Elite ou Boss marcado | bônus |
| terminar combate sem Flecha sofrer dano corpo a corpo | alto |
| derrotar Boss | alto |
| missão pessoal | muito alto |
| desafio de Maestria | muito alto |

Farmar inimigos fracos repetidamente tem retorno reduzido, como no Bastião. Valores absolutos: **EM ABERTO**.

## 3. Níveis

### M1 — Olhar de Rastreadora

No início de cada combate, a primeira aplicação da Marca do Caçador acontece mais cedo (o atraso inicial é reduzido; valor **EM ABERTO**).

Objetivo: reduzir o início lento de quem já domina a heroína, sem marcar automaticamente nem dispensar a skill.  
Visual: pena extra na aljava.

### M2 — Distância Segura

Enquanto nenhum inimigo estiver dentro do alcance corpo a corpo da Flecha, ela recebe um pequeno bônus de cadência do ataque básico. O bônus some assim que um inimigo alcança a retaguarda.

Reforça a fraqueza em vez de apagá-la: premia a party que protege a linha.

### M3 — Técnica de Mestre (escolha)

Primeiro modificador de skill. O jogador escolhe um estilo; a troca ocorre no Hub. Nenhuma opção deve ser universalmente melhor.

- **M3-A — Mira Estável (Crítico):** Olho Aguçado — cada crítico durante a janela reduz levemente o cooldown restante de Flecha Perfurante, com limite por ativação.
- **M3-B — Rastro Longo (Marca):** Marca do Caçador — quando um aliado derrota a presa marcada, a Marca é transferida ao próximo alvo elegível mesmo antes do rank 5 da skill; nos ranks que já transferem, a nova marca começa com a janela útil completa.
- **M3-C — Corda Solta (Velocidade):** Ricochete — cada alvo distinto atingido reduz levemente o cooldown restante de Rajada, com limite por ativação.

### M4 — Leitura de Terreno

Quando um inimigo se aproxima da retaguarda, Flecha exibe um indicador discreto e o próximo ataque básico prioriza esse inimigo. Cooldown interno **EM ABERTO**.

Dá resposta à ameaça sem torná-la imune; não cria recuo, esquiva nem controle.

### M5 — Ressonante (marco)

Flecha alcança **FORMA III — RESSONANTE**.

**Evolução visual:** veios de Lúmen no arco; a Marca ganha um símbolo luminoso sobre a presa; críticos deixam rastro breve; a ponta das flechas brilha durante Olho Aguçado. A silhueta de arqueira encapuzada permanece intacta.

**Recompensa mecânica — Presa Ressonante:** quando a presa marcada acumula acertos de dois heróis diferentes da party dentro de uma janela curta, ela fica Ressonante por pouco tempo. Durante esse estado, críticos de Flecha contra ela prolongam a Marca por um limite fixo. Duração, limite de extensão e cooldown: **EM ABERTO**.

Premia a coordenação que define a Flecha; não é dano bruto adicional nem funciona sem party.

### M6 — Aljava Organizada

Após usar uma skill, o primeiro ataque básico seguinte contra a presa marcada recebe um pequeno reforço. Não acumula entre skills.

### M7 — Doutrina (escolha)

Segundo modificador avançado; uma Doutrina ativa por vez, troca no Hub.

- **Doutrina — Precisão:** um crítico contra a presa marcada durante Olho Aguçado faz a próxima Flecha Perfurante atravessar proteção temporária mesmo sem o rank 4 da skill. Uma vez por janela.
- **Doutrina — Matilha:** enquanto a presa marcada for atingida por aliados, cada acerto de aliado reduz levemente o cooldown restante da Marca do Caçador, com limite por combate ou janela.
- **Doutrina — Vento:** se Rajada e Ricochete forem usados em sequência curta, a segunda skill recebe cadência extra. Cooldown interno **EM ABERTO**.

### M8 — Echo alternativo (proposta)

Segue a mesma regra do Bastião: **não existe slot extra de Echo**. Os conceitos abaixo seriam Ecos alternativos para o slot Echo único, se aprovados no catálogo do [Sistema de Ecos](../03_systems/ECHO_SYSTEM.md). Nada aqui amplia o equipamento do slice.

- **Eco — Pegada Fresca:** a primeira presa marcada de cada combate revela uma fraqueza temporária para toda a party.
- **Eco — Última Flecha:** derrotar a presa marcada com um crítico devolve parte do cooldown da skill usada.
- **Eco — Vento Norte:** Ricochete pode saltar uma vez de volta para a presa marcada.

### M9 — Instinto Refinado

A passiva de identidade [Instinto de Caçadora](hero_002_flecha_passives.md#passiva-de-identidade--instinto-de-caçadora) evolui: o reforço do próximo disparo básico após crítico contra a presa marcada também pode ser aproveitado pela primeira skill ofensiva usada em seguida. Mantém o limite de não acumular indefinidamente.

### M10 — A Última Trilha (marco)

Desbloqueia **FORMA IV — LENDÁRIA** e o **Signature Modifier**.

**Evolução visual:** capa com padrões completos de Lúmen; arco com marcas das caçadas; flechas deixam rastro contínuo; a Marca projeta um círculo breve no chão; Chuva de Flechas ganha uma salva visualmente distinta. A Flecha continua reconhecível instantaneamente.

**Signature Modifier — Nenhuma Presa Escapa:** Chuva de Flechas passa a marcar, ao terminar, o inimigo mais atingido pela salva (se não houver presa marcada) ou renova a Marca atual. Aliados que atingirem essa presa logo depois recebem uma abertura curta, na mesma família da abertura do rank 3 da Signature, sem acumular com ela.

M10 não significa invencibilidade: posicionamento, proteção da party e escolha de alvo continuam decisivos.

## 4. Desafios de Maestria

- **M3 — Olho de Águia:** derrotar um número de presas marcadas (quantidade **EM ABERTO**).
- **M5 — Caçada em Grupo:** acumular dano coordenado de aliados contra presas marcadas (valor por telemetria).
- **M7 — Nenhum Passo Atrás:** derrotar uma Elite ou Boss sem que Flecha sofra dano corpo a corpo.
- **M10 — A Última Trilha:** desafio exclusivo ligado à lore pessoal — rastrear e abater uma presa especial através da névoa do Apagamento, com a party protegendo a retaguarda. Depende de LORE/missões pessoais.

## 5. Progressão visual

| Forma | Origem |
| --- | --- |
| I — Base | Lv. 1 |
| II — Desperta | campanha pessoal (não vem da Maestria) |
| III — Ressonante | Mastery 5 |
| IV — Lendária | Mastery 10 |

## 6. Resumo

| Mastery | Recompensa |
| --- | --- |
| M1 | Marca inicial mais cedo |
| M2 | cadência com retaguarda livre |
| M3 | modificador de skill (escolha por build) |
| M4 | resposta a ameaça na retaguarda |
| M5 | Forma Ressonante + Presa Ressonante |
| M6 | reforço pós-skill contra a presa |
| M7 | Doutrina |
| M8 | Echo alternativo para o slot único (proposta) |
| M9 | Instinto de Caçadora evoluído |
| M10 | Forma Lendária + Signature Modifier |

## 7. Builds após Maestria

| Build | Combinação sugerida |
| --- | --- |
| Crítico | Passivas de Precisão + Ponto de Mira + M3-A Mira Estável + Doutrina Precisão + Eco Última Flecha |
| Marca | Passivas de Caçada + Caçada Coordenada + M3-B Rastro Longo + Doutrina Matilha + Eco Pegada Fresca |
| Velocidade | Passivas de Cadência + Aljava em Movimento + M3-C Corda Solta + Doutrina Vento + Eco Vento Norte |

## 8. Pendências e validação

- Valores, janelas, cooldowns e limites de todos os níveis.
- Custo de MXP por nível e curva de retorno reduzido.
- Conferir conflitos com passivas A/B/C e Capstones, principalmente M3-B × rank 5 da Marca e M9 × Instinto de Caçadora.
- Visual das Formas III/IV depende de contrato de arte próprio; não altera o Golden/contrato atual.
- Desafio M10 e Forma II dependem da lore pessoal e das missões pessoais (pendentes).
