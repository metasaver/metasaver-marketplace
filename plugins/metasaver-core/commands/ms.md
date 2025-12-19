---
name: ms
description: Intelligent MetaSaver command that analyzes complexity and routes optimally
---

# MetaSaver Command

Universal entry point for all MetaSaver workflows. Analyzes tasks, routes to appropriate commands, and resumes interrupted workflows.

**Use /ms for everything.** It routes to `/build`, `/audit`, `/architect`, `/debug`, or `/qq` based on task type.

---

## Workflow

```
Entry + State Check → Resume OR (New Analysis → Route to Command)
```

**New tasks:** Phase 1 → Phase 2b (Analysis) → Phase 3 (Route)
**Resuming:** Phase 1 → Phase 2a (Resume at correct step)

---

## Entry Handling

When /ms is invoked, ALWAYS proceed to Phase 1 regardless of prompt content.

---

## Phase 1: Entry + State Check

**See:** `/skill workflow-steps/state-management`

When /ms is invoked:

1. **Parse prompt** - Extract user intent from prompt text
2. **Check for active workflow:**
   - Glob for `docs/projects/*/workflow-state.json`
   - Read most recent (by folder date) workflow-state.json using `/skill workflow-steps/state-management`
   - Check status field: if not "complete" or "error", workflow is active
3. **Check TodoWrite** - Look for todo items with workflow phase markers
4. **Check continuation cues** - Prompt contains: "continue", "proceed", "yes", "do it", "approve"

**Decision:**

- Active workflow found → Phase 2a: Resume Workflow
- No active workflow → Phase 2b: New Workflow Analysis

**State Detection Priority:**

1. workflow-state.json in most recent project folder
2. TodoWrite items with workflow phase markers
3. User prompt continuation cues

---

## Phase 2a: Resume Workflow

**See:** `/skill workflow-steps/state-management`

When active workflow is detected:

1. Read workflow-state.json from project folder
2. Extract: command, phase, phaseName, step, currentWave, status
3. Read execution-plan.md (if exists)
4. Read story files for status (if executing)
5. Route to workflow at appropriate step based on status

**Resume routing by status:**

| Status           | Resume Action                                  |
| ---------------- | ---------------------------------------------- |
| analysis         | Continue analysis phase                        |
| requirements     | Resume BA PRD creation (process user response) |
| design           | Resume design phase                            |
| approval_waiting | Present plan, get approval                     |
| executing        | Continue at currentWave                        |
| hitl_waiting     | Process user response, continue workflow       |
| validating       | Continue validation phase                      |
| error            | Present error, ask user how to proceed         |

After routing determination, proceed to execution at identified step.

---

## Phase 2b: New Workflow Analysis (PARALLEL)

**See:** `/skill analysis-phase`

Spawn 3 agents in parallel:

- `complexity-check` → score (1-50)
- `tool-check` → required MCP tools
- `scope-check` → targets and references

---

## Phase 3: Route to Command

Based on analysis from Phase 2b, route to appropriate command:

**Routing Rules:**

| Trigger Keywords                             | Detected Scope        | Route To   |
| -------------------------------------------- | --------------------- | ---------- |
| None (question only)                         | complexity < 15       | /qq        |
| "audit", "validate", "check"                 | config files in scope | /audit     |
| "debug", "browser", "test UI"                | UI/E2E testing        | /debug     |
| "plan", "explore", "design", vague           | unclear requirements  | /architect |
| "build", "implement", "add", "fix", "create" | clear requirements    | /build     |

**Routing Priority:**

1. /qq - Simple questions (lowest complexity, no file changes)
2. /audit - Compliance/validation tasks (config files in scope)
3. /debug - Browser/E2E testing tasks (UI/testing keywords)
4. /architect - Exploration/planning tasks (vague requirements)
5. /build - Implementation tasks (default for complex work)

**Route Decision:**

After routing decision, /ms transfers control to the target command with:

- Original user prompt
- Analysis results (complexity, scope, tools)
- Any HITL answers collected during clarification

**Commands handle their own workflows** - each command (build, audit, architect, debug, qq) manages its execution, approval gates, and state tracking.

---

## Phase 4: Execution (Delegated to Commands)

After routing in Phase 3, execution is handled by the target command:

- `/build` → PRD creation, story extraction, wave execution
- `/audit` → Investigation, resolution, remediation
- `/architect` → Deep exploration and planning
- `/debug` → Browser testing workflow
- `/qq` → Direct answer (no execution phases)

**State Tracking During Execution:**

Each command uses `/skill workflow-steps/state-management` to:

1. Update workflow-state.json at wave start
2. Track story completion
3. Set HITL checkpoints between waves
4. Save resumption context

**Resumption Flow:**

When user returns to `/ms` after HITL stop:

1. Phase 1 detects active workflow from workflow-state.json
2. Phase 2a resumes at correct command and wave
3. Execution continues in routed command

**/ms does not execute directly** - it only routes and resumes.

---

## Phase 5: Validate (Delegated to Commands)

After execution completes in the routed command, validation is triggered:

**Validation Steps (handled by routed command):**

1. `/skill production-check` - Build, lint, test
2. `/skill repomix-cache-refresh` - Update cache
3. Clear workflow-state.json (workflow complete)

**Completion States:**

- `status: "complete"` - Workflow finished successfully
- `status: "error"` - Validation failed, needs intervention

**On Successful Completion:**

- workflow-state.json status set to "complete"
- User notified of completion
- Final report generated (if applicable)

**On Validation Failure:**

- workflow-state.json status set to "error"
- Error details saved
- User notified for intervention
- `/ms` can resume from error state after fix

**/ms validation behavior:**

When `/ms` resumes a workflow with `status: "error"`:

1. Phase 2a detects error status
2. Routes to original command with error context
3. Command attempts validation retry

---

## Examples

```bash
# New task: Simple question
/ms "how does the agent-selection skill work?"
→ Phase 1: No active workflow
→ Phase 2b: Analysis (complexity=5)
→ Phase 3: Route to /qq
→ /qq executes and answers

# New task: Build feature
/ms "add user authentication to the app"
→ Phase 1: No active workflow
→ Phase 2b: Analysis (complexity=28, scope=app files)
→ Phase 3: Route to /build
→ /build executes with state tracking

# New task: Audit configs
/ms "check if eslint config matches our standards"
→ Phase 1: No active workflow
→ Phase 2b: Analysis (scope=config files, "check" keyword)
→ Phase 3: Route to /audit
→ /audit executes investigation and remediation

# Resume workflow after HITL stop
/ms "yes, proceed with the next wave"
→ Phase 1: Found workflow-state.json (build, wave 2, hitl_waiting)
→ Phase 2a: Resume at wave 3
→ /build PM spawns wave 3 agents

# Answer clarifying question mid-workflow
/ms "use JWT tokens, not sessions"
→ Phase 1: Found workflow-state.json (build, requirements, hitl_waiting)
→ Phase 2a: Resume requirements phase
→ /build BA incorporates answer, continues

# Continue with approval after approval_waiting
/ms "approved, proceed"
→ Phase 1: Found workflow-state.json (build, approval_waiting)
→ Phase 2a: Resume at execution phase
→ /build executes plan

# New task: Debug UI issue
/ms "debug the login button in the browser"
→ Phase 1: No active workflow
→ Phase 2b: Analysis ("debug", "browser" keywords)
→ Phase 3: Route to /debug
→ /debug spawns browser and debugger

# New task: Plan architecture
/ms "explore options for implementing real-time notifications"
→ Phase 1: No active workflow
→ Phase 2b: Analysis ("explore" keyword, vague requirements)
→ Phase 3: Route to /architect
→ /architect creates design docs and proposes approach
```

---

## Enforcement

1. ALWAYS check for active workflow state first (Phase 1: Entry + State Check)
2. ALWAYS use `/skill workflow-steps/state-management` to read workflow-state.json
3. ALWAYS check for continuation cues in prompt ("continue", "proceed", "yes", "do it", "approve")
4. ALWAYS resume active workflows at the correct step (Phase 2a: Resume Workflow)
5. For new workflows: ALWAYS run Analysis phase (parallel: complexity, tools, scope)
6. ALWAYS route to appropriate command based on analysis results (Phase 3: Route to Command)
7. /ms is a ROUTER ONLY - commands handle execution, approval gates, state tracking
8. NEVER spawn agents directly from /ms - route to commands, which spawn agents
9. NEVER execute workflows directly from /ms - route to commands, which execute workflows
10. Track workflow state via commands (PM updates workflow-state.json)
11. All commands follow their own enforcement rules for execution
