---
id: ECHO_C1_001
status: IMPLEMENTED
certainty: HIPOTESE
runtime_id: echo_c1_001
---

# ECHO_C1_001 — A Sentinela que Ficou

**Status do conteúdo:** `IMPLEMENTED` no `SLICE-1`. A regra de alvo é hipótese até playtest; este estado registra implementação e testes automatizados, não balanceamento final.

## Identidade

- **Herói associado:** Bastião (`hero_001`).
- **Skill modificada:** Muralha Viva (`skill_bas_006`).
- **Aquisição:** recompensa única ao concluir o encontro da Geleia Anciã (`c1_2_2_b`) pela primeira vez.
- **Custo:** nenhum.
- **Equipamento:** slot de Echo dedicado; equipar ou desequipar pelo inventário no Refúgio. Posse e escolha equipada são persistidas no save.

## Efeito no slice

Ao conjurar Muralha Viva com este Echo equipado, Bastião também recebe o buff normal da skill quando sua porcentagem de HP for a menor entre os heróis vivos. Em empate, prevalece o primeiro herói na ordem da formação. O efeito usa o valor, atributo e duração carregados pela definição de Muralha Viva; o Echo não introduz outro número de combate nem representa distância.

Sem o Echo, Muralha Viva continua aplicando seu efeito somente aos alvos definidos na skill (`allies_behind`). O Echo não modifica outras skills nem protege Bastião quando outro herói tiver menor porcentagem de HP.

## Evidência

Testes Godot focados verificam a redução compartilhada com Muralha Viva, a ausência de efeito sem equipar, o caso em que outro herói está com menos HP, empate pela ordem da formação, recompensa no encontro, persistência e prevenção de duplicação.

O efeito segue `HIPÓTESE` até playtest. A regra geral do sistema está em [ECHO_SYSTEM](../../03_systems/ECHO_SYSTEM.md); o recorte do Capítulo 1 está em [SLICE_1_SCOPE](../chapters/chapter_01/SLICE_1_SCOPE.md).
