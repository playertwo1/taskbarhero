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
