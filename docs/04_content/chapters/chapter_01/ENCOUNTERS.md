---
id: CHAPTER_01_ENCOUNTERS
status: DESIGN
---

# Capítulo 1 — encontros e ritmo

**Status:** `DESIGN`; composição e quantidades são `HIPÓTESE` para simulação, não dados runtime.  
**Fonte única das formações e quantidades:** [encounter_plan.json](encounter_plan.json). O arquivo é uma proposta documental e não é carregado pelo jogo. Nomes, arquétipos, ranks, encounter_cost e loot vêm do [catálogo canônico v0.4](../../../../documents/canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/CHAPTER_01_ENEMIES_CANONICAL.json).

## Princípios de composição

- Cada formação mistura funções quando isso ensina uma prioridade: controller com assassin, heavy com controller, ou suporte com inimigos frágeis.
- Sinergias perigosas ficam em grupos pequenos; telegraphs de ataques pesados não se sobrepõem a investidas de assassinos.
- Adds contam no custo do encontro. Como alvos provisórios de `CONTENT-1`, encontros comuns ficam até 3,25; elite até 5; minichefe até 11,5; boss final até 21,5 pontos de encounter_cost. São limites locais para este capítulo, derivados da composição proposta, não novos valores canônicos globais.
- Encontros de elite e minichefe funcionam como clímax da subfase. Adds ficam limitados e não atacam em simultâneo quando isso obscurece o telegraph principal.
- Todos os 17 registros canônicos aparecem ao menos uma vez ao longo do capítulo; a primeira aparição introduz o comportamento antes de o combinar com outras famílias.
- As quantidades são inimigos que a party derrota ao longo do encontro. Invocações são escalonadas e não simultâneas quando indicado no plano.

## Guardião-Cervo de Pedra — desafio final

**Alvo de balanceamento:** confronto longo e exigente, com counterplay legível. O encontro deve respeitar a referência canônica de 120–210 segundos contra `HERO_REFERENCE`; para uma party de três, o teste de design escala o orçamento de HP pelo tamanho da party e compara com o DPS combinado dos três heróis iniciais. A simulação de ECON-1 estima TTK teórico de cerca de **139 s** com a party inicial nos níveis 1 e 6, sem afirmar taxa de vitória.

Fases e padrões propostos para `SLICE-1`:

1. **100–70% — Guarda do santuário:** golpe de casco telegrafado e varredura frontal alternados; após errar a investida, o Guardião abre uma janela de resposta.
2. **70–35% — Chamado do bosque:** surge uma Geleia de Lúmen. O boss conserva um ataque principal por vez e cria uma pausa clara para lidar com o add ou continuar o dano.
3. **35–0% — Última vigília:** combina investida e varredura com recuperação menor, sem sobrepor duas áreas letais. O Guardião fica vulnerável após a investida longa.

Não usar bloqueio invisível de vida nem golpe inevitável de morte. Dano alto precisa de telegraph e resposta; cura e escudo continuam úteis. Os thresholds e ataques acima são um contrato de design proposto, sujeito ao protótipo e às regras de boss v0.4.

### Critério de dificuldade

Não forçar a derrota do jogador. O alvo inicial para teste humano de primeira tentativa é **40–60% de vitórias**, medido em pelo menos 10 testers ou runs independentes sem explicação das mecânicas. Registrar party, nível, equipamento, skills, duração, causa de derrota, uso de skills defensivas e vitória. Se a taxa ficar fora da faixa, ajustar primeiro telegraphs, recuperação, frequência de adds e dano recebido; ajustar HP só se o TTK também estiver fora da faixa.

Essa taxa é uma hipótese de QA para calibrar “desafiador, mas justo”; a simulação numérica não pode provar a taxa de primeira vitória. O teste só é executável após o boss e as respostas estarem no `SLICE-1`.

## Ferreiro no recorte ECON-1

**Proposta:** demonstrar o Reforço `+1` em itens elegíveis, que concede o `+2%` de status base definido pelo contrato v0.4 e não rola affix. O [modelo ECON-1](../../../06_balance/ECONOMY_MODEL.md) é a autoridade para custo por item; este recorte testa apenas `+1` e não define níveis superiores. A melhoria é opcional e não é requisito para enfrentar ou vencer o Guardião.

O evento opcional pré-boss concede uma quantidade única de Resíduo de Lúmen registrada em [encounter_plan.json](encounter_plan.json). A Geleia Anciã e a Rainha das Geleias também têm drops garantidos no catálogo; o evento e esses encontros cobrem pelo menos um Reforço sem exigir desmontar a única peça útil. Sem o evento, drops aleatórios podem completar o custo; a simulação estima quantos itens podem receber `+1` ao fim do capítulo. Não assumir repetição para farm. Quantidade e custo são hipóteses deste slice, não alterações ao catálogo v0.4 nem valores runtime.

## Validação reproduzível

Execute `python tools/economy/simulate_chapter1_balance.py`. O relatório verifica cobertura do bestiário, limites locais de encounter budget, distribuição de drops de Resíduo/Ouro e TTK teórico de uma party Bastião/Flecha/Íris em níveis 1 e 6. Seeds e número de amostras são argumentos da ferramenta.

**Limite:** a simulação não executa a IA, telegraphs, cura, escudos, comportamento do jogador ou runtime Godot. Use o resultado como filtro de extremos; validar dificuldade de primeira tentativa com playtest instrumentado no `SLICE-1`.
