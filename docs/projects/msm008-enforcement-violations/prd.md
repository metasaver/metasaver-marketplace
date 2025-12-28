# PRD: AskUserQuestion Enforcement

**Project:** msm008-enforcement-violations
**Date:** 2025-12-28
**Stories:** 3

---

## Problem

Agent bypassed /ms workflow enforcement:

1. Used plain text questions instead of AskUserQuestion tool
2. Skipped Phase 2b Analysis
3. Self-routed instead of formal routing

**Root cause:** CLAUDE.md says "answer directly" for simple questions, creating an escape hatch.

---

## Solution (Minimal)

3 changes to close the escape hatch:

| Story  | Change                                  | Impact                    |
| ------ | --------------------------------------- | ------------------------- |
| US-001 | Remove "answer directly" from CLAUDE.md | Closes the escape hatch   |
| US-002 | Make Phase 2b analysis mandatory in /ms | Prevents analysis skip    |
| US-003 | Add AskUserQuestion enforcement to /ms  | Explicit tool requirement |

---

## User Stories

### US-001: Update CLAUDE.md

**Agent:** manual-edit (CLAUDE.md is not a plugin component)

Remove "Simple questions -> Answer directly without workflow" from:

- Always-On Behavior table
- Routing Guidance section

Add:

- "All interactions -> Route through /ms"
- "Questions to user -> Always use AskUserQuestion tool"

**File:** `CLAUDE.md`

---

### US-002: Make Phase 2b Mandatory

**Agent:** command-author

Remove any complexity-based bypass conditions in Phase 2b. Analysis phase runs for ALL new workflows.

**File:** `plugins/metasaver-core/commands/ms.md`

---

### US-003: Add AskUserQuestion Enforcement

**Agent:** command-author

Add to /ms Enforcement section:

```
1. Use AskUserQuestion tool for every question to the user. Present structured options with clear descriptions.
```

**File:** `plugins/metasaver-core/commands/ms.md`

---

## Execution

**Wave 1 (Sequential):**

- US-001: CLAUDE.md update (manual)

**Wave 2 (Parallel):**

- US-002: /ms Phase 2b mandatory (command-author)
- US-003: /ms enforcement (command-author)

**Duration:** ~10 minutes

---

## Why This Works

- /ms is the universal entry point - all other commands route through it
- Enforcement at /ms propagates to routed commands (/build, /audit, /architect, /debug, /qq)
- No hooks needed - prompt engineering is sufficient

---

## Out of Scope (Deferred)

- Hook-based enforcement (can't block, only remind)
- Other command updates (inherit from /ms)
- Sync scripts (only needed if hooks deployed)

If violations persist after this fix, revisit with hooks.

---

## Approval

Run `/build docs/projects/msm008-enforcement-violations/prd.md` to execute.
