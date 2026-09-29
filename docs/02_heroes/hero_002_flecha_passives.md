---
status: DESIGN
certainty: HIPOTESE
---

# HERO_002 — Flecha: passivas e árvores de build

**Fonte de estrutura:** [HERO_STANDARD.md](../../HERO_STANDARD.md).
**Identidade e skills:** [ficha da Flecha](hero_002_flecha.md) · [skills canônicas](../04_content/skills/FLECHA_SKILLS.md).
**Escopo:** 1 passiva de identidade + 3 árvores de 5 passivas, incluindo um Capstone por árvore. Conceitos e nomes são propostas de design; números e efeitos runtime não estão aprovados.

## Estrutura

| Grupo | Passivas | Identidade |
| --- | --- | --- |
| Identidade | Instinto de Caçadora | Marca e acerto crítico. |
| A — Precisão | A1–A5 | Preparação e recompensa por críticos. |
| B — Caçada | B1–B5 | Marca e coordenação com a party. |
| C — Cadência | C1–C5 | Ritmo de ataque e continuidade entre skills. |

Cada passiva pode ter até cinco ranks. Para passivas comuns, ranks intermediários ampliam o efeito principal; ranks avançados acrescentam a interação descrita na ficha. Valores, limites e ajustes por rank ficam para BALANCE-FOUNDATION-1 e SLICE-1. A5, B5 e C5 são Capstones de nível estrutural T7 conforme HERO_STANDARD.md.

## Passiva de identidade — Instinto de Caçadora

Flecha reconhece o alvo que marcou: seus acertos contra a presa marcada têm maior consistência de crítico. A passiva reforça a mecânica da personagem sem criar recurso, marcas acumuláveis ou um segundo sistema de stacks.

**Rank 3 sugerido:** a interação com críticos passa a distinguir ataques básicos de skills, permitindo que build e loadout mudem a forma de explorar a Marca.
**Rank 5 sugerido:** um crítico contra a presa marcada fortalece o próximo disparo básico de Flecha; o bônus não pode se acumular indefinidamente.

## Build A — Precisão

**Objetivo:** preparar disparos críticos e aproveitá-los sem tornar cada ataque um crítico garantido.
**Skills que combinam:** Olho Aguçado, Flecha Perfurante e Marca do Caçador.

### A1 — Respiração Controlada

Ao manter o alvo sob mira, Flecha estabiliza o próximo disparo. Trocar de alvo ou perder a linha de tiro encerra a preparação. É uma recompensa por foco, não por inatividade prolongada.

### A2 — Ponta de Penetração

Acertos críticos reduzem parcialmente a proteção efetiva do alvo para os próximos ataques de Flecha. A interação deve usar o modelo compartilhado de penetração e não criar uma defesa paralela.

### A3 — Leitura de Abertura

Depois de atingir um alvo com Flecha Perfurante, Flecha identifica uma abertura e melhora a precisão de seu próximo acerto contra esse mesmo alvo.

### A4 — Ajuste Fino

Críticos em sequência aumentam gradualmente o valor da próxima janela de Olho Aguçado. O efeito tem limite e termina ao trocar o alvo ou encerrar a janela, evitando acúmulo permanente.

### A5 — Capstone: Disparo Perfeito

Olho Aguçado passa a preparar um disparo decisivo. Se esse disparo crítico atingir a presa marcada, ele reforça a próxima skill de Flecha equipada; não recarrega a própria skill nem cria uma cadeia automática sem limite.

## Build B — Caçada

**Objetivo:** transformar a Marca do Caçador em uma chamada clara de foco para os três heróis.
**Skills que combinam:** Marca do Caçador, Rajada e Chuva de Flechas.

### B1 — Rastro Aberto

A presa marcada fica visualmente mais legível para a party. Esse benefício é de leitura e não concede dano por si só.

### B2 — Pressão Coordenada

Quando um aliado atinge a presa marcada, a contribuição desse acerto melhora a próxima oportunidade ofensiva de Flecha contra ela. A regra não acumula efeitos por cada ataque da party sem limite.

### B3 — Alvo Persistente

Uma mudança temporária de posição ou de linha de visão não cancela imediatamente a intenção de Flecha de perseguir a presa marcada. Regras para ocultação e troca de alvo ficam para a especificação de inimigos.

### B4 — Caçada Compartilhada

Acertos de aliados durante a Marca prolongam sua utilidade até um teto definido no balanceamento. O prolongamento deve ter retorno decrescente ou limite claro para evitar duração infinita em chefes.

### B5 — Capstone: Presa da Party

Durante uma janela após aplicar a Marca, a party pode preparar uma resposta conjunta: quando Flecha usa uma skill ofensiva contra a presa, um aliado contribui com um efeito de suporte da própria build. Não copia nem repete skills completas de aliados.

## Build C — Cadência

**Objetivo:** manter Flecha ativa e fluida sem transformar velocidade de ataque em poder gratuito sem limite.
**Skills que combinam:** Rajada, Ricochete e Chuva de Flechas.

### C1 — Cordas Tensionadas

Acertos básicos consecutivos melhoram o ritmo dos disparos enquanto Flecha mantém o mesmo alvo. A sequência reinicia quando o alvo muda ou Flecha precisa reposicionar-se.

### C2 — Saque Rápido

Após usar uma skill, Flecha prepara seu próximo ataque básico mais rapidamente. O benefício não reduz cooldown de skills.

### C3 — Passo de Arqueira

Quando um inimigo pressiona a retaguarda, Flecha procura automaticamente um novo espaço de tiro. O reposicionamento não concede esquiva automática nem imunidade a dano.

### C4 — Aljava em Ordem

Acertos de Ricochete em alvos diferentes preparam uma Rajada mais fluida; acertos repetidos no mesmo alvo não acumulam o efeito. A sinergia não altera a prioridade configurada pelo jogador no Hub.

### C5 — Capstone: Ritmo Implacável

Ao terminar Rajada ou Ricochete contra uma presa marcada, Flecha encurta parte do cooldown restante da outra skill equipada, uma única vez por ativação. Não reinicia cooldown, não altera prioridade ou gatilho e não tem efeito se a outra skill já estiver pronta.

## Leitura de balanceamento e pendências

- Não foram atribuídos percentuais, durações, stacks, cooldowns ou limiares.
- “Precisão”, “proteção efetiva” e “ritmo” devem ser expressos pelos status e modificadores compartilhados; não criar atributos novos para a Flecha.
- Críticos e penetração precisam respeitar caps e a ordem de cálculo canônica.
- A passiva de identidade e os Capstones devem continuar úteis sem tornar as demais escolhas irrelevantes.
- A árvore não escolhe nem troca as duas skills equipadas durante uma expedição.
- Validar builds de Crítico, Caçada e Cadência contra inimigos comuns, elite, minichefe, boss e party abaixo/acima do equipamento esperado.

## Referências

- [Padrão Canônico dos Heróis](../../HERO_STANDARD.md)
- [Sistema de skills](../03_systems/SKILL_SYSTEM.md)
- [Sistema compartilhado de balanceamento](../06_balance/COMBAT_BALANCE_STANDARD.md)
- [Base canônica v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md)
