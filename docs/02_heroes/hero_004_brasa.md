# HERO_004 — Brasa (A Sobrevivente)

**Status de ciclo:** `APPROVED`  
**Certeza de conteúdo:** `DECIDIDO` (Direção de Rafael em 28/09/2026)  
**ID de design:** `HERO_004`  
**ID runtime:** `hero_brasa`  
**Papel central:** Bruiser / Berserker  
**Posição de combate:** Linha de frente (Melee agressivo)  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Fantasia e identidade

> *"Quanto mais perto de morrer, mais perigosa fica."*

Brasa veio de uma região que foi praticamente consumida pelo Apagamento. Enquanto Bastião tenta impedir que os outros sofram dano com seu escudo maciço, Brasa transforma o sofrimento pessoal em força bruta e devastadora.

### Gancho de lore
> *Brasa sobreviveu a uma cidade inteira apagada.*  
> *O problema é que ela não consegue lembrar quem estava tentando salvar.*

### Evolução no Hub (Refúgio da Vigília)
Quando resgatada e integrada ao Refúgio, Brasa estabelece a **Área de Treinamento**, um espaço rústico onde os combatentes aprimoram técnicas de impacto e resistência física.

---

## 2. Mecânica central: Fúria

Brasa acumula pontos de **Fúria** organicamente durante o combate:
1. **Ao sofrer dano:** Fração do dano recebido é convertida em Fúria.
2. **Ao abater inimigos:** Eliminações concedem um surto imediato de Fúria.
3. **Ao receber cura estando em HP crítico (<30%):** O contraste entre a agonia e o alívio alimenta sua determinação, gerando Fúria adicional.

A Fúria eleva diretamente o poder de seus ataques físicos e desbloqueia bônus específicos das suas árvores de build.

---

## 3. Rotas de build

| Build | Foco principal | Comportamento em combate |
| --- | --- | --- |
| **Berserker** | Dano em baixo HP | Multiplicadores brutais de dano físico e velocidade proporcionais à perda de HP. |
| **Chamas** | Queimadura / Dano contínuo | Golpes inflamam os alvos com fogo residual de Lúmen corrompido, espalhando dano no tempo. |
| **Imortal** | Roubo de vida / Sustentação | Converte dano infligido em sobrevida, permitindo operar por períodos prolongados no limiar da morte. |

---

## 4. Habilidade característica: Última Centelha

* **Efeito:** Ao atingir menos de 30% de HP máximo, Brasa entra em estado de sobreaquecimento, ganhando aumento massivo de velocidade de ataque e roubo de vida vigoroso por alguns segundos.

---

## 5. Sinergias de party recomendadas

* **Bastião + Orvalho + Brasa (Build de Resistência e Atrito):** Orvalho mantém a regeneração contínua de Brasa no limiar crítico enquanto Bastião absorve picos de dano letal.
* **Brasa + Flecha + Sino (Build Hiperagressiva):** Sino eleva o ritmo e reduz tempos de recarga, Flecha marca alvos prioritários e Brasa executa varreduras com Fúria no frontline.

---

## 6. Diretrizes visuais e contratuais

* **Silhueta:** Guerreira de olhar intenso e cicatrizes de fuligem, empunhando machados de combate / cutelo pesado.
* **Cores (TY40):** Subconjuntos `crimson`, `iron`, `wood`, `gold`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Contrato de arte:** [`../../docs/art/contracts/hero_brasa.yaml`](../art/contracts/hero_brasa.yaml).
