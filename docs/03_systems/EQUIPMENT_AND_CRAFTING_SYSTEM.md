---
status: APPROVED
source: "[1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx](../../documents/1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx)"
---

# Equipamentos e artesãos da cidade

> **Autoridade atual:** slots, função dos artesãos e limites próprios de Pocket Hero estão resumidos nas decisões `CRAFT-1`/`ITEM-1`. Para catálogo, raridades, materiais, stats, affixes, Item Power e loot, prevalece a [balanceamento v1.0](../06_balance/v1/README.md). O corpo original abaixo de “PROJETO TASKBAR” é uma transcrição histórica v0.1; trechos que conflitem com v0.5 estão supersedidos. A palavra MVP no original não reabre o MVP concluído do Pocket Hero.
> **Documento original:** [1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx](../../documents/1-Taskbar_Equipamentos_e_Artesaos_da_Cidade_v0.1.docx). A conversão preserva texto e tabelas; elementos visuais do Word, se houver, continuam disponíveis apenas no DOCX.

## Decisões de base aprovadas por delegação de Rafael

- **DECIDIDO em 2026-09-28:** equipamento é preparação persistente. O jogador compara e altera loadout somente no Hub; durante a expedição ele fica travado, e drops vão para o inventário sem substituir ou destruir automaticamente peças equipadas.
- **DECIDIDO em 2026-09-28:** aquisição combina drops e recompensas determinísticas de marcos. Uma build não pode depender de obter um item aleatório específico; o item novo permanece guardado até o jogador escolher equipá-lo.
- **DECIDIDO por Rafael em 2026-09-30:** no slice, usar Comum, Incomum, Raro e Épico. Épicos só vêm como recompensas de boss, têm atributos superiores e podem trazer modificador. Relíquia e Memória ficam fora do slice atual.
- **DECIDIDO em 2026-09-28:** o Ferreiro é o primeiro serviço de equipamento: oferece desmontagem e um serviço de melhoria controlada. Desmontar exige confirmação explícita e exibe o resultado; itens favoritos/protegidos não podem ser desmontados. Reforja aleatória, fixação de affix, ascensão e crafting livre ficam para depois do slice.
- **DECIDIDO por delegação em 2026-09-28:** o primeiro recorte do Ferreiro usará `MAT_C1_LUMEN_RESIDUE` (Resíduo de Lúmen), material do catálogo do Capítulo 1 ([materiais](../04_content/chapters/chapter_01/CHAPTER_01_MATERIAL_CATALOG.md)). `Sucata`, ausente do catálogo, não faz parte do recorte proposto.
- **DECIDIDO em 2026-09-28:** a abertura dos artesãos é gradual e persistente na conta/Hub. O Ferreiro vem primeiro; Alquimista e Ourives entram conforme suas funções estiverem sustentadas por conteúdo e economia. A Gravadora de Ecos só abre junto do sistema de Echo decidido abaixo.
- **DECIDIDO em 2026-09-28:** cada herói tem seis posições de equipamento: Arma, Secundário, Armadura, Acessório I, Acessório II e Echo. São cinco equipamentos convencionais e um Echo. Cabeça, peito, luvas e botas se consolidam em Armadura; amuletos, anéis e relíquias se consolidam na família Acessório. Toda peça deve sustentar uma identidade ou decisão de build, evitando itens que só ofereçam um pequeno bônus estatístico.
- **DECIDIDO por Rafael em 2026-09-30:** somente armas são exclusivas por personagem. Secundários, armaduras, acessórios e Ecos podem ser equipados por todos os heróis do trio; os efeitos compartilhados não devem exigir skill ou recurso exclusivo.
- **DECIDIDO em 2026-09-28:** Ferreiro cuida de Arma, Secundário e Armadura; Ourives, dos dois slots de Acessório; Gravadora, de Echo; Alquimista, de materiais, catalisadores, transmutação e consumíveis.

Essas decisões são de arquitetura do design. Os números de itens, raridades, affixes, craft e loot seguem o [balanceamento v1.0](../06_balance/v1/README.md). Seleção final de conteúdo do slice, escala de atributos, migração de schema runtime, custos e QA seguem para `BALANCE-1`/`ECON-1`/`LOOT-EXPANSION-1`.

## CRAFT-1 — escopo e sequência aprovados

**Status:** `APPROVED` para arquitetura e ordem dos serviços em 2026-09-28. Isso define o plano pós-MVP; não confirma NPCs, menus, receitas ou implementação existentes.

### Ordem de abertura

| Ordem | Artesão/serviço | Quando fica disponível | Limite da primeira entrega |
| --- | --- | --- | --- |
| 1 | **Ferreiro** | Primeiro artesão restaurado pelo Ramo da Oficina (`TREE_OFI_001`). Desmontagem e aprimoramento abrem pelos nós `TREE_OFI_002` e `TREE_OFI_003`. | Desmontagem com confirmação e proteção de favoritos; um caminho controlado de aprimoramento. Sem reforja, auto-desmontagem ou fabricação livre no slice. |
| 2 | **Gravadora de Ecos** | Junto da primeira recompensa Echo e da introdução do sistema (`TREE_MEM_001`/`TREE_MEM_002`, `ECHO-1`). Precisa ser opcional para conclusão da expedição. | Arquivar Ecos descobertos e equipar/trocar os que o jogador já possui, somente no Hub. Sem extração, cópia, infusão, melhoria ou coleção completa. |
| 3 | **Alquimista** | Depois do Ferreiro, quando `ECON-1` aprovar uma fonte e um uso para materiais transformáveis (`TREE_ALQ_001`/`TREE_ALQ_002`). | Começa com transmutação de materiais existentes. Destilação de Essência e catalisadores entram depois de especificar equipamentos elegíveis e economia. |
| 4 | **Ourives** | Depois de Alquimia básica e quando conteúdo futuro definir acessórios elegíveis (`TREE_OFI_004`/`TREE_OFI_005`). | Uma receita determinística e curada de acessório. Sockets, lapidação e recalibração exigem expansão e aprovação econômica próprias. |

A disponibilidade de cada artesão ou serviço é persistente na conta/Hub. Respec nunca fecha oficina nem remove um serviço já restaurado. As áreas dos sete ramos podem ficar visíveis após a Keystone da Árvore; serviços individuais só abrem ao cumprir seus pré-requisitos de árvore, conteúdo e sistema.

### Função, fonte e sink de cada serviço

| Serviço | Função sem sobreposição | Fonte de entrada | Saída / sink | Estado de economia |
| --- | --- | --- | --- | --- |
| Ferreiro — desmontagem | Converter equipamento selecionado que o jogador não quer manter. | Peça obtida por drop ou recompensa determinística; confirmação obrigatória. Favoritos/protegidos são inelegíveis. | Material comum compatível com o item/região. No recorte do Capítulo 1, usar Resíduo de Lúmen; nada é desmontado automaticamente no slice. | Tipo e quantidades seguem as regras herdadas e incorporadas à v0.5; rendimentos por item/raridade e elegibilidade do subset serão simulados em `ECON-1`/`SLICE-1`. |
| Ferreiro — aprimoramento controlado | Melhorar uma peça elegível sem rerrolar atributos nem apagar a identidade do item. | Equipamento selecionado e material canônico do recorte; Ouro pode ser custo secundário. | Consome os materiais aprovados e o mesmo item recebe uma melhoria limitada. | **Recomendação para o slice:** demonstrar Reforço `+1` conforme regra herdada incorporada à v0.5 (`+2%` do poder de status base). A hipótese de custo está em [v1 · economia e loot](../06_balance/v1/07_ECONOMIA_LOOT.md); elegibilidade ainda será fechada em `SLICE-1`. Não aumenta Item Power. |
| Gravadora — catalogar/equipar Echo | Consultar memória descoberta e alterar qual Echo possuído está equipado. | Echo recebido em recompensa/missão determinística. | Nenhum Echo é consumido ou duplicado ao catalogar/equipar; o item continua no inventário persistente. | Sem moeda no fluxo básico. Qualquer custo futuro precisa de motivo e sink próprios em `ECHO-1`/`ECON-1`. |
| Alquimista — transmutar | Trocar materiais excedentes de faixas inferiores por material de faixa superior já definido. | Materiais de crafting existentes obtidos em conteúdo/desmontagem. | Consome os materiais de entrada e concede um resultado compatível com receitas elegíveis. | Famílias, receitas, taxas e limites econômicos ficam para `ECON-1`; não introduzir moedas por conveniência. |
| Alquimista — destilar/criar catalisador | Preparar insumo para serviços avançados do Ferreiro. | Equipamentos elegíveis para destilação e materiais existentes; a extração sempre mostra o resultado antes de consumir a peça. | Essência é produzida por destilação; Catalisador usa Essência e é consumido por reforja/serviços avançados futuros. | Fora do slice; elegibilidade exige catálogo futuro e receitas/quantidades dependem de `ECON-1`. |
| Ourives — receita de acessório | Produzir um acessório conhecido com resultado determinístico. | Materiais e ouro definidos para a receita, vindos de conteúdo/economia aprovados. | Consome os insumos e produz um acessório do catálogo sem rolagem aleatória obrigatória. | Catálogo futuro de acessórios e recursos/receita dependem de expansão de conteúdo e `ECON-1`. |

**Materiais no recorte proposto para o slice:** somente Resíduo de Lúmen (`MAT_C1_LUMEN_RESIDUE`) entra no ciclo inicial do Ferreiro. Não adicionar Essência Corrompida nem outras famílias antes de cada uma ter fonte, sink e UI especificados. Fragmentos de Ressonância permanecem recurso da Árvore; Ouro continua separado. A desmontagem segue a regra de material herdada e incorporada à v0.5, sem criar uma moeda chamada Sucata.

**Fora de CRAFT-1 / slice:** reforja e proteção de atributos, forja livre de bases, ascensão, sockets/lapidação, extração/infusão/cópia/melhoria de Ecos, consumíveis, purificação, síntese avançada e auto-desmontagem. Reforja e proteção de atributos deixam de ocupar os dois últimos nós iniciais de Oficina; ficam para possível expansão da árvore depois da validação do slice.

O Cartógrafo/Mercador não faz parte dos quatro artesãos deste gate. Contratos e recompensas de expedição ficam com a lógica de conteúdo até surgir um serviço distinto, necessário e com fonte/sink definidos.

As dependências com os nós aprovados ficam na [Árvore dos Ecos](GLOBAL_RESONANCE_TREE.md); números, taxas e pools econômicos permanecem para `ECON-1`.

## ITEM-1 — modelo e escopo inicial aprovados

**Status:** `APPROVED` para o contrato de design em 2026-09-28. Não altera o JSON, cenas, interface ou regras runtime atuais.

- Os **seis slots** do [`HERO_STANDARD.md`](../02_heroes/HERO_STANDARD.md) são Arma, Secundário, Armadura, Acessório I, Acessório II e Echo. O catálogo herdado tem 6 Armas, 7 Secundários, 5 Armaduras, 10 Acessórios e 5 Ecos (33 templates); os tokens runtime `weapon`, `armor` e `amulet` seguem como legado até migração.
- O catálogo ativo e adaptado do Capítulo 1 está na [balanceamento v1.0](../04_content/items/CHAPTER_01_ITEM_CATALOG.md). Os IDs persistentes são preservados; novos templates só entram após registro explícito.
- No slice, as quatro raridades são **Comum, Incomum, Raro e Épico**. Épicos são recompensas exclusivas de boss. Relíquia e Memória ficam fora do recorte atual.
- Somente armas são restritas a um personagem. Secundários, armaduras, acessórios e Ecos são compartilháveis pelos três heróis quando seu efeito for universal.
- Cada item do slice tem identidade e propriedades fixas e curadas. Não haverá rolagem aleatória de affixes nem reforja no primeiro slice. Um efeito mecânico especial é opcional e definido por item; ele não é gerado novamente a cada drop.
- A proposta de `Item Power`, budgets e relação com raridade/affixes herdada está sob revisão na v0.5; a escala de combate **10×** foi decidida por Rafael em 2026-09-30 e o orçamento por raridade está registrado em [v1 · itens e raridade](../06_balance/v1/04_ITENS_RARIDADE.md); a matriz por item/raridade segue por fechar. Não está integrada ao runtime atual.
- Para documentação de design, o registro descreve: ID de design no registry; ID runtime existente quando aplicável; nome; slot canônico (mais token legado quando houver); raridade; atributos-base; efeito fixo opcional; origem/recompensa. Custos, pesos e taxas de drop ficam para `ECON-1`. Isso não autoriza migrar o formato achatado atual de `data/items/items.json` para um novo schema.

| Campo de design | Obrigatoriedade/uso | Limite nesta fase |
| --- | --- | --- |
| `design_id` | Obrigatório para cada item catalogado; vem do [registry](../CONTENT_REGISTRY.md). | ID persistente, distinto do ID runtime. |
| `runtime_id` | Ausente nos templates de design até a migração de conteúdo. | Usar os IDs legados apenas no [manifesto de compatibilidade](../04_content/LEGACY_RUNTIME_CATALOG.md); não associá-los por categoria. |
| `name` | Obrigatório; nome de catálogo. | Candidatos preservam o nome listado no overview até uma revisão explícita. |
| `slot` | Obrigatório; posição/família compatível no modelo canônico. | Somente armas têm compatibilidade por herói; demais itens devem ser compartilháveis no trio. |
| `rarity` | Obrigatório nas quatro faixas do slice. | Comum–Épico; Épico só pode ser recompensa de boss. |
| `base_stats` | Estrutura fixa de atributos-base por item. | Números e budgets seguem para `ECON-1`; o JSON atual mantém atributos achatados. |
| `fixed_effect` | Opcional, definido por ficha para itens que mudam uma interação. | Sem geração aleatória de efeito no slice. |
| `source` | Obrigatório antes de publicar drop/recompensa. | Tipo de origem pode ser design; fonte concreta, peso e frequência seguem para `CONTENT-1`/`ECON-1`. |

Os templates herdados e as novas variantes passam por reconciliação no balanceamento v1.0. A lista quantitativa por raridade aguarda a decisão de escala e não deve ser migrada até simulação e QA.

## Como usar esta proposta no Pocket Hero

- O runtime atual continua definido por [`data/items/items.json`](../../data/items/items.json): três slots (`weapon`, `armor`, `amulet`) e quatro raridades (`Comum`, `Raro`, `Épico`, `Lendário`).
- O [`HERO_STANDARD.md`](../02_heroes/HERO_STANDARD.md) descreve seis slots canônicos. Os três tokens atuais de item (`weapon`, `armor`, `amulet`) não equivalem a seis posições; a expansão do runtime exige escopo e migração próprios.
- Os budgets, affixes e Item Power herdados estão integrados ao balanceamento v1.0 e em revisão para os quatro tiers do slice. O JSON, código e inventário atuais só mudam durante uma migração aprovada.
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

**Documento de design histórico v0.1 — não canônico quando divergir do balanceamento v1.0**

## 1. Visão do sistema

O sistema de equipamentos é uma das grandes fontes de progressão repetível. Em vez de concentrar desmontagem, síntese, reroll e crafting dentro de um objeto abstrato como um Cube, nosso jogo distribui essas funções entre moradores e estabelecimentos da cidade.


> Princípio central
> O jogador não “abre uma máquina de crafting”. Ele volta para casa, conversa com pessoas conhecidas, melhora os estabelecimentos e vê a cidade se especializar junto com ele.


> EXPEDIÇÃO

## 2. Os seis slots canônicos de equipamento

O modelo de [`HERO_STANDARD.md`](../02_heroes/HERO_STANDARD.md) possui cinco slots convencionais e um Echo. O runtime e o catálogo do Capítulo 1 ainda usam três tipos de registro (`weapon`, `armor`, `amulet`); esses tipos legados não provam que a interface ou os dados suportem as seis posições.

| Slot canônico | Função de design | Escopo do catálogo inicial |
| --- | --- | --- |
| Arma (`weapon`) | Principal fonte ofensiva e identidade do herói | Incluída no catálogo de 30 |
| Secundário | Escudo, grimório, aljava, foco ou ferramenta, conforme o herói | Conteúdo futuro |
| Armadura (`armor` legado) | Defesa e atributos principais; consolida cabeça, peito, luvas e botas | Incluída no catálogo de 30 |
| Acessório I | Especialização de build | Pool inicial derivado dos amuletos; compatibilidade ainda será definida por item |
| Acessório II | Especialização de build | Mesmo pool familiar de acessórios; cada posição pode aceitar itens compatíveis |
| Echo | Efeitos especiais ligados à memória e à lore | Categoria com cinco itens no catálogo canônico de 30; ocupa a posição Echo |

O Ferreiro atende Arma, Secundário e Armadura; o Ourives atende Acessório I e II; a Gravadora de Ecos atende Echo; o Alquimista atende materiais, catalisadores, transmutação e consumíveis. Cada peça deve oferecer identidade ou decisão de build, em vez de apenas acrescentar um bônus estatístico pequeno.

## 3. Raridades

A direção geral continua sendo comunicar identidade e potencial de build, não apenas números maiores. A escada de nove raridades está em [v1 · itens e raridade](../06_balance/v1/04_ITENS_RARIDADE.md); o slice usa quatro: Comum, Incomum, Raro e Épico; Épicos são exclusivos de recompensa de boss. O runtime atual ainda carrega quatro raridades com nomes diferentes; a compatibilidade transitória está documentada na ponte de IDs legados.

| Raridade inicial | Estado e uso |
| --- | --- |
| Comum | Existente no runtime; mantida |
| Raro | Existente no runtime; mantida |
| Épico | Existente no runtime; mantida |
| Lendário | Existente no runtime; mantida |

Os nomes e papéis de raridade deste trecho v0.1 estão supersedidos. Relíquia e Memória permanecem fora da raridade genérica do slice conforme a decisão de Rafael de 2026-09-30.


**A tabela a seguir é uma transcrição histórica v0.1. Para raridades e qualidade, a autoridade ativa é a [balanceamento v1.0](../06_balance/v1/README.md); a especificação herdada de origem está em [v1 · economia e loot](../06_balance/v1/07_ECONOMIA_LOOT.md).**

| Raridade candidata | Affixes típicos na proposta | Papel futuro proposto |
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

O exemplo a seguir é conceitual e de longo prazo; não introduz níveis de item, affixes rolados ou valores no runtime do slice.


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
| Ourives — Bancada | Acessórios; sockets e ajustes finos continuam sujeitos a aprovação futura |
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

O Ourives cuida da especialização fina dos acessórios (incluindo itens que antes eram agrupados como anéis, amuletos ou relíquias). Sockets continuam sendo uma possibilidade futura sujeita a gate próprio. Esse NPC deve ser desbloqueado depois do Ferreiro para não inundar o início com sistemas.

- Criar acessórios-base (família que inclui itens antes classificados como anéis, amuletos e relíquias).
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

## 11. Item Power e nível — direção futura

Se vier a ser introduzido, Item Power fica separado do nível do herói e define uma faixa de atributos-base. Sua função é permitir comparar peças sem esconder tudo em números complexos. A separação conceitual de raridade, poder-base e efeito especial está aprovada; fórmula, faixa, interface e uso em runtime não estão.

- Nível do herói define o que pode cair.
- Item Power define a faixa potencial dos atributos-base da peça.
- Raridade define quantidade/qualidade de propriedades.
- Poder especial define identidade.
- Crafting melhora a peça, mas não deve tornar qualquer drop antigo eterno sem custo alto.
## 12. Affixes — expansão após o slice

O primeiro slice não rola affixes aleatórios nem oferece reforja. Até existir um pool aprovado e uma simulação de economia, os atributos e efeitos são fixos por item.


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
| Depois do slice | Alquimista: transmutação após definir fonte/sink. Ourives: uma receita curada após especificação futura de acessórios. Ambos passam por economia antes da integração. |
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

- Os seis slots possuem função clara e todo item deve justificar sua contribuição para uma build.
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
