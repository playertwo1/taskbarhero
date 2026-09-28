# Golden References e ART-0

Golden é uma referência interna congelada, com asset, hash, contrato, licença/proveniência, finalidade e aprovação independente registrados. Um PNG chamado “master” ou “reference” não é automaticamente Golden.

## Gate ART-0 — referências para produção

Rafael aprovou os quatro Golden visuais e autorizou refazer o restante do MVP com base neles em 2026-09-27. Os quatro slots abaixo estão completos e o lote de sprites do MVP foi produzido. O ART-0 está **PASS para iniciar a produção**; isso não significa que cada sprite final passou por auditoria visual independente ou validação mobile.

- [ ] **GOLDEN HERO** — herói aprovado, contrato e hash fixos.
- [ ] **GOLDEN ENEMY** — inimigo aprovado, contrato e hash fixos.
- [ ] **GOLDEN BOSS** — boss aprovado, contrato e hash fixos.
- [ ] **GOLDEN ANIMATION** — animação curta aprovada, com frames, timing e hashes registrados.

**Estado atual: ART-0 PASS / SPRITES DO MVP PRODUZIDOS / QA DE RELEASE EM ANDAMENTO.** Rafael aprovou os exemplos visuais de Bastião, Geleia de Lúmen, Guardião-Cervo e animação idle em 2026-09-27, para uso pessoal, e autorizou aplicar essa direção ao restante dos sprites. Os hashes estão fixados abaixo. A aprovação Golden fixa a direção visual; cada folha final ainda precisa de auditoria visual e revisão mobile antes de receber aceite de release.

## Registro congelado

| Slot | Golden ID | Asset/contrato | SHA-256 | Aprovação independente (nome/data) | Estado |
|---|---|---|---|---|---|
| Hero | `GOLDEN_HERO_BASTIAO_V1` | [Bastião v2](./hero_bastiao_candidate_v002.png) · [manifesto](./hero_bastiao_candidate_v002.manifest.yaml) · [fonte](./hero_bastiao_generation_source_v002.png) · `contracts/hero_bastiao.yaml` | `bc1e2a39ed35d29f9806c6f773f377bb15958d83c9f216ca2980dba30b2b132e` | Rafael, 2026-09-27 | GOLDEN VISUAL APROVADO; folha de release/QA pendente |
| Enemy | `GOLDEN_ENEMY_GEL_LUMEN_V1` | [Geleia aprovada](./enemy_geleia_lumen_candidate_v001.png) · [manifesto](./enemy_geleia_lumen_candidate_v001.manifest.yaml) · `contracts/enemy_lumen_slime.yaml` | `512feed18b561d7b59c56d5afac2f651dd930952d1c5f25fd8cb8d703f0f17f7` | Rafael, 2026-09-27 | GOLDEN VISUAL APROVADO; folha de release/QA pendente |
| Boss | `GOLDEN_BOSS_GUARDIAO_CERVO_V1` | [Guardião-Cervo v2](./boss_guardiao_cervo_candidate_v002.png) · [manifesto](./boss_guardiao_cervo_candidate_v002.manifest.yaml) · [fonte](./boss_guardiao_generation_source_v002.png) · `contracts/boss_guardiao_cervo.yaml` | `da2b1fae5987c68433b06623778c33dc0e5e587709320d91ccd0ecb4dc6ea6d3` | Rafael, 2026-09-27 | GOLDEN VISUAL APROVADO; folha de release/QA pendente |
| Animation | `GOLDEN_ANIM_GEL_LUMEN_IDLE_V1` | [Idle, 4 quadros](./enemy_geleia_lumen_idle_candidate_v001.png) · [metadata](./enemy_geleia_lumen_idle_candidate_v001.json) · [manifesto](./enemy_geleia_lumen_idle_candidate_v001.manifest.yaml) · `contracts/enemy_lumen_slime.yaml` (`idle`) | `ed45ec2a2606fab692dd97a5e3ceec6c17996d261430a9054d88624c430749ce` | Rafael, 2026-09-27 | GOLDEN VISUAL APROVADO; apenas tag idle; folha completa/QA pendente |

## Tamanhos e cadência

O contrato de Geleia passou para 64×64, baseline `y=60` e pivô `[32, 60]` (versão 1.1.0). A cadência de quadros já correspondia ao padrão e foi mantida: idle 4, attack 4, hit 2, death 6 (16 no total), respeitando [`ANIMATION_STANDARD.md`](../ANIMATION_STANDARD.md). O candidato idle de Golden Animation contém somente os quatro quadros do tag `idle`.

## Comparação de candidatos

As primeiras propostas de Bastião e Guardião-Cervo foram rejeitadas por Rafael como inferiores ao padrão visual da Geleia. A pedido de Rafael, os PNGs pré-Golden v001 foram removidos do repositório em 2026-09-28 para impedir que sejam reutilizados como referência; os manifestos textuais mantêm o registro da rejeição. Consulte apenas os quatro Golden identificados nesta página e os assets atuais do [inventário MVP](../MVP_SPRITE_INVENTORY.md). Os Golden foram aprovados para uso pessoal; a autorização não concede direitos de redistribuição ou uso comercial.

**Higiene de referência:** fontes editáveis e prévias de sprites produzidas antes da aprovação Golden foram removidas de `assets/sprites/` e das prévias antigas em `docs/art/`. Menções a arquivos antigos no [registro de auditoria](../../REGISTRO_DE_AUDITORIA.md) são apenas históricas. Não recrie nem use essas saídas antigas como base; para produção, siga esta página, os contratos atuais e os manifestos `v002`.

## Versionamento

Ao aprovar um candidato: confirme ID estável, fixe o hash SHA-256, salve preview/fonte/licença e preencha reviewer, data e QA. Mudança visual posterior cria nova versão e reabre auditoria de consistência; nunca sobrescreva silenciosamente um Golden. Golden externo não é permitido sem direitos documentados em [`../REFERENCE_LIBRARY.md`](../REFERENCE_LIBRARY.md).
