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
--------------------------------------------------------------------------------
[EM ANDAMENTO] FASE COMFY-00 — Fundação do ComfyUI como Motor Generativo do Daedalus
               ├─ [PASS] COMFY-00.1 a COMFY-00.9 (Instalação, API, Custom Nodes, Smoke Test 48x48)
               └─ [PENDENTE] COMFY-00.10 a COMFY-00.12: Poses consistentes, mini-animação e homologação
[BLOQUEADO]    FASE R11 — Produzir Bosque de Lúmen (aguarda conclusão de COMFY-00)
```

---

## 5. Próxima Ação Imediata

1. Download e registro dos pesos dos modelos de difusão aprovados para permitir geração autônoma de novos conceitos (COMFY-00.10).
2. Validação da mini-animação COMFY-ANIM-01 integrada no Aseprite e Godot.
3. Homologação final por Têmis para liberar a FASE R11.
