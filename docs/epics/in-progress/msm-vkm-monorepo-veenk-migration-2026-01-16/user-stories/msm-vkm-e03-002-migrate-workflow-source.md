---
story_id: "MSM-VKM-E03-002"
epic_id: "MSM-VKM-E03"
title: "Migrate workflow source files"
status: "pending"
complexity: 4
wave: 0
agent: "core-claude-plugin:generic:coder"
dependencies: ["MSM-VKM-E03-001"]
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E03-002: Migrate workflow source files

## User Story

**As a** developer working with LangGraph workflows
**I want** all workflow source files migrated to the marketplace packages directory
**So that** workflows are accessible from the unified monorepo structure

---

## Acceptance Criteria

- [ ] All 18 TypeScript source files copied to packages/veenk-workflows/src/
- [ ] Directory structure preserved (nodes/, schemas/, state/, utils/)
- [ ] File contents unchanged (no modifications during copy)
- [ ] All workflow nodes migrated (architect.ts, reviewer.ts, etc.)
- [ ] All schema files migrated (workflow state schemas)
- [ ] All utility files migrated (helpers, validators, etc.)
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

18 TypeScript source files in packages/veenk-workflows/src/:

| File                        | Purpose                         |
| --------------------------- | ------------------------------- |
| `nodes/architect.ts`        | Architect workflow node         |
| `nodes/reviewer.ts`         | Reviewer workflow node          |
| `nodes/planner.ts`          | Planner workflow node           |
| `nodes/coder.ts`            | Coder workflow node             |
| `nodes/tester.ts`           | Tester workflow node            |
| `schemas/workflow-state.ts` | Workflow state type definitions |
| `state/checkpointing.ts`    | State persistence logic         |
| `utils/validation.ts`       | Workflow validation utilities   |
| `utils/error-handling.ts`   | Error handling utilities        |
| `index.ts`                  | Package exports                 |
| _(and 8 more files)_        | _(additional workflow code)_    |

### Files to Modify

None - this story is copy only. Import paths will be updated in MSM-VKM-E03-005.

---

## Implementation Notes

Copy all workflow source files from veenk to marketplace:

**Source location:** `/home/jnightin/code/veenk/packages/agentic-workflows/veenk-workflows/src/`
**Target location:** `/home/jnightin/code/metasaver-marketplace/packages/veenk-workflows/src/`

### Migration Process

1. Copy entire src/ directory structure
2. Preserve directory hierarchy
3. Do NOT modify file contents
4. Do NOT update imports yet (handled in separate story)
5. Verify all 18 files copied successfully

### Source File Inventory

Expected files to migrate (exact list from veenk repository):

- Workflow node implementations (5-7 files)
- Schema definitions (2-3 files)
- State management (1-2 files)
- Utilities (3-5 files)
- Main index file (1 file)

### Dependencies

Depends on MSM-VKM-E03-001 (package directory structure must exist).

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- All TypeScript source files in packages/veenk-workflows/src/

**Migration Pattern:**

```
veenk/packages/agentic-workflows/veenk-workflows/src/
  └─> metasaver-marketplace/packages/veenk-workflows/src/
```

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] All 18 source files present in target location
- [ ] Directory structure matches source
- [ ] File contents identical to source

---

## Notes

- This is a straight copy operation - no code changes
- Import paths will be broken after this step (fixed in MSM-VKM-E03-005)
- TypeScript compilation will fail until imports are updated
- Does not affect existing plugin structure at plugins/metasaver-core/
- Source files remain in veenk repository (copy, not move)
