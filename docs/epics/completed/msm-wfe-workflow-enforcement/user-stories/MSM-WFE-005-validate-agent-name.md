---
story_id: "MSM-WFE-005"
title: "Add validateAgentName to story creation"
status: "pending"
agent: "core-claude-plugin:generic:skill-author"
dependencies: []
---

# Story: Add Agent Name Validation to Story Creation

## Description

As a workflow system, I need to validate agent names against the agent-selection skill registry so that invalid agent assignments are caught immediately.

## Acceptance Criteria

- [ ] Add `validateAgentName` section to user-story-creation skill
- [ ] Read valid agents from agent-selection skill tables
- [ ] Reject invalid names like "backend-dev" or "frontend-dev"
- [ ] Return suggestion for closest valid agent
- [ ] Follows established skill template

## Technical Notes

**Files to modify:**

- `plugins/metasaver-core/skills/workflow-steps/user-story-creation/SKILL.md`

**Implementation:**

Add section:

```markdown
## Agent Name Validation

Before writing story, validate agent assignment:

**Valid agent patterns:**

- `core-claude-plugin:generic:{name}`
- `core-claude-plugin:domain:{domain}:{name}`
- `core-claude-plugin:config:{category}:{name}`

**Validation process:**

1. Read story agent field
2. Check against patterns above
3. If invalid: Return error with suggestion
   - "backend-dev" → suggest "core-claude-plugin:generic:backend-dev"
   - "coder" → suggest "core-claude-plugin:generic:coder"
4. If valid: Continue story creation
```
