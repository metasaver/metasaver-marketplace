---
story_id: "MSM-VKM-E03-004"
epic_id: "MSM-VKM-E03"
title: "Update package.json with @metasaver namespace"
status: "pending"
complexity: 2
wave: 3
agent: "core-claude-plugin:config:workspace:root-package-json-agent"
dependencies: ["MSM-VKM-E03-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E03-004: Update package.json with @metasaver namespace

## User Story

**As a** developer working with the workflow package
**I want** package.json updated with the correct @metasaver namespace
**So that** the package is properly scoped and can be published/referenced correctly

---

## Acceptance Criteria

- [ ] Package name is @metasaver/veenk-workflows
- [ ] Version field present and appropriate
- [ ] Description updated to reflect marketplace context
- [ ] Scripts section includes build, test, lint, lint:tsc
- [ ] Dependencies copied from veenk package.json
- [ ] DevDependencies copied from veenk package.json
- [ ] Repository field references metasaver-marketplace
- [ ] Keywords include relevant terms (langgraph, workflows, metasaver)
- [ ] License field appropriate (MIT or project license)
- [ ] File format is valid JSON
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** packages/veenk-workflows

### Files to Create

None - this modifies an existing file.

### Files to Modify

| File                                    | Changes                               |
| --------------------------------------- | ------------------------------------- |
| `packages/veenk-workflows/package.json` | Update name, dependencies, repository |

---

## Implementation Notes

Update package.json based on veenk repository version:

**Source location:** `/home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/package.json`
**Target location:** `/home/jnightin/code/metasaver-marketplace/packages/veenk-workflows/package.json`

### Key Updates

1. **Name**: Change to `@metasaver/veenk-workflows`
2. **Repository**: Update to metasaver-marketplace repository URL
3. **Dependencies**: Copy all dependencies from veenk
4. **DevDependencies**: Copy all devDependencies from veenk
5. **Scripts**: Ensure standard monorepo scripts present

### Expected Structure

```json
{
  "name": "@metasaver/veenk-workflows",
  "version": "0.1.0",
  "description": "LangGraph workflow implementations for MetaSaver",
  "type": "module",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "vitest",
    "test:watch": "vitest --watch",
    "lint": "eslint src __tests__",
    "lint:tsc": "tsc --noEmit"
  },
  "dependencies": {
    "@langchain/langgraph": "^0.0.20",
    "@langchain/core": "^0.1.50"
  },
  "devDependencies": {
    "typescript": "^5.3.0",
    "vitest": "^1.2.0"
  },
  "keywords": ["langgraph", "workflows", "metasaver"],
  "license": "MIT"
}
```

### Dependencies

Depends on MSM-VKM-E03-001 (package structure must exist).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `packages/veenk-workflows/package.json` - Package manifest

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] File validated with `cat package.json | jq`
- [ ] Package name uses @metasaver namespace
- [ ] All dependencies present

---

## Notes

- This updates the package manifest for marketplace context
- Critical for pnpm workspace to recognize package
- Dependencies must be copied accurately to avoid build failures
- Does not affect existing plugin structure at plugins/metasaver-core/
