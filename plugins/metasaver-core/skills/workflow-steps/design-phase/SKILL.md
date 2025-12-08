---
name: design-phase
description: Architecture design and execution planning workflow. Spawns architect agent for technical design, then project-manager agent to create execution plan with parallel waves. Outputs architecture docs and task assignments.
---

# Design Phase Skill

> **ROOT AGENT ONLY** - Spawns agents, runs only from root Claude Code agent.

**Purpose:** Create architecture design and execution plan
**Trigger:** After PRD approval (prd-approval or innovate-phase)
**Input:** `prdPath`, `complexity` (int), `tools` (string[]), `scope` (string[])
**Output:** `{architecture, executionPlan}`

---

## Workflow

**1. Spawn architect agent**

- Analyze PRD requirements
- Design architecture following MetaSaver patterns
- Create architecture documentation
- Identify components, services, interfaces
- Model selection: complexity ≥30 → Opus, else Sonnet

**2. Spawn project-manager agent**

- Read architecture docs
- Break down into implementable tasks
- Assign each task to domain agent
- Organize into parallel waves (max 10 agents/wave)
- Identify dependencies between tasks
- Model: Sonnet

---

## Model Selection

| Complexity | Architect | PM     |
| ---------- | --------- | ------ |
| 15-29      | sonnet    | sonnet |
| ≥30        | opus      | sonnet |

---

## Architecture Output Example

```json
{
  "overview": "JWT auth service with microservices",
  "components": [
    {
      "name": "UserService",
      "type": "backend-service",
      "responsibilities": ["User CRUD", "Auth"],
      "interfaces": ["REST API /api/users"],
      "dependencies": ["PrismaClient", "JWT"]
    }
  ],
  "dataFlow": "Request → Controller → Service → DB",
  "techDecisions": [
    { "decision": "JWT for auth", "rationale": "Stateless, scalable" }
  ]
}
```

---

## Execution Plan Output Example

```json
{
  "totalTasks": 4,
  "totalWaves": 2,
  "waves": [
    {
      "waveNumber": 1,
      "tasks": [
        {
          "id": "task-1",
          "description": "Create Prisma schema for users",
          "agent": "prisma-database-agent",
          "dependencies": []
        }
      ]
    },
    {
      "waveNumber": 2,
      "tasks": [
        {
          "id": "task-3",
          "description": "Implement UserService",
          "agent": "data-service-agent",
          "dependencies": ["task-1"]
        }
      ]
    }
  ]
}
```

---

## Agent Selection Guide

| Domain              | Agent(s)                                                |
| ------------------- | ------------------------------------------------------- |
| Backend API         | backend-dev, data-service-agent                         |
| Frontend components | react-component-agent, shadcn-component-agent           |
| Database            | prisma-database-agent                                   |
| Testing             | unit-test-agent, integration-test-agent, e2e-test-agent |
| Config files        | Specific config agent (eslint-agent, etc.)              |

---

## Integration

**Called by:**

- `/audit` command (after prd-approval)
- `/build` command (after innovate-phase)
- `/ms` command (for complexity ≥15)

**Calls:**

- `architect` agent (SME for architecture design)
- `project-manager` agent (SME for planning)

**Next step:** execution-phase (spawn domain workers)
