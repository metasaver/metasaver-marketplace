---
story_id: "MSM-WKR-007"
epic_id: "MSM-WKR"
title: "Create user-story-creation-skill"
status: "pending"
wave: 3
agent: "core-claude-plugin:generic:skill-author"
dependencies: ["MSM-WKR-004", "MSM-WKR-005"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-007: Create user-story-creation-skill

## User Story

As a BA agent, I want a user-story-creation-skill that wraps user-story-template.md so that user stories are created consistently with proper frontmatter and validation.

---

## Acceptance Criteria

- [ ] Skill created at `skills/workflow-steps/user-story-creation/SKILL.md`
- [ ] Skill references `templates/docs/user-story-template.md`
- [ ] Skill includes process guidance for:
  - [ ] Frontmatter with agent assignment
  - [ ] Story format (As a... I want... So that...)
  - [ ] Acceptance criteria structure
  - [ ] File naming convention (`{PROJ}-{EPIC}-{NNN}-{desc}.md`)
- [ ] Skill includes inline validation
- [ ] Skill is invoked by BA agent

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/skills/workflow-steps/

### Files to Create

| File                                                 | Purpose                   |
| ---------------------------------------------------- | ------------------------- |
| `skills/workflow-steps/user-story-creation/SKILL.md` | User story creation skill |

---

## Definition of Done

- [ ] Skill file exists
- [ ] References template (not duplicates)
- [ ] Process guidance included
- [ ] Validation checklist present
