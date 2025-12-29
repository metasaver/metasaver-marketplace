# US-004: Update Command-Author with Positive Framing Guidance

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-001
**Parallelizable With:** US-002, US-003
**Priority:** High
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a user of command-author, I want the agent to validate and guide positive framing so that newly created commands use ALWAYS/DO patterns instead of NEVER/DON'T.

---

## Acceptance Criteria

- [ ] command-author prompt updated with positive reinforcement section
- [ ] Section references `/skill positive-framing-patterns`
- [ ] Validation checks for NEVER/DON'T in new command content
- [ ] Suggestions provided when negative framing detected
- [ ] Examples show correct positive framing for command prompts

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/agents/generic/command-author.md` (update)
- **Pattern:**
  - Use command-author to modify itself (self-referential update)
  - Mirror agent-author and skill-author validation patterns
  - Add new section: "Positive Framing Validation"
- **Dependencies:**
  - Requires US-001 (positive-framing-patterns skill) complete
  - Reference: `/skill positive-framing-patterns` in validation logic
- **Notes:**
  - Add validation checkpoint: scan new command content for NEVER/DON'T/DO NOT
  - Suggest transformations when negative framing detected
  - Include 2-3 inline examples of correct positive framing for commands
  - Insert section after existing "Validation" section in command-author.md
  - Commands often have imperative tone - emphasize DO patterns over DON'T

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
