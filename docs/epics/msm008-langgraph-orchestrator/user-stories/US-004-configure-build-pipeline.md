---
story_id: "MSM008-004"
title: "Configure TypeScript build pipeline"
epic: "Epic 1: Foundation"
status: "pending"
priority: "P0"
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM008-001", "MSM008-002", "MSM008-003"]
---

# Story: Configure TypeScript Build Pipeline

## Description

As a developer, I need the TypeScript build pipeline configured so that the package compiles to `dist/` and can be committed for bundled distribution.

## Acceptance Criteria

- [ ] `npm run build` compiles TypeScript to `dist/`
- [ ] Build completes in < 30 seconds (NFR-002)
- [ ] Output includes `.js` and `.d.ts` files
- [ ] Source maps generated for debugging
- [ ] `dist/` directory can be committed to git
- [ ] Package exports resolve correctly after build

## Architecture

- **Files to modify:**
  - `packages/langgraph-orchestrator/package.json` (scripts)
  - `packages/langgraph-orchestrator/tsconfig.json` (build settings)
- **Files to create:**
  - `packages/langgraph-orchestrator/.gitignore` (exclude node_modules, include dist)
- **Database:** None
- **Components:** None
- **Libraries:** TypeScript compiler (tsc)

## Implementation Notes

**tsconfig.json build settings:**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

**package.json scripts:**

```json
{
  "scripts": {
    "build": "tsc",
    "build:watch": "tsc --watch",
    "clean": "rm -rf dist"
  }
}
```

**.gitignore:**

```
node_modules/
# Note: dist/ is NOT ignored - bundled distribution
*.log
.DS_Store
```

## Dependencies

- MSM008-001: Package structure
- MSM008-002: LangGraph dependencies (for compilation)
- MSM008-003: MCP server (for compilation)

## Estimated Effort

Small (1 hour)
