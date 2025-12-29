---
story_id: "MSM-WKR-010"
epic_id: "MSM-WKR"
title: "Update requirements-phase skill"
status: "pending"
wave: 4
agent: "core-claude-plugin:generic:skill-author"
dependencies: ["MSM-WKR-003", "MSM-WKR-004", "MSM-WKR-008"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-010: Update requirements-phase skill

## User Story

As a workflow orchestrator, I want requirements-phase updated to use EA for PRD and BA for stories so that responsibilities are properly separated.

---

## Acceptance Criteria

- [ ] requirements-phase spawns EA agent for PRD creation
- [ ] requirements-phase spawns reviewer for PRD validation
- [ ] requirements-phase has HITL gate for PRD approval
- [ ] requirements-phase spawns BA for story outlines AFTER PRD approved
- [ ] Remove BA "draft mode" for PRD (EA does this now)
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

| File                                                | Changes                      |
| --------------------------------------------------- | ---------------------------- |
| `skills/workflow-steps/requirements-phase/SKILL.md` | Split EA/BA responsibilities |

---

## Architecture

**New Flow:**

```
1. Spawn EA agent → Creates PRD (invokes prd-creation-skill)
2. Spawn Reviewer → Validates PRD
3. HITL → User approves PRD
4. Spawn BA agent → Creates story outlines
5. Continue to design-phase
```

**Old Flow (to remove):**

```
1. Spawn BA agent (draft mode) → Creates PRD + stories
...
```

---

## Definition of Done

- [ ] requirements-phase uses EA for PRD
- [ ] requirements-phase uses BA for stories only
- [ ] Validation gate exists for PRD
- [ ] HITL approval gate for PRD
