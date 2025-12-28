# US-010: Implement UserPromptSubmit Hook Handler

**Epic:** EPIC-002
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-009
**Parallelizable With:** none (depends on design)
**Priority:** High
**Estimated Size:** Medium (15-20 min)
**PRD Reference:** ../prd.md

---

## User Story

As a MetaSaver user, I want a UserPromptSubmit hook that reminds me about /ms for complex work so that I benefit from workflow tracking without being blocked.

---

## Acceptance Criteria

- [ ] Hook handler file created at `plugins/metasaver-core/hooks/user-prompt-submit.js`
- [ ] Implements activation logic from US-009
- [ ] Uses complexity-check skill for prompt analysis
- [ ] Detects /ms and MetaSaver command prefixes
- [ ] Returns helpful message when triggered
- [ ] Returns null when skip conditions met
- [ ] Hook is non-blocking (blocking: false)

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/hooks/user-prompt-submit.js` (create)
- **Pattern:**
  - JavaScript hook handler module (ES6 syntax)
  - Export function: `onUserPromptSubmit(context)`
  - Return null to skip, return message object to fire
- **Dependencies:**
  - Requires US-009 (hook-activation-spec) for logic definition
  - Uses complexity-check skill for prompt analysis
  - Uses message-templates from US-012 for responses
- **Notes:**
  - Hook API: `context.prompt` contains user input
  - Hook API: `context.invoke_skill('complexity-check', {prompt})` for complexity
  - Implement activation logic from US-009 spec
  - Return format: `{blocking: false, message: "..."}`
  - Non-blocking hook: user can proceed even if hook fires
  - Reference similar hooks in marketplace (if any exist)
  - Import message templates: `const {getComplexWorkMessage} = require('./message-templates')`
  - Error handling: return null on errors (don't block user)

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
