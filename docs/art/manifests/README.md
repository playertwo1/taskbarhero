# Manifestos de assets

Contrato descreve o que deve ser produzido; manifesto registra o que foi produzido e aprovado. Mantenha um arquivo YAML por asset/versão seguindo [`asset_manifest.schema.yaml`](./asset_manifest.schema.yaml). Manifesto não substitui contrato nem Golden.

## Estados oficiais

`DRAFT` → `CONCEPT_APPROVED` → `REFERENCE_LOCKED` → `PIXELIZED` → `CLEANUP` → `TECHNICAL_QA` → `ARTISTIC_QA` → `APPROVED` → `INTEGRATED`.

Transições exigem evidência e responsável/data. `FAIL` devolve o asset à etapa indicada no relatório; não apague tentativas anteriores. O autor não pode preencher a própria aprovação de QA independente.

## Uso

1. Copie o modelo/schema para `assets/.../<asset_id>.manifest.yaml`.
2. Preencha contrato, versão, caminhos e metadados de geração; use `null` somente onde o schema permite.
3. Registre hash SHA-256 dos arquivos de entrada/saída e identificadores/licenças dos modelos.
4. Rode `python tools/sprite_lint.py --manifest <caminho-do-manifesto>`.
5. Atualize resultados QA e status somente com evidência. `APPROVED` requer aprovação artística independente e lint técnico PASS.

Manifestos são versionados junto ao asset. Nunca grave segredos ou caminhos pessoais absolutos. O manifesto global legado continua em [`../ASSET_MANIFEST.yaml`](../ASSET_MANIFEST.yaml); não o confunda com um manifesto de linhagem individual.
