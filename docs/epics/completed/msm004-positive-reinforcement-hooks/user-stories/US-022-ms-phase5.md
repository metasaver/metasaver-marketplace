# US-022: Implement /ms Phase 5 (Validation)

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-021
**Parallelizable With:** none (needs Phase 4 complete)
**Priority:** Medium
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a /ms command user, I want workflows validated and cleaned up after completion so that the repository stays clean and verified.

---

## Acceptance Criteria

- [ ] /ms runs production-check skill if files modified
- [ ] /ms runs repomix-cache-refresh skill after production-check
- [ ] /ms clears workflow-state.json on successful completion
- [ ] /ms preserves state file on validation failure
- [ ] /ms logs validation results
- [ ] Workflow marked as complete in state before clearing

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/ms.md` (update Phase 5 section)
- **Pattern:**
  - Use command-author to modify /ms command
  - Add validation and cleanup logic at workflow end
  - Run post-completion checks
- **Dependencies:**
  - Requires US-021 (Phase 4 execution tracking) complete
  - Runs after workflow execution completes
- **Notes:**
  - Check if files were modified: read workflow-state.json for file changes list
  - If files modified: invoke production-check skill for validation
  - After production-check: invoke repomix-cache-refresh skill to update cache
  - If production-check passes: mark workflow status="complete", clear state file
  - If production-check fails: mark workflow status="error", preserve state file for debugging
  - Clear state file: delete {projectFolder}/workflow-state.json
  - Log validation results: "Validation passed, workflow complete" or "Validation failed, preserved state"
  - Workflow marked complete in state BEFORE clearing (for audit trail)
  - Phase 5 runs automatically at end of successful workflow execution
  - User can skip validation with explicit flag if needed

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
