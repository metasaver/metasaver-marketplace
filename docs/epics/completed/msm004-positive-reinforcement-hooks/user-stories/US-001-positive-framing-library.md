# US-001: Create Positive Framing Pattern Library

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Parallelizable With:** US-002, US-003, US-004, US-005, US-006
**Priority:** High
**Estimated Size:** Medium (15-20 min)
**PRD Reference:** ../prd.md

---

## User Story

As a plugin author, I want a pattern library for positive framing so that I can transform NEVER/DON'T statements into ALWAYS/DO patterns consistently.

---

## Acceptance Criteria

- [ ] Skill file created at `plugins/metasaver-core/skills/cross-cutting/positive-framing-patterns.md`
- [ ] Contains 20+ before/after transformation examples
- [ ] Includes decision tree for choosing imperative vs. suggestive tone
- [ ] References cognitive psychology research on positive framing
- [ ] Provides categories: commands, prohibitions, warnings, recommendations
- [ ] Examples cover plugin content: agents, skills, commands, documentation

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/skills/cross-cutting/positive-framing-patterns.md` (create)
- **Pattern:**
  - Use skill-author agent to create skill file
  - Include frontmatter: name, description
  - Structure: Introduction → Categories → Decision Tree → Psychology References → Examples
- **Dependencies:**
  - Must be registered in `.claude-plugin/marketplace.json` skills array
  - Path: `./skills/cross-cutting/positive-framing-patterns`
- **Notes:**
  - Categorize by context: commands, prohibitions, warnings, recommendations
  - Include 20+ before/after transformation examples
  - Reference similar pattern: `plugins/metasaver-core/skills/cross-cutting/` existing skills for format
  - Decision tree should guide tone selection (imperative vs. suggestive)

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
