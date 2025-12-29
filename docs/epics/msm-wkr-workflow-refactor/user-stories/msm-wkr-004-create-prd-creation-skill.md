---
story_id: "MSM-WKR-004"
epic_id: "MSM-WKR"
title: "Create prd-creation-skill"
status: "pending"
wave: 2
agent: "core-claude-plugin:generic:skill-author"
dependencies: ["MSM-WKR-001", "MSM-WKR-002"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-004: Create prd-creation-skill

## User Story

As an EA agent, I want a prd-creation-skill that wraps the prd-template.md so that PRDs are created consistently following the template with built-in validation.

---

## Acceptance Criteria

- [ ] Skill created at `skills/workflow-steps/prd-creation/SKILL.md`
- [ ] Skill references `templates/docs/prd-template.md` (does NOT duplicate template content)
- [ ] Skill includes process guidance:
  - [ ] How to fill frontmatter
  - [ ] How to fill each section
  - [ ] What NOT to include (no user stories)
- [ ] Skill includes inline validation checklist:
  - [ ] Frontmatter complete (epic_id, title, version, status, created, updated, owner)
  - [ ] Required sections present
  - [ ] No user stories embedded
  - [ ] Epic summary is table-only
- [ ] Skill is invoked by EA agent

### Standard AC Items (Required)

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** plugins/metasaver-core/skills/workflow-steps/

### Files to Create

| File                                          | Purpose            |
| --------------------------------------------- | ------------------ |
| `skills/workflow-steps/prd-creation/SKILL.md` | PRD creation skill |

---

## Architecture

**Skill Structure:**

```markdown
---
name: prd-creation
description: Create PRD following template with validation
---

# PRD Creation Skill

## Template Reference

**Template:** Read from `templates/docs/prd-template.md`

(DO NOT duplicate template content here - reference it)

## Process

1. Read template
2. Fill frontmatter with epic details
3. Fill each section per requirements
4. Validate before output

## Validation Checklist

### Frontmatter (REQUIRED)

- [ ] epic_id: matches pattern {PREFIX}-{CODE}
- [ ] title: present and non-empty
- [ ] version: present (e.g., "1.0")
- [ ] status: one of [draft, in-review, approved, in-progress, complete]
- [ ] created: valid date YYYY-MM-DD
- [ ] updated: valid date YYYY-MM-DD
- [ ] owner: "enterprise-architect-agent"

### Required Sections

- [ ] Executive Summary exists
- [ ] Problem Statement exists
- [ ] Solution Overview exists
- [ ] Requirements exists (FR-XXX, NFR-XXX format)
- [ ] Scope (In/Out) exists
- [ ] Story Summary exists (table format)
- [ ] Success Criteria exists
- [ ] Risks & Mitigations exists
- [ ] Dependencies exists

### Prohibited Content

- [ ] NO full user story text (As a... I want...)
- [ ] NO acceptance criteria lists
- [ ] NO implementation code examples
- [ ] Story Summary is TABLE ONLY (no story details)

## Integration

**Called by:** enterprise-architect agent
**Output:** prd.md file in epic folder
```

---

## Definition of Done

- [ ] Skill file exists
- [ ] Skill references template (not duplicates)
- [ ] Validation checklist is complete
- [ ] Process guidance is clear
