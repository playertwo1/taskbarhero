# HERO_002 — Flecha (A Caçadora Silvestre)

**Status de ciclo:** `IMPLEMENTED`  
**Certeza de conteúdo:** `DECIDIDO`  
**ID de design:** `HERO_002`  
**ID runtime:** `flecha` / `hero_flecha`  
**Papel central:** Atiradora Ranged DPS / Marca & Crítico  
**Posição de combate:** Retaguarda  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Fantasia e identidade

> *"Caçadora e exploradora dos ermos de Lúmen."*

Flecha rastreia as rotas através da névoa do Apagamento. Ágil e implacável, ela abate inimigos à distância antes que eles se aproximem da linha de frente, construindo dano progressivo com acertos críticos e aljavas encantadas.

---

## 2. Mecânica central: Marca da Caçada

* Aplicação de **Marcas** em alvos prioritários, amplificando o dano de acertos críticos.
* Saraivadas contínuas de flechas de alta velocidade.
* Mobilidade evasiva para evitar encurralamentos.

---

## 3. Diretrizes visuais e contratuais

* **Silhueta:** Arqueira com túnica e capuz florestal verde-oliva, cabelos loiros, aljava nas costas e arco recurvo flexionado.
* **Cores (TY40):** Subconjuntos `forest`, `wood`, `iron`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Cena Godot:** `scenes/heroes/Flecha.tscn`.
* **Contrato de arte:** [`../../docs/art/contracts/hero_flecha.yaml`](../art/contracts/hero_flecha.yaml).
