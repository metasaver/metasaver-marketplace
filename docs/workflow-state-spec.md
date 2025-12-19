# Workflow State Schema Specification

## Overview

`workflow-state.json` tracks active workflow progress for `/ms` continuation support. This file enables the PM to resume workflows after HITL (Human-in-the-Loop) stops, ensuring seamless continuation of complex multi-phase tasks.

## Purpose

- Track current workflow phase, step, and wave
- Enable workflow resumption after interruptions
- Coordinate epic and story progress across execution waves
- Support HITL question/answer cycles
- Provide PM with complete context for continuation

## Location

`docs/projects/{yyyymmdd}-{name}/workflow-state.json`

Example: `docs/projects/20251219-positive-reinforcement-hooks/workflow-state.json`

## Schema

### Required Fields

| Field         | Type   | Description                                    | Example                                |
| ------------- | ------ | ---------------------------------------------- | -------------------------------------- |
| `command`     | string | Active command being executed                  | "build", "audit", "architect", "debug" |
| `phase`       | number | Current phase number (1-5)                     | 4                                      |
| `phaseName`   | string | Human-readable phase name                      | "Execution"                            |
| `step`        | string | Current step identifier                        | "wave-execution"                       |
| `currentWave` | number | Current execution wave (0 if not in execution) | 2                                      |
| `totalWaves`  | number | Total planned waves                            | 3                                      |
| `status`      | string | Workflow status (see enum below)               | "hitl_waiting"                         |
| `lastUpdate`  | string | ISO 8601 timestamp of last update              | "2025-12-19T10:30:00Z"                 |

### Status Enum

Defines all valid workflow states for proper resumption routing.

| Status             | Description                                           | Resume Action                 |
| ------------------ | ----------------------------------------------------- | ----------------------------- |
| `analysis`         | Running analysis phase (complexity/scope/tool checks) | Continue analysis             |
| `requirements`     | BA creating PRD/epics/stories                         | Continue BA work              |
| `design`           | Architect enriching stories with technical details    | Continue architect work       |
| `approval_waiting` | Waiting for user approval of execution plan           | Present plan for approval     |
| `executing`        | Running execution waves                               | Continue at current wave      |
| `hitl_waiting`     | Stopped for user input (question asked)               | Process user response         |
| `validating`       | Running production checks (build/lint/test)           | Continue validation           |
| `complete`         | Workflow finished successfully                        | No action needed              |
| `error`            | Error occurred, needs intervention                    | Review error, decide recovery |

### Epic Tracking

`epics`: Array of epic progress objects

Each epic object contains:

| Field              | Type   | Description                              | Example                              |
| ------------------ | ------ | ---------------------------------------- | ------------------------------------ |
| `id`               | string | Epic identifier                          | "EPIC-001"                           |
| `status`           | string | Epic status                              | "pending", "in_progress", "complete" |
| `storiesCompleted` | number | Number of completed stories in this epic | 2                                    |
| `storiesTotal`     | number | Total stories in this epic               | 3                                    |

**Example:**

```json
"epics": [
  {
    "id": "EPIC-001",
    "status": "in_progress",
    "storiesCompleted": 2,
    "storiesTotal": 3
  },
  {
    "id": "EPIC-002",
    "status": "pending",
    "storiesCompleted": 0,
    "storiesTotal": 2
  }
]
```

### Story Tracking

`stories`: Object with three arrays tracking story lifecycle

| Field        | Type     | Description                         | Example              |
| ------------ | -------- | ----------------------------------- | -------------------- |
| `completed`  | string[] | Story IDs that have been completed  | ["US-001", "US-002"] |
| `inProgress` | string[] | Story IDs currently being worked on | ["US-003"]           |
| `pending`    | string[] | Story IDs not yet started           | ["US-004", "US-005"] |

**Example:**

```json
"stories": {
  "completed": ["US-001", "US-002"],
  "inProgress": ["US-003"],
  "pending": ["US-004", "US-005", "US-006"]
}
```

### HITL Fields

Optional fields used when workflow stops for user input.

| Field          | Type   | Required | Description                 | Example                                 |
| -------------- | ------ | -------- | --------------------------- | --------------------------------------- |
| `hitlQuestion` | string | No       | Last question asked to user | "Wave 2 complete. Proceed with wave 3?" |
| `resumeAction` | string | No       | Action to take when resumed | "spawn-wave-3"                          |

**Example:**

```json
"hitlQuestion": "Wave 2 complete. Proceed with wave 3?",
"resumeAction": "spawn-wave-3"
```

## Complete Schema Example

```json
{
  "command": "build",
  "phase": 4,
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
    },
    {
      "id": "EPIC-002",
      "status": "pending",
      "storiesCompleted": 0,
      "storiesTotal": 2
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

## PM Update Responsibilities

The PM (Project Manager agent) is responsible for maintaining `workflow-state.json` throughout the workflow lifecycle.

| Event             | PM Action                       | Fields Updated                                                          |
| ----------------- | ------------------------------- | ----------------------------------------------------------------------- |
| Workflow start    | Create workflow-state.json      | All required fields, `status: "analysis"`                               |
| Phase transition  | Update phase and status         | `phase`, `phaseName`, `status`, `lastUpdate`                            |
| Wave start        | Update wave counter and stories | `currentWave`, move stories to `inProgress`, `lastUpdate`               |
| Story completion  | Update story status             | Move story to `completed`, update epic `storiesCompleted`, `lastUpdate` |
| Wave completion   | Prepare next wave               | Clear `inProgress`, `lastUpdate`                                        |
| HITL stop         | Save question and context       | `status: "hitl_waiting"`, `hitlQuestion`, `resumeAction`, `lastUpdate`  |
| Error occurs      | Mark error state                | `status: "error"`, `lastUpdate`                                         |
| Workflow complete | Mark complete                   | `status: "complete"`, `lastUpdate`                                      |

## Resume Logic

When `/ms` finds an active `workflow-state.json`:

1. **Read** workflow state
2. **Check** status field
3. **Route** to appropriate handler:

| Status             | Resume Handler                                |
| ------------------ | --------------------------------------------- |
| `analysis`         | Continue analysis phase                       |
| `requirements`     | Resume BA work                                |
| `design`           | Resume architect work                         |
| `approval_waiting` | Present plan, get approval                    |
| `executing`        | Resume at `currentWave`                       |
| `hitl_waiting`     | Process user response, execute `resumeAction` |
| `validating`       | Continue validation                           |
| `complete`         | Inform user, no action needed                 |
| `error`            | Review error, consult user                    |

## State Cleanup

- **During workflow**: PM updates state after each significant event
- **On completion**: PM sets `status: "complete"` (file remains for audit trail)
- **On error**: PM sets `status: "error"` with error details
- **After validation**: PM can optionally archive or remove state file

## Validation Rules

- `command` must be one of: "build", "audit", "architect", "debug"
- `phase` must be 1-5
- `status` must match enum values
- `currentWave` must be 0 or positive integer <= `totalWaves`
- `totalWaves` must be positive integer
- `lastUpdate` must be valid ISO 8601 timestamp
- Epic IDs in `epics` must match IDs in story files
- Story IDs in `stories` must exist in story files
- Story arrays must not contain duplicates
- Story must appear in exactly one array (completed/inProgress/pending)

## Benefits

1. **Seamless Resumption**: User can continue workflows with simple "/ms continue"
2. **Context Preservation**: PM knows exact state and next action
3. **Progress Tracking**: Clear view of epic/story completion
4. **HITL Support**: Questions and context preserved across interruptions
5. **Error Recovery**: Error state captured for debugging and recovery
6. **Audit Trail**: Complete workflow history preserved in state file
