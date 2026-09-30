# Referências visuais do SLICE-1E

**Status:** conceitos exploratórios criados para preparar a direção das telas. Não são layout aprovado, sprites finais, texto de jogo ou fonte de valores. As referências cobrem as lacunas identificadas nos contratos do slice.

| Tela | Referência atual | O que explorar |
| --- | --- | --- |
| UI_S01 — Título | [Título existente](../title_screen_reference.png) | Entrada atmosférica sem oferta ou recurso pago. |
| UI_S02 — Refúgio | [Hub retrato](s02_refugio_concept_v001.png) | Cena vertical e pontos tocáveis de serviço; referências antigas com loja/recursos são históricas. |
| UI_S03 — Expedição | [Trilha do capítulo](s03_expedicao_concept_v001.png) | Uma rota vertical, nós de encontro e ação de iniciar; sem energia ou moeda. |
| UI_S04 — Loadout | [Build da party](s04_loadout_concept_v001.png) | Três heróis, builds independentes, habilidades e equipamento; ícones e marcadores são placeholders. |
| UI_S05 — Expedição em curso | [Combate](s05_expedicao_em_curso_concept_v001.png) | Campo de combate acima; HP, telégrafo, pausa, velocidades e log abaixo. Números/nomes rasterizados são ilustrativos. |
| UI_S06 — Escolha | [Evento](s06_event_choice_concept_v001.png) · [Reward Choice](s06_reward_choice_concept_v001.png) | Dois estados: escolhas de evento e três itens. As imagens não criam efeitos, custos ou itens. |
| UI_S07 — Resultado | [Vitória](s07_resultado_concept_v001.png) · [Derrota](s07_resultado_derrota_concept_v001.png) | Dois resultados; ícones e linhas de texto não definem recompensas nem valores. |
| UI_S08 + UI_S11 — Inventário / Echo | [Inventário com seção Echo](s08_inventario_echo_section_concept_v001.png) | Filtros de slots, lista de itens e seção Echo integrada. UI_S11 não vira tela própria. |
| UI_S09 — Árvore | [Árvore dos Ecos](../slice_1d_references/01_arvore_dos_ecos_v003.png) | Referência 1D atual. |
| UI_S10 — Ferreiro | [Ferreiro](../slice_1d_references/02_ferreiro_v003.png) | Referência 1D atual. |
| Shared — ui_kit | [Conceito aprovado](../../candidates/ui_kit_v003/concept_ui_kit_v003.png) | Materiais e linguagem para as peças compartilhadas. |
| Hub pós-boss — camada modular | [Módulos da Lanterna-Mãe](../slice_1d_references/04_lanterna_overlay_modules_v001.png) | Aura, núcleo, vegetação e broto em conceito separado. |

## Limites e fontes

Os [contratos de UX](../../../09_ui/INDEX.md) e os [contratos de arte](../../contracts/screens/) continuam autoritativos. Texto, quantidades, nomes, estatísticas e ícones inventados pela geração são apenas marcadores visuais e devem ser substituídos pelos dados e rótulos reais. A direção segue o conceito aprovado do `ui_kit` e a regra de não introduzir loja, monetização, compra ou vantagem paga.

As imagens antigas de UI_S02 a UI_S04 em [`UI_SCREEN_PROPOSALS.md`](../UI_SCREEN_PROPOSALS.md) mostram moedas, energia ou poder total e ficam como histórico; não foram usadas para gerar as referências atuais. Estas imagens podem orientar composição e atmosfera. A produção ainda passa por contrato, decisão visual, pixel cleanup, QA técnico, auditoria independente e QA mobile. Não integram assets do jogo.

Para transformar as referências em tarefas concretas, use a [fila de produção de sprites](../../SPRITE_PRODUCTION_BACKLOG.md), que liga cada imagem aos IDs de pacote e às peças dos contratos.
