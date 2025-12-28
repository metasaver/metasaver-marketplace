# US-011: Register Hook in plugin.json

**Epic:** EPIC-002
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-010
**Parallelizable With:** US-013 (testing)
**Priority:** High
**Estimated Size:** Small (5 min)
**PRD Reference:** ../prd.md

---

## User Story

As a plugin developer, I want the UserPromptSubmit hook registered in plugin.json so that Claude Code marketplace loads and executes the hook.

---

## Acceptance Criteria

- [ ] plugin.json updated with hooks registration
- [ ] UserPromptSubmit hook entry added
- [ ] Hook points to correct file path
- [ ] JSON validates correctly (use jq)
- [ ] Hook registration follows marketplace spec

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/.claude-plugin/plugin.json` (update)
- **Pattern:**
  - JSON manifest update (use Read before Edit)
  - Add "hooks" array if it doesn't exist
  - Append UserPromptSubmit hook entry
- **Dependencies:**
  - Requires US-010 (hook handler implementation) complete
  - Hook file must exist before registration
- **Notes:**
  - Hook registration format: `{"event": "onUserPromptSubmit", "handler": "../hooks/user-prompt-submit.js"}`
  - Path is relative to `.claude-plugin/` directory
  - Validate JSON with jq after edit: `cat plugin.json | jq`
  - Check existing hooks array structure before adding
  - Follow marketplace hook registration spec
  - Test hook loads by reloading plugin after registration

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
