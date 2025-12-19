# US-012: Create Hook Message Templates

**Epic:** EPIC-002
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Parallelizable With:** US-009 (activation logic)
**Priority:** Medium
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a MetaSaver user, I want clear, helpful hook messages with examples so that I understand when and how to use /ms effectively.

---

## Acceptance Criteria

- [ ] Message templates created for different scenarios
- [ ] Templates use positive framing (benefit-focused)
- [ ] Include 2-3 relevant /ms usage examples
- [ ] Reference CLAUDE.md for routing rules
- [ ] Offer "Continue anyway" guidance
- [ ] Tone is friendly and collaborative

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/hooks/message-templates.js` (create)
- **Pattern:**
  - JavaScript module with exported template functions
  - Functions return formatted message strings
  - Import in user-prompt-submit.js hook handler
- **Dependencies:**
  - Can run in parallel with US-009 (activation logic)
  - Used by US-010 (hook handler)
- **Notes:**
  - Export functions: `getComplexWorkMessage()`, `getMultiStepMessage()`, `getBuildTaskMessage()`
  - Messages should include: benefit explanation, 2-3 /ms usage examples, "Continue anyway" note
  - Positive framing: "Using /ms helps track progress" vs "Don't work without /ms"
  - Reference CLAUDE.md routing rules in messages
  - Tone: friendly, collaborative, helpful (not blocking or restrictive)
  - Example format: "This looks like [complex work]. Using /ms helps by: [benefits]. Try: `/ms build feature X`. Or continue directly."
  - Keep messages under 300 characters for readability

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
