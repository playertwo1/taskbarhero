# Pocket Hero — Direção de Arte e Estilo Visual

**Status:** DECIDIDO (FASE R7)  
**Versão:** 1.0.0  
**Data:** 2026-09-27  
**Alvo:** Pocket Hero (MVP Android)  

---

## 1. Identidade e Atmosfera

Pocket Hero adota uma identidade visual de **Dark Fantasy Original**, marcada por:
- **Tons atmosféricos e solenes:** Florestas densas e antigas, ruínas de pedra cobertas de musgo e folhagem sombria.
- **Acentos bioluminescentes:** Pontos de luz mágica, esporos brilhantes e fluidos luminosos (o "Lúmen") que quebram a escuridão e destacam pontos focais.
- **Originalidade estrita:** O jogo possui seus próprios heróis, monstros e lore. É proibido copiar silhuetas, designs, paletas ou assets de *Task Bar Hero* ou referências externas.

---

## 2. Perspectiva e Orientação

- **Perspectiva:** Visão lateral estrita (*pure side-view* 2D ortográfico). Sem visão isométrica ou top-down.
- **Orientação de combate:**
  - **Heróis (party):** Sempre voltados para a **DIREITA** (`facing: right`).
  - **Inimigos e Bosses:** Sempre voltados para a **ESQUERDA** (`facing: left`).
  - Ambos convergem para o centro da faixa de combate na parte inferior da tela.

---

## 3. Iluminação e Sombreamento

- **Fonte de Luz Principal:** Direcional fixa, vinda do **alto à esquerda** (aproximadamente 45° acima do plano do solo).
- **Hue-Shifting (Variação de Matiz):**
  - Áreas iluminadas tendem a matizes mais quentes/claros (amarelos, cianos brilhantes, verdes claros).
  - Sombras profundas migram para matizes mais frios e saturados (azuis-escuros, violetas, verdes terrosos escuros).
  - Sombras nunca devem ser pretas puras ou geradas por redução linear de brilho.
- **Técnica de Sombreamento:** *Hard shading* (sombras recortadas limpas) em 2 a 3 passos tonais por material.
  - **Proibido:** *Pillow-shading* (sombreamento em anel seguindo a borda), ruído estocástico sem forma e gradientes automáticos que causem desfoque.

---

## 4. Contorno (Outlining) e Linhas

- **Contorno Externo:** Outline escuro seletivo (*selective outlining* ou *sel-out*), garantindo que a entidade destaque-se perfeitamente contra o fundo escuro AMOLED da faixa de batalha.
- **Contornos Internos:** Linhas internas usam o tom mais escuro da rampa do próprio material (não preto puro), evitando aspecto de "recorte colado".
- **Limpeza de Pixels:**
  - Sem *jaggies* (degraus irregulares em curvas e diagonais).
  - Sem *doubles* involuntários (pixels dobrados de 2×2 em linhas diagonais que deveriam ter 1px de espessura).
  - Cantos e arestas devem ser limpos, com clusters de pixels legíveis.

---

## 5. Escala de Personagens e Dimensões de Canvas

Para garantir consistência e legibilidade visual:

| Categoria | Canvas Padrão | Altura Útil | Exemplos |
| :--- | :---: | :---: | :--- |
| **Inimigos Comuns Pequenos** | **32×32** | 16–26 px | Geleia de Lúmen, Gremlin de Folha |
| **Heróis da Party** | **48×48** | 30–38 px | Bastião (Tanque), Flecha (DPS), Íris (Maga) |
| **Inimigos Médios & Elites** | **48×48** | 28–42 px | Javali de Musgo, Espírito de Raiz, Elite |
| **Chefes de Região (Bosses)**| **64×64** | 48–58 px | Guardião-Cervo de Pedra |
| **Ícones de Inventário** | **24×24** ou **32×32** | 20–28 px | Armas, armaduras, amuletos |

- **Baseline:** Todos os sprites de combate ancoram seu ponto de apoio de solo na mesma linha base virtual, evitando flutuações ou pés enterrados.

---

## 6. Critérios de Legibilidade Mobile & AMOLED

1. **Teste de Silhueta:** Pintando todo o sprite de uma cor sólida, a criatura/herói deve ser imediatamente reconhecível pela sua forma externa.
2. **Exagero Estratégico:** Como a tela do smartphone possui alta densidade de pixels (PPI), olhos, armas, chifres e núcleos de energia devem ter massas de pixels ligeiramente maiores para não virarem ruído invisível a 1×.
3. **Contraste com Preto Puro:** A interface e o cenário usam bases quase pretas para eficiência em telas AMOLED; nenhum sprite deve sumir ou se misturar totalmente com a cor `#000000` / `#0d0e12`.
4. **Filtro Nearest Neighbor:** No Godot e em qualquer pré-visualização, a textura deve usar estritamente `Filter: Nearest` (sem interpolação bilinear ou borramento).

---

## 7. Congelamento da Versão 1 (ART_DIRECTION v1) — Gate R11

**Status:** CONGELADO E HOMOLOGADO (FASE R11 - Passo 2)  
**Data:** 2026-09-27  
**Assets de Referência Canônica:**
- **Herói de Referência:** Bastião (`assets/sprites/heroes/bastiao/hero_bastiao_sheet.png`, 48×48 px, 16 frames, 9 cores, Rampa Ferro & Ouro).
- **Inimigo de Referência:** Geleia de Lúmen (`assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png`, 32×32 px, 16 frames, 5 cores, Rampa Lúmen).
- **Cenário de Teste:** Faixa de Combate AMOLED (`docs/art/preview_bosque_lumen_r11.png` e `docs/art/combat_loop_bosque_lumen.gif`).

### 7.1 Regras Congeladas para Próximos Assets (Flecha, Íris, Mobs, Boss)
1. **Grid e Escala Universal:**
   - 1 pixel de arte = 2 pixels de tela (escala 2.0× uniforme no container `BattleStrip`).
   - Sem mixels: nenhuma entidade ou elemento cênico pode usar fator de escala fracionário ou inconsistente.
   - Ponto de apoio (Baseline):
     - Canvas 32×32 (mobs comuns): `Y = 29` (offset `Vector2(0, -13)` no Godot).
     - Canvas 48×48 (heróis e elites): `Y = 44` (offset `Vector2(0, -20)` no Godot).
     - Canvas 64×64 (chefes de área): `Y = 60` (offset `Vector2(0, -28)` no Godot).
2. **Paletas-Base e Contraste AMOLED:**
   - Todo asset deve mapear estritamente suas cores para as rampas canônicas de `docs/art/PALETTE.md`.
   - Contraste mínimo contra fundo `#060807` assegurado sem necessitar de contorno branco ou halos artificiais.
   - Canal Alpha binário estrito `[0, 255]`; halos semitransparentes são causa imediata de reprovação (FAIL).
3. **Direção da Luz (Lighting):**
   - Top-left 45° estrito para todos os combatentes e props.
   - Realces na face superior-esquerda; sombras projetadas na base inferior-direita.
4. **Conjunto Mínimo de 4 Animações Canônicas:**
   - `idle`: 4 frames (loop, ~6 FPS).
   - `attack`: 4 frames (one-shot, ~10 FPS).
   - `hit`: 2 frames (one-shot, ~12 FPS).
   - `death`: 6 frames (one-shot, ~8 FPS, dissipação/dither dissolve).
