---
story_id: "MSM008-005"
title: "Update plugin .mcp.json configuration"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-004"]
---

# Story: Update Plugin .mcp.json Configuration

## Description

As a plugin user, I need the `.mcp.json` updated to include the langgraph-orchestrator server so that Claude Code can access the orchestration tools.

## Acceptance Criteria

- [ ] `.mcp.json` includes `langgraph-orchestrator` server entry
- [ ] Server command points to `dist/mcp/server.js`
- [ ] Server loads successfully when Claude Code starts
- [ ] No conflicts with existing MCP servers

## Architecture

- **Files to modify:**
  - `plugins/metasaver-core/.mcp.json`
- **Files to create:** None
- **Database:** None
- **Components:** None
- **Libraries:** None

## Implementation Notes

**Updated .mcp.json entry:**

```json
{
  "mcpServers": {
    "langgraph-orchestrator": {
      "command": "node",
      "args": ["../packages/langgraph-orchestrator/dist/mcp/server.js"]
    }
  }
}
```

**Path considerations:**

- `.mcp.json` is at `plugins/metasaver-core/.mcp.json`
- Package is at `packages/langgraph-orchestrator/`
- Relative path from plugin to package: `../packages/langgraph-orchestrator/dist/mcp/server.js`

**Verification:**

1. Build the package: `cd packages/langgraph-orchestrator && npm run build`
2. Start Claude Code in a project with the plugin installed
3. Verify MCP server appears in available tools

## Dependencies

- MSM008-004: Build pipeline must produce `dist/mcp/server.js`

## Estimated Effort

Small (30 minutes)
