# Synthesis & Output — Phase 3 Project-First (GSD Integrated)

Reference file for `mobile-dev-study`. Contains Phase 3 synthesis workflow: directory structure, sub-topic file format, index file, and master panel — all structured around the Project-First approach.

---

## 3.1 Output Contract — Two-Layer Incremental Delivery

Synthesize subagent research into the **minimum viable first delivery**.

### Layer 1 — Immediate Delivery (Always Generated First)

Path: `.planning/phases/fase-XX-[nome-da-fase]/{MXX-slug}/`

```
.planning/phases/fase-XX-[nome-da-fase]/{MXX-slug}/
├── CONTEXT.md
├── UI-SPEC.md
├── RESEARCH.md
├── MISSAO.md
└── prerequisites/   ← específicos para todas as sub-tasks da feature
```

### Template for `MISSAO.md`

```markdown
# MISSAO
🎯 Missão [XX]: [Nome do Objetivo da Feature]

Bem-vindo ao Módulo [XX] - [Tema da Feature].
O seu objetivo principal é: **[Descrição do objetivo do aplicativo em 1 frase]**

📱 Features & Componentes da Missão

- [ ] [Nome da Feature / Componente 1] — [Stack / Camada (ex: UI Screen)]
  - Pré-requisitos: [[prerequisites/[pasta-do-conceito]/[arquivo].md|Nome do Conceito 1]]
- [ ] [Nome da Feature / Componente 2] — [Stack / Camada (ex: State / ViewModel)]
  - Pré-requisitos: [[prerequisites/[pasta-a]/[arquivo-a].md|Nome do Conceito A]], [[prerequisites/[pasta-b]/[arquivo-b].md|Nome do Conceito B]]

🧠 Questões de Orientação

Antes de escrever qualquer código no seu app, abra o seu editor e responda mentalmente:
1. "Qual estado essa tela precisa refletir e qual evento altera esse estado?"
2. "Como os componentes visuais estão organizados na hierarquia de layout?"
3. "Qual a responsabilidade desta camada e onde o efeito colateral deve ser tratado?"

Abriu a IDE? Comece a implementação da feature no codebase do app. Quando travar ou concluir, me avise!
```

---

### Layer 2 — Generated On Demand Only

Generated ONLY after the student reports completing or attempting the feature:

```
├── [XX].[Y]-[slug].md       ← apenas após o aluno tentar/concluir a feature
└── README_[APP].md          ← apenas após todas as features do marco serem concluídas
```

| File/Folder | Trigger |
|---|---|
| `[XX].[Y]-[slug].md` | Aluno relata avanço ou conclusão da feature |
| `README_[APP].md` | Todas as features do roadmap/marco concluídas |

---

## 3.2 Sub-topic File Structure (Post-Feature Walkthrough)

Lightweight format (4 sections):

1. **Conceito Consolidado** — 2-3 frases de resumo sobre o componente/padrão implementado.
2. **Raciocínio & Arquitetura** — Análise da decisão técnica:
   - **Causa Raiz & Motivação** — Por que esta estrutura de estado/componente foi escolhida.
   - **Cadeia de Decisão** — Passo a passo do raciocínio ("percebi X → estruturei Y → resultado Z").
   - **Sinal de Reconhecimento** — Checklist mental de smells para identificar o mesmo padrão em telas futuras.
3. **Cheat Sheet / Referência Rápida** — Snippets genéricos e cópia limpa de assinaturas.
4. **Próximos Passos (Checklist)** — Próximos componentes do app no roadmap.

---

## 3.3 Prerequisite File Structure (Pre-Feature)

Prerequisite files MUST NOT leak the assembled feature code. They follow the 4 Essential Pillars:

1. **Título Principal** (ex: `# Gerenciamento de Estado Reativo com StateFlow`)
2. **Definição e Mecânica (Conceito Core)** — Explicação técnica do ciclo de vida e estado.
3. **Sintaxe & Estrutura Primitiva** — Snippets genéricos em mock/neutral domains.
4. **Fluxo de Teste Manual, Tratameno de Erros & Remediação** — Boas práticas de memória e concorrência.

---

## 🔴 Regra de Idioma

- Todos os arquivos finais entregues ao aluno (`MISSAO.md`, `prerequisites/*.md`, `[XX].[Y]-[slug].md`) devem ser escritos exclusivamente em **Português (BR)** na segunda pessoa ("você").
- Arquivos intermediários de planejamento e pesquisa (`CONTEXT.md`, `UI-SPEC.md`, `RESEARCH.md`) são escritos em **Inglês**.
