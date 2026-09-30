---
status: DESIGN
certainty: HIPOTESE
---

# Flecha — skills canônicas

**Herói:** [HERO_002 — Flecha](../../02_heroes/hero_002_flecha.md)
**Fonte dos nomes e do conjunto de seis:** [HERO_STANDARD.md](../../02_heroes/HERO_STANDARD.md), seção 14.
**Escopo:** intenção de gameplay e evolução qualitativa dos ranks. Esta ficha não aprova números, cooldowns, gatilhos nem implementação.

## Identidade de combate

Flecha é uma atiradora de retaguarda que prepara um alvo com a **Marca do Caçador** e transforma precisão, críticos e sequência de disparos em pressão sustentada. Seu diferencial é fazer a party convergir para uma presa sem depender de comandos durante o combate.

O combate é automático. Skills escolhem alvos segundo regras próprias; a prioridade entre as duas skills equipadas é configurada no Hub. Gatilhos, limites ajustáveis, cooldowns e seleção exata de alvos permanecem **EM ABERTO**, conforme o [Sistema de skills](../../03_systems/SKILL_SYSTEM.md).

## Conjunto canônico

Os nomes abaixo substituem como catálogo vigente os cinco conceitos antigos. Seus IDs antigos ficam preservados e marcados **DEPRECATED** no [registro central](../../CONTENT_REGISTRY.md); não são reaproveitados nem associados por semelhança.

| ID | Skill | Tipo | Papel |
| --- | --- | --- | --- |
| SKILL_FLE_006 | Marca do Caçador | Normal | Preparar um alvo para dano coordenado. |
| SKILL_FLE_007 | Flecha Perfurante | Normal | Atingir uma linha de inimigos e explorar aberturas. |
| SKILL_FLE_008 | Olho Aguçado | Normal | Criar uma janela de precisão e crítico. |
| SKILL_FLE_009 | Rajada | Normal | Concentrar disparos rápidos em um alvo. |
| SKILL_FLE_010 | Ricochete | Normal | Distribuir pressão entre inimigos agrupados. |
| SKILL_FLE_011 | Chuva de Flechas | Signature | Desferir uma sequência ampla, com foco adicional na presa marcada. |

## Skills normais

### SKILL_FLE_006 — Marca do Caçador

**Intenção:** Flecha identifica uma presa e aplica uma marca visível. A marca abre oportunidades para Flecha e aliados, dando à party um alvo comum. Não acumula marcas por si só; número de alvos, duração e reaplicação ficam **EM ABERTO**.

**Evolução sugerida dos ranks:**

1. Marca um alvo escolhido automaticamente pela regra de prioridade da skill.
2. Aumenta a janela útil da marca.
3. Melhora a interação dos ataques de Flecha contra o alvo marcado.
4. Permite que uma interação da party prolongue ou reforce a oportunidade, sem exigir outro recurso.
5. Ao derrotar a presa marcada, transfere a marca para o próximo alvo elegível.

### SKILL_FLE_007 — Flecha Perfurante

**Intenção:** Disparo preciso que atravessa inimigos alinhados. Responde a formações estreitas e a alvos cuja defesa tenha sido aberta por Bastião ou Íris.

**Evolução sugerida dos ranks:**

1. A flecha atravessa mais de um alvo alinhado.
2. Aumenta a capacidade de atravessar a formação.
3. Atingir uma presa marcada melhora o impacto do disparo.
4. O disparo ganha uma propriedade de perfuração contra proteção temporária.
5. Atingir a presa marcada no fim da trajetória cria uma segunda oportunidade de disparo, sujeita a limite de ativação.

### SKILL_FLE_008 — Olho Aguçado

**Intenção:** Flecha mede uma abertura e concentra sua mira. Durante a janela criada pela skill, seus disparos favorecem acertos críticos; contra a presa marcada, a recompensa de precisão é maior. O bônus exato e sua duração são **EM ABERTO**.

**Evolução sugerida dos ranks:**

1. Concede uma janela curta de precisão.
2. Prolonga a janela ou amplia a quantidade de disparos beneficiados.
3. Aumenta a consistência crítica contra a presa marcada.
4. Um crítico durante a janela estende parte do benefício.
5. Concluir a janela com um acerto crítico fortalece a próxima skill ofensiva de Flecha, sem criar ativação infinita.

### SKILL_FLE_009 — Rajada

**Intenção:** Sequência de disparos concentrados. É a principal forma de converter a preparação da Marca em pressão contínua contra um alvo prioritário; a quantidade de flechas, intervalo e chance de crítico não estão definidos.

**Evolução sugerida dos ranks:**

1. Dispara uma sequência curta contra o alvo escolhido automaticamente.
2. Aumenta a sequência ou melhora seu ritmo.
3. Disparos contra a presa marcada ganham uma interação de crítico.
4. Acertos consecutivos reforçam o último disparo da sequência.
5. Se a sequência atingir a presa marcada, o último disparo prolonga a oportunidade de dano coordenado.

### SKILL_FLE_010 — Ricochete

**Intenção:** Uma flecha salta entre alvos próximos, favorecendo grupos sem substituir a especialidade de foco da Rajada. Prioridade dos saltos, limite de alvos e redução de dano por salto são **EM ABERTO**.

**Evolução sugerida dos ranks:**

1. A flecha pode atingir alvos adicionais próximos.
2. Amplia o alcance de salto entre alvos.
3. Um salto que alcança a presa marcada ganha precisão.
4. Acertar alvos distintos melhora o próximo ricochete da sequência.
5. A sequência termina com um disparo concentrado se alcançar a presa marcada.

## Signature — SKILL_FLE_011 — Chuva de Flechas

**Intenção:** Flecha cobre a área de combate com uma salva coordenada e reserva o impacto mais preciso para a presa marcada, quando houver uma. É a expressão máxima de preparação do alvo seguida por pressão ofensiva. A assinatura não deve ser apenas dano em área maior.

**Ranks da Signature:**

1. Executa a salva ampla e dá foco adicional à presa marcada.
2. Amplia uma propriedade funcional da salva — cobertura, sequência ou interação com a marca; escolher na validação de design.
3. Acertos contra a presa marcada deixam uma abertura curta para a party, com efeito e duração a validar.

## Builds de referência — recomendadas

São combinações iniciais para orientar passivas e Traits; não são loadouts obrigatórios. Cada herói equipa no máximo duas skills por expedição, e a Signature compete por um desses slots.

| Build | Foco | Par inicial recomendado |
| --- | --- | --- |
| Crítico | Criar janelas e converter precisão em críticos. | Olho Aguçado + Flecha Perfurante |
| Marca | Maximizar o tempo e a colaboração sobre uma presa. | Marca do Caçador + Rajada |
| Velocidade | Manter pressão e alternar alvos com agilidade. | Rajada + Ricochete |

Chuva de Flechas pode substituir uma das duas skills quando estiver desbloqueada. As passivas estão em [hero_002_flecha_passives.md](../../02_heroes/hero_002_flecha_passives.md); as propostas de Trait estão em [hero_002_flecha_traits.md](../../02_heroes/hero_002_flecha_traits.md). Sinergias de equipamento/Echo ainda precisam de ficha própria.

## Pendências de design

- Distribuição das seis skills pelos tiers de HERO_STANDARD.md.
- Gatilhos automáticos, limites configuráveis e regras detalhadas de alvo.
- Cooldowns, duração, quantidade de disparos, alcance e valores por rank.
- Regra exata de acerto crítico e interação entre Marca, Olho Aguçado e skills.
- Validar os modificadores de skill da [Mastery 1–10](../../02_heroes/hero_002_flecha_mastery.md).
- Integração das skills com as builds, equipamentos, Echo e missões pessoais.
- Revisão contra o combate automático e validação em SLICE-1.

## Histórico preservado

Os conceitos anteriores e suas descrições permanecem em [FLECHA_SKILLS_LEGADO.md](../../../arquivados/FLECHA_SKILLS_LEGADO.md), com IDs antigos marcados como DEPRECATED. A ficha histórica não deve orientar conteúdo novo.
