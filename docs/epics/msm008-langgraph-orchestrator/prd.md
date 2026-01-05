---
project_id: "MSM-008"
title: "LangGraph Orchestrator Framework"
version: "2.1"
status: "draft"
created: "2026-01-04"
updated: "2026-01-04"
owner: "enterprise-architect-agent"
---

# PRD: LangGraph Orchestrator Framework

## 1. Executive Summary

The LangGraph Orchestrator Framework provides a deterministic workflow execution engine for Claude Code plugin workflows. Rather than implementing specific workflows, this framework delivers reusable node types, state management patterns, Zod schema validation with retry loops, and HITL (Human-in-the-Loop) primitives that workflow authors can compose into reliable, observable, and resumable workflows.

**Goal:** Deliver a production-ready framework that enables workflow authors to build deterministic, schema-validated, human-in-the-loop workflows that are debuggable in LangGraph Studio and runnable in production with Redis-backed persistence.

---

## 2. Problem Statement

### Current State

The MetaSaver plugin currently orchestrates workflows through Claude Code's native capabilities:

1. **Markdown-based command definitions** (`/build`, `/audit`, `/architect`) describe workflow phases
2. **Claude Code interprets** these commands and attempts to execute phases sequentially
3. **Task tool spawning** for sub-agents relies on Claude Code's judgment
4. **State management** via `workflow-state.json` is manually coordinated through skill pseudo-code

### Pain Points

| #   | Pain Point                         | Impact                                                                         | Evidence                                                         |
| --- | ---------------------------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------- |
| 1   | **Phase skipping**                 | Workflows jump from Requirements to Execution without Design phase             | Postmortem: workflows skip phases non-deterministically          |
| 2   | **Agent spawning failures**        | TDD pairs not created correctly; tester and coder agents not coordinated       | Postmortem: "Tester/Coder agent pairs not spawned correctly"     |
| 3   | **Template adherence failures**    | PRD, execution plan, and user story formats inconsistent across invocations    | User: "last 3 different Claude Code instances got formats wrong" |
| 4   | **State corruption**               | Lost progress, context exhaustion, workflow-state.json not updated             | Postmortem: "workflow-state.json not updated consistently"       |
| 5   | **Gate bypassing**                 | PRD enforcement gates not checked; stories created without PRD                 | Postmortem: "Gate bypassing" documented                          |
| 6   | **No deterministic state machine** | Workflow transitions rely on LLM interpretation rather than programmatic logic | Architectural gap                                                |
| 7   | **Context window exhaustion**      | Long workflows exhaust context, losing state and requiring manual intervention | User-reported issue                                              |
| 8   | **Difficult debugging**            | No visibility into workflow state transitions or execution history             | No observability tooling                                         |

### Root Cause

The fundamental issue is **relying on LLM interpretation for workflow control flow**. LLMs are non-deterministic by nature. When the workflow engine IS the LLM, you get non-deterministic workflows.

**Solution:** Move control flow to a deterministic state machine (LangGraph) while using LLMs only for content generation within validated output contracts.

---

## 3. Solution Overview

### Target State

A reusable framework that provides:

1. **Deterministic workflow engine** - LangGraph.js state machine controls all transitions
2. **Schema-validated outputs** - Every LLM output passes Zod validation with retry loop
3. **HITL node primitives** - Four types of human checkpoints available to workflow authors
4. **Persistent state** - Redis-backed checkpointing for pause/resume
5. **Observability** - LangGraph Studio for debugging, LangSmith/Langfuse for production traces
6. **Agent spawning** - Claude Agent SDK wrapper with circuit breaker pattern

### What This Is / What This Is Not

| This IS                                         | This is NOT                          |
| ----------------------------------------------- | ------------------------------------ |
| A workflow framework (node library)             | A specific workflow implementation   |
| Reusable HITL node types                        | A complete /build or /audit workflow |
| Zod schema validation patterns                  | Business logic for PRD generation    |
| State management with Redis                     | GitHub Issues/Milestones integration |
| LangGraph Studio runnable project               | A VSCode extension (that's Phase 2)  |
| Documentation and examples for workflow authors | End-user documentation               |

### Core Principles

| #   | Principle                      | Description                                                         |
| --- | ------------------------------ | ------------------------------------------------------------------- |
| 1   | **Framework over workflow**    | Build primitives, not the /build command                            |
| 2   | **Deterministic control flow** | State machine controls transitions; LLMs generate content only      |
| 3   | **Schema-first**               | Every agent output has a Zod schema; validation happens before use  |
| 4   | **HITL-native**                | Human checkpoints are first-class primitives, not afterthoughts     |
| 5   | **Observable by default**      | Every node execution is traced and inspectable                      |
| 6   | **Fail gracefully**            | Circuit breakers, retries, and HITL escalation on repeated failures |
| 7   | **Compose, don't configure**   | Workflow authors build graphs from primitives, not config files     |

### Design Decisions

Key architectural decisions made during requirements analysis:

| Decision               | Choice                          | Rationale                                                                                     |
| ---------------------- | ------------------------------- | --------------------------------------------------------------------------------------------- |
| Orchestration engine   | LangGraph.js                    | Deterministic state machine with built-in HITL support and visual debugging                   |
| Project type           | Framework (not workflow)        | Enables reuse across /build, /audit, /architect; workflows built separately to test framework |
| State persistence      | Redis only (no SQLite fallback) | Production-grade persistence; SQLite adds complexity without proportional benefit             |
| Deployment environment | Docker-only                     | Consistent cross-platform behavior; avoids local Redis installation complexity                |
| Schema validation      | Zod                             | Runtime validation with TypeScript inference; widely adopted in TypeScript ecosystem          |
| Agent spawning         | Claude Agent SDK                | Official SDK provides stable interface for Claude Code integration                            |
| Retry strategy         | Exponential backoff with jitter | Prevents thundering herd; graceful degradation under load                                     |
| HITL approach          | LangGraph interrupt() primitive | Native support for pause/resume with persistent state                                         |
| Observability          | LangSmith/Langfuse (optional)   | Zero-config tracing when enabled; no observability lock-in                                    |
| Module format          | ESM only                        | Modern standard; better tree-shaking; aligned with LangGraph ecosystem                        |

---

## 4. Requirements

### Functional Requirements - Phase 1: Framework

| ID     | Requirement                                                      | Priority | Category       |
| ------ | ---------------------------------------------------------------- | -------- | -------------- |
| FR-001 | Package structure in `packages/langgraph-orchestrator/`          | P0       | Foundation     |
| FR-002 | LangGraph.js core setup with TypeScript                          | P0       | Foundation     |
| FR-003 | Zod schema validation with 3-retry loop and error feedback       | P0       | Validation     |
| FR-004 | HITL node type: Requirements Clarification (ask questions)       | P0       | HITL           |
| FR-005 | HITL node type: Approval Gate (approve/reject with feedback)     | P0       | HITL           |
| FR-006 | HITL node type: Add Instructions (inject context mid-workflow)   | P0       | HITL           |
| FR-007 | HITL node type: Interrupt/Resume (pause and continue later)      | P0       | HITL           |
| FR-008 | Redis checkpointer using `@langchain/langgraph-checkpoint-redis` | P0       | Persistence    |
| FR-009 | Docker Redis service (docker-compose.yml)                        | P0       | Persistence    |
| FR-010 | LangGraph Studio integration (`langgraph.json` config)           | P0       | Debugging      |
| FR-011 | LangSmith/Langfuse observability via environment variables       | P1       | Observability  |
| FR-012 | Claude Agent SDK wrapper with circuit breaker                    | P0       | Agent Spawning |
| FR-013 | Exponential backoff with jitter for retries                      | P0       | Resilience     |
| FR-014 | Configurable failure thresholds and recovery timeouts            | P1       | Resilience     |
| FR-015 | Example workflow graph demonstrating all node types              | P0       | Documentation  |
| FR-016 | TypeScript strict mode, ESM modules                              | P0       | Foundation     |
| FR-017 | Build pipeline (tsc compilation, dist/ output)                   | P0       | Foundation     |
| FR-018 | npm script `dev` for LangGraph Studio (`langgraph dev`)          | P0       | Developer UX   |
| FR-019 | Automatic tracing of all graph node executions                   | P1       | Observability  |
| FR-020 | Health check endpoint for circuit breaker state                  | P2       | Operations     |

### Functional Requirements - Phase 2: Adapters

| ID     | Requirement                                           | Priority | Category    |
| ------ | ----------------------------------------------------- | -------- | ----------- |
| FR-021 | VSCode extension adapter for workflow execution       | P1       | Integration |
| FR-022 | Claude Code CLI adapter for command-line invocation   | P1       | Integration |
| FR-023 | REST API endpoint for programmatic workflow access    | P2       | Integration |
| FR-024 | MCP server wrapper for Claude Code native integration | P2       | Integration |

### Non-Functional Requirements

| ID      | Requirement                                        | Priority |
| ------- | -------------------------------------------------- | -------- |
| NFR-001 | TypeScript strict mode enabled                     | P0       |
| NFR-002 | Build completes in < 30 seconds                    | P1       |
| NFR-003 | LangGraph Studio starts in < 10 seconds            | P1       |
| NFR-004 | Redis handles concurrent state access safely       | P0       |
| NFR-005 | Workflow state recoverable after process crash     | P0       |
| NFR-006 | Error messages include actionable context          | P1       |
| NFR-007 | All node executions traced in LangSmith/Langfuse   | P1       |
| NFR-008 | Circuit breaker state queryable via health check   | P2       |
| NFR-009 | Framework documentation enables workflow authoring | P0       |
| NFR-010 | Zod schemas exported for consumer use              | P0       |

---

## 5. Scope

### In Scope - Phase 1 (Framework)

1. **LangGraph workflow framework** - Core state machine setup with TypeScript
2. **Node library** - Reusable node types for common patterns:
   - Validation nodes (Zod schema + retry loop)
   - HITL nodes (4 types: clarification, approval, add-instructions, interrupt/resume)
   - Agent spawning nodes (Claude Agent SDK wrapper)
   - Conditional routing nodes (if-gates, routing logic)
3. **State management** - Redis-backed checkpointing with TTL
4. **Zod schema library** - Schemas for common artifacts (PRD, execution plan, user story)
5. **Resilience patterns** - Circuit breaker, exponential backoff with jitter
6. **LangGraph Studio integration** - Runnable project for visual debugging
7. **Documentation** - Workflow authoring guide with examples
8. **Example workflow** - Single example demonstrating all node types

### In Scope - Phase 2 (Adapters)

1. **VSCode extension integration** - Run workflows from VSCode
2. **Claude Code CLI integration** - Invoke workflows from command line
3. **REST API endpoint** - Programmatic workflow access

### Out of Scope

| Item                                 | Reason                                                     |
| ------------------------------------ | ---------------------------------------------------------- |
| `/build` workflow implementation     | User will build workflows phase-by-phase to test framework |
| `/audit` workflow implementation     | Framework focus; workflows built separately                |
| `/architect` workflow implementation | Framework focus; workflows built separately                |
| `/ms` workflow implementation        | Framework focus; workflows built separately                |
| GitHub Issues/Milestones integration | Build nodes when needed; not a framework requirement       |
| SQLite checkpointer                  | Redis-only for production-grade persistence                |
| Local Redis fallback                 | Docker Redis only (user confirmed)                         |
| npm package publishing               | Bundled distribution approach                              |
| UI/Dashboard                         | LangGraph Studio serves as the UI                          |

---

## 6. Epic Summary

Phase 1 (Framework) delivery broken into implementation waves:

| Epic ID | Title                       | Story Count | Complexity | Wave | Dependencies |
| ------- | --------------------------- | ----------- | ---------- | ---- | ------------ |
| E01     | Foundation & Package Setup  | 4           | 8          | 1    | None         |
| E02     | Persistence & Checkpointing | 3           | 6          | 1    | None         |
| E03     | Schema Library              | 4           | 8          | 2    | E01          |
| E04     | HITL Node Library           | 5           | 12         | 2    | E01          |
| E05     | Resilience Patterns         | 3           | 8          | 3    | E01          |
| E06     | Agent Spawning              | 2           | 6          | 3    | E05          |
| E07     | Example Workflow            | 2           | 5          | 4    | E03, E04     |
| E08     | Documentation               | 2           | 4          | 4    | E07          |

**Phase 1 Totals:** 8 epics, ~25 stories, ~57 complexity points

### Epic Descriptions

**E01: Foundation & Package Setup**

- Package structure in `packages/langgraph-orchestrator/`
- TypeScript configuration (strict mode, ESM)
- Build pipeline (tsc compilation)
- LangGraph Studio configuration (`langgraph.json`)

**E02: Persistence & Checkpointing**

- Docker Compose for Redis service
- Redis checkpointer integration
- TTL configuration for state cleanup

**E03: Schema Library**

- PRD schema with frontmatter validation
- Execution plan schema
- User story schema
- Common shared types

**E04: HITL Node Library**

- Requirements clarification node
- Approval gate node
- Add-instructions node
- Interrupt/resume node
- HITL node factory pattern

**E05: Resilience Patterns**

- Circuit breaker implementation
- Exponential backoff with jitter
- Configurable failure thresholds

**E06: Agent Spawning**

- Claude Agent SDK wrapper
- Integration with circuit breaker
- Spawn configuration options

**E07: Example Workflow**

- Demo workflow demonstrating all node types
- LangGraph Studio runnable example

**E08: Documentation**

- Workflow authoring guide
- API reference for node factories

---

## 7. Technical Architecture

### Technology Stack

| Component         | Technology                            | Version | Rationale                              |
| ----------------- | ------------------------------------- | ------- | -------------------------------------- |
| Runtime           | Node.js                               | 20+     | LTS, ESM support                       |
| Language          | TypeScript                            | 5.x     | Type safety, strict mode               |
| Orchestration     | @langchain/langgraph                  | latest  | Deterministic state machine            |
| LLM Integration   | @langchain/anthropic                  | latest  | Claude model support                   |
| Agent Spawning    | @anthropic-ai/claude-code             | latest  | Official Claude Code SDK               |
| Schema Validation | zod                                   | 3.x     | Runtime type validation with inference |
| State Persistence | @langchain/langgraph-checkpoint-redis | latest  | Production-grade Redis checkpointing   |
| Observability     | LangSmith / Langfuse                  | latest  | Automatic trace capture                |
| Dev Server        | @langchain/langgraph-cli              | latest  | LangGraph Studio support               |

### Package Structure

```
packages/langgraph-orchestrator/
├── package.json
├── tsconfig.json
├── langgraph.json                 # LangGraph Studio config
├── docker-compose.yml             # Redis service
├── src/
│   ├── index.ts                   # Main exports
│   ├── schemas/                   # Zod schema library
│   │   ├── index.ts               # Schema exports
│   │   ├── prd.ts                 # PRD schema
│   │   ├── execution-plan.ts      # Execution plan schema
│   │   ├── user-story.ts          # User story schema
│   │   └── common.ts              # Shared types
│   ├── nodes/                     # Reusable node library
│   │   ├── index.ts               # Node exports
│   │   ├── validation.ts          # Schema validation node factory
│   │   ├── hitl/                  # HITL node types
│   │   │   ├── clarification.ts   # Requirements clarification
│   │   │   ├── approval.ts        # Approval gate
│   │   │   ├── add-instructions.ts # Mid-workflow context injection
│   │   │   └── interrupt-resume.ts # Pause/continue
│   │   ├── agent-spawn.ts         # Claude Agent SDK wrapper
│   │   └── conditional.ts         # If-gates, routing
│   ├── lib/                       # Core utilities
│   │   ├── checkpointer.ts        # Redis checkpointer setup
│   │   ├── circuit-breaker.ts     # Circuit breaker pattern
│   │   ├── retry.ts               # Exponential backoff with jitter
│   │   ├── observability.ts       # LangSmith/Langfuse config
│   │   └── claude-sdk.ts          # Claude Agent SDK wrapper
│   ├── examples/                  # Example workflows
│   │   └── demo-workflow.ts       # All node types demonstrated
│   └── types/                     # TypeScript types
│       └── index.ts
├── dist/                          # Compiled output
└── docs/
    └── workflow-authoring.md      # How to build workflows
```

### Zod Schema Library

Schemas extracted from existing templates for type-safe validation:

#### PRD Schema

```typescript
// src/schemas/prd.ts
import { z } from "zod";

export const PrdFrontmatterSchema = z.object({
  project_id: z.string().regex(/^[A-Z]{3}\d{3}$/),
  title: z.string().min(1),
  version: z.string().default("1.0"),
  status: z.enum(["draft", "in-review", "approved", "in-progress", "complete"]),
  created: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  updated: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  owner: z.string(),
});

export const RequirementSchema = z.object({
  id: z.string().regex(/^(FR|NFR)-\d{3}$/),
  requirement: z.string().min(1),
  priority: z.enum(["P0", "P1", "P2"]),
});

export const RiskSchema = z.object({
  risk: z.string(),
  impact: z.enum(["High", "Medium", "Low"]),
  likelihood: z.enum(["High", "Medium", "Low"]),
  mitigation: z.string(),
});

export const EpicSummarySchema = z.object({
  epicId: z.string(),
  title: z.string(),
  storyCount: z.number().int().positive(),
  complexity: z.number().int().positive(),
});

export const PrdSchema = z.object({
  frontmatter: PrdFrontmatterSchema,
  executiveSummary: z.string().min(50),
  goal: z.string().min(10),
  problemStatement: z.object({
    currentState: z.string(),
    issues: z.array(z.object({ issue: z.string(), impact: z.string() })),
    painPoints: z.array(z.string()).min(1),
  }),
  solutionOverview: z.object({
    targetState: z.string(),
    corePrinciples: z.array(
      z.object({
        principle: z.string(),
        description: z.string(),
      }),
    ),
  }),
  functionalRequirements: z.array(RequirementSchema).min(1),
  nonFunctionalRequirements: z.array(RequirementSchema),
  scope: z.object({
    inScope: z.array(z.string()).min(1),
    outOfScope: z.array(z.string()),
  }),
  epicSummary: z.array(EpicSummarySchema),
  successCriteria: z.object({
    technical: z.array(z.string()),
    verification: z.array(z.string()),
    metrics: z.array(z.object({ metric: z.string(), target: z.string() })),
  }),
  risks: z.array(RiskSchema),
  dependencies: z.object({
    external: z.array(z.string()),
    internal: z.array(z.string()),
  }),
});

export type Prd = z.infer<typeof PrdSchema>;
```

#### Execution Plan Schema

```typescript
// src/schemas/execution-plan.ts
import { z } from "zod";

export const ExecutionPlanFrontmatterSchema = z.object({
  project_id: z.string(),
  title: z.string(),
  status: z.enum(["pending", "in-progress", "complete"]),
  total_stories: z.number().int().nonnegative(),
  total_complexity: z.number().int().nonnegative(),
  total_waves: z.number().int().nonnegative(),
  created: z.string(),
  updated: z.string(),
  owner: z.string(),
});

export const StoryIndexEntrySchema = z.object({
  wave: z.number().int().positive(),
  storyId: z.string(),
  title: z.string(),
  epicId: z.string(),
  dependencies: z.array(z.string()),
  complexity: z.number().int().positive(),
  status: z.enum(["pending", "in-progress", "complete", "blocked"]),
});

export const WaveSchema = z.object({
  waveNumber: z.number().int().positive(),
  name: z.string(),
  stories: z.array(z.string()),
  complexity: z.number().int().positive(),
  dependencies: z.string(),
  execution: z.enum(["Parallel", "Sequential"]),
  tasks: z.array(
    z.object({
      storyId: z.string(),
      task: z.string(),
      agent: z.string(),
      estimatedFiles: z.number().int().nonnegative(),
    }),
  ),
});

export const ExecutionPlanSchema = z.object({
  frontmatter: ExecutionPlanFrontmatterSchema,
  summary: z.object({
    totalStories: z.number().int().positive(),
    totalComplexity: z.number().int().positive(),
    waves: z.number().int().positive(),
    criticalPath: z.string(),
    estimatedDuration: z.string(),
  }),
  storyIndex: z.array(StoryIndexEntrySchema),
  waves: z.array(WaveSchema),
  agentAssignments: z.array(
    z.object({
      wave: z.number().int().positive(),
      storyId: z.string(),
      subagentType: z.string(),
    }),
  ),
  risks: z.array(
    z.object({
      risk: z.string(),
      impact: z.enum(["High", "Medium", "Low"]),
      mitigation: z.string(),
    }),
  ),
  rollbackPlan: z.array(z.string()),
});

export type ExecutionPlan = z.infer<typeof ExecutionPlanSchema>;
```

#### User Story Schema

```typescript
// src/schemas/user-story.ts
import { z } from "zod";

export const UserStoryFrontmatterSchema = z.object({
  story_id: z.string().regex(/^[a-z]{3}-[a-z]{3,4}-\d{3}$/),
  epic_id: z.string(),
  title: z.string(),
  status: z.enum(["pending", "in-progress", "complete", "blocked"]),
  complexity: z.number().int().min(1).max(10),
  wave: z.number().int().positive(),
  agent: z.string(),
  dependencies: z.array(z.string()),
  created: z.string(),
  updated: z.string(),
});

export const UserStorySchema = z.object({
  frontmatter: UserStoryFrontmatterSchema,
  userStory: z.object({
    asA: z.string(),
    iWant: z.string(),
    soThat: z.string(),
  }),
  acceptanceCriteria: z.array(z.string()).min(1),
  technicalDetails: z.object({
    repo: z.string(),
    package: z.string(),
    filesToCreate: z.array(
      z.object({
        file: z.string(),
        purpose: z.string(),
      }),
    ),
    filesToModify: z.array(
      z.object({
        file: z.string(),
        changes: z.string(),
      }),
    ),
  }),
  implementationNotes: z.string().optional(),
  architecture: z
    .object({
      apiEndpoints: z
        .array(
          z.object({
            method: z.enum(["GET", "POST", "PUT", "DELETE", "PATCH"]),
            endpoint: z.string(),
            description: z.string(),
          }),
        )
        .optional(),
      databaseModels: z
        .array(
          z.object({
            model: z.string(),
            fields: z.string(),
          }),
        )
        .optional(),
      keyFiles: z.array(z.string()).optional(),
    })
    .optional(),
  definitionOfDone: z.array(z.string()),
});

export type UserStory = z.infer<typeof UserStorySchema>;
```

### HITL Node Types

The framework provides four HITL primitive types:

#### 1. Requirements Clarification

Pause workflow to ask user clarifying questions. Resumes when answers provided.

```typescript
// src/nodes/hitl/clarification.ts
import { interrupt } from "@langchain/langgraph";

export interface ClarificationRequest {
  kind: "clarification";
  questions: string[];
  context?: Record<string, unknown>;
  instructions: string;
}

export interface ClarificationResponse {
  answers: Record<string, string>;
}

export function createClarificationNode<TState extends Record<string, unknown>>(options: { getQuestions: (state: TState) => Promise<string[]>; shouldAsk: (state: TState) => boolean; updateState: (state: TState, response: ClarificationResponse) => Partial<TState> }) {
  return async function clarificationNode(state: TState) {
    if (!options.shouldAsk(state)) {
      return {}; // Skip, no clarification needed
    }

    const questions = await options.getQuestions(state);

    if (questions.length === 0) {
      return {}; // No questions to ask
    }

    const response = interrupt<ClarificationRequest, ClarificationResponse>({
      kind: "clarification",
      questions,
      instructions: "Please answer the following questions to proceed:",
    });

    return options.updateState(state, response);
  };
}
```

#### 2. Approval Gate

Pause workflow for explicit approval/rejection. Can include feedback on rejection.

```typescript
// src/nodes/hitl/approval.ts
import { interrupt } from "@langchain/langgraph";

export interface ApprovalRequest {
  kind: "approval";
  summary: Record<string, unknown>;
  details?: Record<string, unknown>;
  instructions: string;
}

export interface ApprovalResponse {
  approved: boolean;
  feedback?: string;
}

export function createApprovalNode<TState extends Record<string, unknown>>(options: { getSummary: (state: TState) => Record<string, unknown>; getDetails?: (state: TState) => Record<string, unknown>; onApproved: (state: TState) => Partial<TState>; onRejected: (state: TState, feedback: string) => Partial<TState> }) {
  return async function approvalNode(state: TState) {
    const response = interrupt<ApprovalRequest, ApprovalResponse>({
      kind: "approval",
      summary: options.getSummary(state),
      details: options.getDetails?.(state),
      instructions: "Review and approve to proceed, or reject with feedback:",
    });

    if (response.approved) {
      return options.onApproved(state);
    } else {
      return options.onRejected(state, response.feedback || "Rejected without feedback");
    }
  };
}
```

#### 3. Add Instructions

Pause workflow to allow user to inject additional context mid-workflow.

```typescript
// src/nodes/hitl/add-instructions.ts
import { interrupt } from "@langchain/langgraph";

export interface AddInstructionsRequest {
  kind: "add_instructions";
  currentContext: Record<string, unknown>;
  prompt: string;
}

export interface AddInstructionsResponse {
  additionalInstructions: string;
  skipRemaining?: boolean;
}

export function createAddInstructionsNode<TState extends Record<string, unknown>>(options: { getContext: (state: TState) => Record<string, unknown>; prompt: string; updateState: (state: TState, response: AddInstructionsResponse) => Partial<TState> }) {
  return async function addInstructionsNode(state: TState) {
    const response = interrupt<AddInstructionsRequest, AddInstructionsResponse>({
      kind: "add_instructions",
      currentContext: options.getContext(state),
      prompt: options.prompt,
    });

    return options.updateState(state, response);
  };
}
```

#### 4. Interrupt/Resume

Pause workflow indefinitely. Resume with optional additional context.

```typescript
// src/nodes/hitl/interrupt-resume.ts
import { interrupt } from "@langchain/langgraph";

export interface InterruptRequest {
  kind: "interrupt";
  reason: string;
  state: Record<string, unknown>;
  resumeInstructions: string;
}

export interface ResumeResponse {
  action: "continue" | "abort";
  context?: Record<string, unknown>;
}

export function createInterruptNode<TState extends Record<string, unknown>>(options: { getReason: (state: TState) => string; getResumeInstructions: (state: TState) => string; onContinue: (state: TState, context?: Record<string, unknown>) => Partial<TState>; onAbort: (state: TState) => Partial<TState> }) {
  return async function interruptNode(state: TState) {
    const response = interrupt<InterruptRequest, ResumeResponse>({
      kind: "interrupt",
      reason: options.getReason(state),
      state: state as Record<string, unknown>,
      resumeInstructions: options.getResumeInstructions(state),
    });

    if (response.action === "continue") {
      return options.onContinue(state, response.context);
    } else {
      return options.onAbort(state);
    }
  };
}
```

### Validation Node with Retry

```typescript
// src/nodes/validation.ts
import { z } from "zod";
import { ChatAnthropic } from "@langchain/anthropic";

export interface ValidationOptions<T> {
  schema: z.ZodSchema<T>;
  maxRetries: number;
  generatePrompt: (previousErrors?: string[]) => string;
  model?: ChatAnthropic;
}

export interface ValidationResult<T> {
  success: boolean;
  data?: T;
  errors?: string[];
  retryCount: number;
}

export async function validateWithRetry<T>(options: ValidationOptions<T>): Promise<ValidationResult<T>> {
  const model =
    options.model ??
    new ChatAnthropic({
      model: "claude-sonnet-4-20250514",
      temperature: 0,
    });

  let lastErrors: string[] = [];

  for (let attempt = 1; attempt <= options.maxRetries; attempt++) {
    const prompt = options.generatePrompt(attempt > 1 ? lastErrors : undefined);

    const structuredModel = model.withStructuredOutput(options.schema);

    try {
      const result = await structuredModel.invoke(prompt);
      const validation = options.schema.safeParse(result);

      if (validation.success) {
        return {
          success: true,
          data: validation.data,
          retryCount: attempt,
        };
      }

      lastErrors = validation.error.errors.map((e) => `${e.path.join(".")}: ${e.message}`);
    } catch (error) {
      lastErrors = [error instanceof Error ? error.message : String(error)];
    }
  }

  return {
    success: false,
    errors: lastErrors,
    retryCount: options.maxRetries,
  };
}

export function createValidationNode<TState extends Record<string, unknown>, TOutput>(options: { schema: z.ZodSchema<TOutput>; generatePrompt: (state: TState, previousErrors?: string[]) => string; maxRetries?: number; onSuccess: (state: TState, data: TOutput) => Partial<TState>; onFailure: (state: TState, errors: string[]) => Partial<TState> }) {
  return async function validationNode(state: TState) {
    const result = await validateWithRetry({
      schema: options.schema,
      maxRetries: options.maxRetries ?? 3,
      generatePrompt: (previousErrors) => options.generatePrompt(state, previousErrors),
    });

    if (result.success && result.data) {
      return options.onSuccess(state, result.data);
    } else {
      return options.onFailure(state, result.errors || ["Unknown validation error"]);
    }
  };
}
```

### Circuit Breaker

```typescript
// src/lib/circuit-breaker.ts

type CircuitState = "CLOSED" | "OPEN" | "HALF_OPEN";

export interface CircuitBreakerConfig {
  failureThreshold: number; // Failures before opening (default: 5)
  recoveryTimeout: number; // ms before trying again (default: 30000)
  maxRetries: number; // Retries per call (default: 3)
  baseDelay: number; // Base delay for backoff (default: 1000)
  maxDelay: number; // Max delay (default: 30000)
}

export class CircuitBreaker {
  private state: CircuitState = "CLOSED";
  private failures = 0;
  private lastFailure: number = 0;
  private config: CircuitBreakerConfig;

  constructor(config: Partial<CircuitBreakerConfig> = {}) {
    this.config = {
      failureThreshold: config.failureThreshold ?? 5,
      recoveryTimeout: config.recoveryTimeout ?? 30000,
      maxRetries: config.maxRetries ?? 3,
      baseDelay: config.baseDelay ?? 1000,
      maxDelay: config.maxDelay ?? 30000,
    };
  }

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === "OPEN") {
      if (Date.now() - this.lastFailure > this.config.recoveryTimeout) {
        this.state = "HALF_OPEN";
      } else {
        throw new Error("Circuit breaker is OPEN - request rejected");
      }
    }

    for (let attempt = 1; attempt <= this.config.maxRetries; attempt++) {
      try {
        const result = await fn();
        this.onSuccess();
        return result;
      } catch (error) {
        if (attempt < this.config.maxRetries) {
          await this.delay(attempt);
        } else {
          this.onFailure();
          throw error;
        }
      }
    }

    throw new Error("Unreachable");
  }

  private delay(attempt: number): Promise<void> {
    const exponentialDelay = Math.min(this.config.baseDelay * Math.pow(2, attempt - 1), this.config.maxDelay);
    const jitter = Math.random() * 500;
    return new Promise((r) => setTimeout(r, exponentialDelay + jitter));
  }

  private onSuccess() {
    this.failures = 0;
    this.state = "CLOSED";
  }

  private onFailure() {
    this.failures++;
    this.lastFailure = Date.now();
    if (this.failures >= this.config.failureThreshold) {
      this.state = "OPEN";
    }
  }

  getState(): CircuitState {
    return this.state;
  }

  getStats() {
    return {
      state: this.state,
      failures: this.failures,
      lastFailure: this.lastFailure,
    };
  }
}
```

### Claude Agent SDK Wrapper

```typescript
// src/lib/claude-sdk.ts
import { ClaudeCode } from "@anthropic-ai/claude-code";
import { CircuitBreaker } from "./circuit-breaker";

const circuitBreaker = new CircuitBreaker({
  failureThreshold: 5,
  recoveryTimeout: 30000,
});

export interface SpawnOptions {
  workingDirectory: string;
  prompt: string;
  systemContext?: string;
  timeout?: number;
}

export interface SpawnResult {
  output: string;
  success: boolean;
  error?: string;
}

export async function spawnClaudeCode(options: SpawnOptions): Promise<SpawnResult> {
  return circuitBreaker.execute(async () => {
    const claude = new ClaudeCode({
      workingDirectory: options.workingDirectory,
    });

    const result = await claude.run({
      prompt: options.prompt,
      systemContext: options.systemContext,
      timeout: options.timeout || 300000, // 5 minutes default
    });

    return {
      output: result.output,
      success: true,
    };
  });
}

export function createAgentSpawnNode<TState extends Record<string, unknown>>(options: { getWorkingDirectory: (state: TState) => string; getPrompt: (state: TState) => string; getSystemContext?: (state: TState) => string; timeout?: number; onSuccess: (state: TState, output: string) => Partial<TState>; onFailure: (state: TState, error: string) => Partial<TState> }) {
  return async function agentSpawnNode(state: TState) {
    try {
      const result = await spawnClaudeCode({
        workingDirectory: options.getWorkingDirectory(state),
        prompt: options.getPrompt(state),
        systemContext: options.getSystemContext?.(state),
        timeout: options.timeout,
      });

      if (result.success) {
        return options.onSuccess(state, result.output);
      } else {
        return options.onFailure(state, result.error || "Unknown error");
      }
    } catch (error) {
      return options.onFailure(state, error instanceof Error ? error.message : String(error));
    }
  };
}
```

### LangGraph Configuration

```json
// langgraph.json
{
  "node_version": "20",
  "graphs": {
    "demo": "./src/examples/demo-workflow.ts:demoGraph"
  },
  "env": ".env"
}
```

### Docker Compose

```yaml
# docker-compose.yml
version: "3.8"

services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  redis_data:
```

### Package.json

```json
{
  "name": "@metasaver/langgraph-orchestrator",
  "version": "1.0.0",
  "type": "module",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.js"
    },
    "./schemas": {
      "types": "./dist/schemas/index.d.ts",
      "import": "./dist/schemas/index.js"
    },
    "./nodes": {
      "types": "./dist/nodes/index.d.ts",
      "import": "./dist/nodes/index.js"
    }
  },
  "scripts": {
    "dev": "langgraph dev",
    "build": "tsc",
    "lint": "eslint src/",
    "typecheck": "tsc --noEmit",
    "docker:up": "docker-compose up -d",
    "docker:down": "docker-compose down"
  },
  "dependencies": {
    "@langchain/anthropic": "^0.3.0",
    "@langchain/core": "^0.3.0",
    "@langchain/langgraph": "^0.2.0",
    "@langchain/langgraph-checkpoint-redis": "^0.1.0",
    "@anthropic-ai/claude-code": "^0.1.0",
    "zod": "^3.23.0"
  },
  "devDependencies": {
    "@langchain/langgraph-cli": "^0.0.1",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "eslint": "^9.0.0"
  }
}
```

---

## 8. Success Criteria

### Phase 1 Success Metrics

| Metric                          | Target      | Measurement                                               |
| ------------------------------- | ----------- | --------------------------------------------------------- |
| LangGraph Studio starts         | < 10s       | Time from `pnpm dev` to "Server running" message          |
| Example workflow runs in Studio | 100%        | Demo workflow executes without errors                     |
| All 4 HITL types functional     | 100%        | Each HITL type pauses and resumes correctly               |
| Zod validation with retry works | 100%        | Validation retries on failure, succeeds within 3 attempts |
| Redis persistence works         | 100%        | Workflow resumes after process restart                    |
| Circuit breaker activates       | 100%        | Breaker opens after configured failures                   |
| TypeScript compiles             | 0 errors    | `pnpm build` succeeds                                     |
| Documentation enables authoring | Qualitative | User can build workflow from docs                         |

### Phase 1 Verification Checklist

- [ ] `docker-compose up` starts Redis
- [ ] `pnpm install` succeeds
- [ ] `pnpm build` compiles without errors
- [ ] `pnpm dev` starts LangGraph Studio
- [ ] Demo workflow visible in Studio UI
- [ ] Clarification HITL pauses for input
- [ ] Approval HITL pauses for approval
- [ ] Add-instructions HITL allows context injection
- [ ] Interrupt/resume HITL pauses and continues
- [ ] Zod validation catches schema errors
- [ ] Zod validation retries with error feedback
- [ ] Redis persists state across restarts
- [ ] Circuit breaker opens after 5 failures
- [ ] Observability traces visible (if LangSmith configured)

---

## 9. Risks and Mitigations

| Risk                           | Impact | Likelihood | Mitigation                                     |
| ------------------------------ | ------ | ---------- | ---------------------------------------------- |
| LangGraph.js API changes       | High   | Low        | Pin version, monitor releases                  |
| Claude Agent SDK instability   | High   | Medium     | Circuit breaker, fallback to direct API        |
| Redis connection failures      | High   | Low        | Connection pooling, health checks, retry logic |
| HITL interrupt patterns change | Medium | Low        | Abstract behind node factories                 |
| Zod schema complexity          | Medium | Medium     | Start with core schemas, add progressively     |
| Framework too abstract         | Medium | Medium     | Include concrete example workflow              |
| Documentation gaps             | Medium | High       | Prioritize authoring guide alongside code      |

---

## 10. Dependencies

### External Dependencies

| Dependency                            | Type     | Purpose                   |
| ------------------------------------- | -------- | ------------------------- |
| @langchain/langgraph                  | npm      | Core orchestration engine |
| @langchain/langgraph-checkpoint-redis | npm      | Redis checkpointing       |
| @langchain/langgraph-cli              | npm      | LangGraph Studio support  |
| @langchain/anthropic                  | npm      | Claude model integration  |
| @anthropic-ai/claude-code             | npm      | Agent spawning            |
| zod                                   | npm      | Schema validation         |
| Redis                                 | Docker   | State persistence backend |
| LangSmith / Langfuse                  | External | Observability platform    |

### Internal Dependencies

None - this is a standalone framework package.

---

## 11. Timeline and Milestones

### Phase 1: Framework (Estimated: 5-7 days)

| Milestone                  | Target  | Deliverable                             |
| -------------------------- | ------- | --------------------------------------- |
| M1.1: Package setup        | Day 1   | Package structure, TypeScript, build    |
| M1.2: Redis + checkpointer | Day 1-2 | Docker Redis, checkpointer integration  |
| M1.3: Zod schema library   | Day 2   | PRD, execution plan, user story schemas |
| M1.4: Validation node      | Day 2-3 | Validation with retry loop              |
| M1.5: HITL nodes (4 types) | Day 3-4 | All 4 HITL node types implemented       |
| M1.6: Circuit breaker      | Day 4   | Circuit breaker + backoff patterns      |
| M1.7: Claude SDK wrapper   | Day 4-5 | Agent spawning with resilience          |
| M1.8: Example workflow     | Day 5-6 | Demo workflow in LangGraph Studio       |
| M1.9: Documentation        | Day 6-7 | Workflow authoring guide                |

### Phase 2: Adapters (Estimated: 4-5 days)

| Milestone                | Target  | Deliverable                          |
| ------------------------ | ------- | ------------------------------------ |
| M2.1: VSCode adapter     | Day 1-2 | VSCode extension integration         |
| M2.2: CLI adapter        | Day 2-3 | Claude Code CLI integration          |
| M2.3: REST API           | Day 3-4 | API endpoint for programmatic access |
| M2.4: MCP server wrapper | Day 4-5 | MCP integration for Claude Code      |

---

## 12. Environment Variables

| Variable               | Required | Description                                            |
| ---------------------- | -------- | ------------------------------------------------------ |
| `ANTHROPIC_API_KEY`    | Yes      | Anthropic API key for Claude                           |
| `REDIS_URL`            | Yes      | Redis connection URL (default: redis://localhost:6379) |
| `LANGCHAIN_TRACING_V2` | No       | Enable LangSmith tracing (true/false)                  |
| `LANGCHAIN_API_KEY`    | No       | LangSmith API key                                      |
| `LANGCHAIN_PROJECT`    | No       | LangSmith project name                                 |
| `LANGFUSE_PUBLIC_KEY`  | No       | Langfuse public key (alternative)                      |
| `LANGFUSE_SECRET_KEY`  | No       | Langfuse secret key (alternative)                      |
| `LANGFUSE_HOST`        | No       | Langfuse host URL                                      |

---

## Appendix A: Reference Documents

- Existing templates: `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/prd-creation/templates/prd-template.md`
- Execution plan template: `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/execution-plan-creation/templates/execution-plan-template.md`
- User story template: `/home/jnightin/code/metasaver-marketplace/plugins/metasaver-core/skills/workflow-steps/user-story-creation/templates/user-story-template.md`
- Workflow state spec: `/home/jnightin/code/metasaver-marketplace/docs/architecture/workflow-state-spec.md`

## Appendix B: Example Workflow Structure

```typescript
// src/examples/demo-workflow.ts
import { StateGraph, START, END, Annotation } from "@langchain/langgraph";
import { RedisCheckpointer } from "@langchain/langgraph-checkpoint-redis";
import { createClarificationNode } from "../nodes/hitl/clarification";
import { createApprovalNode } from "../nodes/hitl/approval";
import { createValidationNode } from "../nodes/validation";
import { PrdSchema } from "../schemas/prd";

// State definition
const DemoState = Annotation.Root({
  input: Annotation<string>,
  phase: Annotation<string>({ default: () => "init" }),
  clarification: Annotation<Record<string, string> | null>({ default: () => null }),
  prd: Annotation<z.infer<typeof PrdSchema> | null>({ default: () => null }),
  approved: Annotation<boolean>({ default: () => false }),
  error: Annotation<string | null>({ default: () => null }),
});

// Nodes
const clarifyNode = createClarificationNode({
  getQuestions: async (state) => ["What is the project scope?", "Who are the stakeholders?"],
  shouldAsk: (state) => state.clarification === null,
  updateState: (state, response) => ({ clarification: response.answers }),
});

const generatePrdNode = createValidationNode({
  schema: PrdSchema,
  generatePrompt: (state, previousErrors) => `
    Generate a PRD based on:
    Input: ${state.input}
    Clarification: ${JSON.stringify(state.clarification)}
    ${previousErrors ? `Previous errors to fix: ${previousErrors.join(", ")}` : ""}
  `,
  onSuccess: (state, data) => ({ prd: data, phase: "approval" }),
  onFailure: (state, errors) => ({ error: `PRD generation failed: ${errors.join(", ")}` }),
});

const approvalNode = createApprovalNode({
  getSummary: (state) => ({ title: state.prd?.frontmatter.title, scope: state.prd?.scope }),
  onApproved: (state) => ({ approved: true, phase: "complete" }),
  onRejected: (state, feedback) => ({ error: `Rejected: ${feedback}`, phase: "error" }),
});

// Graph
const checkpointer = new RedisCheckpointer({
  url: process.env.REDIS_URL || "redis://localhost:6379",
  ttl: 7 * 24 * 60 * 60,
});

export const demoGraph = new StateGraph(DemoState)
  .addNode("clarify", clarifyNode)
  .addNode("generate_prd", generatePrdNode)
  .addNode("approval", approvalNode)
  .addEdge(START, "clarify")
  .addEdge("clarify", "generate_prd")
  .addConditionalEdges(
    "generate_prd",
    (state) => {
      if (state.error) return "error";
      return "approval";
    },
    {
      approval: "approval",
      error: END,
    },
  )
  .addEdge("approval", END)
  .compile({ checkpointer });
```

---

**Document Owner:** enterprise-architect-agent
**Review Status:** Draft - Pending User Review

---

<!--
CHANGES v2.1 (from v2.0):
1. Added Design Decisions section documenting key architectural choices
2. Added Epic Summary section with 8 epics broken into 4 implementation waves
3. Renumbered sections to maintain sequential order (now 12 sections)
4. Added epic descriptions with deliverables per epic

CHANGES v2.0 (from v1.1):
1. Reframed as FRAMEWORK project (not /build workflow implementation)
2. Removed GitHub Issues/Milestones (out of scope per user)
3. Added explicit Phase 1 (Framework) / Phase 2 (Adapters) distinction
4. Added Zod schemas extracted from existing templates
5. Added 4 HITL node type implementations
6. Added circuit breaker and retry patterns
7. Added example workflow demonstrating all node types
8. LangGraph Studio as primary UI (Phase 1 deliverable)
9. Docker Redis only (no local fallback)
10. Clarified out of scope: specific workflow implementations
-->
