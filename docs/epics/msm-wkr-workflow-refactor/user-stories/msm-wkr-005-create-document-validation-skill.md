---
story_id: "MSM-WKR-005"
epic_id: "MSM-WKR"
title: "Create document-validation-skill"
status: "pending"
wave: 2
agent: "core-claude-plugin:generic:skill-author"
dependencies: ["MSM-WKR-001", "MSM-WKR-002"]
priority: "P0"
created: "2024-12-29"
updated: "2024-12-29"
---

# MSM-WKR-005: Create document-validation-skill

## User Story

As a Standards Reviewer agent, I want a document-validation-skill with checklists for all document types so that I can validate PRDs, execution plans, and user stories before HITL approval.

---

## Acceptance Criteria

- [ ] Skill created at `skills/workflow-steps/document-validation/SKILL.md`
- [ ] Skill includes validation checklists for:
  - [ ] PRD validation
  - [ ] Execution plan validation
  - [ ] User story validation
- [ ] Each checklist validates:
  - [ ] Frontmatter completeness
  - [ ] Required sections
  - [ ] Prohibited content
  - [ ] Cross-document consistency (where applicable)
- [ ] Skill returns PASS or FAIL with specific violations
- [ ] Skill is invoked by reviewer agent before HITL gates

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
| `skills/workflow-steps/document-validation/SKILL.md` | Document validation skill |

---

## Architecture

**Skill Structure:**

```markdown
---
name: document-validation
description: Validate documents against templates before HITL
---

# Document Validation Skill

## Purpose

Validate PRDs, execution plans, and user stories before showing to user.

## Usage

Invoke with document type and path:

- `validate(type="prd", path="docs/epics/xxx/prd.md")`
- `validate(type="execution-plan", path="docs/epics/xxx/execution-plan.md")`
- `validate(type="user-story", path="docs/epics/xxx/user-stories/MSM-WKR-001-xxx.md")`

## PRD Validation Checklist

### Frontmatter

- [ ] epic_id matches {PREFIX}-{CODE}
- [ ] title present
- [ ] version present
- [ ] status is valid enum
- [ ] created is YYYY-MM-DD
- [ ] updated is YYYY-MM-DD
- [ ] owner is "enterprise-architect-agent"

### Required Sections

- [ ] Executive Summary
- [ ] Problem Statement
- [ ] Solution Overview
- [ ] Requirements (FR/NFR tables)
- [ ] Scope
- [ ] Story Summary
- [ ] Success Criteria
- [ ] Risks
- [ ] Dependencies

### Prohibited

- [ ] No "As a... I want..."
- [ ] No acceptance criteria lists
- [ ] No code examples

## Execution Plan Validation Checklist

### Frontmatter

- [ ] epic_id matches PRD
- [ ] total_stories > 0
- [ ] total_waves > 0
- [ ] owner is "project-manager-agent"

### Required Sections

- [ ] Summary table
- [ ] User Stories Index
- [ ] Wave sections
- [ ] Dependency Graph
- [ ] Agent Assignments

### Consistency

- [ ] All stories in index appear in waves
- [ ] No story in multiple waves
- [ ] Dependencies reference valid story IDs

## User Story Validation Checklist

### Frontmatter

- [ ] story_id matches {PROJ}-{EPIC}-{NNN}
- [ ] epic_id matches parent epic
- [ ] wave is number
- [ ] agent is valid subagent_type
- [ ] dependencies is array

### Required Sections

- [ ] User Story (As a...)
- [ ] Acceptance Criteria
- [ ] Technical Details
- [ ] Definition of Done

### File Naming

- [ ] Filename matches {PROJ}-{EPIC}-{NNN}-{kebab-case}.md

## Output Format

Return structured result:
{
"status": "PASS" | "FAIL",
"violations": [
{ "rule": "...", "message": "...", "location": "..." }
]
}
```

---

## Definition of Done

- [ ] Skill file exists
- [ ] All three validation types implemented
- [ ] Checklists are comprehensive
- [ ] Output format is clear
