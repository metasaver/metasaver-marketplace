---
story_id: "MSM-WFE-006"
title: "Update /build command with gate calls"
status: "pending"
agent: "core-claude-plugin:generic:command-author"
dependencies: ["MSM-WFE-001", "MSM-WFE-002", "MSM-WFE-003", "MSM-WFE-004"]
---

# Story: Update /build Command with Validation Gate Calls

## Description

As a workflow system, I need the /build command to call validation gates at each phase transition so that enforcement is mandatory.

## Acceptance Criteria

- [ ] Add gate call after PRD creation phase
- [ ] Add gate call after execution plan phase
- [ ] Add gate call after story creation phase
- [ ] Add phase requirements check before each transition
- [ ] Follows established command template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/commands/build.md`

**Implementation:**

Add enforcement sections at each phase:

```markdown
## Phase 3: After PRD Creation

**Enforcement gate:**

1. Call `checkPhaseRequirements(3)` - verify prd.md exists
2. Spawn reviewer for PRD validation
3. On FAIL: Loop to requirements phase
4. On PASS: Continue to Phase 4

## Phase 5: After Execution Plan

**Enforcement gate:**

1. Call `checkPhaseRequirements(5)` - verify execution-plan.md exists
2. Spawn reviewer for plan validation
3. On FAIL: Loop to planning phase
4. On PASS: Continue to Phase 6

## Phase 6: After Story Creation

**Enforcement gate:**

1. Call `checkPhaseRequirements(6)` - verify user-stories/ populated
2. Spawn reviewer for stories validation
3. On FAIL: Loop to story phase
4. On PASS: Continue to HITL
```
