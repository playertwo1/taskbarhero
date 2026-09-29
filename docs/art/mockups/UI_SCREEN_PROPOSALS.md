# Pocket Hero — Propostas de Telas de Interface (Mobile UX)

**Status:** PROPOSTA / EXPLORAÇÃO DE DESIGN  
**Data:** 2026-09-28  
**Visualizador Interativo:** [`core_screens_options.html`](./core_screens_options.html)  
**Conceitos Visuais de Alta Fidelidade (Pixel Art Dark Fantasy):**
- [Hub / O Refúgio (Diorama)](./hub_screen_reference.png)
- [Seleção de Fases (Bosque de Lúmen)](./stage_select_reference.png)
- [Tela Inicial (Título & Atmosfera)](./title_screen_reference.png)
- [Loadout da Party (Preparação de Batalha)](./party_loadout_reference.png)  

Este documento detalha **3 opções de interface mobile** para cada uma das 4 telas centrais do ecossistema do Pocket Hero:

1. **O Hub / O Refúgio (Cidade dos Artesãos & Árvore dos Ecos)**
2. **Seleção de Fases (Capítulo 1 — Bosque de Lúmen)**
3. **Tela Inicial (Título, Splash & Retorno Offline)**
4. **Loadout e Preparação de Combate (Party, Skills & Equipamento)**

---

## 1. O Hub / O Refúgio da Vigília

**Direção visual atual:** Rafael escolheu como base de composição o [Refúgio com party e serviços](./hub_environment_concepts_v003/07_refugio_party_e_servicos.png). O estudo [mobile retrato](./hub_environment_concepts_v004/08_refugio_mobile_retrato.png) reorganiza a cena para o viewport do celular. A orientação autoritativa de tela, peças modulares, heróis e limites de produção está em [`docs/05_hub/HUB_VISUAL_DIRECTION.md`](../../05_hub/HUB_VISUAL_DIRECTION.md).

As opções antigas abaixo permanecem como histórico de exploração, não como direção selecionada. A árvore não é o tema visual principal do Hub; Lúmen aparece como luz/energia localizada. A base horizontal foi recomposta em estudo vertical; a entrega de produção deverá usar módulos/quads separados e props animados apenas quando fizer sentido.

- Comparativo histórico das primeiras opções: `hub_3_options_comparison.png` (removido em 2026-09-29; disponível no histórico do git, commit `10e67b6`)
- Conceitos v001 e v002: [Praça/Porta/Terraços](./hub_environment_concepts_v001/README.md) · [Encruzilhada/Pátio/Rua](./hub_environment_concepts_v002/README.md)
- Variação escolhida com party e artesãos: [conceito v003](./hub_environment_concepts_v003/README.md)


---

## 2. Seleção de Fases (Capítulo 1 — Bosque de Lúmen)

Representa a jornada pelas 5 fases macro e as 10 subfases do Capítulo 1.

| Opção | Nome | Conceito Visual | Filosofia de UX / Trade-off |
| :--- | :--- | :--- | :--- |
| **2A (Rec.)** | **Trilha Vertical de Encontros** | Caminho desenhado de baixo para cima com nós claros (Comum, Clareira, Minichefe Matriarca, Elite Alfa, Boss Supremo). | **Foco em Pacing:** Leitura perfeita em scroll vertical mobile. O jogador visualiza instantaneamente o progresso e onde estão os picos de dificuldade. |
| **2B** | **Mapa Regional de Lúmen** | Visão cartográfica do bosque com regiões cobertas pelo Apagamento que se iluminam ao serem purificadas. | **Foco em Exploração:** Excelente para expressar a lore de restaurar o Lúmen e visualizar taxas de XP/h de cada zona. |
| **2C** | **Carrossel de Expedição** | Fichas horizontais detalhadas por subfase, com arte do bioma, lista de drops típicos e preview dos inimigos. | **Foco em Informação:** Muito rica em detalhes táticos antes de entrar na batalha (fraquezas, drops e recomendações). |

---

## 3. Tela Inicial (Título & Entrada no Mundo)

A porta de entrada do aplicativo no Android.

| Opção | Nome | Conceito Visual | Filosofia de UX / Trade-off |
| :--- | :--- | :--- | :--- |
| **3A (Rec.)** | **Chama na Penumbra** | Logotipo de *Pocket Hero* centralizado com partículas sutis de Lúmen flutuando e comando *"Toque para Continuar"*. | **Foco em Fluidez:** Entrada rápida e limpa em menos de 2 segundos. Sem telas intermediárias desnecessárias. |
| **3B** | **Acampamento & Retorno Offline** | Mostra de imediato a party descansando e abre um card com as recompensas acumuladas de ausência (XP, Ouro, Itens). | **Foco no Jogador Idle:** Gratificação instantânea logo na inicialização. O jogador recolhe os ganhos com 1 toque. |
| **3C** | **Portal da Fenda (Menu Clássico)** | Arte do Guardião-Cervo ao fundo e menu clássico com botões verticais (*Continuar, Expedições, Refúgio, Codex*). | **Foco Clássico:** Experiência tradicional de RPG nostálgico, ideal para jogadores que preferem navegar por menus explícitos. |

---

## 4. Loadout e Preparação de Combate

Tela conceitual onde o jogador prepara a equipe antes de iniciar uma fase desafiadora: escolher a formação dos 3 heróis, as 2 skills ativas por herói e o loadout de 6 posições por herói (18 posições no total, incluindo Echo).

| Opção | Nome | Conceito Visual | Filosofia de UX / Trade-off |
| :--- | :--- | :--- | :--- |
| **4A (Rec.)** | **Linha de Batalha (3 Colunas)** | Os 3 heróis posicionados lado a lado em colunas com seus slots de skill e itens visíveis em um só relance. | **Foco em Visão Geral:** Permite comparar a party inteira sem trocar de aba. Toque em qualquer slot abre a gaveta de seleção. |
| **4B** | **Foco no Herói + Gaveta Rápida** | Abas no topo para alternar entre heróis (Bastião, Flecha, Íris), dedicando a tela inteira aos detalhes das 6 skills e status. | **Foco em Profundidade:** Excelente para ler com calma as descrições de efeitos e testar sinergias complexas. |
| **4C** | **Matriz de Sinergia e Papéis** | Painel tático com gráfico de equilíbrio (Dano, Sobrevivência, Suporte) e recomendações contra o chefe da fase. | **Foco Estratégico:** Ajuda o jogador a diagnosticar fraquezas da formação antes de enfrentar chefes difíceis. |

---

## Como experimentar os protótipos

Abra o arquivo [`core_screens_options.html`](./core_screens_options.html) em qualquer navegador ou inspecione as opções no visualizador interativo embutido.
