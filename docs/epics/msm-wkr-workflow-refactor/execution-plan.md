---
epic_id: "MSM-WKR"
title: "Workflow Refactor - Agent/Skill Separation & Template Enforcement"
status: "pending"
total_stories: 16
total_waves: 5
created: "2024-12-29"
updated: "2024-12-29"
owner: "project-manager-agent"
---

# Execution Plan: Workflow Refactor

## Summary

| Metric        | Value                                  |
| ------------- | -------------------------------------- |
| Total Stories | 16                                     |
| Waves         | 5                                      |
| Critical Path | Cleanup → Create → Refactor → Commands |
| Repos         | 1 (metasaver-marketplace)              |

---

## Wave Strategy Overview

```
Wave 1 (Cleanup)           Wave 2 (Create)            Wave 3 (Create)
┌──────────────────┐       ┌──────────────────┐       ┌──────────────────┐
│ MSM-WKR-001      │       │ MSM-WKR-003 (EA) │       │ MSM-WKR-006      │
│ MSM-WKR-002      │       │ MSM-WKR-004      │       │ MSM-WKR-007      │
└────────┬─────────┘       │ MSM-WKR-005      │       └────────┬─────────┘
         │                 └────────┬─────────┘                │
         │                          │                          │
         ▼                          ▼                          ▼
Wave 4 (Refactor)          Wave 5 (Commands + Audit)
┌──────────────────┐       ┌──────────────────┐
│ MSM-WKR-008 (BA) │       │ MSM-WKR-012      │
│ MSM-WKR-009      │       │ MSM-WKR-013      │
│ MSM-WKR-010      │       │ MSM-WKR-014      │
│ MSM-WKR-011      │       │ MSM-WKR-015      │
└──────────────────┘       │ MSM-WKR-016      │
                           └──────────────────┘
```

---

## User Stories Index

| Wave | Story ID    | Title                                 | Dependencies                          | Agent            |
| ---- | ----------- | ------------------------------------- | ------------------------------------- | ---------------- |
| 1    | MSM-WKR-001 | Delete complexity-check skill         | None                                  | `coder`          |
| 1    | MSM-WKR-002 | Delete tool-check skill               | None                                  | `coder`          |
| 2    | MSM-WKR-003 | Create enterprise-architect agent     | MSM-WKR-001, MSM-WKR-002              | `agent-author`   |
| 2    | MSM-WKR-004 | Create prd-creation-skill             | MSM-WKR-001, MSM-WKR-002              | `skill-author`   |
| 2    | MSM-WKR-005 | Create document-validation-skill      | MSM-WKR-001, MSM-WKR-002              | `skill-author`   |
| 3    | MSM-WKR-006 | Create execution-plan-skill           | MSM-WKR-004, MSM-WKR-005              | `skill-author`   |
| 3    | MSM-WKR-007 | Create user-story-creation-skill      | MSM-WKR-004, MSM-WKR-005              | `skill-author`   |
| 4    | MSM-WKR-008 | Refactor business-analyst agent       | MSM-WKR-003, MSM-WKR-007              | `agent-author`   |
| 4    | MSM-WKR-009 | Enhance reviewer agent                | MSM-WKR-005                           | `agent-author`   |
| 4    | MSM-WKR-010 | Update requirements-phase skill       | MSM-WKR-003, MSM-WKR-004, MSM-WKR-008 | `skill-author`   |
| 4    | MSM-WKR-011 | Update design-phase skill             | MSM-WKR-006, MSM-WKR-007              | `skill-author`   |
| 5    | MSM-WKR-012 | Update /build command                 | MSM-WKR-010, MSM-WKR-011              | `command-author` |
| 5    | MSM-WKR-013 | Update /architect command             | MSM-WKR-004                           | `command-author` |
| 5    | MSM-WKR-014 | Update /ms command                    | MSM-WKR-001, MSM-WKR-002              | `command-author` |
| 5    | MSM-WKR-015 | Remove references from /qq and /audit | MSM-WKR-001, MSM-WKR-002              | `command-author` |
| 5    | MSM-WKR-016 | Audit all agents for correct tools    | MSM-WKR-003, MSM-WKR-008, MSM-WKR-009 | `reviewer`       |

---

## Wave 1: Cleanup (Delete Deprecated Skills)

**Stories:** MSM-WKR-001, MSM-WKR-002
**Execution:** Parallel
**Dependencies:** None

| Story       | Task                                                    | Agent   | Est. Files |
| ----------- | ------------------------------------------------------- | ------- | ---------- |
| MSM-WKR-001 | Delete complexity-check skill folder and all references | `coder` | 10+        |
| MSM-WKR-002 | Delete tool-check skill folder and all references       | `coder` | 5+         |

**Verification Gate:**

```bash
# No references to deleted skills remain
grep -r "complexity-check" plugins/ --include="*.md" | wc -l  # Should be 0
grep -r "tool-check" plugins/ --include="*.md" | wc -l  # Should be 0
```

---

## Wave 2: Create Foundation (EA Agent + Core Skills)

**Stories:** MSM-WKR-003, MSM-WKR-004, MSM-WKR-005
**Execution:** Parallel (after Wave 1)
**Dependencies:** Wave 1 complete

| Story       | Task                                                             | Agent          | Est. Files |
| ----------- | ---------------------------------------------------------------- | -------------- | ---------- |
| MSM-WKR-003 | Create EA agent with Serena, Context7, sequential-thinking tools | `agent-author` | 1          |
| MSM-WKR-004 | Create prd-creation-skill wrapping prd-template.md               | `skill-author` | 1          |
| MSM-WKR-005 | Create document-validation-skill with checklists                 | `skill-author` | 1          |

**Verification Gate:**

```bash
# Files exist
ls plugins/metasaver-core/agents/generic/enterprise-architect.md
ls plugins/metasaver-core/skills/workflow-steps/prd-creation/SKILL.md
ls plugins/metasaver-core/skills/workflow-steps/document-validation/SKILL.md
```

---

## Wave 3: Create Remaining Skills

**Stories:** MSM-WKR-006, MSM-WKR-007
**Execution:** Parallel
**Dependencies:** MSM-WKR-004, MSM-WKR-005 complete

| Story       | Task                                                             | Agent          | Est. Files |
| ----------- | ---------------------------------------------------------------- | -------------- | ---------- |
| MSM-WKR-006 | Create execution-plan-skill wrapping execution-plan-template.md  | `skill-author` | 1          |
| MSM-WKR-007 | Create user-story-creation-skill wrapping user-story-template.md | `skill-author` | 1          |

**Verification Gate:**

```bash
# Files exist
ls plugins/metasaver-core/skills/workflow-steps/execution-plan-creation/SKILL.md
ls plugins/metasaver-core/skills/workflow-steps/user-story-creation/SKILL.md
```

---

## Wave 4: Refactor Existing Components

**Stories:** MSM-WKR-008, MSM-WKR-009, MSM-WKR-010, MSM-WKR-011
**Execution:** Sequential (dependencies within wave)
**Dependencies:** Waves 2-3 complete

| Story       | Task                                                       | Agent          | Est. Files |
| ----------- | ---------------------------------------------------------- | -------------- | ---------- |
| MSM-WKR-008 | Refactor BA agent - remove PRD creation, focus on stories  | `agent-author` | 1          |
| MSM-WKR-009 | Enhance reviewer agent - add document validation           | `agent-author` | 1          |
| MSM-WKR-010 | Update requirements-phase - use EA for PRD, BA for stories | `skill-author` | 1          |
| MSM-WKR-011 | Update design-phase - use new skills                       | `skill-author` | 1          |

**Verification Gate:**

```bash
# BA agent doesn't mention PRD creation
grep -c "create PRD" plugins/metasaver-core/agents/generic/business-analyst.md  # Should be 0
```

---

## Wave 5: Update Commands + Final Audit

**Stories:** MSM-WKR-012, MSM-WKR-013, MSM-WKR-014, MSM-WKR-015, MSM-WKR-016
**Execution:** MSM-WKR-012/013 parallel, then MSM-WKR-014, then MSM-WKR-015/016 parallel
**Dependencies:** Wave 4 complete

| Story       | Task                                                   | Agent            | Est. Files |
| ----------- | ------------------------------------------------------ | ---------------- | ---------- |
| MSM-WKR-012 | Update /build - remove complexity routing, always full | `command-author` | 1          |
| MSM-WKR-013 | Update /architect - make innovation optional           | `command-author` | 1          |
| MSM-WKR-014 | Update /ms - remove deleted skill references           | `command-author` | 1          |
| MSM-WKR-015 | Remove complexity/tool refs from /qq and /audit        | `command-author` | 2          |
| MSM-WKR-016 | Audit all agents for correct tools                     | `reviewer`       | 20+        |

**Verification Gate:**

```bash
# No complexity-check references in any command
grep -r "complexity-check" plugins/metasaver-core/commands/ | wc -l  # Should be 0
```

---

## Dependency Graph

```
MSM-WKR-001 ──┬──▶ MSM-WKR-003 ──┬──▶ MSM-WKR-008 ──┬──▶ MSM-WKR-012
MSM-WKR-002 ──┘                  │                  │
                                 │                  ├──▶ MSM-WKR-013
                                 ├──▶ MSM-WKR-004 ──┤
                                 │                  │
                                 ├──▶ MSM-WKR-005 ──┼──▶ MSM-WKR-009 ──▶ MSM-WKR-016
                                 │                  │
                                 └─────────────────┼──▶ MSM-WKR-006 ──▶ MSM-WKR-011
                                                    │
                                                    └──▶ MSM-WKR-007 ──┤
                                                                       │
                                                         MSM-WKR-010 ◀─┘

MSM-WKR-014, MSM-WKR-015 (depend only on MSM-WKR-001, MSM-WKR-002)
```

---

## Agent Assignments

| Wave | Story       | subagent_type                               |
| ---- | ----------- | ------------------------------------------- |
| 1    | MSM-WKR-001 | `core-claude-plugin:generic:coder`          |
| 1    | MSM-WKR-002 | `core-claude-plugin:generic:coder`          |
| 2    | MSM-WKR-003 | `core-claude-plugin:generic:agent-author`   |
| 2    | MSM-WKR-004 | `core-claude-plugin:generic:skill-author`   |
| 2    | MSM-WKR-005 | `core-claude-plugin:generic:skill-author`   |
| 3    | MSM-WKR-006 | `core-claude-plugin:generic:skill-author`   |
| 3    | MSM-WKR-007 | `core-claude-plugin:generic:skill-author`   |
| 4    | MSM-WKR-008 | `core-claude-plugin:generic:agent-author`   |
| 4    | MSM-WKR-009 | `core-claude-plugin:generic:agent-author`   |
| 4    | MSM-WKR-010 | `core-claude-plugin:generic:skill-author`   |
| 4    | MSM-WKR-011 | `core-claude-plugin:generic:skill-author`   |
| 5    | MSM-WKR-012 | `core-claude-plugin:generic:command-author` |
| 5    | MSM-WKR-013 | `core-claude-plugin:generic:command-author` |
| 5    | MSM-WKR-014 | `core-claude-plugin:generic:command-author` |
| 5    | MSM-WKR-015 | `core-claude-plugin:generic:command-author` |
| 5    | MSM-WKR-016 | `core-claude-plugin:generic:reviewer`       |

---

## Risk Mitigation

| Risk                                  | Impact | Mitigation                      |
| ------------------------------------- | ------ | ------------------------------- |
| Breaking /build workflow              | High   | Test after each wave            |
| Orphaned references to deleted skills | Medium | Comprehensive grep after Wave 1 |
| Agent author errors                   | Medium | Validate generated files        |

---

## Rollback Plan

1. Git revert to pre-epic state
2. Each wave can be reverted independently
3. Keep deleted skills in git history (recoverable)

---

## Progress Tracking

**Updated:** 2024-12-29

| Wave   | Status  | Stories                                                         |
| ------ | ------- | --------------------------------------------------------------- |
| Wave 1 | pending | MSM-WKR-001, MSM-WKR-002                                        |
| Wave 2 | pending | MSM-WKR-003, MSM-WKR-004, MSM-WKR-005                           |
| Wave 3 | pending | MSM-WKR-006, MSM-WKR-007                                        |
| Wave 4 | pending | MSM-WKR-008, MSM-WKR-009, MSM-WKR-010, MSM-WKR-011              |
| Wave 5 | pending | MSM-WKR-012, MSM-WKR-013, MSM-WKR-014, MSM-WKR-015, MSM-WKR-016 |

---

**Document Owner:** project-manager-agent
**PRD Reference:** ./prd.md
