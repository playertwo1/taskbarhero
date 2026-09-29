# HERO_002 — Flecha (A Caçadora Silvestre)

**Status de design:** `DESIGN` — a ficha ainda não atende a completude de HERO_STANDARD.md.<br>
**Status do runtime MVP:** `IMPLEMENTED`<br>
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

## 2. Mecânica central: Marca do Caçador

* Marca uma presa para preparar dano coordenado da party.
* Usa precisão e críticos para sustentar dano à distância.
* Mantém mobilidade e fragilidade de retaguarda como forças e fraquezas.

O catálogo vigente e a progressão qualitativa das seis skills estão em [FLECHA_SKILLS.md](../04_content/skills/FLECHA_SKILLS.md). Os conceitos anteriores e seus IDs foram preservados em [arquivados](../../arquivados/FLECHA_SKILLS_LEGADO.md); não são o kit atual.

## Ataque básico — proposta

Disparos automáticos de arco contra alvos válidos, com uma cadência legível e interação com a Marca do Caçador. Nome, sequência, alvo prioritário e números ficam para a ficha de balanceamento.

## Fraqueza — proposta

Baixa resistência quando inimigos alcançam a retaguarda; Flecha depende de espaço e de uma party que controle a aproximação. Isso dá função ao posicionamento de Bastião e ao controle da Íris sem tornar a presença deles obrigatória.

## Builds principais

Consulte as três combinações iniciais recomendadas em [FLECHA_SKILLS.md](../04_content/skills/FLECHA_SKILLS.md). As 16 passivas estão conceituadas em [hero_002_flecha_passives.md](hero_002_flecha_passives.md); três Traits recomendados, um por build, estão em [hero_002_flecha_traits.md](hero_002_flecha_traits.md); a proposta de Mastery 1–10 está em [hero_002_flecha_mastery.md](hero_002_flecha_mastery.md). Valores e gatilhos continuam sem validação. Lore pessoal e equipamentos/Echos continuam pendentes.

---

## 3. Diretrizes visuais e contratuais

* **Silhueta:** Arqueira com túnica e capuz florestal verde-oliva, cabelos loiros, aljava nas costas e arco recurvo flexionado.
* **Cores (TY40):** Subconjuntos `forest`, `wood`, `iron`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Cena Godot:** `scenes/heroes/Flecha.tscn`.
* **Contrato de arte:** [`../../docs/art/contracts/hero_flecha.yaml`](../art/contracts/hero_flecha.yaml).
