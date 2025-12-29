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
│ US-001          │──▶│ US-003          │──▶│ US-005          │
│ US-002          │   │ US-004          │   │ US-006          │
└─────────────────┘   └─────────────────┘   └─────────────────┘
     Parallel              Parallel              Sequential
```

---

## User Stories Index

{This section lists ALL user stories in the epic with their status}

| Wave | Story ID | Title   | Epic | Dependencies   | Complexity | Status  |
| ---- | -------- | ------- | ---- | -------------- | ---------- | ------- |
| 1    | US-001   | {Title} | E01  | None           | {X}        | pending |
| 1    | US-002   | {Title} | E01  | None           | {X}        | pending |
| 2    | US-003   | {Title} | E02  | US-001         | {X}        | pending |
| 2    | US-004   | {Title} | E02  | US-001, US-002 | {X}        | pending |

---

## Wave 1: {Wave Name}

**Stories:** {list}
**Complexity:** {sum}
**Dependencies:** None
**Execution:** Parallel / Sequential

| Story  | Task               | Agent             | Est. Files |
| ------ | ------------------ | ----------------- | ---------- |
| US-001 | {Task description} | `{subagent_type}` | {N}        |
| US-002 | {Task description} | `{subagent_type}` | {N}        |

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

| Story  | Task               | Agent             | Est. Files |
| ------ | ------------------ | ----------------- | ---------- |
| US-003 | {Task description} | `{subagent_type}` | {N}        |
| US-004 | {Task description} | `{subagent_type}` | {N}        |

**Verification Gate:**

```bash
pnpm build
pnpm lint
pnpm test
```

---

## Dependency Graph

```
US-001 ──┬──▶ US-003 ──▶ US-005
         │
US-002 ──┘
```

---

## Cross-Epic Dependencies

{List any dependencies on stories in OTHER epics/projects}

| Story  | Depends On       | Epic/Project   | Notes   |
| ------ | ---------------- | -------------- | ------- |
| US-003 | {external story} | {epic/project} | {notes} |

---

## Agent Assignments

| Wave | Story  | subagent_type                                                        |
| ---- | ------ | -------------------------------------------------------------------- |
| 1    | US-001 | `core-claude-plugin:generic:coder`                                   |
| 1    | US-002 | `core-claude-plugin:config:workspace:typescript-configuration-agent` |

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

| Wave   | Status  | Stories        |
| ------ | ------- | -------------- |
| Wave 1 | pending | US-001, US-002 |
| Wave 2 | pending | US-003, US-004 |

---

**Document Owner:** project-manager-agent
**PRD Reference:** ./prd.md

---

<!--
TEMPLATE RULES:
1. Execution plan lists ALL stories with their wave assignments
2. Stories reference by ID (US-001) - details in user-stories/ folder
3. Each wave has verification gates
4. Agent assignments use full subagent_type
5. Cross-epic dependencies section for multi-project coordination
6. Progress tracking updated as work completes
7. Frontmatter MUST include owner agent
-->
