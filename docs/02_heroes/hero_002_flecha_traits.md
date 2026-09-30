---
status: DESIGN
certainty: HIPOTESE
---

# HERO_002 — Flecha: Traits de especialização

**Fonte estrutural:** [HERO_STANDARD.md](HERO_STANDARD.md), seção 6.  
**Herói:** [ficha da Flecha](hero_002_flecha.md)  
**Skills:** [catálogo canônico](../04_content/skills/FLECHA_SKILLS.md)  
**Passivas:** [árvores de build](hero_002_flecha_passives.md)  
**Escopo:** três propostas recomendadas, uma para cada build. O jogador equipa uma por vez; Traits alteram regras, não adicionam apenas bônus percentuais.

> Estas propostas avançam o design de HERO-002 sem fixar números ou declarar efeitos implementados. Gatilhos automáticos e seleção de alvo devem ser validados com o sistema de combate e no SLICE-1.

## Trait — Ponto de Mira

**Build:** Crítico  
**Skills que combina:** Olho Aguçado + Flecha Perfurante  
**Regra proposta:** ao ativar Olho Aguçado, Flecha fixa a mira no alvo que a skill escolheu. Seus ataques básicos mantêm esse foco durante a janela da skill, mesmo se a regra geral de seleção de alvo indicar outra presa.

Se o alvo morrer ou deixar de ser elegível, Flecha volta à seleção automática normal. O Trait não prolonga Olho Aguçado, não garante críticos e não troca o alvo da Marca do Caçador.

**Identidade:** especializa a janela de precisão em eliminar um alvo prioritário.  
**Trade-off:** oferece menos valor quando há vários inimigos frágeis que precisam ser atingidos rapidamente.

## Trait — Caçada Coordenada

**Build:** Marca  
**Skills que combina:** Marca do Caçador + Rajada  
**Regra proposta:** quando um aliado atinge a presa marcada, o próximo ataque básico de Flecha prioriza essa presa, desde que ela ainda esteja viva e elegível.

O sinal não acumula: vários acertos de aliados antes do próximo ataque básico continuam gerando apenas uma prioridade. Se a presa cair antes do disparo, a seleção automática normal é retomada.

**Identidade:** transforma a Marca em uma chamada de foco legível para a party e coordena ataques sem repetir skills de aliados.  
**Trade-off:** depende de aliados capazes de atingir a presa marcada e tem pouco efeito quando Flecha luta sem suporte ativo.

## Trait — Aljava em Movimento

**Build:** Velocidade  
**Skills que combina:** Rajada + Ricochete  
**Regra proposta:** quando Ricochete atinge mais de um inimigo na mesma ativação, o próximo ataque básico de Flecha prioriza outro alvo atingido pela sequência, se ainda estiver vivo e elegível. Caso não exista outro alvo válido, a seleção automática normal é usada.

O Trait não adiciona saltos ao Ricochete, não aumenta velocidade de ataque e não cria uma fila de alvos persistente.

**Identidade:** mantém Flecha alternando pressão entre inimigos agrupados em vez de concentrar todos os disparos no mesmo alvo.  
**Trade-off:** perde valor contra um único inimigo ou quando os alvos atingidos deixam de ser válidos antes do disparo.

## Regras compartilhadas e validação

- Um único Trait fica ativo por vez; a troca ocorre fora do combate no Hub, conforme a estrutura aprovada para especialização.
- Os três Traits usam a escolha automática de alvos existente no conceito de combate e não adicionam controles durante a luta.
- Prioridades são efeitos de uma única ação seguinte; não acumulam nem alteram a prioridade escolhida para ativar skills no Hub.
- Validar legibilidade, frequência, conflitos com passivas/skills e utilidade contra grupos, elites e chefes durante BALANCE-FOUNDATION-1 e SLICE-1.
- Cooldowns, duração de janelas, critérios exatos de elegibilidade e impacto numérico permanecem em aberto.

## Referências

- [Padrão Canônico dos Heróis](HERO_STANDARD.md)
- [Sistema de skills](../03_systems/SKILL_SYSTEM.md)
- [Padrão compartilhado de balanceamento](../06_balance/v1/01_STATUS_E_COMBATE.md)
