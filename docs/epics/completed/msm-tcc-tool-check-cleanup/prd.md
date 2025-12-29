# PRD: Tool-Check Cleanup

**Epic:** MSM007
**Complexity:** 8
**Date:** 2025-12-28
**Status:** COMPLETE

---

## Executive Summary

Complete the remaining work from MSM003 (Command Skill Restructure). The original epic was ~85% completed through subsequent work (MSM004-006). This focused epic addresses the 3 remaining items:

1. Delete `tool-check` skill
2. Delete `tool-check-agent`
3. Remove all tool-check references from commands/skills

**Note:** US-004 (standards-audit skill) was dropped - the inline implementation in `/build` Phase 7 is sufficient.

---

## Background

MSM003 proposed removing `tool-check` because it wasn't providing value - commands don't need to know MCP tools upfront. This was deprioritized while more critical workflow fixes (MSM004-006) were completed. Now it's time to finish the cleanup.

---

## User Stories

### US-001: Delete tool-check skill

**Target:** `plugins/metasaver-core/skills/cross-cutting/tool-check/SKILL.md`
**Action:** Delete entire directory

**Acceptance Criteria:**

- [x] Directory `skills/cross-cutting/tool-check/` deleted
- [x] No remaining tool-check skill files

---

### US-002: Delete tool-check-agent

**Target:** `plugins/metasaver-core/agents/generic/tool-check-agent.md`
**Action:** Delete file

**Acceptance Criteria:**

- [x] File `agents/generic/tool-check-agent.md` deleted

---

### US-003: Remove tool-check references

**Targets:** Commands and skills that reference tool-check
**Action:** Remove spawning/invocation of tool-check

**Files checked:**

- `commands/ms.md` - Clean
- `commands/build.md` - Clean
- `skills/workflow-steps/analysis-phase/SKILL.md` - Clean
- `CLAUDE.md` - Updated (example code block)

**Acceptance Criteria:**

- [x] No references to `tool-check` in any command
- [x] No references to `tool-check-agent` in any command
- [x] Analysis phase only spawns: scope-check (not tool-check)
- [x] CLAUDE.md example updated

---

## Execution Plan

**Wave 1: Deletions (parallel)** - COMPLETE

- US-001: Delete tool-check skill (direct file operation)
- US-002: Delete tool-check-agent (direct file operation)

**Wave 2: References cleanup** - COMPLETE

- US-003: Remove tool-check references from commands/skills

---

## Files Summary

| Action | File                                            | Status  |
| ------ | ----------------------------------------------- | ------- |
| DELETE | `skills/cross-cutting/tool-check/SKILL.md`      | Done    |
| DELETE | `agents/generic/tool-check-agent.md`            | Done    |
| UPDATE | `commands/ms.md`                                | Clean   |
| UPDATE | `commands/build.md`                             | Clean   |
| UPDATE | `skills/workflow-steps/analysis-phase/SKILL.md` | Clean   |
| UPDATE | `CLAUDE.md`                                     | Updated |

---

## Success Criteria

- [x] No `tool-check` files exist
- [x] No `tool-check` references exist in operational files
- [x] MSM003 can be marked as superseded/complete

---

## Completion Notes

**Completed:** 2025-12-29

US-004 (standards-audit skill) was intentionally dropped. The `/build` command Phase 7 already implements this functionality inline by calling `structure-check`, `dry-check`, and `config-audit` in parallel. Creating a wrapper skill would add indirection without value.
