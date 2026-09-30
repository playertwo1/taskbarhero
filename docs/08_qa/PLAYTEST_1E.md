---
id: PLAYTEST_1E
status: DESIGN
certainty: HIPOTESE
---

# Roteiro de playtest do slice (SLICE-1E)

**Status:** roteiro `DESIGN`, ainda não executado. O Argos é simulação determinística e não mede diversão, leitura de tela nem decisão humana. Este roteiro define o que observar, como registrar e como cada resultado volta para os achados de balanceamento. Nenhum número do jogo muda por causa deste arquivo; quem decide é Rafael, depois de ler as anotações.

## 1. O que o playtest precisa responder

| # | Pergunta | Origem | Meta de referência |
| --- | --- | --- | --- |
| P1 | O jogador vence o Guardião-Cervo por volta do nível 10–11, com derrotas e vitórias parciais no caminho? | [v1 · perfil do Capítulo 1](../06_balance/v1/capitulos/CAPITULO_01.md), pacing | nível 9–12; 3–8 tentativas (tolerância `HIPÓTESE`) |
| P2 | Que fração vence o Guardião na primeira tentativa? | [ENCOUNTERS](../04_content/chapters/chapter_01/ENCOUNTERS.md) | 40–60% (meta humana; o Argos só dá referência) |
| P3 | Builds com Íris no Arcano e no Controle parecem mais fracas ou só mais arriscadas? | [BAL-009](BALANCE_FINDINGS.md) | sem meta numérica; comparar escolha e resultado |
| P4 | Lúmen (cura) domina a escolha? | BAL-006 e BAL-009 | uma build sem Lúmen vence sem grind |
| P5 | O Guardião tem folga entre golpes ou parece desgastante demais? | BAL-005 e BAL-008 | percepção do jogador; TTK observado |
| P6 | A Árvore e o Ferreiro são compreendidos e usados? | 1D | o jogador restaura o Ferreiro e usa desmontagem ou reforço sem ajuda |
| P7 | Equipamento ganho gera uma decisão real (usar, reforçar, desmontar)? | gate do SLICE-1 | ao menos uma decisão consciente por sessão |
| P8 | Os textos, botões e painéis são legíveis em celular? | contratos de tela | sem toque errado nem texto cortado |

## 2. Preparação

- **Build:** exporte o APK pelo preset `Android` (`--export-debug`). Atenção: em build de debug, `SliceCampaignScreen` usa **semente determinística** (`1 + XP`) e mostra os botões de desenvolvimento (Sondagem, Voltar ao título). Para medir sorte de loot e de eventos, use uma exportação de release ou registre no relatório que a semente era fixa. Isso é uma limitação conhecida, não corrigida.
- **Aparelho:** de preferência celular real (o S25 Ultra segue pendente de conexão, [setup](../../ROADMAP.md)); senão o emulador Pixel 9 do Android Studio (`tools/android/start_emulator.py`).
- **Save limpo:** apague o save da sessão anterior para começar do nível 1. O arquivo é `user://slice_save.json`; no Android fica na pasta de dados do app (verificar o caminho no aparelho, ele só aparece depois da primeira gravação).
- **Perfil do jogador:** anote se conhece RPGs idle/incrementais. Com 3 a 5 pessoas, misture perfis. O resultado de uma pessoa só não decide nada.
- **Sem dica:** não explique builds, Ferreiro nem Árvore. Só diga o objetivo: "vencer o Guardião-Cervo".

## 3. Sessão

1. Limite de 90 minutos ou até vencer o Guardião, o que vier primeiro.
2. O jogador escolhe a build livremente por herói (18 combinações) e pode usar os presets de atalho.
3. Quem observa fala o mínimo possível e anota. Pedir para "pensar em voz alta" ajuda no P6 e no P8.
4. Ao fim de cada expedição (vitória ou derrota), preencha uma linha da tabela da seção 4.
5. Ao fim da sessão, faça as perguntas da seção 5.

## 4. Registro por tentativa

Copie esta tabela para o relatório da sessão. Uma linha por expedição.

| Tentativa | Nível do trio | Bastião / Flecha / Íris | Chegou até | Venceu? | Mortes | HP da party antes do Guardião | Escolhas (Poço, Reward Choice) | Loot útil? | Equipou / reforçou / desmontou |
| ---: | ---: | --- | --- | --- | ---: | --- | --- | --- | --- |
| 1 | | | | | | | | | |

- **Chegou até:** nome do encontro em que a party caiu, ou "venceu".
- **HP antes do Guardião:** baixo, médio ou cheio, como o jogador percebeu; o valor exato só existe se a telemetria estiver ligada (ver seção 6).
- **Marcos de Fragmentos e Ferreiro:** anote em que expedição o jogador comprou cada nó da Árvore, se restaurou o Ferreiro e se reforçou algum item.

## 5. Perguntas depois da sessão

1. O que você achou mais difícil? Onde perdeu mais?
2. Você trocou de build? Por quê?
3. Alguma build pareceu inútil? Alguma pareceu obrigatória?
4. O Guardião pareceu justo? Deu para ler o que ele ia fazer?
5. Você entendeu para que serve a Árvore dos Ecos? E o Ferreiro?
6. Teve algum momento em que teve que escolher entre usar, guardar ou desmontar um item? Como decidiu?
7. Algum botão ou texto foi difícil de ler ou de tocar no celular?
8. Você voltaria a jogar amanhã? O que faria?

## 6. Dados que a telemetria já entrega

A [SliceTelemetry](../../scripts/combat/SliceTelemetry.gd) só liga com `options["telemetry"] = true` e a campanha do aplicativo **não a liga**. Portanto, hoje, nenhum dado automático sai de uma sessão de celular; o que vale são as anotações e o arquivo de save (nível, XP, itens, Resíduo, Fragmentos, nós comprados, marcos).

- **Sugestão (não feita):** ligar a telemetria em uma exportação de playtest e gravar o resumo localmente, sem rede, conforme a política local-first do [v1 · perfil do Capítulo 1](../06_balance/v1/capitulos/CAPITULO_01.md). Decisão de Rafael.
- **Sem dado no run (pendente):** `cooldown_uptime`, `debuff_uptime`, `stagger_damage`, tempo com Guarda pronta e dano evitado.

## 7. Como o resultado volta para o balanceamento

Nenhuma regra abaixo altera números sozinha. Cada uma produz uma proposta que Rafael aceita ou não.

| Se o playtest mostrar | Registrar como | Proposta a avaliar |
| --- | --- | --- |
| Maioria vence o Guardião antes do nível 9 ou sem derrota | `PACING` em BALANCE_FINDINGS | subir a dificuldade do Guardião; manter os demais valores |
| Maioria precisa de mais de 8 tentativas ou passa do nível 12 | `PACING` | dar mais sobrevivência ao Arcano/Controle antes de mexer no Guardião |
| Todos escolhem Lúmen | `BALANCE` (BAL-006) | mover sobrevivência para Arcano/Controle; só depois pensar em reduzir a cura |
| Jogadores não usam ou não entendem o Ferreiro | `UX` e `BALANCE` de economia | rever custo do Reforço e o texto da Árvore antes de qualquer ajuste de Resíduo |
| Toque errado ou texto cortado em 432×960 | `BUG` de UI | corrigir a tela conforme [SCREEN_CONVENTIONS](../09_ui/SCREEN_CONVENTIONS.md) |
| Muitos abandonam antes de 30 minutos | `PACING` | investigar o começo da rota (encontros 1 a 3) |

## 8. Fechamento

- Um relatório por sessão em `docs/08_qa/playtests/AAAA-MM-DD_<jogador>.md`, com as seções 4 e 5 preenchidas.
- Resumo consolidado atualiza [BALANCE_FINDINGS](BALANCE_FINDINGS.md) (BAL-009) e os checkboxes do gate do [ROADMAP](../../ROADMAP.md). Só marque um checkbox com evidência de pelo menos três sessões.
- Playtest não altera o resultado dos testes automatizados nem os relatórios do Argos: são evidências diferentes e não se substituem.
