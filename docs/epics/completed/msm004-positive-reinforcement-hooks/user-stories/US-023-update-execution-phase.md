# US-023: Update execution-phase Skill for State Tracking

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-016
**Parallelizable With:** US-017, US-018, US-019, US-020
**Priority:** High
**Estimated Size:** Medium (15 min)
**PRD Reference:** ../prd.md

---

## User Story

As a PM agent executing workflows, I want state tracking integrated into execution-phase so that workflow progress persists automatically.

---

## Acceptance Criteria

- [ ] execution-phase skill updated to use state-management skill
- [ ] PM calls updateWorkflowState at wave start
- [ ] PM updates story statuses: pending → inProgress → completed
- [ ] PM saves HITL questions to state before stopping
- [ ] PM marks epics as complete when all stories done
- [ ] State updates happen at key milestones
- [ ] Error handling preserves state on failures

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/skills/workflow-steps/execution-phase.md` (update)
- **Pattern:**
  - Use skill-author to modify execution-phase skill
  - Add state-management skill integration at key milestones
  - Preserve existing PM agent workflow logic
- **Dependencies:**
  - Requires US-016 (state-management skill) complete
  - Can run in parallel with US-017, US-018, US-019, US-020
- **Notes:**
  - Insert state updates at milestones:
    - Wave start: `updateWorkflowState(projectFolder, {currentWave: N, status: "executing"})`
    - Story start: `updateWorkflowState(projectFolder, {stories: {inProgress: [...existing, storyId]}})`
    - Story complete: `markStoryComplete(state, storyId)`
    - Epic complete: `updateWorkflowState(projectFolder, {epics: [...updated]})`
    - HITL stop: `setHITL(state, question, resumeAction)` + `status="hitl_waiting"`
  - PM agent needs projectFolder parameter (passed from routed command)
  - Preserve existing error handling, add state save on errors
  - State updates should be non-blocking: if state write fails, log warning but continue
  - PM agent already has wave/story tracking logic - integrate state writes into existing flow
  - Reference state-management skill methods in PM agent prompt

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
