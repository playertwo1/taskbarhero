# Pocket Hero — Padrão Técnico de Sprites e Animações

**Status:** DECIDIDO (FASE R7)  
**Versão:** 1.0.0  
**Data:** 2026-09-27  
**Alvo:** Pocket Hero (Godot 4.7 Standard)  

---

## 1. Especificações de Canvas e Ancoragem

### 1.1 Coordenadas e Margens
* **Origem:** Canto superior esquerdo `(0, 0)`.
* **Margem de Segurança (Padding):**
  * Canvas de 32×32: mínimo de 2px de respiro nas bordas laterais e superior.
  * Canvas de 48×48 e 64×64: mínimo de 3px a 4px de respiro.
  * O respiro garante espaço para efeitos de impacto, squash & stretch e partículas sem corte abrupto de pixels.
* **Linha Base (Baseline) de Solo:**
  * Canvas 32×32: linha `Y = 29` (3px acima da borda inferior).
  * Canvas 48×48: linha `Y = 44` (4px acima da borda inferior).
  * Canvas 64×64: linha `Y = 60` (4px acima da borda inferior).
* **Ponto de Pivot para Godot:**
  * O centro horizontal do personagem deve coincidir com `X = Width / 2`.
  * O pivot de rotação e posicionamento em cena deve ser colocado na interseção do centro horizontal com a baseline.

---

## 2. Conjunto Canônico de Animações

Todos os combatentes (heróis, monstros comuns, elites e chefes) devem implementar no mínimo as 4 animações obrigatórias:

| Animação | Frames Mínimos | Duração / FPS | Modo de Reprodução | Propósito |
| :--- | :---: | :---: | :---: | :--- |
| **`idle`** | 4 frames | 160 ms (~6 FPS) | Loop Contínuo | Respiração, pulsação, prontidão de combate. |
| **`attack`** | 4 a 6 frames | 90–110 ms (~10 FPS) | One-shot | Antecipação (wind-up), golpe rápido (impacto com overshoot) e recuperação. |
| **`hit`** | 2 frames | 80 ms (~12 FPS) | One-shot | Recuo rígido com flash de dano, retorno rápido. |
| **`death`** | 4 a 6 frames | 120 ms (~8 FPS) | One-shot (congelado no final) | Colapso físico, dissolução mágica ou dissipação em partículas. |

---

## 3. Formato de Exportação e Estrutura de Arquivos

### 3.1 Padrão de Spritesheet
* **Formato:** PNG com canal alfa de 32 bits (RGBA).
* **Fundo:** 100% transparente (Alpha = 0).
* **Layout:** Faixa horizontal (*horizontal strip*), onde a largura é `largura_canvas * contagem_de_frames` e a altura é igual à altura do canvas.
* **Metadados:** Arquivo `.json` complementar com lista de tags de animação, durações de frames e retângulos de recorte (gerado nativamente pelo Aseprite via flag `--data`).

### 3.2 Convenção de Nomenclatura (Naming)
```text
assets/sprites/<categoria>/<entidade>/<entidade>_<animacao>_v<versao>.<ext>
```
Exemplos:
* `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet_v001.png`
* `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet_v001.json`
* `assets/sprites/heroes/bastiao/hero_bastiao_idle_v001.png`
* `assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_death_v001.png`

---

## 4. Integração no Godot Engine

1. **SpriteFrames / AnimatedSprite2D:**
   * Criar um recurso `SpriteFrames` que divida a spritesheet pelas dimensões declaradas no contrato.
   * Associar cada tag com o FPS especificado na tabela acima.
2. **Import Settings do Godot:**
   * `Compress Mode`: Lossless.
   * `Filter`: Nearest (Texture Filter: Nearest).
   * Sem compressão que gere borramento ou interpolação de canais alfa.
