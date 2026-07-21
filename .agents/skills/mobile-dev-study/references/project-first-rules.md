# Project-First Rules — Mobile Development Details and Principles

Reference file for `mobile-dev-study`. Details the core Project-First rules (Rules 13–20) adapted for mobile application development across React Native, Flutter, Kotlin, and Swift.

---

## Rule 13: Nested Prerequisites (Prohibition of Isolated Fundamentals)

### Principle

All basic theoretical, syntax, component, and state concepts live **inside** the practical module that requires them under `prerequisites/`, never as an isolated directory at the root.

### Structure

```
.planning/phases/fase-XX-[nome-da-fase]/{MXX-slug}/
├── CONTEXT.md
├── UI-SPEC.md
├── RESEARCH.md
├── MISSAO.md
└── prerequisites/
    ├── [concept-folder-1]/
    │   ├── [concept-note-1].md
    │   └── [concept-note-2].md
    └── [concept-folder-2]/
        └── [concept-note-3].md
```

### Prerequisites Content Boundary

A prerequisite file teaches **building blocks** — the individual primitives a student needs to reason with (e.g., how a hook manages local state, how a flexbox container layout works, how a URL request handles async response headers). It must **NEVER assemble those pieces into the completed app feature component**.

#### ✅ Correct — teach the building block primitive

```markdown
## React Native: Handling Local Input State with useState
The `useState` hook holds mutable local state:
  const [text, setText] = useState('');

To update state based on input:
  <TextInput value={text} onChangeText={setText} />
```

#### ❌ Forbidden — assembled feature component inside a prerequisite

```markdown
## Complete LoginForm Component
Here is the full code for your LoginForm screen with validation and API call:
  export const LoginForm = () => { ... full code ... }
```

> 🔴 **Rule**: If removing the prerequisite content would allow the student to complete the feature by copy-pasting, that content DOES NOT belong in a prerequisite. Explain the hook. Explain the component lifecycle. Do not build the feature screen.

---

## Rule 14: Direct Codebase Implementation (No Separate Automation Directory)

### Principle

The student builds the application features directly within the main mobile app codebase (`src/`, `lib/`, `app/`). There is **NO separate `automacao-e-scripts/` directory**.

- The project itself IS the implementation codebase.
- Custom state helpers, utility functions, services, and unit/E2E test files belong directly in the project source tree (e.g. `src/services/`, `lib/widgets/`, `app/src/main/`).
- No auxiliary script directories are created outside the project codebase.

---

## Rule 15: Mandatory Retake Bridges

### Principle

Every task in the `MISSAO.md` checklist MUST have its prerequisites listed inline with Obsidian links pointing to the specific prerequisite file in `prerequisites/`.

### Format in MISSAO.md

```markdown
- [ ] Implementar a tela de login com validação de formulário
  - Pré-requisitos: [[prerequisites/state-management/use-state-mechanics.md|useState Mechanics]], [[prerequisites/ui-components/text-input-handling.md|TextInput Handling]]
```

### Format in Post-Feature Walkthrough (`[XX].[Y]-[slug].md`)

```markdown
### 🔗 Retake Bridges

Se você encontrou dificuldades na implementação deste componente, revise os conceitos-chave:
- [[../prerequisites/state-management/use-state-mechanics.md|useState Mechanics]]
```

---

## Rule 16: Master Panel by App Feature Objectives

### Principle

The `README_[APP].md` is structured by **real Mobile Application Features / Milestones**, not by theoretical academic chapters.

### Examples of Feature Objectives

| Objective | Description | Target Component/Screen |
|---|---|---|
| **Objective 1: User Authentication** | Build secure login, signup, and session persistence | `LoginScreen`, `AuthRepository` |
| **Objective 2: Feed & Pagination** | Render dynamic list with infinite scroll & pull-to-refresh | `FeedScreen`, `UseFeedList` |
| **Objective 3: Offline Storage & Sync** | Persist data locally and sync when online | `LocalDatabase`, `SyncWorker` |

---

## Rule 17: Dynamic Integration with Real Mobile App Specifications

### Principle

Checklists contain targets of **specific user stories, UI components, and acceptance criteria** — never passive reading.

### Sourcing Priority for Mobile Features

1. **User Story & Acceptance Criteria** — Primary source defined in `UI-SPEC.md` / `CONTEXT.md`.
2. **Standard Mobile UI Design Specs** — Mobile layout patterns (Material 3 for Android, Human Interface Guidelines for iOS).
3. **Official Documentation & Native APIs** — Context7 docs for official API usage.

---

## Rule 18: Single Entry Point (Anti-Overwhelm)

### Principle

The first deliverable to the student is `MISSAO.md` + the full `prerequisites/` directory (conceptual theory for ALL sub-tasks in scope). No `[XX].[Y]-[slug].md` post-feature walkthrough files or `README_[APP].md` are generated until the student reports completing or attempting the feature.

**Generation Order:**
1. **Phase 1**: Generate `CONTEXT.md` & `UI-SPEC.md` (Scope & UI contract)
2. **Phase 2**: Generate `RESEARCH.md` (Subagent research)
3. **Phase 3**: Generate `MISSAO.md` + `prerequisites/` (First student-facing deliverable)

---

## Rule 19: Multi-Stack Architecture-First Boundary

### Principle

Prerequisite files explain isolated concepts, architecture patterns, and primitives. They must be highly technical, objective, and adaptable to the user's stack:

1. **React Native (TypeScript)**
2. **Flutter (Dart)**
3. **Kotlin Native (Jetpack Compose)**
4. **Swift Native (SwiftUI)**

Structure prerequisite notes using the **4 Essential Pillars**:
1. **📋 Technical Definition & Mechanics (Core Concept)**
2. **📱 Code Primitives & UI Layout Syntax**
3. **🎯 State Flow & Execution Lifecycle**
4. **🧪 Edge Cases, Memory Management & Best Practices**

---

## Rule 20: Anti-Solution-Leak Enforcement

### Mandatory Gates (P0)

Every prerequisite note generated must pass these 4 tests before being written:

1. **Verbatim Code Test:** Can a student copy-paste any code snippet directly into their screen component and solve the feature? If YES → remove it. Teach the building blocks, not the completed screen.
2. **Feature Fingerprint Test:** Does the file use exact variable names, API endpoints, or business domain keys unique to the student's app project? If YES → replace with generic neutral names (e.g. `userProfile` instead of `userAccountDto_v2`).
3. **Value Leak Test:** Does the note hardcode specific business logic conditions or dummy flags that solve the feature requirement? If YES → neutralise.
4. **Assembly Chain Test:** Does the note connect multiple hooks, controllers, and UI views in the exact sequence required by the app feature? If YES → separate them into isolated prerequisite notes.
