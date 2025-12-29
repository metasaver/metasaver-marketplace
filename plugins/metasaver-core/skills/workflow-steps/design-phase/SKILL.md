---
name: design-phase
description: Design phase with validation gates. Annotates PRD, creates story outlines, builds execution plan (via execution-plan-creation skill), validates artifacts via reviewer, and gets HITL approval. Use when orchestrating the design phase after PRD approval.
---

# Design Phase Skill

> **ROOT AGENT ONLY** - Spawns agents, runs only from root Claude Code agent.

**Purpose:** Annotate PRD, create stories, build execution plan with validation gates
**Trigger:** After requirements-phase passes (PRD approved)
**Input:** `prdPath` (string), `projectFolder` (string), `complexity` (int), `tools` (string[]), `scope` (string[])
**Output:** `{storiesFolder, storyFiles, executionPlan, allApproved}`

---

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DESIGN PHASE                                │
├─────────────────────────────────────────────────────────────────────┤
│  1. Architect annotates PRD                                         │
│       ↓                                                             │
│  2. BA creates story outlines                                       │
│       ↓                                                             │
│  3. PM creates execution plan (uses execution-plan-creation skill)  │
│       ↓                                                             │
│  4. Reviewer validates execution plan (uses document-validation)    │
│       ↓                                                             │
│  5. HITL: User approves execution plan                              │
│       ↓                                                             │
│  6. BA fills story details (uses user-story-creation skill)         │
│       ↓                                                             │
│  7. Architect adds Architecture section to stories                  │
│       ↓                                                             │
│  8. Reviewer validates stories (uses document-validation)           │
│       ↓                                                             │
│  9. HITL: User approves stories                                     │
│       ↓                                                             │
│ 10. Continue to execution-phase                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Workflow Steps

### Step 1: Architect Annotates PRD

**Spawn:** `core-claude-plugin:generic:architect`

- Read approved PRD from `prdPath`
- Add inline architecture notes (API endpoints, key files, patterns)
- Keep annotations concise (50-100 lines max)
- Complexity >= 30 triggers deeper analysis mode

### Step 2: BA Creates Story Outlines

**Spawn:** `core-claude-plugin:generic:business-analyst`

- Read annotated PRD
- Create `user-stories/` folder in project folder
- Extract story outlines (title, brief description, dependencies)
- Follow Story Granularity Guidelines (see below)
- Create files: `{PROJ}-{EPIC}-{NNN}-{slug}.md`
- Return paths to all story files

### Step 3: PM Creates Execution Plan

**Spawn:** `core-claude-plugin:generic:project-manager`

**Invokes:** `/skill execution-plan-creation`

- Read story outlines
- Analyze dependencies, build dependency graph
- Organize into parallel waves (max 10 agents/wave)
- Assign agents to each story
- Output to `execution-plan.md` in project folder

### Step 4: Validate Execution Plan

**Spawn:** `core-claude-plugin:generic:reviewer`

**Invokes:** `/skill document-validation` (type: execution-plan)

- Validate frontmatter fields
- Validate required sections
- Check wave integrity (all stories assigned, valid DAG)
- **If invalid:** Return issues to PM, loop back to Step 3

### Step 5: HITL - Approve Execution Plan

**Invokes:** `/skill hitl-approval`

Present to user:

- Execution plan summary (total stories, waves, complexity)
- Wave breakdown with agent assignments
- Critical path through dependencies

**If rejected:** Collect feedback, return to Step 3

### Step 6: BA Fills Story Details

**Spawn:** `core-claude-plugin:generic:business-analyst`

**Invokes:** `/skill user-story-creation`

- Read each story outline
- Fill in complete story format (As a / I want / So that)
- Add acceptance criteria (minimum 3 testable criteria)
- Add technical details (files to create/modify)
- Save updated story files

### Step 7: Architect Adds Architecture Section

**Spawn:** `core-claude-plugin:generic:architect`

For each story file:

- Read the story
- Add "Architecture" section (if not exists)
- Fill in: API endpoints, key files, database models, component names, patterns
- Save updated story file

### Step 8: Validate Stories

**Spawn:** `core-claude-plugin:generic:reviewer`

**Invokes:** `/skill document-validation` (type: user-story)

For each story:

- Validate frontmatter fields
- Validate required sections
- Check acceptance criteria completeness
- **If invalid:** Return issues to BA, loop back to Step 6

### Step 9: HITL - Approve Stories

**Invokes:** `/skill hitl-approval`

Present to user:

- List of all stories with complexity scores
- Stories grouped by wave
- Total implementation effort estimate

**If rejected:** Collect feedback, return to Step 6

### Step 10: Continue to Execution Phase

**Output:**

```json
{
  "storiesFolder": "docs/epics/msm008-feature/user-stories/",
  "storyFiles": ["MSM-008-001-story.md", "MSM-008-002-story.md"],
  "executionPlan": "docs/epics/msm008-feature/execution-plan.md",
  "allApproved": true
}
```

---

## Story Granularity Guidelines

**ALWAYS create stories by functional capability, not by package/layer.**

| Approach         | Result                              |
| ---------------- | ----------------------------------- |
| Package-based    | Bottlenecks, sequential execution   |
| Capability-based | Parallel execution, smaller stories |

**Rules:**

1. **Stories = Testable Units**: Each story independently testable
2. **Max 15-20 min per story**: Break down larger stories
3. **Parallel by default**: Stories in same wave run concurrently
4. **Dependency-aware**: Use `dependencies` field in frontmatter

**Example - Good (capability-based):**

```
US-001: Database schema       → Wave 1 (parallel)
US-002: Contracts types       → Wave 1 (parallel)
US-003a: Workflow scaffolding → Wave 2
US-003b: Height/weight parser → Wave 2 (parallel)
US-003c: Team fuzzy matching  → Wave 2 (parallel)
```

---

## Validation Gate Pattern

Each validation gate follows this pattern:

```
1. Spawn reviewer agent
2. Reviewer invokes document-validation skill
3. If valid: Continue to next step
4. If invalid: Return issues to authoring agent
5. Authoring agent fixes issues
6. Loop back to validation
```

---

## Integration

**Called by:**

- `/build` command (after requirements-phase)
- `/ms` command (for complexity >= 15, after requirements-phase)

**Spawns:**

- `core-claude-plugin:generic:architect` (Steps 1, 7)
- `core-claude-plugin:generic:business-analyst` (Steps 2, 6)
- `core-claude-plugin:generic:project-manager` (Step 3)
- `core-claude-plugin:generic:reviewer` (Steps 4, 8)

**Invokes Skills:**

- `/skill execution-plan-creation` (Step 3)
- `/skill user-story-creation` (Step 6)
- `/skill document-validation` (Steps 4, 8)
- `/skill hitl-approval` (Steps 5, 9)

**Next step:** execution-phase (wave-based implementation)
