---
name: ms
description: Intelligent MetaSaver command that analyzes complexity and routes optimally
---

# MetaSaver Intelligent Router

Analyzes prompt complexity and routes to optimal execution method.

**IMPORTANT:** Never do git operations without user approval.

---

## Phase 1: Analysis (PARALLEL)

Spawn 3 agents in parallel using the Task tool. Each agent receives the user prompt and executes a skill:

**IMPORTANT:** You MUST spawn all 3 agents in a SINGLE message with 3 Task tool calls.

```
Task 1: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill complexity-check on this prompt: {USER_PROMPT}
           Return ONLY: score: <integer 1-50>"

Task 2: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill tool-check on this prompt: {USER_PROMPT}
           Return ONLY: tools: [<tool1>, <tool2>, ...]"

Task 3: subagent_type="general-purpose", model="haiku"
  Prompt: "Execute /skill scope-check on this prompt: {USER_PROMPT}
           Return ONLY: repos: [<path1>, <path2>, ...]"
```

Wait for all 3 agents to complete. Collect results:

- `complexity_score` (int)
- `tools` (string[])
- `repos` (string[])

Pass these to Phase 2.

---

## Phase 2: Requirements (ALL tasks)

```
Business Analyst → PRD → Vibe Check
```

BA creates PRD for ALL complexity levels. Vibe Check validates.

---

## Phase 3: Route by Complexity

### Complexity <15

```
PRD → Architect → PM → Workers → Validation
```

No PRD Approval gate. No Innovate.

### Complexity 15-29

```
PRD → PRD Approval → Architect → PM → Workers → Validation → Report
```

PRD Approval required. No Innovate.

### Complexity ≥30

```
PRD → Innovate Phase → PRD Approval → Architect (opus) → PM (Gantt) → Workers (waves) → Validation → Report
```

Innovate phase included. Full enterprise workflow.

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

**Self-aware spawning:**

```
[MODE] for [path/scope].
You are [Agent Name].
READ YOUR INSTRUCTIONS at .claude/agents/[category]/[agent-name].md
```

---

## Workflow Details

### Requirements Phase (ALL tasks)

Spawn `business-analyst` → Creates PRD → Vibe check validates

### Innovate Phase (≥30 only)

Spawn `innovation-advisor` → Suggests industry best practices → User picks options → BA updates PRD

### PRD Approval (15+)

Present PRD to user → User approves → Continue

### Execution Phase

PM spawns workers from plan. Max 10 agents per wave.

### Report Phase

`business-analyst` (sign-off) + `project-manager` (consolidation)

---

## Examples

```bash
# <15: Quick workflow
/ms "add logging to service"
→ BA → PRD → Architect → PM → backend-dev

# 15-29: Full workflow with PRD approval
/ms "build JWT auth API"
→ BA → PRD → Approval → Architect → PM → workers → Report

# ≥30: Enterprise with Innovate
/ms "standardize error handling across microservices"
→ BA → PRD → Innovate → Approval → Architect (opus) → PM (Gantt) → waves → Report
```

---

## Enforcement

1. Run analysis skills in PARALLEL
2. BA creates PRD for ALL tasks
3. Route by complexity (<15 / 15-29 / ≥30)
4. Score ≥15: Require PRD approval
5. Score ≥30: Include Innovate phase
6. Select model by complexity
7. Call `vibe_learn` after fixing errors
8. Call `/skill repomix-cache-refresh` if files modified
