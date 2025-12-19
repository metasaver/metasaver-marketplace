# EPIC-001: Positive Reinforcement Refactoring

**Status:** 🔵 Pending
**Priority:** High
**Stories:** 8 stories
**PRD Reference:** ../prd.md

---

## Description

Transform MetaSaver plugin to use positive reinforcement patterns throughout all documentation and prompts. Replace 59 files containing NEVER/DON'T/DO NOT statements with ALWAYS/DO patterns. Update author agents with positive framing guidance to ensure future content maintains collaborative, instructive tone.

This epic addresses the adversarial tone problem by shifting from prohibition ("don't do X") to instruction ("always do Y"), improving developer experience and reducing cognitive friction.

---

## Stories in this Epic

| Story  | Title                                   | Status     | Assignee   |
| ------ | --------------------------------------- | ---------- | ---------- |
| US-001 | Create positive framing pattern library | 🔵 Pending | unassigned |
| US-002 | Update agent-author with guidance       | 🔵 Pending | unassigned |
| US-003 | Update skill-author with guidance       | 🔵 Pending | unassigned |
| US-004 | Update command-author with guidance     | 🔵 Pending | unassigned |
| US-005 | Update CLAUDE.md /ms routing section    | 🔵 Pending | unassigned |
| US-006 | Create file audit checklist             | 🔵 Pending | unassigned |
| US-007 | Review high-priority files              | 🔵 Pending | unassigned |
| US-008 | Review medium-priority files            | 🔵 Pending | unassigned |

---

## Acceptance Criteria (Epic-Level)

- [ ] Positive framing pattern library created with 20+ examples
- [ ] All 3 author agents updated with positive reinforcement guidance
- [ ] CLAUDE.md uses ALWAYS/DO patterns for /ms routing rules
- [ ] All 59 files audited and categorized for refactoring
- [ ] High-priority files (commands, core agents) reviewed
- [ ] Author agents validate new content for negative framing

---

## Architecture Notes

> Added by Architect after PRD approval

- **Domain:** Cross-cutting - affects agents, skills, commands, documentation
- **Key Files:**
  - plugins/metasaver-core/agents/generic/agent-author.md
  - plugins/metasaver-core/agents/generic/skill-author.md
  - plugins/metasaver-core/agents/generic/command-author.md
  - CLAUDE.md
  - New skill: plugins/metasaver-core/skills/cross-cutting/positive-framing-patterns.md
- **Dependencies:** None (foundational epic)
- **Pattern:** Use skill-author agent to create pattern library, then use respective author agents for updates

---

## Completion

> Updated by PM when epic is complete

**Completed:** (not complete)
**Stories Completed:** 0/8
**Verified:** no
