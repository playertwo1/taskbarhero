# Referências de balanceamento recebidas

Esta pasta preserva os materiais enviados para orientar a próxima etapa de balanceamento do Pocket Hero.

## Arquivos

- [`BALANCE_MASTER_v0.2.md`](BALANCE_MASTER_v0.2.md) — índice e contratos resumidos do pacote v0.2.
- [`TASKBAR_BALANCE_PACK_v0.1.zip`](TASKBAR_BALANCE_PACK_v0.1.zip) — arquivo original recebido.
- [`pack_v0.1/TASKBAR_BALANCE_PACK_v0.1/`](pack_v0.1/TASKBAR_BALANCE_PACK_v0.1/) — mantém somente os arquivos que diferem da base canônica (`README.md` e `BALANCE_MASTER.md`).

**Deduplicação (2026-09-29):** dez arquivos do ZIP v0.1 e o antigo `STATUS_SYSTEM_BASE_v1.0.md` eram idênticos byte a byte às cópias da [base canônica v0.4](../../canonical/taskbar_sistema_v0.4/source/TASKBAR_SISTEMA_COMPLETO_v0.4/) e foram removidos daqui para manter uma única fonte: `STATUS_SYSTEM_BASE.md`, `COMBAT_FORMULAS.md`, `STAT_BUDGETS.md`, `HERO_STATS_BALANCE.md`, `ENEMY_STATS_BALANCE.md`, `EQUIPMENT_BALANCE.md`, `BUFF_DEBUFF_BALANCE.md`, `DIFFICULTY_SCALING.md`, `BALANCE_QA_CHECKLIST.md` e `balance_baseline_v0.1.json`. Leia-os na pasta canônica.

## Precedência e adaptação

Estes materiais são referências importadas, não fontes canônicas do Pocket Hero. A v0.2 lista dependências que não acompanham o ZIP v0.1; portanto, os arquivos não são um pacote integrado nem prova de aprovação de números.

A estrutura de adaptação do projeto está em [`docs/06_balance/COMBAT_BALANCE_STANDARD.md`](../../../docs/06_balance/COMBAT_BALANCE_STANDARD.md), aprovada para o design. Decisões explícitas de Rafael, [`HERO_STANDARD.md`](../../../HERO_STANDARD.md), os contratos de sistemas em `docs/`, e os dados/código/testes atuais prevalecem conforme a ordem definida em [`documents/INDEX.md`](../../INDEX.md) e [`AGENTS.md`](../../../AGENTS.md). Valores numéricos de referência continuam hipóteses até simulação e playtest.

O repositório GitHub associado ao projeto é https://github.com/playertwo1/taskbarhero. Ele identifica o projeto, mas não altera a autoridade dos documentos locais nem aprova conteúdo transferido de referências externas.
