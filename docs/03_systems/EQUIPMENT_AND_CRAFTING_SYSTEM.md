---
status: DESIGN
source: "[1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx](../../documents/1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx)"
---

# Equipamentos e artesãos da cidade

> **Fonte e escopo:** Esta é uma transcrição estruturada da proposta v0.1. O conteúdo é DESIGN/HIPÓTESE, não altera slots, raridades, economia ou runtime atuais. A palavra MVP no original se refere ao protótipo mínimo do sistema de crafting e não reabre o MVP do Pocket Hero já concluído.
> **Documento original:** [1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx](../../documents/1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx). A conversão preserva texto e tabelas; elementos visuais do Word, se houver, continuam disponíveis apenas no DOCX.

## Decisões de base aprovadas por delegação de Rafael

- **DECIDIDO em 2026-09-28:** equipamento é preparação persistente. O jogador compara e altera loadout somente no Hub; durante a expedição ele fica travado, e drops vão para o inventário sem substituir ou destruir automaticamente peças equipadas.
- **DECIDIDO em 2026-09-28:** aquisição combina drops e recompensas determinísticas de marcos. Uma build não pode depender de obter um item aleatório específico; o item novo permanece guardado até o jogador escolher equipá-lo.
- **DECIDIDO em 2026-09-28:** manter as quatro raridades existentes no primeiro slice. Raridades adicionais, Item Power e affixes avançados só entram após reconciliação e simulação em `ITEM-1`.
- **DECIDIDO em 2026-09-28:** o Ferreiro é o primeiro serviço de equipamento: oferece desmontagem e um serviço de melhoria controlada. Desmontar exige confirmação explícita e exibe o resultado; itens favoritos/protegidos não podem ser desmontados. Reforja aleatória, fixação de affix, ascensão e crafting livre ficam para depois do slice.
- **DECIDIDO em 2026-09-28:** para testar o Ferreiro, usar inicialmente um material de salvamento (`Sucata`) obtido ao desmontar equipamento e consumido na melhoria. Manter ouro como custo secundário quando os valores forem definidos; não introduzir outras famílias de materiais no slice.
- **DECIDIDO em 2026-09-28:** a abertura dos artesãos é gradual e persistente na conta/Hub. O Ferreiro vem primeiro; Alquimista e Ourives entram conforme suas funções estiverem sustentadas por conteúdo e economia. A Gravadora de Ecos só abre junto do sistema de Echo decidido abaixo.

Essas decisões são de arquitetura do design. Valores, schema runtime, quantidade de cada slot no primeiro slice, custos e tabelas de drop continuam em aberto para `ITEM-1`/`ECON-1`.

## CRAFT-1 — escopo e sequência aprovados

**Status:** `APPROVED` para arquitetura e ordem dos serviços em 2026-09-28. Isso define o plano pós-MVP; não confirma NPCs, menus, receitas ou implementação existentes.

### Ordem de abertura

| Ordem | Artesão/serviço | Quando fica disponível | Limite da primeira entrega |
| --- | --- | --- | --- |
| 1 | **Ferreiro** | Primeiro artesão restaurado pelo Ramo da Oficina (`TREE_OFI_001`). Desmontagem e aprimoramento abrem pelos nós `TREE_OFI_002` e `TREE_OFI_003`. | Desmontagem com confirmação e proteção de favoritos; um caminho controlado de aprimoramento. Sem reforja, auto-desmontagem ou fabricação livre no slice. |
| 2 | **Gravadora de Ecos** | Junto da primeira recompensa Echo e da introdução do sistema (`TREE_MEM_001`/`TREE_MEM_002`, `ECHO-1`). Precisa ser opcional para conclusão da expedição. | Arquivar Ecos descobertos e equipar/trocar os que o jogador já possui, somente no Hub. Sem extração, cópia, infusão, melhoria ou coleção completa. |
| 3 | **Alquimista** | Depois do Ferreiro, quando `CRAFT-1` e `ECON-1` aprovarem uma fonte e um uso para materiais transformáveis (`TREE_ALQ_001`/`TREE_ALQ_002`). | Começa com transmutação de materiais existentes. Destilação de Essência e catalisadores entram depois de schema de item e economia. |
| 4 | **Ourives** | Depois de Alquimia básica e quando `ITEM-1` definir acessórios elegíveis (`TREE_OFI_004`/`TREE_OFI_005`). | Uma receita determinística e curada de acessório. Sockets, lapidação e recalibração não entram sem aprovação própria em `ITEM-1`/`ECON-1`. |

A disponibilidade de cada artesão ou serviço é persistente na conta/Hub. Respec nunca fecha oficina nem remove um serviço já restaurado. As áreas dos sete ramos podem ficar visíveis após a Keystone da Árvore; serviços individuais só abrem ao cumprir seus pré-requisitos de árvore, conteúdo e sistema.

### Função, fonte e sink de cada serviço

| Serviço | Função sem sobreposição | Fonte de entrada | Saída / sink | Estado de economia |
| --- | --- | --- | --- | --- |
| Ferreiro — desmontagem | Converter equipamento selecionado que o jogador não quer manter. | Peça obtida por drop ou recompensa determinística; confirmação obrigatória. Favoritos/protegidos são inelegíveis. | Sucata para aprimoramento inicial. O item escolhido é consumido; nada é desmontado automaticamente no slice. | Sucata pode ser definida no CRAFT-1; quantidades e diferenças por slot/raridade ficam para `ITEM-1`/`ECON-1`. |
| Ferreiro — aprimoramento controlado | Melhorar uma peça elegível sem rerrolar atributos nem apagar a identidade do item. | Equipamento selecionado e Sucata; ouro pode ser custo secundário. | Sucata é consumida e o mesmo item recebe uma melhoria limitada. | Faixa, custo, limite e valor secundário ficam para `ITEM-1`/`ECON-1`. |
| Gravadora — catalogar/equipar Echo | Consultar memória descoberta e alterar qual Echo possuído está equipado. | Echo recebido em recompensa/missão determinística. | Nenhum Echo é consumido ou duplicado ao catalogar/equipar; o item continua no inventário persistente. | Sem moeda no fluxo básico. Qualquer custo futuro precisa de motivo e sink próprios em `ECHO-1`/`ECON-1`. |
| Alquimista — transmutar | Trocar materiais excedentes de faixas inferiores por material de faixa superior já definido. | Materiais de crafting existentes obtidos em conteúdo/desmontagem. | Consome os materiais de entrada e concede um resultado compatível com receitas elegíveis. | Famílias, receitas, taxas e limites ficam para `CRAFT-1`/`ECON-1`; não introduzir moedas por conveniência. |
| Alquimista — destilar/criar catalisador | Preparar insumo para serviços avançados do Ferreiro. | Equipamentos elegíveis para destilação e materiais existentes; a extração sempre mostra o resultado antes de consumir a peça. | Essência é produzida por destilação; Catalisador usa Essência e é consumido por reforja/serviços avançados futuros. | Fora do slice; elegibilidade, receitas, confirmação e quantidades ficam para `ITEM-1`/`ECON-1`. |
| Ourives — receita de acessório | Produzir um acessório conhecido com resultado determinístico. | Materiais e ouro definidos para a receita, vindos de conteúdo/economia aprovados. | Consome os insumos e produz um acessório do catálogo sem rolagem aleatória obrigatória. | Primeiro slot/receita e recursos ficam para `ITEM-1`/`ECON-1`. |

**Materiais no slice:** somente `Sucata` entra no ciclo do Ferreiro. Não adicionar Essência, Catalisador, Liga ou outras famílias antes de cada uma ter fonte, sink e UI especificados. Fragmentos de Ressonância permanecem recurso da árvore; Ouro continua separado.

**Fora de CRAFT-1 / slice:** reforja e proteção de atributos, forja livre de bases, ascensão, sockets/lapidação, extração/infusão/cópia/melhoria de Ecos, consumíveis, purificação, síntese avançada e auto-desmontagem. Reforja e proteção de atributos deixam de ocupar os dois últimos nós iniciais de Oficina; ficam para possível expansão da árvore depois da validação do slice.

O Cartógrafo/Mercador não faz parte dos quatro artesãos deste gate. Contratos e recompensas de expedição ficam com a lógica de conteúdo até surgir um serviço distinto, necessário e com fonte/sink definidos.

As dependências com os nós aprovados ficam na [Árvore dos Ecos](GLOBAL_RESONANCE_TREE.md); números, taxas e pools permanecem fora desta fonte até `ITEM-1`/`ECON-1`.

## Como usar esta proposta no Pocket Hero

- O runtime atual continua definido por [`data/items/items.json`](../../data/items/items.json): três slots (`weapon`, `armor`, `amulet`) e quatro raridades (`Comum`, `Raro`, `Épico`, `Lendário`).
- O [`HERO_STANDARD.md`](../../HERO_STANDARD.md) já descreve uma direção de dez slots por herói. A expansão do runtime para esse modelo ainda precisa de escopo, migração e roadmap próprios.
- Os sete grupos de raridade, Item Power, affixes, materiais, custos e serviços abaixo são propostas; não alteram JSON, código, inventário ou economia.
- A trilha de artesãos e estabelecimentos deve ser planejada como progressão pós-MVP. O “MVP recomendado” na fonte significa um protótipo mínimo do sistema de crafting.
- A nota sobre personagens e equipamentos exclusivos do Bastião é material de exemplo, subordinado à ficha de referência e às decisões de gameplay atuais.

**PROJETO TASKBAR**

# EQUIPAMENTOS E ARTESÃOS DA CIDADE

**Loot, crafting e substituição diegética do “Cube”**


| Status | DESIGN PROPOSAL |
| --- | --- |
| Versão | v0.1 |
| Escopo | Sistema global / Hub / progressão |
| Uso | Documento-base para implementação e balanceamento |

**Documento de design — referência canônica**

## 1. Visão do sistema

O sistema de equipamentos é uma das grandes fontes de progressão repetível. Em vez de concentrar desmontagem, síntese, reroll e crafting dentro de um objeto abstrato como um Cube, nosso jogo distribui essas funções entre moradores e estabelecimentos da cidade.


> Princípio central
> O jogador não “abre uma máquina de crafting”. Ele volta para casa, conversa com pessoas conhecidas, melhora os estabelecimentos e vê a cidade se especializar junto com ele.


> EXPEDIÇÃO

## 2. Os 10 slots de equipamento


| Slot | Função de design | Observação |
| --- | --- | --- |
| Arma | Principal identidade ofensiva | Frequentemente específica por herói/classe |
| Secundário | Escudo, foco, ferramenta etc. | Pode mudar bastante o gameplay |
| Cabeça | Defesa/utilidade | Universal por arquétipo |
| Peito | Maior peça defensiva | Maior orçamento de defesa |
| Luvas | Ataque/velocidade | Foco ofensivo |
| Botas | Movimento/esquiva | Foco em mobilidade |
| Amuleto | Efeitos especiais | Atributos híbridos |
| Anel | Especialização | Boa fonte de affixes |
| Relíquia | Poderes raros | Ligada a história/mundo |
| Echo | Modifica skill/lore | Slot exclusivo do nosso universo |

## 3. Raridades

A raridade deve indicar principalmente complexidade e potencial de build, não apenas números maiores. O jogador precisa reconhecer rapidamente o valor de um drop.


| Raridade | Affixes típicos | Papel |
| --- | --- | --- |
| Comum | 1 | Base / início |
| Incomum | 2 | Primeira especialização |
| Raro | 3 | Builds consistentes |
| Épico | 4 | Combinações fortes |
| Lendário | 4 + efeito especial | Muda comportamento |
| Mítico | 4 + poder forte + condição | Endgame |
| Relíquia / Echo Único | Regras próprias | Peças narrativas / build-defining |


> Evitar inflação
> Não precisamos lançar dez raridades de uma vez. Sete categorias claras são mais fáceis de ler, balancear e expandir.

## 4. Anatomia de um item


| Campo | Exemplo |
| --- | --- |
| Nome | Muralha do Primeiro Juramento |
| Slot | Secundário / Escudo |
| Raridade | Lendário |
| Nível do item | 42 |
| Atributo base | Armadura + Bloqueio |
| Affixes | Vida / Guarda / resistência |
| Poder especial | Perfect Blocks geram Guarda adicional |
| Origem | Boss / missão / crafting |
| Estado de crafting | 2/4 intervenções usadas |
| Lore | Texto curto opcional |

## 5. A cidade substitui o Cube

As funções de um sistema central de crafting são distribuídas entre especialistas. Isso dá personalidade ao Hub e cria uma progressão visual e funcional dos NPCs.


| NPC / Local | Responsabilidade |
| --- | --- |
| Ferreiro — Forja | Upgrade, desmontagem, reforja física, criação de armas/armaduras |
| Alquimista — Laboratório | Transmutação de materiais, essências, catalisadores, consumíveis |
| Gravadora de Ecos — Santuário | Echoes, poderes especiais, extração/infusão de memória |
| Ourives — Bancada | Anéis, amuletos, sockets e ajustes finos |
| Cartógrafo / Mercador | Conversões limitadas, contratos e recompensas de expedição |

## 6. Ferreiro da cidade

## Identidade

O Ferreiro é o primeiro grande artesão do Hub. Sua oficina começa simples e fisicamente melhora conforme a Árvore dos Ecos restaura o Ramo da Oficina.

## Serviços

As opções abaixo descrevem capacidades possíveis de longo prazo. O escopo aprovado para a primeira entrega está definido na seção CRAFT-1 deste documento e prevalece sobre sugestões gerais desta transcrição.


| Serviço | Função | Desbloqueio sugerido |
| --- | --- | --- |
| Desmontar | Transforma equipamento em materiais | Inicial |
| Aprimorar | Aumenta nível/poder do item | Oficina I |
| Reforjar | Troca um affix por outro da mesma família | Oficina II |
| Fixar atributo | Protege um affix durante reforja | Oficina III |
| Forjar base | Cria item do slot escolhido | Oficina III |
| Ascender peça | Permite levar peça favorita a faixa superior com limite | Endgame |

## Desmontagem

Itens ruins nunca devem ser totalmente inúteis. Desmontar gera materiais relacionados à raridade e ao tipo do item. Itens raros podem gerar pequena chance de materiais especiais.


| Raridade | Resultado principal |
| --- | --- |
| Comum | Sucata / Metal / Tecido |
| Incomum | Materiais + chance de componente |
| Raro | Materiais refinados |
| Épico | Materiais refinados + Essência |
| Lendário+ | Essência especial / componente raro |

## Reforja

O jogador escolhe UM atributo e paga para rolá-lo novamente. Cada nova tentativa aumenta moderadamente o custo. O sistema mostra claramente a família de resultados possíveis para evitar crafting cego.


> Regra de segurança
> Nunca apagar automaticamente um item bom por acidente. Toda reforja deve exigir confirmação e exibir “antes → depois”.

## 7. Alquimista da cidade

## Identidade

O Alquimista trabalha com substâncias, memórias residuais e materiais que não fazem sentido na bancada do Ferreiro. Ele é o responsável pela transformação de recursos.

## Serviços


| Serviço | Função |
| --- | --- |
| Transmutação | 3–5 materiais inferiores → material superior |
| Destilação | Transforma itens/fragmentos específicos em Essências |
| Catalisadores | Cria reagentes usados em Reforja e Ascensão |
| Tônicos | Consumíveis temporários de expedição |
| Purificação | Remove corrupção/penalidade de certos itens especiais |
| Síntese avançada | Combina materiais de boss para receitas específicas |

## 8. Gravadora de Ecos

Esse NPC substitui a parte mais “mágica” do Cube. Seu papel é trabalhar com memórias e poderes especiais, mantendo o Ferreiro focado no material e o Alquimista na transformação de recursos.


| Serviço | Função |
| --- | --- |
| Extrair Eco | Retira um poder especial de item elegível e o transforma em memória utilizável |
| Infundir Eco | Aplica uma memória compatível a um slot Echo ou item específico |
| Catalogar | Adiciona o poder à coleção/Codex |
| Ressonar | Melhora um Echo por etapas limitadas |
| Recordar | Permite recuperar uma versão básica de um Echo já descoberto |


> Benefício
> O jogador pode desmontar um Lendário ruim sem sentir que “perdeu para sempre” seu poder exclusivo: se cumprir as condições, registra o Echo.

## 9. Ourives

O Ourives cuida da especialização fina: anéis, amuletos e sockets. Esse NPC deve ser desbloqueado depois do Ferreiro para não inundar o início com sistemas.

- Criar anéis e amuletos-base.
- Adicionar/remover sockets dentro de limites.
- Lapidar gemas ou cristais.
- Recalibrar pequenos atributos utilitários.
- Criar peças voltadas para builds híbridas.
## 10. Materiais

Poucas famílias claras são melhores que dezenas de moedas sem função. O jogador deve entender intuitivamente onde cada recurso é usado.


| Material | Origem | Uso |
| --- | --- | --- |
| Sucata | Desmontagem comum | Upgrades iniciais |
| Liga | Armas/armaduras raras | Ferreiro |
| Essência | Itens mágicos/lendários | Alquimia + Ecos |
| Catalisador | Alquimista | Reforja avançada / ascensão |
| Cristal de Ressonância | Bosses/marcos | Echoes e upgrades especiais |
| Memória Fragmentada | Missões/lore | Gravadora de Ecos |

## 11. Item Power e nível

Equipamento possui Item Power separado do nível do herói. Item Power define a faixa de valores-base e de affixes. O objetivo é permitir comparar peças sem esconder tudo em números complexos.

- Nível do herói define o que pode cair.
- Item Power define a força potencial da peça.
- Raridade define quantidade/qualidade de propriedades.
- Poder especial define identidade.
- Crafting melhora a peça, mas não deve tornar qualquer drop antigo eterno sem custo alto.
## 12. Affixes


| Família | Exemplos |
| --- | --- |
| Ofensivo | dano, crítico, velocidade, dano de skill |
| Defensivo | vida, armadura, bloqueio, resistência |
| Utilidade | movimento, cooldown, geração de recurso |
| Mecânica de herói | Guarda, Sementes, Fúria, Ritmo etc. |
| Especial | interações condicionais / efeitos de build |

Affixes ligados à mecânica do herói devem aparecer em pool controlado por slot e arquétipo para reduzir drops completamente inúteis.

## 13. Poderes Lendários e Echoes

Lendários devem mudar decisão, skill ou interação, não apenas fornecer números maiores.


| Ruim | Bom |
| --- | --- |
| +25% dano | Contra-Golpe cria segunda onda se usado após Perfect Block |
| +20% vida | Muralha Viva acompanha Bastião lentamente |
| +15% velocidade | Impacto de Escudo permite recuo defensivo após colisão |

Echoes podem ser ainda mais narrativos: são memórias materializadas e podem alterar efeitos visuais, falas ou comportamento de Signature Skills.

## 14. Limites de crafting

Crafting precisa melhorar sorte ruim sem eliminar a emoção do drop. Por isso cada item possui um orçamento de intervenção.


| Sistema | Limite sugerido |
| --- | --- |
| Reforja de affix | 1 affix principal por item; tentativas ilimitadas com custo crescente |
| Fixar atributo | 1–2 atributos protegidos conforme progressão |
| Sockets | Número limitado por raridade |
| Ascensão | Poucas vezes por item e com material raro |
| Infusão de Echo | Compatibilidade por slot/herói |
| Upgrade de Item Power | Faixa limitada; não acompanha eternamente todo conteúdo |

## 15. Progressão dos estabelecimentos


O avanço combina campanha, nós da Árvore dos Ecos e prontidão dos sistemas dependentes; não é um nível numérico compartilhado dos estabelecimentos.

| Marco | Serviço desbloqueado | Dependência de design |
| --- | --- | --- |
| Primeira reconstrução do Refúgio | Ferreiro restaurado; desmontagem e aprimoramento controlado | `TREE_OFI_001`–`TREE_OFI_003`, `ITEM-1`/`ECON-1` |
| Primeira memória recuperável | Gravadora: catalogar e equipar/trocar Ecos possuídos | `TREE_MEM_001`/`TREE_MEM_002`, `ECHO-1`; a recompensa Echo continua opcional |
| Economia de materiais estabelecida | Alquimista restaurado; transmutação simples | `TREE_ALQ_001`/`TREE_ALQ_002`, `CRAFT-1`/`ECON-1` |
| Catálogo de acessórios validado | Ourives restaurado; receita curada de acessório | `TREE_OFI_004`/`TREE_OFI_005`, `ITEM-1`/`ECON-1` |

Reforja, sockets, melhoria de Ecos, ascensão e receitas avançadas são expansões futuras, não níveis necessários para o slice.

## 16. Loop econômico


> DROP

Esse ciclo garante que quase todo drop tenha pelo menos três valores possíveis: uso imediato, material ou conhecimento/Echo.

## 17. Relação com o Bastião

O Bastião serve como primeiro caso de teste do sistema. Seus itens exclusivos já definidos podem ser distribuídos entre as novas camadas.


| Item | Tratamento |
| --- | --- |
| Muralha do Primeiro Juramento | Lendário de escudo; Ferreiro pode aprimorar e reforjar |
| Vigília | Lendário de espada; poder catalogável na Gravadora se elegível |
| A Sentinela que Ficou | Echo Único; somente Santuário de Ecos |
| Itens Guardião | Pools defensivos + proteção de aliados |
| Itens Retaliação | Perfect Block, stagger, Contra-Golpe |
| Itens Controle | Desequilíbrio, knockback, área |

## 18. UX do loot

- Comparação lado a lado entre item equipado e novo drop.
- Ícones claros para atributos que sobem/descem.
- Marcar favorito e bloquear contra desmontagem.
- Filtro automático por raridade e Item Power.
- Opção de auto-desmontar apenas itens que o jogador configurar.
- Poder Lendário destacado separadamente dos atributos numéricos.
- Mostrar onde o material é usado ao tocar nele.
## 19. O que NÃO fazer


| Problema | Consequência |
| --- | --- |
| 20 moedas de crafting | Confusão e inventário morto |
| Reroll sem mostrar pool | Frustração e sensação de cassino |
| Crafting melhor que qualquer drop | Exploração perde sentido |
| Drop sempre melhor que crafting | Artesãos viram decoração |
| NPCs todos fazem tudo | Cidade perde identidade |
| Itens Lendários apenas com stats altos | Builds ficam genéricas |

## 20. Escopo por horizonte

| Horizonte | Conteúdo aprovado |
| --- | --- |
| `SLICE-1` | Ferreiro: desmontagem protegida e aprimoramento controlado. Gravadora: catalogar e equipar/trocar o Echo opcional já obtido. Alquimista e Ourives não são requisitos do slice. |
| Depois do slice | Alquimista: transmutação após definir fonte/sink. Ourives: uma receita curada após `ITEM-1`. Ambos passam por economia antes da integração. |
| Expansão futura | Reforja, catalisadores, sockets, essências avançadas, ascensão, serviços completos da Gravadora, receitas de endgame e qualquer novo artesão. |

## 21. Estrutura recomendada no repositório


| Arquivo | Responsabilidade |
| --- | --- |
| systems/equipment/EQUIPMENT_SYSTEM.md | Slots, raridades, Item Power e affixes |
| systems/crafting/BLACKSMITH.md | Ferreiro |
| systems/crafting/ALCHEMIST.md | Alquimista |
| systems/crafting/ECHO_ENGRAVER.md | Gravadora de Ecos |
| systems/crafting/JEWELER.md | Ourives |
| data/items/ | Definições de itens |
| data/affixes/ | Pools de affixes |
| data/recipes/ | Receitas e custos |

## 22. Definition of Done

- Os 10 slots possuem função clara.
- Raridades e número de affixes estão definidos.
- Item Power está separado de raridade.
- Ferreiro possui fluxo de desmontagem, upgrade e reforja.
- Alquimista possui transmutação e catalisadores.
- Echoes têm especialista próprio.
- Materiais possuem origem e uso claros.
- Itens podem ser bloqueados contra desmontagem.
- Crafting melhora drops sem substituir loot.
- A Árvore dos Ecos desbloqueia níveis dos estabelecimentos.
- O sistema já suporta equipamentos exclusivos dos 8 heróis.

> Status do documento
> EQUIPMENT_CITY_CRAFTING_DESIGN: READY FOR PROTOTYPE
