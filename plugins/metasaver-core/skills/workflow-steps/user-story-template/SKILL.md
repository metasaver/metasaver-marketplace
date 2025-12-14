---
name: user-story-template
description: Standard format for user story files extracted from PRDs. Stories live in docs/projects/{yyyymmdd}-{name}/user-stories/US-{number}-{name}.md with status tracking, architecture notes, and acceptance criteria. Use when BA extracts stories, Architect annotates, PM tracks, or Workers implement.
---

# User Story Template Skill

Standard file format for user stories extracted from PRDs and tracked throughout project execution.

## Purpose

Define consistent user story file structure to:

- Track story status and ownership across workflow phases
- Link stories to PRD requirements and dependencies
- Provide architecture guidance from Architect to Workers
- Record implementation notes during execution
- Enable PM to verify completion

## Story File Location

```
docs/projects/{yyyymmdd}-{name}/
├── prd.md
└── user-stories/
    ├── US-001-descriptive-name.md
    ├── US-002-descriptive-name.md
    └── US-003-descriptive-name.md
```

**Naming Convention:** `US-{number}-{kebab-case-title}.md`

## Template

```markdown
# US-{number}: {Title}

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

| Field                | Description                                          | Set By    | Phase        |
| -------------------- | ---------------------------------------------------- | --------- | ------------ |
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

### Example 1: Database Story with Dependencies

```markdown
# US-003: Create User Authentication API

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

### Example 2: Frontend Story without Dependencies

```markdown
# US-007: Add Loading Spinner to Dashboard

**Status:** 🔵 Pending
**Assignee:** unassigned
**Depends On:** none
**Priority:** Low
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

- **business-analyst** (BA): Creates stories during extraction from PRD
- **architect**: Adds technical notes after PRD approval
- **project-manager** (PM): Updates status, assigns workers, verifies completion
- **worker-agent**: Reads assigned story, adds implementation notes
- **extract-phase**: Generates story files from PRD
- **architecture-phase**: Annotates stories with technical guidance
- **execution-phase**: Workers implement and update stories

**Related Skills:**

- `/skill prd-template` - Parent PRD format
- `/skill extract-phase` - Story extraction workflow
- `/skill architecture-phase` - Story annotation workflow
- `/skill execution-phase` - Story implementation workflow

## Story Granularity Guidelines (CRITICAL)

**DO NOT create 1 story per package/layer.** This causes execution bottlenecks.

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

**BAD: One story for entire workflow package (30+ min)**

```markdown
US-003: Workflow Package

- Create package scaffolding
- Implement 11 parsing nodes
- Write unit tests
- Wire workflow.ts
```

**GOOD: Multiple stories by functional capability**

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

1. **Naming:** Use descriptive kebab-case names (US-001-auth-api, not US-001)
2. **Dependencies:** Always specify dependencies to ensure correct execution order
3. **Parallelization:** Always specify which stories can run together
4. **Size check:** If estimated size is "Large", break it down further
5. **Architecture Notes:** Be specific about files, patterns, and integration points
6. **Implementation Notes:** Workers should document decisions and deviations
7. **Verification:** PM must verify acceptance criteria before marking Complete
8. **Status Updates:** Update status promptly to avoid stale assignments
