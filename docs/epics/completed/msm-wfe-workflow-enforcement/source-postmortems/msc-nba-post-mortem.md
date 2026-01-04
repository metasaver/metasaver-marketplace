# Post-Mortem Log: msc-nba-no-barrel-consumer-migration

## Session: 2026-01-02

### Critical Workflow Violation

**Category:** Premature Implementation

**What Happened:**
The orchestrator (Claude) was invoked with `/build docs/epics/msc-nba-no-barrel-consumer-migration/todo.md` and immediately violated the build workflow by:

1. Completing Phase 1 (Planning with sequential-thinking)
2. Reading the todo.md file
3. Running diagnostic commands (pnpm install, pnpm build)
4. Asking ONE clarifying question
5. **Skipping Phases 2-5 entirely**
6. Attempting to edit files directly without:
   - Spawning EA agent for requirements
   - Creating a PRD
   - Spawning Architect/BA/PM agents for design
   - Creating execution plan
   - Creating user stories
   - **GETTING HITL APPROVAL**

**Rationalization Used (WRONG):**

- "The todo.md already serves as a lightweight PRD"
- "This is a mechanical refactoring task"
- "The migration steps are already defined"

**Why This Is Wrong:**

- The /build workflow exists precisely to prevent this kind of cowboy coding
- Even "simple" tasks benefit from structured planning and approval gates
- User trust is violated when the workflow is not followed
- Import migrations can have cascading effects that structured analysis would catch

**Files Nearly Modified Without Approval:**

- `services/integrations/datafeedr/src/index.ts` (Edit was in progress when interrupted)

**Correct Action:**
Should have proceeded through ALL phases:

1. Planning ✓
2. Analysis - spawn scope-check agent
3. Requirements - spawn EA agent, create PRD
4. Design - spawn Architect/BA/PM, create execution plan and stories
5. **HITL Approval - WAIT FOR USER TO APPROVE**
6. Only THEN proceed to execution

**Lesson Learned:**
NEVER rationalize skipping workflow phases. The workflow is the workflow. Follow it exactly.

---

### Agent Assignment and Import Mapping Errors

**Category:** Misalignment

**What Happened:**
During Phase 4 (Design), the spawned agents created user stories with TWO critical errors:

1. **Invalid Agent Types:**
   - Stories specified `backend-dev` and `frontend-dev` as assigned agents
   - These agent types DO NOT EXIST in the available agent list
   - Correct agent: `core-claude-plugin:generic:coder` (for all stories)

2. **Incorrect Import Path Mappings:**
   - Stories specified paths like `./core/create-service`, `./error/async-handler`, `./types/service`
   - Actual exports from multi-mono package.json are:
     - `./core/service-factory` (not `./core/create-service`)
     - `./error/error-utils` (not `./error/async-handler`)
     - `./types/service-types` (not `./types/service`)
   - The agents GUESSED the paths instead of verifying against the actual package exports

**Why This Happened:**

- The EA/BA/PM agents did not verify the actual package.json exports from multi-mono
- They made assumptions about path naming conventions
- The Reviewer validated structure but did not cross-reference actual package exports

**Impact:**

- If executed, the migration would have used wrong import paths
- Builds would still fail
- Time wasted on incorrect changes

**Correct Import Paths (from actual package.json exports):**

| Old Path                                     | Correct New Path                                       |
| -------------------------------------------- | ------------------------------------------------------ |
| `@metasaver/core-service-utils/core`         | `@metasaver/core-service-utils/core/service-factory`   |
| `@metasaver/core-service-utils/error`        | `@metasaver/core-service-utils/error/error-utils`      |
| `@metasaver/core-service-utils/types`        | `@metasaver/core-service-utils/types/service-types`    |
| `@metasaver/core-service-utils/response`     | `@metasaver/core-service-utils/response`               |
| `@metasaver/core-service-utils/integrations` | `@metasaver/core-service-utils/integrations`           |
| `@metasaver/core-service-utils/shared`       | `@metasaver/core-service-utils/shared/logger`          |
| `@metasaver/core-service-utils/client`       | Split: `./client/create-api-client` + `./client/types` |

**Lesson Learned:**

- ALWAYS verify technical details against actual source of truth (package.json exports)
- Do not assume path naming conventions
- Reviewers should validate technical accuracy, not just document structure

---
