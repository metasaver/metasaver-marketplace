---
name: ms
description: Intelligent MetaSaver command that analyzes complexity and routes optimally
---

# MetaSaver Intelligent Router

Analyzes prompt complexity and routes to optimal execution method.

**IMPORTANT:** Never do git operations without user approval.

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel to execute complexity-check, tool-check, and scope-check skills.
Collect: `complexity_score`, `tools`, `repos`

---

## Phase 2: Route by Complexity

### Score ≤4: Agent Check (Direct)

```
Spawn agent: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill agent-check on: {USER_PROMPT}. Return ONLY: agent: <name> or agent: none"
```

- If agent matched → Spawn that agent directly (skip PRD)
- If no match → Direct Claude response (skip PRD)

### Score 5-14: Quick Workflow

```
Architect → PM → Workers → Validation
```

No PRD. No Approval. No Innovate.

### Score 15-29: Full Workflow (same as /build, no Innovate)

```
Requirements (HITL) → PRD Complete → Vibe Check → PRD Approval → Design → Execution → Report
```

### Score ≥30: Enterprise Workflow (same as /build, with Innovate)

```
Requirements (HITL) → PRD Complete → [Innovate?] → Vibe Check → PRD Approval → Design → Execution → Report
```

---

## Shared Phases (align with /build and /audit)

### Requirements Phase (HITL) - Score ≥15

**See:** `/skill requirements-phase`

### PRD Complete + Innovate - Score ≥15

**See:** `/skill innovate-phase`

- Score ≥30: Ask "Want to Innovate?" (HARD STOP)
- Score 15-29: Write PRD, skip innovate

### Vibe Check - Score ≥15

Single vibe check on PRD. If fails, return to BA.

### PRD Approval - Score ≥15

**See:** `/skill prd-approval`

### Design Phase

**See:** `/skill design-phase`

### Execution Phase

**See:** `/skill execution-phase`

### Validation Phase

**See:** `/skill validation-phase`

### Report Phase - Score ≥15

**See:** `/skill report-phase`

---

## Model Selection

| Complexity | BA/Architect | Workers | Thinking   |
| ---------- | ------------ | ------- | ---------- |
| ≤4         | -            | haiku   | none       |
| 5-14       | sonnet       | sonnet  | none       |
| 15-29      | sonnet       | sonnet  | think      |
| ≥30        | opus         | sonnet  | ultrathink |

---

## Agent Selection

**Use `/skill agent-selection` for full agent reference.**

---

## Examples

```bash
# ≤4: Agent check
/ms "security scan"
→ agent-check → security-engineer agent

# ≤4: No match
/ms "what does this code do?"
→ agent-check → no match → Direct Claude

# 5-14: Quick workflow
/ms "add logging to service"
→ Architect → PM → backend-dev

# 15-29: Full workflow
/ms "build JWT auth API"
→ BA → PRD → Vibe Check → Approval → Architect → PM → workers → Report

# ≥30: Enterprise with Innovate
/ms "standardize error handling across microservices"
→ BA → PRD → [Innovate?] → Vibe Check → Approval → Architect (opus) → PM → waves → Report
```

---

## Enforcement

1. Run analysis skills in PARALLEL (single message, 3 Task calls)
2. Score ≤4: Spawn agent for `/skill agent-check`, then route accordingly
3. Score 5-14: Skip PRD, go direct to Architect
4. Score ≥15: Full workflow with HITL Requirements, Vibe Check, PRD Approval
5. Score ≥30: Include Innovate phase (ask user, hard stop)
6. Select model by complexity
7. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
