# Pocket Hero — resumo consolidado do projeto

> Consolidação dos documentos de referência e pipeline recebidos em 2026-09-26. Os DOCX integrais estão preservados em `docs/archive/`; este arquivo destaca as decisões e critérios úteis para execução. Quando houver divergência entre propostas, ela fica explícita em vez de ser tratada como decisão aprovada.

## Identidade e objetivo

**Pocket Hero** (nome de trabalho; repositório `playertwo1/taskbarhero`) é um RPG mobile idle de combate automático, com pixel art dark fantasy e batalha legível em uma faixa compacta. Android é a plataforma inicial. O jogo deve ter identidade própria: referências de gênero podem orientar estruturas e sistemas, nunca copiar arte, sprites, nomes distintivos, interface, textos ou balanceamento de terceiros.

A proposta combina combate automático com decisões do jogador sobre formação, equipamento, progressão e eficiência de farm. O overlay sobre outros apps é uma ideia pós-MVP, não parte da primeira entrega.

## MVP

O primeiro objetivo é provar um jogo completo dentro de um app Android normal:

- **Bosque de Lúmen**, com cinco fases: entrada, pressão, ninho/farm, elite e chefe.
- Três heróis: **Bastião** (proteção), **Flecha** (dano à distância) e **Íris** (magia em área).
- Quatro inimigos comuns, uma elite e o **Guardião-Cervo de Pedra** como chefe.
- Combate automático, XP/nível, ouro, atributos, equipamento, 15 itens iniciais, save local e progresso offline.
- APK debug instalável, legibilidade em tela pequena e uma sessão prolongada sem crash.
- O overlay Android, servidor/contas, multiplayer, monetização, cloud save e produção em muitas regiões ficam fora do MVP.

O MVP só fecha após cumprir seus critérios e passar pela auditoria técnica, visual e de gameplay (roadmap R18–R19).

## Visão de conteúdo posterior

A proposta de longo prazo descreve cinco biomas — Bosque de Lúmen, Distrito Cinzento, Mar de Vidro, Espinha do Inverno e Fortaleza Rubra — mais **Eco Corrompido**, uma camada de endgame com mutações, modificadores e risco/recompensa. A escala deve crescer por famílias de inimigos e variantes, não por assets isolados em massa.

Sistemas candidatos incluem party de até três, papéis de combate distintos, Ecos desbloqueados por marcos, loot com afixos que alteram habilidades, reciclagem/filtro de loot, dificuldades que remixam conteúdo e tracker com XP/h, ouro/h, TTK, mortes, drops e inventário. São propostas para priorização futura, não todas requisitos do MVP.

## Direção e produção de sprites

- Pixel art dark fantasy, vista lateral, silhuetas claras em escala mobile.
- Heróis voltados à direita; inimigos à esquerda; luz principal no alto à esquerda.
- Fundo transparente para entidades, pixel-perfect/nearest-neighbor e outline seletivo.
- Testar canvas de 32×32 contra 48×48 antes de congelar o padrão; paleta comum sugerida de 16–24 cores, com exceções justificadas.
- Derivar variantes de uma silhueta-mãe, preservando a leitura e mudando poucos elementos relevantes.
- Nomear assets com IDs estáveis e versão (`*_v001`); contratos definem dimensões, animações, exportação e QA.

### Pipeline proposto

1. Rafael define o pedido; **Theia** delimita escopo e prioridade.
2. **Daedalus** cria contrato de asset e produz arte com **pixel-mcp + Aseprite**.
3. A saída inclui spritesheet, metadata e preview, seguida de checagens técnicas.
4. **Têmis** (ou auditor independente) avalia contrato e consistência; o executor não aprova o próprio trabalho.
5. Após PASS, **Ergane** integra no Godot e valida cena, animação e comportamento.
6. Validar legibilidade em aparelho real; registrar versão, evidências e manifest.

**Hermes** faz roteamento e handoff; **Research** entra quando faltar informação. **Pixelorama** é ferramenta opcional de revisão manual. O projeto não deve instalar ferramentas, configurar MCPs ou produzir em lote sem a autorização/etapa correspondente.

### Gates sugeridos

- Contrato completo antes da arte.
- Arquivos, dimensões, frames, transparência, nomes e exportações conferidos.
- Revisão visual independente.
- Importação e teste no Godot.
- Validação mobile quando a arte afetar a faixa de combate.

## Próximas etapas conforme os documentos

O roadmap chama o primeiro marco de **SETUP-01**: verificar ferramentas e fluxo Android/Godot; ele permanece pendente no checklist existente. O manual do pipeline recomenda depois provar um único slime animado de ponta a ponta. O documento de referências sugere, em paralelo, um pacote visual maior do Bosque de Lúmen (**ART-C0-LUMEN**).

**Divergência a resolver antes de produzir arte:** escolher entre validar primeiro um único sprite/pipeline e iniciar diretamente o pacote ART-C0-LUMEN. Não tratar nenhuma dessas propostas como aprovação já dada.

## Estado registrado nesta consolidação

- O MCP `pixel-art` v0.5.0 foi instalado e registrado no perfil Hermes `default`; health check do servidor/Aseprite e `hermes mcp test` passaram. A allowlist expõe 29 ferramentas, com `trust: untrusted` e sampling desativado.
- Nenhum sprite foi criado, nenhum código do jogo foi alterado e Godot/Android não foram testados nesta tarefa. O Aseprite local é 1.3.7; o health check passou, mas a geração de arte ainda não foi validada.
- Na conferência local, `main` estava em `67c226f` e alinhada com `origin/main`; `Aseprite/` e `Godot_v4.7.2-stable_win64.exe/` estavam não rastreadas e foram preservadas sem alteração. A presença da pasta Godot não comprova setup funcional.
- Próxima ação recomendada: abrir uma nova sessão Hermes para carregar as ferramentas, fazer um teste isolado de sprite e resolver se o primeiro gate de arte será um slime de prova ou ART-C0-LUMEN.

## Fontes do repositório

- Jogo de referência instalado via Steam: `C:\Program Files (x86)\Steam\steamapps\common\TaskbarHero` — usar para estudar estrutura e sistemas; não copiar assets, arte, nomes ou conteúdo protegido.
- `docs/archive/TBH_Referencias_e_Banco_de_Ideias_Pocket_Hero.docx`
- `docs/archive/Pocket_Hero_Pipeline_IA_Sprites_Hermes.docx`
- `ROADMAP.md`
- `docs/REFERENCIAS_TBH.md` e `docs/PIPELINE_IA_SPRITES.md` são materiais anteriores; consultar os DOCX integrais e esta consolidação para a proposta atual.
