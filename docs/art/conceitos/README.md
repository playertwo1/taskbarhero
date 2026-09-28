# Conceitos visuais — Pocket Hero

## Para qualquer IA que vá criar arte

**Cânone de conteúdo:** para sprites de inimigos/equipamentos, use primeiro os [catálogos v0.4](../../../documents/canonical/taskbar_sistema_v0.4/README.md). Muitas fichas e prévias desta pasta foram feitas para o catálogo legado; não transfira automaticamente nomes, papéis, IDs ou efeitos. Assets com Golden aprovado mantêm sua identidade quando ela corresponde ao registro canônico.

1. Leia [`../ASSET_VISUAL_BLUEPRINT.md`](../ASSET_VISUAL_BLUEPRINT.md), [`../SPRITE_STYLE_GUIDE.md`](../SPRITE_STYLE_GUIDE.md), [`../PALETTE.md`](../PALETTE.md) e o Golden correspondente em [`../golden/README.md`](../golden/README.md).
2. Abra o índice da categoria e a ficha exata do asset. Não use só o nome: cada ficha contém a silhueta, materiais, foco visual, paleta candidata e prompt específico.
3. Para assets existentes, consulte o contrato individual e os Golden; estes têm precedência sobre a ficha conceitual. Conceitos com identidade não listada no bestiário ou catálogo v0.4 são visuais legados.
4. Gere primeiro uma única imagem de conceito/master reference em resolução ampla, isolada e com uma pose clara. Peça variantes somente para decisão visual; não gere folha de animação completa numa única imagem.
5. Depois da referência aprovada, siga o contrato para canvas, baseline, facing, paleta e quadros; faça pixel cleanup, lint técnico, auditoria visual independente e validação mobile antes da integração.

## Regras compartilhadas para prompts

- Jogo 2D original, dark fantasy acolhedor, pixel art manual/limpa, vista lateral estrita para sprites de combate. Inimigos olham para a esquerda.
- Prioridade: silhueta → leitura → consistência → animação → detalhe. Luz no alto à esquerda; hard shading em 2–3 níveis por material; clusters deliberados e outline seletivo.
- Sem gradientes, blur, antialiasing, pintura realista, ruído, pixels isolados, microdetalhes, cenário, tipografia, logos ou marcas d'água.
- Use a TY40 somente no escopo/licença registrada em [`PALETTE.md`](../PALETTE.md); cada contrato fixa o subconjunto e o limite de cores. Não invente uma paleta.
- Um prompt não substitui contrato, Golden, guia de estilo nem aprovação de Rafael. Não produzir lote em escala antes do gate de piloto visual já registrado no roadmap.

## Pastas

- [Modelos conceituais de heróis](../CONCEPT_MODEL_STYLE.md) — estilo aprovado, mapa das imagens atuais por personagem e caminho das fichas/contratos para futura criação de sprites.
- [Monstros comuns](./monstros/README.md) — fichas canônicas com brief, status e drops; fichas antigas ficam identificadas como referências legadas.
- [Elites](./elites/README.md) — brief inicial para as três elites canônicas e arquivo da referência legada.
- [Chefes e minichefes](./chefes/README.md) — brief para os três minichefes canônicos e Golden do Guardião-Cervo.
- [Itens](./itens/README.md) — 30 fichas para o catálogo anterior; o catálogo v0.4 precisa ser mapeado/ilustrado.

Os conceitos não incluem skills nem fases; permanecem catalogadas na [base visual](../ASSET_VISUAL_BLUEPRINT.md) para uma próxima fatia.
