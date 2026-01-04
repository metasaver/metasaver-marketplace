---
story_id: "MSM-WFE-002"
title: "Add mandatory reviewer gate after execution plan"
status: "pending"
agent: "core-claude-plugin:generic:skill-author"
dependencies: []
---

# Story: Add Mandatory Reviewer Gate After Execution Plan

## Description

As a workflow system, I need to enforce reviewer validation after execution plan creation so that invalid plans cannot proceed to story creation.

## Acceptance Criteria

- [ ] Modify `execution-plan-creation` skill to spawn reviewer after plan write
- [ ] Reviewer returns `{result: "PASS"|"FAIL", issues: []}`
- [ ] On FAIL: Loop back to project-manager with issues
- [ ] On PASS: Allow phase transition
- [ ] Follows established skill template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/skills/workflow-steps/execution-plan-creation/SKILL.md`

**Implementation:**

Add section after plan write:

```markdown
## Validation Gate

After execution plan is written, spawn reviewer:

**Spawn:** `core-claude-plugin:generic:reviewer`
**Input:** Plan path, validation type "execution-plan"
**Output:** `{result: "PASS"|"FAIL", issues: []}`

On FAIL: Return issues to project-manager, retry plan creation
On PASS: Continue to next phase
```
