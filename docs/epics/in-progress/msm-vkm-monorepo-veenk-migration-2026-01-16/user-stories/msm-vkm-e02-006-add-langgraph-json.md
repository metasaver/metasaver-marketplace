---
story_id: "MSM-VKM-E02-006"
epic_id: "MSM-VKM-E02"
title: "Add langgraph.json configuration"
status: "pending"
complexity: 2
wave: 2
agent: "core-claude-plugin:generic:coder"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E02-006: Add langgraph.json configuration

## User Story

**As a** developer working with LangGraph workflows
**I want** langgraph.json configuration for LangGraph Studio integration
**So that** LangGraph Studio can discover and load workflows from the monorepo

---

## Acceptance Criteria

- [ ] File `langgraph.json` created at repository root
- [ ] Configuration points to workflow package location
- [ ] Workflow entry points specified correctly
- [ ] Redis connection URL configured
- [ ] Environment variable references configured (if needed)
- [ ] File format is valid JSON
- [ ] LangGraph Studio discovers workflows
- [ ] Workflows load successfully in LangGraph Studio
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File             | Purpose                             |
| ---------------- | ----------------------------------- |
| `langgraph.json` | LangGraph Studio configuration file |

### Files to Modify

None - this is a new file.

---

## Implementation Notes

Copy langgraph.json from veenk repository and update paths:

**Source location:** `/home/jnightin/code/veenk/langgraph.json`
**Target location:** `/home/jnightin/code/metasaver-marketplace/langgraph.json`

### Expected Configuration

```json
{
  "dependencies": ["."],
  "graphs": {
    "architect": "./packages/veenk-workflows/src/graphs/architect.ts"
  },
  "env": {
    "REDIS_URL": "redis://localhost:6379"
  }
}
```

### Path Updates

Update paths to reflect new monorepo structure:

- Workflow paths: `./packages/veenk-workflows/src/`
- Dependency references: Update if needed

### Dependencies

None - this is a configuration file.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `langgraph.json` - LangGraph Studio configuration

**Integration:**

- LangGraph Studio reads this file to discover workflows
- Redis URL configured for checkpointing
- Workflow entry points map to TypeScript files

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `cat langgraph.json | jq`
- [ ] LangGraph Studio discovers workflows
- [ ] Workflows load without errors in LangGraph Studio

---

## Notes

- LangGraph Studio requires this file for workflow discovery
- Paths must point to migrated package locations
- Redis URL can use environment variable
- Does not affect existing plugin structure at plugins/metasaver-core/
