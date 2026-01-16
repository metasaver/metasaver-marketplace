---
story_id: "MSM-VKM-E03-005"
epic_id: "MSM-VKM-E03"
title: "Update import paths in TypeScript files"
status: "pending"
complexity: 4
wave: 0
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-002", "MSM-VKM-E03-004"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E03-005: Update import paths in TypeScript files

## User Story

**As a** developer building the migrated workflow package
**I want** all import paths updated to reflect the new package name and structure
**So that** TypeScript compilation succeeds and module resolution works correctly

---

## Acceptance Criteria

- [ ] All package imports updated to @metasaver/veenk-workflows
- [ ] All relative imports updated if directory structure changed
- [ ] No broken import references remain
- [ ] TypeScript compilation succeeds without module resolution errors
- [ ] ESLint passes without import-related errors
- [ ] All exports from index.ts resolve correctly
- [ ] Test files can import from package successfully
- [ ] No circular dependency warnings
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** packages/veenk-workflows

### Files to Create

None - this modifies existing files.

### Files to Modify

All TypeScript files in packages/veenk-workflows/src/ and packages/veenk-workflows/test/:

| File Pattern        | Changes                                           |
| ------------------- | ------------------------------------------------- |
| `src/**/*.ts`       | Update package imports to @metasaver/\* namespace |
| `test/**/*.test.ts` | Update package imports to @metasaver/\* namespace |

---

## Implementation Notes

Update import statements across all migrated TypeScript files:

### Import Pattern Changes

**Before (veenk):**

```typescript
import { WorkflowState } from "@veenk/workflows";
import { ArchitectNode } from "agentic-workflows";
```

**After (marketplace):**

```typescript
import { WorkflowState } from "@metasaver/veenk-workflows";
import { ArchitectNode } from "@metasaver/veenk-workflows";
```

### Relative Import Updates

If internal file structure changed:

- Update relative imports (./schemas/_, ../utils/_, etc.)
- Verify directory references match new structure

### Automated Find/Replace

Use search and replace for common patterns:

1. `@veenk/workflows` → `@metasaver/veenk-workflows`
2. `agentic-workflows` → `@metasaver/veenk-workflows`
3. Review and update any other package-specific imports

### Validation Process

1. Run `pnpm lint:tsc` to find remaining import errors
2. Fix each TypeScript error related to module resolution
3. Verify all exports from index.ts work correctly
4. Run tests to confirm imports resolve at runtime

### Dependencies

Depends on:

- MSM-VKM-E03-002: Source files must be migrated
- MSM-VKM-E03-004: package.json must have updated name

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All TypeScript files with import statements
- index.ts (main package export)
- test/\*_/_.test.ts (test file imports)

**Import Resolution:**

- TypeScript resolves @metasaver/\* via tsconfig.json paths
- pnpm workspace resolves package dependencies
- All imports must use new @metasaver namespace

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] `pnpm lint:tsc` passes with no module resolution errors
- [ ] `pnpm build` succeeds for veenk-workflows package
- [ ] No broken import references found

---

## Notes

- This is a critical step - broken imports will prevent compilation
- Use automated find/replace where possible, but review each change
- Test compilation after each batch of changes
- Verify test files can import from package correctly
- Does not affect existing plugin structure at plugins/metasaver-core/
