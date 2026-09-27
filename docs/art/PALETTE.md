# Pocket Hero — Paleta Canônica e Harmonias de Cor

**Status:** DECIDIDO (FASE R7)  
**Versão:** 1.0.0  
**Data:** 2026-09-27  
**Alvo:** Bosque de Lúmen & Entidades do MVP  

---

## 1. Princípios de Cor e Economia de Paleta

1. **Economia Estrita:** Cada personagem ou criatura deve usar entre **8 e 16 cores distintas no total**, organizadas em rampas claras de 3 a 5 tons por material.
2. **Unificação de Sombras:** Sombras profundas de diferentes materiais compartilham matizes azulados/escuros comuns (`#10141d` ou `#121815`), simulando a iluminação atmosférica do Bosque e amarrando todos os elementos no mesmo espaço cênico.
3. **Alto Contraste para AMOLED:** Os pontos focais (olhos de monstros, fio de lâminas, cristais de Lúmen) utilizam o tom de *highlight* máximo da rampa, destacando-se fortemente do fundo escuro da faixa de batalha.

---

## 2. Rampas de Cores do Bosque de Lúmen

### 2.1 Rampa Lúmen (Bioluminescência Mágica & Geleia)
Usada no corpo translúcido da Geleia de Lúmen, feitiços de Íris, auras e relíquias mágicas:
* `#0c2229` — Sombra profunda (contorno interno escuro)
* `#14444d` — Sombra média
* `#1f7580` — Tom base / meio-tom
* `#32b2a6` — Luz principal
* `#67f0cc` — Brilho de bioluminescência
* `#d4fffa` — Ponto especular / núcleo de energia

### 2.2 Rampa Silvestre (Musgo, Folhas & Cipós)
Usada no Gremlin de Folha, pelagem musgosa do Javali, solo do bosque e armaduras de couro/folhas:
* `#111c14` — Sombra profunda de folhagem
* `#1c3622` — Sombra de casca e musgo
* `#2e5733` — Tom base vegetal
* `#4e8749` — Luz solar filtrada
* `#80c26b` — Broto jovem / realce

### 2.3 Rampa Rocha & Terra Antiga (Pedra, Chifres & Ruínas)
Usada no Guardião-Cervo de Pedra, rochas do cenário, cascos e solo batido:
* `#14151a` — Fenda / sombra de pedra
* `#242730` — Rocha úmida na sombra
* `#3d4252` — Tom base de pedra antiga
* `#626a80` — Rocha iluminada
* `#929cb5` — Crista de rocha / desgaste áspero

### 2.4 Rampa Ferro & Metal Nobre (Armaduras & Armas)
Usada nas proteções de Bastião, pontas de flecha e lâminas:
* `#131921` — Sombra de aço frio
* `#222f3d` — Metal na penumbra
* `#3a4e63` — Tom base de ferro forjado
* `#5e7a99` — Reflexo de luz na lâmina
* `#a8c5e6` — Brilho especular do corte

### 2.5 Rampa Sangue & Alerta (Dano, Olhos Agressivos & Críticos)
Usada em olhos de predadores, efeitos de corte, golpes críticos e números de dano:
* `#290a12` — Sombra de sangue seco
* `#521320` — Vermelho profundo
* `#8c1f30` — Tom base escarlate
* `#d43545` — Alerta vivo / sangue fresco
* `#ff6e75` — Ponto de impacto crítico

### 2.6 Rampa Ouro & Âmbar (Moedas, Tesouros & Lendários)
Usada em moedas de ouro, ícones de raridade lendária e gemas preciosas:
* `#261a0b` — Sombra de metal oxidado
* `#543813` — Ouro envelhecido
* `#9c6d1a` — Tom base de ouro
* `#e0a328` — Ouro polido
* `#ffea78` — Brilho puro do tesouro

---

## 3. Diretriz para Criação de Sprites no Aseprite / MCP

Ao invocar o `pixel-mcp` para pintar ou gerar paletas:
1. Carregar previamente a paleta correspondente.
2. Ativar a flag `use_palette: true` nas operações de desenho de pixels para encaixar automaticamente as cores nos tons canônicos acima definidos.
3. Não introduzir novas cores arbitrárias sem atualizar formalmente este documento.
