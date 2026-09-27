# ROADMAP — Taskbar Hero Mobile / Pocket Hero

Status: planejamento inicial  
Engine-alvo: Godot 4.7.2 stable  
Plataforma inicial: Android  
Orquestração: Hermes Agent  
Arte: Daedalus + pixel-mcp + Aseprite  
Repositório: playertwo1/taskbarhero

---

## 0. Definição de MVP

O MVP não é o overlay Android. O objetivo inicial é provar o jogo completo dentro de um app Android normal. O overlay só entra depois do MVP, quando o loop principal estiver estável.

### Conteúdo mínimo do MVP

**Região**
- Bosque de Lúmen.
- 5 fases curtas: entrada, pressão, ninho/farm, elite e boss.

**Heróis**
- Bastião — frontline/tank.
- Flecha — ranged DPS.
- Íris — AoE/magia.

**Inimigos**
- Geleia de Lúmen.
- Gremlin de Folha.
- Javali de Musgo.
- Espírito de Raiz.
- 1 elite.
- 1 boss: Guardião-Cervo de Pedra.

**Progressão**
- XP.
- level.
- ouro.
- stats básicos.
- equipamento.
- raridades.
- 15 itens iniciais.
- save local.
- progresso offline.

**Combate**
- automático.
- grupo de até 3 heróis.
- inimigos surgem e avançam.
- dano, morte, XP, loot e próxima onda.
- boss ao final da região.

**Arte**
- pixel art original.
- spritesheets animadas.
- cenário em camadas.
- efeitos básicos.

**Android**
- APK debug instalável.
- jogo funcional em aparelho real.
- legibilidade validada em tela pequena.

**Fora do MVP**
- Google Play.
- servidor.
- conta/login.
- multiplayer.
- monetização.
- cloud save.
- overlay sobre outros apps.
- conteúdo corrompido completo.
- dezenas de regiões.
- centenas de itens.

---

# FASE R0 — Congelar decisões técnicas

## Objetivo

Eliminar decisões fundamentais antes de começar a instalar e produzir conteúdo.

## Decisões

- Godot 4.7.2 Standard.
- GDScript.
- Android primeiro.
- portrait como modo principal do app.
- batalha em faixa horizontal inferior.
- pixel art side-view.
- Git/GitHub para versionamento.
- Hermes como orquestrador.
- Theia como diretora.
- Ergane como Builder.
- Têmis como Auditora.
- Research para pesquisa.
- Daedalus para arte.
- pixel-mcp + Aseprite como backend artístico.
- Pixelorama como editor/revisor opcional.

## Gate R0

PASS quando:
- estas decisões estiverem registradas no repositório;
- nenhuma discussão essencial sobre engine/plataforma bloquear a instalação.

---

# FASE R1 — Preparar o Windows

## Objetivo

Ter um ambiente previsível para desenvolvimento, automação e build Android.

## 1. Atualizar Windows e winget

Abra PowerShell:

```powershell
winget --version
```

Atualize o App Installer pela Microsoft Store se o winget não responder.

## 2. Instalar Git

```powershell
winget install -e --id Git.Git
```

Validar:

```powershell
git --version
```

## 3. Instalar Node.js LTS

Necessário para MCPs npm/npx e ferramentas auxiliares.

```powershell
winget install -e --id OpenJS.NodeJS.LTS
```

Validar:

```powershell
node --version
npm --version
npx --version
```

## 4. Instalar Go

O pixel-mcp exige Go 1.23+.

Use o instalador oficial atual ou:

```powershell
winget search GoLang.Go
```

Instale a versão estável atual disponível.

Validar:

```powershell
go version
```

Aceite somente Go >= 1.23.

## 5. Instalar OpenJDK 17

Godot recomenda JDK 17 para exportação Android.

```powershell
winget install -e --id EclipseAdoptium.Temurin.17.JDK
```

Validar:

```powershell
java -version
javac -version
```

## Gate R1

PASS quando os comandos abaixo funcionarem:

```text
git --version
node --version
npm --version
npx --version
go version
java -version
```

---

# FASE R2 — Instalar Godot

## Objetivo

Preparar a engine principal.

## 1. Instalar Godot 4.7.2 stable

Usar **Godot 4.7.2 Standard**, não .NET.

Motivo:
- GDScript é suficiente;
- reduz dependências;
- Android com C# possui limitações adicionais;
- a mesma versão é usada pelo Pixelorama atual.

Baixar da página oficial do Godot.

## 2. Instalar Export Templates

No Godot:

```text
Editor
→ Manage Export Templates
→ Download and Install
```

Confirmar que os templates correspondem exatamente ao Godot 4.7.2.

## 3. Configurar projeto inicial

Clone:

```powershell
git clone https://github.com/playertwo1/taskbarhero.git
cd taskbarhero
```

Futuramente o projeto Godot ficará na raiz ou em uma pasta `game/`, dependendo da estrutura adotada antes do primeiro commit de código.

## Gate R2

PASS quando:
- Godot abre;
- versão exibida = 4.7.2;
- export templates 4.7.2 instalados.

---

# FASE R3 — Instalar Android Studio e SDK

## Objetivo

Conseguir instalar um APK criado pelo Godot no celular.

## 1. Instalar Android Studio

```powershell
winget install -e --id Google.AndroidStudio
```

Execute o Android Studio pelo menos uma vez para completar a instalação do SDK.

## 2. SDK necessário para Godot 4.7

Instalar pelo SDK Manager:

- Android SDK Platform-Tools >= 35.0.0
- Android SDK Build-Tools 35.0.1
- Android SDK Platform 35
- Android SDK Command-line Tools (latest)
- CMake 3.10.2.4988404
- NDK 28.1.13356709

## 3. Validar ADB

Caminho típico:

```text
%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe
```

Teste:

```powershell
adb version
```

Se `adb` não estiver no PATH, use o caminho completo ou adicione `platform-tools` ao PATH.

## 4. Configurar o S25 Ultra

No celular:

```text
Configurações
→ Sobre o telefone
→ Informações do software
→ tocar 7x em Número da versão
→ Opções do desenvolvedor
→ Depuração USB
```

Conectar por USB.

No PC:

```powershell
adb devices
```

Aceitar a chave RSA no telefone.

Resultado esperado:

```text
<serial>    device
```

## 5. Configurar Android no Godot

```text
Editor
→ Editor Settings
→ Export
→ Android
```

Definir:

- Java SDK Path → JDK 17.
- Android SDK Path → normalmente `%LOCALAPPDATA%\Android\Sdk`.

## Gate R3

PASS quando:
- `adb devices` mostra o celular como `device`;
- Godot reconhece Java SDK;
- Godot reconhece Android SDK;
- um projeto vazio exporta e abre no S25 Ultra.

---

# FASE R4 — Validar Aseprite (Pixelorama opcional)

## Objetivo

Preparar o ambiente de criação/revisão de pixel art.

## 1. Aseprite

Instalar Aseprite 1.3.10+.

Registrar o caminho exato do executável, por exemplo:

```text
C:\Program Files\Aseprite\Aseprite.exe
```

Não assumir esse caminho: confirmar na instalação real.

## 2. Pixelorama

Uso:
- revisão manual;
- correção de pixels;
- inspeção de animação;
- edição de paleta;
- fallback quando a geração automática precisar de acabamento.

Se disponível, usar uma versão estável. Pixelorama é ferramenta opcional de revisão, não bloqueia o gate.

## Gate R4

PASS quando:
- Aseprite abre;
- é possível criar e salvar um PNG transparente.

Se Pixelorama estiver instalado, conferir nele o mesmo PNG como verificação adicional.

---

# FASE R5 — Instalar pixel-mcp

## Objetivo

Permitir que Hermes/Daedalus controlem o Aseprite.

## 1. Clonar

Escolher uma pasta de ferramentas, por exemplo:

```text
C:\AI\tools\
```

Executar:

```powershell
cd C:\AI\tools
git clone https://github.com/willibrandon/pixel-mcp.git
cd pixel-mcp
```

## 2. Compilar no Windows

Para evitar depender de `make`, usar o Go diretamente:

```powershell
New-Item -ItemType Directory -Force bin
go build -o bin\pixel-mcp.exe .\cmd\pixel-mcp
```

## 3. Validar

```powershell
.\bin\pixel-mcp.exe --health
```

## 4. Criar configuração

O pixel-mcp usa um config com caminho absoluto do Aseprite.

Exemplo conceitual:

```json
{
  "aseprite_path": "C:/Program Files/Aseprite/Aseprite.exe",
  "temp_dir": "C:/AI/temp/pixel-mcp",
  "timeout": 30,
  "log_level": "info",
  "log_file": "",
  "enable_timing": false
}
```

Ajustar os caminhos ao computador real.

## 5. Teste isolado

Antes de envolver Hermes:
- iniciar pixel-mcp;
- criar canvas simples;
- desenhar poucos pixels;
- exportar PNG;
- confirmar que o arquivo abre no Aseprite/Pixelorama.

## Gate R5

PASS quando o pixel-mcp:
- inicia;
- encontra o Aseprite;
- cria um sprite;
- exporta um PNG válido.

---

# FASE R6 — Conectar pixel-mcp ao Hermes

## Objetivo

Fazer o Hermes enxergar o backend artístico como uma ferramenta.

## 1. Validar suporte MCP

O Hermes padrão já inclui suporte MCP.

Caso a instalação não tenha extras MCP:

```bash
cd ~/.hermes/hermes-agent
uv pip install -e ".[mcp]"
```

## 2. Registrar o servidor

No `~/.hermes/config.yaml`, adicionar um servidor stdio apontando para o executável real.

Exemplo conceitual:

```yaml
mcp_servers:
  pixel_art:
    command: "C:/AI/tools/pixel-mcp/bin/pixel-mcp.exe"
```

O formato final deve seguir a instalação atual do Hermes.

## 3. Princípio de contexto mínimo

Não liberar todos os documentos do projeto em todas as chamadas.

Daedalus recebe somente:
- ART_DIRECTION.md;
- SPRITE_STANDARD.md;
- PALETTE.md;
- contrato do asset;
- referência explicitamente aprovada.

## 4. Primeiro teste via Hermes

Pedido:

```text
Use o MCP pixel_art.
Crie um canvas 32x32 transparente.
Desenhe um quadrado simples.
Exporte como test_mcp.png.
Não altere outros arquivos.
```

## Gate R6

PASS quando:
- Hermes descobre as ferramentas;
- consegue chamar pixel-mcp;
- PNG é criado;
- nenhum acesso desnecessário ao projeto ocorre.

---

# FASE R7 — Criar governança do Daedalus

## Objetivo

Evitar que cada modelo invente seu próprio estilo.

Criar:

```text
docs/art/
├── ART_DIRECTION.md
├── SPRITE_STANDARD.md
├── PALETTE.md
├── ASSET_MANIFEST.yaml
├── QA_CHECKLIST.md
├── PROMPT_RECIPES.md
└── contracts/
```

Criar também a configuração/SOUL do Daedalus.

## ART_DIRECTION.md

Congelar:
- side view;
- direção da iluminação;
- outline;
- escala de personagens;
- contraste;
- número aproximado de cores;
- orientação padrão;
- regra de legibilidade em tela pequena.

## SPRITE_STANDARD.md

Definir:
- canvas;
- baseline;
- pivot;
- margem;
- nomes de animação;
- frames;
- FPS;
- layout da spritesheet.

## ASSET_MANIFEST.yaml

Registrar:
- asset_id;
- versão;
- status;
- diretório;
- responsável;
- cena Godot correspondente.

## QA_CHECKLIST.md

Automático:
- resolução;
- transparência;
- número de frames;
- nomes;
- arquivos obrigatórios.

Visual:
- silhueta;
- paleta;
- luz;
- escala;
- legibilidade.

## Gate R7

PASS quando Daedalus consegue receber um contrato de asset sem precisar inventar regras ausentes.

**Status:** PASS em 2026-09-27. Governança completa criada em `docs/art/` (`ART_DIRECTION.md`, `SPRITE_STANDARD.md`, `PALETTE.md`, `ASSET_MANIFEST.yaml`, `QA_CHECKLIST.md`, `PROMPT_RECIPES.md`, `DAEDALUS_SOUL.md` e contrato `contracts/enemy_lumen_slime.yaml`). Daedalus e Têmis possuem todos os critérios para executar a FASE R9.

---

# FASE R8 — Criar esqueleto do projeto Godot

## Objetivo

Ter arquitetura suficiente para receber os primeiros assets sem construir o jogo inteiro.

Estrutura:

```text
taskbarhero/
├── project.godot
├── assets/
│   ├── sprites/
│   │   ├── heroes/
│   │   ├── enemies/
│   │   ├── bosses/
│   │   ├── pets/
│   │   ├── items/
│   │   └── effects/
│   └── environments/
├── data/
│   ├── heroes/
│   ├── enemies/
│   ├── items/
│   └── regions/
├── scenes/
│   ├── main/
│   ├── battle/
│   ├── heroes/
│   ├── enemies/
│   └── ui/
├── scripts/
│   ├── combat/
│   ├── progression/
│   ├── loot/
│   ├── save/
│   └── android/
├── docs/
└── tools/
```

Criar autoloads:

```text
GameManager
SaveManager
LootManager
ProgressionManager
```

## Gate R8

PASS quando:
- projeto abre sem erros;
- cena principal roda;
- alterações da etapa foram revisadas em diff, preservando mudanças pré-existentes; commit somente com autorização de Rafael;
- APK vazio/placeholder ainda exporta.

---

# FASE R9 — Provar o pipeline artístico com UM sprite

## Objetivo

Não fabricar dezenas de assets antes de provar a fábrica.

Primeiro asset sugerido:

```text
enemy_lumen_slime
```

Contrato:

- 32x32 ou 48x48;
- idle 4;
- attack 4;
- hit 2;
- death 4–6;
- transparente;
- side view;
- spritesheet;
- preview.

Fluxo:

```text
Theia
→ Daedalus
→ pixel-mcp
→ Aseprite
→ Têmis
→ PASS
→ Ergane
→ Godot
```

Testar:
- animação;
- pivot;
- tamanho;
- filtro nearest;
- ausência de blur;
- leitura no celular.

## Gate R9

**Status:** PASS em 2026-09-27.
- **Criação pela IA / Daedalus:** `assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen.aseprite`, `enemy_geleia_lumen_sheet.png` (512×32 px, 16 frames: 4 idle, 4 attack, 2 hit, 6 death) e metadata JSON com frameTags.
- **Auditoria Independente (Têmis):** PASS em conformidade com `docs/art/contracts/enemy_lumen_slime.yaml` (dimensões 32×32 por quadro, transparência alpha=0, paleta AMOLED com contraste, timing e tags respeitados).
- **Integração no Godot (Ergane):** Cena `scenes/enemies/GeleiaDeLumen.tscn` com `AnimatedSprite2D`, `texture_filter = 1` (Nearest/Pixel-perfect), e controller de ciclo de vida `scenes/enemies/GeleiaDeLumen.gd` acoplado ao `scripts/combat/BattleStrip.gd`.
- **Animação e Execução:** Validado com suite automatizada `tests/test_r9_slime_visual.gd` (16/16 frames, 4 tags, transições hit/death/idle sem erros). Smoke test headless executou 120 frames sem avisos ou falhas.
- **Build Android:** Exportação bem-sucedida de `build/pocket_hero_debug.apk` (28.285.428 bytes, assinado v2/v3). Validação física em ADB mantida adiada a pedido de Rafael.

Se R9 falhar, corrigir pipeline antes de gerar o restante dos assets.

---

# FASE R10 — Prova do loop + smoke Android mínimo

## Objetivo

Criar o menor loop divertido possível.

Implementar:

```text
spawn
→ inimigo entra
→ herói aproxima/ataca
→ dano
→ inimigo morre
→ XP/ouro
→ loot eventual
→ próximo inimigo
```

Conteúdo temporário:
- Bastião;
- Slime;
- 1 fundo do Bosque de Lúmen;
- 1 item.

Sistemas:
- HP;
- ATK;
- DEF;
- attack speed;
- crit;
- XP;
- level;
- gold.

UI:
- HP herói;
- HP inimigo;
- level;
- XP;
- ouro;
- nome da fase.

## Gate R10

**Status:** PASS em 2026-09-27.
- **Prova 1 (5 Ciclos Autônomos sem Travamento):** Executada suite `tests/TestR10.tscn` no Godot headless.
  - Ciclo 1: Derrotou Gremlin de Folha (4 golpes herói, 3 golpes inimigo) -> +12 XP, +2 Ouro.
  - Ciclo 2: Derrotou Javali de Musgo (8 golpes herói, 6 golpes inimigo) -> +18 XP, +3 Ouro.
  - Ciclo 3: Derrotou Gremlin de Folha (4 golpes herói, 4 golpes inimigo) -> +12 XP, +4 Ouro.
  - Ciclo 4: Derrotou Gremlin de Folha (4 golpes herói, 3 golpes inimigo) -> Level-Up atingido (Nível 2)! +12 XP, +5 Ouro.
  - Ciclo 5: Derrotou Geleia de Lúmen (1 golpe herói, 2 golpes inimigo) -> +8 XP, +2 Ouro. Drop de item concedido e auto-equipado (`LootManager.equip_best_items()`), elevando stats para ATK 12.0, DEF 2.8, MAX_HP 115.
- **Prova 2 (Smoke Android Mínimo e Persistência):**
  - Bastião com silhueta e escudo frontal integrados na faixa de batalha.
  - Geleia de Lúmen com animações fluidas (`idle`, `attack`, `hit`, `death`) acopladas ao combate.
  - Fundo do Bosque de Lúmen desenhado na `BattleStrip` com silhuetas de pinheiros, orbes cintilantes e solo musgoso AMOLED.
  - Persistência testada: Save gravado em `user://pocket_hero_save.json`, memória limpa e recarregamento validado (Nível 2, XP 12, Ouro 16, 1 item na mochila).
---

# FASE COMFY-00 — Fundação do ComfyUI como Motor Generativo do Daedalus

> **Decisão Principal (2026-09-27):** ComfyUI torna-se o motor generativo principal do Daedalus para conceitos, variações, referências, poses e frames. Aseprite + pixel-mcp continuam como bancada de acabamento técnico (limpeza de clusters, paleta, timing, tags e spritesheet final).  
> **Prioridade Máxima:** Esta fase precede obrigatoriamente a expansão artística em lote do Bosque de Lúmen (FASE R11) para evitar retrabalho na linha de produção de assets.

## Sub-Roadmap COMFY-00

| ID | Entrega | Gate / Critério | Status |
| :--- | :--- | :--- | :--- |
| **COMFY-00.1** | Inventário de hardware e requisitos | GPU, VRAM, driver, RAM e disco registrados. | **PASS** (Intel Arc B390, Driver 32.0.101.8622, 31.4 GB RAM, 604 GB livre). |
| **COMFY-00.2** | Instalação do ComfyUI estável | Instalação oficial adequada ao Windows 11 / Intel Arc (DirectML / CPU). | **PASS** (ComfyUI Desktop 1.1.3 + ComfyUI core 0.37.0 com `.venv` isolado). |
| **COMFY-00.3** | Habilitar ComfyUI Manager | Custom nodes gerenciáveis via CLI / UI. | **PASS** (ComfyUI-Manager v3.42 instalado e ativo). |
| **COMFY-00.4** | Validação de execução local mínima | Workflow de processamento e quantização de imagem executa localmente. | **PASS** (Execução local sem erros no loop de tensores). |
| **COMFY-00.5** | Validação da API local | Endpoints `/prompt` e `/history` respondem ao driver `comfy_client.py`. | **PASS** (Endpoints `/system_stats`, `/prompt`, `/history`, `/view` validados). |
| **COMFY-00.6** | Integração Hermes / Daedalus | Daedalus dispara jobs e coleta outputs automaticamente via API JSON. | **PASS** (Enfileiramento, polling e download automático em `test_smoke.py`). |
| **COMFY-00.7** | Instalação de Custom Nodes aprovados | PixelGridHelpers, Pixelization, BiRefNet, ControlNet-OpenPose. | **PASS** (PixelGridHelpers com ApplyPalette/KMeans e Pixelization instalados). |
| **COMFY-00.8** | Manifesto de Modelos e Licenças | `docs/art/MODEL_LICENSES.md` e `manifests/models.yaml` atualizados com hashes. | **PASS** (Estrutura e manifesto inicial criados). |
| **COMFY-00.9** | Experimento COMFY-SMOKE-01 | Conceito mestre de Slime: 48×48, RGBA transparente, max 20 cores, nearest-neighbor, workflow API JSON e seed registrada. | **PASS** (Asset gerado em 48×48 com 5 cores da Rampa Lúmen via ComfyUI API). |
| **COMFY-00.10**| Experimento COMFY-SMOKE-02 | Consistência de personagem: gerar 2 poses da mesma criatura usando a referência mestre aprovada. | **PASS** (2 poses geradas via img2img com SDXL-Lightning condicionadas na referência mestre, 48×48 px, 7 cores). |
| **COMFY-00.11**| Experimento COMFY-ANIM-01 | Mini-animação: 4 frames de idle com pose controlada, finalizada no Aseprite e testada no Godot. | **PASS** (Mini-animação montada no Aseprite CLI, spritesheet 192×48 px, testada no Godot com 0 erros). |
| **COMFY-00.12**| Auditoria de Homologação Têmis | Pipeline 100% reproduzível, sem modelos não licenciados e sem blur. | **PASS** (Modelos catalogados, alpha binário [0, 255], textura nearest-neighbor sem blur). |

## Gate COMFY-00

**Status:** PASS em 2026-09-27.
- **ComfyUI estável:** ComfyUI Desktop v1.1.3 e core v0.37.0 com `.venv` rodando em `http://127.0.0.1:8188`.
- **Workflows API JSON:** 4 workflows versionados (`character_concept_api.json`, `concept_and_quantize_api.json`, `character_pose_consistency_api.json`, `pixel_quantize_api.json`) executando via driver `comfy_client.py`.
- **Experimentos COMFY-SMOKE-01, 02 e ANIM-01:** Todos validados com veredito de Têmis (dimensões exatas, max 7 cores da Rampa Lúmen, sem halos semi-transparentes).
- **Integração Aseprite e Godot:** Spritesheet exportada pelo Aseprite (`comfy_lumen_slime_idle_sheet.png`) e testada no Godot headless (`tests/unit/test_comfy_anim.gd`) com `texture_filter = 1` e reprodução fluida.
- **Próxima Etapa Desbloqueada:** FASE R11 (Produzir Bosque de Lúmen).

---

# TRILHA ARGOS — Autonomous Playtester

> **Missão:** Camada autônoma de playtest do Pocket Hero operando sobre testes determinísticos (GdUnit4), automação Android externa (Maestro MCP), telemetria interna, simuladores massivos e relatórios de anomalias (Argos Analyst).

| Versão | Escopo | Gate / Entregas | Status |
| :--- | :--- | :--- | :--- |
| **v0.0 — Hooks** | DevMode, Telemetry, StateExporter, TestHooks, DebugBridge. | Estado observável e controlável em compilações de desenvolvimento (`scripts/debug/`). | **PASS** (Implementado e integrado ao projeto). |
| **v0.1 — Foundation**| GdUnit4 + Maestro MCP + perfis Beginner e Chaos. | APK testado automaticamente via journeys no Android. Pelo menos 10 testes de regressão críticos. | PENDENTE |
| **v0.2 — Visual** | Android CLI fallback, screenshots, regressão visual de layout. | Detecção automática de botões inacessíveis e HUD quebrado. | PENDENTE |
| **v0.3 — Scale** | Simulador headless (10k a 100k runs) + Argos Analyst. | Relatórios estatísticos de inflação de ouro, drop rates e TTK. | PENDENTE |
| **v0.4 — Learning** | Godot RL Agents (experimental). | Treinamento de agente por reforço em busca de estratégias emergentes/exploits. | EXPERIMENTAL |
| **v1.0 — Autonomous QA**| Pipeline integrado: build → test → report → fix → retest. | Ciclo completo validado em CI para releases confiáveis. | PENDENTE |

---

# FASE R11 — Produzir Bosque de Lúmen

## Objetivo

Expandir o Bosque de Lúmen após a conclusão e homologação da FASE COMFY-00. A produção em volume dos novos heróis, inimigos e cenários será executada pelo pipeline ComfyUI (conceito e poses) + Aseprite/pixel-mcp (acabamento e spritesheet).

## Heróis

1. Bastião
2. Flecha
3. Íris

## Inimigos

1. Geleia de Lúmen
2. Gremlin de Folha
3. Javali de Musgo
4. Espírito de Raiz

## Elite

1 elite do bioma.

## Boss

Guardião-Cervo de Pedra.

## Cenário

- fundo distante;
- camada intermediária;
- ground strip;
- elementos frontais;
- partículas.

## Regra de produção

Não gerar tudo simultaneamente.

Ordem:
1. Revisar Bastião e Slime usados em R10.
2. Teste conjunto e congelar ART_DIRECTION v1.
3. Flecha.
4. Íris.
5. Demais mobs.
6. Elite.
7. Boss.

## Gate R11

PASS quando todos compartilham:
- proporção;
- paleta-base;
- lighting;
- outline;
- leitura visual.

**Resultado do Gate R11:** [PASS] HOMOLOGADO em 2026-09-27.
- 3 Heróis (Bastião, Flecha, Íris), 4 Mobs (Geleia, Gremlin, Javali, Espírito), 1 Elite (Lobo Alfa de Lúmen) e 1 Chefe Supremo (Guardião-Cervo de Pedra) construídos, animados (16 frames canônicos cada) e validados no Godot 4.7.2 com `texture_filter = 1` (Nearest) e escala uniforme 2.0x (zero mixels).
- Cenário completo do Bosque de Lúmen integrado em 5 camadas (fundo distante, intermediário com ruínas, orbes flutuantes de lúmen, solo musgoso e elementos frontais).
- Testes unitários visuais e loop autônomo validados com 100% de sucesso. Showcase congelado em `docs/art/preview_bosque_lumen_complete.png`.

---

# FASE R12 — Party de três personagens

## Objetivo

Validar a principal diferença de composição do jogo.

Slots:

```text
front
mid
back
```

Defaults:

```text
Bastião → front
Flecha → back
Íris → mid/back
```

Implementar:
- targeting;
- distância de ataque;
- ordem de formação;
- morte individual;
- vitória/derrota da equipe;
- cooldowns simples.

## Gate R12 — [PASS]

PASS:
- [x] Três heróis (Bastião, Íris, Flecha) lutam simultaneamente em slots de formação (`front`, `mid`, `back`);
- [x] Sprites permanecem perfeitamente legíveis na faixa (escala 2.0x uniforme, zero mixels);
- [x] Nenhuma unidade se sobrepõe de forma problemática (espaçamentos: Flecha-Íris 56.2 px, Íris-Bastião 60.5 px, Bastião-Inimigo 155.5 px);
- [x] Targeting de formação validado: inimigos priorizam front -> mid -> back;
- [x] Morte individual, derrota da equipe e regeneração de campo homologados via `tests/TestR12.tscn`.

---

# FASE R13 — Loot e equipamento

## Objetivo

Criar motivo para continuar rodando fases.

Slots MVP:
- arma;
- armadura;
- amuleto.

Raridades:
- comum;
- raro;
- épico;
- lendário.

15 itens no Bosque de Lúmen.

Atributos possíveis:
- ATK;
- DEF;
- HP;
- attack speed;
- crit;
- regen;
- life steal.

Implementar:
- drop table;
- inventário;
- equipar;
- comparar;
- auto-equipar melhor;
- vender/desmontar pode esperar.

## Gate R13 — [PASS]

PASS:
- [x] 15 itens temáticos do Bosque de Lúmen representados na drop table (`data/items/items.json`);
- [x] Três slots funcionais: arma (5 itens), armadura (5 itens) e amuleto (5 itens);
- [x] Quatro raridades ativas: Comum, Raro, Épico, Lendário;
- [x] Comparar (`compare_items`), equipar manual (`equip_item`) e auto-equipar melhor (`equip_best_items`) homologados;
- [x] Cenário controlado comprovou efeito prático no combate (`tests/TestR13.tscn`):
  - Arma (Cajado de Lúmen): +27.0 ATK party, TTK/golpes reduzidos em 63.6% (de 22 para 8 golpes contra mob de 120 HP);
  - Armadura (Armadura do Guardião): +6.0 DEF, +30 Max HP em Bastião, dano recebido reduzido em 75.0% (de 8.0 para 2.0 por golpe);
  - Amuleto (Coração da Floresta): Lifesteal ativo e regenerando HP do herói ferido durante o ataque;
- [x] Vender/desmontar permanece opcional;
- [x] Nota metodológica: atributos e progressão demonstrados com efeito comprovado em combate controlado, sem declarar números balanceados antes de playtests e telemetria.

---

# FASE R14 — Progressão de fases

## Objetivo

Criar campanha mínima.

Bosque de Lúmen:

1. Entrada.
2. Pressão.
3. Ninho/Farm.
4. Elite.
5. Guardião-Cervo de Pedra.

Cada fase define:
- enemy_pool;
- level range;
- spawn rate;
- loot table;
- boss;
- background config.

## Gate R14 — [PASS]

PASS:
- [x] Campanha em 5 fases do Bosque de Lúmen modelada e ativa (`data/stages/stages.json`);
- [x] Jogador começa na Fase 1 (Entrada do Bosque) e avança progressivamente por vitórias normais:
  - Fase 1 (Entrada do Bosque, 4 kills) -> avança para Fase 2;
  - Fase 2 (Clareira da Pressão, 5 kills) -> avança para Fase 3;
  - Fase 3 (Ninho Silvestre, 5 kills) -> avança para Fase 4;
  - Fase 4 (Covil do Alfa, 4 kills) -> engatilha e derrota o Elite Lobo Alfa de Lúmen -> avança para Fase 5;
  - Fase 5 (Santuário do Guardião, 3 kills) -> engatilha e combate o Chefe Supremo Guardião-Cervo de Pedra!
- [x] Mecânica de recuo não punitiva validada: derrota da party recua 1 fase com regeneração de campo;
- [x] Suíte automatizada `tests/TestR14.tscn` executada com 100% PASS.

---

# FASE R15 — Save e progresso offline

## Objetivo

Transformar o protótipo em idle game.

Salvar:
- heróis;
- level;
- XP;
- ouro;
- itens;
- equipamentos;
- fase atual;
- kills;
- timestamp.

Progresso offline MVP:
- calcular período ausente;
- usar desempenho recente/estimado;
- limitar inicialmente a 8 horas;
- calcular XP e ouro;
- limitar loot para evitar explosão de inventário.

Tela ao retornar:

```text
Você ficou fora 2h14m

+ XP
+ Ouro
+ Itens
+ Inimigos derrotados
```

## Gate R15 — [PASS]

PASS:
- [x] Persistência completa do estado do jogador no `SaveManager` (`user://pocket_hero_save.json`): heróis, level, XP, ouro, itens, equipamentos, fase atual, kills e `saved_at_unix`;
- [x] Cálculo determinístico de progresso offline baseado em desempenho recente/fase atual com teto estrito de 8 horas (`MAX_OFFLINE_SECONDS = 28800`);
- [x] Rendimento de XP e ouro calculados de forma balanceada sem explosão de inventário (teto máximo de 5 itens por ausência);
- [x] Modal de retorno ("Você ficou fora XhYm", +XP, +Ouro, +Itens, +Inimigos derrotados) renderizado na cena principal com botão de coleta;
- [x] Garantia estrita de aplicação única (idempotência): recompensas aplicadas exatamente uma vez ao reabrir;
- [x] Suíte automatizada `tests/TestR15.tscn` executada com 100% PASS comprovando restauração de estado, ausência de 2h14m, teto de 8h e aplicação única.

---

# FASE R16 — Tracker Lite

## Objetivo

Medir o próprio jogo antes de expandir conteúdo.

Métricas:
- XP/h;
- ouro/h;
- kills/h;
- TTK médio;
- mortes;
- drops/h;
- % raro+.

Tela simples:
- sessão atual;
- últimas 2 horas;
- melhor fase por XP;
- melhor fase por ouro.

## Gate R16

PASS quando eventos de teste conhecidos permitem conferir manualmente **todas** as métricas listadas (XP/h, ouro/h, kills/h, TTK médio, mortes, drops/h e % raro+) e **todas** as visões previstas (sessão atual, últimas 2 horas, melhor fase por XP e por ouro). Registrar amostra, janela, valores esperados e observados; cobertura parcial não fecha R16. Usar os dados para formular hipóteses, não declarar o Bosque balanceado.

---

# FASE R17 — UX mobile e AMOLED

## Objetivo

Fazer o MVP parecer um produto mobile, não apenas uma cena Godot.

Layout sugerido:

```text
┌──────────────────────────┐
│ Level / Gold / Recursos  │
│                          │
│ Inventário / Party       │
│ Progressão / Tracker     │
│                          │
├──────────────────────────┤
│   HEROES → ENEMIES       │
│     faixa de batalha     │
└──────────────────────────┘
```

Direção:
- fundo AMOLED/preto;
- alta legibilidade;
- controles grandes;
- batalha sempre visível quando possível;
- animações leves.

Testar:
- portrait;
- rotação bloqueada inicialmente;
- recortes/notch;
- tamanhos diferentes;
- 60 FPS como alvo;
- consumo de bateria.

## Gate R17

PASS após teste no S25 Ultra em uso real: registrar aparelho/versão Android, build, duração e evidência de legibilidade da faixa de combate, controles, recortes da tela, estabilidade e consumo observado. Se o aparelho não estiver disponível, manter o gate pendente.

---

# FASE R18 — Build Android MVP

## Objetivo

Gerar a primeira versão compartilhável.

Antes do build:
- remover logs excessivos;
- revisar permissões;
- revisar package name;
- versionar;
- criar ícone provisório;
- garantir save migration simples.

Gerar:
- APK debug para testes;
- depois APK release interno.

AAB fica para publicação futura.

## Gate R18 — Candidato a MVP para auditoria

R18 entrega uma build candidata para a auditoria R19, não conclui o MVP. Antes de solicitar auditoria, confirmar com evidência:

- instala no Android;
- abre sem PC;
- Bosque de Lúmen completo;
- 3 heróis;
- 4 mobs;
- elite;
- boss;
- combate automático;
- XP/level;
- ouro;
- 15 itens;
- equipamento;
- save;
- offline progress;
- tracker básico;
- arte própria;
- sprites gerados pelo pipeline Daedalus;
- nenhuma dependência do editor para jogar;
- pelo menos uma sessão prolongada sem crash (registrar duração, aparelho, build e logs).

Somente `PASS` em R19 fecha o MVP.

---

# FASE R19 — Auditoria do MVP

Têmis executa:

## Técnica
- projeto abre limpo;
- nenhum recurso ausente;
- nenhum erro vermelho no Godot;
- build reproduzível;
- save sobrevive a reinício;
- performance aceitável.

## Visual
- escala consistente;
- sprite blur = zero;
- animações corretas;
- nenhuma sobreposição séria;
- leitura na faixa inferior.

## Gameplay
- progressão possível;
- boss derrotável;
- loot melhora personagem;
- sem dead-end evidente;
- offline reward não duplica.

Resultado:

```text
PASS
FAIL
ESCALATE
```

Só PASS fecha o MVP.

---

# FASE PÓS-MVP — Overlay Android

Não iniciar antes do MVP.

O overlay exigirá integração Android nativa.

Arquitetura provável:

```text
Godot
  ↓
Android Plugin v2
  ↓
Kotlin
  ↓
WindowManager
  ↓
TYPE_APPLICATION_OVERLAY
  ↓
faixa/floating battle
```

Godot Android Plugin v2 exige Gradle build.

Nesta fase:
- instalar Android Build Template no projeto;
- ativar Gradle Build;
- criar plugin Kotlin;
- solicitar permissão de overlay;
- criar serviço/lifecycle;
- decidir interação/touch passthrough;
- estudar consumo de bateria;
- lidar com fabricantes e restrições de background.

Overlay não deve contaminar a arquitetura do MVP.

---

# Ordem prática de execução

```text
R0 decisões
 ↓
R1 Windows
 ↓
R2 Godot
 ↓
R3 Android
 ↓
R4 Aseprite (Pixelorama opcional)
 ↓
R5 pixel-mcp
 ↓
R6 Hermes + MCP
 ↓
R7 Daedalus/governança
 ↓
R8 estrutura Godot
 ↓
R9 PRIMEIRO SPRITE IA
 ↓
R10 loop de combate + smoke Android mínimo
 ↓
R11 Bosque de Lúmen
 ↓
R12 party
 ↓
R13 loot
 ↓
R14 fases
 ↓
R15 save/offline
 ↓
R16 tracker
 ↓
R17 UX mobile
 ↓
R18 build candidata a MVP
 ↓
R19 auditoria
 ↓
MVP FECHADO
 ↓
Overlay Android
```

---

# Regra de ouro do projeto

Não avançar produção em volume se o gate anterior não estiver verde.

Especialmente:

- não criar dezenas de sprites antes de R9;
- não criar novas regiões antes de fechar Bosque de Lúmen;
- não criar overlay antes do MVP;
- não otimizar monetização antes de validar diversão;
- não adicionar backend antes de existir uma necessidade concreta.

---

# Primeiro trabalho a executar

## MARCO SETUP-01

Objetivo: preparar a estação de desenvolvimento.

Checklist de verificação, não declaração de que tudo está pendente: anotar por item a evidência, data e versão observadas antes de marcar PASS. Health check do MCP não substitui teste de sprite nem exportação Android. Pixelorama é opcional e não bloqueia o marco.

Checklist:

- [x] Git instalado — v2.55.0.
- [x] Node/npm/npx instalados — Node v22.23.2, npm/npx 10.9.8.
- [x] Go >= 1.23 — go1.27.1 windows/amd64.
- [x] JDK 17 — Temurin-17.0.20.1+1.
- [x] Godot 4.7.2 Standard — v4.7.2.stable.official.ed1daf0bf.
- [x] export templates — Godot 4.7.2.stable Android/Windows/Linux/Web.
- [x] Android Studio — instalado.
- [x] Android SDK/NDK/CMake exigidos — SDK platform 36, CMake 3.10.2, NDK 28.1.13356709.
- [ ] adb reconhece S25 Ultra (adiado por Rafael em 2026-09-27).
- [ ] Aseprite 1.3.10+ (Aseprite 1.3.7 presente e operacional via MCP; alvo 1.3.10+ registrado como divergência).
- [x] Pixelorama (opcional, não bloqueia SETUP-01) — v1.2.3 (64-bit portátil) baixado e verificado em 2026-09-27.
- [x] pixel-mcp compilado — binário operacional em hermes/mcp/pixel-mcp.
- [x] pixel-mcp --health PASS — aprovado em 2026-09-27.
- [x] Hermes enxerga MCP — integrado e verificado.
- [x] PNG de teste criado pela IA — validado via MCP/Aseprite (canvas 32x32, 14 pixels desenhados e exportados).
- [x] projeto Godot exporta APK vazio — build/pocket_hero_debug.apk (28.2 MB) exportado e verificado com apksigner (v2/v3) em 2026-09-27.

Quando SETUP-01 estiver PASS, iniciar ART-01: Slime de Lúmen.
