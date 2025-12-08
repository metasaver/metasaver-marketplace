---
name: build
description: Build new features with architecture validation and optional innovation
---

# Build Command

Creates new features with architecture validation. Includes optional Innovate phase.

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

## Phase 3: Innovate (OPTIONAL)

```
Present PRD → "Want to innovate with best practices?"
IF yes: Innovation Advisor → Numbered suggestions (impact/effort)
        User responds: 1:yes, 2:explain, 3:no
        BA updates PRD with selections
        Vibe Check validates enhanced PRD
IF no: Continue with original PRD
```

---

## Phase 4: Human Validation

```
Present final PRD → User approves → Continue
```

---

## Phase 5: Design

```
Architect (design) → Project Manager (execution plan)
```

---

## Phase 6: Execution

```
PM spawns domain agents (waves, max 10 parallel) → Production Check → Validation
```

---

## Phase 7: Report

```
Business Analyst (sign-off) + Project Manager (consolidation)
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

**Self-aware spawning:**

```
BUILD MODE for {path/scope}.
You are {Agent Name}.
READ YOUR INSTRUCTIONS at .claude/agents/{category}/{agent}.md
```

---

## Examples

```bash
# Simple feature
/build "add logging to service"
→ BA → PRD → [Innovate?] → Approval → Architect → PM → backend-dev → Report

# Complex feature
/build "JWT auth API"
→ BA → PRD → [Innovate?] → Approval → Architect → PM → workers → Report

# Enterprise feature
/build "multi-tenant SaaS"
→ BA (opus) → PRD → Innovate → Approval → Architect (opus) → PM → waves → Report
```

---

## Enforcement

1. Run analysis skills in PARALLEL
2. BA creates PRD for ALL tasks
3. Innovate phase is OPTIONAL (ask user)
4. Human Validation required
5. Use Context7 for library research
6. Domain agents use sonnet
7. Call `/skill repomix-cache-refresh` if files modified
