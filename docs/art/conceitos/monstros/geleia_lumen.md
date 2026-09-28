# Geleia de Lúmen

**ID de conceito:** `geleia_lumen`

**Estado:** existente; seguir o Golden de inimigo e o contrato `enemy_lumen_slime.yaml` sem redesign.

**Classificação:** sprite de monstro comum

## Ideia visual

- **Silhueta/forma principal:** Pequena massa baixa, arredondada e translúcida, com base larga e topo em gota irregular; um núcleo luminoso grande define o centro.
- **Materiais e detalhes de identidade:** Olhos simples integrados à massa; brilho frio concentrado no núcleo, sem membros ou acessórios que quebrem a leitura de geleia.
- **Paleta candidata:** lumen + crimson (contrato: máximo 12 cores). Usar somente cores dos subconjuntos TY40 em [`../../PALETTE.md`](../../PALETTE.md); o contrato final prevalece.
- **Escala/orientação:** Há divergência documentada: ART_DIRECTION lista 32×32 para a Geleia, enquanto o contrato 1.1.0 e o README Golden registram 64×64, baseline Y=60. O contrato atual prevalece até revisão explícita; não assumir outra resolução.
- **Leitura que deve sobreviver em 1×:** reconhecer imediatamente a categoria e este asset sem depender do nome, de texto ou de moldura colorida.

## Prompt para gerar um conceito

> Crie um conceito visual original de **Geleia de Lúmen** para o jogo Pocket Hero, seguindo a descrição visual desta ficha e a direção de arte em [`../../ASSET_VISUAL_BLUEPRINT.md`](../../ASSET_VISUAL_BLUEPRINT.md). Use pixel art deliberada como referência: silhueta forte, formas grandes e limpas, clusters de pixels, sombreamento duro em 2–3 níveis por material, contorno seletivo escuro e luz fixa vindo do alto à esquerda. A paleta candidata é **lumen + crimson (contrato: máximo 12 cores)**, sempre subordinada ao contrato e a `PALETTE.md`. **Descrição específica:** Pequena massa baixa, arredondada e translúcida, com base larga e topo em gota irregular; um núcleo luminoso grande define o centro. Olhos simples integrados à massa; brilho frio concentrado no núcleo, sem membros ou acessórios que quebrem a leitura de geleia.
>
> Gere apenas um objeto/personagem isolado, centralizado, em uma pose neutra que deixe a silhueta clara, sobre fundo transparente ou plano simples removível. Sem cenário, interface, moldura, texto, logotipo, marca d'água, efeitos fora do contorno ou elementos decorativos sem função. Preserve identidade própria de Pocket Hero. O resultado é um **concept/master reference**, não o sprite final: não invente canvas, número de frames, baseline ou animações; confirme-os no contrato antes de pixelizar/integrar.

## Restrições para a IA

- Esta ficha define uma proposta visual, não altera lore, comportamento, atributos, loot ou balanceamento.
- Para assets existentes, contrato e Golden aprovados prevalecem; mantenha a identidade e não os redesenhe.
- Para candidatos novos, os detalhes são hipótese visual; não os trate como conteúdo de gameplay aprovado.
- Não copie personagens, formas, paletas, poses ou elementos distintivos de jogos de referência.
- Não renderize efeitos de raridade, estados selecionados/equipados, moldura de inventário ou textos dentro do asset.

## Fontes relacionadas

- [Contrato](../../contracts/enemy_lumen_slime.yaml) · [Golden inimigo](../../golden/enemy_geleia_lumen_candidate_v001.png)
- [Base visual de assets](../../ASSET_VISUAL_BLUEPRINT.md)
- [Direção de arte](../../ART_DIRECTION.md) · [guia de estilo](../../SPRITE_STYLE_GUIDE.md) · [paleta](../../PALETTE.md)
- [Capítulo 1 — catálogo de conteúdo](../../../04_content/chapters/chapter_01/OVERVIEW.md)
