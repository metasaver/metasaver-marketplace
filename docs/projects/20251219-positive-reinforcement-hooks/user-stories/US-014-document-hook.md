# US-014: Document Hook Behavior

**Epic:** EPIC-002
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-010, US-013
**Parallelizable With:** US-011
**Priority:** Medium
**Estimated Size:** Small (10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a MetaSaver user, I want clear documentation on how the UserPromptSubmit hook works so that I understand when and why I receive /ms reminders.

---

## Acceptance Criteria

- [ ] Documentation file created at `docs/hooks-usage.md`
- [ ] Explains hook purpose and benefits
- [ ] Lists all activation conditions
- [ ] Lists all skip conditions
- [ ] Provides examples of hook messages
- [ ] Explains how to opt-out if needed
- [ ] References CLAUDE.md for /ms routing rules

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `docs/hooks-usage.md` (create)
- **Pattern:**
  - User-facing documentation (non-technical)
  - Include purpose, benefits, examples, opt-out instructions
  - Link to CLAUDE.md for /ms routing details
- **Dependencies:**
  - Requires US-010 (hook handler) complete
  - Requires US-013 (testing) for verified examples
  - Can run in parallel with US-011
- **Notes:**
  - Section 1: "What is UserPromptSubmit Hook?" - purpose and benefits
  - Section 2: "When Does It Fire?" - list activation conditions (non-technical)
  - Section 3: "When Is It Skipped?" - list skip conditions
  - Section 4: "Example Messages" - 2-3 sample hook messages users might see
  - Section 5: "How to Opt-Out" - explain "ignore /ms" or continue directly
  - Section 6: "Why This Helps" - benefits of /ms workflow tracking
  - Tone: friendly, user-focused, non-technical
  - Link to CLAUDE.md "Always-On Behavior" section for /ms routing rules
  - Link to ms-command-target-state.md for workflow details

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
