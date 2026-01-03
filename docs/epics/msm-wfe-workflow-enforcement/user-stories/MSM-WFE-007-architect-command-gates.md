---
story_id: "MSM-WFE-007"
title: "Update /architect command with gate calls"
status: "pending"
agent: "core-claude-plugin:generic:command-author"
dependencies: ["MSM-WFE-001", "MSM-WFE-002", "MSM-WFE-003", "MSM-WFE-004"]
---

# Story: Update /architect Command with Validation Gate Calls

## Description

As a workflow system, I need the /architect command to call validation gates after PRD and design phases so that enforcement is mandatory.

## Acceptance Criteria

- [ ] Add gate call after PRD creation (Phase 4)
- [ ] Add gate call after design phase (Phase 7)
- [ ] Add phase requirements check before transitions
- [ ] Follows established command template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/commands/architect.md`

**Implementation:**

Add enforcement sections:

```markdown
## Phase 4: After PRD Review

**Enforcement gate:**

1. Reviewer validates PRD structure
2. On FAIL: Return to EA agent with violations
3. On PASS: Continue to Innovation Decision

## Phase 7: After Design

**Enforcement gate:**

1. Verify stories and execution plan exist
2. Spawn reviewer for design artifacts validation
3. On FAIL: Loop to design phase
4. On PASS: Continue to HITL (Phase 8)
```
