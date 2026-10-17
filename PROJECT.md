# PROJECT — Pocket Hero

Contrato de visão. Atualize quando o projeto nasce e quando a visão muda; o resto (marcos, estado) fica em `ROADMAP.md` e `STATE.md`. Resumo de [`README.md`](README.md), [`AGENTS.md`](AGENTS.md) e do [resumo do projeto](docs/00_project/POCKET_HERO_PROJECT_BRIEF.md); pilares e loop continuam em [`docs/00_project/`](docs/00_project/GAME_PILLARS.md).

## Problema
Fazer um RPG mobile de combate automático, party, equipamentos e progressão incremental com identidade própria, usando o Task Bar Hero só como referência de estrutura, nunca como fonte de assets, nomes, textos ou tabelas.

## Para quem
Jogadores de Android (app normal); o primeiro jogador e decisor é Rafael. O público-alvo detalhado está nos documentos de `docs/00_project/`.

## MVP — até três fluxos que entregam valor
O MVP antigo (gate R19) foi substituído pelo vertical slice do Capítulo 1 no `1A-CUT`:
1. Montar a party no Refúgio (loadout do trio Bastião, Flecha e Íris) e partir para a expedição.
2. Expedição de 10 encontros com loot, eventos e dois chefes (Rainha das Geleias e Guardião-Cervo), com pausa e velocidades.
3. Voltar ao Refúgio e progredir: Fragmentos, Árvore dos Ecos e Ferreiro.

## Fora do MVP (escrito para não voltar escondido)
- Overlay, backend, contas, multiplayer, cloud save, monetização e vantagem paga.
- Recriar o loop legado do MVP ou conteúdo sem `content_set: "slice"`.
- Arte final gerada por script (vem do ComfyUI e do Aseprite).

## Restrições
- Plataforma/ambiente: Godot 4.7.2 Standard, GDScript, Android (app normal).
- Dados sensíveis e privacidade: sem contas nem dados pessoais no escopo; nunca expor credenciais.
- Custos, licenças, integrações obrigatórias: personagens, mundo, interface e arte originais; nenhum asset ou texto do Task Bar Hero.

## Como saberemos que funcionou
Slice com testes Godot verdes, Argos dentro das metas do Capítulo 1 e playtest humano (`docs/08_qa/PLAYTEST_1E.md`) confirmando diversão, clareza, TTK e pacing.

## Autoridade de produto
Rafael (a instrução mais recente dele vem primeiro; `AGENTS.md` §2).

## Alternativas consideradas
O MVP R0–R19 (loop legado), homologado em 2026-09-27 e substituído pelo slice em 2026-09-29; histórico em `arquivados/ROADMAP_CONCLUIDO.md`.
