---
story_id: "MSM-WKR-011"
epic_id: "MSM-WKR"
title: "Update design-phase skill"
status: "pending"
wave: 4
agent: "core-claude-plugin:generic:skill-author"
dependencies: ["MSM-WKR-006", "MSM-WKR-007"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-011: Update design-phase skill

## User Story

As a workflow orchestrator, I want design-phase updated to use the new skills so that execution plans and stories are created consistently.

---

## Acceptance Criteria

- [ ] design-phase uses execution-plan-skill for PM
- [ ] design-phase uses user-story-creation-skill for BA
- [ ] design-phase has validation gates after each artifact
- [ ] design-phase has HITL gates for execution plan and stories
- [ ] Update workflow diagram in skill

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/skills/workflow-steps/

### Files to Modify

| File                                          | Changes                              |
| --------------------------------------------- | ------------------------------------ |
| `skills/workflow-steps/design-phase/SKILL.md` | Use new skills, add validation gates |

---

## Architecture

**New Flow:**

```
1. Architect annotates PRD (unchanged)
2. BA creates story outlines
3. PM creates execution plan (invokes execution-plan-skill)
4. Reviewer validates execution plan
5. HITL: User approves execution plan
6. BA fills story details (invokes user-story-creation-skill)
7. Architect adds Architecture section to stories
8. Reviewer validates stories
9. HITL: User approves stories
10. Continue to execution-phase
```

---

## Definition of Done

- [ ] design-phase uses new skills
- [ ] Validation gates added
- [ ] HITL gates added
- [ ] Workflow diagram updated
