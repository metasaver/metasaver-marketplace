---
story_id: "MSM-WFE-001"
title: "Add mandatory reviewer gate after PRD creation"
status: "pending"
agent: "core-claude-plugin:generic:skill-author"
dependencies: []
---

# Story: Add Mandatory Reviewer Gate After PRD Creation

## Description

As a workflow system, I need to enforce reviewer validation after PRD creation so that invalid PRDs cannot proceed to the design phase.

## Acceptance Criteria

- [ ] Modify `prd-creation` skill to spawn reviewer after PRD write
- [ ] Reviewer returns `{result: "PASS"|"FAIL", issues: []}`
- [ ] On FAIL: Loop back to enterprise-architect with issues
- [ ] On PASS: Allow phase transition
- [ ] Follows established skill template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/skills/workflow-steps/prd-creation/SKILL.md`

**Implementation:**

Add section after PRD write:

```markdown
## Validation Gate

After PRD is written, spawn reviewer:

**Spawn:** `core-claude-plugin:generic:reviewer`
**Input:** PRD path, validation type "prd"
**Output:** `{result: "PASS"|"FAIL", issues: []}`

On FAIL: Return issues to enterprise-architect, retry PRD creation
On PASS: Continue to next phase
```
