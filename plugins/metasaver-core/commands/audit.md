---
name: audit
description: Natural language audit command that validates configurations, code quality, and standards compliance
---

# Audit Command

Validates configurations and standards compliance. No Innovate phase (audit checks, doesn't build).

**IMPORTANT:** Never do git operations without user approval.

---

## Phase 1: Analysis (PARALLEL)

```
/skill complexity-check → score: int (1-50)
/skill tool-check → tools: string[]
/skill scope-check → repos/files: string[]
```

---

## Phase 2: Requirements (ALL tasks)

```
Business Analyst → PRD → Vibe Check
```

BA creates PRD for ALL complexity levels. Vibe Check validates.

---

## Phase 3: PRD Approval (complexity ≥15 only)

```
IF complexity ≥15: Present PRD → User Approves → Continue
IF complexity <15: Skip to Design Phase
```

---

## Phase 4: Design

```
Architect (scope + approach) → Project Manager (execution plan)
```

---

## Phase 5: Execution

```
PM spawns config agents (waves, max 10 parallel) → Production Check → Validation
```

---

## Phase 6: Report

```
Business Analyst → Final Report to User
```

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

**Self-aware spawning:**

```
AUDIT MODE for {file_path}.
You are {Agent Name}.
READ YOUR INSTRUCTIONS at .claude/agents/config/{category}/{agent}.md
```

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

1. Run analysis skills in PARALLEL
2. BA creates PRD for ALL tasks
3. PRD Approval only for complexity ≥15
4. NO Innovate phase (audit only)
5. Config agents use haiku
6. Call `/skill repomix-cache-refresh` if files modified
