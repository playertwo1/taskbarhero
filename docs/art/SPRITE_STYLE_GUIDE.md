# POCKET HERO — SPRITE STYLE GUIDE v2

> **Status:** Fonte oficial de verdade para criação e validação de sprites  
> **Projeto:** Pocket Hero / taskbarhero  
> **Pipeline:** Hermes → Theia → Daedalus → ComfyUI → Pixel Cleanup → Aseprite/pixel-mcp → Têmis → Godot  
> **Princípio central:** **silhueta > leitura > consistência > animação > detalhe**

---

## 1. Objetivo

Este documento define como todos os sprites do Pocket Hero devem ser concebidos, gerados, convertidos para pixel art, limpos, animados, validados, exportados e testados no jogo.

Nenhum agente deve inventar um estilo ou pipeline novo sem alterar este documento explicitamente.

### Autoridade e precedência

Em conflito sobre um asset, aplique esta ordem (da maior para a menor autoridade):

**ASSET CONTRACT > GOLDEN REFERENCES > SPRITE STYLE GUIDE > PALETTE > ANIMATION STANDARD > REFERENCE LIBRARY > EXTERNAL REFERENCES > PROMPT.**

Um prompt não pode substituir um contrato, uma referência aprovada ou uma regra do projeto. Registre a divergência e encaminhe-a ao responsável de arte. Use o [manifesto](./manifests/README.md) para rastreabilidade, a [biblioteca de referências](./REFERENCE_LIBRARY.md) para proveniência e o [guia de QA](./QA_SPRITES.md) para critérios técnicos.

### ART-0 — gate para produção em massa

Antes de iniciar ou retomar produção em massa, devem existir e estar aprovados: **1 GOLDEN HERO + 1 GOLDEN ENEMY + 1 GOLDEN BOSS + 1 GOLDEN ANIMATION**. Registre cada aprovação em [`golden/README.md`](./golden/README.md). Até os quatro itens passarem, produza apenas trabalho necessário para fechar o gate; não trate assets existentes como aprovados automaticamente.

---

## 2. Inspiração visual

Pocket Hero usa TBH: Task Bar Hero apenas como **referência funcional** de leitura em tamanho pequeno, personagens compactos, pixel art legível, silhuetas claras, combate simples e animações curtas.

Não copiar sprites, personagens, poses, paletas específicas, armas, bosses, UI, animações ou identidade visual.

> **Aprender a função visual. Nunca reproduzir o conteúdo visual.**

---

## 3. DNA visual

- charming dark fantasy
- clean pixel art
- compact
- mobile-readable
- iconic silhouette
- limited palette
- hard shading
- animation-friendly
- polished indie game
- not over-detailed

Evitar realismo, pintura digital, microdetalhes, gradients, blur e aparência de imagem de IA reduzida.

---

## 4. SILHUETA PRIMEIRO

Antes de pensar em textura ou detalhe, o sprite precisa funcionar como forma.

Mesmo em uma cor só, deve ser possível reconhecer:
- quem é;
- para onde olha;
- função;
- arma;
- se é herói, inimigo, elite ou boss.

Se a silhueta falhar, o asset volta para CONCEPT.

---

## 5. Resolução de geração ≠ resolução final

**Nunca gerar diretamente o sprite final em 48×48.**

48×48 é a resolução final do asset, não a resolução principal de geração.

```text
~512×512
↓
design/reference
↓
pose control
↓
background removal
↓
pixel grid correction
↓
Median Fixer
↓
palette reduction
↓
48×48 final
↓
Aseprite cleanup
```

---

## 6. Tamanhos finais (Padrão Alta Densidade — Decidido por Rafael em 2026-09-30)

| Elemento | Resolução canônica | Função / Observação |
|---|---:|---|
| **Heróis** | **96×96** | Padrão canônico de alta densidade; baseline proporcional ao chão de combate |
| **Inimigos pequenos** | **64×64** | Gremlins, criaturinhas e minions menores |
| **Inimigos normais** | **96×96** | Mobs comuns com mesma densidade de pixel do herói |
| **Elites** | **128×128** | Inimigos avançados com presença de combate destacada |
| **Mini-chefes** | **128–192px** | Subchefes de clareira e eventos especiais |
| **Chefes** | **192–256px** | Chefes de capítulo com grande escala e impacto visual |
| **Chefes excepcionais / Colossais** | **256–384px** | Encontros de clímax e chefes titânicos |
| **Ícones de itens** | **64×64** | Equipamentos, materiais e consumíveis (UI mobile legível) |
| **Ícones de skills** | **64×64** | Habilidades ativas e passivas |
| **Retratos / UI** | **256×256+** | Diálogos, cartões de herói e ilustrações de serviço |
| **Arquivo Master / Conceito** | **1024×1024** | Matriz de geração ComfyUI / alta resolução antes do downscale |

---

## 7. Orientação

Heróis:

```text
Facing RIGHT →
```

Inimigos:

```text
← Facing LEFT
```

---

## 8. Proporções

Priorizar:
- cabeça separada;
- torso compacto;
- pernas simples;
- braços legíveis;
- arma visível;
- centro de massa estável.

Evitar anatomia realista e proporções inconsistentes entre frames.

---

## 9. Master Reference

Todo personagem importante deve possuir uma referência mestre aprovada.

Exemplos:

```text
hero_bastiao_reference_v001.png
enemy_lumen_slime_reference_v001.png
```

Depois de aprovada, não regenerar do zero. Preservar roupa, arma, paleta, proporções e silhueta.

---

## 10. Pipeline oficial

```text
ART CONTRACT
↓
CONCEPT GENERATION
↓
A/B/C/D VARIANTS
↓
MASTER REFERENCE APPROVED
↓
REFERENCE CONDITIONING + POSE CONTROL
↓
FRAME GENERATION
↓
BACKGROUND REMOVAL
↓
PIXEL GRID CORRECTION
↓
MEDIAN FIXER
↓
MERGE SIMILAR COLORS
↓
PALETTE QUANTIZATION
↓
ENFORCE PALETTE
↓
DOWNSCALE TO FINAL SIZE
↓
ASEPRITE / PIXEL-MCP
↓
PIXEL CLEANUP
↓
SPRITESHEET / TAGS
↓
TÊMIS QA
↓
GODOT
```

---

## 11. ComfyUI

ComfyUI é o **atelier generativo**.

Serve para:
- conceitos;
- variações;
- referência visual;
- pose control;
- consistency conditioning;
- background removal;
- pixel preprocessing;
- palette preprocessing.

Ele não substitui Aseprite.

---

## 12. Aseprite / pixel-mcp

Aseprite é a **bancada de acabamento**.

Serve para:
- corrigir clusters;
- pixels isolados;
- outline;
- olhos;
- armas;
- alinhamento de frames;
- pivot;
- timing;
- tags;
- spritesheet final.

> **ComfyUI cria. Aseprite finaliza.**

---

## 13. Median Fixer

O Median Fixer corrige imagens que parecem pixel art, mas possuem microvariações dentro de cada “pixel lógico”.

Ele ajuda a:
- remover microvariações;
- reduzir antialiasing;
- limpar blocos;
- tornar o grid lógico consistente.

Ele NÃO corrige:
- anatomia;
- silhueta;
- arma deformada;
- design ruim;
- personagem inconsistente.

> **Median Fixer corrige a grade. Não corrige a arte.**

---

## 14. Teste de grid

Quando aplicável, testar:

```text
grid_size = 4
grid_size = 6
grid_size = 8
```

Comparar em 1×.

Escolher o menor valor que preserve olhos, arma e silhueta enquanto reduz ruído.

---

## 15. PixelGridHelpers

Ordem inicial recomendada:

```text
Median Fixer
↓
Merge Similar Colors
↓
Quantize Max Colors
↓
Enforce Palette
```

A ordem pode mudar se a evidência visual justificar.

---

## 16. Paleta

Use [`PALETTE.md`](./PALETTE.md): master `TY_HIGH_FANTASY_40`, limitado aos subconjuntos e `max_colors` do contrato do asset. O número 40 descreve a paleta-mestre, não a quantidade autorizada por sprite.

```text
limite por asset = contrato
```

Valores de 16/20/24 cores e rampas antigos neste guia registram experimentos históricos; não substituem a TY40 nem o limite do contrato.

Testar 16, 20 e 24.

Não aceitar centenas de cores ou dezenas de tons quase iguais.

---

## 17. Iluminação e shading

Default:

```text
upper-left light source
```

Usar:
- hard shading;
- 1–3 níveis por material;
- highlights pequenos;
- contraste forte.

Evitar gradients, airbrush, soft shadows e ruído.

---

## 18. Outline

Default:

```text
selective 1 px outline
```

Preferir contorno mais escuro que a cor local e mais forte nas bordas externas.

---

## 19. Teste em tamanho real

Sempre avaliar em:

```text
1×
2×
4×
```

Prioridade absoluta: **1×**.

Se só parece bom ampliado: **FAIL**.

---

## 20. Geração de conceitos

Gerar inicialmente apenas:

```text
1 personagem
1 pose
```

Criar variações A/B/C/D/E/F.

A escolhida vira Master Reference.

Não gerar animação antes da referência ser aprovada.

---

## 21. Geração de animação

Para heróis, bosses e ataques importantes:

```text
MASTER REFERENCE
+
IP-Adapter / Reference Conditioning
+
OpenPose / ControlNet
+
same base prompt
+
controlled seed
```

Gerar **ONE FRAME AT A TIME**.

Spritesheet completa em uma única geração não é o default.

---

## 22. Consistência entre frames

Manter:
- identidade;
- roupa;
- arma;
- proporções;
- paleta;
- silhueta;
- iluminação;
- baseline.

Só a pose deve mudar.

---

## 23. Frame counts iniciais

Herói:

```yaml
idle: 4
walk: 6
attack: 6
hit: 2
death: 6
```

Inimigo:

```yaml
idle: 4
attack: 4-6
hit: 2
death: 4-6
```

Boss:

```yaml
idle: 4-6
attack_1: 6-8
attack_2: 6-8
special: 8-12
hit: 2
death: 8-12
```

---

## 24. FPS de animação

Renderização e animação são independentes.

O jogo pode renderizar em:

```text
30 / 60 / 90 / 120 FPS
```

A sprite pode animar em:

| Animação | FPS visual |
|---|---:|
| Idle | 5–7 |
| Walk | 8–10 |
| Run | 10–12 |
| Attack | 9–12 |
| Cast | 8–12 |
| Hit | 10–14 |
| Death | 7–10 |

---

## 25. Regra dos 120 FPS

PASS:

```text
60 FPS render → attack = 0.6s
120 FPS render → attack = 0.6s
```

FAIL:

```text
60 FPS render → attack = 0.6s
120 FPS render → attack = 0.3s
```

Nunca amarrar animação ou gameplay ao frame count de render.

---

## 26. Prompt de conceito

```text
Create a clean 2D side-view fantasy game character for Pocket Hero.

Focus on:
- extremely clear iconic silhouette
- compact proportions
- large readable shapes
- simple design
- minimal micro-details
- animation-friendly anatomy
- clear weapon or defining feature
- strong visual hierarchy
- polished indie game asset
- isolated plain background

Do NOT over-detail.

Character:
[DESCRIPTION]
```

---

## 27. Prompt de pixel style

```text
Intentional handcrafted pixel art,
clean pixel clusters,
hard edges,
hard shading,
limited palette,
selective one-pixel outline,
upper-left lighting,
no antialiasing,
no smooth gradients,
no subpixel detail,
mobile-readable,
game-ready.
```

---

## 28. Prompt de frame com referência

```text
Use the approved Pocket Hero Master Reference.

Preserve exactly:
- identity
- outfit
- weapon
- proportions
- color relationships
- silhouette language
- lighting direction

Create ONE animation frame.

Animation:
[ANIMATION]

Pose:
[POSE]

Technical:
- transparent RGBA
- same baseline
- no design drift
- no new accessories
- no weapon redesign
```

---

## 29. Negative prompt

```text
blurry,
antialiasing,
smooth edges,
photorealistic,
painterly,
3D render,
soft shading,
gradients,
over-detailed,
micro-details,
noisy pixels,
random isolated pixels,
muddy colors,
weak silhouette,
inconsistent outline,
deformed anatomy,
extra limbs,
broken weapon,
design drift,
background scenery,
text,
logo,
watermark
```

---

## 30. Parâmetros obrigatórios de reprodução

```yaml
model:
lora:
seed:
sampler:
steps:
cfg:
generation_resolution:
reference_image:
ip_adapter_weight:
controlnet:
controlnet_weight:
pixel_snap:
grid_size:
palette_size:
final_resolution:
workflow_json:
```

Sem isso, o resultado não é considerado reproduzível.

---

## 31. Export

```text
PNG
RGBA
transparent background
nearest-neighbor
no smoothing
```

Nunca JPG.

---

## 32. QA — Design

- [ ] silhueta funciona;
- [ ] reconhecível a 1×;
- [ ] arma/função legível;
- [ ] poucos detalhes;
- [ ] identidade própria;
- [ ] não parece cópia externa.

---

## 33. QA — Pixel Grid

- [ ] grid consistente;
- [ ] Median Fixer testado quando necessário;
- [ ] sem microvariação de cor;
- [ ] sem antialiasing;
- [ ] clusters limpos;
- [ ] poucos pixels isolados;
- [ ] paleta controlada.

---

## 34. QA — Animação

- [ ] mesmo personagem em todos os frames;
- [ ] arma consistente;
- [ ] roupa consistente;
- [ ] paleta consistente;
- [ ] baseline consistente;
- [ ] impacto legível;
- [ ] timing correto;
- [ ] sem jitter;
- [ ] mesma duração em 60 e 120 FPS.

---

## 35. QA — Mobile

Testar no aparelho real.

- [ ] legibilidade sem zoom;
- [ ] contraste;
- [ ] 2–3 personagens simultâneos;
- [ ] efeitos não escondem sprite;
- [ ] 60 FPS;
- [ ] 120 FPS;
- [ ] animação mantém a mesma velocidade.

---

## 36. Critério de beleza

Não perguntar apenas “ficou bonito?”.

Perguntar:

1. funciona a 1×?
2. reconheço imediatamente?
3. silhueta é forte?
4. arma/função está clara?
5. parece pertencer ao Pocket Hero?
6. anima bem?
7. parece pixel art deliberada?
8. ou parece imagem de IA pixelizada?

Se falhar em dois ou mais pontos: **REFazer**.

---

## 37. Sinais de FAIL

Rejeitar:
- aparência de ilustração reduzida;
- pixel soup;
- antialiasing;
- ruído;
- cores demais;
- outline irregular;
- arma deformada;
- anatomia inconsistente;
- design drift;
- pose impossível;
- silhueta fraca;
- sprite bonito só ampliado.

---

## 38. Definition of Done — Sprite

- [ ] contrato existe;
- [ ] Master Reference aprovada;
- [ ] design original;
- [ ] silhouette PASS;
- [ ] dimensão correta;
- [ ] orientação correta;
- [ ] pixel grid PASS;
- [ ] palette PASS;
- [ ] transparência PASS;
- [ ] Aseprite cleanup concluído;
- [ ] Godot import PASS;
- [ ] 1× PASS;
- [ ] mobile PASS;
- [ ] Têmis PASS.

---

## 39. Teste oficial antes da produção em volume

### COMFY-SPRITE-QUALITY-01

> Experimento documentado historicamente. A receita abaixo não é um preset vigente: tamanho, limite de cores e subconjuntos devem seguir o contrato atual e `PALETTE.md`.

Asset:

```text
Slime de Lúmen
```

Comparar:

```text
A — pipeline antigo
B — pipeline novo
```

Pipeline novo:

```text
512 concept
↓
Master Reference
↓
Reference Conditioning
↓
Median Fixer
↓
Merge Similar Colors
↓
20-color Quantize
↓
Enforce Palette
↓
48×48
↓
Aseprite cleanup
```

Só continuar se **B > A** visualmente em 1×.

---

## 40. Segundo teste oficial

### COMFY-SPRITE-CONSISTENCY-01

Gerar:

```text
idle_00
idle_01
```

com a mesma Master Reference.

FAIL se olhos, forma, cores, silhueta ou corpo mudarem.

---

## 41. Regra de produção

Não produzir dezenas de assets antes de provar:

```text
1 sprite excelente
+
2 frames consistentes
+
1 animação curta limpa
```

---

## 42. Instrução para Daedalus

```text
Você é Daedalus, agente de arte do Pocket Hero.

Seu objetivo não é gerar muitas imagens.
Seu objetivo é produzir game assets reproduzíveis e bonitos.

Prioridade:
silhueta > leitura > consistência > animação > detalhe.

Não gere diretamente em 48×48.
Use resolução maior para concept/reference.
Depois converta deliberadamente para pixel art.

Use:
Master Reference
Reference Conditioning
Pose Control
Median Fixer
Palette Quantization
Aseprite cleanup

Não trate "pixelized" como "pixel art".

Nunca aprove seu próprio asset.
Entregue para Têmis.

Use Minimum Sufficient Context.
```

---

## 43. Regra final

> **Pocket Hero deve parecer um jogo criado deliberadamente em pixel art — nunca uma ilustração de IA reduzida para 48×48.**

> **Se o sprite não funciona pequeno, ele não funciona.**

## Ícones de itens — tamanho definido

Por decisão de Rafael em 2026-09-28, os ícones do inventário Pocket Hero usam canvas final 32×32. A arte do item fica isolada e transparente; moldura, raridade, seleção e quantidade pertencem à interface. Validar a leitura mobile antes de aceite de release.
