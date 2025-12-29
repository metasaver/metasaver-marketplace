# US-024: Create Migration Guide Documentation

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-017, US-018, US-019, US-020, US-021, US-022
**Parallelizable With:** US-015 (can draft early)
**Priority:** Medium
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a MetaSaver user, I want clear migration guidance so that I understand the changes from old to new /ms behavior.

---

## Acceptance Criteria

- [ ] Migration guide created at `docs/ms-migration-guide.md`
- [ ] Documents old behavior: /ms spawned BA directly, no state tracking
- [ ] Documents new behavior: 5-phase workflow with state persistence
- [ ] Explains workflow resumption benefits
- [ ] Provides before/after examples
- [ ] Lists breaking changes (if any)
- [ ] References ms-command-target-state.md for full details

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `docs/ms-migration-guide.md` (create)
- **Pattern:**
  - User-facing migration documentation
  - Before/after comparison with examples
  - Highlight benefits of new workflow state tracking
- **Dependencies:**
  - Requires US-017, US-018, US-019, US-020, US-021, US-022 complete for accurate documentation
  - Can draft early in parallel with US-015 (workflow-state-schema)
- **Notes:**
  - Section 1: "What Changed" - overview of old vs new /ms behavior
  - Section 2: "Old Behavior" - /ms spawned BA directly, no state tracking, HITL lost context
  - Section 3: "New Behavior" - 5-phase workflow (Entry → Resume/Analyze → Route → Execute → Validate)
  - Section 4: "Workflow Resumption" - explain how /ms detects and resumes active workflows
  - Section 5: "Benefits" - state persistence, seamless HITL resume, progress tracking
  - Section 6: "Examples" - before/after workflow scenarios
  - Section 7: "Breaking Changes" - list any incompatibilities (if any)
  - Section 8: "Migration Steps" - how to adopt new workflow (should be automatic)
  - Link to ms-command-target-state.md for full technical details
  - Link to workflow-state-spec.md for schema reference
  - Tone: user-friendly, benefit-focused, positive framing

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
