---
id: UI_S04
status: DESIGN
certainty: HIPOTESE
---

# UI_S04 — Loadout da party

**Estado do contrato:** `DESIGN`. **Implementação:** DESIGN (provisório: seletor de 4 presets; build livre por herói decidida)

## Implementação atual

`SliceCampaignScreen` oferece um `OptionButton` com 4 `BUILD_PRESETS` (Ofensivo, Controle, Guardião, Cura). Não há escolha por herói nem visualização de skills.

## Objetivo

Escolher livremente a build de cada herói do trio, ver skills, passivas e Trait fixos da build, o equipamento e o Echo antes de partir.

## Entra por

- Refúgio (S02).
- Expedição (S03).

## Sai para

- Voltar ao Refúgio.
- Inventário (S08) para trocar equipamento.
- Seção Echo do Inventário (S08/S11) para o Echo.

## Dados exibidos

- Três heróis com nome, papel e build atual (2 builds por herói, [SLICE_1_SCOPE](../../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) seção 1).
- Skills equipadas (2), passivas, Trait e efeitos, com texto de `data/skills/`.
- Equipamento por slot e bônus totais.
- Echo equipado.

## Ações

- Escolher a build de cada herói de forma independente (2 ou 3 opções por herói).
- Ver a combinação resultante e se ela é válida.
- Tocar em skill/passiva para ver a descrição.
- Abrir o Inventário (na seção Echo, quando for o slot Echo) a partir do slot.

## Estados

- Editável (fora da run).
- Travado durante a expedição: leitura apenas, com aviso.
- Build sem efeito implementado (nós `kind: none`): sinalizar que o efeito ainda não está ativo.

## Layout e toque

- Três colunas lado a lado (opção 4A) com skills e itens visíveis de relance.
- Gaveta para escolher; nenhuma decisão exige rolagem horizontal.

## Fora do slice

- Escolha de skills por slot dentro de uma build (o slice usa loadout fixo por build).
- Party de 3 entre 8 heróis, Mastery e Signature.

## Critérios de aceite

- Toda combinação escolhida pelo jogador é uma das 18 combinações que o simulador cobre; a tela não permite build inexistente.
- O texto de skills vem dos dados, sem cópia.
- Nenhuma alteração é possível com `inventory.locked`.

## Decisões

- **DECIDIDO:** O slice entrega cada build como loadout fixo, sem gate de nível (regra local do SLICE-1).
- **RECOMENDADO:** Colunas 4A das propostas.
- **DECIDIDO:** Build livre por herói (Rafael, 2026-09-29): Bastião escolhe entre 3 builds, Flecha entre 2 e Íris entre 3, o que dá 18 combinações. O Argos já simula essas 18; os 4 presets viram atalhos opcionais.
- **EM ABERTO:** Se os 4 presets continuam como atalhos na tela.

## Arte

[Contrato de arte](../../art/contracts/screens/s04_loadout.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
