# US-002: Update Agent-Author with Positive Framing Guidance

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-001
**Parallelizable With:** US-003, US-004
**Priority:** High
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a user of agent-author, I want the agent to validate and guide positive framing so that newly created agents use ALWAYS/DO patterns instead of NEVER/DON'T.

---

## Acceptance Criteria

- [ ] agent-author prompt updated with positive reinforcement section
- [ ] Section references `/skill positive-framing-patterns`
- [ ] Validation checks for NEVER/DON'T in new agent content
- [ ] Suggestions provided when negative framing detected
- [ ] Examples show correct positive framing for agent prompts

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/agents/generic/agent-author.md` (update)
- **Pattern:**
  - Use agent-author to modify itself (self-referential update)
  - Base validation logic on existing agent-author validation sections
  - Add new section: "Positive Framing Validation"
- **Dependencies:**
  - Requires US-001 (positive-framing-patterns skill) complete
  - Reference: `/skill positive-framing-patterns` in validation logic
- **Notes:**
  - Add validation checkpoint: scan new agent content for NEVER/DON'T/DO NOT
  - Suggest transformations when negative framing detected
  - Include 2-3 inline examples of correct positive framing for agents
  - Insert section after existing "Validation" section in agent-author.md

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
