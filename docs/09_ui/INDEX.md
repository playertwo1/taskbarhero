# UI — índice

Contratos de tela do slice. Cada tela tem um contrato de UX em Markdown (objetivo, dados, ações, estados, aceite) e um contrato de arte estruturado em [`docs/art/contracts/screens/`](../art/contracts/screens/). Regras comuns: [SCREEN_CONVENTIONS](SCREEN_CONVENTIONS.md). Status de todos: `DESIGN`, aguardando revisão de Rafael.

| ID | Tela | Implementação hoje | Contrato de UX | Contrato de arte |
| --- | --- | --- | --- | --- |
| `UI_S01` | Título | provisória | [s01](screens/s01_titulo.md) | [yaml](../art/contracts/screens/s01_titulo.yaml) |
| `UI_S02` | Refúgio (Hub) | não existe; a preparação da campanha é substituta | [s02](screens/s02_refugio.md) | [yaml](../art/contracts/screens/s02_refugio.yaml) |
| `UI_S03` | Expedição (seleção) | botão na preparação | [s03](screens/s03_expedicao.md) | [yaml](../art/contracts/screens/s03_expedicao.yaml) |
| `UI_S04` | Loadout da party | seletor de 4 presets | [s04](screens/s04_loadout.md) | [yaml](../art/contracts/screens/s04_loadout.yaml) |
| `UI_S05` | Expedição em curso | texto, sem sprites de combate | [s05](screens/s05_expedicao_em_curso.md) | [yaml](../art/contracts/screens/s05_expedicao_em_curso.yaml) |
| `UI_S06` | Escolha (Reward Choice e evento) | botões de texto | [s06](screens/s06_escolha.md) | [yaml](../art/contracts/screens/s06_escolha.yaml) |
| `UI_S07` | Resultado | texto | [s07](screens/s07_resultado.md) | [yaml](../art/contracts/screens/s07_resultado.yaml) |
| `UI_S08` | Inventário | lista de texto | [s08](screens/s08_inventario.md) | [yaml](../art/contracts/screens/s08_inventario.yaml) |
| `UI_S09` | Árvore dos Ecos | lista linear de 6 nós | [s09](screens/s09_arvore_dos_ecos.md) | [yaml](../art/contracts/screens/s09_arvore_dos_ecos.yaml) |
| `UI_S10` | Ferreiro | lista de texto | [s10](screens/s10_ferreiro.md) | [yaml](../art/contracts/screens/s10_ferreiro.yaml) |
| `UI_S11` | Gravadora de Ecos | dentro do Inventário | [s11](screens/s11_gravadora_de_ecos.md) | [yaml](../art/contracts/screens/s11_gravadora_de_ecos.yaml) |

## Sem contrato ainda (fora do slice)

Retorno offline, Bestiário/Codex, Alquimista, Ourives, seleção entre os 8 heróis, Mastery, missões de herói, configurações, créditos e capítulos futuros. Só ganham contrato depois que o sistema correspondente tiver regra aprovada.

## Fluxo

`Título → Refúgio → Expedição → (Loadout) → Expedição em curso ⇄ Escolha → Resultado → Refúgio → Inventário / Árvore / Ferreiro / Gravadora`

Voltar ao [índice de docs](../INDEX.md).
