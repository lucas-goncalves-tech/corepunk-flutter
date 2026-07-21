# Workflow Phases — Research & Decomposition (GSD Integrated)

Reference file for `mobile-dev-study`. Contains Phase 1 (GSD Context & Spec Generation) and Phase 2 (Parallel Research) workflows.

> [!IMPORTANT]
> ## Responsible Agent Configuration
> The agent responsible for executing all phases, tasks, and subagent orchestration in this skill is **`mobile-dev-tutor`**.

---

## Phase 0: Output Path Resolution (Runs Before Phase 1)

1. Resolve the workspace root containing `.planning/`.
2. Read the requested module entry and parent phase heading from `.planning/ROADMAP.md`.
3. Derive the phase name slug (e.g. `fase-01-auth`) and module slug (e.g. `m02-jwt-login`).
4. Compose output path: `.planning/phases/fase-XX-[nome-da-fase]/{MXX-slug}/`
5. Announce to user: `📁 Output path: {composed path}`

---

## Phase 1: GSD Context & Spec Generation

Use `sequentialthinking` via `call_mcp_tool` to reason about the mobile feature scope in English, then write the GSD specification contracts in the output directory:

### Artifacts to Create in `.planning/phases/fase-XX-[nome]/{MXX-slug}/`:

#### 1. `CONTEXT.md`
Write markdown file containing:
- **Feature Objective**: Single sentence goal of the mobile app module.
- **Target Stack**: User's chosen stack (React Native, Flutter, Kotlin, or Swift).
- **Scope Boundary**: In-scope components vs out-of-scope items.
- **Subagent Roles**: Brief overview of subagents A, B, C, D.

#### 2. `UI-SPEC.md`
Write markdown file containing:
- **UI Layout Requirements**: Screens, components, layout hierarchy, navigation flow.
- **State Management Contract**: Expected state properties, reactive data flows.
- **Acceptance Criteria**: Functional criteria required to mark the feature complete.

---

## Phase 2: Parallel Research & Subagent Orchestration

Launch 4 subagents in parallel via `invoke_subagent`. Each subagent outputs its findings in English to a consolidated GSD `RESEARCH.md` file (or scratch research files).

### 1. Main AI — Workspace Skill Scanner
- Scans available workspace skills to avoid duplicating concepts.
- Saves report to: `.agents/scratch/research/[module_slug]_workspace_skills.md`

### 2. Parallel Subagents

#### Subagent A — Feature Hunter (research subagent)
- **Prompt SCOPE:** `SCOPE: Only module [MXX] — [module name]. Do NOT expand to other modules.`
- **Task:** Analyzes user stories, acceptance criteria, UI components, and API specs for the feature.
- **Output:** Formatted list of feature sub-tasks and acceptance requirements.
- **Save to:** `.agents/scratch/research/[module_slug]_features.md`

#### Subagent B — Blocker Extractor (research subagent)
- **Prompt SCOPE:** `SCOPE: Only module [MXX] — [module name].`
- **Task:** Identifies exact sticking points for beginners in mobile dev (e.g., state re-render loops, unhandled promise rejections, memory leaks in subscriptions, lifecycle misconfiguration).
- **Output:** Sticking points and minimal unlocking concepts for each feature task.
- **Save to:** `.agents/scratch/research/[module_slug]_blockers.md`

#### Subagent C — Context7 Documentation Lookup (self subagent — needs MCP)
- **Prompt SCOPE:** `SCOPE: Only module [MXX] — [module name].`
- **Task:** Uses `resolve-library-id` and `query-docs` to fetch official API documentation for React Native, Flutter, Jetpack Compose, SwiftUI, Navigation, or State libraries.
- **Output:** Syntax excerpts, method signatures, and CLI commands.
- **Save to:** `.agents/scratch/research/[module_slug]_context7_docs.md`

#### Subagent D — Modern Mobile Architecture Specialist (research subagent)
- **Prompt SCOPE:** `SCOPE: Only module [MXX] — [module name].`
- **Task:** Researches modern architecture patterns (MVVM, Clean Arch, Repository pattern) and deprecations (legacy class components, unencrypted storage, deprecated navigation methods).
- **Output:** Modern pattern guidelines and refactoring recommendations.
- **Save to:** `.agents/scratch/research/[module_slug]_modern_standards.md`

---

## Phase 3: Consolidated GSD `RESEARCH.md`

Before moving to Phase 3 synthesis, compile all subagent findings into `.planning/phases/fase-XX-[nome]/{MXX-slug}/RESEARCH.md`.
