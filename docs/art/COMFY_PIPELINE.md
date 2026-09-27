# Pipeline Artístico IA — ComfyUI & Daedalus

> **Status:** DECIDIDO (2026-09-27)  
> **Papel do ComfyUI:** Motor Generativo Principal (Conceitos, referências, variantes, poses, frames).  
> **Papel do Aseprite + pixel-mcp:** Bancada de Acabamento Técnico (Limpeza de clusters, paleta, timing, tags, spritesheet).  
> **Papel de Têmis:** Auditoria Independente de Conformidade (QA visual e técnico).  
> **Papel de Ergane:** Integração na Godot Engine.  

---

## 1. Princípio Fundamental de Arquitetura

O processo de geração artística do Pocket Hero separa claramente a **criação de visual** do **acabamento técnico**:

```text
                     HERMES (Orquestração)
                               │
                       THEIA (Escopo)
                               │
                     DAEDALUS (Fábrica de Arte)
             ┌─────────────────┴─────────────────┐
             │                                   │
      MOTOR GENERATIVO                  BANCADA TÉCNICA
          ComfyUI                           Aseprite
    (Conceito, referência,              (Limpeza de pixels,
     pose, remoção de fundo,             timing, tags, paleta,
     pixelização preliminar)             spritesheet final)
             │                                   │
             └─────────────────┬─────────────────┘
                               │
                     TÊMIS (Auditoria QA)
                               │
                     ERGANE (Godot Engine)
```

1. **ComfyUI não substitui o Aseprite.** ComfyUI é forte em explorar conceitos, manter referências consistentes (via IP-Adapter) e controlar poses frame a frame (via ControlNet OpenPose). Aseprite é insubstituível na precisão de pixels individuais, alinhamento no grid, sel-out e timing de animação.
2. **Não há produção em volume sem prova do pipeline.** Toda produção em lote só é autorizada após o Gate COMFY-00 estar 100% homologado.
3. **Reference Conditioning:** Uma vez aprovado o conceito mestre de um personagem, **nenhum frame subsequente é gerado do zero**. Toda variação ou animação deve usar a imagem de referência aprovada condicionada via IP-Adapter/OpenPose.

---

## 2. Fluxo Passo a Passo do Asset (17 Etapas)

1. **Contrato do Asset:** Leitura de `docs/art/contracts/<asset_id>.yaml` (dimensões, paleta, animações, frame rate).
2. **Conceito Mestre:** Geração de lote de conceitos via ComfyUI (`tools/daedalus/comfyui/workflows/character_concept_api.json`).
3. **Aprovação da Referência:** Rafael / Theia aprova a imagem mestre (ex.: `hero_bastiao_reference_v001.png`), congelando a fonte visual de verdade.
4. **Poses Alvo:** Definição das poses esqueléticas (OpenPose) para cada frame chave da animação.
5. **Geração Frame a Frame:** Execução do workflow ComfyUI alimentado pela Referência + Pose ControlNet.
6. **Remoção de Fundo:** Segmentação com BiRefNet ou nó equivalente, gerando canal alpha puro.
7. **Redimensionamento:** Escala por Nearest-Neighbor para a resolução alvo do contrato (32×32 ou 48×48).
8. **Quantização de Paleta:** Aplicação das rampas oficiais do `docs/art/PALETTE.md` via nó ComfyUI (ex.: `ComfyUI-PixelGridHelpers`).
9. **Hard Alpha:** Garantia de ausência de halos semi-transparentes (alpha binário: 0 ou 255).
10. **Exportação RGBA:** Gravação do frame intermediário PNG 32-bit.
11. **Repetição de Poses:** Processamento de todos os frames da animação (`idle`, `attack`, `hit`, `death`).
12. **Montagem da Folha Provisória:** Junção dos quadros em fita horizontal ou grid.
13. **Acabamento no Aseprite:** Abertura via `pixel-mcp` para remoção de pixels órfãos ("stray pixels"), reforço de sel-out e limpeza de clusters.
14. **Configuração de Tags & Timing:** Definição dos frameTags e durações em milissegundos conforme contrato.
15. **Exportação Canônica:** Geração de `<asset_id>.aseprite`, `<asset_id>_sheet.png` e `<asset_id>_sheet.json`.
16. **Auditoria Têmis:** Inspeção técnica e visual contra o `docs/art/QA_CHECKLIST.md`. Emissão de veredito PASS/FAIL.
17. **Integração no Godot:** Criação do `SpriteFrames`, cena `.tscn` e teste no `BattleStrip`.

---

## 3. Especificação dos Custom Nodes Aprovados

Apenas nós estritamente necessários e auditados devem ser instalados no ComfyUI:

| Custom Node | Repositório | Finalidade |
| :--- | :--- | :--- |
| **ComfyUI-PixelGridHelpers** | `molbal/ComfyUI-PixelGridHelpers` | Quantização para paleta fixa, merge de cores similares e alinhamento de grid. |
| **ComfyUI-Pixelization** | `DarioFT/ComfyUI-Pixelization` | Algoritmos de pixelização e redução de escala nearest-neighbor. |
| **ComfyUI-Manager** | `ltdrdata/ComfyUI-Manager` | Gerenciamento e atualização de nós customizados. |
| **ControlNet-OpenPose** | `Fannovel16/comfyui_controlnet_aux` | Extração e aplicação de pose por esqueleto 2D. |
| **BiRefNet** | `ZhengPeng7/BiRefNet` ou nós integrados | Remoção precisa de fundo de personagens. |

---

## 4. Diretrizes de Hardware e Execução

* **Ambiente de Desenvolvimento:** Windows 11 64-bit, 32 GB RAM, Intel Arc B390 GPU.
* **Modo de Operação:**
  * Workflows exportados no formato **API JSON** versionados em `tools/daedalus/comfyui/workflows/`.
  * Driver Python de automação em `tools/daedalus/comfyui/drivers/comfy_client.py` conectando na API local (`http://127.0.0.1:8188`).
  * Nenhum modelo pesado (>500MB) deve ser comitado no Git.
  * Modelos são baixados sob demanda e catalogados com SHA-256 e licença em `docs/art/MODEL_LICENSES.md`.
