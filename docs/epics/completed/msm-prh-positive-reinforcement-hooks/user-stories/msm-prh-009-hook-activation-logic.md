# US-009: Design Hook Activation Logic

**Epic:** EPIC-002
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Parallelizable With:** US-012 (message templates)
**Priority:** High
**Estimated Size:** Medium (15 min)
**PRD Reference:** ../prd.md

---

## User Story

As a MetaSaver architect, I want clear activation logic for the UserPromptSubmit hook so that it fires only when appropriate and provides value without annoyance.

---

## Acceptance Criteria

- [ ] Detection rules defined for when hook should fire
- [ ] Skip conditions documented: already using /ms, simple question, explicit opt-out
- [ ] Complexity threshold defined (< 10 = simple, skip hook)
- [ ] Command prefix detection logic specified
- [ ] Design documented in technical spec

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `docs/projects/20251219-positive-reinforcement-hooks/hook-activation-spec.md` (create)
- **Pattern:**
  - Design specification document (not implementation)
  - Define logic rules BEFORE implementation in US-010
  - Include decision flowchart (markdown diagram or pseudocode)
- **Dependencies:**
  - None (can run in parallel with US-012 message templates)
- **Notes:**
  - Detection rules: complexity-check score >= 15 for complex prompts
  - Skip conditions: prompt starts with /ms, /build, /audit, /debug, /qq, /architect
  - Skip conditions: prompt contains "ignore /ms" or "skip workflow"
  - Skip conditions: complexity < 10 (simple questions)
  - Complexity threshold: Use complexity-check skill, score 0-100
  - Command prefix detection: regex match for /[a-z]+
  - Spec should include 5-10 example prompts with expected fire/skip decisions
  - Format: Markdown with "Decision Logic", "Skip Conditions", "Examples" sections

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
