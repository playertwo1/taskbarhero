---
id: UI_S04
status: DESIGN
certainty: HIPOTESE
---

# UI_S04 — Loadout da party

**Estado do contrato:** `DESIGN`. **Implementação:** DESIGN (provisório: seletor de 4 presets)

## Implementação atual

`SliceCampaignScreen` oferece um `OptionButton` com 4 `BUILD_PRESETS` (Ofensivo, Controle, Guardião, Cura). Não há escolha por herói nem visualização de skills.

## Objetivo

Escolher a build de cada herói do trio, ver skills, passivas e Trait fixos da build, o equipamento e o Echo antes de partir.

## Entra por

- Refúgio (S02).
- Expedição (S03).

## Sai para

- Voltar ao Refúgio.
- Inventário (S08) para trocar equipamento.
- Gravadora (S11) para o Echo.

## Dados exibidos

- Três heróis com nome, papel e build atual (2 builds por herói, [SLICE_1_SCOPE](../../04_content/chapters/chapter_01/SLICE_1_SCOPE.md) seção 1).
- Skills equipadas (2), passivas, Trait e efeitos, com texto de `data/skills/`.
- Equipamento por slot e bônus totais.
- Echo equipado.

## Ações

- Alternar a build de um herói.
- Tocar em skill/passiva para ver a descrição.
- Abrir Inventário ou Gravadora a partir do slot.

## Estados

- Editável (fora da run).
- Travado durante a expedição: leitura apenas, com aviso.
- Build sem efeito implementado (nós `kind: none`): sinalizar que o efeito ainda não está ativo.

## Layout e toque

- Três colunas lado a lado (opção 4A) com skills e itens visíveis de relance.
- Gaveta para escolher; nenhuma decisão exige rolagem horizontal.

## Fora do slice

- Escolha de skills por slot livre (o slice usa loadout fixo por build).
- Party de 3 entre 8 heróis, Mastery e Signature.

## Critérios de aceite

- Cada combinação de build oferecida corresponde a um preset válido do simulador.
- O texto de skills vem dos dados, sem cópia.
- Nenhuma alteração é possível com `inventory.locked`.

## Decisões

- **DECIDIDO:** O slice entrega cada build como loadout fixo, sem gate de nível (regra local do SLICE-1).
- **RECOMENDADO:** Colunas 4A das propostas.
- **EM ABERTO:** Se combinações livres de build por herói entram já, ou só os 4 presets, até o playtest.

## Arte

[Contrato de arte](../../art/contracts/screens/s04_loadout.yaml) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
