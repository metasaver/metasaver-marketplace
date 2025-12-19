# US-007: Review High-Priority Files for Positive Framing

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-001, US-006
**Parallelizable With:** none (sequential after checklist)
**Priority:** High
**Estimated Size:** Large (break down by file type - this is a placeholder)
**PRD Reference:** ../prd.md

---

## User Story

As a developer maintaining MetaSaver, I want high-priority files (commands and core agents) reviewed for positive framing so that the most visible content sets the right tone.

---

## Acceptance Criteria

- [ ] All high-priority files from checklist reviewed
- [ ] NEVER/DON'T statements transformed to ALWAYS/DO
- [ ] Changes use positive framing patterns from US-001
- [ ] Appropriate author agent used for each file type
- [ ] Changes verified for tone and clarity

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/*.md` (multiple command files)
  - `plugins/metasaver-core/agents/generic/*.md` (core agent files)
- **Pattern:**
  - LARGE STORY - PM should break down by file in execution plan
  - Use appropriate author agent per file type: command-author for commands, agent-author for agents
  - Batch files by type for parallel review
- **Dependencies:**
  - Requires US-001 (positive-framing-patterns) for transformation guidance
  - Requires US-006 (file-audit-checklist) for file list
  - Sequential after checklist creation
- **Notes:**
  - Read checklist from US-006 to get high-priority file list
  - For each file: scan for NEVER/DON'T/DO NOT → apply transformations → verify tone
  - Use positive-framing-patterns skill for transformation guidance
  - Commands priority: /ms, /build, /audit, /debug (most user-facing)
  - Agent priority: agent-author, skill-author, command-author, architect, coder
  - Track completion checkboxes in US-006 checklist as files are reviewed

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
