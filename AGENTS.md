# Pocket Hero — instruções para agentes de código

## Antes de trabalhar

1. Leia [`documents/INDEX.md`](documents/INDEX.md) e [`documents/AI_PROJECT_GUIDE.md`](documents/AI_PROJECT_GUIDE.md).
2. Leia [`ROADMAP.md`](ROADMAP.md) e o guia temático ligado à tarefa; não carregue tudo quando uma fonte menor basta.
3. Confira `git status` e preserve todas as alterações pré-existentes, inclusive arquivos não rastreados. Nunca sobrescreva nem inclua esses arquivos no commit por conveniência.

## Fontes e decisões

- A instrução mais recente de Rafael prevalece.
- Código e testes mostram o que existe; `ROADMAP.md` define o plano e os gates.
- O guia de IA e os guias de design são contexto, não prova de implementação nem autorização para expandir escopo.
- Separe **DECIDIDO**, **RECOMENDADO**, **HIPÓTESE** e **EM ABERTO**. Não transforme números ou propostas de teste em requisitos finais sem confirmação/evidência.
- Se uma decisão aberta afetar a tarefa, pare e peça a escolha de Rafael em vez de inventá-la.

## Produto e originalidade

- O produto é Pocket Hero; `taskbarhero` é o nome do repositório. TBH/Task Bar Hero é apenas referência.
- Preserve identidade, nomes, arte, lore, UI, mapas, textos e balanceamento originais. Não copie assets ou conteúdo distintivo do jogo de referência.
- O MVP é Android como app normal. Overlay, backend, contas, multiplayer, cloud save, monetização e expansão grande de conteúdo estão fora do MVP.
- Não introduza vantagem paga ou sistema que dependa de compra.

## Implementação e aceite

- Trabalhe uma fatia do roadmap por vez. Antes de editar, determine arquivos, comportamento esperado e regressão/aceite.
- Para economia e pacing, registrar hipótese, fórmula, fontes/saídas de recursos e como simular ou medir; não chamar números de balanceados sem playtest/telemetria.
- Para arte, usar contrato, QA técnico e auditoria visual independente antes da integração; não escalar produção antes de passar o gate do primeiro asset.
- Execute as verificações pertinentes do roadmap, revise o diff e registre evidência. Teste parcial não fecha uma etapa inteira.
- Não instale ferramentas, altere segurança, faça commit ou push sem pedido explícito de Rafael. Nunca exponha credenciais.
