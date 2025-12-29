# US-018: Implement /ms Phase 2a (Resume Workflow)

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-016, US-017
**Parallelizable With:** US-019 (different phase)
**Priority:** High
**Estimated Size:** Medium (15-20 min)
**PRD Reference:** ../prd.md

---

## User Story

As a /ms command user, I want workflows to resume at the correct step after HITL stops so that I can pick up where I left off without repeating work.

---

## Acceptance Criteria

- [ ] /ms reads workflow-state.json using state-management skill
- [ ] Extracts: command, phase, step, wave, status
- [ ] Reads execution-plan.md for context
- [ ] Reads story files to verify current status
- [ ] Routes based on status field:
  - approval_waiting → Present plan, get approval
  - executing → Continue at current wave
  - hitl_waiting → Process user response, continue workflow
- [ ] Passes state context to resumed workflow
- [ ] Validates state file integrity before resume

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/ms.md` (update Phase 2a section)
- **Pattern:**
  - Use command-author to modify /ms command
  - Create new Phase 2a section for workflow resumption
  - Extract context from state and project files
- **Dependencies:**
  - Requires US-016 (state-management skill) complete
  - Requires US-017 (Phase 1 state detection) complete
  - Can run in parallel with US-019 (different phase)
- **Notes:**
  - Read workflow-state.json using state-management skill
  - Extract fields: command, phase, step, currentWave, status
  - Read {projectFolder}/execution-plan.md for context
  - Read story files to verify current status (check Implementation Notes sections)
  - Routing based on status field:
    - "approval_waiting" → Present plan to user, get approval, set status to "executing"
    - "executing" → Continue at currentWave, execute remaining stories
    - "hitl_waiting" → Process user response in prompt, call resumeAction, continue workflow
  - Pass state context to resumed workflow (PM agent needs currentWave, inProgress stories)
  - Validate state file integrity: check required fields, validate wave bounds
  - If state corrupted: log error, fall back to Phase 2b (new workflow)

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
