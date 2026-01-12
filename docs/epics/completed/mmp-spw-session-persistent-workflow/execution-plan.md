# Execution Plan: MMP-SPW Session-Persistent Workflow

## Overview

| Field           | Value      |
| --------------- | ---------- |
| Epic            | MMP-SPW    |
| Stories         | 4          |
| Waves           | 2          |
| Est. Complexity | Low-Medium |

---

## Wave 1: Foundation (Critical Path)

### SPW-001: CLAUDE.md Constitution

- **Agent**: `core-claude-plugin:generic:coder`
- **Task**: Add Constitution section to top of CLAUDE.md
- **Files**: `CLAUDE.md`
- **Dependencies**: None

### SPW-002: Session Restore Command

- **Agent**: `core-claude-plugin:generic:command-author`
- **Task**: Create `/session` command
- **Files**: `plugins/metasaver-core/commands/session.md`
- **Dependencies**: SPW-001 (references Constitution rules)

**Wave 1 can execute SPW-001 and SPW-002 in parallel** - while SPW-002 references SPW-001's rules conceptually, it doesn't need SPW-001 to be merged first.

---

## Wave 2: Enhancement

### SPW-003: Workflow Enforcement Skill

- **Agent**: `core-claude-plugin:generic:skill-author`
- **Task**: Create workflow enforcement skill
- **Files**: `plugins/metasaver-core/skills/cross-cutting/workflow-enforcement.md`
- **Dependencies**: SPW-001 (enforces Constitution rules)

### SPW-004: Post-Mortem Consolidation

- **Agent**: `core-claude-plugin:generic:coder`
- **Task**: Create consolidation doc, archive backlog files
- **Files**:
  - `docs/architecture/workflow-failures-consolidated.md`
  - Move backlog files to `docs/epics/backlog/archived/`
- **Dependencies**: None (can reference SPW-001-003 as "implemented")

**Wave 2 can execute SPW-003 and SPW-004 in parallel.**

---

## Execution Diagram

```
Wave 1 (Parallel):
├── SPW-001: CLAUDE.md Constitution
└── SPW-002: Session Restore Command

Wave 2 (Parallel):
├── SPW-003: Workflow Enforcement Skill
└── SPW-004: Post-Mortem Consolidation
```

---

## Verification Steps

After each wave:

1. Validate created/modified files exist
2. Check file syntax (markdown linting)
3. For commands/skills: verify frontmatter format

After all waves:

1. Test `/session` command works
2. Verify Constitution is at top of CLAUDE.md
3. Verify backlog files moved to archive

---

## Risk Mitigation

| Risk                       | Mitigation                                   |
| -------------------------- | -------------------------------------------- |
| CLAUDE.md merge conflicts  | This is the only repo, no conflicts expected |
| Command/skill registration | Verify marketplace.json if needed            |
| Backlog file loss          | Move to archive, don't delete                |
