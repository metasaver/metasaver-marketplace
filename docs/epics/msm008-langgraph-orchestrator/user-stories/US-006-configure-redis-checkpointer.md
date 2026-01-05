---
story_id: "MSM008-006"
title: "Configure Redis checkpointer for state persistence"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-002"]
---

# Story: Configure Redis Checkpointer

## Description

As a workflow system, I need Redis-based state persistence so that workflows can be paused, resumed, and recovered after process crashes (NFR-007).

## Acceptance Criteria

- [ ] `@langchain/langgraph-checkpoint-redis` dependency installed
- [ ] Redis checkpointer configured with `REDIS_URL` environment variable
- [ ] Default TTL of 7 days for workflow state
- [ ] Checkpointer integrates with LangGraph workflow compilation
- [ ] State persists across process restarts (verify with test)

## Architecture

- **Files to modify:**
  - `packages/langgraph-orchestrator/package.json` (add dependency)
- **Files to create:**
  - `packages/langgraph-orchestrator/src/lib/checkpointer.ts`
- **Database:** Redis (external service)
- **Components:** None
- **Libraries:**
  - `@langchain/langgraph-checkpoint-redis` - Redis state persistence
  - Reference multi-mono for Redis patterns if available

## Implementation Notes

**Checkpointer setup (src/lib/checkpointer.ts):**

```typescript
import { RedisCheckpointer } from "@langchain/langgraph-checkpoint-redis";

export interface CheckpointerConfig {
  redisUrl?: string;
  ttlSeconds?: number;
}

const DEFAULT_TTL_SECONDS = 7 * 24 * 60 * 60; // 7 days

export function createCheckpointer(config: CheckpointerConfig = {}) {
  const redisUrl = config.redisUrl || process.env.REDIS_URL || "redis://localhost:6379";
  const ttl = config.ttlSeconds || DEFAULT_TTL_SECONDS;

  return new RedisCheckpointer({
    url: redisUrl,
    ttl,
  });
}
```

**Integration with workflow:**

```typescript
import { createCheckpointer } from "../lib/checkpointer.js";

const checkpointer = createCheckpointer();
const workflow = graph.compile({ checkpointer });
```

**Environment variable:**

- `REDIS_URL` - Redis connection URL (default: `redis://localhost:6379`)

## Dependencies

- MSM008-002: LangGraph.js must be configured
- MSM008-007: Redis service must be available (can develop in parallel with localhost)

## Estimated Effort

Medium (2-3 hours)
