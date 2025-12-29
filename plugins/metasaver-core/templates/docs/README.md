# Documentation Templates

Standard templates for project documentation in MetaSaver repositories.

## Folder Structure

Every project creates a folder in `docs/projects/`:

```
docs/projects/{project-id}-{kebab-case-name}/
├── prd.md                    # Product Requirements Document
├── execution-plan.md         # Wave-based execution plan
└── user-stories/             # Individual user story files
    ├── US-001-{story-name}.md
    ├── US-002-{story-name}.md
    └── ...
```

## Project ID Conventions

| Repo           | Prefix | Example                |
| -------------- | ------ | ---------------------- |
| metasaver-com  | MSC    | MSC015-user-management |
| rugby-crm      | CHB    | CHB008-player-details  |
| multi-mono     | MUM    | MUM003-zdatatable      |
| resume-builder | RSB    | RSB001-resume-export   |

## Document Ownership

| Document           | Owner Agent               | Purpose                  |
| ------------------ | ------------------------- | ------------------------ |
| prd.md             | business-analyst-agent    | Requirements definition  |
| execution-plan.md  | project-manager-agent     | Story sequencing & waves |
| user-stories/\*.md | coder (or specific agent) | Implementation specs     |

## Required Frontmatter

### PRD

```yaml
---
project_id: "MSC015"
title: "User Management"
version: "1.0"
status: "draft" # draft | in-review | approved | in-progress | complete
complexity: 28
created: "2024-12-28"
updated: "2024-12-28"
owner: "business-analyst-agent"
---
```

### Execution Plan

```yaml
---
project_id: "MSC015"
title: "User Management"
status: "pending" # pending | in-progress | complete
total_stories: 12
total_complexity: 28
total_waves: 4
created: "2024-12-28"
updated: "2024-12-28"
owner: "project-manager-agent"
---
```

### User Story

```yaml
---
story_id: "US-001"
epic_id: "E01"
title: "Add Username Generator"
status: "pending" # pending | in-progress | complete | blocked
complexity: 3
wave: 1
agent: "core-claude-plugin:generic:coder"
dependencies: []
created: "2024-12-28"
updated: "2024-12-28"
---
```

## Key Rules

### PRD Rules

1. **Requirements only** - No full user story content
2. Epic summary lists epics but does NOT include acceptance criteria
3. Architect adds "Architecture:" subsections inline
4. User stories go in `/user-stories/` folder
5. All frontmatter fields required

### Execution Plan Rules

1. Lists ALL stories with wave assignments
2. Each wave has verification gates (`pnpm build`, etc.)
3. Agent assignments use full `subagent_type`
4. Cross-epic dependencies documented
5. Progress tracking section updated as work completes

### User Story Rules

1. **Frontmatter agent field required** - Specifies executing agent
2. Story ID format: `US-{NNN}` (3-digit zero-padded)
3. Epic ID format: `E{NN}` (2-digit zero-padded)
4. File naming: `US-{NNN}-{kebab-case-title}.md`
5. Dependencies list other story IDs
6. Architecture section added by architect-agent

## Epic vs Story Organization

**Preferred:** Flat structure with epic ID in frontmatter

```
user-stories/
├── US-001-database-setup.md      # epic_id: E01
├── US-002-api-endpoints.md       # epic_id: E01
├── US-003-frontend-page.md       # epic_id: E02
└── US-004-integration-tests.md   # epic_id: E02
```

**Alternative (for very large projects):** Epic subfolders

```
user-stories/
├── E01-database-layer/
│   ├── epic.md                   # Epic overview
│   ├── US-001-setup.md
│   └── US-002-migration.md
└── E02-frontend/
    ├── epic.md
    └── US-003-page.md
```

## Status Flow

### PRD Status

```
draft → in-review → approved → in-progress → complete
```

### Execution Plan Status

```
pending → in-progress → complete
```

### User Story Status

```
pending → in-progress → complete
                     → blocked (if dependencies not met)
```

## Template Files

- `prd-template.md` - PRD template
- `execution-plan-template.md` - Execution plan template
- `user-story-template.md` - User story template

Copy the appropriate template when starting a new project.
