# Pocket Hero — direção para modelos conceituais de heróis

**Status:** referência visual de estilo aprovada por Rafael em 2026-09-28. Não substitui os contratos individuais, as fichas canônicas ou os Golden de produção.

## Registro da decisão

Rafael aprovou o conjunto de [modelos conceituais v001 para Brasa, Véu, Orvalho, Forja e Sino](./mockups/hero_model_concepts_v001/README.md) como base de apresentação visual para modelos conceituais futuros. O conjunto serve como histórico de como mostrar a arte de personagens do Pocket Hero às IAs e à equipe.

## Direção que esses modelos estabelecem

- Um herói isolado por imagem, corpo inteiro, pose legível e fundo transparente.
- Vista lateral voltada para a direita, preservando a orientação dos sprites de herói.
- Pixel art conceitual ampliada: clusters limpos, contorno seletivo, sombra dura em poucos níveis e forma reconhecível em escala pequena.
- Paleta coerente com TY High Fantasy 40 e com os subconjuntos declarados pelo contrato de cada herói.
- Equipamento distintivo em silhueta clara, sem cenário, tipografia, efeitos decorativos excessivos ou elementos de outros jogos.
- Manter escala, enquadramento e acabamento parecidos entre personagens para facilitar comparação de elenco.

## Autoridade por assunto

- A direção aprovada de apresentação está nos modelos v001 linkados acima.
- A identidade, roupa, arma, mecânica e cores próprias de cada personagem vêm da ficha e do contrato individual em [`../02_heroes/INDEX.md`](../02_heroes/INDEX.md) e [`contracts/`](./contracts/).
- Os modelos conceituais não são folhas de animação nem arte final. Não alteram sprites, Golden, runtime ou gameplay sem decisão específica.
- Antes de transformar um modelo em sprite, seguir os contratos, a paleta e o fluxo de pixel cleanup, QA técnico, auditoria visual independente e validação mobile.

## Mapa das referências por herói

Use a imagem indicada como referência conceitual mais recente. “Atual” aqui significa referência visual para consulta; não significa que o desenho foi aprovado como modelo canônico nem que substitui o sprite runtime. O [índice visual do elenco e Capítulo 1](./referencia/README.md) mantém o mapa dos arquivos e o histórico.

| Herói | Referência conceitual a consultar | Ficha de identidade | Contrato de sprite |
| --- | --- | --- | --- |
| Bastião | [candidato v004](./referencia/herois/HERO_001_bastiao_conceito_v004.png) · [Golden aprovado](./golden/hero_bastiao_candidate_v002.png) · [v003 histórico](./referencia/herois/HERO_001_bastiao_conceito_v003.png) | [HERO_001](../02_heroes/hero_001_bastiao.md) | [hero_bastiao.yaml](./contracts/hero_bastiao.yaml) |
| Flecha | [conceito v004](./referencia/herois/HERO_002_flecha_conceito_v004.png) · [v003 histórico](./referencia/herois/HERO_002_flecha_conceito_v003.png) | [HERO_002](../02_heroes/hero_002_flecha.md) | [hero_flecha.yaml](./contracts/hero_flecha.yaml) |
| Íris | [conceito v005](./referencia/herois/HERO_003_iris_conceito_v005.png) · [v004 histórico](./referencia/herois/HERO_003_iris_conceito_v004.png) · [v003 histórico](./referencia/herois/HERO_003_iris_conceito_v003.png) | [HERO_003](../02_heroes/hero_003_iris.md) | [hero_iris.yaml](./contracts/hero_iris.yaml) |
| Brasa | [conceito v003](./referencia/herois/HERO_004_brasa_conceito_v003.png) · [v002 histórico](./referencia/herois/HERO_004_brasa_conceito_v002.png) | [HERO_004](../02_heroes/hero_004_brasa.md) | [hero_brasa.yaml](./contracts/hero_brasa.yaml) |
| Véu | [conceito v003](./referencia/herois/HERO_005_veu_conceito_v003.png) · [v002 histórico](./referencia/herois/HERO_005_veu_conceito_v002.png) | [HERO_005](../02_heroes/hero_005_veu.md) | [hero_veu.yaml](./contracts/hero_veu.yaml) |
| Orvalho | [conceito v003](./referencia/herois/HERO_006_orvalho_conceito_v003.png) · [v002 histórico](./referencia/herois/HERO_006_orvalho_conceito_v002.png) | [HERO_006](../02_heroes/hero_006_orvalho.md) | [hero_orvalho.yaml](./contracts/hero_orvalho.yaml) |
| Forja | [conceito v003](./referencia/herois/HERO_007_forja_conceito_v003.png) · [v002 histórico](./referencia/herois/HERO_007_forja_conceito_v002.png) | [HERO_007](../02_heroes/hero_007_forja.md) | [hero_forja.yaml](./contracts/hero_forja.yaml) |
| Sino | [conceito v003](./referencia/herois/HERO_008_sino_conceito_v003.png) · [v002 histórico](./referencia/herois/HERO_008_sino_conceito_v002.png) | [HERO_008](../02_heroes/hero_008_sino.md) | [hero_sino.yaml](./contracts/hero_sino.yaml) |

As folhas runtime atuais continuam em [`assets/sprites/heroes/`](../../assets/sprites/heroes/). Consulte o [índice de heróis](../02_heroes/INDEX.md) para o catálogo e cenas.

## Roteiro rápido para futuras IAs

1. Leia este mapa para localizar a imagem conceitual mais recente do herói.
2. Leia a ficha correspondente e o contrato ligado na tabela. A ficha define a identidade; o contrato define canvas, baseline, pivot, facing, paleta e animações do sprite.
3. Consulte o [Golden de herói](./golden/README.md) e o [guia de estilo](./SPRITE_STYLE_GUIDE.md). Use v001 como base de apresentação, não como licença para copiar detalhes de outro herói.
4. Preserve as versões anteriores como histórico. Em especial, não reutilize Íris v002 como referência atual: ela ficou parecida demais com Sino e foi substituída pela proposta v003.
5. Produza primeiro um master isolado para revisão; só depois converta em quadros de animação seguindo o contrato e o QA do projeto.

## Histórico de versões

- **v001 — cinco heróis restantes:** primeiro conjunto de conceitos; escolhido por Rafael como referência visual de estilo.
- **v002 — trio inicial:** Bastião, Flecha e Íris refeitos para testar a consistência visual com o estilo de v001. Consulte [`mockups/hero_model_concepts_v002/README.md`](./mockups/hero_model_concepts_v002/README.md).
- **v003 — Íris revisada:** proposta v002 preservada no histórico; a v003 reduz a semelhança percebida com Sino sem alterar ainda a ficha/contrato. Consulte [`mockups/hero_model_concepts_v003/README.md`](./mockups/hero_model_concepts_v003/README.md).
- **Nova rodada de conceitos — 2026-09-29:** referências atualizadas para os oito heróis: Bastião v004 (candidato; Golden v002 mantido), Flecha v004, Íris v005 e Brasa/Véu/Orvalho/Forja/Sino v003. Consulte [índice de referências](./referencia/README.md); versões anteriores foram mantidas como histórico.
