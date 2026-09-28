# Auditoria de instalação e prontidão — pipeline de sprites

**Data:** 2026-09-28  
**Resultado geral:** `SPRITE PIPELINE = PARTIAL`  
**Escopo desta etapa:** preparar recursos fora do ComfyUI, conforme pedido de Rafael. ComfyUI, seus nodes, modelos, processos e workflows foram deixados para depois; os dados dessa seção são o retrato da auditoria anterior, não uma nova intervenção.

## Hardware e sistema

- Windows 11 Pro, build 26200.
- CPU: Intel Core Ultra X7 358H, 16 núcleos / 16 processadores lógicos.
- GPU: Intel Arc B390; driver 32.0.101.8622. O campo WMI `AdapterRAM` reporta aproximadamente 2 GiB; por ser GPU integrada, esse número não representa toda a memória compartilhada disponível.
- RAM: 31,37 GiB; na última captura fora do ComfyUI havia 14,18 GiB livres.
- Disco: Samsung MZVL81T0HFLB-00B, 953,9 GB; volume C: 919 GB, com 602,3 GB livres.
- A execução consultada do ComfyUI estava configurada com `--cpu`, PyTorch `2.14.0+cpu`; não foi validado backend Intel XPU.

## Componentes

| Componente | Caminho / versão observada | Configurado? | Teste e status |
|---|---|---:|---|
| ComfyUI | `C:\Users\notefael\AppData\Local\Comfy-Desktop\ComfyUI`; 0.37.0; Python 3.13.14; venv local; API `127.0.0.1:8188`; argumentos `main.py --listen 127.0.0.1 --port 8188 --cpu` | Sim | `PARTIAL — DEFERRED`. Um smoke test de nodes em imagem-fixture chegou a PNG 64×64 com paleta limitada e alpha binário. A geração por prompt em 512×512 falhou no KSampler com `[Errno 22] Invalid argument` ao escrever a barra de progresso no logger; não salvou imagem. O pedido posterior de Rafael é deixar o ComfyUI para depois. |
| ComfyUI-Manager | Presente em `...\ComfyUI\custom_nodes\ComfyUI-Manager` | Sim | `PARTIAL`. Não foi instalado nem atualizado nesta preparação; versão/commit não ficaram registrados aqui. O traceback da geração atravessou o wrapper de stderr do Manager e o logger do ComfyUI. |
| Aseprite | `C:\Users\notefael\projetos\taskbarhero\Aseprite\Aseprite.exe`; 1.3.7 | Sim | `PARTIAL`. O MCP conseguiu exportar PNG/JSON em scratch. Uma tentativa batch anterior de converter PNG para `.aseprite` não criou o arquivo esperado. O roadmap do projeto registra alvo 1.3.10+; nenhuma atualização foi feita. |
| Pixelorama | `C:\Users\notefael\projetos\taskbarhero\Pixelorama\Pixelorama.exe`; 1.2.3 (metadados do executável) | Sim | `NOT REQUIRED` para o caminho mínimo, que já usa Aseprite; a GUI do Pixelorama não foi usada neste teste. |
| Godot | `C:\Users\notefael\projetos\taskbarhero\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe`; 4.7.2 | Sim | `PASS` em projeto scratch: importou PNG 192×64 e montou `AnimatedSprite2D` com três regiões 64×64, 6 FPS e filtro nearest. Isso prova a fixture, não a cena real do Bastião nem o pipeline completo. |
| Pixel-mcp | `C:\Users\notefael\AppData\Local\hermes\mcp\pixel-mcp\pixel-mcp.exe` | Sim | `PARTIAL`. O binário já existia; foi registrado no perfil Hermes `builder`, sampling desabilitado e backup criado. Testes anteriores do Hermes MCP e exportação em scratch passaram. A versão do binário não está confirmada neste relatório. |
| Hermes MCP | Configuração do perfil `builder` em `...\profiles\builder\config.yaml` | Sim | `PASS` para descoberta/teste anterior do servidor e exportação de fixture; não equivale ao end-to-end de produção. Nenhum conteúdo confidencial foi copiado para este relatório. |
| Python geral | Python 3.14.7, ambiente gerenciado pelo Hermes | Sim | `PASS` como ferramenta disponível. O ComfyUI usa o venv separado listado acima; não instalar requirements no Python geral. |
| Git | 2.53.0.windows.3 | Sim | `PASS` como ferramenta disponível. Branch do projeto: `main`, HEAD `9d9f7792f578d7a87bca6f1dbdd297f004434416`. |
| GitHub CLI | 2.101.0 | Sim | Encontrado. Não necessário para os testes do pipeline. |
| Go | 1.27.1 windows/amd64 | Sim | Encontrado. Não necessário para o snapper já compilado. |
| Node.js / npm | Node v26.7.0; npm no ambiente Hermes | Sim | Encontrados. Não foi necessário instalar pacotes. |
| Rust / Cargo | Não encontrados no `PATH` | Não | `NOT REQUIRED` para a fixture: o SpriteFusion instalado já executou sem compilação local. |
| FFmpeg | n9.0.1-27-g9b0578816c-20260910 | Sim | Encontrado; não necessário nos testes executados. |
| ImageMagick | `magick` não encontrado no `PATH` | Não | `NOT REQUIRED` para o caminho testado. |

## Nodes e modelos — último estado observado antes da pausa do ComfyUI

- **PixelGridHelpers**, incluindo `GridMedianFixer`: `PASS` na fixture. Quantização/limite de paleta, merge de cores, redução e reconstrução do grid foram exercitados; o Median Fixer pertence ao próprio pacote.
- **SpriteFusion Pixel Snapper**: `PASS` na fixture para saída 64×64 e remoção por chroma-key de fundo uniforme. Isso não prova recorte confiável de cabelo, armas ou capas em fundos complexos.
- **Pixelization**: pacote/node encontrado, mas os pesos necessários não estavam disponíveis no caminho verificado; não foi executado nem baixado modelo.
- **IP-Adapter, ControlNet Aux, Advanced ControlNet e RMBG**: não foram instalados ou alterados nesta etapa. O estado funcional de cada integração não é declarado como PASS.
- **PixelArt Detector**: opcional; não foi comparado. Não foi marcado como necessário.
- O checkpoint `sdxl_lightning_4step.safetensors` existia no diretório compartilhado e seu SHA-256 conferia com o registro aprovado: `e0d996ee0013e79d9d3561f50fcafb9a17e3ff07b780358e3b66d67932c4d490`. A tentativa de geração não chegou ao `SaveImage`; não há geração 1024×1024 validada.
- Nenhum node, checkpoint ou outro modelo foi instalado/atualizado nesta etapa.

## Arte, contrato e QA

- `docs/art/PALETTE.md` confirma `TY_HIGH_FANTASY_40`; o uso interno descrito ali é pessoal/privado e não concede licença de redistribuição ou uso comercial.
- O contrato atual de Bastião define canvas **48×48**, subconjuntos `iron` + `gold`, máximo 14 cores e idle com 4 frames a 6 FPS.
- A especificação de preparação solicita sprite final **64×64** e geração inicial **1024×1024**. Isso conflita com o contrato de Bastião; não alterei o contrato nem integrei sprite técnico como arte oficial.
- A folha scratch e os testes de importação não passaram por revisão visual independente nem por validação na cena real do projeto.

## Workflows

- A pasta do projeto contém 12 workflows API existentes, mas `01_CHARACTER_BASE.json` não foi encontrado na auditoria anterior.
- O workflow de conceito de Bastião observado usa 512→48 e paleta legada; não deve ser usado como está para novos assets.
- A criação/alteração dos workflows modulares fica para quando Rafael retomar a etapa do ComfyUI.

## Alterações e preservação

### Configuração do pixel-mcp (feita na etapa anterior desta auditoria)

- **ANTES:** o executável já existia; foi feito backup do `config.yaml` do perfil antes do registro.
- **DEPOIS:** servidor `pixel-mcp` registrado no perfil `builder`; sampling desabilitado.
- **MOTIVO:** habilitar o fluxo Hermes → pixel-mcp → Aseprite sem permitir sampling do servidor.
- **TESTE:** `hermes mcp test pixel-mcp` e exportação de artefatos em scratch passaram na etapa anterior.
- **RESULTADO:** integração utilizável em teste; não prova animação/asset oficial completo.

### Relatórios desta preparação

- **ANTES:** os dois caminhos de relatório foram verificados como inexistentes.
- **DEPOIS:** criados `SPRITE_ENVIRONMENT_PATHS.md` e `SPRITE_INSTALLATION_AUDIT.md`.
- **MOTIVO:** registrar recursos existentes e separar o que foi provado do que ficou adiado.
- **TESTE:** verificação dos caminhos, leitura dos documentos e conferência do status Git após a escrita.
- **RESULTADO:** só estes dois relatórios foram adicionados por esta etapa; não houve edição de assets, workflows ou arquivos de configuração do ComfyUI.

Antes da escrita, o repositório já estava em `main` com HEAD `9d9f7792f578d7a87bca6f1dbdd297f004434416`, dezenas de caminhos rastreados modificados/deletados e muitos itens não rastreados; `git diff --stat` registrava 53 arquivos alterados. Após a escrita, os únicos caminhos novos no status são estes dois relatórios; o trabalho preexistente foi preservado, sem revert, limpeza ou commit.

## Fechamento

**PASS** — caminhos e versões consultáveis; PixelGridHelpers/Median Fixer e SpriteFusion em fixture; importação e animação em Godot scratch; integração pixel-mcp em testes anteriores.  
**PARTIAL** — Aseprite batch de PNG→`.aseprite`; Pixelorama não exercitado; alpha foi validado na fixture Comfy, não na cena real do jogo.  
**BLOCKED/DEFERRED** — geração de imagem por ComfyUI, pesos de Pixelization, nós/modelos de pose e background removal para fundos complexos; esses itens ficam suspensos por instrução de Rafael para deixar o ComfyUI para depois.

`SPRITE PIPELINE = PARTIAL` — ainda não foi provado um único fluxo 1024×1024 → Aseprite/pixel-mcp → spritesheet 64×64 → cena real do Godot.

**Próximo passo concreto antes de arte oficial do Bastião:** Rafael confirmar se prevalece o contrato atual de 48×48 ou se o alvo 64×64 requer atualizar formalmente esse contrato. A etapa ComfyUI permanece pausada até nova instrução.
