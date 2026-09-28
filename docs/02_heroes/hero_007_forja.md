# HERO_007 — Forja (A Catadora de Relíquias)

**Status de ciclo:** `APPROVED`  
**Certeza de conteúdo:** `DECIDIDO` (Direção de Rafael em 28/09/2026)  
**ID de design:** `HERO_007`  
**ID runtime:** `hero_forja`  
**Papel central:** Engenheira / Invocadora de Autômatos  
**Posição de combate:** Retaguarda tática  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Fantasia e identidade

> *"Pegar restos do mundo antigo e fazê-los funcionar novamente."*

Forja explora ruínas esquecidas de uma civilização ancestral anterior ao Apagamento. Sem recorrer a ficção científica incompatível, ela domina a magitecnologia movida a Lúmen: engrenagens pesadas de bronze, caldeiras a vapor e autômatos de pedra rúnica.

### Gancho de lore
> *Forja encontra máquinas antigas que utilizavam Lúmen... mas algumas parecem ter sido construídas especificamente para **extrair** o Lúmen do mundo.*  
> *A terrível dúvida ecoa: O Apagamento realmente aconteceu de forma natural, ou foi provocado por ganância tecnológica ancestral?*

### Evolução no Hub (Refúgio da Vigília)
No Hub, Forja estabelece a **Oficina do Refúgio**, cheia de peças mecânicas, caldeiras e bancadas onde recicla sucata da expedição e aprimora engenhocas.

---

## 2. Mecânica central: Engenhocas

Durante a luta, Forja projeta e desdobra pequenos autômatos no campo de batalha:
1. ⚙️ **Sentinela Autônoma:** Dispara dardos de sucata nos inimigos próximos.
2. 💡 **Farol de Ressonância:** Emite ondas de pulso que fortalecem o poder dos aliados.
3. 💣 **Mina de Lúmen:** Detona quando inimigos se aproximam, causando atordoamento e dano em área.
4. 🧲 **Coletor de Sucata:** Aspira fragmentos de Lúmen soltos pelo combate para acelerar a construção de novas peças.

---

## 3. Rotas de build

| Build | Foco principal | Comportamento em combate |
| --- | --- | --- |
| **Torres** | Balística e alcance | Prioriza posicionar múltiplas sentinelas pesadas com fogo cruzado. |
| **Armadilhas** | Controle de terreno | Espalha minas de choque e campos repulsores para quebrar avanço inimigo. |
| **Autômatos** | Unidades móveis | Constrói construtos bípedes robustos que avançam como minitanques absorvendo golpes. |

---

## 4. Habilidade característica: Projeto Impossível

* **Efeito:** Forja aciona um dínamo de Lúmen e une temporariamente todas as engenhocas presentes na arena em uma máquina colossal mista que executa um bombardeio maciço contra a tropa inimiga antes de se desmantelar em peças recicláveis.

---

## 5. Sinergias de party recomendadas

* **Forja + Sino + Íris (Build de Construtos & Aceleração de Loop):** Sino acelera o ritmo de recarga $\rightarrow$ Forja projeta enxames de máquinas em velocidade recorde $\rightarrow$ Íris agrupa e congela os monstros sob o fogo das sentinelas.

---

## 6. Diretrizes visuais e contratuais

* **Silhueta:** Moça engenhosa com óculos de solda/proteção de latão erguidos na testa, cinto reforçado de ferramentas, chave inglesa/martelo pesado de artesão e uma pequena sentinela flutuante rúnica a tiracolo.
* **Cores (TY40):** Subconjuntos `iron`, `gold`, `lumen`, `wood`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Contrato de arte:** [`../../docs/art/contracts/hero_forja.yaml`](../art/contracts/hero_forja.yaml).
