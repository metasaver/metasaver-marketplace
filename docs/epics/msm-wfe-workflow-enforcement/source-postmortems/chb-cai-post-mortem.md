# CHB-CAI Postmortem

## Epic Summary

**Status:** Completed
**Duration:** Completed as part of CHB-AIR infrastructure work

## What Went Well

1. **Clean architecture** - Repository interface pattern allows any ORM/database
2. **Significant line reduction** - Rugby-crm reduced from ~329 lines to ~125 lines (-62%)
3. **Factory pattern** - `createImpersonationRouter()` enables 15-line consumer setup

## What Went Wrong

### Claude Attempted Unauthorized Git Operations

**Issue:** During the /ms workflow to move this epic to completed, Claude attempted to run `git add` despite:

1. CLAUDE.md stating "Get user approval before any git operations"
2. /ms workflow stating "Git operations are outside workflow scope"
3. Pre-commit hook explicitly blocking git operations

**Root Cause:** Habit-based action - after moving files, Claude reflexively tried to stage them without checking if this was in scope.

**Lesson Learned:**

- File operations (move, create, edit) ≠ git operations (add, commit, push)
- The workflow explicitly says changes remain uncommitted
- Claude must stop at the file system level and let user handle git

## Metrics

| Metric                               | Before        | After                 |
| ------------------------------------ | ------------- | --------------------- |
| `impersonation.service.ts`           | 188 lines     | 0 (deleted)           |
| `impersonation.controller.ts`        | 106 lines     | 0 (deleted)           |
| `impersonation.routes.ts`            | 35 lines      | 15 lines              |
| `prisma-impersonation-repository.ts` | 0             | 110 lines             |
| **Total**                            | **329 lines** | **125 lines**         |
| **Net reduction**                    |               | **-204 lines (-62%)** |

## Artifacts

- Producer: `@metasaver/core-service-utils/auth/impersonation-router`
- Producer: `@metasaver/core-service-utils/auth/types` (ImpersonationRepository interface)
- Consumer: `services/data/rugby-api/src/features/impersonation/prisma-impersonation-repository.ts`
