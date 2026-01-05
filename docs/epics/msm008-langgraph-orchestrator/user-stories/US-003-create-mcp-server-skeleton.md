---
story_id: "MSM008-003"
title: "Create MCP server skeleton"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-001"]
---

# Story: Create MCP Server Skeleton

## Description

As a developer, I need an MCP server skeleton using `@metasaver/core-mcp-utils` patterns so that the orchestrator can expose tools to Claude Code.

## Acceptance Criteria

- [ ] MCP server created at `src/mcp/server.ts`
- [ ] Uses `createMCPServer()` from `@metasaver/core-mcp-utils`
- [ ] Server name: `langgraph-orchestrator`
- [ ] Server version matches package version
- [ ] Capabilities include `tools: {}`
- [ ] Server starts successfully via stdio transport

## Architecture

- **Files to create:**
  - `packages/langgraph-orchestrator/src/mcp/server.ts`
  - `packages/langgraph-orchestrator/src/mcp/tools/.gitkeep`
- **Files to modify:**
  - `packages/langgraph-orchestrator/package.json` (add @metasaver/core-mcp-utils dependency)
- **Database:** None
- **Components:** None
- **Libraries:**
  - Use `@metasaver/core-mcp-utils` - `createMCPServer()` factory function
  - Reference: `/home/jnightin/code/multi-mono/packages/mcp-utils/src/core/server-factory.ts`

## Implementation Notes

**MCP server pattern (from core-mcp-utils):**

```typescript
import { createMCPServer } from "@metasaver/core-mcp-utils/core";

const server = createMCPServer({
  name: "langgraph-orchestrator",
  version: "1.0.0",
  description: "LangGraph workflow orchestration for MetaSaver plugin",
  capabilities: {
    tools: {},
  },
});

server.start();
```

**Package dependency:**

```json
{
  "dependencies": {
    "@metasaver/core-mcp-utils": "workspace:*"
  }
}
```

Note: Since this is in metasaver-marketplace (not multi-mono), may need to reference via npm package or relative path. Consider bundling approach.

## Dependencies

- MSM008-001: Package structure must exist

## Estimated Effort

Small (1-2 hours)
