# Pocket Hero — direção para modelos conceituais de heróis

**Status:** direção de apresentação visual aprovada por Rafael em 2026-09-28. Não substitui contratos individuais, fichas canônicas ou Golden de produção.

## Direção de apresentação

- Um herói isolado por imagem, corpo inteiro, pose legível e fundo transparente.
- Vista lateral voltada para a direita, preservando a orientação dos sprites de herói.
- Pixel art conceitual ampliada: clusters limpos, contorno seletivo, sombra dura em poucos níveis e forma reconhecível em escala pequena.
- Paleta coerente com TY High Fantasy 40 e com os subconjuntos declarados pelo contrato de cada herói.
- Equipamento distintivo em silhueta clara, sem cenário, tipografia, efeitos decorativos excessivos ou elementos de outros jogos.
- Manter escala, enquadramento e acabamento parecidos entre personagens para facilitar comparação do elenco.
- Seguir a [direção dark fantasy global](./IMAGE_CREATION_CONTRACT.md); não usar estética de loja, monetização, vantagem paga ou progressão pay-to-win como referência.

## Autoridade por assunto

- O [índice de referências visuais atuais](./referencia/README.md) aponta para a versão conceitual mais recente disponível de cada herói.
- A identidade, roupa, arma, mecânica e cores próprias de cada personagem vêm da ficha e do contrato individual em [`../02_heroes/INDEX.md`](../02_heroes/INDEX.md) e [`contracts/`](./contracts/).
- Conceitos não são folhas de animação nem arte final. Não alteram sprites, Golden, runtime ou gameplay sem decisão específica.
- Antes de transformar um conceito em sprite, siga contratos, paleta, pixel cleanup, QA técnico, auditoria visual independente e validação mobile.

## Mapa das referências por herói

Consulte a tabela em [Referências visuais atuais](./referencia/README.md), que mantém um único link conceitual vigente por herói e identifica os Golden aprovados separadamente.

As folhas runtime estão em [`assets/sprites/heroes/`](../../assets/sprites/heroes/). Consulte o [índice de heróis](../02_heroes/INDEX.md) para o catálogo e as cenas.

## Roteiro rápido para futuras IAs

1. Use [Referências visuais atuais](./referencia/README.md) para localizar o conceito vigente.
2. Leia a ficha e o contrato correspondente. A ficha define identidade; o contrato define canvas, baseline, pivot, facing, paleta e animações do sprite.
3. Consulte o [Golden de herói](./golden/README.md), o [guia de estilo](./SPRITE_STYLE_GUIDE.md) e o [contrato global de criação de imagens](./IMAGE_CREATION_CONTRACT.md).
4. Produza primeiro um master isolado para revisão; depois converta em quadros de animação seguindo o contrato e o QA do projeto.
