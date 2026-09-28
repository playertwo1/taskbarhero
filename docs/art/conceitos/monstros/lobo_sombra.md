# Lobo de Sombra

**ID de conceito:** `lobo_sombra`

**Estado:** inimigo comum aprovado e implementado no Capítulo 1. Sua spritesheet existe; QA visual independente e revisão mobile continuam pendentes.

**Classificação:** sprite de monstro comum

## Ideia visual

- **Silhueta/forma principal:** Predador quadrúpede muito magro e baixo, pernas traseiras comprimidas para o bote, focinho longo; silhueta enxuta para contrastar com o Alfa robusto.
- **Materiais e detalhes de identidade:** Pelagem quase negra com placas de pelo angulares e olhos focais visíveis; sem juba luminosa, runas ou brilho esmeralda do Alfa; sombra deve ser forma sólida, não fumaça.
- **Paleta candidata:** neutral_stone + crimson em olhos discretos; sem preto preenchendo a silhueta inteira.. Usar somente cores dos subconjuntos TY40 em [`../../PALETTE.md`](../../PALETTE.md); o contrato final prevalece.
- **Escala/orientação:** Conceito isolado; tamanho, baseline e animações aguardam contrato próprio.
- **Leitura que deve sobreviver em 1×:** reconhecer imediatamente a categoria e este asset sem depender do nome, de texto ou de moldura colorida.

## Prompt para gerar um conceito

> Crie um conceito visual original de **Lobo de Sombra** para o jogo Pocket Hero, seguindo a descrição visual desta ficha e a direção de arte em [`../../ASSET_VISUAL_BLUEPRINT.md`](../../ASSET_VISUAL_BLUEPRINT.md). Use pixel art deliberada como referência: silhueta forte, formas grandes e limpas, clusters de pixels, sombreamento duro em 2–3 níveis por material, contorno seletivo escuro e luz fixa vindo do alto à esquerda. A paleta candidata é **neutral_stone + crimson em olhos discretos; sem preto preenchendo a silhueta inteira.**, sempre subordinada ao contrato e a `PALETTE.md`. **Descrição específica:** Predador quadrúpede muito magro e baixo, pernas traseiras comprimidas para o bote, focinho longo; silhueta enxuta para contrastar com o Alfa robusto. Pelagem quase negra com placas de pelo angulares e olhos focais visíveis; sem juba luminosa, runas ou brilho esmeralda do Alfa; sombra deve ser forma sólida, não fumaça.
>
> Gere apenas um objeto/personagem isolado, centralizado, em uma pose neutra que deixe a silhueta clara, sobre fundo transparente ou plano simples removível. Sem cenário, interface, moldura, texto, logotipo, marca d'água, efeitos fora do contorno ou elementos decorativos sem função. Preserve identidade própria de Pocket Hero. O resultado é um **concept/master reference**, não o sprite final: não invente canvas, número de frames, baseline ou animações; confirme-os no contrato antes de pixelizar/integrar.

## Restrições para a IA

- Esta ficha define uma proposta visual, não altera lore, comportamento, atributos, loot ou balanceamento.
- Para assets existentes, contrato e Golden aprovados prevalecem; mantenha a identidade e não os redesenhe.
- Esta ficha orienta a identidade visual do inimigo existente. Dados de gameplay pertencem ao runtime e à documentação de conteúdo; não altere comportamento ou balanceamento por esta ficha.
- Não copie personagens, formas, paletas, poses ou elementos distintivos de jogos de referência.
- Não renderize efeitos de raridade, estados selecionados/equipados, moldura de inventário ou textos dentro do asset.

## Fontes relacionadas

- [Base visual de assets](../../ASSET_VISUAL_BLUEPRINT.md)
- [Direção de arte](../../ART_DIRECTION.md) · [guia de estilo](../../SPRITE_STYLE_GUIDE.md) · [paleta](../../PALETTE.md)
- [Capítulo 1 — catálogo de conteúdo](../../../04_content/chapters/chapter_01/OVERVIEW.md)
