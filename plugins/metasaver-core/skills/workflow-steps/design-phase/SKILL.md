---
name: design-phase
description: Lightweight architecture annotation and execution planning workflow. Spawns architect agent to add brief inline annotations to PRD user stories (50-100 lines, ~30 seconds), then project-manager agent to create execution plan with parallel waves. Outputs annotated PRD and task assignments.
---

# Design Phase Skill

> **ROOT AGENT ONLY** - Spawns agents, runs only from root Claude Code agent.

**Purpose:** Add lightweight architecture annotations to PRD and create execution plan
**Trigger:** After Human Validation (prd-approval phase)
**Input:** `prdPath`, `complexity` (int), `tools` (string[]), `scope` (string[])
**Output:** `{annotatedPrdPath, executionPlan}`

---

## Workflow

**1. Spawn architect agent**

- Read PRD user stories
- Add brief "Architecture:" subsections inline to each user story
- Annotate with: API endpoints, key files, database models, component names
- Total output: 50-100 lines max (30 seconds of work)
- Model selection: complexity ≥30 → Opus, else Sonnet
- **NOT:** Separate architecture documents, ADRs, detailed code, or component diagrams

**2. Spawn project-manager agent**

- Read annotated PRD (with inline architecture notes)
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

## Architecture Annotation Example

**PRD User Story (before):**

```
### User Story 3: User Registration
As a new user, I want to register an account so I can access the platform.
```

**PRD User Story (after architect annotation):**

```
### User Story 3: User Registration
As a new user, I want to register an account so I can access the platform.

**Architecture:**
- API: `POST /api/auth/register`
- Files: `services/auth/routes/auth.routes.ts`, `services/auth/controllers/auth.controller.ts`
- Database: Add User model with email, password, createdAt
- Component: `RegisterForm.tsx`
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
- `/build` command (after prd-approval / human validation)
- `/ms` command (for complexity ≥15, after prd-approval)

**Calls:**

- `architect` agent (SME for architecture design)
- `project-manager` agent (SME for planning)

**Next step:** execution-phase (spawn domain workers)
