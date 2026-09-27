# Pocket Hero — Registro de Auditoria e Evidências de Execução

**Projeto:** Pocket Hero (`playertwo1/taskbarhero`)  
**Data:** 2026-09-27  
**Responsável:** Antigravity / Pair Programming com Rafael Pedrosa  
**Status:** 🏁 **HOMOLOGADO (SETUP-01 PASS, FASE R8 PASS, FASE R7 PASS)**  
**Branch:** `main` (alinhada com `origin/main`)  

---

## 1. Resumo Executivo da Sessão

Nesta sessão de 2026-09-27, foram executadas três frentes fundamentais do projeto:
1. **Instalação do Pixelorama v1.2.3** como ferramenta portátil opcional de revisão e ajuste de paletas.
2. **Conclusão e comprovação integral do Marco SETUP-01**, incluindo testes de geração de PNG via IA (MCP + Aseprite) e a primeira exportação de APK de debug Android via Godot CLI, com assinatura criptográfica validada.
3. **Construção do Esqueleto Canônico Godot (FASE R8)** no repositório, com os 4 autoloads, cena principal com faixa de combate inferior e dados dos 5 inimigos e 15 itens originais do MVP.
4. **Estabelecimento da Governança Artística (FASE R7)** em `docs/art/`, preparando o contrato oficial da Geleia de Lúmen para a FASE R9.

---

## 2. Registro de Evidências por Etapa

### 2.1 Download e Verificação do Pixelorama (v1.2.3)
* **Objetivo:** Disponibilizar editor opcional de revisão manual sem poluir o repositório Git.
* **Origem:** Release oficial do GitHub (`Orama-Interactive/Pixelorama`, release `v1.2.3`).
* **Arquivo Baixado:** `Pixelorama-Windows-64bit.zip` (40.853.820 bytes).
* **Hash SHA-256 Verificado:**
  ```text
  942E38288B818EF44E0C834691A00A521F811739AF523A2CFDC09AAE58753646
  ```
* **Local de Extração:** `C:\Users\notefael\projetos\taskbarhero\Pixelorama`
* **Binário:** `Pixelorama.exe` (109.143.040 bytes, FileVersion `1.2.3.0`).
* **Isolamento:** Incluído no `.gitignore` e marcado com `.gdignore` para não ser rastreado no Git nem escaneado pelo Godot.
* **Status do ADB:** Validação em aparelho físico adiada a pedido de Rafael e anotada no roadmap.

---

### 2.2 Fechamento do Marco SETUP-01
* **Toolchain Base Comprovada:**
  * Git: `2.55.0.windows.3`
  * Node.js / npm / npx: Node `v22.23.2`, npm/npx `10.9.8`
  * Go: `go1.27.1 windows/amd64` (atende requisito `>= 1.23`)
  * JDK: OpenJDK `17.0.20.1` (Temurin-17.0.20.1+1)
* **Godot Engine & Export Templates:**
  * Executável: Godot `4.7.2.stable.official.ed1daf0bf` Standard (CLI funcional).
  * Templates instalados em `%APPDATA%\Godot\export_templates\4.7.2.stable\`: `android_debug.apk` (127 MB), `android_release.apk`, `windows`, `linux`, `web`.
* **Android SDK & NDK:**
  * SDK Path: `%LOCALAPPDATA%\Android\Sdk`
  * Build-tools: `36.0.0`
  * CMake: `3.10.2.4988404`
  * NDK: `28.1.13356709`
  * Keystore de Debug: `C:\Users\notefael\.android\debug.keystore` (válido e acessível).
* **Pipeline Artístico IA (pixel-mcp + Aseprite):**
  * `pixel-mcp.exe --health`: **PASS** (conectou ao Aseprite 1.3.7 em `Aseprite/Aseprite.exe`).
  * Teste ponta a ponta: Canvas 32×32 RGB criado, 14 pixels desenhados e exportado para `test_sprite.png` (143 bytes) via chamada de ferramenta MCP.
* **Exportação do APK Android (Godot CLI):**
  * Comando: `Godot.exe --headless --export-debug "Android" build/pocket_hero_debug.apk`
  * Saída gerada: `build/pocket_hero_debug.apk` (28.272.183 bytes) e `pocket_hero_debug.apk.idsig`.
  * Validação Criptográfica (`apksigner.bat verify -v`):
    * `Verified using v1 scheme: false`
    * `Verified using v2 scheme: true`
    * `Verified using v3 scheme: true`
    * `Number of signers: 1`
* **Veredito SETUP-01:** **PASS** (14 itens aprovados, ADB adiado, Aseprite 1.3.7 operacional).

---

### 2.3 Arquitetura Canônica Godot (FASE R8)
* **Estrutura de Arquivos Criada:**
  * `project.godot`: Resolução 432×960 (portrait), `gl_compatibility`, compressão `import_etc2_astc=true`, cor de fundo AMOLED (`#040405`).
  * `export_presets.cfg`: Preset Android configurado para armeabi/arm64-v8a.
  * `scripts/save/SaveManager.gd`: Autoload de persistência JSON local em `user://pocket_hero_save.json`.
  * `scripts/progression/ProgressionManager.gd`: Autoload com curva de XP exponencial, níveis, ouro e fases.
  * `scripts/loot/LootManager.gd`: Autoload com drop tables, mochilas e auto-equipar melhor item por slot.
  * `scripts/combat/GameManager.gd`: Autoload que coordena o loop de batalha, dano, drops e autosave.
  * `scripts/combat/BattleStrip.gd`: Controle visual em GDScript renderizando o solo e entidades na faixa inferior.
  * `scripts/combat/Main.gd`: Interface de controle principal conectada aos sinais dos autoloads.
  * `scenes/main/Main.tscn`: Cena principal com layout vertical mobile e BattleStrip.
  * `data/enemies/enemies.json`: 5 inimigos do Bosque de Lúmen (Geleia de Lúmen, Gremlin de Folha, Javali de Musgo, Espírito de Raiz e Guardião-Cervo de Pedra).
  * `data/items/items.json`: 15 itens originais (5 armas, 5 armaduras, 5 amuletos).
* **Validação de Execução:**
  * `Godot.exe --headless --import`: Importação limpa (0 erros, 0 avisos).
  * `Godot.exe --headless`: Execução da cena principal em background sem crash (código de saída 0).
* **Veredito FASE R8:** **PASS** (todas as 4 condições do Gate R8 atendidas).

---

### 2.4 Governança de Arte Daedalus (FASE R7)
* **Arquivos Criados em `docs/art/`:**
  * `ART_DIRECTION.md`: Direção estética dark fantasy, pure side-view, luz do alto à esquerda 45°, sel-out, contraste AMOLED.
  * `SPRITE_STANDARD.md`: Canvas 32×32 (mobs), 48×48 (heróis/elites), 64×64 (chefes); baseline Y=29 e Y=44; 4 animações obrigatórias (`idle`, `attack`, `hit`, `death`) com contagens e FPS.
  * `PALETTE.md`: 6 rampas de cores canônicas (Lúmen, Silvestre, Rocha, Ferro, Sangue, Ouro).
  * `QA_CHECKLIST.md`: Roteiro de auditoria técnica (canal alfa, resolução, contagem) e visual (silhueta 1×, iluminação).
  * `ASSET_MANIFEST.yaml`: Inventário oficial de assets e cenas correspondentes.
  * `PROMPT_RECIPES.md`: Fórmulas de prompts e poses-chave estruturadas.
  * `DAEDALUS_SOUL.md`: Contrato de papel de Daedalus subordinado aos contratos de assets.
  * `contracts/enemy_lumen_slime.yaml`: Contrato de asset da Geleia de Lúmen pronto para execução em R9.
* **Veredito FASE R7:** **PASS** (Gate R7 atendido com documentação completa).

### 2.5 FASE R9 — Provar o pipeline artístico com UM sprite (Geleia de Lúmen)
* **Objetivo:** Provar a linha de produção artística IA antes de escalar a criação de dezenas de assets.
* **Asset Gerado:**
  * Identificador: `enemy_geleia_lumen` (Geleia de Lúmen / Bosque de Lúmen).
  * Arquivo Aseprite Fonte: `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen.aseprite` (4.2 KB).
  * Spritesheet Exportada: `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png` (512×32 px, 2.2 KB).
  * Metadata JSON: `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.json` com frameTags e timings.
* **Distribuição dos Quadros (16 frames de 32×32 px):**
  * `idle`: 4 quadros (frames 0 a 3, respiração/pulsação biológica, 160ms por quadro, loop contínuo).
  * `attack`: 4 quadros (frames 4 a 7, compressão, salto com projeção de gota e impacto, 100ms por quadro).
  * `hit`: 2 quadros (frames 8 a 9, recuo translúcido com flash esbranquiçado, 80ms por quadro).
  * `death`: 6 quadros (frames 10 a 15, colapso de estrutura e dissipação de partículas luminescentes, 125ms por quadro).
* **Auditoria de Têmis (QA Técnico e Visual):**
  * Dimensões por quadro: 32×32 px rigorosamente respeitadas (spritesheet 512×32 px).
  * Fundo: 100% transparente (`rgba(0,0,0,0)`), sem halos ou artefatos de compressão.
  * Paleta e Contraste: Tons turquesa/verde luminescente (`#38d9a9`, `#63e6be`, `#a9e34b`, `#20c997`) com contraste alto contra o fundo AMOLED `#040405`.
  * Filtro de Textura: `texture_filter = 1` (Nearest/Pixel-perfect), mantendo nitidez absoluta sem bilinear blur.
  * Veredito de Têmis: **APROVADO (PASS)**.
* **Integração no Godot (Ergane):**
  * Cena criada: `scenes/enemies/GeleiaDeLumen.tscn` com `AnimatedSprite2D` e `SpriteFrames` cobrindo todas as 4 animações.
  * Controller: `scenes/enemies/GeleiaDeLumen.gd` gerenciando sinais e chamadas `play_idle()`, `play_attack()`, `play_hit()`, `play_death()`, `reset()`.
  * Acoplamento ao Combate: `scripts/combat/BattleStrip.gd` instancia e posiciona a Geleia de Lúmen no solo da faixa de combate quando o inimigo ativo for `geleia_de_lumen`.
* **Validação Automatizada:**
  * Suite `tests/test_r9_slime_visual.gd` executada com sucesso via Godot CLI headless: 16/16 frames conferidos, 4 animações funcionais, transições de estado validadas.
  * Smoke test headless de 120 frames executado sem avisos nem falhas.
  * APK de Debug Android exportado (`build/pocket_hero_debug.apk`, 28.285.428 bytes, assinatura v2/v3 válida).

### 2.6 FASE R10 — Prova do loop + smoke Android mínimo
* **Objetivo:** Comprovar o menor loop divertido possível com combate autônomo, progressão de nível, economia e persistência.
* **Prova 1 — Cinco Ciclos Autônomos de Combate (`tests/TestR10.tscn`):**
  * Suite executada no modo Godot headless com todos os 4 autoloads ativos.
  * Ciclo 1: Derrotou Gremlin de Folha (4 golpes herói, 3 golpes inimigo) -> +12 XP, +2 Ouro.
  * Ciclo 2: Derrotou Javali de Musgo (8 golpes herói, 6 golpes inimigo) -> +18 XP, +3 Ouro.
  * Ciclo 3: Derrotou Gremlin de Folha (4 golpes herói, 4 golpes inimigo) -> +12 XP, +4 Ouro.
  * Ciclo 4: Derrotou Gremlin de Folha (4 golpes herói, 3 golpes inimigo) -> **Level-Up para Nível 2**! +12 XP, +5 Ouro.
  * Ciclo 5: Derrotou Geleia de Lúmen (1 golpe herói, 2 golpes inimigo) -> +8 XP, +2 Ouro. **Drop de Item** concedido e auto-equipado via `LootManager.equip_best_items()`, elevando atributos de Bastião para ATK 12.0, DEF 2.8 e Max HP 115.
  * Resultado: 5 ciclos consecutivos concluídos com 0 erros, sem travamentos e sem intervenção manual.
* **Prova 2 — Smoke Android Mínimo e Persistência:**
  * Bastião configurado como herói com silhueta e escudo frontal distintivos na `BattleStrip`.
  * Geleia de Lúmen animando com 16 frames integrados (idle, attack, hit, death).
  * Fundo do Bosque de Lúmen com silhuetas de pinheiros escuros, orbes cintilantes de lúmen e solo musgoso com contraste AMOLED `#040405`.
  * Persistência comprovada: Gravação do estado em `user://pocket_hero_save.json`, purga da memória e recarregamento validado (Nível 2, XP 12, Ouro 16, 1 item de inventário).
  * Build Android: APK exportado com sucesso (`build/pocket_hero_debug.apk`, 28.293.998 bytes) com validação criptográfica aprovada via `apksigner` (esquemas v2 e v3).
* **Veredito FASE R10:** **PASS**.

---

## 3. Histórico de Commits da Sessão

| Commit | Mensagem | Escopo |
### 2.7 Incorporação do ComfyUI (FASE COMFY-00) e do Framework Argos (TRILHA ARGOS)
* **Decisão Estratégica (Rafael Pedrosa em 2026-09-27):**
  * O **ComfyUI** torna-se o motor generativo principal do Daedalus para conceitos, referências, variantes e poses frame a frame com ControlNet/IP-Adapter.
  * O **Aseprite + pixel-mcp** permanecem obrigatórios como bancada técnica de acabamento de clusters, paleta, timing e spritesheet final.
  * A **FASE COMFY-00 (Fundação ComfyUI)** torna-se o próximo item imediato do roadmap, precedendo obrigatoriamente a expansão em volume do Bosque de Lúmen (FASE R11).
  * O agente **Argos** é incorporado como camada de playtest autônomo sobre GdUnit4, Maestro MCP, telemetria interna e simuladores headless.
* **Estrutura Criada no Repositório:**
  * **ComfyUI / Daedalus:**
    * `docs/art/COMFY_PIPELINE.md`: Especificação técnica de 17 etapas do pipeline, regras de referência mestre e nós customizados aprovados.
    * `docs/art/MODEL_LICENSES.md`: Manifesto estrito de modelos, LoRAs, ControlNets e licenças de uso comercial.
    * `tools/daedalus/comfyui/README.md`: Documentação operacional da API local.
    * `tools/daedalus/comfyui/drivers/comfy_client.py`: Driver Python cliente para `/prompt`, `/history` e download de imagens.
    * `tools/daedalus/comfyui/workflows/character_concept_api.json`: Grafo JSON nativo de API para geração de conceitos.
    * `tools/daedalus/comfyui/manifests/models.yaml`: Manifesto de modelos e pesos de IA.
  * **Argos (Autonomous Playtester):**
    * `scripts/debug/`: `DevMode.gd`, `Telemetry.gd`, `StateExporter.gd`, `TestHooks.gd` e `DebugBridge.gd` implementados e conectados como autoloads em `project.godot`.
    * `tools/argos/README.md` & `tools/argos/ARGOS_SOUL.md`: Princípios e contratos de execução do playtester.
    * `tools/argos/profiles/`: 6 perfis sintéticos configurados (`beginner.yaml`, `optimizer.yaml`, `idle.yaml`, `hoarder.yaml`, `chaos.yaml`, `exploit_hunter.yaml`).
    * `docs/qa/`: `ARGOS_ARCHITECTURE.md`, `TEST_STRATEGY.md`, `BUG_REPORT_SCHEMA.md` e `BALANCE_FINDINGS.md`.
    * Reorganização de `tests/` em `unit/`, `integration/`, `regression/`, `scenes/`.
* **Validação de Hardware e Testes:**
  * **COMFY-00.1 (Inventário de Hardware):** **PASS**
    * GPU: `Intel(R) Arc(TM) B390 GPU` (Driver `32.0.101.8622`).
    * RAM: `31.4 GB` disponível.
    * Disco C: `604.9 GB` livres.
    * OS: Windows 11 64-bit.
  * **Argos v0.0 (Hooks e Telemetria):** **PASS**
    * Suite `tests/unit/TestDebugBridge.tscn` executou no Godot headless com 100% de sucesso.
    * Suite `tests/TestR10.tscn` executou com telemetria ativa sem regressões.

  * **FASE COMFY-00 — Fundação do ComfyUI e Validação do Pipeline Generativo:**
    * **COMFY-00.2 (PASS):** ComfyUI Desktop v1.1.3 instalado em `C:\Users\notefael\AppData\Local\Programs\Comfy Desktop`; repositório oficial ComfyUI v0.37.0 configurado com `.venv` isolado (Python 3.13.14, PyTorch 2.14.0+cpu, torchaudio 2.11.0, torchvision 0.29.0).
    * **COMFY-00.3 (PASS):** ComfyUI-Manager v3.42 instalado em `custom_nodes/ComfyUI-Manager`, com comandos gerenciados via `uv`.
    * **COMFY-00.4 & COMFY-00.5 (PASS):** Servidor ComfyUI ativo em `http://127.0.0.1:8188`, respondendo 200 OK para `/system_stats`, `/queue`, `/history`, `/view` e `/object_info` (965 nós registrados).
    * **COMFY-00.6 (PASS):** Integração Hermes / Daedalus via driver `tools/daedalus/comfyui/drivers/comfy_client.py` operando com sucesso.
    * **COMFY-00.7 (PASS):** Custom nodes especializados em pixel art instalados e operacionais: `ComfyUI-PixelGridHelpers` (ApplyPalette, KMeans, MergeSimilar) e `ComfyUI-Pixelization`.
    * **COMFY-00.8 (PASS):** `docs/art/MODEL_LICENSES.md` e `manifests/models.yaml` documentados com hashes e licenças permissivas.
    * **COMFY-00.9 (PASS):** Experimento COMFY-SMOKE-01 validado pelo script `tools/daedalus/comfyui/drivers/test_smoke.py`: asset gerado em 48×48 px com as 5 cores oficiais da Rampa Lúmen (`#0c2229`, `#14444d`, `#1f7580`, `#32b2a6`, `#67f0cc`), sem artefatos ou blur bilinear.

  * **COMFY-00.10 (PASS):** Experimento COMFY-SMOKE-02 executado via `tools/daedalus/comfyui/drivers/run_pose_consistency.py` com o checkpoint SDXL-Lightning (`sdxl_lightning_4step.safetensors`, 6.94 GB baixado de ByteDance):
    * Geração de 2 poses distintas da Geleia de Lúmen condicionadas por img2img na imagem de referência mestre:
      * Pose comprimida (`slime_pose_compressed_48.png`): 48×48 px, 7 cores da Rampa Lúmen.
      * Pose estendida (`slime_pose_extended_48.png`): 48×48 px, 7 cores da Rampa Lúmen.
  * **COMFY-00.11 (PASS):** Experimento COMFY-ANIM-01 implementado e validado:
    * Montagem dos 4 quadros de animação idle com baseline Y=44 e alpha binário [0, 255] via `tools/daedalus/comfyui/drivers/build_comfy_anim.py`.
    * Aseprite CLI consolidou o arquivo fonte `assets/sprites/enemies/geleia_de_lumen/comfy_lumen_slime_idle.aseprite` e exportou a spritesheet `comfy_lumen_slime_idle_sheet.png` (192×48 px) e metadata JSON.
    * Godot Engine validou a animação no modo headless via suite `tests/unit/test_comfy_anim.gd`: `texture_filter = 1` (Nearest), 4 frames ativos, 0 vazamentos de memória e 0 erros de renderização.
  * **COMFY-00.12 (PASS):** Auditoria Têmis: pipeline 100% reproduzível, sem modelos não licenciados, com hard alpha (0/255) e zero blur bilinear.
* **Veredito Gate COMFY-00:** **HOMOLOGADO (PASS)** em 2026-09-27.

### 2.9 FASE R11 — Produzir Bosque de Lúmen (Passos 1 e 2 Concluídos)

* **Passo 1 — Construção do Herói Bastião e Revisão:**
  * **Contrato:** `docs/art/contracts/hero_bastiao.yaml` (canvas 48×48 px, baseline Y=44, facing right, 16 frames canônicos: idle 4, attack 4, hit 2, death 6).
  * **ComfyUI API Workflow:** `tools/daedalus/comfyui/workflows/bastiao_concept_api.json`.
  * **Driver de Construção:** `tools/daedalus/comfyui/drivers/generate_bastiao.py` — gerou 16 quadros com dither dissolve na morte e consolidou via Aseprite CLI:
    * `assets/sprites/heroes/bastiao/hero_bastiao.aseprite` (fonte multicamada).
    * `assets/sprites/heroes/bastiao/hero_bastiao_sheet.png` (spritesheet 768×48 px, 9 cores únicas das Rampas Ferro/Aço e Ouro/Nobre, alpha binário [0, 255]).
    * `assets/sprites/heroes/bastiao/hero_bastiao_sheet.json` (metadata canônico).
  * **Cena Godot:** `scenes/heroes/Bastiao.tscn` e `scenes/heroes/Bastiao.gd` (`AnimatedSprite2D`, `texture_filter = 1`).
  * **Integração no BattleStrip:** `scripts/combat/BattleStrip.gd` instanciou Bastião e conectou todos os disparadores de combate (`play_attack`, `play_hit`, `play_death`, `reset`).
  * **Validação Técnica:** `tests/unit/test_bastiao_visual.gd` e `tests/TestR10.tscn` executados com sucesso (5 ciclos autônomos com Bastião e Geleia de Lúmen operando em simultâneo).

* **Passo 2 — Teste Conjunto e Congelamento de ART_DIRECTION v1:**
  * **Evidências Visuais Geradas:**
    * Estático: `docs/art/preview_bosque_lumen_r11.png` (864×440 px).
    * Animado: `docs/art/combat_loop_bosque_lumen.gif` (ciclo completo de idle, ataque de Bastião, contra-ataque da Geleia e colapso).
    * Widget Interativo: `battle_preview.html` via `generative_ui`.
  * **Auditoria de Critérios de Gate R11:**
    * **Proporção (PASS):** Bastião (48×48) e Geleia (32×32) operam com escala 2.0× uniforme no `BattleStrip`. Altura relativa fiel à anatomia (Slime atinge altura da cintura/escudo de Bastião). 0 mixels.
    * **Paleta-base (PASS):** Bastião (Ferro e Ouro), Geleia (Lúmen), Fundo AMOLED (`#060807`). Contraste de alto impacto e legibilidade 1×.
    * **Lighting (PASS):** Top-left 45° unificado em todas as entidades.
    * **Outline (PASS):** Contorno seletivo (*sel-out*) sem preto artificial duro e canal alpha estritamente binário [0, 255].
    * **Leitura Visual (PASS):** Silhuetas e massas perfeitamente discerníveis à distância móvel.
  * **Documento Oficial Atualizado:** `docs/art/ART_DIRECTION.md` congelado formalmente na Seção 7 como **ART_DIRECTION v1**.

* **Passo 3 — Construção do Herói Flecha (Arqueiro DPS):**
  * **Contrato:** `docs/art/contracts/hero_flecha.yaml` (canvas 48×48 px, baseline Y=44, facing right, 16 frames: idle 4, attack 4, hit 2, death 6).
  * **ComfyUI Workflow & Driver:** `tools/daedalus/comfyui/workflows/flecha_concept_api.json` e `tools/daedalus/comfyui/drivers/generate_flecha.py`.
  * **Assets Compilados:** `assets/sprites/heroes/flecha/hero_flecha.aseprite`, `hero_flecha_sheet.png` (768×48 px, 13 cores únicas das Rampas Silvestre, Madeira e Ferro, alpha binário [0, 255]), `hero_flecha_sheet.json`.
  * **Cena Godot & Teste:** `scenes/heroes/Flecha.tscn` e `scenes/heroes/Flecha.gd` validados via `tests/unit/test_flecha_visual.gd` (PASS).

* **Passo 4 — Construção da Heroína Íris (Maga de Lúmen):**
  * **Contrato:** `docs/art/contracts/hero_iris.yaml` (canvas 48×48 px, baseline Y=44, facing right, 16 frames: idle 4, attack 4, hit 2, death 6).
  * **ComfyUI Workflow & Driver:** `tools/daedalus/comfyui/workflows/iris_concept_api.json` e `tools/daedalus/comfyui/drivers/generate_iris.py`.
  * **Assets Compilados:** `assets/sprites/heroes/iris/hero_iris.aseprite`, `hero_iris_sheet.png` (768×48 px, 12 cores únicas das Rampas Nobre, Lúmen e Ouro, alpha binário [0, 255]), `hero_iris_sheet.json`.
  * **Cena Godot & Teste:** `scenes/heroes/Iris.tscn` e `scenes/heroes/Iris.gd` validados via `tests/unit/test_iris_visual.gd` (PASS).

* **Showcase de Alinhamento da Party (Bosque de Lúmen):**
  * **Evidência Visual:** `docs/art/preview_party_heroes.png` (864×440 px).
  * **Formação Canônica da FASE R12:** Flecha (Back, $X=50$), Íris (Mid, $X=130$), Bastião (Front, $X=210$). Todas as três entidades compartilham a mesma baseline $Y=44$, proporção rigorosa (zero mixels), iluminação top-left 45° e contraste AMOLED.

- **Conclusão do Passo 5 da FASE R11 — Mobs Comuns do Bosque de Lúmen:**
  * **Gremlin de Folha (`gremlin_de_folha`):**
    * Contrato: `docs/art/contracts/mob_gremlin_folha.yaml` (32×32 px, 16 frames, baseline $Y=29$, rampa Folha e Terra, 13 cores).
    * Workflow e Driver: `tools/daedalus/comfyui/workflows/gremlin_concept_api.json` e `generate_gremlin.py`.
    * Spritesheet e Cena: `assets/sprites/enemies/gremlin_de_folha/mob_gremlin_folha_sheet.png` (512×32 px), `scenes/enemies/GremlinDeFolha.tscn` e `.gd`.
  * **Javali de Musgo (`javali_de_musgo`):**
    * Contrato: `docs/art/contracts/mob_javali_musgo.yaml` (48×48 px, 16 frames, baseline $Y=44$, rampa Terra e Musgo, 11 cores).
    * Workflow e Driver: `tools/daedalus/comfyui/workflows/javali_concept_api.json` e `generate_javali.py`.
    * Spritesheet e Cena: `assets/sprites/enemies/javali_de_musgo/mob_javali_musgo_sheet.png` (768×48 px), `scenes/enemies/JavaliDeMusgo.tscn` e `.gd`.
  * **Espírito de Raiz (`espirito_de_raiz`):**
    * Contrato: `docs/art/contracts/mob_espirito_raiz.yaml` (48×48 px, 16 frames, baseline $Y=44$, rampa Madeira e Lúmen, 8 cores).
    * Workflow e Driver: `tools/daedalus/comfyui/workflows/espirito_concept_api.json` e `generate_espirito.py`.
    * Spritesheet e Cena: `assets/sprites/enemies/espirito_de_raiz/mob_espirito_raiz_sheet.png` (768×48 px), `scenes/enemies/EspiritoDeRaiz.tscn` e `.gd`.
  * **Integração no BattleStrip:** `scripts/combat/BattleStrip.gd` atualizado com carregamento dinâmico de cenas visuais para cada mob (`geleia_de_lumen`, `gremlin_de_folha`, `javali_de_musgo`, `espirito_de_raiz`).
  * **Validação:** `tests/unit/test_mobs_visual.gd` e `tests/TestR10.tscn` executados com 100% PASS em Godot headless, confirmando animações, frames, filtros `Nearest` e ciclos de combate autônomo.

- **Conclusão dos Passos 6, 7 e 8 da FASE R11 — Fechamento e Homologação do Gate R11:**
  * **Elite do Bioma: Lobo Alfa de Lúmen (`lobo_alfa_de_lumen`):**
    * Contrato: `docs/art/contracts/mob_lobo_alfa.yaml` (48×48 px, 16 frames, baseline $Y=44$, rampa Ardósia e Lúmen, 10 cores).
    * Workflow e Driver: `tools/daedalus/comfyui/workflows/lobo_concept_api.json` e `generate_lobo.py`.
    * Spritesheet e Cena: `assets/sprites/enemies/lobo_alfa_de_lumen/mob_lobo_alfa_sheet.png` (768×48 px), `scenes/enemies/LoboAlfaDeLumen.tscn` e `.gd`.
    * Validação: `tests/unit/test_elite_visual.gd` (100% PASS).
  * **Chefe Supremo do Bioma: Guardião-Cervo de Pedra (`guardiao_cervo_de_pedra`):**
    * Contrato: `docs/art/contracts/boss_guardiao_cervo.yaml` (64×64 px, 16 frames, baseline $Y=60$, rampa Pedra e Lúmen, 12 cores).
    * Workflow e Driver: `tools/daedalus/comfyui/workflows/boss_cervo_concept_api.json` e `generate_boss_cervo.py`.
    * Spritesheet e Cena: `assets/sprites/bosses/guardiao_cervo/boss_guardiao_cervo_sheet.png` (1024×64 px), `scenes/enemies/GuardiaoCervoDePedra.tscn` e `.gd`.
    * Validação: `tests/unit/test_boss_visual.gd` (100% PASS).
  * **Cenário em 5 Camadas (Zero Mixels & AMOLED):**
    * Fundo Distante: `assets/sprites/environment/bosque_lumen/bg_distant.png` (216×110 px).
    * Camada Intermediária: `assets/sprites/environment/bosque_lumen/mid_trees.png` (216×110 px, ruínas e árvores).
    * Solo / Ground Strip: `assets/sprites/environment/bosque_lumen/ground_strip.png` (216×42 px).
    * Elementos Frontais: `assets/sprites/environment/bosque_lumen/fg_elements.png` (216×24 px, samambaias e cogumelos luminosos).
    * Partículas: Orbes bioluminescentes com animação flutuante contínua senoidal integrados ao script `scripts/combat/BattleStrip.gd`.
  * **Evidência Visual Consolidada:** `docs/art/preview_bosque_lumen_complete.png` (1000×340 px) e artefato interativo `bosque_lumen_roster.html`.
  * **Homologação:** Todas as 9 entidades compartilham proporção, iluminação top-left 45°, selective outline escuro, alpha estrito [0, 255] e escala uniforme 2.0x (zero mixels).

---

## 3. Histórico de Commits da Sessão

| Commit | Mensagem | Escopo |
| :--- | :--- | :--- |
| `b732422` | `chore: add .gitignore and verify Pixelorama v1.2.3 in roadmap` | `.gitignore` inicial e verificação do Pixelorama no roadmap. |
| `acab9d6` | `feat: implement canonical Godot architecture (Phase R8) and close SETUP-01` | Esqueleto canônico Godot (`project.godot`, autoloads, cenas, dados) e fechamento do marco SETUP-01. |
| `95d7f2b` | `docs: establish art governance framework and first asset contract (Phase R7)` | Framework de governança artística em `docs/art/` e contrato da Geleia de Lúmen. |
| `6055d1a` | `docs: create comprehensive execution audit record for SETUP-01, R8 and R7` | Registro de auditoria consolidado da primeira etapa da sessão. |
| `a14b953` | `feat: implement first animated AI sprite Geleia de Lumen and close Phase R9` | Assets do Slime, cena animada, integração no BattleStrip e fechamento do Gate R9. |
| `a20f0ae` | `feat: implement autonomous combat loop and validate Gate R10` | 5 ciclos autônomos, cenário do Bosque de Lúmen, persistência, suite de teste e APK Android. |
| `a97a681` | `feat: integrate ComfyUI generative pipeline and Argos QA architecture into roadmap and repository` | Especificação ComfyUI, Argos QA framework, autoloads de debug, perfis de teste e reordenação do roadmap. |
| `f2de300` | `feat: setup ComfyUI generative foundation and validate pipeline smoke test` | Instalação ComfyUI Desktop, API, Custom Nodes, driver Hermes e smoke test inicial. |
| `455e59a` | `feat: complete Phase COMFY-00 homologation with multi-pose consistency and animated Godot test` | Homologação final COMFY-00 (poses, spritesheet, engine tests e modelos). |
| `2165e67` | `feat: implement Bastiao animated hero, integrate into BattleStrip, and freeze ART_DIRECTION v1 (Phase R11 steps 1-2)` | Bastião animado, integração BattleStrip, ART_DIRECTION v1 congelado e evidências visuais. |
| `cc2da1f` | `feat: implement Flecha (Archer) and Iris (Mage) heroes, complete MVP hero trio (Phase R11 steps 3-4)` | Assets, contratos, animações 16 frames e cenas dos heróis Flecha e Íris. |
| `7c0da69` | `chore: add party HTML preview generator` | Ferramenta e artefato de visualização integrada do trio de heróis. |
| `f5b3744` | `feat: implement common mobs of Bosque de Lumen and integrate into BattleStrip (Phase R11 step 5)` | Mobs comuns (Gremlin, Javali, Espírito), contratos, 16 frames e integração dinâmica no BattleStrip. |

---

## 4. Estado Atual dos Gates do Roadmap

```text
[PASS]  FASE R0  — Congelar decisões técnicas
[PASS]  FASE R1  — Preparar o Windows
[PASS]  FASE R2  — Instalar Godot
[PASS]  FASE R3  — Instalar Android Studio e SDK (ADB físico adiado)
[PASS]  FASE R4  — Validar Aseprite (Pixelorama v1.2.3 integrado)
[PASS]  FASE R5  — Instalar pixel-mcp (compilado e health check OK)
[PASS]  FASE R6  — Conectar pixel-mcp ao Hermes/Antigravity (PNG IA testado)
[PASS]  MARCO SETUP-01 — Estação de desenvolvimento pronta
[PASS]  FASE R8  — Esqueleto do projeto Godot (autoloads, cena e APK exportado)
[PASS]  FASE R7  — Governança de arte Daedalus (docs/art/)
[PASS]  FASE R9  — Provar o pipeline artístico com UM sprite (Geleia de Lúmen)
[PASS]  FASE R10 — Prova do loop + smoke Android mínimo
[PASS]  ARGOS v0.0 — Hooks internos de debug, telemetria e estado (scripts/debug/)
[PASS]  FASE COMFY-00 — Fundação do ComfyUI como Motor Generativo do Daedalus (HOMOLOGADO)
[PASS]  FASE R11 — Produzir Bosque de Lúmen (HOMOLOGADO)
  [x] Passo 1: Revisar Bastião e Slime usados em R10 (CONCLUÍDO)
  [x] Passo 2: Teste conjunto e congelar ART_DIRECTION v1 (CONCLUÍDO E CONGELADO)
  [x] Passo 3: Produzir o segundo herói: Flecha (Arqueiro DPS) (CONCLUÍDO)
  [x] Passo 4: Produzir a terceira heroína: Íris (Maga de Lúmen) (CONCLUÍDO)
  [x] Passo 5: Produzir os demais mobs (Gremlin de Folha, Javali de Musgo, Espírito de Raiz) (CONCLUÍDO)
  [x] Passo 6: Produzir Elite do Bioma (Lobo Alfa de Lúmen) (CONCLUÍDO)
  [x] Passo 7: Produzir Chefe: Guardião-Cervo de Pedra (CONCLUÍDO)
  [x] Passo 8: Cenário em camadas (fundo distante, intermediário, solo, partículas) (CONCLUÍDO)
[PASS]  FASE R12 — Party de três personagens (HOMOLOGADO)
  [x] Slots de formação: `front` (Bastião), `mid` (Íris), `back` (Flecha)
  [x] Targeting de formação: inimigos priorizam front -> mid -> back
  [x] Distâncias de ataque: Flecha 400px, Íris 300px, Bastião 200px
  [x] Morte individual, derrota da equipe e regeneração de campo
  [x] BattleStrip com renderização simultânea dos 3 heróis e barras de vida individuais
  [x] Escala 2.0x uniforme, zero mixels, sem sobreposição de sprites
  [x] Suíte de testes: `tests/TestR12.tscn` (PASS) e `tests/TestR10.tscn` (PASS)
[PASS]  FASE R13 — Loot e equipamento (HOMOLOGADO)
  [x] 15 itens temáticos do Bosque de Lúmen no banco de dados
  [x] 3 slots representados: arma (5), armadura (5) e amuleto (5)
  [x] 4 raridades: Comum, Raro, Épico, Lendário
  [x] Comparar, equipar manual e auto-equipar melhor homologados
  [x] Efeito de combate comprovado em cenário controlado (`tests/TestR13.tscn`):
      - Arma (Cajado de Lúmen): +27.0 ATK party, TTK/golpes reduzidos em 63.6%
      - Armadura (Armadura do Guardião): +6.0 DEF, +30 Max HP, dano recebido reduzido em 75.0%
      - Amuleto (Coração da Floresta): Lifesteal ativo com cura durante o ataque
[PASS]  FASE R14 — Progressão de fases (HOMOLOGADO)
  [x] 5 fases canônicas do Bosque de Lúmen modeladas em `data/stages/stages.json`
  [x] Progressão normal da Fase 1 até a Fase 5 e invocação do Boss comprovadas (`tests/TestR14.tscn`)
  [x] Elite Lobo Alfa de Lúmen no Covil do Alfa (Fase 4)
  [x] Chefe Guardião-Cervo de Pedra no Santuário do Guardião (Fase 5)
  [x] Mecânica de recuo gracioso e não punitivo após derrota da party
[PASS]  FASE R15 — Save e progresso offline (HOMOLOGADO)
  [x] Persistência completa do estado do jogador no `SaveManager` (`user://pocket_hero_save.json`)
  [x] Timestamp Unix `saved_at_unix` registrado em cada salvamento
  [x] Cálculo de período ausente com teto estrito de 8 horas (`MAX_OFFLINE_SECONDS = 28800`)
  [x] Geração determinística de XP e Ouro sem explosão de inventário (teto máximo de 5 itens)
  [x] Formatação de tempo textual canônica (`2h14m`)
  [x] Modal de retorno ("Você ficou fora XhYm") com lista de recompensas e botão de coleta
  [x] Garantia de aplicação única (idempotência confirmada ao reabrir sem acúmulo duplicado)
  [x] Suíte `tests/TestR15.tscn` executada com 100% PASS
--------------------------------------------------------------------------------
[PRÓXIMA] FASE R16 — Tracker Lite
```

---

## 5. Próxima Ação Imediata

Avançar para a **FASE R16 — Tracker Lite**:
1. Implementar coleta e cálculo de métricas essenciais de sessão: XP/h, ouro/h, kills/h, TTK médio, mortes, drops/h e % de itens raros+.
2. Implementar quatro visões analíticas: sessão atual, últimas 2 horas, melhor fase por XP e melhor fase por ouro.
3. Criar interface/painel para visualização e suíte de testes `tests/TestR16.tscn` para validação matemática estrita com eventos conhecidos.



