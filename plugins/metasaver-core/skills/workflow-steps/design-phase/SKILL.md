---
name: design-phase
description: Lightweight architecture annotation and execution planning workflow. Spawns architect agent to add brief inline annotations to story files from user-stories/ folder (50-100 lines, ~30 seconds), then project-manager agent to create execution plan with parallel waves. Outputs annotated story files and task assignments.
---

# Design Phase Skill

> **ROOT AGENT ONLY** - Spawns agents, runs only from root Claude Code agent.

**Purpose:** Add lightweight architecture annotations to story files and create execution plan
**Trigger:** After Human Validation (prd-approval phase)
**Input:** `storiesFolder`, `storyFiles` (string[]), `complexity` (int), `tools` (string[]), `scope` (string[])
**Output:** `{annotatedStories, architectureNotes, executionPlan}`

---

## Workflow

**1. Spawn architect agent**

- Read all story files from `storiesFolder`
- For each story file:
  - Read the story
  - Add "Architecture Notes" section (if not exists)
  - Fill in: API endpoints, key files, database models, component names, patterns
  - Save updated story file
- Optionally create `architecture-notes.md` for complex cross-cutting concerns
- Total output: 50-100 lines max (30 seconds of work)
- Model selection: complexity ≥30 → Opus, else Sonnet
- **NOT:** Separate architecture documents, ADRs, detailed code, or component diagrams

**2. Spawn project-manager agent**

- Read annotated story files (with inline architecture notes)
- Break down into implementable tasks
- Assign each task to domain agent
- Organize into parallel waves (max 10 agents/wave)
- Identify dependencies between tasks based on story dependencies
- Output to `execution-plan.md` in project folder
- Model: Sonnet

---

## Model Selection

| Complexity | Architect | PM     |
| ---------- | --------- | ------ |
| 15-29      | sonnet    | sonnet |
| ≥30        | opus      | sonnet |

---

## Architecture Annotation Example

**Story File (before): `user-stories/US-003-user-registration.md`**

```markdown
# User Story 3: User Registration

**As a** new user
**I want to** register an account
**So that** I can access the platform

## Acceptance Criteria

- User can enter email and password
- Form validates input before submission
- User receives confirmation email
```

**Story File (after architect annotation):**

```markdown
# User Story 3: User Registration

**As a** new user
**I want to** register an account
**So that** I can access the platform

## Acceptance Criteria

- User can enter email and password
- Form validates input before submission
- User receives confirmation email

## Architecture Notes

- **API:** `POST /api/auth/register`
- **Files:** `services/auth/routes/auth.routes.ts`, `services/auth/controllers/auth.controller.ts`
- **Database:** User model (email, password, createdAt)
- **Components:** `RegisterForm.tsx`
- **Pattern:** Form validation + email service integration
```

---

## Output Format

**Annotated Stories:**

```json
{
  "annotatedStories": [
    "user-stories/US-001-view-list.md",
    "user-stories/US-002-add-item.md",
    "user-stories/US-003-user-registration.md"
  ],
  "architectureNotes": "architecture-notes.md",
  "executionPlan": "execution-plan.md"
}
```

**Execution Plan (`execution-plan.md`) Example:**

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
          "storyFiles": ["US-003-user-registration.md"],
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
          "storyFiles": ["US-003-user-registration.md"],
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
