# HERO_008 — Sino (O Guardião das Memórias)

**Status de ciclo:** `APPROVED`  
**Certeza de conteúdo:** `DECIDIDO` (Direção de Rafael em 28/09/2026)  
**ID de design:** `HERO_008`  
**ID runtime:** `hero_sino`  
**Papel central:** Suporte Buffer / Manipulador de Ritmo  
**Posição de combate:** Retaguarda rítmica  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Fantasia e identidade

> *"Mudar o ritmo da batalha."*

Sino é um Memorialista. Antes do grande Apagamento, sua ordem conservava memórias de eras inteiras encapsuladas em pequenos sinos e carrilhões de Lúmen. Ao tocá-los com precisão musical, desperta ecos do passado que distorcem o tempo e fortalecem o espírito dos companheiros.

### Gancho de lore
> *Sino sabe um segredo proibido que ninguém mais no mundo conhece:*  
> *"Memórias podem ser retiradas e preservadas sem matar a pessoa."*  
> *Isso muda completamente a compreensão sobre a natureza das criaturas corrompidas e dos Ecos.*

### Evolução no Hub (Refúgio da Vigília)
No Hub, Sino restaura o **Memorial da Vigília**, um templo sereno de pilares antigos onde os Ecos e lembranças das expedições passadas são entalhados e honrados, concedendo benefícios duradouros à guilda.

---

## 2. Mecânica central: Ritmo

Sino sintoniza a cadência das habilidades da equipe:
* **Geração de Notas:** A cada terceira habilidade utilizada por qualquer membro da party, Sino acumula uma **Nota de Lúmen**.
* Ao atingir compassos completos, Sino libera ressonâncias que produzem:
  * 🎵 Redução instantânea de cooldowns aliados.
  * 🎵 Replicação do efeito da última habilidade ativada.
  * 🎵 Escudos de harmonia e extensão de buffs temporários.
  * 🎵 Interrupção rítmica de conjurações inimigas.

---

## 3. Rotas de build

| Build | Foco principal | Comportamento em combate |
| --- | --- | --- |
| **Ritmo** | Cadência e velocidade | Acelera brutalmente os ciclos de ataque básico e cooldowns da equipe. |
| **Ressonância** | Replicação de efeitos | Faz com que habilidades fortes de aliados sejam imediatamente ecoadas em versão gêmea. |
| **Memória** | Preservação e sustentação | Rebobina o estado da equipe, devolvendo vida e estamina baseando-se no dano sofrido nos últimos segundos. |

---

## 4. Habilidade característica: Encore

* **Efeito:** Sino desfere um badalar monumental em seu cajado de sinos de Lúmen. Toda a party repete imediatamente uma versão harmônica das suas últimas habilidades utilizadas (ex: Íris solta uma nova explosão arcana, Flecha uma saraivada e Bastião ergue um escudo adicional simultaneamente).

---

## 5. Sinergias de party recomendadas

* **Brasa + Flecha + Sino (Build Agressiva de Alta Frequência):** Sino acelera o ritmo $\rightarrow$ Flecha aplica marcas em velocidade vertiginosa $\rightarrow$ Brasa em fúria desfere golpes repetidos em cascata.
* **Forja + Sino + Íris (Build de Controle e Engenharia Contínua):** Permite rotações ultra-rápidas de máquinas e magias arcanas.

---

## 6. Diretrizes visuais e contratuais

* **Silhueta:** Figura serena em túnica cerimonial decorada com runas de pauta musical, portando cajado com pequenos sinos dourados e de cristal de Lúmen que ressoam suavemente a cada movimento.
* **Cores (TY40):** Subconjuntos `lumen`, `gold`, `crimson`, `iron`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Contrato de arte:** [`../../docs/art/contracts/hero_sino.yaml`](../art/contracts/hero_sino.yaml).
