# Catálogo de rejeições de arte

Registre falhas observadas para evitar regressão. Não marque hipóteses como erros ocorridos: use `PENDENTE` até haver arquivo, frame e evidência. Este catálogo complementa os códigos de [`QA_SPRITES.md`](./QA_SPRITES.md).

## Padrões rejeitados

| ID | Padrão | Sintoma verificável | Correção | Status |
|---|---|---|---|---|
| `REJ-PIXEL-001` | Ilustração reduzida apresentada como pixel art | antialiasing, clusters incoerentes ou ruído visível em 1× | reconstruir clusters e contornos manualmente | Regra preventiva |
| `REJ-PALETTE-001` | Cores herdadas de rampas antigas fora da TY40 | linter encontra RGB visível ausente dos subconjuntos autorizados | requantizar e auditar visualmente | Regra preventiva |
| `REJ-ANIM-001` | Drift entre frames | rosto, roupa, arma, proporção ou paleta mudam sem intenção | usar Golden/master e pose frame a frame | Regra preventiva |
| `REJ-MOBILE-001` | Sprite funciona apenas ampliado | função/arma/silhueta deixam de ser legíveis em 1× | simplificar massas e aumentar pixels dos focos | Regra preventiva |
| `REJ-LICENSE-001` | Referência sem licença/proveniência clara usada como fonte de produção | ausência de titular/licença/permissão verificável | limitar a análise interna ou substituir | Bloqueio preventivo |

## Registro de ocorrência

Para cada novo caso, acrescente ID, asset/manifesto, commit, arquivo e frames, código de QA, causa, correção aprovada, evidência de revalidação e status. Preserve o original em histórico Git; não duplique nem publique material que não possua direitos claros.
