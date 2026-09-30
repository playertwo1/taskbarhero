# QA mobile do slice (1E) — achados

**Data:** 2026-09-30 · **Aparelho:** emulador Pixel 9 (1080×2424) · **Build:** APK debug exportado a partir de `main` (commit `e845b36`).
**Estado:** parcial. Status dos achados: `ABERTO` até Rafael corrigir.

## Cobertura

- Verificado: Título, Refúgio (preparação da expedição) e início da expedição (arena, controles de velocidade, log).
- **Não verificado:** Árvore dos Ecos, Ferreiro (exige desbloqueio por `TREE_OFI_001`), Inventário/Echo, Reward Choice, evento, tela de resultado, Guardião.

## Corrigido nesta sessão

| ID | Achado | Correção |
| --- | --- | --- |
| QA-001 | Refúgio mais largo que a tela: scroll horizontal, texto e botões cortados à direita. Causa: subtítulo sem quebra de linha. | `autowrap` no subtítulo e scroll horizontal desligado em [SliceCampaignScreen.gd](../../scripts/ui/SliceCampaignScreen.gd) (`e845b36`). Conferido no emulador. |

## Achados abertos

| ID | Tela | Achado | Observação |
| --- | --- | --- | --- |
| QA-002 | Título | O texto "TOUCH TO START" da arte se sobrepõe a "TOQUE PARA CONTINUAR" e à linha de versão. | Provável texto embutido na arte de fundo; decidir entre refazer a arte ou remover o texto do label. |
| QA-003 | Título | A versão aparece duas vezes e com valores diferentes (`v0.2.0` e `v1.0.2`). | Conferir a fonte de cada valor. |
| QA-004 | Expedição | A arena mostra só o Bastião; Flecha e Íris não aparecem. | **EM ABERTO:** pode ser intencional (um ator por vez); confirmar com o contrato de [UI](../09_ui/INDEX.md). |
| QA-005 | Refúgio | Arrastar a partir de um dropdown ou botão abre o menu em vez de rolar a tela. O arraste só rolou a partir de um título. | Pode atrapalhar no celular real; verificar no S25 Ultra. Opção: `ScrollContainer` com `follow_focus`/deadzone de toque. |
| QA-006 | Refúgio | O card do Ferreiro não aparece. | Esperado enquanto `TREE_OFI_001` estiver travado; só registrar para a próxima rodada de QA. |

## Próxima rodada

Percorrer as telas não verificadas, destravar o Ferreiro e repetir o QA em 432×960 com o texto de cada tela (cortes, alvos de toque pequenos, contraste).
