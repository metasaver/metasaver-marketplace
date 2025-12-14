---
name: build
description: Build new features with architecture validation and optional innovation
---

# Build Command

Creates new features with architecture validation. Includes optional Innovate phase.

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /build is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to understand scope, then the BA addresses user questions during Requirements HITL while investigating the codebase.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel to execute complexity-check, tool-check, and scope-check skills.
Collect: `complexity_score`, `tools`, `scope` (with `targets` and `references`)

---

## Phase 2: Requirements (HITL Q&A)

**See:** `/skill requirements-phase`

BA reviews original prompt for user questions, investigates codebase using Serena tools to answer them, then drafts PRD with HITL clarification loop until complete.

**No approval here**—just Q&A to gather requirements. Approval happens after design.

Creates project folder: `docs/projects/{yyyymmdd}-{name}/prd.md`

---

## Phase 3: PRD Complete + Innovate (HITL STOP)

**See:** `/skill innovate-phase`

1. Write PRD file, link to user
2. Ask: "Want to Innovate?" (HARD STOP)
3. If yes: innovation-advisor → user selects → BA updates PRD

---

## Phase 4: Vibe Check

Single vibe check on final PRD. If fails, return to BA to revise.

---

## Phase 5: Design

**See:** `/skill design-phase`

1. BA extracts user stories (following granularity guidelines—NOT 1 per package!)
2. Architect annotates story files with implementation details
3. PM creates execution plan with parallel waves

---

## Phase 6: Plan Approval

**See:** `/skill plan-approval`

User sees the **complete picture**:

- PRD (requirements)
- User stories (work breakdown)
- Architecture notes (on each story)
- Execution plan (waves, parallelization)

Then approves or requests changes. This is the single approval point.

---

## Phase 7: Execution

**See:** `/skill execution-phase`

PM spawns workers → Workers read story files → PM updates story status

---

## Phase 8: Validation

**See:** `/skill validation-phase`

Code quality checks scaled by change size.

---

## Phase 9: Report

**See:** `/skill report-phase`

BA (sign-off) + PM (consolidation) → Final report

---

## Project Folder Structure

After /build completes:

```
docs/projects/{yyyymmdd}-{name}/
├── prd.md                    # Reference document
├── user-stories/
│   ├── US-001-{slug}.md      # Individual stories (annotated)
│   ├── US-002-{slug}.md
│   └── ...
├── execution-plan.md         # PM's Gantt chart
└── architecture-notes.md     # Optional (complex items)
```

---

## Model Selection

| Complexity | BA/Architect | Workers | Thinking   |
| ---------- | ------------ | ------- | ---------- |
| <15        | sonnet       | sonnet  | none       |
| 15-29      | sonnet       | sonnet  | think      |
| ≥30        | opus         | sonnet  | ultrathink |

---

## Agent Selection

**Use `/skill agent-selection` for full agent reference.**

---

## Examples

```bash
/build "add logging to service"
→ BA (Q&A) → PRD → [Innovate?] → Vibe Check → Design (stories + annotate + plan) → Plan Approval → workers

/build "multi-tenant SaaS"
→ BA (opus Q&A) → PRD → Innovate → Vibe Check → Design → Plan Approval → waves → Report
```

---

## Enforcement

1. ALWAYS run Analysis phase first—never skip to answer user questions
2. Run analysis skills in PARALLEL (single message, 3 Task calls)
3. BA addresses user questions in Requirements HITL (Q&A only, no approval)
4. BA creates PRD with HITL clarification loop
5. Write PRD file and link before asking about Innovate
6. Innovate is OPTIONAL (ask user, hard stop)
7. Single Vibe Check after PRD finalized
8. Design phase extracts stories, adds architecture, creates execution plan
9. Plan Approval happens AFTER design—user sees PRD + stories + plan together
10. BA must follow Story Granularity Guidelines (NOT 1 per package!)
11. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
