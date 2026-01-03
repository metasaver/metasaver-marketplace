---
story_id: "MSM-WFE-004"
title: "Add checkPhaseRequirements to state-management"
status: "pending"
agent: "core-claude-plugin:generic:skill-author"
dependencies: []
---

# Story: Add Phase Requirements Check to State Management

## Description

As a workflow system, I need to verify required artifacts exist before phase transitions so that phases cannot be skipped.

## Acceptance Criteria

- [ ] Add `checkPhaseRequirements(phase)` section to state-management skill
- [ ] Phase 3 requires: prd.md exists
- [ ] Phase 5 requires: execution-plan.md exists
- [ ] Phase 6 requires: user-stories/ populated
- [ ] Return error if requirements not met
- [ ] Follows established skill template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/skills/cross-cutting/state-management/SKILL.md`

**Implementation:**

Add section:

```markdown
## Phase Requirements Check

Before advancing phase, verify artifacts exist:

| Phase | Required Artifacts              |
| ----- | ------------------------------- |
| 3     | prd.md exists in project folder |
| 5     | execution-plan.md exists        |
| 6     | user-stories/ folder has files  |

**Check process:**

1. Read target phase from workflow-state.json
2. Verify required artifacts exist using Glob
3. If missing: Return error with specific missing artifact
4. If present: Allow phase transition
```
