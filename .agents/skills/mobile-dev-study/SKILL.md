---
name: mobile-dev-study
description: "Personal study assistant for mobile application development (React Native, Flutter, Kotlin, Swift) using a Project-First approach integrated with GSD, managed and executed by the mobile-dev-tutor agent."
when_to_use: "When the user asks to study mobile development, plan an app feature, or build a mobile course module."
allowed-tools: Read, Write, Edit, Grep, Glob, Agent, call_mcp_tool
---

# Mobile Dev Study

Personal study assistant using the **Project-First** approach for the **`mobile-dev-tutor`** agent, natively integrated with the **GSD (Get Stuff Done)** framework. Transforms application feature milestones into study guides with nested architectural & conceptual prerequisites in `.planning/`.

---

> [!CAUTION]
> ## 📱 MODULE SCOPE GATE
> **One invocation = One feature/module. No exceptions.**
> The GSD `.planning/ROADMAP.md` is the source of truth for the Single Module ID referenced (e.g. M02). Do NOT generate multiple modules or full phases at once.

---

## 🗂️ Output Path Contract (GSD Native)

Before starting, determine and announce the output path: `.planning/phases/fase-XX-[nome-da-fase]/{MXX-slug}/`.

1. Extract root path of workspace containing `.planning/`.
2. Read module and phase from `.planning/ROADMAP.md`.
3. Slugify names (e.g., `.planning/phases/fase-01-auth/m02-jwt-login`).
4. Announce: `📁 Output path: {path}`.

---

## Routing Table

Resolve relative paths below from the directory of this `SKILL.md`.

| Task / Phase | Read (Path Relative to Skill) |
|---|---|
| GSD spec generation, research subagents, CONTEXT & UI-SPEC | [./references/workflow-phases.md](./references/workflow-phases.md) |
| Output formats, layer 1 MISSAO.md, layer 2 walkthroughs | [./references/synthesis-and-output.md](./references/synthesis-and-output.md) |
| Cross-stack mapping matrix (RN, Flutter, Kotlin, Swift) | [./references/stack-mapping.md](./references/stack-mapping.md) |
| Project-First rules & anti-solution-leak rules | [./references/project-first-rules.md](./references/project-first-rules.md) |
| Post-feature code walkthrough & refactoring format | [./references/code-walkthrough-format.md](./references/code-walkthrough-format.md) |

---

## 🔴 Critical Rules

1. **You are helping a STUDENT build an app, not delivering copy-paste code.** Audience is always the user.
2. **Never ask unnecessary questions.** Start immediately if roadmap and module ID are present.
3. **Write TO the user, not ABOUT a subject.** Use direct address ("você").
4. **Always use the Output Path Contract path.** Never invent paths.
5. **Multi-stack adaptability.** Dynamically adapt examples and prerequisites to the user's stack (React Native, Flutter, Kotlin Compose, or Swift SwiftUI).
6. **Prioritize direct technical mechanics.** Teach lifecycle, state flow, hooks, streams, and async primitives.
7. **Maintain High Granularity (Atomic Sub-topics).** Keep prerequisite files well under 500-800 lines.
8. **🚫 FORBIDDEN: Inline comments inside code blocks.** Code snippets must be clean; use annotations below.
9. **🚫 FORBIDDEN: Monolithic code blocks.** Split blocks over 10 lines.
10. **Direct Codebase Implementation (Rule 14).** No separate `automacao-e-scripts/` directory. All implementation logic belongs in the student's app codebase (`src/`, `lib/`, `app/`).
11. **Retake Bridges.** Include relative links to prerequisites in lab/feature guides.
12. **Master Panel by Feature Objectives.** README should use feature objectives (Auth, Offline Storage, Push Notifications).
13. **Single Entry Point (Anti-Overwhelm).** Deliver only `MISSAO.md` + `prerequisites/` first.
14. **🚫 FORBIDDEN: Prerequisites That Solve the Feature.** Teach isolated building blocks, never assembled feature components.
15. **🚨 ANTI-SOLUTION-LEAK ENFORCEMENT.** Re-evaluate prerequisites against leak tests.

---

## Workflow

You MUST execute these phases in order.

### Phase 0: Resolve Output Path
1. Resolve workspace root and GSD `.planning/` directory.
2. Compose path: `.planning/phases/fase-XX-[nome-da-fase]/{MXX-slug}/`.
3. Announce: `📁 Output path: {path}`.

### Phase 1: GSD Context & Spec Generation
Create GSD specification contracts in output folder:
- `CONTEXT.md` (Scope, goals, stack bounds)
- `UI-SPEC.md` or `SPEC.md` (UI layout requirements, state management expectations, API contracts)

### Phase 2: Parallel Research & Skill Scanning
Launch 4 parallel research subagents with `invoke_subagent` writing into GSD `RESEARCH.md`:
- **Subagent A — Feature Hunter**: Maps features, user stories, acceptance criteria, APIs.
- **Subagent B — Blocker Extractor**: Identifies mobile beginner sticking points (re-renders, memory leaks, unhandled async).
- **Subagent C — Context7 Documentation**: Fetches official docs for target stack libraries.
- **Subagent D — Modern Mobile Specialist**: Researches modern patterns (MVVM, Clean Arch) and deprecations.

### Phase 3: Synthesis — Build Study Documents
Build files in output folder:
- `MISSAO.md` (Mission panel template with inline Obsidian links).
- `prerequisites/[topic]/[note].md` (4-pillar flexible prerequisite guides).

### Phase 3.5: Anti-Solution-Leak Scan (MANDATORY Self-Correction)
Re-read all `prerequisites/` and run the Anti-Solution-Leak tests. Fix any violations.

### Phase 4: Validation (MANDATORY BLOCKING)
Run both validation scripts:
1. `python {skill_dir}/scripts/validate_spec.py {output_folder}/`
2. `python {skill_dir}/scripts/validate_study_output.py {output_folder}/`
Both must return exit code 0.

### Phase 5: GSD Compliance Report & State Sync
Print report to user and sync `.planning/STATE.md`:
```
📋 Relatório de Conformidade GSD — [Módulo XX]
✅ Fases executadas: 0/1/2/3/4/5
✅ Arquivos GSD gerados: CONTEXT.md, UI-SPEC.md, RESEARCH.md
✅ Pré-requisitos: gerados para todas as sub-tasks da feature
✅ Anti-Solution-Leak Scan (Phase 3.5): 0 violações
✅ Codebase Target: Implementação direta no projeto (Sem pasta automação)
```

---

## Output Contract

Produces:
- `CONTEXT.md` & `UI-SPEC.md` (GSD feature contracts)
- `RESEARCH.md` (Consolidated subagent findings)
- `MISSAO.md` (Feature Mission panel)
- `[XX].[Y]-[slug].md` (Post-feature architectural review)
- `prerequisites/[topic]/[note].md` (Building blocks and concepts)
- `README_[APP].md` (App Master panel)

---

## When to Use

Activate when the user asks to study mobile development, plan an app feature, or execute a mobile course module.
