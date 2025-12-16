---
name: audit
description: Natural language audit command that validates configurations, code quality, and standards compliance
---

# Audit Command

Validates configurations and standards compliance. Audit-only workflow (validation focus, Innovate excluded).

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /audit is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to understand scope, then the BA addresses user questions during Requirements HITL while investigating the codebase.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel to execute complexity-check, tool-check, and scope-check skills.
Collect: `complexity_score`, `tools`, `scope` (with `targets` and `references`)

---

## Phase 2: Requirements (HITL)

**Invoke:** `/skill requirements-phase` with mode=audit

BA investigates codebase FIRST using Serena tools to discover scope, answers user questions from investigation, then drafts PRD with HITL clarification loop. Audit scope is typically self-evident from file discovery (package.json, config files, directory structure)—only ask clarification if scope is genuinely ambiguous after investigation.

---

## Phase 3: Vibe Check

Single vibe check on PRD. If fails, return to BA to revise.

---

## Phase 4: PRD Complete & Approval (complexity ≥15 only)

**See:** `/skill prd-approval`

- **complexity ≥15:** Write PRD file → Link to user → User approves
- **complexity <15:** Skip to Design Phase (PRD stays internal)

**Audit-only workflow** (validation focus, Innovate excluded).

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

1. ALWAYS run Analysis phase first—never skip to answer user questions
2. Run analysis skills in PARALLEL (single message, 3 Task calls)
3. BA addresses user questions in Requirements HITL, not before Phase 1
4. BA creates PRD with HITL clarification loop
5. Write PRD file and link to user
6. Audit-only workflow (Innovate excluded)
7. Single Vibe Check after PRD complete
8. PRD Approval only for complexity ≥15
9. Config agents use haiku
10. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
