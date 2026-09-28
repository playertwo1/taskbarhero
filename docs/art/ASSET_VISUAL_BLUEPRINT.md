# Base visual de assets — Pocket Hero

**Status:** proposta de direção e inventário; detalhes específicos aguardam protótipo e QA

**Objetivo:** orientar a criação coerente de ícones e sprites do Capítulo 1 sem confundir conceito visual, contrato, produção e aprovação.

## 1. Direção existente que continua valendo

- **DECIDIDO:** usar identidade própria de dark fantasy, pixel art legível em escala mobile, iluminação principal no alto à esquerda e silhuetas reconhecíveis. A referência visual funcional são os Golden registrados em [`golden/README.md`](./golden/README.md); não copiar arte, poses, personagens, UI ou símbolos distintivos de referências externas.
- **DECIDIDO:** sprites animados seguem os contratos por entidade e os padrões em [`ART_DIRECTION.md`](./ART_DIRECTION.md), [`SPRITE_STYLE_GUIDE.md`](./SPRITE_STYLE_GUIDE.md), [`SPRITE_STANDARD.md`](./SPRITE_STANDARD.md) e [`ANIMATION_STANDARD.md`](./ANIMATION_STANDARD.md). O canvas não é universal: vale o contrato de cada asset.
- **DECIDIDO:** novos assets usam apenas as cores e subconjuntos definidos em [`PALETTE.md`](./PALETTE.md), conforme o contrato.
- **DECIDIDO por Rafael em 2026-09-28:** ícones de itens em 32×32, exibidos na grade visual do inventário. Moldura, raridade e seleção continuam elementos separados da imagem do ícone. A validação mobile ainda está pendente; não reduzir o asset aprovado para 24×24 sem revisão explícita.
- **STATUS REGISTRADO em 2026-09-28:** Rafael escolheu a opção de grade visual e autorizou a criação dos 30 ícones. Os 15 itens candidatos do Capítulo 1 permanecem apenas no catálogo visual e não entram no loot ou gameplay.
- **STATUS REGISTRADO:** os quatro Golden foram aprovados e o ART-0 está liberado para produção. As folhas animadas do MVP passaram lint técnico, enquanto a auditoria visual independente e a revisão mobile continuam pendentes; consultar [`MVP_SPRITE_INVENTORY.md`](./MVP_SPRITE_INVENTORY.md) e o roadmap antes de integrar ou iniciar novos lotes.
- **Licença da paleta:** [`PALETTE.md`](./PALETTE.md) registra aprovação atual apenas para uso pessoal/privado e ausência de licença externa explícita. Antes de redistribuir ou comercializar o jogo, obter os direitos necessários ou trocar a paleta e revalidar os assets.

## 2. Ideia visual central

**HIPÓTESE de arte:** o Bosque de Lúmen é reconhecível por pedra antiga, raízes curvas, madeira escura, musgo e pequenos núcleos de luz fria. A luz de Lúmen deve funcionar como acento focal, não como preenchimento de tudo. Os acentos quentes de ouro/âmbar distinguem recompensa, artefato e pontos importantes da interface.

Para manter a leitura:

1. Uma silhueta ou símbolo principal por ícone.
2. Dois ou três planos de contraste: contorno, forma principal e detalhe luminoso/material.
3. Contorno seletivo e clusters limpos conforme o guia de estilo; sem blur, gradiente ou textura ruidosa.
4. Transparência e composição simples para que a interface forneça moldura, fundo, estado selecionado e raridade.
5. A forma deve comunicar categoria mesmo em monocromático. Cor reforça a leitura; não a substitui.

As cores específicas, proporções, margens e limites de cores continuam vindo do subconjunto e do contrato de cada asset. Esta proposta não cria uma paleta nova.

## 3. Linguagem por família de asset

| Família | Forma que deve ler primeiro | Tratamento do Capítulo 1 | Uso candidato |
| --- | --- | --- | --- |
| **Armas** | Perfil comprido ou diagonal; ponta, lâmina, arco ou foco mágico distintos. | Materiais de madeira, pedra, metal e luz de Lúmen com uma silhueta própria por item. | Inventário, comparação de equipamento, recompensa. |
| **Armaduras** | Volume compacto e protetor; reconhecer peito, manto ou ombreira. | Casca, folhas, couro, musgo e micélio organizados em massas grandes. | Inventário e equipamento. |
| **Amuletos** | Um foco central com moldura ou cordão simples; leitura simétrica quando possível. | Semente, presa, nó, broche e pedra com material e centro luminoso distintos. | Inventário e comparação. |
| **Skills** | Um gesto/ação principal com um elemento secundário. | Escudo/raiz para Bastião; trajetória/marca para Flecha; prisma/micélio para Íris. | Botão, lista de skills e feedback de combate, conforme as telas aprovadas. |
| **Heróis** | Rosto, arma ou emblema que preserve a silhueta do sprite Golden. | Bastião: defesa; Flecha: trajetória; Íris: foco arcano. Não desenhar retratos incompatíveis com a folha aprovada. | Party, seleção e status se a UI exigir. |
| **Inimigos** | Cabeça, olhos, arma ou elemento de espécie em primeiro plano. | Usar gesto e anatomia da folha aprovada; variantes compartilham a família, mas mantêm uma diferença clara. | Bestiário, alvo e resumo de encontro se implementados. |
| **Fases** | Um marco geográfico simples, visto em silhueta. | Marcos de pedra, clareira/fungo, raízes, rastro da matilha e santuário. | Mapa, navegação e objetivo atual. |
| **Chefes** | Emblema maior e mais específico que o inimigo comum. | Galhada e pedra para o Guardião-Cervo; coroa de micélio em camadas para uma Matriarca candidata; perfil de lobo para o Alfa. | Apresentação do encontro e recompensa, se a UI exigir. |
| **Efeitos** | Um sinal com começo, ponto de impacto e dissipação claros. | Raiz/escudo, marca, fratura, cura, telegraph de ataque e brilho de loot. | Combate; reduzir intensidade e respeitar legibilidade mobile. |

O conteúdo da tabela é uma proposta de linguagem. Não adiciona automaticamente telas, bestiário, equipamentos visíveis nos heróis ou novos sistemas ao jogo.

As ideias individuais e os prompts prontos para gerar conceitos de monstros, elite, chefes e os 30 itens estão organizados por pasta em [`conceitos/README.md`](./conceitos/README.md). Contratos e Golden aprovados continuam prevalecendo sobre essas fichas.

## 4. Sistema para ícones

### Itens

- Produzir **30 ícones de item** após confirmar a necessidade e os tamanhos na tela de inventário: os 15 itens já existentes e os 15 candidatos novos do Capítulo 1 em [`../04_content/chapters/chapter_01/OVERVIEW.md`](../04_content/chapters/chapter_01/OVERVIEW.md).
- Manter o desenho-base do item separado de moldura de raridade, estado equipado e seleção. A interface pode compor esses estados sem gerar quatro cópias coloridas do mesmo ícone.
- Variar primeiro a forma e o material. Uma Lendária deve continuar reconhecível sem moldura colorida.
- Nesta proposta, não desenhar nome, sigla ou texto dentro do canvas. Nome, raridade e comparação são texto/UI fora do sprite.

### Skills

- O lote inicial contém **15 ícones para skills normais**, cinco para cada um dos três heróis com conceitos listados no overview do Capítulo 1; Signature Skills não estão incluídas nesse catálogo. A meta do catálogo completo está no [CONTENT_REGISTRY](../CONTENT_REGISTRY.md) e no [padrão canônico](../../HERO_STANDARD.md); criar assets adicionais somente conforme os conceitos das skills restantes forem aprovados.
- Agrupar por gramática visual de herói (motivo, ângulo e acento), mas dar a cada habilidade um verbo visual próprio: proteger, contra-atacar, provocar, reforçar, resistir; marcar, romper, disparar, executar, esquivar; concentrar, proteger, fraturar, restaurar, retornar.
- Se o jogo ainda não exibir todas as skills ao mesmo tempo, manter os arquivos catalogados sem produzir o lote completo antes da aprovação de gameplay.

### Fases e encontros

- Criar um emblema do Bosque e um ícone para cada uma das cinco fases macro.
- **HIPÓTESE de economia visual:** as dez subfases reutilizam o emblema da fase macro com um marcador de progresso/variação de cenário. Só criar dez ícones independentes se mapa e teste de navegação demonstrarem que cada subfase precisa ser distinguida por arte própria.
- Planejar até onze retratos/emblemas de inimigos do Capítulo 1 se forem usados na UI: oito comuns (quatro existentes + quatro candidatos), o Alfa, a Matriarca candidata e o Guardião-Cervo. Não gerar os retratos como sistema isolado se a UI ainda não for usá-los.

## 5. Sprites animados e ambientes do Capítulo 1

O rascunho de conteúdo prevê oito famílias de inimigo comum, Lobo Alfa de Lúmen como elite, Guardião-Cervo de Pedra como chefe existente e Matriarca do Micélio como minichefe candidato. As três folhas do grupo de heróis e as folhas do MVP já têm caminhos e contratos próprios. O elenco extra continua sujeito à aprovação de conteúdo.

**Recomendado:**

- Reusar as quatro camadas do Bosque aprovadas no inventário do MVP, validando-as no cenário/câmera atuais.
- Fazer por fase um pequeno conjunto de marcos de cenário, props e efeitos para distinguir Entrada, Clareira, Ninho, Covil e Santuário.
- Construir variação de subfase trocando poucos props, iluminação, partículas ou composição; não produzir dez fundos inteiros sem evidência de que essa diferença é necessária.
- Reusar efeitos simples de raiz, Lúmen, micélio e pedra quando a leitura continuar clara; os telegraphs de boss devem ter forma própria e contraste suficiente.
- Manter sprites de combate e ícones em contratos e entregas separados: compartilhar referências de estilo, não o mesmo arquivo/redimensionamento.

## 6. Lote-piloto e autorização de produção

Rafael escolheu a grade visual do inventário e definiu 32×32 para os ícones em 2026-09-28. Também autorizou a produção visual direta dos 30 ícones. O lote foi criado com contratos e manifestos e passou pelo linter técnico; auditoria artística independente e revisão mobile continuam pendentes. Os 15 candidatos não foram adicionados aos dados de loot/gameplay.

O piloto para outras famílias de assets continua necessário antes de lotes de skills, fases e novas famílias animadas:

1. **Ícone de skill:** uma skill de cada herói (três) para validar a gramática visual da party.
2. **Ícone de fase:** a Entrada do Bosque e seu estado selecionado/concluído na navegação prevista.
3. **Asset animado novo:** uma única família de inimigo, escolhida após a aprovação do contrato de gameplay.

Passar contrato, lint técnico, inspeção a 1× e revisão independente visual/mobile. Se falhar, corrigir a linguagem e repetir esse conjunto antes de escalar essas famílias. A criação de conceitos em resolução maior não substitui os arquivos finais em pixel art nem o aceite no Godot.

## 7. Contrato e identificação de arquivos

Todo asset novo recebe contrato e manifesto usando o padrão em [`ASSET_MANIFEST.yaml`](./ASSET_MANIFEST.yaml) e [`manifests/README.md`](./manifests/README.md). O contrato registra pelo menos:

- ID estável, categoria, item/personagem/fase vinculado e finalidade/tela de uso;
- versão, tamanho final e escala em que será lido;
- orientação, pivô/baseline quando aplicável, transparência e export;
- Golden/style reference, subconjunto de paleta e limite de cores;
- número de quadros e timing para asset animado;
- proveniência/workflow, autor, QA técnico, auditoria visual independente e status de integração.

Exemplos de nomes candidatos:

```text
item_adaga_de_luz_icon_v001.png
skill_bastiao_amparo_de_raiz_icon_v001.png
stage_bosque_entrada_icon_v001.png
enemy_xama_de_esporos_sheet_v001.png
fx_skill_iris_veio_lumen_v001.png
```

IDs e nomes finais devem corresponder a `data/items/items.json`, aos IDs de gameplay ou ao catálogo de fases quando esses schemas forem definidos. Não renomear os arquivos canônicos atuais em lote.

## 8. Ordem de produção

1. Fechar aceite visual e mobile do conjunto de sprites MVP já produzido.
2. Confirmar em quais telas aparecem os ícones e qual tamanho funciona; montar o lote-piloto da seção 6.
3. Rafael aprova direção do piloto; Têmis faz auditoria independente; Ergane integra os aprovados no Godot.
4. Completar o catálogo de ícones de itens, skills e fases em lotes com contratos e QA próprios.
5. Produzir folhas dos inimigos/minichefe novos após aprovação dos kits de gameplay, seguindo a mesma sequência contrato → arte → QA técnico → auditoria visual independente → integração → validação mobile.
6. Produzir variações ambientais e efeitos conforme a necessidade comprovada por fase e skill.

## 9. Pontos que continuam em aberto

- Validação mobile da grade escolhida e leitura dos ícones finais 32×32.
- Se heróis/inimigos precisam de retratos e se cada subfase terá ícone próprio.
- Direção aprovada para retratos/emblemas; os Golden atuais são sprites de entidade, não Golden de ícone.
- Quais skills e itens entram primeiro no gameplay e quais efeitos realmente exigem arte dedicada.
- Direitos de paleta/arte antes de qualquer redistribuição comercial.

## Critério de pronto desta base

Para os ícones de item, tamanho e tela foram definidos por Rafael, o catálogo foi produzido e o lint técnico passou; falta revisão visual independente e validação mobile. Para skills, fases e novas famílias animadas, o piloto correspondente continua pendente.
