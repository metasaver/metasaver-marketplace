---
# Execution Plan Frontmatter - REQUIRED FIELDS
project_id: "{PREFIX}{NNN}" # Must match PRD project_id
title: "{Project Title}"
status: "pending" # pending | in-progress | complete
total_stories: 0
total_complexity: 0
total_waves: 0
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
owner: "project-manager-agent" # Agent that owns this document
---

# Execution Plan: {Project Title}

## Summary

| Metric             | Value         |
| ------------------ | ------------- |
| Total Stories      | {N}           |
| Total Complexity   | {X}           |
| Waves              | {N}           |
| Critical Path      | {description} |
| Estimated Duration | {time}        |

---

## Wave Strategy Overview

```
Wave 1 (Name)         Wave 2 (Name)         Wave 3 (Name)
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│ prj-epc-001     │──▶│ prj-epc-003     │──▶│ prj-epc-005     │
│ prj-epc-002     │   │ prj-epc-004     │   │ prj-epc-006     │
└─────────────────┘   └─────────────────┘   └─────────────────┘
     Parallel              Parallel              Sequential
```

---

## User Stories Index

{This section lists ALL user stories in the epic with their status}

| Wave | Story ID    | Title   | Epic    | Dependencies             | Complexity | Status  |
| ---- | ----------- | ------- | ------- | ------------------------ | ---------- | ------- |
| 1    | prj-epc-001 | {Title} | prj-epc | None                     | {X}        | pending |
| 1    | prj-epc-002 | {Title} | prj-epc | None                     | {X}        | pending |
| 2    | prj-epc-003 | {Title} | prj-epc | prj-epc-001              | {X}        | pending |
| 2    | prj-epc-004 | {Title} | prj-epc | prj-epc-001, prj-epc-002 | {X}        | pending |

---

## Wave 1: {Wave Name}

**Stories:** {list}
**Complexity:** {sum}
**Dependencies:** None
**Execution:** Parallel / Sequential

| Story       | Task               | Agent             | Est. Files |
| ----------- | ------------------ | ----------------- | ---------- |
| prj-epc-001 | {Task description} | `{subagent_type}` | {N}        |
| prj-epc-002 | {Task description} | `{subagent_type}` | {N}        |

**Verification Gate:**

```bash
pnpm build
pnpm lint
pnpm test
```

---

## Wave 2: {Wave Name}

**Stories:** {list}
**Complexity:** {sum}
**Dependencies:** Wave 1 complete
**Execution:** Parallel / Sequential

| Story       | Task               | Agent             | Est. Files |
| ----------- | ------------------ | ----------------- | ---------- |
| prj-epc-003 | {Task description} | `{subagent_type}` | {N}        |
| prj-epc-004 | {Task description} | `{subagent_type}` | {N}        |

**Verification Gate:**

```bash
pnpm build
pnpm lint
pnpm test
```

---

## Dependency Graph

```
prj-epc-001 ──┬──▶ prj-epc-003 ──▶ prj-epc-005
              │
prj-epc-002 ──┘
```

---

## Cross-Epic Dependencies

{List any dependencies on stories in OTHER epics/projects}

| Story       | Depends On       | Epic/Project   | Notes   |
| ----------- | ---------------- | -------------- | ------- |
| prj-epc-003 | {external story} | {epic/project} | {notes} |

---

## Agent Assignments

| Wave | Story       | subagent_type                                                        |
| ---- | ----------- | -------------------------------------------------------------------- |
| 1    | prj-epc-001 | `core-claude-plugin:generic:coder`                                   |
| 1    | prj-epc-002 | `core-claude-plugin:config:workspace:typescript-configuration-agent` |

---

## Risk Mitigation

| Risk     | Impact       | Mitigation   |
| -------- | ------------ | ------------ |
| {Risk 1} | High/Med/Low | {Mitigation} |

---

## Rollback Plan

{Describe how to rollback if things go wrong}

1. Revert git changes for affected stories
2. {Step 2}
3. {Step 3}

---

## Progress Tracking

**Updated:** {YYYY-MM-DD}

| Wave   | Status  | Stories                  |
| ------ | ------- | ------------------------ |
| Wave 1 | pending | prj-epc-001, prj-epc-002 |
| Wave 2 | pending | prj-epc-003, prj-epc-004 |

---

**Document Owner:** project-manager-agent
**PRD Reference:** ./prd.md

---

<!--
TEMPLATE RULES:
1. Execution plan lists ALL stories with their wave assignments
2. Stories reference by ID ({PROJECT}-{EPIC}-{NNN}, e.g., msm-feat-001) - details in user-stories/ folder
3. Each wave has verification gates
4. Agent assignments use full subagent_type
5. Cross-epic dependencies section for multi-project coordination
6. Progress tracking updated as work completes
7. Frontmatter MUST include owner agent
-->
