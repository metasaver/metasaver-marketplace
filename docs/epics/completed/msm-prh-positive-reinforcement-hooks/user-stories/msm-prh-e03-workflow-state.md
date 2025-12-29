# EPIC-003: Workflow State & /ms Updates

**Status:** 🔵 Pending
**Priority:** High
**Stories:** 10 stories
**PRD Reference:** ../prd.md

---

## Description

Update /ms command to match target state architecture diagram with full workflow resumption support. Implement workflow-state.json management for PM to track execution progress across HITL stops. Add all 5 phases from target diagram: Entry + State Check, Resume/New Workflow, Routing, Execution Tracking, and Validation.

This epic transforms /ms from simple BA spawner into intelligent workflow orchestrator with full state persistence and resumption capabilities.

---

## Stories in this Epic

| Story  | Title                                 | Status     | Assignee   |
| ------ | ------------------------------------- | ---------- | ---------- |
| US-015 | Define workflow-state.json schema     | 🔵 Pending | unassigned |
| US-016 | Create PM state management skill      | 🔵 Pending | unassigned |
| US-017 | Implement /ms Phase 1 (State Check)   | 🔵 Pending | unassigned |
| US-018 | Implement /ms Phase 2a (Resume)       | 🔵 Pending | unassigned |
| US-019 | Implement /ms Phase 2b (New Analysis) | 🔵 Pending | unassigned |
| US-020 | Implement /ms Phase 3 (Routing)       | 🔵 Pending | unassigned |
| US-021 | Implement /ms Phase 4 (Exec Tracking) | 🔵 Pending | unassigned |
| US-022 | Implement /ms Phase 5 (Validation)    | 🔵 Pending | unassigned |
| US-023 | Update execution-phase skill          | 🔵 Pending | unassigned |
| US-024 | Create migration guide documentation  | 🔵 Pending | unassigned |

---

## Acceptance Criteria (Epic-Level)

- [ ] workflow-state.json schema matches target diagram section 3
- [ ] PM can read/write/update state files via skill
- [ ] /ms Phase 1 detects active workflows correctly
- [ ] /ms Phase 2a resumes workflows at correct step
- [ ] /ms Phase 2b runs parallel analysis skills
- [ ] /ms Phase 3 routes to correct commands
- [ ] /ms Phase 4 updates state during execution
- [ ] /ms Phase 5 runs validation and clears state
- [ ] Execution-phase skill integrates state tracking
- [ ] Migration guide covers old vs new /ms behavior

---

## Architecture Notes

> Added by Architect after PRD approval

- **Domain:** Command infrastructure + PM workflow
- **Key Files:**
  - plugins/metasaver-core/commands/ms.md (major update)
  - plugins/metasaver-core/skills/workflow-steps/state-management.md (create)
  - plugins/metasaver-core/skills/workflow-steps/execution-phase.md (update)
  - docs/ms-migration-guide.md (create)
- **Dependencies:**
  - US-015 must complete before US-016-023 (schema defines structure)
  - US-016 must complete before US-017-022 (state management used by all phases)
  - US-021 depends on US-023 (execution tracking integration)
- **Pattern:** Use command-author for /ms updates, skill-author for new/updated skills

---

## Completion

> Updated by PM when epic is complete

**Completed:** (not complete)
**Stories Completed:** 0/10
**Verified:** no
