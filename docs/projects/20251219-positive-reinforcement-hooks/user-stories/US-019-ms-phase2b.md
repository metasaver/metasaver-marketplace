# US-019: Implement /ms Phase 2b (New Workflow Analysis)

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-017
**Parallelizable With:** US-018 (different phase)
**Priority:** High
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a /ms command user, I want new workflows analyzed efficiently so that the command can route me to the right workflow quickly.

---

## Acceptance Criteria

- [ ] /ms spawns 3 skills in parallel: complexity-check, scope-check, tool-check
- [ ] Collects all 3 results
- [ ] Passes results to Phase 3 for routing decision
- [ ] Handles skill errors gracefully
- [ ] Logs analysis results for debugging

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/ms.md` (update Phase 2b section)
- **Pattern:**
  - Use command-author to modify /ms command
  - Update existing Phase 2b to spawn 3 skills in parallel
  - Collect results for Phase 3 routing
- **Dependencies:**
  - Requires US-017 (Phase 1 state detection) complete
  - Can run in parallel with US-018 (different phase)
- **Notes:**
  - Spawn 3 skills in parallel: complexity-check, scope-check, tool-check
  - Use skill invocation API to run concurrently (not sequentially)
  - Collect all 3 results before proceeding to Phase 3
  - Handle skill errors gracefully: if skill fails, use defaults (complexity=50, scope="unknown", tools=[])
  - Pass analysis results to Phase 3 for routing decision
  - Log analysis results for debugging: "Analysis complete: complexity={score}, scope={type}, tools={list}"
  - This is existing Phase 2b logic - minimal changes needed
  - Results structure: `{complexity: number, scope: string, tools: string[]}`

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
