# Argos — relatório `slice_paths`

- Commit: `3b28de6` (com alterações locais) · Godot 4.7.2-stable (official)
- Sementes por célula: 6 · `enemy_damage_scale` 0.5
- Simulação determinística; **não é playtest** e não avalia diversão.

## Achados

- **[BALANCE/HIGH] Poucos caminhos viáveis** — viáveis até o nível 8 (rota ≥ 50%): 48; sem lumen: 0 _(regra: Pedido de Rafael (2026-09-29): mais de um caminho viável, sem depender da cura)_
- **[BALANCE/HIGH] Dominância no nível 5** — melhor 100% vs mediana 0%; líderes: base · guardiao/critico/lumen, base · retaliacao/marca/lumen, base · retaliacao_tele/critico/lumen, base · retaliacao_tele/marca/lumen, cacada_burst · guardiao/critico/lumen, cacada_burst · retaliacao/marca/lumen _(regra: Perfil optimizer do Argos: build dominante elimina escolhas)_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: base · retaliacao_tele/critico/lumen** — 33% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: base · retaliacao_tele/marca/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: cacada_burst · retaliacao_tele/critico/lumen** — 33% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: cacada_burst · retaliacao_tele/marca/lumen** — 50% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: combinado · guardiao/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: combinado · guardiao/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: combinado · retaliacao/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: combinado · retaliacao/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: combinado · retaliacao_tele/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: combinado · retaliacao_tele/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: folego · guardiao/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: folego · guardiao/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: folego · retaliacao/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: folego · retaliacao/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: folego · retaliacao_tele/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: folego · retaliacao_tele/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: muralha_r5 · guardiao/critico/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: muralha_r5 · retaliacao_tele/critico/lumen** — 50% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: muralha_r5 · retaliacao_tele/marca/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: poco_lumen · guardiao/critico/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: poco_lumen · guardiao/marca/lumen** — 50% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: poco_lumen · retaliacao/critico/lumen** — 67% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: poco_lumen · retaliacao/marca/lumen** — 33% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: poco_lumen · retaliacao_tele/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: poco_lumen · retaliacao_tele/marca/lumen** — 83% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: pocoes · guardiao/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: pocoes · guardiao/marca/lumen** — 83% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: pocoes · retaliacao/critico/lumen** — 67% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: pocoes · retaliacao/marca/lumen** — 83% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: pocoes · retaliacao_tele/critico/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: pocoes · retaliacao_tele/marca/lumen** — 83% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: veu_maior · guardiao/critico/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: veu_maior · guardiao/marca/lumen** — 33% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: veu_maior · retaliacao/critico/lumen** — 50% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: veu_maior · retaliacao/marca/lumen** — 17% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: veu_maior · retaliacao_tele/critico/lumen** — 67% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Vitória na 1ª tentativa desde o nível inicial: veu_maior · retaliacao_tele/marca/lumen** — 100% das campanhas vencem na tentativa 1 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/MEDIUM] Combinações que nunca vencem na campanha** — 25: base · guardiao/critico/arcano, base · guardiao/marca/arcano, base · retaliacao/critico/arcano, base · retaliacao/marca/arcano, base · retaliacao_tele/critico/arcano, base · retaliacao_tele/marca/arcano, cacada_burst · guardiao/critico/arcano, cacada_burst · guardiao/marca/arcano, cacada_burst · retaliacao/critico/arcano, cacada_burst · retaliacao/marca/arcano, cacada_burst · retaliacao_tele/critico/arcano, cacada_burst · retaliacao_tele/marca/arcano, muralha_r5 · guardiao/critico/arcano, muralha_r5 · guardiao/marca/arcano, muralha_r5 · retaliacao/critico/arcano, muralha_r5 · retaliacao/marca/arcano, muralha_r5 · retaliacao_tele/critico/arcano, muralha_r5 · retaliacao_tele/marca/arcano, poco_lumen · guardiao/critico/arcano, veu_maior · guardiao/critico/arcano, veu_maior · guardiao/marca/arcano, veu_maior · retaliacao/critico/arcano, veu_maior · retaliacao/marca/arcano, veu_maior · retaliacao_tele/critico/arcano, veu_maior · retaliacao_tele/marca/arcano _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: base · guardiao/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: base · guardiao/marca/controle** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: base · retaliacao/critico/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: base · retaliacao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: base · retaliacao_tele/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: base · retaliacao_tele/marca/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: cacada_burst · guardiao/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: cacada_burst · guardiao/marca/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: cacada_burst · retaliacao/critico/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: cacada_burst · retaliacao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: cacada_burst · retaliacao_tele/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: cacada_burst · retaliacao_tele/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: combinado · guardiao/critico/arcano** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: combinado · guardiao/marca/arcano** — mediana 7.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: combinado · retaliacao/critico/arcano** — mediana 8.0 tentativas, nível 13.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: combinado · retaliacao/marca/arcano** — mediana 7.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: combinado · retaliacao_tele/critico/arcano** — mediana 7.5 tentativas, nível 13.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: combinado · retaliacao_tele/marca/arcano** — mediana 6.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · guardiao/critico/arcano** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · guardiao/critico/controle** — mediana 6.5 tentativas, nível 12.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · guardiao/marca/arcano** — mediana 8.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · guardiao/marca/controle** — mediana 6.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · retaliacao/critico/arcano** — mediana 6.5 tentativas, nível 12.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · retaliacao/critico/controle** — mediana 6.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · retaliacao/marca/arcano** — mediana 6.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: folego · retaliacao_tele/critico/arcano** — mediana 6.0 tentativas, nível 11.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: muralha_r5 · guardiao/critico/controle** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: muralha_r5 · guardiao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: muralha_r5 · retaliacao/critico/controle** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: muralha_r5 · retaliacao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: muralha_r5 · retaliacao_tele/critico/controle** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: muralha_r5 · retaliacao_tele/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · guardiao/critico/controle** — mediana 7.5 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · guardiao/marca/arcano** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · guardiao/marca/controle** — mediana 7.5 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao/critico/arcano** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao/critico/controle** — mediana 7.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao/marca/arcano** — mediana 9.5 tentativas, nível 14.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao/marca/controle** — mediana 6.0 tentativas, nível 11.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao_tele/critico/arcano** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao_tele/critico/controle** — mediana 6.5 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao_tele/marca/arcano** — mediana 7.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: poco_lumen · retaliacao_tele/marca/controle** — mediana 6.0 tentativas, nível 11.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · guardiao/critico/arcano** — mediana 10.0 tentativas, nível 15.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · guardiao/critico/controle** — mediana 6.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · guardiao/marca/arcano** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · guardiao/marca/controle** — mediana 6.0 tentativas, nível 12.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · retaliacao/critico/arcano** — mediana 8.5 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · retaliacao/marca/arcano** — mediana 6.5 tentativas, nível 12.5 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · retaliacao_tele/critico/arcano** — mediana 7.5 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: pocoes · retaliacao_tele/marca/arcano** — mediana 7.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: veu_maior · guardiao/critico/controle** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: veu_maior · guardiao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: veu_maior · retaliacao/critico/controle** — mediana 9.0 tentativas, nível 14.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: veu_maior · retaliacao/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: veu_maior · retaliacao_tele/critico/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[PACING/LOW] Tentativas fora da faixa: veu_maior · retaliacao_tele/marca/controle** — mediana 8.0 tentativas, nível 13.0 _(regra: Pedido de Rafael: desafio e progresso após derrotas (HIPÓTESE de faixa))_
- **[INFO/INFO] Referência de primeira tentativa no nível 5** — melhor combinação 100% (meta humana 40%–60%) _(regra: ENCOUNTERS.md: 40–60% na primeira tentativa é meta de teste humano; aqui só referência)_
- **[INFO/INFO] Itens por tentativa** — mediana 4.0 item(ns) por tentativa entre combinações _(regra: SLICE_1_SCOPE.md seção 3: mínimo de 5 Resíduos antes do boss = um Reforço +1 (HIPÓTESE))_

## Rota completa (vitória por combinação e nível)

| Build (Bastião/Flecha/Íris) | Nível | Vitória | Δ anterior | Perde mais em | HP ao chegar no Guardião | Cura |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| base · guardiao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · guardiao/critico/controle | 5 | 0% |  | c1_3_2_a | 5% | 0 |
| base · guardiao/critico/lumen | 5 | 100% |  |  | 57% | 567 |
| base · guardiao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · guardiao/marca/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · guardiao/marca/lumen | 5 | 83% |  | c1_5_2_a | 56% | 548 |
| base · retaliacao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · retaliacao/critico/controle | 5 | 0% |  | c1_3_2_a | 17% | 0 |
| base · retaliacao/critico/lumen | 5 | 67% |  | c1_5_2_a | 48% | 508 |
| base · retaliacao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · retaliacao/marca/controle | 5 | 0% |  | c1_3_2_a | 14% | 0 |
| base · retaliacao/marca/lumen | 5 | 100% |  |  | 50% | 498 |
| base · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · retaliacao_tele/critico/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 43% | 518 |
| base · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| base · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 6% | 0 |
| base · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 44% | 508 |
| cacada_burst · guardiao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · guardiao/critico/controle | 5 | 0% |  | c1_3_2_a | 5% | 0 |
| cacada_burst · guardiao/critico/lumen | 5 | 100% |  |  | 57% | 567 |
| cacada_burst · guardiao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · guardiao/marca/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · guardiao/marca/lumen | 5 | 83% |  | c1_5_2_a | 56% | 548 |
| cacada_burst · retaliacao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · retaliacao/critico/controle | 5 | 0% |  | c1_3_2_a | 17% | 0 |
| cacada_burst · retaliacao/critico/lumen | 5 | 67% |  | c1_5_2_a | 48% | 508 |
| cacada_burst · retaliacao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · retaliacao/marca/controle | 5 | 0% |  | c1_3_2_a | 14% | 0 |
| cacada_burst · retaliacao/marca/lumen | 5 | 100% |  |  | 50% | 498 |
| cacada_burst · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · retaliacao_tele/critico/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 43% | 518 |
| cacada_burst · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| cacada_burst · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 6% | 0 |
| cacada_burst · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 44% | 508 |
| combinado · guardiao/critico/arcano | 5 | 0% |  | c1_5_2_a | 42% | 0 |
| combinado · guardiao/critico/controle | 5 | 0% |  | c1_5_2_a | 53% | 0 |
| combinado · guardiao/critico/lumen | 5 | 100% |  |  | 68% | 566 |
| combinado · guardiao/marca/arcano | 5 | 0% |  | c1_5_2_a | 47% | 0 |
| combinado · guardiao/marca/controle | 5 | 0% |  | c1_5_2_a | 45% | 0 |
| combinado · guardiao/marca/lumen | 5 | 100% |  |  | 66% | 543 |
| combinado · retaliacao/critico/arcano | 5 | 0% |  | c1_5_2_a | 38% | 0 |
| combinado · retaliacao/critico/controle | 5 | 0% |  | c1_5_2_a | 48% | 0 |
| combinado · retaliacao/critico/lumen | 5 | 100% |  |  | 51% | 518 |
| combinado · retaliacao/marca/arcano | 5 | 0% |  | c1_5_2_a | 43% | 0 |
| combinado · retaliacao/marca/controle | 5 | 0% |  | c1_5_2_a | 49% | 0 |
| combinado · retaliacao/marca/lumen | 5 | 100% |  |  | 59% | 498 |
| combinado · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_5_2_a | 34% | 0 |
| combinado · retaliacao_tele/critico/controle | 5 | 0% |  | c1_5_2_a | 46% | 0 |
| combinado · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 48% | 518 |
| combinado · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_5_2_a | 39% | 0 |
| combinado · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 48% | 0 |
| combinado · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 52% | 508 |
| folego · guardiao/critico/arcano | 5 | 0% |  | c1_5_2_a | 43% | 0 |
| folego · guardiao/critico/controle | 5 | 0% |  | c1_5_2_a | 56% | 0 |
| folego · guardiao/critico/lumen | 5 | 100% |  |  | 85% | 554 |
| folego · guardiao/marca/arcano | 5 | 0% |  | c1_5_2_a | 53% | 0 |
| folego · guardiao/marca/controle | 5 | 0% |  | c1_5_2_a | 60% | 0 |
| folego · guardiao/marca/lumen | 5 | 100% |  |  | 85% | 482 |
| folego · retaliacao/critico/arcano | 5 | 0% |  | c1_5_2_a | 50% | 0 |
| folego · retaliacao/critico/controle | 5 | 0% |  | c1_5_2_a | 55% | 0 |
| folego · retaliacao/critico/lumen | 5 | 100% |  |  | 79% | 468 |
| folego · retaliacao/marca/arcano | 5 | 0% |  | c1_5_2_a | 51% | 0 |
| folego · retaliacao/marca/controle | 5 | 0% |  | c1_5_2_a | 58% | 0 |
| folego · retaliacao/marca/lumen | 5 | 100% |  |  | 83% | 445 |
| folego · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_5_2_a | 43% | 0 |
| folego · retaliacao_tele/critico/controle | 5 | 0% |  | c1_5_2_a | 52% | 0 |
| folego · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 84% | 484 |
| folego · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_5_2_a | 50% | 0 |
| folego · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 62% | 0 |
| folego · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 79% | 446 |
| muralha_r5 · guardiao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| muralha_r5 · guardiao/critico/controle | 5 | 0% |  | c1_5_2_a | 7% | 0 |
| muralha_r5 · guardiao/critico/lumen | 5 | 100% |  |  | 63% | 566 |
| muralha_r5 · guardiao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| muralha_r5 · guardiao/marca/controle | 5 | 0% |  | c1_5_2_a | 13% | 0 |
| muralha_r5 · guardiao/marca/lumen | 5 | 100% |  |  | 65% | 543 |
| muralha_r5 · retaliacao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| muralha_r5 · retaliacao/critico/controle | 5 | 0% |  | c1_3_2_a | 18% | 0 |
| muralha_r5 · retaliacao/critico/lumen | 5 | 67% |  | c1_5_2_a | 48% | 508 |
| muralha_r5 · retaliacao/marca/arcano | 5 | 0% |  | c1_3_2_a | 3% | 0 |
| muralha_r5 · retaliacao/marca/controle | 5 | 0% |  | c1_5_2_a | 7% | 0 |
| muralha_r5 · retaliacao/marca/lumen | 5 | 83% |  | c1_5_2_a | 52% | 488 |
| muralha_r5 · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| muralha_r5 · retaliacao_tele/critico/controle | 5 | 0% |  | c1_3_2_a | — | 0 |
| muralha_r5 · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 45% | 518 |
| muralha_r5 · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| muralha_r5 · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 4% | 0 |
| muralha_r5 · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 44% | 508 |
| poco_lumen · guardiao/critico/arcano | 5 | 0% |  | c1_5_2_a | 20% | 0 |
| poco_lumen · guardiao/critico/controle | 5 | 0% |  | c1_5_2_a | 44% | 0 |
| poco_lumen · guardiao/critico/lumen | 5 | 100% |  |  | 82% | 567 |
| poco_lumen · guardiao/marca/arcano | 5 | 0% |  | c1_5_2_a | 35% | 0 |
| poco_lumen · guardiao/marca/controle | 5 | 0% |  | c1_5_2_a | 44% | 0 |
| poco_lumen · guardiao/marca/lumen | 5 | 100% |  |  | 81% | 548 |
| poco_lumen · retaliacao/critico/arcano | 5 | 0% |  | c1_5_2_a | 34% | 0 |
| poco_lumen · retaliacao/critico/controle | 5 | 0% |  | c1_5_2_a | 42% | 0 |
| poco_lumen · retaliacao/critico/lumen | 5 | 100% |  |  | 77% | 508 |
| poco_lumen · retaliacao/marca/arcano | 5 | 0% |  | c1_5_2_a | 35% | 0 |
| poco_lumen · retaliacao/marca/controle | 5 | 0% |  | c1_5_2_a | 43% | 0 |
| poco_lumen · retaliacao/marca/lumen | 5 | 100% |  |  | 81% | 496 |
| poco_lumen · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_3_2_a | 28% | 0 |
| poco_lumen · retaliacao_tele/critico/controle | 5 | 0% |  | c1_5_2_a | 33% | 0 |
| poco_lumen · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 77% | 518 |
| poco_lumen · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_3_2_a | 36% | 0 |
| poco_lumen · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 41% | 0 |
| poco_lumen · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 75% | 508 |
| pocoes · guardiao/critico/arcano | 5 | 0% |  | c1_5_2_a | 33% | 0 |
| pocoes · guardiao/critico/controle | 5 | 0% |  | c1_5_2_a | 48% | 0 |
| pocoes · guardiao/critico/lumen | 5 | 100% |  |  | 63% | 567 |
| pocoes · guardiao/marca/arcano | 5 | 0% |  | c1_5_2_a | 40% | 0 |
| pocoes · guardiao/marca/controle | 5 | 0% |  | c1_5_2_a | 43% | 0 |
| pocoes · guardiao/marca/lumen | 5 | 100% |  |  | 67% | 548 |
| pocoes · retaliacao/critico/arcano | 5 | 0% |  | c1_5_2_a | 41% | 0 |
| pocoes · retaliacao/critico/controle | 5 | 0% |  | c1_5_2_a | 46% | 0 |
| pocoes · retaliacao/critico/lumen | 5 | 100% |  |  | 49% | 508 |
| pocoes · retaliacao/marca/arcano | 5 | 0% |  | c1_5_2_a | 51% | 0 |
| pocoes · retaliacao/marca/controle | 5 | 0% |  | c1_5_2_a | 48% | 0 |
| pocoes · retaliacao/marca/lumen | 5 | 100% |  |  | 50% | 498 |
| pocoes · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_5_2_a | 39% | 0 |
| pocoes · retaliacao_tele/critico/controle | 5 | 0% |  | c1_5_2_a | 42% | 0 |
| pocoes · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 46% | 518 |
| pocoes · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_5_2_a | 49% | 0 |
| pocoes · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 44% | 0 |
| pocoes · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 44% | 508 |
| veu_maior · guardiao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| veu_maior · guardiao/critico/controle | 5 | 0% |  | c1_5_2_a | 8% | 0 |
| veu_maior · guardiao/critico/lumen | 5 | 100% |  |  | 63% | 567 |
| veu_maior · guardiao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| veu_maior · guardiao/marca/controle | 5 | 0% |  | c1_3_2_a | 15% | 0 |
| veu_maior · guardiao/marca/lumen | 5 | 100% |  |  | 64% | 548 |
| veu_maior · retaliacao/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| veu_maior · retaliacao/critico/controle | 5 | 0% |  | c1_5_2_a | 20% | 0 |
| veu_maior · retaliacao/critico/lumen | 5 | 100% |  |  | 52% | 518 |
| veu_maior · retaliacao/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| veu_maior · retaliacao/marca/controle | 5 | 0% |  | c1_5_2_a | 16% | 0 |
| veu_maior · retaliacao/marca/lumen | 5 | 100% |  |  | 58% | 498 |
| veu_maior · retaliacao_tele/critico/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| veu_maior · retaliacao_tele/critico/controle | 5 | 0% |  | c1_5_2_a | 8% | 0 |
| veu_maior · retaliacao_tele/critico/lumen | 5 | 100% |  |  | 50% | 518 |
| veu_maior · retaliacao_tele/marca/arcano | 5 | 0% |  | c1_3_2_a | — | 0 |
| veu_maior · retaliacao_tele/marca/controle | 5 | 0% |  | c1_5_2_a | 14% | 0 |
| veu_maior · retaliacao_tele/marca/lumen | 5 | 100% |  |  | 51% | 508 |

## Campanha (tentativas até vencer; HP cheio a cada volta ao Hub, XP acumulado)

| Build | Vence | 1ª tentativa | Tentativas (mediana) | Nível na vitória |
| --- | ---: | ---: | ---: | ---: |
| base · guardiao/critico/arcano | 0% | 0% | — | — |
| base · guardiao/critico/controle | 100% | 0% | 10.0 | 15.0 |
| base · guardiao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| base · guardiao/marca/arcano | 0% | 0% | — | — |
| base · guardiao/marca/controle | 83% | 0% | 9.0 | 14.0 |
| base · guardiao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| base · retaliacao/critico/arcano | 0% | 0% | — | — |
| base · retaliacao/critico/controle | 100% | 0% | 9.5 | 14.5 |
| base · retaliacao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| base · retaliacao/marca/arcano | 0% | 0% | — | — |
| base · retaliacao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| base · retaliacao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| base · retaliacao_tele/critico/arcano | 0% | 0% | — | — |
| base · retaliacao_tele/critico/controle | 100% | 0% | 10.0 | 15.0 |
| base · retaliacao_tele/critico/lumen | 100% | 33% | 2.0 | 5.0 |
| base · retaliacao_tele/marca/arcano | 0% | 0% | — | — |
| base · retaliacao_tele/marca/controle | 100% | 0% | 9.5 | 14.5 |
| base · retaliacao_tele/marca/lumen | 100% | 17% | 2.0 | 5.0 |
| cacada_burst · guardiao/critico/arcano | 0% | 0% | — | — |
| cacada_burst · guardiao/critico/controle | 100% | 0% | 10.0 | 15.0 |
| cacada_burst · guardiao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| cacada_burst · guardiao/marca/arcano | 0% | 0% | — | — |
| cacada_burst · guardiao/marca/controle | 67% | 0% | 10.0 | 15.0 |
| cacada_burst · guardiao/marca/lumen | 100% | 0% | 2.0 | 4.0 |
| cacada_burst · retaliacao/critico/arcano | 0% | 0% | — | — |
| cacada_burst · retaliacao/critico/controle | 100% | 0% | 9.5 | 14.5 |
| cacada_burst · retaliacao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| cacada_burst · retaliacao/marca/arcano | 0% | 0% | — | — |
| cacada_burst · retaliacao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| cacada_burst · retaliacao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| cacada_burst · retaliacao_tele/critico/arcano | 0% | 0% | — | — |
| cacada_burst · retaliacao_tele/critico/controle | 100% | 0% | 10.0 | 15.0 |
| cacada_burst · retaliacao_tele/critico/lumen | 100% | 33% | 2.0 | 5.0 |
| cacada_burst · retaliacao_tele/marca/arcano | 0% | 0% | — | — |
| cacada_burst · retaliacao_tele/marca/controle | 100% | 0% | 8.0 | 13.0 |
| cacada_burst · retaliacao_tele/marca/lumen | 100% | 50% | 1.5 | 2.5 |
| combinado · guardiao/critico/arcano | 83% | 0% | 9.0 | 14.0 |
| combinado · guardiao/critico/controle | 100% | 0% | 4.0 | 9.0 |
| combinado · guardiao/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| combinado · guardiao/marca/arcano | 100% | 0% | 7.0 | 13.0 |
| combinado · guardiao/marca/controle | 100% | 0% | 5.0 | 10.0 |
| combinado · guardiao/marca/lumen | 100% | 100% | 1.0 | 1.0 |
| combinado · retaliacao/critico/arcano | 100% | 0% | 8.0 | 13.5 |
| combinado · retaliacao/critico/controle | 100% | 0% | 4.0 | 9.0 |
| combinado · retaliacao/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| combinado · retaliacao/marca/arcano | 100% | 0% | 7.0 | 13.0 |
| combinado · retaliacao/marca/controle | 100% | 0% | 4.0 | 9.0 |
| combinado · retaliacao/marca/lumen | 100% | 100% | 1.0 | 1.0 |
| combinado · retaliacao_tele/critico/arcano | 100% | 0% | 7.5 | 13.5 |
| combinado · retaliacao_tele/critico/controle | 100% | 0% | 4.0 | 9.0 |
| combinado · retaliacao_tele/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| combinado · retaliacao_tele/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| combinado · retaliacao_tele/marca/controle | 100% | 0% | 4.5 | 9.5 |
| combinado · retaliacao_tele/marca/lumen | 100% | 100% | 1.0 | 1.0 |
| folego · guardiao/critico/arcano | 67% | 0% | 9.0 | 14.0 |
| folego · guardiao/critico/controle | 100% | 0% | 6.5 | 12.5 |
| folego · guardiao/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| folego · guardiao/marca/arcano | 100% | 0% | 8.0 | 14.0 |
| folego · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| folego · guardiao/marca/lumen | 100% | 100% | 1.0 | 1.0 |
| folego · retaliacao/critico/arcano | 100% | 0% | 6.5 | 12.5 |
| folego · retaliacao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| folego · retaliacao/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| folego · retaliacao/marca/arcano | 100% | 0% | 6.0 | 12.0 |
| folego · retaliacao/marca/controle | 100% | 0% | 4.5 | 9.5 |
| folego · retaliacao/marca/lumen | 100% | 100% | 1.0 | 1.0 |
| folego · retaliacao_tele/critico/arcano | 100% | 0% | 6.0 | 11.0 |
| folego · retaliacao_tele/critico/controle | 100% | 0% | 4.0 | 9.0 |
| folego · retaliacao_tele/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| folego · retaliacao_tele/marca/arcano | 100% | 0% | 4.5 | 9.5 |
| folego · retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| folego · retaliacao_tele/marca/lumen | 100% | 100% | 1.0 | 1.0 |
| muralha_r5 · guardiao/critico/arcano | 0% | 0% | — | — |
| muralha_r5 · guardiao/critico/controle | 100% | 0% | 9.0 | 14.0 |
| muralha_r5 · guardiao/critico/lumen | 100% | 17% | 2.0 | 5.0 |
| muralha_r5 · guardiao/marca/arcano | 0% | 0% | — | — |
| muralha_r5 · guardiao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| muralha_r5 · guardiao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| muralha_r5 · retaliacao/critico/arcano | 0% | 0% | — | — |
| muralha_r5 · retaliacao/critico/controle | 100% | 0% | 9.5 | 14.5 |
| muralha_r5 · retaliacao/critico/lumen | 100% | 0% | 2.0 | 5.0 |
| muralha_r5 · retaliacao/marca/arcano | 0% | 0% | — | — |
| muralha_r5 · retaliacao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| muralha_r5 · retaliacao/marca/lumen | 100% | 0% | 2.0 | 5.0 |
| muralha_r5 · retaliacao_tele/critico/arcano | 0% | 0% | — | — |
| muralha_r5 · retaliacao_tele/critico/controle | 83% | 0% | 10.0 | 15.0 |
| muralha_r5 · retaliacao_tele/critico/lumen | 100% | 50% | 1.5 | 3.0 |
| muralha_r5 · retaliacao_tele/marca/arcano | 0% | 0% | — | — |
| muralha_r5 · retaliacao_tele/marca/controle | 100% | 0% | 8.0 | 13.0 |
| muralha_r5 · retaliacao_tele/marca/lumen | 100% | 17% | 2.0 | 5.0 |
| poco_lumen · guardiao/critico/arcano | 0% | 0% | — | — |
| poco_lumen · guardiao/critico/controle | 100% | 0% | 7.5 | 13.0 |
| poco_lumen · guardiao/critico/lumen | 100% | 17% | 2.0 | 5.0 |
| poco_lumen · guardiao/marca/arcano | 67% | 0% | 10.0 | 15.0 |
| poco_lumen · guardiao/marca/controle | 100% | 0% | 7.5 | 13.0 |
| poco_lumen · guardiao/marca/lumen | 100% | 50% | 1.5 | 2.5 |
| poco_lumen · retaliacao/critico/arcano | 33% | 0% | 10.0 | 15.0 |
| poco_lumen · retaliacao/critico/controle | 100% | 0% | 7.0 | 13.0 |
| poco_lumen · retaliacao/critico/lumen | 100% | 67% | 1.0 | 1.0 |
| poco_lumen · retaliacao/marca/arcano | 100% | 0% | 9.5 | 14.5 |
| poco_lumen · retaliacao/marca/controle | 100% | 0% | 6.0 | 11.0 |
| poco_lumen · retaliacao/marca/lumen | 100% | 33% | 2.0 | 4.5 |
| poco_lumen · retaliacao_tele/critico/arcano | 83% | 0% | 9.0 | 14.0 |
| poco_lumen · retaliacao_tele/critico/controle | 100% | 0% | 6.5 | 12.0 |
| poco_lumen · retaliacao_tele/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| poco_lumen · retaliacao_tele/marca/arcano | 100% | 0% | 7.0 | 12.0 |
| poco_lumen · retaliacao_tele/marca/controle | 100% | 0% | 6.0 | 11.0 |
| poco_lumen · retaliacao_tele/marca/lumen | 100% | 83% | 1.0 | 1.0 |
| pocoes · guardiao/critico/arcano | 33% | 0% | 10.0 | 15.0 |
| pocoes · guardiao/critico/controle | 100% | 0% | 6.0 | 12.0 |
| pocoes · guardiao/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| pocoes · guardiao/marca/arcano | 100% | 0% | 8.0 | 13.0 |
| pocoes · guardiao/marca/controle | 100% | 0% | 6.0 | 12.0 |
| pocoes · guardiao/marca/lumen | 100% | 83% | 1.0 | 1.0 |
| pocoes · retaliacao/critico/arcano | 100% | 0% | 8.5 | 14.0 |
| pocoes · retaliacao/critico/controle | 100% | 0% | 5.0 | 10.0 |
| pocoes · retaliacao/critico/lumen | 100% | 67% | 1.0 | 1.0 |
| pocoes · retaliacao/marca/arcano | 100% | 0% | 6.5 | 12.5 |
| pocoes · retaliacao/marca/controle | 100% | 0% | 4.0 | 9.0 |
| pocoes · retaliacao/marca/lumen | 100% | 83% | 1.0 | 1.0 |
| pocoes · retaliacao_tele/critico/arcano | 100% | 0% | 7.5 | 13.0 |
| pocoes · retaliacao_tele/critico/controle | 100% | 0% | 5.0 | 10.0 |
| pocoes · retaliacao_tele/critico/lumen | 100% | 100% | 1.0 | 1.0 |
| pocoes · retaliacao_tele/marca/arcano | 100% | 0% | 7.0 | 13.0 |
| pocoes · retaliacao_tele/marca/controle | 100% | 0% | 4.0 | 9.0 |
| pocoes · retaliacao_tele/marca/lumen | 100% | 83% | 1.0 | 1.0 |
| veu_maior · guardiao/critico/arcano | 0% | 0% | — | — |
| veu_maior · guardiao/critico/controle | 100% | 0% | 9.0 | 14.0 |
| veu_maior · guardiao/critico/lumen | 100% | 17% | 2.0 | 5.0 |
| veu_maior · guardiao/marca/arcano | 0% | 0% | — | — |
| veu_maior · guardiao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| veu_maior · guardiao/marca/lumen | 100% | 33% | 2.0 | 5.0 |
| veu_maior · retaliacao/critico/arcano | 0% | 0% | — | — |
| veu_maior · retaliacao/critico/controle | 100% | 0% | 9.0 | 14.0 |
| veu_maior · retaliacao/critico/lumen | 100% | 50% | 1.5 | 3.0 |
| veu_maior · retaliacao/marca/arcano | 0% | 0% | — | — |
| veu_maior · retaliacao/marca/controle | 100% | 0% | 8.0 | 13.0 |
| veu_maior · retaliacao/marca/lumen | 100% | 17% | 2.0 | 5.0 |
| veu_maior · retaliacao_tele/critico/arcano | 0% | 0% | — | — |
| veu_maior · retaliacao_tele/critico/controle | 100% | 0% | 8.0 | 13.0 |
| veu_maior · retaliacao_tele/critico/lumen | 100% | 67% | 1.0 | 1.0 |
| veu_maior · retaliacao_tele/marca/arcano | 0% | 0% | — | — |
| veu_maior · retaliacao_tele/marca/controle | 100% | 0% | 8.0 | 13.0 |
| veu_maior · retaliacao_tele/marca/lumen | 100% | 100% | 1.0 | 1.0 |

## Comparação de variantes (sem cura = Íris fora da build Lúmen)

| Variante | Rota: cura | Rota: melhor sem cura | Sem cura com rota ≥ 50% | Tentativas: cura | Tentativas: melhor sem cura | Caminhos sem cura em ≤ 5 tentativas |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| base | 92% | 0% | 0/12 | 2.0 | 8.0 | 0/12 |
| cacada_burst | 92% | 0% | 0/12 | 2.0 | 8.0 | 0/12 |
| combinado | 100% | 0% | 0/12 | 1.0 | 4.0 | 6/12 (guardiao/critico/controle, guardiao/marca/controle, retaliacao/critico/controle, retaliacao/marca/controle…) |
| folego | 100% | 0% | 0/12 | 1.0 | 4.0 | 4/12 (retaliacao/marca/controle, retaliacao_tele/critico/controle, retaliacao_tele/marca/arcano, retaliacao_tele/marca/controle) |
| muralha_r5 | 92% | 0% | 0/12 | 2.0 | 8.0 | 0/12 |
| poco_lumen | 100% | 0% | 0/12 | 1.2 | 6.0 | 0/12 |
| pocoes | 100% | 0% | 0/12 | 1.0 | 4.0 | 4/12 (retaliacao/critico/controle, retaliacao/marca/controle, retaliacao_tele/critico/controle, retaliacao_tele/marca/controle) |
| veu_maior | 100% | 0% | 0/12 | 1.8 | 8.0 | 0/12 |

## Economia e loot na campanha (modelo canônico simplificado)

| Build | Ouro/tentativa | Resíduo/tentativa | Itens/tentativa | Itens equipados no fim | Resíduo total |
| --- | ---: | ---: | ---: | ---: | ---: |
| base · guardiao/critico/arcano | 136 | 10.0 | 3.0 | 13 | 102 |
| base · guardiao/critico/controle | 228 | 12.0 | 4.0 | 15 | 119 |
| base · guardiao/critico/lumen | 360 | 13.0 | 4.5 | 6 | 28 |
| base · guardiao/marca/arcano | 221 | 12.0 | 3.5 | 14 | 115 |
| base · guardiao/marca/controle | 225 | 12.0 | 4.0 | 14 | 112 |
| base · guardiao/marca/lumen | 360 | 13.0 | 5.0 | 6 | 26 |
| base · retaliacao/critico/arcano | 215 | 12.0 | 4.0 | 13 | 116 |
| base · retaliacao/critico/controle | 225 | 11.0 | 4.0 | 12 | 111 |
| base · retaliacao/critico/lumen | 367 | 13.0 | 4.0 | 6 | 26 |
| base · retaliacao/marca/arcano | 221 | 12.0 | 3.0 | 14 | 114 |
| base · retaliacao/marca/controle | 234 | 12.0 | 4.0 | 12 | 96 |
| base · retaliacao/marca/lumen | 356 | 13.0 | 5.0 | 7 | 26 |
| base · retaliacao_tele/critico/arcano | 217 | 11.0 | 3.0 | 14 | 107 |
| base · retaliacao_tele/critico/controle | 225 | 12.0 | 4.0 | 12 | 116 |
| base · retaliacao_tele/critico/lumen | 500 | 13.0 | 4.0 | 5 | 24 |
| base · retaliacao_tele/marca/arcano | 220 | 11.5 | 4.0 | 12 | 117 |
| base · retaliacao_tele/marca/controle | 230 | 12.0 | 4.0 | 14 | 110 |
| base · retaliacao_tele/marca/lumen | 481 | 13.0 | 5.0 | 5 | 25 |
| cacada_burst · guardiao/critico/arcano | 138 | 10.0 | 4.0 | 12 | 100 |
| cacada_burst · guardiao/critico/controle | 228 | 12.0 | 4.0 | 15 | 119 |
| cacada_burst · guardiao/critico/lumen | 360 | 13.0 | 4.5 | 6 | 28 |
| cacada_burst · guardiao/marca/arcano | 218 | 11.5 | 3.0 | 14 | 115 |
| cacada_burst · guardiao/marca/controle | 226 | 12.0 | 4.0 | 12 | 116 |
| cacada_burst · guardiao/marca/lumen | 357 | 12.0 | 4.0 | 6 | 22 |
| cacada_burst · retaliacao/critico/arcano | 218 | 12.0 | 3.5 | 14 | 114 |
| cacada_burst · retaliacao/critico/controle | 225 | 11.0 | 4.0 | 12 | 111 |
| cacada_burst · retaliacao/critico/lumen | 367 | 13.0 | 4.0 | 6 | 26 |
| cacada_burst · retaliacao/marca/arcano | 220 | 12.0 | 4.0 | 13 | 114 |
| cacada_burst · retaliacao/marca/controle | 230 | 12.0 | 3.5 | 11 | 98 |
| cacada_burst · retaliacao/marca/lumen | 360 | 13.0 | 5.0 | 6 | 28 |
| cacada_burst · retaliacao_tele/critico/arcano | 218 | 11.0 | 4.0 | 14 | 112 |
| cacada_burst · retaliacao_tele/critico/controle | 225 | 12.0 | 4.0 | 12 | 116 |
| cacada_burst · retaliacao_tele/critico/lumen | 500 | 13.0 | 4.0 | 5 | 24 |
| cacada_burst · retaliacao_tele/marca/arcano | 224 | 11.5 | 4.0 | 12 | 118 |
| cacada_burst · retaliacao_tele/marca/controle | 226 | 12.0 | 4.0 | 12 | 96 |
| cacada_burst · retaliacao_tele/marca/lumen | 516 | 13.0 | 4.0 | 5 | 17 |
| combinado · guardiao/critico/arcano | 235 | 13.0 | 4.0 | 13 | 116 |
| combinado · guardiao/critico/controle | 238 | 13.0 | 4.0 | 10 | 54 |
| combinado · guardiao/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| combinado · guardiao/marca/arcano | 234 | 13.0 | 4.0 | 12 | 90 |
| combinado · guardiao/marca/controle | 238 | 13.0 | 4.0 | 10 | 62 |
| combinado · guardiao/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| combinado · retaliacao/critico/arcano | 228 | 13.0 | 4.0 | 12 | 106 |
| combinado · retaliacao/critico/controle | 235 | 13.0 | 5.0 | 10 | 50 |
| combinado · retaliacao/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| combinado · retaliacao/marca/arcano | 235 | 13.0 | 4.0 | 12 | 90 |
| combinado · retaliacao/marca/controle | 235 | 13.0 | 4.5 | 9 | 48 |
| combinado · retaliacao/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| combinado · retaliacao_tele/critico/arcano | 233 | 13.0 | 4.0 | 12 | 94 |
| combinado · retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 10 | 52 |
| combinado · retaliacao_tele/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| combinado · retaliacao_tele/marca/arcano | 234 | 13.0 | 4.0 | 10 | 80 |
| combinado · retaliacao_tele/marca/controle | 238 | 13.0 | 5.0 | 10 | 56 |
| combinado · retaliacao_tele/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| folego · guardiao/critico/arcano | 228 | 13.0 | 4.0 | 13 | 114 |
| folego · guardiao/critico/controle | 233 | 13.0 | 5.0 | 12 | 87 |
| folego · guardiao/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| folego · guardiao/marca/arcano | 233 | 13.0 | 4.0 | 12 | 106 |
| folego · guardiao/marca/controle | 237 | 13.0 | 4.0 | 10 | 74 |
| folego · guardiao/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| folego · retaliacao/critico/arcano | 234 | 13.0 | 4.0 | 13 | 81 |
| folego · retaliacao/critico/controle | 237 | 13.0 | 4.0 | 12 | 78 |
| folego · retaliacao/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| folego · retaliacao/marca/arcano | 235 | 13.0 | 4.0 | 12 | 81 |
| folego · retaliacao/marca/controle | 237 | 13.0 | 5.0 | 10 | 58 |
| folego · retaliacao/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| folego · retaliacao_tele/critico/arcano | 234 | 13.0 | 4.0 | 10 | 76 |
| folego · retaliacao_tele/critico/controle | 237 | 13.0 | 5.0 | 11 | 54 |
| folego · retaliacao_tele/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| folego · retaliacao_tele/marca/arcano | 238 | 13.0 | 4.0 | 10 | 58 |
| folego · retaliacao_tele/marca/controle | 237 | 13.0 | 5.0 | 10 | 54 |
| folego · retaliacao_tele/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| muralha_r5 · guardiao/critico/arcano | 223 | 11.0 | 4.0 | 12 | 114 |
| muralha_r5 · guardiao/critico/controle | 230 | 12.0 | 4.0 | 12 | 106 |
| muralha_r5 · guardiao/critico/lumen | 481 | 13.0 | 4.0 | 5 | 24 |
| muralha_r5 · guardiao/marca/arcano | 220 | 12.0 | 4.0 | 14 | 119 |
| muralha_r5 · guardiao/marca/controle | 230 | 12.0 | 4.0 | 14 | 92 |
| muralha_r5 · guardiao/marca/lumen | 360 | 13.0 | 4.5 | 5 | 26 |
| muralha_r5 · retaliacao/critico/arcano | 218 | 12.0 | 4.0 | 14 | 116 |
| muralha_r5 · retaliacao/critico/controle | 224 | 12.0 | 4.0 | 13 | 109 |
| muralha_r5 · retaliacao/critico/lumen | 360 | 13.0 | 5.0 | 6 | 28 |
| muralha_r5 · retaliacao/marca/arcano | 220 | 12.0 | 3.0 | 13 | 113 |
| muralha_r5 · retaliacao/marca/controle | 230 | 13.0 | 4.0 | 12 | 104 |
| muralha_r5 · retaliacao/marca/lumen | 356 | 13.0 | 5.5 | 7 | 26 |
| muralha_r5 · retaliacao_tele/critico/arcano | 218 | 11.5 | 3.0 | 13 | 112 |
| muralha_r5 · retaliacao_tele/critico/controle | 225 | 11.0 | 4.0 | 12 | 112 |
| muralha_r5 · retaliacao_tele/critico/lumen | 522 | 13.0 | 6.0 | 5 | 18 |
| muralha_r5 · retaliacao_tele/marca/arcano | 220 | 11.5 | 3.5 | 11 | 112 |
| muralha_r5 · retaliacao_tele/marca/controle | 225 | 12.0 | 4.0 | 14 | 97 |
| muralha_r5 · retaliacao_tele/marca/lumen | 481 | 13.0 | 5.0 | 5 | 25 |
| poco_lumen · guardiao/critico/arcano | 226 | 12.0 | 4.0 | 12 | 121 |
| poco_lumen · guardiao/critico/controle | 235 | 13.0 | 4.0 | 12 | 96 |
| poco_lumen · guardiao/critico/lumen | 481 | 13.0 | 5.0 | 6 | 24 |
| poco_lumen · guardiao/marca/arcano | 228 | 13.0 | 4.0 | 14 | 124 |
| poco_lumen · guardiao/marca/controle | 232 | 12.0 | 4.0 | 13 | 91 |
| poco_lumen · guardiao/marca/lumen | 495 | 13.0 | 6.0 | 5 | 18 |
| poco_lumen · retaliacao/critico/arcano | 232 | 12.0 | 4.0 | 12 | 120 |
| poco_lumen · retaliacao/critico/controle | 234 | 13.0 | 4.0 | 12 | 92 |
| poco_lumen · retaliacao/critico/lumen | 529 | 13.5 | 6.0 | 4 | 14 |
| poco_lumen · retaliacao/marca/arcano | 228 | 12.0 | 4.0 | 13 | 116 |
| poco_lumen · retaliacao/marca/controle | 232 | 13.0 | 4.0 | 12 | 70 |
| poco_lumen · retaliacao/marca/lumen | 511 | 13.0 | 4.5 | 5 | 22 |
| poco_lumen · retaliacao_tele/critico/arcano | 220 | 12.0 | 4.0 | 12 | 108 |
| poco_lumen · retaliacao_tele/critico/controle | 232 | 13.0 | 4.0 | 12 | 86 |
| poco_lumen · retaliacao_tele/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| poco_lumen · retaliacao_tele/marca/arcano | 216 | 11.0 | 4.0 | 10 | 80 |
| poco_lumen · retaliacao_tele/marca/controle | 232 | 13.0 | 4.0 | 10 | 74 |
| poco_lumen · retaliacao_tele/marca/lumen | 568 | 13.0 | 5.0 | 4 | 14 |
| pocoes · guardiao/critico/arcano | 228 | 13.0 | 4.0 | 13 | 125 |
| pocoes · guardiao/critico/controle | 236 | 13.0 | 4.0 | 12 | 80 |
| pocoes · guardiao/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| pocoes · guardiao/marca/arcano | 227 | 13.0 | 4.0 | 12 | 108 |
| pocoes · guardiao/marca/controle | 238 | 13.0 | 4.0 | 10 | 74 |
| pocoes · guardiao/marca/lumen | 522 | 13.0 | 6.0 | 4 | 14 |
| pocoes · retaliacao/critico/arcano | 227 | 13.0 | 4.0 | 14 | 108 |
| pocoes · retaliacao/critico/controle | 238 | 13.0 | 4.0 | 10 | 66 |
| pocoes · retaliacao/critico/lumen | 529 | 13.5 | 6.0 | 4 | 14 |
| pocoes · retaliacao/marca/arcano | 233 | 13.0 | 4.0 | 12 | 83 |
| pocoes · retaliacao/marca/controle | 237 | 13.0 | 4.0 | 9 | 49 |
| pocoes · retaliacao/marca/lumen | 522 | 14.0 | 6.0 | 4 | 14 |
| pocoes · retaliacao_tele/critico/arcano | 228 | 13.0 | 3.5 | 12 | 98 |
| pocoes · retaliacao_tele/critico/controle | 238 | 13.0 | 4.0 | 12 | 67 |
| pocoes · retaliacao_tele/critico/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
| pocoes · retaliacao_tele/marca/arcano | 233 | 13.0 | 4.0 | 12 | 86 |
| pocoes · retaliacao_tele/marca/controle | 238 | 13.0 | 4.0 | 9 | 50 |
| pocoes · retaliacao_tele/marca/lumen | 539 | 14.0 | 6.0 | 4 | 14 |
| veu_maior · guardiao/critico/arcano | 136 | 10.0 | 3.0 | 13 | 102 |
| veu_maior · guardiao/critico/controle | 233 | 12.0 | 4.0 | 13 | 104 |
| veu_maior · guardiao/critico/lumen | 481 | 13.0 | 5.0 | 6 | 26 |
| veu_maior · guardiao/marca/arcano | 221 | 12.0 | 3.5 | 14 | 115 |
| veu_maior · guardiao/marca/controle | 230 | 12.0 | 4.0 | 13 | 98 |
| veu_maior · guardiao/marca/lumen | 488 | 13.5 | 5.0 | 5 | 25 |
| veu_maior · retaliacao/critico/arcano | 215 | 12.0 | 4.0 | 13 | 116 |
| veu_maior · retaliacao/critico/controle | 232 | 12.0 | 4.0 | 12 | 103 |
| veu_maior · retaliacao/critico/lumen | 496 | 14.0 | 6.0 | 4 | 20 |
| veu_maior · retaliacao/marca/arcano | 221 | 12.0 | 3.0 | 14 | 114 |
| veu_maior · retaliacao/marca/controle | 232 | 13.0 | 4.0 | 12 | 105 |
| veu_maior · retaliacao/marca/lumen | 481 | 13.0 | 5.0 | 6 | 26 |
| veu_maior · retaliacao_tele/critico/arcano | 217 | 11.0 | 3.0 | 14 | 107 |
| veu_maior · retaliacao_tele/critico/controle | 234 | 11.0 | 4.0 | 10 | 92 |
| veu_maior · retaliacao_tele/critico/lumen | 529 | 13.5 | 5.5 | 4 | 15 |
| veu_maior · retaliacao_tele/marca/arcano | 220 | 11.5 | 4.0 | 12 | 117 |
| veu_maior · retaliacao_tele/marca/controle | 230 | 12.0 | 4.0 | 12 | 96 |
| veu_maior · retaliacao_tele/marca/lumen | 545 | 13.5 | 6.0 | 4 | 14 |
