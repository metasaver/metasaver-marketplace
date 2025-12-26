---
name: design-phase
description: Extracts user stories from PRD, adds architecture annotations, and creates execution plan. Spawns BA to extract stories, architect to annotate, PM to plan parallel waves. Approval happens AFTER this phase so user sees full picture.
---

# Design Phase Skill

> **ROOT AGENT ONLY** - Spawns agents, runs only from root Claude Code agent.

**Purpose:** Extract stories from PRD, add architecture annotations, create execution plan
**Trigger:** After vibe-check passes (PRD is written)
**Input:** `prdPath` (string), `projectFolder` (string), `complexity` (int), `tools` (string[]), `scope` (string[])
**Output:** `{storiesFolder, storyFiles, annotatedStories, architectureNotes, executionPlan}`

---

## Workflow

**1. Spawn BA agent (extract-stories mode)**

- Read approved PRD from `prdPath`
- Create `user-stories/` folder in project folder
- Extract individual stories using `/skill user-story-template`
- **CRITICAL: Follow Story Granularity Guidelines** (see below)
- Create files: `US-001-{slug}.md`, `US-002-{slug}.md`, etc.
- Return paths to all story files

**2. Spawn architect agent**

- Read all story files from `storiesFolder`
- For each story file:
  - Read the story
  - Add "Architecture Notes" section (if not exists)
  - Fill in: API endpoints, key files, database models, component names, patterns
  - Save updated story file
- Optionally create `architecture-notes.md` for complex cross-cutting concerns
- Total output: 50-100 lines max (30 seconds of work)
- Model selection: complexity ≥30 → Opus, else Sonnet
- **DO:** Keep annotations inline in story files; avoid separate architecture documents, ADRs, detailed code, or component diagrams

**3. Spawn project-manager agent**

- Read annotated story files (with inline architecture notes)
- Break down into implementable tasks
- Assign each task to domain agent
- Organize into parallel waves (max 10 agents/wave)
- Identify dependencies between tasks based on story dependencies
- Output to `execution-plan.md` in project folder
- Model: Sonnet

---

## Story Granularity Guidelines (CRITICAL)

**ALWAYS create stories by functional capability, not by package/layer.** Package-based stories cause bottlenecks.

**BAD (package-based):**

```
US-001: Database changes      → 1 agent, 20 min
US-002: Contracts package     → 1 agent, 10 min
US-003: Workflow package      → 1 agent, 30 min (BOTTLENECK - too large!)
US-004: API layer             → 1 agent, 10 min
US-005: Frontend              → 1 agent, 15 min
```

**GOOD (functional capability-based):**

```
US-001: Database schema       → 1 agent
US-002: Contracts types       → 1 agent (parallel with US-001)
US-003a: Workflow scaffolding → 1 agent
US-003b: Height/weight parser → 1 agent (parallel)
US-003c: Team fuzzy matching  → 1 agent (parallel)
US-003d: Major entity parser  → 1 agent (parallel)
US-003e: Validation + upsert  → 1 agent (after US-003b-d)
US-004: API layer             → 1 agent
US-005: Frontend              → 1 agent
```

**Rules for Story Granularity:**

1. **Stories = Testable Units**: Each story should be independently testable
2. **Max 15-20 min per story**: If larger, break it down
3. **Parallel by default**: Stories in same layer should be parallelizable
4. **Dependency-aware**: Use `Depends On` field to show execution order
5. **Add `parallelizable_with` field**: Show which stories can run together

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

**Full Design Output (ready for plan-approval):**

```json
{
  "storiesFolder": "docs/projects/20251208-feature/user-stories/",
  "storyFiles": [
    "US-001-database-schema.md",
    "US-002-contracts-types.md",
    "US-003a-workflow-scaffolding.md",
    "US-003b-height-weight-parser.md",
    "US-003c-team-fuzzy-matching.md",
    "US-003d-major-entity-parser.md",
    "US-003e-validation-upsert.md",
    "US-004-api-layer.md",
    "US-005-frontend.md"
  ],
  "annotatedStories": [
    "user-stories/US-001-database-schema.md",
    "user-stories/US-002-contracts-types.md",
    "user-stories/US-003a-workflow-scaffolding.md"
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

- `/audit` command (after vibe-check)
- `/build` command (after vibe-check / innovate)
- `/ms` command (for complexity ≥15, after vibe-check)

**Calls:**

- `business-analyst` agent (extract-stories mode)
- `architect` agent (SME for architecture design)
- `project-manager` agent (SME for planning)

**Next step:** plan-approval (user sees PRD + stories + plan, then approves)
