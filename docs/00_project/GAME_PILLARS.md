---
status: DESIGN
---

# Pilares de design — Pocket Hero

**Versão:** rascunho inicial da EXP-DESIGN-1  
**Autoridade:** proposta de princípios para orientar decisões. Só os pontos rotulados `DECIDIDO` vêm das fontes vigentes; recomendações não são aprovação de produto.

## Identidade já registrada

- **DECIDIDO:** Pocket Hero é um RPG incremental/idle de combate automático, loot e builds, com fantasia sombria original e Android como plataforma inicial em um aplicativo normal. Veja o [resumo do projeto](../POCKET_HERO_PROJECT_BRIEF.md) e o [guia de IA](../../documents/AI_PROJECT_GUIDE.md).
- **DECIDIDO:** referências de gênero podem orientar princípios, mas arte, nomes, mapas, interface, textos, lore e balanceamento devem ser originais.
- **DECIDIDO:** não haverá vantagem de poder paga. Overlay, backend, contas, multiplayer, cloud save e monetização estão fora do MVP homologado.
- **DECIDIDO por delegação explícita de Rafael em 2026-09-28:** o jogador melhora resultados por decisões e compreensão do sistema, sem depender de cliques repetitivos.

## Pilares em discussão

Os itens abaixo sintetizam princípios recorrentes dos guias. Os pilares 1–5 têm decisões de direção registradas; detalhes de progressão do pilar 5 seguem em aberto. O pilar 6 reflete decisões de identidade já registradas.

### 1. Preparar antes; combater no automático

**DECIDIDO por Rafael em 2026-09-28:** antes da expedição, o jogador define party, equipamentos e skills. Depois que a batalha começa, o combate segue sozinho; não há comandos diretos durante a luta.

As regras já escolhidas para slots, loadout, desbloqueio, evolução e ativação automática estão na fonte autoritativa, [Sistema de skills](../03_systems/SKILL_SYSTEM.md). O jogador pode encerrar voluntariamente uma expedição e retorna ao Hub para preparar a próxima; o [Loop central](CORE_LOOP.md) registra o fluxo.

**Ainda em aberto:** distribuição das skills nos tiers, conjuntos de escolha por marco e valores/gatilhos/cooldowns concretos.

**Sinal de qualidade:** a preparação muda o resultado de forma compreensível, e a luta pode ser acompanhada sem exigir ação repetitiva.

### 2. Progresso que o jogador consegue ler

**DECIDIDO por Rafael em 2026-09-28:** o jogo recomenda um objetivo/marco, e o jogador pode fixar outro objetivo para acompanhar.

**DECIDIDO por Rafael em 2026-09-28:** junto do objetivo, mostrar o progresso, a recompensa/desbloqueio esperado e uma sugestão de próximo passo.

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** atualizar sugestões em marcos significativos (mudança de fase, recompensa/desbloqueio, vitória ou parede), não a cada ação de combate. Baseá-las no próximo conteúdo já disponível e explicar a relação entre a sugestão e o objetivo do jogador; nunca trocar o objetivo escolhido automaticamente.

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** mostrar o próximo marco útil e explicar sua importância; apresentar sistemas e menus gradualmente conforme o jogador aprende os anteriores (*unfolding*).

**DECIDIDO por Rafael em 2026-09-28:** o jogador pode acompanhar o objetivo a qualquer momento, mas só pode trocar o objetivo da expedição no Hub.

**Sinal de qualidade:** o jogador identifica o objetivo recomendado ou escolhido, seu progresso e uma ação plausível para avançar.

### 3. Presença ajuda; ausência não pune

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** o progresso offline continua até um teto de tempo ausente. Com o app aberto, o jogador pode revisar a preparação; não comanda as batalhas.

**Sinal de qualidade:** fechar o app não apaga o progresso; ao retornar, o jogador entende o que avançou. O modelo não exige manter o app aberto.

**Ainda em aberto:** valor do teto e cálculo pertencem à etapa de pacing/economia. Não haverá penalidade adicional de eficiência dentro do teto.

### 4. Paredes abrem caminhos

**DECIDIDO por Rafael em 2026-09-28:** uma parede deve admitir várias rotas viáveis. O jogador pode rever a party, o equipamento e as skills ativas escolhidas antes da expedição. Progresso não deve depender somente de um drop aleatório.

**Sinal de qualidade:** preparações diferentes conseguem avançar; não é necessário comandar ou trocar skills durante a batalha.

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** o slice deve demonstrar pelo menos duas rotas viáveis por meio de party, skills e equipamentos; permitir revisitar conteúdo concluído para ganhar XP/ouro e buscar equipamento; e oferecer recompensas determinísticas por primeira vitória/marco, para que nenhum drop aleatório específico seja obrigatório. Nível/atributos podem ajudar, mas não devem ser a única resposta. As sugestões do pilar 2 devem apontar preparação ou conteúdo útil sem montar a build pelo jogador. Não haverá ramificação de mapa no primeiro slice; rotas alternativas de campanha podem ser avaliadas após validar essas escolhas de preparação.

### 5. Crescimento muda possibilidades

**DECIDIDO por Rafael em 2026-09-28:** a progressão deve incluir tanto melhorias numéricas quanto desbloqueios que abram novas possibilidades de jogo, como sinergias, escolhas ou mecânicas.

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** upgrades e desbloqueios devem abrir sinergias, decisões, automação ou acesso a conteúdo; aumentos numéricos isolados precisam justificar sua função.

**Sinal de qualidade:** o jogador percebe uma nova opção ou estratégia, e não apenas um número maior.

**Ainda em aberto:** ritmo, distribuição e combinação entre melhorias numéricas e desbloqueios qualitativos.

### 6. Clareza mobile com identidade original

**DECIDIDO:** manter identidade visual e conteúdo próprios, com combate legível em tela pequena.

**Sinal de qualidade:** ameaças, escolhas e feedback essenciais continuam claros no telefone sem copiar linguagem visual distintiva de terceiros.

## Limites de uso

- Estes pilares não autorizam por si só mecânicas, fórmulas, raridades, monetização ou roadmap não registrados. As decisões aprovadas estão nas fontes de sistema e no [AUDITORIA.md](AUDITORIA.md).
- Não introduzir prestígio/ascensão, moeda, automação ou sistema apenas porque um pilar parece sugeri-lo: documentar sua função e seguir o gate correspondente. Os Fragmentos de Ressonância, por exemplo, foram aprovados especificamente para a Árvore dos Ecos com fonte/sink previstos; seus valores ficam para ECON-1.
- Para princípios incrementais detalhados, consulte o [guia resumido](INCREMENTAL_DESIGN_GUIDE.md) e o [guia completo](../../documents/GUIA_DESIGN_INCREMENTAL_POCKET_HERO.md). Eles são recomendações, não fontes runtime.

## Decisões em aberto

1. Como distribuir e ritmar melhorias numéricas e desbloqueios de novas possibilidades? Os princípios estão definidos; números e distribuição pertencem a `ECON-1`/balanceamento.

O pilar 3 está decidido em nível de direção; seus parâmetros numéricos pertencem à etapa de balanceamento.

O documento permanece `DESIGN` até que números, UI mobile e detalhes encaminhados às fases correspondentes sejam validados; as direções aprovadas por delegação estão registradas no [AUDITORIA.md](AUDITORIA.md).
