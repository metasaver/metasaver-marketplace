# EPIC-002: Hook Enforcement System

**Status:** 🔵 Pending
**Priority:** High
**Stories:** 6 stories
**PRD Reference:** ../prd.md

---

## Description

Implement UserPromptSubmit hook workaround to remind users about /ms workflow routing. Since PreToolUse hooks are broken (GitHub issue #6305), use UserPromptSubmit as detection mechanism. Hook provides helpful guidance when complex work is detected without /ms prefix, but remains non-blocking to preserve user agency.

This epic establishes enforcement guardrails that guide users toward best practices without creating friction or blocking legitimate direct interactions.

---

## Stories in this Epic

| Story  | Title                              | Status     | Assignee   |
| ------ | ---------------------------------- | ---------- | ---------- |
| US-009 | Design hook activation logic       | 🔵 Pending | unassigned |
| US-010 | Implement UserPromptSubmit handler | 🔵 Pending | unassigned |
| US-011 | Register hook in plugin.json       | 🔵 Pending | unassigned |
| US-012 | Create hook message templates      | 🔵 Pending | unassigned |
| US-013 | Add hook testing scenarios         | 🔵 Pending | unassigned |
| US-014 | Document hook behavior             | 🔵 Pending | unassigned |

---

## Acceptance Criteria (Epic-Level)

- [ ] Hook fires on complex prompts without /ms prefix
- [ ] Hook skips on /ms commands and MetaSaver commands
- [ ] Hook skips on simple questions (complexity < 10)
- [ ] Hook message is helpful and provides examples
- [ ] Hook is non-blocking (user can continue anyway)
- [ ] Hook registered in plugin.json correctly
- [ ] Hook behavior documented with examples

---

## Architecture Notes

> Added by Architect after PRD approval

- **Domain:** Plugin infrastructure (hooks system)
- **Key Files:**
  - plugins/metasaver-core/hooks/user-prompt-submit.js (create)
  - plugins/metasaver-core/.claude-plugin/plugin.json (update)
  - docs/hooks-usage.md (create documentation)
- **Dependencies:**
  - Existing complexity-check skill (for estimating prompt complexity)
  - CLAUDE.md (reference for /ms routing rules)
- **Pattern:** Follow Claude Code marketplace hook registration pattern, use command-author for documentation updates

---

## Completion

> Updated by PM when epic is complete

**Completed:** (not complete)
**Stories Completed:** 0/6
**Verified:** no
