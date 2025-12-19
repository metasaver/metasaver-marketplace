# US-015: Define workflow-state.json Schema

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Parallelizable With:** US-024 (migration guide)
**Priority:** High
**Estimated Size:** Medium (15 min)
**PRD Reference:** ../prd.md

---

## User Story

As a PM agent, I want a well-defined workflow-state.json schema so that I can track workflow progress consistently across all commands.

---

## Acceptance Criteria

- [ ] Schema documented matching ms-command-target-state.md section 3
- [ ] Includes all required fields: command, phase, phaseName, step, currentWave, totalWaves, status, lastUpdate
- [ ] Includes epic tracking: array with id, status, storiesCompleted, storiesTotal
- [ ] Includes story tracking: completed, inProgress, pending arrays
- [ ] Includes HITL fields: hitlQuestion, resumeAction
- [ ] Status enum documented: analysis, requirements, design, approval_waiting, executing, hitl_waiting, validating, complete, error
- [ ] Example schema file created

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `docs/projects/20251219-positive-reinforcement-hooks/workflow-state-schema.json` (create example)
  - `docs/workflow-state-spec.md` (create specification)
- **Pattern:**
  - JSON schema definition with example instance
  - Specification document explains each field
  - Used by US-016 state-management skill
- **Dependencies:**
  - Can run in parallel with US-024 (migration guide)
  - No dependencies (foundational schema)
- **Notes:**
  - Required fields: command, phase, phaseName, step, currentWave, totalWaves, status, lastUpdate
  - Epic tracking: `epics: [{id, status, storiesCompleted, storiesTotal}]`
  - Story tracking: `stories: {completed: [], inProgress: [], pending: []}`
  - HITL fields: `hitlQuestion: string`, `resumeAction: string`
  - Status enum: "analysis", "requirements", "design", "approval_waiting", "executing", "hitl_waiting", "validating", "complete", "error"
  - Reference ms-command-target-state.md section 3 for field definitions
  - Example schema should show realistic /build workflow state
  - Spec document should include field-by-field descriptions and valid values

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
