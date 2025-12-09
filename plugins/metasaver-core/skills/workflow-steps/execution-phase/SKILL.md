---
name: execution-phase
description: Gantt-style parallel execution of domain worker agents with dependency respect. Spawns up to 10 concurrent agents, waits for ANY task completion, immediately starts next ready task. Use when orchestrating parallel implementation workflows.
---

# Execution Phase - Domain Worker Orchestration

> **ROOT AGENT ONLY** - Called by commands only, never by subagents.

**Purpose:** Execute implementation tasks via domain worker agents
**Trigger:** After design-phase completes
**Input:** Execution plan with task dependencies
**Output:** Collection of all worker outputs

---

## Workflow Steps

1. **Load execution plan** from design-phase (tasks + dependencies + story files)
2. **Initialize state:** pending tasks, running tasks (max 10), completed set
3. **Loop:** While pending or running tasks exist:
   - **Start ready tasks** (dependencies met, under limit):
     - Update story file: Status → 🔄 In Progress
     - Update story file: Assignee → {agent-name}
     - Spawn worker agent with story file path
   - Wait for ANY task to complete (not all)
   - **On task completion:**
     - Update story file: Status → ✅ Complete
     - Update story file: Completion section with files modified
     - Update story file: Verified → yes (if validation passes)
     - Record result, add to completed set
   - Immediately start next ready task
4. **On task failure:** Log error, update story status to ❌ Failed, continue (validation phase handles retries)
5. **Return:** All results with status, files modified, errors, story completion tracking

---

## Execution Logic

```
pending = [...tasks]
running = {} // taskId -> Promise
completed = new Set()
MAX_CONCURRENT = 10

while (pending.length || running.size > 0):
  // Start ready tasks
  while (running.size < 10):
    ready = pending.find(t => t.deps all in completed)
    if !ready: break
    running[ready.id] = spawnAgent(ready)

  // Wait for any task completion
  finished = await Promise.race(running values)
  completed.add(finished.id)
  results.push(finished)
```

---

## Agent Spawning

**Spawn template:**

```
CONSTITUTION: 1) Change only what must change 2) Fix root cause, not symptoms 3) Read existing code first 4) Verify before done 5) Do exactly what asked

TASK: {task.description}
STORY: Read your story file at {storyFilePath}
PRD: Reference {prdPath} only if you need more context

UPDATE: After completion, report files modified so PM can update story.
READ YOUR INSTRUCTIONS at .claude/agents/{category}/{agent}.md
```

Model: `sonnet` (balanced cost/capability)

**Key Changes:**

- Workers read story files (not PRD) for task context
- Story file contains acceptance criteria, dependencies, implementation details
- PRD is referenced only when workers need broader context
- Workers report files modified for PM to track in story

---

## Domain Agent Categories

| Category | Agents                                         |
| -------- | ---------------------------------------------- |
| Backend  | backend-dev, data-service, integration-service |
| Frontend | react-component, shadcn                        |
| Database | prisma-database                                |
| Testing  | unit-test, integration-test, e2e-test          |
| Config   | 26+ config agents (for /audit)                 |

---

## Constraints

| Constraint         | Value  | Rationale                   |
| ------------------ | ------ | --------------------------- |
| Max concurrent     | 10     | Prevent resource exhaustion |
| Worker model       | sonnet | Balanced cost               |
| Config agent model | haiku  | Fast audit                  |

---

## Output Format

```json
{
  "totalTasks": 8,
  "completedTasks": 7,
  "failedTasks": 1,
  "results": [
    {
      "taskId": "task-1",
      "agent": "prisma-database",
      "status": "success",
      "output": "...",
      "filesModified": ["schema.prisma", "migration.sql"],
      "storyFile": ".claude/stories/US-001.md"
    }
  ],
  "storiesCompleted": ["US-001", "US-002", "US-005"],
  "storiesRemaining": ["US-003", "US-004"]
}
```

---

## Integration

**Called by:** /audit, /build, /ms (complexity ≥15)
**Calls:** Domain agents, vibe_learn MCP (errors)
**Next phase:** validation-phase

---

## Example

```
/build JWT authentication API

Execution Plan:
  - Task 1: prisma (User model) [no deps]
  - Task 2: backend-dev (AuthService) [dep: 1]
  - Task 3: backend-dev (TokenService) [dep: 1]
  - Task 4: integration-test [dep: 2,3]

Gantt execution:
  t=0: Start task-1 [1 running]
  t=2: task-1 done → Start 2,3 [2 running]
  t=4: task-3 done [1 running]
  t=5: task-2 done → Start 4 [1 running]
  t=7: task-4 done [0 running]

Output: All 4 tasks completed, 6 files modified
```
