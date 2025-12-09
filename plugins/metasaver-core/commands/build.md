---
name: build
description: Build new features with architecture validation and optional innovation
---

# MetaSaver Constitution

| #   | Principle       | Rule                                        |
| --- | --------------- | ------------------------------------------- |
| 1   | **Minimal**     | Change only what must change                |
| 2   | **Root Cause**  | Fix the source (address symptoms at origin) |
| 3   | **Read First**  | Understand existing code before modifying   |
| 4   | **Verify**      | Confirm it works before marking done        |
| 5   | **Exact Scope** | Do precisely what was asked                 |

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
Collect: `complexity_score`, `tools`, `repos`

---

## Phase 2: Requirements (HITL)

**See:** `/skill requirements-phase`

BA reviews original prompt for user questions, investigates codebase using Serena tools to answer them, then drafts PRD with HITL clarification loop until complete.

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

## Phase 5: Human Validation

**See:** `/skill prd-approval`

Present final PRD → User approves → **BA extracts user stories to `user-stories/` folder** → Continue

---

## Phase 6: Design

**See:** `/skill design-phase`

Architect annotates story files → PM creates execution plan from stories

---

## Phase 7: Execution

**See:** `/skill execution-phase`

PM spawns workers → Workers read story files → PM updates story status → Validation

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
→ BA → PRD → [Innovate?] → Vibe Check → Approval → Architect → PM → workers

/build "multi-tenant SaaS"
→ BA (opus) → PRD → Innovate → Vibe Check → Approval → Architect (opus) → PM → waves
```

---

## Enforcement

1. ALWAYS run Analysis phase first—never skip to answer user questions
2. Run analysis skills in PARALLEL (single message, 3 Task calls)
3. BA addresses user questions in Requirements HITL, not before Phase 1
4. BA creates PRD with HITL clarification loop
5. Write PRD file and link before asking about Innovate
6. Innovate is OPTIONAL (ask user, hard stop)
7. Single Vibe Check after PRD finalized
8. Human Validation required before Design
9. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
