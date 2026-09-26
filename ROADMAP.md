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

# FASE R4 — Instalar Aseprite e Pixelorama

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

Instalar uma versão estável.

O Pixelorama atual é desenvolvido sobre Godot 4.7.2.

## Gate R4

PASS quando:
- Aseprite abre;
- é possível criar e salvar um PNG transparente;
- Pixelorama abre o mesmo PNG.

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
- Git está limpo após commit;
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

PASS quando o Slime:
- foi criado pela IA;
- passou auditoria;
- entrou no Godot;
- animou;
- apareceu corretamente no S25 Ultra.

Se R9 falhar, corrigir pipeline antes de gerar o restante dos assets.

---

# FASE R10 — Vertical slice de combate

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

PASS quando é possível deixar o jogo rodando por alguns minutos sem interação e o loop continua corretamente.

---

# FASE R11 — Produzir Bosque de Lúmen

## Objetivo

Transformar o vertical slice em conteúdo mínimo real.

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
1. Bastião.
2. Slime.
3. Teste conjunto.
4. Congelar ART_DIRECTION v1.
5. Flecha.
6. Íris.
7. demais mobs.
8. elite.
9. boss.

## Gate R11

PASS quando todos compartilham:
- proporção;
- paleta-base;
- lighting;
- outline;
- leitura visual.

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

## Gate R12

PASS quando:
- três heróis lutam simultaneamente;
- sprites permanecem legíveis na faixa;
- nenhuma unidade se sobrepõe de forma problemática.

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

## Gate R13

PASS quando matar inimigos pode melhorar a força da party de forma perceptível.

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

## Gate R14

PASS quando o jogador começa na fase 1 e chega ao boss seguindo progressão normal.

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

## Gate R15

PASS quando:
- fechar totalmente o app;
- esperar;
- reabrir;
- estado anterior volta corretamente;
- progresso offline é aplicado uma única vez.

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

PASS quando as métricas podem ser usadas para balancear o Bosque de Lúmen.

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

PASS no S25 Ultra em uso real.

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

## Gate R18 — MVP

O MVP está concluído somente quando:

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
- pelo menos uma sessão prolongada sem crash.

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
R4 Aseprite/Pixelorama
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
R10 loop de combate
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
R18 APK MVP
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

Checklist:

- [ ] Git instalado.
- [ ] Node/npm/npx instalados.
- [ ] Go >= 1.23.
- [ ] JDK 17.
- [ ] Godot 4.7.2 Standard.
- [ ] export templates.
- [ ] Android Studio.
- [ ] Android SDK/NDK/CMake exigidos.
- [ ] adb reconhece S25 Ultra.
- [ ] Aseprite 1.3.10+.
- [ ] Pixelorama.
- [ ] pixel-mcp compilado.
- [ ] pixel-mcp --health PASS.
- [ ] Hermes enxerga MCP.
- [ ] PNG de teste criado pela IA.
- [ ] projeto Godot exporta APK vazio.

Quando SETUP-01 estiver PASS, iniciar ART-01: Slime de Lúmen.
