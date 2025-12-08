---
name: audit
description: Natural language audit command that validates configurations, code quality, and standards compliance
---

# Audit Command

Validates configurations and standards compliance. No Innovate phase (audit checks, doesn't build).

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

## Phase 3: Vibe Check

Single vibe check on PRD. If fails, return to BA to revise.

---

## Phase 4: PRD Complete & Approval (complexity ≥15 only)

**See:** `/skill prd-approval`

- **complexity ≥15:** Write PRD file → Link to user → User approves
- **complexity <15:** Skip to Design Phase (PRD stays internal)

**No Innovate phase for audit** (audit validates, doesn't enhance).

---

## Phase 5: Design

**See:** `/skill design-phase`

Architect → arch_docs → Project Manager → execution_plan

---

## Phase 6: Execution

**See:** `/skill execution-phase`

PM spawns config agents (waves, max 10 parallel) → Validation

---

## Phase 7: Validation

**See:** `/skill validation-phase`

Code quality checks scaled by change size.

---

## Phase 8: Report

**See:** `/skill report-phase`

BA (sign-off) + PM (consolidation) → Final audit report

---

## Model Selection

| Complexity | BA/Architect | Workers |
| ---------- | ------------ | ------- |
| <15        | sonnet       | haiku   |
| 15-29      | sonnet       | haiku   |
| ≥30        | opus         | haiku   |

Config agents always use **haiku** (fast, efficient for standards checking).

---

## Agent Selection

**Use `/skill agent-selection` for full agent reference.**

---

## Output Format

```markdown
# {Scope} Audit Report

**Compliance Target:** 100%

## Executive Summary

{1-2 sentences}

## Status by Domain

✅ ESLint - PASS (100%)
❌ Turbo.json - FAIL (72%)

## Prioritized Recommendations

### Critical | ### Warnings | ### Info
```

---

## Enforcement

1. Run analysis skills in PARALLEL (single message, 3 Task calls)
2. BA creates PRD with HITL clarification loop
3. Write PRD file and link to user
4. NO Innovate phase (audit only)
5. Single Vibe Check after PRD complete
6. PRD Approval only for complexity ≥15
7. Config agents use haiku
8. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
