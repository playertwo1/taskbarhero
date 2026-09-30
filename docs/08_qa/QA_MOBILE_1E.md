# QA mobile do slice (1E) — achados e homologação

**Data:** 2026-09-30 · **Aparelho:** emulador Pixel 9 (`1080x2424`, 420 dpi, Android 17) · **Build:** APK debug atualizado (`build/pocket_hero_debug.apk`, Godot 4.7.2 Standard).
**Estado:** `HOMOLOGADO / PASS`. Loop completo verificado via toques nativos no emulador. Relatório detalhado em [`QA_MOBILE_PIXEL9_REPORT.md`](QA_MOBILE_PIXEL9_REPORT.md).

## Cobertura

- **Verificado e Aprovado:**
  1. Title Screen (`UI_S01`): layout centralizado e transição ao toque.
  2. Refúgio de Lúmen (`UI_S02`): TopBar tátil de recursos, diorama com lanterna, trio descansando (96×96) e cards de serviços.
  3. Árvore dos Ecos: compra dos 6 nós da árvore consumindo 22 Fragmentos de Ressonância.
  4. Desbloqueio do Ferreiro: ativação dinâmica do botão no Hub após compra de `TREE_OFI_001`.
  5. Presets & Loadout (`UI_S04`): dropdown com os 4 presets do slice; alternância dinâmica de descrições e skills por herói.
  6. Expedição & Arena: 4 camadas de parallax do Bosque, atores animados, velocidades (×1 a ×20) e pausa.
  7. Eventos de Expedição: botões de escolha com efeitos aplicados na party.
  8. Reward Choices: cards com ícones 64×64 de alta resolução e tipografia colorida por raridade nos chefes.
  9. Tela de Resultado (`UI_S07`): badges de XP, Resíduo de Lúmen e Fragmentos com grade de itens conquistados.
  10. Inventário (`UI_S03`): slot de Echo ("A Sentinela que Ficou"), exibição de itens e botão "Equipar os melhores".
  11. Ferreiro de Lúmen (`UI_S05`): validação de slot (apenas Arma, Secundário e Armadura), Reforço +1 consumindo 5 Resíduos, favoritar item e proteção contra desmontagem de favoritos.

## Histórico de Correções e Fechamento

| ID | Tela | Achado | Status / Resolução |
| --- | --- | --- | --- |
| QA-001 | Refúgio | Scroll horizontal e texto cortado no subtítulo. | **RESOLVIDO**: `autowrap` ativado e scroll horizontal desabilitado em `SliceCampaignScreen.gd`. |
| QA-002 | Título | Texto "TOUCH TO START" da arte sobreposto a label. | **RESOLVIDO**: Limpeza visual e alinhamento no TitleScreen. |
| QA-003 | Título | Versão duplicada. | **RESOLVIDO**: Unificado para versão única. |
| QA-004 | Expedição | Arena com ator único em foco. | **DESIGN INTENCIONAL**: O ator ativo da vanguarda/party lidera o avanço na arena mobile. |
| QA-005 | Refúgio | Arraste em dropdown vs rolagem. | **MONITORADO**: Alvos táteis ajustados com folga; scrollbar tátil à direita disponível. |
| QA-006 | Refúgio | Card do Ferreiro ausente antes da Árvore. | **COMPORTAMENTO ESPERADO**: O Ferreiro é desbloqueado dinamicamente via `TREE_OFI_001` (validado ao vivo no Pixel 9). |
