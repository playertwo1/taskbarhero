---
document_type: repository-structure
id: ESTRUTURA_DO_REPOSITORIO
status: APPROVED
last_reviewed: 2026-09-30
language: pt-BR
---

# Estrutura do repositório

**Autoridade sobre onde cada coisa mora e onde criar arquivos novos.** Vale para qualquer agente (Claude, ChatGPT, Antigravity/Gemini) e para Rafael. Reorganizada em 2026-09-30 por decisão de Rafael; as mudanças estão no [CHANGELOG](../../CHANGELOG.md).

## 1. Mapa

```text
taskbarhero/
├── README.md            entrada humana: o que é o jogo, como rodar, onde ler
├── AGENTS.md            regras para agentes (curto; aponta para cá)
├── PROJECT_STATE.md     painel: onde está cada fonte de verdade
├── ROADMAP.md           estado, trabalho atual, próximo, futuro, gates
├── CHANGELOG.md         mudanças estruturais datadas
├── project.godot · export_presets.cfg · icon.png · jogar.bat   projeto Godot
│
├── data/                valores que o jogo carrega (JSON) — autoridade de runtime
├── scenes/              cenas Godot (.tscn) e scripts presos a elas
├── scripts/             só GDScript do jogo: combat/, run/, ui/, debug/
├── assets/              só o que o jogo carrega (sprites, UI, tema)
├── tests/unit/          testes Godot (cada TestX.tscn + test_x.gd)
│
├── tools/               ferramentas de desenvolvimento (Python/CLI), nunca carregadas pelo jogo
│   ├── argos/           playtester automático (simulador, Analyst, perfis, cenários, relatórios)
│   ├── balance/         validador de dados, sondas e checagem de escala
│   ├── content/         exportadores de conteúdo (ex.: textos de eventos)
│   ├── art/             auditorias de sprite (lint, prancha de orientação)
│   ├── android/         emulador e utilitários Android
│   ├── docs/            verificador de links da documentação
│   ├── daedalus/        pipeline ComfyUI e utilitários de pixel art
│   └── run_godot_tests.py · run_one_scene.py · godot_import.py · sprite_lint.py
│
├── docs/                design: por que e como o jogo deve funcionar
│   ├── INDEX.md · CONTENT_REGISTRY.md
│   ├── 00_project/ … 09_ui/   uma pasta por área, cada uma com INDEX.md
│   ├── 06_balance/v1/   balanceamento global v1.0 (autoridade de números)
│   └── art/             arte: guias, contratos, Golden, conceitos, mockups, referências visuais
├── documents/           guias-base (DOCX originais + Markdown) e propostas DOCX futuras
├── arquivados/          histórico: roadmap concluído, planos executados, versões substituídas
│
└── (local, fora do git) build/ · work/ · .godot/ · Aseprite/ · Pixelorama/ · Godot*.exe
```

## 2. Onde criar um arquivo novo

| Vou criar… | Coloque em | Regra |
| --- | --- | --- |
| Valor que o jogo lê | `data/<área>/` | `content_set: "slice"` e campo `source` apontando para o documento de design |
| Regra ou número de balanceamento | `docs/06_balance/v1/<domínio>.md` | um domínio por assunto; valores locais de capítulo em `v1/capitulos/` |
| Ficha de herói, skill, item, inimigo, capítulo | `docs/02_heroes/`, `docs/04_content/<tipo>/` | registre o ID em `docs/CONTENT_REGISTRY.md` |
| Sistema de gameplay | `docs/03_systems/` | uma regra transversal por arquivo |
| Contrato de tela | `docs/09_ui/screens/` + `docs/art/contracts/screens/` | UX e arte separados |
| Conceito, mockup ou referência visual | `docs/art/conceitos/`, `docs/art/mockups/`, `docs/art/referencia/` | nunca em `assets/` |
| Sprite aprovado para o jogo | `assets/sprites/<tipo>/` | só depois de contrato, QA técnico e auditoria |
| Código do jogo | `scripts/<área>/` ou junto da cena em `scenes/` | GDScript apenas |
| Ferramenta, script Python, gerador | `tools/<área>/` | nunca em `scripts/` |
| Teste | `tests/unit/TestX.tscn` + `test_x.gd` | o executor só roda `tests/unit/` |
| Cenário de simulação | `tools/argos/simulator/combat/scenarios/` | hipóteses por `overrides`, nunca editando `/data` |
| Achado de balanceamento | `docs/08_qa/BALANCE_FINDINGS.md` | hipótese + proposta; decisão de Rafael |
| Plano de implementação | `docs/` durante o trabalho; `arquivados/planos_concluidos/` ao terminar | plano não é regra |
| Rascunho, captura, APK, fonte intermediária | `work/` ou `build/` | fora do git |

## 3. Regras de manutenção

- **Um fato → uma fonte.** Índices apontam, não copiam.
- **Concluído vai para `arquivados/`; obsoleto é excluído** (o git guarda o histórico). Nada substituído fica ao lado da fonte vigente.
- Ao mover um arquivo, reaponte os links e rode `python tools/docs/check_links.py --orphans` (0 problema e 0 órfão).
- Todo documento novo precisa de um link de entrada em algum `INDEX.md`.
- Cabeçalho recomendado: metadados (`status`, `last_reviewed`) e uma linha dizendo de que ele é autoridade.

## 4. Verificações rápidas

```text
python tools/docs/check_links.py --orphans      # documentação: links, âncoras, órfãos
python tools/balance/validate_balance_data.py   # dados de balanceamento
python tools/run_godot_tests.py                 # testes Godot
python tools/argos/run.py --scenario slice_quick
```

## 5. Recomendações ainda não executadas

Agendadas para a fatia `NOW-5 · OPUS-ROUND-1` do [ROADMAP](../../ROADMAP.md), **executada somente pelo Claude Opus**. Precisam de tarefa própria porque mexem em código, em muitos links ou em arquivos importados pelo Godot:

| # | Recomendação | Por quê | Cuidado |
| --- | --- | --- | --- |
| R-1 | Unir `docs/art/` e `docs/07_art/` numa só pasta | hoje `07_art` é só um índice que aponta para `art/` | ~700 arquivos com `.import`; reapontar tudo |
| R-2 | Pôr um `.gdignore` em `docs/` e parar de versionar `.import` de imagens de documentação | o Godot importa imagens que o jogo nunca usa: metade dos arquivos de `docs/art` são `.import` e o cache `.godot` cresce | o Argos lê dois JSON de `docs/` por `FileAccess`; testar antes |
| R-3 | Remover cenas de inimigos do MVP que o slice não usa (`SaqueadorDaMata`, `LoboDeSombra`, `XamaDeEsporos`, `SentinelaDeRaizes` e outras) | legado do `1A-CUT` | conferir `ArenaPreview.tscn` e `SliceCampaignScreen.gd`, que ainda carregam cenas de herói/inimigo |
| R-4 | Renomear `documents/` para algo menos parecido com `docs/` (ex.: `docs/00_project/fontes/`) | dois nomes quase iguais confundem agentes | muitos links; fazer junto de R-1 |
| R-5 | Enxugar os relatórios versionados do Argos para só os citados como evidência | hoje 32 relatórios (~2 MB) no git | manter os citados em ROADMAP, BALANCE_FINDINGS e v1 |
