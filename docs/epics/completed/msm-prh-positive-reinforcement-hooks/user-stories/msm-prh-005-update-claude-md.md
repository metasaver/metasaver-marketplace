# US-005: Update CLAUDE.md /ms Routing Section

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-001
**Parallelizable With:** US-002, US-003, US-004, US-006
**Priority:** High
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a developer reading CLAUDE.md, I want clear positive guidance on /ms routing so that I understand when to use /ms without feeling restricted by negative rules.

---

## Acceptance Criteria

- [ ] "NEVER spawn agents directly" replaced with "ALWAYS route complex work through /ms"
- [ ] All routing rules use ALWAYS/DO patterns
- [ ] Examples show WHEN to use /ms (positive framing)
- [ ] Links to ms-command-target-state.md for details
- [ ] Tone is collaborative and instructive

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `CLAUDE.md` (update "Always-On Behavior" section at repo root)
- **Pattern:**
  - Direct file edit (not a plugin component)
  - Transform existing routing rules to positive framing
  - Preserve all routing logic, only change tone
- **Dependencies:**
  - Requires US-001 complete for reference patterns
  - Links to `docs/ms-command-target-state.md` for details
- **Notes:**
  - Replace "NEVER spawn agents directly" with "ALWAYS route complex work through /ms"
  - Transform all NEVER/DON'T rules to ALWAYS/DO patterns
  - Add "Routing:" subsection with WHEN to use /ms (positive framing)
  - Examples: "Simple questions → Answer directly", "Complex work → /ms workflow"
  - Keep table format, update rule column text
  - Tone: collaborative guide, not restriction list

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
