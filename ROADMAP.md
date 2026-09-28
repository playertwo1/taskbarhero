# ROADMAP — Pocket Hero

Status atualizado em 2026-09-27
Engine: Godot 4.7.2 Standard · Plataforma inicial: Android

## Estado atual

O MVP do Pocket Hero foi concluído e homologado no gate R19 em 2026-09-27. O histórico das fases concluídas, incluindo evidências e checklists, está em [`arquivados/ROADMAP_CONCLUIDO.md`](arquivados/ROADMAP_CONCLUIDO.md).

## Trabalho em andamento — ART-0 Golden References

Os quatro exemplos visuais do ART-0 foram aprovados por Rafael em 2026-09-27 e estão registrados com hashes em [`docs/art/golden/README.md`](docs/art/golden/README.md). **A produção em massa continua bloqueada** até preparar as folhas completas e passar o QA técnico/visual; os arquivos aprovados são referências visuais, não substituem os assets de release.

- [x] **GOLDEN HERO** — Bastião v002 aprovado visualmente; hash fixado; folha completa/QA pendente.
- [x] **GOLDEN ENEMY** — Geleia 64×64 aprovada visualmente; hash fixado; folha completa/QA pendente.
- [x] **GOLDEN BOSS** — Guardião-Cervo v002 aprovado visualmente; hash fixado; folha completa/QA pendente.
- [x] **GOLDEN ANIMATION** — idle da Geleia, 4 quadros a 160ms, aprovado visualmente; hash fixado; release/QA pendente.

As quatro aprovações visuais já foram registradas. Não marcar o gate de produção como concluído nem abrir lotes até que as folhas completas e o QA técnico/visual passem. Os registros e contratos atuais são as fontes de estado para essa etapa.

## Design em andamento — conteúdo do Capítulo 1

Rafael definiu começar a construir conteúdo além do MVP, iniciando pelo Capítulo 1 no Bosque de Lúmen. A proposta preserva as cinco fases macro e descreve subfases, inimigos/chefes, **15 skills (cinco por herói)** e **30 itens no catálogo total** (15 do MVP + 15 candidatos novos) em [`docs/content/CAPITULO_01_BOSQUE_DE_LUMEN.md`](docs/content/CAPITULO_01_BOSQUE_DE_LUMEN.md).

- [x] Preservar cinco fases macro e ampliar o rascunho para dez subfases; Rafael aprovou a direção macro.
- [x] Completar o catálogo de design com 15 skills (cinco por herói) e 30 itens (15 existentes + 15 novos candidatos).
- [ ] Definir lore final, escolhas/unlocks de skills, efeitos/raridades de itens e detalhes dos encontros de chefes.
- [ ] Definir fórmulas, fontes/saídas de recursos e simulações antes de congelar números.
- [ ] Depois da aprovação de design, planejar schema/dados e um segmento jogável vertical.

Este trabalho é de design. Não libera produção de arte em massa, que continua bloqueada pelo QA de release do ART-0.

## Pendências registradas de setup

Estas pendências permanecem anotadas no marco SETUP-01. Não reabrem a homologação do MVP; revalidar quando houver necessidade de retomar a validação em aparelho físico ou atualizar a ferramenta:

- [ ] **ADB / S25 Ultra** — conexão física foi adiada por Rafael em 2026-09-27. O emulador Android Studio foi usado para homologar R17–R19.
- [ ] **Aseprite 1.3.10+** — consta Aseprite 1.3.7 operacional; o alvo 1.3.10+ do setup ainda não foi atingido.

## Trabalho futuro

### Trilha ARGOS — Autonomous Playtester

Os hooks da v0.0 foram concluídos e estão registrados no arquivo de concluídos. Permanecem planejadas:

| Versão | Escopo | Entrega / gate | Estado |
| --- | --- | --- | --- |
| **v0.1 — Foundation** | GdUnit4, Maestro MCP e perfis Beginner/Chaos. | APK testado por jornadas Android; pelo menos 10 regressões críticas. | PENDENTE |
| **v0.2 — Visual** | Fallback CLI Android, screenshots e regressão visual. | Detectar botões inacessíveis e HUD quebrado. | PENDENTE |
| **v0.3 — Scale** | Simulador headless (10k–100k execuções) e Argos Analyst. | Relatórios de inflação de ouro, drops e TTK. | PENDENTE |
| **v0.4 — Learning** | Godot RL Agents. | Experimento de estratégias emergentes/exploits. | EXPERIMENTAL |
| **v1.0 — Autonomous QA** | Pipeline integrado build → test → report → fix → retest. | Ciclo validado em CI para releases. | PENDENTE |

### FASE PÓS-MVP — Overlay Android

O overlay é trabalho futuro, fora do MVP concluído. Começar apenas quando priorizado. A integração provável usa Godot Android Plugin v2, Kotlin e `WindowManager` com `TYPE_APPLICATION_OVERLAY`.

Escopo previsto:

- instalar Android Build Template e ativar Gradle Build;
- criar plugin Kotlin e serviço/lifecycle;
- solicitar permissão de overlay e decidir interação/touch passthrough;
- estudar consumo de bateria e restrições de background por fabricante.

O overlay deve permanecer separado da arquitetura central do MVP até essa fase ser priorizada.

## Ordem e limites

1. Concluir ART-0 antes de iniciar produção em massa de arte.
2. Priorizar as próximas entregas entre ARGOS e Overlay quando houver decisão de produto.
3. Não adicionar backend, contas, multiplayer, cloud save, monetização ou conteúdo extenso sem necessidade concreta e priorização explícita.

Para economia e pacing, registrar hipótese, fórmula, fontes e saídas de recursos e método de medição. Tratar números como hipóteses até playtest/telemetria. Preservar a identidade original do Pocket Hero.

## Referências

- [Documentos do projeto](documents/INDEX.md)
- [Resumo consolidado](docs/POCKET_HERO_PROJECT_BRIEF.md)
- [Golden References e ART-0](docs/art/golden/README.md)
- [Inventário de sprites do MVP](docs/art/MVP_SPRITE_INVENTORY.md)
- [Histórico das fases concluídas](arquivados/ROADMAP_CONCLUIDO.md)
