# Pocket Hero — Receitas de Prompting e Instrução Artística (Daedalus)

**Status:** DECIDIDO (FASE R7)  
**Versão:** 1.0.0  
**Uso:** Daedalus / Agentes Geradores com MCP `pixel-mcp`  

---

## 1. Princípios de Geração via IA

Ao instruir o agente artístico (Daedalus) ou chamar ferramentas MCP para criação de sprites:
1. **Nunca gerar "no vácuo":** O prompt deve referenciar explicitamente o arquivo de contrato (`docs/art/contracts/<asset>.yaml`) e a paleta (`docs/art/PALETTE.md`).
2. **Construção em Camadas:**
   - **Passo 1 — Silhueta:** Criar o contorno e a massa principal com 1 cor de rascunho, validando baseline e proporções.
   - **Passo 2 — Sombreamento de Volume:** Aplicar sombras direcionais (luz do alto à esquerda) usando as cores da rampa.
   - **Passo 3 — Acentos Bioluminescentes:** Adicionar os pontos focais iluminados (olhos, núcleo, lâmina).
   - **Passo 4 — Animação:** Gerar as poses chave respeitando antecipação, ação e recuperação.
   - **Passo 5 — Limpeza:** Remover pixels órfãos (*stray pixels*), corrigir *jaggies* e aparar contornos.

---

## 2. Template Padrão de Prompt para Daedalus

```markdown
Atue como Daedalus, especialista em Pixel Art do Pocket Hero.
Crie o asset conforme o contrato abaixo:

CONTRATO: {caminho_do_contrato}
ASSET_ID: {asset_id}
DIMENSÕES: {largura}x{altura}
DIREÇÃO DA FACE: {left para inimigos | right para heróis}
BASELINE: Y = {baseline_y}
FONTE DE LUZ: Top-left (alto à esquerda) a 45°
RAMPAS OBRIGATÓRIAS: {rampa_1, rampa_2} de docs/art/PALETTE.md

ANIMAÇÕES A GERAR:
1. idle ({N} frames): ciclo sutil de respiração/pulsação em loop.
2. attack ({N} frames): recuo rápido, avanço com corte e retorno.
3. hit ({N} frames): recuo com flash de impacto.
4. death ({N} frames): colapso e dissipação.

RESTRIÇÕES RÍGIDAS:
- Fundo 100% transparente.
- Sem pillow-shading.
- Sem interpolação ou desfoque.
- Exportar spritesheet horizontal e metadados JSON.
```

---

## 3. Receita Específica: Geleia de Lúmen (Slime)

```markdown
CRIATURA: Geleia de Lúmen (enemy_geleia_lumen)
CANVAS: 32x32 pixels
FACING: Left (olhando para a esquerda)
BASELINE: Y = 29
RAMPAS: Lúmen (Ciano/Turquesa) + Sangue (apenas para olhos/núcleo interno quando irritado)

POSES CHAVE:
- idle (4 frames):
  - F1: Forma de gota relaxada (18px de altura, 20px de largura).
  - F2: Leve compressão para baixo (16px altura, 22px largura - squash).
  - F3: Alongamento suave para cima (20px altura, 18px largura - stretch).
  - F4: Retorno à posição base F1.
- attack (4 frames):
  - F1: Recuo e achatamento no solo preparando impulso (squash forte).
  - F2: Salto em arco diagonal em direção ao herói com corpo esticado.
  - F3: Impacto frontal e expansão de bioluminescência.
  - F4: Aterrissagem e recuperação para a base.
- hit (2 frames):
  - F1: Deformação com recuo para a direita e flash esbranquiçado no núcleo.
  - F2: Recuperação de forma tremulando.
- death (6 frames):
  - F1-F2: Núcleo brilha intensamente e racha.
  - F3-F4: Colapso gelatinoso no solo com esferas menores se separando.
  - F5-F6: Dissolução translúcida dos resíduos em fumaça de luz tênue até sumir.
```
