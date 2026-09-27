# Pocket Hero — Checklist de QA e Auditoria Visual de Sprites

**Status:** DECIDIDO (FASE R7)  
**Versão:** 1.0.0  
**Responsável pela Auditoria:** Têmis (Auditora Independente) / Agente de QA  
**Alvo:** Todos os assets candidatos antes da integração no Godot  

---

## 1. QA Técnico (Verificação Objetiva)

Qualquer reprovação nesta etapa resulta em **FAIL** automático sem necessidade de análise estética:

- [ ] **1.1 Dimensões Exatas:** A resolução de cada frame coincide com o contrato (ex.: 32×32, 48×48 ou 64×64)? Sem dimensões arbitrárias ou redimensionamentos com interpolação.
- [ ] **1.2 Transparência Perfeita:** O canal Alpha dos pixels de fundo é estritamente `0`? Não existem "halos" semitransparentes, ruído cinza ou pixels borrados na borda da silhueta.
- [ ] **1.3 Contagem de Frames:** Todas as animações do contrato estão presentes com a contagem exata de frames (`idle: 4`, `attack: 4-6`, `hit: 2`, `death: 4-6`)?
- [ ] **1.4 Conformidade da Paleta:** O número total de cores está dentro do limite do contrato (máx. 16 a 24 cores) e todos os tons pertencem às rampas de [`PALETTE.md`](./PALETTE.md)?
- [ ] **1.5 Nomenclatura e Estrutura:** Os arquivos seguem a convenção canônica definida em [`SPRITE_STANDARD.md`](./SPRITE_STANDARD.md)?
- [ ] **1.6 Baseline Respeitada:** O ponto de apoio no solo coincide com a linha base designada (Y=29 para 32×32; Y=44 para 48×48)? O personagem não está "flutuando" nem "afundado".

---

## 2. QA Visual & Artístico (Auditoria de Estilo)

Avaliação de conformidade com a [`ART_DIRECTION.md`](./ART_DIRECTION.md):

- [ ] **2.1 Teste de Silhueta:** Preenchendo a silhueta com preto sólido, a forma e ação da criatura/herói continuam distinguíveis e legíveis?
- [ ] **2.2 Fonte de Luz Unificada:** A iluminação principal vem claramente do **alto à esquerda (~45°)** em todos os frames?
- [ ] **2.3 Qualidade dos Clusters de Pixels:**
  - Sem *jaggies* grosseiros em linhas diagonais.
  - Sem *doubles* desnecessários (pixels duplicados em cantos).
  - Sem *pillow-shading* (o centro não é clareado artificialmente sem considerar o volume).
  - Sem ruído de pixels isolados (estilo *dither* caótico ou confete).
- [ ] **2.4 Legibilidade Mobile 1×:** A miniatura do sprite é imediatamente compreensível quando visualizada na proporção real da tela de um smartphone (faixa inferior de ~220px)?
- [ ] **2.5 Fluidez e Peso da Animação:**
  - `idle`: ciclo orgânico e suave sem quebras bruscas.
  - `attack`: impacto visível com antecipação e recuperação rápida.
  - `hit`: sensação de impacto e reação física clara.
  - `death`: transição de derrota satisfatória e definitiva.
- [ ] **2.6 Originalidade Estrita:** O asset não replica silhueta, paleta ou elementos visuais de *Task Bar Hero* ou outros jogos comerciais.

---

## 3. Emissão de Veredito

Ao final da inspeção, a auditoria deve emitir um dos três pareceres formais:

```text
VEREDITO: [PASS | FAIL | ESCALATE]
EVIDÊNCIAS:
- [Item auditado]: [Evidência observada]
AÇÃO RECOMENDADA:
- Se PASS: Liberar para integração no Godot (Ergane).
- Se FAIL: Devolver para Daedalus com apontamento cirúrgico dos pixels/frames a corrigir.
- Se ESCALATE: Bloquear e submeter a Rafael se houver contradição de design ou escopo.
```
