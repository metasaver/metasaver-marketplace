# PRD: Tool-Check Cleanup & Standards-Audit Creation

**Epic:** MSM007
**Complexity:** 12
**Date:** 2025-12-28
**Status:** Ready for execution

---

## Executive Summary

Complete the remaining work from MSM003 (Command Skill Restructure). The original epic was ~85% completed through subsequent work (MSM004-006). This focused epic addresses the 4 remaining items:

1. Delete `tool-check` skill
2. Delete `tool-check-agent`
3. Remove all tool-check references from commands/skills
4. Create `standards-audit` skill

---

## Background

MSM003 proposed removing `tool-check` because it wasn't providing value - commands don't need to know MCP tools upfront. This was deprioritized while more critical workflow fixes (MSM004-006) were completed. Now it's time to finish the cleanup.

---

## User Stories

### US-001: Delete tool-check skill

**Target:** `plugins/metasaver-core/skills/cross-cutting/tool-check/SKILL.md`
**Action:** Delete entire directory

**Acceptance Criteria:**

- [ ] Directory `skills/cross-cutting/tool-check/` deleted
- [ ] No remaining tool-check skill files

---

### US-002: Delete tool-check-agent

**Target:** `plugins/metasaver-core/agents/generic/tool-check-agent.md`
**Action:** Delete file

**Acceptance Criteria:**

- [ ] File `agents/generic/tool-check-agent.md` deleted

---

### US-003: Remove tool-check references

**Targets:** Commands and skills that reference tool-check
**Action:** Remove spawning/invocation of tool-check

**Files to check:**

- `commands/ms.md` - Phase 2b Analysis
- `commands/build.md` - Analysis phase
- `skills/workflow-steps/analysis-phase/SKILL.md`

**Acceptance Criteria:**

- [ ] No references to `tool-check` in any command
- [ ] No references to `tool-check-agent` in any command
- [ ] Analysis phase only spawns: complexity-check, scope-check (not tool-check)

---

### US-004: Create standards-audit skill

**Target:** `plugins/metasaver-core/skills/workflow-steps/standards-audit/SKILL.md`
**Action:** Create new skill

**Purpose:** Post-execution validation that runs config agents + structure check + DRY check

**Content:**

- Spawn config agents to validate generated code
- Run structure-check to verify file locations
- Run dry-check to verify no duplication with multi-mono
- Return validation results

**Used by:** `/ms`, `/build` (NOT `/audit` - audit has its own investigation/remediation)

**Acceptance Criteria:**

- [ ] Skill file created with proper frontmatter
- [ ] Purpose and workflow documented
- [ ] Integration notes for /ms and /build
- [ ] References config agents, structure-check, dry-check

---

## Execution Plan

**Wave 1: Deletions (parallel)**

- US-001: Delete tool-check skill (direct file operation)
- US-002: Delete tool-check-agent (direct file operation)

**Wave 2: References cleanup**

- US-003: Remove tool-check references from commands/skills (skill-author/command-author)

**Wave 3: Creation**

- US-004: Create standards-audit skill (skill-author)

---

## Files Summary

| Action | File                                                        | Author         |
| ------ | ----------------------------------------------------------- | -------------- |
| DELETE | `skills/cross-cutting/tool-check/SKILL.md`                  | Direct         |
| DELETE | `agents/generic/tool-check-agent.md`                        | Direct         |
| UPDATE | `commands/ms.md` (if needed)                                | command-author |
| UPDATE | `skills/workflow-steps/analysis-phase/SKILL.md` (if needed) | skill-author   |
| CREATE | `skills/workflow-steps/standards-audit/SKILL.md`            | skill-author   |

---

## Success Criteria

- [ ] No `tool-check` files exist
- [ ] No `tool-check` references exist
- [ ] `standards-audit` skill exists and is documented
- [ ] MSM003 can be marked as superseded/complete
