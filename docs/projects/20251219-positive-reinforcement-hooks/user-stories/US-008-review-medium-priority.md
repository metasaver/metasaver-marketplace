# US-008: Review Medium-Priority Files for Positive Framing

**Epic:** EPIC-001
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-001, US-006, US-007
**Parallelizable With:** none (sequential after high-priority)
**Priority:** Medium
**Estimated Size:** Large (break down by file type - this is a placeholder)
**PRD Reference:** ../prd.md

---

## User Story

As a developer maintaining MetaSaver, I want medium-priority files (skills and config agents) reviewed for positive framing so that all plugin content maintains consistent tone.

---

## Acceptance Criteria

- [ ] All medium-priority files from checklist reviewed
- [ ] NEVER/DON'T statements transformed to ALWAYS/DO
- [ ] Changes use positive framing patterns from US-001
- [ ] Appropriate author agent used for each file type
- [ ] Changes verified for tone and clarity

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/skills/**/*.md` (all skill files)
  - `plugins/metasaver-core/agents/config/**/*.md` (config agent files)
- **Pattern:**
  - LARGE STORY - PM should break down by file in execution plan
  - Use skill-author for skills, agent-author for config agents
  - Batch files by subdomain for parallel review
- **Dependencies:**
  - Requires US-001 (positive-framing-patterns) for transformation guidance
  - Requires US-006 (file-audit-checklist) for file list
  - Requires US-007 complete (sequential after high-priority)
- **Notes:**
  - Read checklist from US-006 to get medium-priority file list
  - For each file: scan for NEVER/DON'T/DO NOT → apply transformations → verify tone
  - Use positive-framing-patterns skill for transformation guidance
  - Skills priority: workflow-steps (execution-phase, planning-phase) then cross-cutting
  - Config agents: eslint-agent, vite-agent, prettier-agent, etc.
  - Track completion checkboxes in US-006 checklist as files are reviewed
  - Lower urgency than US-007 but same quality standards

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
