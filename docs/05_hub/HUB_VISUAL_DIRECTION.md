# Direção visual do Refúgio da Vigília

**Status:** direção visual escolhida para orientar o conceito e a futura composição mobile. A imagem continua sendo referência conceitual; não é arte final nem sprite aprovado.

## Referência base escolhida

Rafael escolheu como base de composição a imagem [Refúgio da Vigília com party e serviços](../art/mockups/hub_environment_concepts_v003/07_refugio_party_e_servicos.png), em 2026-09-28.

Para orientar a tela mobile, existe também o estudo [Composição mobile retrato](../art/mockups/hub_environment_concepts_v004/08_refugio_mobile_retrato.png). Ele transpõe a leitura da base para a proporção vertical; a imagem horizontal v003 continua sendo a referência original escolhida.

Ela define o ponto de partida visual: pátio neutro de pedra e madeira, portão e rotas ao fundo, pequeno foco de Lúmen, forja, bancada de alquimia, fachadas para futuros serviços e área de descanso com fogueira e bancos. O Hub deve servir de base recorrente nas viagens entre biomas; floresta, mina ou outra cidade não devem dominar sua identidade. Lúmen aparece como luz/energia localizada. A Árvore dos Ecos não é o tema nem o marco central desta direção visual.

## Composição para celular

- **DECIDIDO:** a tela do projeto usa viewport vertical de `432×960`, conforme `project.godot`. O Hub ocupa a tela mobile inteira como espaço de jogo.
- **DIREÇÃO DE ARTE:** recompor a referência horizontal para uma cena retrato. Não esticar nem simplesmente recortar a imagem escolhida.
- **DIREÇÃO DE ARTE:** organizar a leitura vertical com entrada/rotas, fachadas de serviços, praça transitável e área da party com bancos/fogueira. A posição exata de UI interativa permanece em aberto até prototipagem.
- **DIREÇÃO DE ARTE:** construir o cenário com vários módulos/quads separados — chão, trechos de muralha, fachadas, telhados, portão, balcões, bigorna, bancada, frascos, bancos, caixas, lanterna e fogueira — em vez de depender de uma única imagem achatada. Isso permite compor a tela inteira e trocar/animar props sem redesenhar todo o fundo.
- **DIREÇÃO DE ARTE:** manter animação para elementos que ganham leitura com movimento, como chama, brasa, brilho de Lúmen e talvez tecido. Quantidade de frames e dimensões por elemento serão definidas no contrato do asset; “usar bastante quadros” não significa animar todos os módulos.
- O estudo retrato v004 mostra a composição-alvo, mas segue sendo uma imagem contínua. A futura entrega de produção deve ser um conjunto modular de peças/quads e folhas de animação separadas, não a simples redução desse PNG.

## Heróis e serviços

- Reutilizar as folhas aprovadas de **Bastião, Flecha e Íris** como os três heróis iniciais. A imagem conceitual serve como referência de pose/posição em descanso, não substitui os sprites canônicos.
- Mostrar um espaço de descanso reconhecível para a party junto da fogueira, com bancos ou assentos.
- A forja do Ferreiro é o primeiro serviço visual ativo. A bancada do Alquimista e fachadas simples dos serviços futuros podem aparecer no layout; sua presença visual não declara esses sistemas implementados nem desbloqueados.
- Identidade, nome, roupa e aparência final dos NPCs artesãos continuam a depender de seus próprios contratos/conceitos.

## Limites antes da produção

A imagem escolhida é uma referência de composição gerada para exploração. Antes da integração, criar contrato específico de cenário/hub, planejar as peças modulares e seus encaixes, aplicar o fluxo de [`ASSET_VISUAL_BLUEPRINT.md`](../art/ASSET_VISUAL_BLUEPRINT.md), [`SPRITE_STYLE_GUIDE.md`](../art/SPRITE_STYLE_GUIDE.md) e [`PALETTE.md`](../art/PALETTE.md), então fazer pixel cleanup, QA técnico, auditoria visual e validação mobile. Não usar o PNG conceitual diretamente como sprite final ou Golden.

## Navegação

- [Índice do Hub](INDEX.md)
- [Conceito escolhido e notas](../art/mockups/hub_environment_concepts_v003/README.md)
- [Estudo de composição mobile retrato](../art/mockups/hub_environment_concepts_v004/README.md)
- [Sistemas de artesãos e crafting](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md)
- [Inventário de sprites e ambientes atuais](../art/MVP_SPRITE_INVENTORY.md)
