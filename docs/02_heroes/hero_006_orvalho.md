# HERO_006 — Orvalho (O Jardineiro do Impossível)

**Status de ciclo:** `APPROVED`  
**Certeza de conteúdo:** `DECIDIDO` (Direção de Rafael em 28/09/2026)  
**ID de design:** `HERO_006`  
**ID runtime:** `hero_orvalho`  
**Papel central:** Curandeiro / Suporte de Regeneração  
**Posição de combate:** Suporte de retaguarda  
**Orientação visual:** Direita ($\rightarrow$)

---

## 1. Fantasia e identidade

> *"Transformar o campo de batalha em um jardim vivo."*

Orvalho foge inteiramente do clichê da sacerdotisa clássica: é uma criatura pequena, rústica e excêntrica que insiste obstinadamente em plantar sementes onde quer que o Lúmen pareça morto.

### Gancho de lore
> *Orvalho acredita em algo que todos consideram absurdo:*  
> *"O Lúmen não está desaparecendo. Ele está tentando ir para algum lugar."*

### Evolução no Hub (Refúgio da Vigília)
Ao retornar ao Refúgio, Orvalho cultiva o **Jardim do Refúgio**, transformando terra estéril em canteiros vivos com flores bioluminescentes, fungos restauradores e ervas de expedição.

---

## 2. Mecânica central: Sementes

Durante a batalha, Orvalho planta **Sementes** bioluminescentes no solo em posições táticas.
Após um tempo de maturação (ou por ativação forçada), as sementes florescem em quatro variantes:
1. 🌱 **Broto Curativo:** Libera pulsos contínuos de regeneração para o aliado mais próximo.
2. 🌻 **Girassol de Lúmen:** Concede buff de poder de ataque e velocidade.
3. 🌵 **Cardo Espinhoso:** Causa dano de atrito e lentidão a inimigos que pisarem na área.
4. 🍃 **Lótus de Purificação:** Remove efeitos negativos e venenos da equipe.

Essa mecânica incentiva uma estratégia focada em preparo de terreno e controle de ritmo.

---

## 3. Rotas de build

| Build | Foco principal | Comportamento em combate |
| --- | --- | --- |
| **Jardim** | Proliferação | Semeia dezenas de pequenos brotos rápidos, saturando a arena com micropulsos de cura e atrito. |
| **Florescimento** | Botânica Gigante | Foca em cultivar poucas plantas monumentais com efeitos massivos de reversão de dano. |
| **Simbiose** | Vínculo Vital | Conecta as curas diretamente a bônus de dano e armadura aos aliados curados. |

---

## 4. Habilidade característica: Última Primavera

* **Efeito:** Orvalho canaliza seu regador mágico/cajado e faz com que todas as sementes presentes no campo desabrochem instantaneamente, aplicando todos os seus efeitos cumulativos de uma só vez em uma explosão botânica de Lúmen.

---

## 5. Sinergias de party recomendadas

* **Bastião + Orvalho + Brasa (Build de Resistência e Atrito Extremo):** Bastião segura o dano direto enquanto Orvalho mantém o jardim alimentando a Fúria de Brasa com curas pontuais no limiar de perigo.

---

## 6. Diretrizes visuais e contratuais

* **Silhueta:** Personagem menor e compacto, chapéu de palha de aba larga com um pequeno broto verde despontando no topo, avental de jardinagem com bolsos cheios de sementes brilhantes, segurando regador de madeira/cajado de broto.
* **Cores (TY40):** Subconjuntos `forest`, `wood`, `lumen`, `neutral_stone`.
* **Dimensões:** Canvas 48×48, baseline $Y=44$, pivot $(24, 44)$.
* **Contrato de arte:** [`../../docs/art/contracts/hero_orvalho.yaml`](../art/contracts/hero_orvalho.yaml).
