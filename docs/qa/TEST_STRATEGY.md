# Estratégia de Testes do Pocket Hero

---

## 1. Pirâmide e Tipos de Testes

```text
                  / \
                 /   \       SOAK & STRESS (Sessões de 8h+ no Android, detecção de memory leaks)
                /  M  \      JORNADAS MAESTRO (FTUE, navegação de menus, fechamento/retomada)
               /   I   \     SIMULADORES MASSIVOS (10k-100k runs de bosses e drops)
              /    N    \    INTEGRAÇÃO SCENE RUNNER (BattleStrip, sinais, UI binding)
             /     G     \   TESTES UNITÁRIOS GDUNIT4 (Cálculo de dano, XP, persistência, fórmulas)
            /─────────────\
```

---

## 2. Matriz de Escolha de Ferramentas

| Pergunta de Validação | Primeira Ferramenta | Segunda Ferramenta |
| :--- | :--- | :--- |
| A fórmula de combate/XP está correta? | GdUnit4 Unit Test | Teste manual |
| O fluxo de nós e sinais da cena funciona? | GdUnit4 Scene Runner | Headless Runner |
| O APK real abre e renderiza no Android? | Maestro CLI / MCP | Android CLI |
| O botão está acessível e clicável no celular? | Maestro Screenshot | Screen Resolve |
| A taxa de drop e o balanceamento são saudáveis? | Simulador Headless | Argos Analyst |
| Existe exploit de repetição ou corrida de estado? | Argos Exploit Hunter | State Snapshot Diff |
| O jogo degrada memória após horas de execução? | Argos Soak Profile | Godot Profiler |
| O jogo é divertido e tem bom ritmo? | Humano (Rafael) | Métricas como apoio |
