---
name: save-prd
description: Save PRD artifacts to project directory after approval. Creates docs/projects/{yyyymmdd}-{name}/ with prd.md, user-stories/, execution-plan.md, innovations-selected.md, and architecture-notes.md. Use when persisting approved PRD from /architect command.
---

# Save PRD Skill

> **ROOT AGENT ONLY** - Runs only from root Claude Code agent after HITL approval.

**Purpose:** Persist approved PRD artifacts to project directory
**Trigger:** After hitl-approval phase completes in /architect workflow
**Input:** PRD content, user stories, execution plan, innovations, architecture notes
**Output:** Complete project directory ready for /build execution

---

## Workflow

**1. Create project directory**

- Generate directory name: `docs/projects/{yyyymmdd}-{kebab-case-name}/`
- Date format: YYYYMMDD (e.g., 20251217)
- Name derived from PRD title (lowercase, hyphens)
- Ensure `docs/projects/` parent exists
- Create directory structure:
  ```
  {project-dir}/
  ├── prd.md
  ├── user-stories/
  ├── execution-plan.md
  ├── innovations-selected.md  # Optional - only if innovations selected
  └── architecture-notes.md
  ```

**2. Save prd.md**

- Write PRD content to `{project-dir}/prd.md`
- Include all sections:
  - Title, Overview, Goals
  - User Stories (summary list)
  - Success Criteria
  - Technical Requirements
  - Out of Scope
- Format: Markdown with proper headings

**3. Save user-stories/ directory**

- Create `{project-dir}/user-stories/` subdirectory
- For each story, write individual file:
  - Filename: `US-{NNN}-{slug}.md` (e.g., `US-001-user-auth.md`)
  - Number: Zero-padded 3 digits
  - Slug: Derived from story title (kebab-case)
- Include in each story file:
  - Story ID, Title
  - Acceptance Criteria
  - Architecture annotations (files, imports, patterns)
  - Dependencies (if any)

**4. Save execution-plan.md**

- Write execution plan to `{project-dir}/execution-plan.md`
- Include:
  - Total stories, total waves
  - Wave breakdown with dependencies
  - Agent assignments
  - Parallel execution pairs
  - Gantt-style task schedule
- Format: Markdown with tables and lists

**5. Save innovations-selected.md (conditional)**

- **Skip if:** No innovations selected by user
- **Write if:** User selected one or more innovations
- File: `{project-dir}/innovations-selected.md`
- Include:
  - List of selected innovations
  - Brief description of each
  - Impact on PRD (what changed)
- Format: Markdown with bullet lists

**6. Save architecture-notes.md**

- Write architecture validation notes to `{project-dir}/architecture-notes.md`
- Include:
  - Multi-mono repo findings (existing solutions referenced)
  - Example files discovered
  - Context7 validation results
  - Patterns to follow
  - Files to create/modify
- Format: Markdown with code blocks and file paths

**7. Output final instruction**

- Return absolute path to PRD
- Tell user: `Run /build {absolute-path}/prd.md`
- Example: `Run /build /home/user/repo/docs/projects/20251217-user-auth/prd.md`

---

## File Creation Order

1. Create parent directory (`docs/projects/{name}/`)
2. Create `user-stories/` subdirectory
3. Write `prd.md`
4. Write each `US-{NNN}-{slug}.md` file
5. Write `execution-plan.md`
6. Write `innovations-selected.md` (if applicable)
7. Write `architecture-notes.md`
8. Output instruction to user

---

## Directory Naming Rules

| Input PRD Title            | Generated Directory Name            |
| -------------------------- | ----------------------------------- |
| "User Authentication API"  | `20251217-user-authentication-api`  |
| "Dashboard Feature"        | `20251217-dashboard-feature`        |
| "Stripe Integration Setup" | `20251217-stripe-integration-setup` |

**Rules:**

- Date prefix: Always YYYYMMDD format (e.g., 20251217)
- Name: Lowercase, words separated by hyphens
- Max length: 50 characters (truncate if needed)
- Remove special characters except hyphens

---

## User Story Filename Examples

| Story ID | Story Title             | Generated Filename                |
| -------- | ----------------------- | --------------------------------- |
| US-001   | "User Authentication"   | `US-001-user-authentication.md`   |
| US-002   | "Token Service"         | `US-002-token-service.md`         |
| US-015   | "Dashboard Widgets API" | `US-015-dashboard-widgets-api.md` |

**Rules:**

- Story ID: Zero-padded to 3 digits
- Slug: Derived from title (kebab-case)
- Max slug length: 40 characters

---

## Error Handling

**If directory exists:**

- Append timestamp suffix: `{name}-{HHmmss}`
- Example: `20251217-user-auth-143022`

**If parent doesn't exist:**

- Create `docs/projects/` directory first
- Then create project directory

**If write fails:**

- Halt workflow
- Report error with file path
- Do not proceed to next file

---

## Integration

**Called by:**

- `/architect` command (Phase 7: Output)

**Calls:**

- File system operations (Write tool)
- No agent spawning required

**Next step:** User executes `/build {prd-path}`

---

## Example

```
Input:
  PRD Title: "User Authentication API"
  Stories: 5 enriched stories with architecture notes
  Execution Plan: 3 waves, 5 TDD pairs
  Innovations: 2 selected (passwordless auth, MFA)
  Architecture Notes: Multi-mono findings, Context7 validation

Save PRD Phase (this skill):
  1. Create directory: docs/projects/20251217-user-authentication-api/
  2. Write prd.md (all sections)
  3. Write user-stories/:
     - US-001-auth-schema.md
     - US-002-auth-service.md
     - US-003-token-service.md
     - US-004-login-endpoint.md
     - US-005-logout-endpoint.md
  4. Write execution-plan.md (3 waves, dependencies)
  5. Write innovations-selected.md (passwordless, MFA)
  6. Write architecture-notes.md (multi-mono, patterns)
  7. Output: "Run /build /home/user/repo/docs/projects/20251217-user-authentication-api/prd.md"

Result:
  docs/projects/20251217-user-authentication-api/
  ├── prd.md
  ├── user-stories/
  │   ├── US-001-auth-schema.md
  │   ├── US-002-auth-service.md
  │   ├── US-003-token-service.md
  │   ├── US-004-login-endpoint.md
  │   └── US-005-logout-endpoint.md
  ├── execution-plan.md
  ├── innovations-selected.md
  └── architecture-notes.md
```

---

## Notes

- This is a **WRITE skill** - creates files, does not modify existing ones
- Always run AFTER hitl-approval (user must approve before saving)
- Output structure matches PRD specification from architect-command-target-state.md
- **NO EXECUTION** - /architect is planning only, /build executes the PRD
