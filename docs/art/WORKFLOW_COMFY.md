# Workflow ComfyUI — conceitos e sprites

ComfyUI explora conceitos e prepara poses; não aprova nem finaliza pixel art. O acabamento manual no Aseprite/pixel-mcp, auditoria independente da Têmis e integração pelo Godot continuam obrigatórios. Este guia complementa [`COMFY_PIPELINE.md`](./COMFY_PIPELINE.md) e os workflows versionados em [`../../tools/daedalus/comfyui/workflows/`](../../tools/daedalus/comfyui/workflows/).

## Contexto mínimo e ordem de autoridade

Leia o contrato do asset, a Golden aplicável (se existir), as seções relevantes do [guia de estilo](./SPRITE_STYLE_GUIDE.md), o subconjunto da [TY40](./PALETTE.md), o [padrão de animação](./ANIMATION_STANDARD.md) e a [referência aprovada](./REFERENCE_LIBRARY.md). Em conflito: **ASSET CONTRACT > GOLDEN REFERENCES > SPRITE STYLE GUIDE > PALETTE > ANIMATION STANDARD > REFERENCE LIBRARY > EXTERNAL REFERENCES > PROMPT**. Não carregar toda a biblioteca nem citar referência externa sem necessidade.

## Etapas

1. **Pré-checagem:** confirmar contrato existente, `asset_id`, tamanho/canvas, orientação, baseline, silhueta, subconjuntos, limite de cores e animações. Sem contrato: não gerar.
2. **Conceito:** gerar folha neutra ou vistas isoladas em resolução de exploração, sem alegar que é pixel art final. Comparar variações e aprovar uma master reference humana.
3. **Pose e consistência:** derivar uma pose por execução, condicionada pela master aprovada. Manter identidade, equipamento, proporção, luz e escala; não pedir spritesheet inteira de uma vez como padrão.
4. **Transparência e grade:** remover fundo sem halo; converter para pixel clusters deliberados. Testar grid quando necessário, preservando olhos, arma, chifres e silhueta.
5. **Quantização:** mapear apenas aos subconjuntos declarados no contrato. Verificar cores distintas e transparência; não misturar rampas antigas.
6. **Limpeza:** corrigir clusters, outline, baseline, pivô e pixels órfãos manualmente em Aseprite/pixel-mcp.
7. **Exportação e lint:** exportar PNG RGBA sem interpolação; registrar frames e duração. Rodar `python tools/sprite_lint.py --manifest <manifesto-do-asset>.yaml`.
8. **Auditoria independente:** Têmis avalia critérios técnicos e visuais em [`QA_SPRITES.md`](./QA_SPRITES.md). O autor do asset não aprova o próprio resultado.
9. **Integração:** Ergane integra apenas após PASS independente; validar import nearest-neighbor e legibilidade mobile.

## Reprodutibilidade

Cada manifesto registra workflow e versão/hash, ComfyUI e custom nodes relevantes, modelo e licença aprovada, LoRA/adapters, seed, sampler, steps, CFG, resolução, condicionamentos e seus pesos, prompt/negative prompt, entradas e hashes, quantização/grade, versão do conversor e export. Use caminhos relativos ao repositório quando possível. Segredos, tokens e caminhos pessoais não devem ser registrados.

Workflow ausente, modelo não aprovado ou parâmetro relevante desconhecido bloqueia o aceite técnico de reprodutibilidade. Isso não impede guardar um concept exploratório como rascunho.
