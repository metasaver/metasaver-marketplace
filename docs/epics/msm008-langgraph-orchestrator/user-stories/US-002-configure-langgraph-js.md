---
story_id: "MSM008-002"
title: "Configure LangGraph.js dependencies"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-001"]
---

# Story: Configure LangGraph.js Dependencies

## Description

As a developer, I need LangGraph.js installed and configured so that I can define state machine workflows for the orchestrator.

## Acceptance Criteria

- [ ] `@langchain/langgraph` dependency installed (^0.2.0)
- [ ] `@langchain/core` dependency installed (peer dependency)
- [ ] `zod` dependency installed (^3.22.0) for state schema validation
- [ ] Basic workflow can be instantiated without errors
- [ ] TypeScript types resolve correctly for LangGraph imports

## Architecture

- **Files to modify:**
  - `packages/langgraph-orchestrator/package.json` (add dependencies)
- **Files to create:**
  - `packages/langgraph-orchestrator/src/workflows/build/index.ts` (basic graph structure)
  - `packages/langgraph-orchestrator/src/workflows/build/state.ts` (state schema placeholder)
- **Database:** None
- **Components:** None
- **Libraries:**
  - `@langchain/langgraph` - Core workflow engine
  - `@langchain/core` - Base LangChain types
  - `zod` - Schema validation (already used in multi-mono)

## Implementation Notes

**Dependencies to add:**

```json
{
  "dependencies": {
    "@langchain/langgraph": "^0.2.0",
    "@langchain/core": "^0.3.0",
    "zod": "^3.22.0"
  }
}
```

**Basic graph structure (src/workflows/build/index.ts):**

```typescript
import { StateGraph, END } from "@langchain/langgraph";
import { BuildStateSchema, type BuildState } from "./state.js";

export function createBuildWorkflow() {
  const graph = new StateGraph<BuildState>({
    channels: {
      command: { value: () => "build" },
      phase: { value: () => 1 },
      status: { value: () => "planning" },
    },
  });

  return graph;
}
```

## Dependencies

- MSM008-001: Package structure must exist

## Estimated Effort

Small (1-2 hours)
