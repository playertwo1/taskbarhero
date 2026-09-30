---
id: UI_S12
status: DESIGN
certainty: HIPOTESE
---

# UI_S12 — Números de item (componente)

**Estado do contrato:** `DESIGN`, aguardando revisão de Rafael. **Implementação:** não existe. Hoje o Inventário e o Ferreiro mostram só nome, raridade e Item Power; nenhum número de bônus aparece para o jogador.

Este contrato não é uma tela nova: define os **componentes de número** que entram em telas existentes — Inventário (S08), Ferreiro (S10), Loadout (S04), Escolha (S06) e Resultado (S07). Convenções comuns: [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md). Contrato de arte: [s12_numeros_de_item.yaml](../../art/contracts/screens/s12_numeros_de_item.yaml). Brief de geração de imagens: [conceitos de UI](../../art/conceitos/ui/README.md).

## Por que existe

A escala de combate 10× (decidida em 2026-09-30, [decisões](../../06_balance/v1/04_ITENS_RARIDADE.md)) só entrega legibilidade se o jogador vir os números. Com os valores atuais (herói nível 10, item Raro, IP 27, nível do item 10) uma arma dá cerca de **+11 de Ataque** sobre um herói com **147**; em 1× seria +1,1 sobre 14,7. O jogador precisa ver o ganho de uma troca **antes** de equipar.

## Objetivo

Mostrar, em qualquer lugar onde um item aparece, **quanto ele muda no herói**, e permitir comparar com o que está equipado sem abrir outra tela.

## Fora do escopo

- Valores de balanceamento: nenhum número é definido aqui. Toda quantidade vem do runtime (`SliceItemStats`, `combat_core.json → item_budget`, `blacksmith_slice.json`).
- Efeitos funcionais de item (modificadores): nenhum item os tem no runtime. A UI não promete efeito nenhum (ver Estados).
- Árvore de raridades de nove níveis: o componente já nasce preparado para ela, mas só cinco molduras são produzidas agora.

## Regras de número (DECIDIDO por Rafael em 2026-09-30, salvo marcação)

1. **Precisão total no cálculo, arredondamento só na tela.** O total de um set ou de um herói é calculado com os valores completos e arredondado uma vez. **Nunca** somar parcelas já arredondadas: três linhas `+2` podem conviver com um total `+7`, e isso é correto.
2. **Inteiros** para Vida, Ataque, Defesa, Recarga (Haste) e Tenacidade, arredondados para o mais próximo (0,5 sobe).
3. **Abreviação a partir de 10.000:** `10k`, `12,4k` (uma casa decimal até 99,9k), `124k`. Abaixo disso, inteiro completo com separador de milhar pt-BR (`2.393`). Mesma regra para HP de inimigo e de chefe.
4. **HIPÓTESE:** Crítico e Velocidade de ataque (percentuais) mostram **uma casa decimal** com vírgula e `%` (`+1,5%`), porque um valor típico por peça fica entre 0,5 e 3 pontos percentuais e o inteiro esconderia a diferença entre raridades.
5. **HIPÓTESE:** um bônus positivo que arredonda para 0 mostra `< 1`, nunca `+0` e nunca esconde a linha.
6. Bônus de item sempre com sinal (`+11`). Diferença de comparação sempre com sinal e com **forma** (▲ melhora, ▼ piora, = igual); a cor reforça, nunca sozinha.
7. Números em fonte de **16 px ou mais** (convenção de corpo); nunca menores que o texto ao lado.
8. Item Power aparece como `IP 27`; BP e fatores internos **nunca** aparecem.

## Componentes

### C1 — Chip de status

Pílula com ícone de status + valor: `[ícone] +11`. Três variantes de fundo: neutro (bônus do item), positivo (diferença melhor) e negativo (diferença pior), todas com forma distinta (seta) além de cor. Altura mínima 24 px, largura pelo conteúdo, toque **não** necessário.

### C2 — Linha de item (Inventário, Escolha, Resultado)

Estrutura (432 px de largura, margens laterais de 12 px):

```text
┌────────────────────────────────────────────┐
│ ┌──────┐  Galho de Vigília        ★ favorito│
│ │ ícone│  [Arma] Raro · IP 27               │
│ │ 72×72│  [⚔ +11] [🛡 +4]      [▲ +7 ATK]   │
│ └──────┘                                    │
│ [ Bastião ▾ ]              [   Equipar   ]  │
└────────────────────────────────────────────┘
```

- Ícone 64×64 dentro da **moldura de raridade** 72×72; glifo de slot ao lado do tipo.
- **Até três chips** de bônus, na ordem fixa Ataque, Vida, Defesa, Velocidade, Crítico, Recarga, Tenacidade; se houver mais, os três maiores por participação no orçamento do item e o resto na gaveta.
- Chip de **diferença** só aparece com um herói selecionado e compara com o item que seria substituído (ver Regras de comparação).
- Linha inteira toca para abrir a gaveta (C3); botões continuam com 48 dp.

### C3 — Gaveta de detalhe do item (Inventário e Ferreiro)

Painel inferior sobre a lista, com fundo opaco (convenção), contendo de cima para baixo:

1. Cabeçalho: moldura + ícone, nome, `Slot · Raridade · IP · Nível do item`, pips de Reforço.
2. **Tabela de bônus:** uma linha por status com ícone 24×24, nome, valor do item e, à direita, a diferença contra o equipado (▲ +7 / ▼ −2 / =).
3. **Total do herói:** `Ataque 147 → 158 (▲ +11)` para Vida, Ataque e Defesa, e uma linha compacta para os ratings que mudam. Valores vêm de `SliceItemStats.equip` com e sem o item.
4. **Identidade** (texto do catálogo) em cinza suave, **sem** prometer efeito (ver Estados).
5. Ações: Equipar/Trocar, Favoritar; no Ferreiro, Reforçar e Desmontar (em dois toques).

### C4 — Ficha de status do herói (Loadout e cabeçalho do Inventário)

Sete linhas: Vida, Ataque, Defesa, Velocidade de ataque, Crítico, Recarga, Tenacidade. Cada uma: ícone 16×16, nome, **total** e, em segunda cor, o **bônus de equipamento** entre parênteses (`Ataque 158 (+11)`). Quando o herói não tem equipamento, o parêntese some.

### C5 — Prévia do Reforço (Ferreiro)

Antes de confirmar: `Ataque +11 → +12`, `Defesa +4 → +4` (mostrando a parte que muda), o custo em Resíduos e o novo estado dos pips. O Reforço atual é +10% por nível (`blacksmith_slice.json`, slice: nível máximo 1).

### C6 — Cartão compacto (Escolha e Resultado)

Moldura + nome + até dois chips, sem ações. Usado em Reward Choice, drops da expedição e resumo do Resultado.

## Regras de comparação

- Compara com o item **do mesmo slot** equipado no herói selecionado. Slot vazio: `Vazio`, e a diferença é o bônus inteiro.
- **Acessório I/II:** compara com o acessório que seria substituído — o de menor pontuação (raridade, depois Item Power), a mesma ordem que o "Equipar os melhores" já usa. **HIPÓTESE.**
- A comparação usa **os totais do herói** nos três status de núcleo e, quando mudam, nos ratings; ela responde "fico mais forte?", não só "este item é maior?".
- **HIPÓTESE:** a diferença exibida é a diferença entre os **totais exibidos** (arredondados), para a linha sempre fechar (`272 → 275 (+3)`); os totais continuam calculados em precisão total (regra 1).
- Selecionar outro herói no seletor recalcula tudo; o número nunca fica desatualizado na tela.

## Estados

- **Sem herói selecionado:** chips de bônus aparecem; chips de diferença não.
- **Travado durante a expedição:** números e comparação continuam visíveis; Equipar/Reforçar/Desmontar ficam desabilitados com o motivo em texto perto do botão.
- **Item sem status calculável** (raridade fora da faixa do template): linha com `—` e sem chips; nunca crash nem `0`.
- **Item com identidade mas sem modificador no runtime** (todos hoje): o texto de identidade aparece rotulado como descrição, sem "efeito", sem número e sem ícone de poder. **RECOMENDADO:** só mostrar efeito ativo quando `modifiers` do item tiver conteúdo e o efeito existir no combate.
- **Relíquia e Memória:** mesma estrutura, moldura própria, sem pip de Reforço se o slot não aceita Reforço.
- **Lista vazia:** estado vazio da tela hospedeira; nada deste componente.

## Dados e API (a implementar; nenhuma regra na tela)

A tela **não calcula**. Uma camada de apresentação única (nome sugerido `ItemStatView`) chama `SliceItemStats.roll/equip` com o perfil ativo e devolve linhas prontas:

| Função | Devolve |
| --- | --- |
| `lines(inst, rows)` | `[{stat, value, text}]` já formatadas pelas regras de número |
| `compare(inst, hero_id, campaign)` | `[{stat, item, equipped, diff, shape}]` contra o item substituído |
| `hero_totals(hero_id, level, campaign, with_uid = -1)` | totais do herói com e sem o item |
| `format_number(value, kind)` | texto final (inteiro, abreviado, percentual) |

Testes obrigatórios ao implementar: formatação (`9.999`, `10.000 → 10k`, `12.350 → 12,4k`, `99.950 → 100k`, `0,4 → < 1`), soma sem arredondar parcelas, e que a diferença mostrada bate com `SliceItemStats.equip` com e sem o item.

## Exemplos reproduzíveis (ilustrativos, não requisitos)

Derivados dos dados de 2026-09-30: `combat_scale` 10, `level_curve_p` 0,8, IP 27, nível do item 10, herói nível 10. Bastião: Vida 2.393, Ataque 147, Defesa 271.

| Item | Raridade | Bônus exibido |
| --- | --- | --- |
| Galho de Vigília (arma) | Comum | `+4 Ataque` `+1 Defesa` |
| Galho de Vigília (arma) | Raro | `+11 Ataque` `+4 Defesa` |
| Galho de Vigília (arma) | Épico | `+15 Ataque` `+5 Defesa` |
| Broquel de Casca (secundário) | Incomum | `+40 Vida` `+4 Defesa` |
| Manto de Folhas (armadura) | Épico | `+142 Vida` `+5 Defesa` |
| Gota de Lúmen (acessório) | Raro | `+58 Vida` `+4 Recarga` |
| Olho de Vidro Verde (acessório) | Raro | `+5 Ataque` `+1,5% Crítico` |

Trocar o Galho Comum pelo Raro em Bastião mostra `Ataque 151 → 158 (▲ +7)` e `Defesa 272 → 275 (▲ +3)`: uma diferença legível sem decimais. Os totais exatos são 151,3 → 158,4 e 272,46 → 274,69; a diferença exata da Defesa é 2,23, mas a tela mostra `+3` porque a linha precisa fechar (`275 − 272`), conforme a regra de comparação.

## Critérios de aceite

- Nenhuma fórmula nem constante de balanceamento em cena; tudo passa por `ItemStatView`.
- Conferido em 432×960 e 1080×2424: nenhum chip ou linha corta; sem rolagem horizontal.
- Cada diferença tem forma (seta) e texto, não só cor.
- Com `combat_scale` 1 a tela mostra o valor correto (`+1,1` vira `+1`): a formatação não assume 10×.
- Ícones e molduras só aparecem depois do PASS do `ui_kit`; antes disso, os chips usam texto puro como fallback.

## Decisões

- **DECIDIDO:** regras de número 1 a 3 e 6 a 8 (Rafael, 2026-09-30).
- **HIPÓTESE:** percentuais com uma casa decimal; `< 1` para bônus arredondado a zero; comparação de acessórios pelo menor pontuado.
- **RECOMENDADO:** até três chips por linha; identidade sem promessa de efeito.
- **EM ABERTO:** nomes finais dos sete status na UI (sugestão: Vida, Ataque, Defesa, Velocidade, Crítico, Recarga, Tenacidade); nomes e molduras dos níveis 5 a 9 de raridade; se o Loadout mostra a ficha completa ou só Vida/Ataque/Defesa.

## Arte

[Contrato de arte](../../art/contracts/screens/s12_numeros_de_item.yaml) · [referências de layout v002](../../art/mockups/s12_numeros_de_item_concepts_v002/README.md) · [brief para geração de imagens](../../art/conceitos/ui/README.md) · [contrato global de criação de imagens](../../art/IMAGE_CREATION_CONTRACT.md) · convenções em [SCREEN_CONVENTIONS](../SCREEN_CONVENTIONS.md).
