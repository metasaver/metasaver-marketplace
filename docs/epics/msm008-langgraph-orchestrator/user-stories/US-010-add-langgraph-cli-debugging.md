---
story_id: "MSM008-010"
title: "Add langgraph-cli debugging setup"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P1"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-002", "MSM008-004"]
---

# Story: Add LangGraph CLI Debugging Setup

## Description

As a developer, I need the LangGraph CLI configured so that I can interactively debug workflows, inspect state, and step through node executions (FR-012, FR-013).

## Acceptance Criteria

- [ ] `@langchain/langgraph-cli` installed as devDependency
- [ ] npm script `dev:debug` runs `langgraph dev`
- [ ] LangGraph Studio opens workflow visualization
- [ ] Breakpoints work at node boundaries
- [ ] State can be inspected at each step

## Architecture

- **Files to modify:**
  - `packages/langgraph-orchestrator/package.json` (add devDependency and script)
- **Files to create:**
  - `packages/langgraph-orchestrator/langgraph.json` (CLI configuration)
- **Database:** None
- **Components:** None
- **Libraries:**
  - `@langchain/langgraph-cli` - Interactive debugging CLI

## Implementation Notes

**Package.json updates:**

```json
{
  "scripts": {
    "dev:debug": "langgraph dev"
  },
  "devDependencies": {
    "@langchain/langgraph-cli": "^0.1.0"
  }
}
```

**langgraph.json configuration:**

```json
{
  "graphs": {
    "build": {
      "path": "./src/workflows/build/index.ts",
      "entrypoint": "createBuildWorkflow"
    }
  },
  "env": ".env"
}
```

**Usage documentation:**

````markdown
## Interactive Debugging

1. Start the debugger:
   ```bash
   cd packages/langgraph-orchestrator
   npm run dev:debug
   ```
````

2. Open LangGraph Studio in browser (URL shown in terminal)

3. Available features:
   - Visual workflow diagram
   - Step-through execution
   - State inspection at each node
   - Breakpoint support
   - Input/output viewing

```

**Developer workflow:**
1. Make changes to workflow nodes
2. Run `npm run dev:debug`
3. Test with sample inputs in Studio
4. Inspect state transitions
5. Fix issues and iterate

## Dependencies

- MSM008-002: LangGraph.js must be configured
- MSM008-004: Build pipeline must work

## Estimated Effort

Small (1-2 hours)
```
