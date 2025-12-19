# US-003: Update Skill-Author with Positive Framing Guidance

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-001
**Parallelizable With:** US-002, US-004
**Priority:** High
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a user of skill-author, I want the agent to validate and guide positive framing so that newly created skills use ALWAYS/DO patterns instead of NEVER/DON'T.

---

## Acceptance Criteria

- [ ] skill-author prompt updated with positive reinforcement section
- [ ] Section references `/skill positive-framing-patterns`
- [ ] Validation checks for NEVER/DON'T in new skill content
- [ ] Suggestions provided when negative framing detected
- [ ] Examples show correct positive framing for skill prompts

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/agents/generic/skill-author.md` (update)
- **Pattern:**
  - Use skill-author to modify skill-author (self-update)
  - Mirror agent-author validation pattern from US-002
  - Add new section: "Positive Framing Validation"
- **Dependencies:**
  - Requires US-001 (positive-framing-patterns skill) complete
  - Reference: `/skill positive-framing-patterns` in validation logic
- **Notes:**
  - Add validation checkpoint: scan new skill content for NEVER/DON'T/DO NOT
  - Suggest transformations when negative framing detected
  - Include 2-3 inline examples of correct positive framing for skills
  - Insert section after existing "Validation" section in skill-author.md
  - Same pattern as US-002 but applied to skill context

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
