---
story_id: "MSM008-008"
title: "Configure LangSmith/Langfuse observability"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-002"]
---

# Story: Configure LangSmith/Langfuse Observability

## Description

As a developer, I need automatic tracing of all graph node executions so that I can debug workflow issues and monitor performance (NFR-009).

## Acceptance Criteria

- [ ] LangSmith tracing enabled via `LANGCHAIN_TRACING_V2=true`
- [ ] Langfuse as alternative via `LANGFUSE_*` environment variables
- [ ] All graph node executions automatically traced
- [ ] Trace metadata includes workflow_id, phase, story_id
- [ ] Observability silently disabled if credentials not configured

## Architecture

- **Files to create:**
  - `packages/langgraph-orchestrator/src/lib/observability.ts`
- **Files to modify:**
  - `packages/langgraph-orchestrator/package.json` (add langfuse dependency)
- **Database:** None
- **Components:** None
- **Libraries:**
  - Use `@metasaver/core-agent-utils` - `createLangfuseHandler()` as reference
  - Reference: `/home/jnightin/code/multi-mono/packages/agent-utils/src/observability.ts`
  - `langfuse-langchain` for Langfuse integration

## Implementation Notes

**Observability module (src/lib/observability.ts):**

```typescript
import { CallbackHandler } from "langfuse-langchain";

export function configureObservability() {
  // LangSmith is auto-enabled via environment variables:
  // LANGCHAIN_TRACING_V2=true
  // LANGCHAIN_API_KEY=<key>
  // LANGCHAIN_PROJECT=msm008-langgraph-orchestrator

  if (process.env.LANGCHAIN_TRACING_V2 === "true") {
    console.error("LangSmith tracing enabled");
  }
}

export function createLangfuseHandler(): CallbackHandler | null {
  try {
    if (!process.env.LANGFUSE_SECRET_KEY || !process.env.LANGFUSE_PUBLIC_KEY) {
      return null;
    }

    return new CallbackHandler({
      secretKey: process.env.LANGFUSE_SECRET_KEY,
      publicKey: process.env.LANGFUSE_PUBLIC_KEY,
      baseUrl: process.env.LANGFUSE_HOST,
      sessionId: `langgraph-${Date.now()}`,
      metadata: {
        project: "msm008-langgraph-orchestrator",
      },
    });
  } catch {
    return null; // Silently disable on errors
  }
}

export function createTraceMetadata(workflowId: string, phase: string, storyId?: string) {
  return {
    run_name: `${phase}-${workflowId}`,
    metadata: {
      workflow_id: workflowId,
      phase,
      story_id: storyId,
      timestamp: new Date().toISOString(),
    },
  };
}
```

**Environment variables:**
| Variable | Description |
|----------|-------------|
| `LANGCHAIN_TRACING_V2` | Enable LangSmith (true/false) |
| `LANGCHAIN_API_KEY` | LangSmith API key |
| `LANGCHAIN_PROJECT` | LangSmith project name |
| `LANGFUSE_PUBLIC_KEY` | Langfuse public key |
| `LANGFUSE_SECRET_KEY` | Langfuse secret key |
| `LANGFUSE_HOST` | Langfuse host URL |

## Dependencies

- MSM008-002: LangGraph.js for automatic tracing integration

## Estimated Effort

Medium (2-3 hours)
