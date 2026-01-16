---
story_id: "MSM-VKM-E03-001"
epic_id: "MSM-VKM-E03"
title: "Create veenk-workflows package structure"
status: "pending"
complexity: 2
wave: 3
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E02-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E03-001: Create veenk-workflows package structure

## User Story

**As a** developer migrating workflow code to the monorepo
**I want** a complete package directory structure for veenk-workflows
**So that** workflow source files, tests, and configuration can be organized properly

---

## Acceptance Criteria

- [ ] Directory packages/veenk-workflows/ created at repository root
- [ ] Subdirectory packages/veenk-workflows/src/ created
- [ ] Subdirectory packages/veenk-workflows/**tests**/ created
- [ ] File packages/veenk-workflows/package.json created with @metasaver/veenk-workflows name
- [ ] File packages/veenk-workflows/tsconfig.json created
- [ ] File packages/veenk-workflows/README.md created
- [ ] File packages/veenk-workflows/vitest.config.ts created (if using Vitest)
- [ ] Directory structure matches standard package layout
- [ ] All configuration files valid
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** packages/veenk-workflows

### Files to Create

| File                                        | Purpose                  |
| ------------------------------------------- | ------------------------ |
| `packages/veenk-workflows/package.json`     | Package manifest         |
| `packages/veenk-workflows/tsconfig.json`    | TypeScript configuration |
| `packages/veenk-workflows/README.md`        | Package documentation    |
| `packages/veenk-workflows/vitest.config.ts` | Test configuration       |
| `packages/veenk-workflows/src/`             | Source code directory    |
| `packages/veenk-workflows/__tests__/`       | Test files directory     |

### Files to Modify

None - this creates new package structure.

---

## Implementation Notes

Create package directory structure by copying from veenk:

**Source location:** `/home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/`
**Target location:** `/home/jnightin/code/metasaver-marketplace/packages/veenk-workflows/`

### Package.json Configuration

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
  "keywords": ["langgraph", "workflows", "metasaver"],
  "license": "MIT"
}
```

### Dependencies to Copy

Copy devDependencies from veenk package.json:

- TypeScript
- Vitest
- LangGraph dependencies
- Testing utilities

### Dependencies

Depends on MSM-VKM-E02-001 (configuration must be in place first).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `package.json` - Package manifest with @metasaver namespace
- `tsconfig.json` - TypeScript compiler configuration
- `README.md` - Package documentation
- `vitest.config.ts` - Test runner configuration

**Package Structure:**

```
packages/veenk-workflows/
├── package.json
├── tsconfig.json
├── vitest.config.ts
├── README.md
├── src/
│   └── (source files added in MSM-VKM-E03-002)
└── __tests__/
    └── (test files added in MSM-VKM-E03-003)
```

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Directory structure created
- [ ] All configuration files valid
- [ ] package.json validated with `cat package.json | jq`

---

## Notes

- This creates empty package structure - source files added in separate story
- Package name uses @metasaver namespace for consistency
- Configuration files based on veenk repository patterns
- Does not affect existing plugin structure at plugins/metasaver-core/
