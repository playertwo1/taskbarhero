# Pipeline de IA para Sprites — Pocket Hero

## Objetivo

Construir um pipeline em que o Hermes Agent coordene Claude, ChatGPT e Antigravity para criar, revisar e integrar sprites pixel art no jogo.

## Arquitetura

```text
Rafael
  ↓
Hermes Agent
  ↓
Theia — Diretora
  ├─ Research — pesquisa e referências
  ├─ Daedalus — arte e sprites
  ├─ Ergane — implementação no Godot
  └─ Têmis — auditoria e validação

Daedalus
  ↓
pixel-mcp
  ↓
Aseprite
  ↓
spritesheets / PNG / JSON
  ↓
Godot
```

## Stack proposta

- Godot 4.7.2
- GDScript
- Hermes Agent
- Claude
- ChatGPT
- Antigravity
- willibrandon/pixel-mcp
- Aseprite
- Pixelorama como editor/revisor auxiliar

## Por que usar pixel-mcp como núcleo

O projeto deve funcionar com múltiplos modelos. Por isso, o núcleo de arte deve ser um MCP reutilizável, em vez de uma integração exclusiva de um único assistente.

Funções desejadas:

- criar sprites por linguagem natural;
- editar sprites existentes;
- trabalhar com layers;
- criar animações;
- exportar PNG;
- exportar GIF;
- exportar spritesheet;
- manter consistência de paleta e dimensões.

## Agente Daedalus

Daedalus é o agente artístico do projeto.

### Responsabilidades

- ler a direção de arte antes de gerar assets;
- obedecer dimensões e paleta;
- produzir todos os frames exigidos;
- exportar no formato definido;
- registrar o asset no manifest;
- encaminhar a saída para auditoria;
- nunca alterar regras de gameplay por conta própria.

### Fluxo

```text
Pedido
  ↓
Theia
  ↓
Daedalus
  ↓
ART_DIRECTION.md
ANIMATION_STANDARD.md
PALETTE.md
ASSET_MANIFEST.yaml
  ↓
pixel-mcp + Aseprite
  ↓
asset candidato
  ↓
Têmis
  ↓
PASS / FAIL / ESCALATE
  ↓
Ergane
  ↓
Godot
```

## Contrato de asset

Exemplo:

```yaml
asset:
  id: enemy_slime_green
  type: enemy

canvas:
  width: 32
  height: 32

style:
  genre: dark_fantasy
  technique: pixel_art
  palette_max: 16
  outline: selective
  shading: hard

view:
  perspective: side
  facing: left

animations:
  idle:
    frames: 4
    fps: 6
  attack:
    frames: 6
    fps: 10
  hit:
    frames: 2
    fps: 12
  death:
    frames: 6
    fps: 8

export:
  transparent_background: true
  spritesheet: horizontal
```

## Padrões iniciais

### Personagens jogáveis

- idle: 4 frames
- walk: 6 frames
- attack: 6 frames
- hit: 2 frames
- death: 6 frames

### Inimigos comuns

- idle: 4 frames
- attack: 4 frames
- hit: 2 frames
- death: 4–6 frames

### Bosses

- idle
- walk
- attack_1
- attack_2
- special
- hit
- death

## Direção de arte inicial

- pixel art dark fantasy;
- leitura clara em tela pequena;
- side view;
- contraste alto;
- fundo transparente para personagens;
- luz principal no alto à esquerda;
- poucos tons por material;
- silhuetas distintas;
- proporção consistente entre heróis e inimigos.

Dimensões sugeridas:

- personagens: 32×32 ou 48×48;
- inimigos comuns: 32×32 ou 48×48;
- elites: 48×48;
- bosses: 64×64 ou maior quando necessário;
- ícones: 24×24 ou 32×32.

## Estrutura recomendada

```text
docs/art/
├── ART_DIRECTION.md
├── ANIMATION_STANDARD.md
├── PALETTE.md
├── QA_SPRITES.md
└── ASSET_MANIFEST.yaml

assets/
├── heroes/
├── enemies/
├── bosses/
├── pets/
├── items/
├── effects/
└── environments/
```

## QA de sprites

Têmis deve verificar:

- dimensões corretas;
- quantidade correta de frames;
- transparência;
- orientação;
- consistência de paleta;
- naming;
- ausência de pixels fora da área;
- leitura visual em escala 1×;
- consistência com os assets aprovados;
- spritesheet exportada corretamente.

## Naming

Exemplos:

```text
hero_bastiao_idle_v001.png
enemy_slime_green_attack_v002.png
boss_guardian_lumen_death_v001.png
item_sword_eclipse_icon_v001.png
```

## Gates

### ART-0 — Direção definida
PASS quando direção, paleta, proporção e animações mínimas estiverem documentadas.

### ART-1 — Primeiro personagem
PASS quando um personagem completo entrar no Godot sem ajustes manuais estruturais.

### ART-2 — Primeira família de inimigos
PASS quando uma sprite-base gerar variantes visualmente coerentes.

### ART-3 — Primeiro boss
PASS quando o boss estiver completo, animado e integrado.

### ART-4 — Pipeline automático
PASS quando o Hermes conseguir pedir, gerar, auditar e integrar um asset com intervenção humana apenas quando necessário.

## Primeira missão sugerida

Criar o pacote visual do Bosque de Lúmen:

- 3 heróis;
- 4 inimigos comuns;
- 1 elite;
- 1 boss;
- 3 pets/Ecos;
- cenário em camadas;
- efeitos básicos;
- ícones de loot iniciais.

## Regra de propriedade intelectual

As referências externas servem para compreender estrutura, pacing e tipos de sistema. O projeto deve usar nomes, personagens, silhuetas, sprites, animações, cenários, efeitos e identidade próprios.
