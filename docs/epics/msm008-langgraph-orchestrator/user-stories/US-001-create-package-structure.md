---
story_id: "MSM008-001"
title: "Create package structure for langgraph-orchestrator"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: []
---

# Story: Create Package Structure

## Description

As a developer, I need the `langgraph-orchestrator` package created with proper TypeScript configuration so that I can build the LangGraph workflow orchestration system.

## Acceptance Criteria

- [ ] Package created at `packages/langgraph-orchestrator/`
- [ ] `package.json` with name `@metasaver/langgraph-orchestrator`
- [ ] `tsconfig.json` with strict mode enabled
- [ ] Source directory structure: `src/workflows/`, `src/mcp/`, `src/lib/`
- [ ] Package exports configured for `./workflows/build` and `./mcp`
- [ ] Build script produces `dist/` output
- [ ] Package type is `"module"` (ESM)

## Architecture

- **Files to create:**
  - `packages/langgraph-orchestrator/package.json`
  - `packages/langgraph-orchestrator/tsconfig.json`
  - `packages/langgraph-orchestrator/src/workflows/build/.gitkeep`
  - `packages/langgraph-orchestrator/src/mcp/.gitkeep`
  - `packages/langgraph-orchestrator/src/lib/.gitkeep`
- **Database:** None
- **Components:** None
- **Libraries:**
  - Base on multi-mono package structure patterns
  - Reference `@metasaver/core-mcp-utils` package.json for ESM configuration

## Implementation Notes

**package.json structure:**

```json
{
  "name": "@metasaver/langgraph-orchestrator",
  "version": "1.0.0",
  "type": "module",
  "exports": {
    "./workflows/build": {
      "types": "./dist/workflows/build/index.d.ts",
      "import": "./dist/workflows/build/index.js"
    },
    "./mcp": {
      "types": "./dist/mcp/server.d.ts",
      "import": "./dist/mcp/server.js"
    }
  },
  "scripts": {
    "build": "tsc",
    "dev:debug": "langgraph dev"
  }
}
```

**tsconfig.json requirements:**

- `strict: true`
- `module: "NodeNext"`
- `moduleResolution: "NodeNext"`
- `outDir: "./dist"`
- `rootDir: "./src"`

## Dependencies

- None (first story in epic)

## Estimated Effort

Small (1-2 hours)
