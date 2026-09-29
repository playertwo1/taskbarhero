# Estratégia de Testes do Pocket Hero

---

## 1. Pirâmide e Tipos de Testes

```text
                  / \
                 /   \       SOAK & STRESS (Sessões de 8h+ no Android, detecção de memory leaks)
                /  M  \      JORNADAS MAESTRO (FTUE, navegação de menus, fechamento/retomada)
               /   I   \     SIMULADORES HEADLESS (matrizes de bosses, builds e drops)
              /    N    \    INTEGRAÇÃO POR CENAS GODOT (sinais, UI e fluxo)
             /     G     \   TESTES HEADLESS (dano, XP, perfis, persistência, fórmulas)
            /─────────────\
```

---

## 2. Matriz de Escolha de Ferramentas

| Pergunta de Validação | Primeira Ferramenta | Segunda Ferramenta |
| :--- | :--- | :--- |
| A fórmula de combate/XP está correta? | Cena de teste Godot headless | Cálculo reproduzível |
| O fluxo de nós e sinais da cena funciona? | Cena de integração Godot | Teste manual direcionado |
| O APK real abre e renderiza no Android? | Maestro CLI / MCP | Android CLI |
| O botão está acessível e clicável no celular? | Maestro Screenshot | Screen Resolve |
| A taxa de drop e o balanceamento são saudáveis? | Simulador Headless | Argos Analyst |
| Existe exploit de repetição ou corrida de estado? | Argos Exploit Hunter | State Snapshot Diff |
| O jogo degrada memória após horas de execução? | Argos Soak Profile | Godot Profiler |
| O jogo é divertido e tem bom ritmo? | Humano (Rafael) | Métricas como apoio |

Comandos vigentes: `python tools/run_godot_tests.py`, `python tools/balance/validate_balance_data.py` e `python tools/argos/run.py --scenario <id>`. GdUnit4, Maestro, soak Android e perfis visuais permanecem planejados até seus gates específicos.
