# QA de sprites — Têmis

O lint automatiza verificações determinísticas. Ele não avalia beleza, semelhança, leitura ou intenção; essas avaliações são independentes e humanas. Um asset só integra após QA técnico e visual PASS.

## Códigos de FAIL

| Código | Significado | Ação |
|---|---|---|
| `SPR-001` | Arquivo ausente, ilegível ou formato não PNG | Corrigir caminho/exportar PNG válido |
| `SPR-002` | Dimensão/canvas ou tileset incompatível com contrato | Corrigir export ou contrato aprovado |
| `SPR-003` | PNG sem canal RGBA ou alpha não binário/sem transparência quando requerido | Corrigir export e remover halo |
| `SPR-004` | Cor visível fora de TY40/subconjuntos autorizados | Requantizar pela paleta autorizada e inspecionar |
| `SPR-005` | Cores visíveis excedem `max_colors` | Simplificar rampas e clusters |
| `SPR-006` | Naming, frame count, strip/atlas ou metadata incompatível | Corrigir nomes e dimensões/tags |
| `SPR-007` | Frames com canvas, pivô ou baseline inconsistentes | Alinhar frames e revisar movimento |
| `SPR-008` | Contrato/manifesta ausente, incompleto ou divergente | Corrigir metadados antes do aceite |
| `SPR-009` | Pixel grid, nearest-neighbor ou import Godot incorreto | Corrigir pixels/import e revisar no jogo |
| `SPR-010` | Silhueta, pose, leitura 1× ou contraste mobile falha | Revisar design e repetir auditoria visual |
| `SPR-011` | Design drift, anatomia/arma quebrada ou identidade inconsistente | Voltar à master reference e refazer frames |
| `SPR-012` | Licença/proveniência de referência ou modelo não liberada | Remover dependência ou esclarecer licença |
| `SPR-013` | Workflow/linhagem insuficiente para reproduzir o asset | Completar manifesto; exploratory draft não é release |
| `SPR-014` | Aprovação própria, ART-0 incompleto ou gate contornado | Solicitar revisor independente e bloquear lote |

O linter emite IDs técnicos próprios, mapeados para `SPR-001` a `SPR-008`; falhas visuais/legais e gate são registradas pela Têmis no relatório, não inferidas pelo script.

## Checklist independente

- [ ] contrato corresponde ao asset e à versão auditada;
- [ ] silhueta e função reconhecíveis em escala 1×;
- [ ] paleta, outline, clusters, iluminação e transparência passam;
- [ ] todos os frames preservam identidade, pivô e baseline;
- [ ] timing correto e independente de 60/120 FPS;
- [ ] nearest-neighbor e contraste/legibilidade em tela mobile;
- [ ] originalidade e referências/licenças documentadas;
- [ ] reviewer diferente do autor registra PASS/FAIL, data, versão e evidências.

## Resultado

Formato do parecer (herdado do checklist R7):

```text
VEREDITO: [PASS | FAIL | ESCALATE]
EVIDÊNCIAS:
- [item auditado]: [evidência observada]
AÇÃO RECOMENDADA:
- PASS: liberar para integração no Godot.
- FAIL: devolver com códigos SPR-*, frames/pixels e correção.
- ESCALATE: bloquear e submeter a Rafael se houver contradição de design ou escopo.
```

Critérios visuais complementares: teste de silhueta preenchida em preto, luz principal do alto à esquerda (~45°), sem jaggies, doubles, pillow-shading ou pixels isolados, e baseline conforme [`ANIMATION_STANDARD.md`](./ANIMATION_STANDARD.md#defaults-técnicos-herdados-do-padrão-r7).

`PASS` exige todos os critérios aplicáveis aprovados e nenhuma falha aberta. Caso contrário, `FAIL` com códigos, arquivo/frames, evidência e ação de correção. Registre cada tentativa sem apagar resultados anteriores.
