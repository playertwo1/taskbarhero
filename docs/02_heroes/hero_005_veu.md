# HERO_005 — Véu (A Que Caminha Entre Sombras)

**Status de ciclo:** `APPROVED`  
**Certeza de conteúdo:** `DECIDIDO` (Direção de Rafael em 28/09/2026)  
**ID de design:** `HERO_005`  
**ID runtime:** `hero_veu`  
**Papel central:** Assassino / Backline Killer  
**Posição de combate:** Móvel / Infiltrador de retaguarda  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Fantasia e identidade

> *"Escolher quem morre primeiro."*

Enquanto Flecha constrói pressão contínua e foca alvos à distância, Véu é a personificação da execução cirúrgica. Ela não desgasta o oponente: ela identifica a fraqueza exposta e desferem o golpe letal.

### Gancho de lore
> *Véu trabalhava para uma organização que já investigava o Apagamento antes mesmo de ele acontecer.*  
> *A dúvida que ela carrega: Alguém no alto escalão sabia que o mundo seria apagado?*

### Evolução no Hub (Refúgio da Vigília)
No Hub, Véu não tem uma morada fixa. Ela começa a surgir em vigas altas, cantos sombrios e telhados do Refúgio. Ninguém na vigília sabe ao certo onde ela dorme, mas sua presença silenciosa mantém a segurança das bordas do assentamento.

---

## 2. Mecânica central: Exposição

Véu monitora o campo e atinge alvos que atingem o estado de **Exposto**. Um inimigo torna-se Exposto quando:
1. Sua vida cai abaixo de determinado limiar (sangrando/enfraquecido).
2. Está sob efeito de controle de grupo (atordoado, enraizado por Íris ou aliados).
3. Está com marca de caçada ativa (aplicada por Flecha).
4. Está no meio de uma animação de ataque direcionada a outro aliado (com flancos abertos).

Contra alvos Expostos, os ataques de Véu ignoram armadura e aplicam multiplicadores letais de acerto crítico.

---

## 3. Rotas de build

| Build | Foco principal | Comportamento em combate |
| --- | --- | --- |
| **Execução** | Dano explosivo | Maximiza o multiplicador de dano em alvos Expostos ou com baixa vida. |
| **Veneno** | Debuffs e dispersão | Golpes inoculam toxinas letais que se espalham em névoa residual para alvos vizinhos. |
| **Sombra** | Mobilidade e reposicionamento | Teleporte entre sombras, esquiva garantida e ataques de flanco contínuos. |

---

## 4. Habilidade característica: Passo Entre Mundos

* **Efeito:** Véu desmaterializa-se em uma pluma de sombras de Lúmen e reaparece instantaneamente atrás do inimigo com menor HP percentual do campo, desferindo um duplo golpe com adagas que reseta o cooldown se o alvo for abatido.

---

## 5. Sinergias de party recomendadas

* **Íris + Flecha + Véu (Build de Burst e Execução Perfeita):** Íris paralisa o grupo com controle de Lúmen $\rightarrow$ Flecha aplica Marcas da Caçada $\rightarrow$ Véu executa em cadeia com Passo Entre Mundos.

---

## 6. Diretrizes visuais e contratuais

* **Silhueta:** Capuz escuro em degradê carvão/sombra, franja carmesim/ruiva visível, olhar cortante, jaqueta de couro ajustada e par de adagas cintilantes com lâmina de aço escuro.
* **Cores (TY40):** Subconjuntos `iron`, `crimson`, `neutral_stone`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Contrato de arte:** [`../../docs/art/contracts/hero_veu.yaml`](../art/contracts/hero_veu.yaml).
