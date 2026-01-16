---
story_id: "MSM-VKM-E01-004"
epic_id: "MSM-VKM-E01"
title: "Create standard monorepo directories"
status: "pending"
complexity: 1
wave: 0
agent: "core-claude-plugin:generic:coder"
dependencies: []
created: "2026-01-16"
updated: "2026-01-16"
---

# MSM-VKM-E01-004: Create standard monorepo directories

## User Story

**As a** developer organizing code in the monorepo
**I want** standard directories for packages, apps, and services
**So that** the repository follows monorepo conventions and code is organized logically

---

## Acceptance Criteria

- [ ] Directory `packages/` created at repository root
- [ ] Directory `apps/` created at repository root
- [ ] Directory `services/` created at repository root
- [ ] Each directory contains a README.md explaining its purpose
- [ ] Directory structure visible in file system
- [ ] Directories tracked by git (contain at least README.md)
- [ ] Follows established template/pattern
- [ ] Format validated

---

## Technical Details

### Location

- **Repo:** metasaver-marketplace
- **Package:** root level

### Files to Create

| File                 | Purpose                                |
| -------------------- | -------------------------------------- |
| `packages/README.md` | Document purpose of packages directory |
| `apps/README.md`     | Document purpose of apps directory     |
| `services/README.md` | Document purpose of services directory |

### Files to Modify

None - these are new directories and files.

---

## Implementation Notes

Create standard monorepo directory structure:

- **packages/**: Shared libraries and utilities (e.g., veenk-workflows)
- **apps/**: Standalone applications (e.g., future UI chat app)
- **services/**: Backend services (e.g., future MCP server)

### Directory Purposes

| Directory   | Purpose                                   |
| ----------- | ----------------------------------------- |
| `packages/` | Reusable code packages and libraries      |
| `apps/`     | Standalone applications with entry points |
| `services/` | Backend services and APIs                 |

Each README.md should document:

1. Purpose of the directory
2. Types of code that belong here
3. Examples of what might live in this directory

### Dependencies

None - this creates empty directories with documentation.

---

## Architecture

(Added by architect-agent - technical annotations pending)

**Key Files:**

- `packages/README.md` - Document packages directory
- `apps/README.md` - Document apps directory
- `services/README.md` - Document services directory

---

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests passing
- [ ] TypeScript compiles
- [ ] Lint passes
- [ ] Acceptance criteria verified
- [ ] Directories exist and contain README.md files
- [ ] READMEs accurately describe directory purposes

---

## Notes

- These directories follow standard monorepo conventions
- Future migrations will populate these directories with code
- Does not affect existing plugin structure at plugins/metasaver-core/
- Empty directories are not tracked by git, hence the README.md requirement
