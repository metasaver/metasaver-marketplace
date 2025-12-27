---
name: user-story-template
description: Standard format for epics and user stories extracted from PRDs. Epics live in docs/projects/{yyyymmdd}-{name}/user-stories/EPIC-{number}-{name}.md, stories in US-{number}-{name}.md. Use when BA extracts stories, Architect annotates, PM tracks, or Workers implement.
---

# User Story Template Skill

Standard file format for **epics** and **user stories** extracted from PRDs and tracked throughout project execution.

## Purpose

Define consistent epic and user story file structure to:

- **Group related stories** under epics for better organization
- Track story status and ownership across workflow phases
- Link stories to PRD requirements and dependencies
- Provide architecture guidance from Architect to Workers
- Record implementation notes during execution
- Enable PM to verify completion

## Standard AC Items

**Every user story MUST include the appropriate standard AC items based on story type.** BA selects the correct set during story extraction.

### Code Stories

Use for: features, bug fixes, API endpoints, components, services, libraries.

| Required AC Item                           | Purpose                                   |
| ------------------------------------------ | ----------------------------------------- |
| `[ ] Unit tests cover acceptance criteria` | Ensures testable implementation           |
| `[ ] All tests pass`                       | Verifies no regressions before completion |

### Non-Code Stories

Use for: documentation, configs, agents, skills, templates, workflows.

| Required AC Item                           | Purpose                               |
| ------------------------------------------ | ------------------------------------- |
| `[ ] Follows established template/pattern` | Ensures consistency with standards    |
| `[ ] Format validated`                     | Verifies correct structure and syntax |

**Why centralized:** All workflows using this template automatically inherit these requirements, ensuring consistent quality without duplicating rules in each agent or phase.

## Hierarchy: Epics → Stories

**ALWAYS create at least 1 epic.** Stories belong to epics.

```
EPIC (feature/capability)
├── US-001 (task 1)
├── US-002 (task 2)
└── US-003 (task 3)
```

**When to create multiple epics:**

- Different functional areas (auth, dashboard, API)
- Different technical domains (frontend, backend, database)
- Different phases (setup, implementation, testing)
- Complexity ≥ 15 typically needs 2+ epics

**Epic Count Guidelines:**

| Complexity | Recommended Epics |
| ---------- | ----------------- |
| < 15       | 1 epic            |
| 15-29      | 1-2 epics         |
| 30-44      | 2-3 epics         |
| ≥ 45       | 3+ epics          |

## File Location

```
docs/projects/{yyyymmdd}-{name}/
├── prd.md
└── user-stories/
    ├── EPIC-001-feature-name.md      # Epic file
    ├── US-001-task-name.md           # Story under EPIC-001
    ├── US-002-task-name.md           # Story under EPIC-001
    ├── EPIC-002-another-feature.md   # Second epic
    ├── US-003-task-name.md           # Story under EPIC-002
    └── US-004-task-name.md           # Story under EPIC-002
```

**Naming Conventions:**

- Epics: `EPIC-{number}-{kebab-case-title}.md`
- Stories: `US-{number}-{kebab-case-title}.md`

---

## Epic Template

```markdown
# EPIC-{number}: {Title}

**Status:** 🔵 Pending | 🔄 In Progress | ✅ Complete | ❌ Blocked
**Priority:** High | Medium | Low
**Stories:** {count} stories
**PRD Reference:** ../prd.md

---

## Description

{1-2 paragraph description of this epic's scope and goals}

---

## Stories in this Epic

| Story  | Title   | Status     | Assignee   |
| ------ | ------- | ---------- | ---------- |
| US-001 | {title} | 🔵 Pending | unassigned |
| US-002 | {title} | 🔵 Pending | unassigned |

---

## Acceptance Criteria (Epic-Level)

- [ ] All stories complete
- [ ] Integration tested
- [ ] {epic-specific criterion}

---

## Architecture Notes

> Added by Architect after PRD approval

- **Domain:** {frontend/backend/database/etc.}
- **Key Files:** {main files affected by this epic}
- **Dependencies:** {external dependencies or other epics}
- **Pattern:** {architectural pattern to follow}

---

## Completion

> Updated by PM when epic is complete

**Completed:** {date}
**Stories Completed:** {X}/{Y}
**Verified:** {yes/no}
```

---

## User Story Template

```markdown
# US-{number}: {Title}

**Epic:** EPIC-{number}
**Status:** 🔵 Pending | 🔄 In Progress | ✅ Complete | ❌ Blocked
**Assignee:** {agent-name or "unassigned"}
**Depends On:** {US-XXX, US-YYY} or "none"
**Parallelizable With:** {US-XXX, US-YYY} or "none"
**Priority:** High | Medium | Low
**Estimated Size:** Small (≤10 min) | Medium (10-20 min) | Large (break it down!)
**PRD Reference:** ../prd.md

---

## User Story

As a {role}, I want to {action} so that {benefit}.

---

## Acceptance Criteria

- [ ] {criterion 1}
- [ ] {criterion 2}
- [ ] {criterion 3}

### Standard AC Items (Required)

> BA: Select ONE set based on story type. Delete the unused set.

**For Code Stories** (features, bug fixes, API endpoints, components):

- [ ] Unit tests cover acceptance criteria
- [ ] All tests pass

**For Non-Code Stories** (docs, configs, agents, skills, templates):

- [ ] Follows established template/pattern
- [ ] Format validated

---

## Architecture Notes

> Added by Architect after PRD approval

- **API:** {endpoint if applicable}
- **Files:** {key files to create/modify}
- **Database:** {schema changes if applicable}
- **Components:** {UI components if applicable}
- **Pattern:** {reference pattern to follow}

---

## Implementation Notes

> Added by Worker during execution

- {notes added during implementation}

---

## Completion

> Updated by PM when story is complete

**Completed By:** {agent-name}
**Files Modified:** {list of files}
**Verified:** {yes/no}
```

## Field Definitions

### Epic Fields

| Field              | Description                               | Set By    | Phase        |
| ------------------ | ----------------------------------------- | --------- | ------------ |
| Status             | Current state of epic                     | PM        | Throughout   |
| Priority           | Urgency level (High/Medium/Low)           | BA        | Extraction   |
| Stories            | Count of stories in this epic             | BA        | Extraction   |
| PRD Reference      | Link to parent PRD file                   | BA        | Extraction   |
| Description        | 1-2 paragraph scope and goals             | BA        | Extraction   |
| Stories in Epic    | Table linking to child stories            | BA        | Extraction   |
| Epic-Level AC      | High-level acceptance criteria for epic   | BA        | Extraction   |
| Architecture Notes | Domain, key files, dependencies, patterns | Architect | Architecture |
| Completion         | Final verification details                | PM        | Verification |

### User Story Fields

| Field                | Description                                          | Set By    | Phase        |
| -------------------- | ---------------------------------------------------- | --------- | ------------ |
| Epic                 | Parent epic this story belongs to                    | BA        | Extraction   |
| Status               | Current state (Pending/In Progress/Complete/Blocked) | PM        | Throughout   |
| Assignee             | Agent or worker responsible                          | PM        | Assignment   |
| Depends On           | Other stories that must complete first               | BA        | Extraction   |
| Parallelizable With  | Stories that can run concurrently with this one      | BA        | Extraction   |
| Priority             | Urgency level (High/Medium/Low)                      | BA        | Extraction   |
| Estimated Size       | Time estimate (Small ≤10min, Medium 10-20min, Large) | BA        | Extraction   |
| PRD Reference        | Link to parent PRD file                              | BA        | Extraction   |
| User Story           | Standard "As a... I want... so that..." format       | BA        | Extraction   |
| Acceptance Criteria  | Checkboxes for completion verification               | BA        | Extraction   |
| Architecture Notes   | Technical implementation guidance                    | Architect | Architecture |
| Implementation Notes | Worker notes during execution                        | Worker    | Execution    |
| Completion           | Final verification details                           | PM        | Verification |

## Status Icons Guide

| Icon | Status      | Meaning                                      |
| ---- | ----------- | -------------------------------------------- |
| 🔵   | Pending     | Not yet started, waiting for assignment      |
| 🔄   | In Progress | Actively being worked on by assigned agent   |
| ✅   | Complete    | Verified by PM, all acceptance criteria met  |
| ❌   | Blocked     | Cannot proceed due to dependencies or issues |

## Examples

### Example 1: Epic with Multiple Stories

```markdown
# EPIC-001: User Authentication System

**Status:** 🔄 In Progress
**Priority:** High
**Stories:** 3 stories
**PRD Reference:** ../prd.md

---

## Description

Implement complete user authentication including database schema, REST API endpoints, and frontend login/logout flows. This epic covers the foundation for all user identity management.

---

## Stories in this Epic

| Story  | Title                | Status         | Assignee              |
| ------ | -------------------- | -------------- | --------------------- |
| US-001 | Create users table   | ✅ Complete    | prisma-database-agent |
| US-002 | Add password hashing | ✅ Complete    | backend-worker-agent  |
| US-003 | Create auth API      | 🔄 In Progress | backend-worker-agent  |

---

## Acceptance Criteria (Epic-Level)

- [x] Users table exists with proper schema
- [x] Passwords are hashed with bcrypt
- [ ] Login/logout API endpoints work
- [ ] JWT tokens issued on successful login

---

## Architecture Notes

- **Domain:** Backend + Database
- **Key Files:** services/data/auth-api/\*, packages/database/prisma/schema.prisma
- **Dependencies:** None (foundational epic)
- **Pattern:** Follow existing user-api service structure
```

### Example 2: Story Belonging to Epic

```markdown
# US-003: Create User Authentication API

**Epic:** EPIC-001
**Status:** 🔄 In Progress
**Assignee:** backend-worker-agent
**Depends On:** US-001, US-002
**Priority:** High
**PRD Reference:** ../prd.md

---

## User Story

As a frontend developer, I want a REST API for user authentication so that I can implement login/logout functionality.

---

## Acceptance Criteria

- [x] POST /api/auth/login endpoint accepts email/password
- [x] JWT token returned on successful authentication
- [ ] POST /api/auth/logout endpoint invalidates token
- [ ] Proper error handling for invalid credentials

---

## Architecture Notes

> Added by Architect after PRD approval

- **API:** Express.js REST endpoints in services/data/auth-api
- **Files:**
  - services/data/auth-api/src/routes/auth.ts
  - services/data/auth-api/src/middleware/jwt.ts
- **Database:** No schema changes (users table exists from US-001)
- **Pattern:** Follow JWT pattern from services/data/user-api

---

## Implementation Notes

> Added by Worker during execution

- Implemented JWT signing with 7-day expiration
- Added refresh token support (not in original AC but good practice)
- Rate limiting added to prevent brute force

---

## Completion

> Updated by PM when story is complete

**Completed By:** backend-worker-agent
**Files Modified:**

- services/data/auth-api/src/routes/auth.ts (created)
- services/data/auth-api/src/middleware/jwt.ts (created)
- services/data/auth-api/package.json (updated deps)
  **Verified:** yes
```

### Example 3: Frontend Story without Dependencies

```markdown
# US-007: Add Loading Spinner to Dashboard

**Epic:** EPIC-002
**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Parallelizable With:** US-008, US-009
**Priority:** Low
**Estimated Size:** Small (≤10 min)
**PRD Reference:** ../prd.md

---

## User Story

As a user, I want to see a loading spinner while dashboard data loads so that I know the app is working.

---

## Acceptance Criteria

- [ ] Spinner appears when API call starts
- [ ] Spinner disappears when data loads
- [ ] Spinner shown on error states with retry button

---

## Architecture Notes

> Added by Architect after PRD approval

- **API:** None (uses existing dashboard API)
- **Files:** apps/admin-portal/src/pages/Dashboard.tsx
- **Components:** Use @metasaver/ui-components Spinner
- **Pattern:** Follow loading pattern from apps/admin-portal/src/pages/Users.tsx

---

## Implementation Notes

> Added by Worker during execution

(Not started yet)

---

## Completion

> Updated by PM when story is complete

(Not completed yet)
```

## Integration

**Used By:**

- **business-analyst** (BA): Creates epics and stories during extraction from PRD
- **architect**: Adds technical notes to epics and stories after PRD approval
- **project-manager** (PM): Updates status, assigns workers, verifies completion
- **worker-agent**: Reads assigned story, adds implementation notes
- **extract-phase**: Generates epic and story files from PRD
- **architecture-phase**: Annotates epics and stories with technical guidance
- **execution-phase**: Workers implement and update stories

**Related Skills:**

- `/skill prd-template` - Parent PRD format
- `/skill requirements-phase` - Epic and story extraction workflow
- `/skill architecture-phase` - Epic and story annotation workflow
- `/skill execution-phase` - Story implementation workflow

## Story Granularity Guidelines (CRITICAL)

**ALWAYS create stories by functional capability, not per package/layer.** This prevents execution bottlenecks.

### Why Granularity Matters

| Approach       | Stories | Max Parallel | Bottleneck Risk             |
| -------------- | ------- | ------------ | --------------------------- |
| Per-package    | 5       | 2            | HIGH (US-003 = 30min alone) |
| Per-capability | 9       | 4            | LOW (max 15-20min each)     |

### Rules for Story Size

1. **Max 15-20 minutes per story** - If larger, break it down
2. **Independently testable** - Each story should be verifiable alone
3. **Single responsibility** - One functional capability per story
4. **Parallel by default** - Same-layer stories should run together

### Breaking Down Large Stories

**AVOID: One story for entire workflow package (30+ min)**

```markdown
US-003: Workflow Package

- Create package scaffolding
- Implement 11 parsing nodes
- Write unit tests
- Wire workflow.ts
```

**ADOPT: Multiple stories by functional capability**

```markdown
US-003a: Workflow scaffolding (package.json, schemas, config) [10 min]
US-003b: Height/weight parser with edge case handling [15 min]
US-003c: Team fuzzy matching with Levenshtein [15 min]
US-003d: Major entity parser with comma splitting [10 min]
US-003e: Validation and upsert logic [15 min]
```

### Using Parallelizable With Field

```markdown
# US-003b: Height/Weight Parser

**Depends On:** US-003a (scaffolding must exist)
**Parallelizable With:** US-003c, US-003d (all parse nodes can run together)
```

This tells PM to schedule US-003b, US-003c, US-003d in the same wave.

---

## Best Practices

### Epics

1. **ALWAYS create an epic for every story** - This is a critical rule. Every story must belong to an epic.
2. **ALWAYS create at least 1 epic** - Even simple tasks get an epic for organization
3. **ALWAYS group by domain or feature** - Auth, Dashboard, API, Database are good epic boundaries
4. **ALWAYS include epic-level AC** - Include high-level criteria that span multiple stories
5. **ALWAYS keep epic descriptions concise** - 1-2 paragraphs max

### Stories

1. **ALWAYS link every story to an epic** - Use the Epic field
2. **ALWAYS use descriptive kebab-case names** - Example: US-001-auth-api (not US-001)
3. **ALWAYS specify dependencies** - Ensure correct execution order
4. **ALWAYS specify parallelization** - Indicate which stories can run together
5. **ALWAYS break down large stories** - If estimated size is "Large", decompose further
6. **ALWAYS include architecture notes** - Be specific about files, patterns, and integration points
7. **ALWAYS document implementation decisions** - Workers should record decisions and deviations
8. **ALWAYS verify acceptance criteria** - PM must verify before marking Complete
9. **ALWAYS update status promptly** - Avoid stale assignments
