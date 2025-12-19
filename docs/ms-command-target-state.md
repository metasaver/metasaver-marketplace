# MS Command Target State

Target workflow architecture for the `/ms` (MetaSaver) command - the universal entry point.

**Purpose:** Universal entry point for all MetaSaver workflows. Routes to appropriate command, tracks workflow state, enables continuation after HITL stops.

**Use /ms for everything.** It handles:

- New work → Routes to /build, /audit, /architect, /debug, /qq
- Continuation → Resumes interrupted workflows at correct step
- State tracking → PM updates workflow-state.json throughout execution

---

## 1. High-Level Flow Overview

```mermaid
flowchart TB
    subgraph P1["Phase 1: Entry + State Check"]
        E1["Parse prompt"]:::step
        E2["Check for workflow-state.json"]:::step
        E3{{"Active workflow?"}}:::decision
        E1 --> E2 --> E3
    end

    subgraph P2_RESUME["Phase 2a: Resume Workflow"]
        R1["Read workflow-state.json"]:::step
        R2["Read execution-plan.md"]:::step
        R3["Read story statuses"]:::step
        R4["Identify phase + step"]:::step
        R5["Route to workflow at step"]:::step
        R1 --> R2 --> R3 --> R4 --> R5
    end

    subgraph P2_NEW["Phase 2b: New Workflow (PARALLEL)"]
        N1["/skill complexity-check"]:::skill
        N2["/skill scope-check"]:::skill
        N3["/skill tool-check"]:::skill
    end

    E3 -->|Yes| P2_RESUME
    E3 -->|No| P2_NEW

    subgraph P3["Phase 3: Route to Command"]
        RT{{"Task type?"}}:::decision
    end

    N1 & N2 & N3 --> P3
    R5 --> EXEC

    RT -->|"Build feature"| BUILD["/build"]:::command
    RT -->|"Audit configs"| AUDIT["/audit"]:::command
    RT -->|"Plan/explore"| ARCH["/architect"]:::command
    RT -->|"Browser debug"| DEBUG["/debug"]:::command
    RT -->|"Quick question"| QQ["/qq"]:::command

    BUILD & AUDIT & ARCH & DEBUG & QQ --> EXEC

    subgraph EXEC["Phase 4: Execution with State Tracking"]
        EX1["PM reads execution plan"]:::step
        EX2["PM spawns wave agents"]:::step
        EX3["Agents update story status"]:::step
        EX4["PM saves workflow-state.json"]:::step
        EX5{{"HITL needed?"}}:::decision
        EX1 --> EX2 --> EX3 --> EX4 --> EX5
    end

    EX5 -->|No| NEXT{{"More waves?"}}:::decision
    EX5 -->|Yes| STOP["Save state + HITL stop"]:::hitl

    NEXT -->|Yes| EX2
    NEXT -->|No| VAL

    subgraph VAL["Phase 5: Validate"]
        V1["/skill production-check"]:::skill
        V2["/skill repomix-cache-refresh"]:::skill
        V1 --> V2
    end

    VAL --> DONE((Complete))

    STOP --> WAIT["User responds with /ms"]:::hitl
    WAIT --> P1

    classDef step fill:#e1e1e1,stroke:#333
    classDef skill fill:#fff3cd,stroke:#333
    classDef command fill:#cce5ff,stroke:#333
    classDef decision fill:#f8d7da,stroke:#333
    classDef hitl fill:#d4edda,stroke:#333
```

---

## 2. Phase Details

### Phase 1: Entry + State Check

```mermaid
flowchart LR
    C1["Look for docs/projects/*/workflow-state.json"]:::step
    C2["Check TodoWrite for workflow todos"]:::step
    C3["Parse prompt for continuation cues"]:::step
    C4{{"Active workflow?"}}:::decision
    C1 --> C2 --> C3 --> C4
    C4 -->|Yes| RESUME["Phase 2a"]:::command
    C4 -->|No| NEW["Phase 2b"]:::command

    classDef step fill:#e1e1e1,stroke:#333
    classDef command fill:#cce5ff,stroke:#333
    classDef decision fill:#f8d7da,stroke:#333
```

**State detection priority:**

1. `workflow-state.json` in most recent project folder
2. TodoWrite items with workflow phase markers
3. User prompt contains: "continue", "proceed", "yes", "do it"

---

### Phase 2a: Resume Workflow

```mermaid
flowchart TB
    R1["Read workflow-state.json"]:::step
    R2["Extract: command, phase, step, wave"]:::step
    R3["Read execution-plan.md"]:::step
    R4["Read story files for status"]:::step
    R5["Route to workflow at step"]:::step
    R1 --> R2 --> R3 --> R4 --> R5

    R5 --> ROUTE{{"Resume at?"}}:::decision
    ROUTE -->|"approval_waiting"| APP["Present plan, get approval"]:::hitl
    ROUTE -->|"executing"| EXEC["Continue at wave N"]:::step
    ROUTE -->|"hitl_waiting"| INPUT["Process user response"]:::step

    classDef step fill:#e1e1e1,stroke:#333
    classDef hitl fill:#d4edda,stroke:#333
    classDef decision fill:#f8d7da,stroke:#333
```

---

### Phase 2b: New Workflow Analysis (PARALLEL)

**See:** `/skill complexity-check`, `/skill scope-check`, `/skill tool-check`

Spawn 3 skills in parallel:

- `complexity-check` → score (1-50)
- `scope-check` → targets and references
- `tool-check` → required MCP tools

---

### Phase 3: Route to Command

| Condition                                              | Route To   |
| ------------------------------------------------------ | ---------- |
| complexity < 15 AND question only                      | /qq        |
| "audit", "validate", "check" + config files            | /audit     |
| "debug", "browser", "UI test"                          | /debug     |
| vague requirements, "plan", "explore", "design"        | /architect |
| clear requirements, "build", "implement", "add", "fix" | /build     |

---

### Phase 4: Execution with State Tracking

**PM manages execution and state:**

```mermaid
flowchart TB
    EX1["PM reads execution-plan.md"]:::step
    EX2["PM identifies current wave"]:::step

    subgraph WAVE["Wave N"]
        W1["Update workflow-state: wave started"]:::step
        W2["Spawn agents for stories (parallel)"]:::step
        W3["Agents execute + update story status"]:::step
        W4["PM collects results"]:::step
        W1 --> W2 --> W3 --> W4
    end

    EX3["PM updates execution-plan.md"]:::step
    EX4["PM saves workflow-state.json"]:::step
    EX5{{"HITL needed?"}}:::decision

    EX1 --> EX2 --> WAVE --> EX3 --> EX4 --> EX5

    EX5 -->|Yes| STOP["Save state, HITL stop"]:::hitl
    EX5 -->|No| MORE{{"More waves?"}}:::decision
    MORE -->|Yes| WAVE
    MORE -->|No| VAL["Phase 5: Validate"]:::step

    classDef step fill:#e1e1e1,stroke:#333
    classDef hitl fill:#d4edda,stroke:#333
    classDef decision fill:#f8d7da,stroke:#333
```

**PM responsibilities during execution:**

| When            | PM Action                                                     |
| --------------- | ------------------------------------------------------------- |
| Wave start      | Update workflow-state: `currentWave`, stories to `inProgress` |
| Agent completes | Update story file status, move to `completed`                 |
| Wave complete   | Update execution-plan.md with results                         |
| HITL needed     | Set `status: hitl_waiting`, save `hitlQuestion`               |
| Error occurs    | Set `status: error`, save error details                       |
| All waves done  | Trigger Phase 5: Validate                                     |

---

### Phase 5: Validate

If files were modified:

1. `/skill production-check` - build, lint, test
2. `/skill repomix-cache-refresh` - update cache
3. Clear workflow-state.json (workflow complete)

---

## 3. Workflow State File

Location: `docs/projects/{name}/workflow-state.json`

```json
{
  "command": "build",
  "phase": 5,
  "phaseName": "Execution",
  "step": "wave-execution",
  "currentWave": 2,
  "totalWaves": 3,
  "status": "hitl_waiting",
  "lastUpdate": "2025-12-19T10:30:00Z",
  "epics": [
    {
      "id": "EPIC-001",
      "status": "in_progress",
      "storiesCompleted": 2,
      "storiesTotal": 3
    }
  ],
  "stories": {
    "completed": ["US-001", "US-002"],
    "inProgress": [],
    "pending": ["US-003", "US-004", "US-005"]
  },
  "hitlQuestion": "Wave 2 complete. Proceed with wave 3?",
  "resumeAction": "spawn-wave-3"
}
```

**Status values:**

| Status             | Meaning                            |
| ------------------ | ---------------------------------- |
| `analysis`         | Running analysis phase             |
| `requirements`     | BA creating PRD/epics/stories      |
| `design`           | Architect enriching stories        |
| `approval_waiting` | Waiting for user approval          |
| `executing`        | Running execution waves            |
| `hitl_waiting`     | Stopped for user input             |
| `validating`       | Running production checks          |
| `complete`         | Workflow finished                  |
| `error`            | Error occurred, needs intervention |

---

## 4. Model Selection

| Complexity | BA     | Workers |
| ---------- | ------ | ------- |
| 1-14       | sonnet | sonnet  |
| 15-29      | sonnet | sonnet  |
| 30+        | opus   | sonnet  |

---

## 5. Examples

```bash
# New build task
/ms "add user authentication to the app"
→ Phase 1: No active workflow
→ Phase 2b: Analysis (complexity=28)
→ Phase 3: Route to /build
→ /build executes with state tracking

# Continue after HITL stop
/ms "yes, proceed with the next wave"
→ Phase 1: Found workflow-state.json (build, wave 2, hitl_waiting)
→ Phase 2a: Resume at wave 3
→ Phase 4: PM spawns wave 3 agents

# Answer clarifying question mid-workflow
/ms "use JWT tokens, not sessions"
→ Phase 1: Found workflow-state.json (build, requirements, hitl_waiting)
→ Phase 2a: Resume requirements phase
→ BA incorporates answer, continues

# Quick question (no workflow state)
/ms "how does the auth middleware work?"
→ Phase 1: No active workflow
→ Phase 2b: Analysis (complexity=5)
→ Phase 3: Route to /qq
→ /qq spawns code-explorer, answers

# Audit task
/ms "check if eslint config matches our standards"
→ Phase 1: No active workflow
→ Phase 2b: Analysis (scope=config files)
→ Phase 3: Route to /audit
→ /audit executes with state tracking
```

---

## 6. Enforcement

1. ALL work goes through /ms (except simple questions answered directly)
2. /ms ALWAYS checks for active workflow state first
3. /ms ALWAYS routes to MetaSaver commands (/build, /audit, /architect, /debug, /qq)
4. /ms routes to commands, commands use MetaSaver agents - NEVER spawn generic agents directly
5. PM ALWAYS updates workflow-state.json after each wave
6. PM ALWAYS updates story files with status changes
7. HITL stops ALWAYS save state for resumption
8. User responses via /ms resume at correct workflow step
9. Track all tasks with TodoWrite
10. Get user approval before any git operations

---

## 7. Command Routing Summary

| /ms is...             | Routes to        | Why                           |
| --------------------- | ---------------- | ----------------------------- |
| Universal entry point | All commands     | Single point of enforcement   |
| State-aware           | Resume or new    | Enables workflow continuation |
| Router only           | Commands do work | Separation of concerns        |

**/ms routes. Commands execute. Agents work. PM tracks state.**

---

## 8. Migration from Old /ms

**Old behavior:**

- /ms spawned BA directly
- /ms spawned agents directly
- No state tracking
- HITL broke workflows

**New behavior:**

- /ms checks state first
- /ms routes to commands
- Commands handle their workflows
- PM tracks state throughout
- /ms resumes workflows after HITL
