---
name: msold
description: (ARCHIVED) Original intelligent MetaSaver router with complexity-based routing
---

# MetaSaver Intelligent Router (ARCHIVED)

**This is the archived version of /ms. See ms.md for the current version.**

Analyzes prompt complexity and routes to optimal execution method.

**IMPORTANT:** ALWAYS get user approval before git operations.

---

## Entry Handling

When /ms is invoked, ALWAYS proceed to Phase 1 regardless of prompt content. User prompts may contain questions, clarifications, or confirmation requests—these are NOT reasons to skip phases. Analysis runs first to determine complexity and routing, then user questions are addressed in the appropriate phase (HITL for score ≥15, or by the routed agent for score ≤14).

---

## Phase 1: Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel to execute complexity-check, tool-check, and scope-check skills.
Collect: `complexity_score`, `tools`, `scope` (with `targets` and `references`)

---

## Phase 2: Route by Complexity

### Score ≤4: Agent Check (Direct)

```
Spawn agent: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill agent-check on: {USER_PROMPT}. Return ONLY: agent: <name> or agent: none"
```

- If agent matched → Spawn that agent directly (skip PRD)
- If direct response → Claude handles directly (PRD skipped)

### Score 5-14: Quick Workflow

```
Architect → PM → Workers → Validation
```

Direct to design (PRD, Approval, Innovate skipped).

### Score 15-29: Full Workflow (same as /build, Innovate skipped)

```
Requirements (HITL Q&A) → PRD → Vibe Check → Design (extract stories + annotate + plan) → Plan Approval → Execution → Report
```

### Score ≥30: Enterprise Workflow (same as /build, with Innovate)

```
Requirements (HITL Q&A) → PRD → [Innovate?] → Vibe Check → Design (extract stories + annotate + plan) → Plan Approval → Execution → Report
```

---

## Shared Phases (align with /build and /audit)

### Requirements Phase (HITL Q&A) - Score ≥15

**See:** `/skill requirements-phase`

BA drafts PRD with clarification loop. No approval here—just Q&A to gather requirements.

### PRD Complete + Innovate - Score ≥15

**See:** `/skill innovate-phase`

- Score ≥30: Ask "Want to Innovate?" (HARD STOP)
- Score 15-29: Write PRD (Innovate skipped)

### Vibe Check - Score ≥15

Single vibe check on PRD. If fails, return to BA.

### Design Phase - Score ≥15

**See:** `/skill design-phase`

1. BA extracts user stories (following granularity guidelines)
2. Architect annotates story files
3. PM creates execution plan with parallel waves

### Plan Approval - Score ≥15

**See:** `/skill plan-approval`

User sees complete picture (PRD + stories + plan), then approves. This is the single approval point.

### Execution Phase

**See:** `/skill execution-phase`

Workers read their assigned story file. PM tracks status in story files.

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

# ≤4: Direct response
/ms "what does this code do?"
→ agent-check → direct → Claude handles

# 5-14: Quick workflow
/ms "add logging to service"
→ Architect → PM → backend-dev

# 15-29: Full workflow with plan approval
/ms "build JWT auth API"
→ BA (Q&A) → PRD → Vibe Check → Design (stories + annotate + plan) → Plan Approval → workers → Report

# ≥30: Enterprise with Innovate
/ms "standardize error handling across microservices"
→ BA (Q&A) → PRD → [Innovate?] → Vibe Check → Design → Plan Approval → waves → Report
```

---

## Enforcement

1. ALWAYS run Analysis phase first—never skip to answer user questions
2. Run analysis skills in PARALLEL (single message, 3 Task calls)
3. User questions addressed by routed agent (≤14) or BA in HITL (≥15)
4. Score ≤4: Spawn agent for `/skill agent-check`, then route accordingly
5. Score 5-14: Skip PRD, go direct to Architect
6. Score ≥15: Full workflow with HITL Requirements (Q&A only), Design, Plan Approval
7. Score ≥30: Include Innovate phase (ask user, hard stop)
8. Plan Approval happens AFTER design—user sees PRD + stories + plan together
9. Select model by complexity
10. If files modified, spawn agent: `subagent_type="general-purpose", model="haiku"` with prompt "Execute /skill repomix-cache-refresh"
