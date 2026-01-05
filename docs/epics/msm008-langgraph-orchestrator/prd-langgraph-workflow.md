# PRD: Metasaver Deterministic Workflow System

## Overview

Build a LangGraph.js-based workflow orchestrator that replaces ad-hoc AI coding with deterministic, human-in-the-loop state machines. Each workflow command (`/ms`, `/architect`, `/build`, `/audit`, `/debug`) becomes a defined graph with explicit phases, structured I/O, quality gates, and approval checkpoints.

## Goals

1. **Deterministic outputs**: Same inputs + same human answers = identical results every time
2. **Human-in-the-loop at every critical decision**: No autonomous execution without approval
3. **Structured I/O contracts**: Every phase has Zod schemas defining exact input/output shapes
4. **Quality gates**: Evaluators validate outputs before proceeding to next phase
5. **Template-based generation**: PRDs, user stories, and plans render through templates, not LLM freestyle

## Technology Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Runtime | Node.js | 20+ |
| Package Manager | pnpm | latest |
| Language | TypeScript | 5.x |
| Orchestration | @langchain/langgraph | latest |
| LLM | @langchain/anthropic | latest |
| Schema Validation | zod | latest |
| Templates | handlebars | latest |
| Server | LangGraph CLI | latest |

## Project Structure

```
metasaver-workflow/
├── package.json
├── tsconfig.json
├── langgraph.json                 # LangGraph server config
├── .env                           # API keys
├── src/
│   ├── index.ts                   # Entry point (exports graphs)
│   ├── schemas/                   # Zod schemas (I/O contracts)
│   │   ├── common.ts              # Shared types
│   │   ├── ms.ts                  # /ms command schemas
│   │   ├── architect.ts           # /architect command schemas
│   │   ├── build.ts               # /build command schemas
│   │   ├── audit.ts               # /audit command schemas
│   │   └── debug.ts               # /debug command schemas
│   ├── nodes/                     # Graph nodes (one file per node)
│   │   ├── scopeCheck.ts
│   │   ├── clarify.ts
│   │   ├── requirements.ts
│   │   ├── vibeCheck.ts
│   │   ├── innovate.ts
│   │   ├── plan.ts
│   │   ├── execute.ts
│   │   ├── verify.ts
│   │   └── save.ts
│   ├── evaluators/                # Quality gate logic
│   │   ├── prdEvaluator.ts
│   │   ├── codeEvaluator.ts
│   │   └── acVerifier.ts
│   ├── graphs/                    # Workflow definitions
│   │   ├── ms.ts                  # /ms workflow graph
│   │   ├── architect.ts           # /architect workflow graph
│   │   ├── build.ts               # /build workflow graph
│   │   ├── audit.ts               # /audit workflow graph
│   │   └── debug.ts               # /debug workflow graph
│   ├── templates/                 # Handlebars templates
│   │   ├── prd.md.hbs
│   │   ├── userStory.md.hbs
│   │   ├── executionPlan.md.hbs
│   │   └── microStory.md.hbs
│   ├── utils/
│   │   ├── llm.ts                 # LLM client setup
│   │   ├── templates.ts           # Template rendering
│   │   └── files.ts               # File system operations
│   └── config/
│       └── standards.ts           # Architectural standards
└── templates/                     # Output templates (also accessible externally)
```

---

## Phase 1: /ms Command (Micro-Story)

**Start with this. It's the simplest workflow.**

### Purpose
Execute a single, small, well-defined task without full PRD generation. Quick HITL loop for minor changes.

### Workflow Phases

```
START → scopeCheck → clarify → execute → verify → save → END
                ↑                           │
                └───────── (if AC fails) ───┘
```

### State Schema

```typescript
// src/schemas/ms.ts
import { z } from "zod";
import { Annotation } from "@langchain/langgraph";

// Input from user
export const MsInputSchema = z.object({
  command: z.string().describe("The user's request"),
  targetPath: z.string().optional().describe("Target repo/path if specified"),
});

// Scope check output
export const ScopeOutputSchema = z.object({
  targetFiles: z.array(z.string()).describe("Files to modify"),
  referenceFiles: z.array(z.string()).describe("Files to use as patterns"),
  estimatedComplexity: z.enum(["trivial", "small", "medium"]).describe("If medium+, suggest /architect instead"),
});

// Clarification Q&A
export const ClarificationSchema = z.object({
  questions: z.array(z.string()),
  answers: z.record(z.string(), z.string()),
});

// Execution result
export const ExecutionResultSchema = z.object({
  filesModified: z.array(z.object({
    path: z.string(),
    diff: z.string(),
  })),
  summary: z.string(),
});

// Verification result
export const VerificationResultSchema = z.object({
  passed: z.boolean(),
  acceptanceCriteria: z.array(z.object({
    criterion: z.string(),
    met: z.boolean(),
    evidence: z.string().optional(),
  })),
  issues: z.array(z.string()),
});

// Graph state annotation
export const MsWorkflowState = Annotation.Root({
  // Input
  command: Annotation<string>,
  targetPath: Annotation<string | null>({
    default: () => null,
  }),
  
  // Phase
  phase: Annotation<string>({
    default: () => "init",
  }),
  
  // Scope
  scope: Annotation<z.infer<typeof ScopeOutputSchema> | null>({
    default: () => null,
  }),
  
  // Clarification
  clarification: Annotation<z.infer<typeof ClarificationSchema> | null>({
    default: () => null,
  }),
  
  // Execution
  executionResult: Annotation<z.infer<typeof ExecutionResultSchema> | null>({
    default: () => null,
  }),
  
  // Verification
  verification: Annotation<z.infer<typeof VerificationResultSchema> | null>({
    default: () => null,
  }),
  
  // Control
  approved: Annotation<boolean>({
    default: () => false,
  }),
  retryCount: Annotation<number>({
    default: () => 0,
  }),
  error: Annotation<string | null>({
    default: () => null,
  }),
});

export type MsState = typeof MsWorkflowState.State;
```

### Node Implementations

#### scopeCheck Node

```typescript
// src/nodes/scopeCheck.ts
import { ChatAnthropic } from "@langchain/anthropic";
import { Command } from "@langchain/langgraph";
import type { MsState } from "../schemas/ms";
import { ScopeOutputSchema } from "../schemas/ms";

const model = new ChatAnthropic({
  model: "claude-sonnet-4-20250514",
  temperature: 0,
});

export async function scopeCheckNode(state: MsState): Promise<Command> {
  const structuredModel = model.withStructuredOutput(ScopeOutputSchema);
  
  const prompt = `
    Analyze this request and determine scope:
    
    Request: ${state.command}
    ${state.targetPath ? `Target: ${state.targetPath}` : ""}
    
    Identify:
    1. Which files need to be modified
    2. Which existing files should be used as reference/patterns
    3. Complexity estimate (trivial/small/medium)
    
    If complexity is "medium" or higher, recommend using /architect instead.
  `;
  
  const scope = await structuredModel.invoke(prompt);
  
  // If too complex, suggest /architect
  if (scope.estimatedComplexity === "medium") {
    return new Command({
      update: {
        phase: "complete",
        error: "This task is too complex for /ms. Please use /architect command instead.",
      },
      goto: "__end__",
    });
  }
  
  return new Command({
    update: {
      scope,
      phase: "clarify",
    },
    goto: "clarify",
  });
}
```

#### clarify Node (HITL)

```typescript
// src/nodes/clarify.ts
import { ChatAnthropic } from "@langchain/anthropic";
import { interrupt, Command } from "@langchain/langgraph";
import type { MsState } from "../schemas/ms";
import { z } from "zod";

const model = new ChatAnthropic({
  model: "claude-sonnet-4-20250514",
  temperature: 0,
});

const QuestionsSchema = z.object({
  questions: z.array(z.string()).max(3),
});

export async function clarifyNode(state: MsState): Promise<Command> {
  // Generate clarifying questions
  const structuredModel = model.withStructuredOutput(QuestionsSchema);
  
  const prompt = `
    Based on this request and scope, generate 1-3 clarifying questions.
    Only ask if genuinely ambiguous. Return empty array if request is clear.
    
    Request: ${state.command}
    Scope: ${JSON.stringify(state.scope)}
  `;
  
  const { questions } = await structuredModel.invoke(prompt);
  
  // If no questions needed, skip to execute
  if (questions.length === 0) {
    return new Command({
      update: {
        clarification: { questions: [], answers: {} },
        phase: "execute",
      },
      goto: "execute",
    });
  }
  
  // HITL: Pause and wait for human answers
  const answers = interrupt({
    kind: "clarification",
    questions,
    scope: state.scope,
    instructions: "Please answer these questions to proceed:",
  });
  
  // Resume: answers contains human input
  return new Command({
    update: {
      clarification: { questions, answers },
      phase: "execute",
    },
    goto: "execute",
  });
}
```

#### execute Node

```typescript
// src/nodes/execute.ts
import { ChatAnthropic } from "@langchain/anthropic";
import { Command } from "@langchain/langgraph";
import type { MsState } from "../schemas/ms";
import { ExecutionResultSchema } from "../schemas/ms";
import * as fs from "fs/promises";
import * as path from "path";

const model = new ChatAnthropic({
  model: "claude-sonnet-4-20250514",
  temperature: 0,
});

export async function executeNode(state: MsState): Promise<Command> {
  // Read current file contents
  const fileContents: Record<string, string> = {};
  
  for (const filePath of state.scope!.targetFiles) {
    try {
      fileContents[filePath] = await fs.readFile(filePath, "utf-8");
    } catch {
      fileContents[filePath] = ""; // New file
    }
  }
  
  // Read reference files
  const referenceContents: Record<string, string> = {};
  for (const filePath of state.scope!.referenceFiles) {
    try {
      referenceContents[filePath] = await fs.readFile(filePath, "utf-8");
    } catch {
      // Reference file not found, skip
    }
  }
  
  const structuredModel = model.withStructuredOutput(ExecutionResultSchema);
  
  const prompt = `
    Execute this task:
    
    Request: ${state.command}
    Clarifications: ${JSON.stringify(state.clarification?.answers || {})}
    
    Target files (current content):
    ${Object.entries(fileContents).map(([p, c]) => `--- ${p} ---\n${c}`).join("\n\n")}
    
    Reference files (use as patterns):
    ${Object.entries(referenceContents).map(([p, c]) => `--- ${p} ---\n${c}`).join("\n\n")}
    
    Generate the complete new file contents.
    Follow patterns from reference files.
    Return a diff for each modified file.
  `;
  
  const result = await structuredModel.invoke(prompt);
  
  return new Command({
    update: {
      executionResult: result,
      phase: "verify",
    },
    goto: "verify",
  });
}
```

#### verify Node

```typescript
// src/nodes/verify.ts
import { ChatAnthropic } from "@langchain/anthropic";
import { Command } from "@langchain/langgraph";
import type { MsState } from "../schemas/ms";
import { VerificationResultSchema } from "../schemas/ms";

const model = new ChatAnthropic({
  model: "claude-sonnet-4-20250514",
  temperature: 0,
});

export async function verifyNode(state: MsState): Promise<Command> {
  const structuredModel = model.withStructuredOutput(VerificationResultSchema);
  
  const prompt = `
    Verify this execution meets the original request:
    
    Original request: ${state.command}
    Clarifications: ${JSON.stringify(state.clarification?.answers || {})}
    
    Execution result:
    ${JSON.stringify(state.executionResult, null, 2)}
    
    Generate acceptance criteria and check each one.
    Be strict. If anything is missing or wrong, mark as not passed.
  `;
  
  const verification = await structuredModel.invoke(prompt);
  
  // If failed and under retry limit, go back to execute
  if (!verification.passed && state.retryCount < 2) {
    return new Command({
      update: {
        verification,
        retryCount: state.retryCount + 1,
        phase: "execute",
      },
      goto: "execute",
    });
  }
  
  return new Command({
    update: {
      verification,
      phase: "save",
    },
    goto: "save",
  });
}
```

#### save Node (HITL Approval)

```typescript
// src/nodes/save.ts
import { interrupt, Command } from "@langchain/langgraph";
import type { MsState } from "../schemas/ms";
import * as fs from "fs/promises";
import * as path from "path";

export async function saveNode(state: MsState): Promise<Command> {
  // HITL: Final approval before writing files
  const approval = interrupt({
    kind: "final_approval",
    summary: {
      request: state.command,
      filesModified: state.executionResult!.filesModified.map(f => f.path),
      verification: state.verification,
    },
    diffs: state.executionResult!.filesModified,
    instructions: "Review the changes. Approve to write files, or reject with feedback.",
  });
  
  if (!approval.approved) {
    return new Command({
      update: {
        approved: false,
        error: approval.feedback || "Rejected by user",
        phase: "complete",
      },
      goto: "__end__",
    });
  }
  
  // Write files
  for (const file of state.executionResult!.filesModified) {
    const dir = path.dirname(file.path);
    await fs.mkdir(dir, { recursive: true });
    // Note: In real implementation, apply diff rather than overwrite
    // For MVP, assume diff contains full new content
    await fs.writeFile(file.path, file.diff);
  }
  
  return new Command({
    update: {
      approved: true,
      phase: "complete",
    },
    goto: "__end__",
  });
}
```

### Graph Definition

```typescript
// src/graphs/ms.ts
import { StateGraph, START, END } from "@langchain/langgraph";
import { MemorySaver } from "@langchain/langgraph";
import { MsWorkflowState } from "../schemas/ms";
import { scopeCheckNode } from "../nodes/scopeCheck";
import { clarifyNode } from "../nodes/clarify";
import { executeNode } from "../nodes/execute";
import { verifyNode } from "../nodes/verify";
import { saveNode } from "../nodes/save";

const workflow = new StateGraph(MsWorkflowState)
  .addNode("scopeCheck", scopeCheckNode)
  .addNode("clarify", clarifyNode)
  .addNode("execute", executeNode)
  .addNode("verify", verifyNode)
  .addNode("save", saveNode)
  .addEdge(START, "scopeCheck")
  .addEdge("scopeCheck", "clarify")
  .addEdge("clarify", "execute")
  .addEdge("execute", "verify")
  .addEdge("verify", "save")
  .addEdge("save", END);

const checkpointer = new MemorySaver();

export const msGraph = workflow.compile({
  checkpointer,
});
```

### Entry Point

```typescript
// src/index.ts
export { msGraph } from "./graphs/ms";
// Future exports:
// export { architectGraph } from "./graphs/architect";
// export { buildGraph } from "./graphs/build";
// export { auditGraph } from "./graphs/audit";
// export { debugGraph } from "./graphs/debug";
```

### LangGraph Config

```json
// langgraph.json
{
  "node_version": "20",
  "graphs": {
    "ms": "./src/index.ts:msGraph"
  },
  "env": ".env"
}
```

### Package.json

```json
{
  "name": "metasaver-workflow",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "npx @langchain/langgraph-cli dev",
    "build": "tsc",
    "lint": "eslint src/"
  },
  "dependencies": {
    "@langchain/anthropic": "^0.3.0",
    "@langchain/core": "^0.3.0",
    "@langchain/langgraph": "^0.2.0",
    "handlebars": "^4.7.0",
    "zod": "^3.23.0"
  },
  "devDependencies": {
    "@langchain/langgraph-cli": "^0.0.1",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "strict": true,
    "skipLibCheck": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Environment Variables

```bash
# .env
ANTHROPIC_API_KEY=your-key-here
```

---

## Phase 2: /architect Command (Future)

After /ms is working, implement the full /architect workflow:

```
START → scopeCheck → requirements → vibeCheck → innovate → architect → plan → approval → save → END
              ↑           ↑                                                    │
              │           └──────────────── (if vibe check fails) ─────────────┤
              └──────────────────────────── (if rejected) ─────────────────────┘
```

This adds:
- BA questions phase (multiple rounds of HITL)
- Innovation selection phase (HITL)
- PRD generation with user stories
- Execution planning with waves
- Template-based output

---

## Testing the /ms Workflow

### Start the Server

```bash
cd metasaver-workflow
pnpm install
pnpm dev
```

Server runs at `http://localhost:2024`

### Test with Agent Chat UI

```bash
# In another terminal
npx create-agent-chat-app
cd agent-chat-app
pnpm install
pnpm dev
```

Open `http://localhost:3000`, connect to:
- Deployment URL: `http://localhost:2024`
- Graph ID: `ms`

### Test with cURL

```bash
# Create a thread
curl -X POST http://localhost:2024/threads \
  -H "Content-Type: application/json" \
  -d '{}'

# Start a run (use thread_id from response)
curl -X POST http://localhost:2024/threads/{thread_id}/runs \
  -H "Content-Type: application/json" \
  -d '{
    "graph_id": "ms",
    "input": {
      "command": "Add a logger utility to src/utils/logger.ts"
    }
  }'

# Get state (check for interrupts)
curl http://localhost:2024/threads/{thread_id}/state

# Resume with answers (when interrupted)
curl -X POST http://localhost:2024/threads/{thread_id}/runs \
  -H "Content-Type: application/json" \
  -d '{
    "graph_id": "ms",
    "input": {
      "resume": {
        "q0": "Winston logger with JSON format"
      }
    }
  }'
```

---

## Success Criteria

### Phase 1 (/ms) Complete When:

- [ ] Server starts with `pnpm dev`
- [ ] Can create thread and start workflow
- [ ] Scope check identifies files correctly
- [ ] Clarify node pauses for human input (interrupt works)
- [ ] Resume with answers continues workflow
- [ ] Execute generates code changes
- [ ] Verify checks acceptance criteria
- [ ] Save requires final approval (interrupt works)
- [ ] Files are written only after approval
- [ ] Same inputs produce same outputs (deterministic)

### Phase 2 Ready When:

- [ ] /ms is stable and tested
- [ ] Patterns established for nodes, schemas, HITL
- [ ] Ready to add complexity of /architect workflow

---

## Notes for Implementation

1. **Start simple**: Get the graph compiling and running before adding LLM calls
2. **Mock LLM first**: Return hardcoded responses to test flow
3. **Add HITL early**: Verify interrupt/resume works before complex logic
4. **One node at a time**: Test each node in isolation
5. **Use LangGraph Studio**: Visual debugging at `https://smith.langchain.com/studio?baseUrl=http://localhost:2024`

---

## References

- LangGraph.js Docs: https://langchain-ai.github.io/langgraphjs/
- HITL Patterns: https://langchain-ai.github.io/langgraph/how-tos/human_in_the_loop/
- Agent Chat UI: https://github.com/langchain-ai/agent-chat-ui
- Zod Docs: https://zod.dev/
