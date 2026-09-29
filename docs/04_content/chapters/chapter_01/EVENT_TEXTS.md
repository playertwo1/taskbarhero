---
id: EVENT_TEXTS_C1
status: DESIGN
certainty: HIPOTESE
derived_from: data/expedition/event_texts_c1.json
---

# Textos dos eventos de expedição — Capítulo 1 (vista derivada)

**Não edite este arquivo.** Ele é gerado por `python tools/content/export_event_texts.py` a partir de [`event_texts_c1.json`](../../../../data/expedition/event_texts_c1.json), que é a fonte dos textos. Mecânica, condições e valores dos eventos ficam em [SLICE_1B_RUN_SPEC](../../../03_systems/SLICE_1B_RUN_SPEC.md) e em [`events_c1.json`](../../../../data/expedition/events_c1.json).

**Status:** `DESIGN`; textos escritos em 2026-09-29 a partir da [lore canônica](../../../01_world/loreparte1.md) e da [Bíblia de Lore](../../../01_world/LORE_BIBLE.md), aguardando revisão de Rafael.

## Regras de escrita

- Mostrar evidência e perguntas; nunca responder os mistérios centrais da Bíblia de Lore (causa do Apagamento, destino do Lúmen, máquinas antigas, o Observador).
- Não revelar o nome verdadeiro do Bastião nem quem ele protegia; não antecipar o desfecho do Guardião-Cervo.
- Tom do Capítulo I: melancolia contida, frases curtas, sem piada e sem exposição.
- Cada intro e cada texto de lore tem até 4 frases; cada resultado de escolha, até 2.

## Poço de Lúmen (`event_c1_001`, fixed)

**Ao aparecer:** No fundo de uma clareira há um poço de pedra sem corda. A água parada mostra, por um instante, rostos que ninguém da party reconhece. Íris diz que ele guarda mais do que água: guarda o que tentou lembrar.

- **Curar a party:** Beber é lembrar, por alguns segundos, por que ainda se está de pé. Os ferimentos deixam de pesar.
- **Sacrificar vida por uma recompensa rara:** O poço aceita o que a party dá e devolve algo do fundo. Custa fôlego, e o Lúmen na água escurece um pouco.

## Reserva de Resíduo (`event_c1_reserva_residuo`, fixed)

**Ao aparecer:** Presa entre duas raízes, uma sacola de Resíduo de Lúmen com uma etiqueta rasurada. Alguém a deixou para quem viesse depois. Nenhum nome sobrou para agradecer.

- **Recolher:** A party recolhe o Resíduo. A chama da Lanterna-Mãe vai precisar de cada fragmento.

## Criatura Ferida (`event_c1_criatura_ferida`, random)

**Ao aparecer:** Um animal pequeno, coberto de musgo, está com as patas presas em raízes cortantes. Não foge nem ataca. Parece ter esquecido qual das duas coisas se faz.

- **Salvar:** Cortar as raízes machuca quem corta. O animal olha para cada um, como se decorasse os rostos, e some entre as árvores.
- **Ignorar:** A party segue. Atrás dela, o animal continua parado, esperando alguém lembrar de decidir por ele.

## Raiz Oca (`event_c1_raiz_oca`, random)

**Ao aparecer:** Uma raiz grossa, oca por dentro, com a casca gasta como se muitas mãos a tivessem aberto. Há um nicho escuro lá dentro.

- **Abrir a raiz:** Flecha estende o braço no escuro do nicho.
  - *Resultado `spines`:* Espinhos escondidos se fecham sobre a mão que entrou. A raiz não guardava nada, só uma defesa.
  - *Resultado `cache`:* No fundo do nicho, embrulhado em folhas secas, há algo guardado por alguém que planejava voltar.
  - *Resultado `nothing`:* O nicho está vazio, mas limpo. Quem esteve aqui levou tudo, ou nunca deixou nada.
- **Ignorar:** Ninguém quer descobrir o que a raiz guarda. Ela continua aberta atrás da party.

## Árvore Cantante (`event_c1_arvore_cantante`, random)

**Ao aparecer:** Uma árvore de casca prateada murmura uma melodia sem palavras, e o ar em volta vibra junto. Íris reconhece o compasso de uma canção que o Apagamento levou de todos, e que a árvore ainda repete sem saber de quem é.

- **Tocar:** Ao tocar o tronco, o ritmo da árvore passa para as mãos. Por um tempo, a party se move no mesmo compasso.
- **Cortar:** O corte silencia a melodia no meio de uma nota. Ela não termina, e ninguém consegue completar por ela.
- **Ignorar:** A canção segue atrás da party por um longo trecho. Depois, também ela é esquecida.

## Cristal Partido (`event_c1_cristal_partido`, random)

**Ao aparecer:** Um cristal de Lúmen rachado ao meio pulsa devagar, como algo ferido. Dentro dele há uma emoção sem dono: raiva, ou medo, ou as duas coisas misturadas. Íris pede que ninguém o toque sem pensar.

- **Absorver o poder:** A fúria alheia entra na party e dá força, mas cobra o corpo. Íris jura que uma das frases seguintes não é dela.
- **Deixar:** O cristal continua pulsando no escuro. Quem quer que tenha sentido aquilo continua sem ninguém que lembre.

## Memorial Esquecido (`event_c1_memorial`, random)

**Ao aparecer:** Uma laje de pedra com nomes gravados, quase todos gastos, como um memorial que ninguém terminou de escrever. Um herói pode honrá-lo; os outros só assistem.

- **Honrar hero_001:** Bastião apoia a mão na laje e fica ali, sem pedir nada. Quando se afasta, parece mais leve.
- **Honrar hero_002:** Flecha lê os nomes um a um, marcando cada um no ar com o dedo. Quando termina, respira fundo e aceita o descanso.
- **Honrar hero_003:** Íris toca a pedra e ouve um coro de vozes que se cala aos poucos. Sai dali mais firme, mesmo sem entender por quê.

## Eco Percebido (`event_c1_eco_percebido`, personal)

**Ao aparecer:** Íris para de repente e leva a mão ao peito. O Bosque, ela diz, está recitando um nome. Depois outro, e outro, sempre em voz baixa, como quem reza.

- **Reagir ao Eco:** Íris repete os nomes em voz alta, e a party sente o Bosque prestar atenção. Ele para no meio de um, como quem esqueceu a última sílaba.

## Rastro da Caçada (`event_c1_rastro_cacada`, personal)

**Ao aparecer:** Na casca de uma árvore há um símbolo riscado com precisão: a marca de quem acompanha um alvo. Flecha reconhece o traço, e não reconhece o momento em que o fez.

- **Seguir o rastro:** Ela segue o rastro por um trecho difícil e chega antes de todos ao próximo ponto. Ainda cansada, aponta a primeira presa.
- **Ignorar:** Flecha olha para trás uma vez e não diz nada. O símbolo fica na casca, esperando outra pessoa.

## O Sobrevivente (`event_c1_sobrevivente`, personal)

**Ao aparecer:** Um tronco caído prende uma pessoa ferida no chão. Ela pergunta o nome de quem chegou e diz que não se lembra do próprio. Bastião a olha por um longo tempo.

- **Proteger:** Bastião ergue o tronco com os ombros e aguenta o peso enquanto os outros a puxam. Ela agradece e, no meio da frase, olha para ele como se o visse pela primeira vez.
- **Passar:** Bastião hesita, e a party segue. Atrás deles, a voz pede outra vez um nome que ninguém lhe deu.

## O Observador (`event_c1_observador`, secret)

**Ao aparecer:** No limite de uma clareira, entre os troncos, há uma figura alta, parada, que ninguém viu chegar. O Lúmen em volta dela não brilha nem sussurra.

- **Testemunhar:** Ninguém se mexe. Quando Flecha ergue o arco para marcá-la, ela não está mais lá, e não deixou rastro.

## Textos de lore reveladas

- `LORE_EVT_CRIATURA_FERIDA`: As pegadas do animal brilharam por um instante no chão de musgo e se apagaram. Íris comenta que o Bosque ainda tenta lembrar quem passa por ele, mas a memória dura menos que o rastro.
- `LORE_EVT_RAIZ_OCA`: Dentro da raiz havia marcas de mãos pequenas, gastas pelo uso. Alguém veio muitas vezes aqui para guardar coisas, e o Bosque, que já soube o nome dessa pessoa, agora só guarda o oco.
- `LORE_EVT_MEMORIAL_hero_001`: Por um instante, Bastião sente o peso de uma porta contra as costas e uma ordem que não obedeceu. Não vê o rosto de ninguém. Só sabe que ficou.
- `LORE_EVT_MEMORIAL_hero_002`: Um dos nomes na laje está gravado, igual, numa das flechas de Flecha. Ela guarda a flecha sem riscar o nome. Ainda não sabe se veio para encontrá-lo ou para caçá-lo.
- `LORE_EVT_MEMORIAL_hero_003`: Entre as vozes, Íris ouve uma que começa uma frase e a deixa incompleta. Ela a termina em pensamento e só depois percebe que não sabe de quem eram aquelas palavras.
- `LORE_EVT_ECO_PERCEBIDO`: O Bosque, dizem as histórias, sabia o nome de cada criatura que nascia nele. Íris ouviu uma lista dessas criaturas, recitada em voz baixa, e a lista tem menos nomes do que ela esperava.
- `LORE_EVT_SOBREVIVENTE`: Bastião não perguntou o nome da pessoa que salvou, e ela não perguntou o dele. Ao se afastar, percebeu que ficar ao lado de alguém que não vai se lembrar de você ainda é ficar.
- `LORE_EVT_OBSERVADOR`: A figura não atacou, não chamou e não deixou rastro. Íris disse que onde ela estava não havia memória alguma: nem vozes, nem ecos, nem silêncio de coisa esquecida. Só um espaço que olhava.
