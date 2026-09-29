# Hub — índice

O fluxo principal do MVP não integra um sistema de Hub. Existe uma cena isolada de protótipo de UI em [`scenes/ui/HubScreen.tscn`](../../scenes/ui/HubScreen.tscn), mas ela não é a cena principal nem confirma serviços, persistência ou progressão de Hub implementados. As referências abaixo descrevem o design pós-MVP.

- **Direção visual escolhida para o futuro Hub:** [Refúgio da Vigília — composição mobile e referência base](HUB_VISUAL_DIRECTION.md). [Imagem base com party e serviços](../art/mockups/hub_environment_concepts_v003/07_refugio_party_e_servicos.png) · [estudo vertical para celular](../art/mockups/hub_environment_concepts_v004/08_refugio_mobile_retrato.png). São referências conceituais, não sprite final nem prova de implementação.

- **Artesãos e serviços da cidade:** [equipamentos e artesãos — CRAFT-1 / ITEM-1](../03_systems/EQUIPMENT_AND_CRAFTING_SYSTEM.md); Ferreiro atende Arma, Secundário e Armadura; Ourives atende os dois slots de Acessório; Gravadora atende Echo; Alquimista atende materiais, catalisadores, transmutação e consumíveis. A disponibilidade de cada serviço continua condicionada aos gates de conteúdo/economia.
- **Árvore e meta-progressão:** [Árvore dos Ecos](../03_systems/GLOBAL_RESONANCE_TREE.md); estrutura e catálogo de 30 nós aprovados em design `TREE-1`; valores, economia, interface e runtime continuam pendentes.
- **Ecos/Codex:** um Echo funcional e opcional está incluído no escopo de design do slice; extração, infusão e Codex completo ficam para depois. Consulte o [Sistema de Ecos](../03_systems/ECHO_SYSTEM.md).
- **Prioridade e gates:** [roadmap](../../ROADMAP.md) — SLICE-0/SLICE-1 e trilha HUB-1 pausada.
- **Estrutura proposta do Refúgio:** [núcleo, estabelecimentos e regra de desbloqueio](HUB_STRUCTURE_SEEDS.md) — `CONCEPT`, sem aprovação de layout.
