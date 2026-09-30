# Relatório de QA Mobile — SLICE-1E (Pixel 9 Android)

**Data de Execução:** 2026-09-30  
**Ambiente de Teste:** Emulador Android Studio (`emulator-5554`)  
**Modelo Simulado:** Google Pixel 9 (Proporção 20:9, Resolução Nativa `1080x2424`, Densidade `420 dpi`, Android 17)  
**Build:** Pocket Hero Debug APK (`build/pocket_hero_debug.apk`, Godot 4.7.2 Standard)  
**Avaliador:** QA Automatizado / Antigravity via `adb` Touch Injection  

---

## 1. Resumo Executivo

O vertical slice (SLICE-1) foi submetido a uma sessão extensiva de teste táctil e validação visual de ponta a ponta no formato de smartphone moderno (Pixel 9). Todas as telas do loop principal (`TitleScreen → Refúgio UI_S02 → Árvore dos Ecos → Presets de Loadout UI_S04 → Arena de Expedição e Combate → Reward Choice → Tela de Resultado UI_S07 → Inventário UI_S03 → Ferreiro de Lúmen UI_S05`) foram navegadas exclusivamente via toques/taps nativos em coordenadas mobile.

**Resultado Global:** **APROVADO COM LOUVOR (PASS)**.
- **Zero crashes** e **zero erros de script (SCRIPT ERROR)**.
- Layouts responsivos sem sangria, truncamento ou sobreposição de texto em 20:9.
- Fidelidade visual dos assets em Alta Densidade: sprites 96×96 da party, bestiário de 64 a 224px, ícones de itens 64×64 e artes de hub 256×256 perfeitamente nítidos sem borrão bilinear.
- Tema AMOLED nativo (`#0d1117`) garante economia energética e contraste tátil de leitura.

---

## 2. Matriz de Evidências por Tela

| Tela / Sistema | Ação Táctil Executada | Comportamento Observado | Status |
| :--- | :--- | :--- | :--- |
| **Title Screen** (`UI_S01`) | Toque na tela inicial | Transição suave para o Refúgio de Lúmen; arte da floresta noturna e logo centralizados. | **PASS** |
| **Refúgio de Lúmen** (`UI_S02`) | Navegação pelo santuário | TopBar de recursos legível; banner dinâmico e trio descansando (Bastião, Flecha, Íris) perfeitamente alinhados; botões com padding tátil mínimo de 48dp. | **PASS** |
| **Árvore dos Ecos** | Compra sequencial de 6 nós | Compra de *Semente da Vigília*, *Pulso Vital*, *Ressonância Estável*, *Forja Reerguida*, *Desmontagem Protegida* e *Aprimoramento Controlado*; consumo de 22 Fragmentos de Ressonância com feedback de status. | **PASS** |
| **Desbloqueio do Ferreiro** | Retorno ao Hub após nó de Forja | O botão de serviço "Ferreiro" com ícone temático apareceu dinamicamente entre Árvore e Inventário. | **PASS** |
| **Loadout & Presets** (`UI_S04`) | Abertura de dropdown e seleção | Popup com os 4 presets do slice funcionando fluidamente; ao selecionar "Preset: Cura", skills e descrições dinâmicas de Bastião e Íris atualizaram instantaneamente. | **PASS** |
| **Arena de Expedição** | Início da run e controles | 4 camadas de parallax do Bosque de Lúmen; atores animados reagindo a golpes e vitórias; botões de velocidade (×1, ×2, ×4, ×20) e pausa responsivos. | **PASS** |
| **Eventos de Escolha** | Seleção tátil de opções | Eventos de expedição ("Absorver o poder", "Salvar animal") acionados com sucesso por toque nos botões dedicados. | **PASS** |
| **Reward Choices (Chefes)** | Seleção de recompensas | Telas de recompensa na Rainha das Geleias e Geleia Anciã renderizaram cards com ícones 64×64 de alta resolução e tipografia colorida por raridade (Comum, Incomum, Raro). | **PASS** |
| **Tela de Resultado** (`UI_S07`) | Fim de run pós-Guardião | Painel AMOLED com badges estilizados de XP, Resíduo de Lúmen (+10) e Fragmentos (+20); grade de 4 itens coletados com seus respectivos ícones. | **PASS** |
| **Inventário** (`UI_S03`) | Visualização e Auto-equip | Exibição de Echo ("A Sentinela que Ficou"); toque no botão "Equipar os melhores" equipou itens ótimos em Bastião, Flecha e Íris marcando o status. | **PASS** |
| **Ferreiro — Validação de Slot** | Toque em Reforçar em Acessório | Exibição correta da restrição canônica: *"Só Arma, Secundário e Armadura recebem Reforço."* | **PASS** |
| **Ferreiro — Reforço +1** | Toque em Reforçar na Couraça | Couraça de Musgo recebeu tag `Reforço +1`; Resíduo de Lúmen decresceu exatamente de 13 para 8 (consumo canônico de 5 resíduos). | **PASS** |
| **Ferreiro — Favoritar** | Toque em Favoritar | Item marcado como favorito; botão alternou para "Tirar favorito". | **PASS** |
| **Ferreiro — Proteção Desmonte** | Toque em Desmontar item favorito | Bloqueio com mensagem: *"Item favorito não pode ser desmontado. Tire o favorito primeiro."* | **PASS** |
| **Retorno ao Refúgio** | Toque em Voltar ao Refúgio | Hub atualizou TopBar e dados de texto para "Resíduo de Lúmen: 8", mantendo total consistência de estado. | **PASS** |

---

## 3. Conformidade com Diretrizes Mobile e UI Kit

1. **Target Touch Size:** Todos os botões do tema AMOLED e UI Kit possuem altura mínima entre 48px e 80px no viewport lógico (`432x960`), resultando em alvos táteis de 120px a 200px na tela nativa do Pixel 9, superando com folga o padrão Google Material Design (mínimo de 48×48 dp).
2. **Escala e Proporção:** Com a configuração `mode="canvas_items"` e `aspect="expand"`, o jogo preenche com perfeição o display 20:9 (`1080x2424`) sem letterboxing preto nem distorções geométricas.
3. **Legibilidade de Tipografia:** Textos primários e secundários mantiveram contraste nítido contra o fundo escuro (`#0d1117`), sem perda de nitidez ou serrilhamento indesejado.
4. **Resolução de Assets:** Todos os sprites de itens carregaram dinamicamente em 64×64 pixels através do `ItemIconResolver`, conferindo acabamento premium e visual artesanal.

---

## 4. Conclusão

A validação mobile em hardware virtual de última geração (Pixel 9 / Android 17) atesta que o **SLICE-1E** cumpre todos os requisitos de jogabilidade, UX, responsividade tátil e identidade visual do Pocket Hero.

## 5. Achados e correções (antigo QA_MOBILE_1E, unificado em 2026-09-30)

| ID | Tela | Achado | Status / Resolução |
| --- | --- | --- | --- |
| QA-001 | Refúgio | Scroll horizontal e texto cortado no subtítulo. | **RESOLVIDO**: `autowrap` ativado e scroll horizontal desabilitado em `SliceCampaignScreen.gd`. |
| QA-002 | Título | Texto "TOUCH TO START" da arte sobreposto a label. | **RESOLVIDO**: Limpeza visual e alinhamento no TitleScreen. |
| QA-003 | Título | Versão duplicada. | **RESOLVIDO**: Unificado para versão única. |
| QA-004 | Expedição | Arena com ator único em foco. | **DESIGN INTENCIONAL**: O ator ativo da vanguarda/party lidera o avanço na arena mobile. |
| QA-005 | Refúgio | Arraste em dropdown vs rolagem. | **MONITORADO**: Alvos táteis ajustados com folga; scrollbar tátil à direita disponível. |
| QA-006 | Refúgio | Card do Ferreiro ausente antes da Árvore. | **COMPORTAMENTO ESPERADO**: O Ferreiro é desbloqueado dinamicamente via `TREE_OFI_001` (validado ao vivo no Pixel 9). |
