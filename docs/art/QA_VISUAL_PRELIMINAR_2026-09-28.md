# Triagem visual preliminar — assets do Capítulo 1

**Data:** 2026-09-28  
**Estado:** revisão preliminar; Gate 0 continua aberto  
**Escopo:** spritesheets de heróis, bestiário, ícones de itens/skills/fases e camadas do Bosque de Lúmen.  
**Parecer:** não é aceite de release nem substitui auditoria independente e validação mobile.

## Fontes e método

- Catálogo: [`MVP_SPRITE_INVENTORY.md`](MVP_SPRITE_INVENTORY.md).
- Critérios: [`QA_SPRITES.md`](QA_SPRITES.md), contratos e manifests dos assets.
- Inspeção visual de folhas ampliadas para leitura de quadros; ícones observados em tamanho nativo nos contact sheets temporários; camadas ambientais compostas para inspeção.
- Comparação de pixels por quadro usada apenas para localizar quadros exatamente repetidos em animações idle. Repetição não é falha automática: conferir timing, intenção do contrato e percepção em movimento.

## Achados que precisam de resolução ou aceite

### QA-ART-2026-09-28-01 — PNG extra na pasta de skills [RESOLVIDO]

- **Observado:** `assets/sprites/skills/icons/` continha 16 PNGs com `test_skill.png`.
- **Resolução (2026-09-28):** Rafael confirmou o descarte do arquivo de teste. O arquivo foi removido, alinhando a pasta estritamente aos 15 ícones de skills oficiais declarados no lote.

### QA-ART-2026-09-28-02 — Quadros idle exatamente repetidos

A leitura automatizada dos JSONs de atlas encontrou três quadros visuais únicos em vez de quatro nos seguintes ciclos idle:

- Heróis: Brasa, Forja, Orvalho, Sino e Véu.
- Inimigos: Lobo de Sombra, Saqueador da Mata, Sentinela de Raízes e Xamã de Esporos.
- Minichefe: Matriarca do Micélio.

Os contratos pedem ciclos idle de quatro quadros. Verificar com o autor se a repetição é uma pausa intencional e assistir aos ciclos no jogo; corrigir somente se a pausa quebrar a descrição, o ritmo ou a leitura. Não há conclusão de FAIL baseada apenas na igualdade de pixels.

### QA-ART-2026-09-28-03 — validações ainda necessárias

- Ver a party, o bestiário e as camadas do Bosque na cena real de combate, com câmera, escala, fundo e import do Godot.
- Fazer leitura em tamanho de tela mobile, especialmente contraste de inimigos escuros e escala dos ícones 32×32.
- Registrar auditor responsável, independência em relação à autoria, assets/versões, evidências e veredito por lote conforme [`QA_SPRITES.md`](QA_SPRITES.md).

## Resultado da triagem

Os contact sheets de itens, skills e fases apresentam formas distintas e paleta visual coerente nesta inspeção; isso é apenas observação preliminar, não `PASS`. A Geleia, os inimigos, heróis e chefes também mantêm identidade reconhecível nas folhas ampliadas, mas ainda não foram aceitos em escala de jogo/mobile. As quatro camadas do Bosque compõem uma cena legível em preview; falta validar a composição e o contraste na cena Godot.

**Gate 0 permanece aberto.** Esta triagem registra achados para a auditoria formal; não muda manifests para `PASS`, não remove arquivos e não altera a homologação anterior do MVP.
