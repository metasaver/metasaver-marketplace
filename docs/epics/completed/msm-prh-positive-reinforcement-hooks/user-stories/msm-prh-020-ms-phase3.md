# US-020: Implement /ms Phase 3 (Route to Command)

**Epic:** EPIC-003
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** US-019
**Parallelizable With:** none (needs Phase 2b results)
**Priority:** High
**Estimated Size:** Medium (15 min)
**PRD Reference:** ../prd.md

---

## User Story

As a /ms command user, I want intelligent routing to the right command so that my work follows the optimal workflow automatically.

---

## Acceptance Criteria

- [ ] Routing decision tree implemented per target diagram
- [ ] Route to /qq: complexity < 15 AND question only
- [ ] Route to /audit: keywords "audit/validate/check" + config files in scope
- [ ] Route to /debug: keywords "debug/browser/UI test"
- [ ] Route to /architect: vague requirements, keywords "plan/explore/design"
- [ ] Route to /build: clear requirements, keywords "build/implement/add/fix"
- [ ] Passes analysis results to target command
- [ ] Logs routing decision for debugging

---

## Architecture Notes

> Added by Architect after PRD approval

- **Files:**
  - `plugins/metasaver-core/commands/ms.md` (update Phase 3 section)
- **Pattern:**
  - Use command-author to modify /ms command
  - Implement decision tree from ms-command-target-state.md diagram
  - Route to appropriate command based on analysis
- **Dependencies:**
  - Requires US-019 (Phase 2b analysis) complete
  - Needs analysis results from complexity-check, scope-check, tool-check
- **Notes:**
  - Routing decision tree (in order):
    1. If complexity < 15 AND scope="question" → route to /qq
    2. If keywords match "audit|validate|check" AND config files in scope → route to /audit
    3. If keywords match "debug|browser|UI test" → route to /debug
    4. If keywords match "plan|explore|design" OR vague requirements → route to /architect
    5. If keywords match "build|implement|add|fix" AND clear requirements → route to /build
    6. Default fallback: route to /architect (for ambiguous cases)
  - Pass analysis results to target command: complexity score, scope, tools list
  - Log routing decision: "Routing to /{command} based on: {reason}"
  - Keywords detection: case-insensitive regex match on prompt
  - This is existing Phase 3 logic - update routing rules to match target state

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
