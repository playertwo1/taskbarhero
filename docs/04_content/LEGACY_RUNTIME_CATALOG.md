# Catálogos runtime legados e migração v0.4

**Função:** tabela de aliases entre os IDs do MVP antigo e os IDs dos catálogos canônicos v0.4. **O conteúdo legado foi removido de `/data` no `1A-CUT` (2026-09-29)**; os IDs da coluna “runtime atual” existem só no histórico do git (commit `cd47758`) e no campo `legacy_alias` das linhas do slice, que serve para reaproveitar nome e sprite.

**Alias no slice (`SLICE-1A-2`):** as linhas do slice em `/data` têm `content_set: "slice"`, `id` igual ao ID de design em minúsculas (por exemplo `en_c1_001`), `design_id` e `legacy_alias` com o ID antigo desta tabela, ou `null` quando a entidade é nova. O alias serve para reaproveitar nome e sprite; os stats vêm da composição de `data/balance/combat_core.json` com o perfil do capítulo, e não dos valores legados. Depois do `1A-CUT` todas as linhas de `/data` pertencem ao slice.

## Inimigos

| ID runtime atual | Entidade runtime | ID canônico v0.4 | Tratamento |
|---|---|---|---|
| `geleia_de_lumen` | Geleia de Lúmen | `EN_C1_001` | Alias de entidade; dados de combate/loot ainda precisam de migração. |
| `espirito_de_raiz` | Espírito de Raiz | `EN_C1_002` | Alias de entidade; dados de combate/loot ainda precisam de migração. |
| `gremlin_de_folha` | Gremlin de Folha | `EN_C1_003` | Alias de entidade; variante singular preservada no runtime. |
| `javali_de_musgo` | Javali de Musgo | `EN_C1_004` | Alias de entidade; dados de combate/loot ainda precisam de migração. |
| `guardiao_cervo_de_pedra` | Guardião-Cervo de Pedra | `BOSS_C1_001` | Alias de entidade; dados de combate/loot ainda precisam de migração. |
| `saqueador_da_mata` | Saqueador da Mata | — | Conteúdo runtime legado sem registro no bestiário canônico v0.4. |
| `xama_de_esporos` | Xamã de Esporos | — | Conteúdo runtime legado sem registro no bestiário canônico v0.4. |
| `sentinela_de_raizes` | Sentinela de Raízes | — | Conteúdo runtime legado sem registro no bestiário canônico v0.4. |
| `lobo_de_sombra` | Lobo de Sombra | — | Conteúdo runtime legado sem registro no bestiário canônico v0.4. |
| `lobo_alfa_de_lumen` | Lobo Alfa de Lúmen | — | Conteúdo runtime legado; a elite canônica não tem equivalência direta. |
| `matriarca_do_micelio` | Matriarca do Micélio | — | Conteúdo runtime legado; minichefes canônicos têm identidades diferentes. |

## Equipamentos

Os 15 IDs runtime atuais pertencem ao catálogo anterior e permanecem carregáveis até migração. Nenhum deve ser reinterpretado como um item novo apenas por pertencer à mesma categoria.

| ID runtime atual | Item runtime | ID canônico v0.4 | Tratamento |
|---|---|---|---|
| `adaga_de_luz` | Adaga de Luz | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `espada_de_musgo` | Espada de Musgo | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `lamina_silvestre` | Lâmina Silvestre | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `machado_ancestral` | Machado Ancestral | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `cajado_de_lumen` | Cajado de Lúmen | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `tunica_de_folhas` | Túnica de Folhas | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `gibao_de_casca` | Gibão de Casca | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `couraca_de_javali` | Couraça de Javali | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `placa_rochosa` | Placa Rochosa | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `armadura_do_guardiao` | Armadura do Guardião | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `pedra_polida` | Pedra Polida | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `semente_vital` | Semente Vital | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `colar_de_espiritos` | Colar de Espíritos | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `amuleto_do_cervo` | Amuleto do Cervo | — | Legado; sem equivalência de identidade no catálogo v0.4. |
| `coracao_da_floresta` | Coração da Floresta | — | Legado; sem equivalência de identidade no catálogo v0.4. |

O catálogo canônico completo de IDs/nome/conceito está na [fonte v0.4](../../documents/canonical/taskbar_sistema_v0.4/README.md). Os dados efetivos do MVP estão em [`data/enemies/enemies.json`](../../data/enemies/enemies.json) e [`data/items/items.json`](../../data/items/items.json). Atribuir equivalências aos itens ou aos inimigos legados sem correspondência exige decisão de migração; não inferir equivalência por categoria ou função aproximada.
