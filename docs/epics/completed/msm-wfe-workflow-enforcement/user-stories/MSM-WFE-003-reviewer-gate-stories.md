---
story_id: "MSM-WFE-003"
title: "Add mandatory reviewer gate after story creation"
status: "pending"
agent: "core-claude-plugin:generic:skill-author"
dependencies: []
---

# Story: Add Mandatory Reviewer Gate After Story Creation

## Description

As a workflow system, I need to enforce reviewer validation after user stories are created so that invalid stories cannot proceed to implementation.

## Acceptance Criteria

- [ ] Modify `user-story-creation` skill to spawn reviewer after stories written
- [ ] Reviewer returns `{result: "PASS"|"FAIL", issues: []}`
- [ ] On FAIL: Loop back to business-analyst with issues
- [ ] On PASS: Allow phase transition
- [ ] Follows established skill template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/skills/workflow-steps/user-story-creation/SKILL.md`

**Implementation:**

Add section after stories written:

```markdown
## Validation Gate

After all stories are written, spawn reviewer:

**Spawn:** `core-claude-plugin:generic:reviewer`
**Input:** Stories folder path, validation type "user-story"
**Output:** `{result: "PASS"|"FAIL", issues: []}`

On FAIL: Return issues to business-analyst, fix affected stories
On PASS: Continue to next phase
```
