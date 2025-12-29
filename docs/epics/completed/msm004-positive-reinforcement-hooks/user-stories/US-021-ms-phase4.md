# US-021: Implement /ms Phase 4 (Execution Tracking)

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-016, US-023
**Parallelizable With:** none (needs state management and execution-phase updates)
**Priority:** High
**Estimated Size:** Medium (15-20 min)
**PRD Reference:** ../prd.md

---

## User Story

As a PM agent, I want execution tracking integrated into /ms workflows so that workflow state persists across HITL stops.

---

## Acceptance Criteria

- [ ] PM updates workflow-state.json at wave start
- [ ] PM sets currentWave and marks stories as inProgress
- [ ] PM updates state when stories complete
- [ ] PM saves HITL questions to state.hitlQuestion field
- [ ] PM sets status to hitl_waiting on HITL stop
- [ ] PM marks workflow complete when all waves done
- [ ] State updates use state-management skill
- [ ] Integration tested with /build workflow

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/ms.md` (update Phase 4 section)
  - `plugins/metasaver-core/skills/workflow-steps/execution-phase.md` (integration points)
- **Pattern:**
  - Use command-author to modify /ms command Phase 4
  - Coordinate with execution-phase skill updates from US-023
  - PM agent calls state-management skill at key milestones
- **Dependencies:**
  - Requires US-016 (state-management skill) complete
  - Requires US-023 (execution-phase updates) complete
  - Both /ms and execution-phase need updates
- **Notes:**
  - PM calls updateWorkflowState at wave start: set currentWave, mark stories inProgress
  - PM calls updateWorkflowState when story completes: move story to completed array
  - PM calls setHITL before HITL stop: save question and resumeAction to state
  - PM calls updateWorkflowState with status="hitl_waiting" on HITL stop
  - PM calls updateWorkflowState with status="complete" when all waves done
  - State updates happen in execution-phase skill (not in /ms command directly)
  - /ms command passes projectFolder to PM agent for state tracking
  - Integration test: run /build workflow, trigger HITL, verify state persists, resume with /ms
  - PM agent is spawned by routed command (/build, /audit, etc.), not by /ms directly

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
