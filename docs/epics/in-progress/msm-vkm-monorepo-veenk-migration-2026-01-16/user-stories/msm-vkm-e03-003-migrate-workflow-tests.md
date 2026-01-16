---
story_id: "MSM-VKM-E03-003"
epic_id: "MSM-VKM-E03"
title: "Migrate workflow test files"
status: "pending"
complexity: 3
wave: 3
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E03-003: Migrate workflow test files

## User Story

**As a** developer ensuring workflow quality
**I want** all workflow test files migrated to the marketplace packages directory
**So that** tests can verify workflow behavior in the unified monorepo

---

## Acceptance Criteria

- [ ] All 10 test files copied to packages/veenk-workflows/**tests**/
- [ ] Test file structure preserved
- [ ] File contents unchanged (no modifications during copy)
- [ ] All workflow node tests migrated
- [ ] All integration tests migrated
- [ ] File permissions preserved
- [ ] Source files remain at original location (copy, not move)
- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** packages/veenk-workflows

### Files to Create

10 test files in packages/veenk-workflows/**tests**/:

| File                      | Purpose                           |
| ------------------------- | --------------------------------- |
| `architect.test.ts`       | Tests for architect workflow node |
| `reviewer.test.ts`        | Tests for reviewer workflow node  |
| `planner.test.ts`         | Tests for planner workflow node   |
| `coder.test.ts`           | Tests for coder workflow node     |
| `tester.test.ts`          | Tests for tester workflow node    |
| _(and 5 more test files)_ | _(additional workflow tests)_     |

### Files to Modify

None - this story is copy only. Import paths will be updated in MSM-VKM-E03-005.

---

## Implementation Notes

Copy all workflow test files from veenk to marketplace:

**Source location:** `/home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/__tests__/`
**Target location:** `/home/jnightin/code/metasaver-marketplace/packages/veenk-workflows/__tests__/`

### Migration Process

1. Copy entire **tests**/ directory contents
2. Preserve file structure
3. Do NOT modify file contents
4. Do NOT update imports yet (handled in separate story)
5. Verify all 10 test files copied successfully

### Test File Inventory

Expected test files to migrate:

- Workflow node tests (5-7 files)
- Integration tests (2-3 files)
- Utility tests (1-2 files)

### Dependencies

Depends on MSM-VKM-E03-001 (package directory structure must exist).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All test files in packages/veenk-workflows/**tests**/

**Migration Pattern:**

```
veenk/packages/agentic-workflows/veenk-workflows/__tests__/
  └─> metasaver-marketplace/packages/veenk-workflows/__tests__/
```

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All 10 test files present in target location
- [ ] File contents identical to source
- [ ] Tests can be executed (may fail until imports fixed)

---

## Notes

- This is a straight copy operation - no code changes
- Import paths will be broken after this step (fixed in MSM-VKM-E03-005)
- Tests may fail until imports are updated
- Does not affect existing plugin structure at plugins/metasaver-core/
- Source files remain in veenk repository (copy, not move)
