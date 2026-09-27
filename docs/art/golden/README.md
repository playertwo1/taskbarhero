# Golden References e ART-0

Golden é uma referência interna congelada, com asset, hash, contrato, licença/proveniência, finalidade e aprovação independente registrados. Um PNG chamado “master” ou “reference” não é automaticamente Golden.

## Gate ART-0 — obrigatório antes de produção em massa

Para abrir produção em massa, todos os quatro registros devem estar completos e aprovados:

- [ ] **GOLDEN HERO** — herói aprovado, contrato e hash fixos.
- [ ] **GOLDEN ENEMY** — inimigo aprovado, contrato e hash fixos.
- [ ] **GOLDEN BOSS** — boss aprovado, contrato e hash fixos.
- [ ] **GOLDEN ANIMATION** — animação curta aprovada, com frames, timing e hashes registrados.

**Estado ao criar esta arquitetura: PENDENTE / NÃO LIBERADO.** Existem referências canônicas anteriores de Bastião e Geleia registradas em `ART_DIRECTION.md`, além de um sprite do Guardião-Cervo; elas são candidatas, mas este gate requer revisão explícita, hash e registro abaixo. A presença dos assets não fecha o gate. Não marcar PASS nem iniciar novo lote até as quatro aprovações. Registre decisão e evidência no roadmap.

## Registro congelado

| Slot | Golden ID | Asset/contrato | SHA-256 | Aprovação independente (nome/data) | Estado |
|---|---|---|---|---|---|
| Hero | — | Candidato: Bastião / `contracts/hero_bastiao.yaml` | — | — | PENDENTE |
| Enemy | — | Candidata: Geleia de Lúmen / `contracts/enemy_lumen_slime.yaml` | — | — | PENDENTE |
| Boss | — | Candidato: Guardião-Cervo / `contracts/boss_guardiao_cervo.yaml` | — | — | PENDENTE |
| Animation | — | Candidata a selecionar; contrato + tag/frame range | — | — | PENDENTE |

## Versionamento

Ao aprovar: atribua ID estável (`GOLDEN_HERO_V1` etc.), fixe o hash SHA-256, salve preview/fonte/licença e preencha reviewer, data e QA. Mudança visual posterior cria nova versão e reabre auditoria de consistência; nunca sobrescreva silenciosamente um Golden. Golden externo não é permitido sem direitos documentados em [`../REFERENCE_LIBRARY.md`](../REFERENCE_LIBRARY.md).
