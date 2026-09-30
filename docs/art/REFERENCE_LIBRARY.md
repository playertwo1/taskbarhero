# Pocket Hero — biblioteca de referências visuais

Esta biblioteca registra proveniência, estado de aprovação e uso permitido. A presença de um arquivo no repositório não significa que ele seja aprovado, livre de direitos ou autorizado para cópia. A ordem de autoridade está no [guia de estilo](./SPRITE_STYLE_GUIDE.md).

## Referências internas registradas

São referências de consistência visual registradas no projeto. O aceite visual documentado não substitui a confirmação da linhagem/licença dos modelos e insumos em [`MODEL_LICENSES.md`](./MODEL_LICENSES.md), nem libera redistribuição isolada. Se a linhagem aplicável não estiver liberada, trate o arquivo como candidato de estudo e não o use como base de produção.

| ID | Asset | O que observar | Licença/proveniência | Estado |
|---|---|---|---|---|
| `REF_PH_HERO_BASTIAO_V1` | [`assets/sprites/heroes/bastiao/hero_bastiao_sheet.png`](../../assets/sprites/heroes/bastiao/hero_bastiao_sheet.png), contrato [`contracts/hero_bastiao.yaml`](./contracts/hero_bastiao.yaml) | silhueta e proporção do herói, escala de combate | Registro de arte própria do Pocket Hero; linhagem de geração deve ser conferida em `MODEL_LICENSES.md` antes de produção derivada | Referência canônica registrada em `ART_DIRECTION.md`; aprovação de Golden pendente |
| `REF_PH_ENEMY_LUMEN_SLIME_V1` | [`assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png`](../../assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png), contrato [`contracts/enemy_lumen_slime.yaml`](./contracts/enemy_lumen_slime.yaml) | leitura mobile e silhueta de inimigo pequeno | Registro de arte própria do Pocket Hero; linhagem de geração deve ser conferida em `MODEL_LICENSES.md`; edição TY40 recente ainda requer lint/QA do arquivo atual | Referência canônica registrada em `ART_DIRECTION.md`; aprovação de Golden pendente |
| `REF_PH_BOSS_CERVO_CANDIDATE_V1` | [`assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_sheet.png`](../../assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_sheet.png), contrato [`contracts/boss_guardiao_cervo.yaml`](./contracts/boss_guardiao_cervo.yaml) | escala e massa visual de boss | Registro de arte própria do Pocket Hero; confirmar linhagem no manifesto/modelos antes de derivar | Candidata; aprovação de Golden pendente |

Os registros canônicos existentes são referências visuais documentadas, mas o [ART-0](./golden/README.md) exige lint, prova de proveniência e aceite explícito para promovê-los a GOLDEN. Não inferir a aprovação de uma animação, boss ou nova versão a partir da existência dos arquivos.

## Referências externas e materiais locais sem licença confirmada

| ID / arquivos | Uso permitido | Licença/proveniência | Estado |
|---|---|---|---|
| `campfire_heroes_reference.jpg` | referência contextual conforme decisão do projeto | Material de terceiro; licença/termos de uso não documentados neste repositório | Referência de estudo apenas; não incorporar, editar para derivar sprites ou redistribuir |
| TY High Fantasy 40 — [Lospec](https://lospec.com/palette-list/ty-high-fantasy-40) | valores de cor usados como palette master, conforme [`PALETTE.md`](./PALETTE.md) | Criador indicado: Toby_Yasha; página não especifica licença | Rafael aprovou uso pessoal/privado no Pocket Hero em 2026-09-27; não autoriza redistribuição, publicação ou uso comercial |
| Páginas de Task Bar Hero/TBH listadas em `README.md` e `docs/00_project/REFERENCIAS_TBH.md` | estudo de mecânicas e legibilidade abstratas | Direitos pertencem aos respectivos titulares; nenhum direito de reutilização é concedido por este registro | Sem uso visual derivativo; preserve identidade original do Pocket Hero |

**Bloqueio de licença:** antes de promover uma referência externa, registre URL de origem, autor/titular, licença exata e versão/data, permissões comerciais e de modificação, atribuição exigida, prova/arquivo da licença e o elemento limitado que será estudado. Se um campo for desconhecido, mantenha o item como não aprovado.

## Adicionar uma referência

1. Atribua ID estável e registre hash SHA-256 do arquivo versionado.
2. Identifique exatamente o traço estudado (por exemplo, timing ou massa de silhueta), não “estilo geral”.
3. Registre origem, licença, restrições e aprovação humana. Arte gerada também referencia o manifesto de modelos/fluxo em [`MODEL_LICENSES.md`](./MODEL_LICENSES.md) e seu manifesto individual.
4. Descreva a adaptação original e confirme que não se reproduzem elementos expressivos de terceiros.
5. Mantenha arquivos sem licença clara na tabela de não aprovados; não os promova por conveniência.
