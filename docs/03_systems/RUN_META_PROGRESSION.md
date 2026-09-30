---
status: DESIGN
---

# Run e meta-progressão

**Versão:** rascunho inicial da EXP-DESIGN-1  
**Estado:** expedições finitas e as regras centrais de persistência listadas abaixo foram **DECIDIDAS**; detalhes do comportamento offline durante a expedição e alguns estados secundários seguem **EM ABERTO**. A primeira fatia não terá um estado separado de pausa/retomada.  
**Autoridade:** regra futura de persistência entre expedições. Este rascunho não altera save, runtime, economia ou balanceamento.

## Problema de design

O jogo combina combate/loot de curto prazo com progressão de longo prazo. Precisamos deixar claro o que uma expedição muda agora, o que continua para a próxima e o que acontece se o jogador sair, perder ou retornar ao Refúgio. Sem essa fronteira, reward, offline e save podem prometer resultados incompatíveis.

## Separação recomendada

- **Run/expedição:** estado de uma jornada em andamento, como fase atual, encontro e escolhas temporárias. Esta lista é ilustrativa, não uma decisão de schema.
- **Meta-progressão:** estado que influencia jornadas futuras, como conteúdo desbloqueado ou serviços persistentes. Os exemplos não aprovam sistema específico.

**DECIDIDO por delegação explícita de Rafael em 2026-09-28:** todo dado novo de gameplay deve declarar seu escopo de duração: apenas encontro, expedição atual, persistente entre expedições ou derivado/calculado.

## Matriz de duração a preencher

| Dado/decisão | Escopo provável | Regra atual |
|---|---|---|
| Fase e encontro em andamento | Expedição | **DECIDIDO:** alcançar o objetivo, sofrer derrota ou retornar voluntariamente encerra a expedição e retorna ao Hub. A primeira fatia não terá estado separado de pausa/retomada; sair/deixar o app em segundo plano será tratado pelas regras de progresso offline, cujos detalhes seguem **EM ABERTO**. |
| Fases já concluídas | Persistente entre expedições | **DECIDIDO por Rafael em 2026-09-28:** uma fase concluída permanece concluída mesmo após retorno voluntário ao Hub. |
| Fase atual ainda não concluída | Expedição | **DECIDIDO por Rafael em 2026-09-28:** se o jogador retornar ao Hub antes de concluir a fase atual, ela recomeça do início na próxima expedição. As recompensas obtidas são conservadas conforme as regras abaixo. |
| HP da party | Entre expedições | **DECIDIDO por Rafael em 2026-09-28:** recupera totalmente de forma automática no Hub após cada expedição, seja por objetivo alcançado, derrota ou retorno voluntário. Persistência de outras condições segue **EM ABERTO**. |
| Loot encontrado | Persistente entre expedições | **DECIDIDO por Rafael em 2026-09-28:** itens obtidos ficam salvos imediatamente e não são perdidos em derrota nem em retorno voluntário. |
| XP e ouro | Persistente entre expedições | **DECIDIDO por Rafael em 2026-09-28:** XP e ouro ganhos ficam salvos e não são perdidos em derrota nem em retorno voluntário. Valores e regras de concessão continuam sujeitos ao design/economia. |
| Skills ativas equipadas | Preparação → expedição | **DECIDIDO:** duas skills equipadas e sua prioridade/gatilhos são configurados no Hub antes da expedição e ficam fixos até ela terminar. Ver [Sistema de skills](SKILL_SYSTEM.md). |
| Skills desbloqueadas e ranks | Persistente por herói | **DECIDIDO:** desbloqueios e melhorias são adquiridos em marcos de nível do herói e escolhidos no Hub após a expedição. Tier eligibility e efeitos concretos permanecem **EM ABERTO**; ver [Sistema de skills](SKILL_SYSTEM.md) e [HERO_STANDARD.md](../02_heroes/HERO_STANDARD.md). |
| Inventário/equipamento | Persistente entre expedições | **DECIDIDO:** itens obtidos ficam salvos mesmo em derrota ou retorno voluntário. O loadout fica travado durante a expedição; itens encontrados são guardados e podem ser equipados no Hub após seu encerramento. Esta regra é alvo do design pós-MVP, não descreve o comportamento atual do MVP. |
| Progressão individual do herói | Persistente por herói | XP/nível e escolhas de skill pertencem ao herói e continuam após o fim da expedição. O [padrão canônico](../02_heroes/HERO_STANDARD.md) define a estrutura de níveis e Mastery; aquisição/ritmo de Mastery ainda precisa de reconciliação com a progressão geral. |
| Conta/Hub | Persistente entre expedições | Desbloqueios globais e serviços pertencem à meta-progressão; consultar o [Hub](../05_hub/INDEX.md), a [Árvore dos Ecos](GLOBAL_RESONANCE_TREE.md) e os gates de artesãos/economia. |
| Árvore global | Persistente entre expedições | **DECIDIDO para design:** catálogo de 30 nós e dependências aprovados em `TREE-1`. Valores, serviços detalhados, balanceamento, interface e implementação continuam em fases próprias; não há runtime. |
| Ecos | Item opcional persistente | **DECIDIDO:** o `SLICE-1` terá um Echo funcional como recompensa determinística; ele fica no inventário e pode ser equipado/trocado no Hub. Função/limites no [Sistema de Ecos](ECHO_SYSTEM.md); ficha e runtime seguem para `ECHO-1`. |
| Progresso offline | Entre sessões | **DECIDIDO por delegação de Rafael:** calcular progresso da expedição atual até um teto de tempo ausente, até alcançar o objetivo ou ocorrer derrota. Encerrar e registrar o resultado uma única vez no Hub; não iniciar outra expedição automaticamente. Fórmula, valor do teto, resolução de combate e apresentação do resumo continuam **EM ABERTO**. |

## Regras recomendadas aprovadas por delegação de Rafael

- **Fim e derrota:** a expedição termina ao cumprir o objetivo, quando os três heróis ativos ficam incapazes de lutar, ou quando o jogador retorna voluntariamente ao Hub. Não há cronômetro de derrota; a duração decorre do objetivo escolhido.
- **Encerramento limpo:** ao voltar ao Hub, recuperar todo o HP e remover efeitos temporários de combate da party (buffs, debuffs e condições). Não criar ferimentos persistentes neste escopo.
- **Gravação:** salvar XP, ouro e cada item obtido ao recebê-los; nunca removê-los por derrota ou retirada voluntária. Fases completas ficam registradas; a fase atual incompleta reinicia do começo na próxima expedição.
- **Expedição offline:** aplicar um teto de tempo ausente, com cálculo do progresso da expedição atual até atingir o objetivo ou derrota. Dentro do teto, não aplicar penalidade adicional de eficiência. Ao terminar, salvar o resultado uma vez e voltar ao Hub; nunca começar outra expedição automaticamente. O valor do teto, a resolução do combate e as recompensas continuam para a etapa de pacing/economia.
- **Duração-alvo:** não estabelecer um limite de minutos por expedição. Cada expedição é delimitada pelo objetivo selecionado; medir duração ativa e offline em playtests e ajustar objetivos/conteúdo na etapa de pacing.

Estas regras fecham a estrutura funcional de DESIGN-1, não valores de balanceamento nem comportamento já implementado no MVP.

## Regras de projeto adotadas

1. **DECIDIDO:** comunicar quando uma escolha é temporária ou permanente.
2. **DECIDIDO:** não apagar progresso persistente por derrota; perdas futuras só entram com decisão explícita e comunicação clara.
3. **DECIDIDO:** não criar reset/prestige, moeda ou material sem uma função, fonte e saída definidas.
4. **DECIDIDO:** documentar fontes, saídas, persistência e método de simulação antes de fechar valores de economia.
5. **DECIDIDO:** calcular progresso offline a partir do estado salvo, sem simulação contínua enquanto o app está fechado; conceder o resultado uma única vez e testar migração do save antes de implementar.

Estas regras orientam o design futuro; não alteram o runtime nem aprovam números de economia.

## Decisões ainda encaminhadas a outras fases

- Fórmula, teto numérico, resolução de combate, recompensas e UI do progresso offline — ECON-1/SLICE-1.
- Fontes, custos e desbloqueios da progressão global/serviços — TREE-1/CRAFT-1/ECON-1.
- Aquisição e ritmo de Mastery — HERO-STD/ECON-1.

## Critério para fechar a fronteira

Para cada estado listado, especificar duração, evento de gravação, resultado em vitória/derrota/saída, comportamento offline e apresentação na UI. Registrar escolhas aprovadas na fonte autoritativa da área; o [AUDITORIA.md](../00_project/AUDITORIA.md) resume as decisões delegadas e aponta para essas fontes. Encaminhar schemas ou implementação apenas pelos gates apropriados.
