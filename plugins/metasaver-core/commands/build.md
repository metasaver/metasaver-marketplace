---
name: build
description: Build new features with architecture validation and optional innovation
---

# Build Command

Creates new features with architecture validation. Includes optional Innovate phase.

**IMPORTANT:** Never do git operations without user approval.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel to execute complexity-check, tool-check, and scope-check skills.
Collect: `complexity_score`, `tools`, `repos`

---

## Phase 2: Requirements (HITL)

**See:** `/skill requirements-phase`

BA drafts PRD with HITL clarification loop until complete.

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

Present final PRD → User approves → Continue

---

## Phase 6: Design

**See:** `/skill design-phase`

Architect → arch_docs → Project Manager → execution_plan

---

## Phase 7: Execution

**See:** `/skill execution-phase`

PM spawns workers (waves, max 10 parallel) → Validation

---

## Phase 8: Validation

**See:** `/skill validation-phase`

Code quality checks scaled by change size.

---

## Phase 9: Report

**See:** `/skill report-phase`

BA (sign-off) + PM (consolidation) → Final report

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

1. Run analysis skills in PARALLEL (single message, 3 Task calls)
2. BA creates PRD with HITL clarification loop
3. Write PRD file and link before asking about Innovate
4. Innovate is OPTIONAL (ask user, hard stop)
5. Single Vibe Check after PRD finalized
6. Human Validation required before Design
7. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
