---
story_id: "MSM-WKR-008"
epic_id: "MSM-WKR"
title: "Refactor business-analyst agent"
status: "pending"
wave: 4
agent: "core-claude-plugin:generic:agent-author"
dependencies: ["MSM-WKR-003", "MSM-WKR-007"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-008: Refactor business-analyst agent

## User Story

As a workflow orchestrator, I want the BA agent refactored to focus on story decomposition only so that PRD creation is handled by the new EA agent.

---

## Acceptance Criteria

- [ ] BA agent no longer creates PRDs (that's EA's job)
- [ ] BA agent focuses on:
  - [ ] Story decomposition from PRD
  - [ ] Acceptance criteria writing
  - [ ] Story granularity management
- [ ] BA agent references `user-story-creation-skill`
- [ ] BA agent uses Serena for understanding code structure
- [ ] BA agent uses AskUserQuestion for clarifications
- [ ] Remove any PRD output format from BA agent

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/agents/generic/

### Files to Modify

| File                                 | Changes                               |
| ------------------------------------ | ------------------------------------- |
| `agents/generic/business-analyst.md` | Remove PRD creation, focus on stories |

---

## Architecture

**BA Workflow After Refactor:**

```
Annotated PRD → BA reads requirements
             → BA identifies stories
             → BA invokes user-story-creation-skill (for each)
             → BA identifies dependencies
             → Output: Story outlines → Story files
```

**Removed Responsibilities:**

- PRD creation (now EA)
- Requirements gathering from user (now EA)
- Strategic vision (now EA)

**Retained Responsibilities:**

- Story decomposition
- Acceptance criteria writing
- Granularity management
- Dependency identification

---

## Definition of Done

- [ ] BA agent updated
- [ ] No PRD creation references
- [ ] References user-story-creation-skill
- [ ] Story decomposition is primary focus
