# Contrato global de criação de imagens — Pocket Hero

**Status:** DECIDIDO · **Aplicação:** toda imagem de conceito, mockup de UI, ilustração ou sprite gerado com IA para Pocket Hero.  
Este contrato fixa a identidade visual global e o processo de referência. Contratos específicos definem conteúdo, composição, dimensões e peças; as referências aprovadas do jogo definem a aparência concreta. Um prompt genérico ou a tendência visual do gerador nunca prevalecem sobre eles.

## 1. Identidade visual do jogo

Pocket Hero é um RPG original de expedições em **dark fantasy acolhedora**. Suas imagens pertencem ao mundo próprio do jogo: florestas antigas, pedra gasta, madeira escura, raízes, musgo, metal usado, personagens compactos e focos de Lúmen teal. A atmosfera é sombria, artesanal e legível; a luz mágica e a luz de lanterna são focos pequenos e deliberados.

Use a paleta e o acabamento das referências atuais do Pocket Hero. Ciano, teal, ouro ou qualquer cor de raridade não devem virar brilho neon, arco-íris, aura, gradiente ou chamariz de venda. Ornamentação deve vir de materiais e motivos do mundo (pedra, madeira, raízes, folhas, símbolos próprios), com detalhe subordinado à leitura.

## 2. Referências obrigatórias antes de gerar

1. Leia este contrato, o índice da área e o contrato específico do asset. Para conteúdo de gameplay, confira também sua fonte de dados autoritativa.
2. Localize no índice as referências visuais **atuais** do mesmo tipo de asset. Abra e observe os arquivos de imagem reais antes de escrever o prompt; nomes de estilo como “dark fantasy”, “pixel art” ou “premium” não substituem inspeção visual.
3. Para UI do slice, consulte como âncoras de estilo: o [ui_kit v003](./candidates/ui_kit_v003/concept_ui_kit_v003.png), o [Inventário S08](./mockups/slice_1e_references/s08_inventario_echo_section_concept_v001.png), o [Loadout S04](./mockups/slice_1e_references/s04_loadout_concept_v001.png) e, quando pertinente, o [Ferreiro S10](./mockups/slice_1d_references/02_ferreiro_v003.png). A [direção de arte](./ART_DIRECTION.md), o [guia de estilo](./SPRITE_STYLE_GUIDE.md) e a [paleta](./PALETTE.md) complementam essas imagens.
4. Se a ferramenta aceitar imagens de referência, passe as âncoras atuais do repositório no pedido e diga qual aspecto cada uma ancora. Se não aceitar, descreva os materiais, valores, luz, contraste, densidade, enquadramento e motivos que observou. Não use referência externa para preencher a direção visual.
5. Se duas referências atuais entrarem em conflito, siga a decisão mais recente de Rafael e os contratos aprovados. Se não houver decisão ou âncora visual adequada para a escolha necessária, registre a lacuna e peça a escolha; não invente outra identidade.

### Âncoras visuais de UI do slice

- Fundo e estrutura: superfícies opacas de pedra/carvão e madeira escura; bordas gastas e pouco contraste decorativo; textura em clusters de pixels, não acabamento liso de aplicativo comercial.
- Atmosfera: recortes de floresta antiga, raízes, vegetação e luz ambiente só quando a tela de referência contém espaço de mundo. Em painéis utilitários, mantenha a superfície limpa e o conteúdo fácil de comparar.
- Cor: neutros frios/terrosos dominam; o Lúmen teal é um acento focal e controlado. Fogo pode introduzir âmbar em contexto de forja. Use os subconjuntos TY40 do contrato; não atribua cores saturadas arbitrárias às raridades.
- Forma: ornamentos funcionais e linguagem do ui_kit v003, com leitura a 1×. Preserve hierarquia, densidade e proporções das telas de referência; não invente uma nova gramática visual para cada componente.

## 3. Bloqueio de estética de monetização

Pocket Hero não tem loja, moeda premium, energia, passe, anúncio, gacha, caixa de loot ou vantagem paga no MVP. Nenhuma imagem deve sugerir esses sistemas pelo texto **ou pela linguagem visual**.

Não introduza vitrines, ofertas, preço/desconto, selos VIP, botão de compra, barra de energia, moeda premium, baú de gacha, prêmio de roleta, painel de oferta, molduras arco-íris, gemas luminosas por tier, glow neon, brilho metálico polido ou botões chamativos de compra. Evite a composição típica de RPG mobile monetizado: cards de recompensa com explosão de luz, raridades que competem por saturação, placas douradas de “lendário”, multiplicadores/badges e chamadas visuais que pressionem o jogador a tocar.

Raridade e comparação só aparecem se o contrato específico pedir. Mesmo assim, devem seguir os símbolos, formas, cores e limites definidos pelo contrato e pela paleta; raridade comunica classificação, não preço, prestígio pago ou promessa de poder. Não invente nomes, estatísticas, recompensas, slots, sistemas ou chamadas para ação.

## 4. Fidelidade ao contrato e à referência

- Trate o contrato de UX como autoridade para hierarquia, quantidade, posição, texto e estados. Preserve o recorte; não redesenhe a tela em nome de “mais impacto”.
- Dado de jogo deve vir do contrato/runtime indicado. Texto e número rasterizados, se inevitáveis num estudo de layout, são marcadores ilustrativos e devem estar identificados como tal.
- Siga `docs/art/PALETTE.md` e o contrato individual para subconjuntos e limites. Não crie cores de raridade nem rampas por intuição.
- Imagem conceitual de tela pode mostrar o contexto necessário, mas não deve ganhar cenário, luzes, partículas, brasões ou enfeites que desviem do componente solicitado.
- Preserve nomes, personagens e motivos originais do Pocket Hero. Nunca copie UI, composição distintiva, silhuetas ou assets de outro jogo.

## 5. Revisão antes de publicar uma imagem como referência

Compare a imagem gerada lado a lado com as âncoras do jogo e com o contrato, em tamanho de tela. Verifique:

- a atmosfera e os materiais pertencem ao Pocket Hero;
- forma, luz, contraste, densidade e cores se mantêm próximas das referências atuais;
- a composição respeita o contrato e não parece loja, gacha, oferta ou inventário genérico de RPG mobile;
- não há conteúdo de gameplay inventado nem acento visual de monetização.

Se a imagem parecer pertencer a outro jogo, use brilho neon, molduras de raridade chamativas ou sinalizar venda/pressão de toque, **rejeite-a e gere uma nova** antes de colocá-la como referência atual em qualquer índice. Mantenha referências rejeitadas identificadas como históricas; não as apague nem as reapresente como aprovadas.

Gerar um conceito não aprova conteúdo nem arte final. Integração continua subordinada ao contrato e aos gates de revisão, pixel cleanup, QA técnico, auditoria visual independente e QA mobile definidos para a categoria.

## Fontes e navegação

[Índice de arte](../07_art/INDEX.md) · [conceitos visuais](./conceitos/README.md) · [direção de arte](./ART_DIRECTION.md) · [guia de pixel art](./SPRITE_STYLE_GUIDE.md) · [paleta](./PALETTE.md) · [receitas de prompting](./PROMPT_RECIPES.md)
