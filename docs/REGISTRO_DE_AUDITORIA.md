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

---

## 3. Histórico de Commits da Sessão

| Commit | Mensagem | Escopo |
| :--- | :--- | :--- |
| `b732422` | `chore: add .gitignore and verify Pixelorama v1.2.3 in roadmap` | `.gitignore` inicial e verificação do Pixelorama no roadmap. |
| `acab9d6` | `feat: implement canonical Godot architecture (Phase R8) and close SETUP-01` | Esqueleto canônico Godot (`project.godot`, autoloads, cenas, dados) e fechamento do marco SETUP-01. |
| `95d7f2b` | `docs: establish art governance framework and first asset contract (Phase R7)` | Framework de governança artística em `docs/art/` e contrato da Geleia de Lúmen. |

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
--------------------------------------------------------------------------------
[AGUARDANDO] FASE R9  — Provar o pipeline artístico com UM sprite (Geleia de Lúmen)
[PENDENTE]   FASE R10 — Prova do loop + smoke Android mínimo
```

---

## 5. Próxima Ação Imediata

Iniciar a **FASE R9**:
1. Criar o sprite da `enemy_geleia_lumen` (Geleia de Lúmen) via Daedalus / MCP Aseprite conforme o contrato `docs/art/contracts/enemy_lumen_slime.yaml`.
2. Produzir a spritesheet com 16 frames no total (4 idle, 4 attack, 2 hit, 6 death).
3. Submeter a auditoria técnica e visual contra o `docs/art/QA_CHECKLIST.md`.
4. Integrar o recurso `SpriteFrames` no Godot em `scenes/enemies/GeleiaDeLumen.tscn`.
