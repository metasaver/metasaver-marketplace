---
name: planning-phase
description: Take enriched user stories and create execution plan with waves for parallel execution. Groups stories by dependencies into execution waves, assigns domain agents, and produces Gantt-style task schedule. Use when planning implementation workflow after architecture annotations.
---

# Planning Phase Skill

> **ROOT AGENT ONLY** - Spawns project-manager agent, runs only from root Claude Code agent.

**Purpose:** Convert enriched user stories into execution plan with parallel waves
**Trigger:** After architect annotations complete (design-phase)
**Input:** `storiesFolder` (string), `storyFiles` (string[]), `complexity` (int)
**Output:** `executionPlan` with waves, tasks, dependencies, and agent assignments

---

## Workflow

**1. Load enriched stories**

- Read all story files from `storiesFolder`
- Extract: story ID, title, dependencies (`Depends On` field), `parallelizable_with` annotations
- Build dependency graph

**2. Spawn project-manager agent**

- Read all enriched story files with architecture notes
- Analyze dependencies between stories:
  - If story A depends on story B, A cannot start until B completes
  - If stories have no dependency relationship, they can run in parallel
- Group independent stories into execution waves:
  - Wave 1: Stories with no dependencies
  - Wave 2+: Stories whose dependencies all completed in prior wave
- For each wave, identify parallel pairs (tester + implementation agent per story)
- Assign domain agents based on story content:
  - Database schema → prisma-database-agent
  - API endpoints → backend-dev or data-service-agent
  - Components → react-component-agent
  - Testing → unit-test, integration-test, e2e-test-agent
- Output to `execution-plan.md` in project folder
- Standard analysis mode

---

## Dependency Analysis Logic

```
Build dependency graph from all story files:
  for each story:
    if story has "Depends On" field:
      add edge: story → dependency
    if story has "parallelizable_with" field:
      mark as parallel-safe with those stories

Topological sort to determine waves:
  Wave 1 = stories with in-degree 0 (no dependencies)
  Wave N = stories whose dependencies all have in-degree 0 in Wave N-1

Limit waves to ≤10 concurrent agents per wave
```

---

## Wave Structure

| Wave | Stories                  | Tester-Implementation Pairs             | Dependencies             |
| ---- | ------------------------ | --------------------------------------- | ------------------------ |
| 1    | prj-epc-001              | T-001 → I-001                           | None                     |
| 2    | prj-epc-002, prj-epc-003 | T-002 → I-002, T-003 → I-003 (parallel) | prj-epc-001              |
| 3    | prj-epc-004              | T-004 → I-004                           | prj-epc-002, prj-epc-003 |

---

## Output Format

**Execution Plan (`execution-plan.md`):**

```json
{
  "totalStories": 5,
  "totalWaves": 3,
  "waves": [
    {
      "waveNumber": 1,
      "storyIds": ["msm-auth-001"],
      "tasks": [
        {
          "id": "task-1",
          "storyId": "msm-auth-001",
          "description": "User authentication schema",
          "testerAgent": "unit-test",
          "implAgent": "prisma-database-agent",
          "dependencies": []
        }
      ]
    },
    {
      "waveNumber": 2,
      "storyIds": ["msm-auth-002", "msm-auth-003"],
      "tasks": [
        {
          "id": "task-2",
          "storyId": "msm-auth-002",
          "description": "User service contracts",
          "testerAgent": "unit-test",
          "implAgent": "data-service-agent",
          "dependencies": ["task-1"]
        },
        {
          "id": "task-3",
          "storyId": "msm-auth-003",
          "description": "Token service implementation",
          "testerAgent": "unit-test",
          "implAgent": "backend-dev",
          "dependencies": ["task-1"]
        }
      ]
    }
  ],
  "parallelPairs": [
    {
      "waveNumber": 2,
      "pairNumber": 1,
      "testerTaskId": "task-2",
      "implTaskId": "task-2"
    },
    {
      "waveNumber": 2,
      "pairNumber": 2,
      "testerTaskId": "task-3",
      "implTaskId": "task-3"
    }
  ]
}
```

---

## Agent Assignment Rules

| Story Content Pattern      | Recommended Agent     |
| -------------------------- | --------------------- |
| Database schema, models    | prisma-database-agent |
| Data service, repositories | data-service-agent    |
| API routes, controllers    | backend-dev           |
| React components           | react-component-agent |
| Configuration files        | Specific config agent |
| Unit tests                 | unit-test             |
| Integration tests          | integration-test      |
| E2E tests                  | e2e-test              |

---

## Story Granularity Validation

**WARN if:**

- Single story >20 minutes of work (suggest further breakdown)
- Story has no dependencies AND no parallelizable pairs (isolated stories waste wave slots)
- More than 10 tasks per wave (recommend splitting)

**PASS if:**

- Stories average 15-20 min each
- Dependency graph creates 2+ distinct waves
- Parallelizable stories grouped in same wave

---

## Integration

**Called by:**

- `/audit` command (after design-phase)
- `/build` command (after design-phase)
- `/architect` command (for complexity ≥30)

**Calls:**

- `project-manager` agent (orchestrates planning)

**Next step:** execution-phase (agents spawn and execute tasks wave-by-wave)

---

## Example

```
Input: 5 enriched user stories with architecture notes

Design Phase Output:
  storiesFolder: docs/epics/in-progress/msm-feature/user-stories/
  storyFiles: [msm-feat-001-schema.md, msm-feat-002-contracts.md, msm-feat-003-parser.md, msm-feat-004-parser.md, msm-feat-005-api.md]

Planning Phase:
  1. Analyze dependencies:
     - msm-feat-001: No dependencies (Wave 1)
     - msm-feat-002, msm-feat-003, msm-feat-004: Depend on msm-feat-001 (Wave 2, parallelizable)
     - msm-feat-005: Depends on msm-feat-002, msm-feat-003, msm-feat-004 (Wave 3)

  2. Assign agents:
     - msm-feat-001: prisma-database-agent (schema)
     - msm-feat-002: data-service-agent (contracts)
     - msm-feat-003, msm-feat-004: backend-dev (parsers - parallel)
     - msm-feat-005: backend-dev (API routes)

  3. Build waves:
     Wave 1: [T-001 → I-001] (sequential pair)
     Wave 2: [T-002 → I-002] | [T-003 → I-003] | [T-004 → I-004] (parallel pairs)
     Wave 3: [T-005 → I-005] (sequential pair)

Output: execution-plan.md with 3 waves, 5 TDD pairs, dependency graph
```
